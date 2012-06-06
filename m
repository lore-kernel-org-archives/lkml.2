Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab2FFP7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:59:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40318 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab2FFP66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:58:58 -0400
Date: Wed, 6 Jun 2012 08:58:40 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-cccb9ba9e4ee0d750265f53de9258df69655c40b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1338884803.28282.153.camel@twins>
References: <1338884803.28282.153.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Implement cycles:p for SNB/IVB
Git-Commit-ID: cccb9ba9e4ee0d750265f53de9258df69655c40b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:58:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cccb9ba9e4ee0d750265f53de9258df69655c40b
Gitweb:     http://git.kernel.org/tip/cccb9ba9e4ee0d750265f53de9258df69655c40b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 5 Jun 2012 10:26:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 16:59:47 +0200

perf/x86: Implement cycles:p for SNB/IVB

Now that there's finally a chip with working PEBS (IvyBridge), we can
enable the hardware and implement cycles:p for SNB/IVB.

Cc: Stephane Eranian <eranian@google.com>
Requested-and-tested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338884803.28282.153.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h       |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c |   50 ++++++++++++++++++++++++++-----
 2 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 83794d8..7241e2f 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -365,6 +365,7 @@ struct x86_pmu {
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
+	void		(*pebs_aliases)(struct perf_event *event);
 
 	/*
 	 * Intel LBR
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 965baa2..2312c1f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1336,15 +1336,9 @@ static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
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
@@ -1365,10 +1359,48 @@ static int intel_pmu_hw_config(struct perf_event *event)
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
@@ -1643,6 +1675,7 @@ static __initconst const struct x86_pmu intel_pmu = {
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
