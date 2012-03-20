Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab2CTE5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 00:57:33 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:36241 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2CTE5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 00:57:32 -0400
Message-ID: <1332219449.2025.11.camel@shrek.rexursive.com>
Subject: [PATCH v3]: Hibernation: lower/better control the amount of pages
 used for buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 20 Mar 2012 15:57:29 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

First off, sorry about the spam. Unfortunately, my fancy binary shifting
arithmetic in the v2 of the patch is not up to scratch (wanted to say
8k, instead said 4k). So, this version just changes (1 << 12) to 8192,
which is what I wanted to set LZO_READ_PAGES constant to. Otherwise the
same as v2.

---------------------------------------
Hibernation/thaw improvements:

1. Set maximum number of pages for read buffering consistently, instead
of inadvertently depending on the size of the sector type.

2. Use at most one quarter of free pages for read buffering.

3. Require that number of free pages when writing the image never falls
below half of total free pages available.

Signed-off-by: Bojan Smojver <bojan@rexursive.com>
---
 kernel/power/swap.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 8742fd0..63b0cfa 100644
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
@@ -72,7 +72,7 @@ struct swap_map_handle {
 	sector_t cur_swap;
 	sector_t first_sector;
 	unsigned int k;
-	unsigned long nr_free_pages, written;
+	unsigned long reqd_free_pages;
 	u32 crc32;
 };
 
@@ -316,8 +316,7 @@ static int get_swap_writer(struct swap_map_handle *handle)
 		goto err_rel;
 	}
 	handle->k = 0;
-	handle->nr_free_pages = nr_free_pages() >> 1;
-	handle->written = 0;
+	handle->reqd_free_pages = nr_free_pages() >> 1;
 	handle->first_sector = handle->cur_swap;
 	return 0;
 err_rel:
@@ -352,11 +351,15 @@ static int swap_write_page(struct swap_map_handle *handle, void *buf,
 		handle->cur_swap = offset;
 		handle->k = 0;
 	}
-	if (bio_chain && ++handle->written > handle->nr_free_pages) {
+	if (bio_chain && nr_free_pages() < handle->reqd_free_pages) {
 		error = hib_wait_on_bio_chain(bio_chain);
 		if (error)
 			goto out;
-		handle->written = 0;
+		/*
+		 * Recalculate the number of required free pages, to make sure
+		 * we never take more than half.
+		 */
+		handle->reqd_free_pages = nr_free_pages() >> 1;
 	}
  out:
 	return error;
@@ -404,7 +407,7 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 #define LZO_THREADS	3
 
 /* Maximum number of pages for read buffering. */
-#define LZO_READ_PAGES	(MAP_PAGE_ENTRIES * 8)
+#define LZO_READ_PAGES	8192
 
 
 /**
@@ -615,10 +618,10 @@ static int save_image_lzo(struct swap_map_handle *handle,
 	}
 
 	/*
-	 * Adjust number of free pages after all allocations have been done.
-	 * We don't want to run out of pages when writing.
+	 * Adjust the number of required free pages after all allocations have
+	 * been done. We don't want to run out of pages when writing.
 	 */
-	handle->nr_free_pages = nr_free_pages() >> 1;
+	handle->reqd_free_pages = nr_free_pages() >> 1;
 
 	/*
 	 * Start the CRC32 thread.
@@ -1129,8 +1132,9 @@ static int load_image_lzo(struct swap_map_handle *handle,
 
 	/*
 	 * Adjust number of pages for read buffering, in case we are short.
+	 * Never take more than a quarter of all available pages.
 	 */
-	read_pages = (nr_free_pages() - snapshot_get_image_size()) >> 1;
+	read_pages = (nr_free_pages() - snapshot_get_image_size()) >> 2;
 	read_pages = clamp_val(read_pages, LZO_CMP_PAGES, LZO_READ_PAGES);
 
 	for (i = 0; i < read_pages; i++) {
---------------------------------------

-- 
Bojan

