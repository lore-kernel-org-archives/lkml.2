Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1KMUaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 15:30:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57289 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab1KMUaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 15:30:13 -0500
Date: Sun, 13 Nov 2011 12:30:07 -0800
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Subject: [DEBUG TOOL] flight data recorder for reference count debugging
Message-ID: <20111113203007.GA23606@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to debug a refcnt bug and it was just painful and none of
the available debugging options seemed good, so I wrote an event
tracking debugging facility.

It records fixed number of latest events, each of which consist of u8
user data, stack trace and time delta from the last event, per target
data structure and transfers the records into storage area when the
data structure gets destroyed.  Later when refcnt discrepancy is
discovered, the record can be dumped showing how the refcnt was
manipulated when, making it easy (or at least possible) to spot which
path forgot to obtain a refcnt or did double put.

For details, please read the comment at the top of fdr.h.

This can be pretty useful in certain situations but I'm not sure
whether this fits upstream, so, for now, just posting so that people,
including me, can find it.

NOT FOR UPSTREAM INCLUSION
---
 arch/x86/include/asm/stacktrace.h |    3 
 arch/x86/kernel/stacktrace.c      |   40 +++
 include/linux/fdr.h               |  181 +++++++++++++++
 include/linux/stacktrace.h        |    6 
 kernel/stacktrace.c               |    6 
 lib/Kconfig.debug                 |    7 
 lib/Makefile                      |    1 
 lib/fdr.c                         |  435 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 679 insertions(+)

