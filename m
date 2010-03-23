Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0CWQXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:23:47 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51611 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab0CWQXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:23:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC 02/15] PM / Hibernate: snapshot cleanup
Date: Tue, 23 Mar 2010 17:17:30 +0100
Message-Id: <1269361063-3341-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Remove support of reads with offset. This means snapshot_read/write_next
now does not accept count parameter.

/dev/snapshot handler is converted to simple_read_from_buffer/simple_write_to_buffer.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/power.h    |   18 +-----
 kernel/power/snapshot.c |  145 ++++++++++++++++++-----------------------------
 kernel/power/swap.c     |    8 +-
 kernel/power/user.c     |   39 ++++++++-----
 4 files changed, 88 insertions(+), 122 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 46c5a26..b1e207d 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -97,24 +97,12 @@ extern int hibernate_preallocate_memory(void);
  */
 
 struct snapshot_handle {
-	loff_t		offset;	/* number of the last byte ready for reading
-				 * or writing in the sequence
-				 */
 	unsigned int	cur;	/* number of the block of PAGE_SIZE bytes the
 				 * next operation will refer to (ie. current)
 				 */
-	unsigned int	cur_offset;	/* offset with respect to the current
-					 * block (for the next operation)
-					 */
-	unsigned int	prev;	/* number of the block of PAGE_SIZE bytes that
-				 * was the current one previously
-				 */
 	void		*buffer;	/* address of the block to read from
 					 * or write to
 					 */
-	unsigned int	buf_offset;	/* location to read from or write to,
-					 * given as a displacement from 'buffer'
-					 */
 	int		sync_read;	/* Set to one to notify the caller of
 					 * snapshot_write_next() that it may
 					 * need to call wait_on_bio_chain()
@@ -125,12 +113,12 @@ struct snapshot_handle {
  * snapshot_read_next()/snapshot_write_next() is allowed to
  * read/write data after the function returns
  */
-#define data_of(handle)	((handle).buffer + (handle).buf_offset)
+#define data_of(handle)	((handle).buffer)
 
 extern unsigned int snapshot_additional_pages(struct zone *zone);
 extern unsigned long snapshot_get_image_size(void);
-extern int snapshot_read_next(struct snapshot_handle *handle, size_t count);
-extern int snapshot_write_next(struct snapshot_handle *handle, size_t count);
+extern int snapshot_read_next(struct snapshot_handle *handle);
+extern int snapshot_write_next(struct snapshot_handle *handle);
 extern void snapshot_write_finalize(struct snapshot_handle *handle);
 extern int snapshot_image_loaded(struct snapshot_handle *handle);
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 830cade..7918351 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1603,14 +1603,9 @@ pack_pfns(unsigned long *buf, struct memory_bitmap *bm)
  *	snapshot_handle structure.  The structure gets updated and a pointer
  *	to it should be passed to this function every next time.
  *
- *	The @count parameter should contain the number of bytes the caller
- *	wants to read from the snapshot.  It must not be zero.
- *
  *	On success the function returns a positive number.  Then, the caller
  *	is allowed to read up to the returned number of bytes from the memory
- *	location computed by the data_of() macro.  The number returned
- *	may be smaller than @count, but this only happens if the read would
- *	cross a page boundary otherwise.
+ *	location computed by the data_of() macro.
  *
  *	The function returns 0 to indicate the end of data stream condition,
  *	and a negative number is returned on error.  In such cases the
@@ -1618,7 +1613,7 @@ pack_pfns(unsigned long *buf, struct memory_bitmap *bm)
  *	any more.
  */
 
-int snapshot_read_next(struct snapshot_handle *handle, size_t count)
+int snapshot_read_next(struct snapshot_handle *handle)
 {
 	if (handle->cur > nr_meta_pages + nr_copy_pages)
 		return 0;
@@ -1629,7 +1624,7 @@ int snapshot_read_next(struct snapshot_handle *handle, size_t count)
 		if (!buffer)
 			return -ENOMEM;
 	}
-	if (!handle->offset) {
+	if (!handle->cur) {
 		int error;
 
 		error = init_header((struct swsusp_info *)buffer);
@@ -1638,42 +1633,30 @@ int snapshot_read_next(struct snapshot_handle *handle, size_t count)
 		handle->buffer = buffer;
 		memory_bm_position_reset(&orig_bm);
 		memory_bm_position_reset(&copy_bm);
-	}
-	if (handle->prev < handle->cur) {
-		if (handle->cur <= nr_meta_pages) {
-			memset(buffer, 0, PAGE_SIZE);
-			pack_pfns(buffer, &orig_bm);
-		} else {
-			struct page *page;
+	} else if (handle->cur <= nr_meta_pages) {
+		memset(buffer, 0, PAGE_SIZE);
+		pack_pfns(buffer, &orig_bm);
+	} else {
+		struct page *page;
 
-			page = pfn_to_page(memory_bm_next_pfn(&copy_bm));
-			if (PageHighMem(page)) {
-				/* Highmem pages are copied to the buffer,
-				 * because we can't return with a kmapped
-				 * highmem page (we may not be called again).
-				 */
-				void *kaddr;
+		page = pfn_to_page(memory_bm_next_pfn(&copy_bm));
+		if (PageHighMem(page)) {
+			/* Highmem pages are copied to the buffer,
+			 * because we can't return with a kmapped
+			 * highmem page (we may not be called again).
+			 */
+			void *kaddr;
 
-				kaddr = kmap_atomic(page, KM_USER0);
-				memcpy(buffer, kaddr, PAGE_SIZE);
-				kunmap_atomic(kaddr, KM_USER0);
-				handle->buffer = buffer;
-			} else {
-				handle->buffer = page_address(page);
-			}
+			kaddr = kmap_atomic(page, KM_USER0);
+			memcpy(buffer, kaddr, PAGE_SIZE);
+			kunmap_atomic(kaddr, KM_USER0);
+			handle->buffer = buffer;
+		} else {
+			handle->buffer = page_address(page);
 		}
-		handle->prev = handle->cur;
-	}
-	handle->buf_offset = handle->cur_offset;
-	if (handle->cur_offset + count >= PAGE_SIZE) {
-		count = PAGE_SIZE - handle->cur_offset;
-		handle->cur_offset = 0;
-		handle->cur++;
-	} else {
-		handle->cur_offset += count;
 	}
-	handle->offset += count;
-	return count;
+	handle->cur++;
+	return PAGE_SIZE;
 }
 
 /**
@@ -2132,14 +2115,9 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
  *	snapshot_handle structure.  The structure gets updated and a pointer
  *	to it should be passed to this function every next time.
  *
- *	The @count parameter should contain the number of bytes the caller
- *	wants to write to the image.  It must not be zero.
- *
  *	On success the function returns a positive number.  Then, the caller
  *	is allowed to write up to the returned number of bytes to the memory
- *	location computed by the data_of() macro.  The number returned
- *	may be smaller than @count, but this only happens if the write would
- *	cross a page boundary otherwise.
+ *	location computed by the data_of() macro.
  *
  *	The function returns 0 to indicate the "end of file" condition,
  *	and a negative number is returned on error.  In such cases the
@@ -2147,16 +2125,18 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
  *	any more.
  */
 
-int snapshot_write_next(struct snapshot_handle *handle, size_t count)
+int snapshot_write_next(struct snapshot_handle *handle)
 {
 	static struct chain_allocator ca;
 	int error = 0;
 
 	/* Check if we have already loaded the entire image */
-	if (handle->prev && handle->cur > nr_meta_pages + nr_copy_pages)
+	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages)
 		return 0;
 
-	if (handle->offset == 0) {
+	handle->sync_read = 1;
+
+	if (!handle->cur) {
 		if (!buffer)
 			/* This makes the buffer be freed by swsusp_free() */
 			buffer = get_image_page(GFP_ATOMIC, PG_ANY);
@@ -2165,56 +2145,43 @@ int snapshot_write_next(struct snapshot_handle *handle, size_t count)
 			return -ENOMEM;
 
 		handle->buffer = buffer;
-	}
-	handle->sync_read = 1;
-	if (handle->prev < handle->cur) {
-		if (handle->prev == 0) {
-			error = load_header(buffer);
-			if (error)
-				return error;
+	} else if (handle->cur == 1) {
+		error = load_header(buffer);
+		if (error)
+			return error;
 
-			error = memory_bm_create(&copy_bm, GFP_ATOMIC, PG_ANY);
-			if (error)
-				return error;
+		error = memory_bm_create(&copy_bm, GFP_ATOMIC, PG_ANY);
+		if (error)
+			return error;
+
+	} else if (handle->cur <= nr_meta_pages + 1) {
+		error = unpack_orig_pfns(buffer, &copy_bm);
+		if (error)
+			return error;
 
-		} else if (handle->prev <= nr_meta_pages) {
-			error = unpack_orig_pfns(buffer, &copy_bm);
+		if (handle->cur == nr_meta_pages + 1) {
+			error = prepare_image(&orig_bm, &copy_bm);
 			if (error)
 				return error;
 
-			if (handle->prev == nr_meta_pages) {
-				error = prepare_image(&orig_bm, &copy_bm);
-				if (error)
-					return error;
-
-				chain_init(&ca, GFP_ATOMIC, PG_SAFE);
-				memory_bm_position_reset(&orig_bm);
-				restore_pblist = NULL;
-				handle->buffer = get_buffer(&orig_bm, &ca);
-				handle->sync_read = 0;
-				if (IS_ERR(handle->buffer))
-					return PTR_ERR(handle->buffer);
-			}
-		} else {
-			copy_last_highmem_page();
+			chain_init(&ca, GFP_ATOMIC, PG_SAFE);
+			memory_bm_position_reset(&orig_bm);
+			restore_pblist = NULL;
 			handle->buffer = get_buffer(&orig_bm, &ca);
+			handle->sync_read = 0;
 			if (IS_ERR(handle->buffer))
 				return PTR_ERR(handle->buffer);
-			if (handle->buffer != buffer)
-				handle->sync_read = 0;
 		}
-		handle->prev = handle->cur;
-	}
-	handle->buf_offset = handle->cur_offset;
-	if (handle->cur_offset + count >= PAGE_SIZE) {
-		count = PAGE_SIZE - handle->cur_offset;
-		handle->cur_offset = 0;
-		handle->cur++;
 	} else {
-		handle->cur_offset += count;
+		copy_last_highmem_page();
+		handle->buffer = get_buffer(&orig_bm, &ca);
+		if (IS_ERR(handle->buffer))
+			return PTR_ERR(handle->buffer);
+		if (handle->buffer != buffer)
+			handle->sync_read = 0;
 	}
-	handle->offset += count;
-	return count;
+	handle->cur++;
+	return PAGE_SIZE;
 }
 
 /**
@@ -2229,7 +2196,7 @@ void snapshot_write_finalize(struct snapshot_handle *handle)
 {
 	copy_last_highmem_page();
 	/* Free only if we have loaded the image entirely */
-	if (handle->prev && handle->cur > nr_meta_pages + nr_copy_pages) {
+	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages) {
 		memory_bm_free(&orig_bm, PG_UNSAFE_CLEAR);
 		free_highmem_data();
 	}
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 1d57573..4a22f0b 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -430,7 +430,7 @@ static int save_image(struct swap_map_handle *handle,
 	bio = NULL;
 	do_gettimeofday(&start);
 	while (1) {
-		ret = snapshot_read_next(snapshot, PAGE_SIZE);
+		ret = snapshot_read_next(snapshot);
 		if (ret <= 0)
 			break;
 		ret = swap_write_page(handle, data_of(*snapshot), &bio);
@@ -491,7 +491,7 @@ int swsusp_write(unsigned int flags)
 		return error;
 	}
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
-	error = snapshot_read_next(&snapshot, PAGE_SIZE);
+	error = snapshot_read_next(&snapshot);
 	if (error < PAGE_SIZE) {
 		if (error >= 0)
 			error = -EFAULT;
@@ -614,7 +614,7 @@ static int load_image(struct swap_map_handle *handle,
 	bio = NULL;
 	do_gettimeofday(&start);
 	for ( ; ; ) {
-		error = snapshot_write_next(snapshot, PAGE_SIZE);
+		error = snapshot_write_next(snapshot);
 		if (error <= 0)
 			break;
 		error = swap_read_page(handle, data_of(*snapshot), &bio);
@@ -659,7 +659,7 @@ int swsusp_read(unsigned int *flags_p)
 	*flags_p = swsusp_header->flags;
 
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
-	error = snapshot_write_next(&snapshot, PAGE_SIZE);
+	error = snapshot_write_next(&snapshot);
 	if (error < PAGE_SIZE)
 		return error < 0 ? error : -EFAULT;
 	header = (struct swsusp_info *)data_of(snapshot);
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 4d22896..68a99c1 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -151,6 +151,7 @@ static ssize_t snapshot_read(struct file *filp, char __user *buf,
 {
 	struct snapshot_data *data;
 	ssize_t res;
+	loff_t pg_offp = *offp & ~PAGE_MASK;
 
 	mutex_lock(&pm_mutex);
 
@@ -159,13 +160,17 @@ static ssize_t snapshot_read(struct file *filp, char __user *buf,
 		res = -ENODATA;
 		goto Unlock;
 	}
-	res = snapshot_read_next(&data->handle, count);
-	if (res > 0) {
-		if (copy_to_user(buf, data_of(data->handle), res))
-			res = -EFAULT;
-		else
-			*offp = data->handle.offset;
-	}
+	if (!pg_offp) { /* on page boundary? */
+		res = snapshot_read_next(&data->handle);
+		if (res <= 0)
+			goto Unlock;
+	} else
+		res = PAGE_SIZE - pg_offp;
+
+	res = simple_read_from_buffer(buf, count, &pg_offp,
+			data_of(data->handle), res);
+	if (res > 0)
+		*offp += res;
 
  Unlock:
 	mutex_unlock(&pm_mutex);
@@ -178,18 +183,24 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
 {
 	struct snapshot_data *data;
 	ssize_t res;
+	loff_t pg_offp = *offp & ~PAGE_MASK;
 
 	mutex_lock(&pm_mutex);
 
 	data = filp->private_data;
-	res = snapshot_write_next(&data->handle, count);
-	if (res > 0) {
-		if (copy_from_user(data_of(data->handle), buf, res))
-			res = -EFAULT;
-		else
-			*offp = data->handle.offset;
-	}
 
+	if (!pg_offp) {
+		res = snapshot_write_next(&data->handle);
+		if (res <= 0)
+			goto unlock;
+	} else
+		res = PAGE_SIZE - pg_offp;
+
+	res = simple_write_to_buffer(data_of(data->handle), res, &pg_offp,
+			buf, count);
+	if (res > 0)
+		*offp += res;
+unlock:
 	mutex_unlock(&pm_mutex);
 
 	return res;
-- 
1.7.0.2


