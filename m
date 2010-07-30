Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab0G3FAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 01:00:48 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:42131 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0G3FAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 01:00:46 -0400
X-Greylist: delayed 843 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Jul 2010 01:00:46 EDT
Subject: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-KIqTVmqmrTRNAXPzqyNt"
Date: Fri, 30 Jul 2010 14:46:41 +1000
Message-ID: <1280465201.2600.10.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KIqTVmqmrTRNAXPzqyNt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

This patch speeds up hibernate/thaw operations (in kernel ones) by
compressing the pages using LZO. Tests on my ThinkPad T510 show that
hibernation times can be cut by the factor of about 4 for an image of
around 1 GB (from about a minute down to about 15 seconds).

I'm not really familiar with kernel internals, so many of the things in
this patch could be very, very wrong. But go easy - this is essentially
the first time I've attempted something like this.

PS. I'm not on the list, so please CC me if you'd like to contact me.

-- 
Bojan

--=-KIqTVmqmrTRNAXPzqyNt
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
index b0bb217..36dfdfb 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -24,6 +24,7 @@
 #include <linux/swapops.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
+#include <linux/lzo.h>
 
 #include "power.h"
 
@@ -357,6 +358,12 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 	return error;
 }
 
+#define LZO_HEADER	sizeof(size_t)
+#define LZO_UNC_PAGES	64
+#define LZO_UNC_SIZE	(LZO_UNC_PAGES * PAGE_SIZE)
+#define LZO_CMP_PAGES	DIV_ROUND_UP(lzo1x_worst_compress(LZO_UNC_SIZE) + \
+			             LZO_HEADER, PAGE_SIZE)
+#define LZO_CMP_SIZE	(LZO_CMP_PAGES * PAGE_SIZE)
 /**
  *	save_image - save the suspend image data
  */
@@ -372,6 +379,39 @@ static int save_image(struct swap_map_handle *handle,
 	struct bio *bio;
 	struct timeval start;
 	struct timeval stop;
+	size_t ul, cl;
+	unsigned char *unc, *cmp;
+	void *wrk, *page;
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
@@ -382,16 +422,48 @@ static int save_image(struct swap_map_handle *handle,
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
+			break;
+
+		ret = lzo1x_1_compress(unc, ul, cmp + LZO_HEADER, &cl, wrk);
+		if (ret < 0) {
+			printk(KERN_ERR "PM: LZO compression failed\n");
 			break;
-		ret = swap_write_page(handle, data_of(*snapshot), &bio);
-		if (ret)
+		}
+
+		if (unlikely(cl == 0 || LZO_HEADER + cl > LZO_CMP_SIZE)) {
+			printk(KERN_ERR "PM: Invalid LZO length\n");
+			ret = -1;
 			break;
-		if (!(nr_pages % m))
-			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
-		nr_pages++;
+		}
+
+		*(size_t *)cmp = cl;
+
+		for (ul = 0; ul < LZO_HEADER + cl; ul += PAGE_SIZE) {
+			memcpy(page, cmp + ul, PAGE_SIZE);
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
@@ -401,6 +473,12 @@ static int save_image(struct swap_map_handle *handle,
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
 
@@ -416,7 +494,8 @@ static int enough_swap(unsigned int nr_pages)
 	unsigned int free_swap = count_swap_pages(root_swap, 1);
 
 	pr_debug("PM: Free swap pages: %u\n", free_swap);
-	return free_swap > nr_pages + PAGES_FOR_IO;
+	return free_swap >
+	       (nr_pages * LZO_CMP_PAGES) / LZO_UNC_PAGES + PAGES_FOR_IO;
 }
 
 /**
@@ -550,6 +629,30 @@ static int load_image(struct swap_map_handle *handle,
 	struct bio *bio;
 	int err2;
 	unsigned nr_pages;
+	size_t ul, cl;
+	unsigned char *unc, *cmp;
+	void *page;
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
@@ -559,21 +662,52 @@ static int load_image(struct swap_map_handle *handle,
 	nr_pages = 0;
 	bio = NULL;
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
+		memcpy(cmp, page, PAGE_SIZE);
+
+		cl = *(size_t *)cmp;
+		if (unlikely(cl == 0 || LZO_HEADER + cl > LZO_CMP_SIZE)) {
+			printk(KERN_ERR "PM: Invalid LZO length\n");
+			error = -1;
 			break;
-		if (!(nr_pages % m))
-			printk("\b\b\b\b%3d%%", nr_pages / m);
-		nr_pages++;
+		}
+
+		for (ul = PAGE_SIZE; ul < LZO_HEADER + cl; ul += PAGE_SIZE) {
+			error = swap_read_page(handle, page, NULL); /* sync */
+			if (error)
+				goto out_finish;
+			memcpy(cmp + ul, page, PAGE_SIZE);
+		}
+
+		ul = LZO_UNC_SIZE;
+		error = lzo1x_decompress_safe(cmp + LZO_HEADER, cl, unc, &ul);
+		if (error < 0) {
+			printk(KERN_ERR "PM: LZO decompression failed\n");
+			break;
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
+
+out_finish:
 	err2 = hib_wait_on_bio_chain(&bio);
 	do_gettimeofday(&stop);
 	if (!error)
@@ -586,6 +720,11 @@ static int load_image(struct swap_map_handle *handle,
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
 

--=-KIqTVmqmrTRNAXPzqyNt--

