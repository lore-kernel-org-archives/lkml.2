Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1DVNmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 09:42:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48251 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367Ab1DVNmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 09:42:35 -0400
Date: Fri, 22 Apr 2011 15:42:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110422134225.GA22574@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      perf: Support Xeon E7's via the Westmere PMU driver

Cyrill Gorcunov (1):
      perf, x86: P4 PMU - Don't forget to clear cpuc->active_mask on overflow

Ingo Molnar (1):
      x86, perf event: Turn off unstructured raw event access to offcore registers

Peter Zijlstra (1):
      perf, x86: Update/fix Intel Nehalem cache events


 arch/x86/kernel/cpu/perf_event.c       |    6 +++++-
 arch/x86/kernel/cpu/perf_event_intel.c |    9 +++++----
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index eed3673a..632e5dc 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -586,8 +586,12 @@ static int x86_setup_perfctr(struct perf_event *event)
 			return -EOPNOTSUPP;
 	}
 
+	/*
+	 * Do not allow config1 (extended registers) to propagate,
+	 * there's no sane user-space generalization yet:
+	 */
 	if (attr->type == PERF_TYPE_RAW)
-		return x86_pmu_extra_regs(event->attr.config, event);
+		return 0;
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 8fc2b2c..43fa20b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -391,12 +391,12 @@ static __initconst const u64 nehalem_hw_cache_event_ids
 {
  [ C(L1D) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f40, /* L1D_CACHE_LD.MESI            */
-		[ C(RESULT_MISS)   ] = 0x0140, /* L1D_CACHE_LD.I_STATE         */
+		[ C(RESULT_ACCESS) ] = 0x010b, /* MEM_INST_RETIRED.LOADS       */
+		[ C(RESULT_MISS)   ] = 0x0151, /* L1D.REPL                     */
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0f41, /* L1D_CACHE_ST.MESI            */
-		[ C(RESULT_MISS)   ] = 0x0141, /* L1D_CACHE_ST.I_STATE         */
+		[ C(RESULT_ACCESS) ] = 0x020b, /* MEM_INST_RETURED.STORES      */
+		[ C(RESULT_MISS)   ] = 0x0251, /* L1D.M_REPL                   */
 	},
 	[ C(OP_PREFETCH) ] = {
 		[ C(RESULT_ACCESS) ] = 0x014e, /* L1D_PREFETCH.REQUESTS        */
@@ -1425,6 +1425,7 @@ static __init int intel_pmu_init(void)
 
 	case 37: /* 32 nm nehalem, "Clarkdale" */
 	case 44: /* 32 nm nehalem, "Gulftown" */
+	case 47: /* 32 nm Xeon E7 */
 		memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, nehalem_hw_cache_extra_regs,
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index c2520e1..d1f77e2 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -947,7 +947,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		if (!x86_perf_event_set_period(event))
 			continue;
 		if (perf_event_overflow(event, 1, &data, regs))
-			p4_pmu_disable_event(event);
+			x86_pmu_stop(event, 0);
 	}
 
 	if (handled) {
