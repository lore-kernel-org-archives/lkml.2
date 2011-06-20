Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1FTJYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 05:24:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48353 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab1FTJYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 05:24:45 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
Date: Mon, 20 Jun 2011 14:53:59 +0530
Message-ID: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.5.6.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current ARM CPU hotplug code suffers from couple of race conditions
in CPU online path with scheduler.
The ARM CPU hotplug code doesn't wait for hot-plugged CPU to be marked
active as part of cpu_notify() by the CPU which brought it up before
enabling interrupts.

So we end up in with couple of race conditions,
1) Interrupts are enabled even before CPU is marked as active.
2) Newly plugged CPU is marked as active but it is not marked online yet.

When an interrupt happens before the cpu_active bit is set, the scheduler
can't schedule the woken thread which is bound to that newly onlined cpu
and and selects a fallback runqueue.

Secondly marking CPU active before it is online also not desirable behaviour.

Fix this race conditions.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
On v3.0 kernel I started seeing lock-up and random crashes when
CPU online/offline was attempted aggressively. With git bisect I could
reach to Peter's commit e4a52bcb9a18142d79e231b6733cabdbf2e67c1f[sched:
Remove rq->lock from the first half of ttwu()] which was also reported
by Marc Zyngier. But even after using the follow up fix from Peter
d6aa8f85f163[sched: Fix ttwu() for __ARCH_WANT_INTERRUPTS_ON_CTXSW],
I was still seeing issues with hotplug path. So as a experiment I just
pushed down the interrupt enabling on newly plugged CPU after it's marked
as online. This made things better and much stable but occasionally I was
still seeing lock-up.

With above as background I looked at arch/x86/ code and got convinced
myself that the experimental hack could be the right fix. While doing
this I came across a commit from Thomas fd8a7de177b [x86: cpu-hotplug:
Prevent softirq wakeup on wrong CPU] which fixed the race 2) on x86
architecture. 

In this patch I have folded possible fixes for both race conditions for
ARM hotplug code as mentioned in change log. Hopefully I am not
introducing any new race with this patch and hence the RFC. 

 arch/arm/kernel/smp.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 344e52b..84373a9 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -302,13 +302,6 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	platform_secondary_init(cpu);
 
 	/*
-	 * Enable local interrupts.
-	 */
-	notify_cpu_starting(cpu);
-	local_irq_enable();
-	local_fiq_enable();
-
-	/*
 	 * Setup the percpu timer for this CPU.
 	 */
 	percpu_timer_setup();
@@ -322,6 +315,17 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	 */
 	set_cpu_online(cpu, true);
 
+
+	while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
+		cpu_relax();
+
+	/*
+	 * Enable local interrupts.
+	 */
+	notify_cpu_starting(cpu);
+	local_irq_enable();
+	local_fiq_enable();
+
 	/*
 	 * OK, it's off to the idle thread for us
 	 */
-- 
1.6.0.4

