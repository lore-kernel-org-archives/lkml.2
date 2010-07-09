Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0GIXhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:37:32 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59632 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808Ab0GIXh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:37:28 -0400
Message-Id: <20100709225818.892971740@efficios.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 18:57:43 -0400
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
Subject: [patch 16/20] Ring buffer library - client sample
References: <20100709225727.312232266@efficios.com>
Content-Disposition: inline; filename=ring-buffer-client-sample.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  9 Jul 2010 22:58:19 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Example ring buffer library client.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 samples/Kconfig                                      |    9 
 samples/Makefile                                     |    2 
 samples/ring_buffer_user/Makefile                    |    4 
 samples/ring_buffer_user/ring_buffer_template_user.c |  273 +++++++++++++++++++
 samples/ring_buffer_user/ring_buffer_template_user.h |  100 ++++++
 5 files changed, 387 insertions(+), 1 deletion(-)

Index: linux.trees.git/samples/Makefile
===================================================================
--- linux.trees.git.orig/samples/Makefile	2010-07-09 18:30:15.000000000 -0400
+++ linux.trees.git/samples/Makefile	2010-07-09 18:31:11.000000000 -0400
@@ -1,4 +1,4 @@
 # Makefile for Linux samples code
 
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ tracepoints/ trace_events/ \
-			   hw_breakpoint/
+			   hw_breakpoint/ ring_buffer_user/
Index: linux.trees.git/samples/ring_buffer_user/ring_buffer_template_user.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/samples/ring_buffer_user/ring_buffer_template_user.c	2010-07-09 18:31:52.000000000 -0400
@@ -0,0 +1,273 @@
+/*
+ * ring_buffer_template_user.c
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring buffer template instance code example.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/module.h>
+#include <linux/debugfs.h>
+
+#include "ring_buffer_template_user.h"
+
+struct ring_buffer_priv {
+	struct dentry *dentry;
+};
+
+struct channel_priv {
+	struct ring_buffer_priv *buf;
+};
+
+static struct channel *chan;
+static struct channel_priv channel_priv;
+static const struct ring_buffer_config client_config;
+
+/* Client callbacks */
+
+static u64 client_ring_buffer_clock_read(struct channel *chan)
+{
+	return ring_buffer_clock_read(chan);
+}
+
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
+/**
+ * ring_buffer_sb_header_size - called on buffer-switch to a new sub-buffer
+ *
+ * Return header size without padding after the structure. Don't use packed
+ * structure because gcc generates inefficient code on some architectures
+ * (powerpc, mips..)
+ */
+static size_t client_subbuffer_header_size(void)
+{
+	return offsetof(struct subbuffer_header, header_end);
+}
+
+/**
+ * ring_buffer_write_trace_header - Write trace header
+ * @trace: Trace information
+ * @header: Memory address where the information must be written to
+ */
+static inline
+void write_trace_header(void *priv, struct subbuffer_header *header)
+{
+	header->magic_number = 0x12345678;
+	header->alignment = ring_buffer_get_alignment(&client_config);
+	/* ... */
+}
+
+static void client_buffer_begin(struct ring_buffer *buf, u64 tsc,
+			      unsigned int subbuf_idx)
+{
+	struct channel *chan = buf->backend.chan;
+	struct subbuffer_header *header =
+		(struct subbuffer_header *)
+			ring_buffer_offset_address(&buf->backend,
+				subbuf_idx * chan->backend.subbuf_size);
+
+	header->cycle_count_begin = tsc;
+	header->data_size = 0xFFFFFFFF; /* for debugging */
+	write_trace_header(chan->backend.priv, header);
+}
+
+/*
+ * offset is assumed to never be 0 here : never deliver a completely empty
+ * subbuffer. data_size is between 1 and subbuf_size.
+ */
+static void client_buffer_end(struct ring_buffer *buf, u64 tsc,
+			    unsigned int subbuf_idx, unsigned long data_size)
+{
+	struct channel *chan = buf->backend.chan;
+	struct subbuffer_header *header =
+		(struct subbuffer_header *)
+			ring_buffer_offset_address(&buf->backend,
+				subbuf_idx * chan->backend.subbuf_size);
+	unsigned long records_lost = 0;
+
+	header->data_size = data_size;
+	header->subbuf_size = PAGE_ALIGN(data_size);
+	header->cycle_count_end = tsc;
+	records_lost += ring_buffer_get_records_lost_full(&client_config, buf);
+	records_lost += ring_buffer_get_records_lost_wrap(&client_config, buf);
+	records_lost += ring_buffer_get_records_lost_big(&client_config, buf);
+	header->records_lost = records_lost;
+}
+
+static int client_buffer_create(struct ring_buffer *buf, void *priv,
+				int cpu, const char *name)
+{
+	struct channel_priv *chan_priv = priv;
+	struct ring_buffer_priv *buf_priv;
+	char *tmpname;
+	int ret = 0;
+
+	if (client_config.alloc == RING_BUFFER_ALLOC_PER_CPU)
+		buf_priv = per_cpu_ptr(chan_priv->buf, cpu);
+	else
+		buf_priv = chan_priv->buf;
+
+	tmpname = kzalloc(NAME_MAX + 1, GFP_KERNEL);
+	if (!tmpname) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	snprintf(tmpname, NAME_MAX, "%s%s_%d",
+		 (client_config.mode == RING_BUFFER_OVERWRITE) ? "flight-" : "",
+		 name, cpu);
+
+	buf_priv->dentry = debugfs_create_file(tmpname, S_IRUSR, NULL, buf,
+					       &ring_buffer_file_operations);
+	if (!buf_priv->dentry) {
+		ret = -ENOMEM;
+		goto free_name;
+	}
+free_name:
+	kfree(tmpname);
+end:
+	return ret;
+}
+
+static void client_buffer_finalize(struct ring_buffer *buf, void *priv, int cpu)
+{
+	struct channel_priv *chan_priv = priv;
+	struct ring_buffer_priv *buf_priv;
+
+	if (client_config.alloc == RING_BUFFER_ALLOC_PER_CPU)
+		buf_priv = per_cpu_ptr(chan_priv->buf, cpu);
+	else
+		buf_priv = chan_priv->buf;
+
+	debugfs_remove(buf_priv->dentry);
+}
+
+static const struct ring_buffer_config client_config = {
+	.cb.ring_buffer_clock_read = client_ring_buffer_clock_read,
+	.cb.record_header_size = client_record_header_size,
+	.cb.subbuffer_header_size = client_subbuffer_header_size,
+	.cb.buffer_begin = client_buffer_begin,
+	.cb.buffer_end = client_buffer_end,
+	.cb.buffer_create = client_buffer_create,
+	.cb.buffer_finalize = client_buffer_finalize,
+
+	.tsc_bits = 64,
+	.alloc = RING_BUFFER_ALLOC_PER_CPU,
+	.sync = RING_BUFFER_SYNC_PER_CPU,
+	.mode = RING_BUFFER_OVERWRITE,
+	.align = RING_BUFFER_NATURAL,
+	.backend = RING_BUFFER_PAGE,
+	.output = RING_BUFFER_SPLICE,
+	.oops = RING_BUFFER_OOPS_CONSISTENCY,
+	.ipi = RING_BUFFER_IPI_BARRIER,
+	.wakeup = RING_BUFFER_WAKEUP_BY_TIMER,
+};
+
+static void write_event_header(const struct ring_buffer_config *config,
+			       struct ring_buffer_ctx *ctx)
+{
+	ring_buffer_write(config, ctx, &ctx->tsc, sizeof(ctx->tsc));
+}
+
+static noinline void trace_event(unsigned long data1, short data2)
+{
+	struct ring_buffer_ctx ctx;
+	int ret, cpu;
+
+	cpu = ring_buffer_get_cpu(&client_config);
+	if (cpu < 0)
+		return;
+	ring_buffer_ctx_init(&ctx, chan, &channel_priv,
+			     sizeof(struct payload),
+			     sizeof(unsigned long),
+			     cpu);
+
+	ret = ring_buffer_reserve(&client_config, &ctx);
+	if (ret)
+		goto put;
+
+	write_event_header(&client_config, &ctx);
+
+	ring_buffer_align_ctx(&client_config, &ctx, sizeof(data1));
+	ring_buffer_write(&client_config, &ctx, &data1, sizeof(data1));
+	ring_buffer_align_ctx(&client_config, &ctx, sizeof(data2));
+	ring_buffer_write(&client_config, &ctx, &data2, sizeof(data2));
+
+	ring_buffer_commit(&client_config, &ctx);
+
+put:
+	ring_buffer_put_cpu(&client_config);
+}
+
+static noinline void use_ring_buffer(void)
+{
+	unsigned long i;
+
+	for (i = 0; i < 1000000; i++)
+		trace_event(i, (short)i);
+}
+
+static int __init ring_buffer_client_init(void)
+{
+	int ret;
+
+	printk(KERN_DEBUG "Ring buffer client init begin\n");
+
+	if (client_config.alloc == RING_BUFFER_ALLOC_PER_CPU)
+		channel_priv.buf = alloc_percpu(struct ring_buffer_priv);
+	else
+		channel_priv.buf = kzalloc(sizeof(struct ring_buffer_priv),
+					    GFP_KERNEL);
+	if (!channel_priv.buf)
+		return -ENOMEM;
+
+	chan = channel_create(&client_config, "sample", &channel_priv, NULL,
+			     1048576, 2,
+			     100000, 1000);
+	if (!chan) {
+		ret = -EINVAL;
+		goto error_create;
+	}
+
+	printk(KERN_DEBUG "Ring buffer client init end\n");
+
+	use_ring_buffer();
+
+	return 0;
+
+error_create:
+	if (client_config.alloc == RING_BUFFER_ALLOC_PER_CPU)
+		free_percpu(channel_priv.buf);
+	else
+		kfree(channel_priv.buf);
+	return ret;
+}
+
+static void __exit ring_buffer_client_exit(void)
+{
+	printk(KERN_DEBUG "Ring buffer client exit begin\n");
+	channel_destroy(chan);
+	if (client_config.alloc == RING_BUFFER_ALLOC_PER_CPU)
+		free_percpu(channel_priv.buf);
+	else
+		kfree(channel_priv.buf);
+	printk(KERN_DEBUG "Ring buffer client exit end\n");
+}
+
+module_init(ring_buffer_client_init);
+module_exit(ring_buffer_client_exit);
+
+MODULE_LICENSE("GPL and additional rights");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Ring Buffer Client Template");
Index: linux.trees.git/samples/ring_buffer_user/ring_buffer_template_user.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/samples/ring_buffer_user/ring_buffer_template_user.h	2010-07-09 18:32:01.000000000 -0400
@@ -0,0 +1,100 @@
+#ifndef _RING_BUFFER_TEMPLATE_USER_H
+#define _RING_BUFFER_TEMPLATE_USER_H
+
+/*
+ * ring_buffer_template_user.h
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring buffer template instance code example.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/types.h>
+#include <linux/trace_clock.h>
+
+/* Align data on its natural alignment */
+#define RING_BUFFER_ALIGN
+
+#include <linux/ringbuffer/config.h>
+
+struct subbuffer_header {
+	uint64_t cycle_count_begin;	/* Cycle count at subbuffer start */
+	uint64_t cycle_count_end;	/* Cycle count at subbuffer end */
+	uint32_t magic_number;		/*
+					 * Trace magic number.
+					 * contains endianness information.
+					 */
+	uint8_t major_version;
+	uint8_t minor_version;
+	uint8_t arch_size;		/* Architecture pointer size */
+	uint8_t alignment;		/* ring buffer data alignment */
+	uint64_t start_time_sec;	/* NTP-corrected start time */
+	uint64_t start_time_usec;
+	uint64_t start_freq;		/*
+					 * Frequency at trace start,
+					 * used all along the trace.
+					 */
+	uint32_t freq_scale;		/* Frequency scaling (divisor) */
+	uint32_t data_size;		/* Size of data in subbuffer */
+	uint32_t subbuf_size;		/* Subbuffer size (include padding) */
+	uint32_t records_lost;		/*
+					 * Records lost in this subbuffer since
+					 * the beginning of the trace.
+					 * (may overflow)
+					 */
+	uint8_t header_end[0];		/* End of header */
+};
+
+struct event_header {
+	u64 tsc;
+};
+
+struct payload {
+	unsigned long field1;
+	short field2;
+} RING_BUFFER_ALIGN_ATTR;
+
+/*
+ * Using the trace_clock_global() as an example.
+ */
+static inline notrace u64 ring_buffer_clock_read(struct channel *chan)
+{
+	return trace_clock_global();
+}
+
+/*
+ * record_header_size - Calculate the header size and padding necessary.
+ * @config: ring buffer instance configuration
+ * @chan: channel
+ * @offset: offset in the write buffer
+ * @data_size: size of the payload
+ * @pre_header_padding: padding to add before the header (output)
+ * @rflags: reservation flags
+ * @ctx: reservation context
+ *
+ * Returns the event header size (including padding).
+ */
+static inline notrace
+unsigned char record_header_size(const struct ring_buffer_config *config,
+				 struct channel *chan, size_t offset,
+				 size_t data_size, size_t *pre_header_padding,
+				 unsigned int rflags,
+				 struct ring_buffer_ctx *ctx)
+{
+	size_t orig_offset = offset;
+	size_t padding;
+
+	padding = ring_buffer_align(config, offset,
+				    sizeof(struct event_header));
+	offset += padding;
+	offset += sizeof(struct event_header);
+
+	*pre_header_padding = padding;
+	return offset - orig_offset;
+}
+
+#include <linux/ringbuffer/api.h>
+
+#endif /* _RING_BUFFER_TEMPLATE_USER_H */
Index: linux.trees.git/samples/Kconfig
===================================================================
--- linux.trees.git.orig/samples/Kconfig	2010-07-09 18:30:15.000000000 -0400
+++ linux.trees.git/samples/Kconfig	2010-07-09 18:31:11.000000000 -0400
@@ -44,4 +44,13 @@ config SAMPLE_HW_BREAKPOINT
 	help
 	  This builds kernel hardware breakpoint example modules.
 
+config SAMPLE_LIB_RING_BUFFER_TEMPLATE
+	tristate "Build ring buffer template user -- loadable modules only"
+	default m
+	depends on LIB_RING_BUFFER
+	#depends on !TRACING	#name conflict with old ring buffer API
+	select TRACE_CLOCK_STANDALONE
+	help
+	  This builds the ring buffer template user.
+
 endif # SAMPLES
Index: linux.trees.git/samples/ring_buffer_user/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/samples/ring_buffer_user/Makefile	2010-07-09 18:31:11.000000000 -0400
@@ -0,0 +1,4 @@
+# builds the ring buffer template user example kernel modules;
+# then to use one (as root):  insmod <module_name.ko>
+
+obj-$(CONFIG_SAMPLE_LIB_RING_BUFFER_TEMPLATE) += ring_buffer_template_user.o

