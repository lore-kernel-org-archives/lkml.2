Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0FBIx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:53:56 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:59198 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab0FBIxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:53:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 1/9] PM / Hibernate: swap, switch to hibernate_io_handle
Date: Wed,  2 Jun 2010 10:52:40 +0200
Message-Id: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I addressed the comments I got on the previous RFC. I left the handles
in place, the functions in hibernate_io_ops now works on them. Further
I got rid of the memory barriers and minimized global variables as much
as possible. Comments welcome.

--

Some code, which will be moved out of swap.c, will know nothing about
swap. There will be also other than swap writers later, so that it
won't make sense at all.

So introduce a new structure called hibernate_io_handle which
currently contains only a pointer to private data, but is independent
on I/O reader/writer actually used. Private data are swap_map_handle
for now.

This structure is allocated in _start and freed in _finish. This will
correspond to the later introduction of hibernate_io_ops where users
will do handle=start->repeat{read/write(handle)}->finish(handle).
I.e. they will operate on handle instead of global variables.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/power.h |   24 ++++++++++
 kernel/power/swap.c  |  114 +++++++++++++++++++++++++++++++------------------
 2 files changed, 96 insertions(+), 42 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 006270f..7427d54 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -1,3 +1,4 @@
+#include <linux/slab.h> /* kzalloc */
 #include <linux/suspend.h>
 #include <linux/suspend_ioctls.h>
 #include <linux/utsname.h>
@@ -115,6 +116,29 @@ struct snapshot_handle {
  */
 #define data_of(handle)	((handle).buffer)
 
+/**
+ * struct hibernate_io_handle - handle for image I/O processing
+ *
+ * @priv: private data for each processor (swap_map_handle etc.)
+ */
+struct hibernate_io_handle {
+	void *priv;
+};
+
+/**
+ * hib_io_handle_alloc - allocate io handle with priv_size for private data
+ *
+ * @priv_size: the sie to allocate behind hibernate_io_handle for private use
+ */
+static inline struct hibernate_io_handle *hib_io_handle_alloc(size_t priv_size)
+{
+	struct hibernate_io_handle *ret;
+	ret = kzalloc(sizeof(*ret) + priv_size, GFP_KERNEL);
+	if (ret)
+		ret->priv = ret + 1;
+	return ret;
+}
+
 extern unsigned int snapshot_additional_pages(struct zone *zone);
 extern unsigned long snapshot_get_image_size(void);
 extern int snapshot_read_next(struct snapshot_handle *handle);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index b0bb217..7096d20 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -268,8 +268,10 @@ static void release_swap_writer(struct swap_map_handle *handle)
 	handle->cur = NULL;
 }
 
-static int get_swap_writer(struct swap_map_handle *handle)
+static struct hibernate_io_handle *get_swap_writer(void)
 {
+	struct hibernate_io_handle *io_handle;
+	struct swap_map_handle *handle;
 	int ret;
 
 	ret = swsusp_swap_check();
@@ -277,12 +279,18 @@ static int get_swap_writer(struct swap_map_handle *handle)
 		if (ret != -ENOSPC)
 			printk(KERN_ERR "PM: Cannot find swap device, try "
 					"swapon -a.\n");
-		return ret;
+		return ERR_PTR(ret);
 	}
+	io_handle = hib_io_handle_alloc(sizeof(*handle));
+	if (!io_handle) {
+		ret = -ENOMEM;
+		goto err_close;
+	}
+	handle = io_handle->priv;
 	handle->cur = (struct swap_map_page *)get_zeroed_page(GFP_KERNEL);
 	if (!handle->cur) {
 		ret = -ENOMEM;
-		goto err_close;
+		goto err_free;
 	}
 	handle->cur_swap = alloc_swapdev_block(root_swap);
 	if (!handle->cur_swap) {
@@ -291,17 +299,20 @@ static int get_swap_writer(struct swap_map_handle *handle)
 	}
 	handle->k = 0;
 	handle->first_sector = handle->cur_swap;
