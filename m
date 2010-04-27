Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0D0IWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 04:22:30 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:57427 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab0D0IW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 04:22:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: [PATCH 3/5] PM / Hibernate: separate block_io
Date: Tue, 27 Apr 2010 10:15:16 +0200
Message-Id: <1272356118-10012-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1272356118-10012-1-git-send-email-jslaby@suse.cz>
References: <1272356118-10012-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move block I/O operations to a separate file. It is because it will
be used later not only by the swap writer.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/Makefile   |    3 +-
 kernel/power/block_io.c |  103 +++++++++++++++++++++++++++++++++++
 kernel/power/power.h    |    9 +++
 kernel/power/swap.c     |  136 +++++++++--------------------------------------
 4 files changed, 139 insertions(+), 112 deletions(-)
 create mode 100644 kernel/power/block_io.c

diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 4319181..524e058 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -8,7 +8,8 @@ obj-$(CONFIG_PM_SLEEP)		+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
-obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o
+obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
+				   block_io.o
 obj-$(CONFIG_HIBERNATION_NVS)	+= hibernate_nvs.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
new file mode 100644
index 0000000..3ba57e0
--- /dev/null
+++ b/kernel/power/block_io.c
@@ -0,0 +1,103 @@
+/*
+ * This file provides functions for block I/O operations on swap/file.
+ *
+ * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/bio.h>
+#include <linux/kernel.h>
+#include <linux/pagemap.h>
+#include <linux/swap.h>
+
+#include "power.h"
+
+/**
+ *	submit - submit BIO request.
+ *	@rw:	READ or WRITE.
+ *	@off	physical offset of page.
+ *	@page:	page we're reading or writing.
+ *	@bio_chain: list of pending biod (for async reading)
+ *
+ *	Straight from the textbook - allocate and initialize the bio.
+ *	If we're reading, make sure the page is marked as dirty.
+ *	Then submit it and, if @bio_chain == NULL, wait.
+ */
+static int submit(int rw, struct block_device *bdev, sector_t sector,
+		struct page *page, struct bio **bio_chain)
+{
+	const int bio_rw = rw | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
+	struct bio *bio;
+
+	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
+	bio->bi_sector = sector;
+	bio->bi_bdev = bdev;
+	bio->bi_end_io = end_swap_bio_read;
+
+	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
+		printk(KERN_ERR "PM: Adding page to bio failed at %ld\n",
+			sector);
+		bio_put(bio);
+		return -EFAULT;
+	}
+
+	lock_page(page);
+	bio_get(bio);
+
+	if (bio_chain == NULL) {
+		submit_bio(bio_rw, bio);
+		wait_on_page_locked(page);
+		if (rw == READ)
+			bio_set_pages_dirty(bio);
+		bio_put(bio);
+	} else {
+		if (rw == READ)
+			get_page(page);	/* These pages are freed later */
+		bio->bi_private = *bio_chain;
+		*bio_chain = bio;
+		submit_bio(bio_rw, bio);
+	}
+	return 0;
+}
+
+int hib_bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
+{
+	return submit(READ, hib_resume_bdev, page_off * (PAGE_SIZE >> 9),
+			virt_to_page(addr), bio_chain);
+}
+
+int hib_bio_write_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
+{
+	return submit(WRITE, hib_resume_bdev, page_off * (PAGE_SIZE >> 9),
+			virt_to_page(addr), bio_chain);
+}
+
+int hib_wait_on_bio_chain(struct bio **bio_chain)
+{
+	struct bio *bio;
+	struct bio *next_bio;
+	int ret = 0;
+
+	if (bio_chain == NULL)
+		return 0;
+
+	bio = *bio_chain;
+	if (bio == NULL)
+		return 0;
+	while (bio) {
+		struct page *page;
+
+		next_bio = bio->bi_private;
+		page = bio->bi_io_vec[0].bv_page;
+		wait_on_page_locked(page);
+		if (!PageUptodate(page) || PageError(page))
+			ret = -EIO;
+		put_page(page);
+		bio_put(bio);
+		bio = next_bio;
+	}
+	*bio_chain = NULL;
+	return ret;
+}
diff --git a/kernel/power/power.h b/kernel/power/power.h
index b1e207d..006270f 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -142,6 +142,15 @@ extern int swsusp_read(unsigned int *flags_p);
 extern int swsusp_write(unsigned int flags);
 extern void swsusp_close(fmode_t);
 
