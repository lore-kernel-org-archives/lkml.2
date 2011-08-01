Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1HALAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:00:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55515 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1HALAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:00:24 -0400
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Francis Moreau <francis.moro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110731153225.GJ2209@sun>
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
	 <20110731110641.GG2209@sun>
	 <CAC9WiBgg+To8ggUvTqxOCy2hgb=XQCRH6D_0HFy4sEEoF8R0rw@mail.gmail.com>
	 <20110731153225.GJ2209@sun>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 13:05:02 +0200
Message-ID: <1312196702.2617.445.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-31 at 19:32 +0400, Cyrill Gorcunov wrote:

> > >> I'm seeing those kernel message when resuming:
> > >>
> > >> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
> > >> [  524.973288] Do you have a strange power saving mode enabled?
> > >> [  524.973289] Dazed and confused, but trying to continue
> > >>
> > >> I don't know if it's important or not because the system seems to work
> > >> after but maybe it worths to report

So I guess the problem is the NMI watchdog and suspend stuff not
shutting things down properly.. 

Argh, the PM notifier muck runs before the hotplug notifiers and it
doesn't avoid hotplug races on its own.. what crap.

something like the below perhaps, compile tested only.. does it work?

---
Subject: perf: Add PM notifiers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Aug 01 12:49:14 CEST 2011

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
---
 kernel/events/core.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 95 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -29,6 +29,7 @@
 #include <linux/hardirq.h>
 #include <linux/rculist.h>
 #include <linux/uaccess.h>
+#include <linux/suspend.h>
 #include <linux/syscalls.h>
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
@@ -6809,7 +6810,7 @@ static void __cpuinit perf_event_init_cp
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
 	mutex_lock(&swhash->hlist_mutex);
-	if (swhash->hlist_refcount > 0) {
+	if (swhash->hlist_refcount > 0 && !swhash->swevent_hlist) {
 		struct swevent_hlist *hlist;
 
 		hlist = kzalloc_node(sizeof(*hlist), GFP_KERNEL, cpu_to_node(cpu));
@@ -6898,7 +6899,14 @@ perf_cpu_notify(struct notifier_block *s
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
@@ -6917,6 +6925,90 @@ perf_cpu_notify(struct notifier_block *s
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


