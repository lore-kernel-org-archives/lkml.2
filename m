Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1HNPxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:53:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:40199 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab1HNPxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:53:10 -0400
Date: Sun, 14 Aug 2011 15:52:52 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-1cvevybkgmv4s6v5y37t4847@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        francis.moro@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, francis.moro@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add PM notifiers to fix CPU hotplug races
Git-Commit-ID: 144060fee07e9c22e179d00819c83c86fbcbf82c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:52:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  144060fee07e9c22e179d00819c83c86fbcbf82c
Gitweb:     http://git.kernel.org/tip/144060fee07e9c22e179d00819c83c86fbcbf82c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 1 Aug 2011 12:49:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 11:53:03 +0200

perf: Add PM notifiers to fix CPU hotplug races

Francis reports that s2r gets him spurious NMIs, this is because the
suspend code leaves the boot cpu up and running.

Cure this by adding a suspend notifier. The problem is that hotplug
and suspend are completely un-serialized and the PM notifiers run
before the suspend cpu unplug of all but the boot cpu.

This leaves a window where the user can initialize another hotplug
operation (either remove or add a cpu) resulting in either one too
many or one too few hotplug ops. Thus we cannot use the hotplug code
for the suspend case.

There's another reason to not use the hotplug code, which is that the
hotplug code totally destroys the perf state, we can do better for
suspend and simply remove all counters from the PMU so that we can
re-instate them on resume.

Reported-by: Francis Moreau <francis.moro@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-1cvevybkgmv4s6v5y37t4847@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |   97 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b8785e2..d4c8542 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -29,6 +29,7 @@
 #include <linux/hardirq.h>
 #include <linux/rculist.h>
 #include <linux/uaccess.h>
+#include <linux/suspend.h>
 #include <linux/syscalls.h>
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
@@ -6809,7 +6810,7 @@ static void __cpuinit perf_event_init_cpu(int cpu)
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
 	mutex_lock(&swhash->hlist_mutex);
-	if (swhash->hlist_refcount > 0) {
+	if (swhash->hlist_refcount > 0 && !swhash->swevent_hlist) {
 		struct swevent_hlist *hlist;
 
 		hlist = kzalloc_node(sizeof(*hlist), GFP_KERNEL, cpu_to_node(cpu));
@@ -6898,7 +6899,14 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
 
-	switch (action & ~CPU_TASKS_FROZEN) {
+	/*
+	 * Ignore suspend/resume action, the perf_pm_notifier will
+	 * take care of that.
+	 */
+	if (action & CPU_TASKS_FROZEN)
+		return NOTIFY_OK;
+
+	switch (action) {
 
 	case CPU_UP_PREPARE:
 	case CPU_DOWN_FAILED:
@@ -6917,6 +6925,90 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
+static void perf_pm_resume_cpu(void *unused)
+{
+	struct perf_cpu_context *cpuctx;
+	struct perf_event_context *ctx;
+	struct pmu *pmu;
+	int idx;
+
+	idx = srcu_read_lock(&pmus_srcu);
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		ctx = cpuctx->task_ctx;
+
+		perf_ctx_lock(cpuctx, ctx);
+		perf_pmu_disable(cpuctx->ctx.pmu);
+
+		cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+		if (ctx)
+			ctx_sched_out(ctx, cpuctx, EVENT_ALL);
+
+		perf_pmu_enable(cpuctx->ctx.pmu);
+		perf_ctx_unlock(cpuctx, ctx);
+	}
+	srcu_read_unlock(&pmus_srcu, idx);
+}
+
+static void perf_pm_suspend_cpu(void *unused)
+{
+	struct perf_cpu_context *cpuctx;
+	struct perf_event_context *ctx;
+	struct pmu *pmu;
+	int idx;
+
+	idx = srcu_read_lock(&pmus_srcu);
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		ctx = cpuctx->task_ctx;
+
+		perf_ctx_lock(cpuctx, ctx);
+		perf_pmu_disable(cpuctx->ctx.pmu);
+
+		perf_event_sched_in(cpuctx, ctx, current);
+
+		perf_pmu_enable(cpuctx->ctx.pmu);
+		perf_ctx_unlock(cpuctx, ctx);
+	}
+	srcu_read_unlock(&pmus_srcu, idx);
+}
+
+static int perf_resume(void)
+{
+	get_online_cpus();
+	smp_call_function(perf_pm_resume_cpu, NULL, 1);
+	put_online_cpus();
+
+	return NOTIFY_OK;
+}
+
+static int perf_suspend(void)
+{
+	get_online_cpus();
+	smp_call_function(perf_pm_suspend_cpu, NULL, 1);
+	put_online_cpus();
+
+	return NOTIFY_OK;
+}
+
+static int perf_pm(struct notifier_block *self, unsigned long action, void *ptr)
+{
+	switch (action) {
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		return perf_resume();
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		return perf_suspend();
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static struct notifier_block perf_pm_notifier = {
+	.notifier_call = perf_pm,
+};
+
 void __init perf_event_init(void)
 {
 	int ret;
@@ -6931,6 +7023,7 @@ void __init perf_event_init(void)
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
 	register_reboot_notifier(&perf_reboot_notifier);
+	register_pm_notifier(&perf_pm_notifier);
 
 	ret = init_hw_breakpoint();
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
