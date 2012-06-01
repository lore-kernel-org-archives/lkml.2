Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab2FAKQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 06:16:17 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:32797 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379Ab2FAKQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 06:16:14 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 13/27] hexagon, smpboot: Use generic SMP booting infrastructure
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Richard Kuo <rkuo@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-hexagon@vger.kernel.org
Date: Fri, 01 Jun 2012 14:43:10 +0530
Message-ID: <20120601091304.31979.39256.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12053123-7014-0000-0000-0000014D52BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

Convert hexagon to use the generic framework to boot secondary CPUs.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-hexagon@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/hexagon/kernel/smp.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index 149fbef..0a679a4 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -29,6 +29,7 @@
 #include <linux/smp.h>
 #include <linux/spinlock.h>
 #include <linux/cpu.h>
+#include <linux/smpboot.h>
 
 #include <asm/time.h>    /*  timer_interrupt  */
 #include <asm/hexagon_vm.h>
@@ -148,7 +149,6 @@ void __init smp_prepare_boot_cpu(void)
 
 void __cpuinit start_secondary(void)
 {
-	unsigned int cpu;
 	unsigned long thread_ptr;
 
 	/*  Calculate thread_info pointer from stack pointer  */
@@ -165,6 +165,13 @@ void __cpuinit start_secondary(void)
 		: "r" (thread_ptr)
 	);
 
+	smpboot_start_secondary(NULL);
+}
+
+void __cpuinit __cpu_pre_starting(void *arg)
+{
+	unsigned int cpu;
+
 	/*  Set the memory struct  */
 	atomic_inc(&init_mm.mm_count);
 	current->active_mm = &init_mm;
@@ -177,17 +184,8 @@ void __cpuinit start_secondary(void)
 	setup_percpu_clockdev();
 
 	printk(KERN_INFO "%s cpu %d\n", __func__, current_thread_info()->cpu);
-
-	notify_cpu_starting(cpu);
-
-	set_cpu_online(cpu, true);
-
-	local_irq_enable();
-
-	cpu_idle();
 }
 
-
 /*
  * called once for each present cpu
  * apparently starts up the CPU and then

