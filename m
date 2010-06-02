Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab0FBMXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:23:08 -0400
Received: from crca.org.au ([74.207.252.120]:58800 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756483Ab0FBMUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:20:20 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 10/21] Hibernation: Move block i/o fns to block_io.c
Date: Wed,  2 Jun 2010 22:19:09 +1000
Message-Id: <1275481160-31150-11-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
References: <1275481160-31150-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the functions that specifically deal with submitting I/O
to block_io.c. This helps us in working towards having a clean
separation between swap specific functions (which will be all
that will be in swap.c eventually) and low level block i/o
functions (block_io.c) that are/will be agnostic with regard to
the source of the storage. The block_io.c functions will thus
also be useable when support for storing an image in a generic
file (non swap) is added later.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/block_io.c |  199 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/block_io.h |   23 ++++++
 kernel/power/swap.c     |  202 +++--------------------------------------------
 3 files changed, 235 insertions(+), 189 deletions(-)
 create mode 100644 kernel/power/block_io.h

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index c353d64..c449db2 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -13,6 +13,7 @@
 #include <linux/swap.h>
 
 #include "power.h"
+#include "extents.h"
 
 static struct bio *bio_chain;
 
@@ -102,3 +103,201 @@ int hib_wait_on_bio_chain(void)
 	bio_chain = NULL;
 	return ret;
 }
