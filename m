Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab1LETPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:15:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113Ab1LETPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:15:34 -0500
Date: Mon, 5 Dec 2011 20:13:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20111205191350.GA31782@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf python: Fix undefined symbol problem

David Ahern (1):
      perf session: Fix crash with invalid CPU list

Gleb Natapov (1):
      perf: Do not set task_ctx pointer in cpuctx if there are no events in the context

Peter Zijlstra (5):
      perf/x86: Fix PEBS instruction unwind
      perf: Don't use -ENOSPC for out of PMU resources
      perf/x86: Enable raw event access to Intel offcore events
      perf, x86: Disable PEBS on SandyBridge chips
      perf: Fix loss of notification with multi-event

Robert Richter (3):
      oprofile: Fix crash when unloading module (hr timer mode)
      oprofile, x86: Fix crash when unloading module (nmi timer mode)
      perf, x86: Force IBS LVT offset assignment for family 10h

Tejun Heo (1):
      trace_events_filter: Use rcu_assign_pointer() when setting ftrace_event_call->filter


 arch/arm/kernel/perf_event.c              |    6 +-
 arch/mips/kernel/perf_event_mipsxx.c      |    8 +-
 arch/x86/kernel/cpu/perf_event.c          |   16 ++---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c  |   29 ++++++----
 arch/x86/kernel/cpu/perf_event_intel.c    |    8 +++
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    6 ++-
 arch/x86/kernel/cpu/perf_event_p4.c       |    2 +-
 arch/x86/oprofile/init.c                  |    7 ++-
 drivers/oprofile/oprof.c                  |   29 ++++++++--
 drivers/oprofile/timer_int.c              |    1 +
 include/linux/perf_event.h                |    1 +
 kernel/events/core.c                      |   89 ++++++++++++++++++++++++++++-
 kernel/events/internal.h                  |    3 +
 kernel/events/ring_buffer.c               |    3 +
 kernel/trace/trace_events_filter.c        |    6 +-
 tools/perf/util/evsel.c                   |   10 +++
 tools/perf/util/hist.c                    |   10 ---
 tools/perf/util/hist.h                    |    2 -
 tools/perf/util/session.c                 |    4 +
 19 files changed, 185 insertions(+), 55 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 24e2347..ff17b17 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -347,15 +347,15 @@ validate_group(struct perf_event *event)
 	memset(&fake_pmu, 0, sizeof(fake_pmu));
 
 	if (!validate_event(&fake_pmu, leader))
-		return -ENOSPC;
+		return -EINVAL;
 
 	list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
 		if (!validate_event(&fake_pmu, sibling))
-			return -ENOSPC;
+			return -EINVAL;
 	}
 
 	if (!validate_event(&fake_pmu, event))
-		return -ENOSPC;
+		return -EINVAL;
 
 	return 0;
 }
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 4f2971b..315fc0b 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -623,7 +623,7 @@ static int mipspmu_event_init(struct perf_event *event)
 	if (!atomic_inc_not_zero(&active_events)) {
 		if (atomic_read(&active_events) > MIPS_MAX_HWEVENTS) {
 			atomic_dec(&active_events);
-			return -ENOSPC;
+			return -EINVAL;
 		}
 
 		mutex_lock(&pmu_reserve_mutex);
@@ -732,15 +732,15 @@ static int validate_group(struct perf_event *event)
 	memset(&fake_cpuc, 0, sizeof(fake_cpuc));
 
 	if (!validate_event(&fake_cpuc, leader))
-		return -ENOSPC;
+		return -EINVAL;
 
 	list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
 		if (!validate_event(&fake_cpuc, sibling))
-			return -ENOSPC;
+			return -EINVAL;
 	}
 
 	if (!validate_event(&fake_cpuc, event))
-		return -ENOSPC;
+		return -EINVAL;
 
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6408910..2bda212 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -312,12 +312,8 @@ int x86_setup_perfctr(struct perf_event *event)
 			return -EOPNOTSUPP;
 	}
 
-	/*
-	 * Do not allow config1 (extended registers) to propagate,
-	 * there's no sane user-space generalization yet:
-	 */
 	if (attr->type == PERF_TYPE_RAW)
