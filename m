Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab1D0P6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:58:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:59924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab1D0P6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:58:36 -0400
Date: Wed, 27 Apr 2011 15:58:14 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-yyfg0bxo9jsqxd6a0ovfny27@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf events, x86: Work around the Nehalem AAJ80 erratum
Git-Commit-ID: ec75a71634dabe439db91c1ef51d5099f4493808
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 15:58:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec75a71634dabe439db91c1ef51d5099f4493808
Gitweb:     http://git.kernel.org/tip/ec75a71634dabe439db91c1ef51d5099f4493808
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 11:51:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 19:34:34 +0200

perf events, x86: Work around the Nehalem AAJ80 erratum

On Nehalem CPUs the retired branch-misses event can be completely bogus,
when there are no branch-misses occuring. When there are a lot of branch
misses then the count is pretty accurate. Still, this leaves us with an
event that over-counts a lot.

Detect this erratum and work it around by using BR_MISP_EXEC.ANY events.
These will also count speculated branches but still it's a lot more
precise in practice than the architectural event.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-yyfg0bxo9jsqxd6a0ovfny27@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 9194b06..9ae4a2a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -25,7 +25,7 @@ struct intel_percore {
 /*
  * Intel PerfMon, used on Core and later.
  */
-static const u64 intel_perfmon_event_map[] =
+static u64 intel_perfmon_event_map[PERF_COUNT_HW_MAX] __read_mostly =
 {
   [PERF_COUNT_HW_CPU_CYCLES]		= 0x003c,
   [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
@@ -1308,7 +1308,7 @@ static void intel_clovertown_quirks(void)
 	 * AJ106 could possibly be worked around by not allowing LBR
 	 *       usage from PEBS, including the fixup.
 	 * AJ68  could possibly be worked around by always programming
-	 * 	 a pebs_event_reset[0] value and coping with the lost events.
+	 *	 a pebs_event_reset[0] value and coping with the lost events.
 	 *
 	 * But taken together it might just make sense to not enable PEBS on
 	 * these chips.
@@ -1412,6 +1412,18 @@ static __init int intel_pmu_init(void)
 		x86_pmu.percore_constraints = intel_nehalem_percore_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
+
+		if (ebx & 0x40) {
+			/*
+			 * Erratum AAJ80 detected, we work it around by using
+			 * the BR_MISP_EXEC.ANY event. This will over-count
+			 * branch-misses, but it's still much better than the
+			 * architectural event which is often completely bogus:
+			 */
+			intel_perfmon_event_map[PERF_COUNT_HW_BRANCH_MISSES] = 0x7f89;
+
+			pr_cont("erratum AAJ80 worked around, ");
+		}
 		pr_cont("Nehalem events, ");
 		break;
 
