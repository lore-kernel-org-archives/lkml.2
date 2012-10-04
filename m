Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2JDJHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:07:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:59220 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2JDJHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:07:48 -0400
Message-ID: <1349341655.4438.7.camel@twins>
Subject: uncore doing kfree() from CPU_{STARTING,DYING}
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, mingo@kernel.org
Date: Thu, 04 Oct 2012 11:07:35 +0200
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zheng,

Can you have a look at 7fdba1ca and do a similar patch for uncore?
Thomas is sad because uncore breaks -rt, the problem (as described in
that patch) is that kfree() must schedule on -rt while
CPU_{STARTING,DYING} really are atomic.

~ Peter


---
commit 7fdba1ca10462f42ad2246b918fe6368f5ce488e
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Jul 22 13:41:54 2011 +0200

    perf, x86: Avoid kfree() in CPU_STARTING
    
    On -rt kfree() can schedule, but CPU_STARTING is before the CPU is
    fully up and running. These are contradictory, so avoid it. Instead
    push the kfree() to CPU_ONLINE where we're free to schedule.
    
    Reported-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/n/tip-kwd4j6ayld5thrscvaxgjquv@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4ee3abf..594d425 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -129,6 +129,8 @@ struct cpu_hw_events {
 	 * AMD specific bits
 	 */
 	struct amd_nb		*amd_nb;
+
+	void			*kfree_on_online;
 };
 
 #define __EVENT_CONSTRAINT(c, n, m, w) {\
@@ -1466,10 +1468,12 @@ static int __cpuinit
 x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 	int ret = NOTIFY_OK;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
+		cpuc->kfree_on_online = NULL;
 		if (x86_pmu.cpu_prepare)
 			ret = x86_pmu.cpu_prepare(cpu);
 		break;
@@ -1479,6 +1483,10 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 			x86_pmu.cpu_starting(cpu);
 		break;
 
+	case CPU_ONLINE:
+		kfree(cpuc->kfree_on_online);
+		break;
+
 	case CPU_DYING:
 		if (x86_pmu.cpu_dying)
 			x86_pmu.cpu_dying(cpu);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 941caa2..ee9436c 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -350,7 +350,7 @@ static void amd_pmu_cpu_starting(int cpu)
 			continue;
 
 		if (nb->nb_id == nb_id) {
-			kfree(cpuc->amd_nb);
+			cpuc->kfree_on_online = cpuc->amd_nb;
 			cpuc->amd_nb = nb;
 			break;
 		}
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f88af2c..3751494 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1362,7 +1362,7 @@ static void intel_pmu_cpu_starting(int cpu)
 
 		pc = per_cpu(cpu_hw_events, i).shared_regs;
 		if (pc && pc->core_id == core_id) {
-			kfree(cpuc->shared_regs);
+			cpuc->kfree_on_online = cpuc->shared_regs;
 			cpuc->shared_regs = pc;
 			break;
 		}

