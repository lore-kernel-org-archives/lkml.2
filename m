Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab0DBTHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:07:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:47761 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab0DBTHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:07:48 -0400
Date: Fri, 2 Apr 2010 19:07:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1269353485.5109.48.camel@twins>
References: <1269353485.5109.48.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Fix AMD hotplug & constraint initialization
Message-ID: <tip-b38b24ead33417146e051453d04bf60b8d2d7e25@git.kernel.org>
Git-Commit-ID: b38b24ead33417146e051453d04bf60b8d2d7e25
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:07:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b38b24ead33417146e051453d04bf60b8d2d7e25
Gitweb:     http://git.kernel.org/tip/b38b24ead33417146e051453d04bf60b8d2d7e25
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 23 Mar 2010 19:31:15 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 19:30:02 +0200

perf, x86: Fix AMD hotplug & constraint initialization

Commit 3f6da39 ("perf: Rework and fix the arch CPU-hotplug hooks") moved
the amd northbridge allocation from CPUS_ONLINE to CPUS_PREPARE_UP
however amd_nb_id() doesn't work yet on prepare so it would simply bail
basically reverting to a state where we do not properly track node wide
constraints - causing weird perf results.

Fix up the AMD NorthBridge initialization code by allocating from
CPU_UP_PREPARE and installing it from CPU_STARTING once we have the
proper nb_id. It also properly deals with the allocation failing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
[ robustify using amd_has_nb() ]
Signed-off-by: Stephane Eranian <eranian@google.com>
LKML-Reference: <1269353485.5109.48.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c     |    8 ++-
 arch/x86/kernel/cpu/perf_event_amd.c |   80 ++++++++++++++++++++--------------
 2 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5fb490c..bd28cf9 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -158,7 +158,7 @@ struct x86_pmu {
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
 
-	void		(*cpu_prepare)(int cpu);
+	int		(*cpu_prepare)(int cpu);
 	void		(*cpu_starting)(int cpu);
 	void		(*cpu_dying)(int cpu);
 	void		(*cpu_dead)(int cpu);
@@ -1333,11 +1333,12 @@ static int __cpuinit
 x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
+	int ret = NOTIFY_OK;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
 		if (x86_pmu.cpu_prepare)
-			x86_pmu.cpu_prepare(cpu);
+			ret = x86_pmu.cpu_prepare(cpu);
 		break;
 
 	case CPU_STARTING:
@@ -1350,6 +1351,7 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 			x86_pmu.cpu_dying(cpu);
 		break;
 
+	case CPU_UP_CANCELED:
 	case CPU_DEAD:
 		if (x86_pmu.cpu_dead)
 			x86_pmu.cpu_dead(cpu);
@@ -1359,7 +1361,7 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 		break;
 	}
 
-	return NOTIFY_OK;
+	return ret;
 }
 
 static void __init pmu_check_apic(void)
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index b87e0b6..db6f7d4 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -137,6 +137,13 @@ static inline int amd_is_nb_event(struct hw_perf_event *hwc)
 	return (hwc->config & 0xe0) == 0xe0;
 }
 
+static inline int amd_has_nb(struct cpu_hw_events *cpuc)
+{
+	struct amd_nb *nb = cpuc->amd_nb;
+
+	return nb && nb->nb_id != -1;
+}
+
 static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 				      struct perf_event *event)
 {
@@ -147,7 +154,7 @@ static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 	/*
 	 * only care about NB events
 	 */
-	if (!(nb && amd_is_nb_event(hwc)))
+	if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
 		return;
 
 	/*
@@ -214,7 +221,7 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	/*
 	 * if not NB event or no NB, then no constraints
 	 */
-	if (!(nb && amd_is_nb_event(hwc)))
+	if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
 		return &unconstrained;
 
 	/*
@@ -293,51 +300,55 @@ static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
 	return nb;
 }
 
-static void amd_pmu_cpu_online(int cpu)
+static int amd_pmu_cpu_prepare(int cpu)
+{
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+
+	WARN_ON_ONCE(cpuc->amd_nb);
+
+	if (boot_cpu_data.x86_max_cores < 2)
+		return NOTIFY_OK;
+
+	cpuc->amd_nb = amd_alloc_nb(cpu, -1);
+	if (!cpuc->amd_nb)
+		return NOTIFY_BAD;
+
+	return NOTIFY_OK;
+}
+
+static void amd_pmu_cpu_starting(int cpu)
 {
-	struct cpu_hw_events *cpu1, *cpu2;
-	struct amd_nb *nb = NULL;
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+	struct amd_nb *nb;
 	int i, nb_id;
 
 	if (boot_cpu_data.x86_max_cores < 2)
 		return;
 
-	/*
-	 * function may be called too early in the
-	 * boot process, in which case nb_id is bogus
-	 */
 	nb_id = amd_get_nb_id(cpu);
-	if (nb_id == BAD_APICID)
-		return;
-
-	cpu1 = &per_cpu(cpu_hw_events, cpu);
-	cpu1->amd_nb = NULL;
+	WARN_ON_ONCE(nb_id == BAD_APICID);
 
 	raw_spin_lock(&amd_nb_lock);
 
 	for_each_online_cpu(i) {
-		cpu2 = &per_cpu(cpu_hw_events, i);
-		nb = cpu2->amd_nb;
-		if (!nb)
+		nb = per_cpu(cpu_hw_events, i).amd_nb;
+		if (WARN_ON_ONCE(!nb))
 			continue;
-		if (nb->nb_id == nb_id)
-			goto found;
-	}
 
-	nb = amd_alloc_nb(cpu, nb_id);
-	if (!nb) {
-		pr_err("perf_events: failed NB allocation for CPU%d\n", cpu);
-		raw_spin_unlock(&amd_nb_lock);
-		return;
+		if (nb->nb_id == nb_id) {
+			kfree(cpuc->amd_nb);
+			cpuc->amd_nb = nb;
+			break;
+		}
 	}
-found:
-	nb->refcnt++;
-	cpu1->amd_nb = nb;
+
+	cpuc->amd_nb->nb_id = nb_id;
+	cpuc->amd_nb->refcnt++;
 
 	raw_spin_unlock(&amd_nb_lock);
 }
 
-static void amd_pmu_cpu_offline(int cpu)
+static void amd_pmu_cpu_dead(int cpu)
 {
 	struct cpu_hw_events *cpuhw;
 
@@ -349,8 +360,10 @@ static void amd_pmu_cpu_offline(int cpu)
 	raw_spin_lock(&amd_nb_lock);
 
 	if (cpuhw->amd_nb) {
-		if (--cpuhw->amd_nb->refcnt == 0)
-			kfree(cpuhw->amd_nb);
+		struct amd_nb *nb = cpuhw->amd_nb;
+
+		if (nb->nb_id == -1 || --nb->refcnt == 0)
+			kfree(nb);
 
 		cpuhw->amd_nb = NULL;
 	}
@@ -379,8 +392,9 @@ static __initconst struct x86_pmu amd_pmu = {
 	.get_event_constraints	= amd_get_event_constraints,
 	.put_event_constraints	= amd_put_event_constraints,
 
-	.cpu_prepare		= amd_pmu_cpu_online,
-	.cpu_dead		= amd_pmu_cpu_offline,
+	.cpu_prepare		= amd_pmu_cpu_prepare,
+	.cpu_starting		= amd_pmu_cpu_starting,
+	.cpu_dead		= amd_pmu_cpu_dead,
 };
 
 static __init int amd_pmu_init(void)
