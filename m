Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0LVIJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 03:09:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:13414 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab0LVIJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 03:09:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,212,1291622400"; 
   d="scan'208";a="639184230"
Subject: [RFC PATCH] perf: Add load latency monitoring on Intel
 Nehalem/Westmere
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 16:12:23 +0800
Message-ID: <1293005543.2565.156.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

This patch adds load latency monitoring on Intel Nehalem/Westmere.
It's applied on top of tip/master(3ea1f4f89) and Andi's offcore
patchsets are needed.

Updated perf offcore patchkit
http://marc.info/?l=linux-kernel&m=129103647731356&w=2

The load latency on Intel Nehalem/Westmere is monitored by event
MEM_INST_RETIRED.LATENCY_ABOVE_THRESHOLD(0x100b). It measures latency
from micro-operation (uop) dispatch to when data is globally observable
(GO).

To monitor load latency, both the PEBS_EN_CTRx and LL_EN_CTRx bits must
be set in IA32_PEBS_ENABLE register. And an extra MSR
MSR_PEBS_LD_LAT_THRESHOLD must be programmed with the desired latency
threshold in core clock cycles. Loads with latencies greater than this
value are counted.

The latency threshold is encoded in the upper 32 bits of
perf_event_attr::config and 'p' modifier must be used to enabel PEBS.

The default latency threshold is 3, as Intel manual says, "The minimum
value that may be programmed in this register is 3 (the minimum
detectable load latency is 4 core clock cycles)."

Here are some example outputs.

# perf top -e r100b:p

----------------------------------------------------------------------------------------------------
   PerfTop:    1800 irqs/sec  kernel:41.9%  exact:  0.0% [1000Hz raw 0x100b],  (all, 4 CPUs)
----------------------------------------------------------------------------------------------------

             samples  pcnt function                        DSO
             _______ _____ _______________________________ _________________________________________

              643.00 13.0% __lock_acquire                  [kernel.kallsyms]                        
              328.00  6.6% check_chain_key                 [kernel.kallsyms]                        
              308.00  6.2% mark_lock                       [kernel.kallsyms]                        
              286.00  5.8% lock_release                    [kernel.kallsyms]                        
              280.00  5.7% check_flags                     [kernel.kallsyms]                        
              239.00  4.8% use_config                      /home/mlin/linux-2.6/scripts/basic/fixdep
              201.00  4.1% trace_hardirqs_on_caller        [kernel.kallsyms]                        
              193.00  3.9% lock_acquire                    [kernel.kallsyms]                        
              182.00  3.7% validate_chain                  [kernel.kallsyms]                        
              162.00  3.3% __gconv_transform_utf8_internal /lib64/libc-2.8.so                       
              145.00  2.9% trace_hardirqs_off_caller       [kernel.kallsyms]                        
              115.00  2.3% mark_held_locks                 [kernel.kallsyms]                        
              102.00  2.1% __GI_mbrtowc                    /lib64/libc-2.8.so                       
               76.00  1.5% do_raw_spin_lock                [kernel.kallsyms]                        
               73.00  1.5% parse_dep_file                  /home/mlin/linux-2.6/scripts/basic/fixdep
               71.00  1.4% restore                         [kernel.kallsyms]                        
               59.00  1.2% _int_malloc                     /lib64/libc-2.8.so  

#Monitor load latency > 51 cycles
# perf top -e r510000100b:p

----------------------------------------------------------------------------------------------------
   PerfTop:    2055 irqs/sec  kernel:47.0%  exact:  0.0% [1000Hz raw 0x510000100b],  (all, 4 CPUs)
----------------------------------------------------------------------------------------------------

             samples  pcnt function                  DSO
             _______ _____ _________________________ _________________________________________

              419.00  9.8% __lock_acquire            [kernel.kallsyms]                        
              278.00  6.5% parse_dep_file            /home/mlin/linux-2.6/scripts/basic/fixdep
              195.00  4.6% find_get_page             [kernel.kallsyms]                        
              195.00  4.6% get_page_from_freelist    [kernel.kallsyms]                        
              184.00  4.3% __d_lookup                [kernel.kallsyms]                        
              180.00  4.2% memcmp                    [kernel.kallsyms]                        
              135.00  3.2% __rmqueue                 [kernel.kallsyms]                        
              123.00  2.9% __GI_strcmp               /lib64/libc-2.8.so                       
               92.00  2.2% unmap_vmas                [kernel.kallsyms]                        
               88.00  2.1% validate_chain            [kernel.kallsyms]                        
               85.00  2.0% do_raw_spin_lock          [kernel.kallsyms]                        
               78.00  1.8% __wake_up_bit             [kernel.kallsyms]                        
               77.00  1.8% __GI_strlen               /lib64/libc-2.8.so                       
               73.00  1.7% copy_user_generic_string  [kernel.kallsyms]                        
               71.00  1.7% page_remove_rmap          [kernel.kallsyms]                        
               70.00  1.6% kmem_cache_free           [kernel.kallsyms]                        
               67.00  1.6% free_pcppages_bulk        [kernel.kallsyms]                        
               62.00  1.5% kmem_cache_alloc          [kernel.kallsyms]                        
               58.00  1.4% ext3_release_file         [kernel.kallsyms]                        
               54.00  1.3% radix_tree_lookup_element [kernel.kallsyms]                        
               47.00  1.1% generic_fillattr          [kernel.kallsyms] 

