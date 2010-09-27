Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0I0FoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:44:24 -0400
Received: from crca.org.au ([74.207.252.120]:58626 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932746Ab0I0FoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:22 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 11/23] Hibernation: Stop passing bio_chain around
Date: Mon, 27 Sep 2010 15:43:46 +1000
Message-Id: <1285566238-10966-12-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using the struct bio **bio_chain as a means of tracking
outstanding i/o and signalling when we want synchronous i/o.
Instead, keep a bio_chain in the block_io code and use a flag
to explicitly request synchronous I/O.

Note that this patch includes a slight modification to the
behaviour of swsusp. Until now, if a page could not be allocated
for the copy of a page to be written, that bio and all future
pages would be written synchronously. After this patch, the
bio with the failed allocation is written synchronously, but we
still write future pages asynchronously if possible.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |   27 +++++++++++----------
 kernel/power/compress.c |   22 +++++++++---------
 kernel/power/compress.h |    6 ++--
 kernel/power/power.h    |    8 ++----
 kernel/power/swap.c     |   58 +++++++++++++++++++++-------------------------
 kernel/power/swap.h     |    4 +-
 6 files changed, 60 insertions(+), 65 deletions(-)

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
diff --git a/kernel/power/compress.c b/kernel/power/compress.c
index b8b8c63..bb9b9ab 100644
--- a/kernel/power/compress.c
+++ b/kernel/power/compress.c
@@ -78,7 +78,7 @@ int compress_image_init(void)
 	return 0;
 }
 
-static int compress_and_write(struct bio **bio)
+static int compress_and_write(void)
 {
 	int ret;
 
@@ -111,7 +111,7 @@ static int compress_and_write(struct bio **bio)
 	for (off = 0; off < LZO_HEADER + cmp_len; off += PAGE_SIZE) {
 		memcpy(page, cmp + off, PAGE_SIZE);
 
-		ret = swap_write_page(page, bio);
+		ret = swap_write_page(page, 0);
 		if (ret)
 			return ret;
 	}
@@ -120,30 +120,30 @@ static int compress_and_write(struct bio **bio)
 	return 0;
 }
 
-int compress_write(char *buf, struct bio **bio, int flags)
+int compress_write(char *buf, int flags)
 {
 	int ret = 0;
 
 	if (flags & SF_NOCOMPRESS_MODE)
-		return swap_write_page(buf, bio);
+		return swap_write_page(buf, 0);
 
 	if (off == LZO_UNC_SIZE)
-		ret = compress_and_write(bio);
+		ret = compress_and_write();
 
 	memcpy(unc + off, buf, PAGE_SIZE);
 	off += PAGE_SIZE;
 	return ret;
 }
 
