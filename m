Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab2FAKXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 06:23:20 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45444 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2FAKXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 06:23:18 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 22/27] um, smpboot: Use generic SMP booting infrastructure
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Date: Fri, 01 Jun 2012 14:45:24 +0530
Message-ID: <20120601091519.31979.57333.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12053123-5140-0000-0000-00000183395D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

Convert um to use the generic framework to boot secondary CPUs.

Notes:
1. Removed call to default_idle() in idle_proc(). The generic framework will
invoke cpu_idle().
2. The generic code will call preempt_disable() and local_irq_enable() which
weren't originally present in idle_proc().

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: user-mode-linux-user@lists.sourceforge.net
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/um/kernel/smp.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
index a02b7e9..6cffcf4 100644
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -10,6 +10,7 @@
 #ifdef CONFIG_SMP
 
 #include "linux/sched.h"
+#include "linux/smpboot.h"
 #include "linux/module.h"
 #include "linux/threads.h"
 #include "linux/interrupt.h"
@@ -58,6 +59,12 @@ static cpumask_t cpu_callin_map = CPU_MASK_NONE;
 
 static int idle_proc(void *cpup)
 {
+	smpboot_start_secondary(cpup);
+	return 0;
+}
+
+void __cpuinit __cpu_pre_starting(void *unused)
+{
 	int cpu = (int) cpup, err;
 
 	err = os_pipe(cpu_data[cpu].ipi_pipe, 1, 1);
@@ -74,11 +81,6 @@ static int idle_proc(void *cpup)
 
 	while (!cpu_isset(cpu, smp_commenced_mask))
 		cpu_relax();
-
-	notify_cpu_starting(cpu);
-	set_cpu_online(cpu, true);
-	default_idle();
-	return 0;
 }
 
 static struct task_struct *idle_thread(int cpu)

