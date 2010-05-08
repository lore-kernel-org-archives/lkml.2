Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0EHQLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 12:11:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:57793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab0EHQLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 12:11:19 -0400
Date: Sat, 8 May 2010 16:09:58 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ming.m.lin@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, gorcunov@openvz.org, rostedt@goodmis.org,
       peterz@infradead.org, ming.m.lin@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100508112716.963478928@openvz.org>
References: <20100508112716.963478928@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perf: P4 PMU -- protect sensible procedures from preemption
Message-ID: <tip-137351e0feeb9f25d99488ee1afc1c79f5499a9a@git.kernel.org>
Git-Commit-ID: 137351e0feeb9f25d99488ee1afc1c79f5499a9a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 08 May 2010 16:09:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  137351e0feeb9f25d99488ee1afc1c79f5499a9a
Gitweb:     http://git.kernel.org/tip/137351e0feeb9f25d99488ee1afc1c79f5499a9a
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sat, 8 May 2010 15:25:52 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 May 2010 14:17:53 +0200

x86, perf: P4 PMU -- protect sensible procedures from preemption

Steven reported:

|
| I'm getting:
|
| Pid: 3477, comm: perf Not tainted 2.6.34-rc6 #2727
| Call Trace:
|  [<ffffffff811c7565>] debug_smp_processor_id+0xd5/0xf0
|  [<ffffffff81019874>] p4_hw_config+0x2b/0x15c
|  [<ffffffff8107acbc>] ? trace_hardirqs_on_caller+0x12b/0x14f
|  [<ffffffff81019143>] hw_perf_event_init+0x468/0x7be
|  [<ffffffff810782fd>] ? debug_mutex_init+0x31/0x3c
|  [<ffffffff810c68b2>] T.850+0x273/0x42e
|  [<ffffffff810c6cab>] sys_perf_event_open+0x23e/0x3f1
|  [<ffffffff81009e6a>] ? sysret_check+0x2e/0x69
|  [<ffffffff81009e32>] system_call_fastpath+0x16/0x1b
|
| When running perf record in latest tip/perf/core
|

Due to the fact that p4 counters are shared between HT threads
we synthetically divide the whole set of counters into two
non-intersected subsets. And while we're "borrowing" counters
from these subsets we should not be preempted (well, strictly
speaking in p4_hw_config we just pre-set reference to the
subset which allow to save some cycles in schedule routine
if it happens on the same cpu). So use get_cpu/put_cpu pair.

Also p4_pmu_schedule_events should use smp_processor_id rather
than raw_ version. This allow us to catch up preemption issue
(if there will ever be).

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
LKML-Reference: <20100508112716.963478928@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index b1f532d..ca40180 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -421,7 +421,8 @@ static u64 p4_pmu_event_map(int hw_event)
 
 static int p4_hw_config(struct perf_event *event)
 {
-	int cpu = raw_smp_processor_id();
+	int cpu = get_cpu();
+	int rc = 0;
 	u32 escr, cccr;
 
 	/*
@@ -454,7 +455,10 @@ static int p4_hw_config(struct perf_event *event)
 			 p4_config_pack_cccr(P4_CCCR_MASK_HT));
 	}
 
-	return x86_setup_perfctr(event);
+	rc = x86_setup_perfctr(event);
+	put_cpu();
+
+	return rc;
 }
 
 static inline void p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
