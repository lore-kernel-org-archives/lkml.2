Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab0FBIyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:54:23 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:59182 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0FBIxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:53:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 7/9] PM / Hibernate: split snapshot_write_next
Date: Wed,  2 Jun 2010 10:52:46 +0200
Message-Id: <1275468768-28229-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading the snapshot, do the initialization and header read in
a separate function. This makes the code more readable and lowers
complexity of snapshot_write_next.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/power.h    |    2 +
 kernel/power/snapshot.c |  100 ++++++++++++++++++++++++++++++-----------------
 kernel/power/swap.c     |   20 ++++------
 3 files changed, 74 insertions(+), 48 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index ff3f63f..6e2e796 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -171,6 +171,8 @@ struct hibernate_io_ops {
 
 extern unsigned int snapshot_additional_pages(struct zone *zone);
 extern unsigned long snapshot_get_image_size(void);
+extern int snapshot_read_init(struct hibernate_io_handle *io_handle,
+		struct snapshot_handle *handle);
 extern int snapshot_write_init(struct hibernate_io_handle *io_handle,
 		struct snapshot_handle *handle);
 extern int snapshot_read_next(struct snapshot_handle *handle);
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 4600d15..9cd6931 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2129,10 +2129,54 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
 }
 
 /**
+ *	snapshot_read_init - initialization before reading the snapshot from
+ *	a backing storage
+ *
+ *	This function *must* be called before snapshot_write_next to initialize
+ *	@handle and read header.
+ *
+ *	@io_handle: io handle used for reading
+ *	@handle: snapshot handle to init
+ */
+int snapshot_read_init(struct hibernate_io_handle *io_handle,
+		struct snapshot_handle *handle)
+{
+	int ret;
+
+	/* This makes the buffer be freed by swsusp_free() */
+	buffer = get_image_page(GFP_ATOMIC, PG_ANY);
+	if (!buffer)
+		return -ENOMEM;
+
+	ret = hib_buffer_init_read(io_handle);
+	if (ret)
+		return ret;
+	ret = hib_buffer_read(io_handle, buffer, sizeof(struct swsusp_info));
+	if (ret)
+		goto finish;
+	hib_buffer_finish_read(io_handle);
+
+	ret = load_header(buffer);
+	if (ret)
+		return ret;
+
+	ret = memory_bm_create(&copy_bm, GFP_ATOMIC, PG_ANY);
+	if (ret)
+		return ret;
+
+	handle->buffer = buffer;
+	handle->sync_read = 1;
+	return 0;
+finish:
+	hib_buffer_finish_read(io_handle);
+	return ret;
+}
+
+/**
  *	snapshot_write_next - used for writing the system memory snapshot.
  *
- *	On the first call to it @handle should point to a zeroed
- *	snapshot_handle structure.  The structure gets updated and a pointer
+ *	Before calling this function, snapshot_read_init has to be called with
+ *	handle passed as @handle here. The structure gets updated and a pointer
  *	to it should be passed to this function every next time.
  *
  *	On success the function returns a positive number.  Then, the caller
@@ -2144,42 +2188,20 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
  *	structure pointed to by @handle is not updated and should not be used
  *	any more.
  */
-
 int snapshot_write_next(struct snapshot_handle *handle)
 {
 	static struct chain_allocator ca;
 	int error = 0;
 
-	/* Check if we have already loaded the entire image */
-	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages)
-		return 0;
-
 	handle->sync_read = 1;
