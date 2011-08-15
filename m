Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab1HOTO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:14:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:36953 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1HOTO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:14:27 -0400
From: Da Zheng <zhengda@chromium.org>
To: phillip@squashfs.org.uk
Cc: linux-kernel@vger.kernel.org, Da Zheng <zhengda@chromium.org>
Subject: [PATCH] Submit larger read requests in squashfs.
Date: Mon, 15 Aug 2011 12:14:04 -0700
Message-Id: <1313435644-27527-1-git-send-email-zhengda@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Squashfs originally use ll_rw_block to submit read requests, and the
request size can't be large. The patch enables squashfs to submit
requests to the block layer as large as possible to improve the
performance. The patch is developed in kernel v2.6.38.3.

Signed-off-by: Da Zheng <zhengda@chromium.org>
---
 fs/squashfs/block.c        |  322 ++++++++++++++++++++++++++++++++------------
 fs/squashfs/decompressor.h |    2 +
 fs/squashfs/lzo_wrapper.c  |   58 ++++++++
 3 files changed, 298 insertions(+), 84 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index ed0eb2a..4eccefa 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -31,52 +31,196 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/buffer_head.h>
+#include <linux/mpage.h>
+#include <linux/sched.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs.h"
 #include "decompressor.h"
 
+/* we don't need to initialize the buffer head completely.
+ * all we need is to set what is required by do_mpage_readpage(). */
+static int get_block(struct inode *inode, sector_t iblock,
+		     struct buffer_head *bh_result, int create)
+{
+	struct super_block *sb = inode->i_sb;
+	set_buffer_mapped(bh_result);
+	bh_result->b_bdev = inode->i_bdev;
+	bh_result->b_blocknr = iblock;
+	bh_result->b_size = sb->s_blocksize;
+	return 0;
+}
+
+static int read_mpages(struct super_block *sb, int length, u64 index)
+{
+	LIST_HEAD(pages);
+	int nr_pages, i, j;
+	pgoff_t page_offset;
+	struct block_device *bdev = sb->s_bdev;
+
+	length = ((((index + length) >> PAGE_CACHE_SHIFT) /* the last page */
+		- (index >> PAGE_CACHE_SHIFT)) /* the first page */
+		+ 1) << PAGE_CACHE_SHIFT;
+	nr_pages = length >> PAGE_CACHE_SHIFT;
+
+	for (page_offset = index >> PAGE_CACHE_SHIFT, i = 0;
+			i < nr_pages; i++) {
+		struct page *page = page_cache_alloc(bdev->bd_inode->i_mapping);
+		if (page == NULL)
+			goto nomem;
+
+		page->index = page_offset + i;
+		list_add(&page->lru, &pages);
+	}
+
+	/* mpage_readpages will remove the page from the page list
+	 * when it adds the page to the page cache. */
+	mpage_readpages(bdev->bd_inode->i_mapping, &pages, nr_pages, get_block);
+	return nr_pages;
+
+nomem:
+	printk(KERN_ERR "not enough memory\n");
+	for (j = 0; j < i; j++) {
+		struct page *page = list_entry(pages.prev, struct page, lru);
+		page_cache_release(page);
+	}
+	return -1;
+}
+
+struct page *wait_on_page(struct address_space *mapping, struct page *page)
+{
+	int err;
+
+	err = lock_page_killable(page);
+	if (unlikely(err)) {
+		printk(KERN_ERR "can't unlock the page\n");
+		return NULL;
+	}
+
+	if (page->mapping == NULL) {
+		unlock_page(page);
+		page_cache_release(page);
+		page = page_cache_alloc(mapping);
+		if (page == NULL)
+			return NULL;
+		goto read_again;
+	}
+
+	/* the page is read successfully. */
+	if (PageUptodate(page)) {
+		unlock_page(page);
+		return page;
+	}
+
+	ClearPageError(page);
+	printk(KERN_INFO "try to read the page again\n");
+read_again:
+	/* the read will unlock the page. */
+	err = mpage_readpage(page, get_block);
+	if (unlikely(err))
+		return NULL;
+
+	if (!PageUptodate(page)) {
+		err = lock_page_killable(page);
+		if (unlikely(err))
+			return NULL;
+
+		if (PageUptodate(page)) {
+			unlock_page(page);
+			return page;
+		}
+
+		if (page->mapping == NULL) {
+			unlock_page(page);
+			page_cache_release(page);
+			page = page_cache_alloc(mapping);
+			if (page == NULL)
+				return NULL;
+			goto read_again;
+		}
+		unlock_page(page);
+	}
+
+	printk(KERN_ERR "get a page not up-to-date\n");
+	return NULL;
+}
+
 /*
  * Read the metadata block length, this is stored in the first two
  * bytes of the metadata block.
  */
