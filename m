Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab2FAJRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:17:07 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:38032 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467Ab2FAJRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:17:02 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 25/27] s390, smpboot: Use generic SMP booting infrastructure
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux390@de.ibm.com (supporter:S390),
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jan Glauber <jang@linux.vnet.ibm.com>, linux-s390@vger.kernel.org
Date: Fri, 01 Jun 2012 14:46:09 +0530
Message-ID: <20120601091604.31979.71351.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060109-4790-0000-0000-000003097106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert s390 to use the generic framework to boot secondary CPUs.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com (supporter:S390)
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/s390/kernel/smp.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 14c8a08..3eb12e6 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -29,6 +29,7 @@
 #include <linux/interrupt.h>
 #include <linux/irqflags.h>
 #include <linux/cpu.h>
+#include <linux/smpboot.h>
 #include <linux/slab.h>
 #include <linux/crash_dump.h>
 #include <asm/asm-offsets.h>
@@ -702,6 +703,11 @@ static void __init smp_detect_cpus(void)
  */
 static void __cpuinit smp_start_secondary(void *cpuvoid)
 {
+	smpboot_start_secondary(cpuvoid);
+}
+
+void __cpuinit __cpu_pre_starting(void *unused)
+{
 	S390_lowcore.last_update_clock = get_clock();
 	S390_lowcore.restart_stack = (unsigned long) restart_stack;
 	S390_lowcore.restart_fn = (unsigned long) do_restart;
@@ -711,15 +717,9 @@ static void __cpuinit smp_start_secondary(void *cpuvoid)
 	__ctl_load(S390_lowcore.cregs_save_area, 0, 15);
 	__load_psw_mask(psw_kernel_bits | PSW_MASK_DAT);
 	cpu_init();
-	preempt_disable();
 	init_cpu_timer();
 	init_cpu_vtimer();
 	pfault_init();
-	notify_cpu_starting(smp_processor_id());
-	set_cpu_online(smp_processor_id(), true);
-	local_irq_enable();
-	/* cpu_idle will call schedule for us */
-	cpu_idle();
 }
 
 /* Upping and downing of CPUs */

