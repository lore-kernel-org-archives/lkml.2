Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab0I0Foo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:44:44 -0400
Received: from crca.org.au ([74.207.252.120]:47966 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758368Ab0I0Fom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:42 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 23/23] Hibernate: Implement readahead when resuming
Date: Mon, 27 Sep 2010 15:43:58 +1000
Message-Id: <1285566238-10966-24-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for submitting reads before they're needed. This greatly
improves the speed of resuming:

From

PM: Image read at 66 MB/s.

to

PM: Image read at 229 MB/s.

...and removes the need for the sync_read flag.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |   89 ++++++++++++++++++++++++++++++++++++++++++++---
 kernel/power/power.h    |    4 --
 kernel/power/snapshot.c |    5 ---
 kernel/power/swap.c     |    2 -
 4 files changed, 84 insertions(+), 16 deletions(-)

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index fc2e05d..70ac2c5 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -24,6 +24,9 @@ void hib_free_buffer(void);
 static atomic_t hib_io_in_progress;
 static DECLARE_WAIT_QUEUE_HEAD(num_in_progress_wait);
 
+static int more_readahead = 1, readahead_list_size;
+static struct page *readahead_list_head, *readahead_list_tail;
+
 /**
  * hib_end_bio - bio completion function.
  * @bio: bio that has completed.
@@ -67,13 +70,14 @@ static void hib_end_bio(struct bio *bio, int err)
  *	@off	physical offset of page.
  *	@page:	page we're reading or writing.
  *	@sync:	whether the i/o should be done synchronously
+ *	@ra:	whether the page is readahead
  *
  *	Straight from the textbook - allocate and initialize the bio.
  *	If we're reading, make sure the page is marked as dirty.
  *	Then submit it and, if @sync, wait.
  */
 static int submit(int rw, struct block_device *bdev, sector_t sector,
-		struct page *page, int sync)
+		struct page *page, int sync, int ra)
 {
 	const int bio_rw = rw | REQ_SYNC | REQ_UNPLUG;
 	struct bio *bio;
@@ -95,6 +99,18 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
 	bio_get(bio);
 	atomic_inc(&hib_io_in_progress);
 
+	page->private = 0;
+
+	if (ra) {
+		if (readahead_list_head)
+			readahead_list_tail->private = (unsigned long) page;
+		else
+			readahead_list_head = page;
+
+		readahead_list_tail = page;
+		readahead_list_size++;
+	}
+
 	if (sync) {
 		submit_bio(bio_rw, bio);
 		wait_on_page_locked(page);
@@ -112,18 +128,25 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
 int hib_bio_read_page(pgoff_t page_off, void *addr, int sync)
 {
 	return submit(READ, hib_resume_bdev, page_off * (PAGE_SIZE >> 9),
-			virt_to_page(addr), sync);
+			virt_to_page(addr), sync, 0);
 }
 
 int hib_bio_write_page(pgoff_t page_off, void *addr, int sync)
 {
 	return submit(WRITE, hib_resume_bdev, page_off * (PAGE_SIZE >> 9),
-			virt_to_page(addr), sync);
+			virt_to_page(addr), sync, 0);
 }
 
 void hib_wait_on_bio_chain(void)
 {
 	wait_event(num_in_progress_wait, !atomic_read(&hib_io_in_progress));
+
+	while (readahead_list_head) {
+		struct page *next = (struct page *) readahead_list_head->private;
+		__free_page(readahead_list_head);
+		readahead_list_head = next;
+		readahead_list_size--;
+	}
 }
 
 static sector_t first_sector;
@@ -220,14 +243,70 @@ int get_swap_reader(unsigned int *flags_p, sector_t first_page)
 	return error;
 }
 
-int swap_read_page(void *buf, int sync)
+int start_one_readahead(void)
 {
 	sector_t offset;
+	struct page *ra_page;
+	int result = 0;
+
+	if (!more_readahead)
+		return 0;
+
+	ra_page = alloc_pages(GFP_NOIO, 0);
+
+	/* No memory for readahead? */
+	if (!ra_page)
+		return 0;
 
 	offset = hib_extent_next(&sector_extents);
 	if (!offset)
+		more_readahead = 0;
+	else
+		result = submit(READ, hib_resume_bdev,
+				offset * (PAGE_SIZE >> 9),
+				ra_page, 0, 1);
+
+	if (result)
+		__free_page(ra_page);
+
+	return result;
+}
+
+int start_more_readahead(void)
+{
+	int ret = 0;
+
+	while (!ret && readahead_list_size < 1000 && more_readahead)
+		ret = start_one_readahead();
+
+	return ret;
+}
+
+int swap_read_page(void *buf, int sync)
+{
+	char *ra;
+	struct page *old;
+	int err = start_more_readahead();
+
+	if (err)
+		return err;
+
+	if (!readahead_list_head)
 		return -EFAULT;
-	return hib_bio_read_page(offset, buf, sync);
+
+	wait_on_page_locked(readahead_list_head);
+
+	ra = kmap(readahead_list_head);
+	memcpy(buf, ra, PAGE_SIZE);
+	kunmap(readahead_list_head);
+
+	old = readahead_list_head;
+	readahead_list_head = (struct page *) old->private;
+	__free_page(old);
+
+	readahead_list_size--;
+
+	return 0;
 }
 
 /* Part Page I/O functions */
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 9525b9c..aecb8ec 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -111,10 +111,6 @@ struct snapshot_handle {
 	void		*buffer;	/* address of the block to read from
 					 * or write to
 					 */
-	int		sync_read;	/* Set to one to notify the caller of
-					 * snapshot_write_next() that it may
-					 * need to call wait_on_bio_chain()
-					 */
 };
 
 /* This macro returns the address from/to which the caller of
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index ac7eb10..1f875a0 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2187,8 +2187,6 @@ int snapshot_write_next(struct snapshot_handle *handle)
 	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages)
 		return 0;
 
-	handle->sync_read = 1;
-
 	if (!handle->cur) {
 		if (!buffer)
 			/* This makes the buffer be freed by swsusp_free() */
@@ -2221,7 +2219,6 @@ int snapshot_write_next(struct snapshot_handle *handle)
 			memory_bm_position_reset(&orig_bm);
 			restore_pblist = NULL;
 			handle->buffer = get_buffer(&orig_bm, &ca);
-			handle->sync_read = 0;
 			if (IS_ERR(handle->buffer))
 				return PTR_ERR(handle->buffer);
 		}
@@ -2230,8 +2227,6 @@ int snapshot_write_next(struct snapshot_handle *handle)
 		handle->buffer = get_buffer(&orig_bm, &ca);
 		if (IS_ERR(handle->buffer))
 			return PTR_ERR(handle->buffer);
-		if (handle->buffer != buffer)
-			handle->sync_read = 0;
 	}
 	handle->cur++;
 	return PAGE_SIZE;
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 0e94484..fb3a21f 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -344,8 +344,6 @@ static int load_image(struct snapshot_handle *snapshot,
 		error = compress_read(data_of(*snapshot), flags);
 		if (error)
 			break;
-		if (snapshot->sync_read)
-			hib_wait_on_bio_chain();
 		if (!(nr_pages % m))
 			printk("\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
-- 
1.7.0.4

