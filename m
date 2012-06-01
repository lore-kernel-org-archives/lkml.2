Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab2FAJxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:53:03 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:41702 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759051Ab2FAJxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:53:01 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 19/27] blackfin,
 smpboot: Use generic SMP booting infrastructure
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>, Bob Liu <lliubbo@gmail.com>,
        Steven Miao <realmz6@gmail.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Date: Fri, 01 Jun 2012 14:44:40 +0530
Message-ID: <20120601091433.31979.19214.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12053123-1396-0000-0000-00000154A4C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

Convert blackfin to use the generic framework to boot secondary CPUs.

Notes:
The call to set_cpu_online() is removed from platform_secondary_init(), since
it will now be done by generic SMP booting code.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/blackfin/mach-bf561/smp.c  |    1 -
 arch/blackfin/mach-common/smp.c |   16 +++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/mach-bf561/smp.c b/arch/blackfin/mach-bf561/smp.c
index ab1c617..e7e2e50 100644
--- a/arch/blackfin/mach-bf561/smp.c
+++ b/arch/blackfin/mach-bf561/smp.c
@@ -69,7 +69,6 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
 	SSYNC();
 
 	/* We are done with local CPU inits, unblock the boot CPU. */
-	set_cpu_online(cpu, true);
 	spin_lock(&boot_lock);
 	spin_unlock(&boot_lock);
 }
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 00bbe67..9ee6f2f 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -25,6 +25,7 @@
 #include <linux/irq.h>
 #include <linux/slab.h>
 #include <linux/atomic.h>
+#include <linux/smpboot.h>
 #include <asm/cacheflush.h>
 #include <asm/irq_handler.h>
 #include <asm/mmu_context.h>
@@ -373,6 +374,11 @@ static void __cpuinit setup_secondary(unsigned int cpu)
 
 void __cpuinit secondary_start_kernel(void)
 {
+	smpboot_start_secondary(NULL);
+}
+
+void __cpuinit __cpu_pre_starting(void *unused)
+{
 	unsigned int cpu = smp_processor_id();
 	struct mm_struct *mm = &init_mm;
 
@@ -405,8 +411,6 @@ void __cpuinit secondary_start_kernel(void)
 	atomic_inc(&mm->mm_count);
 	current->active_mm = mm;
 
-	preempt_disable();
-
 	setup_secondary(cpu);
 
 	platform_secondary_init(cpu);
@@ -414,19 +418,17 @@ void __cpuinit secondary_start_kernel(void)
 	/* setup local core timer */
 	bfin_local_timer_setup();
 
-	local_irq_enable();
-
 	bfin_setup_caches(cpu);
+}
 
-	notify_cpu_starting(cpu);
+void __cpuinit __cpu_pre_online(void *unused)
+{
 	/*
 	 * Calibrate loops per jiffy value.
 	 * IRQs need to be enabled here - D-cache can be invalidated
 	 * in timer irq handler, so core B can read correct jiffies.
 	 */
 	calibrate_delay();
-
-	cpu_idle();
 }
 
 void __init smp_prepare_boot_cpu(void)