Any comment is appropriated.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c          |   18 +++++++++++++++---
 arch/x86/kernel/cpu/perf_event_intel.c    |    4 ++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    5 +++++
 include/linux/perf_event.h                |    1 +
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ed6ff11..2a02529 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -197,18 +197,25 @@ struct extra_reg {
 	unsigned int		extra_shift;
 	u64			config_mask;
 	u64			valid_mask;
+	u64			flags;
 };
 
-#define EVENT_EXTRA_REG(e, ms, m, vm, es) {	\
+#define EVENT_EXTRA_REG(e, ms, m, vm, es, f) {	\
 	.event = (e),		\
 	.msr = (ms),		\
 	.config_mask = (m),	\
 	.valid_mask = (vm),	\
 	.extra_shift = (es),	\
+	.flags = (f),	\
 	}
 #define INTEL_EVENT_EXTRA_REG(event, msr, vm, es)	\
-	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, es)
-#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, 0)
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm, es, 0)
+#define INTEL_EVENT_EXTRA_REG2(event, msr, vm, es, f)	\
+	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT | \
+			ARCH_PERFMON_EVENTSEL_UMASK, vm, es, f)
+#define EVENT_EXTRA_END EVENT_EXTRA_REG(0, 0, 0, 0, 0, 0)
+
+#define EXTRA_REG_LD_LAT 0x1
 
 union perf_capabilities {
 	struct {
@@ -384,6 +391,11 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 		if (extra & ~er->valid_mask)
 			return -EINVAL;
 		event->hw.extra_config = extra;
+		event->hw.extra_flags = er->flags;
+
+		/* The minimum value that may be programmed into MSR_PEBS_LD_LAT is 3 */
+		if ((er->flags & EXTRA_REG_LD_LAT) && extra < 3)
+			event->hw.extra_config = 3;
 		break;
 	}
 	return 0;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index bc4afb1..7e2b873 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -89,6 +89,8 @@ static struct event_constraint intel_nehalem_event_constraints[] =
 static struct extra_reg intel_nehalem_extra_regs[] =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, 0x1a6, 0xffff, 32), /* OFFCORE_RESPONSE */
+	/* MEM_INST_RETIRED.LATENCY_ABOVE_THRESHOLD */
+	INTEL_EVENT_EXTRA_REG2(0x100b, 0x3f6, 0xffff, 32, EXTRA_REG_LD_LAT),
 	EVENT_EXTRA_END
 };
 
@@ -114,6 +116,8 @@ static struct extra_reg intel_westmere_extra_regs[] =
 {
 	INTEL_EVENT_EXTRA_REG(0xb7, 0x1a6, 0xffff, 32), /* OFFCORE_RESPONSE_0 */
 	INTEL_EVENT_EXTRA_REG(0xbb, 0x1a7, 0xffff, 32), /* OFFCORE_RESPONSE_1 */
+	/* MEM_INST_RETIRED.LATENCY_ABOVE_THRESHOLD */
+	INTEL_EVENT_EXTRA_REG2(0x100b, 0x3f6, 0xffff, 32, EXTRA_REG_LD_LAT),
 	EVENT_EXTRA_END
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index b7dcd9f..d008c40 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -376,6 +376,7 @@ static struct event_constraint intel_core_pebs_events[] = {
 };
 
 static struct event_constraint intel_nehalem_pebs_events[] = {
+	PEBS_EVENT_CONSTRAINT(0x100b, 0xf), /* MEM_INST_RETIRED.LATENCY_ABOVE_THRESHOLD */
 	PEBS_EVENT_CONSTRAINT(0x00c0, 0xf), /* INSTR_RETIRED.ANY */
 	PEBS_EVENT_CONSTRAINT(0xfec1, 0xf), /* X87_OPS_RETIRED.ANY */
 	PEBS_EVENT_CONSTRAINT(0x00c5, 0xf), /* BR_INST_RETIRED.MISPRED */
@@ -414,6 +415,8 @@ static void intel_pmu_pebs_enable(struct perf_event *event)
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
+	if (hwc->extra_flags & EXTRA_REG_LD_LAT)
+		cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
 	WARN_ON_ONCE(cpuc->enabled);
 
 	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
@@ -426,6 +429,8 @@ static void intel_pmu_pebs_disable(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 
 	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
+	if (hwc->extra_flags & EXTRA_REG_LD_LAT)
+		cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
 	if (cpuc->enabled)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d24d9ab..38bffa4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -541,6 +541,7 @@ struct hw_perf_event {
 			int		last_cpu;
 			unsigned int	extra_reg;
 			u64		extra_config;
+			u64		extra_flags;
 		};
 		struct { /* software */
 			struct hrtimer	hrtimer;


