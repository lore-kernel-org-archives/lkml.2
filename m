Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab0IQWEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:04:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab0IQWEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:04:53 -0400
From: Thomas Renninger <trenn@suse.de>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Sat, 18 Sep 2010 00:04:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.4-0.1.99.9.f8e4270-desktop; KDE/4.4.4; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <201009171508.46471.trenn@suse.de> <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com>
In-Reply-To: <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201009180004.38103.trenn@suse.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

power-trace: Use power_switch_state instead of power_start and power_end

No need to have power_start and power_end. power_switch_state of state=0
means we exited power saving state. Userspace has all the information
it needs to detect power enter/exit case.

Export it, so that intel_idle can make use of it, even if compiled as module.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 arch/x86/kernel/process.c   |    9 +++++++--
 drivers/cpuidle/cpuidle.c   |    3 +++
 drivers/idle/intel_idle.c   |    3 +++
 kernel/trace/power-traces.c |    2 +-
 4 files changed, 14 insertions(+), 3 deletions(-)

Index: linux-2.6.35-master/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.35-master.orig/arch/x86/kernel/process.c
+++ linux-2.6.35-master/arch/x86/kernel/process.c
@@ -375,7 +375,10 @@ static inline int hlt_use_halt(void)
 void default_idle(void)
 {
 	if (hlt_use_halt()) {
+		/* trace_power_start is deprecated, remove it after a while */
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
+		trace_power_switch_state(POWER_CSTATE, 1, smp_processor_id());
+
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
 		 * TS_POLLING-cleared state must be visible before we
@@ -446,6 +449,8 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
 	trace_power_start(POWER_CSTATE, (ax>>4)+1, smp_processor_id());
+	trace_power_switch_state(POWER_CSTATE, (ax>>4)+1, smp_processor_id());
+
 	if (!need_resched()) {
 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
@@ -462,6 +467,8 @@ static void mwait_idle(void)
 {
 	if (!need_resched()) {
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
+		trace_power_switch_state(POWER_CSTATE, 1, smp_processor_id());
+
 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
@@ -482,11 +489,9 @@ static void mwait_idle(void)
  */
 static void poll_idle(void)
 {
-	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
-	trace_power_end(0);
 }
 
 /*
Index: linux-2.6.35-master/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-2.6.35-master.orig/drivers/cpuidle/cpuidle.c
+++ linux-2.6.35-master/drivers/cpuidle/cpuidle.c
@@ -106,7 +106,10 @@ static void cpuidle_idle_call(void)
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev);
+
+	/* trace_power_end is deprecated, remove it after a while */
 	trace_power_end(smp_processor_id());
+	trace_power_switch_state(POWER_CSTATE, 0, smp_processor_id());
 }
 
 /**
Index: linux-2.6.35-master/drivers/idle/intel_idle.c
===================================================================
--- linux-2.6.35-master.orig/drivers/idle/intel_idle.c
+++ linux-2.6.35-master/drivers/idle/intel_idle.c
@@ -192,8 +192,11 @@ static int intel_idle(struct cpuidle_dev
 
 	stop_critical_timings();
 #ifndef MODULE
+	/* trace_power_start is deprecated, remove it after a while */
 	trace_power_start(POWER_CSTATE, (eax >> 4) + 1, cpu);
 #endif
+	trace_power_switch_state(POWER_CSTATE, (eax >> 4) + 1, smp_processor_id());
+
 	if (!need_resched()) {
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
Index: linux-2.6.35-master/kernel/trace/power-traces.c
===================================================================
--- linux-2.6.35-master.orig/kernel/trace/power-traces.c
+++ linux-2.6.35-master/kernel/trace/power-traces.c
@@ -13,4 +13,4 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>
 
-
+EXPORT_TRACEPOINT_SYMBOL_GPL(power_switch_state);
