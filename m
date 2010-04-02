Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab0DBTKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:10:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:38650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab0DBTKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:10:19 -0400
Date: Fri, 2 Apr 2010 19:09:43 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, gorcunov@gmail.com,
       robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
In-Reply-To: <1269968113.5258.442.camel@laptop>
References: <1269968113.5258.442.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Fix up the ANY flag stuff
Message-ID: <tip-b4cdc5c264b35c67007800dec3928e9547a9d70b@git.kernel.org>
Git-Commit-ID: b4cdc5c264b35c67007800dec3928e9547a9d70b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:09:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b4cdc5c264b35c67007800dec3928e9547a9d70b
Gitweb:     http://git.kernel.org/tip/b4cdc5c264b35c67007800dec3928e9547a9d70b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 30 Mar 2010 17:00:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 19:52:04 +0200

perf, x86: Fix up the ANY flag stuff

Stephane noticed that the ANY flag was in generic arch code, and Cyrill
reported that it broke the P4 code.

Solve this by merging x86_pmu::raw_event into x86_pmu::hw_config and
provide intel_pmu and amd_pmu specific versions of this callback.

The intel_pmu one deals with the ANY flag, the amd_pmu adds the few extra
event bits AMD64 has.

Reported-by: Stephane Eranian <eranian@google.com>
Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Robert Richter <robert.richter@amd.com>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1269968113.5258.442.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |   35 +++++++++------------------
 arch/x86/kernel/cpu/perf_event_amd.c   |   17 ++++++++++---
 arch/x86/kernel/cpu/perf_event_intel.c |   30 ++++++++++++++++++++---
 arch/x86/kernel/cpu/perf_event_p4.c    |   40 +++++++++++++++++--------------
 arch/x86/kernel/cpu/perf_event_p6.c    |    3 +-
 5 files changed, 74 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1dd42c1..65e9c5e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -196,12 +196,11 @@ struct x86_pmu {
 	void		(*enable_all)(int added);
 	void		(*enable)(struct perf_event *);
 	void		(*disable)(struct perf_event *);
-	int		(*hw_config)(struct perf_event_attr *attr, struct hw_perf_event *hwc);
+	int		(*hw_config)(struct perf_event *event);
 	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
 	unsigned	eventsel;
 	unsigned	perfctr;
 	u64		(*event_map)(int);
-	u64		(*raw_event)(u64);
 	int		max_events;
 	int		num_counters;
 	int		num_counters_fixed;
@@ -426,28 +425,26 @@ set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event_attr *attr)
 	return 0;
 }
 
-static int x86_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc)
+static int x86_pmu_hw_config(struct perf_event *event)
 {
 	/*
 	 * Generate PMC IRQs:
 	 * (keep 'enabled' bit clear for now)
 	 */
-	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
+	event->hw.config = ARCH_PERFMON_EVENTSEL_INT;
 
 	/*
 	 * Count user and OS events unless requested not to
 	 */
-	if (!attr->exclude_user)
-		hwc->config |= ARCH_PERFMON_EVENTSEL_USR;
-	if (!attr->exclude_kernel)
-		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
+	if (!event->attr.exclude_user)
+		event->hw.config |= ARCH_PERFMON_EVENTSEL_USR;
+	if (!event->attr.exclude_kernel)
+		event->hw.config |= ARCH_PERFMON_EVENTSEL_OS;
 
-	return 0;
-}
+	if (event->attr.type == PERF_TYPE_RAW)
+		event->hw.config |= event->attr.config & X86_RAW_EVENT_MASK;
 
-static u64 x86_pmu_raw_event(u64 hw_event)
-{
-	return hw_event & X86_RAW_EVENT_MASK;
+	return 0;
 }
 
 /*
@@ -489,7 +486,7 @@ static int __hw_perf_event_init(struct perf_event *event)
 	hwc->last_tag = ~0ULL;
 
 	/* Processor specifics */
-	err = x86_pmu.hw_config(attr, hwc);
+	err = x86_pmu.hw_config(event);
 	if (err)
 		return err;
 
@@ -508,16 +505,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 			return -EOPNOTSUPP;
 	}
 
-	/*
-	 * Raw hw_event type provide the config in the hw_event structure
-	 */
-	if (attr->type == PERF_TYPE_RAW) {
-		hwc->config |= x86_pmu.raw_event(attr->config);
-		if ((hwc->config & ARCH_PERFMON_EVENTSEL_ANY) &&
-		    perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
-			return -EACCES;
+	if (attr->type == PERF_TYPE_RAW)
 		return 0;
-	}
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, attr);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 37e9517..bbd7339 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -111,9 +111,19 @@ static u64 amd_pmu_event_map(int hw_event)
 	return amd_perfmon_event_map[hw_event];
 }
 
