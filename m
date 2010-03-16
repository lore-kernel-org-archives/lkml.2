Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936217Ab0CPGCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:02:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:55563 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935167Ab0CPGCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:02:31 -0400
Date: Tue, 16 Mar 2010 06:00:49 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, ebiederm@xmission.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, ebiederm@xmission.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1268692386.3296.43.camel@sbs-t61.sc.intel.com>
References: <1268692386.3296.43.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Handle legacy PIC interrupts on all the cpu's
Message-ID: <tip-36e9e1eab777e077f7484d309ff676d0568e27d1@git.kernel.org>
Git-Commit-ID: 36e9e1eab777e077f7484d309ff676d0568e27d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 06:00:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36e9e1eab777e077f7484d309ff676d0568e27d1
Gitweb:     http://git.kernel.org/tip/36e9e1eab777e077f7484d309ff676d0568e27d1
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 15 Mar 2010 14:33:06 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 16 Mar 2010 06:36:35 +0100

x86: Handle legacy PIC interrupts on all the cpu's

Ingo Molnar reported that with the recent changes of not
statically blocking IRQ0_VECTOR..IRQ15_VECTOR's on all the
cpu's, broke an AMD platform (with Nvidia chipset) boot when
"noapic" boot option is used.

On this platform, legacy PIC interrupts are getting delivered to
all the cpu's instead of just the boot cpu. Thus not
initializing the vector to irq mapping for the legacy irq's
resulted in not handling certain interrupts causing boot hang.

Fix this by initializing the vector to irq mapping on all the
logical cpu's, if the legacy IRQ is handled by the legacy PIC.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
[ -v2: io-apic-enabled improvement ]
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1268692386.3296.43.camel@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/hw_irq.h  |    1 +
 arch/x86/kernel/apic/io_apic.c |    8 ++++++++
 arch/x86/kernel/irqinit.c      |   22 ++++++++++++++++++++++
 arch/x86/kernel/smpboot.c      |    2 +-
 4 files changed, 32 insertions(+), 1 deletions(-)

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
