Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1BTQ5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 11:57:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:7928 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab1BTQ5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 11:57:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,195,1297065600"; 
   d="scan'208";a="391495093"
Subject: [PATCH 5/6] perf: Optimise topology iteration
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 00:57:39 +0800
Message-Id: <1298221059.2318.70.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we iterate the full machine looking for a matching core_id/nb
for the percore and the amd northbridge stuff , using a smaller topology
mask makes sense.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event_amd.c   |    3 ++-
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 461f62b..7217d84 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -320,6 +320,7 @@ static void amd_pmu_cpu_starting(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 	struct amd_nb *nb;
+	const struct cpumask *mask = cpu_coregroup_mask(cpu);
 	int i, nb_id;
 
 	if (boot_cpu_data.x86_max_cores < 2)
@@ -328,7 +329,7 @@ static void amd_pmu_cpu_starting(int cpu)
 	nb_id = amd_get_nb_id(cpu);
 	WARN_ON_ONCE(nb_id == BAD_APICID);
 
-	for_each_online_cpu(i) {
+	for_each_cpu(i, mask) {
 		nb = per_cpu(cpu_hw_events, i).amd_nb;
 		if (WARN_ON_ONCE(!nb))
 			continue;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 059c0ab..5540d35 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1123,7 +1123,7 @@ static void intel_pmu_cpu_starting(int cpu)
 	if (!ht_capable())
 		return;
 
-	for_each_online_cpu(i) {
+	for_each_cpu(i, topology_thread_cpumask(cpu)) {
 		struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
 
 		if (pc && pc->core_id == core_id) {
-- 
1.7.3



