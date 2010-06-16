Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab0FPQHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:07:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:33952 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206Ab0FPQGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:06:35 -0400
Message-Id: <20100616160238.529009255@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 16 Jun 2010 18:00:33 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 6/8] perf: Per PMU disable
References: <20100616160027.590430763@chello.nl>
Content-Disposition: inline; filename=perf-pmu-disable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes perf_disable() into perf_disable_pmu().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/arm/kernel/perf_event.c             |   24 ++++++++++-----------
 arch/powerpc/kernel/perf_event.c         |   23 +++++++++++---------
 arch/powerpc/kernel/perf_event_fsl_emb.c |   18 +++++++++-------
 arch/sh/kernel/perf_event.c              |   34 ++++++++++++++++---------------
 arch/sparc/kernel/perf_event.c           |   20 ++++++++++--------
 arch/x86/kernel/cpu/perf_event.c         |   16 ++++++++------
 include/linux/perf_event.h               |   13 ++++++-----
 kernel/perf_event.c                      |   30 ++++++++++++++++-----------
 8 files changed, 98 insertions(+), 80 deletions(-)

Index: linux-2.6/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6/arch/arm/kernel/perf_event.c
@@ -529,16 +529,7 @@ static int armpmu_event_init(struct perf
 	return err;
 }
 
-static struct pmu pmu = {
-	.event_init = armpmu_event_init,
-	.enable	    = armpmu_enable,
-	.disable    = armpmu_disable,
-	.unthrottle = armpmu_unthrottle,
-	.read	    = armpmu_read,
-};
-
-void
-hw_perf_enable(void)
+static void armpmu_pmu_enable(struct pmu *pmu)
 {
 	/* Enable all of the perf events on hardware. */
 	int idx;
@@ -559,13 +550,22 @@ hw_perf_enable(void)
 	armpmu->start();
 }
 
-void
-hw_perf_disable(void)
+static void armpmu_pmu_disable(struct pmu *pmu)
 {
 	if (armpmu)
 		armpmu->stop();
 }
 
+static struct pmu pmu = {
+	.pmu_enable = armpmu_pmu_enable,
+	.pmu_disable= armpmu_pmu_disable,
+	.event_init = armpmu_event_init,
+	.enable	    = armpmu_enable,
+	.disable    = armpmu_disable,
+	.unthrottle = armpmu_unthrottle,
+	.read	    = armpmu_read,
+};
+
 /*
  * ARMv6 Performance counter handling code.
  *
Index: linux-2.6/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event.c
+++ linux-2.6/arch/powerpc/kernel/perf_event.c
@@ -517,7 +517,7 @@ static void write_mmcr0(struct cpu_hw_ev
  * Disable all events to prevent PMU interrupts and to allow
  * events to be added or removed.
  */
-void hw_perf_disable(void)
+static void powerpc_pmu_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw;
 	unsigned long flags;
@@ -565,7 +565,7 @@ void hw_perf_disable(void)
  * If we were previously disabled and events were added, then
  * put the new config on the PMU.
  */
