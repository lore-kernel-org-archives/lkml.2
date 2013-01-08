Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab3AHNfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:35:13 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:60861 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab3AHNfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:35:12 -0500
MIME-Version: 1.0
Date: Tue, 8 Jan 2013 21:35:11 +0800
Message-ID: <CAKWKT+bYwVXxi_pAG7S+htF9NYNtNxLN=Td+aqaynuHmD00DbA@mail.gmail.com>
Subject: [PATCH] fix multiple mark_page_accessed called when sequentially
 writing a file with blocksize less than PAGE_SIZE ,which might pollute the LRU.
From: Qiang Gao <gaoqiangscut@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sequential write to a file with blocksize less than PAGE_SIZE  will call
mark_page_accessed multiple times,

	if (!pagevec_space(pvec))
 		__pagevec_lru_add(pvec, lru);
it seems this trick fix this problem,but not quite thoroughly. there's a chance
that when another page was added to the pvec before the 14th page was
secondly mark_page_accesseded, then the 14th page was still active.



diff --git a/fs/open.c b/fs/open.c
index 9b33c0c..a418419 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -674,6 +674,13 @@ int open_check_o_direct(struct file *f)
 	return 0;
 }

+
+static void
+file_w_state_init(struct file_w_state *wstat)
+{
+	wstat->prev_w_pos=-1;
+}
+
 static int do_dentry_open(struct file *f,
 			  int (*open)(struct inode *, struct file *),
 			  const struct cred *cred)
@@ -730,6 +737,7 @@ static int do_dentry_open(struct file *f,
 	f->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);

 	file_ra_state_init(&f->f_ra, f->f_mapping->host->i_mapping);
+	file_w_state_init(&f->f_wstat);

 	return 0;

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7617ee0..b90d3ff 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -746,6 +746,10 @@ struct file_ra_state {
 	loff_t prev_pos;		/* Cache last read() position */
 };

+struct file_w_state {
+	loff_t prev_w_pos;
+};
+
 /*
  * Check if @index falls in the readahead windows.
  */
@@ -787,6 +791,7 @@ struct file {
 	struct fown_struct	f_owner;
 	const struct cred	*f_cred;
 	struct file_ra_state	f_ra;
+	struct file_w_state		f_wstat;

 	u64			f_version;
 #ifdef CONFIG_SECURITY
diff --git a/mm/filemap.c b/mm/filemap.c
index 83efee7..ea144a9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2287,6 +2287,9 @@ static ssize_t generic_perform_write(struct file *file,
 	long status = 0;
 	ssize_t written = 0;
 	unsigned int flags = 0;
+	unsigned long prev_pos=file->f_wstat.prev_w_pos;
+	unsigned long prev_off=(prev_pos & (PAGE_CACHE_SIZE -1));
+	pgoff_t prev_index=(prev_pos >> PAGE_CACHE_SHIFT);

 	/*
 	 * Copies from kernel address space cannot fail (NFSD is a big user).
@@ -2296,12 +2299,14 @@ static ssize_t generic_perform_write(struct file *file,

 	do {
 		struct page *page;
+		pgoff_t index;
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
 		void *fsdata;

 		offset = (pos & (PAGE_CACHE_SIZE - 1));
+		index = pos >> PAGE_CACHE_SHIFT;
 		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
 						iov_iter_count(i));

@@ -2334,7 +2339,8 @@ again:
 		pagefault_enable();
 		flush_dcache_page(page);

-		mark_page_accessed(page);
+		if (index != prev_index || offset != prev_off)
+			mark_page_accessed(page);
 		status = a_ops->write_end(file, mapping, pos, bytes, copied,
 						page, fsdata);
 		if (unlikely(status < 0))
@@ -2359,6 +2365,8 @@ again:
 		}
 		pos += copied;
 		written += copied;
+		prev_index = index;
+		prev_off = offset;

 		balance_dirty_pages_ratelimited(mapping);
 		if (fatal_signal_pending(current)) {
@@ -2367,6 +2375,7 @@ again:
 		}
 	} while (iov_iter_count(i));

+	file->f_wstat.prev_w_pos=pos;
 	return written ? written : status;
 }
