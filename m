Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0GIXiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:38:13 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59632 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab0GIXhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:37:32 -0400
Message-Id: <20100709225818.636671595@efficios.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 18:57:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [patch 15/20] Ring buffer library - VFS operations
References: <20100709225727.312232266@efficios.com>
Content-Disposition: inline; filename=ring-buffer-vfs.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  9 Jul 2010 22:58:19 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File operation supports for ring buffer reader. splice() and mmap().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 Documentation/ioctl/ioctl-number.txt |    2 
 include/linux/ringbuffer/vfs.h       |   57 +++++++
 lib/ringbuffer/Makefile              |    3 
 lib/ringbuffer/ring_buffer_mmap.c    |  115 +++++++++++++++
 lib/ringbuffer/ring_buffer_splice.c  |  190 +++++++++++++++++++++++++
 lib/ringbuffer/ring_buffer_vfs.c     |  257 +++++++++++++++++++++++++++++++++++
 6 files changed, 624 insertions(+)

Index: linux.trees.git/lib/ringbuffer/Makefile
===================================================================
--- linux.trees.git.orig/lib/ringbuffer/Makefile	2010-07-09 18:13:53.000000000 -0400
+++ linux.trees.git/lib/ringbuffer/Makefile	2010-07-09 18:29:10.000000000 -0400
@@ -1,2 +1,5 @@
 obj-y += ring_buffer_backend.o
 obj-y += ring_buffer_frontend.o
