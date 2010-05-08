Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0EHL13 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 07:27:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50252 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab0EHL1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 07:27:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=rUq/fozQXlLCUC5xfvGbIKhdpWMvr9TivUdsILAlhRr7qH+dZkKeNCylKr8rXxbQC+
         mYUfKZyu9LccShpN52f0xSaqEcBdA0Pj3l04LR8gU9B2Vy5M2tmsT4LZImuZ6qnQHJ0k
         1HCcWdqNTm+3T6Af3GjzLhiN2sZwEz2pJKg54=
Message-Id: <20100508112716.963478928@openvz.org>
User-Agent: quilt/0.47-1
Date: Sat, 08 May 2010 15:25:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/4] x86,perf: P4 PMU -- protect sensible procedures from preemption
References: <20100508112550.187421916@openvz.org>
Content-Disposition: inline; filename=x86-perf-p4-getcpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven reported
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
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
Note: I've removed Steven's Tested-by tag, since due to
commit 9d0fcba67e47ff398a6fa86476d4884d472dc98a the former
patch Steven were testing is not applicable anymore.

 arch/x86/kernel/cpu/perf_event_p4.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -421,7 +421,8 @@ static u64 p4_pmu_event_map(int hw_event
 
 static int p4_hw_config(struct perf_event *event)
 {
-	int cpu = raw_smp_processor_id();
+	int cpu = get_cpu();
+	int rc = 0;
 	u32 escr, cccr;
 
 	/*
@@ -454,7 +455,10 @@ static int p4_hw_config(struct perf_even
 			 p4_config_pack_cccr(P4_CCCR_MASK_HT));
 	}
 
-	return x86_setup_perfctr(event);
+	rc = x86_setup_perfctr(event);
+	put_cpu();
+
+	return rc;
 }
 
 static inline void p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)

