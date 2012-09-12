Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab2IMAaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:30:46 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50843 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416Ab2ILXd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:33:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Hugh Dickins <hughd@google.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 057/108] block: replace __getblk_slow misfix by grow_dev_page fix
Date: Wed, 12 Sep 2012 16:28:55 -0700
Message-Id: <20120912232456.521188896@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 676ce6d5ca3098339c028d44fe0427d1566a4d2d upstream.

Commit 91f68c89d8f3 ("block: fix infinite loop in __getblk_slow")
is not good: a successful call to grow_buffers() cannot guarantee
that the page won't be reclaimed before the immediate next call to
__find_get_block(), which is why there was always a loop there.

Yesterday I got "EXT4-fs error (device loop0): __ext4_get_inode_loc:3595:
inode #19278: block 664: comm cc1: unable to read itable block" on console,
which pointed to this commit.

I've been trying to bisect for weeks, why kbuild-on-ext4-on-loop-on-tmpfs
sometimes fails from a missing header file, under memory pressure on
ppc G5.  I've never seen this on x86, and I've never seen it on 3.5-rc7
itself, despite that commit being in there: bisection pointed to an
irrelevant pinctrl merge, but hard to tell when failure takes between
18 minutes and 38 hours (but so far it's happened quicker on 3.6-rc2).

(I've since found such __ext4_get_inode_loc errors in /var/log/messages
from previous weeks: why the message never appeared on console until
yesterday morning is a mystery for another day.)

Revert 91f68c89d8f3, restoring __getblk_slow() to how it was (plus
a checkpatch nitfix).  Simplify the interface between grow_buffers()
and grow_dev_page(), and avoid the infinite loop beyond end of device
by instead checking init_page_buffers()'s end_block there (I presume
that's more efficient than a repeated call to blkdev_max_block()),
returning -ENXIO to __getblk_slow() in that case.

And remove akpm's ten-year-old "__getblk() cannot fail ... weird"
comment, but that is worrying: are all users of __getblk() really
now prepared for a NULL bh beyond end of device, or will some oops??

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/buffer.c |   66 +++++++++++++++++++++++++++---------------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -914,7 +914,7 @@ link_dev_buffers(struct page *page, stru
 /*
  * Initialise the state of a blockdev page's buffers.
  */ 
-static void
+static sector_t
 init_page_buffers(struct page *page, struct block_device *bdev,
 			sector_t block, int size)
 {
@@ -936,33 +936,41 @@ init_page_buffers(struct page *page, str
 		block++;
 		bh = bh->b_this_page;
 	} while (bh != head);
+
+	/*
+	 * Caller needs to validate requested block against end of device.
+	 */
+	return end_block;
 }
 
 /*
  * Create the page-cache page that contains the requested block.
  *
- * This is user purely for blockdev mappings.
+ * This is used purely for blockdev mappings.
  */
-static struct page *
+static int
 grow_dev_page(struct block_device *bdev, sector_t block,
-		pgoff_t index, int size)
+		pgoff_t index, int size, int sizebits)
 {
 	struct inode *inode = bdev->bd_inode;
 	struct page *page;
 	struct buffer_head *bh;
+	sector_t end_block;
+	int ret = 0;		/* Will call free_more_memory() */
 
 	page = find_or_create_page(inode->i_mapping, index,
 		(mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS)|__GFP_MOVABLE);
 	if (!page)
-		return NULL;
+		return ret;
 
 	BUG_ON(!PageLocked(page));
 
 	if (page_has_buffers(page)) {
 		bh = page_buffers(page);
 		if (bh->b_size == size) {
-			init_page_buffers(page, bdev, block, size);
-			return page;
+			end_block = init_page_buffers(page, bdev,
+						index << sizebits, size);
+			goto done;
 		}
 		if (!try_to_free_buffers(page))
 			goto failed;
@@ -982,14 +990,14 @@ grow_dev_page(struct block_device *bdev,
 	 */
 	spin_lock(&inode->i_mapping->private_lock);
 	link_dev_buffers(page, bh);
-	init_page_buffers(page, bdev, block, size);
+	end_block = init_page_buffers(page, bdev, index << sizebits, size);
 	spin_unlock(&inode->i_mapping->private_lock);
-	return page;
-
+done:
+	ret = (block < end_block) ? 1 : -ENXIO;
 failed:
 	unlock_page(page);
 	page_cache_release(page);
-	return NULL;
+	return ret;
 }
 
 /*
@@ -999,7 +1007,6 @@ failed:
 static int
 grow_buffers(struct block_device *bdev, sector_t block, int size)
 {
-	struct page *page;
 	pgoff_t index;
 	int sizebits;
 
@@ -1023,22 +1030,14 @@ grow_buffers(struct block_device *bdev,
 			bdevname(bdev, b));
 		return -EIO;
 	}
-	block = index << sizebits;
+
 	/* Create a page with the proper size buffers.. */
-	page = grow_dev_page(bdev, block, index, size);
-	if (!page)
-		return 0;
-	unlock_page(page);
-	page_cache_release(page);
-	return 1;
+	return grow_dev_page(bdev, block, index, size, sizebits);
 }
 
 static struct buffer_head *
 __getblk_slow(struct block_device *bdev, sector_t block, int size)
 {
-	int ret;
-	struct buffer_head *bh;
-
 	/* Size must be multiple of hard sectorsize */
 	if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
 			(size < 512 || size > PAGE_SIZE))) {
@@ -1051,21 +1050,20 @@ __getblk_slow(struct block_device *bdev,
 		return NULL;
 	}
 
-retry:
-	bh = __find_get_block(bdev, block, size);
-	if (bh)
-		return bh;
+	for (;;) {
+		struct buffer_head *bh;
+		int ret;
 
-	ret = grow_buffers(bdev, block, size);
-	if (ret == 0) {
-		free_more_memory();
-		goto retry;
-	} else if (ret > 0) {
 		bh = __find_get_block(bdev, block, size);
 		if (bh)
 			return bh;
+
+		ret = grow_buffers(bdev, block, size);
+		if (ret < 0)
+			return NULL;
+		if (ret == 0)
+			free_more_memory();
 	}
-	return NULL;
 }
 
 /*
@@ -1321,10 +1319,6 @@ EXPORT_SYMBOL(__find_get_block);
  * which corresponds to the passed block_device, block and size. The
  * returned buffer has its reference count incremented.
  *
- * __getblk() cannot fail - it just keeps trying.  If you pass it an
- * illegal block number, __getblk() will happily return a buffer_head
- * which represents the non-existent block.  Very weird.
- *
  * __getblk() will lock up the machine if grow_dev_page's try_to_free_buffers()
  * attempt is failing.  FIXME, perhaps?
  */