Index: work/include/linux/stacktrace.h
===================================================================
--- work.orig/include/linux/stacktrace.h
+++ work/include/linux/stacktrace.h
@@ -19,6 +19,12 @@ extern void save_stack_trace_regs(struct
 extern void save_stack_trace_tsk(struct task_struct *tsk,
 				struct stack_trace *trace);
 
+/*
+ * Saves only trace from the current context.  Doesn't handle exception
+ * stacks or verify text address.
+ */
+extern void save_stack_trace_quick(struct stack_trace *trace);
+
 extern void print_stack_trace(struct stack_trace *trace, int spaces);
 
 #ifdef CONFIG_USER_STACKTRACE_SUPPORT
Index: work/kernel/stacktrace.c
===================================================================
--- work.orig/kernel/stacktrace.c
+++ work/kernel/stacktrace.c
@@ -31,6 +31,12 @@ EXPORT_SYMBOL_GPL(print_stack_trace);
  * (whenever this facility is utilized - for example by procfs):
  */
 __weak void
+save_stack_trace_quick(struct stack_trace *trace)
+{
+	WARN_ONCE(1, KERN_INFO "save_stack_trace_quick() not implemented yet.\n");
+}
+
+__weak void
 save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
 	WARN_ONCE(1, KERN_INFO "save_stack_trace_tsk() not implemented yet.\n");
Index: work/arch/x86/include/asm/stacktrace.h
===================================================================
--- work.orig/arch/x86/include/asm/stacktrace.h
+++ work/arch/x86/include/asm/stacktrace.h
@@ -48,11 +48,14 @@ void dump_trace(struct task_struct *tsk,
 		const struct stacktrace_ops *ops, void *data);
 
 #ifdef CONFIG_X86_32
+
 #define STACKSLOTS_PER_LINE 8
 #define get_bp(bp) asm("movl %%ebp, %0" : "=r" (bp) :)
+#define get_irq_stack_end()	0
 #else
 #define STACKSLOTS_PER_LINE 4
 #define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
+#define get_irq_stack_end()	(unsigned long)this_cpu_read(irq_stack_ptr)
 #endif
 
 #ifdef CONFIG_FRAME_POINTER
Index: work/arch/x86/kernel/stacktrace.c
===================================================================
--- work.orig/arch/x86/kernel/stacktrace.c
+++ work/arch/x86/kernel/stacktrace.c
@@ -81,6 +81,46 @@ void save_stack_trace_tsk(struct task_st
 }
 EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
 
+#ifdef CONFIG_FRAME_POINTER
+void save_stack_trace_quick(struct stack_trace *trace)
+{
+	const unsigned long stk_sz = THREAD_SIZE - sizeof(struct stack_frame);
+	unsigned long tstk = (unsigned long)current_thread_info();
+	unsigned long istk = get_irq_stack_end();
+	unsigned long last_bp = 0;
+	unsigned long bp, stk;
+
+	get_bp(bp);
+
+	if (bp > tstk && bp <= tstk + stk_sz)
+		stk = tstk;
+	else if (istk && (bp > istk && bp <= stk_sz))
+		stk = istk;
+	else
+		goto out;
+
+	while (bp > last_bp && bp <= stk + stk_sz) {
+		struct stack_frame *frame = (struct stack_frame *)bp;
+		unsigned long ret_addr = frame->return_address;
+
+		if (!trace->skip) {
+			if (trace->nr_entries >= trace->max_entries)
+				return;
+			trace->entries[trace->nr_entries++] = ret_addr;
+		} else {
+			trace->skip--;
+		}
+
+		last_bp = bp;
+		bp = (unsigned long)frame->next_frame;
+	}
+out:
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
+}
+EXPORT_SYMBOL_GPL(save_stack_trace_quick);
+#endif
+
 /* Userspace stacktrace - based on kernel/trace/trace_sysprof.c */
 
 struct stack_frame_user {
Index: work/include/linux/fdr.h
===================================================================
--- /dev/null
+++ work/include/linux/fdr.h
@@ -0,0 +1,181 @@
+/*
+ * fdr.h - flight data recorder (for refcnt debugging)
+ *
+ * Copyright (c) 2011 Google, Inc.
+ * Copyright (c) 2011 Tejun Heo <tj@kernel.org>
+ *
+ * This is a debugging facility to record events with backtrace and later
+ * lookup and dump them when an anomaly is detected.  This is especially
+ * useful for tracking down reference count problems.  By the time symptoms
+ * of refcnt bugs can be detected, there usually is no record of who caused
+ * the original problem how.  FDR can retain the history of refcnt related
+ * operations and dump it later when something looks fishy.
+ *
+ * Let's say buggy_struct is reference counted and my_buggy_function()
+ * operates on it.  Because of a suspected reference double put bug,
+ * my_buggy_function() is passed a pointer to already freed buggy_struct
+ * and ends up tripping oops when it tries to dereference a pointer in the
+ * struct.
+ *
+ * The following pseudo code shows how to instrument it using FDR.  It will
+ * record the latest 64 events per buggy_struct and retain the latest 4096
+ * finished recordings.  buggy_function() triggers FDR_DUMP_ON() if pointer
+ * dereference can't be made, in which case FDR will go through the records
+ * and print out the recorded events for the buggy_struct.
+ *
+ * Note that FDR_DUMP_ON() doesn't care why buggy_struct or its FDR
+ * contains at that point.  The pointer is used only as key to retrieve the
+ * matching record.
+ *
+ *  #define MY_FDR_NR_EVENTS	64
+ *  #define MY_FDR_NR_RECORDS	4096
+ *
+ *  struct buggy_struct {
+ *	...
+ *	DECLARE_FDR_FIELD(fdr, MY_FDR_NR_EVENTS);
+ *	...
+ *  };
+ *
+ *  static struct fdr_type *my_fdr_type;
+ *
+ *  static void buggy_struct_init(struct buggy_struct *buggy)
+ *  {
+ *	...
+ *	fdr_init(&buggy->fdr, my_fdr_type);			// rec'd as 0xfe
+ *	...
+ *  }
+ *
+ *  static void buggy_inc_ref(struct buggy_struct *buggy)
+ *  {
+ *	...
+ *	fdr_event(0x00, 1, &buggy->fdr, my_fdr_type);		// inc is 0x00
+ *	...
+ *  }
+ *
+ *  static void buggy_dec_ref(struct buggy_struct *buggy)
+ *  {
+ *	...
+ *	if (refcnt still above zero) {
+ *		fdr_event(0x10, 1, &buggy->fdr, my_fdr_type);	// dec is 0x10
+ *		return;
+ *	}
+ *	fdr_finish(&buggy->fdr, my_fdr_type);			// rec'd as 0xff
+ *	destroy(buggy);
+ *  }
+ *
+ *  static void buggy_function(struct buggy_struct *buggy)
+ *  {
+ *	char buf[sizeof(*buggy->ptr)];
+ *	...
+ *	FDR_DUMP_ON(probe_kernel_read(buf, buggy->ptr, sizeof(buf)) < 0,
+ *		    &buggy->fdr, my_fdr_type);
+ *	...
+ *  }
+ *
+ *  static int __init buggy_subsys_init(void)
+ *  {
+ *	...
+ *	my_fdr_type = fdr_create_type(MY_FDR_NR_EVENTS, MY_FDR_NR_RECORDS);
+ *	...
+ *  }
+ *
+ * When the dump condition triggers, FDR prints out something like the
+ * following which shows the recorded events in the reverse chronological
+ * order revealing how the reference has been updated from where.
+ *
+ *  Dumping FDR ffff880019df0ac0 at test-fdr.c:85, stor_seq 1
+ *  Record finished 4.492s ago w/ seq 20
+ *    #00: FINI +4.900s stk4
+ *         buggy_put_setfn+0x4c/0x60 [test_fdr]
+ *         simple_attr_write+0xdb/0xf0
+ *         vfs_write+0xc8/0x180
+ *         sys_write+0x51/0x90
+ *         system_call_fastpath+0x16/0x1b
+ *    #01: 0x10 +0.800s stk4
+ *         buggy_put_setfn+0x4c/0x60 [test_fdr]
+ *         simple_attr_write+0xdb/0xf0
+ *         vfs_write+0xc8/0x180
+ *         sys_write+0x51/0x90
+ *         system_call_fastpath+0x16/0x1b
+ *    #02: 0x00 +1.100s stk3
+ *         buggy_get_setfn+0x4c/0x60 [test_fdr]
+ *         simple_attr_write+0xdb/0xf0
+ *         vfs_write+0xc8/0x180
+ *         sys_write+0x51/0x90
+ *         system_call_fastpath+0x16/0x1b
+ *    ...
+ */
+#ifndef _LINUX_FDR_H
+#define _LINUX_FDR_H
+
+#ifdef CONFIG_FDR
+
+struct fdr_type;
+struct fdr;
+
+#include <linux/spinlock.h>
+
+/* fdr_init/finish() are automatically recorded with the following @data */
+#define FDR_EVENT_DATA_INIT	0xfe
+#define FDR_EVENT_DATA_FINI	0xff
+
+/* each event takes 4 bytes */
+struct fdr_event {
+	u8		data;		/* FDR_EVENT_DATA_* or user supplied */
+	u8		time_delta;	/* time delta since the last event */
+	u16		stack_id;	/* recorded backtrace */
+};
+
+/*
+ * The recorder.  Embedded into the target data structure to be tracked
+ * using DECLARE_FDR_FIELD() macro.
+ */
+struct fdr {
+	spinlock_t		lock;	/* lock, maybe combine with seq? */
+	u32			seq;	/* event sequence number */
+	u32			jiffies_32; /* timestamp of the last event */
+	struct fdr_event	events[];   /* storage for event recording */
+};
+
+/* macro to declare FDR field in the target data structure */
+#define DECLARE_FDR_FIELD(field, nr_events)				\
+	struct fdr field; struct fdr_event __fdr_event_##field[nr_events]
+
+struct fdr_type *fdr_create_type(int nr_events, int nr_records);
+void fdr_destroy_type(struct fdr_type *type);
+
+void fdr_init(struct fdr *fdr, struct fdr_type *type);
+void fdr_event(u8 data, int stack_skip, struct fdr *fdr, struct fdr_type *type);
+void fdr_finish(struct fdr *fdr, struct fdr_type *type);
+void __fdr_dump(const struct fdr *fdr_addr, struct fdr_type *type,
+		const char *file, int line);
+
+/*
+ * Dump records for @fdr_addr of @type if @cond is %true.  Note that
+ * @fdr_addr is never dereferenced.  Also, only records of finished FDRs
+ * are considered.
+ */
+#define FDR_DUMP_ON(cond, fdr_addr, type)	do {			\
+	if (cond)							\
+		__fdr_dump((fdr_addr), (type), __FILE__, __LINE__);	\
+	} while (0)
+
+#else  /* CONFIG_FDR */
+
+struct fdr;
+
+#define DECLARE_FDR_FIELD(field, nr_events)
+
+static struct fdr_type *fdr_create_type(int nr_events, int nr_records)
+{ return NULL; }
+static inline void fdr_destroy_type(struct fdr_type *type) { }
+
+static inline void fdr_init(struct fdr *fdr, struct fdr_type *type) { }
+static inline void fdr_rec_event(u8 data, int stack_skip, struct fdr *fdr,
+				 struct fdr_type *type) { }
+static inline void fdr_rec_finish(struct fdr *fdr, struct fdr_type *type) { }
+
+#define FDR_DUMP_ON(cond, fdr_addr, type)	do { } while (0)
+
+#endif /* CONFIG_FDR */
+#endif /*_LINUX_FDR_H*/
Index: work/lib/Kconfig.debug
===================================================================
--- work.orig/lib/Kconfig.debug
+++ work/lib/Kconfig.debug
@@ -374,6 +374,13 @@ config DEBUG_OBJECTS_ENABLE_DEFAULT
         help
           Debug objects boot parameter default value
 
+config FDR
+	bool "Flight data recorder (for refcnt debugging)"
+	depends on DEBUG_KERNEL
+	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE
+	help
+	  If you're lost in refcounting hell without any hope.
+
 config DEBUG_SLAB
 	bool "Debug slab memory allocations"
 	depends on DEBUG_KERNEL && SLAB && !KMEMCHECK
Index: work/lib/Makefile
===================================================================
--- work.orig/lib/Makefile
+++ work/lib/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_BTREE) += btree.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
+obj-$(CONFIG_FDR) += fdr.o
 
 ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
   lib-y += dec_and_lock.o
