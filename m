Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab0HEDIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:08:22 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:54932 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab0HEDIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:08:19 -0400
Subject: [PATCH 1/2] PM: Compress hibernation image with LZO
From: Bojan Smojver <bojan@rexursive.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 13:08:17 +1000
Message-ID: <1280977697.2618.15.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compress hibernation image with LZO in order to save on I/O and
therefore time to hibernate/thaw.

Signed-off-by: Bojan Smojver <bojan@rexursive.com>
---

 kernel/power/Kconfig |    2 +
 kernel/power/swap.c  |  205 ++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 183 insertions(+), 24 deletions(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index ca6066a..cb57eb9 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -137,6 +137,8 @@ config SUSPEND_FREEZER
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
 	depends on PM && SWAP && ARCH_HIBERNATION_POSSIBLE
+	select LZO_COMPRESS
+	select LZO_DECOMPRESS
 	select SUSPEND_NVS if HAS_IOMEM
 	---help---
 	  Enable the suspend to disk (STD) functionality, which is usually
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index b0bb217..512eb3a 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -24,6 +24,7 @@
 #include <linux/swapops.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
+#include <linux/lzo.h>
 
 #include "power.h"
 
@@ -357,6 +358,18 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 	return error;
 }
 
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
 /**
  *	save_image - save the suspend image data
  */
