Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2BGPKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:10:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43546 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab2BGPKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:10:50 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=DK3RciQjqIYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=c0JL13GjBl_zNdwkUXEA:9 a=SgKHuPrNJdhr6ZnCoaQA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120207151049.413659845@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 07 Feb 2012 09:56:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rob Herring <robherring2@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>, Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 2/3][RFC] x86/tracing: Denote the power and cpuidle tracepoints as _rcuidle()
References: <20120207145653.829892056@goodmis.org>
Content-Disposition: inline; filename=0002-x86-tracing-Denote-the-power-and-cpuidle-tracepoints.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The power and cpuidle tracepoints are called within a rcu_idle_exit()
section, and must be denoted with the _rcuidle() version of the tracepoint.

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/process.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 15763af..44eefde 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -377,8 +377,8 @@ static inline int hlt_use_halt(void)
 void default_idle(void)
 {
 	if (hlt_use_halt()) {
-		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
-		trace_cpu_idle(1, smp_processor_id());
+		trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
+		trace_cpu_idle_rcuidle(1, smp_processor_id());
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
 		 * TS_POLLING-cleared state must be visible before we
@@ -391,8 +391,8 @@ void default_idle(void)
 		else
 			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
-		trace_power_end(smp_processor_id());
-		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+		trace_power_end_rcuidle(smp_processor_id());
+		trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
@@ -450,8 +450,8 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
 static void mwait_idle(void)
 {
 	if (!need_resched()) {
-		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
-		trace_cpu_idle(1, smp_processor_id());
+		trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
+		trace_cpu_idle_rcuidle(1, smp_processor_id());
 		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
@@ -461,8 +461,8 @@ static void mwait_idle(void)
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
-		trace_power_end(smp_processor_id());
-		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+		trace_power_end_rcuidle(smp_processor_id());
+		trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 	} else
 		local_irq_enable();
 }
@@ -474,13 +474,13 @@ static void mwait_idle(void)
  */
 static void poll_idle(void)
 {
-	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
-	trace_cpu_idle(0, smp_processor_id());
+	trace_power_start_rcuidle(POWER_CSTATE, 0, smp_processor_id());
+	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
-	trace_power_end(smp_processor_id());
-	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+	trace_power_end_rcuidle(smp_processor_id());
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
 
 /*
-- 
1.7.8.3


