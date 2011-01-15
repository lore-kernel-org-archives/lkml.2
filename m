Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1AOPSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:18:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45876 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab1AOPSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:18:14 -0500
Date: Sat, 15 Jan 2011 16:17:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110115151759.GA12020@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
drivers/acpi/numa.c                # 9378b63: x86, ia64, acpi: Clean up x86-ism

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, olpc: Add missing Kconfig dependencies

Jacob Pan (1):
      x86, mrst: Set correct APB timer IRQ affinity for secondary cpu

John Stultz (1):
      x86: tsc: Fix calibration refinement conditionals to avoid divide by zero

Tony Luck (1):
      x86, ia64, acpi: Clean up x86-ism in drivers/acpi/numa.c


 arch/x86/Kconfig            |    1 +
 arch/x86/kernel/apb_timer.c |   14 ++++++++------
 arch/x86/kernel/tsc.c       |    4 ++--
 drivers/acpi/numa.c         |    8 ++------
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b6fccb0..184bc88 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2064,6 +2064,7 @@ config OLPC
 	bool "One Laptop Per Child support"
 	select GPIOLIB
 	select OLPC_OPENFIRMWARE
+	depends on !X86_64 && !X86_PAE
 	---help---
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 7c9ab59..51ef31a 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -313,14 +313,16 @@ static void apbt_setup_irq(struct apbt_dev *adev)
 	if (adev->irq == 0)
 		return;
 
+	irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
+	irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
+	/* APB timer irqs are set up as mp_irqs, timer is edge type */
+	__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
+
 	if (system_state == SYSTEM_BOOTING) {
-		irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
-		irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
-		/* APB timer irqs are set up as mp_irqs, timer is edge type */
-		__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
 		if (request_irq(adev->irq, apbt_interrupt_handler,
-				IRQF_TIMER | IRQF_DISABLED | IRQF_NOBALANCING,
-				adev->name, adev)) {
+					IRQF_TIMER | IRQF_DISABLED |
+					IRQF_NOBALANCING,
+					adev->name, adev)) {
 			printk(KERN_ERR "Failed request IRQ for APBT%d\n",
 			       adev->num);
 		}
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 463901e..ae09f97 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -464,7 +464,7 @@ unsigned long native_calibrate_tsc(void)
 		tsc_pit_min = min(tsc_pit_min, tsc_pit_khz);
 
 		/* hpet or pmtimer available ? */
-		if (!hpet && !ref1 && !ref2)
+		if (ref1 == ref2)
 			continue;
 
 		/* Check, whether the sampling was disturbed by an SMI */
@@ -935,7 +935,7 @@ static void tsc_refine_calibration_work(struct work_struct *work)
 	tsc_stop = tsc_read_refs(&ref_stop, hpet);
 
 	/* hpet or pmtimer available ? */
-	if (!hpet && !ref_start && !ref_stop)
+	if (ref_start == ref_stop)
 		goto out;
 
 	/* Check, whether the sampling was disturbed by an SMI */
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index d9926af..5eb25eb 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -275,23 +275,19 @@ acpi_table_parse_srat(enum acpi_srat_type id,
 int __init acpi_numa_init(void)
 {
 	int ret = 0;
-	int nr_cpu_entries = nr_cpu_ids;
 
-#ifdef CONFIG_X86
 	/*
 	 * Should not limit number with cpu num that is from NR_CPUS or nr_cpus=
 	 * SRAT cpu entries could have different order with that in MADT.
 	 * So go over all cpu entries in SRAT to get apicid to node mapping.
 	 */
-	nr_cpu_entries = MAX_LOCAL_APIC;
-#endif
 
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
-				     acpi_parse_x2apic_affinity, nr_cpu_entries);
+				     acpi_parse_x2apic_affinity, 0);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-				     acpi_parse_processor_affinity, nr_cpu_entries);
+				     acpi_parse_processor_affinity, 0);
 		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 					    acpi_parse_memory_affinity,
 					    NR_NODE_MEMBLKS);
