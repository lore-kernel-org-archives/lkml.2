Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab0ENIjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:39:07 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:45446 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758082Ab0ENIjE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:39:04 -0400
Subject: [PATCH] power_end event
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 10:38:43 +0200
Message-ID: <1273826323.5258.133.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I reported the power_end tracing problem earlier this year
(http://lkml.org/lkml/2010/2/24/79) and sent a patch which worked for my
system. However this patch would have not worked on other systems (as
for example Arjans). It would had lead to a double posting of these
events.

However. Here's a diff that should fix the problem on the correct spot.

The reason that it worked for Arjan and not for me is that his system
uses drivers/acpi/processor_idle.c when idling, mine uses the cpu_idle
thread from arch/x86/kernel/process_64.c.
A comparable idle thread also exists for 32 bit x86, so I added it in
process_32.c too.

However, is there any standard about where to report the start and end
events? Currently it's the idle routine, which creates the power_start
event, the routine which calls the idle_routine on the other hand
creates the power_end event.

For these patches, I'm not sure whether the power_end event should even
be reported. On kernels, which use the repnop loop when idling, there
won't be a switch to another c-state and therefore no power_start event,
the power_end event could belong to. Would that be a problem? If it
would, the only way to fix this would be to move the power_end events
into the idle routines, since cpu_idle is dumb and does not know whats
behind pm_idle.

Robert

PS: I hand over the smp_processor_id() to power_end since i hope that
the changed interface defined in http://lkml.org/lkml/2010/4/27/271 will
be part of the standard tree one day. As long as this new interface is
not included in the standard tree, this patch won't make no harm. When
it will be included, this code does not have to be touched anymore.

Signed-off-by: Robert Schöne <robert.schoene@tu-dresden.de>

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