+/* kernel/power/block_io.c */
+extern struct block_device *hib_resume_bdev;
+
+extern int hib_bio_read_page(pgoff_t page_off, void *addr,
+		struct bio **bio_chain);
+extern int hib_bio_write_page(pgoff_t page_off, void *addr,
+		struct bio **bio_chain);
+extern int hib_wait_on_bio_chain(struct bio **bio_chain);
+
 struct timeval;
 /* kernel/power/swsusp.c */
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 7f2a17e..1b1ab6f 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -145,93 +145,7 @@ int swsusp_swap_in_use(void)
  */
 
 static unsigned short root_swap = 0xffff;
-static struct block_device *resume_bdev;
-
-/**
- *	submit - submit BIO request.
- *	@rw:	READ or WRITE.
- *	@off	physical offset of page.
- *	@page:	page we're reading or writing.
- *	@bio_chain: list of pending biod (for async reading)
- *
- *	Straight from the textbook - allocate and initialize the bio.
- *	If we're reading, make sure the page is marked as dirty.
- *	Then submit it and, if @bio_chain == NULL, wait.
- */
-static int submit(int rw, pgoff_t page_off, struct page *page,
-			struct bio **bio_chain)
-{
-	const int bio_rw = rw | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
-	struct bio *bio;
-
-	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
-	bio->bi_sector = page_off * (PAGE_SIZE >> 9);
-	bio->bi_bdev = resume_bdev;
-	bio->bi_end_io = end_swap_bio_read;
-
-	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
-		printk(KERN_ERR "PM: Adding page to bio failed at %ld\n",
-			page_off);
-		bio_put(bio);
-		return -EFAULT;
-	}
-
-	lock_page(page);
-	bio_get(bio);
-
-	if (bio_chain == NULL) {
-		submit_bio(bio_rw, bio);
-		wait_on_page_locked(page);
-		if (rw == READ)
-			bio_set_pages_dirty(bio);
-		bio_put(bio);
-	} else {
-		if (rw == READ)
-			get_page(page);	/* These pages are freed later */
-		bio->bi_private = *bio_chain;
-		*bio_chain = bio;
-		submit_bio(bio_rw, bio);
-	}
-	return 0;
-}
-
-static int bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
-{
-	return submit(READ, page_off, virt_to_page(addr), bio_chain);
-}
-
-static int bio_write_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
-{
-	return submit(WRITE, page_off, virt_to_page(addr), bio_chain);
-}
-
-static int wait_on_bio_chain(struct bio **bio_chain)
-{
-	struct bio *bio;
-	struct bio *next_bio;
-	int ret = 0;
-
-	if (bio_chain == NULL)
-		return 0;
-
-	bio = *bio_chain;
-	if (bio == NULL)
-		return 0;
-	while (bio) {
-		struct page *page;
-
-		next_bio = bio->bi_private;
-		page = bio->bi_io_vec[0].bv_page;
-		wait_on_page_locked(page);
-		if (!PageUptodate(page) || PageError(page))
-			ret = -EIO;
-		put_page(page);
-		bio_put(bio);
-		bio = next_bio;
-	}
-	*bio_chain = NULL;
-	return ret;
-}
+struct block_device *hib_resume_bdev;
 
 /*
  * Saving part
@@ -241,14 +155,14 @@ static int mark_swapfiles(sector_t start, unsigned int flags)
 {
 	int error;
 
-	bio_read_page(swsusp_resume_block, swsusp_header, NULL);
+	hib_bio_read_page(swsusp_resume_block, swsusp_header, NULL);
 	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
 	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
 		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);
 		swsusp_header->image = start;
 		swsusp_header->flags = flags;
-		error = bio_write_page(swsusp_resume_block,
+		error = hib_bio_write_page(swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "PM: Swap header not found!\n");
@@ -267,18 +181,18 @@ static int swsusp_swap_check(void) /* This is called before saving image */
 	int res;
 
 	res = swap_type_of(swsusp_resume_device, swsusp_resume_block,
-			&resume_bdev);
+			&hib_resume_bdev);
 	if (res < 0)
 		return res;
 
 	root_swap = res;
-	res = blkdev_get(resume_bdev, FMODE_WRITE);
+	res = blkdev_get(hib_resume_bdev, FMODE_WRITE);
 	if (res)
 		return res;
 
-	res = set_blocksize(resume_bdev, PAGE_SIZE);
+	res = set_blocksize(hib_resume_bdev, PAGE_SIZE);
 	if (res < 0)
-		blkdev_put(resume_bdev, FMODE_WRITE);
+		blkdev_put(hib_resume_bdev, FMODE_WRITE);
 
 	return res;
 }
@@ -309,7 +223,7 @@ static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
 	} else {
 		src = buf;
 	}
