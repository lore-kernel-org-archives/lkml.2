Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab0IGQ4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:56:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:60085 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab0IGQ4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:56:38 -0400
Message-Id: <20100907165012.227790649@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 18:46:51 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 18/19] perf: Provide a separate task context for swevents
References: <20100907164633.879932949@chello.nl>
Content-Disposition: inline; filename=perf-swevent-context.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since software events are always schedulable, mixing them up with
hardware events (who are not) can lead to funny scheduling oddities.

Giving them their own context solves this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h  |    1 +
 kernel/hw_breakpoint.c |    2 ++
 kernel/perf_event.c    |    8 ++++++++
 3 files changed, 11 insertions(+)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1164,6 +1164,7 @@ struct rcu_node;
 enum perf_event_task_context {
 	perf_invalid_context = -1,
 	perf_hw_context = 0,
+	perf_sw_context,
 	perf_nr_task_contexts,
 };
 
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4691,6 +4691,8 @@ static int perf_swevent_init(struct perf
 }
 
 static struct pmu perf_swevent = {
+	.task_ctx_nr	= perf_sw_context,
+
 	.event_init	= perf_swevent_init,
 	.add		= perf_swevent_add,
 	.del		= perf_swevent_del,
@@ -4782,6 +4784,8 @@ static int perf_tp_event_init(struct per
 }
 
 static struct pmu perf_tracepoint = {
+	.task_ctx_nr	= perf_sw_context,
+
 	.event_init	= perf_tp_event_init,
 	.add		= perf_trace_add,
 	.del		= perf_trace_del,
@@ -4970,6 +4974,8 @@ static int cpu_clock_event_init(struct p
 }
 
 static struct pmu perf_cpu_clock = {
+	.task_ctx_nr	= perf_sw_context,
+
 	.event_init	= cpu_clock_event_init,
 	.add		= cpu_clock_event_add,
 	.del		= cpu_clock_event_del,
@@ -5045,6 +5051,8 @@ static int task_clock_event_init(struct 
 }
 
 static struct pmu perf_task_clock = {
+	.task_ctx_nr	= perf_sw_context,
+
 	.event_init	= task_clock_event_init,
 	.add		= task_clock_event_add,
 	.del		= task_clock_event_del,
Index: linux-2.6/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6.orig/kernel/hw_breakpoint.c
+++ linux-2.6/kernel/hw_breakpoint.c
@@ -610,6 +610,8 @@ static void hw_breakpoint_stop(struct pe
 }
 
 static struct pmu perf_breakpoint = {
+	.task_ctx_nr	= perf_sw_context, /* could eventually get its own */
+
 	.event_init	= hw_breakpoint_event_init,
 	.add		= hw_breakpoint_add,
 	.del		= hw_breakpoint_del,