+obj-y += ring_buffer_vfs.o
+obj-y += ring_buffer_splice.o
+obj-y += ring_buffer_mmap.o
Index: linux.trees.git/lib/ringbuffer/ring_buffer_splice.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/lib/ringbuffer/ring_buffer_splice.c	2010-07-09 18:30:04.000000000 -0400
@@ -0,0 +1,190 @@
+/*
+ * ring_buffer_splice.c
+ *
+ * Copyright (C) 2002-2005 - Tom Zanussi <zanussi@us.ibm.com>, IBM Corp
+ * Copyright (C) 1999-2005 - Karim Yaghmour <karim@opersys.com>
+ * Copyright (C) 2008-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Re-using content from kernel/relay.c.
+ *
+ * This file is released under the GPL v2.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+
+#include <linux/ringbuffer/backend.h>
+#include <linux/ringbuffer/frontend.h>
+#include <linux/ringbuffer/vfs.h>
+
+#if 0
+#define printk_dbg(fmt, args...) printk(fmt, args)
+#else
+#define printk_dbg(fmt, args...)
+#endif
+
+loff_t ring_buffer_no_llseek(struct file *file, loff_t offset, int origin)
+{
+	return -ESPIPE;
+}
+
+/*
+ * Release pages from the buffer so splice pipe_to_file can move them.
+ * Called after the pipe has been populated with buffer pages.
+ */
+static void ring_buffer_pipe_buf_release(struct pipe_inode_info *pipe,
+					 struct pipe_buffer *pbuf)
+{
+	__free_page(pbuf->page);
+}
+
+static const struct pipe_buf_operations ring_buffer_pipe_buf_ops = {
+	.can_merge = 0,
+	.map = generic_pipe_buf_map,
+	.unmap = generic_pipe_buf_unmap,
+	.confirm = generic_pipe_buf_confirm,
+	.release = ring_buffer_pipe_buf_release,
+	.steal = generic_pipe_buf_steal,
+	.get = generic_pipe_buf_get,
+};
+
+/*
+ * Page release operation after splice pipe_to_file ends.
+ */
+static void ring_buffer_page_release(struct splice_pipe_desc *spd,
+				     unsigned int i)
+{
+	__free_page(spd->pages[i]);
+}
+
+/*
+ *	subbuf_splice_actor - splice up to one subbuf's worth of data
+ */
+static int subbuf_splice_actor(struct file *in,
+			       loff_t *ppos,
+			       struct pipe_inode_info *pipe,
+			       size_t len,
+			       unsigned int flags)
+{
+	struct ring_buffer *buf = in->private_data;
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned int poff, subbuf_pages, nr_pages;
+	struct page *pages[PIPE_DEF_BUFFERS];
+	struct partial_page partial[PIPE_DEF_BUFFERS];
+	struct splice_pipe_desc spd = {
+		.pages = pages,
+		.nr_pages = 0,
+		.partial = partial,
+		.flags = flags,
+		.ops = &ring_buffer_pipe_buf_ops,
+		.spd_release = ring_buffer_page_release,
+	};
+	unsigned long consumed_old, consumed_idx, roffset;
+	unsigned long bytes_avail;
+
+	/*
+	 * Check that a GET_SUBBUF ioctl has been done before.
+	 */
+	WARN_ON(atomic_long_read(&buf->active_readers) != 1);
+	consumed_old = ring_buffer_get_consumed(config, buf);
+	consumed_old += *ppos;
+	consumed_idx = subbuf_index(consumed_old, chan);
+
+	/*
+	 * Adjust read len, if longer than what is available.
+	 * Max read size is 1 subbuffer due to get_subbuf/put_subbuf for
+	 * protection.
+	 */
+	bytes_avail = chan->backend.subbuf_size;
+	WARN_ON(bytes_avail > chan->backend.buf_size);
+	len = min_t(size_t, len, bytes_avail);
+	subbuf_pages = bytes_avail >> PAGE_SHIFT;
+	nr_pages = min_t(unsigned int, subbuf_pages, PIPE_DEF_BUFFERS);
+	roffset = consumed_old & PAGE_MASK;
+	poff = consumed_old & ~PAGE_MASK;
+	printk_dbg(KERN_DEBUG "SPLICE actor len %zu pos %zd write_pos %ld\n",
+		   len, (ssize_t)*ppos, ring_buffer_get_offset(config, buf));
+
+	for (; spd.nr_pages < nr_pages; spd.nr_pages++) {
+		unsigned int this_len;
+		struct page **page, *new_page;
+		void **virt;
+
+		if (!len)
+			break;
+		printk_dbg(KERN_DEBUG "SPLICE actor loop len %zu roffset %ld\n",
+			   len, roffset);
+
+		/*
+		 * We have to replace the page we are moving into the splice
+		 * pipe.
+		 */
+		new_page = alloc_pages_node(cpu_to_node(max(buf->backend.cpu,
+							    0)),
+					    GFP_KERNEL | __GFP_ZERO, 0);
+		if (!new_page)
+			break;
+
+		this_len = PAGE_SIZE - poff;
+		page = ring_buffer_read_get_page(&buf->backend, roffset, &virt);
+		spd.pages[spd.nr_pages] = *page;
+		*page = new_page;
+		*virt = page_address(new_page);
+		spd.partial[spd.nr_pages].offset = poff;
+		spd.partial[spd.nr_pages].len = this_len;
+
+		poff = 0;
+		roffset += PAGE_SIZE;
+		len -= this_len;
+	}
+
+	if (!spd.nr_pages)
+		return 0;
+
+	return splice_to_pipe(pipe, &spd);
+}
+
+ssize_t ring_buffer_splice_read(struct file *in, loff_t *ppos,
+				struct pipe_inode_info *pipe, size_t len,
+				unsigned int flags)
+{
+	struct ring_buffer *buf = in->private_data;
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+	ssize_t spliced;
+	int ret;
+
+	if (config->output != RING_BUFFER_SPLICE)
+		return -EINVAL;
+
+	ret = 0;
+	spliced = 0;
+
+	printk_dbg(KERN_DEBUG "SPLICE read len %zu pos %zd\n", len,
+		   (ssize_t)*ppos);
+	while (len && !spliced) {
+		ret = subbuf_splice_actor(in, ppos, pipe, len, flags);
+		printk_dbg(KERN_DEBUG "SPLICE read loop ret %d\n", ret);
+		if (ret < 0)
+			break;
+		else if (!ret) {
+			if (flags & SPLICE_F_NONBLOCK)
+				ret = -EAGAIN;
+			break;
+		}
+
+		*ppos += ret;
+		if (ret > len)
+			len = 0;
+		else
+			len -= ret;
+		spliced += ret;
+	}
+
+	if (spliced)
+		return spliced;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_splice_read);
Index: linux.trees.git/Documentation/ioctl/ioctl-number.txt
===================================================================
--- linux.trees.git.orig/Documentation/ioctl/ioctl-number.txt	2010-07-09 18:08:14.000000000 -0400
+++ linux.trees.git/Documentation/ioctl/ioctl-number.txt	2010-07-09 18:29:10.000000000 -0400
@@ -320,4 +320,6 @@ Code  Seq#(hex)	Include File		Comments
 					<mailto:thomas@winischhofer.net>
 0xF4	00-1F	video/mbxfb.h		mbxfb
 					<mailto:raph@8d.com>