+
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
+static struct swap_map_handle handle;
+
+extern struct hib_extent_state sector_extents;
+
+/* Calculate the overhead needed for storing n pages */
+unsigned int hib_bio_overhead(unsigned int nr_pages)
+{
+	return DIV_ROUND_UP(nr_pages, MAP_PAGE_ENTRIES);
+}
+
+/* Get the first sector of the image proper, for storing in the signature */
+sector_t hib_get_first_sector(void)
+{
+	return handle.first_sector;
+}
+
+/**
+ *	write_page - Write one page to given swap location.
+ *	@buf:		Address we're writing.
+ *	@offset:	Offset of the swap page we're writing to.
+ *	@sync:		Whether to force synchronous i/o.
+ */
+
+static int write_page(void *buf, sector_t offset, int sync)
+{
+	void *src;
+
+	if (!offset)
+		return -ENOSPC;
+
+	if (!sync) {
+		src = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
+		if (src) {
+			memcpy(src, buf, PAGE_SIZE);
+		} else {
+			WARN_ON_ONCE(1);
+			sync = 1;	/* Go synchronous */
+			src = buf;
+		}
+	} else {
+		src = buf;
+	}
+	return hib_bio_write_page(offset, src, sync);
+}
+
+void release_swap_writer(void)
+{
+	if (handle.cur)
+		free_page((unsigned long)handle.cur);
+	handle.cur = NULL;
+}
+
+int hib_bio_prepare_write(void)
+{
+	handle.cur = (struct swap_map_page *)get_zeroed_page(GFP_KERNEL);
+
+	if (!handle.cur)
+		return -ENOMEM;
+
+	handle.cur_swap = hib_extent_next(&sector_extents);
+
+	if (!handle.cur_swap) {
+		release_swap_writer();
+		return -ENOSPC;
+	}
+
+	handle.k = 0;
+	handle.first_sector = handle.cur_swap;
+	return 0;
+}
+
+int swap_write_page(void *buf, int sync)
+{
+	int error = 0;
+	sector_t offset;
+
+	if (!handle.cur)
+		return -EINVAL;
+	offset = hib_extent_next(&sector_extents);
+	error = write_page(buf, offset, sync);
+	if (error)
+		return error;
+	handle.cur->entries[handle.k++] = offset;
+	if (handle.k >= MAP_PAGE_ENTRIES) {
+		error = hib_wait_on_bio_chain();
+		if (error)
+			goto out;
+		offset = hib_extent_next(&sector_extents);
+		if (!offset)
+			return -ENOSPC;
+		handle.cur->next_swap = offset;
+		error = write_page(handle.cur, handle.cur_swap, 1);
+		if (error)
+			goto out;
+		memset(handle.cur, 0, PAGE_SIZE);
+		handle.cur_swap = offset;
+		handle.k = 0;
+	}
+ out:
+	return error;
+}
+
+int flush_swap_writer(void)
+{
+	if (handle.cur && handle.cur_swap)
+		return write_page(handle.cur, handle.cur_swap, 1);
+	else
+		return -EINVAL;
+}
+
+/**
+ *	The following functions allow us to read data using a swap map
+ *	in a file-alike way
+ */
+
+void release_swap_reader(void)
+{
+	if (handle.cur)
+		free_page((unsigned long)handle.cur);
+	handle.cur = NULL;
+}
+
+int get_swap_reader(unsigned int *flags_p, sector_t first_page)
+{
+	int error;
+
+	handle.cur = (struct swap_map_page *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
+	if (!handle.cur)
+		return -ENOMEM;
+
+	error = hib_bio_read_page(first_page, handle.cur, 1);
+	if (error) {
+		release_swap_reader();
+		return error;
+	}
+	handle.k = 0;
+	return 0;
+}
+
+int swap_read_page(void *buf, int sync)
+{
+	sector_t offset;
+	int error;
+
+	if (!handle.cur)
+		return -EINVAL;
+	offset = handle.cur->entries[handle.k];
+	if (!offset)
+		return -EFAULT;
+	error = hib_bio_read_page(offset, buf, sync);
+	if (error)
+		return error;
+	if (++handle.k >= MAP_PAGE_ENTRIES) {
+		error = hib_wait_on_bio_chain();
+		handle.k = 0;
+		offset = handle.cur->next_swap;
+		if (!offset)
+			release_swap_reader();
+		else if (!error)
+			error = hib_bio_read_page(offset, handle.cur, 1);
+	}
+	return error;
+}
diff --git a/kernel/power/block_io.h b/kernel/power/block_io.h
new file mode 100644
index 0000000..2f91d6d
--- /dev/null
+++ b/kernel/power/block_io.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@ucw.cz>
+ * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
+ * Copyright (C) 2010 Nigel Cunningham <nigel@tuxonice.net>
+ *
+ * This file is released under the GPLv2.
+ */
+
+/* Low level routines */
+int hib_bio_read_page(pgoff_t page_off, void *addr, int sync);
+int hib_bio_write_page(pgoff_t page_off, void *addr, int sync);
+int hib_wait_on_bio_chain(void);
+
+unsigned int hib_bio_overhead(unsigned int nr_pages);
+sector_t hib_get_first_sector(void);
+extern struct hib_extent_state sector_extents;
+void release_swap_writer(void);
+int hib_bio_prepare_write(void);
+int flush_swap_writer(void);
+int swap_write_page(void *buf, int sync);
+int get_swap_reader(unsigned int *flags_p, sector_t first_page);
+void release_swap_reader(void);
+int swap_read_page(void *buf, int sync);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 45f89dc..b4ab6a2 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -26,45 +26,10 @@
 
 #include "power.h"
 #include "extents.h"
+#include "block_io.h"
 
 #define SWSUSP_SIG	"S1SUSPEND"
 
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
-	sector_t first_sector;
-	unsigned int k;
-};
-
-static struct swap_map_handle handle;
-
 static unsigned short root_swap = 0xffff;
 
 struct swsusp_header {
@@ -78,7 +43,7 @@ struct swsusp_header {
 static struct swsusp_header *swsusp_header;
 
 static struct hib_extent_state swap_extents;
-static struct hib_extent_state sector_extents;
+struct hib_extent_state sector_extents;
 
 /**
  *	alloc_swapdev_block - allocate a swap page and register that it has
@@ -126,7 +91,7 @@ static int allocate_swap(unsigned int nr_pages)
 {
 	unsigned int free_swap = count_swap_pages(root_swap, 1);
 
-	nr_pages += DIV_ROUND_UP(nr_pages, MAP_PAGE_ENTRIES);
+	nr_pages += hib_bio_overhead(nr_pages);
 
 	pr_debug("PM: Free swap pages: %u\n", free_swap);
 	if (free_swap < nr_pages)
@@ -182,7 +147,7 @@ static int mark_swapfiles(unsigned int flags)
 	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
 		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);
-		swsusp_header->image = handle.first_sector;
+		swsusp_header->image = hib_get_first_sector();
 		swsusp_header->flags = flags;
 		error = hib_bio_write_page(swsusp_resume_block,
 					swsusp_header, 1);
@@ -220,42 +185,6 @@ static int swsusp_swap_check(void)
 	return res;
 }
 
-/**
- *	write_page - Write one page to given swap location.
- *	@buf:		Address we're writing.
- *	@offset:	Offset of the swap page we're writing to.
- *	@sync:		Whether to force synchronous i/o.
- */
-
-static int write_page(void *buf, sector_t offset, int sync)
-{
-	void *src;
-
-	if (!offset)
-		return -ENOSPC;
-
-	if (!sync) {
-		src = (void *)__get_free_page(__GFP_WAIT | __GFP_HIGH);
-		if (src) {
-			memcpy(src, buf, PAGE_SIZE);
-		} else {
-			WARN_ON_ONCE(1);
-			sync = 1;	/* Go synchronous */
-			src = buf;
-		}
-	} else {
-		src = buf;
-	}
-	return hib_bio_write_page(offset, src, sync);
-}
-
-static void release_swap_writer(void)
-{
-	if (handle.cur)
-		free_page((unsigned long)handle.cur);
-	handle.cur = NULL;
-}
-
 static int get_swap_writer(unsigned long pages)
 {
 	int ret;
@@ -267,70 +196,19 @@ static int get_swap_writer(unsigned long pages)
 					"swapon -a.\n");
 		return ret;
 	}
-	handle.cur = (struct swap_map_page *)get_zeroed_page(GFP_KERNEL);
-	if (!handle.cur) {
-		ret = -ENOMEM;
-		goto err_close;
-	}
 	if (!allocate_swap(pages)) {
 		printk(KERN_ERR "PM: Not enough free swap\n");
 		ret = -ENOSPC;
 		goto err_close;
 	}
-	handle.cur_swap = hib_extent_next(&sector_extents);
-	if (!handle.cur_swap) {
-		ret = -ENOSPC;
-		goto err_rel;
-	}
-	handle.k = 0;
-	handle.first_sector = handle.cur_swap;
-	return 0;
-err_rel:
-	release_swap_writer();
+	ret = hib_bio_prepare_write();
+	if (!ret)
+		return 0;
 err_close:
 	swsusp_close(FMODE_WRITE);
 	return ret;
 }
 
