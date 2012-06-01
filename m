Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab2FAJRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:17:23 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:39454 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759181Ab2FAJRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:17:19 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 27/27] alpha, smpboot: Use generic SMP booting infrastructure
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mike Frysinger <vapier@gentoo.org>, linux-alpha@vger.kernel.org
Date: Fri, 01 Jun 2012 14:46:30 +0530
Message-ID: <20120601091625.31979.49911.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060109-8256-0000-0000-000002C1D083
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert alpha to use the generic framework to boot secondary CPUs.

Notes:
1. The secondary cpu was being set in the cpu_online_mask way too early.
Postpone it.

2. The original code was enabling interrupts before calling
wait_boot_cpu_to_stop(). Instead postpone the enabling of interrupts
to after the cpu_online_mask is set.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: linux-alpha@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/alpha/kernel/smp.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 35ddc02..2547431 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -28,6 +28,7 @@
 #include <linux/profile.h>
 #include <linux/bitops.h>
 #include <linux/cpu.h>
+#include <linux/smpboot.h>
 
 #include <asm/hwrpb.h>
 #include <asm/ptrace.h>
@@ -119,13 +120,17 @@ wait_boot_cpu_to_stop(int cpuid)
 void __cpuinit
 smp_callin(void)
 {
-	int cpuid = hard_smp_processor_id();
+	smpboot_start_secondary(NULL);
+}
+
+void __cpuinit __cpu_pre_starting(void *unused)
+{
+	unsigned int cpuid = hard_smp_processor_id();
 
 	if (cpu_online(cpuid)) {
 		printk("??, cpu 0x%x already present??\n", cpuid);
 		BUG();
 	}
-	set_cpu_online(cpuid, true);
 
 	/* Turn on machine checks.  */
 	wrmces(7);
@@ -145,15 +150,16 @@ smp_callin(void)
 	/* All kernel threads share the same mm context.  */
 	atomic_inc(&init_mm.mm_count);
 	current->active_mm = &init_mm;
+}
 
-	/* inform the notifiers about the new cpu */
-	notify_cpu_starting(cpuid);
-
-	/* Must have completely accurate bogos.  */
-	local_irq_enable();
+void __cpuinit __cpu_pre_online(void *unused)
+{
+	unsigned int cpuid = hard_smp_processor_id();
 
-	/* Wait boot CPU to stop with irq enabled before running
-	   calibrate_delay. */
+	/*
+	 * Wait boot CPU to stop with irq disabled before running
+	 * calibrate_delay.
+	 */
 	wait_boot_cpu_to_stop(cpuid);
 	mb();
 	calibrate_delay();
@@ -165,9 +171,6 @@ smp_callin(void)
 
 	DBGS(("smp_callin: commencing CPU %d current %p active_mm %p\n",
 	      cpuid, current, current->active_mm));
-
-	/* Do nothing.  */
-	cpu_idle();
 }
 
 /* Wait until hwrpb->txrdy is clear for cpu.  Return -1 on timeout.  */

