Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0HQXYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 19:24:11 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48076 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab0HQXXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 19:23:25 -0400
Message-Id: <20100817232153.421305064@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 17 Aug 2010 19:16:32 -0400
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
Subject: [RFC PATCH 13/20] Ring buffer frontend
References: <20100817231619.277457797@efficios.com>
Content-Disposition: inline; filename=ring_buffer_frontend.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 17 Aug 2010 23:21:53 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wait-free ring buffer reader/writer synchronization. Inherits of a parent
backend that holds the memory buffers and accessors. The backend can be replaced
so that the same frontend (synchronization) code can be used with various
backends by compiling the frontend code with various backends.

The frontend inherits from the backend because it needs to call the backend for
the flight-recorder "sub-buffer exchange" routine and to clear/set the subbuffer
noref flag.

However, the backend (the parent) does not have to know anything specific about
the frontend. It's the user (client) which calls the frontend to synchronize and
the backend to manipulate buffer data.

This frontend/backend separation permits to use the same ring buffer
synchronization code to write data to kernel pages, to video memory, to serial
ports, etc etc, without having to deal with different synchronization schemes.

The frontend also deals with cpu hotplug, cpu idle and periodical "flush"
deferrable timers.

Changelog since v1:
- Support ring buffer snapshot. The snapshot grabs the producer and consumer
  position, which then lets the reader read the data more than once, in any
  order. This allows readers to read flight recorder sub-buffers from the
  latest to the oldest (in reverse order).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/ringbuffer/api.h               |   25 
 include/linux/ringbuffer/config.h            |  309 +++++
 include/linux/ringbuffer/frontend.h          |  223 +++
 include/linux/ringbuffer/frontend_api.h      |  352 +++++
 include/linux/ringbuffer/frontend_internal.h |  424 +++++++
 include/linux/ringbuffer/frontend_types.h    |  162 ++
 include/linux/ringbuffer/vatomic.h           |   85 +
 lib/Kconfig                                  |   12 
 lib/Makefile                                 |    2 
 lib/ringbuffer/Makefile                      |    1 
 lib/ringbuffer/ring_buffer_frontend.c        | 1625 +++++++++++++++++++++++++++
 11 files changed, 3220 insertions(+)

