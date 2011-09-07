Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1IGQc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:32:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:38245 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab1IGQcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:32:53 -0400
Subject: Re: v3.1-rc5: Weird kernel log message when resuming avout NMI
 received
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 07 Sep 2011 10:00:51 +0200
In-Reply-To: <CAC9WiBiNj-NS2mb8SaR1pK2JQdJOAbnN_rCXk1ZEMNaWQWZwxQ@mail.gmail.com>
References: <CAC9WiBiNj-NS2mb8SaR1pK2JQdJOAbnN_rCXk1ZEMNaWQWZwxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315382451.11101.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 08:37 +0200, Francis Moreau wrote:
> 
> > After the second suspend/resume sequence I still have the same warning
> > except that the reason has changed to '2d':
> >
> >  kernel:[  404.091393] Uhhuh. NMI received for unknown reason 2d on CPU 0.
> >  kernel:[  404.091394] Do you have a strange power saving mode enabled?
> >  kernel:[  404.091396] Dazed and confused, but trying to continue

I'm somewhat out of ideas there..  I guess I'll have to go debug on my
laptop which hasn't got a serial port :-(

Rafael, can you see anything obviously broken in the below patch from a
s2r pov?

---
>From 144060fee07e9c22e179d00819c83c86fbcbf82c Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 1 Aug 2011 12:49:14 +0200
Subject: [PATCH] perf: Add PM notifiers to fix CPU hotplug races

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

