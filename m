Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab0I0FrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:47:23 -0400
Received: from crca.org.au ([74.207.252.120]:33895 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932703Ab0I0FoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:20 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 10/23] Hibernation: Stop passing swap_map_handle struct
Date: Mon, 27 Sep 2010 15:43:45 +1000
Message-Id: <1285566238-10966-11-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop passing the swap_map_handle struct around. It's a local (to the
file) variable and continuing to pass it around will create ugliness
as I work to disentangle swap specific functions from block i/o and
put them in separate files.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/compress.c |   29 ++++-----
 kernel/power/compress.h |   11 +---
 kernel/power/swap.c     |  155 ++++++++++++++++++++++++-----------------------
 kernel/power/swap.h     |   18 +-----
 4 files changed, 97 insertions(+), 116 deletions(-)

diff --git a/kernel/power/compress.c b/kernel/power/compress.c
index 45725ea..b8b8c63 100644
--- a/kernel/power/compress.c
+++ b/kernel/power/compress.c
@@ -78,7 +78,7 @@ int compress_image_init(void)
 	return 0;
 }
 
-static int compress_and_write(struct swap_map_handle *handle, struct bio **bio)
+static int compress_and_write(struct bio **bio)
 {
 	int ret;
 
@@ -111,7 +111,7 @@ static int compress_and_write(struct swap_map_handle *handle, struct bio **bio)
 	for (off = 0; off < LZO_HEADER + cmp_len; off += PAGE_SIZE) {
 		memcpy(page, cmp + off, PAGE_SIZE);
 
-		ret = swap_write_page(handle, page, bio);
+		ret = swap_write_page(page, bio);
 		if (ret)
 			return ret;
 	}
@@ -120,32 +120,30 @@ static int compress_and_write(struct swap_map_handle *handle, struct bio **bio)
 	return 0;
 }
 
-int compress_write(struct swap_map_handle *handle, char *buf, struct bio **bio,
-		int flags)
+int compress_write(char *buf, struct bio **bio, int flags)
 {
 	int ret = 0;
 
 	if (flags & SF_NOCOMPRESS_MODE)
-		return swap_write_page(handle, buf, bio);
+		return swap_write_page(buf, bio);
 
 	if (off == LZO_UNC_SIZE)
-		ret = compress_and_write(handle, bio);
+		ret = compress_and_write(bio);
 
 	memcpy(unc + off, buf, PAGE_SIZE);
 	off += PAGE_SIZE;
 	return ret;
 }
 
-void compress_write_finish(struct swap_map_handle *handle, struct bio **bio,
-		int flags)
+void compress_write_finish(struct bio **bio, int flags)
 {
 	if (!(flags & SF_NOCOMPRESS_MODE))
-		compress_and_write(handle, bio);
+		compress_and_write(bio);
 }
 
