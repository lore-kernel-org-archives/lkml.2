Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874Ab0JFUIv convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Wed, 6 Oct 2010 16:08:51 -0400
Received: from mail.candelatech.com ([208.74.158.172]:57389 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759700Ab0JFUIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:08:49 -0400
From: greearb@candelatech.com
To: linux-kernel@vger.kernel.org
Cc: cl@linux.com, Ben Greear <greearb@candelatech.com>
Subject: [RFC] slub:  Enable backtrace for create/delete points.
Date: Wed,  6 Oct 2010 13:08:43 -0700
Message-Id: <1286395723-28271-1-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from QUOTED-PRINTABLE to 8bit by mail.home.local id o96KA0D8026289

From: Ben Greear <greearb@candelatech.com>

This patch attempts to grab a backtrace for the creation
and deletion points of the slub object.  When a fault is
detected, we can then get a better idea of where the item
was deleted.

This probably only works on 32-bit x86, and probably breaks
compiles on other architectures..so it's just RFC at this point.

Example slub debugging output:

=============================================================================
BUG kmalloc-8192: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xf576c1a0-0xf576c30f. First byte 0x50 instead of 0x6b
INFO: Allocated in ath_rxbuf_alloc+0x1d/0x74 [ath] age=10567 cpu=0 pid=0
	set_track+0x3c/0x89
	__slab_alloc+0x353/0x3dd
	ath_rxbuf_alloc+0x1d/0x74 [ath]
	mark_held_locks+0x47/0x5f
	kmem_cache_alloc+0xa0/0xc5
	__kmalloc_track_caller+0xa1/0xf2
	ath_rxbuf_alloc+0x1d/0x74 [ath]
	ath_rxbuf_alloc+0x1d/0x74 [ath]
	__alloc_skb+0x58/0xf4
	ath_rxbuf_alloc+0x1d/0x74 [ath]
	ath_rx_tasklet+0x765/0x130e [ath9k]
	ath9k_tasklet+0x9a/0x12a [ath9k]
	tasklet_action+0x73/0xc6
	__do_softirq+0x86/0x111
INFO: Freed in skb_release_data+0x8c/0x90 age=19 cpu=0 pid=5084
	set_track+0x3c/0x89
	__slab_free+0x17f/0x1ba
	skb_release_data+0x8c/0x90
	kfree+0xaf/0xdf
	skb_release_data+0x8c/0x90
	skb_release_data+0x8c/0x90
	skb_release_data+0x8c/0x90
	__kfree_skb+0x12/0x6d
	consume_skb+0x2a/0x2c
	ieee80211_rx+0x74d/0x7b2 [mac80211]
	__kmalloc_track_caller+0xcd/0xf2
	trace_hardirqs_on_caller+0xeb/0x125
	ath_rx_send_to_mac80211+0x5a/0x60 [ath9k]
	trace_hardirqs_on+0xb/0xd
INFO: Slab 0xc1ba2d00 objects=3 used=2 fp=0xf576c150 flags=0x400040c1
INFO: Object 0xf576c150 @offset=16720 fp=0x(null)

Bytes b4 0xf576c140:  00 00 00 00 5c 75 fc ff 5a 5a 5a 5a 5a 5a 5a 5a ....\u��ZZZZZZZZ
  Object 0xf576c150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf576c160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
...

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 2b16a2a... 2a405b2... M	arch/x86/include/asm/stacktrace.h
:100644 100644 6e8752c... 838fdc4... M	arch/x86/kernel/dumpstack.c
:100644 100644 0f6376ff.. e206e3c... M	arch/x86/kernel/dumpstack_32.c
:100644 100644 2b0a35e... eb608de... M	include/linux/kernel.h
:100644 100644 13fffe1... 0bf46edb.. M	mm/slub.c
 arch/x86/include/asm/stacktrace.h |   10 +++++++
 arch/x86/kernel/dumpstack.c       |   46 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/dumpstack_32.c    |   48 +++++++++++++++++++++++++++++++++++++
 include/linux/kernel.h            |    1 +
 mm/slub.c                         |   28 ++++++++++++++++-----
 5 files changed, 126 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 2b16a2a..2a405b2 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -28,6 +28,12 @@ print_context_stack(struct thread_info *tinfo,
 		    unsigned long *end, int *graph);
 
 extern unsigned long
+store_context_stack(unsigned long *addrs, int *addrslen,
+		    struct thread_info *tinfo,
+		    unsigned long *stack, unsigned long bp,
+		    unsigned long *end);
+
+extern unsigned long
 print_context_stack_bp(struct thread_info *tinfo,
 		       unsigned long *stack, unsigned long bp,
 		       const struct stacktrace_ops *ops, void *data,
@@ -49,6 +55,10 @@ void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data);
 
+void store_trace(unsigned long *addrs, int *addrslen,
+		 struct task_struct *task, struct pt_regs *regs,
+		 unsigned long *stack, unsigned long bp);
+
 #ifdef CONFIG_X86_32
 #define STACKSLOTS_PER_LINE 8
 #define get_bp(bp) asm("movl %%ebp, %0" : "=r" (bp) :)
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 6e8752c..838fdc4 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -111,6 +111,35 @@ print_context_stack(struct thread_info *tinfo,
 EXPORT_SYMBOL_GPL(print_context_stack);
 
 unsigned long
+store_context_stack(unsigned long *addrs, int *addrslen,
+		    struct thread_info *tinfo,
+		    unsigned long *stack, unsigned long bp,
+		    unsigned long *end)
+{
+	struct stack_frame *frame = (struct stack_frame *)bp;
+	int i = 0;
+
+	while ((*addrslen > 0) &&
+	       valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
+	       unsigned long addr = *stack;
+
+	       if (__kernel_text_address(addr)) {
+			addrs[i] = addr;
+			(*addrslen)--;
+			i++;
+			if ((unsigned long) stack == bp + sizeof(long)) {
+				frame = frame->next_frame;
+				bp = (unsigned long) frame;
+			}
+		}
+
+		stack++;
+	}
+	return bp;
+}
+EXPORT_SYMBOL_GPL(store_context_stack);
+
+unsigned long
 print_context_stack_bp(struct thread_info *tinfo,
 		       unsigned long *stack, unsigned long bp,
 		       const struct stacktrace_ops *ops, void *data,
@@ -214,6 +243,23 @@ void dump_stack(void)
 }
 EXPORT_SYMBOL(dump_stack);
 
+/*
+ * The architecture-independent dump_stack generator
+ */
+void store_stack(unsigned long *addrs, int *addrslen)
+{
+	unsigned long bp = 0;
+	unsigned long stack;
+
+#ifdef CONFIG_FRAME_POINTER
+	if (!bp)
+		get_bp(bp);
+#endif
+
+	store_trace(addrs, addrslen, NULL, NULL, &stack, bp);
+}
+EXPORT_SYMBOL(store_stack);
+
 static arch_spinlock_t die_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 static int die_owner = -1;
 static unsigned int die_nest_count;
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 0f6376ff..e206e3c 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -63,6 +63,54 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 }
 EXPORT_SYMBOL(dump_trace);
 
+void store_trace(unsigned long *addrs, int *addrslen,
+		 struct task_struct *task, struct pt_regs *regs,
+		 unsigned long *stack, unsigned long bp)
+{
+	int idx = 0;
+
+	if (!task)
+		task = current;
+
+	if (!stack) {
+		unsigned long dummy;
+
+		stack = &dummy;
+		if (task && task != current)
+			stack = (unsigned long *)task->thread.sp;
+	}
+
+#ifdef CONFIG_FRAME_POINTER
+	if (!bp) {
+		if (task == current) {
+			/* Grab bp right from our regs */
+			get_bp(bp);
+		} else {
+			/* bp is the last reg pushed by switch_to */
+			bp = *(unsigned long *) task->thread.sp;
+		}
+	}
+#endif
+
+	for (;;) {
+		struct thread_info *context;
+		int alen = *addrslen;
+
+		context = (struct thread_info *)
+			((unsigned long)stack & (~(THREAD_SIZE - 1)));
+		bp = store_context_stack(addrs + idx, addrslen,
+					 context, stack, bp,  NULL);
+		idx += (alen - *addrslen);
+		if (*addrslen == 0)
+			break;
+
+		stack = (unsigned long *)context->previous_esp;
+		if (!stack)
+			break;
+	}
+}
+EXPORT_SYMBOL(store_trace);
+
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		   unsigned long *sp, unsigned long bp, char *log_lvl)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2b0a35e..eb608de 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -369,6 +369,7 @@ extern enum system_states {
 #define TAINT_FIRMWARE_WORKAROUND	11
 
 extern void dump_stack(void) __cold;
+extern void store_stack(unsigned long *addrs, int *addrslen) __cold;
 
 enum {
 	DUMP_PREFIX_NONE,
diff --git a/mm/slub.c b/mm/slub.c
index 13fffe1..0bf46edb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -190,8 +190,9 @@ static LIST_HEAD(slab_caches);
 /*
  * Tracking user of a slab.
  */
+#define TRACK_ADDRS_COUNT 16
 struct track {
-	unsigned long addr;	/* Called from address */
+	unsigned long addrs[TRACK_ADDRS_COUNT];	/* Called from address */
 	int cpu;		/* Was running on cpu */
 	int pid;		/* Pid context */
 	unsigned long when;	/* When did the operation occur */
@@ -370,7 +371,14 @@ static void set_track(struct kmem_cache *s, void *object,
 	struct track *p = get_track(s, object, alloc);
 
 	if (addr) {
-		p->addr = addr;
+		int ln = TRACK_ADDRS_COUNT - 1;
+		int idx;
+		p->addrs[0] = addr;
+		store_stack(p->addrs + 1, &ln);
+		/* ln is 'remaining' slots available upon return */
+		for (idx = (TRACK_ADDRS_COUNT - 1) - ln;
+		     idx < TRACK_ADDRS_COUNT; idx++)
+			p->addrs[idx] = 0;
 		p->cpu = smp_processor_id();
 		p->pid = current->pid;
 		p->when = jiffies;
@@ -389,11 +397,17 @@ static void init_tracking(struct kmem_cache *s, void *object)
 
 static void print_track(const char *s, struct track *t)
 {
-	if (!t->addr)
+	int i;
+	if (!t->addrs[0])
 		return;
 
 	printk(KERN_ERR "INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
-		s, (void *)t->addr, jiffies - t->when, t->cpu, t->pid);
+		s, (void *)t->addrs[0], jiffies - t->when, t->cpu, t->pid);
+	for (i = 1; i < TRACK_ADDRS_COUNT; i++)
+		if (t->addrs[i])
+			printk(KERN_ERR "\t%pS\n", (void *)t->addrs[i]);
+		else
+			break;
 }
 
 static void print_tracking(struct kmem_cache *s, void *object)
@@ -3579,7 +3593,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 			break;
 
 		caddr = t->loc[pos].addr;
-		if (track->addr == caddr) {
+		if (track->addrs[0] == caddr) {
 
 			l = &t->loc[pos];
 			l->count++;
@@ -3602,7 +3616,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 			return 1;
 		}
 
-		if (track->addr < caddr)
+		if (track->addrs[0] < caddr)
 			end = pos;
 		else
 			start = pos;
@@ -3620,7 +3634,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 			(t->count - pos) * sizeof(struct location));
 	t->count++;
 	l->count = 1;
-	l->addr = track->addr;
+	l->addr = track->addrs[0];
 	l->sum_time = age;
 	l->min_time = age;
 	l->max_time = age;
-- 
1.7.2.2

