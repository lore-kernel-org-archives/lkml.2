Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab0HQXYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 19:24:44 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58379 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab0HQXXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 19:23:22 -0400
Message-Id: <20100817232153.951360273@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 17 Aug 2010 19:16:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Subject: [RFC PATCH 15/20] Ring buffer library - VFS operations (v2)
References: <20100817231619.277457797@efficios.com>
Content-Disposition: inline; filename=ring-buffer-vfs.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 17 Aug 2010 23:21:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File operation supports for ring buffer reader. splice() and mmap().

Changelog since v1:
* Add snapshot-related ioctl
* Improved compat ioctl support (with unsigned long type).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 Documentation/ioctl/ioctl-number.txt |    2 
 include/linux/ringbuffer/vfs.h       |   85 +++++++++
 lib/ringbuffer/Makefile              |    3 
 lib/ringbuffer/ring_buffer_mmap.c    |  115 ++++++++++++
 lib/ringbuffer/ring_buffer_splice.c  |  190 ++++++++++++++++++++
 lib/ringbuffer/ring_buffer_vfs.c     |  324 +++++++++++++++++++++++++++++++++++
 6 files changed, 719 insertions(+)

Index: linux.trees.git/lib/ringbuffer/Makefile
===================================================================
--- linux.trees.git.orig/lib/ringbuffer/Makefile	2010-08-17 17:05:50.000000000 -0400
+++ linux.trees.git/lib/ringbuffer/Makefile	2010-08-17 17:16:47.000000000 -0400
@@ -1,2 +1,5 @@
 obj-y += ring_buffer_backend.o
 obj-y += ring_buffer_frontend.o
+obj-y += ring_buffer_vfs.o
+obj-y += ring_buffer_splice.o
+obj-y += ring_buffer_mmap.o
Index: linux.trees.git/lib/ringbuffer/ring_buffer_splice.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/lib/ringbuffer/ring_buffer_splice.c	2010-08-17 17:05:50.000000000 -0400
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
--- linux.trees.git.orig/Documentation/ioctl/ioctl-number.txt	2010-08-17 17:05:37.000000000 -0400
+++ linux.trees.git/Documentation/ioctl/ioctl-number.txt	2010-08-17 17:05:50.000000000 -0400
@@ -321,4 +321,6 @@ Code  Seq#(hex)	Include File		Comments
 					<mailto:thomas@winischhofer.net>
 0xF4	00-1F	video/mbxfb.h		mbxfb
 					<mailto:raph@8d.com>
+0xF6	00-3F	lib/ringbuffer/ring_buffer_vfs.h	Ring Buffer Library
+					<mailto:mathieu.desnoyers@efficios.com>
 0xFD	all	linux/dm-ioctl.h