Index: work/lib/fdr.c
===================================================================
--- /dev/null
+++ work/lib/fdr.c
@@ -0,0 +1,435 @@
+/*
+ * lib/fdr.c - flight data recorder (for refcnt debugging)
+ *
+ * Copyright (c) 2011 Google, Inc.
+ * Copyright (c) 2011 Tejun Heo <tj@kernel.org>
+ *
+ * Read comment at the top of include/linux/fdr.h for details.
+ */
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+#include <linux/rculist.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/idr.h>
+#include <linux/jhash.h>
+#include <linux/kallsyms.h>
+#include <linux/stacktrace.h>
+#include <linux/fdr.h>
+
+#define FDR_MAX_STACK_DEPTH	32
+#define FDR_MAX_STACKS		USHRT_MAX
+#define FDR_STACK_HASH_SIZE	(FDR_MAX_STACKS >> 2)
+
+struct fdr_stack {
+	struct hlist_node	hash_node;
+	u16			id;
+	int			depth;
+	unsigned long		trace[];
+};
+
+struct fdr_stor_ent {
+	const struct fdr	*key;
+	u32			seq;
+	u32			jiffies_32;
+	struct fdr_event	events[];
+};
+
+struct fdr_type {
+	int			nr_events;
+	int			nr_records;
+	u64			stor_seq;
+	char			stor[];
+};
+
+static DEFINE_MUTEX(fdr_type_mutex);
+static int nr_fdr_types;
+
+static DEFINE_SPINLOCK(fdr_lock);
+static DEFINE_IDR(fdr_stack_idr);
+static struct hlist_head fdr_stack_hash[FDR_STACK_HASH_SIZE] =
+	{ [0 ... FDR_STACK_HASH_SIZE - 1] = HLIST_HEAD_INIT };
+
+static size_t fdr_evt_size(int nr_events)
+{
+	return nr_events * sizeof(struct fdr_event);
+}
+
+static size_t fdr_stor_ent_size(int nr_events)
+{
+	return ALIGN(sizeof(struct fdr_stor_ent) + fdr_evt_size(nr_events),
+		     __alignof__(struct fdr_stor_ent));
+}
+
+static struct fdr_stor_ent *fdr_stor_ent(int idx, struct fdr_type *type)
+{
+	return (void *)type->stor + idx * fdr_stor_ent_size(type->nr_events);
+}
+
+/**
+ * fdr_create_type - create a fdr_type
+ * @nr_events: number of events to record per fdr
+ * @nr_records: number of finished fdr's to store
+ *
+ * Create a fdr_type.  May sleep.
+ */
+struct fdr_type *fdr_create_type(int nr_events, int nr_records)
+{
+	struct fdr_type *type;
+	size_t ent_sz = fdr_stor_ent_size(nr_events);
+	size_t type_sz = sizeof(*type) + nr_records * ent_sz;
+
+	type = vzalloc(type_sz);
+	if (type) {
+		type->nr_events = nr_events;
+		type->nr_records = nr_records;
+
+		mutex_lock(&fdr_type_mutex);
+		nr_fdr_types++;
+		mutex_unlock(&fdr_type_mutex);
+	}
+	return type;
+}
+EXPORT_SYMBOL_GPL(fdr_create_type);
+
+/**
+ * fdr_destroy_type - destory a fdr_type
+ * @type: fdr_type to destroy
+ *
+ * Destroy @type.  May sleep.
+ */
+void fdr_destroy_type(struct fdr_type *type)
+{
+	vfree(type);
+
+	mutex_lock(&fdr_type_mutex);
+
+	if (!--nr_fdr_types) {
+		struct fdr_stack *stack;
+		int cursor = 0;
+
+		/*
+		 * There's no fdr_type left, nobody could be accessing the
+		 * stack idr and hashtable.  Destroy them.
+		 */
+		while ((stack = idr_get_next(&fdr_stack_idr, &cursor))) {
+			idr_remove(&fdr_stack_idr, stack->id);
+			hlist_del_init(&stack->hash_node);
+			kfree(stack);
+		}
+		idr_destroy(&fdr_stack_idr);
+		idr_init(&fdr_stack_idr);
+
+		/*
+		 * Make sure grace period has passed before the idr and
+		 * hashtable are used again.
+		 */
+		synchronize_sched();
+	}
+
+	mutex_unlock(&fdr_type_mutex);
+}
+EXPORT_SYMBOL_GPL(fdr_destroy_type);
+
+static struct fdr_stack *fdr_hash_head_lookup(int depth, unsigned long *trace,
+					      struct hlist_head *hash_head)
+{
+	struct hlist_node *pos;
+	struct fdr_stack *stack;
+
+	hlist_for_each_entry_rcu(stack, pos, hash_head, hash_node)
+		if (stack->depth == depth &&
+		    !memcmp(stack->trace, trace, depth * sizeof(trace[0])))
+			return stack;
+	return NULL;
+}
+
+/* call w/ irq disabled */
+static u16 fdr_get_stack_id(int skip)
+{
+	static DEFINE_PER_CPU(unsigned long [FDR_MAX_STACK_DEPTH], trace_pcpu);
+	unsigned long *trace = *this_cpu_ptr(&trace_pcpu);
+	struct stack_trace st = { .max_entries = FDR_MAX_STACK_DEPTH,
+				  .entries = trace, .skip = skip };
+	unsigned long hash;
+	struct hlist_head *hash_head;
+	struct fdr_stack *stack;
+	int id = 0, depth;
+
+	WARN_ON_ONCE(!irqs_disabled());
+
+	/* acquire stack trace, ignore -1LU end of stack marker */
+	save_stack_trace_quick(&st);
+	if (st.nr_entries && trace[st.nr_entries - 1] == ULONG_MAX)
+		st.nr_entries--;
+	depth = st.nr_entries;
+
+	hash = jhash(trace, depth * sizeof(trace[0]), JHASH_INITVAL);
+	hash_head = &fdr_stack_hash[hash % FDR_STACK_HASH_SIZE];
+	stack = fdr_hash_head_lookup(depth, trace, hash_head);
+	if (stack)
+		return stack->id;
+
+	/* create a new one */
+	spin_lock(&fdr_lock);
+
+	/* did someone else do it already? */
+	stack = fdr_hash_head_lookup(depth, trace, hash_head);
+	if (stack)
+		goto out_unlock;
+
+	if (!idr_pre_get(&fdr_stack_idr, GFP_NOIO))
+		goto out_unlock;
+
+	stack = kmalloc(sizeof(*stack) + depth * sizeof(trace[0]), GFP_NOWAIT);
+	if (!stack)
+		goto out_unlock;
+
+	if (idr_get_new_above(&fdr_stack_idr, stack, 2, &id) < 0 ||
+	    WARN_ON_ONCE(id >= FDR_MAX_STACKS)) {
+		if (id)
+			idr_remove(&fdr_stack_idr, id);
+		kfree(stack);
+		stack = NULL;
+		goto out_unlock;
+	}
+
+	/* init and hash */
+	stack->id = id;
+	stack->depth = depth;
+	memcpy(stack->trace, trace, depth * sizeof(trace[0]));
+	hlist_add_head_rcu(&stack->hash_node, hash_head);
+
+out_unlock:
+	spin_unlock(&fdr_lock);
+	return stack ? stack->id : 1;
+}
+
+/**
+ * fdr_init - initialize FDR
+ * @fdr: FDR to init
+ * @type: @fdr's type
+ *
+ * Initialize @fdr and record init event.
+ */
+void fdr_init(struct fdr *fdr, struct fdr_type *type)
+{
+	memset(fdr, 0, sizeof(*fdr) + fdr_evt_size(type->nr_events));
+	spin_lock_init(&fdr->lock);
+	fdr->jiffies_32 = jiffies;
+
+	/* record init event */
+	fdr_event(FDR_EVENT_DATA_INIT, 2, fdr, type);
+}
+EXPORT_SYMBOL_GPL(fdr_init);
+
+/*
+ * msecs <-> tdelta conversions.
+ *
+ * This is to encode reasonable amount of time delta in u8.
+ *
+ * [0, 99ms]		: recorded in millisecs
+ * (99ms, 9.9s]		: recorded in decisecs (0.1s)
+ * (9.9s, 540s]		: recorded in decasecs (10s)
+ * (540s, inf.)		: recorded as eternity!
+ */
+static u8 fdr_msecs_to_tdelta(unsigned long msecs)
+{
+	unsigned long mili = msecs;
+	unsigned long deci = mili / 100;
+	unsigned long deca = deci / 100;
+
+	if (mili < 100)
+		return msecs;
+	if (deci < 100)
+		return 100 + deci;
+	if (deca < 255)
+		return 200 + deca;
+	return 255;
+}
+
+static unsigned long fdr_tdelta_to_msecs(u8 tdelta)
+{
+	if (tdelta < 100)
+		return tdelta;
+	if (tdelta < 200)
+		return (tdelta - 100) * 100;
+	if (tdelta < 255)
+		return (tdelta - 200) * 10000;
+	return ULONG_MAX;
+}
+
+static void fdr_format_msecs(unsigned long msecs, unsigned long max_msecs,
+			     char *buf, size_t len)
+{
+	if (msecs < ULONG_MAX)
+		snprintf(buf, len, "%lu.%03lus", msecs / 1000, msecs % 1000);
+	else
+		snprintf(buf, len, "> %lus", max_msecs / 1000);
+}
+
+/**
+ * fdr_event - record an event into FDR
+ * @data: arbitrary 8bit data for the event
+ * @stack_skip: number of frames to skip when acquire stack trace
+ * @fdr: FDR to record event into
+ * @type: @fdr's type
+ *
+ * Record an event w/ @data and stack trace into @fdr.  Can be called from
+ * any context.
+ */
+noinline void fdr_event(u8 data, int stack_skip, struct fdr *fdr,
+			struct fdr_type *type)
+{
+	struct fdr_event *evt;
+	unsigned long msecs, tdelta;
+	unsigned long flags;
+	u32 now = jiffies;
+	u16 stack_id;
+
+	if (unlikely(!type))
+		return;
+
+	spin_lock_irqsave(&fdr->lock, flags);
+
+	/* find stackid */
+	stack_id = fdr_get_stack_id(stack_skip + 1);
+
+	/* determine time delta */
+	msecs = jiffies_to_msecs(now - fdr->jiffies_32);
+	tdelta = fdr_msecs_to_tdelta(msecs);
+	fdr->jiffies_32 = now;
+
+	/* record evt and update fdr */
+	evt = &fdr->events[fdr->seq++ % type->nr_events];
+	evt->data = data;
+	evt->time_delta = tdelta;
+	evt->stack_id = stack_id;
+
+	spin_unlock_irqrestore(&fdr->lock, flags);
+}
+EXPORT_SYMBOL_GPL(fdr_event);
+
+/**
+ * fdr_finish - finish up FDR
+ * @fdr: FDR to finish
+ * @type: @fdr's type
+ *
+ * Transfer @fdr's data into @type's storage.  After this function returns,
+ * @fdr can be freed or reused for other purposes.
+ */
+void fdr_finish(struct fdr *fdr, struct fdr_type *type)
+{
+	struct fdr_stor_ent *fse;
+	unsigned long flags;
+	int idx;
+
+	if (unlikely(!type))
+		return;
+
+	/* record finish event */
+	fdr_event(FDR_EVENT_DATA_FINI, 2, fdr, type);
+
+	/* transfer to storage */
+	spin_lock_irqsave(&fdr_lock, flags);
+
+	idx = type->stor_seq++ % type->nr_records;
+	fse = fdr_stor_ent(idx, type);
+
+	fse->key = fdr;
+	fse->seq = fdr->seq;
+	fse->jiffies_32 = jiffies;
+	memcpy(fse->events, fdr->events, fdr_evt_size(type->nr_events));
+
+	spin_unlock_irqrestore(&fdr_lock, flags);
+}
+EXPORT_SYMBOL_GPL(fdr_finish);
+
+static int fdr_prev_idx(u64 idx, int nr_entries)
+{
+	idx %= nr_entries;
+	return idx ? idx - 1 : nr_entries - 1;
+}
+
+static void fdr_dump_one(struct fdr_stor_ent *fse, struct fdr_type *type)
+{
+	u32 now = jiffies;
+	int idx, end, cnt = 0;
+	char time_buf[32], data_buf[5];
+
+	fdr_format_msecs(jiffies_to_msecs(now - fse->jiffies_32),
+			 jiffies_to_msecs(UINT_MAX),
+			 time_buf, sizeof(time_buf));
+
+	pr_warning("Record finished %s ago w/ seq %u\n", time_buf, fse->seq);
+
+	idx = end = fdr_prev_idx(fse->seq, type->nr_events);
+	do {
+		struct fdr_event *evt = &fse->events[idx];
+		unsigned long msecs;
+		int i;
+
+		if (!evt->stack_id)
+			break;
+
+		if (evt->data == FDR_EVENT_DATA_INIT)
+			strncpy(data_buf, "INIT", sizeof(data_buf));
+		else if (evt->data == FDR_EVENT_DATA_FINI)
+			strncpy(data_buf, "FINI", sizeof(data_buf));
+		else
+			snprintf(data_buf, sizeof(data_buf),
+				 "0x%02x", evt->data);
+
+		msecs = fdr_tdelta_to_msecs(evt->time_delta);
+		fdr_format_msecs(msecs, fdr_tdelta_to_msecs(254), time_buf,
+				 sizeof(time_buf));
+
+		pr_warning("  #%02d: %s +%s stk%d\n",
+			   cnt++, data_buf, time_buf, evt->stack_id);
+
+		if (evt->stack_id == 1) {
+			pr_warning("       (unknown)\n");
+		} else {
+			struct fdr_stack *stack =
+				idr_find(&fdr_stack_idr, evt->stack_id);
+
+			for (i = 0; i < stack->depth; i++)
+				pr_warning("       %pF\n",
+					   (void *)stack->trace[i]);
+		}
+	} while ((idx = fdr_prev_idx(idx, type->nr_events)) != end);
+}
+
+/**
+ * __fdr_dump - dump FDR recordings
+ * @fdr_addr: address of FDR to dump
+ * @type: fdr_type @fdr_addr was associated with
+ * @file: the calling file
+ * @line: the calling line
+ *
+ * Dump recordings for finished FDRs which were at @fdr_addr.  Note that
+ * @fdr_addr is never dereferenced.  Can be called from any context.
+ */
+void __fdr_dump(const struct fdr *fdr_addr, struct fdr_type *type,
+		const char *file, int line)
+{
+	unsigned long flags;
+	int idx, end;
+
+	pr_warning("Dumping FDR %p at %s:%d, stor_seq %llu\n",
+		   fdr_addr, file, line, type->stor_seq);
+
+	spin_lock_irqsave(&fdr_lock, flags);
+
+	idx = end = fdr_prev_idx(type->stor_seq, type->nr_records);
+	do {
+		struct fdr_stor_ent *fse = fdr_stor_ent(idx, type);
+
+		if (fse->key == fdr_addr)
+			fdr_dump_one(fse, type);
+	} while ((idx = fdr_prev_idx(idx, type->nr_records)) != end);
+
+	spin_unlock_irqrestore(&fdr_lock, flags);
+}
+EXPORT_SYMBOL_GPL(__fdr_dump);
