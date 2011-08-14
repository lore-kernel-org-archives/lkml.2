Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1HNPwB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:52:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:40176 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab1HNPv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:51:59 -0400
Date: Sun, 14 Aug 2011 15:51:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-kwd4j6ayld5thrscvaxgjquv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Avoid kfree() in CPU_STARTING
Git-Commit-ID: 7fdba1ca10462f42ad2246b918fe6368f5ce488e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:51:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fdba1ca10462f42ad2246b918fe6368f5ce488e
Gitweb:     http://git.kernel.org/tip/7fdba1ca10462f42ad2246b918fe6368f5ce488e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 22 Jul 2011 13:41:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 11:53:02 +0200

perf, x86: Avoid kfree() in CPU_STARTING

On -rt kfree() can schedule, but CPU_STARTING is before the CPU is
fully up and running. These are contradictory, so avoid it. Instead
push the kfree() to CPU_ONLINE where we're free to schedule.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-kwd4j6ayld5thrscvaxgjquv@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |    8 ++++++++
 arch/x86/kernel/cpu/perf_event_amd.c   |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)

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