-void hw_perf_enable(void)
+static void powerpc_pmu_pmu_enable(struct pmu *pmu)
 {
 	struct perf_event *event;
 	struct cpu_hw_events *cpuhw;
@@ -735,7 +735,7 @@ static int power_pmu_enable(struct perf_
 	int ret = -EAGAIN;
 
 	local_irq_save(flags);
-	perf_disable();
+	perf_disable_pmu(event->pmu);
 
 	/*
 	 * Add the event to the list (if there is room)
@@ -769,7 +769,7 @@ nocheck:
 
 	ret = 0;
  out:
-	perf_enable();
+	perf_enable_pmu(event->pmu);
 	local_irq_restore(flags);
 	return ret;
 }
@@ -784,7 +784,7 @@ static void power_pmu_disable(struct per
 	unsigned long flags;
 
 	local_irq_save(flags);
-	perf_disable();
+	perf_disable_pmu(event->pmu);
 
 	power_pmu_read(event);
 
@@ -818,7 +818,7 @@ static void power_pmu_disable(struct per
 		cpuhw->mmcr[0] &= ~(MMCR0_PMXE | MMCR0_FCECE);
 	}
 
-	perf_enable();
+	perf_enable_pmu(event->pmu);
 	local_irq_restore(flags);
 }
 
@@ -834,7 +834,7 @@ static void power_pmu_unthrottle(struct 
 	if (!event->hw.idx || !event->hw.sample_period)
 		return;
 	local_irq_save(flags);
-	perf_disable();
+	perf_disable_pmu(event->pmu);
 	power_pmu_read(event);
 	left = event->hw.sample_period;
 	event->hw.last_period = left;
@@ -845,7 +845,7 @@ static void power_pmu_unthrottle(struct 
 	local64_set(&event->hw.prev_count, val);
 	local64_set(&event->hw.period_left, left);
 	perf_event_update_userpage(event);
-	perf_enable();
+	perf_enable_pmu(event->pmu);
 	local_irq_restore(flags);
 }
 
@@ -858,7 +858,7 @@ void power_pmu_start_txn(struct pmu *pmu
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
-	perf_disable();
+	perf_disable_pmu(pmu);
 	cpuhw->group_flag |= PERF_EVENT_TXN;
 	cpuhw->n_txn_start = cpuhw->n_events;
 }
@@ -873,7 +873,7 @@ void power_pmu_cancel_txn(struct pmu *pm
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
-	perf_enable();
+	perf_enable_pmu(pmu);
 }
 
 /*
@@ -1128,6 +1128,9 @@ static int power_pmu_event_init(struct p
 }
 
 struct pmu power_pmu = {
+	.pmu_enable	= power_pmu_pmu_enable,
+	.pmu_disable	= power_pmu_pmu_disable,
+	.event_init	= pmwer_pmu_event_init,
 	.enable		= power_pmu_enable,
 	.disable	= power_pmu_disable,
 	.read		= power_pmu_read,
Index: linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -177,7 +177,7 @@ static void fsl_emb_pmu_read(struct perf
  * Disable all events to prevent PMU interrupts and to allow
  * events to be added or removed.
  */
-void hw_perf_disable(void)
+static void fsl_emb_pmu_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw;
 	unsigned long flags;
@@ -216,7 +216,7 @@ void hw_perf_disable(void)
  * If we were previously disabled and events were added, then
  * put the new config on the PMU.
  */
-void hw_perf_enable(void)
+static void fsl_emb_pmu_pmu_enable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw;
 	unsigned long flags;
@@ -271,7 +271,7 @@ static int fsl_emb_pmu_enable(struct per
 	u64 val;
 	int i;
 
-	perf_disable();
+	perf_disable_pmu(event->pmu);
 	cpuhw = &get_cpu_var(cpu_hw_events);
 
 	if (event->hw.config & FSL_EMB_EVENT_RESTRICTED)
@@ -311,7 +311,7 @@ static int fsl_emb_pmu_enable(struct per
 	ret = 0;
  out:
 	put_cpu_var(cpu_hw_events);
-	perf_enable();
+	perf_enable_pmu(event->pmu);
 	return ret;
 }
 
@@ -321,7 +321,7 @@ static void fsl_emb_pmu_disable(struct p
 	struct cpu_hw_events *cpuhw;
 	int i = event->hw.idx;
 
-	perf_disable();
+	perf_disable_pmu(event->pmu);
 	if (i < 0)
 		goto out;
 
@@ -349,7 +349,7 @@ static void fsl_emb_pmu_disable(struct p
 	cpuhw->n_events--;
 
  out:
-	perf_enable();
+	perf_enable_pmu(event->pmu);
 	put_cpu_var(cpu_hw_events);
 }
 
@@ -367,7 +367,7 @@ static void fsl_emb_pmu_unthrottle(struc
 	if (event->hw.idx < 0 || !event->hw.sample_period)
 		return;
 	local_irq_save(flags);
-	perf_disable();
+	perf_disable_pmu(event->pmu);
 	fsl_emb_pmu_read(event);
 	left = event->hw.sample_period;
 	event->hw.last_period = left;
@@ -378,7 +378,7 @@ static void fsl_emb_pmu_unthrottle(struc
 	atomic64_set(&event->hw.prev_count, val);
 	atomic64_set(&event->hw.period_left, left);
 	perf_event_update_userpage(event);
-	perf_enable();
+	perf_enable_pmu(event->pmu);
 	local_irq_restore(flags);
 }
 
@@ -524,6 +524,8 @@ static int fsl_emb_pmu_event_init(struct
 }
 
 static struct pmu fsl_emb_pmu = {
+	.pmu_enable	= fsl_emb_pmu_pmu_enable,
+	.pmu_disable	= fsl_emb_pmu_pmu_disable,
 	.event_init	= fsl_emb_pmu_event_init,
 	.enable		= fsl_emb_pmu_enable,
 	.disable	= fsl_emb_pmu_disable,
Index: linux-2.6/arch/sh/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/perf_event.c
+++ linux-2.6/arch/sh/kernel/perf_event.c
@@ -268,7 +268,25 @@ static in sh_pmu_event_init(struct perf_
 	return err;
 }
 
+static void sh_pmu_pmu_enable(struct pmu *pmu)
+{
+	if (!sh_pmu_initialized())
+		return;
+
+	sh_pmu->enable_all();
+}
+
+static void sh_pmu_pmu_disable(struct pmu *pmu)
+{
+	if (!sh_pmu_initialized())
+		return;
+
+	sh_pmu->disable_all();
+}
+
 static struct pmu pmu = {
+	.pmu_enable	= sh_pmu_pmu_enable,
+	.pmu_disable	= sh_pmu_pmu_disable,
 	.event_init	= sh_pmu_event_init,
 	.enable		= sh_pmu_enable,
 	.disable	= sh_pmu_disable,
@@ -299,22 +317,6 @@ sh_pmu_notifier(struct notifier_block *s
 	return NOTIFY_OK;
 }
 
-void hw_perf_enable(void)
-{
-	if (!sh_pmu_initialized())
-		return;
-
-	sh_pmu->enable_all();
-}
-
-void hw_perf_disable(void)
-{
-	if (!sh_pmu_initialized())
-		return;
-
-	sh_pmu->disable_all();
-}
-
 int __cpuinit register_sh_pmu(struct sh_pmu *pmu)
 {
 	if (sh_pmu)
Index: linux-2.6/arch/sparc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/perf_event.c
+++ linux-2.6/arch/sparc/kernel/perf_event.c
@@ -663,7 +663,7 @@ out:
 	return pcr;
 }
 
-void hw_perf_enable(void)
+static void sparc_pmu_pmu_enable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	u64 pcr;
@@ -690,7 +690,7 @@ void hw_perf_enable(void)
 	pcr_ops->write(cpuc->pcr);
 }
 
-void hw_perf_disable(void)
+static void sparc_pmu_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	u64 val;
@@ -717,7 +717,7 @@ static void sparc_pmu_disable(struct per
 	int i;
 
 	local_irq_save(flags);
-	perf_disable();
+	perf_disable_pmu(event->pmu);
 
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event[i]) {
@@ -747,7 +747,7 @@ static void sparc_pmu_disable(struct per
 		}
 	}
 
-	perf_enable();
+	perf_enable_pmu(event->pmu);
 	local_irq_restore(flags);
 }
 
@@ -990,7 +990,7 @@ static int sparc_pmu_enable(struct perf_
 	unsigned long flags;
 
 	local_irq_save(flags);
-	perf_disable();
+	perf_disable_pmu(event->pmu);
 
 	n0 = cpuc->n_events;
 	if (n0 >= perf_max_events)
@@ -1019,7 +1019,7 @@ nocheck:
 
 	ret = 0;
 out:
-	perf_enable();
+	perf_enable_pmu(event->pmu);
 	local_irq_restore(flags);
 	return ret;
 }
@@ -1102,7 +1102,7 @@ static void sparc_pmu_start_txn(struct p
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
-	perf_disable();
+	perf_disable_pmu(pmu);
 	cpuhw->group_flag |= PERF_EVENT_TXN;
 }
 
@@ -1116,7 +1116,7 @@ static void sparc_pmu_cancel_txn(struct 
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
-	perf_enable();
+	perf_enable_pmu(pmu);
 }
 
 /*
@@ -1140,11 +1140,13 @@ static int sparc_pmu_commit_txn(struct p
 		return -EAGAIN;
 
 	cpuc->group_flag &= ~PERF_EVENT_TXN;
-	perf_enable();
+	perf_enable_pmu(pmu);
 	return 0;
 }
 
 static struct pmu pmu = {
+	.pmu_enable	= sparc_pmu_pmu_enable,
+	.pmu_disable	= sparc_pmu_pmu_disable,
 	.event_init	= sparc_pmu_event_init,
 	.enable		= sparc_pmu_enable,
 	.disable	= sparc_pmu_disable,
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -583,7 +583,7 @@ static void x86_pmu_disable_all(void)
 	}
 }
 
-void hw_perf_disable(void)
+static void x86_pmu_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -803,7 +803,7 @@ static inline int match_prev_assignment(
 static int x86_pmu_start(struct perf_event *event);
 static void x86_pmu_stop(struct perf_event *event);
 
-void hw_perf_enable(void)
+static void x86_pmu_pmu_enable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct perf_event *event;
@@ -969,7 +969,7 @@ static int x86_pmu_enable(struct perf_ev
 
 	hwc = &event->hw;
 
-	perf_disable();
+	perf_disable_pmu(event->pmu);
 	n0 = cpuc->n_events;
 	ret = n = collect_events(cpuc, event, false);
 	if (ret < 0)
@@ -999,7 +999,7 @@ done_collect:
 
 	ret = 0;
 out:
-	perf_enable();
+	perf_enable_pmu(event->pmu);
 	return ret;
 }
 
@@ -1403,7 +1403,7 @@ static void x86_pmu_start_txn(struct pmu
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	perf_disable();
+	perf_disable_pmu(pmu);
 	cpuc->group_flag |= PERF_EVENT_TXN;
 	cpuc->n_txn = 0;
 }
@@ -1423,7 +1423,7 @@ static void x86_pmu_cancel_txn(struct pm
 	 */
 	cpuc->n_added -= cpuc->n_txn;
 	cpuc->n_events -= cpuc->n_txn;
-	perf_enable();
+	perf_enable_pmu(pmu);
 }
 
 /*
@@ -1453,7 +1453,7 @@ static int x86_pmu_commit_txn(struct pmu
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
 	cpuc->group_flag &= ~PERF_EVENT_TXN;
-	perf_enable();
+	perf_enable_pmu(pmu);
 	return 0;
 }
 
@@ -1572,6 +1572,8 @@ int x86_pmu_event_init(struct perf_event
 }
 
 static struct pmu pmu = {
+	.pmu_enable	= x86_pmu_pmu_enable,
+	.pmu_disable	= x86_pmu_pmu_disable,
 	.event_init	= x86_pmu_event_init
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -561,6 +561,11 @@ struct perf_event;
 struct pmu {
 	struct list_head		entry;
 
+	int				*pmu_disable_count;
+
+	void (*pmu_enable)		(struct pmu *pmu);
+	void (*pmu_disable)		(struct pmu *pmu);
+
 	/*
 	 * Should return -ENOENT when the @event doesn't match this PMU.
 	 */
@@ -864,10 +869,8 @@ extern void perf_event_free_task(struct 
 extern void set_perf_event_pending(void);
 extern void perf_event_do_pending(void);
 extern void perf_event_print_debug(void);
-extern void __perf_disable(void);
-extern bool __perf_enable(void);
-extern void perf_disable(void);
-extern void perf_enable(void);
+extern void perf_disable_pmu(struct pmu *pmu);
+extern void perf_enable_pmu(struct pmu *pmu);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
 extern void perf_event_update_userpage(struct perf_event *event);
@@ -1056,8 +1059,6 @@ static inline void perf_event_exit_task(
 static inline void perf_event_free_task(struct task_struct *task)	{ }
 static inline void perf_event_do_pending(void)				{ }
 static inline void perf_event_print_debug(void)				{ }
-static inline void perf_disable(void)					{ }
-static inline void perf_enable(void)					{ }
 static inline int perf_event_task_disable(void)				{ return -EINVAL; }
 static inline int perf_event_task_enable(void)				{ return -EINVAL; }
 
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -71,23 +71,20 @@ static atomic64_t perf_event_id;
  */
 static DEFINE_SPINLOCK(perf_resource_lock);
 
-void __weak hw_perf_disable(void)		{ barrier(); }
-void __weak hw_perf_enable(void)		{ barrier(); }
-
 void __weak perf_event_print_debug(void)	{ }
 
-static DEFINE_PER_CPU(int, perf_disable_count);
-
-void perf_disable(void)
+void perf_disable_pmu(struct pmu *pmu)
 {
-	if (!__get_cpu_var(perf_disable_count)++)
-		hw_perf_disable();
+	int *count = this_cpu_ptr(pmu->pmu_disable_count);
+	if (!(*count)++)
+		pmu->pmu_disable(pmu);
 }
 
-void perf_enable(void)
+void perf_enable_pmu(struct pmu *pmu)
 {
-	if (!--__get_cpu_var(perf_disable_count))
-		hw_perf_enable();
+	int *count = this_cpu_ptr(pmu->pmu_disable_count);
+	if (!--(*count))
+		pmu->pmu_enable(pmu);
 }
 
 static void get_ctx(struct perf_event_context *ctx)
@@ -4758,16 +4755,25 @@ static struct srcu_struct pmus_srcu;
 
 int perf_pmu_register(struct pmu *pmu)
 {
+	int ret;
+
 	spin_lock(&pmus_lock);
+	ret = -ENOMEM;
+	pmu->pmu_disable_count = alloc_percpu(int);
+	if (!pmu->pmu_disable_count)
+		goto unlock;
 	list_add_rcu(&pmu->entry, &pmus);
+	ret = 0;
+unlock:
 	spin_unlock(&pmus_lock);
 
-	return 0;
+	return ret;
 }
 
 void perf_pmu_unregister(struct pmu *pmu)
 {
 	spin_lock(&pmus_lock);
+	free_percpu(pmu->pmu_disable_count);
 	list_del_rcu(&pmu->entry);
 	spin_unlock(&pmus_lock);
 


