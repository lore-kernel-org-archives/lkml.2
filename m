Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab2JSVcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:32:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41810 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab2JSVct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:32:49 -0400
Date: Fri, 19 Oct 2012 17:33:38 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com
Subject: [PATCH 3/3] perf_event: remove cpuc->enabled check
In-Reply-To: <alpine.DEB.2.02.1210191722430.14552@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1210191732000.14552@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210191722430.14552@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Between 2.6.33 and 2.6.34 the PMU code was made modular.
The x86_pmu_enable() call was extended to disable cpuc->enabled 
and iterate the counters, enabling one at a time, before calling 
enable_all() at the end, followed by re-enabling cpuc->enabled.

Since cpuc->enabled was set to 0, that change effectively caused
the "val |= ARCH_PERFMON_EVENTSEL_ENABLE;" code in p6_pmu_enable_event()
and p6_pmu_disable_event() to be dead code that was never called.

This change removes this code (which was confusing) and adds some
extra commentary to make it more clear what is going on.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff -ur linux-3.7-rc1.orig/arch/x86/kernel/cpu/perf_event_p6.c linux-3.7-rc1/arch/x86/kernel/cpu/perf_event_p6.c
--- linux-3.7-rc1.orig/arch/x86/kernel/cpu/perf_event_p6.c	2012-10-14 17:41:04.000000000 -0400
+++ linux-3.7-rc1/arch/x86/kernel/cpu/perf_event_p6.c	2012-10-19 15:58:50.416238172 -0400
@@ -64,25 +64,25 @@
 static inline void
 p6_pmu_disable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 val = P6_NOP_EVENT;
 
-	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
-
 	(void)wrmsrl_safe(hwc->config_base, val);
 }
 
 static void p6_pmu_enable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 val;
 
 	val = hwc->config;
-	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
+
+	/*
+	 * p6 only has a global event enable, set on PerfEvtSel0
+	 * We "disable" events by programming P6_NOP_EVENT
+	 * and we rely on p6_pmu_enable_all() being called
+	 * to actually enable the events.
+	 */
 
 	(void)wrmsrl_safe(hwc->config_base, val);
 }