-static u64 amd_pmu_raw_event(u64 hw_event)
+static int amd_pmu_hw_config(struct perf_event *event)
 {
-	return hw_event & AMD64_RAW_EVENT_MASK;
+	int ret = x86_pmu_hw_config(event);
+
+	if (ret)
+		return ret;
+
+	if (event->attr.type != PERF_TYPE_RAW)
+		return 0;
+
+	event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
+
+	return 0;
 }
 
 /*
@@ -365,12 +375,11 @@ static __initconst struct x86_pmu amd_pmu = {
 	.enable_all		= x86_pmu_enable_all,
 	.enable			= x86_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
-	.hw_config		= x86_hw_config,
+	.hw_config		= amd_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_K7_EVNTSEL0,
 	.perfctr		= MSR_K7_PERFCTR0,
 	.event_map		= amd_pmu_event_map,
-	.raw_event		= amd_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
 	.num_counters		= 4,
 	.cntval_bits		= 48,
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index dfdd6f9..30bf10c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -758,6 +758,30 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
 	return x86_get_event_constraints(cpuc, event);
 }
 
+static int intel_pmu_hw_config(struct perf_event *event)
+{
+	int ret = x86_pmu_hw_config(event);
+
+	if (ret)
+		return ret;
+
+	if (event->attr.type != PERF_TYPE_RAW)
+		return 0;
+
+	if (!(event->attr.config & ARCH_PERFMON_EVENTSEL_ANY))
+		return 0;
+
+	if (x86_pmu.version < 3)
+		return -EINVAL;
+
+	if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	event->hw.config |= ARCH_PERFMON_EVENTSEL_ANY;
+
+	return 0;
+}
+
 static __initconst struct x86_pmu core_pmu = {
 	.name			= "core",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -765,12 +789,11 @@ static __initconst struct x86_pmu core_pmu = {
 	.enable_all		= x86_pmu_enable_all,
 	.enable			= x86_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
-	.hw_config		= x86_hw_config,
+	.hw_config		= x86_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
 	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
 	.event_map		= intel_pmu_event_map,
-	.raw_event		= x86_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
 	.apic			= 1,
 	/*
@@ -804,12 +827,11 @@ static __initconst struct x86_pmu intel_pmu = {
 	.enable_all		= intel_pmu_enable_all,
 	.enable			= intel_pmu_enable_event,
 	.disable		= intel_pmu_disable_event,
-	.hw_config		= x86_hw_config,
+	.hw_config		= intel_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
 	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
 	.event_map		= intel_pmu_event_map,
-	.raw_event		= x86_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
 	.apic			= 1,
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 4139100..acd237d 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -419,20 +419,7 @@ static u64 p4_pmu_event_map(int hw_event)
 	return config;
 }
 
-/*
- * We don't control raw events so it's up to the caller
- * to pass sane values (and we don't count the thread number
- * on HT machine but allow HT-compatible specifics to be
- * passed on)
- */
-static u64 p4_pmu_raw_event(u64 hw_event)
-{
-	return hw_event &
-		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
-		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
-}
-
-static int p4_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc)
+static int p4_hw_config(struct perf_event *event)
 {
 	int cpu = raw_smp_processor_id();
 	u32 escr, cccr;
@@ -444,11 +431,29 @@ static int p4_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc)
 	 */
 
 	cccr = p4_default_cccr_conf(cpu);
-	escr = p4_default_escr_conf(cpu, attr->exclude_kernel, attr->exclude_user);
-	hwc->config = p4_config_pack_escr(escr) | p4_config_pack_cccr(cccr);
+	escr = p4_default_escr_conf(cpu, event->attr.exclude_kernel,
+					 event->attr.exclude_user);
+	event->hw.config = p4_config_pack_escr(escr) |
+			   p4_config_pack_cccr(cccr);
 
 	if (p4_ht_active() && p4_ht_thread(cpu))
-		hwc->config = p4_set_ht_bit(hwc->config);
+		event->hw.config = p4_set_ht_bit(event->hw.config);
+
+	if (event->attr.type != PERF_TYPE_RAW)
+		return 0;
+
+	/*
+	 * We don't control raw events so it's up to the caller
+	 * to pass sane values (and we don't count the thread number
+	 * on HT machine but allow HT-compatible specifics to be
+	 * passed on)
+	 *
+	 * XXX: HT wide things should check perf_paranoid_cpu() &&
+	 *      CAP_SYS_ADMIN
+	 */
+	event->hw.config |= event->attr.config &
+		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
+		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
 
 	return 0;
 }
@@ -785,7 +790,6 @@ static __initconst struct x86_pmu p4_pmu = {
 	.eventsel		= MSR_P4_BPU_CCCR0,
 	.perfctr		= MSR_P4_BPU_PERFCTR0,
 	.event_map		= p4_pmu_event_map,
-	.raw_event		= p4_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(p4_general_events),
 	.get_event_constraints	= x86_get_event_constraints,
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 03c139a..9123e8e 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -91,12 +91,11 @@ static __initconst struct x86_pmu p6_pmu = {
 	.enable_all		= p6_pmu_enable_all,
 	.enable			= p6_pmu_enable_event,
 	.disable		= p6_pmu_disable_event,
-	.hw_config		= x86_hw_config,
+	.hw_config		= x86_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_P6_EVNTSEL0,
 	.perfctr		= MSR_P6_PERFCTR0,
 	.event_map		= p6_pmu_event_map,
-	.raw_event		= x86_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(p6_perfmon_event_map),
 	.apic			= 1,
 	.max_period		= (1ULL << 31) - 1,
