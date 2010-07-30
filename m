Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab0G3Kob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 06:44:31 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:46493 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0G3Koa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 06:44:30 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1280465201.2600.10.camel@shrek.rexursive.com>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
Content-Type: multipart/mixed; boundary="=-2V40hWAOlTJ/6g5YXQBC"
Date: Fri, 30 Jul 2010 20:44:27 +1000
Message-ID: <1280486667.2608.1.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2V40hWAOlTJ/6g5YXQBC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2010-07-30 at 14:46 +1000, Bojan Smojver wrote:
> This patch speeds up hibernate/thaw operations

This is probably a bit simpler.

-- 
Bojan

--=-2V40hWAOlTJ/6g5YXQBC
Content-Disposition: attachment; filename="hibernate-lzo.patch"
Content-Type: text/x-patch; name="hibernate-lzo.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

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
index b0bb217..80aa5a0 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -24,6 +24,7 @@
 #include <linux/swapops.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
+#include <linux/lzo.h>
 
 #include "power.h"
 
@@ -357,6 +358,17 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 	return error;
 }
 
+#define LZO_HEADER	sizeof(size_t)
+#define LZO_ORDER	6
+#define LZO_PAGES	(1 << LZO_ORDER)
+#define LZO_SIZE	(LZO_PAGES * PAGE_SIZE)
+#define LZO_ADD_PAGES	(DIV_ROUND_UP(lzo1x_worst_compress(LZO_SIZE) + \
+			              LZO_HEADER, PAGE_SIZE) - LZO_PAGES)
+#define LZO_CMP_PAGES	LZO_PAGES
+#define LZO_CMP_SIZE	(LZO_CMP_PAGES * PAGE_SIZE)
+#define LZO_UNC_PAGES	(LZO_PAGES - LZO_ADD_PAGES)
+#define LZO_UNC_SIZE	(LZO_UNC_PAGES * PAGE_SIZE)
+
 /**
  *	save_image - save the suspend image data
  */
