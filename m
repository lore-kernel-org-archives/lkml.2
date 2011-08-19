Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1HSPEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:04:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64142 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1HSPEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:04:50 -0400
From: tom.leiming@gmail.com
To: rostedt@goodmis.org, fweisbec@gmail.com, jean.pihet@newoldbits.com,
        mingo@redhat.com, trenn@suse.de
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 3/3] trace points: power: remove 'cpu_id' from trace_cpu_idle
Date: Fri, 19 Aug 2011 23:04:04 +0800
Message-Id: <1313766244-22313-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com>
References: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch removes the 'cpu_id' parameter of the cpu_idle
trace point, based on the ideas below:

- the cpu_id which is passed to trace point is always the current
  cpu
- the current cpu info has been included into the trace result
  already
- smp_processor_id() can't be used safely in preemptible context.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 Documentation/trace/events-power.txt |    6 +++---
 arch/arm/mach-omap2/pm34xx.c         |    4 ++--
 arch/x86/kernel/process.c            |   12 ++++++------
 drivers/cpuidle/cpuidle.c            |    4 ++--
 include/trace/events/power.h         |   15 ++++++++++++---
 5 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/Documentation/trace/events-power.txt b/Documentation/trace/events-power.txt
index e9d5fe3..9f2f96c 100644
--- a/Documentation/trace/events-power.txt
+++ b/Documentation/trace/events-power.txt
@@ -23,7 +23,7 @@ Cf. include/trace/events/power.h for the events definitions.
 A 'cpu' event class gathers the CPU-related events: cpuidle and
 cpufreq.
 
-cpu_idle		"state=%lu cpu_id=%lu"
+cpu_idle		"state=%lu"
 cpu_frequency		"state=%lu cpu_id=%lu"
 
 A suspend event is used to indicate the system going in and out of the
@@ -33,8 +33,8 @@ machine_suspend		"state=%lu"
 
 
 Note: the value of '-1' or '4294967295' for state means an exit from the current state,
-i.e. trace_cpu_idle(4, smp_processor_id()) means that the system
-enters the idle state 4, while trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id())
+i.e. trace_cpu_idle(4) means that the system
+enters the idle state 4, while trace_cpu_idle(PWR_EVENT_EXIT)
 means that the system exits the previous idle state.
 
 The event which has 'state=4294967295' in the trace is very important to the user
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 7255d9b..cde9a11 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -502,12 +502,12 @@ static void omap3_pm_idle(void)
 		goto out;
 
 	trace_power_start(POWER_CSTATE, 1, smp_processor_id());
-	trace_cpu_idle(1, smp_processor_id());
+	trace_cpu_idle(1);
 
 	omap_sram_idle();
 
 	trace_power_end(smp_processor_id());
-	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+	trace_cpu_idle(PWR_EVENT_EXIT);
 
 out:
 	local_fiq_enable();
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e7e3b01..fb9e92b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -378,7 +378,7 @@ void default_idle(void)
 {
 	if (hlt_use_halt()) {
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
-		trace_cpu_idle(1, smp_processor_id());
+		trace_cpu_idle(1);
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
 		 * TS_POLLING-cleared state must be visible before we
@@ -392,7 +392,7 @@ void default_idle(void)
 			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
 		trace_power_end(smp_processor_id());
-		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+		trace_cpu_idle(PWR_EVENT_EXIT);
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
@@ -443,7 +443,7 @@ static void mwait_idle(void)
 {
 	if (!need_resched()) {
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
-		trace_cpu_idle(1, smp_processor_id());
+		trace_cpu_idle(1);
 		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
@@ -454,7 +454,7 @@ static void mwait_idle(void)
 		else
 			local_irq_enable();
 		trace_power_end(smp_processor_id());
-		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+		trace_cpu_idle(PWR_EVENT_EXIT);
 	} else
 		local_irq_enable();
 }
@@ -467,12 +467,12 @@ static void mwait_idle(void)
 static void poll_idle(void)
 {
 	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
-	trace_cpu_idle(0, smp_processor_id());
+	trace_cpu_idle(0);
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
 	trace_power_end(smp_processor_id());
-	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+	trace_cpu_idle(PWR_EVENT_EXIT);
 }
 
 /*
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index d4c5423..7980732 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -106,12 +106,12 @@ int cpuidle_idle_call(void)
 	dev->last_state = target_state;
 
 	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
-	trace_cpu_idle(next_state, dev->cpu);
+	trace_cpu_idle(next_state);
 
 	dev->last_residency = target_state->enter(dev, target_state);
 
 	trace_power_end(dev->cpu);
-	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
+	trace_cpu_idle(PWR_EVENT_EXIT);
 
 	if (dev->last_state)
 		target_state = dev->last_state;
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 3878edc..8a579bd 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -27,11 +27,20 @@ DECLARE_EVENT_CLASS(cpu,
 		  (unsigned long)__entry->cpu_id)
 );
 
-DEFINE_EVENT(cpu, cpu_idle,
+TRACE_EVENT(cpu_idle,
+	TP_PROTO(unsigned int state),
 
-	TP_PROTO(unsigned int state, unsigned int cpu_id),
+	TP_ARGS(state),
+
+	TP_STRUCT__entry(
+		__field(	u32,		state		)
+	),
+
+	TP_fast_assign(
+		__entry->state = state;
+	),
 
-	TP_ARGS(state, cpu_id)
+	TP_printk("state=%lu", (unsigned long)__entry->state)
 );
 
 /* This file can get included multiple times, TRACE_HEADER_MULTI_READ at top */
-- 
1.7.4.1

