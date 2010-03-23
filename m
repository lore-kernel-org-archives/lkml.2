Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0CWQXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:23:25 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51607 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab0CWQXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:23:22 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC 15/15] PM / Hibernate: move non-swap code to snapshot.c
Date: Tue, 23 Mar 2010 17:17:43 +0100
Message-Id: <1269361063-3341-15-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, when all the swap-independent code was separated, it's time to
move it into snapshot.c, because it is snapshot related.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/power.h    |    7 --
 kernel/power/snapshot.c |  196 +++++++++++++++++++++++++++++++++++++++++++++--
 kernel/power/swap.c     |  182 -------------------------------------------
 3 files changed, 189 insertions(+), 196 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index cf1450f..29c450a 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -128,14 +128,7 @@ struct sws_module_ops {
 	int (*write_page)(void *addr, struct bio **bio_chain);
 };
 
-extern unsigned int snapshot_additional_pages(struct zone *zone);
 extern unsigned long snapshot_get_image_size(void);
-extern int snapshot_read_init(struct snapshot_handle *handle);
-extern int snapshot_write_init(struct snapshot_handle *handle);
-extern int snapshot_read_next(struct snapshot_handle *handle);
-extern int snapshot_write_next(struct snapshot_handle *handle);
-extern void snapshot_write_finalize(struct snapshot_handle *handle);
-extern int snapshot_image_loaded(struct snapshot_handle *handle);
 
 /* If unset, the snapshot device cannot be open. */
 extern atomic_t snapshot_device_available;
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d432e87..a8a28da 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -789,7 +789,7 @@ void free_basic_memory_bitmaps(void)
  *	zone (usually the returned value is greater than the exact number)
  */
 