-		return 0;
+		return x86_pmu_extra_regs(event->attr.config, event);
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, event);
@@ -588,7 +584,7 @@ done:
 				x86_pmu.put_event_constraints(cpuc, cpuc->event_list[i]);
 		}
 	}
-	return num ? -ENOSPC : 0;
+	return num ? -EINVAL : 0;
 }
 
 /*
@@ -607,7 +603,7 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 
 	if (is_x86_event(leader)) {
 		if (n >= max_count)
-			return -ENOSPC;
+			return -EINVAL;
 		cpuc->event_list[n] = leader;
 		n++;
 	}
@@ -620,7 +616,7 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 			continue;
 
 		if (n >= max_count)
-			return -ENOSPC;
+			return -EINVAL;
 
 		cpuc->event_list[n] = event;
 		n++;
@@ -1316,7 +1312,7 @@ static int validate_event(struct perf_event *event)
 	c = x86_pmu.get_event_constraints(fake_cpuc, event);
 
 	if (!c || !c->weight)
-		ret = -ENOSPC;
+		ret = -EINVAL;
 
 	if (x86_pmu.put_event_constraints)
 		x86_pmu.put_event_constraints(fake_cpuc, event);
@@ -1341,7 +1337,7 @@ static int validate_group(struct perf_event *event)
 {
 	struct perf_event *leader = event->group_leader;
 	struct cpu_hw_events *fake_cpuc;
-	int ret = -ENOSPC, n;
+	int ret = -EINVAL, n;
 
 	fake_cpuc = allocate_fake_cpuc();
 	if (IS_ERR(fake_cpuc))
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index ab6343d..3b8a2d3 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -199,8 +199,7 @@ static int force_ibs_eilvt_setup(void)
 		goto out;
 	}
 
-	pr_err(FW_BUG "using offset %d for IBS interrupts\n", offset);
-	pr_err(FW_BUG "workaround enabled for IBS LVT offset\n");
+	pr_info("IBS: LVT offset %d assigned\n", offset);
 
 	return 0;
 out:
@@ -265,19 +264,23 @@ perf_ibs_cpu_notifier(struct notifier_block *self, unsigned long action, void *h
 static __init int amd_ibs_init(void)
 {
 	u32 caps;
-	int ret;
+	int ret = -EINVAL;
 
 	caps = __get_ibs_caps();
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
-	if (!ibs_eilvt_valid()) {
-		ret = force_ibs_eilvt_setup();
-		if (ret) {
-			pr_err("Failed to setup IBS, %d\n", ret);
-			return ret;
-		}
-	}
+	/*
+	 * Force LVT offset assignment for family 10h: The offsets are
+	 * not assigned by the BIOS for this family, so the OS is
+	 * responsible for doing it. If the OS assignment fails, fall
+	 * back to BIOS settings and try to setup this.
+	 */
+	if (boot_cpu_data.x86 == 0x10)
+		force_ibs_eilvt_setup();
+
+	if (!ibs_eilvt_valid())
+		goto out;
 
 	get_online_cpus();
 	ibs_caps = caps;
@@ -287,7 +290,11 @@ static __init int amd_ibs_init(void)
 	smp_call_function(setup_APIC_ibs, NULL, 1);
 	put_online_cpus();
 
-	return perf_event_ibs_init();
+	ret = perf_event_ibs_init();
+out:
+	if (ret)
+		pr_err("Failed to setup IBS, %d\n", ret);
+	return ret;
 }
 
 /* Since we need the pci subsystem to init ibs we can't do this earlier: */
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 2be5ebe..8d601b1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1545,6 +1545,13 @@ static void intel_clovertown_quirks(void)
 	x86_pmu.pebs_constraints = NULL;
 }
 
+static void intel_sandybridge_quirks(void)
+{
+	printk(KERN_WARNING "PEBS disabled due to CPU errata.\n");
+	x86_pmu.pebs = 0;
+	x86_pmu.pebs_constraints = NULL;
+}
+
 __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -1694,6 +1701,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 42: /* SandyBridge */
