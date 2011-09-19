Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1ISETp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 00:19:45 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:35176 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1ISETn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 00:19:43 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Sep 2011 00:19:43 EDT
Subject: [PATCH]: Improve performance of LZO hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: linux-kernel@vger.kernel.org
Date: Mon, 19 Sep 2011 14:14:04 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1316405644.2026.17.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a patch (well, first draft anyway) that enables threading of
compression/decompression and better buffering on thaw. The hibernation
speed didn't change much in my tests (most likely because my CPU is
already fast enough to saturate I/O), but thaw speed was almost cut in
half with this approach. See what you think of it and let me know (I'm
not subscribed, so please CC me).

I did test this on my ThinkPad T510, but because I'm affected by bug
#37142, occasionally I still have trouble on thaw, which makes it hard
to distinguish what caused which problem. So, if this patch eats your
disk, I don't want to hear it. ;-)

---------------------------------------
Use threads for LZO compression/decompression on hibernate/thaw.
Improve read buffering on thaw.

Signed-off-by: Bojan Smojver <bojan@rexursive.com>
---
 kernel/power/swap.c |  514 +++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 391 insertions(+), 123 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 7c97c3a..d450488 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -27,6 +27,9 @@
 #include <linux/slab.h>
 #include <linux/lzo.h>
 #include <linux/vmalloc.h>
+#include <linux/cpu.h>
+#include <linux/atomic.h>
+#include <linux/kthread.h>
 
 #include "power.h"
 
@@ -372,6 +375,9 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 			             LZO_HEADER, PAGE_SIZE)
 #define LZO_CMP_SIZE	(LZO_CMP_PAGES * PAGE_SIZE)
 
+/* Maximum number of threads for compression/decompression. */
+#define LZO_THREADS	2
+
 /**
  *	save_image - save the suspend image data
  */
@@ -419,6 +425,46 @@ static int save_image(struct swap_map_handle *handle,
 	return ret;
 }
 
