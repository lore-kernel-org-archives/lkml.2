Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0EGPFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:05:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64616 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab0EGPFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VNFdY5bw6pL+k90CUmD/8sYFAmvZYI82x2sQQiCOKmy1GGN5a8XomNBmV4biDDzbQm
         3xHgUUbxlBRoyrwTswHI4E+2Wqv5Y2eWwvmK9bqSu5Y511KA1g8NlxIejRtiL3nGuEi6
         OELVpTd/uKT1aVQwnp8FLtc9zqgTXA9FSmgfA=
Date: Fri, 7 May 2010 19:05:17 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH -tip] x86,perf: P4 PMU -- protect sensible procedures from
	preemption
Message-ID: <20100507150517.GB16434@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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
non-intersected subsets. And while we're borrowing counters
from these subsets we should not be preempted. So use
get_cpu/put_cpu pair.

Also p4_pmu_schedule_events should use smp_processor_id rather
than raw_ version. This allow us to catch up preemption issue
(if there will ever be).

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

N.B. I'm still invetigating the need of preemt to be
disabled of p4_pmu_schedule_events, though Steven has
tested this version and preemtion issue didn't reveal itself
anyhow I think it's valueable to close the former issue
in p4_hw_config first.

 arch/x86/kernel/cpu/perf_event_p4.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -421,7 +421,7 @@ static u64 p4_pmu_event_map(int hw_event
 
 static int p4_hw_config(struct perf_event *event)
 {
-	int cpu = raw_smp_processor_id();
+	int cpu = get_cpu();
 	u32 escr, cccr;
 
 	/*
@@ -440,7 +440,7 @@ static int p4_hw_config(struct perf_even
 		event->hw.config = p4_set_ht_bit(event->hw.config);
 
 	if (event->attr.type != PERF_TYPE_RAW)
-		return 0;
+		goto out;
 
 	/*
 	 * We don't control raw events so it's up to the caller
@@ -455,6 +455,8 @@ static int p4_hw_config(struct perf_even
 		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
 		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
 
+out:
+	put_cpu();
 	return 0;
 }
 
@@ -741,7 +743,7 @@ static int p4_pmu_schedule_events(struct
 {
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long escr_mask[BITS_TO_LONGS(ARCH_P4_TOTAL_ESCR)];
-	int cpu = raw_smp_processor_id();
+	int cpu = smp_processor_id();
 	struct hw_perf_event *hwc;
 	struct p4_event_bind *bind;
 	unsigned int i, thread, num;
