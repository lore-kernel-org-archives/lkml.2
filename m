Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2ATWg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 17:36:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33978 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab2ATWft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 17:35:49 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        john.johansen@canonical.com, dustin.kirkland@gazzang.com,
        Cong Wang <xiyou.wangcong@gmail.com>, Li Wang <liwang@nudt.edu.cn>
Subject: [PATCH 3/3] eCryptfs: Remove unused ecryptfs_read()
Date: Fri, 20 Jan 2012 16:35:07 -0600
Message-Id: <1327098907-28963-4-git-send-email-tyhicks@canonical.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327098907-28963-1-git-send-email-tyhicks@canonical.com>
References: <1327098907-28963-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ecryptfs_read() has been ifdef'ed out for years now and it was
apparently unused before then. It is time to get rid of it for good.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
---
 fs/ecryptfs/read_write.c |   73 ----------------------------------------------
 1 files changed, 0 insertions(+), 73 deletions(-)

diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index 608c1c3..5c0106f 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -282,76 +282,3 @@ int ecryptfs_read_lower_page_segment(struct page *page_for_ecryptfs,
 	flush_dcache_page(page_for_ecryptfs);
 	return rc;
 }
-
-#if 0
-/**
- * ecryptfs_read
- * @data: The virtual address into which to write the data read (and
- *        possibly decrypted) from the lower file
- * @offset: The offset in the decrypted view of the file from which to
- *          read into @data
- * @size: The number of bytes to read into @data
- * @ecryptfs_file: The eCryptfs file from which to read
- *
- * Read an arbitrary amount of data from an arbitrary location in the
- * eCryptfs page cache. This is done on an extent-by-extent basis;
- * individual extents are decrypted and read from the lower page
- * cache (via VFS reads). This function takes care of all the
- * address translation to locations in the lower filesystem.
- *
- * Returns zero on success; non-zero otherwise
- */
-int ecryptfs_read(char *data, loff_t offset, size_t size,
-		  struct file *ecryptfs_file)
-{
-	struct inode *ecryptfs_inode = ecryptfs_file->f_dentry->d_inode;
-	struct page *ecryptfs_page;
-	char *ecryptfs_page_virt;
-	loff_t ecryptfs_file_size = i_size_read(ecryptfs_inode);
-	loff_t data_offset = 0;
-	loff_t pos;
-	int rc = 0;
-
-	if ((offset + size) > ecryptfs_file_size) {
-		rc = -EINVAL;
-		printk(KERN_ERR "%s: Attempt to read data past the end of the "
-			"file; offset = [%lld]; size = [%td]; "
-		       "ecryptfs_file_size = [%lld]\n",
-		       __func__, offset, size, ecryptfs_file_size);
-		goto out;
-	}
-	pos = offset;
-	while (pos < (offset + size)) {
-		pgoff_t ecryptfs_page_idx = (pos >> PAGE_CACHE_SHIFT);
-		size_t start_offset_in_page = (pos & ~PAGE_CACHE_MASK);
-		size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
-		size_t total_remaining_bytes = ((offset + size) - pos);
-
-		if (num_bytes > total_remaining_bytes)
-			num_bytes = total_remaining_bytes;
-		ecryptfs_page = ecryptfs_get_locked_page(ecryptfs_inode,
-							 ecryptfs_page_idx);
-		if (IS_ERR(ecryptfs_page)) {
-			rc = PTR_ERR(ecryptfs_page);
-			printk(KERN_ERR "%s: Error getting page at "
-			       "index [%ld] from eCryptfs inode "
-			       "mapping; rc = [%d]\n", __func__,
-			       ecryptfs_page_idx, rc);
-			goto out;
-		}
-		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
-		memcpy((data + data_offset),
-		       ((char *)ecryptfs_page_virt + start_offset_in_page),
-		       num_bytes);
-		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
-		flush_dcache_page(ecryptfs_page);
-		SetPageUptodate(ecryptfs_page);
-		unlock_page(ecryptfs_page);
-		page_cache_release(ecryptfs_page);
-		pos += num_bytes;
-		data_offset += num_bytes;
-	}
-out:
-	return rc;
-}
-#endif  /*  0  */
-- 
1.7.8.3

