Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0IYER1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 00:17:27 -0400
Received: from crca.org.au ([74.207.252.120]:60372 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab0IYERY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 00:17:24 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: [PATCH 09/22] Hibernation: Stop passing swap_map_handle struct
Date: Sat, 25 Sep 2010 14:16:51 +1000
Message-Id: <1285388224-10012-10-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop passing the swap_map_handle struct around. It's a local (to the
file) variable and continuing to pass it around will create ugliness
as I work to disentangle swap specific functions from block i/o and
put them in separate files.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/swap.c |  135 ++++++++++++++++++++++++---------------------------
 1 files changed, 64 insertions(+), 71 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 0c87522..1df890f 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -63,6 +63,8 @@ struct swap_map_handle {
 	unsigned int k;
 };
 
+static struct swap_map_handle handle;
+
 static unsigned short root_swap = 0xffff;
 
 struct swsusp_header {
@@ -173,7 +175,7 @@ char __nosavedata write_speed, read_speed;
  * Saving part
  */
 
-static int mark_swapfiles(struct swap_map_handle *handle, unsigned int flags)
+static int mark_swapfiles(unsigned int flags)
 {
 	int error;
 
@@ -183,7 +185,7 @@ static int mark_swapfiles(struct swap_map_handle *handle, unsigned int flags)
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
 		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);
 		swsusp_header->write_speed = write_speed;
-		swsusp_header->image = handle->first_sector;
+		swsusp_header->image = handle.first_sector;
 		swsusp_header->flags = flags;
 		error = hib_bio_write_page(swsusp_resume_block,
 					swsusp_header, NULL);
@@ -250,14 +252,14 @@ static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
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
 
-static int get_swap_writer(struct swap_map_handle *handle, unsigned long pages)
+static int get_swap_writer(unsigned long pages)
 {
 	int ret;
 
@@ -268,8 +270,8 @@ static int get_swap_writer(struct swap_map_handle *handle, unsigned long pages)
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
@@ -278,74 +280,72 @@ static int get_swap_writer(struct swap_map_handle *handle, unsigned long pages)
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
 
-static int swap_write_page(struct swap_map_handle *handle, void *buf,
-				struct bio **bio_chain)
+static int swap_write_page(void *buf, struct bio **bio_chain)
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
@@ -355,8 +355,7 @@ static int swap_writer_finish(struct swap_map_handle *handle,
  *	save_image - save the suspend image data
  */
 
-static int save_image(struct swap_map_handle *handle,
-                      struct snapshot_handle *snapshot,
+static int save_image(struct snapshot_handle *snapshot,
                       unsigned int nr_to_write)
 {
 	unsigned int m;
@@ -380,7 +379,7 @@ static int save_image(struct swap_map_handle *handle,
 		ret = snapshot_read_next(snapshot);
 		if (ret <= 0)
 			break;
-		ret = swap_write_page(handle, data_of(*snapshot), &bio);
+		ret = swap_write_page(data_of(*snapshot), &bio);
 		if (ret)
 			break;
 		if (!(nr_pages % m))
@@ -412,14 +411,13 @@ static int save_image(struct swap_map_handle *handle,
 
 int swsusp_write(unsigned int flags)
 {
-	struct swap_map_handle handle;
 	struct snapshot_handle snapshot;
 	struct swsusp_info *header;
 	unsigned long pages;
 	int error;
 
 	pages = snapshot_get_image_size();
-	error = get_swap_writer(&handle, pages);
+	error = get_swap_writer(pages);
 	if (error) {
 		printk(KERN_ERR "PM: Cannot get swap writer\n");
 		return error;
@@ -433,11 +431,11 @@ int swsusp_write(unsigned int flags)
 		goto out_finish;
 	}
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = swap_write_page(&handle, header, NULL);
+	error = swap_write_page(header, NULL);
 	if (!error)
-		error = save_image(&handle, &snapshot, pages - 1);
+		error = save_image(&snapshot, pages - 1);
 out_finish:
-	error = swap_writer_finish(&handle, flags, error);
+	error = swap_writer_finish(flags, error);
 	return error;
 }
 
@@ -446,15 +444,14 @@ out_finish:
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
 
@@ -463,48 +460,47 @@ static int get_swap_reader(struct swap_map_handle *handle,
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
 
-static int swap_read_page(struct swap_map_handle *handle, void *buf,
-				struct bio **bio_chain)
+static int swap_read_page(void *buf, struct bio **bio_chain)
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
@@ -515,9 +511,7 @@ static int swap_reader_finish(struct swap_map_handle *handle)
  *	(assume there are @nr_pages pages to load)
  */
 
-static int load_image(struct swap_map_handle *handle,
-                      struct snapshot_handle *snapshot,
-                      unsigned int nr_to_read)
+static int load_image(struct snapshot_handle *snapshot, unsigned int nr_to_read)
 {
 	unsigned int m;
 	int error = 0;
@@ -540,7 +534,7 @@ static int load_image(struct swap_map_handle *handle,
 		error = snapshot_write_next(snapshot);
 		if (error <= 0)
 			break;
-		error = swap_read_page(handle, data_of(*snapshot), &bio);
+		error = swap_read_page(data_of(*snapshot), &bio);
 		if (error)
 			break;
 		if (snapshot->sync_read)
@@ -576,7 +570,6 @@ static int load_image(struct swap_map_handle *handle,
 int swsusp_read(unsigned int *flags_p)
 {
 	int error;
-	struct swap_map_handle handle;
 	struct snapshot_handle snapshot;
 	struct swsusp_info *header;
 
@@ -585,14 +578,14 @@ int swsusp_read(unsigned int *flags_p)
 	if (error < PAGE_SIZE)
 		return error < 0 ? error : -EFAULT;
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = get_swap_reader(&handle, flags_p);
+	error = get_swap_reader(flags_p);
 	if (error)
 		goto end;
 	if (!error)
-		error = swap_read_page(&handle, header, NULL);
+		error = swap_read_page(header, NULL);
 	if (!error)
-		error = load_image(&handle, &snapshot, header->pages - 1);
-	swap_reader_finish(&handle);
+		error = load_image(&snapshot, header->pages - 1);
+	swap_reader_finish();
 end:
 	if (!error)
 		pr_debug("PM: Image successfully loaded\n");
-- 
1.7.0.4

