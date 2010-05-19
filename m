Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0ESQqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:46:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42710 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab0ESQqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:46:10 -0400
To: linux-fsdevel@vger.kernel.org
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [patch] pipe: add support for shrinking and growing pipes
Message-Id: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 19 May 2010 18:45:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a forward port to 2.6.34 of this patch from Jens:

  http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff_plain;h=24547ac4d97bebb58caf9ce58bd507a95c812a3f

One issue I see is that it's possible to grow pipes indefinitely.
Should this be restricted to privileged users?

Thanks,
Miklos


From: Jens Axboe <jens.axboe@oracle.com>

This patch adds F_GETPIPE_SZ and F_SETPIPE_SZ fcntl() actions for
growing and shrinking the size of a pipe and adjusts pipe.c and splice.c
(and relay and network splice) usage to work with these larger (or smaller)
pipes.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fcntl.c                  |    5 +
 fs/pipe.c                   |  107 ++++++++++++++++++++++++++---
 fs/splice.c                 |  160 +++++++++++++++++++++++++++++---------------
 include/asm-generic/fcntl.h |    7 +
 include/linux/pipe_fs_i.h   |   11 +--
 include/linux/splice.h      |    7 +
 kernel/relay.c              |   19 +++--
 kernel/trace/trace.c        |   60 +++++++++-------
 net/core/skbuff.c           |   39 ++++++----
 9 files changed, 299 insertions(+), 116 deletions(-)

Index: linux-2.6/fs/fcntl.c
===================================================================
--- linux-2.6.orig/fs/fcntl.c	2010-05-14 18:23:05.000000000 +0200
+++ linux-2.6/fs/fcntl.c	2010-05-14 18:23:06.000000000 +0200
@@ -14,6 +14,7 @@
 #include <linux/dnotify.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/pipe_fs_i.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
 #include <linux/signal.h>
@@ -412,6 +413,10 @@ static long do_fcntl(int fd, unsigned in
 	case F_NOTIFY:
 		err = fcntl_dirnotify(fd, filp, arg);
 		break;
+	case F_SETPIPE_SZ:
+	case F_GETPIPE_SZ:
+		err = pipe_fcntl(filp, cmd, arg);
+		break;
 	default:
 		break;
 	}
Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c	2010-05-14 18:23:05.000000000 +0200
+++ linux-2.6/fs/pipe.c	2010-05-14 18:23:06.000000000 +0200
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/log2.h>
 #include <linux/mount.h>
 #include <linux/pipe_fs_i.h>
 #include <linux/uio.h>
