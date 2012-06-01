Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965931Ab2FAWsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:48:47 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45064 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965890Ab2FAWsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:48:45 -0400
Message-ID: <4FC94693.5050707@linux.vnet.ibm.com>
Date: Sat, 02 Jun 2012 04:17:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        yong.zhang0@gmail.com, akpm@linux-foundation.org,
        vatsa@linux.vnet.ibm.com, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikunj@linux.vnet.ibm.com,
        vapier@gentoo.org, konrad@gaisler.com, tkhai@yandex.ru,
        sparclinux@vger.kernel.org
Subject: [UPDATED PATCH 21/27] sparc32, smpboot: Use generic SMP booting infrastructure
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091503.31979.52537.stgit@srivatsabhat.in.ibm.com> <20120601.135612.699120609738854050.davem@davemloft.net> <20120601185448.GA19148@merkur.ravnborg.org>
In-Reply-To: <20120601185448.GA19148@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060112-5490-0000-0000-000001851AD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Convert sparc32 to use the generic framework to boot secondary CPUs.

Notes:
While removing the call to cpu_idle(), we can also remove the call to
cpu_panic() because we are calling BUG() in the generic code anyway.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Konrad Eisele <konrad@gaisler.com>
Cc: Tkhai Kirill <tkhai@yandex.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/sparc/kernel/leon_smp.c      |   25 +++++++++++++++----------
 arch/sparc/kernel/sun4d_smp.c     |   26 +++++++++++++-------------
 arch/sparc/kernel/sun4m_smp.c     |   26 +++++++++++++++-----------
 arch/sparc/kernel/trampoline_32.S |   12 ------------
 4 files changed, 43 insertions(+), 46 deletions(-)

diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index a469090..498ca9b 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -25,6 +25,7 @@
 #include <linux/gfp.h>
 #include <linux/cpu.h>
 #include <linux/clockchips.h>