-
-	if (!handle->cur) {
-		if (!buffer)
-			/* This makes the buffer be freed by swsusp_free() */
-			buffer = get_image_page(GFP_ATOMIC, PG_ANY);
-
-		if (!buffer)
-			return -ENOMEM;
-
-		handle->buffer = buffer;
-	} else if (handle->cur == 1) {
-		error = load_header(buffer);
-		if (error)
-			return error;
-
-		error = memory_bm_create(&copy_bm, GFP_ATOMIC, PG_ANY);
-		if (error)
-			return error;
-
-	} else if (handle->cur <= nr_meta_pages + 1) {
+	if (handle->cur < nr_meta_pages) {
 		error = unpack_orig_pfns(buffer, &copy_bm);
 		if (error)
 			return error;
 
-		if (handle->cur == nr_meta_pages + 1) {
+		/* well, this was the last meta page
+		   prepare for ordinary pages */
+		if (handle->cur + 1 == nr_meta_pages) {
 			error = prepare_image(&orig_bm, &copy_bm);
 			if (error)
 				return error;
@@ -2192,16 +2214,22 @@ int snapshot_write_next(struct snapshot_handle *handle)
 			if (IS_ERR(handle->buffer))
 				return PTR_ERR(handle->buffer);
 		}
+		error = PAGE_SIZE;
 	} else {
 		copy_last_highmem_page();
-		handle->buffer = get_buffer(&orig_bm, &ca);
-		if (IS_ERR(handle->buffer))
-			return PTR_ERR(handle->buffer);
-		if (handle->buffer != buffer)
-			handle->sync_read = 0;
+		/* prepare next unless this was the last one */
+		if (handle->cur + 1 < nr_meta_pages + nr_copy_pages) {
+			handle->buffer = get_buffer(&orig_bm, &ca);
+			if (IS_ERR(handle->buffer))
+				return PTR_ERR(handle->buffer);
+			if (handle->buffer != buffer)
+				handle->sync_read = 0;
+			error = PAGE_SIZE;
+		}
 	}
+
 	handle->cur++;
-	return PAGE_SIZE;
+	return error;
 }
 
 /**
@@ -2216,7 +2244,7 @@ void snapshot_write_finalize(struct snapshot_handle *handle)
 {
 	copy_last_highmem_page();
 	/* Free only if we have loaded the image entirely */
-	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages) {
+	if (handle->cur >= nr_meta_pages + nr_copy_pages) {
 		memory_bm_free(&orig_bm, PG_UNSAFE_CLEAR);
 		free_highmem_data();
 	}
@@ -2225,7 +2253,7 @@ void snapshot_write_finalize(struct snapshot_handle *handle)
 int snapshot_image_loaded(struct snapshot_handle *handle)
 {
 	return !(!nr_copy_pages || !last_highmem_page_copied() ||
-			handle->cur <= nr_meta_pages + nr_copy_pages);
+			handle->cur < nr_meta_pages + nr_copy_pages);
 }
 
 #ifdef CONFIG_HIGHMEM
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 9b319f1..f7864bc 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -599,9 +599,6 @@ static int load_image(struct hibernate_io_handle *io_handle,
 	bio = NULL;
 	do_gettimeofday(&start);
 	for ( ; ; ) {
-		error = snapshot_write_next(snapshot);
-		if (error <= 0)
-			break;
 		error = hibernate_io_ops->read_page(io_handle,
 				data_of(*snapshot), &bio);
 		if (error)
@@ -610,9 +607,13 @@ static int load_image(struct hibernate_io_handle *io_handle,
 			error = hib_wait_on_bio_chain(&bio);
 		if (error)
 			break;
+		error = snapshot_write_next(snapshot);
+		if (error >= 0)
+			nr_pages++;
+		if (error <= 0)
+			break;
 		if (!(nr_pages % m))
 			printk("\b\b\b\b%3d%%", nr_pages / m);
-		nr_pages++;
 	}
 	err2 = hib_wait_on_bio_chain(&bio);
 	do_gettimeofday(&stop);
@@ -640,22 +641,17 @@ int swsusp_read(unsigned int *flags_p)
 	int error;
 	struct hibernate_io_handle *io_handle;
 	struct snapshot_handle snapshot;
-	struct swsusp_info *header;
 
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
-	error = snapshot_write_next(&snapshot);
-	if (error < PAGE_SIZE)
-		return error < 0 ? error : -EFAULT;
-	header = (struct swsusp_info *)data_of(snapshot);
 	io_handle = hibernate_io_ops->reader_start(flags_p);
 	if (IS_ERR(io_handle)) {
 		error = PTR_ERR(io_handle);
 		goto end;
 	}
+	error = snapshot_read_init(io_handle, &snapshot);
 	if (!error)
-		error = hibernate_io_ops->read_page(io_handle, header, NULL);
-	if (!error)
-		error = load_image(io_handle, &snapshot, header->pages - 1);
+		error = load_image(io_handle, &snapshot,
+				snapshot_get_image_size()  - 1);
 	hibernate_io_ops->reader_finish(io_handle);
 end:
 	if (!error)
-- 
1.7.1


