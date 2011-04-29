Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab1D2MqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 08:46:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:60552 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab1D2MqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 08:46:23 -0400
Date: Fri, 29 Apr 2011 12:45:59 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-7y40wib8n000io7hjpn1dsrm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf events: Add generic front-end and back-end stalled cycle event definitions
Git-Commit-ID: 8f62242246351b5a4bc0c1f00c0c7003edea128a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Apr 2011 12:46:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f62242246351b5a4bc0c1f00c0c7003edea128a
Gitweb:     http://git.kernel.org/tip/8f62242246351b5a4bc0c1f00c0c7003edea128a
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 29 Apr 2011 13:19:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Apr 2011 14:23:58 +0200

perf events: Add generic front-end and back-end stalled cycle event definitions

Add two generic hardware events: front-end and back-end stalled cycles.

These events measure conditions when the CPU is executing code but its
capabilities are not fully utilized. Understanding such situations and
analyzing them is an important sub-task of code optimization workflows.

Both events limit performance: most front end stalls tend to be caused
by branch misprediction or instruction fetch cachemisses, backend
stalls can be caused by various resource shortages or inefficient
instruction scheduling.

Front-end stalls are the more important ones: code cannot run fast
if the instruction stream is not being kept up.

An over-utilized back-end can cause front-end stalls and thus
has to be kept an eye on as well.

The exact composition is very program logic and instruction mix
dependent.

We use the terms 'stall', 'front-end' and 'back-end' loosely and
try to use the best available events from specific CPUs that
approximate these concepts.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-7y40wib8n000io7hjpn1dsrm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 include/linux/perf_event.h             |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 1ea9422..393085b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1414,7 +1414,7 @@ static __init int intel_pmu_init(void)
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
 
 		/* Install the stalled-cycles event: UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 */
-		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES] = 0x1803fb1;
+		intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x1803fb1;
 
 		if (ebx & 0x40) {
 			/*
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ac636dd..4e2d7ae 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -52,7 +52,8 @@ enum perf_hw_id {
 	PERF_COUNT_HW_BRANCH_INSTRUCTIONS	= 4,
 	PERF_COUNT_HW_BRANCH_MISSES		= 5,
 	PERF_COUNT_HW_BUS_CYCLES		= 6,
-	PERF_COUNT_HW_STALLED_CYCLES		= 7,
+	PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	= 7,
+	PERF_COUNT_HW_STALLED_CYCLES_BACKEND	= 8,
 
 	PERF_COUNT_HW_MAX,			/* non-ABI */
 };
