Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab0FBIxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:53:30 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:59196 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab0FBIx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:53:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 2/9] PM / Hibernate: add hibernate_io_ops
Date: Wed,  2 Jun 2010 10:52:41 +0200
Message-Id: <1275468768-28229-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a centralized structure for actually used reader/writer. It
contains basic operations called from snapshot layer which doesn't
need to know who reads/writes the image right now -- this is
specified by current set of functions stored in hibernate_io_ops.

In other words there are more than one hibernate_io_ops which
contain different set of functions. E.g. one is for swap, one for
userspace (user.c) handler.

For now they will hold only swap operations. In next patches, user
support will be converted to ops as well to have a single layer which
allows easier transitions later.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/hibernate.c |    2 +
 kernel/power/power.h     |   27 +++++++++++++++++++++
 kernel/power/swap.c      |   57 ++++++++++++++++++++++++++++++---------------
 3 files changed, 67 insertions(+), 19 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index aa9e916..7d38e6a 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -35,6 +35,8 @@ dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
 int in_suspend __nosavedata = 0;
 
+struct hibernate_io_ops *hibernate_io_ops;
+
 enum {
 	HIBERNATION_INVALID,
 	HIBERNATION_PLATFORM,
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 7427d54..32a40f9 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -139,6 +139,31 @@ static inline struct hibernate_io_handle *hib_io_handle_alloc(size_t priv_size)
 	return ret;
 }
 
+/**
+ * struct hibernate_io_ops - functions of a hibernation module
+ *
+ * @free_space: hom much space is available for the image
+ * @reader_start: initialize an image reader
+ * @reader_finish: deinitialize the reader
+ * @writer_start: initialize an image writer
+ * @writer_finish: deinitialize the writer
+ * @read_page: read an image page from a backing store
+ * @write_page: write an image page to a backing store
+ */
+struct hibernate_io_ops {
+	unsigned long (*free_space)(void);
+
+	struct hibernate_io_handle *(*reader_start)(unsigned int *flags_p);
+	int (*reader_finish)(struct hibernate_io_handle *io_handle);
+	struct hibernate_io_handle *(*writer_start)(void);
+	int (*writer_finish)(struct hibernate_io_handle *io_handle,
+			unsigned int flags, int error);
+	int (*read_page)(struct hibernate_io_handle *io_handle, void *addr,
+			struct bio **bio_chain);
+	int (*write_page)(struct hibernate_io_handle *io_handle, void *addr,
+			struct bio **bio_chain);
+};
+
 extern unsigned int snapshot_additional_pages(struct zone *zone);
 extern unsigned long snapshot_get_image_size(void);
 extern int snapshot_read_next(struct snapshot_handle *handle);
