Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab1EFA1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:27:25 -0400
Received: from kroah.org ([198.145.64.141]:37497 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607Ab1EFA1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:27:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:26:08 2011
Message-Id: <20110506002608.083192247@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:25:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [08/43] NFS: nfs_wcc_update_inode() should set nfsi->attr_gencount
In-Reply-To: <20110506002625.GA20426@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 27dc1cd3ad9300f81e1219e5fc305d91d85353f8 upstream.

If the call to nfs_wcc_update_inode() results in an attribute update, we
need to ensure that the inode's attr_gencount gets bumped too, otherwise
we are not protected against races with other GETATTR calls.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/inode.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -861,9 +861,10 @@ out:
 	return ret;
 }
 
-static void nfs_wcc_update_inode(struct inode *inode, struct nfs_fattr *fattr)
+static unsigned long nfs_wcc_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
+	unsigned long ret = 0;
 
 	if ((fattr->valid & NFS_ATTR_FATTR_PRECHANGE)
 			&& (fattr->valid & NFS_ATTR_FATTR_CHANGE)
@@ -871,25 +872,32 @@ static void nfs_wcc_update_inode(struct
 		nfsi->change_attr = fattr->change_attr;
 		if (S_ISDIR(inode->i_mode))
 			nfsi->cache_validity |= NFS_INO_INVALID_DATA;
+		ret |= NFS_INO_INVALID_ATTR;
 	}
 	/* If we have atomic WCC data, we may update some attributes */
 	if ((fattr->valid & NFS_ATTR_FATTR_PRECTIME)
 			&& (fattr->valid & NFS_ATTR_FATTR_CTIME)
-			&& timespec_equal(&inode->i_ctime, &fattr->pre_ctime))
-			memcpy(&inode->i_ctime, &fattr->ctime, sizeof(inode->i_ctime));
+			&& timespec_equal(&inode->i_ctime, &fattr->pre_ctime)) {
+		memcpy(&inode->i_ctime, &fattr->ctime, sizeof(inode->i_ctime));
+		ret |= NFS_INO_INVALID_ATTR;
+	}
 
 	if ((fattr->valid & NFS_ATTR_FATTR_PREMTIME)
 			&& (fattr->valid & NFS_ATTR_FATTR_MTIME)
 			&& timespec_equal(&inode->i_mtime, &fattr->pre_mtime)) {
-			memcpy(&inode->i_mtime, &fattr->mtime, sizeof(inode->i_mtime));
-			if (S_ISDIR(inode->i_mode))
-				nfsi->cache_validity |= NFS_INO_INVALID_DATA;
+		memcpy(&inode->i_mtime, &fattr->mtime, sizeof(inode->i_mtime));
+		if (S_ISDIR(inode->i_mode))
+			nfsi->cache_validity |= NFS_INO_INVALID_DATA;
+		ret |= NFS_INO_INVALID_ATTR;
 	}
 	if ((fattr->valid & NFS_ATTR_FATTR_PRESIZE)
 			&& (fattr->valid & NFS_ATTR_FATTR_SIZE)
 			&& i_size_read(inode) == nfs_size_to_loff_t(fattr->pre_size)
-			&& nfsi->npages == 0)
-			i_size_write(inode, nfs_size_to_loff_t(fattr->size));
+			&& nfsi->npages == 0) {
+		i_size_write(inode, nfs_size_to_loff_t(fattr->size));
+		ret |= NFS_INO_INVALID_ATTR;
+	}
+	return ret;
 }
 
 /**
@@ -1183,7 +1191,7 @@ static int nfs_update_inode(struct inode
 			| NFS_INO_REVAL_PAGECACHE);
 
 	/* Do atomic weak cache consistency updates */
-	nfs_wcc_update_inode(inode, fattr);
+	invalid |= nfs_wcc_update_inode(inode, fattr);
 
 	/* More cache consistency checks */
 	if (fattr->valid & NFS_ATTR_FATTR_CHANGE) {


