Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2CQG6O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 02:58:14 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:34313 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2CQG6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 02:58:08 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Mar 2012 02:58:08 EDT
Message-ID: <1331967113.1877.9.camel@shrek.rexursive.com>
Subject: [PATCH]: Lower the amount of pages used for buffering on hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 17 Mar 2012 17:51:53 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

The patch below reduces the amount of pages that can used by hibernation
code for buffering. Previously, we would take half of what was available
as a starting point, now only a quarter. And, we clamp the value to an
absolute maximum, just to be sure.

Also, the calculation of the maximum number of pages used for buffering
does not depend on the size of the sector type, which it inadvertently
did before.

In my testing, this had negligible effect on performance, but may
provide more pages to other kernel needs during hibernation.

---------------------------------------
 kernel/power/swap.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 8742fd0..6212351 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -51,6 +51,9 @@
 
 #define MAP_PAGE_ENTRIES	(PAGE_SIZE / sizeof(sector_t) - 1)
 
+/* Maximum number of pages for write buffering. */
+#define BUF_WRITE_PAGES		(1 << 15)
+
 struct swap_map_page {
 	sector_t entries[MAP_PAGE_ENTRIES];
 	sector_t next_swap;
@@ -316,7 +319,9 @@ static int get_swap_writer(struct swap_map_handle *handle)
 		goto err_rel;
 	}
 	handle->k = 0;
-	handle->nr_free_pages = nr_free_pages() >> 1;
+	handle->nr_free_pages = nr_free_pages() >> 2;
+	handle->nr_free_pages = clamp_val(handle->nr_free_pages,
+	                                  1, BUF_WRITE_PAGES);
 	handle->written = 0;
 	handle->first_sector = handle->cur_swap;
 	return 0;
@@ -404,7 +409,7 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 #define LZO_THREADS	3
 
 /* Maximum number of pages for read buffering. */
-#define LZO_READ_PAGES	(MAP_PAGE_ENTRIES * 8)
+#define LZO_READ_PAGES	(1 << 12)
 
 
 /**
@@ -618,7 +623,9 @@ static int save_image_lzo(struct swap_map_handle *handle,
 	 * Adjust number of free pages after all allocations have been done.
 	 * We don't want to run out of pages when writing.
 	 */
-	handle->nr_free_pages = nr_free_pages() >> 1;
+	handle->nr_free_pages = nr_free_pages() >> 2;
+	handle->nr_free_pages = clamp_val(handle->nr_free_pages,
+	                                  1, BUF_WRITE_PAGES);
 
 	/*
 	 * Start the CRC32 thread.
@@ -1130,7 +1137,7 @@ static int load_image_lzo(struct swap_map_handle *handle,
 	/*
 	 * Adjust number of pages for read buffering, in case we are short.
 	 */
-	read_pages = (nr_free_pages() - snapshot_get_image_size()) >> 1;
+	read_pages = (nr_free_pages() - snapshot_get_image_size()) >> 2;
 	read_pages = clamp_val(read_pages, LZO_CMP_PAGES, LZO_READ_PAGES);
 
 	for (i = 0; i < read_pages; i++) {
---------------------------------------

-- 
Bojan

