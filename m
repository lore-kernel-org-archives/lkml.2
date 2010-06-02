Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab0FBIyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:54:25 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:59181 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab0FBIxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:53:19 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 9/9] PM / Hibernate: move non-swap code to image.c
Date: Wed,  2 Jun 2010 10:52:48 +0200
Message-Id: <1275468768-28229-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, when all the swap-independent code was separated, it's time to
move it into a separate file called image.c. Although snapshot.c is
image related too, we want to move the snapshot.c code to mm/,
because it is rather a memory management so that mm people won't
forget about hibernation. Hence we don't pollute snapshot.c with
image processing here.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/Makefile   |    2 +-
 kernel/power/image.c    |  204 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/power.h    |    1 -
 kernel/power/snapshot.c |    2 +-
 kernel/power/swap.c     |  192 --------------------------------------------
 5 files changed, 206 insertions(+), 195 deletions(-)
 create mode 100644 kernel/power/image.c

diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 524e058..c8f26f0 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
-				   block_io.o
+				   block_io.o image.o
 obj-$(CONFIG_HIBERNATION_NVS)	+= hibernate_nvs.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
diff --git a/kernel/power/image.c b/kernel/power/image.c
new file mode 100644
index 0000000..7ebed6b
--- /dev/null
+++ b/kernel/power/image.c
@@ -0,0 +1,204 @@
+/*
+ * kernel/power/image.c
+ *
+ * This file provides functions for reading and writing the suspend image.
+ * It is independent of readers/writers (e.g. swap).
+ *
+ * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/time.h>
+
+#include "power.h"
+
+/**
+ *	save_image - save the suspend image data
+ */
+static int save_image(struct hibernate_io_handle *io_handle,
+		      struct snapshot_handle *snapshot,
+                      unsigned int nr_to_write)
+{
+	unsigned int m;
+	int ret;
+	int nr_pages;
+	int err2;
+	struct bio *bio;
+	struct timeval start;
+	struct timeval stop;
+
+	printk(KERN_INFO "PM: Saving image data pages (%u pages) ...     ",
+		nr_to_write);
+	m = nr_to_write / 100;
+	if (!m)
+		m = 1;
+	nr_pages = 0;
+	bio = NULL;
+	do_gettimeofday(&start);
+	while (1) {
+		ret = snapshot_read_next(snapshot);
+		if (ret <= 0)
+			break;
+		ret = hibernate_io_ops->write_page(io_handle,
+				data_of(*snapshot), &bio);
+		if (ret)
+			break;
+		if (!(nr_pages % m))
+			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
+		nr_pages++;
+	}
+	err2 = hib_wait_on_bio_chain(&bio);
+	do_gettimeofday(&stop);
+	if (!ret)
+		ret = err2;
+	if (!ret)
+		printk(KERN_CONT "\b\b\b\bdone\n");
+	else
+		printk(KERN_CONT "\n");
+	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
+	return ret;
+}
+
+/**
+ *	enough_space - Make sure we have enough space to save the image.
+ *
+ *	Returns TRUE or FALSE after checking the total amount of
+ *	space avaiable from the resume block.
+ */
+static int enough_space(unsigned int nr_pages)
+{
+	unsigned int free_pages = hibernate_io_ops->free_space();
+
+	pr_debug("PM: Free storage pages: %u\n", free_pages);
+	return free_pages > nr_pages + PAGES_FOR_IO;
+}
+
+/**
+ *	swsusp_write - Write entire image and metadata.
+ *	@flags: flags to pass to the "boot" kernel in the image header
+ *
+ *	It is important _NOT_ to umount filesystems at this point. We want
+ *	them synced (in case something goes wrong) but we DO not want to mark
+ *	filesystem clean: it is not. (And it does not matter, if we resume
+ *	correctly, we'll mark system clean, anyway.)
+ */
+int swsusp_write(unsigned int flags)
+{
+	struct hibernate_io_handle *io_handle;
+	struct snapshot_handle snapshot;
+	unsigned long pages;
+	int error;
+
+	pages = snapshot_get_image_size();
+	io_handle = hibernate_io_ops->writer_start();
+	if (IS_ERR(io_handle)) {
+		printk(KERN_ERR "PM: Cannot get swap writer\n");
+		return PTR_ERR(io_handle);
+	}
+	if (!enough_space(pages)) {
+		printk(KERN_ERR "PM: Not enough free space for image\n");
+		error = -ENOSPC;
+		goto out_finish;
+	}
+	memset(&snapshot, 0, sizeof(struct snapshot_handle));
+	error = snapshot_write_init(io_handle, &snapshot);
+	if (error) {
+		printk(KERN_ERR "PM: Cannot init writer\n");
+		goto out_finish;
+	}
+	error = save_image(io_handle, &snapshot, pages - 1);
+out_finish:
+	error = hibernate_io_ops->writer_finish(io_handle, flags, error);
+	return error;
+}
+
+/**
+ *	load_image - load the image
+ *	@handle and the snapshot handle @snapshot
+ *	(assume there are @nr_pages pages to load)
+ */
+static int load_image(struct hibernate_io_handle *io_handle,
+		      struct snapshot_handle *snapshot,
+		      unsigned int nr_to_read)
+{
+	unsigned int m;
+	int error = 0;
+	struct timeval start;
+	struct timeval stop;
+	struct bio *bio;
+	int err2;
+	unsigned nr_pages;
+
+	printk(KERN_INFO "PM: Loading image data pages (%u pages) ...     ",
+		nr_to_read);
+	m = nr_to_read / 100;
+	if (!m)
+		m = 1;
+	nr_pages = 0;
+	bio = NULL;
+	do_gettimeofday(&start);
+	for ( ; ; ) {
+		error = hibernate_io_ops->read_page(io_handle,
+				data_of(*snapshot), &bio);
+		if (error)
+			break;
+		if (snapshot->sync_read)
+			error = hib_wait_on_bio_chain(&bio);
+		if (error)
+			break;
+		error = snapshot_write_next(snapshot);
+		if (error >= 0)
+			nr_pages++;
+		if (error <= 0)
+			break;
+		if (!(nr_pages % m))
+			printk("\b\b\b\b%3d%%", nr_pages / m);
+	}
+	err2 = hib_wait_on_bio_chain(&bio);
+	do_gettimeofday(&stop);
+	if (!error)
+		error = err2;
+	if (!error) {
+		printk("\b\b\b\bdone\n");
+		snapshot_write_finalize(snapshot);
+		if (!snapshot_image_loaded(snapshot))
+			error = -ENODATA;
+	} else
+		printk("\n");
+	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
+	return error;
+}
+
+/**
+ *	swsusp_read - read the hibernation image.
+ *	@flags_p: flags passed by the "frozen" kernel in the image header should
+ *		  be written into this memeory location
+ */
+int swsusp_read(unsigned int *flags_p)
+{
+	int error;
+	struct hibernate_io_handle *io_handle;
+	struct snapshot_handle snapshot;
+
+	memset(&snapshot, 0, sizeof(struct snapshot_handle));
+	io_handle = hibernate_io_ops->reader_start(flags_p);
+	if (IS_ERR(io_handle)) {
+		error = PTR_ERR(io_handle);
+		goto end;
+	}
+	error = snapshot_read_init(io_handle, &snapshot);
+	if (!error)
+		error = load_image(io_handle, &snapshot,
+				snapshot_get_image_size()  - 1);
+	hibernate_io_ops->reader_finish(io_handle);
+end:
+	if (!error)
+		pr_debug("PM: Image successfully loaded\n");
+	else
+		pr_debug("PM: Error %d resuming\n", error);
+	return error;
+}
+
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 1fdbfe7..ad42a0f 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -169,7 +169,6 @@ struct hibernate_io_ops {
 			struct bio **bio_chain);
 };
 
