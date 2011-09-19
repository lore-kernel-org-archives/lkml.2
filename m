Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1ISVyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:54:16 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:11432 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab1ISVyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:54:15 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E77B952.3010606@am.sony.com>
Date: Mon, 19 Sep 2011 14:51:14 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: <tglx@linutronix.de>, <linux-rt-users@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] preempt-rt: convert arm boot_lock to raw
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The arm boot_lock is used by the secondary processor startup code.  The locking
task is the idle thread, which has idle->sched_class == &idle_sched_class.
idle_sched_class->enqueue_task == NULL, so if the idle task blocks on the
lock, the attempt to wake it when the lock becomes available will fail:

try_to_wake_up()
   ...
      activate_task()
         enqueue_task()
            p->sched_class->enqueue_task(rq, p, flags)

Fix by converting boot_lock to a raw spin lock.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 arch/arm/mach-exynos4/platsmp.c   |   10 	5 +	5 -	0 !
 arch/arm/mach-msm/platsmp.c       |   10 	5 +	5 -	0 !
 arch/arm/mach-omap2/omap-smp.c    |   10 	5 +	5 -	0 !
 arch/arm/mach-tegra/platsmp.c     |   10 	5 +	5 -	0 !
 arch/arm/mach-ux500/platsmp.c     |   10 	5 +	5 -	0 !
 arch/arm/plat-versatile/platsmp.c |   10 	5 +	5 -	0 !
 6 files changed, 30 insertions(+), 30 deletions(-)

Index: b/arch/arm/plat-versatile/platsmp.c
===================================================================
--- a/arch/arm/plat-versatile/platsmp.c
+++ b/arch/arm/plat-versatile/platsmp.c
@@ -37,7 +37,7 @@ static void __cpuinit write_pen_release(
 	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
 }
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
@@ -57,8 +57,8 @@ void __cpuinit platform_secondary_init(u
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -69,7 +69,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * Set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 	/*
 	 * This is really belt and braces; we hold unintended secondary
@@ -99,7 +99,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return pen_release != -1 ? -ENOSYS : 0;
 }
Index: b/arch/arm/mach-exynos4/platsmp.c
===================================================================
--- a/arch/arm/mach-exynos4/platsmp.c
+++ b/arch/arm/mach-exynos4/platsmp.c
@@ -56,7 +56,7 @@ static void __iomem *scu_base_addr(void)
 	return (void __iomem *)(S5P_VA_SCU);
 }
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
@@ -76,8 +76,8 @@ void __cpuinit platform_secondary_init(u
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -88,7 +88,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * Set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 	/*
 	 * The secondary processor is waiting to be released from
@@ -120,7 +120,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return pen_release != -1 ? -ENOSYS : 0;
 }
Index: b/arch/arm/mach-msm/platsmp.c
===================================================================
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -38,7 +38,7 @@ extern void msm_secondary_startup(void);
  */
 volatile int pen_release = -1;
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
@@ -62,8 +62,8 @@ void __cpuinit platform_secondary_init(u
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 static __cpuinit void prepare_cold_cpu(unsigned int cpu)
@@ -100,7 +100,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 	/*
 	 * The secondary processor is waiting to be released from
@@ -134,7 +134,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return pen_release != -1 ? -ENOSYS : 0;
 }
Index: b/arch/arm/mach-omap2/omap-smp.c
===================================================================
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -29,7 +29,7 @@
 /* SCU base address */
 static void __iomem *scu_base;
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
@@ -43,8 +43,8 @@ void __cpuinit platform_secondary_init(u
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -53,7 +53,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * Set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 	/*
 	 * Update the AuxCoreBoot0 with boot state for secondary core.
@@ -70,7 +70,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * Now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return 0;
 }
Index: b/arch/arm/mach-tegra/platsmp.c
===================================================================
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -29,7 +29,7 @@
 
 extern void tegra_secondary_startup(void);
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 static void __iomem *scu_base = IO_ADDRESS(TEGRA_ARM_PERIF_BASE);
 
 #define EVP_CPU_RESET_VECTOR \
@@ -51,8 +51,8 @@ void __cpuinit platform_secondary_init(u
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -66,7 +66,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 
 	/* set the reset vector to point to the secondary_startup routine */
@@ -102,7 +102,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return 0;
 }
Index: b/arch/arm/mach-ux500/platsmp.c
===================================================================
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -57,7 +57,7 @@ static void __iomem *scu_base_addr(void)
 	return NULL;
 }
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
@@ -77,8 +77,8 @@ void __cpuinit platform_secondary_init(u
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -89,7 +89,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 	/*
 	 * The secondary processor is waiting to be released from
@@ -110,7 +110,7 @@ int __cpuinit boot_secondary(unsigned in
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return pen_release != -1 ? -ENOSYS : 0;
 }