-void compress_write_finish(struct bio **bio, int flags)
+void compress_write_finish(int flags)
 {
 	if (!(flags & SF_NOCOMPRESS_MODE))
-		compress_and_write(bio);
+		compress_and_write();
 }
 
 static int read_and_decompress(void)
 {
-	int error = swap_read_page(page, NULL), off;
+	int error = swap_read_page(page, 1), off;
 	cmp_len = *(size_t *)page;
 
 	if (unlikely(!cmp_len ||
@@ -154,7 +154,7 @@ static int read_and_decompress(void)
 
 	memcpy(cmp, page, PAGE_SIZE);
 	for (off = PAGE_SIZE; off < LZO_HEADER + cmp_len; off += PAGE_SIZE) {
-		error = swap_read_page(page, NULL); /* sync */
+		error = swap_read_page(page, 1); /* sync */
 		if (error)
 			return error;
 
@@ -179,12 +179,12 @@ static int read_and_decompress(void)
 	return 0;
 }
 
-int compress_read(char *buf, struct bio **bio, int flags)
+int compress_read(char *buf, int flags)
 {
 	int ret = 0;
 
 	if (flags & SF_NOCOMPRESS_MODE)
-		return swap_read_page(buf, bio);
+		return swap_read_page(buf, 0);
 
 	if (!off) {
 		ret = read_and_decompress();
diff --git a/kernel/power/compress.h b/kernel/power/compress.h
index a25f673..df8ea7c 100644
--- a/kernel/power/compress.h
+++ b/kernel/power/compress.h
@@ -12,7 +12,7 @@
 
 int compress_image_init(void);
 void compress_image_cleanup(void);
-int compress_write(char *page, struct bio **bio, int flags);
-void compress_write_finish(struct bio **bio, int flags);
-int compress_read(char *page, struct bio **bio, int flags);
+int compress_write(char *page, int flags);
+void compress_write_finish(int flags);
+int compress_read(char *page, int flags);
 unsigned int compress_extra_pages(unsigned int base, unsigned int flags);
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 22f8607..3c11987 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -154,11 +154,9 @@ extern void swsusp_close(fmode_t);
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
index 7340314..d828fe9 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -173,7 +173,7 @@ static int mark_swapfiles(unsigned int flags)
 {
 	int error;
 
-	hib_bio_read_page(swsusp_resume_block, swsusp_header, NULL);
+	hib_bio_read_page(swsusp_resume_block, swsusp_header, 1);
 	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
 	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
@@ -182,7 +182,7 @@ static int mark_swapfiles(unsigned int flags)
 		swsusp_header->image = handle.first_sector;
 		swsusp_header->flags = flags;
 		error = hib_bio_write_page(swsusp_resume_block,
-					swsusp_header, NULL);
+					swsusp_header, 1);
 	} else {
 		printk(KERN_ERR "PM: Swap header not found!\n");
 		error = -ENODEV;
@@ -221,29 +221,29 @@ static int swsusp_swap_check(void)
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
@@ -289,7 +289,7 @@ err_close:
 	return ret;
 }
 
-int swap_write_page(void *buf, struct bio **bio_chain)
+int swap_write_page(void *buf, int sync)
 {
 	int error = 0;
 	sector_t offset;
@@ -297,19 +297,19 @@ int swap_write_page(void *buf, struct bio **bio_chain)
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
@@ -323,7 +323,7 @@ int swap_write_page(void *buf, struct bio **bio_chain)
 static int flush_swap_writer(void)
 {
 	if (handle.cur && handle.cur_swap)
-		return write_page(handle.cur, handle.cur_swap, NULL);
+		return write_page(handle.cur, handle.cur_swap, 1);
 	else
 		return -EINVAL;
 }
@@ -357,7 +357,6 @@ static int save_image(struct snapshot_handle *snapshot,
 	int ret;
 	int nr_pages;
 	int err2;
-	struct bio *bio;
 	struct timeval start;
 	struct timeval stop;
 	int mps;
@@ -368,21 +367,20 @@ static int save_image(struct snapshot_handle *snapshot,
 	if (!m)
 		m = 1;
 	nr_pages = 0;
-	bio = NULL;
 	do_gettimeofday(&start);
 	while (1) {
 		ret = snapshot_read_next(snapshot);
 		if (ret <= 0)
 			break;
-		ret = compress_write(data_of(*snapshot), &bio, flags);
+		ret = compress_write(data_of(*snapshot), flags);
 		if (ret)
 			break;
 		if (!(nr_pages % m))
 			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
 	}
-	compress_write_finish(&bio, flags);
-	err2 = hib_wait_on_bio_chain(&bio);
+	compress_write_finish(flags);
+	err2 = hib_wait_on_bio_chain();
 	do_gettimeofday(&stop);
 	if (!ret)
 		ret = err2;
@@ -434,7 +432,7 @@ int swsusp_write(unsigned int flags)
 		goto out_finish;
 	}
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = swap_write_page(header, NULL);
+	error = swap_write_page(header, 1);
 	if (!error)
 		error = save_image(&snapshot, pages - 1, flags);
 out_finish:
@@ -468,7 +466,7 @@ static int get_swap_reader(unsigned int *flags_p)
 	if (!handle.cur)
 		return -ENOMEM;
 
-	error = hib_bio_read_page(swsusp_header->image, handle.cur, NULL);
+	error = hib_bio_read_page(swsusp_header->image, handle.cur, 1);
 	if (error) {
 		release_swap_reader();
 		return error;
@@ -477,7 +475,7 @@ static int get_swap_reader(unsigned int *flags_p)
 	return 0;
 }
 
-int swap_read_page(void *buf, struct bio **bio_chain)
+int swap_read_page(void *buf, int sync)
 {
 	sector_t offset;
 	int error;
@@ -487,17 +485,17 @@ int swap_read_page(void *buf, struct bio **bio_chain)
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
@@ -522,7 +520,6 @@ static int load_image(struct snapshot_handle *snapshot,
 	int error = 0;
 	struct timeval start;
 	struct timeval stop;
-	struct bio *bio;
 	int err2;
 	unsigned nr_pages;
 	int mps;
@@ -533,24 +530,23 @@ static int load_image(struct snapshot_handle *snapshot,
 	if (!m)
 		m = 1;
 	nr_pages = 0;
-	bio = NULL;
 	do_gettimeofday(&start);
 	for ( ; ; ) {
 		error = snapshot_write_next(snapshot);
 		if (error <= 0)
 			break;
-		error = compress_read(data_of(*snapshot), &bio, flags);
+		error = compress_read(data_of(*snapshot), flags);
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
@@ -594,7 +590,7 @@ int swsusp_read(unsigned int *flags_p)
 	if (error)
 		goto end;
 	if (!error)
-		error = swap_read_page(header, NULL);
+		error = swap_read_page(header, 1);
 	if (!error)
 		error = load_image(&snapshot, header->pages - 1, *flags_p);
 	swap_reader_finish();
@@ -620,7 +616,7 @@ int swsusp_check(void)
 		set_blocksize(hib_resume_bdev, PAGE_SIZE);
 		memset(swsusp_header, 0, PAGE_SIZE);
 		error = hib_bio_read_page(swsusp_resume_block,
-					swsusp_header, NULL);
+					swsusp_header, 1);
 		if (error)
 			goto put;
 
@@ -629,7 +625,7 @@ int swsusp_check(void)
 			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
 			/* Reset swap signature now */
 			error = hib_bio_write_page(swsusp_resume_block,
-						swsusp_header, NULL);
+						swsusp_header, 1);
 		} else {
 			error = -EINVAL;
 		}
diff --git a/kernel/power/swap.h b/kernel/power/swap.h
index 7d109ad..8e2eed4 100644
--- a/kernel/power/swap.h
+++ b/kernel/power/swap.h
@@ -10,5 +10,5 @@
  *
  */
 
-int swap_write_page(void *buf, struct bio **bio_chain);
-int swap_read_page(void *buf, struct bio **bio_chain);
+int swap_write_page(void *buf, int sync);
+int swap_read_page(void *buf, int sync);
-- 
1.7.0.4