+/**
+ * Structure used for LZO data compression.
+ */
+struct cmp_data {
+	struct task_struct *thr;                  /* thread */
+	atomic_t ready;                           /* ready to start flag */
+	atomic_t stop;                            /* ready to stop flag */
+	wait_queue_head_t go;                     /* start compression */
+	wait_queue_head_t done;                   /* compression done */
+	int ret;                                  /* return code */
+	size_t unc_len;                           /* uncompressed length */
+	size_t cmp_len;                           /* compressed length */
+	unsigned char unc[LZO_UNC_SIZE];          /* uncompressed buffer */
+	unsigned char cmp[LZO_CMP_SIZE];          /* compressed buffer */
+	unsigned char wrk[LZO1X_1_MEM_COMPRESS];  /* compression workspace */
+};
+
+/**
+ * Compression function that runs in its own thread.
+ */
+static int lzo_compress_threadfn(void *data)
+{
+	struct cmp_data *d = data;
+
+	while(1) {
+		wait_event(d->go, atomic_read(&d->ready) ||
+		                  kthread_should_stop());
+		if (kthread_should_stop())
+			break;
+
+		atomic_set(&d->ready, 0);
+		d->ret = lzo1x_1_compress(d->unc, d->unc_len,
+			                  d->cmp + LZO_HEADER, &d->cmp_len,
+		                          d->wrk);
+		atomic_set(&d->stop, 1);
+		wake_up(&d->done);
+	}
+
+	return 0;
+}
 
 /**
  * save_image_lzo - Save the suspend image data compressed with LZO.
@@ -434,11 +480,26 @@ static int save_image_lzo(struct swap_map_handle *handle,
 	int ret = 0;
 	int nr_pages;
 	int err2;
+	int cpu;
 	struct bio *bio;
 	struct timeval start;
 	struct timeval stop;
-	size_t off, unc_len, cmp_len;
-	unsigned char *unc, *cmp, *wrk, *page;
+	size_t off, thr, cthr, nthr;
+	unsigned char *page;
+	struct cmp_data *data;
+
+	/* 
+	 * Get more grunt. We don't care if this fails - we'll do it with just
+	 * one core in that case.
+	 */
+	enable_nonboot_cpus();
+
+	/*
+	 * We'll limit the number of threads for compression to limit memory
+	 * footprint.
+	 */
+	nthr = num_online_cpus() - 1;
+	nthr = nthr > LZO_THREADS ? LZO_THREADS : (nthr < 1 ? 1 : nthr);
 
 	page = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
 	if (!page) {
@@ -446,29 +507,58 @@ static int save_image_lzo(struct swap_map_handle *handle,
 		return -ENOMEM;
 	}
 
-	wrk = vmalloc(LZO1X_1_MEM_COMPRESS);
-	if (!wrk) {
-		printk(KERN_ERR "PM: Failed to allocate LZO workspace\n");
+	data = vmalloc(sizeof(*data) * nthr);
+	if (!data) {
+		printk(KERN_ERR "PM: Failed to allocate LZO data\n");
 		free_page((unsigned long)page);
+		disable_nonboot_cpus();
 		return -ENOMEM;
 	}
 
-	unc = vmalloc(LZO_UNC_SIZE);
-	if (!unc) {
-		printk(KERN_ERR "PM: Failed to allocate LZO uncompressed\n");
-		vfree(wrk);
-		free_page((unsigned long)page);
-		return -ENOMEM;
+	/*
+	 * Start the compression threads.
+	 */
+	for (thr = 0; thr < nthr; thr++) {
+		atomic_set(&data[thr].ready, 0);
+		atomic_set(&data[thr].stop, 0);
+
+		init_waitqueue_head(&data[thr].go);
+		init_waitqueue_head(&data[thr].done);
+
+		data[thr].thr = kthread_create(lzo_compress_threadfn,
+		                               &data[thr],
+		                               "image_compress/%zu", thr);
+		/*
+		 * On error, stop started threads, clean up, then exit.
+		 */
+		if (IS_ERR(data[thr].thr)) {
+			printk(KERN_ERR
+			       "PM: Cannot start compression threads\n");
+			while(thr) {
+				--thr;
+				kthread_stop(data[thr].thr);
+				wake_up(&data[thr].go);
+			}
+			vfree(data);
+			free_page((unsigned long)page);
+			disable_nonboot_cpus();
+			return -ENOMEM;
+		}
 	}
 
-	cmp = vmalloc(LZO_CMP_SIZE);
-	if (!cmp) {
-		printk(KERN_ERR "PM: Failed to allocate LZO compressed\n");
-		vfree(unc);
-		vfree(wrk);
-		free_page((unsigned long)page);
-		return -ENOMEM;
+	/*
+	 * Bind the threads to CPUs and wake them up.
+	 */
+	thr = 0;
+	for_each_online_cpu(cpu) {
+		if (cpu == smp_processor_id())
+			continue;
+		kthread_bind(data[thr++].thr, cpu);
+		if (thr >= nthr)
+			break;
 	}
+	for (thr = 0; thr < nthr; thr++)
+		wake_up_process(data[thr].thr);
 
 	printk(KERN_INFO
 		"PM: Compressing and saving image data (%u pages) ...     ",
@@ -480,54 +570,75 @@ static int save_image_lzo(struct swap_map_handle *handle,
 	bio = NULL;
 	do_gettimeofday(&start);
 	for (;;) {
-		for (off = 0; off < LZO_UNC_SIZE; off += PAGE_SIZE) {
-			ret = snapshot_read_next(snapshot);
-			if (ret < 0)
-				goto out_finish;
-
-			if (!ret)
+		for (thr = 0; thr < nthr; thr++) {
+			for (off = 0; off < LZO_UNC_SIZE; off += PAGE_SIZE) {
+				ret = snapshot_read_next(snapshot);
+				if (ret < 0)
+					goto out_finish;
+
+				if (!ret)
+					break;
+
+				memcpy(data[thr].unc + off,
+				       data_of(*snapshot), PAGE_SIZE);
+
+				if (!(nr_pages % m))
+					printk(KERN_CONT "\b\b\b\b%3d%%",
+				               nr_pages / m);
+				nr_pages++;
+			}
+			if (!off)
 				break;
 
-			memcpy(unc + off, data_of(*snapshot), PAGE_SIZE);
+			data[thr].unc_len = off;
 
-			if (!(nr_pages % m))
-				printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
-			nr_pages++;
+			atomic_set(&data[thr].ready, 1);
+			wake_up(&data[thr].go);
 		}
 
-		if (!off)
+		if (!thr)
 			break;
 
-		unc_len = off;
-		ret = lzo1x_1_compress(unc, unc_len,
-		                       cmp + LZO_HEADER, &cmp_len, wrk);
-		if (ret < 0) {
-			printk(KERN_ERR "PM: LZO compression failed\n");
-			break;
-		}
+		for (cthr = thr, thr = 0; thr < cthr; thr++) {
+			wait_event(data[thr].done,
+			           atomic_read(&data[thr].stop));
+			atomic_set(&data[thr].stop, 0);
 
-		if (unlikely(!cmp_len ||
-		             cmp_len > lzo1x_worst_compress(unc_len))) {
-			printk(KERN_ERR "PM: Invalid LZO compressed length\n");
-			ret = -1;
-			break;
-		}
-
-		*(size_t *)cmp = cmp_len;
+			ret = data[thr].ret;
 
-		/*
-		 * Given we are writing one page at a time to disk, we copy
-		 * that much from the buffer, although the last bit will likely
-		 * be smaller than full page. This is OK - we saved the length
-		 * of the compressed data, so any garbage at the end will be
-		 * discarded when we read it.
-		 */
-		for (off = 0; off < LZO_HEADER + cmp_len; off += PAGE_SIZE) {
-			memcpy(page, cmp + off, PAGE_SIZE);
+			if (ret < 0) {
+				printk(KERN_ERR "PM: LZO compression failed\n");
+				goto out_finish;
+			}
 
-			ret = swap_write_page(handle, page, &bio);
-			if (ret)
+			if (unlikely(!data[thr].cmp_len ||
+			             data[thr].cmp_len >
+			             lzo1x_worst_compress(data[thr].unc_len))) {
+				printk(KERN_ERR
+				       "PM: Invalid LZO compressed length\n");
+				ret = -1;
 				goto out_finish;
+			}
+
+			*(size_t *)data[thr].cmp = data[thr].cmp_len;
+
+			/*
+			 * Given we are writing one page at a time to disk, we
+			 * copy that much from the buffer, although the last
+			 * bit will likely be smaller than full page. This is
+			 * OK - we saved the length of the compressed data, so
+			 * any garbage at the end will be discarded when we
+			 * read it.
+			 */
+			for (off = 0;
+			     off < LZO_HEADER + data[thr].cmp_len;
+			     off += PAGE_SIZE) {
+				memcpy(page, data[thr].cmp + off, PAGE_SIZE);
+
+				ret = swap_write_page(handle, page, &bio);
+				if (ret)
+					goto out_finish;
+			}
 		}
 	}
 
@@ -542,10 +653,13 @@ out_finish:
 		printk(KERN_CONT "\n");
 	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
 
-	vfree(cmp);
-	vfree(unc);
-	vfree(wrk);
+	for (thr = 0; thr < nthr; thr++) {
+		kthread_stop(data[thr].thr);
+		wake_up(&data[thr].go);
+	}
+	vfree(data);
 	free_page((unsigned long)page);
+	disable_nonboot_cpus();
 
 	return ret;
 }
@@ -743,6 +857,46 @@ static int load_image(struct swap_map_handle *handle,
 }
 
 /**
+ * Structure used for LZO data decompression.
+ */
+struct dec_data {
+	struct task_struct *thr;                  /* thread */
+	atomic_t ready;                           /* ready to start flag */
+	atomic_t stop;                            /* ready to stop flag */
+	wait_queue_head_t go;                     /* start compression */
+	wait_queue_head_t done;                   /* compression done */
+	int ret;                                  /* return code */
+	size_t unc_len;                           /* uncompressed length */
+	size_t cmp_len;                           /* compressed length */
+	unsigned char unc[LZO_UNC_SIZE];          /* uncompressed buffer */
+	unsigned char cmp[LZO_CMP_SIZE];          /* compressed buffer */
+};
+
+/**
+ * Deompression function that runs in its own thread.
+ */
+static int lzo_decompress_threadfn(void *data)
+{
+	struct dec_data *d = data;
+
+	while (1) {
+		wait_event(d->go, atomic_read(&d->ready) ||
+		                  kthread_should_stop());
+		if (kthread_should_stop())
+			break;
+
+		atomic_set(&d->ready, 0);
+		d->unc_len = LZO_UNC_SIZE;
+		d->ret = lzo1x_decompress_safe(d->cmp + LZO_HEADER, d->cmp_len,
+		                               d->unc, &d->unc_len);
+		atomic_set(&d->stop, 1);
+		wake_up(&d->done);
+	}
+
+	return 0;
+}
+
+/**
  * load_image_lzo - Load compressed image data and decompress them with LZO.
  * @handle: Swap map handle to use for loading data.
  * @snapshot: Image to copy uncompressed data into.
@@ -754,45 +908,99 @@ static int load_image_lzo(struct swap_map_handle *handle,
 {
 	unsigned int m;
 	int error = 0;
+	int cpu;
 	struct bio *bio;
 	struct timeval start;
 	struct timeval stop;
 	unsigned nr_pages;
-	size_t i, off, unc_len, cmp_len;
-	unsigned char *unc, *cmp, *page[LZO_CMP_PAGES];
+	size_t i, off, thr, cthr, nthr;
+	size_t ring = 0, pg = 0, npages,
+	       have = 0, want = MAP_PAGE_ENTRIES, need, asked = 0;
+	unsigned char **page;
+	struct dec_data *data;
+
+	/*
+	 * We'll limit the number of threads for decompression to limit memory
+	 * footprint.
+	 */
+	nthr = num_online_cpus() - 1;
+	nthr = nthr > LZO_THREADS ? LZO_THREADS : (nthr < 1 ? 1 : nthr);
+
+	page = vmalloc(sizeof(*page) * MAP_PAGE_ENTRIES);
+	if (!page) {
+		printk(KERN_ERR "PM: Failed to allocate LZO page\n");
+		return -ENOMEM;
+	}
 
-	for (i = 0; i < LZO_CMP_PAGES; i++) {
+	for (i = 0; i < MAP_PAGE_ENTRIES; i++) {
 		page[i] = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
 		if (!page[i]) {
-			printk(KERN_ERR "PM: Failed to allocate LZO page\n");
-
-			while (i)
-				free_page((unsigned long)page[--i]);
-
-			return -ENOMEM;
+			if (i < LZO_CMP_PAGES) {
+				printk(KERN_ERR
+				       "PM: Failed to allocate LZO pages\n");
+				while (i)
+					free_page((unsigned long)page[--i]);
+				vfree(page);
+				return -ENOMEM;
+			}
 		}
 	}
+	npages = i;
 
-	unc = vmalloc(LZO_UNC_SIZE);
-	if (!unc) {
-		printk(KERN_ERR "PM: Failed to allocate LZO uncompressed\n");
-
-		for (i = 0; i < LZO_CMP_PAGES; i++)
+	data = vmalloc(sizeof(*data) * nthr);
+	if (!data) {
+		printk(KERN_ERR "PM: Failed to allocate LZO data\n");
+		for (i = 0; i < npages; i++)
 			free_page((unsigned long)page[i]);
-
+		vfree(page);
 		return -ENOMEM;
 	}
 
-	cmp = vmalloc(LZO_CMP_SIZE);
-	if (!cmp) {
-		printk(KERN_ERR "PM: Failed to allocate LZO compressed\n");
+	/*
+	 * Start the decompression threads.
+	 */
+	for (thr = 0; thr < nthr; thr++) {
+		atomic_set(&data[thr].ready, 0);
+		atomic_set(&data[thr].stop, 0);
 
-		vfree(unc);
-		for (i = 0; i < LZO_CMP_PAGES; i++)
-			free_page((unsigned long)page[i]);
+		init_waitqueue_head(&data[thr].go);
+		init_waitqueue_head(&data[thr].done);
 
-		return -ENOMEM;
+		data[thr].thr = kthread_create(lzo_decompress_threadfn,
+		                               &data[thr],
+		                               "image_decompress/%zu", thr);
+		/*
+		 * On error, stop started threads, clean up, then exit.
+		 */
+		if (IS_ERR(data[thr].thr)) {
+			printk(KERN_ERR
+			       "PM: Cannot start decompression threads\n");
+			while (thr) {
+				--thr;
+				kthread_stop(data[thr].thr);
+				wake_up(&data[thr].go);
+			}
+			vfree(data);
+			for (i = 0; i < npages; i++)
+				free_page((unsigned long)page[i]);
+			vfree(page);
+			return -ENOMEM;
+		}
+	}
+
+	/*
+	 * Bind the threads to CPUs and wake them up.
+	 */
+	thr = 0;
+	for_each_online_cpu(cpu) {
+		if (cpu == smp_processor_id())
+			continue;
+		kthread_bind(data[thr++].thr, cpu);
+		if (thr >= nthr)
+			break;
 	}
+	for (thr = 0; thr < nthr; thr++)
+		wake_up_process(data[thr].thr);
 
 	printk(KERN_INFO
 		"PM: Loading and decompressing image data (%u pages) ...     ",
@@ -808,61 +1016,117 @@ static int load_image_lzo(struct swap_map_handle *handle,
 	if (error <= 0)
 		goto out_finish;
 
-	for (;;) {
-		error = swap_read_page(handle, page[0], NULL); /* sync */
-		if (error)
-			break;
-
-		cmp_len = *(size_t *)page[0];
-		if (unlikely(!cmp_len ||
-		             cmp_len > lzo1x_worst_compress(LZO_UNC_SIZE))) {
-			printk(KERN_ERR "PM: Invalid LZO compressed length\n");
-			error = -1;
-			break;
+	for(;;) {
+		for (i = 0; have < LZO_CMP_PAGES && i < want; i++) {
+			error = swap_read_page(handle, page[ring], &bio);
+			if (error) {
+				/*
+				 * On real read error, finish. On end of data,
+				 * just exit the read loop.
+				 */
+				if (handle->cur &&
+				    handle->cur->entries[handle->k])
+					goto out_finish;
+				else
+					break;
+			}
+			if (++ring >= npages)
+				ring = 0;
 		}
+		asked += i;
+		want -= i;
 
-		for (off = PAGE_SIZE, i = 1;
-		     off < LZO_HEADER + cmp_len; off += PAGE_SIZE, i++) {
-			error = swap_read_page(handle, page[i], &bio);
+		/*
+		 * We are out of data, wait for some more.
+		 */
+		if (!have) {
+			if (!asked)
+				break;
+
+			error = hib_wait_on_bio_chain(&bio);
 			if (error)
 				goto out_finish;
+			have += asked;
+			asked = 0;
 		}
 
-		error = hib_wait_on_bio_chain(&bio); /* need all data now */
-		if (error)
-			goto out_finish;
+		for (thr = 0; have && thr < nthr; thr++) {
+			data[thr].cmp_len = *(size_t *)page[pg];
+			if (unlikely(!data[thr].cmp_len ||
+			             data[thr].cmp_len >
+			             lzo1x_worst_compress(LZO_UNC_SIZE))) {
+				printk(KERN_ERR
+				       "PM: Invalid LZO compressed length\n");
+				error = -1;
+				goto out_finish;
+			}
 
-		for (off = 0, i = 0;
-		     off < LZO_HEADER + cmp_len; off += PAGE_SIZE, i++) {
-			memcpy(cmp + off, page[i], PAGE_SIZE);
-		}
+			need = DIV_ROUND_UP(data[thr].cmp_len + LZO_HEADER,
+			                    PAGE_SIZE);
+			if (need > have)
+				break;
 
-		unc_len = LZO_UNC_SIZE;
-		error = lzo1x_decompress_safe(cmp + LZO_HEADER, cmp_len,
-		                              unc, &unc_len);
-		if (error < 0) {
-			printk(KERN_ERR "PM: LZO decompression failed\n");
-			break;
+			for (off = 0;
+			     off < LZO_HEADER + data[thr].cmp_len;
+			     off += PAGE_SIZE) {
+				memcpy(data[thr].cmp + off,
+				       page[pg], PAGE_SIZE);
+				have--;
+				want++;
+				if (++pg >= npages)
+					pg = 0;
+			}
+
+			atomic_set(&data[thr].ready, 1);
+			wake_up(&data[thr].go);
 		}
 
-		if (unlikely(!unc_len ||
-		             unc_len > LZO_UNC_SIZE ||
-		             unc_len & (PAGE_SIZE - 1))) {
-			printk(KERN_ERR "PM: Invalid LZO uncompressed length\n");
-			error = -1;
-			break;
+		/*
+		 * Wait for more data while we are decompressing.
+		 */
+		if (have < LZO_CMP_PAGES && asked) {
+			error = hib_wait_on_bio_chain(&bio);
+			if (error)
+				goto out_finish;
+			have += asked;
+			asked = 0;
 		}
 
-		for (off = 0; off < unc_len; off += PAGE_SIZE) {
-			memcpy(data_of(*snapshot), unc + off, PAGE_SIZE);
+		for (cthr = thr, thr = 0; thr < cthr; thr++) {
+			wait_event(data[thr].done,
+			           atomic_read(&data[thr].stop));
+			atomic_set(&data[thr].stop, 0);
+
+			error = data[thr].ret;
 
-			if (!(nr_pages % m))
-				printk("\b\b\b\b%3d%%", nr_pages / m);
-			nr_pages++;
+			if (error < 0) {
+				printk(KERN_ERR
+				       "PM: LZO decompression failed\n");
+				goto out_finish;
+			}
 
-			error = snapshot_write_next(snapshot);
-			if (error <= 0)
+			if (unlikely(!data[thr].unc_len ||
+			             data[thr].unc_len > LZO_UNC_SIZE ||
+			             data[thr].unc_len & (PAGE_SIZE - 1))) {
+				printk(KERN_ERR
+				       "PM: Invalid LZO uncompressed length\n");
+				error = -1;
 				goto out_finish;
+			}
+
+			for (off = 0;
+			     off < data[thr].unc_len; off += PAGE_SIZE) {
+				memcpy(data_of(*snapshot),
+				       data[thr].unc + off, PAGE_SIZE);
+
+				if (!(nr_pages % m))
+					printk("\b\b\b\b%3d%%", nr_pages / m);
+				nr_pages++;
+
+				error = snapshot_write_next(snapshot);
+				if (error <= 0)
+					goto out_finish;
+			}
 		}
 	}
 
@@ -877,10 +1141,14 @@ out_finish:
 		printk("\n");
 	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
 
-	vfree(cmp);
-	vfree(unc);
-	for (i = 0; i < LZO_CMP_PAGES; i++)
+	for (thr = 0; thr < nthr; thr++) {
+		kthread_stop(data[thr].thr);
+		wake_up(&data[thr].go);
+	}
+	vfree(data);
+	for (i = 0; i < npages; i++)
 		free_page((unsigned long)page[i]);
+	vfree(page);
 
 	return error;
 }
---------------------------------------

-- 
Bojan