-	return bio_write_page(offset, src, bio_chain);
+	return hib_bio_write_page(offset, src, bio_chain);
 }
 
 /*
@@ -380,7 +294,7 @@ static int swap_write_page(struct swap_map_handle *handle, void *buf,
 		return error;
 	handle->cur->entries[handle->k++] = offset;
 	if (handle->k >= MAP_PAGE_ENTRIES) {
-		error = wait_on_bio_chain(bio_chain);
+		error = hib_wait_on_bio_chain(bio_chain);
 		if (error)
 			goto out;
 		offset = alloc_swapdev_block(root_swap);
@@ -441,7 +355,7 @@ static int save_image(struct swap_map_handle *handle,
 			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
 	}
-	err2 = wait_on_bio_chain(&bio);
+	err2 = hib_wait_on_bio_chain(&bio);
 	do_gettimeofday(&stop);
 	if (!ret)
 		ret = err2;
@@ -553,7 +467,7 @@ static int get_swap_reader(struct swap_map_handle *handle, sector_t start)
 	if (!handle->cur)
 		return -ENOMEM;
 
-	error = bio_read_page(start, handle->cur, NULL);
+	error = hib_bio_read_page(start, handle->cur, NULL);
 	if (error) {
 		release_swap_reader(handle);
 		return error;
@@ -573,17 +487,17 @@ static int swap_read_page(struct swap_map_handle *handle, void *buf,
 	offset = handle->cur->entries[handle->k];
 	if (!offset)
 		return -EFAULT;
-	error = bio_read_page(offset, buf, bio_chain);
+	error = hib_bio_read_page(offset, buf, bio_chain);
 	if (error)
 		return error;
 	if (++handle->k >= MAP_PAGE_ENTRIES) {
-		error = wait_on_bio_chain(bio_chain);
+		error = hib_wait_on_bio_chain(bio_chain);
 		handle->k = 0;
 		offset = handle->cur->next_swap;
 		if (!offset)
 			release_swap_reader(handle);
 		else if (!error)
-			error = bio_read_page(offset, handle->cur, NULL);
+			error = hib_bio_read_page(offset, handle->cur, NULL);
 	}
 	return error;
 }
@@ -622,14 +536,14 @@ static int load_image(struct swap_map_handle *handle,
 		if (error)
 			break;
 		if (snapshot->sync_read)
-			error = wait_on_bio_chain(&bio);
+			error = hib_wait_on_bio_chain(&bio);
 		if (error)
 			break;
 		if (!(nr_pages % m))
 			printk("\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
 	}
-	err2 = wait_on_bio_chain(&bio);
+	err2 = hib_wait_on_bio_chain(&bio);
 	do_gettimeofday(&stop);
 	if (!error)
 		error = err2;
@@ -686,11 +600,11 @@ int swsusp_check(void)
 {
 	int error;
 
-	resume_bdev = open_by_devnum(swsusp_resume_device, FMODE_READ);
-	if (!IS_ERR(resume_bdev)) {
-		set_blocksize(resume_bdev, PAGE_SIZE);
+	hib_resume_bdev = open_by_devnum(swsusp_resume_device, FMODE_READ);
+	if (!IS_ERR(hib_resume_bdev)) {
+		set_blocksize(hib_resume_bdev, PAGE_SIZE);
 		memset(swsusp_header, 0, PAGE_SIZE);
-		error = bio_read_page(swsusp_resume_block,
+		error = hib_bio_read_page(swsusp_resume_block,
 					swsusp_header, NULL);
 		if (error)
 			goto put;
@@ -698,7 +612,7 @@ int swsusp_check(void)
 		if (!memcmp(SWSUSP_SIG, swsusp_header->sig, 10)) {
 			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
 			/* Reset swap signature now */
-			error = bio_write_page(swsusp_resume_block,
+			error = hib_bio_write_page(swsusp_resume_block,
 						swsusp_header, NULL);
 		} else {
 			error = -EINVAL;
@@ -706,11 +620,11 @@ int swsusp_check(void)
 
 put:
 		if (error)
-			blkdev_put(resume_bdev, FMODE_READ);
+			blkdev_put(hib_resume_bdev, FMODE_READ);
 		else
 			pr_debug("PM: Signature found, resuming\n");
 	} else {
-		error = PTR_ERR(resume_bdev);
+		error = PTR_ERR(hib_resume_bdev);
 	}
 
 	if (error)
@@ -725,12 +639,12 @@ put:
 
 void swsusp_close(fmode_t mode)
 {
-	if (IS_ERR(resume_bdev)) {
+	if (IS_ERR(hib_resume_bdev)) {
 		pr_debug("PM: Image device not initialised\n");
 		return;
 	}
 
-	blkdev_put(resume_bdev, mode);
+	blkdev_put(hib_resume_bdev, mode);
 }
 
 static int swsusp_header_init(void)
-- 
1.7.0.3


