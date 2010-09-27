Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab0I0Fol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:44:41 -0400
Received: from crca.org.au ([74.207.252.120]:46010 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758368Ab0I0Foj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:39 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 21/23] Hibernation: Remove swap_map structure
Date: Mon, 27 Sep 2010 15:43:56 +1000
Message-Id: <1285566238-10966-22-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unused swap_map structure and associated
swap_map_handle.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |   56 -----------------------------------------------
 1 files changed, 0 insertions(+), 56 deletions(-)

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index 4f46878..f452650 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -126,40 +126,7 @@ void hib_wait_on_bio_chain(void)
 	wait_event(num_in_progress_wait, !atomic_read(&hib_io_in_progress));
 }
 
-/*
- *	The swap map is a data structure used for keeping track of each page
- *	written to a swap partition.  It consists of many swap_map_page
- *	structures that contain each an array of MAP_PAGE_SIZE swap entries.
- *	These structures are stored on the swap and linked together with the
- *	help of the .next_swap member.
- *
- *	The swap map is created during suspend.  The swap map pages are
- *	allocated and populated one at a time, so we only need one memory
- *	page to set up the entire structure.
- *
- *	During resume we also only need to use one swap_map_page structure
- *	at a time.
- */
-
-#define MAP_PAGE_ENTRIES	(PAGE_SIZE / sizeof(sector_t) - 1)
-
-struct swap_map_page {
-	sector_t entries[MAP_PAGE_ENTRIES];
-	sector_t next_swap;
-};
-
-/**
- *	The swap_map_handle structure is used for handling swap in
- *	a file-alike way
- */
-
-struct swap_map_handle {
-	struct swap_map_page *cur;
-	unsigned int k;
-};
-
 static sector_t first_sector;
-static struct swap_map_handle handle;
 
 extern struct hib_extent_state sector_extents;
 
@@ -207,20 +174,12 @@ static int write_page(void *buf, sector_t offset, int sync)
 
 void release_swap_writer(void)
 {
-	if (handle.cur)
-		free_page((unsigned long)handle.cur);
-	handle.cur = NULL;
 }
 
 int hib_bio_prepare_write(void)
 {
 	int result, result2;
 
-	handle.cur = (struct swap_map_page *)get_zeroed_page(GFP_KERNEL);
-
-	if (!handle.cur)
-		return -ENOMEM;
-
 	result = hib_prepare_buffer();
 	if (result) {
 		release_swap_writer();
@@ -232,8 +191,6 @@ int hib_bio_prepare_write(void)
 	result = hib_extents_store(&sector_extents);
 	result2 = hib_flush_write_buffer();
 
-	handle.k = 0;
-
 	if (result || result2)
 		release_swap_writer();
 
@@ -244,8 +201,6 @@ int swap_write_page(void *buf, int sync)
 {
 	sector_t offset;
 
-	if (!handle.cur)
-		return -EINVAL;
 	offset = hib_extent_next(&sector_extents);
 	return write_page(buf, offset, sync);
 }
@@ -263,19 +218,12 @@ int flush_swap_writer(void)
 
 void release_swap_reader(void)
 {
-	if (handle.cur)
-		free_page((unsigned long)handle.cur);
-	handle.cur = NULL;
 }
 
 int get_swap_reader(unsigned int *flags_p, sector_t first_page)
 {
 	int error;
 
-	handle.cur = (struct swap_map_page *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
-	if (!handle.cur)
-		return -ENOMEM;
-
 	error = hib_prepare_buffer();
 	if (error) {
 		release_swap_reader();
@@ -290,8 +238,6 @@ int get_swap_reader(unsigned int *flags_p, sector_t first_page)
 		return error;
 	}
 
-	handle.k = 0;
-
 	error = hib_extents_load(&sector_extents, 1);
 
 	if (error) {
@@ -306,8 +252,6 @@ int swap_read_page(void *buf, int sync)
 {
 	sector_t offset;
 
-	if (!handle.cur)
-		return -EINVAL;
 	offset = hib_extent_next(&sector_extents);
 	if (!offset)
 		return -EFAULT;
-- 
1.7.0.4

