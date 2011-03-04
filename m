Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637Ab1CDNE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:04:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:43006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759435Ab1CDNEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:04:25 -0500
Date: Fri, 4 Mar 2011 13:04:01 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1299119690-13991-5-git-send-email-ming.m.lin@intel.com>
References: <1299119690-13991-5-git-send-email-ming.m.lin@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Avoid the percore allocations if the CPU is not HT capable
Message-ID: <tip-90a37ed96b2be7a2ad86764589eabd6992657c89@git.kernel.org>
Git-Commit-ID: 90a37ed96b2be7a2ad86764589eabd6992657c89
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 13:04:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90a37ed96b2be7a2ad86764589eabd6992657c89
Gitweb:     http://git.kernel.org/tip/90a37ed96b2be7a2ad86764589eabd6992657c89
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Thu, 3 Mar 2011 10:34:50 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 12:51:10 +0100

perf: Avoid the percore allocations if the CPU is not HT capable

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1299119690-13991-5-git-send-email-ming.m.lin@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/smp.h             |   10 ++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c |   18 ++++++++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 1f46951..c1bbfa8 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -17,10 +17,20 @@
 #endif
 #include <asm/thread_info.h>
 #include <asm/cpumask.h>
+#include <asm/cpufeature.h>
 
 extern int smp_num_siblings;
 extern unsigned int num_processors;
 
+static inline bool cpu_has_ht_siblings(void)
+{
+	bool has_siblings = false;
+#ifdef CONFIG_SMP
+	has_siblings = cpu_has_ht && smp_num_siblings > 1;
+#endif
+	return has_siblings;
+}
+
 DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6e9b676..8fc2b2c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1205,6 +1205,9 @@ static int intel_pmu_cpu_prepare(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 
+	if (!cpu_has_ht_siblings())
+		return NOTIFY_OK;
+
 	cpuc->per_core = kzalloc_node(sizeof(struct intel_percore),
 				      GFP_KERNEL, cpu_to_node(cpu));
 	if (!cpuc->per_core)
@@ -1221,6 +1224,15 @@ static void intel_pmu_cpu_starting(int cpu)
 	int core_id = topology_core_id(cpu);
 	int i;
 
+	init_debug_store_on_cpu(cpu);
+	/*
+	 * Deal with CPUs that don't clear their LBRs on power-up.
+	 */
+	intel_pmu_lbr_reset();
+
+	if (!cpu_has_ht_siblings())
+		return;
+
 	for_each_cpu(i, topology_thread_cpumask(cpu)) {
 		struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
 
@@ -1233,12 +1245,6 @@ static void intel_pmu_cpu_starting(int cpu)
 
 	cpuc->per_core->core_id = core_id;
 	cpuc->per_core->refcnt++;
-
-	init_debug_store_on_cpu(cpu);
-	/*
-	 * Deal with CPUs that don't clear their LBRs on power-up.
-	 */
-	intel_pmu_lbr_reset();
 }
 
 static void intel_pmu_cpu_dying(int cpu)
