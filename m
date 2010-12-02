Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab0LBQnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:43:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:58287 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859Ab0LBQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:42:40 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: Thomas Renninger <trenn@suse.de>,
        Robert Schoene <robert.schoene@tu-dresden.de>,
        Jean Pihet <j-pihet@ti.com>, Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
        linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 3/8] X86/perf: fix power:cpu_idle double end events and throw cpu_idle events from the cpuidle layer
Date: Thu,  2 Dec 2010 17:42:23 +0100
Message-Id: <1291308148-28628-4-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1291308148-28628-3-git-send-email-trenn@suse.de>
References: <1291308148-28628-1-git-send-email-trenn@suse.de>
 <1291308148-28628-2-git-send-email-trenn@suse.de>
 <1291308148-28628-3-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently intel_idle and acpi_idle driver show double cpu_idle "exit idle"
events -> this patch fixes it and makes cpu_idle events throwing less complex.

It also introduces cpu_idle events for all architectures which use
the cpuidle subsystem, namely:
  - arch/arm/mach-at91/cpuidle.c
  - arch/arm/mach-davinci/cpuidle.c
  - arch/arm/mach-kirkwood/cpuidle.c
  - arch/arm/mach-omap2/cpuidle34xx.c
  - arch/drivers/acpi/processor_idle.c (for all cases, not only mwait)
  - arch/x86/kernel/process.c (did throw events before, but was a mess)
  - drivers/idle/intel_idle.c (did throw events before)

Convention should be:
Fire cpu_idle events inside the current pm_idle function (not somewhere
down the the callee tree) to keep things easy.

Current possible pm_idle functions in X86:
c1e_idle, poll_idle, cpuidle_idle_call, mwait_idle, default_idle
-> this is really easy is now.

This affects userspace:
The type field of the cpu_idle power event can now direclty get
mapped to:
/sys/devices/system/cpu/cpuX/cpuidle/stateX/{name,desc,usage,time,...}
instead of throwing very CPU/mwait specific values.
This change is not visible for the intel_idle driver.
For the acpi_idle driver it should only be visible if the vendor
misses out C-states in his BIOS.
Another (perf timechart) patch reads out cpuidle info of cpu_idle
events from:
/sys/.../cpuidle/stateX/*, then the cpuidle events are mapped
to the correct C-/cpuidle state again, even if e.g. vendors miss
out C-states in their BIOS and for example only export C1 and C3.
-> everything is fine.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Robert Schoene <robert.schoene@tu-dresden.de>
CC: Jean Pihet <j-pihet@ti.com>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Len Brown <lenb@kernel.org>
CC: linux-pm@lists.linux-foundation.org
CC: linux-acpi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: linux-perf-users@vger.kernel.org
CC: linux-omap@vger.kernel.org
---
 arch/x86/kernel/process.c    |    6 ++++--
 arch/x86/kernel/process_32.c |    4 ----
 arch/x86/kernel/process_64.c |    6 ------
 drivers/cpuidle/cpuidle.c    |   10 ++++++++--
 drivers/idle/intel_idle.c    |    2 --
 5 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 155d975..b618548 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -387,6 +387,8 @@ void default_idle(void)
 		else
 			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
+		trace_power_end(smp_processor_id());
+		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
@@ -444,8 +446,6 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
  */
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
-	trace_power_start(POWER_CSTATE, (ax>>4)+1, smp_processor_id());
-	trace_cpu_idle((ax>>4)+1, smp_processor_id());
 	if (!need_resched()) {
 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
@@ -472,6 +472,8 @@ static void mwait_idle(void)
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
+		trace_power_end(smp_processor_id());
+		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 	} else
 		local_irq_enable();
 }
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4b9befa..8d12878 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -57,8 +57,6 @@
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
 
-#include <trace/events/power.h>
-
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
 /*
@@ -113,8 +111,6 @@ void cpu_idle(void)
 			stop_critical_timings();
 			pm_idle();
 			start_critical_timings();
-			trace_power_end(smp_processor_id());
-			trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 		}
 		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 4c818a7..bd387e8 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -51,8 +51,6 @@
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
 
-#include <trace/events/power.h>
-
 asmlinkage extern void ret_from_fork(void);
 
 DEFINE_PER_CPU(unsigned long, old_rsp);
@@ -141,10 +139,6 @@ void cpu_idle(void)
 			pm_idle();
 			start_critical_timings();
 
-			trace_power_end(smp_processor_id());
-			trace_cpu_idle(PWR_EVENT_EXIT,
-				       smp_processor_id());
-
 			/* In many cases the interrupt that ended idle
 			   has already called exit_idle. But some idle
 			   loops can be woken up without interrupt. */
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 99cc8fc..4649495 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -96,7 +96,15 @@ static void cpuidle_idle_call(void)
 
 	/* enter the state and update stats */
 	dev->last_state = target_state;
+
+	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
+	trace_cpu_idle(next_state, dev->cpu);
+
 	dev->last_residency = target_state->enter(dev, target_state);
+
+	trace_power_end(dev->cpu);
+	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
+
 	if (dev->last_state)
 		target_state = dev->last_state;
 
@@ -106,8 +114,6 @@ static void cpuidle_idle_call(void)
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev);
-	trace_power_end(smp_processor_id());
-	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 }
 
 /**
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index ba5134f..60414ae 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -220,8 +220,6 @@ static int intel_idle(struct cpuidle_device *dev, struct cpuidle_state *state)
 	kt_before = ktime_get_real();
 
 	stop_critical_timings();
-	trace_power_start(POWER_CSTATE, (eax >> 4) + 1, cpu);
-	trace_cpu_idle((eax >> 4) + 1, cpu);
 	if (!need_resched()) {
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
-- 
1.6.0.2

