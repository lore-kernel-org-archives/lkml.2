Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0GIXjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:39:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59632 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709Ab0GIXjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:39:42 -0400
Message-Id: <20100709225819.667435403@efficios.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 18:57:46 -0400
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
Subject: [patch 19/20] Ring Buffer: Basic API
References: <20100709225727.312232266@efficios.com>
Content-Disposition: inline; filename=ring-buffer-simple-api.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  9 Jul 2010 22:58:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Offer basic APIs for pre-built ring buffer clients:

- Global Overwrite
- Global Discard

- Per-cpu Overwrite with channel-wide iterator
- Per-cpu Discard with channel-wide iterator

- Per-cpu Overwrite with buffer-local iterator
- Per-cpu Discard with buffer-local iterator

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/ringbuffer/global_discard.h         |   39 ++
 include/linux/ringbuffer/global_overwrite.h       |   40 ++
 include/linux/ringbuffer/percpu_discard.h         |   39 ++
 include/linux/ringbuffer/percpu_local_discard.h   |   47 ++
 include/linux/ringbuffer/percpu_local_overwrite.h |   47 ++
 include/linux/ringbuffer/percpu_overwrite.h       |   40 ++
 lib/ringbuffer/Makefile                           |   15 
 lib/ringbuffer/ring_buffer_global.c               |  317 ++++++++++++++++++
 lib/ringbuffer/ring_buffer_percpu.c               |  334 +++++++++++++++++++
 lib/ringbuffer/ring_buffer_percpu_local.c         |  371 ++++++++++++++++++++++
 10 files changed, 1283 insertions(+), 6 deletions(-)

