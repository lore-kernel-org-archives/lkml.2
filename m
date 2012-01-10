Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934085Ab2AJXB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:01:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934055Ab2AJXBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:01:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:22 2012
Message-Id: <20120110215022.710670575@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>
Subject: [21/42] udf: Fix deadlock when converting file from in-ICB one to normal one
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit d2eb8c359309ec45d6bf5b147303ab8e13be86ea upstream.

During BKL removal in 2.6.38, conversion of files from in-ICB format to normal
format got broken. We call ->writepage with i_data_sem held but udf_get_block()
also acquires i_data_sem thus creating A-A deadlock.

We fix the problem by dropping i_data_sem before calling ->writepage() which is
safe since i_mutex still protects us against any changes in the file. Also fix
pagelock - i_data_sem lock inversion in udf_expand_file_adinicb() by dropping
i_data_sem before calling find_or_create_page().

Reported-by: Matthias Matiak <netzpython@mail-on.us>
Tested-by: Matthias Matiak <netzpython@mail-on.us>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/udf/file.c  |    6 +++---
 fs/udf/inode.c |   21 ++++++++++++++++++---
 2 files changed, 21 insertions(+), 6 deletions(-)

--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -125,7 +125,6 @@ static ssize_t udf_file_aio_write(struct
 			err = udf_expand_file_adinicb(inode);
 			if (err) {
 				udf_debug("udf_expand_adinicb: err=%d\n", err);
-				up_write(&iinfo->i_data_sem);
 				return err;
 			}
 		} else {
@@ -133,9 +132,10 @@ static ssize_t udf_file_aio_write(struct
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
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -145,6 +145,12 @@ const struct address_space_operations ud
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
@@ -163,9 +169,15 @@ int udf_expand_file_adinicb(struct inode
 			iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
 		/* from now on we have normal address_space methods */
 		inode->i_data.a_ops = &udf_aops;
+		up_write(&iinfo->i_data_sem);
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
@@ -181,6 +193,7 @@ int udf_expand_file_adinicb(struct inode
 		SetPageUptodate(page);
 		kunmap(page);
 	}
+	down_write(&iinfo->i_data_sem);
 	memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr, 0x00,
 	       iinfo->i_lenAlloc);
 	iinfo->i_lenAlloc = 0;
@@ -190,17 +203,20 @@ int udf_expand_file_adinicb(struct inode
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
@@ -1105,10 +1121,9 @@ int udf_setsize(struct inode *inode, lof
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


