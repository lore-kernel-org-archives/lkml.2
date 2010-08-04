Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0HDEEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:04:21 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:37541 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab0HDEEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:04:20 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1280890070.2741.11.camel@shrek.rexursive.com>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
	 <1280486667.2608.1.camel@shrek.rexursive.com>
	 <4C534C9D.8000600@tuxonice.net>
	 <1280532174.2583.1.camel@shrek.rexursive.com>
	 <4C5362E7.3000706@tuxonice.net>
	 <1280538184.2583.11.camel@shrek.rexursive.com>
	 <4C537A01.5040808@tuxonice.net>
	 <1280540035.2658.5.camel@shrek.rexursive.com>
	 <1280551286.3097.6.camel@shrek.rexursive.com>
	 <20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>
	 <1280710453.2727.8.camel@shrek.rexursive.com>
	 <20100802101058.d4f1c7b6.kamezawa.hiroyu@jp.fujitsu.com>
	 <1280712068.2671.0.camel@shrek.rexursive.com>
	 <20100802102750.7d414819.kamezawa.hiroyu@jp.fujitsu.com>
	 <1280713381.2673.2.camel@shrek.rexursive.com>
	 <1280800750.3305.4.camel@shrek.rexursive.com>
	 <1280802642.2627.2.camel@shrek.rexursive.com> <4C58D3B0.10602@tuxonice.net>
	 <1280890070.2741.11.camel@shrek.rexursive.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 14:04:18 +1000
Message-ID: <1280894658.2591.1.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 12:47 +1000, Bojan Smojver wrote:
> Points taken for all the other comments. Thank you.

Style wise, does this look better?

PS. Don't worry about contents yet - still working out the kinks.

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
index b0bb217..1515e2c 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -24,6 +24,7 @@
 #include <linux/swapops.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
+#include <linux/lzo.h>
 
 #include "power.h"
 
@@ -357,6 +358,30 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 	return error;
 }
 
+/* We need to remember how much compressed data we need to read. */
+#define LZO_HEADER	sizeof(size_t)
+
+/* Number of pages/bytes we'll compress at a time. */
+#define LZO_UNC_PAGES	64
+#define LZO_UNC_SIZE	(LZO_UNC_PAGES * PAGE_SIZE)
+
+/* Number of pages/bytes we need for compressed data (worst case). */
+#define LZO_CMP_PAGES	DIV_ROUND_UP(lzo1x_worst_compress(LZO_UNC_SIZE) + \
+			             LZO_HEADER, PAGE_SIZE)
+#define LZO_CMP_SIZE	(LZO_CMP_PAGES * PAGE_SIZE)
+
+/* As per examples/overlap.c in lzo distribution, we need to add more space
+ * to the end of the buffer in order to perform overlapping compression. We
+ * also add LZO_HEADER, because our compressed data starts at that offset.
+ * Then we round it off on PAGE_SIZE boundary, so that we can copy full pages
+ * safely. We call this overhead. Magic numbers and formula below.
+ */
+#define LZO_OVH_PAGES	DIV_ROUND_UP((LZO_UNC_SIZE > 0xBFFF ? \
+			              0xBFFF : LZO_UNC_SIZE) + \
+			             LZO_UNC_SIZE / 16 + 64 + 3 + \
+			             LZO_HEADER, PAGE_SIZE)
+#define LZO_OVH_SIZE	(LZO_OVH_PAGES + PAGE_SIZE)
+
 /**
  *	save_image - save the suspend image data
  */
