Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab0IYETx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 00:19:53 -0400
Received: from crca.org.au ([74.207.252.120]:35759 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277Ab0IYER0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 00:17:26 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 10/22] Hibernation: Stop passing bio_chain around
Date: Sat, 25 Sep 2010 14:16:52 +1000
Message-Id: <1285388224-10012-11-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using the struct bio **bio_chain as a means of tracking
outstanding i/o and signalling when we want synchronous i/o.
Instead, keep a bio_chain in the block_io code and use a flag
to explicitly request synchronous I/O.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |   27 +++++++++++-----------
 kernel/power/power.h    |    8 ++----
 kernel/power/swap.c     |   56 +++++++++++++++++++++-------------------------
 3 files changed, 43 insertions(+), 48 deletions(-)

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index 83bbc7c..aa239a2 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -14,6 +14,8 @@
 
 #include "power.h"
 
+static struct bio *bio_chain;
+
 /**
  *	submit - submit BIO request.
  *	@rw:	READ or WRITE.
@@ -26,7 +28,7 @@
  *	Then submit it and, if @bio_chain == NULL, wait.
  */
 static int submit(int rw, struct block_device *bdev, sector_t sector,
-		struct page *page, struct bio **bio_chain)
+		struct page *page, int sync)
 {
 	const int bio_rw = rw | REQ_SYNC | REQ_UNPLUG;
 	struct bio *bio;
@@ -46,7 +48,7 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
 	lock_page(page);
 	bio_get(bio);
 
-	if (bio_chain == NULL) {
+	if (sync) {
 		submit_bio(bio_rw, bio);
 		wait_on_page_locked(page);
 		if (rw == READ)
@@ -55,26 +57,26 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
 	} else {
 		if (rw == READ)
 			get_page(page);	/* These pages are freed later */
-		bio->bi_private = *bio_chain;
-		*bio_chain = bio;
+		bio->bi_private = bio_chain;
+		bio_chain = bio;
 		submit_bio(bio_rw, bio);
 	}
 	return 0;
 }
 
-int hib_bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
+int hib_bio_read_page(pgoff_t page_off, void *addr, int sync)
 {
 	return submit(READ, hib_resume_bdev, page_off * (PAGE_SIZE >> 9),
-			virt_to_page(addr), bio_chain);
+			virt_to_page(addr), sync);
 }
 
-int hib_bio_write_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
+int hib_bio_write_page(pgoff_t page_off, void *addr, int sync)
 {
 	return submit(WRITE, hib_resume_bdev, page_off * (PAGE_SIZE >> 9),
-			virt_to_page(addr), bio_chain);
+			virt_to_page(addr), sync);
 }
 
-int hib_wait_on_bio_chain(struct bio **bio_chain)
+int hib_wait_on_bio_chain(void)
 {
 	struct bio *bio;
 	struct bio *next_bio;
@@ -83,9 +85,8 @@ int hib_wait_on_bio_chain(struct bio **bio_chain)
 	if (bio_chain == NULL)
 		return 0;
 
-	bio = *bio_chain;
-	if (bio == NULL)
-		return 0;
+	bio = bio_chain;
+
 	while (bio) {
 		struct page *page;
 
@@ -98,6 +99,6 @@ int hib_wait_on_bio_chain(struct bio **bio_chain)
 		bio_put(bio);
 		bio = next_bio;
 	}
-	*bio_chain = NULL;
+	bio_chain = NULL;
 	return ret;
 }
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 67b6896..1750f64 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -147,11 +147,9 @@ extern void swsusp_close(fmode_t);
 /* kernel/power/block_io.c */
 extern struct block_device *hib_resume_bdev;
 