-	return 0;
+	return io_handle;
 err_rel:
 	release_swap_writer(handle);
 err_close:
 	swsusp_close(FMODE_WRITE);
-	return ret;
+err_free:
+	kfree(io_handle);
+	return ERR_PTR(ret);
 }
 
-static int swap_write_page(struct swap_map_handle *handle, void *buf,
-				struct bio **bio_chain)
+static int swap_write_page(struct hibernate_io_handle *io_handle, void *buf,
+		struct bio **bio_chain)
 {
+	struct swap_map_handle *handle = io_handle->priv;
 	int error = 0;
 	sector_t offset;
 
@@ -339,9 +350,11 @@ static int flush_swap_writer(struct swap_map_handle *handle)
 		return -EINVAL;
 }
 
-static int swap_writer_finish(struct swap_map_handle *handle,
+static int swap_writer_finish(struct hibernate_io_handle *io_handle,
 		unsigned int flags, int error)
 {
+	struct swap_map_handle *handle = io_handle->priv;
+
 	if (!error) {
 		flush_swap_writer(handle);
 		printk(KERN_INFO "PM: S");
@@ -352,6 +365,7 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 	if (error)
 		free_all_swap_pages(root_swap);
 	release_swap_writer(handle);
+	kfree(io_handle);
 	swsusp_close(FMODE_WRITE);
 
 	return error;
@@ -361,8 +375,8 @@ static int swap_writer_finish(struct swap_map_handle *handle,
  *	save_image - save the suspend image data
  */
 
-static int save_image(struct swap_map_handle *handle,
-                      struct snapshot_handle *snapshot,
+static int save_image(struct hibernate_io_handle *io_handle,
+		      struct snapshot_handle *snapshot,
                       unsigned int nr_to_write)
 {
 	unsigned int m;
@@ -385,7 +399,7 @@ static int save_image(struct swap_map_handle *handle,
 		ret = snapshot_read_next(snapshot);
 		if (ret <= 0)
 			break;
-		ret = swap_write_page(handle, data_of(*snapshot), &bio);
+		ret = swap_write_page(io_handle, data_of(*snapshot), &bio);
 		if (ret)
 			break;
 		if (!(nr_pages % m))
@@ -431,17 +445,17 @@ static int enough_swap(unsigned int nr_pages)
 
 int swsusp_write(unsigned int flags)
 {
-	struct swap_map_handle handle;
+	struct hibernate_io_handle *io_handle;
 	struct snapshot_handle snapshot;
 	struct swsusp_info *header;
 	unsigned long pages;
 	int error;
 
 	pages = snapshot_get_image_size();
-	error = get_swap_writer(&handle);
-	if (error) {
+	io_handle = get_swap_writer();
+	if (IS_ERR(io_handle)) {
 		printk(KERN_ERR "PM: Cannot get swap writer\n");
-		return error;
+		return PTR_ERR(io_handle);
 	}
 	if (!enough_swap(pages)) {
 		printk(KERN_ERR "PM: Not enough free swap\n");
@@ -457,11 +471,11 @@ int swsusp_write(unsigned int flags)
 		goto out_finish;
 	}
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = swap_write_page(&handle, header, NULL);
+	error = swap_write_page(io_handle, header, NULL);
 	if (!error)
-		error = save_image(&handle, &snapshot, pages - 1);
+		error = save_image(io_handle, &snapshot, pages - 1);
 out_finish:
-	error = swap_writer_finish(&handle, flags, error);
+	error = swap_writer_finish(io_handle, flags, error);
 	return error;
 }
 
@@ -477,32 +491,43 @@ static void release_swap_reader(struct swap_map_handle *handle)
 	handle->cur = NULL;
 }
 
-static int get_swap_reader(struct swap_map_handle *handle,
-		unsigned int *flags_p)
+static struct hibernate_io_handle *get_swap_reader(unsigned int *flags_p)
 {
+	struct hibernate_io_handle *io_handle;
+	struct swap_map_handle *handle;
 	int error;
 
 	*flags_p = swsusp_header->flags;
 
 	if (!swsusp_header->image) /* how can this happen? */
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
+	io_handle = hib_io_handle_alloc(sizeof(*handle));
+	if (!io_handle)
+		return ERR_PTR(-ENOMEM);
+	handle = io_handle->priv;
 	handle->cur = (struct swap_map_page *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
-	if (!handle->cur)
-		return -ENOMEM;
+	if (!handle->cur) {
+		error = -ENOMEM;
+		goto err_free;
+	}
 
 	error = hib_bio_read_page(swsusp_header->image, handle->cur, NULL);
-	if (error) {
-		release_swap_reader(handle);
-		return error;
-	}
+	if (error)
+		goto err_rel;
 	handle->k = 0;
-	return 0;
+	return io_handle;
+err_rel:
+	release_swap_reader(handle);
+err_free:
+	kfree(io_handle);
+	return ERR_PTR(error);
 }
 
-static int swap_read_page(struct swap_map_handle *handle, void *buf,
-				struct bio **bio_chain)
+static int swap_read_page(struct hibernate_io_handle *io_handle, void *buf,
+		struct bio **bio_chain)
 {
+	struct swap_map_handle *handle = io_handle->priv;
 	sector_t offset;
 	int error;
 
@@ -526,22 +551,25 @@ static int swap_read_page(struct swap_map_handle *handle, void *buf,
 	return error;
 }
 
-static int swap_reader_finish(struct swap_map_handle *handle)
+static int swap_reader_finish(struct hibernate_io_handle *io_handle)
 {
+	struct swap_map_handle *handle = io_handle->priv;
+
 	release_swap_reader(handle);
+	kfree(io_handle);
 
 	return 0;
 }
 
 /**
- *	load_image - load the image using the swap map handle
+ *	load_image - load the image
  *	@handle and the snapshot handle @snapshot
  *	(assume there are @nr_pages pages to load)
  */
 
-static int load_image(struct swap_map_handle *handle,
-                      struct snapshot_handle *snapshot,
-                      unsigned int nr_to_read)
+static int load_image(struct hibernate_io_handle *io_handle,
+		      struct snapshot_handle *snapshot,
+		      unsigned int nr_to_read)
 {
 	unsigned int m;
 	int error = 0;
@@ -563,7 +591,7 @@ static int load_image(struct swap_map_handle *handle,
 		error = snapshot_write_next(snapshot);
 		if (error <= 0)
 			break;
-		error = swap_read_page(handle, data_of(*snapshot), &bio);
+		error = swap_read_page(io_handle, data_of(*snapshot), &bio);
 		if (error)
 			break;
 		if (snapshot->sync_read)
@@ -598,7 +626,7 @@ static int load_image(struct swap_map_handle *handle,
 int swsusp_read(unsigned int *flags_p)
 {
 	int error;
-	struct swap_map_handle handle;
+	struct hibernate_io_handle *io_handle;
 	struct snapshot_handle snapshot;
 	struct swsusp_info *header;
 
@@ -607,14 +635,16 @@ int swsusp_read(unsigned int *flags_p)
 	if (error < PAGE_SIZE)
 		return error < 0 ? error : -EFAULT;
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = get_swap_reader(&handle, flags_p);
-	if (error)
+	io_handle = get_swap_reader(flags_p);
+	if (IS_ERR(io_handle)) {
+		error = PTR_ERR(io_handle);
 		goto end;
+	}
 	if (!error)
-		error = swap_read_page(&handle, header, NULL);
+		error = swap_read_page(io_handle, header, NULL);
 	if (!error)
-		error = load_image(&handle, &snapshot, header->pages - 1);
-	swap_reader_finish(&handle);
+		error = load_image(io_handle, &snapshot, header->pages - 1);
+	swap_reader_finish(io_handle);
 end:
 	if (!error)
 		pr_debug("PM: Image successfully loaded\n");
-- 
1.7.1