-unsigned int snapshot_additional_pages(struct zone *zone)
+static unsigned int snapshot_additional_pages(struct zone *zone)
 {
 	unsigned int res;
 
@@ -1605,7 +1605,7 @@ pack_pfns(unsigned long *buf, struct memory_bitmap *bm)
  *
  *	@handle: snapshot handle to init
  */
-int snapshot_write_init(struct snapshot_handle *handle)
+static int snapshot_write_init(struct snapshot_handle *handle)
 {
 	int ret;
 
@@ -1646,7 +1646,7 @@ finish:
  *	structure pointed to by @handle is not updated and should not be used
  *	any more.
  */
-int snapshot_read_next(struct snapshot_handle *handle)
+static int snapshot_read_next(struct snapshot_handle *handle)
 {
 	if (handle->cur < nr_meta_pages) {
 		memset(buffer, 0, PAGE_SIZE);
@@ -2134,7 +2134,7 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
  *
  *	@handle: snapshot handle to init
  */
-int snapshot_read_init(struct snapshot_handle *handle)
+static int snapshot_read_init(struct snapshot_handle *handle)
 {
 	int ret;
 
@@ -2183,7 +2183,7 @@ finish:
  *	structure pointed to by @handle is not updated and should not be used
  *	any more.
  */
-int snapshot_write_next(struct snapshot_handle *handle)
+static int snapshot_write_next(struct snapshot_handle *handle)
 {
 	static struct chain_allocator ca;
 	int error = 0;
@@ -2235,7 +2235,7 @@ int snapshot_write_next(struct snapshot_handle *handle)
  *	used any more.
  */
 
-void snapshot_write_finalize(struct snapshot_handle *handle)
+static void snapshot_write_finalize(struct snapshot_handle *handle)
 {
 	copy_last_highmem_page();
 	/* Free only if we have loaded the image entirely */
@@ -2245,12 +2245,194 @@ void snapshot_write_finalize(struct snapshot_handle *handle)
 	}
 }
 
-int snapshot_image_loaded(struct snapshot_handle *handle)
+static int snapshot_image_loaded(struct snapshot_handle *handle)
 {
 	return !(!nr_copy_pages || !last_highmem_page_copied() ||
 			handle->cur < nr_meta_pages + nr_copy_pages);
 }
 
+/**
+ *	save_image - save the suspend image data
+ */
+
+static int save_image(struct snapshot_handle *snapshot,
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
+		ret = sws_io_ops->write_page(data_of(*snapshot), &bio);
+		if (ret)
+			break;
+		if (!(nr_pages % m))
+			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
+		nr_pages++;
+	}
+	err2 = sws_wait_on_bio_chain(&bio);
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
+
+static int enough_space(unsigned int nr_pages)
+{
+	unsigned int free_pages = sws_io_ops->storage_available();
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
+
+int swsusp_write(unsigned int flags)
+{
+	struct snapshot_handle snapshot;
+	unsigned long pages;
+	int error;
+
+	pages = snapshot_get_image_size();
+	error = sws_io_ops->get_writer();
+	if (error) {
+		printk(KERN_ERR "PM: Cannot get swap writer\n");
+		return error;
+	}
+	if (!enough_space(pages)) {
+		printk(KERN_ERR "PM: Not enough free space for image\n");
+		error = -ENOSPC;
+		goto out_finish;
+	}
+	memset(&snapshot, 0, sizeof(struct snapshot_handle));
+	error = snapshot_write_init(&snapshot);
+	if (error) {
+		printk(KERN_ERR "PM: Cannot init writer\n");
+		goto out_finish;
+	}
+	error = save_image(&snapshot, pages - 1);
+out_finish:
+	error = sws_io_ops->put_writer(flags, error);
+	return error;
+}
+
+/**
+ *	load_image - load the image
+ *	@handle and the snapshot handle @snapshot
+ *	(assume there are @nr_pages pages to load)
+ */
+
+static int load_image(struct snapshot_handle *snapshot, unsigned int nr_to_read)
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
+		error = sws_io_ops->read_page(data_of(*snapshot), &bio);
+		if (error)
+			break;
+		if (snapshot->sync_read)
+			error = sws_wait_on_bio_chain(&bio);
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
+	err2 = sws_wait_on_bio_chain(&bio);
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
+
+int swsusp_read(unsigned int *flags_p)
+{
+	int error;
+	struct snapshot_handle snapshot;
+
+	memset(&snapshot, 0, sizeof(struct snapshot_handle));
+	error = sws_io_ops->get_reader(flags_p);
+	if (error)
+		goto end;
+	error = snapshot_read_init(&snapshot);
+	if (!error)
+		error = load_image(&snapshot, snapshot_get_image_size() - 1);
+	sws_io_ops->put_reader();
+end:
+	if (!error)
+		pr_debug("PM: Image successfully loaded\n");
+	else
+		pr_debug("PM: Error %d resuming\n", error);
+	return error;
+}
+
 #ifdef CONFIG_HIGHMEM
 /* Assumes that @buf is ready and points to a "safe" page */
 static inline void
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 4472cf3..ddd7238 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -360,106 +360,6 @@ static int put_swap_writer(unsigned int flags, int error)
 	return error;
 }
 
-/**
- *	save_image - save the suspend image data
- */
-
-static int save_image(struct snapshot_handle *snapshot,
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
-		ret = sws_io_ops->write_page(data_of(*snapshot), &bio);
-		if (ret)
-			break;
-		if (!(nr_pages % m))
-			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
-		nr_pages++;
-	}
-	err2 = sws_wait_on_bio_chain(&bio);
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
-	unsigned int free_pages = sws_io_ops->storage_available();
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
-	struct snapshot_handle snapshot;
-	unsigned long pages;
-	int error;
-
-	pages = snapshot_get_image_size();
-	error = sws_io_ops->get_writer();
-	if (error) {
-		printk(KERN_ERR "PM: Cannot get swap writer\n");
-		return error;
-	}
-	if (!enough_space(pages)) {
-		printk(KERN_ERR "PM: Not enough free space for image\n");
-		error = -ENOSPC;
-		goto out_finish;
-	}
-	memset(&snapshot, 0, sizeof(struct snapshot_handle));
-	error = snapshot_write_init(&snapshot);
-	if (error) {
-		printk(KERN_ERR "PM: Cannot init writer\n");
-		goto out_finish;
-	}
-	error = save_image(&snapshot, pages - 1);
-out_finish:
-	error = sws_io_ops->put_writer(flags, error);
-	return error;
-}
-
 static unsigned long swap_storage_available(void)
 {
 	return count_swap_pages(root_swap, 1);
@@ -546,88 +446,6 @@ struct sws_module_ops swap_ops = {
 };
 
 /**
- *	load_image - load the image
- *	@handle and the snapshot handle @snapshot
- *	(assume there are @nr_pages pages to load)
- */
-
-static int load_image(struct snapshot_handle *snapshot, unsigned int nr_to_read)
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
-		error = sws_io_ops->read_page(data_of(*snapshot), &bio);
-		if (error)
-			break;
-		if (snapshot->sync_read)
-			error = sws_wait_on_bio_chain(&bio);
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
-	err2 = sws_wait_on_bio_chain(&bio);
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
-	struct snapshot_handle snapshot;
-
-	memset(&snapshot, 0, sizeof(struct snapshot_handle));
-	error = sws_io_ops->get_reader(flags_p);
-	if (error)
-		goto end;
-	error = snapshot_read_init(&snapshot);
-	if (!error)
-		error = load_image(&snapshot, snapshot_get_image_size() - 1);
-	sws_io_ops->put_reader();
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
1.7.0.2


