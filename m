Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0HQXYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 19:24:03 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:32843 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab0HQXX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 19:23:26 -0400
Message-Id: <20100817232153.234089098@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 17 Aug 2010 19:16:31 -0400
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
Subject: [RFC PATCH 12/20] Ring buffer backend
References: <20100817231619.277457797@efficios.com>
Content-Disposition: inline; filename=ring_buffer_backend.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 17 Aug 2010 23:21:53 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ring buffer backend, with page allocation, data read/write API, cpu hotplug
management.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/ringbuffer/backend.h          |  141 +++++
 include/linux/ringbuffer/backend_internal.h |  418 +++++++++++++++
 include/linux/ringbuffer/backend_types.h    |   80 ++
 lib/ringbuffer/Makefile                     |    1 
 lib/ringbuffer/ring_buffer_backend.c        |  755 ++++++++++++++++++++++++++++
 5 files changed, 1395 insertions(+)

Index: linux.trees.git/lib/ringbuffer/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/lib/ringbuffer/Makefile	2010-08-17 16:10:21.000000000 -0400
@@ -0,0 +1 @@
+obj-y += ring_buffer_backend.o
Index: linux.trees.git/include/linux/ringbuffer/backend.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/backend.h	2010-07-15 13:36:17.000000000 -0400
@@ -0,0 +1,141 @@
+#ifndef _LINUX_RING_BUFFER_BACKEND_H
+#define _LINUX_RING_BUFFER_BACKEND_H
+
+/*
+ * linux/ringbuffer/backend.h
+ *
+ * Copyright (C) 2008-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring buffer backend (API).
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ *
+ * Credits to Steven Rostedt for proposing to use an extra-subbuffer owned by
+ * the reader in flight recorder mode.
+ */
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/list.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+
+/* Internal helpers */
+#include <linux/ringbuffer/backend_internal.h>
+#include <linux/ringbuffer/frontend_internal.h>
+
+/* Ring buffer backend API */
+
+/* Ring buffer backend access (read/write) */
+
+extern size_t ring_buffer_read(struct ring_buffer_backend *bufb,
+			       size_t offset, void *dest, size_t len);
+
+extern int __ring_buffer_copy_to_user(struct ring_buffer_backend *bufb,
+				      size_t offset, void __user *dest,
+				      size_t len);
+
+extern int ring_buffer_read_cstr(struct ring_buffer_backend *bufb,
+				 size_t offset, void *dest, size_t len);
+
+extern struct page **
+ring_buffer_read_get_page(struct ring_buffer_backend *bufb, size_t offset,
+			  void ***virt);
+
+/*
+ * Return the address where a given offset is located.
+ * Should be used to get the current subbuffer header pointer. Given we know
+ * it's never on a page boundary, it's safe to write directly to this address,
+ * as long as the write is never bigger than a page size.
+ */
+extern void *
+ring_buffer_offset_address(struct ring_buffer_backend *bufb,
+			   size_t offset);
+extern void *
+ring_buffer_read_offset_address(struct ring_buffer_backend *bufb,
+				size_t offset);
+
+/**
+ * ring_buffer_write - write data to a buffer backend
+ * @config : ring buffer instance configuration
+ * @ctx: ring buffer context. (input arguments only)
+ * @src : source pointer to copy from
+ * @len : length of data to copy
+ *
+ * This function copies "len" bytes of data from a source pointer to a buffer
+ * backend, at the current context offset. This is more or less a buffer
+ * backend-specific memcpy() operation. Calls the slow path (_ring_buffer_write)
+ * if copy is crossing a page boundary.
+ */
+static inline
+void ring_buffer_write(const struct ring_buffer_config *config,
+		       struct ring_buffer_ctx *ctx,
+		       const void *src, size_t len)
+{
+	struct ring_buffer_backend *bufb = &ctx->buf->backend;
+	struct channel_backend *chanb = &ctx->chan->backend;
+	size_t sbidx, index;
+	size_t offset = ctx->buf_offset;
+	ssize_t pagecpy;
+	struct ring_buffer_backend_pages *rpages;
+	unsigned long sb_bindex, id;
+
+	offset &= chanb->buf_size - 1;
+	sbidx = offset >> chanb->subbuf_size_order;
+	index = (offset & (chanb->subbuf_size - 1)) >> PAGE_SHIFT;
+	pagecpy = min_t(size_t, len, (-offset) & ~PAGE_MASK);
+	id = bufb->buf_wsb[sbidx].id;
+	sb_bindex = subbuffer_id_get_index(config, id);
+	rpages = bufb->array[sb_bindex];
+	CHAN_WARN_ON(ctx->chan,
+		     config->mode == RING_BUFFER_OVERWRITE
+		     && subbuffer_id_is_noref(config, id));
+	if (likely(pagecpy == len))
+		ring_buffer_do_copy(config,
+				    rpages->p[index].virt
+				    + (offset & ~PAGE_MASK),
+				    src, len);
+	else
+		_ring_buffer_write(bufb, offset, src, len, 0);
+	ctx->buf_offset += len;
+}
+
+/*
+ * This accessor counts the number of unread records in a buffer.
+ * It only provides a consistent value if no reads not writes are performed
+ * concurrently.
+ */
+static inline
+unsigned long ring_buffer_get_records_unread(
+				const struct ring_buffer_config *config,
+				struct ring_buffer *buf)
+{
+	struct ring_buffer_backend *bufb = &buf->backend;
+	struct ring_buffer_backend_pages *pages;
+	unsigned long records_unread = 0, sb_bindex, id;
+	unsigned int i;
+
+	for (i = 0; i < bufb->chan->backend.num_subbuf; i++) {
+		id = bufb->buf_wsb[i].id;
+		sb_bindex = subbuffer_id_get_index(config, id);
+		pages = bufb->array[sb_bindex];
+		records_unread += v_read(config, &pages->records_unread);
+	}
+	if (config->mode == RING_BUFFER_OVERWRITE) {
+		id = bufb->buf_rsb.id;
+		sb_bindex = subbuffer_id_get_index(config, id);
+		pages = bufb->array[sb_bindex];
+		records_unread += v_read(config, &pages->records_unread);
+	}
+	return records_unread;
+}
+
+ssize_t ring_buffer_file_splice_read(struct file *in, loff_t *ppos,
+				     struct pipe_inode_info *pipe, size_t len,
+				     unsigned int flags);
+loff_t ring_buffer_no_llseek(struct file *file, loff_t offset, int origin);
+
+#endif /* _LINUX_RING_BUFFER_BACKEND_H */
Index: linux.trees.git/include/linux/ringbuffer/backend_internal.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/backend_internal.h	2010-08-17 12:00:52.000000000 -0400
@@ -0,0 +1,418 @@
+#ifndef _LINUX_RING_BUFFER_BACKEND_INTERNAL_H
+#define _LINUX_RING_BUFFER_BACKEND_INTERNAL_H
+
+/*
+ * linux/ringbuffer/backend_internal.h
+ *
+ * Copyright (C) 2008-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring buffer backend (internal helpers).
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/ringbuffer/config.h>
+#include <linux/ringbuffer/backend_types.h>
+#include <linux/ringbuffer/frontend_types.h>
+#include <linux/string.h>
+
+/* Ring buffer backend API presented to the frontend */
+
+/* Ring buffer and channel backend create/free */
+
+int ring_buffer_backend_create(struct ring_buffer_backend *bufb,
+			       struct channel_backend *chan,
+			       int cpu);
+void channel_backend_unregister_notifiers(struct channel_backend *chanb);
+void ring_buffer_backend_free(struct ring_buffer_backend *bufb);
+int channel_backend_init(struct channel_backend *chanb,
+			 const char *name,
+			 const struct ring_buffer_config *config,
+			 void *priv, size_t subbuf_size,
+			 size_t num_subbuf);
+void channel_backend_free(struct channel_backend *chanb);
+
+void ring_buffer_backend_reset(struct ring_buffer_backend *bufb);
+void channel_backend_reset(struct channel_backend *chanb);
+
+int ring_buffer_backend_init(void);
+void ring_buffer_backend_exit(void);
+
+extern void _ring_buffer_write(struct ring_buffer_backend *bufb,
+			       size_t offset, const void *src, size_t len,
+			       ssize_t pagecpy);
+
+/*
+ * Subbuffer ID bits for overwrite mode. Need to fit within a single word to be
+ * exchanged atomically.
+ *
+ * Top half word, except lowest bit, belongs to "offset", which is used to keep
+ * to count the produced buffers.  For overwrite mode, this provides the
+ * consumer with the capacity to read subbuffers in order, handling the
+ * situation where producers would write up to 2^15 buffers (or 2^31 for 64-bit
+ * systems) concurrently with a single execution of get_subbuf (between offset
+ * sampling and subbuffer ID exchange).
+ */
+
+#define HALF_ULONG_BITS		(BITS_PER_LONG >> 1)
+
+#define SB_ID_OFFSET_SHIFT	(HALF_ULONG_BITS + 1)
+#define SB_ID_OFFSET_COUNT	(1UL << SB_ID_OFFSET_SHIFT)
+#define SB_ID_OFFSET_MASK	(~(SB_ID_OFFSET_COUNT - 1))
+/*
+ * Lowest bit of top word half belongs to noref. Used only for overwrite mode.
+ */
+#define SB_ID_NOREF_SHIFT	(SB_ID_OFFSET_SHIFT - 1)
+#define SB_ID_NOREF_COUNT	(1UL << SB_ID_NOREF_SHIFT)
+#define SB_ID_NOREF_MASK	SB_ID_NOREF_COUNT
+/*
+ * In overwrite mode: lowest half of word is used for index.
+ * Limit of 2^16 subbuffers per buffer on 32-bit, 2^32 on 64-bit.
+ * In producer-consumer mode: whole word used for index.
+ */
+#define SB_ID_INDEX_SHIFT	0
+#define SB_ID_INDEX_COUNT	(1UL << SB_ID_INDEX_SHIFT)
+#define SB_ID_INDEX_MASK	(SB_ID_NOREF_COUNT - 1)
+
+/*
+ * Construct the subbuffer id from offset, index and noref. Use only the index
+ * for producer-consumer mode (offset and noref are only used in overwrite
+ * mode).
+ */
+static inline
+unsigned long subbuffer_id(const struct ring_buffer_config *config,
+			   unsigned long offset, unsigned long noref,
+			   unsigned long index)
+{
+	if (config->mode == RING_BUFFER_OVERWRITE)
+		return (offset << SB_ID_OFFSET_SHIFT)
+		       | (noref << SB_ID_NOREF_SHIFT)
+		       | index;
+	else
+		return index;
+}
+
+/*
+ * Compare offset with the offset contained within id. Return 1 if the offset
+ * bits are identical, else 0.
+ */
+static inline
+int subbuffer_id_compare_offset(const struct ring_buffer_config *config,
+				unsigned long id, unsigned long offset)
+{
+	return (id & SB_ID_OFFSET_MASK) == (offset << SB_ID_OFFSET_SHIFT);
+}
+
+static inline
+unsigned long subbuffer_id_get_index(const struct ring_buffer_config *config,
+				     unsigned long id)
+{
+	if (config->mode == RING_BUFFER_OVERWRITE)
+		return id & SB_ID_INDEX_MASK;
+	else
+		return id;
+}
+
+static inline
+unsigned long subbuffer_id_is_noref(const struct ring_buffer_config *config,
+				    unsigned long id)
+{
+	if (config->mode == RING_BUFFER_OVERWRITE)
+		return !!(id & SB_ID_NOREF_MASK);
+	else
+		return 1;
+}
+
+/*
+ * Only used by reader on subbuffer ID it has exclusive access to. No volatile
+ * needed.
+ */
+static inline
+void subbuffer_id_set_noref(const struct ring_buffer_config *config,
+			    unsigned long *id)
+{
+	if (config->mode == RING_BUFFER_OVERWRITE)
+		*id |= SB_ID_NOREF_MASK;
+}
+
+static inline
+void subbuffer_id_set_noref_offset(const struct ring_buffer_config *config,
+				   unsigned long *id, unsigned long offset)
+{
+	unsigned long tmp;
+
+	if (config->mode == RING_BUFFER_OVERWRITE) {
+		tmp = *id;
+		tmp &= ~SB_ID_OFFSET_MASK;
+		tmp |= offset << SB_ID_OFFSET_SHIFT;
+		tmp |= SB_ID_NOREF_MASK;
+		/* Volatile store, read concurrently by readers. */
+		ACCESS_ONCE(*id) = tmp;
+	}
+}
+
+/* No volatile access, since already used locally */
+static inline
+void subbuffer_id_clear_noref(const struct ring_buffer_config *config,
+			      unsigned long *id)
+{
+	if (config->mode == RING_BUFFER_OVERWRITE)
+		*id &= ~SB_ID_NOREF_MASK;
+}
+
+/*
+ * For overwrite mode, cap the number of subbuffers per buffer to:
+ * 2^16 on 32-bit architectures
+ * 2^32 on 64-bit architectures
+ * This is required to fit in the index part of the ID. Return 0 on success,
+ * -EPERM on failure.
+ */
+static inline
+int subbuffer_id_check_index(const struct ring_buffer_config *config,
+			     unsigned long num_subbuf)
+{
+	if (config->mode == RING_BUFFER_OVERWRITE)
+		return (num_subbuf > (1UL << HALF_ULONG_BITS)) ? -EPERM : 0;
+	else
+		return 0;
+}
+
+static inline
+void subbuffer_count_record(const struct ring_buffer_config *config,
+			    struct ring_buffer_backend *bufb,
+			    unsigned long idx)
+{
+	unsigned long sb_bindex;
+
+	sb_bindex = subbuffer_id_get_index(config, bufb->buf_wsb[idx].id);
+	v_inc(config, &bufb->array[sb_bindex]->records_commit);
+}
+
+/*
+ * Reader has exclusive subbuffer access for record consumption. No need to
+ * perform the decrement atomically.
+ */
+static inline
+void subbuffer_consume_record(const struct ring_buffer_config *config,
+			      struct ring_buffer_backend *bufb)
+{
+	unsigned long sb_bindex;
+
+	sb_bindex = subbuffer_id_get_index(config, bufb->buf_rsb.id);
+	CHAN_WARN_ON(bufb->chan,
+		     !v_read(config, &bufb->array[sb_bindex]->records_unread));
+	/* Non-atomic decrement protected by exclusive subbuffer access */
+	_v_dec(config, &bufb->array[sb_bindex]->records_unread);
+	v_inc(config, &bufb->records_read);
+}
+
+static inline
+unsigned long subbuffer_get_records_count(
+				const struct ring_buffer_config *config,
+				struct ring_buffer_backend *bufb,
+				unsigned long idx)
+{
+	unsigned long sb_bindex;
+
+	sb_bindex = subbuffer_id_get_index(config, bufb->buf_wsb[idx].id);
+	return v_read(config, &bufb->array[sb_bindex]->records_commit);
+}
+
+/*
+ * Must be executed at subbuffer delivery when the writer has _exclusive_
+ * subbuffer access. See ring_buffer_check_deliver() for details.
+ * ring_buffer_get_records_count() must be called to get the records count
+ * before this function, because it resets the records_commit count.
+ */
+static inline
+unsigned long subbuffer_count_records_overrun(
+				const struct ring_buffer_config *config,
+				struct ring_buffer_backend *bufb,
+				unsigned long idx)
+{
+	struct ring_buffer_backend_pages *pages;
+	unsigned long overruns, sb_bindex;
+
+	sb_bindex = subbuffer_id_get_index(config, bufb->buf_wsb[idx].id);
+	pages = bufb->array[sb_bindex];
+	overruns = v_read(config, &pages->records_unread);
+	v_set(config, &pages->records_unread,
+	      v_read(config, &pages->records_commit));
+	v_set(config, &pages->records_commit, 0);
+
+	return overruns;
+}
+
+static inline
+void subbuffer_set_data_size(const struct ring_buffer_config *config,
+			     struct ring_buffer_backend *bufb,
+			     unsigned long idx,
+			     unsigned long data_size)
+{
+	struct ring_buffer_backend_pages *pages;
+	unsigned long sb_bindex;
+
+	sb_bindex = subbuffer_id_get_index(config, bufb->buf_wsb[idx].id);
+	pages = bufb->array[sb_bindex];
+	pages->data_size = data_size;
+}
+
+static inline
+unsigned long subbuffer_get_read_data_size(
+				const struct ring_buffer_config *config,
+				struct ring_buffer_backend *bufb)
+{
+	struct ring_buffer_backend_pages *pages;
+	unsigned long sb_bindex;
+
+	sb_bindex = subbuffer_id_get_index(config, bufb->buf_rsb.id);
+	pages = bufb->array[sb_bindex];
+	return pages->data_size;
+}
+
+static inline
+unsigned long subbuffer_get_data_size(
+				const struct ring_buffer_config *config,
+				struct ring_buffer_backend *bufb,
+				unsigned long idx)
+{
+	struct ring_buffer_backend_pages *pages;
+	unsigned long sb_bindex;
+
+	sb_bindex = subbuffer_id_get_index(config, bufb->buf_wsb[idx].id);
+	pages = bufb->array[sb_bindex];
+	return pages->data_size;
+}
+
+/**
+ * ring_buffer_clear_noref - Clear the noref subbuffer flag, called by writer.
+ */
+static inline
+void ring_buffer_clear_noref(const struct ring_buffer_config *config,
+			     struct ring_buffer_backend *bufb,
+			     unsigned long idx)
+{
+	unsigned long id, new_id;
+
+	if (config->mode != RING_BUFFER_OVERWRITE)
+		return;
+
+	/*
+	 * Performing a volatile access to read the sb_pages, because we want to
+	 * read a coherent version of the pointer and the associated noref flag.
+	 */
+	id = ACCESS_ONCE(bufb->buf_wsb[idx].id);
+	for (;;) {
+		/* This check is called on the fast path for each record. */
+		if (likely(!subbuffer_id_is_noref(config, id))) {
+			/*
+			 * Store after load dependency ordering the writes to
+			 * the subbuffer after load and test of the noref flag
+			 * matches the memory barrier implied by the cmpxchg()
+			 * in update_read_sb_index().
+			 */
+			return;	/* Already writing to this buffer */
+		}
+		new_id = id;
+		subbuffer_id_clear_noref(config, &new_id);
+		new_id = cmpxchg(&bufb->buf_wsb[idx].id, id, new_id);
+		if (likely(new_id == id))
+			break;
+		id = new_id;
+	}
+}
+
+/**
+ * ring_buffer_set_noref_offset - Set the noref subbuffer flag and offset,
+ *                                called by writer.
+ */
+static inline
+void ring_buffer_set_noref_offset(const struct ring_buffer_config *config,
+				  struct ring_buffer_backend *bufb,
+				  unsigned long idx,
+				  unsigned long offset)
+{
+	if (config->mode != RING_BUFFER_OVERWRITE)
+		return;
+
+	/*
+	 * Because ring_buffer_set_noref() is only called by a single thread
+	 * (the one which updated the cc_sb value), there are no concurrent
+	 * updates to take care of: other writers have not updated cc_sb, so
+	 * they cannot set the noref flag, and concurrent readers cannot modify
+	 * the pointer because the noref flag is not set yet.
+	 * The smp_wmb() in ring_buffer_commit() takes care of ordering writes
+	 * to the subbuffer before this set noref operation.
+	 * subbuffer_set_noref() uses a volatile store to deal with concurrent
+	 * readers of the noref flag.
+	 */
+	CHAN_WARN_ON(bufb->chan,
+		     subbuffer_id_is_noref(config, bufb->buf_wsb[idx].id));
+	/*
+	 * Memory barrier that ensures counter stores are ordered before set
+	 * noref and offset.
+	 */
+	smp_mb();
+	subbuffer_id_set_noref_offset(config, &bufb->buf_wsb[idx].id, offset);
+}
+
+/**
+ * update_read_sb_index - Read-side subbuffer index update.
+ */
+static inline
+int update_read_sb_index(const struct ring_buffer_config *config,
+			 struct ring_buffer_backend *bufb,
+			 struct channel_backend *chanb,
+			 unsigned long consumed_idx,
+			 unsigned long consumed_count)
+{
+	unsigned long old_id, new_id;
+
+	if (config->mode == RING_BUFFER_OVERWRITE) {
+		/*
+		 * Exchange the target writer subbuffer with our own unused
+		 * subbuffer. No need to use ACCESS_ONCE() here to read the
+		 * old_wpage, because the value read will be confirmed by the
+		 * following cmpxchg().
+		 */
+		old_id = bufb->buf_wsb[consumed_idx].id;
+		if (unlikely(!subbuffer_id_is_noref(config, old_id)))
+			return -EAGAIN;
+		/*
+		 * Make sure the offset count we are expecting matches the one
+		 * indicated by the writer.
+		 */
+		if (unlikely(!subbuffer_id_compare_offset(config, old_id,
+							  consumed_count)))
+			return -EAGAIN;
+		CHAN_WARN_ON(bufb->chan,
+			     !subbuffer_id_is_noref(config, bufb->buf_rsb.id));
+		subbuffer_id_set_noref_offset(config, &bufb->buf_rsb.id,
+					      consumed_count);
+		new_id = cmpxchg(&bufb->buf_wsb[consumed_idx].id, old_id,
+				 bufb->buf_rsb.id);
+		if (unlikely(old_id != new_id))
+			return -EAGAIN;
+		bufb->buf_rsb.id = new_id;
+	} else {
+		/* No page exchange, use the writer page directly */
+		bufb->buf_rsb.id = bufb->buf_wsb[consumed_idx].id;
+	}
+	return 0;
+}
+
+/*
+ * Use the architecture-specific memcpy implementation for constant-sized
+ * inputs, but rely on an inline memcpy for length statically unknown.
+ * The function call to memcpy is just way too expensive for a fast path.
+ */
+#define ring_buffer_do_copy(config, dest, src, len)		\
+do {								\
+	size_t __len = (len);					\
+	if (__builtin_constant_p(len))				\
+		memcpy((dest), (src), __len);			\
+	else							\
+		inline_memcpy((dest), (src), __len);		\
+} while (0)
+
+#endif /* _LINUX_RING_BUFFER_BACKEND_INTERNAL_H */
Index: linux.trees.git/lib/ringbuffer/ring_buffer_backend.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/lib/ringbuffer/ring_buffer_backend.c	2010-07-15 13:36:17.000000000 -0400
@@ -0,0 +1,755 @@
+/*
+ * ring_buffer_backend.c
+ *
+ * Copyright (C) 2005-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/vmalloc.h>
+#include <linux/stddef.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/cpu.h>
+#include <linux/mm.h>
+
+#include <linux/ringbuffer/config.h>
+#include <linux/ringbuffer/backend.h>
+#include <linux/ringbuffer/frontend.h>
+
+/**
+ * ring_buffer_backend_allocate - allocate a channel buffer
+ * @config: ring buffer instance configuration
+ * @buf: the buffer struct
+ * @size: total size of the buffer
+ * @num_subbuf: number of subbuffers
+ * @extra_reader_sb: need extra subbuffer for reader
+ */
+static
+int ring_buffer_backend_allocate(const struct ring_buffer_config *config,
+				 struct ring_buffer_backend *bufb,
+				 size_t size, size_t num_subbuf,
+				 int extra_reader_sb)
+{
+	struct channel_backend *chanb = &bufb->chan->backend;
+	unsigned long j, num_pages, num_pages_per_subbuf, page_idx = 0;
+	unsigned long subbuf_size, mmap_offset = 0;
+	unsigned long num_subbuf_alloc;
+	struct page **pages;
+	void **virt;
+	unsigned long i;
+
+	num_pages = size >> PAGE_SHIFT;
+	num_pages_per_subbuf = num_pages >> get_count_order(num_subbuf);
+	subbuf_size = chanb->subbuf_size;
+	num_subbuf_alloc = num_subbuf;
+
+	if (extra_reader_sb) {
+		num_pages += num_pages_per_subbuf; /* Add pages for reader */
+		num_subbuf_alloc++;
+	}
+
+	pages = kmalloc_node(ALIGN(sizeof(*pages) * num_pages,
+				   1 << INTERNODE_CACHE_SHIFT),
+			GFP_KERNEL, cpu_to_node(max(bufb->cpu, 0)));
+	if (unlikely(!pages))
+		goto pages_error;
+
+	virt = kmalloc_node(ALIGN(sizeof(*virt) * num_pages,
+				  1 << INTERNODE_CACHE_SHIFT),
+			GFP_KERNEL, cpu_to_node(max(bufb->cpu, 0)));
+	if (unlikely(!virt))
+		goto virt_error;
+
+	bufb->array = kmalloc_node(ALIGN(sizeof(*bufb->array)
+					 * num_subbuf_alloc,
+				  1 << INTERNODE_CACHE_SHIFT),
+			GFP_KERNEL, cpu_to_node(max(bufb->cpu, 0)));
+	if (unlikely(!bufb->array))
+		goto array_error;
+
+	for (i = 0; i < num_pages; i++) {
+		pages[i] = alloc_pages_node(cpu_to_node(max(bufb->cpu, 0)),
+					    GFP_KERNEL | __GFP_ZERO, 0);
+		if (unlikely(!pages[i]))
+			goto depopulate;
+		virt[i] = page_address(pages[i]);
+	}
+	bufb->num_pages_per_subbuf = num_pages_per_subbuf;
+
+	/* Allocate backend pages array elements */
+	for (i = 0; i < num_subbuf_alloc; i++) {
+		bufb->array[i] =
+			kzalloc_node(ALIGN(
+				sizeof(struct ring_buffer_backend_pages) +
+				sizeof(struct ring_buffer_backend_page)
+				* num_pages_per_subbuf,
+				1 << INTERNODE_CACHE_SHIFT),
+				GFP_KERNEL, cpu_to_node(max(bufb->cpu, 0)));
+		if (!bufb->array[i])
+			goto free_array;
+	}
+
+	/* Allocate write-side subbuffer table */
+	bufb->buf_wsb = kzalloc_node(ALIGN(
+				sizeof(struct ring_buffer_backend_subbuffer)
+				* num_subbuf,
+				1 << INTERNODE_CACHE_SHIFT),
+				GFP_KERNEL, cpu_to_node(max(bufb->cpu, 0)));
+	if (unlikely(!bufb->buf_wsb))
+		goto free_array;
+
+	for (i = 0; i < num_subbuf; i++)
+		bufb->buf_wsb[i].id = subbuffer_id(config, 0, 1, i);
+
+	/* Assign read-side subbuffer table */
+	if (extra_reader_sb)
+		bufb->buf_rsb.id = subbuffer_id(config, 0, 1,
+						num_subbuf_alloc - 1);
+	else
+		bufb->buf_rsb.id = subbuffer_id(config, 0, 1, 0);
+
+	/* Assign pages to page index */
+	for (i = 0; i < num_subbuf_alloc; i++) {
+		for (j = 0; j < num_pages_per_subbuf; j++) {
+			CHAN_WARN_ON(chanb, page_idx > num_pages);
+			bufb->array[i]->p[j].virt = virt[page_idx];
+			bufb->array[i]->p[j].page = pages[page_idx];
+			page_idx++;
+		}
+		if (config->output == RING_BUFFER_MMAP) {
+			bufb->array[i]->mmap_offset = mmap_offset;
+			mmap_offset += subbuf_size;
+		}
+	}
+
+	/*
+	 * If kmalloc ever uses vmalloc underneath, make sure the buffer pages
+	 * will not fault.
+	 */
+	vmalloc_sync_all();
+	kfree(virt);
+	kfree(pages);
+	return 0;
+
+free_array:
+	for (i = 0; (i < num_subbuf_alloc && bufb->array[i]); i++)
+		kfree(bufb->array[i]);
+depopulate:
+	/* Free all allocated pages */
+	for (i = 0; (i < num_pages && pages[i]); i++)
+		__free_page(pages[i]);
+	kfree(bufb->array);
+array_error:
+	kfree(virt);
+virt_error:
+	kfree(pages);
+pages_error:
+	return -ENOMEM;
+}
+
+int ring_buffer_backend_create(struct ring_buffer_backend *bufb,
+				     struct channel_backend *chanb,
+				     int cpu)
+{
+	const struct ring_buffer_config *config = chanb->config;
+
+	bufb->chan = container_of(chanb, struct channel, backend);
+	bufb->cpu = cpu;
+
+	return ring_buffer_backend_allocate(config, bufb, chanb->buf_size,
+					   chanb->num_subbuf,
+					   chanb->extra_reader_sb);
+}
+
+void ring_buffer_backend_free(struct ring_buffer_backend *bufb)
+{
+	struct channel_backend *chanb = &bufb->chan->backend;
+	unsigned long i, j, num_subbuf_alloc;
+
+	num_subbuf_alloc = chanb->num_subbuf;
+	if (chanb->extra_reader_sb)
+		num_subbuf_alloc++;
+
+	kfree(bufb->buf_wsb);
+	for (i = 0; i < num_subbuf_alloc; i++) {
+		for (j = 0; j < bufb->num_pages_per_subbuf; j++)
+			__free_page(bufb->array[i]->p[j].page);
+		kfree(bufb->array[i]);
+	}
+	kfree(bufb->array);
+	bufb->allocated = 0;
+}
+
+void ring_buffer_backend_reset(struct ring_buffer_backend *bufb)
+{
+	struct channel_backend *chanb = &bufb->chan->backend;
+	const struct ring_buffer_config *config = chanb->config;
+	unsigned long num_subbuf_alloc;
+	unsigned int i;
+
+	num_subbuf_alloc = chanb->num_subbuf;
+	if (chanb->extra_reader_sb)
+		num_subbuf_alloc++;
+
+	for (i = 0; i < chanb->num_subbuf; i++)
+		bufb->buf_wsb[i].id = subbuffer_id(config, 0, 1, i);
+	if (chanb->extra_reader_sb)
+		bufb->buf_rsb.id = subbuffer_id(config, 0, 1,
+						num_subbuf_alloc - 1);
+	else
+		bufb->buf_rsb.id = subbuffer_id(config, 0, 1, 0);
+
+	for (i = 0; i < num_subbuf_alloc; i++) {
+		/* Don't reset mmap_offset */
+		v_set(config, &bufb->array[i]->records_commit, 0);
+		v_set(config, &bufb->array[i]->records_unread, 0);
+		bufb->array[i]->data_size = 0;
+		/* Don't reset backend page and virt addresses */
+	}
+	/* Don't reset num_pages_per_subbuf, cpu, allocated */
+	v_set(config, &bufb->records_read, 0);
+}
+
+/*
+ * The frontend is responsible for also calling ring_buffer_backend_reset for
+ * each buffer when calling channel_backend_reset.
+ */
+void channel_backend_reset(struct channel_backend *chanb)
+{
+	struct channel *chan = container_of(chanb, struct channel, backend);
+	const struct ring_buffer_config *config = chanb->config;
+
+	/*
+	 * Don't reset buf_size, subbuf_size, subbuf_size_order,
+	 * num_subbuf_order, buf_size_order, extra_reader_sb, num_subbuf,
+	 * priv, notifiers, config, cpumask and name.
+	 */
+	chanb->start_tsc = config->cb.ring_buffer_clock_read(chan);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+/**
+ *	ring_buffer_cpu_hp_callback - CPU hotplug callback
+ *	@nb: notifier block
+ *	@action: hotplug action to take
+ *	@hcpu: CPU number
+ *
+ *	Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
+ */
+static
+int __cpuinit ring_buffer_cpu_hp_callback(struct notifier_block *nb,
+					  unsigned long action,
+					  void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct channel_backend *chanb = container_of(nb, struct channel_backend,
+						     cpu_hp_notifier);
+	const struct ring_buffer_config *config = chanb->config;
+	struct ring_buffer *buf;
+	int ret;
+
+	CHAN_WARN_ON(chanb, config->alloc == RING_BUFFER_ALLOC_GLOBAL);
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		buf = per_cpu_ptr(chanb->buf, cpu);
+		ret = ring_buffer_create(buf, chanb, cpu);
+		if (ret) {
+			printk(KERN_ERR
+			  "ring_buffer_cpu_hp_callback: cpu %d "
+			  "buffer creation failed\n", cpu);
+			return NOTIFY_BAD;
+		}
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		/* No need to do a buffer switch here, because it will happen
+		 * when tracing is stopped, or will be done by switch timer CPU
+		 * DEAD callback. */
+		break;
+	}
+	return NOTIFY_OK;
+}
+#endif
+
+/**
+ * channel_backend_init - initialize a channel backend
+ * @chanb: channel backend
+ * @name: channel name
+ * @config: client ring buffer configuration
+ * @priv: client private data
+ * @parent: dentry of parent directory, %NULL for root directory
+ * @subbuf_size: size of sub-buffers (> PAGE_SIZE, power of 2)
+ * @num_subbuf: number of sub-buffers (power of 2)
+ *
+ * Returns channel pointer if successful, %NULL otherwise.
+ *
+ * Creates per-cpu channel buffers using the sizes and attributes
+ * specified.  The created channel buffer files will be named
+ * name_0...name_N-1.  File permissions will be %S_IRUSR.
+ *
+ * Called with CPU hotplug disabled.
+ */
+int channel_backend_init(struct channel_backend *chanb,
+				const char *name,
+				const struct ring_buffer_config *config,
+				void *priv, size_t subbuf_size,
+				size_t num_subbuf)
+{
+	struct channel *chan = container_of(chanb, struct channel, backend);
+	unsigned int i;
+	int ret;
+
+	if (!name)
+		return -EPERM;
+
+	if (!(subbuf_size && num_subbuf))
+		return -EPERM;
+
+	/* Check that the subbuffer size is larger than a page. */
+	CHAN_WARN_ON(chanb, subbuf_size < PAGE_SIZE);
+
+	/*
+	 * Make sure the number of subbuffers and subbuffer size are power of 2.
+	 */
+	CHAN_WARN_ON(chanb, hweight32(subbuf_size) != 1);
+	CHAN_WARN_ON(chanb, hweight32(num_subbuf) != 1);
+
+	ret = subbuffer_id_check_index(config, num_subbuf);
+	if (ret)
+		return ret;
+
+	chanb->priv = priv;
+	chanb->buf_size = num_subbuf * subbuf_size;
+	chanb->subbuf_size = subbuf_size;
+	chanb->buf_size_order = get_count_order(chanb->buf_size);
+	chanb->subbuf_size_order = get_count_order(subbuf_size);
+	chanb->num_subbuf_order = get_count_order(num_subbuf);
+	chanb->extra_reader_sb =
+			(config->mode == RING_BUFFER_OVERWRITE) ? 1 : 0;
+	chanb->num_subbuf = num_subbuf;
+	strlcpy(chanb->name, name, NAME_MAX);
+	chanb->config = config;
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU) {
+		if (!zalloc_cpumask_var(&chanb->cpumask, GFP_KERNEL))
+			return -ENOMEM;
+	}
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU) {
+		/* Allocating the buffer per-cpu structures */
+		chanb->buf = alloc_percpu(struct ring_buffer);
+		if (!chanb->buf)
+			goto free_cpumask;
+
+		/*
+		 * In case of non-hotplug cpu, if the ring-buffer is allocated
+		 * in early initcall, it will not be notified of secondary cpus.
+		 * In that off case, we need to allocate for all possible cpus.
+		 */
+#ifdef CONFIG_HOTPLUG_CPU
+		/*
+		 * buf->backend.allocated test takes care of concurrent CPU
+		 * hotplug.
+		 * Priority higher than frontend, so we create the ring buffer
+		 * before we start the timer.
+		 */
+		chanb->cpu_hp_notifier.notifier_call =
+				ring_buffer_cpu_hp_callback;
+		chanb->cpu_hp_notifier.priority = 5;
+		register_hotcpu_notifier(&chanb->cpu_hp_notifier);
+
+		get_online_cpus();
+		for_each_online_cpu(i) {
+			ret = ring_buffer_create(per_cpu_ptr(chanb->buf, i),
+						 chanb, i);
+			if (ret)
+				goto free_bufs;	/* cpu hotplug locked */
+		}
+		put_online_cpus();
+#else
+		for_each_possible_cpu(i) {
+			ret = ring_buffer_create(per_cpu_ptr(chanb->buf, i),
+						 chanb, i);
+			if (ret)
+				goto free_bufs;	/* cpu hotplug locked */
+		}
+#endif
+	} else {
+		chanb->buf = kzalloc(sizeof(struct ring_buffer), GFP_KERNEL);
+		if (!chanb->buf)
+			goto free_cpumask;
+		ret = ring_buffer_create(chanb->buf, chanb, -1);
+		if (ret)
+			goto free_bufs;
+	}
+	chanb->start_tsc = config->cb.ring_buffer_clock_read(chan);
+
+	return 0;
+
+free_bufs:
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU) {
+		for_each_possible_cpu(i) {
+			struct ring_buffer *buf = per_cpu_ptr(chanb->buf, i);
+
+			if (!buf->backend.allocated)
+				continue;
+			ring_buffer_free(buf);
+		}
+#ifdef CONFIG_HOTPLUG_CPU
+		put_online_cpus();
+#endif
+		free_percpu(chanb->buf);
+	} else
+		kfree(chanb->buf);
+free_cpumask:
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU)
+		free_cpumask_var(chanb->cpumask);
+	return -ENOMEM;
+}
+
+/**
+ * channel_backend_unregister_notifiers - unregister notifiers
+ * @chan: the channel
+ *
+ * Holds CPU hotplug.
+ */
+void channel_backend_unregister_notifiers(struct channel_backend *chanb)
+{
+	const struct ring_buffer_config *config = chanb->config;
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU)
+		unregister_hotcpu_notifier(&chanb->cpu_hp_notifier);
+}
+
+/**
+ * channel_backend_free - destroy the channel
+ * @chan: the channel
+ *
+ * Destroy all channel buffers and frees the channel.
+ */
+void channel_backend_free(struct channel_backend *chanb)
+{
+	const struct ring_buffer_config *config = chanb->config;
+	unsigned int i;
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU) {
+		for_each_possible_cpu(i) {
+			struct ring_buffer *buf = per_cpu_ptr(chanb->buf, i);
+
+			if (!buf->backend.allocated)
+				continue;
+			ring_buffer_free(buf);
+		}
+		free_cpumask_var(chanb->cpumask);
+		free_percpu(chanb->buf);
+	} else {
+		struct ring_buffer *buf = chanb->buf;
+
+		CHAN_WARN_ON(chanb, !buf->backend.allocated);
+		ring_buffer_free(buf);
+		kfree(buf);
+	}
+}
+
+/**
+ * ring_buffer_write - write data to a ring_buffer buffer.
+ * @bufb : buffer backend
+ * @offset : offset within the buffer
+ * @src : source address
+ * @len : length to write
+ * @pagecpy : page size copied so far
+ */
+void _ring_buffer_write(struct ring_buffer_backend *bufb, size_t offset,
+			const void *src, size_t len, ssize_t pagecpy)
+{
+	struct channel_backend *chanb = &bufb->chan->backend;
+	const struct ring_buffer_config *config = chanb->config;
+	size_t sbidx, index;
+	struct ring_buffer_backend_pages *rpages;
+	unsigned long sb_bindex, id;
+
+	do {
+		len -= pagecpy;
+		src += pagecpy;
+		offset += pagecpy;
+		sbidx = offset >> chanb->subbuf_size_order;
+		index = (offset & (chanb->subbuf_size - 1)) >> PAGE_SHIFT;
+
+		/*
+		 * Underlying layer should never ask for writes across
+		 * subbuffers.
+		 */
+		CHAN_WARN_ON(chanb, offset >= chanb->buf_size);
+
+		pagecpy = min_t(size_t, len, PAGE_SIZE - (offset & ~PAGE_MASK));
+		id = bufb->buf_wsb[sbidx].id;
+		sb_bindex = subbuffer_id_get_index(config, id);
+		rpages = bufb->array[sb_bindex];
+		CHAN_WARN_ON(chanb, config->mode == RING_BUFFER_OVERWRITE
+			     && subbuffer_id_is_noref(config, id));
+		ring_buffer_do_copy(config,
+				    rpages->p[index].virt
+					+ (offset & ~PAGE_MASK),
+				    src, pagecpy);
+	} while (unlikely(len != pagecpy));
+}
+EXPORT_SYMBOL_GPL(_ring_buffer_write);
+
+/**
+ * ring_buffer_read - read data from ring_buffer_buffer.
+ * @bufb : buffer backend
+ * @offset : offset within the buffer
+ * @dest : destination address
+ * @len : length to copy to destination
+ *
+ * Should be protected by get_subbuf/put_subbuf.
+ * Returns the length copied.
+ */
+size_t ring_buffer_read(struct ring_buffer_backend *bufb, size_t offset,
+			void *dest, size_t len)
+{
+	struct channel_backend *chanb = &bufb->chan->backend;
+	const struct ring_buffer_config *config = chanb->config;
+	size_t index;
+	ssize_t pagecpy, orig_len;
+	struct ring_buffer_backend_pages *rpages;
+	unsigned long sb_bindex, id;
+
+	orig_len = len;
+	offset &= chanb->buf_size - 1;
+	index = (offset & (chanb->subbuf_size - 1)) >> PAGE_SHIFT;
+	if (unlikely(!len))
+		return 0;
+	for (;;) {
+		pagecpy = min_t(size_t, len, PAGE_SIZE - (offset & ~PAGE_MASK));
+		id = bufb->buf_rsb.id;
+		sb_bindex = subbuffer_id_get_index(config, id);
+		rpages = bufb->array[sb_bindex];
+		CHAN_WARN_ON(chanb, config->mode == RING_BUFFER_OVERWRITE
+			     && subbuffer_id_is_noref(config, id));
+		memcpy(dest, rpages->p[index].virt + (offset & ~PAGE_MASK),
+		       pagecpy);
+		len -= pagecpy;
+		if (likely(!len))
+			break;
+		dest += pagecpy;
+		offset += pagecpy;
+		index = (offset & (chanb->subbuf_size - 1)) >> PAGE_SHIFT;
+		/*
+		 * Underlying layer should never ask for reads across
+		 * subbuffers.
+		 */
+		CHAN_WARN_ON(chanb, offset >= chanb->buf_size);
+	}
+	return orig_len;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_read);
+
+/**
+ * ring_buffer_copy_to_user - read data from ring_buffer_buffer to userspace
+ * @bufb : buffer backend
+ * @offset : offset within the buffer
+ * @dest : destination userspace address
+ * @len : length to copy to destination
+ *
+ * Should be protected by get_subbuf/put_subbuf.
+ * access_ok() must have been performed on dest addresses prior to call this
+ * function.
+ * Returns -EFAULT on error, 0 if ok.
+ */
+int __ring_buffer_copy_to_user(struct ring_buffer_backend *bufb,
+			       size_t offset, void __user *dest, size_t len)
+{
+	struct channel_backend *chanb = &bufb->chan->backend;
+	const struct ring_buffer_config *config = chanb->config;
+	size_t index;
+	ssize_t pagecpy, orig_len;
+	struct ring_buffer_backend_pages *rpages;
+	unsigned long sb_bindex, id;
+
+	orig_len = len;
+	offset &= chanb->buf_size - 1;
+	index = (offset & (chanb->subbuf_size - 1)) >> PAGE_SHIFT;
+	if (unlikely(!len))
+		return 0;
+	for (;;) {
+		pagecpy = min_t(size_t, len, PAGE_SIZE - (offset & ~PAGE_MASK));
+		id = bufb->buf_rsb.id;
+		sb_bindex = subbuffer_id_get_index(config, id);
+		rpages = bufb->array[sb_bindex];
+		CHAN_WARN_ON(chanb, config->mode == RING_BUFFER_OVERWRITE
+			     && subbuffer_id_is_noref(config, id));
+		if (__copy_to_user(dest,
+			       rpages->p[index].virt + (offset & ~PAGE_MASK),
+			       pagecpy))
+			return -EFAULT;
+		len -= pagecpy;
+		if (likely(!len))
+			break;
+		dest += pagecpy;
+		offset += pagecpy;
+		index = (offset & (chanb->subbuf_size - 1)) >> PAGE_SHIFT;
+		/*
+		 * Underlying layer should never ask for reads across
+		 * subbuffers.
+		 */
+		CHAN_WARN_ON(chanb, offset >= chanb->buf_size);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__ring_buffer_copy_to_user);
+
+/**
+ * ring_buffer_read_cstr - read a C-style string from ring_buffer_buffer.
+ * @bufb : buffer backend
+ * @offset : offset within the buffer
+ * @dest : destination address
+ * @len : destination's length
+ *
+ * return string's length
+ * Should be protected by get_subbuf/put_subbuf.
+ */
+int ring_buffer_read_cstr(struct ring_buffer_backend *bufb, size_t offset,
+			  void *dest, size_t len)
+{
+	struct channel_backend *chanb = &bufb->chan->backend;
+	const struct ring_buffer_config *config = chanb->config;
+	size_t index;
+	ssize_t pagecpy, pagelen, strpagelen, orig_offset;
+	char *str;
+	struct ring_buffer_backend_pages *rpages;
+	unsigned long sb_bindex, id;
+
+	offset &= chanb->buf_size - 1;
+	index = (offset & (chanb->subbuf_size - 1)) >> PAGE_SHIFT;
+	orig_offset = offset;
+	for (;;) {
+		id = bufb->buf_rsb.id;
+		sb_bindex = subbuffer_id_get_index(config, id);
+		rpages = bufb->array[sb_bindex];
+		CHAN_WARN_ON(chanb, config->mode == RING_BUFFER_OVERWRITE
+			     && subbuffer_id_is_noref(config, id));
+		str = (char *)rpages->p[index].virt + (offset & ~PAGE_MASK);
+		pagelen = PAGE_SIZE - (offset & ~PAGE_MASK);
+		strpagelen = strnlen(str, pagelen);
+		if (len) {
+			pagecpy = min_t(size_t, len, strpagelen);
+			if (dest) {
+				memcpy(dest, str, pagecpy);
+				dest += pagecpy;
+			}
+			len -= pagecpy;
+		}
+		offset += strpagelen;
+		index = (offset & (chanb->subbuf_size - 1)) >> PAGE_SHIFT;
+		if (strpagelen < pagelen)
+			break;
+		/*
+		 * Underlying layer should never ask for reads across
+		 * subbuffers.
+		 */
+		CHAN_WARN_ON(chanb, offset >= chanb->buf_size);
+	}
+	if (dest && len)
+		((char *)dest)[0] = 0;
+	return offset - orig_offset;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_read_cstr);
+
+/**
+ * ring_buffer_read_get_page - Get a whole page to read from
+ * @bufb : buffer backend
+ * @offset : offset within the buffer
+ * @virt : pointer to page address (output)
+ *
+ * Should be protected by get_subbuf/put_subbuf.
+ * Returns the pointer to the page struct pointer.
+ */
+struct page **ring_buffer_read_get_page(struct ring_buffer_backend *bufb,
+					size_t offset, void ***virt)
+{
+	size_t index;
+	struct ring_buffer_backend_pages *rpages;
+	struct channel_backend *chanb = &bufb->chan->backend;
+	const struct ring_buffer_config *config = chanb->config;
+	unsigned long sb_bindex, id;
+
+	offset &= chanb->buf_size - 1;
+	index = (offset & (chanb->subbuf_size - 1)) >> PAGE_SHIFT;
+	id = bufb->buf_rsb.id;
+	sb_bindex = subbuffer_id_get_index(config, id);
+	rpages = bufb->array[sb_bindex];
+	CHAN_WARN_ON(chanb, config->mode == RING_BUFFER_OVERWRITE
+		     && subbuffer_id_is_noref(config, id));
+	*virt = &rpages->p[index].virt;
+	return &rpages->p[index].page;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_read_get_page);
+
+/**
+ * ring_buffer_read_offset_address - get address of a location within the buffer
+ * @bufb : buffer backend
+ * @offset : offset within the buffer.
+ *
+ * Return the address where a given offset is located (for read).
+ * Should be used to get the current subbuffer header pointer. Given we know
+ * it's never on a page boundary, it's safe to write directly to this address,
+ * as long as the write is never bigger than a page size.
+ */
+void *ring_buffer_read_offset_address(struct ring_buffer_backend *bufb,
+				      size_t offset)
+{
+	size_t index;
+	struct ring_buffer_backend_pages *rpages;
+	struct channel_backend *chanb = &bufb->chan->backend;
+	const struct ring_buffer_config *config = chanb->config;
+	unsigned long sb_bindex, id;
+
+	offset &= chanb->buf_size - 1;
+	index = (offset & (chanb->subbuf_size - 1)) >> PAGE_SHIFT;
+	id = bufb->buf_rsb.id;
+	sb_bindex = subbuffer_id_get_index(config, id);
+	rpages = bufb->array[sb_bindex];
+	CHAN_WARN_ON(chanb, config->mode == RING_BUFFER_OVERWRITE
+		     && subbuffer_id_is_noref(config, id));
+	return rpages->p[index].virt + (offset & ~PAGE_MASK);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_read_offset_address);
+
+/**
+ * ring_buffer_offset_address - get address of a location within the buffer
+ * @bufb : buffer backend
+ * @offset : offset within the buffer.
+ *
+ * Return the address where a given offset is located.
+ * Should be used to get the current subbuffer header pointer. Given we know
+ * it's always at the beginning of a page, it's safe to write directly to this
+ * address, as long as the write is never bigger than a page size.
+ */
+void *ring_buffer_offset_address(struct ring_buffer_backend *bufb,
+				 size_t offset)
+{
+	size_t sbidx, index;
+	struct ring_buffer_backend_pages *rpages;
+	struct channel_backend *chanb = &bufb->chan->backend;
+	const struct ring_buffer_config *config = chanb->config;
+	unsigned long sb_bindex, id;
+
+	offset &= chanb->buf_size - 1;
+	sbidx = offset >> chanb->subbuf_size_order;
+	index = (offset & (chanb->subbuf_size - 1)) >> PAGE_SHIFT;
+	id = bufb->buf_wsb[sbidx].id;
+	sb_bindex = subbuffer_id_get_index(config, id);
+	rpages = bufb->array[sb_bindex];
+	CHAN_WARN_ON(chanb, config->mode == RING_BUFFER_OVERWRITE
+		     && subbuffer_id_is_noref(config, id));
+	return rpages->p[index].virt + (offset & ~PAGE_MASK);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_offset_address);
Index: linux.trees.git/include/linux/ringbuffer/backend_types.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/backend_types.h	2010-07-15 13:36:17.000000000 -0400
@@ -0,0 +1,80 @@
+#ifndef _LINUX_RING_BUFFER_BACKEND_TYPES_H
+#define _LINUX_RING_BUFFER_BACKEND_TYPES_H
+
+/*
+ * linux/ringbuffer/backend_types.h
+ *
+ * Copyright (C) 2008-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring buffer backend (types).
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/cpumask.h>
+#include <linux/types.h>
+
+struct ring_buffer_backend_page {
+	void *virt;			/* page virtual address (cached) */
+	struct page *page;		/* pointer to page structure */
+};
+
+struct ring_buffer_backend_pages {
+	unsigned long mmap_offset;	/* offset of the subbuffer in mmap */
+	union v_atomic records_commit;	/* current records committed count */
+	union v_atomic records_unread;	/* records to read */
+	unsigned long data_size;	/* Amount of data to read from subbuf */
+	struct ring_buffer_backend_page p[];
+};
+
+struct ring_buffer_backend_subbuffer {
+	/* Identifier for subbuf backend pages. Exchanged atomically. */
+	unsigned long id;		/* backend subbuffer identifier */
+};
+
+/*
+ * Forward declaration of frontend-specific channel and ring_buffer.
+ */
+struct channel;
+struct ring_buffer;
+
+struct ring_buffer_backend {
+	/* Array of ring_buffer_backend_subbuffer for writer */
+	struct ring_buffer_backend_subbuffer *buf_wsb;
+	/* ring_buffer_backend_subbuffer for reader */
+	struct ring_buffer_backend_subbuffer buf_rsb;
+	/*
+	 * Pointer array of backend pages, for whole buffer.
+	 * Indexed by ring_buffer_backend_subbuffer identifier (id) index.
+	 */
+	struct ring_buffer_backend_pages **array;
+	unsigned int num_pages_per_subbuf;
+
+	struct channel *chan;		/* Associated channel */
+	int cpu;			/* This buffer's cpu. -1 if global. */
+	union v_atomic records_read;	/* Number of records read */
+	unsigned int allocated:1;	/* Bool: is buffer allocated ? */
+};
+
+struct channel_backend {
+	unsigned long buf_size;		/* Size of the buffer */
+	unsigned long subbuf_size;	/* Sub-buffer size */
+	unsigned int subbuf_size_order;	/* Order of sub-buffer size */
+	unsigned int num_subbuf_order;	/*
+					 * Order of number of sub-buffers/buffer
+					 * for writer.
+					 */
+	unsigned int buf_size_order;	/* Order of buffer size */
+	int extra_reader_sb:1;		/* Bool: has extra reader subbuffer */
+	struct ring_buffer *buf;	/* Channel per-cpu buffers */
+
+	unsigned long num_subbuf;	/* Number of sub-buffers for writer */
+	u64 start_tsc;			/* Channel creation TSC value */
+	void *priv;			/* Client-specific information */
+	struct notifier_block cpu_hp_notifier;	 /* CPU hotplug notifier */
+	const struct ring_buffer_config *config; /* Ring buffer configuration */
+	cpumask_var_t cpumask;		/* Allocated per-cpu buffers cpumask */
+	char name[NAME_MAX];		/* Channel name */
+};
+
+#endif /* _LINUX_RING_BUFFER_BACKEND_TYPES_H */