@@ -372,6 +385,38 @@ static int save_image(struct swap_map_handle *handle,
 	struct bio *bio;
 	struct timeval start;
 	struct timeval stop;
+	size_t i, unc_len, cmp_len;
+	unsigned char *unc, *cmp, *wrk, *page;
+
+	page = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
+	if (!page) {
+		printk(KERN_ERR "PM: Failed to allocate LZO page\n");
+		return -ENOMEM;
+	}
+
+	wrk = vmalloc(LZO1X_1_MEM_COMPRESS);
+	if (!wrk) {
+		printk(KERN_ERR "PM: Failed to allocate LZO workspace\n");
+		free_page((unsigned long)page);
+		return -ENOMEM;
+	}
+
+	unc = vmalloc(LZO_UNC_SIZE);
+	if (!unc) {
+		printk(KERN_ERR "PM: Failed to allocate LZO uncompressed\n");
+		vfree(wrk);
+		free_page((unsigned long)page);
+		return -ENOMEM;
+	}
+
+	cmp = vmalloc(LZO_CMP_SIZE);
+	if (!cmp) {
+		printk(KERN_ERR "PM: Failed to allocate LZO compressed\n");
+		vfree(unc);
+		vfree(wrk);
+		free_page((unsigned long)page);
+		return -ENOMEM;
+	}
 
 	printk(KERN_INFO "PM: Saving image data pages (%u pages) ...     ",
 		nr_to_write);
@@ -382,16 +427,57 @@ static int save_image(struct swap_map_handle *handle,
 	bio = NULL;
 	do_gettimeofday(&start);
 	while (1) {
-		ret = snapshot_read_next(snapshot);
-		if (ret <= 0)
+		for (i = 0; i < LZO_UNC_SIZE; i += PAGE_SIZE) {
+			ret = snapshot_read_next(snapshot);
+			if (ret < 0)
+				goto out_finish;
+
+			if (!ret)
+				break;
+
+			memcpy(unc + i, data_of(*snapshot), PAGE_SIZE);
+
+			if (!(nr_pages % m))
+				printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
+			nr_pages++;
+		}
+
+		if (!i)
 			break;
-		ret = swap_write_page(handle, data_of(*snapshot), &bio);
-		if (ret)
+
+		unc_len = i;
+		ret = lzo1x_1_compress(unc, unc_len,
+		                       cmp + LZO_HEADER, &cmp_len, wrk);
+		if (ret < 0) {
+			printk(KERN_ERR "PM: LZO compression failed\n");
 			break;
-		if (!(nr_pages % m))
-			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
-		nr_pages++;
+		}
+
+		if (unlikely(!cmp_len ||
+		             cmp_len > lzo1x_worst_compress(unc_len))) {
+			printk(KERN_ERR "PM: Invalid LZO compressed length\n");
+			ret = -1;
+			break;
+		}
+
+		*(size_t *)cmp = cmp_len;
+
+		/* Given we are writing one page at a time to disk, we copy
+		 * that much from the buffer, although the last bit will likely
+		 * be smaller than full page. This is OK - we saved the length
+		 * of the compressed data, so any garbage at the end will be
+		 * discarded when we read it.
+		 */
+		for (i = 0; i < LZO_HEADER + cmp_len; i += PAGE_SIZE) {
+			memcpy(page, cmp + i, PAGE_SIZE);
+
+			ret = swap_write_page(handle, page, &bio);
+			if (ret)
+				goto out_finish;
+		}
 	}
+
+out_finish:
 	err2 = hib_wait_on_bio_chain(&bio);
 	do_gettimeofday(&stop);
 	if (!ret)
@@ -401,6 +487,12 @@ static int save_image(struct swap_map_handle *handle,
 	else
 		printk(KERN_CONT "\n");
 	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
+
+	vfree(cmp);
+	vfree(unc);
+	vfree(wrk);
+	free_page((unsigned long)page);
+
 	return ret;
 }
 
@@ -416,7 +508,8 @@ static int enough_swap(unsigned int nr_pages)
 	unsigned int free_swap = count_swap_pages(root_swap, 1);
 
 	pr_debug("PM: Free swap pages: %u\n", free_swap);
-	return free_swap > nr_pages + PAGES_FOR_IO;
+	return free_swap >
+	       (nr_pages * LZO_CMP_PAGES) / LZO_UNC_PAGES + 1 + PAGES_FOR_IO;
 }
 
 /**
@@ -547,9 +640,30 @@ static int load_image(struct swap_map_handle *handle,
 	int error = 0;
 	struct timeval start;
 	struct timeval stop;
-	struct bio *bio;
-	int err2;
 	unsigned nr_pages;
+	size_t i, unc_len, cmp_len;
+	unsigned char *unc, *cmp, *page;
+
+	page = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
+	if (!page) {
+		printk(KERN_ERR "PM: Failed to allocate LZO page\n");
+		return -ENOMEM;
+	}
+
+	unc = vmalloc(LZO_UNC_SIZE);
+	if (!unc) {
+		printk(KERN_ERR "PM: Failed to allocate LZO uncompressed\n");
+		free_page((unsigned long)page);
+		return -ENOMEM;
+	}
+
+	cmp = vmalloc(LZO_CMP_SIZE);
+	if (!cmp) {
+		printk(KERN_ERR "PM: Failed to allocate LZO compressed\n");
+		vfree(unc);
+		free_page((unsigned long)page);
+		return -ENOMEM;
+	}
 
 	printk(KERN_INFO "PM: Loading image data pages (%u pages) ...     ",
 		nr_to_read);
@@ -557,27 +671,65 @@ static int load_image(struct swap_map_handle *handle,
 	if (!m)
 		m = 1;
 	nr_pages = 0;
-	bio = NULL;
 	do_gettimeofday(&start);
+
+	error = snapshot_write_next(snapshot);
+	if (error <= 0)
+		goto out_finish;
+
 	for ( ; ; ) {
-		error = snapshot_write_next(snapshot);
-		if (error <= 0)
-			break;
-		error = swap_read_page(handle, data_of(*snapshot), &bio);
+		error = swap_read_page(handle, page, NULL); /* sync */
 		if (error)
 			break;
-		if (snapshot->sync_read)
-			error = hib_wait_on_bio_chain(&bio);
-		if (error)
+
+		cmp_len = *(size_t *)page;
+		if (unlikely(!cmp_len ||
+		             cmp_len > lzo1x_worst_compress(LZO_UNC_SIZE))) {
+			printk(KERN_ERR "PM: Invalid LZO compressed length\n");
+			error = -1;
 			break;
-		if (!(nr_pages % m))
-			printk("\b\b\b\b%3d%%", nr_pages / m);
-		nr_pages++;
+		}
+
+		memcpy(cmp, page, PAGE_SIZE);
+		for (i = PAGE_SIZE; i < LZO_HEADER + cmp_len; i += PAGE_SIZE) {
+			error = swap_read_page(handle, page, NULL); /* sync */
+			if (error)
+				goto out_finish;
+
+			memcpy(cmp + i, page, PAGE_SIZE);
+		}
+
+		unc_len = LZO_UNC_SIZE;
+		error = lzo1x_decompress_safe(cmp + LZO_HEADER, cmp_len,
+		                              unc, &unc_len);
+		if (error < 0) {
+			printk(KERN_ERR "PM: LZO decompression failed\n");
+			break;
+		}
+
+		if (unlikely(!unc_len ||
+		             unc_len > LZO_UNC_SIZE ||
+		             unc_len & (PAGE_SIZE - 1))) {
+			printk(KERN_ERR "PM: Invalid LZO uncompressed length\n");
+			error = -1;
+			break;
+		}
+
+		for (i = 0; i < unc_len; i += PAGE_SIZE) {
+			memcpy(data_of(*snapshot), unc + i, PAGE_SIZE);
+
+			if (!(nr_pages % m))
+				printk("\b\b\b\b%3d%%", nr_pages / m);
+			nr_pages++;
+
+			error = snapshot_write_next(snapshot);
+			if (error <= 0)
+				goto out_finish;
+		}
 	}
-	err2 = hib_wait_on_bio_chain(&bio);
+
+out_finish:
 	do_gettimeofday(&stop);
-	if (!error)
-		error = err2;
 	if (!error) {
 		printk("\b\b\b\bdone\n");
 		snapshot_write_finalize(snapshot);
@@ -586,6 +738,11 @@ static int load_image(struct swap_map_handle *handle,
 	} else
 		printk("\n");
 	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
+
+	vfree(cmp);
+	vfree(unc);
+	free_page((unsigned long)page);
+
 	return error;
 }
 


-- 
Bojan

