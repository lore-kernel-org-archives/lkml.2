Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab0FBIyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:54:21 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:59183 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0FBIxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:53:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rjw@sisk.pl
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 5/9] PM / Hibernate: add chunk i/o support
Date: Wed,  2 Jun 2010 10:52:44 +0200
Message-Id: <1275468768-28229-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chunk support is useful when not writing whole pages at once. It takes
care of joining the buffers into the pages and writing at once when
needed.

This adds functions for both reads and writes.

In the end when pages are compressed they use this interface as well
(because they are indeed shorter than PAGE_SIZE).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/block_io.c |  126 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/power.h    |   16 ++++++
 2 files changed, 142 insertions(+), 0 deletions(-)

diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index 97024fd..5b6413d 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@ucw.cz>
  * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
+ * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)
  *
  * This file is released under the GPLv2.
  */
@@ -74,6 +75,131 @@ int hib_bio_write_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
 			virt_to_page(addr), bio_chain);
 }
 
+static int hib_buffer_init_rw(struct hibernate_io_handle *io_handle,
+		int writing)
+{
+	/* should never happen - it means we didn't finish properly last time */
+	BUG_ON(io_handle->chunk_buffer || io_handle->chunk_buffer_pos);
+
+	io_handle->chunk_buffer =
+		(void *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
+	if (io_handle->chunk_buffer && !writing)
+		io_handle->chunk_buffer_pos = PAGE_SIZE;
+
+	return io_handle->chunk_buffer ? 0 : -ENOMEM;
+}
+
+int hib_buffer_init_read(struct hibernate_io_handle *io_handle)
+{
+	return hib_buffer_init_rw(io_handle, 0);
+}
+
+int hib_buffer_init_write(struct hibernate_io_handle *io_handle)
+{
+	return hib_buffer_init_rw(io_handle, 1);
+}
+
+/**
+ * hib_buffer_rw - combine smaller buffers into PAGE_SIZE I/O
+ * @io_handle: handle from reader/writer
+ * @writing: whether writing (or reading).
+ * @buffer: the start of the buffer to write or fill.
+ * @buffer_size: the size of the buffer to write or fill.
+ **/
+static int hib_buffer_rw(struct hibernate_io_handle *io_handle, int writing,
+		char *buffer, int buffer_size)
+{
+	int bytes_left = buffer_size, ret;
+
+	while (bytes_left) {
+		char *source_start = buffer + buffer_size - bytes_left;
+		char *dest_start = io_handle->chunk_buffer +
+			io_handle->chunk_buffer_pos;
+		int capacity = PAGE_SIZE - io_handle->chunk_buffer_pos;
+		char *to = writing ? dest_start : source_start;
+		char *from = writing ? source_start : dest_start;
+
+		if (bytes_left <= capacity) {
+			memcpy(to, from, bytes_left);
+			io_handle->chunk_buffer_pos += bytes_left;
+			return 0;
+		}
+
+		/* Complete this page and start a new one */
+		memcpy(to, from, capacity);
+		bytes_left -= capacity;
+
+		if (writing)
+			ret = hibernate_io_ops->write_page(io_handle,
+					io_handle->chunk_buffer, NULL);
+		else
+			ret = hibernate_io_ops->read_page(io_handle,
+					io_handle->chunk_buffer, NULL);
+
+		if (ret)
+			return ret;
+
+		io_handle->chunk_buffer_pos = 0;
+	}
+
+	return 0;
+}
+
+int hib_buffer_read(struct hibernate_io_handle *io_handle, char *buffer,
+		int buffer_size)
+{
+	return hib_buffer_rw(io_handle, 0, buffer, buffer_size);
+}
+
+int hib_buffer_write(struct hibernate_io_handle *io_handle, char *buffer,
+		int buffer_size)
+{
+	return hib_buffer_rw(io_handle, 1, buffer, buffer_size);
+}
+
+int hib_buffer_flush_page_read(struct hibernate_io_handle *io_handle)
+{
+	io_handle->chunk_buffer_pos = PAGE_SIZE;
+
+	return 0;
+}
+
+int hib_buffer_finish_read(struct hibernate_io_handle *io_handle)
+{
+	int ret;
+
+	ret = hib_buffer_flush_page_read(io_handle);
+
+	free_page((unsigned long)io_handle->chunk_buffer);
+	io_handle->chunk_buffer = NULL;
+	io_handle->chunk_buffer_pos = 0;
+
+	return ret;
+}
+
+int hib_buffer_flush_page_write(struct hibernate_io_handle *io_handle)
+{
+	int ret = 0;
+	if (io_handle->chunk_buffer_pos)
+		ret = hibernate_io_ops->write_page(io_handle,
+				io_handle->chunk_buffer, NULL);
+	io_handle->chunk_buffer_pos = 0;
+	return ret;
+}
+
+int hib_buffer_finish_write(struct hibernate_io_handle *io_handle)
+{
+	int ret = 0;
+
+	ret = hib_buffer_flush_page_write(io_handle);
+
+	free_page((unsigned long)io_handle->chunk_buffer);
+	io_handle->chunk_buffer = NULL;
+	io_handle->chunk_buffer_pos = 0;
+
+	return ret;
+}
+
 int hib_wait_on_bio_chain(struct bio **bio_chain)
 {
 	struct bio *bio;
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 32a40f9..812b66c 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -119,9 +119,14 @@ struct snapshot_handle {
 /**
  * struct hibernate_io_handle - handle for image I/O processing
  *
+ * @chunk_buffer: temporary buffer used by chunk I/O to fill whole page
+ * @chunk_buffer_pos: position in chio_buffer
  * @priv: private data for each processor (swap_map_handle etc.)
  */
 struct hibernate_io_handle {
+	char *chunk_buffer;
+	unsigned long chunk_buffer_pos;
+
 	void *priv;
 };
 
@@ -200,6 +205,17 @@ extern int hib_bio_write_page(pgoff_t page_off, void *addr,
 		struct bio **bio_chain);
 extern int hib_wait_on_bio_chain(struct bio **bio_chain);
 
+extern int hib_buffer_init_read(struct hibernate_io_handle *io_handle);
+extern int hib_buffer_init_write(struct hibernate_io_handle *io_handle);
+extern int hib_buffer_finish_read(struct hibernate_io_handle *io_handle);
+extern int hib_buffer_finish_write(struct hibernate_io_handle *io_handle);
+extern int hib_buffer_flush_page_read(struct hibernate_io_handle *io_handle);
+extern int hib_buffer_flush_page_write(struct hibernate_io_handle *io_handle);
+extern int hib_buffer_read(struct hibernate_io_handle *io_handle, char *buffer,
+		int buffer_size);
+extern int hib_buffer_write(struct hibernate_io_handle *io_handle, char *buffer,
+		int buffer_size);
+
 struct timeval;
 /* kernel/power/swsusp.c */
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
-- 
1.7.1


