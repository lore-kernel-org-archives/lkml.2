Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0CWQYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:24:50 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51601 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab0CWQXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:23:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC 13/15] PM / Hibernate: split snapshot_write_next
Date: Tue, 23 Mar 2010 17:17:41 +0100
Message-Id: <1269361063-3341-13-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading the snapshot, do the initialization and header read in
a separate function. This makes the code more readable and lowers
complexity of snapshot_write_next.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/power.h    |    1 +
 kernel/power/snapshot.c |   98 +++++++++++++++++++++++++++++-----------------
 kernel/power/swap.c     |   19 +++------
 3 files changed, 70 insertions(+), 48 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 638a97c..842d27b 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -130,6 +130,7 @@ struct sws_module_ops {
 
 extern unsigned int snapshot_additional_pages(struct zone *zone);
 extern unsigned long snapshot_get_image_size(void);
+extern int snapshot_read_init(struct snapshot_handle *handle);
 extern int snapshot_write_init(struct snapshot_handle *handle);
 extern int snapshot_read_next(struct snapshot_handle *handle);
 extern int snapshot_write_next(struct snapshot_handle *handle);
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index c8864de..d432e87 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2126,10 +2126,52 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
 }
 
 /**
+ *	snapshot_read_init - initialization before reading the snapshot from
+ *	a backing storage
+ *
+ *	This function *must* be called before snapshot_write_next to initialize
+ *	@handle and read header.
+ *
+ *	@handle: snapshot handle to init
+ */
+int snapshot_read_init(struct snapshot_handle *handle)
+{
+	int ret;
+
+	/* This makes the buffer be freed by swsusp_free() */
+	buffer = get_image_page(GFP_ATOMIC, PG_ANY);
+	if (!buffer)
+		return -ENOMEM;
+
+	ret = sws_rw_buffer_init(0);
+	if (ret)
+		return ret;
+	ret = sws_rw_buffer(0, buffer, sizeof(struct swsusp_info));
+	if (ret)
+		goto finish;
+	sws_rw_buffer_finish(0);
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
+	sws_rw_buffer_finish(0);
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
@@ -2141,42 +2183,20 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
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
@@ -2189,16 +2209,22 @@ int snapshot_write_next(struct snapshot_handle *handle)
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
@@ -2213,7 +2239,7 @@ void snapshot_write_finalize(struct snapshot_handle *handle)
 {
 	copy_last_highmem_page();
 	/* Free only if we have loaded the image entirely */
-	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages) {
+	if (handle->cur >= nr_meta_pages + nr_copy_pages) {
 		memory_bm_free(&orig_bm, PG_UNSAFE_CLEAR);
 		free_highmem_data();
 	}
@@ -2222,7 +2248,7 @@ void snapshot_write_finalize(struct snapshot_handle *handle)
 int snapshot_image_loaded(struct snapshot_handle *handle)
 {
 	return !(!nr_copy_pages || !last_highmem_page_copied() ||
-			handle->cur <= nr_meta_pages + nr_copy_pages);
+			handle->cur < nr_meta_pages + nr_copy_pages);
 }
 
 #ifdef CONFIG_HIGHMEM
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 1b0ed28..4472cf3 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -570,9 +570,6 @@ static int load_image(struct snapshot_handle *snapshot, unsigned int nr_to_read)
 	bio = NULL;
 	do_gettimeofday(&start);
 	for ( ; ; ) {
-		error = snapshot_write_next(snapshot);
-		if (error <= 0)
-			break;
 		error = sws_io_ops->read_page(data_of(*snapshot), &bio);
 		if (error)
 			break;
@@ -580,9 +577,13 @@ static int load_image(struct snapshot_handle *snapshot, unsigned int nr_to_read)
 			error = sws_wait_on_bio_chain(&bio);
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
 	err2 = sws_wait_on_bio_chain(&bio);
 	do_gettimeofday(&stop);
@@ -609,20 +610,14 @@ int swsusp_read(unsigned int *flags_p)
 {
 	int error;
 	struct snapshot_handle snapshot;
-	struct swsusp_info *header;
 
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
-	error = snapshot_write_next(&snapshot);
-	if (error < PAGE_SIZE)
-		return error < 0 ? error : -EFAULT;
-	header = (struct swsusp_info *)data_of(snapshot);
 	error = sws_io_ops->get_reader(flags_p);
 	if (error)
 		goto end;
+	error = snapshot_read_init(&snapshot);
 	if (!error)
-		error = sws_io_ops->read_page(header, NULL);
-	if (!error)
-		error = load_image(&snapshot, header->pages - 1);
+		error = load_image(&snapshot, snapshot_get_image_size() - 1);
 	sws_io_ops->put_reader();
 end:
 	if (!error)
-- 
1.7.0.2