Index: linux.trees.git/lib/ringbuffer/ring_buffer_frontend.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/lib/ringbuffer/ring_buffer_frontend.c	2010-08-17 19:11:58.000000000 -0400
@@ -0,0 +1,1625 @@
+/*
+ * ring_buffer_frontend.c
+ *
+ * (C) Copyright 2005-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring buffer wait-free buffer synchronization. Producer-consumer and flight
+ * recorder (overwrite) modes. See thesis:
+ *
+ * Desnoyers, Mathieu (2009), "Low-Impact Operating System Tracing", Ph.D.
+ * dissertation, Ecole Polytechnique de Montreal.
+ * http://www.lttng.org/pub/thesis/desnoyers-dissertation-2009-12.pdf
+ *
+ * - Algorithm presentation in Chapter 5:
+ *     "Lockless Multi-Core High-Throughput Buffering".
+ * - Algorithm formal verification in Section 8.6:
+ *     "Formal verification of LTTng"
+ *
+ * Author:
+ *	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Inspired from LTT and RelayFS:
+ *  Karim Yaghmour <karim@opersys.com>
+ *  Tom Zanussi <zanussi@us.ibm.com>
+ *  Bob Wisniewski <bob@watson.ibm.com>
+ * And from K42 :
+ *  Bob Wisniewski <bob@watson.ibm.com>
+ *
+ * Buffer reader semantic :
+ *
+ * - get_subbuf_size
+ * while buffer is not finalized and empty
+ *   - get_subbuf
+ *     - if return value != 0, continue
+ *   - splice one subbuffer worth of data to a pipe
+ *   - splice the data from pipe to disk/network
+ *   - put_subbuf
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/idle.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+
+#include <linux/ringbuffer/config.h>
+#include <linux/ringbuffer/backend.h>
+#include <linux/ringbuffer/frontend.h>
+#include <linux/ringbuffer/iterator.h>
+
+/*
+ * Internal structure representing offsets to use at a sub-buffer switch.
+ */
+struct switch_offsets {
+	unsigned long begin, end, old;
+	size_t pre_header_padding, size;
+	unsigned int switch_new_start:1, switch_new_end:1, switch_old_start:1,
+		     switch_old_end:1;
+};
+
+DEFINE_PER_CPU(unsigned int, ring_buffer_nesting);
+EXPORT_PER_CPU_SYMBOL(ring_buffer_nesting);
+
+static
+void ring_buffer_print_errors(struct channel *chan,
+			      struct ring_buffer *buf,
+			      int cpu);
+
+static const struct file_operations ring_buffer_file_operations;
+
+/*
+ * Must be called under cpu hotplug protection.
+ */
+void ring_buffer_free(struct ring_buffer *buf)
+{
+	struct channel *chan = buf->backend.chan;
+
+	ring_buffer_print_errors(chan, buf, buf->backend.cpu);
+	kfree(buf->commit_hot);
+	kfree(buf->commit_cold);
+
+	ring_buffer_backend_free(&buf->backend);
+}
+
+/**
+ * ring_buffer_reset - Reset ring buffer to initial values.
+ * @buf: Ring buffer.
+ *
+ * Effectively empty the ring buffer. Should be called when the buffer is not
+ * used for writing. The ring buffer can be opened for reading, but the reader
+ * should not be using the iterator concurrently with reset. The previous
+ * current iterator record is reset.
+ */
+void ring_buffer_reset(struct ring_buffer *buf)
+{
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned int i;
+
+	/*
+	 * Reset iterator first. It will put the subbuffer if it currently holds
+	 * it.
+	 */
+	ring_buffer_iterator_reset(buf);
+	v_set(config, &buf->offset, 0);
+	for (i = 0; i < chan->backend.num_subbuf; i++) {
+		v_set(config, &buf->commit_hot[i].cc, 0);
+		v_set(config, &buf->commit_hot[i].seq, 0);
+		v_set(config, &buf->commit_cold[i].cc_sb, 0);
+	}
+	atomic_long_set(&buf->consumed, 0);
+	atomic_set(&buf->record_disabled, 0);
+	v_set(config, &buf->last_tsc, 0);
+	ring_buffer_backend_reset(&buf->backend);
+	/* Don't reset number of active readers */
+	v_set(config, &buf->records_lost_full, 0);
+	v_set(config, &buf->records_lost_wrap, 0);
+	v_set(config, &buf->records_lost_big, 0);
+	v_set(config, &buf->records_count, 0);
+	v_set(config, &buf->records_overrun, 0);
+	buf->finalized = 0;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_reset);
+
+/**
+ * channel_reset - Reset channel to initial values.
+ * @chan: Channel.
+ *
+ * Effectively empty the channel. Should be called when the channel is not used
+ * for writing. The channel can be opened for reading, but the reader should not
+ * be using the iterator concurrently with reset. The previous current iterator
+ * record is reset.
+ */
+void channel_reset(struct channel *chan)
+{
+	/*
+	 * Reset iterators first. Will put the subbuffer if held for reading.
+	 */
+	channel_iterator_reset(chan);
+	atomic_set(&chan->record_disabled, 0);
+	/* Don't reset commit_count_mask, still valid */
+	channel_backend_reset(&chan->backend);
+	/* Don't reset switch/read timer interval */
+	/* Don't reset notifiers and notifier enable bits */
+	/* Don't reset reader reference count */
+}
+EXPORT_SYMBOL_GPL(channel_reset);
+
+/*
+ * Must be called under cpu hotplug protection.
+ */
+int ring_buffer_create(struct ring_buffer *buf,
+		       struct channel_backend *chanb,
+		       int cpu)
+{
+	const struct ring_buffer_config *config = chanb->config;
+	struct channel *chan = container_of(chanb, struct channel, backend);
+	void *priv = chanb->priv;
+	unsigned int j, num_subbuf;
+	size_t subbuf_header_size;
+	u64 tsc;
+	int ret;
+
+	/* Test for cpu hotplug */
+	if (buf->backend.allocated)
+		return 0;
+
+	ret = ring_buffer_backend_create(&buf->backend, &chan->backend, cpu);
+	if (ret)
+		return ret;
+
+	buf->commit_hot =
+		kzalloc_node(ALIGN(sizeof(*buf->commit_hot)
+				   * chan->backend.num_subbuf,
+				   1 << INTERNODE_CACHE_SHIFT),
+			GFP_KERNEL, cpu_to_node(max(cpu, 0)));
+	if (!buf->commit_hot) {
+		ret = -ENOMEM;
+		goto free_chanbuf;
+	}
+
+	buf->commit_cold =
+		kzalloc_node(ALIGN(sizeof(*buf->commit_cold)
+				   * chan->backend.num_subbuf,
+				   1 << INTERNODE_CACHE_SHIFT),
+			GFP_KERNEL, cpu_to_node(max(cpu, 0)));
+	if (!buf->commit_cold) {
+		ret = -ENOMEM;
+		goto free_commit;
+	}
+
+	atomic_long_set(&buf->consumed, 0);
+	atomic_long_set(&buf->active_readers, 0);
+	num_subbuf = chan->backend.num_subbuf;
+	for (j = 0; j < num_subbuf; j++) {
+		v_set(config, &buf->commit_hot[j].cc, 0);
+		v_set(config, &buf->commit_hot[j].seq, 0);
+		v_set(config, &buf->commit_cold[j].cc_sb, 0);
+	}
+	init_waitqueue_head(&buf->read_wait);
+	raw_spin_lock_init(&buf->raw_idle_spinlock);
+
+	v_set(config, &buf->records_lost_full, 0);
+	v_set(config, &buf->records_lost_wrap, 0);
+	v_set(config, &buf->records_lost_big, 0);
+	v_set(config, &buf->records_count, 0);
+	v_set(config, &buf->records_overrun, 0);
+	buf->finalized = 0;
+
+	/*
+	 * Write the subbuffer header for first subbuffer so we know the total
+	 * duration of data gathering.
+	 */
+	subbuf_header_size = config->cb.subbuffer_header_size();
+	v_set(config, &buf->offset, subbuf_header_size);
+	subbuffer_id_clear_noref(config, &buf->backend.buf_wsb[0].id);
+	tsc = config->cb.ring_buffer_clock_read(buf->backend.chan);
+	config->cb.buffer_begin(buf, tsc, 0);
+	v_add(config, subbuf_header_size, &buf->commit_hot[0].cc);
+
+	if (config->cb.buffer_create) {
+		ret = config->cb.buffer_create(buf, priv, cpu, chanb->name);
+		if (ret)
+			goto free_init;
+	}
+
+	/*
+	 * Ensure the buffer is ready before setting it to allocated and setting
+	 * the cpumask.
+	 * Used for cpu hotplug vs cpumask iteration.
+	 */
+	smp_wmb();
+	buf->backend.allocated = 1;
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU) {
+		CHAN_WARN_ON(chan, cpumask_test_cpu(cpu,
+			     chan->backend.cpumask));
+		cpumask_set_cpu(cpu, chan->backend.cpumask);
+	}
+
+	return 0;
+
+	/* Error handling */
+free_init:
+	kfree(buf->commit_cold);
+free_commit:
+	kfree(buf->commit_hot);
+free_chanbuf:
+	ring_buffer_backend_free(&buf->backend);
+	return ret;
+}
+
+static void switch_buffer_timer(unsigned long data)
+{
+	struct ring_buffer *buf = (struct ring_buffer *)data;
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+
+	/*
+	 * Only flush buffers periodically if readers are active.
+	 */
+	if (atomic_long_read(&buf->active_readers))
+		ring_buffer_switch_slow(buf, SWITCH_ACTIVE);
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU)
+		mod_timer_pinned(&buf->switch_timer,
+				 jiffies + chan->switch_timer_interval);
+	else
+		mod_timer(&buf->switch_timer,
+			  jiffies + chan->switch_timer_interval);
+}
+
+static void ring_buffer_start_switch_timer(struct ring_buffer *buf)
+{
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+
+	if (!chan->switch_timer_interval)
+		return;
+
+	init_timer_deferrable(&buf->switch_timer);
+	buf->switch_timer.function = switch_buffer_timer;
+	buf->switch_timer.expires = jiffies + chan->switch_timer_interval;
+	buf->switch_timer.data = (unsigned long)buf;
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU)
+		add_timer_on(&buf->switch_timer, buf->backend.cpu);
+	else
+		add_timer(&buf->switch_timer);
+}
+
+static void ring_buffer_stop_switch_timer(struct ring_buffer *buf)
+{
+	struct channel *chan = buf->backend.chan;
+
+	if (!chan->switch_timer_interval)
+		return;
+
+	del_timer_sync(&buf->switch_timer);
+}
+
+/*
+ * Polling timer to check the channels for data.
+ */
+static void read_buffer_timer(unsigned long data)
+{
+	struct ring_buffer *buf = (struct ring_buffer *)data;
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+
+	CHAN_WARN_ON(chan, !buf->backend.allocated);
+
+	if (atomic_long_read(&buf->active_readers)
+	    && ring_buffer_poll_deliver(config, buf, chan)) {
+		wake_up_interruptible(&buf->read_wait);
+		wake_up_interruptible(&chan->read_wait);
+	}
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU)
+		mod_timer_pinned(&buf->read_timer,
+				 jiffies + chan->read_timer_interval);
+	else
+		mod_timer(&buf->read_timer,
+			  jiffies + chan->read_timer_interval);
+}
+
+static void ring_buffer_start_read_timer(struct ring_buffer *buf)
+{
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+
+	if (config->wakeup != RING_BUFFER_WAKEUP_BY_TIMER
+	    || !chan->read_timer_interval)
+		return;
+
+	init_timer_deferrable(&buf->read_timer);
+	buf->read_timer.function = read_buffer_timer;
+	buf->read_timer.expires = jiffies + chan->read_timer_interval;
+	buf->read_timer.data = (unsigned long)buf;
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU)
+		add_timer_on(&buf->read_timer, buf->backend.cpu);
+	else
+		add_timer(&buf->read_timer);
+}
+
+static void ring_buffer_stop_read_timer(struct ring_buffer *buf)
+{
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+
+	if (config->wakeup != RING_BUFFER_WAKEUP_BY_TIMER
+	    || !chan->read_timer_interval)
+		return;
+
+	del_timer_sync(&buf->read_timer);
+	/*
+	 * do one more check to catch data that has been written in the last
+	 * timer period.
+	 */
+	if (ring_buffer_poll_deliver(config, buf, chan)) {
+		wake_up_interruptible(&buf->read_wait);
+		wake_up_interruptible(&chan->read_wait);
+	}
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
+	struct channel *chan = container_of(nb, struct channel,
+					    cpu_hp_notifier);
+	struct ring_buffer *buf = per_cpu_ptr(chan->backend.buf, cpu);
+	const struct ring_buffer_config *config = chan->backend.config;
+
+	if (!chan->cpu_hp_enable)
+		return NOTIFY_DONE;
+
+	CHAN_WARN_ON(chan, config->alloc == RING_BUFFER_ALLOC_GLOBAL);
+
+	switch (action) {
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		ring_buffer_start_switch_timer(buf);
+		ring_buffer_start_read_timer(buf);
+		return NOTIFY_OK;
+
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		ring_buffer_stop_switch_timer(buf);
+		ring_buffer_stop_read_timer(buf);
+		return NOTIFY_OK;
+
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		/*
+		 * Performing a buffer switch on a remote CPU. Performed by
+		 * the CPU responsible for doing the hotunplug after the target
+		 * CPU stopped running completely. Ensures that all data
+		 * from that remote CPU is flushed.
+		 */
+		ring_buffer_switch_slow(buf, SWITCH_ACTIVE);
+		return NOTIFY_OK;
+
+	default:
+		return NOTIFY_DONE;
+	}
+}
+#endif
+
+
+/*
+ * For per-cpu buffers, call the reader wakeups before switching the buffer, so
+ * that wake-up-tracing generated events are flushed before going idle. We test
+ * if the spinlock is locked to deal with the race where readers try to sample
+ * the ring buffer before we perform the switch. We let the readers retry in
+ * that case. If there is data in the buffer, the wake up is going to forbid the
+ * CPU running the reader thread from going idle.
+ *
+ * For a global buffer, if the client requested a reader timer, then chances are
+ * we are going to keep the system from going idle anyway, so just bite the
+ * bullet and do the wake up. We have no way to know if we are the last CPU
+ * going to idle, so just switch the buffer. Use a spinlock to ensure we send
+ * the wakeup before performing the buffer switch, in case wakeup is
+ * instrumented and writes data in the buffer.
+ */
+static int ring_buffer_idle_callback(struct notifier_block *nb,
+				  unsigned long val,
+				  void *data)
+{
+	struct channel *chan = container_of(nb, struct channel,
+					    idle_notifier);
+	const struct ring_buffer_config *config = chan->backend.config;
+	struct ring_buffer *buf;
+
+	if (val != IDLE_START)
+		return 0;
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU)
+		buf = channel_get_ring_buffer(config, chan, smp_processor_id());
+	else
+		buf = channel_get_ring_buffer(config, chan, 0);
+
+	raw_spin_lock(&buf->raw_idle_spinlock);
+	if (config->wakeup == RING_BUFFER_WAKEUP_BY_TIMER
+	    && chan->read_timer_interval
+	    && atomic_long_read(&buf->active_readers)
+	    && (ring_buffer_poll_deliver(config, buf, chan)
+		|| ring_buffer_pending_data(config, buf, chan))) {
+		wake_up_interruptible(&buf->read_wait);
+		wake_up_interruptible(&chan->read_wait);
+	}
+	if (chan->switch_timer_interval)
+		ring_buffer_switch_slow(buf, SWITCH_ACTIVE);
+	raw_spin_unlock(&buf->raw_idle_spinlock);
+
+	return 0;
+}
+
+/*
+ * Holds CPU hotplug.
+ */
+static void channel_unregister_notifiers(struct channel *chan)
+{
+	const struct ring_buffer_config *config = chan->backend.config;
+	int cpu;
+
+	channel_iterator_unregister_notifiers(chan);
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU) {
+#ifdef CONFIG_HOTPLUG_CPU
+		get_online_cpus();
+		chan->cpu_hp_enable = 0;
+		for_each_online_cpu(cpu) {
+			struct ring_buffer *buf = per_cpu_ptr(chan->backend.buf,
+							      cpu);
+			ring_buffer_stop_switch_timer(buf);
+			ring_buffer_stop_read_timer(buf);
+		}
+		put_online_cpus();
+		unregister_cpu_notifier(&chan->cpu_hp_notifier);
+#else
+		for_each_possible_cpu(cpu) {
+			struct ring_buffer *buf = per_cpu_ptr(chan->backend.buf,
+							      cpu);
+			ring_buffer_stop_switch_timer(buf);
+			ring_buffer_stop_read_timer(buf);
+		}
+#endif
+	} else {
+		struct ring_buffer *buf = chan->backend.buf;
+
+		ring_buffer_stop_switch_timer(buf);
+		ring_buffer_stop_read_timer(buf);
+	}
+	unregister_idle_notifier(&chan->idle_notifier);
+	channel_backend_unregister_notifiers(&chan->backend);
+}
+
+static void channel_free(struct channel *chan)
+{
+	channel_iterator_free(chan);
+	channel_backend_free(&chan->backend);
+	kfree(chan);
+}
+
+/**
+ * channel_create - Create channel.
+ * @config: ring buffer instance configuration
+ * @name: name of the channel
+ * @priv: ring buffer client private data
+ * @buf_addr: pointer the the beginning of the preallocated buffer contiguous
+ *            address mapping. It is used only by RING_BUFFER_STATIC
+ *            configuration. It can be set to NULL for other backends.
+ * @subbuf_size: subbuffer size
+ * @num_subbuf: number of subbuffers
+ * @switch_timer_interval: Time interval (in us) to fill sub-buffers with
+ *                         padding to let readers get those sub-buffers.
+ *                         Used for live streaming.
+ * @read_timer_interval: Time interval (in us) to wake up pending readers.
+ *
+ * Holds cpu hotplug.
+ * Returns NULL on failure.
+ */
+struct channel *channel_create(const struct ring_buffer_config *config,
+		   const char *name, void *priv, void *buf_addr,
+		   size_t subbuf_size,
+		   size_t num_subbuf, unsigned int switch_timer_interval,
+		   unsigned int read_timer_interval)
+{
+	int ret, cpu;
+	struct channel *chan;
+
+	if (ring_buffer_check_config(config,
+				     switch_timer_interval,
+				     read_timer_interval))
+		return NULL;
+
+	chan = kzalloc(sizeof(struct channel), GFP_KERNEL);
+	if (!chan)
+		return NULL;
+
+	ret = channel_backend_init(&chan->backend, name, config, priv,
+				   subbuf_size, num_subbuf);
+	if (ret)
+		goto error;
+
+	ret = channel_iterator_init(chan);
+	if (ret)
+		goto error_free_backend;
+
+	chan->commit_count_mask = (~0UL >> chan->backend.num_subbuf_order);
+	chan->switch_timer_interval = usecs_to_jiffies(switch_timer_interval);
+	chan->read_timer_interval = usecs_to_jiffies(read_timer_interval);
+	init_waitqueue_head(&chan->read_wait);
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU) {
+		/*
+		 * In case of non-hotplug cpu, if the ring-buffer is allocated
+		 * in early initcall, it will not be notified of secondary cpus.
+		 * In that off case, we need to allocate for all possible cpus.
+		 */
+#ifdef CONFIG_HOTPLUG_CPU
+		chan->cpu_hp_notifier.notifier_call =
+				ring_buffer_cpu_hp_callback;
+		chan->cpu_hp_notifier.priority = 6;
+		register_cpu_notifier(&chan->cpu_hp_notifier);
+
+		get_online_cpus();
+		for_each_online_cpu(cpu) {
+			struct ring_buffer *buf = per_cpu_ptr(chan->backend.buf,
+							       cpu);
+			ring_buffer_start_switch_timer(buf);
+			ring_buffer_start_read_timer(buf);
+		}
+		chan->cpu_hp_enable = 1;
+		put_online_cpus();
+#else
+		for_each_possible_cpu(cpu) {
+			struct ring_buffer *buf = per_cpu_ptr(chan->backend.buf,
+							      cpu);
+			ring_buffer_start_switch_timer(buf);
+			ring_buffer_start_read_timer(buf);
+		}
+#endif
+	} else {
+		struct ring_buffer *buf = chan->backend.buf;
+
+		ring_buffer_start_switch_timer(buf);
+		ring_buffer_start_read_timer(buf);
+	}
+
+	chan->idle_notifier.notifier_call = ring_buffer_idle_callback;
+	/*
+	 * smallest prio, run after any tracing activity, right before sleeping.
+	 */
+	chan->idle_notifier.priority = ~0U;
+	register_idle_notifier(&chan->idle_notifier);
+
+	return chan;
+
+error_free_backend:
+	channel_backend_free(&chan->backend);
+error:
+	kfree(chan);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(channel_create);
+
+/**
+ * channel_destroy - Finalize, wait for q.s. and destroy channel.
+ * @chan: channel to destroy
+ *
+ * Holds cpu hotplug.
+ * Call "destroy" callback, finalize channels, wait for readers to release their
+ * reference, then destroy ring buffer data. Note that when readers have
+ * completed data consumption of finalized channels, get_subbuf() will return
+ * -ENODATA. They should release their handle at that point.
+ * Returns the private data pointer.
+ */
+void *channel_destroy(struct channel *chan)
+{
+	int cpu;
+	const struct ring_buffer_config *config = chan->backend.config;
+	void *priv;
+
+	channel_unregister_notifiers(chan);
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU) {
+		/*
+		 * No need to hold cpu hotplug, because all notifiers have been
+		 * unregistered.
+		 */
+		for_each_channel_cpu(cpu, chan) {
+			struct ring_buffer *buf = per_cpu_ptr(chan->backend.buf,
+							      cpu);
+
+			if (config->cb.buffer_finalize)
+				config->cb.buffer_finalize(buf,
+							   chan->backend.priv,
+							   cpu);
+			if (buf->backend.allocated)
+				ring_buffer_switch_slow(buf, SWITCH_FLUSH);
+			/*
+			 * Perform flush before writing to finalized.
+			 */
+			smp_wmb();
+			ACCESS_ONCE(buf->finalized) = 1;
+			wake_up_interruptible(&buf->read_wait);
+		}
+	} else {
+		struct ring_buffer *buf = chan->backend.buf;
+
+		if (config->cb.buffer_finalize)
+			config->cb.buffer_finalize(buf, chan->backend.priv, -1);
+		if (buf->backend.allocated)
+			ring_buffer_switch_slow(buf, SWITCH_FLUSH);
+		/*
+		 * Perform flush before writing to finalized.
+		 */
+		smp_wmb();
+		ACCESS_ONCE(buf->finalized) = 1;
+		wake_up_interruptible(&buf->read_wait);
+	}
+	wake_up_interruptible(&chan->read_wait);
+
+	while (atomic_long_read(&chan->read_ref) > 0)
+		msleep(100);
+	/* Finish waiting for refcount before free */
+	smp_mb();
+	priv = chan->backend.priv;
+	channel_free(chan);
+	return priv;
+}
+EXPORT_SYMBOL_GPL(channel_destroy);
+
+struct ring_buffer *channel_get_ring_buffer(
+					const struct ring_buffer_config *config,
+					struct channel *chan, int cpu)
+{
+	if (config->alloc == RING_BUFFER_ALLOC_GLOBAL)
+		return chan->backend.buf;
+	else
+		return per_cpu_ptr(chan->backend.buf, cpu);
+}
+EXPORT_SYMBOL_GPL(channel_get_ring_buffer);
+
+int ring_buffer_open_read(struct ring_buffer *buf)
+{
+	struct channel *chan = buf->backend.chan;
+
+	if (!atomic_long_add_unless(&buf->active_readers, 1, 1))
+		return -EBUSY;
+	atomic_long_inc(&chan->read_ref);
+	smp_mb__after_atomic_inc();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_open_read);
+
+void ring_buffer_release_read(struct ring_buffer *buf)
+{
+	struct channel *chan = buf->backend.chan;
+
+	CHAN_WARN_ON(chan, atomic_long_read(&buf->active_readers) != 1);
+	smp_mb__before_atomic_dec();
+	atomic_long_dec(&chan->read_ref);
+	atomic_long_dec(&buf->active_readers);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_release_read);
+
+/*
+ * Promote compiler barrier to a smp_mb().
+ * For the specific ring buffer case, this IPI call should be removed if the
+ * architecture does not reorder writes.  This should eventually be provided by
+ * a separate architecture-specific infrastructure.
+ */
+static void remote_mb(void *info)
+{
+	smp_mb();
+}
+
+/**
+ * ring_buffer_snapshot - save subbuffer position snapshot (for read)
+ * @buf: ring buffer
+ * @consumed: consumed count indicating the position where to read
+ * @produced: produced count, indicates position when to stop reading
+ *
+ * Returns -ENODATA if buffer is finalized, -EAGAIN if there is currently no
+ * data to read at consumed position, or 0 if the get operation succeeds.
+ * Busy-loop trying to get data if the idle sequence lock is held.
+ */
+
+int ring_buffer_snapshot(struct ring_buffer *buf, unsigned long *consumed,
+			 unsigned long *produced)
+{
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned long consumed_cur, write_offset;
+	int finalized;
+
+retry:
+	finalized = ACCESS_ONCE(buf->finalized);
+	/*
+	 * Read finalized before counters.
+	 */
+	smp_rmb();
+	consumed_cur = atomic_long_read(&buf->consumed);
+	/*
+	 * No need to issue a memory barrier between consumed count read and
+	 * write offset read, because consumed count can only change
+	 * concurrently in overwrite mode, and we keep a sequence counter
+	 * identifier derived from the write offset to check we are getting
+	 * the same sub-buffer we are expecting (the sub-buffers are atomically
+	 * "tagged" upon writes, tags are checked upon read).
+	 */
+	write_offset = v_read(config, &buf->offset);
+
+	/*
+	 * Check that we are not about to read the same subbuffer in
+	 * which the writer head is.
+	 */
+	if ((subbuf_trunc(write_offset, chan)
+	   - subbuf_trunc(consumed_cur, chan))
+	   == 0)
+		goto nodata;
+
+	*consumed = consumed_cur;
+	*produced = subbuf_trunc(write_offset, chan);
+
+	return 0;
+
+nodata:
+	/*
+	 * The memory barriers __wait_event()/wake_up_interruptible() take care
+	 * of "raw_spin_is_locked" memory ordering.
+	 */
+	if (finalized)
+		return -ENODATA;
+	else if (raw_spin_is_locked(&buf->raw_idle_spinlock))
+		goto retry;
+	else
+		return -EAGAIN;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_snapshot);
+
+/**
+ * ring_buffer_put_snapshot - move consumed counter forward
+ * @buf: ring buffer
+ * @consumed_new: new consumed count value
+ */
+void ring_buffer_move_consumer(struct ring_buffer *buf,
+			       unsigned long consumed_new)
+{
+	struct ring_buffer_backend *bufb = &buf->backend;
+	struct channel *chan = bufb->chan;
+	unsigned long consumed;
+
+	CHAN_WARN_ON(chan, atomic_long_read(&buf->active_readers) != 1);
+
+	/*
+	 * Only push the consumed value forward.
+	 * If the consumed cmpxchg fails, this is because we have been pushed by
+	 * the writer in flight recorder mode.
+	 */
+	consumed = atomic_long_read(&buf->consumed);
+	while ((long) consumed - (long) consumed_new < 0)
+		consumed = atomic_long_cmpxchg(&buf->consumed, consumed,
+					       consumed_new);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_move_consumer);
+
+/**
+ * ring_buffer_get_subbuf - get exclusive access to subbuffer for reading
+ * @buf: ring buffer
+ * @consumed: consumed count indicating the position where to read
+ *
+ * Returns -ENODATA if buffer is finalized, -EAGAIN if there is currently no
+ * data to read at consumed position, or 0 if the get operation succeeds.
+ * Busy-loop trying to get data if the idle sequence lock is held.
+ */
+int ring_buffer_get_subbuf(struct ring_buffer *buf, unsigned long consumed)
+{
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned long consumed_cur, consumed_idx, commit_count, write_offset;
+	int ret;
+	int finalized;
+
+retry:
+	finalized = ACCESS_ONCE(buf->finalized);
+	/*
+	 * Read finalized before counters.
+	 */
+	smp_rmb();
+	consumed_cur = atomic_long_read(&buf->consumed);
+	consumed_idx = subbuf_index(consumed, chan);
+	commit_count = v_read(config, &buf->commit_cold[consumed_idx].cc_sb);
+	/*
+	 * Make sure we read the commit count before reading the buffer
+	 * data and the write offset. Correct consumed offset ordering
+	 * wrt commit count is insured by the use of cmpxchg to update
+	 * the consumed offset.
+	 * smp_call_function_single can fail if the remote CPU is offline,
+	 * this is OK because then there is no wmb to execute there.
+	 * If our thread is executing on the same CPU as the on the buffers
+	 * belongs to, we don't have to synchronize it at all. If we are
+	 * migrated, the scheduler will take care of the memory barriers.
+	 * Normally, smp_call_function_single() should ensure program order when
+	 * executing the remote function, which implies that it surrounds the
+	 * function execution with :
+	 * smp_mb()
+	 * send IPI
+	 * csd_lock_wait
+	 *                recv IPI
+	 *                smp_mb()
+	 *                exec. function
+	 *                smp_mb()
+	 *                csd unlock
+	 * smp_mb()
+	 *
+	 * However, smp_call_function_single() does not seem to clearly execute
+	 * such barriers. It depends on spinlock semantic to provide the barrier
+	 * before executing the IPI and, when busy-looping, csd_lock_wait only
+	 * executes smp_mb() when it has to wait for the other CPU.
+	 *
+	 * I don't trust this code. Therefore, let's add the smp_mb() sequence
+	 * required ourself, even if duplicated. It has no performance impact
+	 * anyway.
+	 *
+	 * smp_mb() is needed because smp_rmb() and smp_wmb() only order read vs
+	 * read and write vs write. They do not ensure core synchronization. We
+	 * really have to ensure total order between the 3 barriers running on
+	 * the 2 CPUs.
+	 */
+	if (config->ipi == RING_BUFFER_IPI_BARRIER) {
+		if (config->sync == RING_BUFFER_SYNC_PER_CPU
+		    && config->alloc == RING_BUFFER_ALLOC_PER_CPU) {
+			if (raw_smp_processor_id() != buf->backend.cpu) {
+				/* Total order with IPI handler smp_mb() */
+				smp_mb();
+				smp_call_function_single(buf->backend.cpu,
+							 remote_mb, NULL, 1);
+				/* Total order with IPI handler smp_mb() */
+				smp_mb();
+			}
+		} else {
+			/* Total order with IPI handler smp_mb() */
+			smp_mb();
+			smp_call_function(remote_mb, NULL, 1);
+			/* Total order with IPI handler smp_mb() */
+			smp_mb();
+		}
+	} else {
+		/*
+		 * Local rmb to match the remote wmb to read the commit count
+		 * before the buffer data and the write offset.
+		 */
+		smp_rmb();
+	}
+
+	write_offset = v_read(config, &buf->offset);
+
+	/*
+	 * Check that the buffer we are getting is after or at consumed_cur
+	 * position.
+	 */
+	if ((long) subbuf_trunc(consumed, chan)
+	    - (long) subbuf_trunc(consumed_cur, chan) < 0)
+		goto nodata;
+
+	/*
+	 * Check that the subbuffer we are trying to consume has been
+	 * already fully committed.
+	 */
+	if (((commit_count - chan->backend.subbuf_size)
+	     & chan->commit_count_mask)
+	    - (buf_trunc(consumed_cur, chan)
+	       >> chan->backend.num_subbuf_order)
+	    != 0)
+		goto nodata;
+
+	/*
+	 * Check that we are not about to read the same subbuffer in
+	 * which the writer head is.
+	 */
+	if ((subbuf_trunc(write_offset, chan)
+	   - subbuf_trunc(consumed_cur, chan))
+	   == 0)
+		goto nodata;
+
+	/*
+	 * Failure to get the subbuffer causes a busy-loop retry without going
+	 * to a wait queue. These are caused by short-lived race windows where
+	 * the writer is getting access to a subbuffer we were trying to get
+	 * access to. Also checks that the "consumed" buffer count we are
+	 * looking for matches the one contained in the subbuffer id.
+	 */
+	ret = update_read_sb_index(config, &buf->backend, &chan->backend,
+				   consumed_idx, buf_trunc_val(consumed, chan));
+	if (ret)
+		goto retry;
+	subbuffer_id_clear_noref(config, &buf->backend.buf_rsb.id);
+
+	buf->get_subbuf_consumed = consumed;
+	buf->get_subbuf = 1;
+
+	return 0;
+
+nodata:
+	/*
+	 * The memory barriers __wait_event()/wake_up_interruptible() take care
+	 * of "raw_spin_is_locked" memory ordering.
+	 */
+	if (finalized)
+		return -ENODATA;
+	else if (raw_spin_is_locked(&buf->raw_idle_spinlock))
+		goto retry;
+	else
+		return -EAGAIN;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_get_subbuf);
+
+/**
+ * ring_buffer_put_subbuf - release exclusive subbuffer access
+ * @buf: ring buffer
+ */
+void ring_buffer_put_subbuf(struct ring_buffer *buf)
+{
+	struct ring_buffer_backend *bufb = &buf->backend;
+	struct channel *chan = bufb->chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned long read_sb_bindex, consumed_idx, consumed;
+
+	CHAN_WARN_ON(chan, atomic_long_read(&buf->active_readers) != 1);
+
+	if (!buf->get_subbuf) {
+		/*
+		 * Reader puts a subbuffer it did not get.
+		 */
+		CHAN_WARN_ON(chan, 1);
+		return;
+	}
+	consumed = buf->get_subbuf_consumed;
+	buf->get_subbuf = 0;
+
+	/*
+	 * Clear the records_unread counter. (overruns counter)
+	 * Can still be non-zero if a file reader simply grabbed the data
+	 * without using iterators.
+	 * Can be below zero if an iterator is used on a snapshot more than
+	 * once.
+	 */
+	read_sb_bindex = subbuffer_id_get_index(config, bufb->buf_rsb.id);
+	v_add(config, v_read(config,
+			     &bufb->array[read_sb_bindex]->records_unread),
+	      &bufb->records_read);
+	v_set(config, &bufb->array[read_sb_bindex]->records_unread, 0);
+	CHAN_WARN_ON(chan, config->mode == RING_BUFFER_OVERWRITE
+		     && subbuffer_id_is_noref(config, bufb->buf_rsb.id));
+	subbuffer_id_set_noref(config, &bufb->buf_rsb.id);
+
+	/*
+	 * Exchange the reader subbuffer with the one we put in its place in the
+	 * writer subbuffer table. Expect the original consumed count. If
+	 * update_read_sb_index fails, this is because the writer updated the
+	 * subbuffer concurrently. We should therefore keep the subbuffer we
+	 * currently have: it has become invalid to try reading this sub-buffer
+	 * consumed count value anyway.
+	 */
+	consumed_idx = subbuf_index(consumed, chan);
+	update_read_sb_index(config, &buf->backend, &chan->backend,
+			     consumed_idx, buf_trunc_val(consumed, chan));
+	/*
+	 * update_read_sb_index return value ignored. Don't exchange sub-buffer
+	 * if the writer concurrently updated it.
+	 */
+}
+EXPORT_SYMBOL_GPL(ring_buffer_put_subbuf);
+
+/*
+ * cons_offset is an iterator on all subbuffer offsets between the reader
+ * position and the writer position. (inclusive)
+ */
+static
+void ring_buffer_print_subbuffer_errors(struct ring_buffer *buf,
+					struct channel *chan,
+					unsigned long cons_offset,
+					int cpu)
+{
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned long cons_idx, commit_count, commit_count_sb;
+
+	cons_idx = subbuf_index(cons_offset, chan);
+	commit_count = v_read(config, &buf->commit_hot[cons_idx].cc);
+	commit_count_sb = v_read(config, &buf->commit_cold[cons_idx].cc_sb);
+
+	if (subbuf_offset(commit_count, chan) != 0)
+		printk(KERN_WARNING
+		       "ring buffer %s, cpu %d: "
+		       "commit count in subbuffer %lu,\n"
+		       "expecting multiples of %lu bytes\n"
+		       "  [ %lu bytes committed, %lu bytes reader-visible ]\n",
+		       chan->backend.name, cpu, cons_idx,
+		       chan->backend.subbuf_size,
+		       commit_count, commit_count_sb);
+
+	printk(KERN_DEBUG "ring buffer: %s, cpu %d: %lu bytes committed\n",
+	       chan->backend.name, cpu, commit_count);
+}
+
+static
+void ring_buffer_print_buffer_errors(struct ring_buffer *buf,
+				     struct channel *chan,
+				     void *priv, int cpu)
+{
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned long write_offset, cons_offset;
+
+	/*
+	 * Can be called in the error path of allocation when
+	 * trans_channel_data is not yet set.
+	 */
+	if (!chan)
+		return;
+	/*
+	 * No need to order commit_count, write_offset and cons_offset reads
+	 * because we execute at teardown when no more writer nor reader
+	 * references are left.
+	 */
+	write_offset = v_read(config, &buf->offset);
+	cons_offset = atomic_long_read(&buf->consumed);
+	if (write_offset != cons_offset)
+		printk(KERN_WARNING
+		       "ring buffer %s, cpu %d: "
+		       "non-consumed data\n"
+		       "  [ %lu bytes written, %lu bytes read ]\n",
+		       chan->backend.name, cpu, write_offset, cons_offset);
+
+	for (cons_offset = atomic_long_read(&buf->consumed);
+	     (long) (subbuf_trunc((unsigned long) v_read(config, &buf->offset),
+				  chan)
+		     - cons_offset) > 0;
+	     cons_offset = subbuf_align(cons_offset, chan))
+		ring_buffer_print_subbuffer_errors(buf, chan, cons_offset,
+						   cpu);
+}
+
+static
+void ring_buffer_print_errors(struct channel *chan,
+			      struct ring_buffer *buf,
+			      int cpu)
+{
+	const struct ring_buffer_config *config = chan->backend.config;
+	void *priv = chan->backend.priv;
+
+	printk(KERN_DEBUG "ring buffer %s, cpu %d: %lu records written, "
+			  "%lu records overrun\n",
+			  chan->backend.name, cpu,
+			  v_read(config, &buf->records_count),
+			  v_read(config, &buf->records_overrun));
+
+	if (v_read(config, &buf->records_lost_full)
+	    || v_read(config, &buf->records_lost_wrap)
+	    || v_read(config, &buf->records_lost_big))
+		printk(KERN_WARNING
+		       "ring buffer %s, cpu %d: records were lost. Caused by:\n"
+		       "  [ %lu buffer full, %lu nest buffer wrap-around, "
+		       "%lu event too big ]\n",
+		       chan->backend.name, cpu,
+		       v_read(config, &buf->records_lost_full),
+		       v_read(config, &buf->records_lost_wrap),
+		       v_read(config, &buf->records_lost_big));
+
+	ring_buffer_print_buffer_errors(buf, chan, priv, cpu);
+}
+
+/*
+ * ring_buffer_switch_old_start: Populate old subbuffer header.
+ *
+ * Only executed when the buffer is finalized, in SWITCH_FLUSH.
+ */
+static
+void ring_buffer_switch_old_start(struct ring_buffer *buf,
+				  struct channel *chan,
+				  struct switch_offsets *offsets,
+				  u64 tsc)
+{
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned long oldidx = subbuf_index(offsets->old, chan);
+	unsigned long commit_count;
+
+	config->cb.buffer_begin(buf, tsc, oldidx);
+
+	/*
+	 * Order all writes to buffer before the commit count update that will
+	 * determine that the subbuffer is full.
+	 */
+	if (config->ipi == RING_BUFFER_IPI_BARRIER) {
+		/*
+		 * Must write slot data before incrementing commit count.  This
+		 * compiler barrier is upgraded into a smp_mb() by the IPI sent
+		 * by get_subbuf().
+		 */
+		barrier();
+	} else
+		smp_wmb();
+	v_add(config, config->cb.subbuffer_header_size(),
+	      &buf->commit_hot[oldidx].cc);
+	commit_count = v_read(config, &buf->commit_hot[oldidx].cc);
+	/* Check if the written buffer has to be delivered */
+	ring_buffer_check_deliver(config, buf, chan, offsets->old, commit_count,
+				  oldidx);
+	ring_buffer_write_commit_counter(config, buf, chan, oldidx,
+					 offsets->old, commit_count,
+					 config->cb.subbuffer_header_size());
+}
+
+/*
+ * ring_buffer_switch_old_end: switch old subbuffer
+ *
+ * Note : offset_old should never be 0 here. It is ok, because we never perform
+ * buffer switch on an empty subbuffer in SWITCH_ACTIVE mode. The caller
+ * increments the offset_old value when doing a SWITCH_FLUSH on an empty
+ * subbuffer.
+ */
+static
+void ring_buffer_switch_old_end(struct ring_buffer *buf,
+					   struct channel *chan,
+					   struct switch_offsets *offsets,
+					   u64 tsc)
+{
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned long oldidx = subbuf_index(offsets->old - 1, chan);
+	unsigned long commit_count, padding_size, data_size;
+
+	data_size = subbuf_offset(offsets->old - 1, chan) + 1;
+	padding_size = chan->backend.subbuf_size - data_size;
+	subbuffer_set_data_size(config, &buf->backend, oldidx, data_size);
+
+	/*
+	 * Order all writes to buffer before the commit count update that will
+	 * determine that the subbuffer is full.
+	 */
+	if (config->ipi == RING_BUFFER_IPI_BARRIER) {
+		/*
+		 * Must write slot data before incrementing commit count.  This
+		 * compiler barrier is upgraded into a smp_mb() by the IPI sent
+		 * by get_subbuf().
+		 */
+		barrier();
+	} else
+		smp_wmb();
+	v_add(config, padding_size, &buf->commit_hot[oldidx].cc);
+	commit_count = v_read(config, &buf->commit_hot[oldidx].cc);
+	ring_buffer_check_deliver(config, buf, chan, offsets->old - 1,
+				  commit_count, oldidx);
+	ring_buffer_write_commit_counter(config, buf, chan, oldidx,
+					 offsets->old, commit_count,
+					 padding_size);
+}
+
+/*
+ * ring_buffer_switch_new_start: Populate new subbuffer.
+ *
+ * This code can be executed unordered : writers may already have written to the
+ * sub-buffer before this code gets executed, caution.  The commit makes sure
+ * that this code is executed before the deliver of this sub-buffer.
+ */
+static
+void ring_buffer_switch_new_start(struct ring_buffer *buf,
+					   struct channel *chan,
+					   struct switch_offsets *offsets,
+					   u64 tsc)
+{
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned long beginidx = subbuf_index(offsets->begin, chan);
+	unsigned long commit_count;
+
+	config->cb.buffer_begin(buf, tsc, beginidx);
+
+	/*
+	 * Order all writes to buffer before the commit count update that will
+	 * determine that the subbuffer is full.
+	 */
+	if (config->ipi == RING_BUFFER_IPI_BARRIER) {
+		/*
+		 * Must write slot data before incrementing commit count.  This
+		 * compiler barrier is upgraded into a smp_mb() by the IPI sent
+		 * by get_subbuf().
+		 */
+		barrier();
+	} else
+		smp_wmb();
+	v_add(config, config->cb.subbuffer_header_size(),
+	      &buf->commit_hot[beginidx].cc);
+	commit_count = v_read(config, &buf->commit_hot[beginidx].cc);
+	/* Check if the written buffer has to be delivered */
+	ring_buffer_check_deliver(config, buf, chan, offsets->begin,
+				  commit_count, beginidx);
+	ring_buffer_write_commit_counter(config, buf, chan, beginidx,
+					 offsets->begin, commit_count,
+					 config->cb.subbuffer_header_size());
+}
+
+/*
+ * ring_buffer_switch_new_end: finish switching current subbuffer
+ *
+ * The only remaining threads could be the ones with pending commits. They will
+ * have to do the deliver themselves.
+ */
+static
+void ring_buffer_switch_new_end(struct ring_buffer *buf,
+					    struct channel *chan,
+					    struct switch_offsets *offsets,
+					    u64 tsc)
+{
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned long endidx = subbuf_index(offsets->end - 1, chan);
+	unsigned long commit_count, padding_size, data_size;
+
+	data_size = subbuf_offset(offsets->end - 1, chan) + 1;
+	padding_size = chan->backend.subbuf_size - data_size;
+	subbuffer_set_data_size(config, &buf->backend, endidx, data_size);
+
+	/*
+	 * Order all writes to buffer before the commit count update that will
+	 * determine that the subbuffer is full.
+	 */
+	if (config->ipi == RING_BUFFER_IPI_BARRIER) {
+		/*
+		 * Must write slot data before incrementing commit count.  This
+		 * compiler barrier is upgraded into a smp_mb() by the IPI sent
+		 * by get_subbuf().
+		 */
+		barrier();
+	} else
+		smp_wmb();
+	v_add(config, padding_size, &buf->commit_hot[endidx].cc);
+	commit_count = v_read(config, &buf->commit_hot[endidx].cc);
+	ring_buffer_check_deliver(config, buf, chan, offsets->end - 1,
+				  commit_count, endidx);
+	ring_buffer_write_commit_counter(config, buf, chan, endidx,
+					 offsets->end, commit_count,
+					 padding_size);
+}
+
+/*
+ * Returns :
+ * 0 if ok
+ * !0 if execution must be aborted.
+ */
+static
+int ring_buffer_try_switch_slow(enum switch_mode mode,
+				struct ring_buffer *buf,
+				struct channel *chan,
+				struct switch_offsets *offsets,
+				u64 *tsc)
+{
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned long off;
+
+	offsets->begin = v_read(config, &buf->offset);
+	offsets->old = offsets->begin;
+	offsets->switch_old_start = 0;
+	off = subbuf_offset(offsets->begin, chan);
+
+	*tsc = config->cb.ring_buffer_clock_read(chan);
+
+	/*
+	 * Ensure we flush the header of an empty subbuffer when doing the
+	 * finalize (SWITCH_FLUSH). This ensures that we end up knowing the
+	 * total data gathering duration even if there were no records saved
+	 * after the last buffer switch.
+	 * In SWITCH_ACTIVE mode, switch the buffer when it contains events.
+	 * SWITCH_ACTIVE only flushes the current subbuffer, dealing with end of
+	 * subbuffer header as appropriate.
+	 * The next record that reserves space will be responsible for
+	 * populating the following subbuffer header. We choose not to populate
+	 * the next subbuffer header here because we want to be able to use
+	 * SWITCH_ACTIVE for periodical buffer flush and CPU idle entry buffer
+	 * flush, which must guarantee that all the buffer content (records and
+	 * header timestamps) are visible to the reader. This is required for
+	 * quiescence guarantees for the fusion merge.
+	 */
+	if (mode == SWITCH_FLUSH || off > 0) {
+		if (unlikely(off == 0)) {
+			/*
+			 * The client does not save any header information.
+			 * Don't switch empty subbuffer on finalize, because it
+			 * is invalid to deliver a completely empty subbuffer.
+			 */
+			if (!config->cb.subbuffer_header_size())
+				return -1;
+			/*
+			 * Need to write the subbuffer start header on finalize.
+			 */
+			offsets->switch_old_start = 1;
+		}
+		offsets->begin = subbuf_align(offsets->begin, chan);
+	} else
+		return -1;	/* we do not have to switch : buffer is empty */
+	/* Note: old points to the next subbuf at offset 0 */
+	offsets->end = offsets->begin;
+	return 0;
+}
+
+/*
+ * Force a sub-buffer switch. This operation is completely reentrant : can be
+ * called while tracing is active with absolutely no lock held.
+ *
+ * Note, however, that as a v_cmpxchg is used for some atomic
+ * operations, this function must be called from the CPU which owns the buffer
+ * for a ACTIVE flush.
+ */
+void ring_buffer_switch_slow(struct ring_buffer *buf, enum switch_mode mode)
+{
+	struct channel *chan = buf->backend.chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+	struct switch_offsets offsets;
+	unsigned long oldidx;
+	u64 tsc;
+
+	offsets.size = 0;
+
+	/*
+	 * Perform retryable operations.
+	 */
+	do {
+		if (ring_buffer_try_switch_slow(mode, buf, chan, &offsets,
+						&tsc))
+			return;	/* Switch not needed */
+	} while (v_cmpxchg(config, &buf->offset, offsets.old, offsets.end)
+		 != offsets.old);
+
+	/*
+	 * Atomically update last_tsc. This update races against concurrent
+	 * atomic updates, but the race will always cause supplementary full TSC
+	 * records, never the opposite (missing a full TSC record when it would
+	 * be needed).
+	 */
+	save_last_tsc(config, buf, tsc);
+
+	/*
+	 * Push the reader if necessary
+	 */
+	ring_buffer_reserve_push_reader(buf, chan, offsets.old);
+
+	oldidx = subbuf_index(offsets.old, chan);
+	ring_buffer_clear_noref(config, &buf->backend, oldidx);
+
+	/*
+	 * May need to populate header start on SWITCH_FLUSH.
+	 */
+	if (offsets.switch_old_start) {
+		ring_buffer_switch_old_start(buf, chan, &offsets, tsc);
+		offsets.old += config->cb.subbuffer_header_size();
+	}
+
+	/*
+	 * Switch old subbuffer.
+	 */
+	ring_buffer_switch_old_end(buf, chan, &offsets, tsc);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_switch_slow);
+
+/*
+ * Returns :
+ * 0 if ok
+ * !0 if execution must be aborted.
+ */
+static
+int ring_buffer_try_reserve_slow(struct ring_buffer *buf, struct channel *chan,
+				 struct switch_offsets *offsets,
+				 struct ring_buffer_ctx *ctx)
+{
+	const struct ring_buffer_config *config = chan->backend.config;
+	unsigned long reserve_commit_diff;
+
+	offsets->begin = v_read(config, &buf->offset);
+	offsets->old = offsets->begin;
+	offsets->switch_new_start = 0;
+	offsets->switch_new_end = 0;
+	offsets->switch_old_end = 0;
+	offsets->pre_header_padding = 0;
+
+	ctx->tsc = config->cb.ring_buffer_clock_read(chan);
+
+	if (last_tsc_overflow(config, buf, ctx->tsc))
+		ctx->rflags = RING_BUFFER_RFLAG_FULL_TSC;
+
+	if (unlikely(subbuf_offset(offsets->begin, ctx->chan) == 0)) {
+		offsets->switch_new_start = 1;		/* For offsets->begin */
+	} else {
+		offsets->size = config->cb.record_header_size(config, chan,
+						offsets->begin,
+						ctx->data_size,
+						&offsets->pre_header_padding,
+						ctx->rflags, ctx);
+		offsets->size +=
+			ring_buffer_align(config,
+					  offsets->begin + offsets->size,
+					  ctx->largest_align)
+			+ ctx->data_size;
+		if (unlikely((subbuf_offset(offsets->begin, chan) +
+			     offsets->size) > chan->backend.subbuf_size)) {
+			offsets->switch_old_end = 1;	/* For offsets->old */
+			offsets->switch_new_start = 1;	/* For offsets->begin */
+		}
+	}
+	if (unlikely(offsets->switch_new_start)) {
+		unsigned long sb_index;
+
+		/*
+		 * We are typically not filling the previous buffer completely.
+		 */
+		if (likely(offsets->switch_old_end))
+			offsets->begin = subbuf_align(offsets->begin, chan);
+		offsets->begin = offsets->begin
+				 + config->cb.subbuffer_header_size();
+		/* Test new buffer integrity */
+		sb_index = subbuf_index(offsets->begin, chan);
+		reserve_commit_diff =
+		  (buf_trunc(offsets->begin, chan)
+		   >> chan->backend.num_subbuf_order)
+		  - ((unsigned long) v_read(config,
+					    &buf->commit_cold[sb_index].cc_sb)
+		     & chan->commit_count_mask);
+		if (likely(reserve_commit_diff == 0)) {
+			/* Next subbuffer not being written to. */
+			if (unlikely(config->mode != RING_BUFFER_OVERWRITE &&
+				(subbuf_trunc(offsets->begin, chan)
+				 - subbuf_trunc((unsigned long)
+				     atomic_long_read(&buf->consumed), chan))
+				>= chan->backend.buf_size)) {
+				/*
+				 * We do not overwrite non consumed buffers
+				 * and we are full : record is lost.
+				 */
+				v_inc(config, &buf->records_lost_full);
+				return -1;
+			} else {
+				/*
+				 * Next subbuffer not being written to, and we
+				 * are either in overwrite mode or the buffer is
+				 * not full. It's safe to write in this new
+				 * subbuffer.
+				 */
+			}
+		} else {
+			/*
+			 * Next subbuffer reserve offset does not match the
+			 * commit offset. Drop record in producer-consumer and
+			 * overwrite mode. Caused by either a writer OOPS or too
+			 * many nested writes over a reserve/commit pair.
+			 */
+			v_inc(config, &buf->records_lost_wrap);
+			return -1;
+		}
+		offsets->size =
+			config->cb.record_header_size(config, chan,
+						offsets->begin,
+						ctx->data_size,
+						&offsets->pre_header_padding,
+						ctx->rflags, ctx);
+		offsets->size +=
+			ring_buffer_align(config,
+					  offsets->begin + offsets->size,
+					  ctx->largest_align)
+			+ ctx->data_size;
+		if (unlikely((subbuf_offset(offsets->begin, chan)
+			     + offsets->size) > chan->backend.subbuf_size)) {
+			/*
+			 * Record too big for subbuffers, report error, don't
+			 * complete the sub-buffer switch.
+			 */
+			v_inc(config, &buf->records_lost_big);
+			return -1;
+		} else {
+			/*
+			 * We just made a successful buffer switch and the
+			 * record fits in the new subbuffer. Let's write.
+			 */
+		}
+	} else {
+		/*
+		 * Record fits in the current buffer and we are not on a switch
+		 * boundary. It's safe to write.
+		 */
+	}
+	offsets->end = offsets->begin + offsets->size;
+
+	if (unlikely((subbuf_offset(offsets->end, chan)) == 0)) {
+		/*
+		 * The offset_end will fall at the very beginning of the next
+		 * subbuffer.
+		 */
+		offsets->switch_new_end = 1;	/* For offsets->begin */
+	}
+	return 0;
+}
+
+/**
+ * ring_buffer_reserve_slow - Atomic slot reservation in a buffer.
+ * @ctx: ring buffer context.
+ *
+ * Return : -ENOSPC if not enough space, else returns 0.
+ * It will take care of sub-buffer switching.
+ */
+int ring_buffer_reserve_slow(struct ring_buffer_ctx *ctx)
+{
+	struct channel *chan = ctx->chan;
+	const struct ring_buffer_config *config = chan->backend.config;
+	struct ring_buffer *buf;
+	struct switch_offsets offsets;
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU)
+		buf = per_cpu_ptr(chan->backend.buf, ctx->cpu);
+	else
+		buf = chan->backend.buf;
+	ctx->buf = buf;
+
+	offsets.size = 0;
+
+	do {
+		if (unlikely(ring_buffer_try_reserve_slow(buf, chan, &offsets,
+							  ctx)))
+			return -ENOSPC;
+	} while (unlikely(v_cmpxchg(config, &buf->offset, offsets.old,
+				    offsets.end)
+			  != offsets.old));
+
+	/*
+	 * Atomically update last_tsc. This update races against concurrent
+	 * atomic updates, but the race will always cause supplementary full TSC
+	 * records, never the opposite (missing a full TSC record when it would
+	 * be needed).
+	 */
+	save_last_tsc(config, buf, ctx->tsc);
+
+	/*
+	 * Push the reader if necessary
+	 */
+	ring_buffer_reserve_push_reader(buf, chan, offsets.end - 1);
+
+	/*
+	 * Clear noref flag for this subbuffer.
+	 */
+	ring_buffer_clear_noref(config, &buf->backend,
+				subbuf_index(offsets.end - 1, chan));
+
+	/*
+	 * Switch old subbuffer if needed.
+	 */
+	if (unlikely(offsets.switch_old_end)) {
+		ring_buffer_clear_noref(config, &buf->backend,
+					subbuf_index(offsets.old - 1, chan));
+		ring_buffer_switch_old_end(buf, chan, &offsets, ctx->tsc);
+	}
+
+	/*
+	 * Populate new subbuffer.
+	 */
+	if (unlikely(offsets.switch_new_start))
+		ring_buffer_switch_new_start(buf, chan, &offsets, ctx->tsc);
+
+	if (unlikely(offsets.switch_new_end))
+		ring_buffer_switch_new_end(buf, chan, &offsets, ctx->tsc);
+
+	ctx->slot_size = offsets.size;
+	ctx->pre_offset = offsets.begin;
+	ctx->buf_offset = offsets.begin + offsets.pre_header_padding;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_reserve_slow);
Index: linux.trees.git/lib/ringbuffer/Makefile
===================================================================
--- linux.trees.git.orig/lib/ringbuffer/Makefile	2010-08-17 19:11:22.000000000 -0400
+++ linux.trees.git/lib/ringbuffer/Makefile	2010-08-17 19:11:28.000000000 -0400
@@ -1 +1,2 @@
 obj-y += ring_buffer_backend.o
