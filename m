Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab0FBMUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:20:31 -0400
Received: from crca.org.au ([74.207.252.120]:38670 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786Ab0FBMU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:20:27 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 13/21] Hibernation: Store block extents at start of image
Date: Wed,  2 Jun 2010 22:19:12 +1000
Message-Id: <1275481160-31150-14-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
References: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for storing the list of extents being
used at the start of the image, prior to the header, in
preparation for switching from using swap map pages to these
extents, then removing the swap map pages.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |   59 ++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index 0e57776..7fabb0c 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -14,6 +14,7 @@
 
 #include "power.h"
 #include "extents.h"
+#include "block_io.h"
 
 static struct bio *bio_chain;
 
@@ -150,7 +151,9 @@ extern struct hib_extent_state sector_extents;
 /* Calculate the overhead needed for storing n pages */
 unsigned int hib_bio_overhead(unsigned int nr_pages)
 {
-	return DIV_ROUND_UP(nr_pages, MAP_PAGE_ENTRIES);
+	return DIV_ROUND_UP(nr_pages, MAP_PAGE_ENTRIES) +
+	       DIV_ROUND_UP(hib_extents_storage_needed(&sector_extents),
+			PAGE_SIZE);
 }
 
 /* Get the first sector of the image proper, for storing in the signature */
@@ -197,21 +200,34 @@ void release_swap_writer(void)
 
 int hib_bio_prepare_write(void)
 {
+	int result, result2;
+
 	handle.cur = (struct swap_map_page *)get_zeroed_page(GFP_KERNEL);
 
 	if (!handle.cur)
 		return -ENOMEM;
 
-	handle.cur_swap = hib_extent_next(&sector_extents);
-
-	if (!handle.cur_swap) {
+	result = hib_prepare_buffer();
+	if (result) {
 		release_swap_writer();
-		return -ENOSPC;
+		return result;
 	}
 
+	handle.first_sector = hib_extent_current(&sector_extents);
+
+	result = hib_extents_store(&sector_extents);
+	result2 = hib_flush_write_buffer();
+
+	handle.cur_swap = hib_extent_next(&sector_extents);
 	handle.k = 0;
-	handle.first_sector = handle.cur_swap;
-	return 0;
+
+	if (!handle.cur_swap)
+		result = -ENOSPC;
+
+	if (result || result2)
+		release_swap_writer();
+
+	return result ? result : result2;
 }
 
 int swap_write_page(void *buf, int sync)
@@ -268,6 +284,7 @@ void release_swap_reader(void)
 int get_swap_reader(unsigned int *flags_p, sector_t first_page)
 {
 	int error;
+	sector_t offset;
 
 	handle.cur = (struct swap_map_page *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
 	if (!handle.cur)
@@ -278,8 +295,34 @@ int get_swap_reader(unsigned int *flags_p, sector_t first_page)
 		release_swap_reader();
 		return error;
 	}
+
+	error = hib_prepare_buffer();
+	if (error) {
+		release_swap_reader();
+		return error;
+	}
+
 	handle.k = 0;
-	return 0;
+
+	/* Bootstrap reading the extents */
+	memcpy(hib_ppio_buffer, handle.cur, PAGE_SIZE);
+	error = hib_extents_load(&sector_extents, 1);
+
+	if (error) {
+		release_swap_reader();
+		return error;
+	}
+
+	offset = hib_extent_next(&sector_extents);
+
+	/* Now read the first swap_map_page */
+	error = hib_bio_read_page(offset, handle.cur, 1);
+	if (error) {
+		release_swap_reader();
+		return error;
+	}
+
+	return error;
 }
 
 int swap_read_page(void *buf, int sync)
-- 
1.7.0.4

