Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0FNLhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:37:32 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:40666 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269Ab0FNLhb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:37:31 -0400
Subject: [PATCH] x86: add power_end event to process_*.c cpu_idle routine
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 13:37:20 +0200
Message-ID: <1276515440.5441.45.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8BIT
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Schöne <robert.schoene@tu-dresden.de>

Systems using the idle thread from process_32.c and process_64.c do not
generate power_end events which could be traced using perf. This patch
adds the event generation for such systems.

Signed-off-by: Robert Schöne <robert.schoene@tu-dresden.de>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>

---
The smp_processor_id() is given to power_end as i hope that the changed
interface defined in http://lkml.org/lkml/2010/4/27/271 will be part of
the standard tree one day. (It is currently part of the -mm tree.) As
long as this new interface is not included in the standard tree, this
patch won't make no harm. When it will be included, this code does not
have to be touched anymore.


 arch/x86/kernel/process_32.c |    4 ++++
 arch/x86/kernel/process_64.c |    5 +++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f6c6266..134f5f9 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -58,6 +58,8 @@
 #include <asm/ds.h>
 #include <asm/debugreg.h>
 
+#include <trace/events/power.h> 
+
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
 /*
@@ -112,6 +114,8 @@ void cpu_idle(void)
 			stop_critical_timings();
 			pm_idle();
 			start_critical_timings();
+
+			trace_power_end(smp_processor_id());
 		}
 		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 17cb329..01c55ed 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -52,6 +52,8 @@
 #include <asm/ds.h>
 #include <asm/debugreg.h>
 
+#include <trace/events/power.h> 
+
 asmlinkage extern void ret_from_fork(void);
 
 DEFINE_PER_CPU(unsigned long, old_rsp);
@@ -139,6 +141,9 @@ void cpu_idle(void)
 			stop_critical_timings();
 			pm_idle();
 			start_critical_timings();
+
+			trace_power_end(smp_processor_id());
+
 			/* In many cases the interrupt that ended idle
 			   has already called exit_idle. But some idle
 			   loops can be woken up without interrupt. */




