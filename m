Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab0I0Frn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:47:43 -0400
Received: from crca.org.au ([74.207.252.120]:49351 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932709Ab0I0FoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:19 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 09/23] Hibernation: Iterate over sectors not swap entries.
Date: Mon, 27 Sep 2010 15:43:44 +1000
Message-Id: <1285566238-10966-10-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record sectors in extents when allocating storage, and use the
sector numbers instead of swap offsets as we write the image. If
we then store these sector extents at the start of the image (as
following patches will do), we can drop the index pages that are
interspersed with the image, do fully asynchronous I/O (which
should give a speed boost) and perhaps also remove some of the
duplication in the paths for reading and writing pages.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/swap.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index f16e973..819d21a 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -58,14 +58,7 @@ struct swsusp_header {
 static struct swsusp_header *swsusp_header;
 
 static struct hib_extent_state swap_extents;
-
-static sector_t next_swapdev_block(void)
-{
-	unsigned long res = hib_extent_next(&swap_extents);
-	if (res)
-		res = swapdev_block(root_swap, res);
-	return res;
-}
+static struct hib_extent_state sector_extents;
 
 /**
  *	alloc_swapdev_block - allocate a swap page and register that it has
@@ -74,14 +67,16 @@ static sector_t next_swapdev_block(void)
 
 sector_t alloc_swapdev_block(int swap)
 {
-	unsigned long offset;
+	unsigned long offset, sector;
 
 	offset = swp_offset(get_swap_page_of_type(swap));
 	if (offset) {
-		if (hib_extents_insert(&swap_extents, offset))
+		sector = swapdev_block(swap, offset);
+		if (hib_extents_insert(&swap_extents, offset) ||
+		    hib_extents_insert(&sector_extents, sector))
 			swap_free(swp_entry(swap, offset));
 		else
-			return swapdev_block(swap, offset);
+			return sector;
 	}
 	return 0;
 }
@@ -123,7 +118,7 @@ static int allocate_swap(unsigned int nr_pages, unsigned int flags)
 		return 0;
 	}
 
-	hib_reset_extent_pos(&swap_extents);
+	hib_reset_extent_pos(&sector_extents);
 	return 1;
 }
 
@@ -266,7 +261,7 @@ static int get_swap_writer(struct swap_map_handle *handle, unsigned long pages,
 		ret = -ENOSPC;
 		goto err_close;
 	}
-	handle->cur_swap = next_swapdev_block();
+	handle->cur_swap = hib_extent_next(&sector_extents);
 	if (!handle->cur_swap) {
 		ret = -ENOSPC;
 		goto err_rel;
@@ -289,7 +284,7 @@ int swap_write_page(struct swap_map_handle *handle, void *buf,
 
 	if (!handle->cur)
 		return -EINVAL;
-	offset = next_swapdev_block();
+	offset = hib_extent_next(&sector_extents);
 	error = write_page(buf, offset, bio_chain);
 	if (error)
 		return error;
@@ -298,7 +293,7 @@ int swap_write_page(struct swap_map_handle *handle, void *buf,
 		error = hib_wait_on_bio_chain(bio_chain);
 		if (error)
 			goto out;
-		offset = next_swapdev_block();
+		offset = hib_extent_next(&sector_extents);
 		if (!offset)
 			return -ENOSPC;
 		handle->cur->next_swap = offset;
-- 
1.7.0.4