+obj-y += ring_buffer_frontend.o
Index: linux.trees.git/lib/Kconfig
===================================================================
--- linux.trees.git.orig/lib/Kconfig	2010-08-17 19:10:01.000000000 -0400
+++ linux.trees.git/lib/Kconfig	2010-08-17 19:11:28.000000000 -0400
@@ -86,6 +86,18 @@ config LIBCRC32C
 	  require M here.  See Castagnoli93.
 	  Module will be libcrc32c.
 
+config LIB_RING_BUFFER
+	bool "Ring Buffer"
+	help
+	  This option provides a generic ring buffer.
+
+config LIB_RING_BUFFER_CLIENTS
+	tristate "Ring Buffer Clients"
+	help
+	  This option provides three generic ring buffer clients: global
+	  buffers, per-cpu buffers with global iterators, and per-cpu buffers
+	  with local per-cpu iterators.
+
 config AUDIT_GENERIC
 	bool
 	depends on AUDIT && !AUDIT_ARCH
Index: linux.trees.git/lib/Makefile
===================================================================
--- linux.trees.git.orig/lib/Makefile	2010-08-17 19:10:01.000000000 -0400
+++ linux.trees.git/lib/Makefile	2010-08-17 19:11:28.000000000 -0400
@@ -106,6 +106,8 @@ obj-$(CONFIG_GENERIC_ATOMIC64) += atomic
 
 obj-$(CONFIG_ATOMIC64_SELFTEST) += atomic64_test.o
 
