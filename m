Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab2FAKIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 06:08:49 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:42611 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379Ab2FAKIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 06:08:48 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 20/27] sparc64, smpboot: Use generic SMP booting infrastructure
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, Jiri Kosina <jkosina@suse.cz>,
        sparclinux@vger.kernel.org
Date: Fri, 01 Jun 2012 14:44:54 +0530
Message-ID: <20120601091449.31979.67743.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12053123-0260-0000-0000-000001465FE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

Convert sparc64 to use the generic framework to boot secondary CPUs.

Notes:
Remove the calls to cpu_idle() from assembly files because we will invoke
cpu_idle() in generic code.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/sparc/kernel/hvtramp.S       |    1 -
 arch/sparc/kernel/smp_64.c        |   18 ++++++++++--------
 arch/sparc/kernel/trampoline_64.S |    1 -
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/kernel/hvtramp.S b/arch/sparc/kernel/hvtramp.S
index 9365432..3eb7e0b 100644
--- a/arch/sparc/kernel/hvtramp.S
+++ b/arch/sparc/kernel/hvtramp.S
@@ -128,7 +128,6 @@ hv_cpu_startup:
 
 	call		smp_callin
 	 nop
-	call		cpu_idle
 	 mov		0, %o0
 	call		cpu_panic
 	 nop
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 781bcb1..3c45538 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -25,6 +25,7 @@
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
 #include <linux/slab.h>
+#include <linux/smpboot.h>
 
 #include <asm/head.h>
 #include <asm/ptrace.h>
@@ -89,6 +90,11 @@ static volatile unsigned long callin_flag = 0;
 
 void __cpuinit smp_callin(void)
 {
+	smpboot_start_secondary(NULL);
+}
+
+void __cpuinit __cpu_pre_starting(void *unused)
+{
 	int cpuid = hard_smp_processor_id();
 
 	__local_per_cpu_offset = __per_cpu_offset(cpuid);
@@ -115,18 +121,14 @@ void __cpuinit smp_callin(void)
 	/* Attach to the address space of init_task. */
 	atomic_inc(&init_mm.mm_count);
 	current->active_mm = &init_mm;
+}
 
-	/* inform the notifiers about the new cpu */
-	notify_cpu_starting(cpuid);
+void __cpuinit __cpu_pre_online(void *unused)
+{
+	unsigned int cpuid = hard_smp_processor_id();
 
 	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		rmb();
-
-	set_cpu_online(cpuid, true);
-	local_irq_enable();
-
-	/* idle thread is expected to have preempt disabled */
-	preempt_disable();
 }
 
 void cpu_panic(void)
diff --git a/arch/sparc/kernel/trampoline_64.S b/arch/sparc/kernel/trampoline_64.S
index da1b781..379b464 100644
--- a/arch/sparc/kernel/trampoline_64.S
+++ b/arch/sparc/kernel/trampoline_64.S
@@ -407,7 +407,6 @@ after_lock_tlb:
 
 	call		smp_callin
 	 nop
-	call		cpu_idle
 	 mov		0, %o0
 	call		cpu_panic
 	 nop