Index: linux.trees.git/lib/ringbuffer/Makefile
===================================================================
--- linux.trees.git.orig/lib/ringbuffer/Makefile	2010-07-09 18:34:50.000000000 -0400
+++ linux.trees.git/lib/ringbuffer/Makefile	2010-07-09 18:35:16.000000000 -0400
@@ -1,6 +1,9 @@
-obj-y += ring_buffer_backend.o
-obj-y += ring_buffer_frontend.o
-obj-y += ring_buffer_iterator.o
-obj-y += ring_buffer_vfs.o
-obj-y += ring_buffer_splice.o
-obj-y += ring_buffer_mmap.o
+ring_buffer-objs := ring_buffer_backend.o ring_buffer_frontend.o \
+		ring_buffer_iterator.o ring_buffer_vfs.o \
+		ring_buffer_splice.o ring_buffer_mmap.o
+
+obj-$(CONFIG_LIB_RING_BUFFER) += ring_buffer.o
+
+obj-$(CONFIG_LIB_RING_BUFFER_CLIENTS) += ring_buffer_global.o
+obj-$(CONFIG_LIB_RING_BUFFER_CLIENTS) += ring_buffer_percpu.o
+obj-$(CONFIG_LIB_RING_BUFFER_CLIENTS) += ring_buffer_percpu_local.o
Index: linux.trees.git/include/linux/ringbuffer/global_discard.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/global_discard.h	2010-07-09 18:35:16.000000000 -0400
@@ -0,0 +1,39 @@
+#ifndef _RING_BUFFER_GLOBAL_DISCARD_H
+#define _RING_BUFFER_GLOBAL_DISCARD_H
+
+/*
+ * ring_buffer_global_discard.h
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring buffer global discard API. Drops records when buffer is full.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/ringbuffer/iterator.h>
+#include <linux/types.h>
+
+/*
+ * ring_buffer_global_discard_create creates a global discard ring buffer.
+ * buf_size is the buffer size, which will be rounded up to the next power of 2
+ * (the floor value is 2*PAGE_SIZE). Returns the ring buffer channel address on
+ * success, NULL on error.
+ */
+extern struct channel *ring_buffer_global_discard_create(size_t buf_size);
+
+/*
+ * ring_buffer_global_discard_destroy finalizes all channel's buffers, waits
+ * for readers to release all references, and destroys the channel.
+ */
+extern void ring_buffer_global_discard_destroy(struct channel *chan);
+
+/*
+ * ring_buffer_global_discard_write writes a record into the ring buffer. The
+ * record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+extern int ring_buffer_global_discard_write(struct channel *chan,
+					    const void *src, size_t len);
+
+#endif /* _RING_BUFFER_GLOBAL_DISCARD_H */
Index: linux.trees.git/include/linux/ringbuffer/global_overwrite.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/global_overwrite.h	2010-07-09 18:35:16.000000000 -0400
@@ -0,0 +1,40 @@
+#ifndef _RING_BUFFER_GLOBAL_OVERWRITE_H
+#define _RING_BUFFER_GLOBAL_OVERWRITE_H
+
+/*
+ * ring_buffer_global_overwrite.h
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring buffer global overwrite API. Overwrites oldest records when buffer is
+ * full.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/ringbuffer/iterator.h>
+#include <linux/types.h>
+
+/*
+ * ring_buffer_global_overwrite_create creates a global overwrite ring buffer.
+ * buf_size is the buffer size, which will be rounded up to the next power of 2
+ * (the floor value is 2*PAGE_SIZE). Returns the ring buffer channel address on
+ * success, NULL on error.
+ */
+extern struct channel *ring_buffer_global_overwrite_create(size_t buf_size);
+
+/*
+ * ring_buffer_global_overwrite_destroy finalizes all channel's buffers, waits
+ * for readers to release all references, and destroys the channel.
+ */
+extern void ring_buffer_global_overwrite_destroy(struct channel *chan);
+
+/*
+ * ring_buffer_global_overwrite_write writes a record into the ring buffer. The
+ * record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+extern int ring_buffer_global_overwrite_write(struct channel *chan,
+					      const void *src, size_t len);
+
+#endif /* _RING_BUFFER_GLOBAL_OVERWRITE_H */
Index: linux.trees.git/include/linux/ringbuffer/percpu_discard.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/percpu_discard.h	2010-07-09 18:35:16.000000000 -0400
@@ -0,0 +1,39 @@
+#ifndef _RING_BUFFER_PERCPU_DISCARD_H
+#define _RING_BUFFER_PERCPU_DISCARD_H
+
+/*
+ * ring_buffer_percpu_discard.h
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Per-CPU ring buffer discard API. Drops records when buffer is full.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/ringbuffer/iterator.h>
+#include <linux/types.h>
+
+/*
+ * ring_buffer_percpu_discard_create creates a per-cpu producer-consumer ring
+ * buffer.  buf_size is the buffer size, which will be rounded up to the next
+ * power of 2 (the floor value is 2*PAGE_SIZE). Returns the ring buffer channel
+ * address on success, NULL on error.
+ */
+extern struct channel *ring_buffer_percpu_discard_create(size_t buf_size);
+
+/*
+ * ring_buffer_percpu_discard_destroy finalizes all channel's buffers, waits
+ * for readers to release all references, and destroys the channel.
+ */
+extern void ring_buffer_percpu_discard_destroy(struct channel *chan);
+
+/*
+ * ring_buffer_percpu_discard_write writes a record into the ring buffer. The
+ * record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+extern int ring_buffer_percpu_discard_write(struct channel *chan,
+					    const void *src, size_t len);
+
+#endif /* _RING_BUFFER_PERCPU_DISCARD_H */
Index: linux.trees.git/include/linux/ringbuffer/percpu_local_discard.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/percpu_local_discard.h	2010-07-09 18:35:43.000000000 -0400
@@ -0,0 +1,47 @@
+#ifndef _RING_BUFFER_PERCPU_LOCAL_DISCARD_H
+#define _RING_BUFFER_PERCPU_LOCAL_DISCARD_H
+
+/*
+ * ring_buffer_percpu_local_discard.h
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Per-CPU local ring buffer discard API. Drops records when buffer is full.
+ * Presents per-cpu-buffer iterators.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/ringbuffer/iterator.h>
+#include <linux/types.h>
+
+/*
+ * ring_buffer_percpu_local_discard_create creates a per-cpu producer-consumer
+ * ring buffer with local iterators. buf_size is the buffer size, which will be
+ * rounded up to the next power of 2 (the floor value is 2*PAGE_SIZE). Returns
+ * the ring buffer channel address on success, NULL on error.
+ * on_buffer_create and on_buffer_finalize are callbacks called whenever a
+ * per-cpu buffer is created or finalized. on_buffer_create returns 0 on
+ * success.
+ */
+extern
+struct channel *ring_buffer_percpu_local_discard_create(size_t buf_size,
+		int (*on_buffer_create)(struct ring_buffer *buf, int cpu),
+		void (*on_buffer_finalize)(struct ring_buffer *buf, int cpu));
+
+/*
+ * ring_buffer_percpu_local_discard_destroy finalizes all channel's buffers,
+ * waits for readers to release all references, and destroys the channel.
+ */
+extern void ring_buffer_percpu_local_discard_destroy(struct channel *chan);
+
+/*
+ * ring_buffer_percpu_local_discard_write writes a record into the ring buffer.
+ * The record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+extern
+int ring_buffer_percpu_local_discard_write(struct channel *chan,
+					   const void *src, size_t len);
+
+#endif /* _RING_BUFFER_PERCPU_LOCAL_DISCARD_H */
Index: linux.trees.git/include/linux/ringbuffer/percpu_local_overwrite.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/percpu_local_overwrite.h	2010-07-09 18:35:16.000000000 -0400
@@ -0,0 +1,47 @@
+#ifndef _RING_BUFFER_PERCPU_LOCAL_OVERWRITE_H
+#define _RING_BUFFER_PERCPU_LOCAL_OVERWRITE_H
+
+/*
+ * ring_buffer_percpu_local_overwrite.h
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Per-CPU local ring buffer overwrite API. Overwrites oldest records
+ * when buffer is full. Presents per-cpu-buffer iterators.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/ringbuffer/iterator.h>
+#include <linux/types.h>
+
+/*
+ * ring_buffer_percpu_local_overwrite_create creates a per-cpu overwrite ring
+ * buffer with local iterators. buf_size is the buffer size, which will be
+ * rounded up to the next power of 2 (the floor value is 2*PAGE_SIZE). Returns
+ * the ring buffer channel address on success, NULL on error.
+ * on_buffer_create and on_buffer_finalize are callbacks called whenever a
+ * per-cpu buffer is created or finalized. on_buffer_create returns 0 on
+ * success.
+ */
+extern
+struct channel *ring_buffer_percpu_local_overwrite_create(size_t buf_size,
+		int (*on_buffer_create)(struct ring_buffer *buf, int cpu),
+		void (*on_buffer_finalize)(struct ring_buffer *buf, int cpu));
+
+/*
+ * ring_buffer_percpu_local_overwrite_destroy finalizes all channel's buffers,
+ * waits for readers to release all references, and destroys the channel.
+ */
+extern void ring_buffer_percpu_local_overwrite_destroy(struct channel *chan);
+
+/*
+ * ring_buffer_percpu_local_overwrite_write writes a record into the ring
+ * buffer. The record starts at the "src" address and is "len" bytes long.
+ * Returns 0 on success, else it returns a negative error value.
+ */
+extern
+int ring_buffer_percpu_local_overwrite_write(struct channel *chan,
+					     const void *src, size_t len);
+
+#endif /* _RING_BUFFER_PERCPU_LOCAL_OVERWRITE_H */
Index: linux.trees.git/include/linux/ringbuffer/percpu_overwrite.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/percpu_overwrite.h	2010-07-09 18:35:16.000000000 -0400
@@ -0,0 +1,40 @@
+#ifndef _RING_BUFFER_PERCPU_OVERWRITE_H
+#define _RING_BUFFER_PERCPU_OVERWRITE_H
+
+/*
+ * ring_buffer_percpu_overwrite.h
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Per-CPU ring buffer overwrite API. Overwrites oldest records when
+ * buffer is full.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/ringbuffer/iterator.h>
+#include <linux/types.h>
+
+/*
+ * ring_buffer_percpu_overwrite_create creates a per-cpu overwrite ring buffer.
+ * buf_size is the buffer size, which will be rounded up to the next power of 2
+ * (the floor value is 2*PAGE_SIZE). Returns the ring buffer channel address on
+ * success, NULL on error.
+ */
+extern struct channel *ring_buffer_percpu_overwrite_create(size_t buf_size);
+
+/*
+ * ring_buffer_percpu_overwrite_destroy finalizes all channel's buffers, waits
+ * for readers to release all references, and destroys the channel.
+ */
+extern void ring_buffer_percpu_overwrite_destroy(struct channel *chan);
+
+/*
+ * ring_buffer_percpu_overwrite_write writes a record into the ring buffer. The
+ * record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+extern int ring_buffer_percpu_overwrite_write(struct channel *chan,
+					      const void *src, size_t len);
+
+#endif /* _RING_BUFFER_PERCPU_OVERWRITE_H */
Index: linux.trees.git/lib/ringbuffer/ring_buffer_global.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/lib/ringbuffer/ring_buffer_global.c	2010-07-09 18:35:16.000000000 -0400
@@ -0,0 +1,317 @@
+/*
+ * ring_buffer_global.c
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring buffer global library implementation.
+ * Creates instances of both overwrite and discard modes.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/ringbuffer/config.h>
+#include <linux/ringbuffer/global_overwrite.h>
+#include <linux/ringbuffer/global_discard.h>
+#include <linux/ringbuffer/vfs.h>
+
+struct subbuffer_header {
+	uint8_t header_end[0];		/* End of header */
+};
+
+struct record_header {
+	uint32_t len;			/* Size of record payload */
+	uint8_t header_end[0];		/* End of header */
+};
+
+static inline
+u64 ring_buffer_clock_read(struct channel *chan)
+{
+	return 0;
+}
+
+static inline
+unsigned char record_header_size(const struct ring_buffer_config *config,
+				 struct channel *chan, size_t offset,
+				 size_t data_size, size_t *pre_header_padding,
+				 unsigned int rflags,
+				 struct ring_buffer_ctx *ctx)
+{
+	return offsetof(struct record_header, header_end);
+}
+
+#include <linux/ringbuffer/api.h>
+
+static
+u64 client_ring_buffer_clock_read(struct channel *chan)
+{
+	return 0;
+}
+
+static
+size_t client_record_header_size(const struct ring_buffer_config *config,
+				 struct channel *chan, size_t offset,
+				 size_t data_size,
+				 size_t *pre_header_padding,
+				 unsigned int rflags,
+				 struct ring_buffer_ctx *ctx)
+{
+	return record_header_size(config, chan, offset, data_size,
+				  pre_header_padding, rflags, ctx);
+}
+
+static
+size_t client_subbuffer_header_size(void)
+{
+	return offsetof(struct subbuffer_header, header_end);
+}
+
+static
+void client_buffer_begin(struct ring_buffer *buf, u64 tsc,
+			 unsigned int subbuf_idx)
+{
+}
+
+static
+void client_buffer_end(struct ring_buffer *buf, u64 tsc,
+		       unsigned int subbuf_idx, unsigned long data_size)
+{
+}
+
+static
+int client_buffer_create(struct ring_buffer *buf, void *priv,
+			 int cpu, const char *name)
+{
+	return 0;
+}
+
+static
+void client_buffer_finalize(struct ring_buffer *buf, void *priv, int cpu)
+{
+}
+
+static
+void client_record_get(const struct ring_buffer_config *config,
+		       struct channel *chan, struct ring_buffer *buf,
+		       size_t offset, size_t *header_len,
+		       size_t *payload_len, u64 *timestamp)
+{
+	struct record_header header;
+	int ret;
+
+	ret = ring_buffer_read(&buf->backend, offset, &header,
+			       offsetof(struct record_header, header_end));
+	CHAN_WARN_ON(chan, ret != offsetof(struct record_header, header_end));
+	*header_len = offsetof(struct record_header, header_end);
+	*payload_len = header.len;
+	*timestamp = 0;
+}
+
+/*
+ * Typically 8 subbuffers of variable size.
+ * Maximum subbuffer size is 4GB. Allocate more subbuffers if more space is
+ * requested.
+ * Periodical buffer switch deferrable timer set to 100ms.
+ * Periodical reader wakeup delivery timer is disabled. It is useless because
+ * RING_BUFFER_WAKEUP_BY_WRITER is set.
+ */
+#define SG_SUBBUF_NUM_ORDER	3
+#define SG_SUBBUF_NUM		(1 << SG_SUBBUF_NUM_ORDER)
+#define SG_SWITCH_INTERVAL_MS	100U
+#define SG_SWITCH_INTERVAL_US	(SG_SWITCH_INTERVAL_MS * 1000)
+#define SG_READ_INTERVAL_US	0
+#define SG_U32_MAX		4294967295U	/* 2^32 - 1 */
+
+static const struct ring_buffer_config global_overwrite_config = {
+	.cb.ring_buffer_clock_read = client_ring_buffer_clock_read,
+	.cb.record_header_size = client_record_header_size,
+	.cb.subbuffer_header_size = client_subbuffer_header_size,
+	.cb.buffer_begin = client_buffer_begin,
+	.cb.buffer_end = client_buffer_end,
+	.cb.buffer_create = client_buffer_create,
+	.cb.buffer_finalize = client_buffer_finalize,
+	.cb.record_get = client_record_get,
+
+	.tsc_bits = 0,
+	.alloc = RING_BUFFER_ALLOC_GLOBAL,
+	.sync = RING_BUFFER_SYNC_GLOBAL,
+	.mode = RING_BUFFER_OVERWRITE,
+	.align = RING_BUFFER_PACKED,
+	.backend = RING_BUFFER_PAGE,
+	.output = RING_BUFFER_ITERATOR,
+	.oops = RING_BUFFER_NO_OOPS_CONSISTENCY,
+	.ipi = RING_BUFFER_NO_IPI_BARRIER,
+	.wakeup = RING_BUFFER_WAKEUP_BY_WRITER,
+};
+
+static const struct ring_buffer_config global_discard_config = {
+	.cb.ring_buffer_clock_read = client_ring_buffer_clock_read,
+	.cb.record_header_size = client_record_header_size,
+	.cb.subbuffer_header_size = client_subbuffer_header_size,
+	.cb.buffer_begin = client_buffer_begin,
+	.cb.buffer_end = client_buffer_end,
+	.cb.buffer_create = client_buffer_create,
+	.cb.buffer_finalize = client_buffer_finalize,
+	.cb.record_get = client_record_get,
+
+	.tsc_bits = 0,
+	.alloc = RING_BUFFER_ALLOC_GLOBAL,
+	.sync = RING_BUFFER_SYNC_GLOBAL,
+	.mode = RING_BUFFER_DISCARD,
+	.align = RING_BUFFER_PACKED,
+	.backend = RING_BUFFER_PAGE,
+	.output = RING_BUFFER_ITERATOR,
+	.oops = RING_BUFFER_NO_OOPS_CONSISTENCY,
+	.ipi = RING_BUFFER_NO_IPI_BARRIER,
+	.wakeup = RING_BUFFER_WAKEUP_BY_WRITER,
+};
+
+/* Wrapper library API */
+
+static
+struct channel *ring_buffer_global_create(
+				const struct ring_buffer_config *config,
+				size_t buf_size)
+{
+	size_t subbuf_size, subbuf_size_order;
+	unsigned int subbuf_num = SG_SUBBUF_NUM;
+
+	/* Typically use 8 subbuffers, minimum of PAGE_SIZE size each */
+	buf_size = max_t(size_t, buf_size, PAGE_SIZE << SG_SUBBUF_NUM_ORDER);
+	subbuf_size = buf_size >> SG_SUBBUF_NUM_ORDER;
+	/*
+	 * Ensure the event payload size fits on u32 event header.
+	 * Maximum subbuffer size is therefore 4GB.
+	 */
+	subbuf_size = min_t(size_t, SG_U32_MAX, subbuf_size);
+
+	/* Allocate more than 8 subbuffers if necessary. */
+	if (subbuf_size < (buf_size >> SG_SUBBUF_NUM_ORDER)) {
+		subbuf_size_order = get_count_order(subbuf_size);
+		subbuf_num = buf_size >> subbuf_size_order;
+	}
+
+	return channel_create(config, "sg", NULL, NULL,
+			      subbuf_size, subbuf_num,
+			      SG_SWITCH_INTERVAL_US, SG_READ_INTERVAL_US);
+}
+
+/**
+ * ring_buffer_global_overwrite_create - creates a global overwrite ring buffer.
+ * @buf_size: the buffer size
+ *
+ * Returns the ring buffer channel address on success, NULL on error.
+ */
+struct channel *ring_buffer_global_overwrite_create(size_t buf_size)
+{
+	return ring_buffer_global_create(&global_overwrite_config, buf_size);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_global_overwrite_create);
+
+/**
+ * ring_buffer_global_discard_create - creates a global discard ring buffer.
+ * @buf_size: the buffer size
+ *
+ * Returns the ring buffer channel address on success, NULL on error.
+ */
+
+struct channel *ring_buffer_global_discard_create(size_t buf_size)
+{
+	return ring_buffer_global_create(&global_discard_config, buf_size);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_global_discard_create);
+
+static
+void ring_buffer_global_destroy(struct channel *chan)
+{
+	channel_destroy(chan);
+}
+
+/**
+ * ring_buffer_global_overwrite_destroy - teardown global overwrite ring buffer.
+ * @chan: ring buffer channel
+ */
+void ring_buffer_global_overwrite_destroy(struct channel *chan)
+{
+	ring_buffer_global_destroy(chan);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_global_overwrite_destroy);
+
+/**
+ * ring_buffer_global_overwrite_destroy - teardown global discard ring buffer.
+ * @chan: ring buffer channel
+ */
+void ring_buffer_global_discard_destroy(struct channel *chan)
+{
+	ring_buffer_global_destroy(chan);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_global_discard_destroy);
+
+/**
+ * ring_buffer_global_write - writes a record into the ring buffer.
+ * @chan: ring buffer channel
+ * @src: start of input to copy from
+ * @len: length of record
+ *
+ * The record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+static
+int ring_buffer_global_write(const struct ring_buffer_config *config,
+			     struct channel *chan, const void *src, size_t len)
+{
+	struct record_header header;
+	struct ring_buffer_ctx ctx;
+	int ret;
+
+	ring_buffer_ctx_init(&ctx, chan, NULL, len, 0, 0);
+	ret = ring_buffer_reserve(config, &ctx);
+	if (ret)
+		goto end;
+	header.len = len;
+	ring_buffer_write(config, &ctx, &header,
+			  offsetof(struct record_header, header_end));
+	ring_buffer_write(config, &ctx, src, len);
+	ring_buffer_commit(config, &ctx);
+end:
+	return ret;
+
+}
+
+/**
+ * ring_buffer_global_overwrite_write - writes a record into the ring buffer.
+ * @chan: ring buffer channel
+ * @src: start of input to copy from
+ * @len: length of record
+ *
+ * The record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+int ring_buffer_global_overwrite_write(struct channel *chan, const void *src,
+				       size_t len)
+{
+	return ring_buffer_global_write(&global_overwrite_config, chan, src,
+					len);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_global_overwrite_write);
+
+/**
+ * ring_buffer_global_discard_write - writes a record into the ring buffer.
+ * @chan: ring buffer channel
+ * @src: start of input to copy from
+ * @len: length of record
+ *
+ * The record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+int ring_buffer_global_discard_write(struct channel *chan, const void *src,
+				     size_t len)
+{
+	return ring_buffer_global_write(&global_discard_config, chan, src, len);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_global_discard_write);
+
+MODULE_LICENSE("GPL and additional rights");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Ring Buffer Library Global Client");
Index: linux.trees.git/lib/ringbuffer/ring_buffer_percpu.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/lib/ringbuffer/ring_buffer_percpu.c	2010-07-09 18:35:16.000000000 -0400
@@ -0,0 +1,334 @@
+/*
+ * ring_buffer_percpu.c
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Per-CPU ring buffer library implementation.
+ * Creates instances of both overwrite and discard modes.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/ringbuffer/config.h>
+#include <linux/ringbuffer/percpu_overwrite.h>
+#include <linux/ringbuffer/percpu_discard.h>
+#include <linux/ringbuffer/vfs.h>
+#include <linux/prio_heap.h>
+#include <linux/trace_clock.h>
+
+struct subbuffer_header {
+	uint8_t header_end[0];		/* End of header */
+};
+
+struct record_header {
+	uint64_t timestamp;		/* Record timestamp */
+	uint32_t len;			/* Size of record payload */
+	uint8_t header_end[0];		/* End of header */
+};
+
+static inline
+u64 ring_buffer_clock_read(struct channel *chan)
+{
+	return trace_clock();
+}
+
+static inline
+unsigned char record_header_size(const struct ring_buffer_config *config,
+				 struct channel *chan, size_t offset,
+				 size_t data_size, size_t *pre_header_padding,
+				 unsigned int rflags,
+				 struct ring_buffer_ctx *ctx)
+{
+	return offsetof(struct record_header, header_end);
+}
+
+#include <linux/ringbuffer/api.h>
+
+static
+u64 client_ring_buffer_clock_read(struct channel *chan)
+{
+	return ring_buffer_clock_read(chan);
+}
+
+static
+size_t client_record_header_size(const struct ring_buffer_config *config,
+				 struct channel *chan, size_t offset,
+				 size_t data_size,
+				 size_t *pre_header_padding,
+				 unsigned int rflags,
+				 struct ring_buffer_ctx *ctx)
+{
+	return record_header_size(config, chan, offset, data_size,
+				  pre_header_padding, rflags, ctx);
+}
+
+static
+size_t client_subbuffer_header_size(void)
+{
+	return offsetof(struct subbuffer_header, header_end);
+}
+
+static
+void client_buffer_begin(struct ring_buffer *buf, u64 tsc,
+			 unsigned int subbuf_idx)
+{
+}
+
+static
+void client_buffer_end(struct ring_buffer *buf, u64 tsc,
+		       unsigned int subbuf_idx, unsigned long data_size)
+{
+}
+
+static
+int client_buffer_create(struct ring_buffer *buf, void *priv,
+			 int cpu, const char *name)
+{
+	return 0;
+}
+
+static
+void client_buffer_finalize(struct ring_buffer *buf, void *priv, int cpu)
+{
+}
+
+static
+void client_record_get(const struct ring_buffer_config *config,
+		       struct channel *chan, struct ring_buffer *buf,
+		       size_t offset, size_t *header_len,
+		       size_t *payload_len, u64 *timestamp)
+{
+	int ret;
+	struct record_header header;
+
+	ret = ring_buffer_read(&buf->backend, offset, &header,
+			       offsetof(struct record_header, header_end));
+	CHAN_WARN_ON(chan, ret != offsetof(struct record_header, header_end));
+	*header_len = offsetof(struct record_header, header_end);
+	*payload_len = header.len;
+	*timestamp = header.timestamp;
+}
+
+/*
+ * Typically 8 subbuffers of variable size per CPU. We allocate more than 2
+ * subbuffers per cpu to provide room for the merge-sort.
+ * Maximum subbuffer size is 4GB. Allocate more subbuffers if more space is
+ * requested.
+ * Periodical buffer switch deferrable timer is set to 100ms. This will wake up
+ * blocking reads when partially filled subbuffers are ready for reading.
+ * Periodical reader wakeup delivery timer is disabled. It is useless because
+ * RING_BUFFER_WAKEUP_BY_WRITER is set.
+ */
+#define SP_SUBBUF_NUM_ORDER	3
+#define SP_SUBBUF_NUM		(1 << SP_SUBBUF_NUM_ORDER)
+#define SP_SWITCH_INTERVAL_MS	100U
+#define SP_SWITCH_INTERVAL_US	(SP_SWITCH_INTERVAL_MS * 1000)
+#define SP_READ_INTERVAL_US	0
+#define SP_U32_MAX		4294967295U	/* 2^32 - 1 */
+
+static const struct ring_buffer_config percpu_overwrite_config = {
+	.cb.ring_buffer_clock_read = client_ring_buffer_clock_read,
+	.cb.record_header_size = client_record_header_size,
+	.cb.subbuffer_header_size = client_subbuffer_header_size,
+	.cb.buffer_begin = client_buffer_begin,
+	.cb.buffer_end = client_buffer_end,
+	.cb.buffer_create = client_buffer_create,
+	.cb.buffer_finalize = client_buffer_finalize,
+	.cb.record_get = client_record_get,
+
+	.tsc_bits = 64,
+	.alloc = RING_BUFFER_ALLOC_PER_CPU,
+	.sync = RING_BUFFER_SYNC_PER_CPU,
+	.mode = RING_BUFFER_OVERWRITE,
+	.align = RING_BUFFER_PACKED,
+	.backend = RING_BUFFER_PAGE,
+	.output = RING_BUFFER_ITERATOR,
+	.oops = RING_BUFFER_NO_OOPS_CONSISTENCY,
+	.ipi = RING_BUFFER_IPI_BARRIER,
+	.wakeup = RING_BUFFER_WAKEUP_BY_WRITER,
+};
+
+static const struct ring_buffer_config percpu_discard_config = {
+	.cb.ring_buffer_clock_read = client_ring_buffer_clock_read,
+	.cb.record_header_size = client_record_header_size,
+	.cb.subbuffer_header_size = client_subbuffer_header_size,
+	.cb.buffer_begin = client_buffer_begin,
+	.cb.buffer_end = client_buffer_end,
+	.cb.buffer_create = client_buffer_create,
+	.cb.buffer_finalize = client_buffer_finalize,
+	.cb.record_get = client_record_get,
+
+	.tsc_bits = 64,
+	.alloc = RING_BUFFER_ALLOC_PER_CPU,
+	.sync = RING_BUFFER_SYNC_PER_CPU,
+	.mode = RING_BUFFER_DISCARD,
+	.align = RING_BUFFER_PACKED,
+	.backend = RING_BUFFER_PAGE,
+	.output = RING_BUFFER_ITERATOR,
+	.oops = RING_BUFFER_NO_OOPS_CONSISTENCY,
+	.ipi = RING_BUFFER_IPI_BARRIER,
+	.wakeup = RING_BUFFER_WAKEUP_BY_WRITER,
+};
+
+/* Wrapper library API */
+
+static
+struct channel *ring_buffer_percpu_create(
+				const struct ring_buffer_config *config,
+				size_t buf_size)
+{
+	size_t subbuf_size, subbuf_size_order;
+	unsigned int subbuf_num = SP_SUBBUF_NUM;
+
+	/* Typically use 8 subbuffers, minimum of PAGE_SIZE size each */
+	buf_size = max_t(size_t, buf_size, PAGE_SIZE << SP_SUBBUF_NUM_ORDER);
+	subbuf_size = buf_size >> SP_SUBBUF_NUM_ORDER;
+	/*
+	 * Ensure the event payload size fits on u32 event header.
+	 * Maximum subbuffer size is therefore 4GB.
+	 */
+	subbuf_size = min_t(size_t, SP_U32_MAX, subbuf_size);
+
+	/* Allocate more than 8 subbuffers if necessary. */
+	if (subbuf_size < (buf_size >> SP_SUBBUF_NUM_ORDER)) {
+		subbuf_size_order = get_count_order(subbuf_size);
+		subbuf_num = buf_size >> subbuf_size_order;
+	}
+
+	return channel_create(config, "sp", NULL, NULL,
+			      subbuf_size, subbuf_num,
+			      SP_SWITCH_INTERVAL_US, SP_READ_INTERVAL_US);
+}
+
+/**
+ * ring_buffer_percpu_overwrite_create - creates a per-cpu overwrite ring
+ *                                       buffer.
+ * @buf_size: the buffer size
+ *
+ * Returns the ring buffer channel address on success, NULL on error.
+ */
+struct channel *ring_buffer_percpu_overwrite_create(size_t buf_size)
+{
+	return ring_buffer_percpu_create(&percpu_overwrite_config, buf_size);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_percpu_overwrite_create);
+
+/**
+ * ring_buffer_percpu_discard_create - creates a per-cpu discard ring buffer.
+ * @buf_size: the buffer size
+ *
+ * Returns the ring buffer channel address on success, NULL on error.
+ */
+
+struct channel *ring_buffer_percpu_discard_create(size_t buf_size)
+{
+	return ring_buffer_percpu_create(&percpu_discard_config, buf_size);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_percpu_discard_create);
+
+static
+void ring_buffer_percpu_destroy(struct channel *chan)
+{
+	channel_destroy(chan);
+}
+
+/**
+ * ring_buffer_percpu_overwrite_destroy - deletes a per-cpu
+ *                                        overwrite ring buffer.
+ * @chan: ring buffer channel
+ */
+void ring_buffer_percpu_overwrite_destroy(struct channel *chan)
+{
+	ring_buffer_percpu_destroy(chan);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_percpu_overwrite_destroy);
+
+/**
+ * ring_buffer_percpu_discard_destroy - deletes a per-cpu
+ *                                      discard ring buffer.
+ * @chan: ring buffer channel
+ */
+void ring_buffer_percpu_discard_destroy(struct channel *chan)
+{
+	ring_buffer_percpu_destroy(chan);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_percpu_discard_destroy);
+
+/**
+ * ring_buffer_percpu_write - writes a record into the ring buffer.
+ * @chan: ring buffer channel
+ * @src: start of input to copy from
+ * @len: length of record
+ *
+ * The record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+static
+int ring_buffer_percpu_write(const struct ring_buffer_config *config,
+			     struct channel *chan, const void *src, size_t len)
+{
+	struct percpu_private *priv = channel_get_private(chan);
+	struct record_header header;
+	struct ring_buffer_ctx ctx;
+	int ret, cpu;
+
+	cpu = ring_buffer_get_cpu(config);
+	if (cpu < 0) {
+		ret = cpu;
+		goto end;
+	}
+	ring_buffer_ctx_init(&ctx, chan, priv, len, 0, cpu);
+	ret = ring_buffer_reserve(config, &ctx);
+	if (ret)
+		goto put;
+	header.timestamp = ctx.tsc;
+	header.len = len;
+	ring_buffer_write(config, &ctx, &header,
+			  offsetof(struct record_header, header_end));
+	ring_buffer_write(config, &ctx, src, len);
+	ring_buffer_commit(config, &ctx);
+put:
+	ring_buffer_put_cpu(config);
+end:
+	return ret;
+}
+
+/**
+ * ring_buffer_percpu_overwrite_write - writes a record into the ring buffer.
+ * @chan: ring buffer channel
+ * @src: start of input to copy from
+ * @len: length of record
+ *
+ * The record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+int ring_buffer_percpu_overwrite_write(struct channel *chan, const void *src,
+				       size_t len)
+{
+	return ring_buffer_percpu_write(&percpu_overwrite_config, chan, src,
+					len);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_percpu_overwrite_write);
+
+/**
+ * ring_buffer_percpu_discard_write - writes a record into the ring buffer.
+ * @chan: ring buffer channel
+ * @src: start of input to copy from
+ * @len: length of record
+ *
+ * The record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+int ring_buffer_percpu_discard_write(struct channel *chan, const void *src,
+				     size_t len)
+{
+	return ring_buffer_percpu_write(&percpu_discard_config, chan, src,
+					len);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_percpu_discard_write);
+
+MODULE_LICENSE("GPL and additional rights");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Ring Buffer Library Per-CPU Client");
Index: linux.trees.git/lib/ringbuffer/ring_buffer_percpu_local.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/lib/ringbuffer/ring_buffer_percpu_local.c	2010-07-09 18:35:16.000000000 -0400
@@ -0,0 +1,371 @@
+/*
+ * ring_buffer_percpu_local.c
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Per-CPU ring buffer library implementation.
+ * Creates instances of both overwrite and discard modes.
+ * Presents per-cpu-buffer iterators.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/ringbuffer/config.h>
+#include <linux/ringbuffer/percpu_local_overwrite.h>
+#include <linux/ringbuffer/percpu_local_discard.h>
+#include <linux/ringbuffer/vfs.h>
+#include <linux/prio_heap.h>
+
+struct channel_priv {
+	/* Returns 0 on success */
+	int (*on_buffer_create)(struct ring_buffer *buf, int cpu);
+	void (*on_buffer_finalize)(struct ring_buffer *buf, int cpu);
+};
+
+struct subbuffer_header {
+	uint8_t header_end[0];		/* End of header */
+};
+
+struct record_header {
+	uint32_t len;			/* Size of record payload */
+	uint8_t header_end[0];		/* End of header */
+};
+
+static inline
+u64 ring_buffer_clock_read(struct channel *chan)
+{
+	return 0;
+}
+
+static inline
+unsigned char record_header_size(const struct ring_buffer_config *config,
+				 struct channel *chan, size_t offset,
+				 size_t data_size, size_t *pre_header_padding,
+				 unsigned int rflags,
+				 struct ring_buffer_ctx *ctx)
+{
+	return offsetof(struct record_header, header_end);
+}
+
+#include <linux/ringbuffer/api.h>
+
+static
+u64 client_ring_buffer_clock_read(struct channel *chan)
+{
+	return ring_buffer_clock_read(chan);
+}
+
+static
+size_t client_record_header_size(const struct ring_buffer_config *config,
+				 struct channel *chan, size_t offset,
+				 size_t data_size,
+				 size_t *pre_header_padding,
+				 unsigned int rflags,
+				 struct ring_buffer_ctx *ctx)
+{
+	return record_header_size(config, chan, offset, data_size,
+				  pre_header_padding, rflags, ctx);
+}
+
+static
+size_t client_subbuffer_header_size(void)
+{
+	return offsetof(struct subbuffer_header, header_end);
+}
+
+static
+void client_buffer_begin(struct ring_buffer *buf, u64 tsc,
+			 unsigned int subbuf_idx)
+{
+}
+
+static
+void client_buffer_end(struct ring_buffer *buf, u64 tsc,
+		       unsigned int subbuf_idx, unsigned long data_size)
+{
+}
+
+static
+int client_buffer_create(struct ring_buffer *buf, void *priv,
+			 int cpu, const char *name)
+{
+	struct channel_priv *chan_priv = priv;
+	return chan_priv->on_buffer_create(buf, cpu);
+}
+
+static
+void client_buffer_finalize(struct ring_buffer *buf, void *priv, int cpu)
+{
+	struct channel_priv *chan_priv = priv;
+	chan_priv->on_buffer_finalize(buf, cpu);
+}
+
+static
+void client_record_get(const struct ring_buffer_config *config,
+		       struct channel *chan, struct ring_buffer *buf,
+		       size_t offset, size_t *header_len,
+		       size_t *payload_len, u64 *timestamp)
+{
+	int ret;
+	struct record_header header;
+
+	ret = ring_buffer_read(&buf->backend, offset, &header,
+			       offsetof(struct record_header, header_end));
+	CHAN_WARN_ON(chan, ret != offsetof(struct record_header, header_end));
+	*header_len = offsetof(struct record_header, header_end);
+	*payload_len = header.len;
+	/* Timestamp is left unset. We don't use channel iterators. */
+}
+
+/*
+ * Typically 8 subbuffers of variable size per CPU.
+ * Maximum subbuffer size is 4GB. Allocate more subbuffers if more space is
+ * requested.
+ * Periodical buffer switch deferrable timer is set to 100ms. This will wake up
+ * blocking reads when partially filled subbuffers are ready for reading.
+ * Periodical reader wakeup delivery timer is disabled. It is useless because
+ * RING_BUFFER_WAKEUP_BY_WRITER is set.
+ */
+#define SP_SUBBUF_NUM_ORDER	3
+#define SP_SUBBUF_NUM		(1 << SP_SUBBUF_NUM_ORDER)
+#define SP_SWITCH_INTERVAL_MS	100U
+#define SP_SWITCH_INTERVAL_US	(SP_SWITCH_INTERVAL_MS * 1000)
+#define SP_READ_INTERVAL_US	0
+#define SP_U32_MAX		4294967295U	/* 2^32 - 1 */
+
+static const struct ring_buffer_config percpu_local_overwrite_config = {
+	.cb.ring_buffer_clock_read = client_ring_buffer_clock_read,
+	.cb.record_header_size = client_record_header_size,
+	.cb.subbuffer_header_size = client_subbuffer_header_size,
+	.cb.buffer_begin = client_buffer_begin,
+	.cb.buffer_end = client_buffer_end,
+	.cb.buffer_create = client_buffer_create,
+	.cb.buffer_finalize = client_buffer_finalize,
+	.cb.record_get = client_record_get,
+
+	.tsc_bits = 64,
+	.alloc = RING_BUFFER_ALLOC_PER_CPU,
+	.sync = RING_BUFFER_SYNC_PER_CPU,
+	.mode = RING_BUFFER_OVERWRITE,
+	.align = RING_BUFFER_PACKED,
+	.backend = RING_BUFFER_PAGE,
+	.output = RING_BUFFER_ITERATOR,
+	.oops = RING_BUFFER_NO_OOPS_CONSISTENCY,
+	.ipi = RING_BUFFER_IPI_BARRIER,
+	.wakeup = RING_BUFFER_WAKEUP_BY_WRITER,
+};
+
+static const struct ring_buffer_config percpu_local_discard_config = {
+	.cb.ring_buffer_clock_read = client_ring_buffer_clock_read,
+	.cb.record_header_size = client_record_header_size,
+	.cb.subbuffer_header_size = client_subbuffer_header_size,
+	.cb.buffer_begin = client_buffer_begin,
+	.cb.buffer_end = client_buffer_end,
+	.cb.buffer_create = client_buffer_create,
+	.cb.buffer_finalize = client_buffer_finalize,
+	.cb.record_get = client_record_get,
+
+	.tsc_bits = 64,
+	.alloc = RING_BUFFER_ALLOC_PER_CPU,
+	.sync = RING_BUFFER_SYNC_PER_CPU,
+	.mode = RING_BUFFER_DISCARD,
+	.align = RING_BUFFER_PACKED,
+	.backend = RING_BUFFER_PAGE,
+	.output = RING_BUFFER_ITERATOR,
+	.oops = RING_BUFFER_NO_OOPS_CONSISTENCY,
+	.ipi = RING_BUFFER_IPI_BARRIER,
+	.wakeup = RING_BUFFER_WAKEUP_BY_WRITER,
+};
+
+/* Wrapper library API */
+
+static
+struct channel *ring_buffer_spl_create(const struct ring_buffer_config *config,
+		size_t buf_size,
+		int (*on_buffer_create)(struct ring_buffer *buf, int cpu),
+		void (*on_buffer_finalize)(struct ring_buffer *buf, int cpu))
+{
+	struct channel *chan;
+	size_t subbuf_size, subbuf_size_order;
+	unsigned int subbuf_num = SP_SUBBUF_NUM;
+	struct channel_priv *priv;
+
+	/* Typically use 8 subbuffers, minimum of PAGE_SIZE size each */
+	buf_size = max_t(size_t, buf_size, PAGE_SIZE << SP_SUBBUF_NUM_ORDER);
+	subbuf_size = buf_size >> SP_SUBBUF_NUM_ORDER;
+	/*
+	 * Ensure the event payload size fits on u32 event header.
+	 * Maximum subbuffer size is therefore 4GB.
+	 */
+	subbuf_size = min_t(size_t, SP_U32_MAX, subbuf_size);
+
+	/* Allocate more than 8 subbuffers if necessary. */
+	if (subbuf_size < (buf_size >> SP_SUBBUF_NUM_ORDER)) {
+		subbuf_size_order = get_count_order(subbuf_size);
+		subbuf_num = buf_size >> subbuf_size_order;
+	}
+
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return NULL;
+	priv->on_buffer_create = on_buffer_create;
+	priv->on_buffer_finalize = on_buffer_finalize;
+
+	chan = channel_create(config, "spl", priv, NULL,
+			      subbuf_size, subbuf_num,
+			      SP_SWITCH_INTERVAL_US, SP_READ_INTERVAL_US);
+	if (!chan)
+		goto free_priv;
+	return chan;
+
+free_priv:
+	kfree(priv);
+	return NULL;
+}
+
+/**
+ * ring_buffer_percpu_local_overwrite_create - creates a per-cpu overwrite
+*                                              ring buffer.
+ * @buf_size: the buffer size
+ * @on_buffer_create: callback to be called on per-cpu buffer creation
+ * @on_buffer_finalize: callback to be called on per-cpu buffer finalize
+ *
+ * Returns the ring buffer channel address on success, NULL on error.
+ */
+struct channel *ring_buffer_percpu_local_overwrite_create(size_t buf_size,
+		int (*on_buffer_create)(struct ring_buffer *buf, int cpu),
+		void (*on_buffer_finalize)(struct ring_buffer *buf, int cpu))
+
+{
+	return ring_buffer_spl_create(&percpu_local_overwrite_config, buf_size,
+				      on_buffer_create, on_buffer_finalize);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_percpu_local_overwrite_create);
+
+/**
+ * ring_buffer_percpu_local_discard_create - creates a per-cpu discard ring
+ *                                           buffer.
+ * @buf_size: the buffer size
+ * @on_buffer_create: callback to be called on per-cpu buffer creation
+ * @on_buffer_finalize: callback to be called on per-cpu buffer finalize
+ *
+ * Returns the ring buffer channel address on success, NULL on error.
+ */
+
+struct channel *ring_buffer_percpu_local_discard_create(size_t buf_size,
+		int (*on_buffer_create)(struct ring_buffer *buf, int cpu),
+		void (*on_buffer_finalize)(struct ring_buffer *buf, int cpu))
+{
+	return ring_buffer_spl_create(&percpu_local_discard_config, buf_size,
+				      on_buffer_create, on_buffer_finalize);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_percpu_local_discard_create);
+
+static
+void ring_buffer_percpu_local_destroy(struct channel *chan)
+{
+	struct channel_priv *priv;
+
+	priv = channel_destroy(chan);
+	kfree(priv);
+}
+
+/**
+ * ring_buffer_percpu_local_overwrite_destroy - deletes a per-cpu overwrite
+ *                                              ring buffer.
+ * @chan: ring buffer channel
+ */
+void ring_buffer_percpu_local_overwrite_destroy(struct channel *chan)
+{
+	ring_buffer_percpu_local_destroy(chan);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_percpu_local_overwrite_destroy);
+/**
+ * ring_buffer_percpu_local_discard_destroy - deletes a per-cpu discard
+ *                                            ring buffer.
+ * @chan: ring buffer channel
+ */
+void ring_buffer_percpu_local_discard_destroy(struct channel *chan)
+{
+	ring_buffer_percpu_local_destroy(chan);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_percpu_local_discard_destroy);
+
+/**
+ * ring_buffer_percpu_write - writes a record into the ring buffer.
+ * @chan: ring buffer channel
+ * @src: start of input to copy from
+ * @len: length of record
+ *
+ * The record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+static
+int ring_buffer_percpu_write(const struct ring_buffer_config *config,
+			 struct channel *chan, const void *src, size_t len)
+{
+	struct percpu_private *priv = channel_get_private(chan);
+	struct record_header header;
+	struct ring_buffer_ctx ctx;
+	int ret, cpu;
+
+	cpu = ring_buffer_get_cpu(config);
+	if (cpu < 0) {
+		ret = cpu;
+		goto end;
+	}
+	ring_buffer_ctx_init(&ctx, chan, priv, len, 0, cpu);
+	ret = ring_buffer_reserve(config, &ctx);
+	if (ret)
+		goto put;
+	header.len = len;
+	ring_buffer_write(config, &ctx, &header,
+			  offsetof(struct record_header, header_end));
+	ring_buffer_write(config, &ctx, src, len);
+	ring_buffer_commit(config, &ctx);
+put:
+	ring_buffer_put_cpu(config);
+end:
+	return ret;
+}
+
+/**
+ * ring_buffer_percpu_local_overwrite_write - writes a record into the ring
+ *                                            buffer.
+ * @chan: ring buffer channel
+ * @src: start of input to copy from
+ * @len: length of record
+ *
+ * The record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+int ring_buffer_percpu_local_overwrite_write(struct channel *chan,
+					     const void *src, size_t len)
+{
+	return ring_buffer_percpu_write(&percpu_local_overwrite_config, chan,
+					src, len);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_percpu_local_overwrite_write);
+
+/**
+ * ring_buffer_percpu_local_discard_write - writes a record into the ring buffer.
+ * @chan: ring buffer channel
+ * @src: start of input to copy from
+ * @len: length of record
+ *
+ * The record starts at the "src" address and is "len" bytes long. Returns 0 on
+ * success, else it returns a negative error value.
+ */
+int ring_buffer_percpu_local_discard_write(struct channel *chan,
+					   const void *src, size_t len)
+{
+	return ring_buffer_percpu_write(&percpu_local_discard_config, chan, src,
+					len);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_percpu_local_discard_write);
+
+MODULE_LICENSE("GPL and additional rights");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Ring Buffer Library Per-CPU Local Client");