-static int read_and_decompress(struct swap_map_handle *handle)
+static int read_and_decompress(void)
 {
-	int error = swap_read_page(handle, page, NULL), off;
+	int error = swap_read_page(page, NULL), off;
 	cmp_len = *(size_t *)page;
 
 	if (unlikely(!cmp_len ||
@@ -156,7 +154,7 @@ static int read_and_decompress(struct swap_map_handle *handle)
 
 	memcpy(cmp, page, PAGE_SIZE);
 	for (off = PAGE_SIZE; off < LZO_HEADER + cmp_len; off += PAGE_SIZE) {
-		error = swap_read_page(handle, page, NULL); /* sync */
+		error = swap_read_page(page, NULL); /* sync */
 		if (error)
 			return error;
 
@@ -181,16 +179,15 @@ static int read_and_decompress(struct swap_map_handle *handle)
 	return 0;
 }
 
-int compress_read(struct swap_map_handle *handle, char *buf, struct bio **bio,
-		int flags)
+int compress_read(char *buf, struct bio **bio, int flags)
 {
 	int ret = 0;
 
 	if (flags & SF_NOCOMPRESS_MODE)
-		return swap_read_page(handle, buf, bio);
+		return swap_read_page(buf, bio);
 
 	if (!off) {
-		ret = read_and_decompress(handle);
+		ret = read_and_decompress();
 		if (ret)
 			return ret;
 	}
diff --git a/kernel/power/compress.h b/kernel/power/compress.h
index 32abfc3..a25f673 100644
--- a/kernel/power/compress.h
+++ b/kernel/power/compress.h
@@ -10,14 +10,9 @@
  *
  */
 
-struct swap_map_handle;
-
 int compress_image_init(void);
 void compress_image_cleanup(void);
-int compress_write(struct swap_map_handle *handle, char *page, struct bio **bio,
-		int flags);
-void compress_write_finish(struct swap_map_handle *handle, struct bio **bio,
-		int flags);
-int compress_read(struct swap_map_handle *handle, char *page, struct bio **bio,
-		int flags);
+int compress_write(char *page, struct bio **bio, int flags);
+void compress_write_finish(struct bio **bio, int flags);
+int compress_read(char *page, struct bio **bio, int flags);
 unsigned int compress_extra_pages(unsigned int base, unsigned int flags);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 819d21a..7340314 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -44,6 +44,20 @@ struct swap_map_page {
 	sector_t next_swap;
 };
 
+/**
+ *	The swap_map_handle structure is used for handling swap in
+ *	a file-alike way
+ */
+
+struct swap_map_handle {
+	struct swap_map_page *cur;
+	sector_t cur_swap;
+	sector_t first_sector;
+	unsigned int k;
+};
+
+static struct swap_map_handle handle;
+
 static unsigned short root_swap = 0xffff;
 
 struct swsusp_header {
@@ -155,7 +169,7 @@ char __nosavedata write_speed, read_speed;
  * Saving part
  */
 
-static int mark_swapfiles(struct swap_map_handle *handle, unsigned int flags)
+static int mark_swapfiles(unsigned int flags)
 {
 	int error;
 
@@ -165,7 +179,7 @@ static int mark_swapfiles(struct swap_map_handle *handle, unsigned int flags)
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
 		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);
 		swsusp_header->write_speed = write_speed;
-		swsusp_header->image = handle->first_sector;
+		swsusp_header->image = handle.first_sector;
 		swsusp_header->flags = flags;
 		error = hib_bio_write_page(swsusp_resume_block,
 					swsusp_header, NULL);
@@ -232,15 +246,14 @@ static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
 	return hib_bio_write_page(offset, src, bio_chain);
 }
 
-static void release_swap_writer(struct swap_map_handle *handle)
+static void release_swap_writer(void)
 {
-	if (handle->cur)
-		free_page((unsigned long)handle->cur);
-	handle->cur = NULL;
+	if (handle.cur)
+		free_page((unsigned long)handle.cur);
+	handle.cur = NULL;
 }
 
-static int get_swap_writer(struct swap_map_handle *handle, unsigned long pages,
-		unsigned int flags)
+static int get_swap_writer(unsigned long pages, unsigned int flags)
 {
 	int ret;
 
@@ -251,8 +264,8 @@ static int get_swap_writer(struct swap_map_handle *handle, unsigned long pages,
 					"swapon -a.\n");
 		return ret;
 	}
-	handle->cur = (struct swap_map_page *)get_zeroed_page(GFP_KERNEL);
-	if (!handle->cur) {
+	handle.cur = (struct swap_map_page *)get_zeroed_page(GFP_KERNEL);
+	if (!handle.cur) {
 		ret = -ENOMEM;
 		goto err_close;
 	}
@@ -261,74 +274,72 @@ static int get_swap_writer(struct swap_map_handle *handle, unsigned long pages,
 		ret = -ENOSPC;
 		goto err_close;
 	}
-	handle->cur_swap = hib_extent_next(&sector_extents);
-	if (!handle->cur_swap) {
+	handle.cur_swap = hib_extent_next(&sector_extents);
+	if (!handle.cur_swap) {
 		ret = -ENOSPC;
 		goto err_rel;
 	}
-	handle->k = 0;
-	handle->first_sector = handle->cur_swap;
+	handle.k = 0;
+	handle.first_sector = handle.cur_swap;
 	return 0;
 err_rel:
-	release_swap_writer(handle);
+	release_swap_writer();
 err_close:
 	swsusp_close(FMODE_WRITE);
 	return ret;
 }
 
-int swap_write_page(struct swap_map_handle *handle, void *buf,
-				struct bio **bio_chain)
+int swap_write_page(void *buf, struct bio **bio_chain)
 {
 	int error = 0;
 	sector_t offset;
 
-	if (!handle->cur)
+	if (!handle.cur)
 		return -EINVAL;
 	offset = hib_extent_next(&sector_extents);
 	error = write_page(buf, offset, bio_chain);
 	if (error)
 		return error;
-	handle->cur->entries[handle->k++] = offset;
-	if (handle->k >= MAP_PAGE_ENTRIES) {
+	handle.cur->entries[handle.k++] = offset;
+	if (handle.k >= MAP_PAGE_ENTRIES) {
 		error = hib_wait_on_bio_chain(bio_chain);
 		if (error)
 			goto out;
 		offset = hib_extent_next(&sector_extents);
 		if (!offset)
 			return -ENOSPC;
-		handle->cur->next_swap = offset;
-		error = write_page(handle->cur, handle->cur_swap, NULL);
+		handle.cur->next_swap = offset;
+		error = write_page(handle.cur, handle.cur_swap, NULL);
 		if (error)
 			goto out;
-		memset(handle->cur, 0, PAGE_SIZE);
-		handle->cur_swap = offset;
-		handle->k = 0;
+		memset(handle.cur, 0, PAGE_SIZE);
+		handle.cur_swap = offset;
+		handle.k = 0;
 	}
  out:
 	return error;
 }
 
-static int flush_swap_writer(struct swap_map_handle *handle)
+static int flush_swap_writer(void)
 {
-	if (handle->cur && handle->cur_swap)
-		return write_page(handle->cur, handle->cur_swap, NULL);
+	if (handle.cur && handle.cur_swap)
+		return write_page(handle.cur, handle.cur_swap, NULL);
 	else
 		return -EINVAL;
 }
 
-static int swap_writer_finish(struct swap_map_handle *handle,
-		unsigned int flags, int error)
+static int swap_writer_finish(unsigned int flags, int error)
 {
 	if (!error) {
-		flush_swap_writer(handle);
+		flush_swap_writer();
 		printk(KERN_INFO "PM: S");
-		error = mark_swapfiles(handle, flags);
+		error = mark_swapfiles(flags);
 		printk("|\n");
 	}
 
 	if (error)
 		free_all_swap_pages(root_swap);
-	release_swap_writer(handle);
+	release_swap_writer();
 	swsusp_close(FMODE_WRITE);
 
 	return error;
@@ -338,8 +349,7 @@ static int swap_writer_finish(struct swap_map_handle *handle,
  *	save_image - save the suspend image data
  */
 
-static int save_image(struct swap_map_handle *handle,
-                      struct snapshot_handle *snapshot,
+static int save_image(struct snapshot_handle *snapshot,
                       unsigned int nr_to_write,
 		      int flags)
 {
@@ -364,14 +374,14 @@ static int save_image(struct swap_map_handle *handle,
 		ret = snapshot_read_next(snapshot);
 		if (ret <= 0)
 			break;
-		ret = compress_write(handle, data_of(*snapshot), &bio, flags);
+		ret = compress_write(data_of(*snapshot), &bio, flags);
 		if (ret)
 			break;
 		if (!(nr_pages % m))
 			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
 	}
-	compress_write_finish(handle, &bio, flags);
+	compress_write_finish(&bio, flags);
 	err2 = hib_wait_on_bio_chain(&bio);
 	do_gettimeofday(&stop);
 	if (!ret)
@@ -398,7 +408,6 @@ static int save_image(struct swap_map_handle *handle,
 
 int swsusp_write(unsigned int flags)
 {
-	struct swap_map_handle handle;
 	struct snapshot_handle snapshot;
 	struct swsusp_info *header;
 	unsigned long pages;
@@ -410,7 +419,7 @@ int swsusp_write(unsigned int flags)
 		return error;
 
 	pages = snapshot_get_image_size();
-	error = get_swap_writer(&handle, pages, flags);
+	error = get_swap_writer(pages, flags);
 	if (error) {
 		printk(KERN_ERR "PM: Cannot get swap writer\n");
 		compress_image_cleanup();
@@ -425,12 +434,12 @@ int swsusp_write(unsigned int flags)
 		goto out_finish;
 	}
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = swap_write_page(&handle, header, NULL);
+	error = swap_write_page(header, NULL);
 	if (!error)
-		error = save_image(&handle, &snapshot, pages - 1, flags);
+		error = save_image(&snapshot, pages - 1, flags);
 out_finish:
 	compress_image_cleanup();
-	error = swap_writer_finish(&handle, flags, error);
+	error = swap_writer_finish(flags, error);
 	return error;
 }
 
@@ -439,15 +448,14 @@ out_finish:
  *	in a file-alike way
  */
 
-static void release_swap_reader(struct swap_map_handle *handle)
+static void release_swap_reader(void)
 {
-	if (handle->cur)
-		free_page((unsigned long)handle->cur);
-	handle->cur = NULL;
+	if (handle.cur)
+		free_page((unsigned long)handle.cur);
+	handle.cur = NULL;
 }
 
-static int get_swap_reader(struct swap_map_handle *handle,
-		unsigned int *flags_p)
+static int get_swap_reader(unsigned int *flags_p)
 {
 	int error;
 
@@ -456,48 +464,47 @@ static int get_swap_reader(struct swap_map_handle *handle,
 	if (!swsusp_header->image) /* how can this happen? */
 		return -EINVAL;
 
-	handle->cur = (struct swap_map_page *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
-	if (!handle->cur)
+	handle.cur = (struct swap_map_page *)get_zeroed_page(__GFP_WAIT | __GFP_HIGH);
+	if (!handle.cur)
 		return -ENOMEM;
 
-	error = hib_bio_read_page(swsusp_header->image, handle->cur, NULL);
+	error = hib_bio_read_page(swsusp_header->image, handle.cur, NULL);
 	if (error) {
-		release_swap_reader(handle);
+		release_swap_reader();
 		return error;
 	}
-	handle->k = 0;
+	handle.k = 0;
 	return 0;
 }
 
-int swap_read_page(struct swap_map_handle *handle, void *buf,
-				struct bio **bio_chain)
+int swap_read_page(void *buf, struct bio **bio_chain)
 {
 	sector_t offset;
 	int error;
 
-	if (!handle->cur)
+	if (!handle.cur)
 		return -EINVAL;
-	offset = handle->cur->entries[handle->k];
+	offset = handle.cur->entries[handle.k];
 	if (!offset)
 		return -EFAULT;
 	error = hib_bio_read_page(offset, buf, bio_chain);
 	if (error)
 		return error;
-	if (++handle->k >= MAP_PAGE_ENTRIES) {
+	if (++handle.k >= MAP_PAGE_ENTRIES) {
 		error = hib_wait_on_bio_chain(bio_chain);
-		handle->k = 0;
-		offset = handle->cur->next_swap;
+		handle.k = 0;
+		offset = handle.cur->next_swap;
 		if (!offset)
-			release_swap_reader(handle);
+			release_swap_reader();
 		else if (!error)
-			error = hib_bio_read_page(offset, handle->cur, NULL);
+			error = hib_bio_read_page(offset, handle.cur, NULL);
 	}
 	return error;
 }
 
-static int swap_reader_finish(struct swap_map_handle *handle)
+static int swap_reader_finish(void)
 {
-	release_swap_reader(handle);
+	release_swap_reader();
 
 	return 0;
 }
@@ -508,9 +515,8 @@ static int swap_reader_finish(struct swap_map_handle *handle)
  *	(assume there are @nr_pages pages to load)
  */
 
-static int load_image(struct swap_map_handle *handle,
-                      struct snapshot_handle *snapshot,
-                      unsigned int nr_to_read, int flags)
+static int load_image(struct snapshot_handle *snapshot,
+		unsigned int nr_to_read, int flags)
 {
 	unsigned int m;
 	int error = 0;
@@ -533,7 +539,7 @@ static int load_image(struct swap_map_handle *handle,
 		error = snapshot_write_next(snapshot);
 		if (error <= 0)
 			break;
-		error = compress_read(handle, data_of(*snapshot), &bio, flags);
+		error = compress_read(data_of(*snapshot), &bio, flags);
 		if (error)
 			break;
 		if (snapshot->sync_read)
@@ -569,7 +575,6 @@ static int load_image(struct swap_map_handle *handle,
 int swsusp_read(unsigned int *flags_p)
 {
 	int error = 0;
-	struct swap_map_handle handle;
 	struct snapshot_handle snapshot;
 	struct swsusp_info *header;
 
@@ -585,16 +590,14 @@ int swsusp_read(unsigned int *flags_p)
 		return error < 0 ? error : -EFAULT;
 	}
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = get_swap_reader(&handle, flags_p);
+	error = get_swap_reader(flags_p);
 	if (error)
 		goto end;
 	if (!error)
-		error = swap_read_page(&handle, header, NULL);
-	if (!error) {
-		error = load_image(&handle, &snapshot, header->pages - 1,
-				*flags_p);
-	}
-	swap_reader_finish(&handle);
+		error = swap_read_page(header, NULL);
+	if (!error)
+		error = load_image(&snapshot, header->pages - 1, *flags_p);
+	swap_reader_finish();
 end:
 	compress_image_cleanup();
 	if (!error)
diff --git a/kernel/power/swap.h b/kernel/power/swap.h
index e9ad377..7d109ad 100644
--- a/kernel/power/swap.h
+++ b/kernel/power/swap.h
@@ -10,19 +10,5 @@
  *
  */
 
-/**
- *	The swap_map_handle structure is used for handling swap in
- *	a file-alike way
- */
-
-struct swap_map_handle {
-	struct swap_map_page *cur;
-	sector_t cur_swap;
-	sector_t first_sector;
-	unsigned int k;
-};
-
-int swap_write_page(struct swap_map_handle *handle, void *buf,
-				struct bio **bio_chain);
-int swap_read_page(struct swap_map_handle *handle, void *buf,
-				struct bio **bio_chain);
+int swap_write_page(void *buf, struct bio **bio_chain);
+int swap_read_page(void *buf, struct bio **bio_chain);
-- 
1.7.0.4

