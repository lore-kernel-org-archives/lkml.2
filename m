Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab1D0P67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:58:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:59939 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab1D0P65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:58:57 -0400
Date: Wed, 27 Apr 2011 15:58:37 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-fue11vymwqsoo5to72jxxjyl@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf events: Add stalled cycles generic event - PERF_COUNT_HW_STALLED_CYCLES
Git-Commit-ID: 94403f8863d0d1d2005291b2ef0719c2534aa303
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 15:58:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94403f8863d0d1d2005291b2ef0719c2534aa303
Gitweb:     http://git.kernel.org/tip/94403f8863d0d1d2005291b2ef0719c2534aa303
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 24 Apr 2011 08:18:31 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:53 +0200

perf events: Add stalled cycles generic event - PERF_COUNT_HW_STALLED_CYCLES

The new PERF_COUNT_HW_STALLED_CYCLES event tries to approximate
cycles the CPU does nothing useful, because it is stalled on a
cache-miss or some other condition.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-fue11vymwqsoo5to72jxxjyl@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    3 +++
 include/linux/perf_event.h             |    1 +
 tools/perf/util/parse-events.c         |    1 +
 tools/perf/util/python.c               |    1 +
 4 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 9ae4a2a..efa2704 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1413,6 +1413,9 @@ static __init int intel_pmu_init(void)
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
 
+		/* Install the stalled-cycles event: 0xff: All reasons, 0xa2: Resource stalls */
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES] = 0xffa2;
+
 		if (ebx & 0x40) {
 			/*
 			 * Erratum AAJ80 detected, we work it around by using
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ee9f1e7..ac636dd 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -52,6 +52,7 @@ enum perf_hw_id {
 	PERF_COUNT_HW_BRANCH_INSTRUCTIONS	= 4,
 	PERF_COUNT_HW_BRANCH_MISSES		= 5,
 	PERF_COUNT_HW_BUS_CYCLES		= 6,
+	PERF_COUNT_HW_STALLED_CYCLES		= 7,
 
 	PERF_COUNT_HW_MAX,			/* non-ABI */
 };
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 952b4ae..1869e4c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -38,6 +38,7 @@ static struct event_symbol event_symbols[] = {
   { CHW(BRANCH_INSTRUCTIONS),	"branch-instructions",	"branches"	},
   { CHW(BRANCH_MISSES),		"branch-misses",	""		},
   { CHW(BUS_CYCLES),		"bus-cycles",		""		},
+  { CHW(STALLED_CYCLES),	"stalled-cycles",	""		},
 
   { CSW(CPU_CLOCK),		"cpu-clock",		""		},
   { CSW(TASK_CLOCK),		"task-clock",		""		},
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index f5e3845..406f613 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -798,6 +798,7 @@ static struct {
 	{ "COUNT_HW_BRANCH_INSTRUCTIONS", PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
 	{ "COUNT_HW_BRANCH_MISSES",	  PERF_COUNT_HW_BRANCH_MISSES },
 	{ "COUNT_HW_BUS_CYCLES",	  PERF_COUNT_HW_BUS_CYCLES },
+	{ "COUNT_HW_STALLED_CYCLES",	  PERF_COUNT_HW_STALLED_CYCLES },
 	{ "COUNT_HW_CACHE_L1D",		  PERF_COUNT_HW_CACHE_L1D },
 	{ "COUNT_HW_CACHE_L1I",		  PERF_COUNT_HW_CACHE_L1I },
 	{ "COUNT_HW_CACHE_LL",	  	  PERF_COUNT_HW_CACHE_LL },