+obj-$(CONFIG_LIB_RING_BUFFER) += ringbuffer/
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
Index: linux.trees.git/include/linux/ringbuffer/api.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/api.h	2010-08-17 19:11:28.000000000 -0400
@@ -0,0 +1,25 @@
+#ifndef _LINUX_RING_BUFFER_API_H
+#define _LINUX_RING_BUFFER_API_H
+
+/*
+ * linux/ringbuffer/api.h
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring Buffer API.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/ringbuffer/backend.h>
+#include <linux/ringbuffer/frontend.h>
+#include <linux/ringbuffer/vfs.h>
+
+/*
+ * ring_buffer_frontend_api.h contains static inline functions that depend on
+ * client static inlines. Hence the inclusion of this "api" header only
+ * within the client.
+ */
+#include <linux/ringbuffer/frontend_api.h>
+
+#endif /* _LINUX_RING_BUFFER_API_H */
Index: linux.trees.git/include/linux/ringbuffer/config.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/config.h	2010-08-17 19:11:28.000000000 -0400
@@ -0,0 +1,309 @@
+#ifndef _LINUX_RING_BUFFER_CONFIG_H
+#define _LINUX_RING_BUFFER_CONFIG_H
+
+/*
+ * linux/ringbuffer/config.h
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring buffer configuration header. Note: after declaring the standard inline
+ * functions, clients should also include linux/ringbuffer/api.h.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/types.h>
+#include <linux/percpu.h>
+
+struct ring_buffer;
+struct channel;
+struct ring_buffer_config;
+struct ring_buffer_ctx;
+
+/*
+ * Ring buffer client callbacks. Only used by slow path, never on fast path.
+ * For the fast path, record_header_size(), ring_buffer_clock_read() should be
+ * provided as inline functions too.  These may simply return 0 if not used by
+ * the client.
+ */
+struct ring_buffer_client_cb {
+	/* Mandatory callbacks */
+
+	/* A static inline version is also required for fast path */
+	u64 (*ring_buffer_clock_read) (struct channel *chan);
+	size_t (*record_header_size) (const struct ring_buffer_config *config,
+				      struct channel *chan, size_t offset,
+				      size_t data_size,
+				      size_t *pre_header_padding,
+				      unsigned int rflags,
+				      struct ring_buffer_ctx *ctx);
+
+	/* Slow path only, at subbuffer switch */
+	size_t (*subbuffer_header_size) (void);
+	void (*buffer_begin) (struct ring_buffer *buf, u64 tsc,
+			      unsigned int subbuf_idx);
+	void (*buffer_end) (struct ring_buffer *buf, u64 tsc,
+			    unsigned int subbuf_idx, unsigned long data_size);
+
+	/* Optional callbacks (can be set to NULL) */
+
+	/* Called at buffer creation/finalize */
+	int (*buffer_create) (struct ring_buffer *buf, void *priv,
+			      int cpu, const char *name);
+	/*
+	 * Clients should guarantee that no new reader handle can be opened
+	 * after finalize.
+	 */
+	void (*buffer_finalize) (struct ring_buffer *buf, void *priv, int cpu);
+
+	/*
+	 * Extract header length, payload length and timestamp from event
+	 * record. Used by buffer iterators. Timestamp is only used by channel
+	 * iterator.
+	 */
+	void (*record_get) (const struct ring_buffer_config *config,
+			    struct channel *chan, struct ring_buffer *buf,
+			    size_t offset, size_t *header_len,
+			    size_t *payload_len, u64 *timestamp);
+};
+
+/*
+ * Ring buffer instance configuration.
+ *
+ * Declare as "static const" within the client object to ensure the inline fast
+ * paths can be optimized.
+ *
+ * alloc/sync pairs:
+ *
+ * RING_BUFFER_ALLOC_PER_CPU and RING_BUFFER_SYNC_PER_CPU :
+ *   Per-cpu buffers with per-cpu synchronization. Tracing must be performed
+ *   with preemption disabled (ring_buffer_get_cpu() and ring_buffer_put_cpu()).
+ *
+ * RING_BUFFER_ALLOC_PER_CPU and RING_BUFFER_SYNC_GLOBAL :
+ *   Per-cpu buffer with global synchronization. Tracing can be performed with
+ *   preemption enabled, statistically stays on the local buffers.
+ *
+ * RING_BUFFER_ALLOC_GLOBAL and RING_BUFFER_SYNC_PER_CPU :
+ *   Should only be used for buffers belonging to a single thread or protected
+ *   by mutual exclusion by the client. Note that periodical sub-buffer switch
+ *   should be disabled in this kind of configuration.
+ *
+ * RING_BUFFER_ALLOC_GLOBAL and RING_BUFFER_SYNC_GLOBAL :
+ *   Global shared buffer with global synchronization.
+ *
+ * wakeup:
+ *
+ * RING_BUFFER_WAKEUP_BY_TIMER uses per-cpu deferrable timers to poll the
+ * buffers and wake up readers if data is ready. Mainly useful for tracers which
+ * don't want to call into the wakeup code on the tracing path. Use in
+ * combination with "read_timer_interval" channel_create() argument.
+ *
+ * RING_BUFFER_WAKEUP_BY_WRITER directly wakes up readers when a subbuffer is
+ * ready to read. Lower latencies before the reader is woken up. Mainly suitable
+ * for drivers.
+ *
+ * RING_BUFFER_WAKEUP_NONE does not perform any wakeup whatsoever. The client
+ * has the responsibility to perform wakeups.
+ */
+struct ring_buffer_config {
+	enum {
+		RING_BUFFER_ALLOC_PER_CPU,
+		RING_BUFFER_ALLOC_GLOBAL,
+	} alloc;
+	enum {
+		RING_BUFFER_SYNC_PER_CPU,	/* Wait-free */
+		RING_BUFFER_SYNC_GLOBAL,	/* Lock-free */
+	} sync;
+	enum {
+		RING_BUFFER_OVERWRITE,		/* Overwrite when buffer full */
+		RING_BUFFER_DISCARD,		/* Discard when buffer full */
+	} mode;
+	enum {
+		RING_BUFFER_NATURAL,
+		RING_BUFFER_PACKED,
+	} align;
+	enum {
+		RING_BUFFER_SPLICE,
+		RING_BUFFER_MMAP,
+		RING_BUFFER_READ,		/* TODO */
+		RING_BUFFER_ITERATOR,
+		RING_BUFFER_NONE,
+	} output;
+	enum {
+		RING_BUFFER_PAGE,
+		RING_BUFFER_VMAP,		/* TODO */
+		RING_BUFFER_STATIC,		/* TODO */
+	} backend;
+	enum {
+		RING_BUFFER_NO_OOPS_CONSISTENCY,
+		RING_BUFFER_OOPS_CONSISTENCY,
+	} oops;
+	enum {
+		RING_BUFFER_IPI_BARRIER,
+		RING_BUFFER_NO_IPI_BARRIER,
+	} ipi;
+	enum {
+		RING_BUFFER_WAKEUP_BY_TIMER,	/* wake up performed by timer */
+		RING_BUFFER_WAKEUP_BY_WRITER,	/*
+						 * writer wakes up reader,
+						 * not lock-free
+						 * (takes spinlock).
+						 */
+	} wakeup;
+	/*
+	 * tsc_bits: timestamp bits saved at each record.
+	 *   0 and 64 disable the timestamp compression scheme.
+	 */
+	unsigned int tsc_bits;
+	struct ring_buffer_client_cb cb;
+};
+
+/*
+ * ring buffer context
+ *
+ * Context passed to ring_buffer_reserve(), ring_buffer_commit(),
+ * ring_buffer_try_discard_reserve(), ring_buffer_align_ctx() and
+ * ring_buffer_write().
+ */
+struct ring_buffer_ctx {
+	/* input received by ring_buffer_reserve(), saved here. */
+	struct channel *chan;		/* channel */
+	void *priv;			/* client private data */
+	size_t data_size;		/* size of payload */
+	int largest_align;		/*
+					 * alignment of the largest element
+					 * in the payload
+					 */
+	int cpu;			/* processor id */
+
+	/* output from ring_buffer_reserve() */
+	struct ring_buffer *buf;	/*
+					 * buffer corresponding to processor id
+					 * for this channel
+					 */
+	size_t slot_size;		/* size of the reserved slot */
+	unsigned long buf_offset;	/* offset following the record header */
+	unsigned long pre_offset;	/*
+					 * Initial offset position _before_
+					 * the record is written. Positioned
+					 * prior to record header alignment
+					 * padding.
+					 */
+	u64 tsc;			/* time-stamp counter value */
+	unsigned int rflags;		/* reservation flags */
+};
+
+/**
+ * ring_buffer_ctx_init - initialize ring buffer context
+ * @ctx: ring buffer context to initialize
+ * @chan: channel
+ * @priv: client private data
+ * @data_size: size of record data payload
+ * @largest_align: largest alignment within data payload types
+ * @cpu: processor id
+ */
+static inline
+void ring_buffer_ctx_init(struct ring_buffer_ctx *ctx,
+			  struct channel *chan, void *priv,
+			  size_t data_size, int largest_align,
+			  int cpu)
+{
+	ctx->chan = chan;
+	ctx->priv = priv;
+	ctx->data_size = data_size;
+	ctx->largest_align = largest_align;
+	ctx->cpu = cpu;
+}
+
+/*
+ * Reservation flags.
+ *
+ * RING_BUFFER_RFLAG_FULL_TSC
+ *
+ * This flag is passed to record_header_size() and to the primitive used to
+ * write the record header. It indicates that the full 64-bit time value is
+ * needed in the record header. If this flag is not set, the record header needs
+ * only to contain "tsc_bits" bit of time value.
+ *
+ * Reservation flags can be added by the client, starting from
+ * "(RING_BUFFER_FLAGS_END << 0)". It can be used to pass information from
+ * record_header_size() to ring_buffer_write_record_header().
+ */
+#define	RING_BUFFER_RFLAG_FULL_TSC		(1U << 0)
+#define RING_BUFFER_RFLAG_END			(1U << 1)
+
+/*
+ * We need to define RING_BUFFER_ALIGN_ATTR so it is known early at
+ * compile-time. We have to duplicate the "config->align" information and the
+ * definition here because config->align is used both in the slow and fast
+ * paths, but RING_BUFFER_ALIGN_ATTR is only available for the client code.
+ */
+#ifdef RING_BUFFER_ALIGN
+# define RING_BUFFER_ALIGN_ATTR		/* Default arch alignment */
+#else
+# define RING_BUFFER_ALIGN_ATTR __attribute__((packed))
+#endif
+
+/*
+ * Calculate the offset needed to align the type.
+ * size_of_type must be non-zero.
+ */
+static inline
+unsigned int ring_buffer_align(const struct ring_buffer_config *config,
+			       size_t align_drift, size_t size_of_type)
+{
+	switch (config->align) {
+	case RING_BUFFER_NATURAL:
+		return offset_align(align_drift, min(sizeof(void *),
+						     size_of_type));
+	case RING_BUFFER_PACKED:
+	default:
+		return 0;
+	}
+}
+
+static inline
+int ring_buffer_get_alignment(const struct ring_buffer_config *config)
+{
+	switch (config->align) {
+	case RING_BUFFER_NATURAL:
+		return sizeof(void *);
+	case RING_BUFFER_PACKED:
+	default:
+		return 0;
+	}
+}
+
+/**
+ * ring_buffer_align_ctx - Align context offset on "alignment"
+ * @config: ring buffer instance configuration.
+ * @ctx: ring buffer context.
+ */
+static inline
+void ring_buffer_align_ctx(const struct ring_buffer_config *config,
+			   struct ring_buffer_ctx *ctx,
+			   size_t alignment)
+{
+	ctx->buf_offset += ring_buffer_align(config, ctx->buf_offset,
+					     alignment);
+}
+
+/*
+ * ring_buffer_check_config() returns 0 on success.
+ * Used internally to check for valid configurations at channel creation.
+ */
+static inline
+int ring_buffer_check_config(const struct ring_buffer_config *config,
+			     unsigned int switch_timer_interval,
+			     unsigned int read_timer_interval)
+{
+	if (config->alloc == RING_BUFFER_ALLOC_GLOBAL
+	    && config->sync == RING_BUFFER_SYNC_PER_CPU
+	    && switch_timer_interval)
+		return -EINVAL;
+	return 0;
+}
+
+#include <linux/ringbuffer/vatomic.h>
+
+#endif /* _LINUX_RING_BUFFER_CONFIG_H */
Index: linux.trees.git/include/linux/ringbuffer/frontend_api.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/frontend_api.h	2010-08-17 19:11:28.000000000 -0400
@@ -0,0 +1,352 @@
+#ifndef _LINUX_RING_BUFFER_FRONTEND_API_H
+#define _LINUX_RING_BUFFER_FRONTEND_API_H
+
+/*
+ * linux/ringbuffer/frontend_api.h
+ *
+ * (C) Copyright 2005-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring Buffer Library Synchronization Header (buffer write API).
+ *
+ * Author:
+ *	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * See ring_buffer_frontend.c for more information on wait-free algorithms.
+ * See linux/ringbuffer/frontend.h for channel allocation and read-side API.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/ringbuffer/frontend.h>
+#include <linux/errno.h>
+
+/**
+ * ring_buffer_get_cpu - Precedes ring buffer reserve/commit.
+ *
+ * Disables preemption (acts as a RCU read-side critical section) and keeps a
+ * ring buffer nesting count as supplementary safety net to ensure tracer client
+ * code will never trigger an endless recursion. Returns the processor ID on
+ * success, -EPERM on failure (nesting count too high).
+ *
+ * asm volatile and "memory" clobber prevent the compiler from moving
+ * instructions out of the ring buffer nesting count. This is required to ensure
+ * that probe side-effects which can cause recursion (e.g. unforeseen traps,
+ * divisions by 0, ...) are triggered within the incremented nesting count
+ * section.
+ */
+static inline
+int ring_buffer_get_cpu(const struct ring_buffer_config *config)
+{
+	int cpu, nesting;
+
+	rcu_read_lock_sched_notrace();
+	cpu = smp_processor_id();
+	nesting = ++per_cpu(ring_buffer_nesting, cpu);
+	barrier();
+
+	if (unlikely(nesting > 4)) {
+		WARN_ON_ONCE(1);
+		per_cpu(ring_buffer_nesting, cpu)--;
+		rcu_read_unlock_sched_notrace();
+		return -EPERM;
+	} else
+		return cpu;
+}
+
+/**
+ * ring_buffer_put_cpu - Follows ring buffer reserve/commit.
+ */
+static inline
+void ring_buffer_put_cpu(const struct ring_buffer_config *config)
+{
+	barrier();
+	__get_cpu_var(ring_buffer_nesting)--;
+	rcu_read_unlock_sched_notrace();
+}
+
+/*
+ * ring_buffer_try_reserve is called by ring_buffer_reserve(). It is not part of
+ * the API per se.
+ *
+ * returns 0 if reserve ok, or 1 if the slow path must be taken.
+ */
+static inline
+int ring_buffer_try_reserve(const struct ring_buffer_config *config,
+			    struct ring_buffer_ctx *ctx,
+			    unsigned long *o_begin, unsigned long *o_end,
+			    unsigned long *o_old, size_t *before_hdr_pad)
+{
+	struct channel *chan = ctx->chan;
+	struct ring_buffer *buf = ctx->buf;
+	*o_begin = v_read(config, &buf->offset);
+	*o_old = *o_begin;
+
+	ctx->tsc = ring_buffer_clock_read(chan);
+
+	/*
+	 * Prefetch cacheline for read because we have to read the previous
+	 * commit counter to increment it and commit seq value to compare it to
+	 * the commit counter.
+	 */
+	prefetch(&buf->commit_hot[subbuf_index(*o_begin, chan)]);
+
+	if (last_tsc_overflow(config, buf, ctx->tsc))
+		ctx->rflags = RING_BUFFER_RFLAG_FULL_TSC;
+
+	if (unlikely(subbuf_offset(*o_begin, chan) == 0))
+		return 1;
+
+	ctx->slot_size = record_header_size(config, chan, *o_begin,
+					    ctx->data_size, before_hdr_pad,
+					    ctx->rflags, ctx);
+	ctx->slot_size +=
+		ring_buffer_align(config, *o_begin + ctx->slot_size,
+				  ctx->largest_align) + ctx->data_size;
+	if (unlikely((subbuf_offset(*o_begin, chan) + ctx->slot_size)
+		     > chan->backend.subbuf_size))
+		return 1;
+
+	/*
+	 * Record fits in the current buffer and we are not on a switch
+	 * boundary. It's safe to write.
+	 */
+	*o_end = *o_begin + ctx->slot_size;
+
+	if (unlikely((subbuf_offset(*o_end, chan)) == 0))
+		/*
+		 * The offset_end will fall at the very beginning of the next
+		 * subbuffer.
+		 */
+		return 1;
+
+	return 0;
+}
+
+/**
+ * ring_buffer_reserve - Reserve space in a ring buffer.
+ * @config: ring buffer instance configuration.
+ * @ctx: ring buffer context. (input and output) Must be already initialized.
+ *
+ * Atomic wait-free slot reservation. The reserved space starts at the context
+ * "pre_offset". Its length is "slot_size". The associated time-stamp is "tsc".
+ *
+ * Return : -ENOSPC if not enough space, -EAGAIN if channel is disabled.
+ *          Returns 0 on success.
+ */
+
+static inline
+int ring_buffer_reserve(const struct ring_buffer_config *config,
+			struct ring_buffer_ctx *ctx)
+{
+	struct channel *chan = ctx->chan;
+	struct ring_buffer *buf;
+	unsigned long o_begin, o_end, o_old;
+	size_t before_hdr_pad = 0;
+
+	if (atomic_read(&chan->record_disabled))
+		return -EAGAIN;
+
+	if (config->alloc == RING_BUFFER_ALLOC_PER_CPU)
+		buf = per_cpu_ptr(chan->backend.buf, ctx->cpu);
+	else
+		buf = chan->backend.buf;
+	if (atomic_read(&buf->record_disabled))
+		return -EAGAIN;
+	ctx->buf = buf;
+
+	/*
+	 * Perform retryable operations.
+	 */
+	if (unlikely(ring_buffer_try_reserve(config, ctx, &o_begin,
+					     &o_end, &o_old, &before_hdr_pad)))
+		goto slow_path;
+
+	if (unlikely(v_cmpxchg(config, &ctx->buf->offset, o_old, o_end)
+		     != o_old))
+		goto slow_path;
+
+	/*
+	 * Atomically update last_tsc. This update races against concurrent
+	 * atomic updates, but the race will always cause supplementary full TSC
+	 * record headers, never the opposite (missing a full TSC record header
+	 * when it would be needed).
+	 */
+	save_last_tsc(config, ctx->buf, ctx->tsc);
+
+	/*
+	 * Push the reader if necessary
+	 */
+	ring_buffer_reserve_push_reader(ctx->buf, chan, o_end - 1);
+
+	/*
+	 * Clear noref flag for this subbuffer.
+	 */
+	ring_buffer_clear_noref(config, &ctx->buf->backend,
+				subbuf_index(o_end - 1, chan));
+
+	ctx->pre_offset = o_begin;
+	ctx->buf_offset = o_begin + before_hdr_pad;
+	return 0;
+slow_path:
+	return ring_buffer_reserve_slow(ctx);
+}
+
+/**
+ * ring_buffer_switch - Perform a sub-buffer switch for a per-cpu buffer.
+ * @config: ring buffer instance configuration.
+ * @buf: buffer
+ * @mode: buffer switch mode (SWITCH_ACTIVE or SWITCH_FLUSH)
+ *
+ * This operation is completely reentrant : can be called while tracing is
+ * active with absolutely no lock held.
+ *
+ * Note, however, that as a v_cmpxchg is used for some atomic operations and
+ * requires to be executed locally for per-CPU buffers, this function must be
+ * called from the CPU which owns the buffer for a ACTIVE flush, with preemption
+ * disabled, for RING_BUFFER_SYNC_PER_CPU configuration.
+ */
+static inline
+void ring_buffer_switch(const struct ring_buffer_config *config,
+			struct ring_buffer *buf, enum switch_mode mode)
+{
+	ring_buffer_switch_slow(buf, mode);
+}
+
+/* See ring_buffer_frontend_api.h for ring_buffer_reserve(). */
+
+/**
+ * ring_buffer_commit - Commit an record.
+ * @config: ring buffer instance configuration.
+ * @ctx: ring buffer context. (input arguments only)
+ *
+ * Atomic unordered slot commit. Increments the commit count in the
+ * specified sub-buffer, and delivers it if necessary.
+ */
+static inline
+void ring_buffer_commit(const struct ring_buffer_config *config,
+			const struct ring_buffer_ctx *ctx)
+{
+	struct channel *chan = ctx->chan;
+	struct ring_buffer *buf = ctx->buf;
+	unsigned long offset_end = ctx->buf_offset;
+	unsigned long endidx = subbuf_index(offset_end - 1, chan);
+	unsigned long commit_count;
+
+	/*
+	 * Must count record before incrementing the commit count.
+	 */
+	subbuffer_count_record(config, &buf->backend, endidx);
+
+	/*
+	 * Order all writes to buffer before the commit count update that will
+	 * determine that the subbuffer is full.
+	 */
+	if (config->ipi == RING_BUFFER_IPI_BARRIER) {
+		/*
+		 * Must write slot data before incrementing commit count.  This
+		 * compiler barrier is upgraded into a smp_mb() by the IPI sent
+		 * by get_subbuf().
+		 */
+		barrier();
+	} else
+		smp_wmb();
+
+	v_add(config, ctx->slot_size, &buf->commit_hot[endidx].cc);
+
+	/*
+	 * commit count read can race with concurrent OOO commit count updates.
+	 * This is only needed for ring_buffer_check_deliver (for non-polling
+	 * delivery only) and for ring_buffer_write_commit_counter. The race can
+	 * only cause the counter to be read with the same value more than once,
+	 * which could cause :
+	 * - Multiple delivery for the same sub-buffer (which is handled
+	 *   gracefully by the reader code) if the value is for a full
+	 *   sub-buffer. It's important that we can never miss a sub-buffer
+	 *   delivery. Re-reading the value after the v_add ensures this.
+	 * - Reading a commit_count with a higher value that what was actually
+	 *   added to it for the ring_buffer_write_commit_counter call (again
+	 *   caused by a concurrent committer). It does not matter, because this
+	 *   function is interested in the fact that the commit count reaches
+	 *   back the reserve offset for a specific sub-buffer, which is
+	 *   completely independent of the order.
+	 */
+	commit_count = v_read(config, &buf->commit_hot[endidx].cc);
+
+	ring_buffer_check_deliver(config, buf, chan, offset_end - 1,
+				  commit_count, endidx);
+	/*
+	 * Update used size at each commit. It's needed only for extracting
+	 * ring_buffer buffers from vmcore, after crash.
+	 */
+	ring_buffer_write_commit_counter(config, buf, chan, endidx,
+					 ctx->buf_offset, commit_count,
+					 ctx->slot_size);
+}
+
+/**
+ * ring_buffer_try_discard_reserve - Try discarding a record.
+ * @config: ring buffer instance configuration.
+ * @ctx: ring buffer context. (input arguments only)
+ *
+ * Only succeeds if no other record has been written after the record to
+ * discard. If discard fails, the record must be committed to the buffer.
+ *
+ * Returns 0 upon success, -EPERM if the record cannot be discarded.
+ */
+static inline
+int ring_buffer_try_discard_reserve(const struct ring_buffer_config *config,
+				    const struct ring_buffer_ctx *ctx)
+{
+	struct ring_buffer *buf = ctx->buf;
+	unsigned long end_offset = ctx->pre_offset + ctx->slot_size;
+
+	/*
+	 * We need to ensure that if the cmpxchg succeeds and discards the
+	 * record, the next record will record a full TSC, because it cannot
+	 * rely on the last_tsc associated with the discarded record to detect
+	 * overflows. The only way to ensure this is to set the last_tsc to 0
+	 * (assuming no 64-bit TSC overflow), which forces to write a 64-bit
+	 * timestamp in the next record.
+	 *
+	 * Note: if discard fails, we must leave the TSC in the record header.
+	 * It is needed to keep track of TSC overflows for the following
+	 * records.
+	 */
+	save_last_tsc(config, buf, 0ULL);
+
+	if (likely(v_cmpxchg(config, &buf->offset, end_offset, ctx->pre_offset)
+		   != end_offset))
+		return -EPERM;
+	else
+		return 0;
+}
+
+static inline
+void channel_record_disable(const struct ring_buffer_config *config,
+			    struct channel *chan)
+{
+	atomic_inc(&chan->record_disabled);
+}
+
+static inline
+void channel_record_enable(const struct ring_buffer_config *config,
+			   struct channel *chan)
+{
+	atomic_dec(&chan->record_disabled);
+}
+
+static inline
+void ring_buffer_record_disable(const struct ring_buffer_config *config,
+				struct ring_buffer *buf)
+{
+	atomic_inc(&buf->record_disabled);
+}
+
+static inline
+void ring_buffer_record_enable(const struct ring_buffer_config *config,
+			       struct ring_buffer *buf)
+{
+	atomic_dec(&buf->record_disabled);
+}
+
+#endif /* _LINUX_RING_BUFFER_FRONTEND_API_H */
Index: linux.trees.git/include/linux/ringbuffer/frontend_internal.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/frontend_internal.h	2010-08-17 19:11:28.000000000 -0400
@@ -0,0 +1,424 @@
+#ifndef _LINUX_RING_BUFFER_FRONTEND_INTERNAL_H
+#define _LINUX_RING_BUFFER_FRONTEND_INTERNAL_H
+
+/*
+ * linux/ringbuffer/frontend_internal.h
+ *
+ * (C) Copyright 2005-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring Buffer Library Synchronization Header (internal helpers).
+ *
+ * Author:
+ *	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * See ring_buffer_frontend.c for more information on wait-free algorithms.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/ringbuffer/config.h>
+#include <linux/ringbuffer/backend_types.h>
+#include <linux/ringbuffer/frontend_types.h>
+#include <linux/prio_heap.h>	/* For per-CPU read-side iterator */
+
+/* Buffer offset macros */
+
+/* buf_trunc mask selects only the buffer number. */
+static inline
+unsigned long buf_trunc(unsigned long offset, struct channel *chan)
+{
+	return (offset) & (~((chan)->backend.buf_size - 1));
+
+}
+
+/* Select the buffer number value (counter). */
+static inline
+unsigned long buf_trunc_val(unsigned long offset, struct channel *chan)
+{
+	return buf_trunc(offset, chan) >> (chan)->backend.buf_size_order;
+}
+
+/* buf_offset mask selects only the offset within the current buffer. */
+static inline
+unsigned long buf_offset(unsigned long offset, struct channel *chan)
+{
+	return (offset) & ((chan)->backend.buf_size - 1);
+}
+
+/* subbuf_offset mask selects the offset within the current subbuffer. */
+static inline
+unsigned long subbuf_offset(unsigned long offset, struct channel *chan)
+{
+	return (offset) & ((chan)->backend.subbuf_size - 1);
+}
+
+/* subbuf_trunc mask selects the subbuffer number. */
+static inline
+unsigned long subbuf_trunc(unsigned long offset, struct channel *chan)
+{
+	return (offset) & (~((chan)->backend.subbuf_size - 1));
+}
+
+/* subbuf_align aligns the offset to the next subbuffer. */
+static inline
+unsigned long subbuf_align(unsigned long offset, struct channel *chan)
+{
+	return ((offset) + (chan)->backend.subbuf_size)
+	       & (~((chan)->backend.subbuf_size - 1));
+}
+
+/* subbuf_index returns the index of the current subbuffer within the buffer. */
+static inline
+unsigned long subbuf_index(unsigned long offset, struct channel *chan)
+{
+	return buf_offset((offset), chan) >> (chan)->backend.subbuf_size_order;
+}
+
+/*
+ * Last TSC comparison functions. Check if the current TSC overflows tsc_bits
+ * bits from the last TSC read. When overflows are detected, the full 64-bit
+ * timestamp counter should be written in the record header. Reads and writes
+ * last_tsc atomically.
+ */
+
+#if (BITS_PER_LONG == 32)
+static inline
+void save_last_tsc(const struct ring_buffer_config *config,
+		   struct ring_buffer *buf, u64 tsc)
+{
+	if (config->tsc_bits == 0 || config->tsc_bits == 64)
+		return;
+
+	/*
+	 * Ensure the compiler performs this update in a single instruction.
+	 */
+	v_set(config, &buf->last_tsc, (unsigned long)(tsc >> config->tsc_bits));
+}
+
+static inline
+int last_tsc_overflow(const struct ring_buffer_config *config,
+		      struct ring_buffer *buf, u64 tsc)
+{
+	unsigned long tsc_shifted;
+
+	if (config->tsc_bits == 0 || config->tsc_bits == 64)
+		return 0;
+
+	tsc_shifted = (unsigned long)(tsc >> config->tsc_bits);
+	if (unlikely((tsc_shifted
+		      - (unsigned long)v_read(config, &buf->last_tsc))))
+		return 1;
+	else
+		return 0;
+}
+#else
+static inline
+void save_last_tsc(const struct ring_buffer_config *config,
+		   struct ring_buffer *buf, u64 tsc)
+{
+	if (config->tsc_bits == 0 || config->tsc_bits == 64)
+		return;
+
+	v_set(config, &buf->last_tsc, (unsigned long)tsc);
+}
+
+static inline
+int last_tsc_overflow(const struct ring_buffer_config *config,
+		      struct ring_buffer *buf, u64 tsc)
+{
+	if (config->tsc_bits == 0 || config->tsc_bits == 64)
+		return 0;
+
+	if (unlikely((tsc - v_read(config, &buf->last_tsc))
+		     >> config->tsc_bits))
+		return 1;
+	else
+		return 0;
+}
+#endif
+
+extern
+int ring_buffer_reserve_slow(struct ring_buffer_ctx *ctx);
+
+extern
+void ring_buffer_switch_slow(struct ring_buffer *buf,
+			     enum switch_mode mode);
+
+/* Buffer write helpers */
+
+static inline
+void ring_buffer_reserve_push_reader(struct ring_buffer *buf,
+				     struct channel *chan,
+				     unsigned long offset)
+{
+	unsigned long consumed_old, consumed_new;
+
+	do {
+		consumed_old = atomic_long_read(&buf->consumed);
+		/*
+		 * If buffer is in overwrite mode, push the reader consumed
+		 * count if the write position has reached it and we are not
+		 * at the first iteration (don't push the reader farther than
+		 * the writer). This operation can be done concurrently by many
+		 * writers in the same buffer, the writer being at the farthest
+		 * write position sub-buffer index in the buffer being the one
+		 * which will win this loop.
+		 */
+		if (unlikely((subbuf_trunc(offset, chan)
+			      - subbuf_trunc(consumed_old, chan))
+			     >= chan->backend.buf_size))
+			consumed_new = subbuf_align(consumed_old, chan);
+		else
+			return;
+	} while (unlikely(atomic_long_cmpxchg(&buf->consumed, consumed_old,
+					      consumed_new) != consumed_old));
+}
+
+static inline
+void ring_buffer_vmcore_check_deliver(const struct ring_buffer_config *config,
+				      struct ring_buffer *buf,
+				      unsigned long commit_count,
+				      unsigned long idx)
+{
+	if (config->oops == RING_BUFFER_OOPS_CONSISTENCY)
+		v_set(config, &buf->commit_hot[idx].seq, commit_count);
+}
+
+static inline
+int ring_buffer_poll_deliver(const struct ring_buffer_config *config,
+			     struct ring_buffer *buf,
+			     struct channel *chan)
+{
+	unsigned long consumed_old, consumed_idx, commit_count, write_offset;
+
+	consumed_old = atomic_long_read(&buf->consumed);
+	consumed_idx = subbuf_index(consumed_old, chan);
+	commit_count = v_read(config, &buf->commit_cold[consumed_idx].cc_sb);
+	/*
+	 * No memory barrier here, since we are only interested
+	 * in a statistically correct polling result. The next poll will
+	 * get the data is we are racing. The mb() that ensures correct
+	 * memory order is in get_subbuf.
+	 */
+	write_offset = v_read(config, &buf->offset);
+
+	/*
+	 * Check that the subbuffer we are trying to consume has been
+	 * already fully committed.
+	 */
+
+	if (((commit_count - chan->backend.subbuf_size)
+	     & chan->commit_count_mask)
+	    - (buf_trunc(consumed_old, chan)
+	       >> chan->backend.num_subbuf_order)
+	    != 0)
+		return 0;
+
+	/*
+	 * Check that we are not about to read the same subbuffer in
+	 * which the writer head is.
+	 */
+	if ((subbuf_trunc(write_offset, chan)
+	   - subbuf_trunc(consumed_old, chan))
+	   == 0)
+		return 0;
+
+	return 1;
+
+}
+
+static inline
+int ring_buffer_pending_data(const struct ring_buffer_config *config,
+			     struct ring_buffer *buf,
+			     struct channel *chan)
+{
+	return !!subbuf_offset(v_read(config, &buf->offset), chan);
+}
+
+static inline
+unsigned long ring_buffer_get_data_size(const struct ring_buffer_config *config,
+					struct ring_buffer *buf,
+					unsigned long idx)
+{
+	return subbuffer_get_data_size(config, &buf->backend, idx);
+}
+
+/*
+ * Check if all space reservation in a buffer have been committed. This helps
+ * knowing if an execution context is nested (for per-cpu buffers only).
+ * This is a very specific ftrace use-case, so we keep this as "internal" API.
+ */
+static inline
+int ring_buffer_reserve_committed(const struct ring_buffer_config *config,
+				  struct ring_buffer *buf,
+				  struct channel *chan)
+{
+	unsigned long offset, idx, commit_count;
+
+	CHAN_WARN_ON(chan, config->alloc != RING_BUFFER_ALLOC_PER_CPU);
+	CHAN_WARN_ON(chan, config->sync != RING_BUFFER_SYNC_PER_CPU);
+
+	/*
+	 * Read offset and commit count in a loop so they are both read
+	 * atomically wrt interrupts. By deal with interrupt concurrency by
+	 * restarting both reads if the offset has been pushed. Note that given
+	 * we only have to deal with interrupt concurrency here, an interrupt
+	 * modifying the commit count will also modify "offset", so it is safe
+	 * to only check for offset modifications.
+	 */
+	do {
+		offset = v_read(config, &buf->offset);
+		idx = subbuf_index(offset, chan);
+		commit_count = v_read(config, &buf->commit_hot[idx].cc);
+	} while (offset != v_read(config, &buf->offset));
+
+	return ((buf_trunc(offset, chan) >> chan->backend.num_subbuf_order)
+		     - (commit_count & chan->commit_count_mask) == 0);
+}
+
+static inline
+void ring_buffer_check_deliver(const struct ring_buffer_config *config,
+			       struct ring_buffer *buf,
+			       struct channel *chan,
+			       unsigned long offset, unsigned long commit_count,
+			       unsigned long idx)
+{
+	unsigned long old_commit_count = commit_count
+					 - chan->backend.subbuf_size;
+	u64 tsc;
+
+	/* Check if all commits have been done */
+	if (unlikely((buf_trunc(offset, chan) >> chan->backend.num_subbuf_order)
+		     - (old_commit_count & chan->commit_count_mask) == 0)) {
+		/*
+		 * If we succeeded at updating cc_sb below, we are the subbuffer
+		 * writer delivering the subbuffer. Deals with concurrent
+		 * updates of the "cc" value without adding a add_return atomic
+		 * operation to the fast path.
+		 *
+		 * We are doing the delivery in two steps:
+		 * - First, we cmpxchg() cc_sb to the new value
+		 *   old_commit_count + 1. This ensures that we are the only
+		 *   subbuffer user successfully filling the subbuffer, but we
+		 *   do _not_ set the cc_sb value to "commit_count" yet.
+		 *   Therefore, other writers that would wrap around the ring
+		 *   buffer and try to start writing to our subbuffer would
+		 *   have to drop records, because it would appear as
+		 *   non-filled.
+		 *   We therefore have exclusive access to the subbuffer control
+		 *   structures.  This mutual exclusion with other writers is
+		 *   crucially important to perform record overruns count in
+		 *   flight recorder mode locklessly.
+		 * - When we are ready to release the subbuffer (either for
+		 *   reading or for overrun by other writers), we simply set the
+		 *   cc_sb value to "commit_count" and perform delivery.
+		 *
+		 * The subbuffer size is least 2 bytes (minimum size: 1 page).
+		 * This guarantees that old_commit_count + 1 != commit_count.
+		 */
+		if (likely(v_cmpxchg(config, &buf->commit_cold[idx].cc_sb,
+					 old_commit_count, old_commit_count + 1)
+			   == old_commit_count)) {
+			/*
+			 * Start of exclusive subbuffer access. We are
+			 * guaranteed to be the last writer in this subbuffer
+			 * and any other writer trying to access this subbuffer
+			 * in this state is required to drop records.
+			 */
+			tsc = config->cb.ring_buffer_clock_read(chan);
+			v_add(config,
+			      subbuffer_get_records_count(config,
+							  &buf->backend, idx),
+			      &buf->records_count);
+			v_add(config,
+			      subbuffer_count_records_overrun(config,
+							      &buf->backend,
+							      idx),
+			      &buf->records_overrun);
+			config->cb.buffer_end(buf, tsc, idx,
+					      ring_buffer_get_data_size(config,
+									buf,
+									idx));
+
+			/*
+			 * Set noref flag and offset for this subbuffer id.
+			 * Contains a memory barrier that ensures counter stores
+			 * are ordered before set noref and offset.
+			 */
+			ring_buffer_set_noref_offset(config, &buf->backend, idx,
+						buf_trunc_val(offset, chan));
+
+			/*
+			 * Order set_noref and record counter updates before the
+			 * end of subbuffer exclusive access. Orders with
+			 * respect to writers coming into the subbuffer after
+			 * wrap around, and also order wrt concurrent readers.
+			 */
+			smp_mb();
+			/* End of exclusive subbuffer access */
+			v_set(config, &buf->commit_cold[idx].cc_sb,
+			      commit_count);
+			ring_buffer_vmcore_check_deliver(config, buf,
+							 commit_count, idx);
+
+			/*
+			 * RING_BUFFER_WAKEUP_BY_WRITER wakeup is not lock-free.
+			 */
+			if (config->wakeup == RING_BUFFER_WAKEUP_BY_WRITER
+			    && atomic_long_read(&buf->active_readers)
+			    && ring_buffer_poll_deliver(config, buf, chan)) {
+				wake_up_interruptible(&buf->read_wait);
+				wake_up_interruptible(&chan->read_wait);
+			}
+
+		}
+	}
+}
+
+/*
+ * ring_buffer_write_commit_counter
+ *
+ * For flight recording. must be called after commit.
+ * This function increments the subbuffer's commit_seq counter each time the
+ * commit count reaches back the reserve offset (modulo subbuffer size). It is
+ * useful for crash dump.
+ */
+static inline
+void ring_buffer_write_commit_counter(const struct ring_buffer_config *config,
+				      struct ring_buffer *buf,
+				      struct channel *chan,
+				      unsigned long idx,
+				      unsigned long buf_offset,
+				      unsigned long commit_count,
+				      size_t slot_size)
+{
+	unsigned long offset, commit_seq_old;
+
+	if (config->oops != RING_BUFFER_OOPS_CONSISTENCY)
+		return;
+
+	offset = buf_offset + slot_size;
+
+	/*
+	 * subbuf_offset includes commit_count_mask. We can simply
+	 * compare the offsets within the subbuffer without caring about
+	 * buffer full/empty mismatch because offset is never zero here
+	 * (subbuffer header and record headers have non-zero length).
+	 */
+	if (unlikely(subbuf_offset(offset - commit_count, chan)))
+		return;
+
+	commit_seq_old = v_read(config, &buf->commit_hot[idx].seq);
+	while ((long) (commit_seq_old - commit_count) < 0)
+		commit_seq_old = v_cmpxchg(config, &buf->commit_hot[idx].seq,
+					 commit_seq_old, commit_count);
+}
+
+extern int ring_buffer_create(struct ring_buffer *buf,
+			      struct channel_backend *chanb, int cpu);
+extern void ring_buffer_free(struct ring_buffer *buf);
+
+/* Keep track of trap nesting inside ring buffer code */
+DECLARE_PER_CPU(unsigned int, ring_buffer_nesting);
+
+#endif /* _LINUX_RING_BUFFER_FRONTEND_INTERNAL_H */
Index: linux.trees.git/include/linux/ringbuffer/frontend.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/frontend.h	2010-08-17 19:11:28.000000000 -0400
@@ -0,0 +1,223 @@
+#ifndef _LINUX_RING_BUFFER_FRONTEND_H
+#define _LINUX_RING_BUFFER_FRONTEND_H
+
+/*
+ * linux/ringbuffer/frontend.h
+ *
+ * (C) Copyright 2005-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring Buffer Library Synchronization Header (API).
+ *
+ * Author:
+ *	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * See ring_buffer_frontend.c for more information on wait-free algorithms.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/pipe_fs_i.h>
+#include <linux/rcupdate.h>
+#include <linux/smp_lock.h>
+#include <linux/cpumask.h>
+#include <linux/module.h>
+#include <linux/bitops.h>
+#include <linux/splice.h>
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/cache.h>
+#include <linux/time.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/cpu.h>
+#include <linux/fs.h>
+
+#include <asm/atomic.h>
+#include <asm/local.h>
+
+/* Internal helpers */
+#include <linux/ringbuffer/frontend_internal.h>
+
+/* Buffer creation/removal and setup operations */
+
+/*
+ * switch_timer_interval is the time interval (in us) to fill sub-buffers with
+ * padding to let readers get those sub-buffers.  Used for live streaming.
+ *
+ * read_timer_interval is the time interval (in us) to wake up pending readers.
+ *
+ * buf_addr is a pointer the the beginning of the preallocated buffer contiguous
+ * address mapping. It is used only by RING_BUFFER_STATIC configuration. It can
+ * be set to NULL for other backends.
+ */
+
+extern
+struct channel *channel_create(const struct ring_buffer_config *config,
+			       const char *name, void *priv,
+			       void *buf_addr,
+			       size_t subbuf_size, size_t num_subbuf,
+			       unsigned int switch_timer_interval,
+			       unsigned int read_timer_interval);
+
+/*
+ * channel_destroy returns the private data pointer. It finalizes all channel's
+ * buffers, waits for readers to release all references, and destroys the
+ * channel.
+ */
+extern
+void *channel_destroy(struct channel *chan);
+
+
+/* Buffer read operations */
+
+/*
+ * Iteration on channel cpumask needs to issue a read barrier to match the write
+ * barrier in cpu hotplug. It orders the cpumask read before read of per-cpu
+ * buffer data. The per-cpu buffer is never removed by cpu hotplug; teardown is
+ * only performed at channel destruction.
+ */
+#define for_each_channel_cpu(cpu, chan)					\
+	for ((cpu) = -1;						\
+		({ (cpu) = cpumask_next((cpu), (chan)->backend.cpumask);\
+		   smp_read_barrier_depends(); (cpu) < nr_cpu_ids; });)
+
+extern struct ring_buffer *channel_get_ring_buffer(
+					const struct ring_buffer_config *config,
+					struct channel *chan, int cpu);
+extern int ring_buffer_open_read(struct ring_buffer *buf);
+extern void ring_buffer_release_read(struct ring_buffer *buf);
+
+/*
+ * Read sequence: snapshot, many get_subbuf/put_subbuf, move_consumer.
+ */
+extern int ring_buffer_snapshot(struct ring_buffer *buf,
+				unsigned long *consumed,
+				unsigned long *produced);
+extern void ring_buffer_move_consumer(struct ring_buffer *buf,
+				      unsigned long consumed_new);
+
+extern int ring_buffer_get_subbuf(struct ring_buffer *buf,
+				  unsigned long consumed);
+extern void ring_buffer_put_subbuf(struct ring_buffer *buf);
+
+/*
+ * ring_buffer_get_next_subbuf/ring_buffer_put_next_subbuf are helpers to read
+ * sub-buffers sequentially.
+ */
+static inline int ring_buffer_get_next_subbuf(struct ring_buffer *buf)
+{
+	int ret;
+
+	ret = ring_buffer_snapshot(buf, &buf->cons_snapshot,
+				   &buf->prod_snapshot);
+	if (ret)
+		return ret;
+	ret = ring_buffer_get_subbuf(buf, buf->cons_snapshot);
+	return ret;
+}
+
+static inline void ring_buffer_put_next_subbuf(struct ring_buffer *buf)
+{
+	ring_buffer_put_subbuf(buf);
+	ring_buffer_move_consumer(buf, subbuf_align(buf->cons_snapshot,
+						    buf->backend.chan));
+}
+
+extern void channel_reset(struct channel *chan);
+extern void ring_buffer_reset(struct ring_buffer *buf);
+
+static inline
+unsigned long ring_buffer_get_offset(const struct ring_buffer_config *config,
+				     struct ring_buffer *buf)
+{
+	return v_read(config, &buf->offset);
+}
+
+static inline
+unsigned long ring_buffer_get_consumed(const struct ring_buffer_config *config,
+				       struct ring_buffer *buf)
+{
+	return atomic_long_read(&buf->consumed);
+}
+
+/*
+ * Must call ring_buffer_is_finalized before reading counters (memory ordering
+ * enforced with respect to trace teardown).
+ */
+static inline
+int ring_buffer_is_finalized(const struct ring_buffer_config *config,
+			     struct ring_buffer *buf)
+{
+	int finalized = ACCESS_ONCE(buf->finalized);
+	/*
+	 * Read finalized before counters.
+	 */
+	smp_rmb();
+	return finalized;
+}
+
+static inline
+unsigned long ring_buffer_get_read_data_size(
+					const struct ring_buffer_config *config,
+					struct ring_buffer *buf)
+{
+	return subbuffer_get_read_data_size(config, &buf->backend);
+}
+
+static inline
+unsigned long ring_buffer_get_records_count(
+				const struct ring_buffer_config *config,
+				struct ring_buffer *buf)
+{
+	return v_read(config, &buf->records_count);
+}
+
+static inline
+unsigned long ring_buffer_get_records_overrun(
+				const struct ring_buffer_config *config,
+				struct ring_buffer *buf)
+{
+	return v_read(config, &buf->records_overrun);
+}
+
+static inline
+unsigned long ring_buffer_get_records_lost_full(
+				const struct ring_buffer_config *config,
+				struct ring_buffer *buf)
+{
+	return v_read(config, &buf->records_lost_full);
+}
+
+static inline
+unsigned long ring_buffer_get_records_lost_wrap(
+				const struct ring_buffer_config *config,
+				struct ring_buffer *buf)
+{
+	return v_read(config, &buf->records_lost_wrap);
+}
+
+static inline
+unsigned long ring_buffer_get_records_lost_big(
+				const struct ring_buffer_config *config,
+				struct ring_buffer *buf)
+{
+	return v_read(config, &buf->records_lost_big);
+}
+
+static inline
+unsigned long ring_buffer_get_records_read(
+				const struct ring_buffer_config *config,
+				struct ring_buffer *buf)
+{
+	return v_read(config, &buf->backend.records_read);
+}
+
+static inline
+void *channel_get_private(struct channel *chan)
+{
+	return chan->backend.priv;
+}
+
+#endif /* _LINUX_RING_BUFFER_FRONTEND_H */
Index: linux.trees.git/include/linux/ringbuffer/frontend_types.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/frontend_types.h	2010-08-17 19:11:28.000000000 -0400
@@ -0,0 +1,162 @@
+#ifndef _LINUX_RING_BUFFER_FRONTEND_TYPES_H
+#define _LINUX_RING_BUFFER_FRONTEND_TYPES_H
+
+/*
+ * linux/ringbuffer/frontend_types.h
+ *
+ * (C) Copyright 2005-2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Ring Buffer Library Synchronization Header (types).
+ *
+ * Author:
+ *	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * See ring_buffer_frontend.c for more information on wait-free algorithms.
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <linux/ringbuffer/config.h>
+#include <linux/ringbuffer/backend_types.h>
+#include <linux/prio_heap.h>	/* For per-CPU read-side iterator */
+
+/*
+ * A switch is done during tracing or as a final flush after tracing (so it
+ * won't write in the new sub-buffer).
+ */
+enum switch_mode { SWITCH_ACTIVE, SWITCH_FLUSH };
+
+/* channel-level read-side iterator */
+struct channel_iter {
+	/* Prio heap of buffers. Lowest timestamps at the top. */
+	struct ptr_heap heap;		/* Heap of struct ring_buffer ptrs */
+	struct list_head empty_head;	/* Empty buffers linked-list head */
+	int read_open;			/* Opened for reading ? */
+	u64 last_qs;			/* Last quiescent state timestamp */
+	u64 last_timestamp;		/* Last timestamp (for WARN_ON) */
+	int last_cpu;			/* Last timestamp cpu */
+	/*
+	 * read() file operation state.
+	 */
+	unsigned long len_left;
+};
+
+/* channel: collection of per-cpu ring buffers. */
+struct channel {
+	atomic_t record_disabled;
+	unsigned long commit_count_mask;	/*
+						 * Commit count mask, removing
+						 * the MSBs corresponding to
+						 * bits used to represent the
+						 * subbuffer index.
+						 */
+
+	struct channel_backend backend;		/* Associated backend */
+
+	unsigned long switch_timer_interval;	/* Buffer flush (jiffies) */
+	unsigned long read_timer_interval;	/* Reader wakeup (jiffies) */
+	struct notifier_block cpu_hp_notifier;	/* CPU hotplug notifier */
+	struct notifier_block idle_notifier;	/* CPU idle notifier */
+	struct notifier_block hp_iter_notifier;	/* hotplug iterator notifier */
+	int cpu_hp_enable:1;			/* Enable CPU hotplug notif. */
+	int hp_iter_enable:1;			/* Enable hp iter notif. */
+	wait_queue_head_t read_wait;		/* reader wait queue */
+	struct channel_iter iter;		/* Channel read-side iterator */
+	atomic_long_t read_ref;			/* Reader reference count */
+};
+
+/* Per-subbuffer commit counters used on the hot path */
+struct commit_counters_hot {
+	union v_atomic cc;		/* Commit counter */
+	union v_atomic seq;		/* Consecutive commits */
+};
+
+/* Per-subbuffer commit counters used only on cold paths */
+struct commit_counters_cold {
+	union v_atomic cc_sb;		/* Incremented _once_ at sb switch */
+};
+
+/* Per-buffer read iterator */
+struct ring_buffer_iter {
+	u64 timestamp;			/* Current record timestamp */
+	size_t header_len;		/* Current record header length */
+	size_t payload_len;		/* Current record payload length */
+
+	struct list_head empty_node;	/* Linked list of empty buffers */
+	unsigned long consumed, read_offset, data_size;
+	enum {
+		ITER_GET_SUBBUF = 0,
+		ITER_TEST_RECORD,
+		ITER_NEXT_RECORD,
+		ITER_PUT_SUBBUF,
+	} state;
+	int allocated:1;
+	int read_open:1;		/* Opened for reading ? */
+};
+
+/* ring buffer state */
+struct ring_buffer {
+	/* First 32 bytes cache-hot cacheline */
+	union v_atomic offset;		/* Current offset in the buffer */
+	struct commit_counters_hot *commit_hot;
+					/* Commit count per sub-buffer */
+	atomic_long_t consumed;		/*
+					 * Current offset in the buffer
+					 * standard atomic access (shared)
+					 */
+	atomic_t record_disabled;
+	/* End of first 32 bytes cacheline */
+	union v_atomic last_tsc;	/*
+					 * Last timestamp written in the buffer.
+					 */
+
+	struct ring_buffer_backend backend;	/* Associated backend */
+
+	struct commit_counters_cold *commit_cold;
+					/* Commit count per sub-buffer */
+	atomic_long_t active_readers;	/*
+					 * Active readers count
+					 * standard atomic access (shared)
+					 */
+					/* Dropped records */
+	union v_atomic records_lost_full;	/* Buffer full */
+	union v_atomic records_lost_wrap;	/* Nested wrap-around */
+	union v_atomic records_lost_big;	/* Events too big */
+	union v_atomic records_count;	/* Number of records written */
+	union v_atomic records_overrun;	/* Number of overwritten records */
+	wait_queue_head_t read_wait;	/* reader buffer-level wait queue */
+	int finalized;			/* buffer has been finalized */
+	struct timer_list switch_timer;	/* timer for periodical switch */
+	struct timer_list read_timer;	/* timer for read poll */
+	raw_spinlock_t raw_idle_spinlock;	/* Idle entry lock/trylock */
+	struct ring_buffer_iter iter;	/* read-side iterator */
+	unsigned long get_subbuf_consumed;	/* Read-side consumed */
+	unsigned long prod_snapshot;	/* Producer count snapshot */
+	unsigned long cons_snapshot;	/* Consumer count snapshot */
+	int get_subbuf:1;		/* Sub-buffer being held by reader */
+};
+
+/*
+ * Issue warnings and disable channels upon internal error.
+ * Can receive struct ring_buffer or struct ring_buffer_backend parameters.
+ */
+#define CHAN_WARN_ON(c, cond)						\
+	({								\
+		struct channel *__chan;					\
+		int _____ret = unlikely(cond);				\
+		if (_____ret) {						\
+			if (__same_type(*(c), struct channel_backend))	\
+				__chan = container_of((void *) (c),	\
+							struct channel, \
+							backend);	\
+			else if (__same_type(*(c), struct channel))	\
+				__chan = (void *) (c);			\
+			else						\
+				BUG_ON(1);				\
+			atomic_inc(&__chan->record_disabled);		\
+			WARN_ON(1);					\
+		}							\
+		_____ret;						\
+	})
+
+#endif /* _LINUX_RING_BUFFER_FRONTEND_TYPES_H */
Index: linux.trees.git/include/linux/ringbuffer/vatomic.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/ringbuffer/vatomic.h	2010-08-17 19:11:28.000000000 -0400
@@ -0,0 +1,85 @@
+#ifndef _LINUX_RING_BUFFER_VATOMIC_H
+#define _LINUX_RING_BUFFER_VATOMIC_H
+
+/*
+ * linux/ringbuffer/vatomic.h
+ *
+ * Copyright (C) 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ *
+ * Dual LGPL v2.1/GPL v2 license.
+ */
+
+#include <asm/atomic.h>
+#include <asm/local.h>
+
+/*
+ * Same data type (long) accessed differently depending on configuration.
+ * v field is for non-atomic access (protected by mutual exclusion).
+ * In the fast-path, the ring_buffer_config structure is constant, so the
+ * compiler can statically select the appropriate branch.
+ * local_t is used for per-cpu and per-thread buffers.
+ * atomic_long_t is used for globally shared buffers.
+ */
+union v_atomic {
+	local_t l;
+	atomic_long_t a;
+	long v;
+};
+
+static inline
+long v_read(const struct ring_buffer_config *config, union v_atomic *v_a)
+{
+	if (config->sync == RING_BUFFER_SYNC_PER_CPU)
+		return local_read(&v_a->l);
+	else
+		return atomic_long_read(&v_a->a);
+}
+
+static inline
+void v_set(const struct ring_buffer_config *config, union v_atomic *v_a,
+	   long v)
+{
+	if (config->sync == RING_BUFFER_SYNC_PER_CPU)
+		local_set(&v_a->l, v);
+	else
+		atomic_long_set(&v_a->a, v);
+}
+
+static inline
+void v_add(const struct ring_buffer_config *config, long v, union v_atomic *v_a)
+{
+	if (config->sync == RING_BUFFER_SYNC_PER_CPU)
+		local_add(v, &v_a->l);
+	else
+		atomic_long_add(v, &v_a->a);
+}
+
+static inline
+void v_inc(const struct ring_buffer_config *config, union v_atomic *v_a)
+{
+	if (config->sync == RING_BUFFER_SYNC_PER_CPU)
+		local_inc(&v_a->l);
+	else
+		atomic_long_inc(&v_a->a);
+}
+
+/*
+ * Non-atomic decrement. Only used by reader, apply to reader-owned subbuffer.
+ */
+static inline
+void _v_dec(const struct ring_buffer_config *config, union v_atomic *v_a)
+{
+	--v_a->v;
+}
+
+static inline
+long v_cmpxchg(const struct ring_buffer_config *config, union v_atomic *v_a,
+	       long old, long _new)
+{
+	if (config->sync == RING_BUFFER_SYNC_PER_CPU)
+		return local_cmpxchg(&v_a->l, old, _new);
+	else
+		return atomic_long_cmpxchg(&v_a->a, old, _new);
+}
+
+#endif /* _LINUX_RING_BUFFER_VATOMIC_H */

