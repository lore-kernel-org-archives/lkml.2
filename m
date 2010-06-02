Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab0FBIy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:54:27 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:59180 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0FBIxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:53:19 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 6/9] PM / Hibernate: split snapshot_read_next
Date: Wed,  2 Jun 2010 10:52:45 +0200
Message-Id: <1275468768-28229-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing the snapshot, do the initialization and header write in
a separate function. This makes the code more readable and lowers
complexity of snapshot_read_next.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/power.h    |    2 +
 kernel/power/snapshot.c |   65 ++++++++++++++++++++++++++++++----------------
 kernel/power/swap.c     |   14 +++-------
 3 files changed, 48 insertions(+), 33 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 812b66c..ff3f63f 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -171,6 +171,8 @@ struct hibernate_io_ops {
 
 extern unsigned int snapshot_additional_pages(struct zone *zone);
 extern unsigned long snapshot_get_image_size(void);
+extern int snapshot_write_init(struct hibernate_io_handle *io_handle,
+		struct snapshot_handle *handle);
 extern int snapshot_read_next(struct snapshot_handle *handle);
 extern int snapshot_write_next(struct snapshot_handle *handle);
 extern void snapshot_write_finalize(struct snapshot_handle *handle);
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 25ce010..4600d15 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1598,10 +1598,46 @@ pack_pfns(unsigned long *buf, struct memory_bitmap *bm)
 }
 
 /**
+ *	snapshot_write_init - initialization before writing the snapshot to
+ *	a backing storage
+ *
+ *	This function *must* be called before snapshot_read_next to initialize
+ *	@handle and write a header.
+ *
+ *	@io_handle: handle used when writing the initial info onto storage
+ *	@handle: snapshot handle to init
+ */
+int snapshot_write_init(struct hibernate_io_handle *io_handle,
+		struct snapshot_handle *handle)
+{
+	int ret;
+
+	/* This makes the buffer be freed by swsusp_free() */
+	buffer = get_image_page(GFP_ATOMIC, PG_ANY);
+	if (!buffer)
+		return -ENOMEM;
+	init_header(buffer);
+	ret = hib_buffer_init_write(io_handle);
+	if (ret)
+		return ret;
+	ret = hib_buffer_write(io_handle, buffer, sizeof(struct swsusp_info));
+	if (ret)
+		goto finish;
+	hib_buffer_finish_write(io_handle);
+	memory_bm_position_reset(&orig_bm);
+	memory_bm_position_reset(&copy_bm);
+	handle->buffer = buffer;
+	return 0;
+finish:
+	hib_buffer_finish_write(io_handle);
+	return ret;
+}
+
+/**
  *	snapshot_read_next - used for reading the system memory snapshot.
  *
- *	On the first call to it @handle should point to a zeroed
- *	snapshot_handle structure.  The structure gets updated and a pointer
+ *	Before calling this function, snapshot_write_init has to be called with
+ *	handle passed as @handle here. The structure gets updated and a pointer
  *	to it should be passed to this function every next time.
  *
  *	On success the function returns a positive number.  Then, the caller
@@ -1613,31 +1649,12 @@ pack_pfns(unsigned long *buf, struct memory_bitmap *bm)
  *	structure pointed to by @handle is not updated and should not be used
  *	any more.
  */
-
 int snapshot_read_next(struct snapshot_handle *handle)
 {
-	if (handle->cur > nr_meta_pages + nr_copy_pages)
-		return 0;
-
-	if (!buffer) {
-		/* This makes the buffer be freed by swsusp_free() */
-		buffer = get_image_page(GFP_ATOMIC, PG_ANY);
-		if (!buffer)
-			return -ENOMEM;
-	}
-	if (!handle->cur) {
-		int error;
-
-		error = init_header((struct swsusp_info *)buffer);
-		if (error)
-			return error;
-		handle->buffer = buffer;
-		memory_bm_position_reset(&orig_bm);
-		memory_bm_position_reset(&copy_bm);
-	} else if (handle->cur <= nr_meta_pages) {
+	if (handle->cur < nr_meta_pages) {
 		memset(buffer, 0, PAGE_SIZE);
 		pack_pfns(buffer, &orig_bm);
-	} else {
+	} else if (handle->cur < nr_meta_pages + nr_copy_pages) {
 		struct page *page;
 
 		page = pfn_to_page(memory_bm_next_pfn(&copy_bm));
@@ -1655,6 +1672,8 @@ int snapshot_read_next(struct snapshot_handle *handle)
 		} else {
 			handle->buffer = page_address(page);
 		}
+	} else {
+		return 0;
 	}
 	handle->cur++;
 	return PAGE_SIZE;
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index f09494e..9b319f1 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -448,7 +448,6 @@ int swsusp_write(unsigned int flags)
 {
 	struct hibernate_io_handle *io_handle;
 	struct snapshot_handle snapshot;
-	struct swsusp_info *header;
 	unsigned long pages;
 	int error;
 
@@ -464,17 +463,12 @@ int swsusp_write(unsigned int flags)
 		goto out_finish;
 	}
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
-	error = snapshot_read_next(&snapshot);
-	if (error < PAGE_SIZE) {
-		if (error >= 0)
-			error = -EFAULT;
-
+	error = snapshot_write_init(io_handle, &snapshot);
+	if (error) {
+		printk(KERN_ERR "PM: Cannot init writer\n");
 		goto out_finish;
 	}
-	header = (struct swsusp_info *)data_of(snapshot);
-	error = hibernate_io_ops->write_page(io_handle, header, NULL);
-	if (!error)
-		error = save_image(io_handle, &snapshot, pages - 1);
+	error = save_image(io_handle, &snapshot, pages - 1);
 out_finish:
 	error = hibernate_io_ops->writer_finish(io_handle, flags, error);
 	return error;
-- 
1.7.1


