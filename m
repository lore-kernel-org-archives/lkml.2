Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965939Ab2FAWpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:45:14 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55943 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965841Ab2FAWpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:45:09 -0400
Message-ID: <4FC945C1.2000004@linux.vnet.ibm.com>
Date: Sat, 02 Jun 2012 04:14:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikunj@linux.vnet.ibm.com, paul.gortmaker@windriver.com,
        vapier@gentoo.org, jkosina@suse.cz, sparclinux@vger.kernel.org
Subject: [UPDATED PATCH 20/27] sparc64, smpboot: Use generic SMP booting infrastructure
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091449.31979.67743.stgit@srivatsabhat.in.ibm.com> <20120601.135522.2065505829159749961.davem@davemloft.net>
In-Reply-To: <20120601.135522.2065505829159749961.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060122-9574-0000-0000-00000303CF9D
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

 arch/sparc/kernel/hvtramp.S       |    2 --
 arch/sparc/kernel/smp_64.c        |   18 ++++++++++--------
 arch/sparc/kernel/trampoline_64.S |    2 --
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/sparc/kernel/hvtramp.S b/arch/sparc/kernel/hvtramp.S
index 9365432..e1a45cf 100644
--- a/arch/sparc/kernel/hvtramp.S
+++ b/arch/sparc/kernel/hvtramp.S
@@ -128,8 +128,6 @@ hv_cpu_startup:
 
 	call		smp_callin
 	 nop
-	call		cpu_idle
-	 mov		0, %o0
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
index da1b781..6171126 100644
--- a/arch/sparc/kernel/trampoline_64.S
+++ b/arch/sparc/kernel/trampoline_64.S
@@ -407,8 +407,6 @@ after_lock_tlb:
 
 	call		smp_callin
 	 nop
-	call		cpu_idle
-	 mov		0, %o0
 	call		cpu_panic
 	 nop
 1:	b,a,pt		%xcc, 1b

