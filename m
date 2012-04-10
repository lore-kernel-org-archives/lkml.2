Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab2DJCra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 22:47:30 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:54934 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2DJCr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 22:47:29 -0400
Message-ID: <1334026047.2103.23.camel@shrek.rexursive.com>
Subject: [PATCH v9]: Hibernation: fix the number of pages used for
 hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Per Olofsson <pelle@debian.org>
Date: Tue, 10 Apr 2012 12:47:27 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

We now know for sure that this is a regression fix. So, please queue for
3.4, 3.3 and 3.2. The buffering changes that went into 3.2 can cause
hangs on hibernation, due to incorrect free pages calculations,
introduced by yours truly.

Special thanks to Per Olofsson for determining the real problem in the
free pages calculation.

---------------------------------------
Hibernation/thaw fixes/improvements:

1. Calculate the number of required free pages based on non-high memory
pages only, because that is where the buffers will come from.

2. Do not allocate memory for buffers from emergency pools, unless
absolutely required. Do not warn about and do not retry non-essential
failed allocations.

3. Do not check the amount of free pages left on every single page
write, but wait until one map is completely populated and then check.

4. Set maximum number of pages for read buffering consistently, instead
of inadvertently depending on the size of the sector type.

5. Fix copyright line, which I missed when I submitted the hibernation
threading patch.

6. Dispense with bit shifting arithmetic to improve readability.

Signed-off-by: Bojan Smojver <bojan@rexursive.com>
---
 kernel/power/swap.c |   69 +++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 8742fd0..074c159 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -6,7 +6,7 @@
  *
  * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@ucw.cz>
  * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
- * Copyright (C) 2010 Bojan Smojver <bojan@rexursive.com>
+ * Copyright (C) 2010-2012 Bojan Smojver <bojan@rexursive.com>
  *
  * This file is released under the GPLv2.
  *
@@ -51,6 +51,29 @@
 
 #define MAP_PAGE_ENTRIES	(PAGE_SIZE / sizeof(sector_t) - 1)
 
+/*
+ * Number of free pages that are not high.
+ */
+static unsigned long low_free_pages(void)
+{
+	struct zone *zone;
+	unsigned long free = 0;
+
+	for_each_populated_zone(zone)
+		if (!is_highmem(zone))
+			free += zone_page_state(zone, NR_FREE_PAGES);
+	return free;
+}
+
+/*
+ * Number of pages required to be kept free while writing the image. Always
+ * half of all available low pages before the writing starts.
+ */
+static inline unsigned long reqd_free_pages(void)
+{
+	return low_free_pages() / 2;
+}
+
 struct swap_map_page {
 	sector_t entries[MAP_PAGE_ENTRIES];
 	sector_t next_swap;
@@ -72,7 +95,7 @@ struct swap_map_handle {
 	sector_t cur_swap;
 	sector_t first_sector;
 	unsigned int k;
-	unsigned long nr_free_pages, written;
+	unsigned long reqd_free_pages;
 	u32 crc32;
 };
 
@@ -265,14 +288,17 @@ static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
 		return -ENOSPC;
 
 	if (bio_chain) {
-		src = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
+		src = (void *)__get_free_page(__GFP_WAIT | __GFP_NOWARN |
+		                              __GFP_NORETRY);
 		if (src) {
 			copy_page(src, buf);
 		} else {
 			ret = hib_wait_on_bio_chain(bio_chain); /* Free pages */
 			if (ret)
 				return ret;
-			src = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
+			src = (void *)__get_free_page(__GFP_WAIT |
+			                              __GFP_NOWARN |
+			                              __GFP_NORETRY);
 			if (src) {
 				copy_page(src, buf);
 			} else {
@@ -316,8 +342,7 @@ static int get_swap_writer(struct swap_map_handle *handle)
 		goto err_rel;
 	}
 	handle->k = 0;
-	handle->nr_free_pages = nr_free_pages() >> 1;
-	handle->written = 0;
+	handle->reqd_free_pages = reqd_free_pages();
 	handle->first_sector = handle->cur_swap;
 	return 0;
 err_rel:
@@ -351,12 +376,17 @@ static int swap_write_page(struct swap_map_handle *handle, void *buf,
 		clear_page(handle->cur);
 		handle->cur_swap = offset;
 		handle->k = 0;
-	}
-	if (bio_chain && ++handle->written > handle->nr_free_pages) {
-		error = hib_wait_on_bio_chain(bio_chain);
-		if (error)
-			goto out;
-		handle->written = 0;
+
+		if (bio_chain && low_free_pages() <= handle->reqd_free_pages) {
+			error = hib_wait_on_bio_chain(bio_chain);
+			if (error)
+				goto out;
+			/*
+			 * Recalculate the number of required free pages, to
+			 * make sure we never take more than half.
+			 */
+			handle->reqd_free_pages = reqd_free_pages();
+		}
 	}
  out:
 	return error;
@@ -404,7 +434,7 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 #define LZO_THREADS	3
 
 /* Maximum number of pages for read buffering. */
-#define LZO_READ_PAGES	(MAP_PAGE_ENTRIES * 8)
+#define LZO_READ_PAGES	8192
 
 
 /**
@@ -615,10 +645,10 @@ static int save_image_lzo(struct swap_map_handle *handle,
 	}
 
 	/*
-	 * Adjust number of free pages after all allocations have been done.
-	 * We don't want to run out of pages when writing.
+	 * Adjust the number of required free pages after all allocations have
+	 * been done. We don't want to run out of pages when writing.
 	 */
-	handle->nr_free_pages = nr_free_pages() >> 1;
+	handle->reqd_free_pages = reqd_free_pages();
 
 	/*
 	 * Start the CRC32 thread.
@@ -1129,14 +1159,17 @@ static int load_image_lzo(struct swap_map_handle *handle,
 
 	/*
 	 * Adjust number of pages for read buffering, in case we are short.
+	 * Never take more than half of all available low pages.
 	 */
-	read_pages = (nr_free_pages() - snapshot_get_image_size()) >> 1;
+	read_pages = (low_free_pages() - snapshot_get_image_size()) / 2;
 	read_pages = clamp_val(read_pages, LZO_CMP_PAGES, LZO_READ_PAGES);
 
 	for (i = 0; i < read_pages; i++) {
 		page[i] = (void *)__get_free_page(i < LZO_CMP_PAGES ?
 		                                  __GFP_WAIT | __GFP_HIGH :
-		                                  __GFP_WAIT);
+		                                  __GFP_WAIT | __GFP_NOWARN |
+		                                  __GFP_NORETRY);
+
 		if (!page[i]) {
 			if (i < LZO_CMP_PAGES) {
 				ring_size = i;
---------------------------------------

-- 
Bojan