-extern int hib_bio_read_page(pgoff_t page_off, void *addr,
-		struct bio **bio_chain);
-extern int hib_bio_write_page(pgoff_t page_off, void *addr,
-		struct bio **bio_chain);
-extern int hib_wait_on_bio_chain(struct bio **bio_chain);
+extern int hib_bio_read_page(pgoff_t page_off, void *addr, int sync);
+extern int hib_bio_write_page(pgoff_t page_off, void *addr, int sync);
+extern int hib_wait_on_bio_chain(void);
 
 struct timeval;
 /* kernel/power/swsusp.c */
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 1df890f..a881086 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -179,7 +179,7 @@ static int mark_swapfiles(unsigned int flags)
 {
 	int error;
 
-	hib_bio_read_page(swsusp_resume_block, swsusp_header, NULL);
+	hib_bio_read_page(swsusp_resume_block, swsusp_header, 1);
 	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
 	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
@@ -188,7 +188,7 @@ static int mark_swapfiles(unsigned int flags)
 		swsusp_header->image = handle.first_sector;
 		swsusp_header->flags = flags;
 		error = hib_bio_write_page(swsusp_resume_block,
-					swsusp_header, NULL);
+					swsusp_header, 1);
 	} else {
 		printk(KERN_ERR "PM: Swap header not found!\n");
 		error = -ENODEV;
@@ -227,29 +227,29 @@ static int swsusp_swap_check(void)
  *	write_page - Write one page to given swap location.
  *	@buf:		Address we're writing.
  *	@offset:	Offset of the swap page we're writing to.
- *	@bio_chain:	Link the next write BIO here
+ *	@sync:		Whether to force synchronous i/o.
  */
 
-static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
+static int write_page(void *buf, sector_t offset, int sync)
 {
 	void *src;
 
 	if (!offset)
 		return -ENOSPC;
 
-	if (bio_chain) {
+	if (!sync) {
 		src = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
 		if (src) {
 			memcpy(src, buf, PAGE_SIZE);
 		} else {
 			WARN_ON_ONCE(1);
-			bio_chain = NULL;	/* Go synchronous */
+			sync = 1;	/* Go synchronous */
 			src = buf;
 		}
 	} else {
 		src = buf;
 	}
-	return hib_bio_write_page(offset, src, bio_chain);
+	return hib_bio_write_page(offset, src, sync);
 }
 
 static void release_swap_writer(void)
@@ -295,7 +295,7 @@ err_close:
 	return ret;
 }
 
-static int swap_write_page(void *buf, struct bio **bio_chain)
+static int swap_write_page(void *buf, int sync)
 {
 	int error = 0;
 	sector_t offset;
@@ -303,19 +303,19 @@ static int swap_write_page(void *buf, struct bio **bio_chain)
 	if (!handle.cur)
 		return -EINVAL;
 	offset = hib_extent_next(&sector_extents);
-	error = write_page(buf, offset, bio_chain);
+	error = write_page(buf, offset, sync);
 	if (error)
 		return error;
 	handle.cur->entries[handle.k++] = offset;
 	if (handle.k >= MAP_PAGE_ENTRIES) {
-		error = hib_wait_on_bio_chain(bio_chain);
+		error = hib_wait_on_bio_chain();
 		if (error)
 			goto out;
 		offset = hib_extent_next(&sector_extents);
 		if (!offset)
 			return -ENOSPC;
 		handle.cur->next_swap = offset;
-		error = write_page(handle.cur, handle.cur_swap, NULL);
+		error = write_page(handle.cur, handle.cur_swap, 1);
 		if (error)
 			goto out;
 		memset(handle.cur, 0, PAGE_SIZE);
@@ -329,7 +329,7 @@ static int swap_write_page(void *buf, struct bio **bio_chain)
 static int flush_swap_writer(void)
 {
 	if (handle.cur && handle.cur_swap)
-		return write_page(handle.cur, handle.cur_swap, NULL);
+		return write_page(handle.cur, handle.cur_swap, 1);
 	else
 		return -EINVAL;
 }
@@ -362,7 +362,6 @@ static int save_image(struct snapshot_handle *snapshot,
 	int ret;
 	int nr_pages;
 	int err2;
-	struct bio *bio;
 	struct timeval start;
 	struct timeval stop;
 	int mps;
@@ -373,20 +372,19 @@ static int save_image(struct snapshot_handle *snapshot,
 	if (!m)
 		m = 1;
 	nr_pages = 0;
-	bio = NULL;
 	do_gettimeofday(&start);
 	while (1) {
 		ret = snapshot_read_next(snapshot);
 		if (ret <= 0)
 			break;
-		ret = swap_write_page(data_of(*snapshot), &bio);
+		ret = swap_write_page(data_of(*snapshot), 0);
 		if (ret)
 			break;
 		if (!(nr_pages % m))
 			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
 	}
-	err2 = hib_wait_on_bio_chain(&bio);
+	err2 = hib_wait_on_bio_chain();
 	do_gettimeofday(&stop);
 	if (!ret)
 		ret = err2;
@@ -431,7 +429,7 @@ int swsusp_write(unsigned int flags)
 		goto out_finish;
 	}
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = swap_write_page(header, NULL);
+	error = swap_write_page(header, 1);
 	if (!error)
 		error = save_image(&snapshot, pages - 1);
 out_finish:
@@ -464,7 +462,7 @@ static int get_swap_reader(unsigned int *flags_p)
 	if (!handle.cur)
 		return -ENOMEM;
 
-	error = hib_bio_read_page(swsusp_header->image, handle.cur, NULL);
+	error = hib_bio_read_page(swsusp_header->image, handle.cur, 1);
 	if (error) {
 		release_swap_reader();
 		return error;
@@ -473,7 +471,7 @@ static int get_swap_reader(unsigned int *flags_p)
 	return 0;
 }
 
-static int swap_read_page(void *buf, struct bio **bio_chain)
+static int swap_read_page(void *buf, int sync)
 {
 	sector_t offset;
 	int error;
@@ -483,17 +481,17 @@ static int swap_read_page(void *buf, struct bio **bio_chain)
 	offset = handle.cur->entries[handle.k];
 	if (!offset)
 		return -EFAULT;
-	error = hib_bio_read_page(offset, buf, bio_chain);
+	error = hib_bio_read_page(offset, buf, sync);
 	if (error)
 		return error;
 	if (++handle.k >= MAP_PAGE_ENTRIES) {
-		error = hib_wait_on_bio_chain(bio_chain);
+		error = hib_wait_on_bio_chain();
 		handle.k = 0;
 		offset = handle.cur->next_swap;
 		if (!offset)
 			release_swap_reader();
 		else if (!error)
-			error = hib_bio_read_page(offset, handle.cur, NULL);
+			error = hib_bio_read_page(offset, handle.cur, 1);
 	}
 	return error;
 }
@@ -517,7 +515,6 @@ static int load_image(struct snapshot_handle *snapshot, unsigned int nr_to_read)
 	int error = 0;
 	struct timeval start;
 	struct timeval stop;
-	struct bio *bio;
 	int err2;
 	unsigned nr_pages;
 	int mps;
@@ -528,24 +525,23 @@ static int load_image(struct snapshot_handle *snapshot, unsigned int nr_to_read)
 	if (!m)
 		m = 1;
 	nr_pages = 0;
-	bio = NULL;
 	do_gettimeofday(&start);
 	for ( ; ; ) {
 		error = snapshot_write_next(snapshot);
 		if (error <= 0)
 			break;
-		error = swap_read_page(data_of(*snapshot), &bio);
+		error = swap_read_page(data_of(*snapshot), 0);
 		if (error)
 			break;
 		if (snapshot->sync_read)
-			error = hib_wait_on_bio_chain(&bio);
+			error = hib_wait_on_bio_chain();
 		if (error)
 			break;
 		if (!(nr_pages % m))
 			printk("\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
 	}
-	err2 = hib_wait_on_bio_chain(&bio);
+	err2 = hib_wait_on_bio_chain();
 	do_gettimeofday(&stop);
 	if (!error)
 		error = err2;
@@ -582,7 +578,7 @@ int swsusp_read(unsigned int *flags_p)
 	if (error)
 		goto end;
 	if (!error)
-		error = swap_read_page(header, NULL);
+		error = swap_read_page(header, 1);
 	if (!error)
 		error = load_image(&snapshot, header->pages - 1);
 	swap_reader_finish();
@@ -607,7 +603,7 @@ int swsusp_check(void)
 		set_blocksize(hib_resume_bdev, PAGE_SIZE);
 		memset(swsusp_header, 0, PAGE_SIZE);
 		error = hib_bio_read_page(swsusp_resume_block,
-					swsusp_header, NULL);
+					swsusp_header, 1);
 		if (error)
 			goto put;
 
@@ -616,7 +612,7 @@ int swsusp_check(void)
 			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
 			/* Reset swap signature now */
 			error = hib_bio_write_page(swsusp_resume_block,
-						swsusp_header, NULL);
+						swsusp_header, 1);
 		} else {
 			error = -EINVAL;
 		}
-- 
1.7.0.4