-static int swap_write_page(void *buf, int sync)
-{
-	int error = 0;
-	sector_t offset;
-
-	if (!handle.cur)
-		return -EINVAL;
-	offset = hib_extent_next(&sector_extents);
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
-}
-
-static int flush_swap_writer(void)
-{
-	if (handle.cur && handle.cur_swap)
-		return write_page(handle.cur, handle.cur_swap, 1);
-	else
-		return -EINVAL;
-}
-
 static int swap_writer_finish(unsigned int flags, int error)
 {
 	if (!error) {
@@ -432,65 +310,6 @@ out_finish:
 	return error;
 }
 
-/**
- *	The following functions allow us to read data using a swap map
- *	in a file-alike way
- */
-
-static void release_swap_reader(void)
-{
-	if (handle.cur)
-		free_page((unsigned long)handle.cur);
-	handle.cur = NULL;
-}
-
-static int get_swap_reader(unsigned int *flags_p)
-{
-	int error;
-
-	*flags_p = swsusp_header->flags;
-
-	if (!swsusp_header->image) /* how can this happen? */
-		return -EINVAL;
-
-	handle.cur = (struct swap_map_page *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
-	if (!handle.cur)
-		return -ENOMEM;
-
-	error = hib_bio_read_page(swsusp_header->image, handle.cur, 1);
-	if (error) {
-		release_swap_reader();
-		return error;
-	}
-	handle.k = 0;
-	return 0;
-}
-
-static int swap_read_page(void *buf, int sync)
-{
-	sector_t offset;
-	int error;
-
-	if (!handle.cur)
-		return -EINVAL;
-	offset = handle.cur->entries[handle.k];
-	if (!offset)
-		return -EFAULT;
-	error = hib_bio_read_page(offset, buf, sync);
-	if (error)
-		return error;
-	if (++handle.k >= MAP_PAGE_ENTRIES) {
-		error = hib_wait_on_bio_chain();
-		handle.k = 0;
-		offset = handle.cur->next_swap;
-		if (!offset)
-			release_swap_reader();
-		else if (!error)
-			error = hib_bio_read_page(offset, handle.cur, 1);
-	}
-	return error;
-}
-
 static int swap_reader_finish(void)
 {
 	release_swap_reader();
@@ -567,7 +386,12 @@ int swsusp_read(unsigned int *flags_p)
 	if (error < PAGE_SIZE)
 		return error < 0 ? error : -EFAULT;
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = get_swap_reader(flags_p);
+	*flags_p = swsusp_header->flags;
+	if (!swsusp_header->image) { /* how can this happen? */
+		error = -EINVAL;
+		goto end;
+	}
+	error = get_swap_reader(flags_p, swsusp_header->image);
 	if (error)
 		goto end;
 	if (!error)
-- 
1.7.0.4