-static struct buffer_head *get_block_length(struct super_block *sb,
+static int get_block_length(struct super_block *sb,
 			u64 *cur_index, int *offset, int *length)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	struct buffer_head *bh;
+	struct page *page;
+	int npages;
+	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
 
-	bh = sb_bread(sb, *cur_index);
-	if (bh == NULL)
-		return NULL;
+	npages = read_mpages(sb, PAGE_CACHE_SIZE,
+			(*cur_index) << PAGE_CACHE_SHIFT);
+	if (npages < 0)
+		return -1;
 
-	if (msblk->devblksize - *offset == 1) {
-		*length = (unsigned char) bh->b_data[*offset];
-		put_bh(bh);
-		bh = sb_bread(sb, ++(*cur_index));
-		if (bh == NULL)
-			return NULL;
-		*length |= (unsigned char) bh->b_data[0] << 8;
+	page = find_get_page(mapping, *cur_index);
+	if (page == NULL)
+		return -1;
+	page = wait_on_page(mapping, page);
+	if (page == NULL) {
+		page_cache_release(page);
+		return -1;
+	}
+
+	if (PAGE_CACHE_SIZE - *offset == 1) {
+		unsigned char *kaddr = kmap_atomic(page, KM_USER0);
+
+		*length = kaddr[*offset];
+		kunmap_atomic(kaddr, KM_USER0);
+		page_cache_release(page);
+
+		(*cur_index)++;
+		npages = read_mpages(sb, PAGE_CACHE_SIZE,
+				(*cur_index) << PAGE_CACHE_SHIFT);
+		if (npages < 0)
+			return -1;
+
+		page = find_get_page(mapping, *cur_index);
+		if (page == NULL)
+			return -1;
+		page = wait_on_page(mapping, page);
+		if (page == NULL) {
+			page_cache_release(page);
+			return -1;
+		}
+
+		kaddr = kmap_atomic(page, KM_USER0);
+		*length |= kaddr[0];
+		kunmap_atomic(kaddr, KM_USER0);
+		page_cache_release(page);
 		*offset = 1;
 	} else {
-		*length = (unsigned char) bh->b_data[*offset] |
-			(unsigned char) bh->b_data[*offset + 1] << 8;
+		unsigned char *kaddr = kmap_atomic(page, KM_USER0);
+
+		*length = kaddr[*offset] | (kaddr[*offset + 1] << 8);
+		kunmap_atomic(kaddr, KM_USER0);
+		page_cache_release(page);
+
 		*offset += 2;
 
 		if (*offset == msblk->devblksize) {
-			put_bh(bh);
-			bh = sb_bread(sb, ++(*cur_index));
-			if (bh == NULL)
-				return NULL;
+			(*cur_index)++;
+			npages = read_mpages(sb, PAGE_CACHE_SIZE,
+					(*cur_index) << PAGE_CACHE_SHIFT);
+			if (npages < 0)
+				return -1;
 			*offset = 0;
 		}
 	}
 
-	return bh;
+	return 0;
 }
 
-
 /*
  * Read and decompress a metadata block or datablock.  Length is non-zero
  * if a datablock is being read (the size is stored elsewhere in the
@@ -86,24 +230,18 @@ static struct buffer_head *get_block_length(struct super_block *sb,
  * generated a larger block - this does occasionally happen with zlib).
  */
 int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
-			int length, u64 *next_index, int srclength, int pages)
+			int length, u64 *next_index, int srclength,
+			int dst_npages)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	struct buffer_head **bh;
-	int offset = index & ((1 << msblk->devblksize_log2) - 1);
-	u64 cur_index = index >> msblk->devblksize_log2;
-	int bytes, compressed, b = 0, k = 0, page = 0, avail;
-
-	bh = kcalloc(((srclength + msblk->devblksize - 1)
-		>> msblk->devblksize_log2) + 1, sizeof(*bh), GFP_KERNEL);
-	if (bh == NULL)
-		return -ENOMEM;
+	int bytes, compressed;
+	int npages;
+	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
 
 	if (length) {
 		/*
 		 * Datablock.
 		 */
-		bytes = -offset;
 		compressed = SQUASHFS_COMPRESSED_BLOCK(length);
 		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
 		if (next_index)
@@ -116,26 +254,22 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 				(index + length) > msblk->bytes_used)
 			goto read_failure;
 
