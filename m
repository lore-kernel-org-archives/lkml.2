Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0COVeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:34:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:4629 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab0COVeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:34:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,645,1262592000"; 
   d="scan'208";a="549268517"
Subject: [patch] x86: handle legacy PIC interrupts on all the cpu's
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 15 Mar 2010 14:33:06 -0800
Message-Id: <1268692386.3296.43.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar reported that with the recent changes of not statically blocking
IRQ0_VECTOR..IRQ15_VECTOR's on all the cpu's, broke an AMD platform
(with Nvidia chipset) boot when "noapic" boot option is used.

On this platform, legacy PIC interrupts are getting delivered to all the
cpu's instead of just the boot cpu. Thus not initializing the vector to irq
mapping for the legacy irq's resulted in not handling certain interrupts
causing boot hang.

Fix this by initializing the vector to irq mapping on all the logical cpu's,
if the legacy IRQ is handled by the legacy PIC.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

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
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e4e0ddc..10f0a1a 100644
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
index ef257fc..daaf413 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -141,6 +141,27 @@ void __init init_IRQ(void)
 	x86_init.irqs.intr_init();
 }
 
+/*
+ * Setup the vector to irq mappings.
+ */
+void setup_vector_irq(int cpu)
+{
+	int irq;
+
+	/*
+	 * On most of the platforms, legacy PIC delivers the interrupts on the
+	 * boot cpu. But there are certain platforms where PIC interrupts are
+	 * delivered to multiple cpu's. If the legacy IRQ is handled by the
+	 * legacy PIC, for the new cpu that is coming online, setup the static
+	 * legacy vector to irq mapping.
+	 */
+	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
+		if (!IO_APIC_IRQ(irq))
+			per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
+
+	__setup_vector_irq(cpu);
+}
+
 static void __init smp_intr_init(void)
 {
 #ifdef CONFIG_SMP
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