+		x86_pmu.quirks = intel_sandybridge_quirks;
 	case 45: /* SandyBridge, "Romely-EP" */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index c0d238f..73da6b6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -493,6 +493,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	unsigned long from = cpuc->lbr_entries[0].from;
 	unsigned long old_to, to = cpuc->lbr_entries[0].to;
 	unsigned long ip = regs->ip;
+	int is_64bit = 0;
 
 	/*
 	 * We don't need to fixup if the PEBS assist is fault like
@@ -544,7 +545,10 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 		} else
 			kaddr = (void *)to;
 
-		kernel_insn_init(&insn, kaddr);
+#ifdef CONFIG_X86_64
+		is_64bit = kernel_ip(to) || !test_thread_flag(TIF_IA32);
+#endif
+		insn_init(&insn, kaddr, is_64bit);
 		insn_get_length(&insn);
 		to += insn.length;
 	} while (to < ip);
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 492bf13..ef484d9 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1268,7 +1268,7 @@ reserve:
 	}
 
 done:
-	return num ? -ENOSPC : 0;
+	return num ? -EINVAL : 0;
 }
 
 static __initconst const struct x86_pmu p4_pmu = {
diff --git a/arch/x86/oprofile/init.c b/arch/x86/oprofile/init.c
index cdfe4c5..f148cf6 100644
--- a/arch/x86/oprofile/init.c
+++ b/arch/x86/oprofile/init.c
@@ -21,6 +21,7 @@ extern int op_nmi_timer_init(struct oprofile_operations *ops);
 extern void op_nmi_exit(void);
 extern void x86_backtrace(struct pt_regs * const regs, unsigned int depth);
 
+static int nmi_timer;
 
 int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
@@ -31,8 +32,9 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 #ifdef CONFIG_X86_LOCAL_APIC
 	ret = op_nmi_init(ops);
 #endif
+	nmi_timer = (ret != 0);
 #ifdef CONFIG_X86_IO_APIC
-	if (ret < 0)
+	if (nmi_timer)
 		ret = op_nmi_timer_init(ops);
 #endif
 	ops->backtrace = x86_backtrace;
@@ -44,6 +46,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 void oprofile_arch_exit(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
-	op_nmi_exit();
+	if (!nmi_timer)
+		op_nmi_exit();
 #endif
 }
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index dccd863..f8c752e 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -239,26 +239,45 @@ int oprofile_set_ulong(unsigned long *addr, unsigned long val)
 	return err;
 }
 
+static int timer_mode;
+
 static int __init oprofile_init(void)
 {
 	int err;
 
+	/* always init architecture to setup backtrace support */
 	err = oprofile_arch_init(&oprofile_ops);
-	if (err < 0 || timer) {
-		printk(KERN_INFO "oprofile: using timer interrupt.\n");
+
+	timer_mode = err || timer;	/* fall back to timer mode on errors */
+	if (timer_mode) {
+		if (!err)
+			oprofile_arch_exit();
 		err = oprofile_timer_init(&oprofile_ops);
 		if (err)
 			return err;
 	}
-	return oprofilefs_register();
+
+	err = oprofilefs_register();
+	if (!err)
+		return 0;
+
+	/* failed */
+	if (timer_mode)
+		oprofile_timer_exit();
+	else
+		oprofile_arch_exit();
+
+	return err;
 }
 
 
 static void __exit oprofile_exit(void)
 {
-	oprofile_timer_exit();
 	oprofilefs_unregister();
-	oprofile_arch_exit();
+	if (timer_mode)
+		oprofile_timer_exit();
+	else
+		oprofile_arch_exit();
 }
 
 
diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index 3ef4462..878fba1 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -110,6 +110,7 @@ int oprofile_timer_init(struct oprofile_operations *ops)
 	ops->start = oprofile_hrtimer_start;
 	ops->stop = oprofile_hrtimer_stop;
 	ops->cpu_type = "timer";
