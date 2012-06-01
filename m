Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab2FAJRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:17:54 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:48954 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab2FAJNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:13:11 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 09/27] m32r, smpboot: Use generic SMP booting infrastructure
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        Hirokazu Takata <takata@linux-m32r.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org
Date: Fri, 01 Jun 2012 14:42:21 +0530
Message-ID: <20120601091216.31979.43892.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060109-9574-0000-0000-000003019571
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert m32r to use the generic framework to boot secondary CPUs.

Notes:
Postpone enabling interrupts to after booting the secondary CPU fully.

Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-m32r@ml.linux-m32r.org
Cc: linux-m32r-ja@ml.linux-m32r.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/m32r/kernel/smpboot.c |   46 ++++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 6ddc51a..cf3fc0c 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -49,6 +49,7 @@
 #include <linux/irq.h>
 #include <linux/bootmem.h>
 #include <linux/delay.h>
+#include <linux/smpboot.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -114,7 +115,6 @@ static void do_boot_cpu(int);
 
 int start_secondary(void *);
 static void smp_callin(void);
-static void smp_online(void);
 
 static void show_mp_info(int);
 static void smp_store_cpu_info(int);
@@ -418,22 +418,38 @@ void __init smp_cpus_done(unsigned int max_cpus)
  *==========================================================================*/
 int __init start_secondary(void *unused)
 {
+	smpboot_start_secondary(unused);
+	return 0;
+}
+
+void __cpuinit __cpu_pre_starting(void *unused)
+{
+	unsigned int cpu;
+
 	cpu_init();
-	preempt_disable();
 	smp_callin();
-	while (!cpumask_test_cpu(smp_processor_id(), &smp_commenced_mask))
+
+	cpu = smp_processor_id();
+	while (!cpumask_test_cpu(cpu, &smp_commenced_mask))
 		cpu_relax();
+}
 
-	smp_online();
+void __cpuinit __cpu_pre_online(void *unused)
+{
+	/* Get our bogomips. */
+	calibrate_delay();
 
+	/* Save our processor parameters */
+	smp_store_cpu_info(smp_processor_id());
+}
+
+void __cpuinit __cpu_post_online(void *unused)
+{
 	/*
 	 * low-memory mappings have been cleared, flush them from
 	 * the local TLBs too.
 	 */
 	local_flush_tlb_all();
-
-	cpu_idle();
-	return 0;
 }
 
 /*==========================================================================*
@@ -485,22 +501,6 @@ static void __init smp_callin(void)
 	cpumask_set_cpu(cpu_id, &cpu_callin_map);
 }
 
-static void __init smp_online(void)
-{
-	int cpu_id = smp_processor_id();
-
-	notify_cpu_starting(cpu_id);
-
-	local_irq_enable();
-
-	/* Get our bogomips. */
-	calibrate_delay();
-
-	/* Save our processor parameters */
- 	smp_store_cpu_info(cpu_id);
-
-	set_cpu_online(cpu_id, true);
-}
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 /* Boot up CPUs common Routines                                              */

