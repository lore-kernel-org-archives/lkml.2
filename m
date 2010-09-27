Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0I0FsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:48:12 -0400
Received: from crca.org.au ([74.207.252.120]:44271 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab0I0FoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:13 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 06/23] Hibernation: Switch to preallocating swap.
Date: Mon, 27 Sep 2010 15:43:41 +1000
Message-Id: <1285566238-10966-7-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to this patch, we allocated swap as we were writing the image.
This patch changes things so that we instead allocate all the swap
we'll need prior to starting to write the image. It lays groundwork
for later patches that switch from doing I/O in batches.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/swap.c |   68 +++++++++++++++++++++++++++++---------------------
 1 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index e597756..4c08329 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -183,6 +183,34 @@ int alloc_swapdev_blocks(int needed)
 }
 
 /**
+ *	allocate_swap - Allocate enough swap to save the image.
+ *
+ *	Calculates the number of swap pages actually needed and seeks
+ *	to allocate that many from the resume partition. Returns TRUE
+ *	or FALSE to indicate whether we got enough storage.
+ */
+
+static int allocate_swap(unsigned int nr_pages, unsigned int flags)
+{
+	unsigned int free_swap = count_swap_pages(root_swap, 1);
+
+	nr_pages += compress_extra_pages(nr_pages, flags);
+	nr_pages += DIV_ROUND_UP(nr_pages, MAP_PAGE_ENTRIES);
+
+	pr_debug("PM: Free swap pages: %u\n", free_swap);
+	if (free_swap < nr_pages)
+		return 0;
+
+	if (alloc_swapdev_blocks(nr_pages) < nr_pages) {
+		free_all_swap_pages(root_swap);
+		return 0;
+	}
+
+	reset_storage_pos();
+	return 1;
+}
+
+/**
  *	free_all_swap_pages - free swap pages allocated for saving image data.
  *	It also frees the extents used to register which swap entries had been
  *	allocated.
@@ -305,7 +333,8 @@ static void release_swap_writer(struct swap_map_handle *handle)
 	handle->cur = NULL;
 }
 
-static int get_swap_writer(struct swap_map_handle *handle)
+static int get_swap_writer(struct swap_map_handle *handle, unsigned long pages,
+		unsigned int flags)
 {
 	int ret;
 
@@ -321,7 +350,12 @@ static int get_swap_writer(struct swap_map_handle *handle)
 		ret = -ENOMEM;
 		goto err_close;
 	}
-	handle->cur_swap = alloc_swapdev_block(root_swap);
+	if (!allocate_swap(pages, flags)) {
+		printk(KERN_ERR "PM: Not enough free swap\n");
+		ret = -ENOSPC;
+		goto err_close;
+	}
+	handle->cur_swap = next_swapdev_block();
 	if (!handle->cur_swap) {
 		ret = -ENOSPC;
 		goto err_rel;
@@ -344,7 +378,7 @@ int swap_write_page(struct swap_map_handle *handle, void *buf,
 
 	if (!handle->cur)
 		return -EINVAL;
-	offset = alloc_swapdev_block(root_swap);
+	offset = next_swapdev_block();
 	error = write_page(buf, offset, bio_chain);
 	if (error)
 		return error;
@@ -353,7 +387,7 @@ int swap_write_page(struct swap_map_handle *handle, void *buf,
 		error = hib_wait_on_bio_chain(bio_chain);
 		if (error)
 			goto out;
-		offset = alloc_swapdev_block(root_swap);
+		offset = next_swapdev_block();
 		if (!offset)
 			return -ENOSPC;
 		handle->cur->next_swap = offset;
@@ -447,25 +481,6 @@ static int save_image(struct swap_map_handle *handle,
 
 
 /**
- *	enough_swap - Make sure we have enough swap to save the image.
- *
- *	Returns TRUE or FALSE after checking the total amount of swap
- *	space avaiable from the resume partition.
- */
-
-static int enough_swap(unsigned int nr_pages, unsigned int flags)
-{
-	unsigned int free_swap = count_swap_pages(root_swap, 1);
-	unsigned int required;
-
-	pr_debug("PM: Free swap pages: %u\n", free_swap);
-
-	required = PAGES_FOR_IO + nr_pages +
-		compress_extra_pages(nr_pages, flags);
-	return free_swap > required;
-}
-
-/**
  *	swsusp_write - Write entire image and metadata.
  *	@flags: flags to pass to the "boot" kernel in the image header
  *
@@ -489,17 +504,12 @@ int swsusp_write(unsigned int flags)
 		return error;
 
 	pages = snapshot_get_image_size();
-	error = get_swap_writer(&handle);
+	error = get_swap_writer(&handle, pages, flags);
 	if (error) {
 		printk(KERN_ERR "PM: Cannot get swap writer\n");
 		compress_image_cleanup();
 		return error;
 	}
-	if (!enough_swap(pages, flags)) {
-		printk(KERN_ERR "PM: Not enough free swap\n");
-		error = -ENOSPC;
-		goto out_finish;
-	}
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
 	error = snapshot_read_next(&snapshot);
 	if (error < PAGE_SIZE) {
-- 
1.7.0.4

