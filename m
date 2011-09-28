Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1I1MWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:22:35 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:45264 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1I1MWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:22:34 -0400
Subject: [PATCH v7]: Improve performance of LZO hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 28 Sep 2011 22:22:31 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317212552.1995.10.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more version, with some issues that Pekka raised (thanks for
reviewing!) addressed. In particular:

- nthr is now called nr_threads and is set sanely
- cthr is now called run_threads
- if a compression/decompression thread is asked to exit before we are
really done, we make sure hibernation/thaw fails

---------------------------------------
Use threads for LZO compression/decompression on hibernate/thaw.
Improve buffering on hibernate/thaw.
v7

In my testing, this improved write/read speed by a factor of 2 to 3.

Signed-off-by: Bojan Smojver <bojan@rexursive.com>
---
 kernel/power/swap.c |  666 ++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 505 insertions(+), 161 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 7c97c3a..5272d66 100644
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
 
@@ -43,8 +46,7 @@
  *	allocated and populated one at a time, so we only need one memory
  *	page to set up the entire structure.
  *
- *	During resume we also only need to use one swap_map_page structure
- *	at a time.
+ *	During resume we pick up all swap_map_page structures into a list.
  */
 
 #define MAP_PAGE_ENTRIES	(PAGE_SIZE / sizeof(sector_t) - 1)
@@ -54,6 +56,11 @@ struct swap_map_page {
 	sector_t next_swap;
 };
 
+struct swap_map_page_list {
+	struct swap_map_page *map;
+	struct swap_map_page_list *next;
+};
+
 /**
  *	The swap_map_handle structure is used for handling swap in
  *	a file-alike way
@@ -61,9 +68,11 @@ struct swap_map_page {
 
 struct swap_map_handle {
 	struct swap_map_page *cur;
+	struct swap_map_page_list *maps;
 	sector_t cur_swap;
 	sector_t first_sector;
 	unsigned int k;
+	unsigned long nr_free_pages, written;
 };
 
 struct swsusp_header {
@@ -245,6 +254,7 @@ static int swsusp_swap_check(void)
 static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
 {
 	void *src;
+	int ret;
 
 	if (!offset)
 		return -ENOSPC;
@@ -254,9 +264,17 @@ static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
 		if (src) {
 			copy_page(src, buf);
 		} else {
-			WARN_ON_ONCE(1);
-			bio_chain = NULL;	/* Go synchronous */
-			src = buf;
+			ret = hib_wait_on_bio_chain(bio_chain); /* Free pages */
+			if (ret)
+				return ret;
+			src = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
+			if (src) {
+				copy_page(src, buf);
+			} else {
+				WARN_ON_ONCE(1);
+				bio_chain = NULL;	/* Go synchronous */
+				src = buf;
+			}
 		}
 	} else {
 		src = buf;
@@ -293,6 +311,8 @@ static int get_swap_writer(struct swap_map_handle *handle)
 		goto err_rel;
 	}
 	handle->k = 0;
+	handle->nr_free_pages = nr_free_pages();
+	handle->written = 0;
 	handle->first_sector = handle->cur_swap;
 	return 0;
 err_rel:
@@ -316,20 +336,23 @@ static int swap_write_page(struct swap_map_handle *handle, void *buf,
 		return error;
 	handle->cur->entries[handle->k++] = offset;
 	if (handle->k >= MAP_PAGE_ENTRIES) {
-		error = hib_wait_on_bio_chain(bio_chain);
-		if (error)
-			goto out;
 		offset = alloc_swapdev_block(root_swap);
 		if (!offset)
 			return -ENOSPC;
 		handle->cur->next_swap = offset;
-		error = write_page(handle->cur, handle->cur_swap, NULL);
+		error = write_page(handle->cur, handle->cur_swap, bio_chain);
 		if (error)
 			goto out;
 		clear_page(handle->cur);
 		handle->cur_swap = offset;
 		handle->k = 0;
 	}
+	if (++handle->written > (handle->nr_free_pages >> 1)) {
+		error = hib_wait_on_bio_chain(bio_chain);
+		if (error)
+			goto out;
+		handle->written = 0;
+	}
  out:
 	return error;
 }
