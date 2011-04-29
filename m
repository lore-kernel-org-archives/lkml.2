Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab1D2Mqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 08:46:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:60566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab1D2Mqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 08:46:45 -0400
Date: Fri, 29 Apr 2011 12:46:24 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-7y40wib8n001io7hjpn1dsrm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf, x86: Add new stalled cycles events for Intel and AMD CPUs
Git-Commit-ID: 91fc4cc00099986bc1ba50e1f421c3548cffae42
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Apr 2011 12:46:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91fc4cc00099986bc1ba50e1f421c3548cffae42
Gitweb:     http://git.kernel.org/tip/91fc4cc00099986bc1ba50e1f421c3548cffae42
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 29 Apr 2011 14:17:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Apr 2011 14:24:15 +0200

perf, x86: Add new stalled cycles events for Intel and AMD CPUs

Extend the Intel and AMD event definitions with generic front-end and
back-end stall events.

( These are only approximations - suggestions are welcome for better events. )

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-7y40wib8n001io7hjpn1dsrm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_amd.c   |   14 ++++++++------
 arch/x86/kernel/cpu/perf_event_intel.c |    4 +++-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index cf4e369..fe29c1d 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -96,12 +96,14 @@ static __initconst const u64 amd_hw_cache_event_ids
  */
 static const u64 amd_perfmon_event_map[] =
 {
-  [PERF_COUNT_HW_CPU_CYCLES]		= 0x0076,
-  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0080,
-  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0081,
-  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c2,
-  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c3,
+  [PERF_COUNT_HW_CPU_CYCLES]			= 0x0076,
+  [PERF_COUNT_HW_INSTRUCTIONS]			= 0x00c0,
+  [PERF_COUNT_HW_CACHE_REFERENCES]		= 0x0080,
+  [PERF_COUNT_HW_CACHE_MISSES]			= 0x0081,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]		= 0x00c2,
+  [PERF_COUNT_HW_BRANCH_MISSES]			= 0x00c3,
+  [PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= 0x00d0, /* "Decoder empty" event */
+  [PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= 0x00d1, /* "Dispatch stalls" event */
 };
 
 static u64 amd_pmu_event_map(int hw_event)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 393085b..7983b9a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1413,7 +1413,9 @@ static __init int intel_pmu_init(void)
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
 
-		/* Install the stalled-cycles event: UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
+		/* UOPS_ISSUED.STALLED_CYCLES */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x180010e;
+		/* UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
 		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
 
 		if (ebx & 0x40) {
