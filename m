Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0IITtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:49:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:33061 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab0IITtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:49:51 -0400
Date: Thu, 9 Sep 2010 19:49:02 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, dengcheng.zhu@gmail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, gorcunov@gmail.com, fweisbec@gmail.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        eranian@googlemail.com, will.deacon@arm.com, lethal@linux-sh.org,
        davem@davemloft.net, mingo@elte.hu, mcree@orcon.net.nz
Reply-To: mingo@redhat.com, dengcheng.zhu@gmail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, gorcunov@gmail.com, fweisbec@gmail.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        eranian@googlemail.com, will.deacon@arm.com, lethal@linux-sh.org,
        davem@davemloft.net, mingo@elte.hu, mcree@orcon.net.nz
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Per PMU disable
Message-ID: <tip-33696fc0d141bbbcb12f75b69608ea83282e3117@git.kernel.org>
Git-Commit-ID: 33696fc0d141bbbcb12f75b69608ea83282e3117
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:49:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33696fc0d141bbbcb12f75b69608ea83282e3117
Gitweb:     http://git.kernel.org/tip/33696fc0d141bbbcb12f75b69608ea83282e3117
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 14 Jun 2010 08:49:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:29 +0200

perf: Per PMU disable

Changes perf_disable() into perf_pmu_disable().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Yanmin <yanmin_zhang@linux.intel.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: David Miller <davem@davemloft.net>
Cc: Michael Cree <mcree@orcon.net.nz>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/alpha/kernel/perf_event.c           |   30 ++++++++++++-----------
 arch/arm/kernel/perf_event.c             |   28 +++++++++++-----------
 arch/powerpc/kernel/perf_event.c         |   24 ++++++++++--------
 arch/powerpc/kernel/perf_event_fsl_emb.c |   18 ++++++++------
 arch/sh/kernel/perf_event.c              |   38 +++++++++++++++--------------
 arch/sparc/kernel/perf_event.c           |   20 ++++++++-------
 arch/x86/kernel/cpu/perf_event.c         |   16 +++++++-----
 include/linux/perf_event.h               |   13 +++++----
 kernel/perf_event.c                      |   31 +++++++++++++++---------
 9 files changed, 119 insertions(+), 99 deletions(-)

diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
index 19660b5..3e26073 100644
--- a/arch/alpha/kernel/perf_event.c
+++ b/arch/alpha/kernel/perf_event.c
@@ -435,7 +435,7 @@ static int alpha_pmu_enable(struct perf_event *event)
 	 * nevertheless we disable the PMCs first to enable a potential
 	 * final PMI to occur before we disable interrupts.
 	 */
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 	local_irq_save(flags);
 
 	/* Default to error to be returned */
@@ -456,7 +456,7 @@ static int alpha_pmu_enable(struct perf_event *event)
 	}
 
 	local_irq_restore(flags);
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 
 	return ret;
 }
@@ -474,7 +474,7 @@ static void alpha_pmu_disable(struct perf_event *event)
 	unsigned long flags;
 	int j;
 
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 	local_irq_save(flags);
 
 	for (j = 0; j < cpuc->n_events; j++) {
@@ -502,7 +502,7 @@ static void alpha_pmu_disable(struct perf_event *event)
 	}
 
 	local_irq_restore(flags);
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 }
 
 
@@ -668,18 +668,10 @@ static int alpha_pmu_event_init(struct perf_event *event)
 	return err;
 }
 
-static struct pmu pmu = {
-	.event_init	= alpha_pmu_event_init,
-	.enable		= alpha_pmu_enable,
-	.disable	= alpha_pmu_disable,
-	.read		= alpha_pmu_read,
-	.unthrottle	= alpha_pmu_unthrottle,
-};
-
 /*
  * Main entry point - enable HW performance counters.
  */
-void hw_perf_enable(void)
+static void alpha_pmu_pmu_enable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -705,7 +697,7 @@ void hw_perf_enable(void)
  * Main entry point - disable HW performance counters.
  */
 
-void hw_perf_disable(void)
+static void alpha_pmu_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -718,6 +710,16 @@ void hw_perf_disable(void)
 	wrperfmon(PERFMON_CMD_DISABLE, cpuc->idx_mask);
 }
 
+static struct pmu pmu = {
+	.pmu_enable	= alpha_pmu_pmu_enable,
+	.pmu_disable	= alpha_pmu_pmu_disable,
+	.event_init	= alpha_pmu_event_init,
+	.enable		= alpha_pmu_enable,
+	.disable	= alpha_pmu_disable,
+	.read		= alpha_pmu_read,
+	.unthrottle	= alpha_pmu_unthrottle,
+};
+
 
 /*
  * Main entry point - don't know when this is called but it
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index afc92c5..3343f3f 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -277,7 +277,7 @@ armpmu_enable(struct perf_event *event)
 	int idx;
 	int err = 0;
 
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 
 	/* If we don't have a space for the counter then finish early. */
 	idx = armpmu->get_event_idx(cpuc, hwc);
