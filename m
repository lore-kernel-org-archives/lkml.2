Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab0I0FoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:44:07 -0400
Received: from crca.org.au ([74.207.252.120]:59566 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab0I0FoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:05 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 01/23] Hibernation: Split compression support out.
Date: Mon, 27 Sep 2010 15:43:36 +1000
Message-Id: <1285566238-10966-2-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate compression support out into its own file, removing in
the process the duplication of the load_image and save_image
functions and some #includes from swap.c that are no longer
needed.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/Makefile   |    2 +-
 kernel/power/compress.c |  210 +++++++++++++++++++++++++++++
 kernel/power/compress.h |   23 +++
 kernel/power/swap.c     |  339 +++++------------------------------------------
 kernel/power/swap.h     |   28 ++++
 5 files changed, 296 insertions(+), 306 deletions(-)
 create mode 100644 kernel/power/compress.c
 create mode 100644 kernel/power/compress.h
 create mode 100644 kernel/power/swap.h

diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index f9063c6..2eb134d 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
-				   block_io.o
+				   block_io.o compress.o
 obj-$(CONFIG_SUSPEND_NVS)	+= nvs.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
diff --git a/kernel/power/compress.c b/kernel/power/compress.c
new file mode 100644
index 0000000..45725ea
--- /dev/null
+++ b/kernel/power/compress.c
@@ -0,0 +1,210 @@
+/*
+ * linux/kernel/power/compress.c
+ *
+ * This file provides functions for (optionally) compressing an
+ * image as it is being written and decompressing it at resume.
+ *
+ * Copyright (C) 2003-2010 Nigel Cunningham <nigel@tuxonice.net>
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/lzo.h>
+#include <linux/vmalloc.h>
+
+#include "power.h"
+#include "swap.h"
+
+/* We need to remember how much compressed data we need to read. */
+#define LZO_HEADER	sizeof(size_t)
+
+/* Number of pages/bytes we'll compress at one time. */
+#define LZO_UNC_PAGES	32
+#define LZO_UNC_SIZE	(LZO_UNC_PAGES * PAGE_SIZE)
+
+/* Number of pages/bytes we need for compressed data (worst case). */
+#define LZO_CMP_PAGES	DIV_ROUND_UP(lzo1x_worst_compress(LZO_UNC_SIZE) + \
+			             LZO_HEADER, PAGE_SIZE)
+#define LZO_CMP_SIZE	(LZO_CMP_PAGES * PAGE_SIZE)
+
+static size_t off, unc_len, cmp_len;
+static unsigned char *unc, *cmp, *wrk, *page;
+
+void compress_image_cleanup(void)
+{
+	if (cmp) {
+		vfree(cmp);
+		cmp = NULL;
+	}
+
+	if (unc) {
+		vfree(unc);
+		unc = NULL;
+	}
+
+	if (wrk) {
+		vfree(wrk);
+		wrk = NULL;
+	}
+
+	if (page) {
+		free_page((unsigned long)page);
+		page = NULL;
+	}
+}
+
+int compress_image_init(void)
+{
+	page = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
+	if (!page) {
+		printk(KERN_ERR "PM: Failed to allocate LZO page\n");
+		return -ENOMEM;
+	}
+
+	wrk = vmalloc(LZO1X_1_MEM_COMPRESS);
+	unc = vmalloc(LZO_UNC_SIZE);
+	cmp = vmalloc(LZO_CMP_SIZE);
+
+	if (!wrk || !unc || !cmp) {
+		printk(KERN_ERR "PM: Failed to allocate memory for (de)compression.\n");
+		compress_image_cleanup();
+		return -ENOMEM;
+	}
+
+	off = 0;
+
+	return 0;
+}
+
+static int compress_and_write(struct swap_map_handle *handle, struct bio **bio)
+{
+	int ret;
+
+	if (!off)
+		return 0;
+
+	unc_len = off;
+	ret = lzo1x_1_compress(unc, unc_len, cmp + LZO_HEADER, &cmp_len, wrk);
+
+	if (ret < 0) {
+		printk(KERN_ERR "PM: LZO compression failed\n");
+		return -EIO;
+	}
+
+	if (unlikely(!cmp_len ||
+	             cmp_len > lzo1x_worst_compress(unc_len))) {
+		printk(KERN_ERR "PM: Invalid LZO compressed length\n");
+		return -EIO;
+	}
+
+	*(size_t *)cmp = cmp_len;
+
+	/*
+	 * Given we are writing one page at a time to disk, we copy
+	 * that much from the buffer, although the last bit will likely
+	 * be smaller than full page. This is OK - we saved the length
+	 * of the compressed data, so any garbage at the end will be
+	 * discarded when we read it.
+	 */
+	for (off = 0; off < LZO_HEADER + cmp_len; off += PAGE_SIZE) {
+		memcpy(page, cmp + off, PAGE_SIZE);
+
+		ret = swap_write_page(handle, page, bio);
+		if (ret)
+			return ret;
+	}
+
+	off = 0;
+	return 0;
+}
+
+int compress_write(struct swap_map_handle *handle, char *buf, struct bio **bio,
+		int flags)
+{
+	int ret = 0;
+
+	if (flags & SF_NOCOMPRESS_MODE)
+		return swap_write_page(handle, buf, bio);
+
+	if (off == LZO_UNC_SIZE)
+		ret = compress_and_write(handle, bio);
+
+	memcpy(unc + off, buf, PAGE_SIZE);
+	off += PAGE_SIZE;
+	return ret;
+}
+
+void compress_write_finish(struct swap_map_handle *handle, struct bio **bio,
+		int flags)
+{
+	if (!(flags & SF_NOCOMPRESS_MODE))
+		compress_and_write(handle, bio);
+}
+
+static int read_and_decompress(struct swap_map_handle *handle)
+{
+	int error = swap_read_page(handle, page, NULL), off;
+	cmp_len = *(size_t *)page;
+
+	if (unlikely(!cmp_len ||
+	             cmp_len > lzo1x_worst_compress(LZO_UNC_SIZE))) {
+		printk(KERN_ERR "PM: Invalid LZO compressed length\n");
+		return -1;
+	}
+
+	memcpy(cmp, page, PAGE_SIZE);
+	for (off = PAGE_SIZE; off < LZO_HEADER + cmp_len; off += PAGE_SIZE) {
+		error = swap_read_page(handle, page, NULL); /* sync */
+		if (error)
+			return error;
+
+		memcpy(cmp + off, page, PAGE_SIZE);
+	}
+
+	unc_len = LZO_UNC_SIZE;
+	error = lzo1x_decompress_safe(cmp + LZO_HEADER, cmp_len,
+	                              unc, &unc_len);
+	if (error < 0) {
+		printk(KERN_ERR "PM: LZO decompression failed\n");
+		return error;
+	}
+
+	if (unlikely(!unc_len ||
+	             unc_len > LZO_UNC_SIZE ||
+	             unc_len & (PAGE_SIZE - 1))) {
+		printk(KERN_ERR "PM: Invalid LZO uncompressed length\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+int compress_read(struct swap_map_handle *handle, char *buf, struct bio **bio,
+		int flags)
+{
+	int ret = 0;
+
+	if (flags & SF_NOCOMPRESS_MODE)
+		return swap_read_page(handle, buf, bio);
+
+	if (!off) {
+		ret = read_and_decompress(handle);
+		if (ret)
+			return ret;
+	}
+
+	memcpy(buf, unc + off, PAGE_SIZE);
+	off += PAGE_SIZE;
+	if (off == unc_len)
+		off = 0;
+
+	return 0;
+}
+
+unsigned int compress_extra_pages(unsigned int base, unsigned int flags)
+{
+	return (flags & SF_NOCOMPRESS_MODE) ? 0 :
+		(base * LZO_CMP_PAGES) / LZO_UNC_PAGES + 1 - base;
+}
diff --git a/kernel/power/compress.h b/kernel/power/compress.h
new file mode 100644
index 0000000..32abfc3
--- /dev/null
+++ b/kernel/power/compress.h
@@ -0,0 +1,23 @@
+/*
+ * linux/kernel/power/compress.h
+ *
+ * This file provides declarations for the functions used in compressing
+ * an image.
+ *
+ * Copyright (C) 2003-2010 Nigel Cunningham <nigel@tuxonice.net>
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+struct swap_map_handle;
+
+int compress_image_init(void);
+void compress_image_cleanup(void);
+int compress_write(struct swap_map_handle *handle, char *page, struct bio **bio,
+		int flags);
+void compress_write_finish(struct swap_map_handle *handle, struct bio **bio,
+		int flags);
+int compress_read(struct swap_map_handle *handle, char *page, struct bio **bio,
+		int flags);
+unsigned int compress_extra_pages(unsigned int base, unsigned int flags);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 3dc0552..3c01105 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -11,23 +11,14 @@
  *
  */
 
-#include <linux/module.h>
-#include <linux/file.h>
-#include <linux/delay.h>
-#include <linux/bitops.h>
-#include <linux/genhd.h>
-#include <linux/device.h>
 #include <linux/buffer_head.h>
-#include <linux/bio.h>
-#include <linux/blkdev.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
-#include <linux/pm.h>
 #include <linux/slab.h>
-#include <linux/lzo.h>
-#include <linux/vmalloc.h>
 
 #include "power.h"
+#include "compress.h"
+#include "swap.h"
 
 #define SWSUSP_SIG	"S1SUSPEND"
 
@@ -53,18 +44,6 @@ struct swap_map_page {
 	sector_t next_swap;
 };
 
-/**
- *	The swap_map_handle structure is used for handling swap in
- *	a file-alike way
- */
-
-struct swap_map_handle {
-	struct swap_map_page *cur;
-	sector_t cur_swap;
-	sector_t first_sector;
-	unsigned int k;
-};
-
 struct swsusp_header {
 	char reserved[PAGE_SIZE - 20 - sizeof(sector_t) - sizeof(int)];
 	sector_t image;
@@ -301,7 +280,7 @@ err_close:
 	return ret;
 }
 
-static int swap_write_page(struct swap_map_handle *handle, void *buf,
+int swap_write_page(struct swap_map_handle *handle, void *buf,
 				struct bio **bio_chain)
 {
 	int error = 0;
@@ -359,25 +338,14 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 	return error;
 }
 
-/* We need to remember how much compressed data we need to read. */
-#define LZO_HEADER	sizeof(size_t)
-
-/* Number of pages/bytes we'll compress at one time. */
-#define LZO_UNC_PAGES	32
-#define LZO_UNC_SIZE	(LZO_UNC_PAGES * PAGE_SIZE)
-
-/* Number of pages/bytes we need for compressed data (worst case). */
-#define LZO_CMP_PAGES	DIV_ROUND_UP(lzo1x_worst_compress(LZO_UNC_SIZE) + \
-			             LZO_HEADER, PAGE_SIZE)
-#define LZO_CMP_SIZE	(LZO_CMP_PAGES * PAGE_SIZE)
-
 /**
  *	save_image - save the suspend image data
  */
 
 static int save_image(struct swap_map_handle *handle,
                       struct snapshot_handle *snapshot,
-                      unsigned int nr_to_write)
+                      unsigned int nr_to_write,
+		      int flags)
 {
 	unsigned int m;
 	int ret;
@@ -399,13 +367,14 @@ static int save_image(struct swap_map_handle *handle,
 		ret = snapshot_read_next(snapshot);
 		if (ret <= 0)
 			break;
-		ret = swap_write_page(handle, data_of(*snapshot), &bio);
+		ret = compress_write(handle, data_of(*snapshot), &bio, flags);
 		if (ret)
 			break;
 		if (!(nr_pages % m))
 			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
 	}
+	compress_write_finish(handle, &bio, flags);
 	err2 = hib_wait_on_bio_chain(&bio);
 	do_gettimeofday(&stop);
 	if (!ret)
@@ -420,136 +389,6 @@ static int save_image(struct swap_map_handle *handle,
 
 
 /**
- * save_image_lzo - Save the suspend image data compressed with LZO.
- * @handle: Swap mam handle to use for saving the image.
- * @snapshot: Image to read data from.
- * @nr_to_write: Number of pages to save.
- */
-static int save_image_lzo(struct swap_map_handle *handle,
-                          struct snapshot_handle *snapshot,
-                          unsigned int nr_to_write)
-{
-	unsigned int m;
-	int ret = 0;
-	int nr_pages;
-	int err2;
-	struct bio *bio;
-	struct timeval start;
-	struct timeval stop;
-	size_t off, unc_len, cmp_len;
-	unsigned char *unc, *cmp, *wrk, *page;
-
-	page = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
-	if (!page) {
-		printk(KERN_ERR "PM: Failed to allocate LZO page\n");
-		return -ENOMEM;
-	}
-
-	wrk = vmalloc(LZO1X_1_MEM_COMPRESS);
-	if (!wrk) {
-		printk(KERN_ERR "PM: Failed to allocate LZO workspace\n");
-		free_page((unsigned long)page);
-		return -ENOMEM;
-	}
-
-	unc = vmalloc(LZO_UNC_SIZE);
-	if (!unc) {
-		printk(KERN_ERR "PM: Failed to allocate LZO uncompressed\n");
-		vfree(wrk);
-		free_page((unsigned long)page);
-		return -ENOMEM;
-	}
-
-	cmp = vmalloc(LZO_CMP_SIZE);
-	if (!cmp) {
-		printk(KERN_ERR "PM: Failed to allocate LZO compressed\n");
-		vfree(unc);
-		vfree(wrk);
-		free_page((unsigned long)page);
-		return -ENOMEM;
-	}
-
-	printk(KERN_INFO
-		"PM: Compressing and saving image data (%u pages) ...     ",
-		nr_to_write);
-	m = nr_to_write / 100;
-	if (!m)
-		m = 1;
-	nr_pages = 0;
-	bio = NULL;
-	do_gettimeofday(&start);
-	for (;;) {
-		for (off = 0; off < LZO_UNC_SIZE; off += PAGE_SIZE) {
-			ret = snapshot_read_next(snapshot);
-			if (ret < 0)
-				goto out_finish;
-
-			if (!ret)
-				break;
-
-			memcpy(unc + off, data_of(*snapshot), PAGE_SIZE);
-
-			if (!(nr_pages % m))
-				printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
-			nr_pages++;
-		}
-
-		if (!off)
-			break;
-
-		unc_len = off;
-		ret = lzo1x_1_compress(unc, unc_len,
-		                       cmp + LZO_HEADER, &cmp_len, wrk);
-		if (ret < 0) {
-			printk(KERN_ERR "PM: LZO compression failed\n");
-			break;
-		}
-
-		if (unlikely(!cmp_len ||
-		             cmp_len > lzo1x_worst_compress(unc_len))) {
-			printk(KERN_ERR "PM: Invalid LZO compressed length\n");
-			ret = -1;
-			break;
-		}
-
-		*(size_t *)cmp = cmp_len;
-
-		/*
-		 * Given we are writing one page at a time to disk, we copy
-		 * that much from the buffer, although the last bit will likely
-		 * be smaller than full page. This is OK - we saved the length
-		 * of the compressed data, so any garbage at the end will be
-		 * discarded when we read it.
-		 */
-		for (off = 0; off < LZO_HEADER + cmp_len; off += PAGE_SIZE) {
-			memcpy(page, cmp + off, PAGE_SIZE);
-
-			ret = swap_write_page(handle, page, &bio);
-			if (ret)
-				goto out_finish;
-		}
-	}
-
-out_finish:
-	err2 = hib_wait_on_bio_chain(&bio);
-	do_gettimeofday(&stop);
-	if (!ret)
-		ret = err2;
-	if (!ret)
-		printk(KERN_CONT "\b\b\b\bdone\n");
-	else
-		printk(KERN_CONT "\n");
-	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
-
-	vfree(cmp);
-	vfree(unc);
-	vfree(wrk);
-	free_page((unsigned long)page);
-
-	return ret;
-}
-
-/**
  *	enough_swap - Make sure we have enough swap to save the image.
  *
  *	Returns TRUE or FALSE after checking the total amount of swap
@@ -563,8 +402,8 @@ static int enough_swap(unsigned int nr_pages, unsigned int flags)
 
 	pr_debug("PM: Free swap pages: %u\n", free_swap);
 
-	required = PAGES_FOR_IO + ((flags & SF_NOCOMPRESS_MODE) ?
-		nr_pages : (nr_pages * LZO_CMP_PAGES) / LZO_UNC_PAGES + 1);
+	required = PAGES_FOR_IO + nr_pages +
+		compress_extra_pages(nr_pages, flags);
 	return free_swap > required;
 }
 
@@ -584,12 +423,18 @@ int swsusp_write(unsigned int flags)
 	struct snapshot_handle snapshot;
 	struct swsusp_info *header;
 	unsigned long pages;
-	int error;
+	int error = 0;
+
+	if (!(flags & SF_NOCOMPRESS_MODE))
+		error = compress_image_init();
+	if (error)
+		return error;
 
 	pages = snapshot_get_image_size();
 	error = get_swap_writer(&handle);
 	if (error) {
 		printk(KERN_ERR "PM: Cannot get swap writer\n");
+		compress_image_cleanup();
 		return error;
 	}
 	if (!enough_swap(pages, flags)) {
@@ -607,12 +452,10 @@ int swsusp_write(unsigned int flags)
 	}
 	header = (struct swsusp_info *)data_of(snapshot);
 	error = swap_write_page(&handle, header, NULL);
-	if (!error) {
-		error = (flags & SF_NOCOMPRESS_MODE) ?
-			save_image(&handle, &snapshot, pages - 1) :
-			save_image_lzo(&handle, &snapshot, pages - 1);
-	}
+	if (!error)
+		error = save_image(&handle, &snapshot, pages - 1, flags);
 out_finish:
+	compress_image_cleanup();
 	error = swap_writer_finish(&handle, flags, error);
 	return error;
 }
@@ -652,7 +495,7 @@ static int get_swap_reader(struct swap_map_handle *handle,
 	return 0;
 }
 
-static int swap_read_page(struct swap_map_handle *handle, void *buf,
+int swap_read_page(struct swap_map_handle *handle, void *buf,
 				struct bio **bio_chain)
 {
 	sector_t offset;
@@ -693,7 +536,7 @@ static int swap_reader_finish(struct swap_map_handle *handle)
 
 static int load_image(struct swap_map_handle *handle,
                       struct snapshot_handle *snapshot,
-                      unsigned int nr_to_read)
+                      unsigned int nr_to_read, int flags)
 {
 	unsigned int m;
 	int error = 0;
@@ -715,7 +558,7 @@ static int load_image(struct swap_map_handle *handle,
 		error = snapshot_write_next(snapshot);
 		if (error <= 0)
 			break;
-		error = swap_read_page(handle, data_of(*snapshot), &bio);
+		error = compress_read(handle, data_of(*snapshot), &bio, flags);
 		if (error)
 			break;
 		if (snapshot->sync_read)
@@ -742,127 +585,6 @@ static int load_image(struct swap_map_handle *handle,
 }
 
 /**
- * load_image_lzo - Load compressed image data and decompress them with LZO.
- * @handle: Swap map handle to use for loading data.
- * @snapshot: Image to copy uncompressed data into.
- * @nr_to_read: Number of pages to load.
- */
-static int load_image_lzo(struct swap_map_handle *handle,
-                          struct snapshot_handle *snapshot,
-                          unsigned int nr_to_read)
-{
-	unsigned int m;
-	int error = 0;
-	struct timeval start;
-	struct timeval stop;
-	unsigned nr_pages;
-	size_t off, unc_len, cmp_len;
-	unsigned char *unc, *cmp, *page;
-
-	page = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
-	if (!page) {
-		printk(KERN_ERR "PM: Failed to allocate LZO page\n");
-		return -ENOMEM;
-	}
-
-	unc = vmalloc(LZO_UNC_SIZE);
-	if (!unc) {
-		printk(KERN_ERR "PM: Failed to allocate LZO uncompressed\n");
-		free_page((unsigned long)page);
-		return -ENOMEM;
-	}
-
-	cmp = vmalloc(LZO_CMP_SIZE);
-	if (!cmp) {
-		printk(KERN_ERR "PM: Failed to allocate LZO compressed\n");
-		vfree(unc);
-		free_page((unsigned long)page);
-		return -ENOMEM;
-	}
-
-	printk(KERN_INFO
-		"PM: Loading and decompressing image data (%u pages) ...     ",
-		nr_to_read);
-	m = nr_to_read / 100;
-	if (!m)
-		m = 1;
-	nr_pages = 0;
-	do_gettimeofday(&start);
-
-	error = snapshot_write_next(snapshot);
-	if (error <= 0)
-		goto out_finish;
-
-	for (;;) {
-		error = swap_read_page(handle, page, NULL); /* sync */
-		if (error)
-			break;
-
-		cmp_len = *(size_t *)page;
-		if (unlikely(!cmp_len ||
-		             cmp_len > lzo1x_worst_compress(LZO_UNC_SIZE))) {
-			printk(KERN_ERR "PM: Invalid LZO compressed length\n");
-			error = -1;
-			break;
-		}
-
-		memcpy(cmp, page, PAGE_SIZE);
-		for (off = PAGE_SIZE; off < LZO_HEADER + cmp_len; off += PAGE_SIZE) {
-			error = swap_read_page(handle, page, NULL); /* sync */
-			if (error)
-				goto out_finish;
-
-			memcpy(cmp + off, page, PAGE_SIZE);
-		}
-
-		unc_len = LZO_UNC_SIZE;
-		error = lzo1x_decompress_safe(cmp + LZO_HEADER, cmp_len,
-		                              unc, &unc_len);
-		if (error < 0) {
-			printk(KERN_ERR "PM: LZO decompression failed\n");
-			break;
-		}
-
-		if (unlikely(!unc_len ||
-		             unc_len > LZO_UNC_SIZE ||
-		             unc_len & (PAGE_SIZE - 1))) {
-			printk(KERN_ERR "PM: Invalid LZO uncompressed length\n");
-			error = -1;
-			break;
-		}
-
-		for (off = 0; off < unc_len; off += PAGE_SIZE) {
-			memcpy(data_of(*snapshot), unc + off, PAGE_SIZE);
-
-			if (!(nr_pages % m))
-				printk("\b\b\b\b%3d%%", nr_pages / m);
-			nr_pages++;
-
-			error = snapshot_write_next(snapshot);
-			if (error <= 0)
-				goto out_finish;
-		}
-	}
-
-out_finish:
-	do_gettimeofday(&stop);
-	if (!error) {
-		printk("\b\b\b\bdone\n");
-		snapshot_write_finalize(snapshot);
-		if (!snapshot_image_loaded(snapshot))
-			error = -ENODATA;
-	} else
-		printk("\n");
-	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
-
-	vfree(cmp);
-	vfree(unc);
-	free_page((unsigned long)page);
-
-	return error;
-}
-
-/**
  *	swsusp_read - read the hibernation image.
  *	@flags_p: flags passed by the "frozen" kernel in the image header should
  *		  be written into this memeory location
@@ -870,15 +592,22 @@ out_finish:
 
 int swsusp_read(unsigned int *flags_p)
 {
-	int error;
+	int error = 0;
 	struct swap_map_handle handle;
 	struct snapshot_handle snapshot;
 	struct swsusp_info *header;
 
+	if (!(*flags_p & SF_NOCOMPRESS_MODE))
+		error = compress_image_init();
+	if (error)
+		return error;
+
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
 	error = snapshot_write_next(&snapshot);
-	if (error < PAGE_SIZE)
+	if (error < PAGE_SIZE) {
+		compress_image_cleanup();
 		return error < 0 ? error : -EFAULT;
+	}
 	header = (struct swsusp_info *)data_of(snapshot);
 	error = get_swap_reader(&handle, flags_p);
 	if (error)
@@ -886,12 +615,12 @@ int swsusp_read(unsigned int *flags_p)
 	if (!error)
 		error = swap_read_page(&handle, header, NULL);
 	if (!error) {
-		error = (*flags_p & SF_NOCOMPRESS_MODE) ?
-			load_image(&handle, &snapshot, header->pages - 1) :
-			load_image_lzo(&handle, &snapshot, header->pages - 1);
+		error = load_image(&handle, &snapshot, header->pages - 1,
+				*flags_p);
 	}
 	swap_reader_finish(&handle);
 end:
+	compress_image_cleanup();
 	if (!error)
 		pr_debug("PM: Image successfully loaded\n");
 	else
diff --git a/kernel/power/swap.h b/kernel/power/swap.h
new file mode 100644
index 0000000..e9ad377
--- /dev/null
+++ b/kernel/power/swap.h
@@ -0,0 +1,28 @@
+/*
+ * linux/kernel/power/swap.h
+ *
+ * This file provides declarations for functions and structures from
+ * kernel/power/swap.c.
+ *
+ * Copyright (C) 2010 Nigel Cunningham <nigel@tuxonice.net>
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+/**
+ *	The swap_map_handle structure is used for handling swap in
+ *	a file-alike way
+ */
+
+struct swap_map_handle {
+	struct swap_map_page *cur;
+	sector_t cur_swap;
+	sector_t first_sector;
+	unsigned int k;
+};
+
+int swap_write_page(struct swap_map_handle *handle, void *buf,
+				struct bio **bio_chain);
+int swap_read_page(struct swap_map_handle *handle, void *buf,
+				struct bio **bio_chain);
-- 
1.7.0.4

