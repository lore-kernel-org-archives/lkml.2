Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab2FFOmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:42:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:37919 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2FFOmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:42:14 -0400
Message-ID: <1338993726.2749.125.camel@twins>
Subject: Re: [PATCH 1/5] perf, x86: Don't assume the alternative cycles
 encoding is architectural
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Date: Wed, 06 Jun 2012 16:42:06 +0200
In-Reply-To: <20120606143536.GH28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338979188.2749.92.camel@twins>
	 <20120606141247.GD28225@tassilo.jf.intel.com>
	 <1338992061.2749.111.camel@twins>
	 <20120606142323.GG28225@tassilo.jf.intel.com>
	 <1338992910.2749.121.camel@twins>
	 <20120606143536.GH28225@tassilo.jf.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 07:35 -0700, Andi Kleen wrote:
> > But simply disabling it for a model isn't how you do things. 
> 
> Do you want it enabled per model?  I can turn the flag around.
> Anything else? 

The below is a refresh from a patch I did about a year ago when we ran
into the SNB trainwreck. I never merged it because SNB.. but IVB seems
to work.


---
Subject: perf, x86: Implement cycles:p for SNB/IVB
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 05 Jun 2012 10:26:43 +0200

Now that there's finally a chip with working PEBS (IvyBridge), we can
implement cycles:p for SNB/IVB.

Cc: Stephane Eranian <eranian@google.com>
Requested-and-tested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338884803.28282.153.camel@twins
---
 arch/x86/kernel/cpu/perf_event.h       |    1 
 arch/x86/kernel/cpu/perf_event_intel.c |   50 +++++++++++++++++++++++++++------
 2 files changed, 43 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -365,6 +365,7 @@ struct x86_pmu {
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
+	void		(*pebs_aliases)(struct perf_event *event);
 
 	/*
 	 * Intel LBR
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1336,15 +1336,9 @@ static void intel_put_event_constraints(
 	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
-static int intel_pmu_hw_config(struct perf_event *event)
+static void intel_pebs_aliases_core2(struct perf_event *event)
 {
-	int ret = x86_pmu_hw_config(event);
-
-	if (ret)
-		return ret;
-
-	if (event->attr.precise_ip &&
-	    (event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
+	if ((event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
 		/*
 		 * Use an alternative encoding for CPU_CLK_UNHALTED.THREAD_P
 		 * (0x003c) so that we can use it with PEBS.
@@ -1365,10 +1359,48 @@ static int intel_pmu_hw_config(struct pe
 		 */
 		u64 alt_config = X86_CONFIG(.event=0xc0, .inv=1, .cmask=16);
 
+		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
+		event->hw.config = alt_config;
+	}
+}
+
+static void intel_pebs_aliases_snb(struct perf_event *event)
+{
+	if ((event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
+		/*
+		 * Use an alternative encoding for CPU_CLK_UNHALTED.THREAD_P
+		 * (0x003c) so that we can use it with PEBS.
+		 *
+		 * The regular CPU_CLK_UNHALTED.THREAD_P event (0x003c) isn't
+		 * PEBS capable. However we can use UOPS_RETIRED.ALL
+		 * (0x01c2), which is a PEBS capable event, to get the same
+		 * count.
+		 *
+		 * UOPS_RETIRED.ALL counts the number of cycles that retires
+		 * CNTMASK micro-ops. By setting CNTMASK to a value (16)
+		 * larger than the maximum number of micro-ops that can be
+		 * retired per cycle (4) and then inverting the condition, we
+		 * count all cycles that retire 16 or less micro-ops, which
+		 * is every cycle.
+		 *
+		 * Thereby we gain a PEBS capable cycle counter.
+		 */
+		u64 alt_config = X86_CONFIG(.event=0xc2, .umask=0x01, .inv=1, .cmask=16);
 
 		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
 		event->hw.config = alt_config;
 	}
+}
+
+static int intel_pmu_hw_config(struct perf_event *event)
+{
+	int ret = x86_pmu_hw_config(event);
+
+	if (ret)
+		return ret;
+
+	if (event->attr.precise_ip && x86_pmu.pebs_aliases)
+		x86_pmu.pebs_aliases(event);
 
 	if (intel_pmu_needs_lbr_smpl(event)) {
 		ret = intel_pmu_setup_lbr_filter(event);
@@ -1643,6 +1675,7 @@ static __initconst const struct x86_pmu
 	.max_period		= (1ULL << 31) - 1,
 	.get_event_constraints	= intel_get_event_constraints,
 	.put_event_constraints	= intel_put_event_constraints,
+	.pebs_aliases		= intel_pebs_aliases_core2,
 
 	.format_attrs		= intel_arch3_formats_attr,
 
@@ -1885,6 +1918,7 @@ __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
+		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
 		x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;