Index: linux.trees.git/lib/ringbuffer/ring_buffer_mmap.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/lib/ringbuffer/ring_buffer_mmap.c	2010-08-17 17:05:50.000000000 -0400
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
+++ linux.trees.git/include/linux/ringbuffer/vfs.h	2010-08-17 17:16:33.000000000 -0400
@@ -0,0 +1,85 @@
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
+long ring_buffer_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+#ifdef CONFIG_COMPAT
+long ring_buffer_compat_ioctl(struct file *filp, unsigned int cmd,
+			      unsigned long arg);
+#endif
+
+/*
+ * Use RING_BUFFER_GET_NEXT_SUBBUF / RING_BUFFER_PUT_NEXT_SUBBUF to read and
+ * consume sub-buffers sequentially.
+ *
+ * Reading sub-buffers without consuming them can be performed with:
+ *
+ * RING_BUFFER_SNAPSHOT
+ * RING_BUFFER_SNAPSHOT_GET_CONSUMED
+ * RING_BUFFER_SNAPSHOT_GET_PRODUCED
+ *
+ * to get the offset range to consume, and then by passing each sub-buffer
+ * offset to RING_BUFFER_GET_SUBBUF, read the sub-buffer, and then release it
+ * with RING_BUFFER_PUT_SUBBUF.
+ *
+ * Note that the "snapshot" API can be used to read the sub-buffer in reverse
+ * order, which is useful for flight recorder snapshots.
+ */
+
+/* Get a snapshot of the current ring buffer producer and consumer positions */
+#define RING_BUFFER_SNAPSHOT			_IO(0xF6, 0x00)
+/* Get the consumer position (iteration start) */
+#define RING_BUFFER_SNAPSHOT_GET_CONSUMED	_IOR(0xF6, 0x01, unsigned long)
+/* Get the producer position (iteration end) */
+#define RING_BUFFER_SNAPSHOT_GET_PRODUCED	_IOR(0xF6, 0x02, unsigned long)
+/* Get exclusive read access to the specified sub-buffer position */
+#define RING_BUFFER_GET_SUBBUF			_IOW(0xF6, 0x03, unsigned long)
+/* Release exclusive sub-buffer access */
+#define RING_BUFFER_PUT_SUBBUF			_IO(0xF6, 0x04)
+
+/* Get exclusive read access to the next sub-buffer that can be read. */
+#define RING_BUFFER_GET_NEXT_SUBBUF		_IO(0xF6, 0x05)
+/* Release exclusive sub-buffer access, move consumer forward. */
+#define RING_BUFFER_PUT_NEXT_SUBBUF		_IO(0xF6, 0x06)
+/* returns the size of the current sub-buffer. */
+#define RING_BUFFER_GET_SUBBUF_SIZE		_IOR(0xF6, 0x07, unsigned long)
+/* returns the maximum size for sub-buffers. */
+#define RING_BUFFER_GET_MAX_SUBBUF_SIZE		_IOR(0xF6, 0x08, unsigned long)
+/* returns the length to mmap. */
+#define RING_BUFFER_GET_MMAP_LEN		_IOR(0xF6, 0x09, unsigned long)
+/* returns the offset of the subbuffer belonging to the mmap reader. */
+#define RING_BUFFER_GET_MMAP_READ_OFFSET	_IOR(0xF6, 0x0A, unsigned long)
+
+#endif /* _LINUX_RING_BUFFER_VFS_H */
Index: linux.trees.git/lib/ringbuffer/ring_buffer_vfs.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/lib/ringbuffer/ring_buffer_vfs.c	2010-08-17 17:16:12.000000000 -0400
@@ -0,0 +1,324 @@
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
+#include <linux/compat.h>
+
+#include <linux/ringbuffer/backend.h>
+#include <linux/ringbuffer/frontend.h>
+#include <linux/ringbuffer/vfs.h>
+
+static int compat_put_ulong(unsigned long arg, compat_ulong_t val)
+{
+	return put_user(val, (compat_ulong_t __user *)compat_ptr(arg));
+}
+
+static int put_ulong(unsigned long arg, unsigned long val)
+{
+	return put_user(val, (unsigned long __user *)arg);
+}
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
+ *	@filp: the file
+ *	@cmd: the command
+ *	@arg: command arg
+ *
+ *	This ioctl implements commands necessary for producer/consumer
+ *	and flight recorder reader interaction :
+ *	RING_BUFFER_GET_NEXT_SUBBUF
+ *		Get the next sub-buffer that can be read. It never blocks.
+ *	RING_BUFFER_PUT_NEXT_SUBBUF
+ *		Release the currently read sub-buffer.
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
+long ring_buffer_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct ring_buffer *buf = inode->i_private;
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+
+	switch (cmd) {
+	case RING_BUFFER_SNAPSHOT:
+		return ring_buffer_snapshot(buf, &buf->cons_snapshot,
+					    &buf->prod_snapshot);
+	case RING_BUFFER_SNAPSHOT_GET_CONSUMED:
+		return put_ulong(buf->cons_snapshot, arg);
+	case RING_BUFFER_SNAPSHOT_GET_PRODUCED:
+		return put_ulong(buf->prod_snapshot, arg);
+	case RING_BUFFER_GET_SUBBUF:
+	{
+		unsigned long uconsume;
+		long ret;
+
+		ret = get_user(uconsume, (unsigned long __user *) arg);
+		if (ret)
+			return ret; /* will return -EFAULT */
+		return ring_buffer_get_subbuf(buf, uconsume);
+	}
+	case RING_BUFFER_PUT_SUBBUF:
+		ring_buffer_put_subbuf(buf);
+		return 0;
+
+	case RING_BUFFER_GET_NEXT_SUBBUF:
+		return ring_buffer_get_next_subbuf(buf);
+	case RING_BUFFER_PUT_NEXT_SUBBUF:
+		ring_buffer_put_next_subbuf(buf);
+		return 0;
+	case RING_BUFFER_GET_SUBBUF_SIZE:
+		return put_ulong(ring_buffer_get_read_data_size(config, buf),
+				 arg);
+	case RING_BUFFER_GET_MAX_SUBBUF_SIZE:
+		return put_ulong(chan->backend.subbuf_size, arg);
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
+		return put_ulong(mmap_buf_len, arg);
+	}
+	case RING_BUFFER_GET_MMAP_READ_OFFSET:
+	{
+		unsigned long sb_bindex;
+
+		if (config->output != RING_BUFFER_MMAP)
+			return -EINVAL;
+		sb_bindex = subbuffer_id_get_index(config,
+						   buf->backend.buf_rsb.id);
+		return put_ulong(buf->backend.array[sb_bindex]->mmap_offset,
+				 arg);
+	}
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+#ifdef CONFIG_COMPAT
+long ring_buffer_compat_ioctl(struct file *filp, unsigned int cmd,
+			      unsigned long arg)
+{
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct ring_buffer *buf = inode->i_private;
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+
+	switch (cmd) {
+	case RING_BUFFER_SNAPSHOT:
+		return ring_buffer_snapshot(buf, &buf->cons_snapshot,
+					    &buf->prod_snapshot);
+	case RING_BUFFER_SNAPSHOT_GET_CONSUMED:
+		return compat_put_ulong(buf->cons_snapshot, arg);
+	case RING_BUFFER_SNAPSHOT_GET_PRODUCED:
+		return compat_put_ulong(buf->prod_snapshot, arg);
+	case RING_BUFFER_GET_SUBBUF:
+	{
+		__u32 uconsume;
+		unsigned long consume;
+		long ret;
+
+		ret = get_user(uconsume, (__u32 __user *) arg);
+		if (ret)
+			return ret; /* will return -EFAULT */
+		consume = buf->cons_snapshot;
+		consume &= ~0xFFFFFFFFL;
+		consume |= uconsume;
+		return ring_buffer_get_subbuf(buf, consume);
+	}
+	case RING_BUFFER_PUT_SUBBUF:
+		ring_buffer_put_subbuf(buf);
+		return 0;
+
+	case RING_BUFFER_GET_NEXT_SUBBUF:
+		return ring_buffer_get_next_subbuf(buf);
+	case RING_BUFFER_PUT_NEXT_SUBBUF:
+		ring_buffer_put_next_subbuf(buf);
+		return 0;
+	case RING_BUFFER_GET_SUBBUF_SIZE:
+	{
+		unsigned long data_size;
+
+		data_size = ring_buffer_get_read_data_size(config, buf);
+		if (data_size > UINT_MAX)
+			return -EFBIG;
+		return put_ulong(data_size, arg);
+	}
+	case RING_BUFFER_GET_MAX_SUBBUF_SIZE:
+		if (chan->backend.subbuf_size > UINT_MAX)
+			return -EFBIG;
+		return put_ulong(chan->backend.subbuf_size, arg);
+	case RING_BUFFER_GET_MMAP_LEN:
+	{
+		unsigned long mmap_buf_len;
+
+		if (config->output != RING_BUFFER_MMAP)
+			return -EINVAL;
+		mmap_buf_len = chan->backend.buf_size;
+		if (chan->backend.extra_reader_sb)
+			mmap_buf_len += chan->backend.subbuf_size;
+		if (mmap_buf_len > UINT_MAX)
+			return -EFBIG;
+		return put_ulong(mmap_buf_len, arg);
+	}
+	case RING_BUFFER_GET_MMAP_READ_OFFSET:
+	{
+		unsigned long sb_bindex, read_offset;
+
+		if (config->output != RING_BUFFER_MMAP)
+			return -EINVAL;
+		sb_bindex = subbuffer_id_get_index(config,
+						   buf->backend.buf_rsb.id);
+		read_offset = buf->backend.array[sb_bindex]->mmap_offset;
+		if (read_offset > UINT_MAX)
+			return -EINVAL;
+		return put_ulong(read_offset, arg);
+	}
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+#endif
+
+const struct file_operations ring_buffer_file_operations = {
+	.open = ring_buffer_open,
+	.release = ring_buffer_release,
+	.poll = ring_buffer_poll,
+	.splice_read = ring_buffer_splice_read,
+	.mmap = ring_buffer_mmap,
+	.unlocked_ioctl = ring_buffer_ioctl,
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

