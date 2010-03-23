Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0CWQXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:23:54 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51612 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab0CWQXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:23:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC 12/15] PM / Hibernate: split snapshot_read_next
Date: Tue, 23 Mar 2010 17:17:40 +0100
Message-Id: <1269361063-3341-12-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing the snapshot, do the initialization and header write in
a separate function. This makes the code more readable and lowers
complexity of snapshot_read_next.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/power.h    |    1 +
 kernel/power/snapshot.c |   63 +++++++++++++++++++++++++++++-----------------
 kernel/power/swap.c     |   14 +++-------
 3 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 50a888a..638a97c 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -130,6 +130,7 @@ struct sws_module_ops {
 
 extern unsigned int snapshot_additional_pages(struct zone *zone);
 extern unsigned long snapshot_get_image_size(void);
+extern int snapshot_write_init(struct snapshot_handle *handle);
 extern int snapshot_read_next(struct snapshot_handle *handle);
 extern int snapshot_write_next(struct snapshot_handle *handle);
 extern void snapshot_write_finalize(struct snapshot_handle *handle);
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 7918351..c8864de 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1597,10 +1597,44 @@ pack_pfns(unsigned long *buf, struct memory_bitmap *bm)
 }
 
 /**
+ *	snapshot_write_init - initialization before writing the snapshot to
+ *	a backing storage
+ *
+ *	This function *must* be called before snapshot_read_next to initialize
+ *	@handle and write a header.
+ *
+ *	@handle: snapshot handle to init
+ */
+int snapshot_write_init(struct snapshot_handle *handle)
+{
+	int ret;
+
+	/* This makes the buffer be freed by swsusp_free() */
+	buffer = get_image_page(GFP_ATOMIC, PG_ANY);
+	if (!buffer)
+		return -ENOMEM;
+	init_header(buffer);
+	ret = sws_rw_buffer_init(1);
+	if (ret)
+		return ret;
+	ret = sws_rw_buffer(1, buffer, sizeof(struct swsusp_info));
+	if (ret)
+		goto finish;
+	sws_rw_buffer_finish(1);
+	memory_bm_position_reset(&orig_bm);
+	memory_bm_position_reset(&copy_bm);
+	handle->buffer = buffer;
+	return 0;
+finish:
+	sws_rw_buffer_finish(1);
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
@@ -1612,31 +1646,12 @@ pack_pfns(unsigned long *buf, struct memory_bitmap *bm)
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
@@ -1654,6 +1669,8 @@ int snapshot_read_next(struct snapshot_handle *handle)
 		} else {
 			handle->buffer = page_address(page);
 		}
+	} else {
+		return 0;
 	}
 	handle->cur++;
 	return PAGE_SIZE;
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index cc79ed1..1b0ed28 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -434,7 +434,6 @@ static int enough_space(unsigned int nr_pages)
 int swsusp_write(unsigned int flags)
 {
 	struct snapshot_handle snapshot;
-	struct swsusp_info *header;
 	unsigned long pages;
 	int error;
 
@@ -450,17 +449,12 @@ int swsusp_write(unsigned int flags)
 		goto out_finish;
 	}
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
-	error = snapshot_read_next(&snapshot);
-	if (error < PAGE_SIZE) {
-		if (error >= 0)
-			error = -EFAULT;
-
+	error = snapshot_write_init(&snapshot);
+	if (error) {
+		printk(KERN_ERR "PM: Cannot init writer\n");
 		goto out_finish;
 	}
-	header = (struct swsusp_info *)data_of(snapshot);
-	error = sws_io_ops->write_page(header, NULL);
-	if (!error)
-		error = save_image(&snapshot, pages - 1);
+	error = save_image(&snapshot, pages - 1);
 out_finish:
 	error = sws_io_ops->put_writer(flags, error);
 	return error;
-- 
1.7.0.2


