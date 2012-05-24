Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2EXH17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 03:27:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:35883 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2EXH15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 03:27:57 -0400
Subject: Re: [PATCH] perf, x86: Make cycles:p working on SNB
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
References: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 09:27:51 +0200
Message-ID: <1337844471.9783.48.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 12:02 +0900, Namhyung Kim wrote:

> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1329,6 +1329,12 @@ static int intel_pmu_hw_config(struct perf_event *event)
>  		 */
>  		u64 alt_config = X86_CONFIG(.event=0xc0, .inv=1, .cmask=16);
>  
> +		/*
> +		 * SNB introduced INST_RETIRED.PREC_DIST for this purpose.
> +		 */
> +		if (x86_pmu.pebs_constraints == intel_snb_pebs_event_constraints)
> +			alt_config = X86_CONFIG(.event=0xc0, .umask=0x01,
> +						.inv=1, .cmask=16);
>  
>  		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
>  		event->hw.config = alt_config;

That's rather ugly.. but that's okay, I've actually got the patch for
this still laying around, it needs a bit of an update though.

Also I'm thinking you're using SNB-EP (you didn't say) since regular SNB
has PEBS disabled as per (6a600a8b).

Stephane, you could never trigger the badness on EP, but ISTR you saying
it was in fact affected by whatever Intel found? So should we mark that
as bad as well?

Also, do you happen to know if/when a u-code update would appear?

---
Subject: perf, x86: Fix cycles:pp for SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 15 Jul 2011 21:17:34 +0200

Intel SNB doesn't support INST_RETIRED as a PEBS event, so implement
the CPU_CLK_UNHALTED alias using UOPS_RETIRED in much the same fasion.

The UOPS_RETIRED thing would work for NHM,WSM,SNB, but Core2 and Atom
really need the old one, so for now only use the new one for SNB.

Reported-and-tested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c       |    1 
 arch/x86/kernel/cpu/perf_event_intel.c |   68 +++++++++++++++++++++++++--------
 2 files changed, 53 insertions(+), 16 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -316,6 +316,7 @@ struct x86_pmu {
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
+	void		(*pebs_aliases)(struct perf_event *event);
 
 	/*
 	 * Intel LBR
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1241,8 +1241,30 @@ static int intel_pmu_hw_config(struct pe
 	if (ret)
 		return ret;
 
-	if (event->attr.precise_ip &&
-	    (event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
+	if (event->attr.precise_ip && x86_pmu.pebs_aliases)
+		x86_pmu.pebs_aliases(event);
+
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
+static void intel_pebs_aliases_core2(struct perf_event *event)
+{
+	if ((event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
 		/*
 		 * Use an alternative encoding for CPU_CLK_UNHALTED.THREAD_P
 		 * (0x003c) so that we can use it with PEBS.
@@ -1266,22 +1288,34 @@ static int intel_pmu_hw_config(struct pe
 		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
 		event->hw.config = alt_config;
 	}
+}
 
-	if (event->attr.type != PERF_TYPE_RAW)
-		return 0;
-
-	if (!(event->attr.config & ARCH_PERFMON_EVENTSEL_ANY))
-		return 0;
-
-	if (x86_pmu.version < 3)
-		return -EINVAL;
-
-	if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	event->hw.config |= ARCH_PERFMON_EVENTSEL_ANY;
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
+		 * CNTMASK uops. By setting CNTMASK to a value (16)
+		 * larger than the maximum number of uops that can be
+		 * retired per cycle (4) and then inverting the condition, we
+		 * count all cycles that retire 16 or less uops, which
+		 * is every cycle.
+		 *
+		 * Thereby we gain a PEBS capable cycle counter.
+		 */
+		u64 alt_config = 0x108001c2; /* UOPS_RETIRED.TOTAL_CYCLES */
 
-	return 0;
+		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
+		event->hw.config = alt_config;
+	}
 }
 
 static __initconst const struct x86_pmu core_pmu = {
@@ -1409,6 +1443,7 @@ static __initconst const struct x86_pmu
 	.max_period		= (1ULL << 31) - 1,
 	.get_event_constraints	= intel_get_event_constraints,
 	.put_event_constraints	= intel_put_event_constraints,
+	.pebs_aliases		= intel_pebs_aliases_core2,
 
 	.cpu_prepare		= intel_pmu_cpu_prepare,
 	.cpu_starting		= intel_pmu_cpu_starting,
@@ -1597,6 +1632,7 @@ static __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_events;
+		x86_pmu.pebs_aliases = intel_pebs_aliases_snb,
 		x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;


