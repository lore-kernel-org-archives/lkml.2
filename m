Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab2CMAyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:54:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:47884 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758739Ab2CMAWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 091/196] NFS: nfs_wcc_update_inode() should set nfsi->attr_gencount
Date: Mon, 12 Mar 2012 20:20:04 -0400
Message-Id: <1331598109-31424-46-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 27dc1cd3ad9300f81e1219e5fc305d91d85353f8 upstream.

If the call to nfs_wcc_update_inode() results in an attribute update, we
need to ensure that the inode's attr_gencount gets bumped too, otherwise
we are not protected against races with other GETATTR calls.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfs/inode.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 50a56ed..b0299c0 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -793,9 +793,10 @@ out:
 	return ret;
 }
 
-static void nfs_wcc_update_inode(struct inode *inode, struct nfs_fattr *fattr)
+static unsigned long nfs_wcc_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
+	unsigned long ret = 0;
 
 	if ((fattr->valid & NFS_ATTR_FATTR_PRECHANGE)
 			&& (fattr->valid & NFS_ATTR_FATTR_CHANGE)
@@ -803,25 +804,32 @@ static void nfs_wcc_update_inode(struct inode *inode, struct nfs_fattr *fattr)
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
@@ -1115,7 +1123,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			| NFS_INO_REVAL_PAGECACHE);
 
 	/* Do atomic weak cache consistency updates */
-	nfs_wcc_update_inode(inode, fattr);
+	invalid |= nfs_wcc_update_inode(inode, fattr);
 
 	/* More cache consistency checks */
 	if (fattr->valid & NFS_ATTR_FATTR_CHANGE) {
-- 
1.7.9.3

