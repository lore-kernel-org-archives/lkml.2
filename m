Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab0CZPoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:44:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab0CZPoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:44:07 -0400
Date: Fri, 26 Mar 2010 16:43:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20100326154354.GA10959@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86, amd: Restrict usage of c1e_idle()

Jan Beulich (1):
      x86: Fix placement of FIX_OHCI1394_BASE

Suresh Siddha (1):
      x86: Handle legacy PIC interrupts on all the cpu's


 arch/x86/include/asm/fixmap.h    |    6 +++---
 arch/x86/include/asm/hw_irq.h    |    1 +
 arch/x86/include/asm/msr-index.h |    2 ++
 arch/x86/kernel/apic/io_apic.c   |    8 ++++++++
 arch/x86/kernel/irqinit.c        |   22 ++++++++++++++++++++++
 arch/x86/kernel/process.c        |   32 ++++++++++++++++++++++++--------
 arch/x86/kernel/smpboot.c        |    2 +-
 7 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 635f03b..d07b44f 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -82,6 +82,9 @@ enum fixed_addresses {
 #endif
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
+#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+	FIX_OHCI1394_BASE,
+#endif
 #ifdef CONFIG_X86_LOCAL_APIC
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 #endif
@@ -132,9 +135,6 @@ enum fixed_addresses {
 	   (__end_of_permanent_fixed_addresses & (TOTAL_FIX_BTMAPS - 1))
 	 : __end_of_permanent_fixed_addresses,
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1,
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	FIX_OHCI1394_BASE,
-#endif
 #ifdef CONFIG_X86_32
 	FIX_WP_TEST,
 #endif
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index a929c9e..46c0fe0 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -133,6 +133,7 @@ extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
+extern void setup_vector_irq(int cpu);
 
 #ifdef CONFIG_X86_IO_APIC
 extern void lock_vector_lock(void);
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1cd58cd..4604e6a 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -105,6 +105,8 @@
 #define MSR_AMD64_PATCH_LEVEL		0x0000008b
 #define MSR_AMD64_NB_CFG		0xc001001f
 #define MSR_AMD64_PATCH_LOADER		0xc0010020
+#define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
+#define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e4e0ddc..463de9a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1268,6 +1268,14 @@ void __setup_vector_irq(int cpu)
 	/* Mark the inuse vectors */
 	for_each_irq_desc(irq, desc) {
 		cfg = desc->chip_data;
+
+		/*
+		 * If it is a legacy IRQ handled by the legacy PIC, this cpu
+		 * will be part of the irq_cfg's domain.
+		 */
+		if (irq < legacy_pic->nr_legacy_irqs && !IO_APIC_IRQ(irq))
+			cpumask_set_cpu(cpu, cfg->domain);
+
 		if (!cpumask_test_cpu(cpu, cfg->domain))
 			continue;
 		vector = cfg->vector;
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index ef257fc..f01d390 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -141,6 +141,28 @@ void __init init_IRQ(void)
 	x86_init.irqs.intr_init();
 }
 
+/*
+ * Setup the vector to irq mappings.
+ */
+void setup_vector_irq(int cpu)
+{
+#ifndef CONFIG_X86_IO_APIC
+	int irq;
+
+	/*
+	 * On most of the platforms, legacy PIC delivers the interrupts on the
+	 * boot cpu. But there are certain platforms where PIC interrupts are
+	 * delivered to multiple cpu's. If the legacy IRQ is handled by the
+	 * legacy PIC, for the new cpu that is coming online, setup the static
+	 * legacy vector to irq mapping:
+	 */
+	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
+		per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
+#endif
+
+	__setup_vector_irq(cpu);
+}
+
 static void __init smp_intr_init(void)
 {
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ad95406..28ad9f4 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -526,21 +526,37 @@ static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 }
 
 /*
- * Check for AMD CPUs, which have potentially C1E support
+ * Check for AMD CPUs, where APIC timer interrupt does not wake up CPU from C1e.
+ * For more information see
+ * - Erratum #400 for NPT family 0xf and family 0x10 CPUs
+ * - Erratum #365 for family 0x11 (not affected because C1e not in use)
  */
 static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
 {
+	u64 val;
 	if (c->x86_vendor != X86_VENDOR_AMD)
-		return 0;
-
-	if (c->x86 < 0x0F)
-		return 0;
+		goto no_c1e_idle;
 
 	/* Family 0x0f models < rev F do not have C1E */
-	if (c->x86 == 0x0f && c->x86_model < 0x40)
-		return 0;
+	if (c->x86 == 0x0F && c->x86_model >= 0x40)
+		return 1;
 
-	return 1;
+	if (c->x86 == 0x10) {
+		/*
+		 * check OSVW bit for CPUs that are not affected
+		 * by erratum #400
+		 */
+		rdmsrl(MSR_AMD64_OSVW_ID_LENGTH, val);
+		if (val >= 2) {
+			rdmsrl(MSR_AMD64_OSVW_STATUS, val);
+			if (!(val & BIT(1)))
+				goto no_c1e_idle;
+		}
+		return 1;
+	}
+
+no_c1e_idle:
+	return 0;
 }
 
 static cpumask_var_t c1e_mask;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a02e80c..06d98ae 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -247,7 +247,7 @@ static void __cpuinit smp_callin(void)
 	/*
 	 * Need to setup vector mappings before we enable interrupts.
 	 */
-	__setup_vector_irq(smp_processor_id());
+	setup_vector_irq(smp_processor_id());
 	/*
 	 * Get our bogomips.
 	 *
