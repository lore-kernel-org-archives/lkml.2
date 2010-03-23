Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0CWRZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:25:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:20948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0CWRZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:25:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=ZwtrqKQdHNpRoIYxSe/64WAuhIjyTV9/S4bJZV/EYaMTAFgLhs2U3rdxyax9Vr/o3
	fCEfU6bLTorJsBJuc1IGA==
Message-ID: <4ba8f988.9804cc0a.4b1f.5d77@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 23 Mar 2010 18:25:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf_events: fix remapped count support
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch fixes the remapped counter support such that it now works
	on X86 processors.

	There were several issues:

	- needed a way to allow (permission) user level read (via RDPMC on x86)
	- there was no way of scaling the count correctly
	- values returned by RDPMC and prev_count did not have the same "sign" extensions
	- did work with Intel X86 fixed counters

	This patch adds a new sysctl control:
		/proc/sys/kernel/perf_event_paranoid_user_read

	It is set by default. You must clear it to allow direct user read.
	I chose not to include this in perf_event_paranoid because the priority there
	did not make sense w.r.t to this particular control point. It would have required
	an ABI change, i.e, changing the meaning of the existing values. The fact that
	we may want to restrict user read is independent of trace points, or system-wide
	monitoring.

	The patch adds a new field to the perf_mmap_page buffer header (delta_base).
	It is necessary to correctly scale the count. This new value represents the
	counter value when the event was last scheduled in. It cannot be substracted
	by the kernel from the total count because of scaling. The correct formula is:

		 count = offset * time_enabled/time_running + (raw_count - prev_count)

	We expose prev_count. The rest was already there. We also correct prev_count
	to allow the substraction to work. On X86 (and possibly others), the user read
	instruction (RDPMC) returns the N-bit count where N is the counter width, the
	upper bits are zeroed. But prev_count is always a 64-bit negative number.
	To avoid having to expose the raw counter width, the kernel now adjusts the
	prev_count value exposed in perf_mmap_page to have only N-bit worth of data.

	User read support on X86 is implemented for AMD processors, Intel X86 processors
	except Pentium 4. I know it is also supported there, but I don't have a machine
	to test this on. A specific patch will be submitted later on.

	For other architectures, e.g., PPC, SPARC, assuming they do offer the ability
	to read counts directly from user space, all that is needed is a couple of new
	arch specific functions:
		- hw_perf_event_counter_width(): actual counter width
		- hw_perf_event_index(): register index to pass to the user instruction
		- hw_perf_update_user_read_perm(): toggle permission to read from userspace
	
	Signed-off-by: Stephane Eranian <eranian@google.com>
