Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1LJCLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 21:11:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab1LJCLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 21:11:41 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Matthias Matiak <netzpython@mail-on.us>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] udf: Fix deadlock when converting file from in-ICB one to normal one
Date: Sat, 10 Dec 2011 03:11:37 +0100
Message-Id: <1323483097-24210-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During BKL removal, conversion of files from in-ICB format to normal format got
broken. We call ->writepage with i_data_sem held but udf_get_block() also
acquires i_data_sem thus creating A-A deadlock.

We fix the problem by dropping i_data_sem before calling ->writepage() which is
safe since i_mutex still protects us against any changes in the file. Also fix
pagelock - i_data_sem lock inversion in udf_expand_file_adinicb() by dropping
i_data_sem before calling find_or_create_page().

Reported-by: Matthias Matiak <netzpython@mail-on.us>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/file.c  |    6 +++---
 fs/udf/inode.c |   20 +++++++++++++++++---
 2 files changed, 20 insertions(+), 6 deletions(-)

 I plan to merge this fix through my tree soon.

diff --git a/fs/udf/file.c b/fs/udf/file.c
index d8ffa7c..dca0c38 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -125,7 +125,6 @@ static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			err = udf_expand_file_adinicb(inode);
 			if (err) {
 				udf_debug("udf_expand_adinicb: err=%d\n", err);
-				up_write(&iinfo->i_data_sem);
 				return err;
 			}
 		} else {
@@ -133,9 +132,10 @@ static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				iinfo->i_lenAlloc = pos + count;
 			else
 				iinfo->i_lenAlloc = inode->i_size;
+			up_write(&iinfo->i_data_sem);
 		}
-	}
-	up_write(&iinfo->i_data_sem);
+	} else
+		up_write(&iinfo->i_data_sem);
 
 	retval = generic_file_aio_write(iocb, iov, nr_segs, ppos);
 	if (retval > 0)
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 1bd2c42..30086a8 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -150,6 +150,12 @@ const struct address_space_operations udf_aops = {
 	.bmap		= udf_bmap,
 };
 
+/*
+ * Expand file stored in ICB to a normal one-block-file
+ *
+ * This function requires i_data_sem for writing and releases it.
+ * This function requires i_mutex held
+ */
 int udf_expand_file_adinicb(struct inode *inode)
 {
 	struct page *page;
@@ -171,6 +177,11 @@ int udf_expand_file_adinicb(struct inode *inode)
 		mark_inode_dirty(inode);
 		return 0;
 	}
+	/*
+	 * Release i_data_sem so that we can lock a page - page lock ranks
+	 * above i_data_sem. i_mutex still protects us against file changes.
+	 */
+	up_write(&iinfo->i_data_sem);
 
 	page = find_or_create_page(inode->i_mapping, 0, GFP_NOFS);
 	if (!page)
@@ -186,6 +197,7 @@ int udf_expand_file_adinicb(struct inode *inode)
 		SetPageUptodate(page);
 		kunmap(page);
 	}
+	down_write(&iinfo->i_data_sem);
 	memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr, 0x00,
 	       iinfo->i_lenAlloc);
 	iinfo->i_lenAlloc = 0;
@@ -195,17 +207,20 @@ int udf_expand_file_adinicb(struct inode *inode)
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
 	/* from now on we have normal address_space methods */
 	inode->i_data.a_ops = &udf_aops;
+	up_write(&iinfo->i_data_sem);
 	err = inode->i_data.a_ops->writepage(page, &udf_wbc);
 	if (err) {
 		/* Restore everything back so that we don't lose data... */
 		lock_page(page);
 		kaddr = kmap(page);
+		down_write(&iinfo->i_data_sem);
 		memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr, kaddr,
 		       inode->i_size);
 		kunmap(page);
 		unlock_page(page);
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		inode->i_data.a_ops = &udf_adinicb_aops;
+		up_write(&iinfo->i_data_sem);
 	}
 	page_cache_release(page);
 	mark_inode_dirty(inode);
@@ -1105,10 +1120,9 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 			if (bsize <
 			    (udf_file_entry_alloc_offset(inode) + newsize)) {
 				err = udf_expand_file_adinicb(inode);
-				if (err) {
-					up_write(&iinfo->i_data_sem);
+				if (err)
 					return err;
-				}
+				down_write(&iinfo->i_data_sem);
 			} else
 				iinfo->i_lenAlloc = newsize;
 		}
-- 
1.7.1