+	printk(KERN_INFO "oprofile: using timer interrupt.\n");
 	return 0;
 }
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1e9ebe5..b1f8912 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -822,6 +822,7 @@ struct perf_event {
 	int				mmap_locked;
 	struct user_struct		*mmap_user;
 	struct ring_buffer		*rb;
+	struct list_head		rb_entry;
 
 	/* poll related */
 	wait_queue_head_t		waitq;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0e8457d..600c162 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -185,6 +185,9 @@ static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 static void update_context_time(struct perf_event_context *ctx);
 static u64 perf_event_time(struct perf_event *event);
 
+static void ring_buffer_attach(struct perf_event *event,
+			       struct ring_buffer *rb);
+
 void __weak perf_event_print_debug(void)	{ }
 
 extern __weak const char *perf_pmu_name(void)
@@ -2173,7 +2176,8 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 
 	perf_event_sched_in(cpuctx, ctx, task);
 
-	cpuctx->task_ctx = ctx;
+	if (ctx->nr_events)
+		cpuctx->task_ctx = ctx;
 
 	perf_pmu_enable(ctx->pmu);
 	perf_ctx_unlock(cpuctx, ctx);
@@ -3190,12 +3194,33 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	struct ring_buffer *rb;
 	unsigned int events = POLL_HUP;
 
+	/*
+	 * Race between perf_event_set_output() and perf_poll(): perf_poll()
+	 * grabs the rb reference but perf_event_set_output() overrides it.
+	 * Here is the timeline for two threads T1, T2:
+	 * t0: T1, rb = rcu_dereference(event->rb)
+	 * t1: T2, old_rb = event->rb
+	 * t2: T2, event->rb = new rb
+	 * t3: T2, ring_buffer_detach(old_rb)
+	 * t4: T1, ring_buffer_attach(rb1)
+	 * t5: T1, poll_wait(event->waitq)
+	 *
+	 * To avoid this problem, we grab mmap_mutex in perf_poll()
+	 * thereby ensuring that the assignment of the new ring buffer
+	 * and the detachment of the old buffer appear atomic to perf_poll()
+	 */
+	mutex_lock(&event->mmap_mutex);
+
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
-	if (rb)
+	if (rb) {
+		ring_buffer_attach(event, rb);
 		events = atomic_xchg(&rb->poll, 0);
+	}
 	rcu_read_unlock();
 
+	mutex_unlock(&event->mmap_mutex);
+
 	poll_wait(file, &event->waitq, wait);
 
 	return events;
@@ -3496,6 +3521,49 @@ unlock:
 	return ret;
 }
 
