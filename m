Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab0IYERn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 00:17:43 -0400
Received: from crca.org.au ([74.207.252.120]:38129 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab0IYERk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 00:17:40 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 18/22] Hibernation: Remove swap_map_pages
Date: Sat, 25 Sep 2010 14:17:00 +1000
Message-Id: <1285388224-10012-19-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop storing swap_map pages in the image. This removes the need
for a wait_on_bio_chain every MAP_PAGE_ENTRIES pages and thus
allows the whole image to be written using async I/O.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |   61 +++-------------------------------------------
 1 files changed, 4 insertions(+), 57 deletions(-)

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index 24b6db5..b068b5a 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -156,7 +156,6 @@ struct swap_map_page {
 
 struct swap_map_handle {
 	struct swap_map_page *cur;
-	sector_t cur_swap;
 	unsigned int k;
 };
 
@@ -168,8 +167,7 @@ extern struct hib_extent_state sector_extents;
 /* Calculate the overhead needed for storing n pages */
 unsigned int hib_bio_overhead(unsigned int nr_pages)
 {
-	return DIV_ROUND_UP(nr_pages, MAP_PAGE_ENTRIES) +
-	       DIV_ROUND_UP(hib_extents_storage_needed(&sector_extents),
+	return DIV_ROUND_UP(hib_extents_storage_needed(&sector_extents),
 			PAGE_SIZE);
 }
 
@@ -235,12 +233,8 @@ int hib_bio_prepare_write(void)
 	result = hib_extents_store(&sector_extents);
 	result2 = hib_flush_write_buffer();
 
-	handle.cur_swap = hib_extent_next(&sector_extents);
 	handle.k = 0;
 
-	if (!handle.cur_swap)
-		result = -ENOSPC;
-
 	if (result || result2)
 		release_swap_writer();
 
@@ -249,41 +243,17 @@ int hib_bio_prepare_write(void)
 
 int swap_write_page(void *buf, int sync)
 {
-	int error = 0;
 	sector_t offset;
 
 	if (!handle.cur)
 		return -EINVAL;
 	offset = hib_extent_next(&sector_extents);
-	error = write_page(buf, offset, sync);
-	if (error)
-		return error;
-	handle.cur->entries[handle.k++] = offset;
-	if (handle.k >= MAP_PAGE_ENTRIES) {
-		error = hib_wait_on_bio_chain();
-		if (error)
-			goto out;
-		offset = hib_extent_next(&sector_extents);
-		if (!offset)
-			return -ENOSPC;
-		handle.cur->next_swap = offset;
-		error = write_page(handle.cur, handle.cur_swap, 1);
-		if (error)
-			goto out;
-		memset(handle.cur, 0, PAGE_SIZE);
-		handle.cur_swap = offset;
-		handle.k = 0;
-	}
- out:
-	return error;
+	return write_page(buf, offset, sync);
 }
 
 int flush_swap_writer(void)
 {
-	if (handle.cur && handle.cur_swap)
-		return write_page(handle.cur, handle.cur_swap, 1);
-	else
-		return -EINVAL;
+	return hib_wait_on_bio_chain();
 }
 
 /**
@@ -301,7 +271,6 @@ void release_swap_reader(void)
 int get_swap_reader(unsigned int *flags_p, sector_t first_page)
 {
 	int error;
-	sector_t offset;
 
 	handle.cur = (struct swap_map_page *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
 	if (!handle.cur)
@@ -330,41 +299,19 @@ int get_swap_reader(unsigned int *flags_p, sector_t first_page)
 		return error;
 	}
 
-	offset = hib_extent_next(&sector_extents);
-
-	/* Now read the first swap_map_page */
-	error = hib_bio_read_page(offset, handle.cur, 1);
-	if (error) {
-		release_swap_reader();
-		return error;
-	}
-
 	return error;
 }
 
 int swap_read_page(void *buf, int sync)
 {
 	sector_t offset;
-	int error;
 
 	if (!handle.cur)
 		return -EINVAL;
 	offset = hib_extent_next(&sector_extents);
 	if (!offset)
 		return -EFAULT;
-	error = hib_bio_read_page(offset, buf, sync);
-	if (error)
-		return error;
-	if (++handle.k >= MAP_PAGE_ENTRIES) {
-		error = hib_wait_on_bio_chain();
-		handle.k = 0;
-		offset = hib_extent_next(&sector_extents);
-		if (!offset)
-			release_swap_reader();
-		else if (!error)
-			error = hib_bio_read_page(offset, handle.cur, 1);
-	}
-	return error;
+	return hib_bio_read_page(offset, buf, sync);
 }
 
 /* Part Page I/O functions */
-- 
1.7.0.4

