Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab0IYEVM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 00:21:12 -0400
Received: from crca.org.au ([74.207.252.120]:49417 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264Ab0IYERR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 00:17:17 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 05/22] Hibernation: Switch to preallocating swap.
Date: Sat, 25 Sep 2010 14:16:47 +1000
Message-Id: <1285388224-10012-6-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from allocating swap as the image is written to allocating
storage prior to writing the image.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/swap.c |   62 ++++++++++++++++++++++++++++++--------------------
 1 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index cebf91c..bebd2cf 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -202,6 +202,33 @@ int alloc_swapdev_blocks(int needed)
 }
 
 /**
+ *	allocate_swap - Allocate enough swap to save the image.
+ *
+ *	Calculates the number of swap pages actually needed and seeks
+ *	to allocate that many from the resume partition. Returns TRUE
+ *	or FALSE to indicate whether we got enough storage.
+ */
+
+static int allocate_swap(unsigned int nr_pages)
+{
+	unsigned int free_swap = count_swap_pages(root_swap, 1);
+
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
@@ -324,7 +351,7 @@ static void release_swap_writer(struct swap_map_handle *handle)
 	handle->cur = NULL;
 }
 
-static int get_swap_writer(struct swap_map_handle *handle)
+static int get_swap_writer(struct swap_map_handle *handle, unsigned long pages)
 {
 	int ret;
 
@@ -340,7 +367,12 @@ static int get_swap_writer(struct swap_map_handle *handle)
 		ret = -ENOMEM;
 		goto err_close;
 	}
-	handle->cur_swap = alloc_swapdev_block(root_swap);
+	if (!allocate_swap(pages)) {
+		printk(KERN_ERR "PM: Not enough free swap\n");
+		ret = -ENOSPC;
+		goto err_close;
+	}
+	handle->cur_swap = next_swapdev_block();
 	if (!handle->cur_swap) {
 		ret = -ENOSPC;
 		goto err_rel;
@@ -363,7 +395,7 @@ static int swap_write_page(struct swap_map_handle *handle, void *buf,
 
 	if (!handle->cur)
 		return -EINVAL;
-	offset = alloc_swapdev_block(root_swap);
+	offset = next_swapdev_block();
 	error = write_page(buf, offset, bio_chain);
 	if (error)
 		return error;
@@ -372,7 +404,7 @@ static int swap_write_page(struct swap_map_handle *handle, void *buf,
 		error = hib_wait_on_bio_chain(bio_chain);
 		if (error)
 			goto out;
-		offset = alloc_swapdev_block(root_swap);
+		offset = next_swapdev_block();
 		if (!offset)
 			return -ENOSPC;
 		handle->cur->next_swap = offset;
@@ -463,21 +495,6 @@ static int save_image(struct swap_map_handle *handle,
 }
 
 /**
- *	enough_swap - Make sure we have enough swap to save the image.
- *
- *	Returns TRUE or FALSE after checking the total amount of swap
- *	space avaiable from the resume partition.
- */
-
-static int enough_swap(unsigned int nr_pages)
-{
-	unsigned int free_swap = count_swap_pages(root_swap, 1);
-
-	pr_debug("PM: Free swap pages: %u\n", free_swap);
-	return free_swap > nr_pages + PAGES_FOR_IO;
-}
-
-/**
  *	swsusp_write - Write entire image and metadata.
  *	@flags: flags to pass to the "boot" kernel in the image header
  *
@@ -496,16 +513,11 @@ int swsusp_write(unsigned int flags)
 	int error;
 
 	pages = snapshot_get_image_size();
-	error = get_swap_writer(&handle);
+	error = get_swap_writer(&handle, pages);
 	if (error) {
 		printk(KERN_ERR "PM: Cannot get swap writer\n");
 		return error;
 	}
-	if (!enough_swap(pages)) {
-		printk(KERN_ERR "PM: Not enough free swap\n");
-		error = -ENOSPC;
-		goto out_finish;
-	}
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
 	error = snapshot_read_next(&snapshot);
 	if (error < PAGE_SIZE) {
-- 
1.7.0.4

