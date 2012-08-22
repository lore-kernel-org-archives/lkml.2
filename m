Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab2HVBej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 21:34:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50743 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab2HVBec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 21:34:32 -0400
Date: Tue, 21 Aug 2012 18:33:45 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jeff Moyer <jmoyer@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        "Richard W.M. Jones" <rjones@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] block: replace __getblk_slow misfix by grow_dev_page fix
Message-ID: <alpine.LSU.2.00.1208211826270.2488@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

Your commit 91f68c89d8f3 ("block: fix infinite loop in __getblk_slow"),
already gone into 3.* stable, is not good.  Could you and your testers
please give this alternative a try - I think it should work, and have
started it on a few days' memory load on 3.5, but not tried your case.

But, see final paragraph of comment below, I'm worried whether
all __getblk() users are actually ready for your new NULL case.

Thanks,
Hugh

[PATCH] block: replace __getblk_slow misfix by grow_dev_page fix

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
a checkpatch nitfix).  Avoid the infinite loop beyond end of device
by instead checking buffer_mapped(bh) in grow_dev_page() (I presume
that's more efficient than a repeated call to blkdev_max_block()),
and returning -ENXIO to __getblk_slow() in that case.

And remove akpm's ten-year-old "__getblk() cannot fail ... weird"
comment, but that is worrying: are all users of __getblk() really
now prepared for a NULL bh beyond end of device, or will some oops??

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org # 3.0 3.2 3.4 3.5
---

 fs/buffer.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- 3.6-rc2/fs/buffer.c	2012-08-04 09:19:20.644022328 -0700
+++ linux/fs/buffer.c	2012-08-21 08:49:32.333908590 -0700
@@ -950,6 +950,7 @@ grow_dev_page(struct block_device *bdev,
 	struct inode *inode = bdev->bd_inode;
 	struct page *page;
 	struct buffer_head *bh;
+	int err = 0;
 
 	page = find_or_create_page(inode->i_mapping, index,
 		(mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS)|__GFP_MOVABLE);
@@ -962,7 +963,11 @@ grow_dev_page(struct block_device *bdev,
 		bh = page_buffers(page);
 		if (bh->b_size == size) {
 			init_page_buffers(page, bdev, block, size);
-			return page;
+			if (buffer_mapped(bh))
+				return page;
+
+			err = -ENXIO;
+			goto failed;
 		}
 		if (!try_to_free_buffers(page))
 			goto failed;
@@ -984,12 +989,14 @@ grow_dev_page(struct block_device *bdev,
 	link_dev_buffers(page, bh);
 	init_page_buffers(page, bdev, block, size);
 	spin_unlock(&inode->i_mapping->private_lock);
-	return page;
+	if (buffer_mapped(bh))
+		return page;
 
+	err = -ENXIO;
 failed:
 	unlock_page(page);
 	page_cache_release(page);
-	return NULL;
+	return ERR_PTR(err);
 }
 
 /*
@@ -1026,8 +1033,8 @@ grow_buffers(struct block_device *bdev,
 	block = index << sizebits;
 	/* Create a page with the proper size buffers.. */
 	page = grow_dev_page(bdev, block, index, size);
-	if (!page)
-		return 0;
+	if (IS_ERR_OR_NULL(page))
+		return PTR_RET(page);
 	unlock_page(page);
 	page_cache_release(page);
 	return 1;
@@ -1036,9 +1043,6 @@ grow_buffers(struct block_device *bdev,
 static struct buffer_head *
 __getblk_slow(struct block_device *bdev, sector_t block, int size)
 {
-	int ret;
-	struct buffer_head *bh;
-
 	/* Size must be multiple of hard sectorsize */
 	if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
 			(size < 512 || size > PAGE_SIZE))) {
@@ -1051,21 +1055,20 @@ __getblk_slow(struct block_device *bdev,
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
@@ -1321,10 +1324,6 @@ EXPORT_SYMBOL(__find_get_block);
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