+static void ring_buffer_attach(struct perf_event *event,
+			       struct ring_buffer *rb)
+{
+	unsigned long flags;
+
+	if (!list_empty(&event->rb_entry))
+		return;
+
+	spin_lock_irqsave(&rb->event_lock, flags);
+	if (!list_empty(&event->rb_entry))
+		goto unlock;
+
+	list_add(&event->rb_entry, &rb->event_list);
+unlock:
+	spin_unlock_irqrestore(&rb->event_lock, flags);
+}
+
+static void ring_buffer_detach(struct perf_event *event,
+			       struct ring_buffer *rb)
+{
+	unsigned long flags;
+
+	if (list_empty(&event->rb_entry))
+		return;
+
+	spin_lock_irqsave(&rb->event_lock, flags);
+	list_del_init(&event->rb_entry);
+	wake_up_all(&event->waitq);
+	spin_unlock_irqrestore(&rb->event_lock, flags);
+}
+
+static void ring_buffer_wakeup(struct perf_event *event)
+{
+	struct ring_buffer *rb;
+
+	rcu_read_lock();
+	rb = rcu_dereference(event->rb);
+	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
+		wake_up_all(&event->waitq);
+	}
+	rcu_read_unlock();
+}
+
 static void rb_free_rcu(struct rcu_head *rcu_head)
 {
 	struct ring_buffer *rb;
@@ -3521,9 +3589,19 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 
 static void ring_buffer_put(struct ring_buffer *rb)
 {
+	struct perf_event *event, *n;
+	unsigned long flags;
+
 	if (!atomic_dec_and_test(&rb->refcount))
 		return;
 
+	spin_lock_irqsave(&rb->event_lock, flags);
+	list_for_each_entry_safe(event, n, &rb->event_list, rb_entry) {
+		list_del_init(&event->rb_entry);
+		wake_up_all(&event->waitq);
+	}
+	spin_unlock_irqrestore(&rb->event_lock, flags);
+
 	call_rcu(&rb->rcu_head, rb_free_rcu);
 }
 
@@ -3546,6 +3624,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
 		vma->vm_mm->pinned_vm -= event->mmap_locked;
 		rcu_assign_pointer(event->rb, NULL);
+		ring_buffer_detach(event, rb);
 		mutex_unlock(&event->mmap_mutex);
 
 		ring_buffer_put(rb);
@@ -3700,7 +3779,7 @@ static const struct file_operations perf_fops = {
 
 void perf_event_wakeup(struct perf_event *event)
 {
-	wake_up_all(&event->waitq);
+	ring_buffer_wakeup(event);
 
 	if (event->pending_kill) {
 		kill_fasync(&event->fasync, SIGIO, event->pending_kill);
@@ -5822,6 +5901,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->group_entry);
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
+	INIT_LIST_HEAD(&event->rb_entry);
+
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
 
@@ -6028,6 +6109,8 @@ set:
 
 	old_rb = event->rb;
 	rcu_assign_pointer(event->rb, rb);
+	if (old_rb)
+		ring_buffer_detach(event, old_rb);
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 09097dd..64568a6 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -22,6 +22,9 @@ struct ring_buffer {
 	local_t				lost;		/* nr records lost   */
 
 	long				watermark;	/* wakeup watermark  */
+	/* poll crap */
+	spinlock_t			event_lock;
+	struct list_head		event_list;
 
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index a2a2920..7f3011c 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -209,6 +209,9 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
 		rb->writable = 1;
 
 	atomic_set(&rb->refcount, 1);
+
+	INIT_LIST_HEAD(&rb->event_list);
+	spin_lock_init(&rb->event_lock);
 }
 
 #ifndef CONFIG_PERF_USE_VMALLOC
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 816d3d0..d6e7926 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1686,7 +1686,7 @@ static int replace_system_preds(struct event_subsystem *system,
 		 * replace the filter for the call.
 		 */
 		filter = call->filter;
-		call->filter = filter_item->filter;
+		rcu_assign_pointer(call->filter, filter_item->filter);
 		filter_item->filter = filter;
 
 		fail = false;
@@ -1741,7 +1741,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 		filter = call->filter;
 		if (!filter)
 			goto out_unlock;
-		call->filter = NULL;
+		RCU_INIT_POINTER(call->filter, NULL);
 		/* Make sure the filter is not being used */
 		synchronize_sched();
 		__free_filter(filter);
@@ -1782,7 +1782,7 @@ out:
 	 * string
 	 */
 	tmp = call->filter;
-	call->filter = filter;
+	rcu_assign_pointer(call->filter, filter);
 	if (tmp) {
 		/* Make sure the call is done with the filter */
 		synchronize_sched();
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e426264..d7915d4 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -34,6 +34,16 @@ int __perf_evsel__sample_size(u64 sample_type)
 	return size;
 }
 
+static void hists__init(struct hists *hists)
+{
+	memset(hists, 0, sizeof(*hists));
+	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
+	hists->entries_in = &hists->entries_in_array[0];
+	hists->entries_collapsed = RB_ROOT;
+	hists->entries = RB_ROOT;
+	pthread_mutex_init(&hists->lock, NULL);
+}
+
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx)
 {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index a36a3fa..abef270 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1211,13 +1211,3 @@ size_t hists__fprintf_nr_events(struct hists *hists, FILE *fp)
 
 	return ret;
 }
-
-void hists__init(struct hists *hists)
-{
-	memset(hists, 0, sizeof(*hists));
-	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
-	hists->entries_in = &hists->entries_in_array[0];
-	hists->entries_collapsed = RB_ROOT;
-	hists->entries = RB_ROOT;
-	pthread_mutex_init(&hists->lock, NULL);
-}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c86c1d2..89289c8 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -63,8 +63,6 @@ struct hists {
 	struct callchain_cursor	callchain_cursor;
 };
 
-void hists__init(struct hists *hists);
-
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *parent, u64 period);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 85c1e6b7..0f4555c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1333,6 +1333,10 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 	}
 
 	map = cpu_map__new(cpu_list);
+	if (map == NULL) {
+		pr_err("Invalid cpu_list\n");
+		return -1;
+	}
 
 	for (i = 0; i < map->nr; i++) {
 		int cpu = map->map[i];