-		for (b = 0; bytes < length; b++, cur_index++) {
-			bh[b] = sb_getblk(sb, cur_index);
-			if (bh[b] == NULL)
-				goto block_release;
-			bytes += msblk->devblksize;
-		}
-		ll_rw_block(READ, b, bh);
+		npages = read_mpages(sb, length, index);
+		if (npages < 0)
+			goto read_failure;
 	} else {
 		/*
 		 * Metadata block.
 		 */
+		int offset = index & (PAGE_CACHE_SIZE - 1);
+		u64 cur_index = index >> PAGE_CACHE_SHIFT;
+
 		if ((index + 2) > msblk->bytes_used)
 			goto read_failure;
 
-		bh[0] = get_block_length(sb, &cur_index, &offset, &length);
-		if (bh[0] == NULL)
+		if (get_block_length(sb, &cur_index, &offset, &length) < 0)
 			goto read_failure;
-		b = 1;
 
-		bytes = msblk->devblksize - offset;
 		compressed = SQUASHFS_COMPRESSED(length);
 		length = SQUASHFS_COMPRESSED_SIZE(length);
 		if (next_index)
@@ -146,65 +280,85 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 
 		if (length < 0 || length > srclength ||
 					(index + length) > msblk->bytes_used)
-			goto block_release;
+			goto read_failure;
 
-		for (; bytes < length; b++) {
-			bh[b] = sb_getblk(sb, ++cur_index);
-			if (bh[b] == NULL)
-				goto block_release;
-			bytes += msblk->devblksize;
+		index = (cur_index << PAGE_CACHE_SHIFT) + offset;
+		npages = 0;
+		if (length - (PAGE_CACHE_SIZE - offset) > 0) {
+			npages = read_mpages(sb, length
+					- (PAGE_CACHE_SIZE - offset),
+					(cur_index + 1) << PAGE_CACHE_SHIFT);
+			if (npages < 0)
+				goto read_failure;
 		}
-		ll_rw_block(READ, b - 1, bh + 1);
+		/* we have read a page in get_block_length. */
+		npages++;
 	}
 
 	if (compressed) {
-		length = squashfs_decompress(msblk, buffer, bh, b, offset,
-			 length, srclength, pages);
-		if (length < 0)
+		if (msblk->decompressor->decompress_page) {
+			length = msblk->decompressor->decompress_page(sb,
+					buffer, npages, index, length,
+					srclength, dst_npages);
+			if (length < 0)
+				goto read_failure;
+		} else
 			goto read_failure;
 	} else {
-		/*
-		 * Block is uncompressed.
-		 */
-		int i, in, pg_offset = 0;
+		/* copy the data from the page cache to the local buffer. */
+		int i, to_offset, from_offset, to_page;
+		u64 page_index = index >> PAGE_CACHE_SHIFT;
 
-		for (i = 0; i < b; i++) {
-			wait_on_buffer(bh[i]);
-			if (!buffer_uptodate(bh[i]))
-				goto block_release;
-		}
+		from_offset = index & (PAGE_CACHE_SIZE - 1);
+		to_offset = 0;
+		to_page = 0;
+		bytes = length;
+		length = 0;
+		for (i = 0; i < npages && bytes > 0; i++) {
+			void *kaddr;
+			struct page *page;
 
-		for (bytes = length; k < b; k++) {
-			in = min(bytes, msblk->devblksize - offset);
-			bytes -= in;
-			while (in) {
-				if (pg_offset == PAGE_CACHE_SIZE) {
-					page++;
-					pg_offset = 0;
-				}
-				avail = min_t(int, in, PAGE_CACHE_SIZE -
-						pg_offset);
-				memcpy(buffer[page] + pg_offset,
-						bh[k]->b_data + offset, avail);
-				in -= avail;
-				pg_offset += avail;
-				offset += avail;
+			page = find_get_page(mapping, page_index + i);
+			if (page == NULL)
+				goto read_failure;
+			page = wait_on_page(mapping, page);
+			if (page == NULL) {
+				page_cache_release(page);
+				goto read_failure;
 			}
-			offset = 0;
-			put_bh(bh[k]);
+
+			kaddr = kmap_atomic(page, KM_USER0);
+			/* copy a page from the kaddr to buffer. */
+			do {
+				int avail = min(PAGE_CACHE_SIZE - from_offset,
+						PAGE_CACHE_SIZE - to_offset);
+				avail = min(avail, bytes);
+				memcpy(buffer[to_page] + to_offset,
+						kaddr + from_offset, avail);
+				to_offset += avail;
+				from_offset += avail;
+				length += avail;
+				bytes -= avail;
+				/* if the destination page is full,
+				 * go to the next page. */
+				if (to_offset == PAGE_CACHE_SIZE) {
+					to_page++;
+					to_offset = 0;
+				}
+			} while (from_offset < PAGE_CACHE_SIZE
+					&& bytes > 0);
+			kunmap_atomic(kaddr, KM_USER0);
+			page_cache_release(page);
+			/* we are going to get a new source page,
+			 * and the offset will start from 0. */
+			from_offset = 0;
 		}
 	}
 
-	kfree(bh);
 	return length;
 
-block_release:
-	for (; k < b; k++)
-		put_bh(bh[k]);
-
 read_failure:
 	ERROR("squashfs_read_data failed to read block 0x%llx\n",
 					(unsigned long long) index);
-	kfree(bh);
 	return -EIO;
 }
diff --git a/fs/squashfs/decompressor.h b/fs/squashfs/decompressor.h
index 330073e..1130c74 100644
--- a/fs/squashfs/decompressor.h
+++ b/fs/squashfs/decompressor.h
@@ -28,6 +28,8 @@ struct squashfs_decompressor {
 	void	(*free)(void *);
 	int	(*decompress)(struct squashfs_sb_info *, void **,
 		struct buffer_head **, int, int, int, int, int);
+	int (*decompress_page)(struct super_block *, void **,
+			int, int, int, int, int);
 	int	id;
 	char	*name;
 	int	supported;
diff --git a/fs/squashfs/lzo_wrapper.c b/fs/squashfs/lzo_wrapper.c
index 00f4dfc..a3cc91d 100644
--- a/fs/squashfs/lzo_wrapper.c
+++ b/fs/squashfs/lzo_wrapper.c
@@ -73,6 +73,63 @@ static void lzo_free(void *strm)
 	kfree(stream);
 }
 
+struct page *wait_on_page(struct address_space *mapping, struct page *page);
+
+static int lzo_uncompress_page(struct super_block *sb, void **buffer,
+	int nr_pages, int index, int length, int srclength, int dst_npages)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	struct squashfs_lzo *stream = msblk->stream;
+	void *buff = stream->input;
+	int avail, i, bytes = length, res;
+	size_t out_len = srclength;
+	int offset = index & (PAGE_CACHE_SIZE - 1);
+	u64 page_index = index >> PAGE_CACHE_SHIFT;
+	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
+
+	mutex_lock(&msblk->read_data_mutex);
+
+	for (i = 0; i < nr_pages; i++) {
+		void *kaddr;
+		struct page *page = find_get_page(mapping, page_index + i);
+		if (page == NULL)
+			goto failed;
+		page = wait_on_page(mapping, page);
+		if (page == NULL)
+			goto failed;
+		avail = bytes < PAGE_CACHE_SIZE - offset ?
+			bytes : PAGE_CACHE_SIZE - offset;
+		kaddr = kmap_atomic(page, KM_USER0);
+		memcpy(buff, kaddr + offset, avail);
+		kunmap_atomic(kaddr, KM_USER0);
+		page_cache_release(page);
+		buff += avail;
+		bytes -= avail;
+		offset = 0;
+	}
+
+	res = lzo1x_decompress_safe(stream->input, (size_t)length,
+					stream->output, &out_len);
+	if (res != LZO_E_OK)
+		goto failed;
+
+	res = bytes = (int)out_len;
+	for (i = 0, buff = stream->output; bytes && i < dst_npages; i++) {
+		avail = min_t(int, bytes, PAGE_CACHE_SIZE);
+		memcpy(buffer[i], buff, avail);
+		buff += avail;
+		bytes -= avail;
+	}
+
+	mutex_unlock(&msblk->read_data_mutex);
+	return res;
+
+failed:
+	mutex_unlock(&msblk->read_data_mutex);
+
+	ERROR("lzo decompression failed, data probably corrupt\n");
+	return -EIO;
+}
 
 static int lzo_uncompress(struct squashfs_sb_info *msblk, void **buffer,
 	struct buffer_head **bh, int b, int offset, int length, int srclength,
@@ -129,6 +186,7 @@ const struct squashfs_decompressor squashfs_lzo_comp_ops = {
 	.init = lzo_init,
 	.free = lzo_free,
 	.decompress = lzo_uncompress,
+	.decompress_page = lzo_uncompress_page,
 	.id = LZO_COMPRESSION,
 	.name = "lzo",
 	.supported = 1
-- 
1.7.3.1