--
 arch/x86/include/asm/perf_event.h      |    2 -
 arch/x86/kernel/cpu/perf_event.c       |   39 ++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_amd.c   |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +
 arch/x86/kernel/cpu/perf_event_p6.c    |    7 +++
 include/linux/perf_event.h             |   15 ++++++-
 kernel/perf_event.c                    |   63 +++++++++++++++++++++++++++++----
 kernel/sysctl.c                        |    7 +++
 8 files changed, 126 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 124dddd..8e1c067 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -134,7 +134,7 @@ union cpuid10_edx {
 extern void init_hw_perf_events(void);
 extern void perf_events_lapic_init(void);
 
-#define PERF_EVENT_INDEX_OFFSET			0
+#define X86_RDPMC_FIXED_BASE	0x40000000
 
 /*
  * Abuse bit 3 of the cpu eflags register to indicate proper PEBS IP fixups.
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f571f51..dcf78c2 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -253,6 +253,12 @@ static int x86_perf_event_set_period(struct perf_event *event);
 
 #define C(x) PERF_COUNT_HW_CACHE_##x
 
+int hw_perf_event_counter_width(struct perf_event *event)
+{
+	/* XXX: not all counters may have the same width */
+	return x86_pmu.event_bits;
+}
+
 static u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -779,6 +785,39 @@ static inline int match_prev_assignment(struct hw_perf_event *hwc,
 static int x86_pmu_start(struct perf_event *event);
 static void x86_pmu_stop(struct perf_event *event);
 
+int hw_perf_event_index(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (hwc->idx == X86_PMC_IDX_FIXED_BTS)
+		return -1;
+
+	if (hwc->idx >= X86_PMC_IDX_FIXED)
+		return X86_RDPMC_FIXED_BASE + hwc->idx - X86_PMC_IDX_FIXED;
+
+	return hwc->idx;
+}
+
+static void __perf_update_user_read_perm(void *data)
+{
+	/*
+	 * enable/disable secure monitoring on
+	 * current CPU
+	 */
+	if (perf_paranoid_user_read())
+		set_in_cr4(X86_CR4_PCE);
+	else
+		clear_in_cr4(X86_CR4_PCE);
+}
+
+int
+hw_event_update_user_read_perm(void)
+{
+	__perf_update_user_read_perm(NULL);
+	smp_call_function(__perf_update_user_read_perm, NULL, 1);
+	return 0;
+}
+
 void hw_perf_enable(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 358a8e3..4fa2ff3 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -299,6 +299,8 @@ static void amd_pmu_cpu_online(int cpu)
 	struct amd_nb *nb = NULL;
 	int i, nb_id;
 
+	__perf_update_user_read_perm(NULL);
+
 	if (boot_cpu_data.x86_max_cores < 2)
 		return;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 044b843..442e391 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -774,6 +774,8 @@ static void intel_pmu_cpu_starting(int cpu)
 	 * Deal with CPUs that don't clear their LBRs on power-up.
 	 */
 	intel_pmu_lbr_reset();
+
+	__perf_update_user_read_perm(NULL);
 }
 
 static void intel_pmu_cpu_dying(int cpu)
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 6ff4d01..752ffdc 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -102,6 +102,11 @@ static void p6_pmu_enable_event(struct perf_event *event)
 	(void)checking_wrmsrl(hwc->config_base + hwc->idx, val);
 }
 
