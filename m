Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0C3PBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 11:01:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58839 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab0C3PA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 11:00:58 -0400
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>
In-Reply-To: <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
	 <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com>
	 <20100330134145.GI11907@erda.amd.com>
	 <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 17:00:55 +0200
Message-ID: <1269961255.5258.221.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 15:53 +0200, Stephane Eranian wrote:
> > So, there are some ARCH_PERFMON_EVENTSEL_* masks that are Intel only,
> > which is true for ARCH_PERFMON_EVENTSEL_ANY. And indead, the code
> > should be checked for this. ARCH_PERFMON_EVENTSEL_ANY is always
> > cleared on AMD cpus, so this code is ok. Actually the bit is cleared
> 
> Until AMD uses that bit too and you won't notice this test. This is a security
> check specific to Intel and it should be in an Intel-specific function.
> 
> > for *all* cpus in x86_pmu_raw_event(), the code was and is broken for
> > this.
> >
> Yes, needs to be authorized for any perfmon v3 and later revisions.

So how about something like this on top of Robert's patches?

---
 arch/x86/kernel/cpu/perf_event.c       |   16 ++++++----------
 arch/x86/kernel/cpu/perf_event_amd.c   |    5 +++--
 arch/x86/kernel/cpu/perf_event_intel.c |   15 ++++++++++++++-
 arch/x86/kernel/cpu/perf_event_p4.c    |    5 +++--
 4 files changed, 26 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -201,7 +201,7 @@ struct x86_pmu {
 	unsigned	eventsel;
 	unsigned	perfctr;
 	u64		(*event_map)(int);
-	u64		(*raw_event)(u64);
+	int		(*raw_event)(struct perf_event *event);
 	int		max_events;
 	int		num_counters;
 	int		num_counters_fixed;
@@ -445,9 +445,10 @@ static int x86_hw_config(struct perf_eve
 	return 0;
 }
 
-static u64 x86_pmu_raw_event(u64 hw_event)
+static int x86_pmu_raw_event(struct perf_event *event)
 {
-	return hw_event & X86_RAW_EVENT_MASK;
+	event->hw.config |= event->attr.config & X86_RAW_EVENT_MASK;
+	return 0;
 }
 
 /*
@@ -511,13 +512,8 @@ static int __hw_perf_event_init(struct p
 	/*
 	 * Raw hw_event type provide the config in the hw_event structure
 	 */
-	if (attr->type == PERF_TYPE_RAW) {
-		hwc->config |= x86_pmu.raw_event(attr->config);
-		if ((hwc->config & ARCH_PERFMON_EVENTSEL_ANY) &&
-		    perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		return 0;
-	}
+	if (attr->type == PERF_TYPE_RAW)
+		return x86_pmu.raw_event(event);
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, attr);
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_amd.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
@@ -111,9 +111,10 @@ static u64 amd_pmu_event_map(int hw_even
 	return amd_perfmon_event_map[hw_event];
 }
 
-static u64 amd_pmu_raw_event(u64 hw_event)
+static int amd_pmu_raw_event(struct perf_event *event)
 {
-	return hw_event & AMD64_RAW_EVENT_MASK;
+	event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
+	return 0;
 }
 
 /*
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -758,6 +758,19 @@ intel_get_event_constraints(struct cpu_h
 	return x86_get_event_constraints(cpuc, event);
 }
 
+static int intel_pmu_raw_event(struct perf_event *event)
+{
+	int ret = x86_pmu_raw_event(event);
+	if (ret)
+		return ret;
+
+	if ((event->hw.config & ARCH_PERFMON_EVENTSEL_ANY) &&
+			perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	return 0;
+}
+
 static __initconst struct x86_pmu core_pmu = {
 	.name			= "core",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -809,7 +822,7 @@ static __initconst struct x86_pmu intel_
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
 	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
 	.event_map		= intel_pmu_event_map,
-	.raw_event		= x86_pmu_raw_event,
+	.raw_event		= intel_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
 	.apic			= 1,
 	/*
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
@@ -425,11 +425,12 @@ static u64 p4_pmu_event_map(int hw_event
  * on HT machine but allow HT-compatible specifics to be
  * passed on)
  */
-static u64 p4_pmu_raw_event(u64 hw_event)
+static int p4_pmu_raw_event(struct perf_event *event)
 {
-	return hw_event &
+	event->hw.config |= event->attr.config &
 		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
 		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
+	return 0;
 }
 
 static int p4_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc)