+#include <linux/smpboot.h>
 
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
@@ -73,13 +74,21 @@ static inline unsigned long do_swap(volatile unsigned long *ptr,
 
 void __cpuinit leon_callin(void)
 {
-	int cpuid = hard_smp_processor_id();
+	smpboot_start_secondary(NULL);
+}
+
+void __cpuinit __cpu_pre_starting(void *unused)
+{
+	unsigned int cpuid = hard_smp_processor_id();
 
 	local_ops->cache_all();
 	local_ops->tlb_all();
 	leon_configure_cache_smp();
+}
 
-	notify_cpu_starting(cpuid);
+void __cpuinit __cpu_pre_online(void *unused)
+{
+	unsigned int cpuid = hard_smp_processor_id();
 
 	/* Get our local ticker going. */
 	register_percpu_ce(cpuid);
@@ -91,11 +100,10 @@ void __cpuinit leon_callin(void)
 	local_ops->tlb_all();
 
 	/*
-	 * Unblock the master CPU _only_ when the scheduler state
-	 * of all secondary CPUs will be up-to-date, so after
-	 * the SMP initialization the master will be just allowed
-	 * to call the scheduler code.
-	 * Allow master to continue.
+	 * Allow master to continue. The master will then give us the
+	 * go-ahead by setting the smp_commenced_mask and will wait without
+	 * timeouts until our setup is completed fully (signified by
+	 * our bit being set in the cpu_online_mask).
 	 */
 	do_swap(&cpu_callin_map[cpuid], 1);
 
@@ -112,9 +120,6 @@ void __cpuinit leon_callin(void)
 
 	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		mb();
-
-	local_irq_enable();
-	set_cpu_online(cpuid, true);
 }
 
 /*
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index ddaea31..cd5367a 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -12,6 +12,7 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/cpu.h>
+#include <linux/smpboot.h>
 
 #include <asm/cacheflush.h>
 #include <asm/switch_to.h>
@@ -52,8 +53,12 @@ static inline void show_leds(int cpuid)
 
 void __cpuinit smp4d_callin(void)
 {
-	int cpuid = hard_smp_processor_id();
-	unsigned long flags;
+	smpboot_start_secondary(NULL);
+}
+
+void __cpuinit __cpu_pre_starting(void *unused)
+{
+	unsigned int cpuid = hard_smp_processor_id();
 
 	/* Show we are alive */
 	cpu_leds[cpuid] = 0x6;
@@ -64,14 +69,13 @@ void __cpuinit smp4d_callin(void)
 
 	local_ops->cache_all();
 	local_ops->tlb_all();
+}
+
+void __cpuinit __cpu_pre_online(void *unused)
+{
+	unsigned int cpuid = hard_smp_processor_id();
+	unsigned long flags;
 
-	notify_cpu_starting(cpuid);
-	/*
-	 * Unblock the master CPU _only_ when the scheduler state
-	 * of all secondary CPUs will be up-to-date, so after
-	 * the SMP initialization the master will be just allowed
-	 * to call the scheduler code.
-	 */
 	/* Get our local ticker going. */
 	register_percpu_ce(cpuid);
 
@@ -106,16 +110,12 @@ void __cpuinit smp4d_callin(void)
 	local_ops->cache_all();
 	local_ops->tlb_all();
 
-	local_irq_enable();	/* We don't allow PIL 14 yet */
-
 	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		barrier();
 
 	spin_lock_irqsave(&sun4d_imsk_lock, flags);
 	cc_set_imsk(cc_get_imsk() & ~0x4000); /* Allow PIL 14 as well */
 	spin_unlock_irqrestore(&sun4d_imsk_lock, flags);
-	set_cpu_online(cpuid, true);
-
 }
 
 /*
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index 128af73..ed05f54 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -10,6 +10,7 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/cpu.h>
+#include <linux/smpboot.h>
 
 #include <asm/cacheflush.h>
 #include <asm/switch_to.h>
@@ -36,12 +37,20 @@ swap_ulong(volatile unsigned long *ptr, unsigned long val)
 
 void __cpuinit smp4m_callin(void)
 {
-	int cpuid = hard_smp_processor_id();
+	smpboot_start_secondary(NULL);
+}
+
+void __cpuinit __cpu_pre_starting(void *unused)
+{
+	unsigned int cpuid = hard_smp_processor_id();
 
 	local_ops->cache_all();
 	local_ops->tlb_all();
+}
 
-	notify_cpu_starting(cpuid);
+void __cpuinit __cpu_pre_online(void *unused)
+{
+	unsigned int cpuid = hard_smp_processor_id();
 
 	register_percpu_ce(cpuid);
 
@@ -52,12 +61,11 @@ void __cpuinit smp4m_callin(void)
 	local_ops->tlb_all();
 
 	/*
-	 * Unblock the master CPU _only_ when the scheduler state
-	 * of all secondary CPUs will be up-to-date, so after
-	 * the SMP initialization the master will be just allowed
-	 * to call the scheduler code.
+	 * Allow master to continue. The master will then give us the
+	 * go-ahead by setting the smp_commenced_mask and will wait without
+	 * timeouts until our setup is completed fully (signified by
+	 * our bit being set in the cpu_online_mask).
 	 */
-	/* Allow master to continue. */
 	swap_ulong(&cpu_callin_map[cpuid], 1);
 
 	/* XXX: What's up with all the flushes? */
@@ -75,10 +83,6 @@ void __cpuinit smp4m_callin(void)
 
 	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		mb();
-
-	local_irq_enable();
-
-	set_cpu_online(cpuid, true);
 }
 
 /*
diff --git a/arch/sparc/kernel/trampoline_32.S b/arch/sparc/kernel/trampoline_32.S
index 7364ddc..75b659e 100644
--- a/arch/sparc/kernel/trampoline_32.S
+++ b/arch/sparc/kernel/trampoline_32.S
@@ -82,17 +82,9 @@ cpu3_startup:
 	call	smp4m_callin
 	 nop
 
-	b,a	smp_do_cpu_idle
-
 	.text
 	.align	4
 
-smp_do_cpu_idle:
-	call	cpu_idle
-	 mov	0, %o0
-
-	call	cpu_panic
-	 nop
 
 /* CPUID in bootbus can be found at PA 0xff0140000 */
 #define SUN4D_BOOTBUS_CPUID	0xf0140000
@@ -147,8 +139,6 @@ sun4d_cpu_startup:
 	call	smp4d_callin
 	 nop
 
-	b,a	smp_do_cpu_idle
-
 #ifdef CONFIG_SPARC_LEON
 
 	__CPUINIT
@@ -206,6 +196,4 @@ leon_smp_cpu_startup:
 	call	leon_callin
 	 nop
 
-	b,a	smp_do_cpu_idle
-
 #endif

