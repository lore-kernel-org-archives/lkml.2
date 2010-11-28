Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0K1Rgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 12:36:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37981 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab0K1Rgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 12:36:39 -0500
Date: Sun, 28 Nov 2010 18:36:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20101128173619.GA11930@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Don Zickus (1):
      x86, perf, nmi: Disable perf if counters are not accessible

Peter Zijlstra (2):
      perf, x86: Fixup Kconfig deps
      perf: Fix the software context switch counter

Thomas Gleixner (1):
      perf: Fix inherit vs. context rotation bug


 arch/x86/Kconfig                 |    2 +-
 arch/x86/kernel/cpu/perf_event.c |   20 ++++++++++++++++++++
 include/linux/perf_event.h       |   30 ++++++++++++++++--------------
 kernel/perf_event.c              |   24 ++++++++++++++++++++----
 4 files changed, 57 insertions(+), 19 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e832768..e330da2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -21,7 +21,7 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_PERF_EVENTS if (!M386 && !M486)
+	select HAVE_PERF_EVENTS
 	select HAVE_IRQ_WORK
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ed63101..6d75b91 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -381,6 +381,20 @@ static void release_pmc_hardware(void) {}
 
 #endif
 
+static bool check_hw_exists(void)
+{
+	u64 val, val_new = 0;
+	int ret = 0;
+
+	val = 0xabcdUL;
+	ret |= checking_wrmsrl(x86_pmu.perfctr, val);
+	ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
+	if (ret || val != val_new)
+		return false;
+
+	return true;
+}
+
 static void reserve_ds_buffers(void);
 static void release_ds_buffers(void);
 
@@ -1372,6 +1386,12 @@ void __init init_hw_perf_events(void)
 
 	pmu_check_apic();
 
+	/* sanity check that the hardware exists or is emulated */
+	if (!check_hw_exists()) {
+		pr_cont("Broken PMU hardware detected, software events only.\n");
+		return;
+	}
+
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
 	if (x86_pmu.quirks)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 40150f3..de2c417 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -850,6 +850,7 @@ struct perf_event_context {
 	int				nr_active;
 	int				is_active;
 	int				nr_stat;
+	int				rotate_disable;
 	atomic_t			refcount;
 	struct task_struct		*task;
 
@@ -908,20 +909,6 @@ extern int perf_num_counters(void);
 extern const char *perf_pmu_name(void);
 extern void __perf_event_task_sched_in(struct task_struct *task);
 extern void __perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
-
-extern atomic_t perf_task_events;
-
-static inline void perf_event_task_sched_in(struct task_struct *task)
-{
-	COND_STMT(&perf_task_events, __perf_event_task_sched_in(task));
-}
-
-static inline
-void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
-{
-	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
-}
-
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
@@ -1030,6 +1017,21 @@ have_event:
 	__perf_sw_event(event_id, nr, nmi, regs, addr);
 }
 
+extern atomic_t perf_task_events;
+
+static inline void perf_event_task_sched_in(struct task_struct *task)
+{
+	COND_STMT(&perf_task_events, __perf_event_task_sched_in(task));
+}
+
+static inline
+void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
+{
+	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
+
+	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
+}
+
 extern void perf_event_mmap(struct vm_area_struct *vma);
 extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 671f6c8..eac7e33 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1287,8 +1287,6 @@ void __perf_event_task_sched_out(struct task_struct *task,
 {
 	int ctxn;
 
-	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
-
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
 }
@@ -1622,8 +1620,12 @@ static void rotate_ctx(struct perf_event_context *ctx)
 {
 	raw_spin_lock(&ctx->lock);
 
-	/* Rotate the first entry last of non-pinned groups */
-	list_rotate_left(&ctx->flexible_groups);
+	/*
+	 * Rotate the first entry last of non-pinned groups. Rotation might be
+	 * disabled by the inheritance code.
+	 */
+	if (!ctx->rotate_disable)
+		list_rotate_left(&ctx->flexible_groups);
 
 	raw_spin_unlock(&ctx->lock);
 }
@@ -6162,6 +6164,7 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 	struct perf_event *event;
 	struct task_struct *parent = current;
 	int inherited_all = 1;
+	unsigned long flags;
 	int ret = 0;
 
 	child->perf_event_ctxp[ctxn] = NULL;
@@ -6202,6 +6205,15 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 			break;
 	}
 
+	/*
+	 * We can't hold ctx->lock when iterating the ->flexible_group list due
+	 * to allocations, but we need to prevent rotation because
+	 * rotate_ctx() will change the list from interrupt context.
+	 */
+	raw_spin_lock_irqsave(&parent_ctx->lock, flags);
+	parent_ctx->rotate_disable = 1;
+	raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);
+
 	list_for_each_entry(event, &parent_ctx->flexible_groups, group_entry) {
 		ret = inherit_task_group(event, parent, parent_ctx,
 					 child, ctxn, &inherited_all);
@@ -6209,6 +6221,10 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 			break;
 	}
 
+	raw_spin_lock_irqsave(&parent_ctx->lock, flags);
+	parent_ctx->rotate_disable = 0;
+	raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);
+
 	child_ctx = child->perf_event_ctxp[ctxn];
 
 	if (child_ctx && inherited_all) {
