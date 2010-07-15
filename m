Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab0GOCUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:20:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758234Ab0GOCRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:17:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/18] xstat: NFS: Return extended attributes [ver #6]
To: viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        linux-ext4@vger.kernel.org
Date: Thu, 15 Jul 2010 03:17:18 +0100
Message-ID: <20100715021717.5544.47926.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return extended attributes from the NFS filesystem.  This includes the
following:

 (1) The change attribute as st_data_version if NFSv4.

 (2) FS_AUTOMOUNT_FL on referral/submount directories.

Furthermore, what nfs_getattr() does can be controlled as follows:

 (1) If AT_FORCE_ATTR_SYNC is indicated, or mtime, ctime or data_version (NFSv4
     only) are requested then the outstanding writes will be written to the
     server first.

 (2) The inode's attributes may be synchronised with the server:

     (a) If AT_FORCE_ATTR_SYNC is indicated or if atime is requested (and atime
     	 updating is not suppressed by a mount flag) then the attributes will
     	 be reread unconditionally.

     (b) If the data version or any of basic stats are requested then the
     	 attributes will be reread if the cached attributes have expired.

     (c) Otherwise the cached attributes will be used - even if expired -
     	 without reference to the server.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/inode.c |   46 ++++++++++++++++++++++++++++++++++------------
 1 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 099b351..8c6de96 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -495,11 +495,21 @@ void nfs_setattr_update_inode(struct inode *inode, struct iattr *attr)
 int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
 	struct inode *inode = dentry->d_inode;
+	unsigned force = stat->query_flags & AT_FORCE_ATTR_SYNC;
 	int need_atime = NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATIME;
 	int err;
 
-	/* Flush out writes to the server in order to update c/mtime.  */
-	if (S_ISREG(inode->i_mode)) {
+	if (NFS_SERVER(inode)->nfs_client->rpc_ops->version < 4)
+		stat->request_mask &= ~XSTAT_REQUEST_DATA_VERSION;
+
+	/* Flush out writes to the server in order to update c/mtime
+	 * or data version if the user wants them */
+	if ((force || stat->request_mask & (XSTAT_REQUEST_MTIME |
+					    XSTAT_REQUEST_CTIME |
+					    XSTAT_REQUEST_DATA_VERSION
+					    )) &&
+	    S_ISREG(inode->i_mode)
+	    ) {
 		err = filemap_write_and_wait(inode->i_mapping);
 		if (err)
 			goto out;
@@ -514,18 +524,30 @@ int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	 *  - NFS never sets MS_NOATIME or MS_NODIRATIME so there is
 	 *    no point in checking those.
 	 */
- 	if ((mnt->mnt_flags & MNT_NOATIME) ||
- 	    ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode)))
+	if (!(stat->request_mask & XSTAT_REQUEST_ATIME) ||
+	    (mnt->mnt_flags & MNT_NOATIME) ||
+	    ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode)))
 		need_atime = 0;
 
-	if (need_atime)
-		err = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
-	else
-		err = nfs_revalidate_inode(NFS_SERVER(inode), inode);
-	if (!err) {
-		generic_fillattr(inode, stat);
-		stat->ino = nfs_compat_user_ino64(NFS_FILEID(inode));
+	if (force || stat->request_mask & (XSTAT_REQUEST__BASIC_STATS |
+					   XSTAT_REQUEST_DATA_VERSION)
+	    ) {
+		if (force || need_atime)
+			err = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
+		else
+			err = nfs_revalidate_inode(NFS_SERVER(inode), inode);
+		if (err)
+			goto out;
 	}
+
+	generic_fillattr(inode, stat);
+	stat->ino = nfs_compat_user_ino64(NFS_FILEID(inode));
+
+	if (stat->request_mask & XSTAT_REQUEST_DATA_VERSION) {
+		stat->data_version = NFS_I(inode)->change_attr;
+		stat->result_mask |= XSTAT_REQUEST_DATA_VERSION;
+	}
+
 out:
 	return err;
 }
@@ -770,7 +792,7 @@ int nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 static int nfs_invalidate_mapping(struct inode *inode, struct address_space *mapping)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
-	
+
 	if (mapping->nrpages != 0) {
 		int ret = invalidate_inode_pages2(mapping);
 		if (ret < 0)