+0xF6	00-3F	lib/ringbuffer/ring_buffer_vfs.h	Ring Buffer Library
+					<mailto:mathieu.desnoyers@efficios.com>
 0xFD	all	linux/dm-ioctl.h
Index: linux.trees.git/lib/ringbuffer/ring_buffer_mmap.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/lib/ringbuffer/ring_buffer_mmap.c	2010-07-09 18:29:10.000000000 -0400
@@ -0,0 +1,115 @@
+/*
+ * ring_buffer_mmap.c
+ *
+ * Copyright (C) 2002-2005 - Tom Zanussi <zanussi@us.ibm.com>, IBM Corp
+ * Copyright (C) 1999-2005 - Karim Yaghmour <karim@opersys.com>
+ * Copyright (C) 2008-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Re-using content from kernel/relay.c.
+ *
+ * This file is released under the GPL v2.
+ */
+
+#include <linux/module.h>
+#include <linux/mm.h>
+
+#include <linux/ringbuffer/backend.h>
+#include <linux/ringbuffer/frontend.h>
+#include <linux/ringbuffer/vfs.h>
+
+/*
+ * fault() vm_op implementation for ring buffer file mapping.
+ */
+static int ring_buffer_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct ring_buffer *buf = vma->vm_private_data;
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+	pgoff_t pgoff = vmf->pgoff;
+	struct page **page;
+	void **virt;
+	unsigned long offset, sb_bindex;
+
+	if (!buf)
+		return VM_FAULT_OOM;
+
+	/*
+	 * Verify that faults are only done on the range of pages owned by the
+	 * reader.
+	 */
+	offset = pgoff << PAGE_SHIFT;
+	sb_bindex = subbuffer_id_get_index(config, buf->backend.buf_rsb.id);
+	if (!(offset >= buf->backend.array[sb_bindex]->mmap_offset
+	      && offset < buf->backend.array[sb_bindex]->mmap_offset +
+			  buf->backend.chan->backend.subbuf_size))
+		return VM_FAULT_SIGBUS;
+	/*
+	 * ring_buffer_read_get_page() gets the page in the current reader's
+	 * pages.
+	 */
+	page = ring_buffer_read_get_page(&buf->backend, offset, &virt);
+	if (!*page)
+		return VM_FAULT_SIGBUS;
+	get_page(*page);
+	vmf->page = *page;
+
+	return 0;
+}
+
+/*
+ * vm_ops for relay file mappings.
+ */
+static const struct vm_operations_struct ring_buffer_mmap_ops = {
+	.fault = ring_buffer_fault,
+};
+
+/**
+ *	ring_buffer_mmap_buf: - mmap channel buffer to process address space
+ *	@buf: ring buffer to map
+ *	@vma: vm_area_struct describing memory to be mapped
+ *
+ *	Returns 0 if ok, negative on error
+ *
+ *	Caller should already have grabbed mmap_sem.
+ */
+static int ring_buffer_mmap_buf(struct ring_buffer *buf,
+				struct vm_area_struct *vma)
+{
+	unsigned long length = vma->vm_end - vma->vm_start;
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned long mmap_buf_len;
+
+	if (config->output != RING_BUFFER_MMAP)
+		return -EINVAL;
+
+	if (!buf)
+		return -EBADF;
+
+	mmap_buf_len = chan->backend.buf_size;
+	if (chan->backend.extra_reader_sb)
+		mmap_buf_len += chan->backend.subbuf_size;
+
+	if (length != mmap_buf_len)
+		return -EINVAL;
+
+	vma->vm_ops = &ring_buffer_mmap_ops;
+	vma->vm_flags |= VM_DONTEXPAND;
+	vma->vm_private_data = buf;
+
+	return 0;
+}
+
+/**
+ *	relay_file_mmap - mmap file op for relay files
+ *	@filp: the file
+ *	@vma: the vma describing what to map
+ *
+ *	Calls upon relay_mmap_buf() to map the file into user space.
+ */
+int ring_buffer_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct ring_buffer *buf = filp->private_data;
+	return ring_buffer_mmap_buf(buf, vma);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_mmap);
Index: linux.trees.git/include/linux/ringbuffer/vfs.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/vfs.h	2010-07-09 18:29:10.000000000 -0400
@@ -0,0 +1,57 @@
+#ifndef _LINUX_RING_BUFFER_VFS_H
+#define _LINUX_RING_BUFFER_VFS_H
+
+/*
+ * linux/ringbuffer/vfs.h
+ *
+ * (C) Copyright 2005-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Wait-free ring buffer VFS file operations.
+ *
+ * Author:
+ *	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/fs.h>
+#include <linux/poll.h>
+
+/* VFS API */
+
+extern const struct file_operations ring_buffer_file_operations;
+
+/*
+ * Internal file operations.
+ */
+
+int ring_buffer_open(struct inode *inode, struct file *file);
+int ring_buffer_release(struct inode *inode, struct file *file);
+unsigned int ring_buffer_poll(struct file *filp, poll_table *wait);
+ssize_t ring_buffer_splice_read(struct file *in, loff_t *ppos,
+				struct pipe_inode_info *pipe, size_t len,
+				unsigned int flags);
+int ring_buffer_mmap(struct file *filp, struct vm_area_struct *vma);
+
+/* Ring Buffer ioctl() and ioctl numbers */
+int ring_buffer_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
+		      unsigned long arg);
+#ifdef CONFIG_COMPAT
+long ring_buffer_compat_ioctl(struct file *file, unsigned int cmd,
+			      unsigned long arg);
+#endif
+
+/* Get the next sub-buffer that can be read. */
+#define RING_BUFFER_GET_SUBBUF			_IOR(0xF6, 0x00, __u32)
+/* Release the oldest reserved (by "get") sub-buffer. */
+#define RING_BUFFER_PUT_SUBBUF			_IOW(0xF6, 0x01, __u32)
+/* returns the size of the current sub-buffer. */
+#define RING_BUFFER_GET_SUBBUF_SIZE		_IOR(0xF6, 0x02, __u32)
+/* returns the maximum size for sub-buffers. */
+#define RING_BUFFER_GET_MAX_SUBBUF_SIZE		_IOR(0xF6, 0x03, __u32)
+/* returns the length to mmap. */
+#define RING_BUFFER_GET_MMAP_LEN		_IOR(0xF6, 0x04, __u32)
+/* returns the offset of the subbuffer belonging to the mmap reader. */
+#define RING_BUFFER_GET_MMAP_READ_OFFSET	_IOR(0xF6, 0x05, __u32)
+
+#endif /* _LINUX_RING_BUFFER_VFS_H */
Index: linux.trees.git/lib/ringbuffer/ring_buffer_vfs.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/lib/ringbuffer/ring_buffer_vfs.c	2010-07-09 18:30:33.000000000 -0400
@@ -0,0 +1,257 @@
+/*
+ * ring_buffer_vfs.c
+ *
+ * Copyright (C) 2009-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring Buffer VFS file operations.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+
+#include <linux/ringbuffer/backend.h>
+#include <linux/ringbuffer/frontend.h>
+#include <linux/ringbuffer/vfs.h>
+
+/**
+ *	ring_buffer_open - ring buffer open file operation
+ *	@inode: opened inode
+ *	@file: opened file
+ *
+ *	Open implementation. Makes sure only one open instance of a buffer is
+ *	done at a given moment.
+ */
+int ring_buffer_open(struct inode *inode, struct file *file)
+{
+	struct ring_buffer *buf = inode->i_private;
+	int ret;
+
+	ret = ring_buffer_open_read(buf);
+	if (ret)
+		return ret;
+
+	file->private_data = buf;
+	ret = nonseekable_open(inode, file);
+	if (ret)
+		goto release_read;
+	return 0;
+
+release_read:
+	ring_buffer_release_read(buf);
+	return ret;
+}
+
+/**
+ *	ring_buffer_release - ring buffer release file operation
+ *	@inode: opened inode
+ *	@file: opened file
+ *
+ *	Release implementation.
+ */
+int ring_buffer_release(struct inode *inode, struct file *file)
+{
+	struct ring_buffer *buf = inode->i_private;
+
+	ring_buffer_release_read(buf);
+
+	return 0;
+}
+
+/**
+ *	ring_buffer_poll - ring buffer poll file operation
+ *	@filp: the file
+ *	@wait: poll table
+ *
+ *	Poll implementation.
+ */
+unsigned int ring_buffer_poll(struct file *filp, poll_table *wait)
+{
+	unsigned int mask = 0;
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct ring_buffer *buf = inode->i_private;
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+	int finalized;
+
+	if (filp->f_mode & FMODE_READ) {
+		poll_wait_set_exclusive(wait);
+		poll_wait(filp, &buf->read_wait, wait);
+
+		finalized = ring_buffer_is_finalized(config, buf);
+		/*
+		 * ring_buffer_is_finalized() contains a smp_rmb() ordering
+		 * finalized load before offsets loads.
+		 */
+
+		WARN_ON(atomic_long_read(&buf->active_readers) != 1);
+retry:
+		if (subbuf_trunc(ring_buffer_get_offset(config, buf), chan)
+		  - subbuf_trunc(ring_buffer_get_consumed(config, buf), chan)
+		  == 0) {
+			if (finalized)
+				return POLLHUP;
+			else {
+				/*
+				 * The memory barriers
+				 * __wait_event()/wake_up_interruptible() take
+				 * care of "raw_spin_is_locked" memory ordering.
+				 */
+				if (raw_spin_is_locked(&buf->raw_idle_spinlock))
+					goto retry;
+				else
+					return 0;
+			}
+		} else {
+			if (subbuf_trunc(ring_buffer_get_offset(config, buf),
+					 chan)
+			  - subbuf_trunc(ring_buffer_get_consumed(config, buf),
+					 chan)
+			  >= chan->backend.buf_size)
+				return POLLPRI | POLLRDBAND;
+			else
+				return POLLIN | POLLRDNORM;
+		}
+	}
+	return mask;
+}
+
+/**
+ *	ring_buffer_ioctl - control ring buffer reader synchronization
+ *
+ *	@inode: the inode
+ *	@filp: the file
+ *	@cmd: the command
+ *	@arg: command arg
+ *
+ *	This ioctl implements commands necessary for producer/consumer
+ *	and flight recorder reader interaction :
+ *	RING_BUFFER_GET_SUBBUF
+ *		Get the next sub-buffer that can be read. It never blocks.
+ *	RING_BUFFER_PUT_SUBBUF
+ *		Release the currently read sub-buffer. Parameter is the last
+ *		put subbuffer (returned by GET_SUBBUF).
+ *	RING_BUFFER_GET_SUBBUF_SIZE
+ *		returns the size of the current sub-buffer.
+ *	RING_BUFFER_GET_MAX_SUBBUF_SIZE
+ *		returns the maximum size for sub-buffers.
+ *	RING_BUFFER_GET_NUM_SUBBUF
+ *		returns the number of reader-visible sub-buffers in the per cpu
+ *              channel (for mmap).
+ *      RING_BUFFER_GET_MMAP_READ_OFFSET
+ *              returns the offset of the subbuffer belonging to the reader.
+ *              Should only be used for mmap clients.
+ */
+int ring_buffer_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
+		      unsigned long arg)
+{
+	struct ring_buffer *buf = inode->i_private;
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+	u32 __user *argp = (u32 __user *)arg;
+
+	switch (cmd) {
+	case RING_BUFFER_GET_SUBBUF:
+	{
+		unsigned long consumed;
+		int ret;
+
+		ret = ring_buffer_get_subbuf(buf, &consumed);
+		if (ret)
+			return ret;
+		else
+			return put_user((u32)consumed, argp);
+		break;
+	}
+	case RING_BUFFER_PUT_SUBBUF:
+	{
+		u32 uconsumed_old;
+		int ret;
+		long consumed_old;
+
+		ret = get_user(uconsumed_old, argp);
+		if (ret)
+			return ret; /* will return -EFAULT */
+
+		consumed_old = ring_buffer_get_consumed(config, buf);
+		consumed_old = consumed_old & (~0xFFFFFFFFL);
+		consumed_old = consumed_old | uconsumed_old;
+		ring_buffer_put_subbuf(buf, consumed_old);
+		break;
+	}
+	case RING_BUFFER_GET_SUBBUF_SIZE:
+		return put_user(ring_buffer_get_read_data_size(config, buf),
+				argp);
+		break;
+	case RING_BUFFER_GET_MAX_SUBBUF_SIZE:
+		return put_user((u32)chan->backend.subbuf_size, argp);
+		break;
+	/*
+	 * TODO: mmap length is currently limited to 4GB, even on 64-bit
+	 * architectures. We should be more clever in dealing with ioctl
+	 * compatibility here. Using a u32 is probably not what we want.
+	 */
+	case RING_BUFFER_GET_MMAP_LEN:
+	{
+		unsigned long mmap_buf_len;
+
+		if (config->output != RING_BUFFER_MMAP)
+			return -EINVAL;
+		mmap_buf_len = chan->backend.buf_size;
+		if (chan->backend.extra_reader_sb)
+			mmap_buf_len += chan->backend.subbuf_size;
+		if (mmap_buf_len > INT_MAX)
+			return -EFBIG;
+		return put_user((u32)mmap_buf_len, argp);
+		break;
+	}
+	case RING_BUFFER_GET_MMAP_READ_OFFSET:
+	{
+		unsigned long sb_bindex;
+
+		if (config->output != RING_BUFFER_MMAP)
+			return -EINVAL;
+		sb_bindex = subbuffer_id_get_index(config,
+						  buf->backend.buf_rsb.id);
+		return put_user((u32)buf->backend.array[sb_bindex]->mmap_offset,
+				 argp);
+		break;
+	}
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return 0;
+}
+
+#ifdef CONFIG_COMPAT
+long ring_buffer_compat_ioctl(struct file *file, unsigned int cmd,
+			      unsigned long arg)
+{
+	long ret = -ENOIOCTLCMD;
+
+	lock_kernel();
+	ret = ring_buffer_ioctl(file->f_dentry->d_inode, file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+#endif
+
+const struct file_operations ring_buffer_file_operations = {
+	.open = ring_buffer_open,
+	.release = ring_buffer_release,
+	.poll = ring_buffer_poll,
+	.splice_read = ring_buffer_splice_read,
+	.mmap = ring_buffer_mmap,
+	.ioctl = ring_buffer_ioctl,
+	.llseek = ring_buffer_no_llseek,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = ring_buffer_compat_ioctl,
+#endif
+};
+EXPORT_SYMBOL_GPL(ring_buffer_file_operations);
+
+MODULE_LICENSE("GPL and additional rights");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Ring Buffer Library VFS");

