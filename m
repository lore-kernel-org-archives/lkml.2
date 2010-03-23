Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0CWQYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:24:48 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51602 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab0CWQXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:23:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC 07/15] PM / Hibernate: add sws_modules_ops
Date: Tue, 23 Mar 2010 17:17:35 +0100
Message-Id: <1269361063-3341-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now they will only hold swap operations. In next patches, user
support will be converted to ops as well to have a single layer and
can push pages instead of pulling them.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 kernel/power/hibernate.c |    2 +
 kernel/power/power.h     |   13 +++++++++++
 kernel/power/swap.c      |   51 ++++++++++++++++++++++++++++++---------------
 3 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index da5288e..762431e 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -34,6 +34,8 @@ dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
 int in_suspend __nosavedata = 0;
 
+struct sws_module_ops *sws_io_ops;
+
 enum {
 	HIBERNATION_INVALID,
 	HIBERNATION_PLATFORM,
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 6c4b4fa..0f08de4 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -115,6 +115,17 @@ struct snapshot_handle {
  */
 #define data_of(handle)	((handle).buffer)
 
+struct sws_module_ops {
+	unsigned long (*storage_available)(void);
+
+	int (*get_reader)(unsigned int *flags_p);
+	int (*put_reader)(void);
+	int (*get_writer)(void);
+	int (*put_writer)(unsigned int flags, int error);
+	int (*read_page)(void *addr, struct bio **bio_chain);
+	int (*write_page)(void *addr, struct bio **bio_chain);
+};
+
 extern unsigned int snapshot_additional_pages(struct zone *zone);
 extern unsigned long snapshot_get_image_size(void);
 extern int snapshot_read_next(struct snapshot_handle *handle);
@@ -213,6 +224,8 @@ enum {
 
 extern int pm_test_level;
 
+extern struct sws_module_ops *sws_io_ops;
+
 #ifdef CONFIG_SUSPEND_FREEZER
 static inline int suspend_freeze_processes(void)
 {
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index ac1a351..cc79ed1 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -387,7 +387,7 @@ static int save_image(struct snapshot_handle *snapshot,
 		ret = snapshot_read_next(snapshot);
 		if (ret <= 0)
 			break;
-		ret = swap_write_page(data_of(*snapshot), &bio);
+		ret = sws_io_ops->write_page(data_of(*snapshot), &bio);
 		if (ret)
 			break;
 		if (!(nr_pages % m))
@@ -407,18 +407,18 @@ static int save_image(struct snapshot_handle *snapshot,
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
+	unsigned int free_pages = sws_io_ops->storage_available();
 
-	pr_debug("PM: Free swap pages: %u\n", free_swap);
-	return free_swap > nr_pages + PAGES_FOR_IO;
+	pr_debug("PM: Free storage pages: %u\n", free_pages);
+	return free_pages > nr_pages + PAGES_FOR_IO;
 }
 
 /**
@@ -439,13 +439,13 @@ int swsusp_write(unsigned int flags)
 	int error;
 
 	pages = snapshot_get_image_size();
-	error = get_swap_writer();
+	error = sws_io_ops->get_writer();
 	if (error) {
 		printk(KERN_ERR "PM: Cannot get swap writer\n");
 		return error;
 	}
-	if (!enough_swap(pages)) {
-		printk(KERN_ERR "PM: Not enough free swap\n");
+	if (!enough_space(pages)) {
+		printk(KERN_ERR "PM: Not enough free space for image\n");
 		error = -ENOSPC;
 		goto out_finish;
 	}
@@ -458,14 +458,19 @@ int swsusp_write(unsigned int flags)
 		goto out_finish;
 	}
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = swap_write_page(header, NULL);
+	error = sws_io_ops->write_page(header, NULL);
 	if (!error)
 		error = save_image(&snapshot, pages - 1);
 out_finish:
-	error = put_swap_writer(flags, error);
+	error = sws_io_ops->put_writer(flags, error);
 	return error;
 }
 
+static unsigned long swap_storage_available(void)
+{
+	return count_swap_pages(root_swap, 1);
+}
+
 /**
  *	The following functions allow us to read data using a swap map
  *	in a file-alike way
@@ -535,6 +540,17 @@ static int put_swap_reader(void)
 	return 0;
 }
 
+struct sws_module_ops swap_ops = {
+	.storage_available = swap_storage_available,
+
+	.get_reader = get_swap_reader,
+	.put_reader = put_swap_reader,
+	.get_writer = get_swap_writer,
+	.put_writer = put_swap_writer,
+	.read_page = swap_read_page,
+	.write_page = swap_write_page,
+};
+
 /**
  *	load_image - load the image
  *	@handle and the snapshot handle @snapshot
@@ -563,7 +579,7 @@ static int load_image(struct snapshot_handle *snapshot, unsigned int nr_to_read)
 		error = snapshot_write_next(snapshot);
 		if (error <= 0)
 			break;
-		error = swap_read_page(data_of(*snapshot), &bio);
+		error = sws_io_ops->read_page(data_of(*snapshot), &bio);
 		if (error)
 			break;
 		if (snapshot->sync_read)
@@ -606,14 +622,14 @@ int swsusp_read(unsigned int *flags_p)
 	if (error < PAGE_SIZE)
 		return error < 0 ? error : -EFAULT;
 	header = (struct swsusp_info *)data_of(snapshot);
-	error = get_swap_reader(flags_p);
+	error = sws_io_ops->get_reader(flags_p);
 	if (error)
 		goto end;
 	if (!error)
-		error = swap_read_page(header, NULL);
+		error = sws_io_ops->read_page(header, NULL);
 	if (!error)
 		error = load_image(&snapshot, header->pages - 1);
-	put_swap_reader();
+	sws_io_ops->put_reader();
 end:
 	if (!error)
 		pr_debug("PM: Image successfully loaded\n");
@@ -682,6 +698,7 @@ static int swsusp_header_init(void)
 	swsusp_header = (struct swsusp_header*) __get_free_page(GFP_KERNEL);
 	if (!swsusp_header)
 		panic("Could not allocate memory for swsusp_header\n");
+	sws_io_ops = &swap_ops;
 	return 0;
 }
 
-- 
1.7.0.2


