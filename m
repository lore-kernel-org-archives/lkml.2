Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab0GOCVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:21:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758153Ab0GOCRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:17:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/18] xstat: AFS: Return extended attributes [ver #6]
To: viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        linux-ext4@vger.kernel.org
Date: Thu, 15 Jul 2010 03:17:14 +0100
Message-ID: <20100715021714.5544.76201.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return extended attributes from the AFS filesystem.  This includes the
following:

 (1) The vnode uniquifier as st_gen.

 (2) The data version number as st_data_version.

 (3) FS_AUTOMOUNT_FL on mountpoint directories.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/inode.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index ee3190a..02f115f 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -300,16 +300,19 @@ error_unlock:
 /*
  * read the attributes of an inode
  */
-int afs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		      struct kstat *stat)
+int afs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
-	struct inode *inode;
-
-	inode = dentry->d_inode;
+	struct inode *inode = dentry->d_inode;
 
 	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
 
 	generic_fillattr(inode, stat);
+
+	stat->result_mask |= XSTAT_REQUEST_GEN | XSTAT_REQUEST_DATA_VERSION;
+	stat->gen = inode->i_generation;
+	stat->data_version = inode->i_version;
+	if (test_bit(AFS_VNODE_MOUNTPOINT, &AFS_FS_I(inode)->flags))
+		stat->inode_flags |= FS_AUTOMOUNT_FL;
 	return 0;
 }
 