@@ -372,6 +395,13 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 			             LZO_HEADER, PAGE_SIZE)
 #define LZO_CMP_SIZE	(LZO_CMP_PAGES * PAGE_SIZE)
 
+/* Maximum number of threads for compression/decompression. */
+#define LZO_THREADS	3
+
+/* Maximum number of pages for read buffering. */
+#define LZO_READ_PAGES	(MAP_PAGE_ENTRIES * 4)
+
+
 /**
  *	save_image - save the suspend image data
  */
@@ -419,6 +449,54 @@ static int save_image(struct swap_map_handle *handle,
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
+		if (kthread_should_stop()) {
+			/*
+			 * If this is not a desired exit, make sure return
+			 * code is an error.
+			 */
+			d->ret = -EFAULT;
+			atomic_set(&d->stop, 1);
+			wake_up(&d->done);
+			break;
+		}
+		atomic_set(&d->ready, 0);
+
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
@@ -434,45 +512,83 @@ static int save_image_lzo(struct swap_map_handle *handle,
 	int ret = 0;
 	int nr_pages;
 	int err2;
+	int cpu;
 	struct bio *bio;
 	struct timeval start;
 	struct timeval stop;
-	size_t off, unc_len, cmp_len;
-	unsigned char *unc, *cmp, *wrk, *page;
+	size_t off, thr, run_threads, nr_threads;
+	unsigned char *page = NULL;
+	struct cmp_data *data = NULL;
+
+	/*
+	 * We'll limit the number of threads for compression to limit memory
+	 * footprint.
+	 */
+	nr_threads = num_online_cpus() - 1;
+	if (nr_threads > LZO_THREADS)
+		nr_threads = LZO_THREADS;
+	else if (nr_threads < 1)
+		nr_threads = 1;
 
 	page = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
 	if (!page) {
 		printk(KERN_ERR "PM: Failed to allocate LZO page\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_clean;
 	}
 
-	wrk = vmalloc(LZO1X_1_MEM_COMPRESS);
-	if (!wrk) {
-		printk(KERN_ERR "PM: Failed to allocate LZO workspace\n");
-		free_page((unsigned long)page);
-		return -ENOMEM;
+	data = vmalloc(sizeof(*data) * nr_threads);
+	if (!data) {
+		printk(KERN_ERR "PM: Failed to allocate LZO data\n");
+		ret = -ENOMEM;
+		goto out_clean;
 	}
-
-	unc = vmalloc(LZO_UNC_SIZE);
-	if (!unc) {
-		printk(KERN_ERR "PM: Failed to allocate LZO uncompressed\n");
-		vfree(wrk);
-		free_page((unsigned long)page);
-		return -ENOMEM;
+	for (thr = 0; thr < nr_threads; thr++)
+		memset(&data[thr], 0, offsetof(struct cmp_data, go));
+
+	/*
+	 * Start the compression threads.
+	 */
+	for (thr = 0; thr < nr_threads; thr++) {
+		init_waitqueue_head(&data[thr].go);
+		init_waitqueue_head(&data[thr].done);
+
+		data[thr].thr = kthread_create(lzo_compress_threadfn,
+		                               &data[thr],
+		                               "image_compress/%zu", thr);
+		if (IS_ERR(data[thr].thr)) {
+			data[thr].thr = NULL;
+			printk(KERN_ERR
+			       "PM: Cannot start compression threads\n");
+			ret = -ENOMEM;
+			goto out_clean;
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
+		if (thr >= nr_threads)
+			break;
 	}
+	for (thr = 0; thr < nr_threads; thr++)
+		wake_up_process(data[thr].thr);
+
+	/*
+	 * Adjust number of free pages after all allocations have been done.
+	 * We don't want to run out of pages when writing.
+	 */
+	handle->nr_free_pages = nr_free_pages();
 
 	printk(KERN_INFO
+		"PM: Using %zu thread(s) for compression.\n"
 		"PM: Compressing and saving image data (%u pages) ...     ",
-		nr_to_write);
+		nr_threads, nr_to_write);
 	m = nr_to_write / 100;
 	if (!m)
 		m = 1;
@@ -480,54 +596,75 @@ static int save_image_lzo(struct swap_map_handle *handle,
 	bio = NULL;
 	do_gettimeofday(&start);
 	for (;;) {
-		for (off = 0; off < LZO_UNC_SIZE; off += PAGE_SIZE) {
-			ret = snapshot_read_next(snapshot);
-			if (ret < 0)
-				goto out_finish;
-
-			if (!ret)
+		for (thr = 0; thr < nr_threads; thr++) {
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
-			break;
-
-		unc_len = off;
-		ret = lzo1x_1_compress(unc, unc_len,
-		                       cmp + LZO_HEADER, &cmp_len, wrk);
-		if (ret < 0) {
-			printk(KERN_ERR "PM: LZO compression failed\n");
+		if (!thr)
 			break;
-		}
 
-		if (unlikely(!cmp_len ||
-		             cmp_len > lzo1x_worst_compress(unc_len))) {
-			printk(KERN_ERR "PM: Invalid LZO compressed length\n");
-			ret = -1;
-			break;
-		}
+		for (run_threads = thr, thr = 0; thr < run_threads; thr++) {
+			wait_event(data[thr].done,
+			           atomic_read(&data[thr].stop));
+			atomic_set(&data[thr].stop, 0);
 
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
 
@@ -541,11 +678,15 @@ out_finish:
 	else
 		printk(KERN_CONT "\n");
 	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
-
-	vfree(cmp);
-	vfree(unc);
-	vfree(wrk);
-	free_page((unsigned long)page);
+out_clean:
+	for (thr = 0; thr < nr_threads; thr++) {
+		if (data[thr].thr) {
+			kthread_stop(data[thr].thr);
+			wake_up(&data[thr].go);
+		}
+	}
+	if (data) vfree(data);
+	if (page) free_page((unsigned long)page);
 
 	return ret;
 }
@@ -625,31 +766,65 @@ out_finish:
 
 static void release_swap_reader(struct swap_map_handle *handle)
 {
+	struct swap_map_page_list *tmp;
+
 	if (handle->cur)
 		free_page((unsigned long)handle->cur);
+	while (handle->maps) {
+		if (handle->maps->map)
+			free_page((unsigned long)handle->maps->map);
+		tmp = handle->maps;
+		handle->maps = handle->maps->next;
+		vfree(tmp);
+	}
 	handle->cur = NULL;
+	handle->maps = NULL;
 }
 
 static int get_swap_reader(struct swap_map_handle *handle,
 		unsigned int *flags_p)
 {
 	int error;
+	struct swap_map_page_list *tmp, *last;
+	sector_t offset;
 
 	*flags_p = swsusp_header->flags;
 
 	if (!swsusp_header->image) /* how can this happen? */
 		return -EINVAL;
 
-	handle->cur = (struct swap_map_page *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
-	if (!handle->cur)
-		return -ENOMEM;
+	handle->cur = NULL;
+	last = handle->maps = NULL;
+	offset = swsusp_header->image;
+	while (offset) {
+		tmp = vmalloc(sizeof(*handle->maps));
+		if (!tmp) {
+			release_swap_reader(handle);
+			return -ENOMEM;
+		}
+		memset(tmp, 0, sizeof(*tmp));
+		if (!handle->maps)
+			handle->maps = tmp;
+		if (last)
+			last->next = tmp;
+		last = tmp;
+
+		tmp->map = (struct swap_map_page *)
+		           __get_free_page(__GFP_WAIT | __GFP_HIGH);
+		if (!tmp->map) {
+			release_swap_reader(handle);
+			return -ENOMEM;
+		}
 
-	error = hib_bio_read_page(swsusp_header->image, handle->cur, NULL);
-	if (error) {
-		release_swap_reader(handle);
-		return error;
+		error = hib_bio_read_page(offset, tmp->map, NULL);
+		if (error) {
+			release_swap_reader(handle);
+			return error;
+		}
+		offset = tmp->map->next_swap;
 	}
 	handle->k = 0;
+	handle->cur = handle->maps->map;
 	return 0;
 }
 
@@ -658,6 +833,7 @@ static int swap_read_page(struct swap_map_handle *handle, void *buf,
 {
 	sector_t offset;
 	int error;
+	struct swap_map_page_list *tmp;
 
 	if (!handle->cur)
 		return -EINVAL;
@@ -668,13 +844,15 @@ static int swap_read_page(struct swap_map_handle *handle, void *buf,
 	if (error)
 		return error;
 	if (++handle->k >= MAP_PAGE_ENTRIES) {
-		error = hib_wait_on_bio_chain(bio_chain);
 		handle->k = 0;
-		offset = handle->cur->next_swap;
-		if (!offset)
+		free_page((unsigned long)handle->maps->map);
+		tmp = handle->maps;
+		handle->maps = handle->maps->next;
+		vfree(tmp);
+		if (!handle->maps)
 			release_swap_reader(handle);
-		else if (!error)
-			error = hib_bio_read_page(offset, handle->cur, NULL);
+		else
+			handle->cur = handle->maps->map;
 	}
 	return error;
 }
@@ -743,6 +921,54 @@ static int load_image(struct swap_map_handle *handle,
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
+		if (kthread_should_stop()) {
+			/*
+			 * If this is not a desired exit, make sure return
+			 * code is an error.
+			 */
+			d->ret = -EFAULT;
+			atomic_set(&d->stop, 1);
+			wake_up(&d->done);
+			break;
+		}
+		atomic_set(&d->ready, 0);
+
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
@@ -754,49 +980,93 @@ static int load_image_lzo(struct swap_map_handle *handle,
 {
 	unsigned int m;
 	int error = 0;
+	int cpu, eof = 0;
 	struct bio *bio;
 	struct timeval start;
 	struct timeval stop;
 	unsigned nr_pages;
-	size_t i, off, unc_len, cmp_len;
-	unsigned char *unc, *cmp, *page[LZO_CMP_PAGES];
-
-	for (i = 0; i < LZO_CMP_PAGES; i++) {
-		page[i] = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
-		if (!page[i]) {
-			printk(KERN_ERR "PM: Failed to allocate LZO page\n");
-
-			while (i)
-				free_page((unsigned long)page[--i]);
+	size_t i, off, thr, run_threads, nr_threads;
+	size_t ring = 0, pg = 0, npages, have = 0, want, need, asked = 0;
+	unsigned char **page = NULL;
+	struct dec_data *data = NULL;
+
+	/*
+	 * We'll limit the number of threads for decompression to limit memory
+	 * footprint.
+	 */
+	nr_threads = num_online_cpus() - 1;
+	if (nr_threads > LZO_THREADS)
+		nr_threads = LZO_THREADS;
+	else if (nr_threads < 1)
+		nr_threads = 1;
+
+	page = vmalloc(sizeof(*page) * LZO_READ_PAGES);
+	if (!page) {
+		printk(KERN_ERR "PM: Failed to allocate LZO page\n");
+		error = -ENOMEM;
+		goto out_clean;
+	}
+	memset(page, 0, sizeof(*page) * LZO_READ_PAGES);
 
-			return -ENOMEM;
+	data = vmalloc(sizeof(*data) * nr_threads);
+	if (!data) {
+		printk(KERN_ERR "PM: Failed to allocate LZO data\n");
+		error = -ENOMEM;
+		goto out_clean;
+	}
+	for (thr = 0; thr < nr_threads; thr++)
+		memset(&data[thr], 0, offsetof(struct cmp_data, go));
+
+	/*
+	 * Start the decompression threads.
+	 */
+	for (thr = 0; thr < nr_threads; thr++) {
+		init_waitqueue_head(&data[thr].go);
+		init_waitqueue_head(&data[thr].done);
+
+		data[thr].thr = kthread_create(lzo_decompress_threadfn,
+		                               &data[thr],
+		                               "image_decompress/%zu", thr);
+		if (IS_ERR(data[thr].thr)) {
+			data[thr].thr = NULL;
+			printk(KERN_ERR
+			       "PM: Cannot start decompression threads\n");
+			error = -ENOMEM;
+			goto out_clean;
 		}
 	}
 
-	unc = vmalloc(LZO_UNC_SIZE);
-	if (!unc) {
-		printk(KERN_ERR "PM: Failed to allocate LZO uncompressed\n");
-
-		for (i = 0; i < LZO_CMP_PAGES; i++)
-			free_page((unsigned long)page[i]);
-
-		return -ENOMEM;
+	for (i = 0; i < LZO_READ_PAGES; i++) {
+		page[i] = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
+		if (!page[i]) {
+			if (i < LZO_CMP_PAGES) {
+				printk(KERN_ERR
+				       "PM: Failed to allocate LZO pages\n");
+				error = -ENOMEM;
+				goto out_clean;
+			}
+		}
 	}
-
-	cmp = vmalloc(LZO_CMP_SIZE);
-	if (!cmp) {
-		printk(KERN_ERR "PM: Failed to allocate LZO compressed\n");
-
-		vfree(unc);
-		for (i = 0; i < LZO_CMP_PAGES; i++)
-			free_page((unsigned long)page[i]);
-
-		return -ENOMEM;
+	want = npages = i;
+
+	/*
+	 * Bind the threads to CPUs and wake them up.
+	 */
+	thr = 0;
+	for_each_online_cpu(cpu) {
+		if (cpu == smp_processor_id())
+			continue;
+		kthread_bind(data[thr++].thr, cpu);
+		if (thr >= nr_threads)
+			break;
 	}
+	for (thr = 0; thr < nr_threads; thr++)
+		wake_up_process(data[thr].thr);
 
 	printk(KERN_INFO
+		"PM: Using %zu thread(s) for decompression.\n"
 		"PM: Loading and decompressing image data (%u pages) ...     ",
-		nr_to_read);
+		nr_threads, nr_to_read);
 	m = nr_to_read / 100;
 	if (!m)
 		m = 1;
@@ -808,61 +1078,128 @@ static int load_image_lzo(struct swap_map_handle *handle,
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
+		for (i = 0; !eof && i < want; i++) {
+			error = swap_read_page(handle, page[ring], &bio);
+			if (error) {
+				/*
+				 * On real read error, finish. On end of data,
+				 * set EOF flag and just exit the read loop.
+				 */
+				if (handle->cur &&
+				    handle->cur->entries[handle->k]) {
+					goto out_finish;
+				} else {
+					eof = 1;
+					break;
+				}
+			}
+			if (++ring >= npages)
+				ring = 0;
 		}
+		asked += i;
+		want -= i;
+
+		/*
+		 * We are out of data, wait for some more.
+		 */
+		if (!have) {
+			if (!asked)
+				break;
 
-		for (off = PAGE_SIZE, i = 1;
-		     off < LZO_HEADER + cmp_len; off += PAGE_SIZE, i++) {
-			error = swap_read_page(handle, page[i], &bio);
+			error = hib_wait_on_bio_chain(&bio);
 			if (error)
 				goto out_finish;
+			have += asked;
+			asked = 0;
+			if (eof)
+				eof = 2;
 		}
 
-		error = hib_wait_on_bio_chain(&bio); /* need all data now */
-		if (error)
-			goto out_finish;
+		for (thr = 0; have && thr < nr_threads; thr++) {
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
+			if (need > have) {
+				if (eof > 1) {
+					error = -1;
+					goto out_finish;
+				}
+				break;
+			}
 
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
+			if (eof)
+				eof = 2;
 		}
 
-		for (off = 0; off < unc_len; off += PAGE_SIZE) {
-			memcpy(data_of(*snapshot), unc + off, PAGE_SIZE);
+		for (run_threads = thr, thr = 0; thr < run_threads; thr++) {
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
 
@@ -876,11 +1213,18 @@ out_finish:
 	} else
 		printk("\n");
 	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
-
-	vfree(cmp);
-	vfree(unc);
-	for (i = 0; i < LZO_CMP_PAGES; i++)
-		free_page((unsigned long)page[i]);
+out_clean:
+	for (i = 0; i < npages; i++)
+		if (page[i])
+			free_page((unsigned long)page[i]);
+	for (thr = 0; thr < nr_threads; thr++) {
+		if (data[thr].thr) {
+			kthread_stop(data[thr].thr);
+			wake_up(&data[thr].go);
+		}
+	}
+	if (data) vfree(data);
+	if (page) vfree(page);
 
 	return error;
 }
---------------------------------------

-- 
Bojan