@@ -390,7 +391,7 @@ redo:
 			if (!buf->len) {
 				buf->ops = NULL;
 				ops->release(pipe, buf);
-				curbuf = (curbuf + 1) & (PIPE_BUFFERS-1);
+				curbuf = (curbuf + 1) & (pipe->buffers - 1);
 				pipe->curbuf = curbuf;
 				pipe->nrbufs = --bufs;
 				do_wakeup = 1;
@@ -472,7 +473,7 @@ pipe_write(struct kiocb *iocb, const str
 	chars = total_len & (PAGE_SIZE-1); /* size of the last buffer */
 	if (pipe->nrbufs && chars != 0) {
 		int lastbuf = (pipe->curbuf + pipe->nrbufs - 1) &
-							(PIPE_BUFFERS-1);
+							(pipe->buffers - 1);
 		struct pipe_buffer *buf = pipe->bufs + lastbuf;
 		const struct pipe_buf_operations *ops = buf->ops;
 		int offset = buf->offset + buf->len;
@@ -518,8 +519,8 @@ redo1:
 			break;
 		}
 		bufs = pipe->nrbufs;
-		if (bufs < PIPE_BUFFERS) {
-			int newbuf = (pipe->curbuf + bufs) & (PIPE_BUFFERS-1);
+		if (bufs < pipe->buffers) {
+			int newbuf = (pipe->curbuf + bufs) & (pipe->buffers-1);
 			struct pipe_buffer *buf = pipe->bufs + newbuf;
 			struct page *page = pipe->tmp_page;
 			char *src;
@@ -580,7 +581,7 @@ redo2:
 			if (!total_len)
 				break;
 		}
-		if (bufs < PIPE_BUFFERS)
+		if (bufs < pipe->buffers)
 			continue;
 		if (filp->f_flags & O_NONBLOCK) {
 			if (!ret)
@@ -640,7 +641,7 @@ static long pipe_ioctl(struct file *filp
 			nrbufs = pipe->nrbufs;
 			while (--nrbufs >= 0) {
 				count += pipe->bufs[buf].len;
-				buf = (buf+1) & (PIPE_BUFFERS-1);
+				buf = (buf+1) & (pipe->buffers - 1);
 			}
 			mutex_unlock(&inode->i_mutex);
 
@@ -671,7 +672,7 @@ pipe_poll(struct file *filp, poll_table
 	}
 
 	if (filp->f_mode & FMODE_WRITE) {
-		mask |= (nrbufs < PIPE_BUFFERS) ? POLLOUT | POLLWRNORM : 0;
+		mask |= (nrbufs < pipe->buffers) ? POLLOUT | POLLWRNORM : 0;
 		/*
 		 * Most Unices do not set POLLERR for FIFOs but on Linux they
 		 * behave exactly like pipes for poll().
@@ -877,25 +878,32 @@ struct pipe_inode_info * alloc_pipe_info
 
 	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL);
 	if (pipe) {
-		init_waitqueue_head(&pipe->wait);
-		pipe->r_counter = pipe->w_counter = 1;
-		pipe->inode = inode;
+		pipe->bufs = kzalloc(sizeof(struct pipe_buffer) * PIPE_DEF_BUFFERS, GFP_KERNEL);
+		if (pipe->bufs) {
+			init_waitqueue_head(&pipe->wait);
+			pipe->r_counter = pipe->w_counter = 1;
+			pipe->inode = inode;
+			pipe->buffers = PIPE_DEF_BUFFERS;
+			return pipe;
+		}
+		kfree(pipe);
 	}
 
-	return pipe;
+	return NULL;
 }
 
 void __free_pipe_info(struct pipe_inode_info *pipe)
 {
 	int i;
 
-	for (i = 0; i < PIPE_BUFFERS; i++) {
+	for (i = 0; i < pipe->buffers; i++) {
 		struct pipe_buffer *buf = pipe->bufs + i;
 		if (buf->ops)
 			buf->ops->release(pipe, buf);
 	}
 	if (pipe->tmp_page)
 		__free_page(pipe->tmp_page);
+	kfree(pipe->bufs);
 	kfree(pipe);
 }
 
@@ -1094,6 +1102,81 @@ SYSCALL_DEFINE1(pipe, int __user *, fild
 }
 
 /*
+ * Allocate a new array of pipe buffers and copy the info over. Returns the
+ * pipe size if successful, or return -ERROR on error.
+ */
+static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
+{
+	struct pipe_buffer *bufs;
+
+	/*
+	 * Must be a power-of-2 currently
+	 */
+	if (!is_power_of_2(arg))
+		return -EINVAL;
+
+	/*
+	 * We can shrink the pipe, if arg >= pipe->nrbufs. Since we don't
+	 * expect a lot of shrink+grow operations, just free and allocate
+	 * again like we would do for growing. If the pipe currently
+	 * contains more buffers than arg, then return busy.
+	 */
+	if (arg < pipe->nrbufs)
+		return -EBUSY;
+
+	bufs = kcalloc(arg, sizeof(struct pipe_buffer), GFP_KERNEL);
+	if (unlikely(!bufs))
+		return -ENOMEM;
+
+	/*
+	 * The pipe array wraps around, so just start the new one at zero
+	 * and adjust the indexes.
+	 */
+	if (pipe->nrbufs) {
+		const unsigned int tail = pipe->nrbufs & (pipe->buffers - 1);
+		const unsigned int head = pipe->nrbufs - tail;
+
+		if (head)
+			memcpy(bufs, pipe->bufs + pipe->curbuf, head * sizeof(struct pipe_buffer));
+		if (tail)
+			memcpy(bufs + head, pipe->bufs + pipe->curbuf, tail * sizeof(struct pipe_buffer));
+	}
+
+	pipe->curbuf = 0;
+	kfree(pipe->bufs);
+	pipe->bufs = bufs;
+	pipe->buffers = arg;
+	return arg;
+}
+
+long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct pipe_inode_info *pipe;
+	long ret;
+
+	pipe = file->f_path.dentry->d_inode->i_pipe;
+	if (!pipe)
+		return -EBADF;
+
+	mutex_lock(&pipe->inode->i_mutex);
+
+	switch (cmd) {
+	case F_SETPIPE_SZ:
+		ret = pipe_set_size(pipe, arg);
+		break;
+	case F_GETPIPE_SZ:
+		ret = pipe->buffers;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&pipe->inode->i_mutex);
+	return ret;
+}
+
+/*
  * pipefs should _never_ be mounted by userland - too much of security hassle,
  * no real gain from having the whole whorehouse mounted. So we don't need
  * any operations on the root directory. However, we need a non-trivial
Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2010-05-14 18:23:05.000000000 +0200
+++ linux-2.6/fs/splice.c	2010-05-14 18:23:06.000000000 +0200
@@ -193,8 +193,8 @@ ssize_t splice_to_pipe(struct pipe_inode
 			break;
 		}
 
-		if (pipe->nrbufs < PIPE_BUFFERS) {
-			int newbuf = (pipe->curbuf + pipe->nrbufs) & (PIPE_BUFFERS - 1);
+		if (pipe->nrbufs < pipe->buffers) {
+			int newbuf = (pipe->curbuf + pipe->nrbufs) & (pipe->buffers - 1);
 			struct pipe_buffer *buf = pipe->bufs + newbuf;
 
 			buf->page = spd->pages[page_nr];
@@ -214,7 +214,7 @@ ssize_t splice_to_pipe(struct pipe_inode
 
 			if (!--spd->nr_pages)
 				break;
-			if (pipe->nrbufs < PIPE_BUFFERS)
+			if (pipe->nrbufs < pipe->buffers)
 				continue;
 
 			break;
@@ -265,6 +265,36 @@ static void spd_release_page(struct spli
 	page_cache_release(spd->pages[i]);
 }
 
+/*
+ * Check if we need to grow the arrays holding pages and partial page
+ * descriptions.
+ */
+int splice_grow_spd(struct pipe_inode_info *pipe, struct splice_pipe_desc *spd)
+{
+	if (pipe->buffers <= PIPE_DEF_BUFFERS)
+		return 0;
+
+	spd->pages = kmalloc(pipe->buffers * sizeof(struct page *), GFP_KERNEL);
+	spd->partial = kmalloc(pipe->buffers * sizeof(struct partial_page), GFP_KERNEL);
+
+	if (spd->pages && spd->partial)
+		return 0;
+
+	kfree(spd->pages);
+	kfree(spd->partial);
+	return -ENOMEM;
+}
+
+void splice_shrink_spd(struct pipe_inode_info *pipe,
+		       struct splice_pipe_desc *spd)
+{
+	if (pipe->buffers <= PIPE_DEF_BUFFERS)
+		return;
+
+	kfree(spd->pages);
+	kfree(spd->partial);
+}
+
 static int
 __generic_file_splice_read(struct file *in, loff_t *ppos,
 			   struct pipe_inode_info *pipe, size_t len,
@@ -272,29 +302,32 @@ __generic_file_splice_read(struct file *
 {
 	struct address_space *mapping = in->f_mapping;
 	unsigned int loff, nr_pages, req_pages;
-	struct page *pages[PIPE_BUFFERS];
-	struct partial_page partial[PIPE_BUFFERS];
+	struct page *pages_def[PIPE_DEF_BUFFERS];
+	struct partial_page partial_def[PIPE_DEF_BUFFERS];
 	struct page *page;
 	pgoff_t index, end_index;
 	loff_t isize;
 	int error, page_nr;
 	struct splice_pipe_desc spd = {
-		.pages = pages,
-		.partial = partial,
+		.pages = pages_def,
+		.partial = partial_def,
 		.flags = flags,
 		.ops = &page_cache_pipe_buf_ops,
 		.spd_release = spd_release_page,
 	};
 
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
+
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	loff = *ppos & ~PAGE_CACHE_MASK;
 	req_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	nr_pages = min(req_pages, (unsigned)PIPE_BUFFERS);
+	nr_pages = min(req_pages, pipe->buffers);
 
 	/*
 	 * Lookup the (hopefully) full range of pages we need.
 	 */
-	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, pages);
+	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, spd.pages);
 	index += spd.nr_pages;
 
 	/*
@@ -335,7 +368,7 @@ __generic_file_splice_read(struct file *
 			unlock_page(page);
 		}
 
-		pages[spd.nr_pages++] = page;
+		spd.pages[spd.nr_pages++] = page;
 		index++;
 	}
 
@@ -356,7 +389,7 @@ __generic_file_splice_read(struct file *
 		 * this_len is the max we'll use from this page
 		 */
 		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
-		page = pages[page_nr];
+		page = spd.pages[page_nr];
 
 		if (PageReadahead(page))
 			page_cache_async_readahead(mapping, &in->f_ra, in,
@@ -393,8 +426,8 @@ __generic_file_splice_read(struct file *
 					error = -ENOMEM;
 					break;
 				}
-				page_cache_release(pages[page_nr]);
-				pages[page_nr] = page;
+				page_cache_release(spd.pages[page_nr]);
+				spd.pages[page_nr] = page;
 			}
 			/*
 			 * page was already under io and is now done, great
@@ -451,8 +484,8 @@ fill_it:
 			len = this_len;
 		}
 
-		partial[page_nr].offset = loff;
-		partial[page_nr].len = this_len;
+		spd.partial[page_nr].offset = loff;
+		spd.partial[page_nr].len = this_len;
 		len -= this_len;
 		loff = 0;
 		spd.nr_pages++;
@@ -464,12 +497,13 @@ fill_it:
 	 * we got, 'nr_pages' is how many pages are in the map.
 	 */
 	while (page_nr < nr_pages)
-		page_cache_release(pages[page_nr++]);
+		page_cache_release(spd.pages[page_nr++]);
 	in->f_ra.prev_pos = (loff_t)index << PAGE_CACHE_SHIFT;
 
 	if (spd.nr_pages)
-		return splice_to_pipe(pipe, &spd);
+		error = splice_to_pipe(pipe, &spd);
 
+	splice_shrink_spd(pipe, &spd);
 	return error;
 }
 
@@ -560,27 +594,36 @@ ssize_t default_file_splice_read(struct
 	unsigned int nr_pages;
 	unsigned int nr_freed;
 	size_t offset;
-	struct page *pages[PIPE_BUFFERS];
-	struct partial_page partial[PIPE_BUFFERS];
-	struct iovec vec[PIPE_BUFFERS];
+	struct page *pages_def[PIPE_DEF_BUFFERS];
+	struct partial_page partial_def[PIPE_DEF_BUFFERS];
+	struct iovec *vec;
 	pgoff_t index;
 	ssize_t res;
 	size_t this_len;
 	int error;
 	int i;
 	struct splice_pipe_desc spd = {
-		.pages = pages,
-		.partial = partial,
+		.pages = pages_def,
+		.partial = partial_def,
 		.flags = flags,
 		.ops = &default_pipe_buf_ops,
 		.spd_release = spd_release_page,
 	};
 
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
+
+	vec = kmalloc(pipe->buffers * sizeof(struct iovec), GFP_KERNEL);
+	if (!vec) {
+		res = -ENOMEM;
+		goto out;
+	}
+
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 	nr_pages = (len + offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
-	for (i = 0; i < nr_pages && i < PIPE_BUFFERS && len; i++) {
+	for (i = 0; i < nr_pages && i < pipe->buffers && len; i++) {
 		struct page *page;
 
 		page = alloc_page(GFP_USER);
@@ -591,7 +634,7 @@ ssize_t default_file_splice_read(struct
 		this_len = min_t(size_t, len, PAGE_CACHE_SIZE - offset);
 		vec[i].iov_base = (void __user *) page_address(page);
 		vec[i].iov_len = this_len;
-		pages[i] = page;
+		spd.pages[i] = page;
 		spd.nr_pages++;
 		len -= this_len;
 		offset = 0;
@@ -610,11 +653,11 @@ ssize_t default_file_splice_read(struct
 	nr_freed = 0;
 	for (i = 0; i < spd.nr_pages; i++) {
 		this_len = min_t(size_t, vec[i].iov_len, res);
-		partial[i].offset = 0;
-		partial[i].len = this_len;
+		spd.partial[i].offset = 0;
+		spd.partial[i].len = this_len;
 		if (!this_len) {
-			__free_page(pages[i]);
-			pages[i] = NULL;
+			__free_page(spd.pages[i]);
+			spd.pages[i] = NULL;
 			nr_freed++;
 		}
 		res -= this_len;
@@ -625,13 +668,17 @@ ssize_t default_file_splice_read(struct
 	if (res > 0)
 		*ppos += res;
 
+out:
+	splice_shrink_spd(pipe, &spd);
+	kfree(vec);
 	return res;
 
 err:
 	for (i = 0; i < spd.nr_pages; i++)
-		__free_page(pages[i]);
+		__free_page(spd.pages[i]);
 
-	return error;
+	res = error;
+	goto out;
 }
 EXPORT_SYMBOL(default_file_splice_read);
 
@@ -784,7 +831,7 @@ int splice_from_pipe_feed(struct pipe_in
 		if (!buf->len) {
 			buf->ops = NULL;
 			ops->release(pipe, buf);
-			pipe->curbuf = (pipe->curbuf + 1) & (PIPE_BUFFERS - 1);
+			pipe->curbuf = (pipe->curbuf + 1) & (pipe->buffers - 1);
 			pipe->nrbufs--;
 			if (pipe->inode)
 				sd->need_wakeup = true;
@@ -1211,7 +1258,7 @@ out_release:
 	 * If we did an incomplete transfer we must release
 	 * the pipe buffers in question:
 	 */
-	for (i = 0; i < PIPE_BUFFERS; i++) {
+	for (i = 0; i < pipe->buffers; i++) {
 		struct pipe_buffer *buf = pipe->bufs + i;
 
 		if (buf->ops) {
@@ -1371,7 +1418,8 @@ static long do_splice(struct file *in, l
  */
 static int get_iovec_page_array(const struct iovec __user *iov,
 				unsigned int nr_vecs, struct page **pages,
-				struct partial_page *partial, int aligned)
+				struct partial_page *partial, int aligned,
+				unsigned int pipe_buffers)
 {
 	int buffers = 0, error = 0;
 
@@ -1414,8 +1462,8 @@ static int get_iovec_page_array(const st
 			break;
 
 		npages = (off + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		if (npages > PIPE_BUFFERS - buffers)
-			npages = PIPE_BUFFERS - buffers;
+		if (npages > pipe_buffers - buffers)
+			npages = pipe_buffers - buffers;
 
 		error = get_user_pages_fast((unsigned long)base, npages,
 					0, &pages[buffers]);
@@ -1450,7 +1498,7 @@ static int get_iovec_page_array(const st
 		 * or if we mapped the max number of pages that we have
 		 * room for.
 		 */
-		if (error < npages || buffers == PIPE_BUFFERS)
+		if (error < npages || buffers == pipe_buffers)
 			break;
 
 		nr_vecs--;
@@ -1593,26 +1641,34 @@ static long vmsplice_to_pipe(struct file
 			     unsigned long nr_segs, unsigned int flags)
 {
 	struct pipe_inode_info *pipe;
-	struct page *pages[PIPE_BUFFERS];
-	struct partial_page partial[PIPE_BUFFERS];
+	struct page *pages_def[PIPE_DEF_BUFFERS];
+	struct partial_page partial_def[PIPE_DEF_BUFFERS];
 	struct splice_pipe_desc spd = {
-		.pages = pages,
-		.partial = partial,
+		.pages = pages_def,
+		.partial = partial_def,
 		.flags = flags,
 		.ops = &user_page_pipe_buf_ops,
 		.spd_release = spd_release_page,
 	};
+	long ret;
 
 	pipe = pipe_info(file->f_path.dentry->d_inode);
 	if (!pipe)
 		return -EBADF;
 
-	spd.nr_pages = get_iovec_page_array(iov, nr_segs, pages, partial,
-					    flags & SPLICE_F_GIFT);
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
+
+	spd.nr_pages = get_iovec_page_array(iov, nr_segs, spd.pages,
+					    spd.partial, flags & SPLICE_F_GIFT,
+					    pipe->buffers);
 	if (spd.nr_pages <= 0)
-		return spd.nr_pages;
+		ret = spd.nr_pages;
+	else
+		ret = splice_to_pipe(pipe, &spd);
 
-	return splice_to_pipe(pipe, &spd);
+	splice_shrink_spd(pipe, &spd);
+	return ret;
 }
 
 /*
@@ -1738,13 +1794,13 @@ static int opipe_prep(struct pipe_inode_
 	 * Check ->nrbufs without the inode lock first. This function
 	 * is speculative anyways, so missing one is ok.
 	 */
-	if (pipe->nrbufs < PIPE_BUFFERS)
+	if (pipe->nrbufs < pipe->buffers)
 		return 0;
 
 	ret = 0;
 	pipe_lock(pipe);
 
-	while (pipe->nrbufs >= PIPE_BUFFERS) {
+	while (pipe->nrbufs >= pipe->buffers) {
 		if (!pipe->readers) {
 			send_sig(SIGPIPE, current, 0);
 			ret = -EPIPE;
@@ -1810,7 +1866,7 @@ retry:
 		 * Cannot make any progress, because either the input
 		 * pipe is empty or the output pipe is full.
 		 */
-		if (!ipipe->nrbufs || opipe->nrbufs >= PIPE_BUFFERS) {
+		if (!ipipe->nrbufs || opipe->nrbufs >= opipe->buffers) {
 			/* Already processed some buffers, break */
 			if (ret)
 				break;
@@ -1831,7 +1887,7 @@ retry:
 		}
 
 		ibuf = ipipe->bufs + ipipe->curbuf;
-		nbuf = (opipe->curbuf + opipe->nrbufs) % PIPE_BUFFERS;
+		nbuf = (opipe->curbuf + opipe->nrbufs) & (opipe->buffers - 1);
 		obuf = opipe->bufs + nbuf;
 
 		if (len >= ibuf->len) {
@@ -1841,7 +1897,7 @@ retry:
 			*obuf = *ibuf;
 			ibuf->ops = NULL;
 			opipe->nrbufs++;
-			ipipe->curbuf = (ipipe->curbuf + 1) % PIPE_BUFFERS;
+			ipipe->curbuf = (ipipe->curbuf + 1) & (ipipe->buffers - 1);
 			ipipe->nrbufs--;
 			input_wakeup = true;
 		} else {
@@ -1914,11 +1970,11 @@ static int link_pipe(struct pipe_inode_i
 		 * If we have iterated all input buffers or ran out of
 		 * output room, break.
 		 */
-		if (i >= ipipe->nrbufs || opipe->nrbufs >= PIPE_BUFFERS)
+		if (i >= ipipe->nrbufs || opipe->nrbufs >= opipe->buffers)
 			break;
 
-		ibuf = ipipe->bufs + ((ipipe->curbuf + i) & (PIPE_BUFFERS - 1));
-		nbuf = (opipe->curbuf + opipe->nrbufs) & (PIPE_BUFFERS - 1);
+		ibuf = ipipe->bufs + ((ipipe->curbuf + i) & (ipipe->buffers-1));
+		nbuf = (opipe->curbuf + opipe->nrbufs) & (opipe->buffers - 1);
 
 		/*
 		 * Get a reference to this pipe buffer,
Index: linux-2.6/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.orig/include/asm-generic/fcntl.h	2010-05-14 18:23:05.000000000 +0200
+++ linux-2.6/include/asm-generic/fcntl.h	2010-05-14 18:23:06.000000000 +0200
@@ -104,6 +104,13 @@
 #define F_GETOWN_EX	16
 #endif
 
+#ifndef F_SETPIPE_SZ		/* for growing pipe sizes */
+#define F_SETPIPE_SZ	17
+#endif
+#ifndef F_GETPIPE_SZ
+#define F_GETPIPE_SZ	18
+#endif
+
 #define F_OWNER_TID	0
 #define F_OWNER_PID	1
 #define F_OWNER_PGRP	2
Index: linux-2.6/include/linux/pipe_fs_i.h
===================================================================
--- linux-2.6.orig/include/linux/pipe_fs_i.h	2010-05-14 18:23:05.000000000 +0200
+++ linux-2.6/include/linux/pipe_fs_i.h	2010-05-14 18:23:06.000000000 +0200
@@ -3,7 +3,7 @@
 
 #define PIPEFS_MAGIC 0x50495045
 
-#define PIPE_BUFFERS (16)
+#define PIPE_DEF_BUFFERS	16
 
 #define PIPE_BUF_FLAG_LRU	0x01	/* page is on the LRU */
 #define PIPE_BUF_FLAG_ATOMIC	0x02	/* was atomically mapped */
@@ -44,17 +44,17 @@ struct pipe_buffer {
  **/
 struct pipe_inode_info {
 	wait_queue_head_t wait;
-	unsigned int nrbufs, curbuf;
-	struct page *tmp_page;
+	unsigned int nrbufs, curbuf, buffers;
 	unsigned int readers;
 	unsigned int writers;
 	unsigned int waiting_writers;
 	unsigned int r_counter;
 	unsigned int w_counter;
+	struct page *tmp_page;
 	struct fasync_struct *fasync_readers;
 	struct fasync_struct *fasync_writers;
 	struct inode *inode;
-	struct pipe_buffer bufs[PIPE_BUFFERS];
+	struct pipe_buffer *bufs;
 };
 
 /*
@@ -154,4 +154,7 @@ int generic_pipe_buf_confirm(struct pipe
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
 void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
 
+/* for F_SETPIPE_SZ and F_GETPIPE_SZ */
+long pipe_fcntl(struct file *, unsigned int, unsigned long arg);
+
 #endif
Index: linux-2.6/include/linux/splice.h
===================================================================
--- linux-2.6.orig/include/linux/splice.h	2010-05-14 18:23:05.000000000 +0200
+++ linux-2.6/include/linux/splice.h	2010-05-14 18:23:06.000000000 +0200
@@ -82,4 +82,11 @@ extern ssize_t splice_to_pipe(struct pip
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
 
+/*
+ * for dynamic pipe sizing
+ */
+extern int splice_grow_spd(struct pipe_inode_info *, struct splice_pipe_desc *);
+extern void splice_shrink_spd(struct pipe_inode_info *,
+				struct splice_pipe_desc *);
+
 #endif
Index: linux-2.6/kernel/relay.c
===================================================================
--- linux-2.6.orig/kernel/relay.c	2010-05-14 18:23:05.000000000 +0200
+++ linux-2.6/kernel/relay.c	2010-05-14 18:23:06.000000000 +0200
@@ -1231,12 +1231,12 @@ static ssize_t subbuf_splice_actor(struc
 	size_t read_subbuf = read_start / subbuf_size;
 	size_t padding = rbuf->padding[read_subbuf];
 	size_t nonpad_end = read_subbuf * subbuf_size + subbuf_size - padding;
-	struct page *pages[PIPE_BUFFERS];
-	struct partial_page partial[PIPE_BUFFERS];
+	struct page *pages_def[PIPE_DEF_BUFFERS];
+	struct partial_page partial_def[PIPE_DEF_BUFFERS];
 	struct splice_pipe_desc spd = {
-		.pages = pages,
+		.pages = pages_def,
 		.nr_pages = 0,
-		.partial = partial,
+		.partial = partial_def,
 		.flags = flags,
 		.ops = &relay_pipe_buf_ops,
 		.spd_release = relay_page_release,
@@ -1245,6 +1245,8 @@ static ssize_t subbuf_splice_actor(struc
 
 	if (rbuf->subbufs_produced == rbuf->subbufs_consumed)
 		return 0;
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
 
 	/*
 	 * Adjust read len, if longer than what is available
@@ -1255,7 +1257,7 @@ static ssize_t subbuf_splice_actor(struc
 	subbuf_pages = rbuf->chan->alloc_size >> PAGE_SHIFT;
 	pidx = (read_start / PAGE_SIZE) % subbuf_pages;
 	poff = read_start & ~PAGE_MASK;
-	nr_pages = min_t(unsigned int, subbuf_pages, PIPE_BUFFERS);
+	nr_pages = min_t(unsigned int, subbuf_pages, pipe->buffers);
 
 	for (total_len = 0; spd.nr_pages < nr_pages; spd.nr_pages++) {
 		unsigned int this_len, this_end, private;
@@ -1289,16 +1291,19 @@ static ssize_t subbuf_splice_actor(struc
 		}
 	}
 
+	ret = 0;
 	if (!spd.nr_pages)
-		return 0;
+		goto out;
 
 	ret = *nonpad_ret = splice_to_pipe(pipe, &spd);
 	if (ret < 0 || ret < total_len)
-		return ret;
+		goto out;
 
         if (read_start + ret == nonpad_end)
                 ret += padding;
 
+out:
+	splice_shrink_spd(pipe, &spd);
         return ret;
 }
 
Index: linux-2.6/net/core/skbuff.c
===================================================================
--- linux-2.6.orig/net/core/skbuff.c	2010-05-14 18:23:05.000000000 +0200
+++ linux-2.6/net/core/skbuff.c	2010-05-14 18:23:06.000000000 +0200
@@ -1417,12 +1417,13 @@ new_page:
 /*
  * Fill page/offset/length into spd, if it can hold more pages.
  */
-static inline int spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
+static inline int spd_fill_page(struct splice_pipe_desc *spd,
+				struct pipe_inode_info *pipe, struct page *page,
 				unsigned int *len, unsigned int offset,
 				struct sk_buff *skb, int linear,
 				struct sock *sk)
 {
-	if (unlikely(spd->nr_pages == PIPE_BUFFERS))
+	if (unlikely(spd->nr_pages == pipe->buffers))
 		return 1;
 
 	if (linear) {
@@ -1457,8 +1458,9 @@ static inline void __segment_seek(struct
 static inline int __splice_segment(struct page *page, unsigned int poff,
 				   unsigned int plen, unsigned int *off,
 				   unsigned int *len, struct sk_buff *skb,
-				   struct splice_pipe_desc *spd, int linear,
-				   struct sock *sk)
+				   struct splice_pipe_desc *spd,
+				   struct pipe_inode_info *pipe,
+				   int linear, struct sock *sk)
 {
 	if (!*len)
 		return 1;
@@ -1481,7 +1483,7 @@ static inline int __splice_segment(struc
 		/* the linear region may spread across several pages  */
 		flen = min_t(unsigned int, flen, PAGE_SIZE - poff);
 
-		if (spd_fill_page(spd, page, &flen, poff, skb, linear, sk))
+		if (spd_fill_page(spd, pipe, page, &flen, poff, skb, linear, sk))
 			return 1;
 
 		__segment_seek(&page, &poff, &plen, flen);
@@ -1498,7 +1500,7 @@ static inline int __splice_segment(struc
  */
 static int __skb_splice_bits(struct sk_buff *skb, unsigned int *offset,
 			     unsigned int *len, struct splice_pipe_desc *spd,
-			     struct sock *sk)
+			     struct pipe_inode_info *pipe, struct sock *sk)
 {
 	int seg;
 
@@ -1508,7 +1510,7 @@ static int __skb_splice_bits(struct sk_b
 	if (__splice_segment(virt_to_page(skb->data),
 			     (unsigned long) skb->data & (PAGE_SIZE - 1),
 			     skb_headlen(skb),
-			     offset, len, skb, spd, 1, sk))
+			     offset, len, skb, spd, pipe, 1, sk))
 		return 1;
 
 	/*
@@ -1518,7 +1520,7 @@ static int __skb_splice_bits(struct sk_b
 		const skb_frag_t *f = &skb_shinfo(skb)->frags[seg];
 
 		if (__splice_segment(f->page, f->page_offset, f->size,
-				     offset, len, skb, spd, 0, sk))
+				     offset, len, skb, spd, pipe, 0, sk))
 			return 1;
 	}
 
@@ -1535,23 +1537,27 @@ int skb_splice_bits(struct sk_buff *skb,
 		    struct pipe_inode_info *pipe, unsigned int tlen,
 		    unsigned int flags)
 {
-	struct partial_page partial[PIPE_BUFFERS];
-	struct page *pages[PIPE_BUFFERS];
+	struct partial_page partial_def[PIPE_DEF_BUFFERS];
+	struct page *pages_def[PIPE_DEF_BUFFERS];
 	struct splice_pipe_desc spd = {
-		.pages = pages,
-		.partial = partial,
+		.pages = pages_def,
+		.partial = partial_def,
 		.flags = flags,
 		.ops = &sock_pipe_buf_ops,
 		.spd_release = sock_spd_release,
 	};
 	struct sk_buff *frag_iter;
 	struct sock *sk = skb->sk;
+	int ret = 0;
+
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
 
 	/*
 	 * __skb_splice_bits() only fails if the output has no room left,
 	 * so no point in going over the frag_list for the error case.
 	 */
-	if (__skb_splice_bits(skb, &offset, &tlen, &spd, sk))
+	if (__skb_splice_bits(skb, &offset, &tlen, &spd, pipe, sk))
 		goto done;
 	else if (!tlen)
 		goto done;
@@ -1562,13 +1568,12 @@ int skb_splice_bits(struct sk_buff *skb,
 	skb_walk_frags(skb, frag_iter) {
 		if (!tlen)
 			break;
-		if (__skb_splice_bits(frag_iter, &offset, &tlen, &spd, sk))
+		if (__skb_splice_bits(frag_iter, &offset, &tlen, &spd, pipe, sk))
 			break;
 	}
 
 done:
 	if (spd.nr_pages) {
-		int ret;
 
 		/*
 		 * Drop the socket lock, otherwise we have reverse
@@ -1582,10 +1587,10 @@ done:
 		release_sock(sk);
 		ret = splice_to_pipe(pipe, &spd);
 		lock_sock(sk);
-		return ret;
 	}
 
-	return 0;
+	splice_shrink_spd(pipe, &spd);
+	return ret;
 }
 
 /**
Index: linux-2.6/kernel/trace/trace.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace.c	2010-05-12 11:19:25.000000000 +0200
+++ linux-2.6/kernel/trace/trace.c	2010-05-14 18:27:42.000000000 +0200
@@ -3269,12 +3269,12 @@ static ssize_t tracing_splice_read_pipe(
 					size_t len,
 					unsigned int flags)
 {
-	struct page *pages[PIPE_BUFFERS];
-	struct partial_page partial[PIPE_BUFFERS];
+	struct page *pages_def[PIPE_DEF_BUFFERS];
+	struct partial_page partial_def[PIPE_DEF_BUFFERS];
 	struct trace_iterator *iter = filp->private_data;
 	struct splice_pipe_desc spd = {
-		.pages		= pages,
-		.partial	= partial,
+		.pages		= pages_def,
+		.partial	= partial_def,
 		.nr_pages	= 0, /* This gets updated below. */
 		.flags		= flags,
 		.ops		= &tracing_pipe_buf_ops,
@@ -3285,6 +3285,9 @@ static ssize_t tracing_splice_read_pipe(
 	size_t rem;
 	unsigned int i;
 
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
+
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
 	if (unlikely(old_tracer != current_trace && current_trace)) {
@@ -3315,23 +3318,23 @@ static ssize_t tracing_splice_read_pipe(
 	trace_access_lock(iter->cpu_file);
 
 	/* Fill as many pages as possible. */
-	for (i = 0, rem = len; i < PIPE_BUFFERS && rem; i++) {
-		pages[i] = alloc_page(GFP_KERNEL);
-		if (!pages[i])
+	for (i = 0, rem = len; i < pipe->buffers && rem; i++) {
+		spd.pages[i] = alloc_page(GFP_KERNEL);
+		if (!spd.pages[i])
 			break;
 
 		rem = tracing_fill_pipe_page(rem, iter);
 
 		/* Copy the data into the page, so we can start over. */
 		ret = trace_seq_to_buffer(&iter->seq,
-					  page_address(pages[i]),
+					  page_address(spd.pages[i]),
 					  iter->seq.len);
 		if (ret < 0) {
-			__free_page(pages[i]);
+			__free_page(spd.pages[i]);
 			break;
 		}
-		partial[i].offset = 0;
-		partial[i].len = iter->seq.len;
+		spd.partial[i].offset = 0;
+		spd.partial[i].len = iter->seq.len;
 
 		trace_seq_init(&iter->seq);
 	}
@@ -3342,12 +3345,14 @@ static ssize_t tracing_splice_read_pipe(
 
 	spd.nr_pages = i;
 
-	return splice_to_pipe(pipe, &spd);
+	ret = splice_to_pipe(pipe, &spd);
+out:
+	splice_shrink_spd(pipe, &spd);
+	return ret;
 
 out_err:
 	mutex_unlock(&iter->mutex);
-
-	return ret;
+	goto out;
 }
 
 static ssize_t
@@ -3746,11 +3751,11 @@ tracing_buffers_splice_read(struct file
 			    unsigned int flags)
 {
 	struct ftrace_buffer_info *info = file->private_data;
-	struct partial_page partial[PIPE_BUFFERS];
-	struct page *pages[PIPE_BUFFERS];
+	struct partial_page partial_def[PIPE_DEF_BUFFERS];
+	struct page *pages_def[PIPE_DEF_BUFFERS];
 	struct splice_pipe_desc spd = {
-		.pages		= pages,
-		.partial	= partial,
+		.pages		= pages_def,
+		.partial	= partial_def,
 		.flags		= flags,
 		.ops		= &buffer_pipe_buf_ops,
 		.spd_release	= buffer_spd_release,
@@ -3759,22 +3764,28 @@ tracing_buffers_splice_read(struct file
 	int entries, size, i;
 	size_t ret;
 
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
+
 	if (*ppos & (PAGE_SIZE - 1)) {
 		WARN_ONCE(1, "Ftrace: previous read must page-align\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	if (len & (PAGE_SIZE - 1)) {
 		WARN_ONCE(1, "Ftrace: splice_read should page-align\n");
-		if (len < PAGE_SIZE)
-			return -EINVAL;
+		if (len < PAGE_SIZE) {
+			ret = -EINVAL;
+			goto out;
+		}
 		len &= PAGE_MASK;
 	}
 
 	trace_access_lock(info->cpu);
 	entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
 
-	for (i = 0; i < PIPE_BUFFERS && len && entries; i++, len -= PAGE_SIZE) {
+	for (i = 0; i < pipe->buffers && len && entries; i++, len -= PAGE_SIZE) {
 		struct page *page;
 		int r;
 
@@ -3829,11 +3840,12 @@ tracing_buffers_splice_read(struct file
 		else
 			ret = 0;
 		/* TODO: block */
-		return ret;
+		goto out;
 	}
 
 	ret = splice_to_pipe(pipe, &spd);
-
+	splice_shrink_spd(pipe, &spd);
+out:
 	return ret;
 }
 
