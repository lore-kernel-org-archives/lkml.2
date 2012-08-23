Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2HWE5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 00:57:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47119 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2HWE46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 00:56:58 -0400
Date: Wed, 22 Aug 2012 21:56:12 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Richard W.M. Jones" <rjones@redhat.com>
cc: Jeff Moyer <jmoyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: replace __getblk_slow misfix by grow_dev_page
 fix
In-Reply-To: <20120822115243.GU1448@rhmail.home.annexia.org>
Message-ID: <alpine.LSU.2.00.1208222143440.1917@eggly.anvils>
References: <alpine.LSU.2.00.1208211826270.2488@eggly.anvils> <20120822115243.GU1448@rhmail.home.annexia.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Richard W.M. Jones wrote:
> On Tue, Aug 21, 2012 at 06:33:45PM -0700, Hugh Dickins wrote:
> > Jeff,
> > 
> > Your commit 91f68c89d8f3 ("block: fix infinite loop in __getblk_slow"),
> > already gone into 3.* stable, is not good.  Could you and your testers
> > please give this alternative a try - I think it should work, and have
> > started it on a few days' memory load on 3.5, but not tried your case.
> 
> I have tested your patch and it does NOT fix the problem in
> http://bugzilla.redhat.com/835019
> Kernel 3.6.0 + your patch => mount goes into a loop when mounting
> a small empty partition.  Please do NOT apply this as it will
> cause a regression!

That was all very helpful information that you provided, thank you.
Sorry, I had missed how "block" is massaged as it's passed down a level.

The patch below fixes it for me, though it does have to change more than
I'd been hoping in such a fix.  Perhaps I am just being silly to resist
repeating the call to blkdev_max_block().  Does this patch work for you?

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
a checkpatch nitfix).  Simplify the interface between grow_buffers()
and grow_dev_page(), and avoid the infinite loop beyond end of device
by instead checking init_page_buffers()'s end_block there (I presume
that's more efficient than a repeated call to blkdev_max_block()),
returning -ENXIO to __getblk_slow() in that case.

And remove akpm's ten-year-old "__getblk() cannot fail ... weird"
comment, but that is worrying: are all users of __getblk() really
now prepared for a NULL bh beyond end of device, or will some oops??

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org # 3.0 3.2 3.4 3.5
---

 fs/buffer.c |   66 ++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

--- 3.6-rc3/fs/buffer.c	2012-08-04 09:19:20.644022328 -0700
+++ linux/fs/buffer.c	2012-08-22 17:11:57.143827063 -0700
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