-extern unsigned int snapshot_additional_pages(struct zone *zone);
 extern unsigned long snapshot_get_image_size(void);
 extern int snapshot_read_init(struct hibernate_io_handle *io_handle,
 		struct snapshot_handle *handle);
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 9cd6931..f898820 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -790,7 +790,7 @@ void free_basic_memory_bitmaps(void)
  *	zone (usually the returned value is greater than the exact number)
  */
 
-unsigned int snapshot_additional_pages(struct zone *zone)
+static unsigned int snapshot_additional_pages(struct zone *zone)
 {
 	unsigned int res;
 
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index f7864bc..585d460 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -371,109 +371,6 @@ static int swap_writer_finish(struct hibernate_io_handle *io_handle,
 	return error;
 }
 
-/**
- *	save_image - save the suspend image data
- */
-
-static int save_image(struct hibernate_io_handle *io_handle,
-		      struct snapshot_handle *snapshot,
-                      unsigned int nr_to_write)
-{
-	unsigned int m;
-	int ret;
-	int nr_pages;
-	int err2;
-	struct bio *bio;
-	struct timeval start;
-	struct timeval stop;
-
-	printk(KERN_INFO "PM: Saving image data pages (%u pages) ...     ",
-		nr_to_write);
-	m = nr_to_write / 100;
-	if (!m)
-		m = 1;
-	nr_pages = 0;
-	bio = NULL;
-	do_gettimeofday(&start);
-	while (1) {
-		ret = snapshot_read_next(snapshot);
-		if (ret <= 0)
-			break;
-		ret = hibernate_io_ops->write_page(io_handle,
-				data_of(*snapshot), &bio);
-		if (ret)
-			break;
-		if (!(nr_pages % m))
-			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
-		nr_pages++;
-	}
-	err2 = hib_wait_on_bio_chain(&bio);
-	do_gettimeofday(&stop);
-	if (!ret)
-		ret = err2;
-	if (!ret)
-		printk(KERN_CONT "\b\b\b\bdone\n");
-	else
-		printk(KERN_CONT "\n");
-	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
-	return ret;
-}
-
-/**
- *	enough_space - Make sure we have enough space to save the image.
- *
- *	Returns TRUE or FALSE after checking the total amount of
- *	space avaiable from the resume block.
- */
-
-static int enough_space(unsigned int nr_pages)
-{
-	unsigned int free_pages = hibernate_io_ops->free_space();
-
-	pr_debug("PM: Free storage pages: %u\n", free_pages);
-	return free_pages > nr_pages + PAGES_FOR_IO;
-}
-
-/**
- *	swsusp_write - Write entire image and metadata.
- *	@flags: flags to pass to the "boot" kernel in the image header
- *
- *	It is important _NOT_ to umount filesystems at this point. We want
- *	them synced (in case something goes wrong) but we DO not want to mark
- *	filesystem clean: it is not. (And it does not matter, if we resume
- *	correctly, we'll mark system clean, anyway.)
- */
-
-int swsusp_write(unsigned int flags)
-{
-	struct hibernate_io_handle *io_handle;
-	struct snapshot_handle snapshot;
-	unsigned long pages;
-	int error;
-
-	pages = snapshot_get_image_size();
-	io_handle = hibernate_io_ops->writer_start();
-	if (IS_ERR(io_handle)) {
-		printk(KERN_ERR "PM: Cannot get swap writer\n");
-		return PTR_ERR(io_handle);
-	}
-	if (!enough_space(pages)) {
-		printk(KERN_ERR "PM: Not enough free space for image\n");
-		error = -ENOSPC;
-		goto out_finish;
-	}
-	memset(&snapshot, 0, sizeof(struct snapshot_handle));
-	error = snapshot_write_init(io_handle, &snapshot);
-	if (error) {
-		printk(KERN_ERR "PM: Cannot init writer\n");
-		goto out_finish;
-	}
-	error = save_image(io_handle, &snapshot, pages - 1);
-out_finish:
-	error = hibernate_io_ops->writer_finish(io_handle, flags, error);
-	return error;
-}
-
 static unsigned long swap_free_space(void)
 {
 	return count_swap_pages(root_swap, 1);
@@ -573,95 +470,6 @@ struct hibernate_io_ops swap_ops = {
 };
 
 /**
- *	load_image - load the image
- *	@handle and the snapshot handle @snapshot
- *	(assume there are @nr_pages pages to load)
- */
-
-static int load_image(struct hibernate_io_handle *io_handle,
-		      struct snapshot_handle *snapshot,
-		      unsigned int nr_to_read)
-{
-	unsigned int m;
-	int error = 0;
-	struct timeval start;
-	struct timeval stop;
-	struct bio *bio;
-	int err2;
-	unsigned nr_pages;
-
-	printk(KERN_INFO "PM: Loading image data pages (%u pages) ...     ",
-		nr_to_read);
-	m = nr_to_read / 100;
-	if (!m)
-		m = 1;
-	nr_pages = 0;
-	bio = NULL;
-	do_gettimeofday(&start);
-	for ( ; ; ) {
-		error = hibernate_io_ops->read_page(io_handle,
-				data_of(*snapshot), &bio);
-		if (error)
-			break;
-		if (snapshot->sync_read)
-			error = hib_wait_on_bio_chain(&bio);
-		if (error)
-			break;
-		error = snapshot_write_next(snapshot);
-		if (error >= 0)
-			nr_pages++;
-		if (error <= 0)
-			break;
-		if (!(nr_pages % m))
-			printk("\b\b\b\b%3d%%", nr_pages / m);
-	}
-	err2 = hib_wait_on_bio_chain(&bio);
-	do_gettimeofday(&stop);
-	if (!error)
-		error = err2;
-	if (!error) {
-		printk("\b\b\b\bdone\n");
-		snapshot_write_finalize(snapshot);
-		if (!snapshot_image_loaded(snapshot))
-			error = -ENODATA;
-	} else
-		printk("\n");
-	swsusp_show_speed(&start, &stop, nr_to_read, "Read");
-	return error;
-}
-
-/**
- *	swsusp_read - read the hibernation image.
- *	@flags_p: flags passed by the "frozen" kernel in the image header should
- *		  be written into this memeory location
- */
-
-int swsusp_read(unsigned int *flags_p)
-{
-	int error;
-	struct hibernate_io_handle *io_handle;
-	struct snapshot_handle snapshot;
-
-	memset(&snapshot, 0, sizeof(struct snapshot_handle));
-	io_handle = hibernate_io_ops->reader_start(flags_p);
-	if (IS_ERR(io_handle)) {
-		error = PTR_ERR(io_handle);
-		goto end;
-	}
-	error = snapshot_read_init(io_handle, &snapshot);
-	if (!error)
-		error = load_image(io_handle, &snapshot,
-				snapshot_get_image_size()  - 1);
-	hibernate_io_ops->reader_finish(io_handle);
-end:
-	if (!error)
-		pr_debug("PM: Image successfully loaded\n");
-	else
-		pr_debug("PM: Error %d resuming\n", error);
-	return error;
-}
-
-/**
  *      swsusp_check - Check for swsusp signature in the resume device
  */
 
-- 
1.7.1


