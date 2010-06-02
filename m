Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab0FBMUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:20:45 -0400
Received: from crca.org.au ([74.207.252.120]:52988 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203Ab0FBMUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:20:41 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 16/21] Hibernation: Replace bio chain
Date: Wed,  2 Jun 2010 22:19:15 +1000
Message-Id: <1275481160-31150-17-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
References: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the bio_chain concept with:
(1) simple atomic_t recording how many pages are in flight
(2) a wait queue for waiting for all I/O to complete
(3) a custom completion routine that frees bio structs and pages used
    for async writes as they complete, undates the atomic_t and
    wakes any waiters.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |   77 ++++++++++++++++++++++++++++------------------
 1 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index 9028f74..c9569e5 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -16,23 +16,61 @@
 #include "extents.h"
 #include "block_io.h"
 
-static struct bio *bio_chain;
-
 static char *hib_ppio_buffer;
 static int hib_ppio_buffer_posn;
 int hib_prepare_buffer(void);
 void hib_free_buffer(void);
 
+static atomic_t hib_io_in_progress;
+static DECLARE_WAIT_QUEUE_HEAD(num_in_progress_wait);
+
+/**
+ * hib_end_bio - bio completion function.
+ * @bio: bio that has completed.
+ * @err: Error value. Yes, like end_swap_bio_read, we ignore it.
+ *
+ * Function called by the block driver from interrupt context when I/O is
+ * completed. If we were writing the page, we want to free it and will have
+ * set bio->bi_private to the parameter we should use in telling the page
+ * allocation accounting code what the page was allocated for. If we're
+ * reading the page, it will be in the singly linked list made from
+ * page->private pointers.
+ **/
+static void hib_end_bio(struct bio *bio, int err)
+{
+	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	struct page *page = bio->bi_io_vec[0].bv_page;
+
+	if (!uptodate) {
+		SetPageError(page);
+		ClearPageUptodate(page);
+		printk(KERN_ALERT "I/O on swap-device (%u:%u:%Lu)\n",
+				imajor(bio->bi_bdev->bd_inode),
+				iminor(bio->bi_bdev->bd_inode),
+				(unsigned long long)bio->bi_sector);
+	} else {
+		SetPageUptodate(page);
+	}
+	unlock_page(page);
+	bio_put(bio);
+
+	if (bio->bi_private)
+		__free_page(page);
+
+	atomic_dec(&hib_io_in_progress);
+	wake_up(&num_in_progress_wait);
+}
+
 /**
  *	submit - submit BIO request.
  *	@rw:	READ or WRITE.
  *	@off	physical offset of page.
  *	@page:	page we're reading or writing.
- *	@bio_chain: list of pending biod (for async reading)
+ *	@sync:	whether the i/o should be done synchronously
  *
  *	Straight from the textbook - allocate and initialize the bio.
  *	If we're reading, make sure the page is marked as dirty.
- *	Then submit it and, if @bio_chain == NULL, wait.
+ *	Then submit it and, if @sync, wait.
  */
 static int submit(int rw, struct block_device *bdev, sector_t sector,
 		struct page *page, int sync)
@@ -43,7 +81,8 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
 	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
 	bio->bi_sector = sector;
 	bio->bi_bdev = bdev;
-	bio->bi_end_io = end_swap_bio_read;
+	bio->bi_private = (void *) (rw && !sync);
+	bio->bi_end_io = hib_end_bio;
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
 		printk(KERN_ERR "PM: Adding page to bio failed at %llu\n",
@@ -54,6 +93,7 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
 
 	lock_page(page);
 	bio_get(bio);
+	atomic_inc(&hib_io_in_progress);
 
 	if (sync) {
 		submit_bio(bio_rw, bio);
@@ -64,8 +104,6 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
 	} else {
 		if (rw == READ)
 			get_page(page);	/* These pages are freed later */
-		bio->bi_private = bio_chain;
-		bio_chain = bio;
 		submit_bio(bio_rw, bio);
 	}
 	return 0;
@@ -85,29 +123,8 @@ int hib_bio_write_page(pgoff_t page_off, void *addr, int sync)
 
 int hib_wait_on_bio_chain(void)
 {
-	struct bio *bio;
-	struct bio *next_bio;
-	int ret = 0;
-
-	if (bio_chain == NULL)
-		return 0;
-
-	bio = bio_chain;
-
-	while (bio) {
-		struct page *page;
-
-		next_bio = bio->bi_private;
-		page = bio->bi_io_vec[0].bv_page;
-		wait_on_page_locked(page);
-		if (!PageUptodate(page) || PageError(page))
-			ret = -EIO;
-		put_page(page);
-		bio_put(bio);
-		bio = next_bio;
-	}
-	bio_chain = NULL;
-	return ret;
+	wait_event(num_in_progress_wait, !atomic_read(&hib_io_in_progress));
+	return 0;
 }
 
 /*
-- 
1.7.0.4