@@ -237,6 +262,8 @@ enum {
 
 extern int pm_test_level;
 
+extern struct hibernate_io_ops *hibernate_io_ops;
+
 #ifdef CONFIG_SUSPEND_FREEZER
 static inline int suspend_freeze_processes(void)
 {
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 7096d20..f09494e 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -268,7 +268,7 @@ static void release_swap_writer(struct swap_map_handle *handle)
 	handle->cur = NULL;
 }
 
-static struct hibernate_io_handle *get_swap_writer(void)
+static struct hibernate_io_handle *swap_writer_start(void)
 {
 	struct hibernate_io_handle *io_handle;
 	struct swap_map_handle *handle;
@@ -399,7 +399,8 @@ static int save_image(struct hibernate_io_handle *io_handle,
 		ret = snapshot_read_next(snapshot);
 		if (ret <= 0)
 			break;
-		ret = swap_write_page(io_handle, data_of(*snapshot), &bio);
+		ret = hibernate_io_ops->write_page(io_handle,
+				data_of(*snapshot), &bio);
 		if (ret)
 			break;
 		if (!(nr_pages % m))
@@ -419,18 +420,18 @@ static int save_image(struct hibernate_io_handle *io_handle,
 }
 
 /**
- *	enough_swap - Make sure we have enough swap to save the image.
+ *	enough_space - Make sure we have enough space to save the image.
  *
- *	Returns TRUE or FALSE after checking the total amount of swap
- *	space avaiable from the resume partition.
+ *	Returns TRUE or FALSE after checking the total amount of
+ *	space avaiable from the resume block.
  */
 
-static int enough_swap(unsigned int nr_pages)
+static int enough_space(unsigned int nr_pages)
 {
-	unsigned int free_swap = count_swap_pages(root_swap, 1);
+	unsigned int free_pages = hibernate_io_ops->free_space();
 
-	pr_debug("PM: Free swap pages: %u\n", free_swap);
-	return free_swap > nr_pages + PAGES_FOR_IO;
+	pr_debug("PM: Free storage pages: %u\n", free_pages);
+	return free_pages > nr_pages + PAGES_FOR_IO;
 }
 
 /**
@@ -452,13 +453,13 @@ int swsusp_write(unsigned int flags)
 	int error;
 
 	pages = snapshot_get_image_size();
-	io_handle = get_swap_writer();
+	io_handle = hibernate_io_ops->writer_start();
 	if (IS_ERR(io_handle)) {
 		printk(KERN_ERR "PM: Cannot get swap writer\n");
 		return PTR_ERR(io_handle);
 	}
-	if (!enough_swap(pages)) {
-		printk(KERN_ERR "PM: Not enough free swap\n");
+	if (!enough_space(pages)) {
+		printk(KERN_ERR "PM: Not enough free space for image\n");
 		error = -ENOSPC;
 		goto out_finish;
 	}
@@ -471,14 +472,19 @@ int swsusp_write(unsigned int flags)
 		goto out_finish;
 	}
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = swap_write_page(io_handle, header, NULL);
+	error = hibernate_io_ops->write_page(io_handle, header, NULL);
 	if (!error)
 		error = save_image(io_handle, &snapshot, pages - 1);
 out_finish:
-	error = swap_writer_finish(io_handle, flags, error);
+	error = hibernate_io_ops->writer_finish(io_handle, flags, error);
 	return error;
 }
 
+static unsigned long swap_free_space(void)
+{
+	return count_swap_pages(root_swap, 1);
+}
+
 /**
  *	The following functions allow us to read data using a swap map
  *	in a file-alike way
@@ -491,7 +497,7 @@ static void release_swap_reader(struct swap_map_handle *handle)
 	handle->cur = NULL;
 }
 
-static struct hibernate_io_handle *get_swap_reader(unsigned int *flags_p)
+static struct hibernate_io_handle *swap_reader_start(unsigned int *flags_p)
 {
 	struct hibernate_io_handle *io_handle;
 	struct swap_map_handle *handle;
@@ -561,6 +567,17 @@ static int swap_reader_finish(struct hibernate_io_handle *io_handle)
 	return 0;
 }
 
+struct hibernate_io_ops swap_ops = {
+	.free_space = swap_free_space,
+
+	.reader_start = swap_reader_start,
+	.reader_finish = swap_reader_finish,
+	.writer_start = swap_writer_start,
+	.writer_finish = swap_writer_finish,
+	.read_page = swap_read_page,
+	.write_page = swap_write_page,
+};
+
 /**
  *	load_image - load the image
  *	@handle and the snapshot handle @snapshot
@@ -591,7 +608,8 @@ static int load_image(struct hibernate_io_handle *io_handle,
 		error = snapshot_write_next(snapshot);
 		if (error <= 0)
 			break;
-		error = swap_read_page(io_handle, data_of(*snapshot), &bio);
+		error = hibernate_io_ops->read_page(io_handle,
+				data_of(*snapshot), &bio);
 		if (error)
 			break;
 		if (snapshot->sync_read)
@@ -635,16 +653,16 @@ int swsusp_read(unsigned int *flags_p)
 	if (error < PAGE_SIZE)
 		return error < 0 ? error : -EFAULT;
 	header = (struct swsusp_info *)data_of(snapshot);
-	io_handle = get_swap_reader(flags_p);
+	io_handle = hibernate_io_ops->reader_start(flags_p);
 	if (IS_ERR(io_handle)) {
 		error = PTR_ERR(io_handle);
 		goto end;
 	}
 	if (!error)
-		error = swap_read_page(io_handle, header, NULL);
+		error = hibernate_io_ops->read_page(io_handle, header, NULL);
 	if (!error)
 		error = load_image(io_handle, &snapshot, header->pages - 1);
-	swap_reader_finish(io_handle);
+	hibernate_io_ops->reader_finish(io_handle);
 end:
 	if (!error)
 		pr_debug("PM: Image successfully loaded\n");
@@ -713,6 +731,7 @@ static int swsusp_header_init(void)
 	swsusp_header = (struct swsusp_header*) __get_free_page(GFP_KERNEL);
 	if (!swsusp_header)
 		panic("Could not allocate memory for swsusp_header\n");
+	hibernate_io_ops = &swap_ops;
 	return 0;
 }
 
-- 
1.7.1


