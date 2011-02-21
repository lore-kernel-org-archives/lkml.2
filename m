Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072Ab1BUFAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 00:00:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:41032 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab1BUFAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 00:00:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,198,1297065600"; 
   d="scan'208";a="391632341"
Subject: Re: [PATCH 5/6] perf: Optimise topology iteration
From: Lin Ming <ming.m.lin@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110221033235.GW5818@one.firstfloor.org>
References: <1298221059.2318.70.camel@localhost>
	 <20110220211512.GT5818@one.firstfloor.org>
	 <1298258964.17806.48.camel@minggr.sh.intel.com>
	 <20110221033235.GW5818@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 13:01:16 +0800
Message-ID: <1298264476.17806.57.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-21 at 11:32 +0800, Andi Kleen wrote:
> On Mon, Feb 21, 2011 at 11:29:24AM +0800, Lin Ming wrote:
> > On Mon, 2011-02-21 at 05:15 +0800, Andi Kleen wrote:
> > > On Mon, Feb 21, 2011 at 12:57:39AM +0800, Lin Ming wrote:
> > > > Currently we iterate the full machine looking for a matching core_id/nb
> > > > for the percore and the amd northbridge stuff , using a smaller topology
> > > > mask makes sense.
> > > 
> > > This is still wrong for CPU hotplug. The CPU "owning" the per core
> > > does not necessarily need to be online anymore.
> > 
> > This is remain issue for hotplug case, no matter we use
> > for_each_online_cpu or topology_thread_cpumask.
> 
> The original code I submitted used for_each_possible_cpu which
> is correct.
> 
> > 
> > > Please drop this patch.
> > 
> > Re-look at the code, I think for_each_online_cpu is wrong for percore,
> > we should use topology_thread_cpumask instead.
> 
> No, that's also cleared on unplug. You really need the possible map
> and nothing else.

That's wrong for kernel initialization, not related to hotplug.

I wrote a simple debug patch,

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f152930..913a8a5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1123,7 +1123,7 @@ static void intel_pmu_cpu_starting(int cpu)
 	if (!ht_capable())
 		return;
 
-	for_each_cpu(i, topology_thread_cpumask(cpu)) {
+	for_each_possible_cpu(i) {
 		struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;
 
 		if (pc && pc->core_id == core_id) {
@@ -1135,6 +1135,9 @@ static void intel_pmu_cpu_starting(int cpu)
 
 	cpuc->per_core->core_id = core_id;
 	cpuc->per_core->refcnt++;
+
+	printk("DEBUG: cpu%d, per_core %p, core_id: %d, ref_count: %d\n",
+		cpu, cpuc->per_core, cpuc->per_core->core_id, cpuc->per_core->refcnt);
 }
 
 static void intel_pmu_cpu_dying(int cpu)

The output as below,

DEBUG: cpu0, per_core ffff8801bec32600, core_id: 0, ref_count: 1
DEBUG: cpu1, per_core ffff8801bec32600, core_id: 0, ref_count: 2
DEBUG: cpu2, per_core ffff8801bec32a20, core_id: 1, ref_count: 1
DEBUG: cpu3, per_core ffff8801bec32a20, core_id: 1, ref_count: 2
DEBUG: cpu4, per_core ffff8801bec32de0, core_id: 2, ref_count: 1
DEBUG: cpu5, per_core ffff8801bec32de0, core_id: 2, ref_count: 2
DEBUG: cpu6, per_core ffff8801becfc120, core_id: 3, ref_count: 1
DEBUG: cpu7, per_core ffff8801becfc120, core_id: 3, ref_count: 2
DEBUG: cpu8, per_core ffff8801bec32600, core_id: 0, ref_count: 3
DEBUG: cpu9, per_core ffff8801bec32600, core_id: 0, ref_count: 4
DEBUG: cpu10, per_core ffff8801bec32a20, core_id: 1, ref_count: 3
DEBUG: cpu11, per_core ffff8801bec32a20, core_id: 1, ref_count: 4
DEBUG: cpu12, per_core ffff8801bec32de0, core_id: 2, ref_count: 3
DEBUG: cpu13, per_core ffff8801bec32de0, core_id: 2, ref_count: 4
DEBUG: cpu14, per_core ffff8801becfc120, core_id: 3, ref_count: 3
DEBUG: cpu15, per_core ffff8801becfc120, core_id: 3, ref_count: 4

As you can see, cpu0, cpu1, cpu8 and cpu9 share the same per_core(ffff8801bec32600).
This is wrong.

cpu0 and cpu8 should share one pef_core, cpu1 and cpu9 share another per_core.

> 
> -Andi


