Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0L0PiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:38:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:1432 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab0L0PiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:38:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,234,1291622400"; 
   d="scan'208";a="872197332"
Subject: [PATCH 5/7] perf: Optimise topology iteration
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, robert.richter@amd.com
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Dec 2010 23:38:07 +0800
Message-Id: <1293464287.2695.106.camel@localhost>
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
 arch/x86/kernel/cpu/perf_event_amd.c   |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 67e2202..5a3b7b8 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -323,7 +323,7 @@ static void amd_pmu_cpu_starting(int cpu)
 	nb_id = amd_get_nb_id(cpu);
 	WARN_ON_ONCE(nb_id == BAD_APICID);
 
-	for_each_online_cpu(i) {
+	for_each_cpu(i, topology_core_cpumask(cpu)) {
 		nb = per_cpu(cpu_hw_events, i).amd_nb;
 		if (WARN_ON_ONCE(!nb))
 			continue;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 354d1de..ad70c2c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1111,7 +1111,7 @@ static void intel_pmu_cpu_starting(int cpu)
 	if (!ht_enabled(cpu))
 		return;
 
-	for_each_online_cpu(i) {
+	for_each_cpu(i, topology_thread_cpumask(cpu)) {
 		struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
 
 		if (pc && pc->core_id == core_id) {
-- 
1.7.3





