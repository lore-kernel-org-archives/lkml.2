Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab2JQRDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:03:49 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56980 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2JQRDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:03:48 -0400
Date: Wed, 17 Oct 2012 13:04:33 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: [PATCH 2/3] perf_event: Remove cpuc->enable check on KNC event
 enable/disable
In-Reply-To: <alpine.DEB.2.02.1210171256550.23243@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1210171303290.23243@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210171256550.23243@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86_pmu.enable() is called from x86_pmu_enable() with cpuc->enabled
set to 0.  This means we weren't re-enabling the counters after
a context switch.

This patch just removes the check, as it should't be necessary
(and the equivelent x86_ generic code does not have the checks).

The origin of this problem is the KNC driver being based on the P6 one.  
The P6 driver also has this issue, but works anyway due to various 
lucky accidents.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff -ur linux-3.7-rc1.orig/arch/x86/kernel/cpu/perf_event_knc.c linux-3.7-rc1/arch/x86/kernel/cpu/perf_event_knc.c
--- linux-3.7-rc1.orig/arch/x86/kernel/cpu/perf_event_knc.c	2012-10-14 17:41:04.000000000 -0400
+++ linux-3.7-rc1/arch/x86/kernel/cpu/perf_event_knc.c	2012-10-17 11:48:22.952394235 -0400
@@ -173,26 +173,22 @@
 static inline void
 knc_pmu_disable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 val;
 
 	val = hwc->config;
-	if (cpuc->enabled)
-		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+	val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 
 	(void)wrmsrl_safe(hwc->config_base + hwc->idx, val);
 }
 
 static void knc_pmu_enable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	u64 val;
 
 	val = hwc->config;
-	if (cpuc->enabled)
-		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
+	val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
 	(void)wrmsrl_safe(hwc->config_base + hwc->idx, val);
 }
