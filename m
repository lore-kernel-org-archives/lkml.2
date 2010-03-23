Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0CWQ0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:26:31 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:57273 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab0CWQ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:26:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC 04/15] PM / Hibernate: move the first_sector out of swsusp_write
Date: Tue, 23 Mar 2010 17:17:32 +0100
Message-Id: <1269361063-3341-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

The first sector knowledge is swap only specific. Move it into the
handle. This will be needed for later non-swap specific code moving
inside snapshot.c.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/swap.c |   76 +++++++++++++++++++++++++-------------------------
 1 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index d4ff0d1..a1cff28 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -28,6 +28,40 @@
 
 #define SWSUSP_SIG	"S1SUSPEND"
 
+/*
+ *	The swap map is a data structure used for keeping track of each page
+ *	written to a swap partition.  It consists of many swap_map_page
+ *	structures that contain each an array of MAP_PAGE_SIZE swap entries.
+ *	These structures are stored on the swap and linked together with the
+ *	help of the .next_swap member.
+ *
+ *	The swap map is created during suspend.  The swap map pages are
+ *	allocated and populated one at a time, so we only need one memory
+ *	page to set up the entire structure.
+ *
+ *	During resume we also only need to use one swap_map_page structure
+ *	at a time.
+ */
+
+#define MAP_PAGE_ENTRIES	(PAGE_SIZE / sizeof(sector_t) - 1)
+
+struct swap_map_page {
+	sector_t entries[MAP_PAGE_ENTRIES];
+	sector_t next_swap;
+};
+
+/**
+ *	The swap_map_handle structure is used for handling swap in
+ *	a file-alike way
+ */
+
+struct swap_map_handle {
+	struct swap_map_page *cur;
+	sector_t cur_swap;
+	sector_t first_sector;
+	unsigned int k;
+};
+
 struct swsusp_header {
 	char reserved[PAGE_SIZE - 20 - sizeof(sector_t) - sizeof(int)];
 	sector_t image;
@@ -150,7 +184,7 @@ struct block_device *sws_resume_bdev;
  * Saving part
  */
 
-static int mark_swapfiles(sector_t start, unsigned int flags)
+static int mark_swapfiles(struct swap_map_handle *handle, unsigned int flags)
 {
 	int error;
 
@@ -159,7 +193,7 @@ static int mark_swapfiles(sector_t start, unsigned int flags)
 	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
 		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);
-		swsusp_header->image = start;
+		swsusp_header->image = handle->first_sector;
 		swsusp_header->flags = flags;
 		error = sws_bio_write_page(swsusp_resume_block,
 					swsusp_header, NULL);
@@ -225,39 +259,6 @@ static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
 	return sws_bio_write_page(offset, src, bio_chain);
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
-	sector_t cur_swap;
-	unsigned int k;
-};
-
 static void release_swap_writer(struct swap_map_handle *handle)
 {
 	if (handle->cur)
@@ -276,6 +277,7 @@ static int get_swap_writer(struct swap_map_handle *handle)
 		return -ENOSPC;
 	}
 	handle->k = 0;
+	handle->first_sector = handle->cur_swap;
 	return 0;
 }
 
@@ -420,8 +422,6 @@ int swsusp_write(unsigned int flags)
 	}
 	error = get_swap_writer(&handle);
 	if (!error) {
-		sector_t start = handle.cur_swap;
-
 		error = swap_write_page(&handle, header, NULL);
 		if (!error)
 			error = save_image(&handle, &snapshot,
@@ -430,7 +430,7 @@ int swsusp_write(unsigned int flags)
 		if (!error) {
 			flush_swap_writer(&handle);
 			printk(KERN_INFO "PM: S");
-			error = mark_swapfiles(start, flags);
+			error = mark_swapfiles(&handle, flags);
 			printk("|\n");
 		}
 	}
-- 
1.7.0.2