@@ -372,6 +384,30 @@ static int save_image(struct swap_map_handle *handle,
 	struct bio *bio;
 	struct timeval start;
 	struct timeval stop;
+	size_t ul, cl;
+	unsigned char *unc, *cmp;
+	void *wrk;
+
+	wrk = vmalloc(LZO1X_1_MEM_COMPRESS);
+	if (!wrk) {
+		printk(KERN_ERR "PM: Failed to allocate LZO workspace\n");
+		return -ENOMEM;
+	}
+
+	unc = vmalloc(LZO_UNC_SIZE);
+	if (!unc) {
+		printk(KERN_ERR "PM: Failed to allocate LZO uncompressed\n");
+		vfree(wrk);
+		return -ENOMEM;
+	}
+
+	cmp = (void *)__get_free_pages(__GFP_WAIT | __GFP_HIGH, LZO_ORDER);
+	if (!cmp) {
+		printk(KERN_ERR "PM: Failed to allocate LZO compressed\n");
+		vfree(unc);
+		vfree(wrk);
+		return -ENOMEM;
+	}
 
 	printk(KERN_INFO "PM: Saving image data pages (%u pages) ...     ",
 		nr_to_write);
@@ -382,16 +418,46 @@ static int save_image(struct swap_map_handle *handle,
 	bio = NULL;
 	do_gettimeofday(&start);
 	while (1) {
-		ret = snapshot_read_next(snapshot);
-		if (ret <= 0)
+		for (ul = 0; ul < LZO_UNC_SIZE; ul += PAGE_SIZE) {
+			ret = snapshot_read_next(snapshot);
+			if (ret < 0)
+				goto out_finish;
+
+			if (ret == 0)
+				break;
+
+			memcpy(unc + ul, data_of(*snapshot), PAGE_SIZE);
+
+			if (!(nr_pages % m))
+				printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
+			nr_pages++;
+		}
+
+		if (ul == 0)
 			break;
-		ret = swap_write_page(handle, data_of(*snapshot), &bio);
-		if (ret)
+
+		ret = lzo1x_1_compress(unc, ul, cmp + LZO_HEADER, &cl, wrk);
+		if (ret < 0) {
+			printk(KERN_ERR "PM: LZO compression failed\n");
 			break;
-		if (!(nr_pages % m))
-			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
-		nr_pages++;
+		}
+
+		if (unlikely(cl == 0 || LZO_HEADER + cl > LZO_CMP_SIZE)) {
+			printk(KERN_ERR "PM: Invalid LZO length\n");
+			ret = -1;
+			break;
+		}
+
+		*(size_t *)cmp = cl;
+
+		for (ul = 0; ul < LZO_HEADER + cl; ul += PAGE_SIZE) {
+			ret = swap_write_page(handle, cmp + ul, &bio);
+			if (ret)
+				goto out_finish;
+		}
 	}
+
+out_finish:
 	err2 = hib_wait_on_bio_chain(&bio);
 	do_gettimeofday(&stop);
 	if (!ret)
@@ -401,6 +467,11 @@ static int save_image(struct swap_map_handle *handle,
 	else
 		printk(KERN_CONT "\n");
 	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
+
+	free_pages((unsigned long)cmp, LZO_ORDER);
+	vfree(unc);
+	vfree(wrk);
+
 	return ret;
 }
 
@@ -416,7 +487,8 @@ static int enough_swap(unsigned int nr_pages)
 	unsigned int free_swap = count_swap_pages(root_swap, 1);
 
 	pr_debug("PM: Free swap pages: %u\n", free_swap);
-	return free_swap > nr_pages + PAGES_FOR_IO;
+	return free_swap >
+	       (nr_pages * LZO_CMP_PAGES) / LZO_UNC_PAGES + PAGES_FOR_IO;
 }
 
 /**
@@ -547,9 +619,22 @@ static int load_image(struct swap_map_handle *handle,
 	int error = 0;
 	struct timeval start;
 	struct timeval stop;
-	struct bio *bio;
-	int err2;
 	unsigned nr_pages;
+	size_t ul, cl;
+	unsigned char *unc, *cmp;
+
+	unc = vmalloc(LZO_UNC_SIZE);
+	if (!unc) {
+		printk(KERN_ERR "PM: Failed to allocate LZO uncompressed\n");
+		return -ENOMEM;
+	}
+
+	cmp = (void *)__get_free_pages(__GFP_WAIT | __GFP_HIGH, LZO_ORDER);
+	if (!cmp) {
+		printk(KERN_ERR "PM: Failed to allocate LZO compressed\n");
+		vfree(unc);
+		return -ENOMEM;
+	}
 
 	printk(KERN_INFO "PM: Loading image data pages (%u pages) ...     ",
 		nr_to_read);
@@ -557,27 +642,58 @@ static int load_image(struct swap_map_handle *handle,
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
+		error = swap_read_page(handle, cmp, NULL);
 		if (error)
 			break;
-		if (snapshot->sync_read)
-			error = hib_wait_on_bio_chain(&bio);
-		if (error)
+
+		cl = *(size_t *)cmp;
+		if (unlikely(cl == 0 || LZO_HEADER + cl > LZO_CMP_SIZE)) {
+			printk(KERN_ERR "PM: Invalid LZO length\n");
+			error = -1;
+			break;
+		}
+
+		for (ul = PAGE_SIZE; ul < LZO_HEADER + cl; ul += PAGE_SIZE) {
+			error = swap_read_page(handle, cmp + ul, NULL);
+			if (error)
+				goto out_finish;
+		}
+
+		ul = LZO_UNC_SIZE;
+		error = lzo1x_decompress_safe(cmp + LZO_HEADER, cl, unc, &ul);
+		if (error < 0) {
+			printk(KERN_ERR "PM: LZO decompression failed\n");
+			break;
+		}
+
+		if (unlikely(ul == 0 || ul > LZO_UNC_SIZE)) {
+			printk(KERN_ERR "PM: Invalid LZO length\n");
+			error = -1;
 			break;
-		if (!(nr_pages % m))
-			printk("\b\b\b\b%3d%%", nr_pages / m);
-		nr_pages++;
+		}
+
+		for (cl = 0; cl < ul; cl += PAGE_SIZE) {
+			memcpy(data_of(*snapshot), unc + cl, PAGE_SIZE);
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
@@ -586,6 +702,10 @@ static int load_image(struct swap_map_handle *handle,
 	} else
 		printk("\n");
 	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
+
+	free_pages((unsigned long)cmp, LZO_ORDER);
+	vfree(unc);
+
 	return error;
 }
 

--=-2V40hWAOlTJ/6g5YXQBC--