@@ -372,6 +397,29 @@ static int save_image(struct swap_map_handle *handle,
 	struct bio *bio;
 	struct timeval start;
 	struct timeval stop;
+	size_t i, unc_len, cmp_len;
+	unsigned char *buf, *wrk, *page;
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
+	buf = vmalloc(LZO_UNC_SIZE + LZO_OVH_SIZE);
+	if (!buf) {
+		printk(KERN_ERR "PM: Failed to allocate LZO buffer\n");
+		vfree(wrk);
+		free_page((unsigned long)page);
+		return -ENOMEM;
+	}
 
 	printk(KERN_INFO "PM: Saving image data pages (%u pages) ...     ",
 		nr_to_write);
@@ -382,16 +430,59 @@ static int save_image(struct swap_map_handle *handle,
 	bio = NULL;
 	do_gettimeofday(&start);
 	while (1) {
-		ret = snapshot_read_next(snapshot);
-		if (ret <= 0)
+		for (unc_len = 0;
+		     unc_len < LZO_UNC_SIZE; unc_len += PAGE_SIZE) {
+			ret = snapshot_read_next(snapshot);
+			if (ret < 0)
+				goto out_finish;
+
+			if (!ret)
+				break;
+
+			/* Copy uncompressed data to the top of the buffer. */
+			memcpy(buf + LZO_OVH_SIZE + unc_len,
+			       data_of(*snapshot), PAGE_SIZE);
+
+			if (!(nr_pages % m))
+				printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
+			nr_pages++;
+		}
+
+		if (!unc_len)
 			break;
-		ret = swap_write_page(handle, data_of(*snapshot), &bio);
-		if (ret)
+
+		ret = lzo1x_1_compress(buf + LZO_OVH_SIZE, unc_len,
+		                       buf + LZO_HEADER, &cmp_len, wrk);
+		if (ret < 0) {
+			printk(KERN_ERR "PM: LZO compression failed\n");
+			break;
+		}
+
+		if (unlikely(!cmp_len ||
+		             cmp_len > lzo1x_worst_compress(unc_len))) {
+			printk(KERN_ERR "PM: Invalid LZO length\n");
+			ret = -1;
 			break;
-		if (!(nr_pages % m))
-			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
-		nr_pages++;
+		}
+
+		*(size_t *)buf = cmp_len;
+
+		/* Given we are writing one page at a time to disk, we copy
+		 * that much from the buffer, although the last bit will likely
+		 * be smaller than full page. This is OK - we saved the length
+		 * of the compressed data, so any garbage at the end will be
+		 * discarded when we read it.
+		 */
+		for (i = 0; i < LZO_HEADER + cmp_len; i += PAGE_SIZE) {
+			memcpy(page, buf + i, PAGE_SIZE);
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
@@ -401,6 +492,11 @@ static int save_image(struct swap_map_handle *handle,
 	else
 		printk(KERN_CONT "\n");
 	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
+
+	vfree(buf);
+	vfree(wrk);
+	free_page((unsigned long)page);
+
 	return ret;
 }
 
@@ -416,7 +512,8 @@ static int enough_swap(unsigned int nr_pages)
 	unsigned int free_swap = count_swap_pages(root_swap, 1);
 
 	pr_debug("PM: Free swap pages: %u\n", free_swap);
-	return free_swap > nr_pages + PAGES_FOR_IO;
+	return free_swap >
+	       (nr_pages * LZO_CMP_PAGES) / LZO_UNC_PAGES + 1 + PAGES_FOR_IO;
 }
 
 /**
@@ -547,9 +644,22 @@ static int load_image(struct swap_map_handle *handle,
 	int error = 0;
 	struct timeval start;
 	struct timeval stop;
-	struct bio *bio;
-	int err2;
 	unsigned nr_pages;
+	size_t i, off, unc_len, cmp_len;
+	unsigned char *buf, *page;
+
+	page = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
+	if (!page) {
+		printk(KERN_ERR "PM: Failed to allocate LZO page\n");
+		return -ENOMEM;
+	}
+
+	buf = vmalloc(LZO_CMP_SIZE);
+	if (!buf) {
+		printk(KERN_ERR "PM: Failed to allocate LZO buffer\n");
+		free_page((unsigned long)page);
+		return -ENOMEM;
+	}
 
 	printk(KERN_INFO "PM: Loading image data pages (%u pages) ...     ",
 		nr_to_read);
@@ -557,27 +667,73 @@ static int load_image(struct swap_map_handle *handle,
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
+			printk(KERN_ERR "PM: Invalid LZO length\n");
+			error = -1;
 			break;
-		if (!(nr_pages % m))
-			printk("\b\b\b\b%3d%%", nr_pages / m);
-		nr_pages++;
+		}
+
+		/* As per examples/overlap.c in lzo distribution, we copy
+		 * compressed data to the top of the in-place decompression
+		 * buffer. */
+		off = LZO_CMP_SIZE - cmp_len;
+		memcpy(buf + off, page + LZO_HEADER,
+		       (cmp_len < PAGE_SIZE - LZO_HEADER ?
+		        cmp_len : PAGE_SIZE - LZO_HEADER));
+
+		for (i = PAGE_SIZE - LZO_HEADER; i < cmp_len; i += PAGE_SIZE) {
+			error = swap_read_page(handle, page, NULL); /* sync */
+			if (error)
+				goto out_finish;
+
+			memcpy(buf + off + i, page,
+			       (cmp_len - unc_len < PAGE_SIZE ?
+			        cmp_len - unc_len : PAGE_SIZE));
+		}
+
+		unc_len = LZO_UNC_SIZE;
+		error = lzo1x_decompress_safe(buf + off, cmp_len,
+		                              buf, &unc_len);
+		if (error < 0) {
+			printk(KERN_ERR "PM: LZO decompression failed\n");
+			break;
+		}
+
+		if (unlikely(!unc_len ||
+		             unc_len > LZO_UNC_SIZE || unc_len % PAGE_SIZE)) {
+			printk(KERN_ERR "PM: Invalid LZO length\n");
+			error = -1;
+			break;
+		}
+
+		for (i = 0; i < unc_len; i += PAGE_SIZE) {
+			memcpy(data_of(*snapshot), buf + i, PAGE_SIZE);
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
@@ -586,6 +742,10 @@ static int load_image(struct swap_map_handle *handle,
 	} else
 		printk("\n");
 	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
+
+	vfree(buf);
+	free_page((unsigned long)page);
+
 	return error;
 }
 

-- 
Bojan