@@ -305,7 +305,7 @@ armpmu_enable(struct perf_event *event)
 	perf_event_update_userpage(event);
 
 out:
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 	return err;
 }
 
@@ -534,16 +534,7 @@ static int armpmu_event_init(struct perf_event *event)
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
@@ -564,13 +555,22 @@ hw_perf_enable(void)
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
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index c140882..deb84bb 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -517,7 +517,7 @@ static void write_mmcr0(struct cpu_hw_events *cpuhw, unsigned long mmcr0)
  * Disable all events to prevent PMU interrupts and to allow
  * events to be added or removed.
  */
-void hw_perf_disable(void)
+static void power_pmu_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw;
 	unsigned long flags;
@@ -565,7 +565,7 @@ void hw_perf_disable(void)
  * If we were previously disabled and events were added, then
  * put the new config on the PMU.
  */
-void hw_perf_enable(void)
+static void power_pmu_pmu_enable(struct pmu *pmu)
 {
 	struct perf_event *event;
 	struct cpu_hw_events *cpuhw;
@@ -735,7 +735,7 @@ static int power_pmu_enable(struct perf_event *event)
 	int ret = -EAGAIN;
 
 	local_irq_save(flags);
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 
 	/*
 	 * Add the event to the list (if there is room)
@@ -769,7 +769,7 @@ nocheck:
 
 	ret = 0;
  out:
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 	local_irq_restore(flags);
 	return ret;
 }
@@ -784,7 +784,7 @@ static void power_pmu_disable(struct perf_event *event)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 
 	power_pmu_read(event);
 
@@ -821,7 +821,7 @@ static void power_pmu_disable(struct perf_event *event)
 		cpuhw->mmcr[0] &= ~(MMCR0_PMXE | MMCR0_FCECE);
 	}
 
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 	local_irq_restore(flags);
 }
 
@@ -837,7 +837,7 @@ static void power_pmu_unthrottle(struct perf_event *event)
 	if (!event->hw.idx || !event->hw.sample_period)
 		return;
 	local_irq_save(flags);
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 	power_pmu_read(event);
 	left = event->hw.sample_period;
 	event->hw.last_period = left;
@@ -848,7 +848,7 @@ static void power_pmu_unthrottle(struct perf_event *event)
 	local64_set(&event->hw.prev_count, val);
 	local64_set(&event->hw.period_left, left);
 	perf_event_update_userpage(event);
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 	local_irq_restore(flags);
 }
 
@@ -861,7 +861,7 @@ void power_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
-	perf_disable();
+	perf_pmu_disable(pmu);
 	cpuhw->group_flag |= PERF_EVENT_TXN;
 	cpuhw->n_txn_start = cpuhw->n_events;
 }
@@ -876,7 +876,7 @@ void power_pmu_cancel_txn(struct pmu *pmu)
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
-	perf_enable();
+	perf_pmu_enable(pmu);
 }
 
 /*
@@ -903,7 +903,7 @@ int power_pmu_commit_txn(struct pmu *pmu)
 		cpuhw->event[i]->hw.config = cpuhw->events[i];
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
-	perf_enable();
+	perf_pmu_enable(pmu);
 	return 0;
 }
 
@@ -1131,6 +1131,8 @@ static int power_pmu_event_init(struct perf_event *event)
 }
 
 struct pmu power_pmu = {
+	.pmu_enable	= power_pmu_pmu_enable,
+	.pmu_disable	= power_pmu_pmu_disable,
 	.event_init	= power_pmu_event_init,
 	.enable		= power_pmu_enable,
 	.disable	= power_pmu_disable,
diff --git a/arch/powerpc/kernel/perf_event_fsl_emb.c b/arch/powerpc/kernel/perf_event_fsl_emb.c
index 9bc84a7..84b1974 100644
--- a/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -177,7 +177,7 @@ static void fsl_emb_pmu_read(struct perf_event *event)
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
@@ -271,7 +271,7 @@ static int fsl_emb_pmu_enable(struct perf_event *event)
 	u64 val;
 	int i;
 
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 	cpuhw = &get_cpu_var(cpu_hw_events);
 
 	if (event->hw.config & FSL_EMB_EVENT_RESTRICTED)
@@ -311,7 +311,7 @@ static int fsl_emb_pmu_enable(struct perf_event *event)
 	ret = 0;
  out:
 	put_cpu_var(cpu_hw_events);
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 	return ret;
 }
 
@@ -321,7 +321,7 @@ static void fsl_emb_pmu_disable(struct perf_event *event)
 	struct cpu_hw_events *cpuhw;
 	int i = event->hw.idx;
 
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 	if (i < 0)
 		goto out;
 
@@ -349,7 +349,7 @@ static void fsl_emb_pmu_disable(struct perf_event *event)
 	cpuhw->n_events--;
 
  out:
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 	put_cpu_var(cpu_hw_events);
 }
 
@@ -367,7 +367,7 @@ static void fsl_emb_pmu_unthrottle(struct perf_event *event)
 	if (event->hw.idx < 0 || !event->hw.sample_period)
 		return;
 	local_irq_save(flags);
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 	fsl_emb_pmu_read(event);
 	left = event->hw.sample_period;
 	event->hw.last_period = left;
@@ -378,7 +378,7 @@ static void fsl_emb_pmu_unthrottle(struct perf_event *event)
 	local64_set(&event->hw.prev_count, val);
 	local64_set(&event->hw.period_left, left);
 	perf_event_update_userpage(event);
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 	local_irq_restore(flags);
 }
 
@@ -524,6 +524,8 @@ static int fsl_emb_pmu_event_init(struct perf_event *event)
 }
 
 static struct pmu fsl_emb_pmu = {
+	.pmu_enable	= fsl_emb_pmu_pmu_enable,
+	.pmu_disable	= fsl_emb_pmu_pmu_disable,
 	.event_init	= fsl_emb_pmu_event_init,
 	.enable		= fsl_emb_pmu_enable,
 	.disable	= fsl_emb_pmu_disable,
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index d042989..4bbe190 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -232,7 +232,7 @@ static int sh_pmu_enable(struct perf_event *event)
 	int idx = hwc->idx;
 	int ret = -EAGAIN;
 
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 
 	if (test_and_set_bit(idx, cpuc->used_mask)) {
 		idx = find_first_zero_bit(cpuc->used_mask, sh_pmu->num_events);
@@ -253,7 +253,7 @@ static int sh_pmu_enable(struct perf_event *event)
 	perf_event_update_userpage(event);
 	ret = 0;
 out:
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 	return ret;
 }
 
@@ -285,7 +285,25 @@ static int sh_pmu_event_init(struct perf_event *event)
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
@@ -316,22 +334,6 @@ sh_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
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
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index d0131de..37cae67 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -664,7 +664,7 @@ out:
 	return pcr;
 }
 
-void hw_perf_enable(void)
+static void sparc_pmu_pmu_enable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	u64 pcr;
@@ -691,7 +691,7 @@ void hw_perf_enable(void)
 	pcr_ops->write(cpuc->pcr);
 }
 
-void hw_perf_disable(void)
+static void sparc_pmu_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	u64 val;
@@ -718,7 +718,7 @@ static void sparc_pmu_disable(struct perf_event *event)
 	int i;
 
 	local_irq_save(flags);
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event[i]) {
@@ -748,7 +748,7 @@ static void sparc_pmu_disable(struct perf_event *event)
 		}
 	}
 
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 	local_irq_restore(flags);
 }
 
@@ -991,7 +991,7 @@ static int sparc_pmu_enable(struct perf_event *event)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 
 	n0 = cpuc->n_events;
 	if (n0 >= perf_max_events)
@@ -1020,7 +1020,7 @@ nocheck:
 
 	ret = 0;
 out:
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 	local_irq_restore(flags);
 	return ret;
 }
@@ -1113,7 +1113,7 @@ static void sparc_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
-	perf_disable();
+	perf_pmu_disable(pmu);
 	cpuhw->group_flag |= PERF_EVENT_TXN;
 }
 
@@ -1127,7 +1127,7 @@ static void sparc_pmu_cancel_txn(struct pmu *pmu)
 	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
 
 	cpuhw->group_flag &= ~PERF_EVENT_TXN;
-	perf_enable();
+	perf_pmu_enable(pmu);
 }
 
 /*
@@ -1151,11 +1151,13 @@ static int sparc_pmu_commit_txn(struct pmu *pmu)
 		return -EAGAIN;
 
 	cpuc->group_flag &= ~PERF_EVENT_TXN;
-	perf_enable();
+	perf_pmu_enable(pmu);
 	return 0;
 }
 
 static struct pmu pmu = {
+	.pmu_enable	= sparc_pmu_pmu_enable,
+	.pmu_disable	= sparc_pmu_pmu_disable,
 	.event_init	= sparc_pmu_event_init,
 	.enable		= sparc_pmu_enable,
 	.disable	= sparc_pmu_disable,
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 846070c..79705ac 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -583,7 +583,7 @@ static void x86_pmu_disable_all(void)
 	}
 }
 
-void hw_perf_disable(void)
+static void x86_pmu_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -803,7 +803,7 @@ static inline int match_prev_assignment(struct hw_perf_event *hwc,
 static int x86_pmu_start(struct perf_event *event);
 static void x86_pmu_stop(struct perf_event *event);
 
-void hw_perf_enable(void)
+static void x86_pmu_pmu_enable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct perf_event *event;
@@ -969,7 +969,7 @@ static int x86_pmu_enable(struct perf_event *event)
 
 	hwc = &event->hw;
 
-	perf_disable();
+	perf_pmu_disable(event->pmu);
 	n0 = cpuc->n_events;
 	ret = n = collect_events(cpuc, event, false);
 	if (ret < 0)
@@ -999,7 +999,7 @@ done_collect:
 
 	ret = 0;
 out:
-	perf_enable();
+	perf_pmu_enable(event->pmu);
 	return ret;
 }
 
@@ -1436,7 +1436,7 @@ static void x86_pmu_start_txn(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	perf_disable();
+	perf_pmu_disable(pmu);
 	cpuc->group_flag |= PERF_EVENT_TXN;
 	cpuc->n_txn = 0;
 }
@@ -1456,7 +1456,7 @@ static void x86_pmu_cancel_txn(struct pmu *pmu)
 	 */
 	cpuc->n_added -= cpuc->n_txn;
 	cpuc->n_events -= cpuc->n_txn;
-	perf_enable();
+	perf_pmu_enable(pmu);
 }
 
 /*
@@ -1486,7 +1486,7 @@ static int x86_pmu_commit_txn(struct pmu *pmu)
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
 	cpuc->group_flag &= ~PERF_EVENT_TXN;
-	perf_enable();
+	perf_pmu_enable(pmu);
 	return 0;
 }
 
@@ -1605,6 +1605,8 @@ int x86_pmu_event_init(struct perf_event *event)
 }
 
 static struct pmu pmu = {
+	.pmu_enable	= x86_pmu_pmu_enable,
+	.pmu_disable	= x86_pmu_pmu_disable,
 	.event_init	= x86_pmu_event_init,
 	.enable		= x86_pmu_enable,
 	.disable	= x86_pmu_disable,
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 243286a..6abf103 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -563,6 +563,11 @@ struct perf_event;
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
@@ -868,10 +873,8 @@ extern void perf_event_free_task(struct task_struct *task);
 extern void set_perf_event_pending(void);
 extern void perf_event_do_pending(void);
 extern void perf_event_print_debug(void);
-extern void __perf_disable(void);
-extern bool __perf_enable(void);
-extern void perf_disable(void);
-extern void perf_enable(void);
+extern void perf_pmu_disable(struct pmu *pmu);
+extern void perf_pmu_enable(struct pmu *pmu);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
 extern void perf_event_update_userpage(struct perf_event *event);
@@ -1056,8 +1059,6 @@ static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
 static inline void perf_event_do_pending(void)				{ }
 static inline void perf_event_print_debug(void)				{ }
-static inline void perf_disable(void)					{ }
-static inline void perf_enable(void)					{ }
 static inline int perf_event_task_disable(void)				{ return -EINVAL; }
 static inline int perf_event_task_enable(void)				{ return -EINVAL; }
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9a98ce9..5ed0c06 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
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
+void perf_pmu_disable(struct pmu *pmu)
 {
-	if (!__get_cpu_var(perf_disable_count)++)
-		hw_perf_disable();
+	int *count = this_cpu_ptr(pmu->pmu_disable_count);
+	if (!(*count)++)
+		pmu->pmu_disable(pmu);
 }
 
-void perf_enable(void)
+void perf_pmu_enable(struct pmu *pmu)
 {
-	if (!--__get_cpu_var(perf_disable_count))
-		hw_perf_enable();
+	int *count = this_cpu_ptr(pmu->pmu_disable_count);
+	if (!--(*count))
+		pmu->pmu_enable(pmu);
 }
 
 static void get_ctx(struct perf_event_context *ctx)
@@ -4970,11 +4967,19 @@ static struct srcu_struct pmus_srcu;
 
 int perf_pmu_register(struct pmu *pmu)
 {
+	int ret;
+
 	mutex_lock(&pmus_lock);
+	ret = -ENOMEM;
+	pmu->pmu_disable_count = alloc_percpu(int);
+	if (!pmu->pmu_disable_count)
+		goto unlock;
 	list_add_rcu(&pmu->entry, &pmus);
+	ret = 0;
+unlock:
 	mutex_unlock(&pmus_lock);
 
-	return 0;
+	return ret;
 }
 
 void perf_pmu_unregister(struct pmu *pmu)
@@ -4984,6 +4989,8 @@ void perf_pmu_unregister(struct pmu *pmu)
 	mutex_unlock(&pmus_lock);
 
 	synchronize_srcu(&pmus_srcu);
+
+	free_percpu(pmu->pmu_disable_count);
 }
 
 struct pmu *perf_init_event(struct perf_event *event)