+static void p6_pmu_cpu_starting(int cpu)
+{
+	__perf_update_user_read_perm(NULL);
+}
+
 static __initconst struct x86_pmu p6_pmu = {
 	.name			= "p6",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -131,6 +136,8 @@ static __initconst struct x86_pmu p6_pmu = {
 	.event_mask		= (1ULL << 32) - 1,
 	.get_event_constraints	= x86_get_event_constraints,
 	.event_constraints	= p6_event_constraints,
+
+	.cpu_starting		= p6_pmu_cpu_starting,
 };
 
 static __init int p6_pmu_init(void)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2bccb7b..31eeb67 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -250,8 +250,8 @@ struct perf_event_mmap_page {
 	 *
 	 *     barrier()
 	 *     if (pc->index) {
-	 *       count = pmc_read(pc->index - 1);
-	 *       count += pc->offset;
+	 *       count = pmc_read(pc->index - 1)  - pc->delta_base;
+	 *       count += pc->offset * pc->time_enabled/pc->time_running;
 	 *     } else
 	 *       goto regular_read;
 	 *
@@ -266,12 +266,13 @@ struct perf_event_mmap_page {
 	__s64	offset;			/* add to hardware event value */
 	__u64	time_enabled;		/* time event active */
 	__u64	time_running;		/* time event on cpu */
+	__u64	delta_base;		/* raw counter base value */
 
 		/*
 		 * Hole for extension of the self monitor capabilities
 		 */
 
-	__u64	__reserved[123];	/* align to 1k */
+	__u64	__reserved[122];	/* align to 1k */
 
 	/*
 	 * Control data for the mmap() data buffer.
@@ -919,6 +920,7 @@ extern void perf_event_fork(struct task_struct *tsk);
 extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 
 extern int sysctl_perf_event_paranoid;
+extern int sysctl_perf_event_paranoid_user_read;
 extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
 
@@ -937,6 +939,11 @@ static inline bool perf_paranoid_kernel(void)
 	return sysctl_perf_event_paranoid > 1;
 }
 
+static inline bool perf_paranoid_user_read(void)
+{
+	return !!sysctl_perf_event_paranoid_user_read;
+}
+
 extern void perf_event_init(void);
 extern void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 			  int entry_size, struct pt_regs *regs);
@@ -958,6 +965,8 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
+extern int proc_perf_event_paranoid_user_read(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 455393e..4e7bfc5 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -56,6 +56,14 @@ static atomic_t nr_task_events __read_mostly;
  */
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
+/*
+ * allow direct user level read to counter
+ * (may not be available on all HW platforms)
+ * 0 - disallow user read (must use read())
+ * 1 - allow direct user read (via assembly instruction)
+ */
+int sysctl_perf_event_paranoid_user_read __read_mostly = 1;
+
 int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
 
 /*
@@ -78,8 +86,19 @@ extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
 	return NULL;
 }
 
+extern __weak int hw_perf_event_counter_width(struct perf_event *event)
+{
+	return 0;
+}
+
 void __weak hw_perf_disable(void)		{ barrier(); }
 void __weak hw_perf_enable(void)		{ barrier(); }
+void __weak hw_perf_update_user_read_perm(void) { }
+
+extern int __weak hw_perf_event_index(struct perf_event *event)
+{
+	return -1;
+}
 
 int __weak
 hw_perf_group_sched_in(struct perf_event *group_leader,
@@ -2211,16 +2230,28 @@ int perf_event_task_disable(void)
 	return 0;
 }
 
-#ifndef PERF_EVENT_INDEX_OFFSET
-# define PERF_EVENT_INDEX_OFFSET 0
-#endif
-
 static int perf_event_index(struct perf_event *event)
 {
+	if (perf_paranoid_user_read())
+		return 0;
+
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
 		return 0;
 
-	return event->hw.idx + 1 - PERF_EVENT_INDEX_OFFSET;
+	return 1 + hw_perf_event_index(event);
+}
+
+static inline u64
+perf_adjust_event_prev_count(struct perf_event *event)
+{
+	u64 val;
+	/*
+	 * restrict prev_count to actual counter width to match
+	 * what user level instructions return
+	 */
+	val = atomic64_read(&event->hw.prev_count);
+	val &= (1ULL << hw_perf_event_counter_width(event)) - 1;
+	return val;
 }
 
 /*
@@ -2249,8 +2280,11 @@ void perf_event_update_userpage(struct perf_event *event)
 	barrier();
 	userpg->index = perf_event_index(event);
 	userpg->offset = atomic64_read(&event->count);
-	if (event->state == PERF_EVENT_STATE_ACTIVE)
-		userpg->offset -= atomic64_read(&event->hw.prev_count);
+	if (event->state == PERF_EVENT_STATE_ACTIVE
+	    && !perf_paranoid_user_read()) {
+                update_event_times(event);
+                userpg->delta_base = perf_adjust_event_prev_count(event);
+	}
 
 	userpg->time_enabled = event->total_time_enabled +
 			atomic64_read(&event->child_total_time_enabled);
@@ -5287,6 +5321,21 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 	return ret;
 }
 
+int proc_perf_event_paranoid_user_read(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int old_state;
+
+	old_state = sysctl_perf_event_paranoid;
+	proc_dointvec(table, write, buffer, length, ppos);
+	if (old_state == sysctl_perf_event_paranoid_user_read)
+		return 0;
+
+	/* update user read state */
+	hw_perf_update_user_read_perm();
+
+	return 0;
+}
 
 /*
  * Initialize the perf_event context in task_struct
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b63c80e..d97ed9e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -929,6 +929,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "perf_event_paranoid_user_read",
+		.data		= &sysctl_perf_event_paranoid_user_read,
+		.maxlen		= sizeof(sysctl_perf_event_sample_rate),
+		.mode		= 0644,
+		.proc_handler	= proc_perf_event_paranoid_user_read,
+	},
 #endif
 #ifdef CONFIG_KMEMCHECK
 	{
