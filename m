Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab1CRVt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:49:27 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3456 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab1CRVtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:49:05 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: tglx@linutronix.de, linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH 2/2] MIPS: Octeon: Rewrite interrupt handling code.
Date: Fri, 18 Mar 2011 14:48:36 -0700
Message-Id: <1300484916-11133-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300484916-11133-1-git-send-email-ddaney@caviumnetworks.com>
References: <1300484916-11133-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 18 Mar 2011 21:48:52.0329 (UTC) FILETIME=[45842D90:01CBE5B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes conversion to new style irq_chip functions, and
correctly enabling/disabling per-CPU interrupts.

The hardware interrupt bit to irq number mapping is now done with a
flexible map, instead of by bit twiddling the irq number.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/Kconfig                              |    1 +
 arch/mips/cavium-octeon/octeon-irq.c           | 1388 ++++++++++++++----------
 arch/mips/cavium-octeon/setup.c                |   12 -
 arch/mips/cavium-octeon/smp.c                  |   39 +-
 arch/mips/include/asm/mach-cavium-octeon/irq.h |  243 ++---
 arch/mips/include/asm/octeon/octeon.h          |    2 +
 arch/mips/pci/msi-octeon.c                     |   20 +-
 7 files changed, 919 insertions(+), 786 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 0a25a60..58d5680 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1355,6 +1355,7 @@ config CPU_CAVIUM_OCTEON
 	select WEAK_ORDERING
 	select CPU_SUPPORTS_HIGHMEM
 	select CPU_SUPPORTS_HUGEPAGES
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  The Cavium Octeon processor is a highly integrated chip containing
 	  many ethernet hardware widgets for networking tasks. The processor
diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index ce7500c..a289fc6 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -3,10 +3,13 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (C) 2004-2008, 2009, 2010 Cavium Networks
+ * Copyright (C) 2004-2008, 2009, 2010, 2011 Cavium Networks
  */
-#include <linux/irq.h>
+
 #include <linux/interrupt.h>
+#include <linux/bitops.h>
+#include <linux/percpu.h>
+#include <linux/irq.h>
 #include <linux/smp.h>
 
 #include <asm/octeon/octeon.h>
@@ -14,6 +17,47 @@
 static DEFINE_RAW_SPINLOCK(octeon_irq_ciu0_lock);
 static DEFINE_RAW_SPINLOCK(octeon_irq_ciu1_lock);
 
+static DEFINE_PER_CPU(unsigned long, octeon_irq_ciu0_en_mirror);
+static DEFINE_PER_CPU(unsigned long, octeon_irq_ciu1_en_mirror);
+
+static __read_mostly u8 octeon_irq_ciu_to_irq[8][64];
+
+union octeon_ciu_chip_data {
+	void *p;
+	unsigned long l;
+	struct {
+		unsigned int line:6;
+		unsigned int bit:6;
+	} s;
+};
+
+struct octeon_core_chip_data {
+	struct mutex core_irq_mutex;
+	bool current_en;
+	bool desired_en;
+	u8 bit;
+};
+
+#define MIPS_CORE_IRQ_LINES 8
+
+static struct octeon_core_chip_data octeon_irq_core_chip_data[MIPS_CORE_IRQ_LINES];
+
+static void __init octeon_irq_set_ciu_mapping(int irq, int line, int bit,
+					      struct irq_chip *chip,
+					      irq_flow_handler_t handler)
+{
+	union octeon_ciu_chip_data cd;
+
+	set_irq_chip_and_handler(irq, chip, handler);
+
+	cd.l = 0;
+	cd.s.line = line;
+	cd.s.bit = bit;
+
+	set_irq_chip_data(irq, cd.p);
+	octeon_irq_ciu_to_irq[line][bit] = irq;
+}
+
 static int octeon_coreid_for_cpu(int cpu)
 {
 #ifdef CONFIG_SMP
@@ -23,9 +67,20 @@ static int octeon_coreid_for_cpu(int cpu)
 #endif
 }
 
-static void octeon_irq_core_ack(unsigned int irq)
+static int octeon_cpu_for_coreid(int coreid)
+{
+#ifdef CONFIG_SMP
+	return cpu_number_map(coreid);
+#else
+	return smp_processor_id();
+#endif
+}
+
+static void octeon_irq_core_ack(struct irq_data *data)
 {
-	unsigned int bit = irq - OCTEON_IRQ_SW0;
+	struct octeon_core_chip_data *cd = irq_data_get_irq_chip_data(data);
+	unsigned int bit = cd->bit;
+
 	/*
 	 * We don't need to disable IRQs to make these atomic since
 	 * they are already disabled earlier in the low level
@@ -37,131 +92,133 @@ static void octeon_irq_core_ack(unsigned int irq)
 		clear_c0_cause(0x100 << bit);
 }
 
-static void octeon_irq_core_eoi(unsigned int irq)
+static void octeon_irq_core_eoi(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned int bit = irq - OCTEON_IRQ_SW0;
-	/*
-	 * If an IRQ is being processed while we are disabling it the
-	 * handler will attempt to unmask the interrupt after it has
-	 * been disabled.
-	 */
-	if ((unlikely(desc->status & IRQ_DISABLED)))
-		return;
+	struct octeon_core_chip_data *cd = irq_data_get_irq_chip_data(data);
+
 	/*
 	 * We don't need to disable IRQs to make these atomic since
 	 * they are already disabled earlier in the low level
 	 * interrupt code.
 	 */
-	set_c0_status(0x100 << bit);
+	set_c0_status(0x100 << cd->bit);
 }
 
-static void octeon_irq_core_enable(unsigned int irq)
+static void octeon_irq_core_set_enable_local(void *arg)
 {
-	unsigned long flags;
-	unsigned int bit = irq - OCTEON_IRQ_SW0;
+	struct irq_data *data = arg;
+	struct octeon_core_chip_data *cd = irq_data_get_irq_chip_data(data);
+	unsigned int mask = 0x100 << cd->bit;
 
 	/*
-	 * We need to disable interrupts to make sure our updates are
-	 * atomic.
+	 * Interrupts are already disabled, so these are atomic.
 	 */
-	local_irq_save(flags);
-	set_c0_status(0x100 << bit);
-	local_irq_restore(flags);
+	if (cd->desired_en)
+		set_c0_status(mask);
+	else
+		clear_c0_status(mask);
+
 }
 
-static void octeon_irq_core_disable_local(unsigned int irq)
+static void octeon_irq_core_disable(struct irq_data *data)
 {
-	unsigned long flags;
-	unsigned int bit = irq - OCTEON_IRQ_SW0;
-	/*
-	 * We need to disable interrupts to make sure our updates are
-	 * atomic.
-	 */
-	local_irq_save(flags);
-	clear_c0_status(0x100 << bit);
-	local_irq_restore(flags);
+	struct octeon_core_chip_data *cd = irq_data_get_irq_chip_data(data);
+	cd->desired_en = false;
 }
 
-static void octeon_irq_core_disable(unsigned int irq)
+static void octeon_irq_core_enable(struct irq_data *data)
 {
-#ifdef CONFIG_SMP
-	on_each_cpu((void (*)(void *)) octeon_irq_core_disable_local,
-		    (void *) (long) irq, 1);
-#else
-	octeon_irq_core_disable_local(irq);
-#endif
+	struct octeon_core_chip_data *cd = irq_data_get_irq_chip_data(data);
+	cd->desired_en = true;
 }
 
-static struct irq_chip octeon_irq_chip_core = {
-	.name = "Core",
-	.enable = octeon_irq_core_enable,
-	.disable = octeon_irq_core_disable,
-	.ack = octeon_irq_core_ack,
-	.eoi = octeon_irq_core_eoi,
-};
+static void octeon_irq_core_bus_lock(struct irq_data *data)
+{
+	struct octeon_core_chip_data *cd = irq_data_get_irq_chip_data(data);
 
+	mutex_lock(&cd->core_irq_mutex);
+}
 
-static void octeon_irq_ciu0_ack(unsigned int irq)
+static void octeon_irq_core_bus_sync_unlock(struct irq_data *data)
 {
-	switch (irq) {
-	case OCTEON_IRQ_GMX_DRP0:
-	case OCTEON_IRQ_GMX_DRP1:
-	case OCTEON_IRQ_IPD_DRP:
-	case OCTEON_IRQ_KEY_ZERO:
-	case OCTEON_IRQ_TIMER0:
-	case OCTEON_IRQ_TIMER1:
-	case OCTEON_IRQ_TIMER2:
-	case OCTEON_IRQ_TIMER3:
-	{
-		int index = cvmx_get_core_num() * 2;
-		u64 mask = 1ull << (irq - OCTEON_IRQ_WORKQ0);
-		/*
-		 * CIU timer type interrupts must be acknoleged by
-		 * writing a '1' bit to their sum0 bit.
-		 */
-		cvmx_write_csr(CVMX_CIU_INTX_SUM0(index), mask);
-		break;
-	}
-	default:
-		break;
+	struct octeon_core_chip_data *cd = irq_data_get_irq_chip_data(data);
+
+	if (cd->desired_en != cd->current_en) {
+		on_each_cpu(octeon_irq_core_set_enable_local, data, 1);
+
+		cd->current_en = cd->desired_en;
 	}
 
-	/*
-	 * In order to avoid any locking accessing the CIU, we
-	 * acknowledge CIU interrupts by disabling all of them.  This
-	 * way we can use a per core register and avoid any out of
-	 * core locking requirements.  This has the side affect that
-	 * CIU interrupts can't be processed recursively.
-	 *
-	 * We don't need to disable IRQs to make these atomic since
-	 * they are already disabled earlier in the low level
-	 * interrupt code.
-	 */
-	clear_c0_status(0x100 << 2);
+	mutex_unlock(&cd->core_irq_mutex);
 }
 
-static void octeon_irq_ciu0_eoi(unsigned int irq)
+
+static void octeon_irq_core_cpu_online(struct irq_data *data, bool e)
 {
-	/*
-	 * Enable all CIU interrupts again.  We don't need to disable
-	 * IRQs to make these atomic since they are already disabled
-	 * earlier in the low level interrupt code.
-	 */
-	set_c0_status(0x100 << 2);
+	if (e)
+		octeon_irq_core_eoi(data);
+}
+
+static void octeon_irq_core_cpu_offline(struct irq_data *data, bool e)
+{
+	if (e)
+		octeon_irq_core_ack(data);
+}
+
+static struct irq_chip octeon_irq_chip_core = {
+	.name = "Core",
+	.irq_enable = octeon_irq_core_enable,
+	.irq_disable = octeon_irq_core_disable,
+	.irq_ack = octeon_irq_core_ack,
+	.irq_eoi = octeon_irq_core_eoi,
+	.irq_bus_lock = octeon_irq_core_bus_lock,
+	.irq_bus_sync_unlock = octeon_irq_core_bus_sync_unlock,
+
+	.irq_cpu_online = octeon_irq_core_cpu_online,
+	.irq_cpu_offline = octeon_irq_core_cpu_offline,
+};
+
+static void __init octeon_irq_init_core(void)
+{
+	int i;
+	int irq;
+	struct octeon_core_chip_data *cd;
+
+	for (i = 0; i < MIPS_CORE_IRQ_LINES; i++) {
+		cd = &octeon_irq_core_chip_data[i];
+		cd->current_en = false;
+		cd->desired_en = false;
+		cd->bit = i;
+		mutex_init(&cd->core_irq_mutex);
+
+		irq = OCTEON_IRQ_SW0 + i;
+		switch (irq) {
+		case OCTEON_IRQ_TIMER:
+		case OCTEON_IRQ_SW0:
+		case OCTEON_IRQ_SW1:
+		case OCTEON_IRQ_5:
+		case OCTEON_IRQ_PERF:
+			set_irq_chip_data(irq, cd);
+			set_irq_chip_and_handler(irq, &octeon_irq_chip_core,
+						 handle_percpu_irq);
+			break;
+		default:
+			break;
+		}
+	}
 }
 
-static int next_coreid_for_irq(struct irq_desc *desc)
+static int next_cpu_for_irq(struct irq_data *data)
 {
 
 #ifdef CONFIG_SMP
-	int coreid;
-	int weight = cpumask_weight(desc->affinity);
+	int cpu;
+	int weight = cpumask_weight(data->affinity);
 
 	if (weight > 1) {
-		int cpu = smp_processor_id();
+		cpu = smp_processor_id();
 		for (;;) {
-			cpu = cpumask_next(cpu, desc->affinity);
+			cpu = cpumask_next(cpu, data->affinity);
 			if (cpu >= nr_cpu_ids) {
 				cpu = -1;
 				continue;
@@ -169,83 +226,175 @@ static int next_coreid_for_irq(struct irq_desc *desc)
 				break;
 			}
 		}
-		coreid = octeon_coreid_for_cpu(cpu);
 	} else if (weight == 1) {
-		coreid = octeon_coreid_for_cpu(cpumask_first(desc->affinity));
+		cpu = cpumask_first(data->affinity);
 	} else {
-		coreid = cvmx_get_core_num();
+		cpu = smp_processor_id();
 	}
-	return coreid;
+	return cpu;
 #else
-	return cvmx_get_core_num();
+	return smp_processor_id();
 #endif
 }
 
-static void octeon_irq_ciu0_enable(unsigned int irq)
+static void octeon_irq_ciu_enable(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	int coreid = next_coreid_for_irq(desc);
+	int cpu = next_cpu_for_irq(data);
+	int coreid = octeon_coreid_for_cpu(cpu);
+	unsigned long *pen;
 	unsigned long flags;
-	uint64_t en0;
-	int bit = irq - OCTEON_IRQ_WORKQ0;	/* Bit 0-63 of EN0 */
+	union octeon_ciu_chip_data cd;
 
-	raw_spin_lock_irqsave(&octeon_irq_ciu0_lock, flags);
-	en0 = cvmx_read_csr(CVMX_CIU_INTX_EN0(coreid * 2));
-	en0 |= 1ull << bit;
-	cvmx_write_csr(CVMX_CIU_INTX_EN0(coreid * 2), en0);
-	cvmx_read_csr(CVMX_CIU_INTX_EN0(coreid * 2));
-	raw_spin_unlock_irqrestore(&octeon_irq_ciu0_lock, flags);
+	cd.p = irq_data_get_irq_chip_data(data);
+
+	if (cd.s.line == 0) {
+		raw_spin_lock_irqsave(&octeon_irq_ciu0_lock, flags);
+		pen = &per_cpu(octeon_irq_ciu0_en_mirror, cpu);
+		set_bit(cd.s.bit, pen);
+		cvmx_write_csr(CVMX_CIU_INTX_EN0(coreid * 2), *pen);
+		raw_spin_unlock_irqrestore(&octeon_irq_ciu0_lock, flags);
+	} else {
+		raw_spin_lock_irqsave(&octeon_irq_ciu1_lock, flags);
+		pen = &per_cpu(octeon_irq_ciu1_en_mirror, cpu);
+		set_bit(cd.s.bit, pen);
+		cvmx_write_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1), *pen);
+		raw_spin_unlock_irqrestore(&octeon_irq_ciu1_lock, flags);
+	}
 }
 
-static void octeon_irq_ciu0_enable_mbox(unsigned int irq)
+static void octeon_irq_ciu_enable_local(struct irq_data *data)
 {
-	int coreid = cvmx_get_core_num();
+	unsigned long *pen;
 	unsigned long flags;
-	uint64_t en0;
-	int bit = irq - OCTEON_IRQ_WORKQ0;	/* Bit 0-63 of EN0 */
+	union octeon_ciu_chip_data cd;
+
+	cd.p = irq_data_get_irq_chip_data(data);
 
-	raw_spin_lock_irqsave(&octeon_irq_ciu0_lock, flags);
-	en0 = cvmx_read_csr(CVMX_CIU_INTX_EN0(coreid * 2));
-	en0 |= 1ull << bit;
-	cvmx_write_csr(CVMX_CIU_INTX_EN0(coreid * 2), en0);
-	cvmx_read_csr(CVMX_CIU_INTX_EN0(coreid * 2));
-	raw_spin_unlock_irqrestore(&octeon_irq_ciu0_lock, flags);
+	if (cd.s.line == 0) {
+		raw_spin_lock_irqsave(&octeon_irq_ciu0_lock, flags);
+		pen = &__get_cpu_var(octeon_irq_ciu0_en_mirror);
+		set_bit(cd.s.bit, pen);
+		cvmx_write_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2), *pen);
+		raw_spin_unlock_irqrestore(&octeon_irq_ciu0_lock, flags);
+	} else {
+		raw_spin_lock_irqsave(&octeon_irq_ciu1_lock, flags);
+		pen = &__get_cpu_var(octeon_irq_ciu1_en_mirror);
+		set_bit(cd.s.bit, pen);
+		cvmx_write_csr(CVMX_CIU_INTX_EN1(cvmx_get_core_num() * 2 + 1), *pen);
+		raw_spin_unlock_irqrestore(&octeon_irq_ciu1_lock, flags);
+	}
 }
 
-static void octeon_irq_ciu0_disable(unsigned int irq)
+static void octeon_irq_ciu_disable_local(struct irq_data *data)
 {
-	int bit = irq - OCTEON_IRQ_WORKQ0;	/* Bit 0-63 of EN0 */
+	unsigned long *pen;
 	unsigned long flags;
-	uint64_t en0;
+	union octeon_ciu_chip_data cd;
+
+	cd.p = irq_data_get_irq_chip_data(data);
+
+	if (cd.s.line == 0) {
+		raw_spin_lock_irqsave(&octeon_irq_ciu0_lock, flags);
+		pen = &__get_cpu_var(octeon_irq_ciu0_en_mirror);
+		clear_bit(cd.s.bit, pen);
+		cvmx_write_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2), *pen);
+		raw_spin_unlock_irqrestore(&octeon_irq_ciu0_lock, flags);
+	} else {
+		raw_spin_lock_irqsave(&octeon_irq_ciu1_lock, flags);
+		pen = &__get_cpu_var(octeon_irq_ciu1_en_mirror);
+		clear_bit(cd.s.bit, pen);
+		cvmx_write_csr(CVMX_CIU_INTX_EN1(cvmx_get_core_num() * 2 + 1), *pen);
+		raw_spin_unlock_irqrestore(&octeon_irq_ciu1_lock, flags);
+	}
+}
+
+static void octeon_irq_ciu_disable_all(struct irq_data *data)
+{
+	unsigned long flags;
+	unsigned long *pen;
 	int cpu;
-	raw_spin_lock_irqsave(&octeon_irq_ciu0_lock, flags);
-	for_each_online_cpu(cpu) {
-		int coreid = octeon_coreid_for_cpu(cpu);
-		en0 = cvmx_read_csr(CVMX_CIU_INTX_EN0(coreid * 2));
-		en0 &= ~(1ull << bit);
-		cvmx_write_csr(CVMX_CIU_INTX_EN0(coreid * 2), en0);
+	union octeon_ciu_chip_data cd;
+
+	wmb(); /* Make sure flag changes arrive before register updates. */
+
+	cd.p = irq_data_get_irq_chip_data(data);
+
+	if (cd.s.line == 0) {
+		raw_spin_lock_irqsave(&octeon_irq_ciu0_lock, flags);
+		for_each_online_cpu(cpu) {
+			int coreid = octeon_coreid_for_cpu(cpu);
+			pen = &per_cpu(octeon_irq_ciu0_en_mirror, cpu);
+			clear_bit(cd.s.bit, pen);
+			cvmx_write_csr(CVMX_CIU_INTX_EN0(coreid * 2), *pen);
+		}
+		raw_spin_unlock_irqrestore(&octeon_irq_ciu0_lock, flags);
+	} else {
+		raw_spin_lock_irqsave(&octeon_irq_ciu1_lock, flags);
+		for_each_online_cpu(cpu) {
+			int coreid = octeon_coreid_for_cpu(cpu);
+			pen = &per_cpu(octeon_irq_ciu1_en_mirror, cpu);
+			clear_bit(cd.s.bit, pen);
+			cvmx_write_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1), *pen);
+		}
+		raw_spin_unlock_irqrestore(&octeon_irq_ciu1_lock, flags);
+	}
+}
+
+static void octeon_irq_ciu_enable_all(struct irq_data *data)
+{
+	unsigned long flags;
+	unsigned long *pen;
+	int cpu;
+	union octeon_ciu_chip_data cd;
+
+	cd.p = irq_data_get_irq_chip_data(data);
+
+	if (cd.s.line == 0) {
+		raw_spin_lock_irqsave(&octeon_irq_ciu0_lock, flags);
+		for_each_online_cpu(cpu) {
+			int coreid = octeon_coreid_for_cpu(cpu);
+			pen = &per_cpu(octeon_irq_ciu0_en_mirror, cpu);
+			set_bit(cd.s.bit, pen);
+			cvmx_write_csr(CVMX_CIU_INTX_EN0(coreid * 2), *pen);
+		}
+		raw_spin_unlock_irqrestore(&octeon_irq_ciu0_lock, flags);
+	} else {
+		raw_spin_lock_irqsave(&octeon_irq_ciu1_lock, flags);
+		for_each_online_cpu(cpu) {
+			int coreid = octeon_coreid_for_cpu(cpu);
+			pen = &per_cpu(octeon_irq_ciu1_en_mirror, cpu);
+			set_bit(cd.s.bit, pen);
+			cvmx_write_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1), *pen);
+		}
+		raw_spin_unlock_irqrestore(&octeon_irq_ciu1_lock, flags);
 	}
-	/*
-	 * We need to do a read after the last update to make sure all
-	 * of them are done.
-	 */
-	cvmx_read_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2));
-	raw_spin_unlock_irqrestore(&octeon_irq_ciu0_lock, flags);
 }
 
 /*
  * Enable the irq on the next core in the affinity set for chips that
  * have the EN*_W1{S,C} registers.
  */
-static void octeon_irq_ciu0_enable_v2(unsigned int irq)
+static void octeon_irq_ciu_enable_v2(struct irq_data *data)
 {
-	int index;
-	u64 mask = 1ull << (irq - OCTEON_IRQ_WORKQ0);
-	struct irq_desc *desc = irq_to_desc(irq);
+	u64 mask;
+	int cpu = next_cpu_for_irq(data);
+	union octeon_ciu_chip_data cd;
+
+	cd.p = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd.s.bit);
 
-	if ((desc->status & IRQ_DISABLED) == 0) {
-		index = next_coreid_for_irq(desc) * 2;
+	/*
+	 * Called under the desc lock, so these should never get out
+	 * of sync.
+	 */
+	if (cd.s.line == 0) {
+		int index = octeon_coreid_for_cpu(cpu) * 2;
+		set_bit(cd.s.bit, &per_cpu(octeon_irq_ciu0_en_mirror, cpu));
 		cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
+	} else {
+		int index = octeon_coreid_for_cpu(cpu) * 2 + 1;
+		set_bit(cd.s.bit, &per_cpu(octeon_irq_ciu1_en_mirror, cpu));
+		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
 	}
 }
 
@@ -253,83 +402,156 @@ static void octeon_irq_ciu0_enable_v2(unsigned int irq)
  * Enable the irq on the current CPU for chips that
  * have the EN*_W1{S,C} registers.
  */
-static void octeon_irq_ciu0_enable_mbox_v2(unsigned int irq)
+static void octeon_irq_ciu_enable_local_v2(struct irq_data *data)
+{
+	u64 mask;
+	union octeon_ciu_chip_data cd;
+
+	cd.p = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd.s.bit);
+
+	if (cd.s.line == 0) {
+		int index = cvmx_get_core_num() * 2;
+		set_bit(cd.s.bit, &__get_cpu_var(octeon_irq_ciu0_en_mirror));
+		cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
+	} else {
+		int index = cvmx_get_core_num() * 2 + 1;
+		set_bit(cd.s.bit, &__get_cpu_var(octeon_irq_ciu1_en_mirror));
+		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
+	}
+}
+
+static void octeon_irq_ciu_disable_local_v2(struct irq_data *data)
 {
-	int index;
-	u64 mask = 1ull << (irq - OCTEON_IRQ_WORKQ0);
+	u64 mask;
+	union octeon_ciu_chip_data cd;
 
-	index = cvmx_get_core_num() * 2;
-	cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
+	cd.p = irq_data_get_irq_chip_data(data);
+	mask = 1ull << (cd.s.bit);
+
+	if (cd.s.line == 0) {
+		int index = cvmx_get_core_num() * 2;
+		clear_bit(cd.s.bit, &__get_cpu_var(octeon_irq_ciu0_en_mirror));
+		cvmx_write_csr(CVMX_CIU_INTX_EN0_W1C(index), mask);
+	} else {
+		int index = cvmx_get_core_num() * 2 + 1;
+		clear_bit(cd.s.bit, &__get_cpu_var(octeon_irq_ciu1_en_mirror));
+		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1C(index), mask);
+	}
 }
 
 /*
- * Disable the irq on the current core for chips that have the EN*_W1{S,C}
- * registers.
+ * Write to the W1C bit in CVMX_CIU_INTX_SUM0 to clear the irq.
  */
-static void octeon_irq_ciu0_ack_v2(unsigned int irq)
-{
-	int index = cvmx_get_core_num() * 2;
-	u64 mask = 1ull << (irq - OCTEON_IRQ_WORKQ0);
-
-	switch (irq) {
-	case OCTEON_IRQ_GMX_DRP0:
-	case OCTEON_IRQ_GMX_DRP1:
-	case OCTEON_IRQ_IPD_DRP:
-	case OCTEON_IRQ_KEY_ZERO:
-	case OCTEON_IRQ_TIMER0:
-	case OCTEON_IRQ_TIMER1:
-	case OCTEON_IRQ_TIMER2:
-	case OCTEON_IRQ_TIMER3:
-		/*
-		 * CIU timer type interrupts must be acknoleged by
-		 * writing a '1' bit to their sum0 bit.
-		 */
+static void octeon_irq_ciu_ack(struct irq_data *data)
+{
+	u64 mask;
+	union octeon_ciu_chip_data cd;
+
+	cd.p = data->chip_data;
+	mask = 1ull << (cd.s.bit);
+
+	if (cd.s.line == 0) {
+		int index = cvmx_get_core_num() * 2;
 		cvmx_write_csr(CVMX_CIU_INTX_SUM0(index), mask);
-		break;
-	default:
-		break;
+	} else {
+		cvmx_write_csr(CVMX_CIU_INT_SUM1, mask);
 	}
-
-	cvmx_write_csr(CVMX_CIU_INTX_EN0_W1C(index), mask);
 }
 
 /*
- * Enable the irq on the current core for chips that have the EN*_W1{S,C}
+ * Disable the irq on the all cores for chips that have the EN*_W1{S,C}
  * registers.
  */
-static void octeon_irq_ciu0_eoi_mbox_v2(unsigned int irq)
+static void octeon_irq_ciu_disable_all_v2(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	int index = cvmx_get_core_num() * 2;
-	u64 mask = 1ull << (irq - OCTEON_IRQ_WORKQ0);
+	int cpu;
+	u64 mask;
+	union octeon_ciu_chip_data cd;
 
-	if (likely((desc->status & IRQ_DISABLED) == 0))
-		cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
+	wmb(); /* Make sure flag changes arrive before register updates. */
+
+	cd.p = data->chip_data;
+	mask = 1ull << (cd.s.bit);
+
+	if (cd.s.line == 0) {
+		for_each_online_cpu(cpu) {
+			int index = octeon_coreid_for_cpu(cpu) * 2;
+			clear_bit(cd.s.bit, &per_cpu(octeon_irq_ciu0_en_mirror, cpu));
+			cvmx_write_csr(CVMX_CIU_INTX_EN0_W1C(index), mask);
+		}
+	} else {
+		for_each_online_cpu(cpu) {
+			int index = octeon_coreid_for_cpu(cpu) * 2 + 1;
+			clear_bit(cd.s.bit, &per_cpu(octeon_irq_ciu1_en_mirror, cpu));
+			cvmx_write_csr(CVMX_CIU_INTX_EN1_W1C(index), mask);
+		}
+	}
 }
 
 /*
- * Disable the irq on the all cores for chips that have the EN*_W1{S,C}
+ * Enable the irq on the all cores for chips that have the EN*_W1{S,C}
  * registers.
  */
-static void octeon_irq_ciu0_disable_all_v2(unsigned int irq)
+static void octeon_irq_ciu_enable_all_v2(struct irq_data *data)
 {
-	u64 mask = 1ull << (irq - OCTEON_IRQ_WORKQ0);
-	int index;
 	int cpu;
-	for_each_online_cpu(cpu) {
-		index = octeon_coreid_for_cpu(cpu) * 2;
-		cvmx_write_csr(CVMX_CIU_INTX_EN0_W1C(index), mask);
+	u64 mask;
+	union octeon_ciu_chip_data cd;
+
+	cd.p = data->chip_data;
+	mask = 1ull << (cd.s.bit);
+
+	if (cd.s.line == 0) {
+		for_each_online_cpu(cpu) {
+			int index = octeon_coreid_for_cpu(cpu) * 2;
+			set_bit(cd.s.bit, &per_cpu(octeon_irq_ciu0_en_mirror, cpu));
+			cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
+		}
+	} else {
+		for_each_online_cpu(cpu) {
+			int index = octeon_coreid_for_cpu(cpu) * 2 + 1;
+			set_bit(cd.s.bit, &per_cpu(octeon_irq_ciu1_en_mirror, cpu));
+			cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
+		}
 	}
 }
 
+static void octeon_irq_cpu_online_mbox(struct irq_data *data, bool e)
+{
+	if (e)
+		octeon_irq_ciu_enable_local(data);
+}
+
+static void octeon_irq_cpu_online_mbox_v2(struct irq_data *data, bool e)
+{
+	if (e)
+		octeon_irq_ciu_enable_local_v2(data);
+}
+
+static void octeon_irq_cpu_offline_mbox(struct irq_data *data, bool e)
+{
+	if (e)
+		octeon_irq_ciu_disable_local(data);
+}
+
+static void octeon_irq_cpu_offline_mbox_v2(struct irq_data *data, bool e)
+{
+	if (e)
+		octeon_irq_ciu_disable_local_v2(data);
+}
+
 #ifdef CONFIG_SMP
-static int octeon_irq_ciu0_set_affinity(unsigned int irq, const struct cpumask *dest)
+static int octeon_irq_ciu_set_affinity(struct irq_data *data,
+				       const struct cpumask *dest, bool force)
 {
 	int cpu;
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_to_desc(data->irq);
 	int enable_one = (desc->status & IRQ_DISABLED) == 0;
 	unsigned long flags;
-	int bit = irq - OCTEON_IRQ_WORKQ0;	/* Bit 0-63 of EN0 */
+	union octeon_ciu_chip_data cd;
+
+	cd.p = data->chip_data;
 
 	/*
 	 * For non-v2 CIU, we will allow only single CPU affinity.
@@ -339,26 +561,40 @@ static int octeon_irq_ciu0_set_affinity(unsigned int irq, const struct cpumask *
 	if (cpumask_weight(dest) != 1)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&octeon_irq_ciu0_lock, flags);
-	for_each_online_cpu(cpu) {
-		int coreid = octeon_coreid_for_cpu(cpu);
-		uint64_t en0 =
-			cvmx_read_csr(CVMX_CIU_INTX_EN0(coreid * 2));
-		if (cpumask_test_cpu(cpu, dest) && enable_one) {
-			enable_one = 0;
-			en0 |= 1ull << bit;
-		} else {
-			en0 &= ~(1ull << bit);
+	if (desc->status & IRQ_DISABLED)
+		return 0;
+
+	if (cd.s.line == 0) {
+		raw_spin_lock_irqsave(&octeon_irq_ciu0_lock, flags);
+		for_each_online_cpu(cpu) {
+			int coreid = octeon_coreid_for_cpu(cpu);
+			unsigned long *pen = &per_cpu(octeon_irq_ciu0_en_mirror, cpu);
+
+			if (cpumask_test_cpu(cpu, dest) && enable_one) {
+				enable_one = 0;
+				set_bit(cd.s.bit, pen);
+			} else {
+				clear_bit(cd.s.bit, pen);
+			}
+			cvmx_write_csr(CVMX_CIU_INTX_EN0(coreid * 2), *pen);
 		}
-		cvmx_write_csr(CVMX_CIU_INTX_EN0(coreid * 2), en0);
+		raw_spin_unlock_irqrestore(&octeon_irq_ciu0_lock, flags);
+	} else {
+		raw_spin_lock_irqsave(&octeon_irq_ciu1_lock, flags);
+		for_each_online_cpu(cpu) {
+			int coreid = octeon_coreid_for_cpu(cpu);
+			unsigned long *pen = &per_cpu(octeon_irq_ciu1_en_mirror, cpu);
+
+			if (cpumask_test_cpu(cpu, dest) && enable_one) {
+				enable_one = 0;
+				set_bit(cd.s.bit, pen);
+			} else {
+				clear_bit(cd.s.bit, pen);
+			}
+			cvmx_write_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1), *pen);
+		}
+		raw_spin_unlock_irqrestore(&octeon_irq_ciu1_lock, flags);
 	}
-	/*
-	 * We need to do a read after the last update to make sure all
-	 * of them are done.
-	 */
-	cvmx_read_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2));
-	raw_spin_unlock_irqrestore(&octeon_irq_ciu0_lock, flags);
-
 	return 0;
 }
 
@@ -366,22 +602,47 @@ static int octeon_irq_ciu0_set_affinity(unsigned int irq, const struct cpumask *
  * Set affinity for the irq for chips that have the EN*_W1{S,C}
  * registers.
  */
-static int octeon_irq_ciu0_set_affinity_v2(unsigned int irq,
-					   const struct cpumask *dest)
+static int octeon_irq_ciu_set_affinity_v2(struct irq_data *data,
+					  const struct cpumask *dest,
+					  bool force)
 {
 	int cpu;
-	int index;
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_to_desc(data->irq);
 	int enable_one = (desc->status & IRQ_DISABLED) == 0;
-	u64 mask = 1ull << (irq - OCTEON_IRQ_WORKQ0);
-
-	for_each_online_cpu(cpu) {
-		index = octeon_coreid_for_cpu(cpu) * 2;
-		if (cpumask_test_cpu(cpu, dest) && enable_one) {
-			enable_one = 0;
-			cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
-		} else {
-			cvmx_write_csr(CVMX_CIU_INTX_EN0_W1C(index), mask);
+	u64 mask;
+	union octeon_ciu_chip_data cd;
+
+	if (desc->status & IRQ_DISABLED)
+		return 0;
+
+	cd.p = data->chip_data;
+	mask = 1ull << cd.s.bit;
+
+	if (cd.s.line == 0) {
+		for_each_online_cpu(cpu) {
+			unsigned long *pen = &per_cpu(octeon_irq_ciu0_en_mirror, cpu);
+			int index = octeon_coreid_for_cpu(cpu) * 2;
+			if (cpumask_test_cpu(cpu, dest) && enable_one) {
+				enable_one = 0;
+				set_bit(cd.s.bit, pen);
+				cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
+			} else {
+				clear_bit(cd.s.bit, pen);
+				cvmx_write_csr(CVMX_CIU_INTX_EN0_W1C(index), mask);
+			}
+		}
+	} else {
+		for_each_online_cpu(cpu) {
+			unsigned long *pen = &per_cpu(octeon_irq_ciu1_en_mirror, cpu);
+			int index = octeon_coreid_for_cpu(cpu) * 2 + 1;
+			if (cpumask_test_cpu(cpu, dest) && enable_one) {
+				enable_one = 0;
+				set_bit(cd.s.bit, pen);
+				cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
+			} else {
+				clear_bit(cd.s.bit, pen);
+				cvmx_write_csr(CVMX_CIU_INTX_EN1_W1C(index), mask);
+			}
 		}
 	}
 	return 0;
@@ -389,80 +650,97 @@ static int octeon_irq_ciu0_set_affinity_v2(unsigned int irq,
 #endif
 
 /*
+ * The v1 CIU code already masks things, so supply a dummy version to
+ * the core chip code.
+ */
+static void octeon_irq_dummy_mask(struct irq_data *data)
+{
+	return;
+}
+
+/*
  * Newer octeon chips have support for lockless CIU operation.
  */
-static struct irq_chip octeon_irq_chip_ciu0_v2 = {
-	.name = "CIU0",
-	.enable = octeon_irq_ciu0_enable_v2,
-	.disable = octeon_irq_ciu0_disable_all_v2,
-	.eoi = octeon_irq_ciu0_enable_v2,
+static struct irq_chip octeon_irq_chip_ciu_v2 = {
+	.name = "CIU",
+	.irq_enable = octeon_irq_ciu_enable_v2,
+	.irq_disable = octeon_irq_ciu_disable_all_v2,
+	.irq_mask = octeon_irq_ciu_disable_local_v2,
+	.irq_unmask = octeon_irq_ciu_enable_v2,
 #ifdef CONFIG_SMP
-	.set_affinity = octeon_irq_ciu0_set_affinity_v2,
+	.irq_set_affinity = octeon_irq_ciu_set_affinity_v2,
 #endif
 };
 
-static struct irq_chip octeon_irq_chip_ciu0 = {
-	.name = "CIU0",
-	.enable = octeon_irq_ciu0_enable,
-	.disable = octeon_irq_ciu0_disable,
-	.eoi = octeon_irq_ciu0_eoi,
+static struct irq_chip octeon_irq_chip_ciu_edge_v2 = {
+	.name = "CIU-E",
+	.irq_enable = octeon_irq_ciu_enable_v2,
+	.irq_disable = octeon_irq_ciu_disable_all_v2,
+	.irq_ack = octeon_irq_ciu_ack,
+	.irq_mask = octeon_irq_ciu_disable_local_v2,
+	.irq_unmask = octeon_irq_ciu_enable_v2,
 #ifdef CONFIG_SMP
-	.set_affinity = octeon_irq_ciu0_set_affinity,
+	.irq_set_affinity = octeon_irq_ciu_set_affinity_v2,
 #endif
 };
 
-/* The mbox versions don't do any affinity or round-robin. */
-static struct irq_chip octeon_irq_chip_ciu0_mbox_v2 = {
-	.name = "CIU0-M",
-	.enable = octeon_irq_ciu0_enable_mbox_v2,
-	.disable = octeon_irq_ciu0_disable,
-	.eoi = octeon_irq_ciu0_eoi_mbox_v2,
+static struct irq_chip octeon_irq_chip_ciu = {
+	.name = "CIU",
+	.irq_enable = octeon_irq_ciu_enable,
+	.irq_disable = octeon_irq_ciu_disable_all,
+	.irq_mask = octeon_irq_dummy_mask,
+#ifdef CONFIG_SMP
+	.irq_set_affinity = octeon_irq_ciu_set_affinity,
+#endif
 };
 
-static struct irq_chip octeon_irq_chip_ciu0_mbox = {
-	.name = "CIU0-M",
-	.enable = octeon_irq_ciu0_enable_mbox,
-	.disable = octeon_irq_ciu0_disable,
-	.eoi = octeon_irq_ciu0_eoi,
+static struct irq_chip octeon_irq_chip_ciu_edge = {
+	.name = "CIU-E",
+	.irq_enable = octeon_irq_ciu_enable,
+	.irq_disable = octeon_irq_ciu_disable_all,
+	.irq_mask = octeon_irq_dummy_mask,
+	.irq_ack = octeon_irq_ciu_ack,
+#ifdef CONFIG_SMP
+	.irq_set_affinity = octeon_irq_ciu_set_affinity,
+#endif
 };
 
-static void octeon_irq_ciu1_ack(unsigned int irq)
-{
-	/*
-	 * In order to avoid any locking accessing the CIU, we
-	 * acknowledge CIU interrupts by disabling all of them.  This
-	 * way we can use a per core register and avoid any out of
-	 * core locking requirements.  This has the side affect that
-	 * CIU interrupts can't be processed recursively.  We don't
-	 * need to disable IRQs to make these atomic since they are
-	 * already disabled earlier in the low level interrupt code.
-	 */
-	clear_c0_status(0x100 << 3);
-}
+/* The mbox versions don't do any affinity or round-robin. */
+static struct irq_chip octeon_irq_chip_ciu_mbox_v2 = {
+	.name = "CIU-M",
+	.irq_enable = octeon_irq_ciu_enable_all_v2,
+	.irq_disable = octeon_irq_ciu_disable_all_v2,
+	.irq_ack = octeon_irq_ciu_disable_local_v2,
+	.irq_eoi = octeon_irq_ciu_enable_local_v2,
+
+	.irq_cpu_online = octeon_irq_cpu_online_mbox_v2,
+	.irq_cpu_offline = octeon_irq_cpu_offline_mbox_v2,
+};
 
-static void octeon_irq_ciu1_eoi(unsigned int irq)
-{
-	/*
-	 * Enable all CIU interrupts again.  We don't need to disable
-	 * IRQs to make these atomic since they are already disabled
-	 * earlier in the low level interrupt code.
-	 */
-	set_c0_status(0x100 << 3);
-}
+static struct irq_chip octeon_irq_chip_ciu_mbox = {
+	.name = "CIU-M",
+	.irq_enable = octeon_irq_ciu_enable_all,
+	.irq_disable = octeon_irq_ciu_disable_all,
+
+	.irq_cpu_online = octeon_irq_cpu_online_mbox,
+	.irq_cpu_offline = octeon_irq_cpu_offline_mbox,
+};
 
-static void octeon_irq_ciu1_enable(unsigned int irq)
+/*
+ * Watchdog interrupts are special.  They are associated with a single
+ * core, so we hardwire the affinity to that core.
+ */
+static void octeon_irq_ciu_wd_enable(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	int coreid = next_coreid_for_irq(desc);
 	unsigned long flags;
-	uint64_t en1;
-	int bit = irq - OCTEON_IRQ_WDOG0;	/* Bit 0-63 of EN1 */
+	unsigned long *pen;
+	int coreid = data->irq - OCTEON_IRQ_WDOG0;	/* Bit 0-63 of EN1 */
+	int cpu = octeon_cpu_for_coreid(coreid);
 
 	raw_spin_lock_irqsave(&octeon_irq_ciu1_lock, flags);
-	en1 = cvmx_read_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1));
-	en1 |= 1ull << bit;
-	cvmx_write_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1), en1);
-	cvmx_read_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1));
+	pen = &per_cpu(octeon_irq_ciu1_en_mirror, cpu);
+	set_bit(coreid, pen);
+	cvmx_write_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1), *pen);
 	raw_spin_unlock_irqrestore(&octeon_irq_ciu1_lock, flags);
 }
 
@@ -470,286 +748,285 @@ static void octeon_irq_ciu1_enable(unsigned int irq)
  * Watchdog interrupts are special.  They are associated with a single
  * core, so we hardwire the affinity to that core.
  */
-static void octeon_irq_ciu1_wd_enable(unsigned int irq)
+static void octeon_irq_ciu1_wd_enable_v2(struct irq_data *data)
 {
-	unsigned long flags;
-	uint64_t en1;
-	int bit = irq - OCTEON_IRQ_WDOG0;	/* Bit 0-63 of EN1 */
-	int coreid = bit;
+	int coreid = data->irq - OCTEON_IRQ_WDOG0;
+	int cpu = octeon_cpu_for_coreid(coreid);
 
-	raw_spin_lock_irqsave(&octeon_irq_ciu1_lock, flags);
-	en1 = cvmx_read_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1));
-	en1 |= 1ull << bit;
-	cvmx_write_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1), en1);
-	cvmx_read_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1));
-	raw_spin_unlock_irqrestore(&octeon_irq_ciu1_lock, flags);
+	set_bit(coreid, &per_cpu(octeon_irq_ciu1_en_mirror, cpu));
+	cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(coreid * 2 + 1), 1ull << coreid);
 }
 
-static void octeon_irq_ciu1_disable(unsigned int irq)
+
+static struct irq_chip octeon_irq_chip_ciu_wd_v2 = {
+	.name = "CIU-W",
+	.irq_enable = octeon_irq_ciu1_wd_enable_v2,
+	.irq_disable = octeon_irq_ciu_disable_all_v2,
+	.irq_mask = octeon_irq_ciu_disable_local_v2,
+	.irq_unmask = octeon_irq_ciu_enable_local_v2,
+};
+
+static struct irq_chip octeon_irq_chip_ciu_wd = {
+	.name = "CIU-W",
+	.irq_enable = octeon_irq_ciu_wd_enable,
+	.irq_disable = octeon_irq_ciu_disable_all,
+	.irq_mask = octeon_irq_dummy_mask,
+};
+
+static void octeon_irq_ip2_v1(void)
 {
-	int bit = irq - OCTEON_IRQ_WDOG0;	/* Bit 0-63 of EN1 */
-	unsigned long flags;
-	uint64_t en1;
-	int cpu;
-	raw_spin_lock_irqsave(&octeon_irq_ciu1_lock, flags);
-	for_each_online_cpu(cpu) {
-		int coreid = octeon_coreid_for_cpu(cpu);
-		en1 = cvmx_read_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1));
-		en1 &= ~(1ull << bit);
-		cvmx_write_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1), en1);
+	const unsigned long core_id = cvmx_get_core_num();
+	u64 ciu_sum = cvmx_read_csr(CVMX_CIU_INTX_SUM0(core_id * 2));
+
+	ciu_sum &= __get_cpu_var(octeon_irq_ciu0_en_mirror);
+	clear_c0_status(STATUSF_IP2);
+	if (likely(ciu_sum)) {
+		int bit = fls64(ciu_sum) - 1;
+		int irq = octeon_irq_ciu_to_irq[0][bit];
+		if (likely(irq))
+			do_IRQ(irq);
+		else
+			spurious_interrupt();
+	} else {
+		spurious_interrupt();
 	}
-	/*
-	 * We need to do a read after the last update to make sure all
-	 * of them are done.
-	 */
-	cvmx_read_csr(CVMX_CIU_INTX_EN1(cvmx_get_core_num() * 2 + 1));
-	raw_spin_unlock_irqrestore(&octeon_irq_ciu1_lock, flags);
+	set_c0_status(STATUSF_IP2);
 }
 
-/*
- * Enable the irq on the current core for chips that have the EN*_W1{S,C}
- * registers.
- */
-static void octeon_irq_ciu1_enable_v2(unsigned int irq)
+static void octeon_irq_ip2_v2(void)
 {
-	int index;
-	u64 mask = 1ull << (irq - OCTEON_IRQ_WDOG0);
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	if ((desc->status & IRQ_DISABLED) == 0) {
-		index = next_coreid_for_irq(desc) * 2 + 1;
-		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
+	const unsigned long core_id = cvmx_get_core_num();
+	u64 ciu_sum = cvmx_read_csr(CVMX_CIU_INTX_SUM0(core_id * 2));
+
+	ciu_sum &= __get_cpu_var(octeon_irq_ciu0_en_mirror);
+	if (likely(ciu_sum)) {
+		int bit = fls64(ciu_sum) - 1;
+		int irq = octeon_irq_ciu_to_irq[0][bit];
+		if (likely(irq))
+			do_IRQ(irq);
+		else
+			spurious_interrupt();
+	} else {
+		spurious_interrupt();
 	}
 }
-
-/*
- * Watchdog interrupts are special.  They are associated with a single
- * core, so we hardwire the affinity to that core.
- */
-static void octeon_irq_ciu1_wd_enable_v2(unsigned int irq)
+static void octeon_irq_ip3_v1(void)
 {
-	int index;
-	int coreid = irq - OCTEON_IRQ_WDOG0;
-	u64 mask = 1ull << (irq - OCTEON_IRQ_WDOG0);
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	if ((desc->status & IRQ_DISABLED) == 0) {
-		index = coreid * 2 + 1;
-		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
+	u64 ciu_sum = cvmx_read_csr(CVMX_CIU_INT_SUM1);
+
+	ciu_sum &= __get_cpu_var(octeon_irq_ciu1_en_mirror);
+	clear_c0_status(STATUSF_IP3);
+	if (likely(ciu_sum)) {
+		int bit = fls64(ciu_sum) - 1;
+		int irq = octeon_irq_ciu_to_irq[1][bit];
+		if (likely(irq))
+			do_IRQ(irq);
+		else
+			spurious_interrupt();
+	} else {
+		spurious_interrupt();
 	}
+	set_c0_status(STATUSF_IP3);
 }
 
-/*
- * Disable the irq on the current core for chips that have the EN*_W1{S,C}
- * registers.
- */
-static void octeon_irq_ciu1_ack_v2(unsigned int irq)
+static void octeon_irq_ip3_v2(void)
 {
-	int index = cvmx_get_core_num() * 2 + 1;
-	u64 mask = 1ull << (irq - OCTEON_IRQ_WDOG0);
-
-	cvmx_write_csr(CVMX_CIU_INTX_EN1_W1C(index), mask);
+	u64 ciu_sum = cvmx_read_csr(CVMX_CIU_INT_SUM1);
+
+	ciu_sum &= __get_cpu_var(octeon_irq_ciu1_en_mirror);
+	if (likely(ciu_sum)) {
+		int bit = fls64(ciu_sum) - 1;
+		int irq = octeon_irq_ciu_to_irq[1][bit];
+		if (likely(irq))
+			do_IRQ(irq);
+		else
+			spurious_interrupt();
+	} else {
+		spurious_interrupt();
+	}
 }
 
-/*
- * Disable the irq on the all cores for chips that have the EN*_W1{S,C}
- * registers.
- */
-static void octeon_irq_ciu1_disable_all_v2(unsigned int irq)
+static void octeon_irq_ip4_mask(void)
 {
-	u64 mask = 1ull << (irq - OCTEON_IRQ_WDOG0);
-	int index;
-	int cpu;
-	for_each_online_cpu(cpu) {
-		index = octeon_coreid_for_cpu(cpu) * 2 + 1;
-		cvmx_write_csr(CVMX_CIU_INTX_EN1_W1C(index), mask);
-	}
+	clear_c0_status(STATUSF_IP4);
+	spurious_interrupt();
 }
 
-#ifdef CONFIG_SMP
-static int octeon_irq_ciu1_set_affinity(unsigned int irq,
-					const struct cpumask *dest)
+static void (*octeon_irq_ip2)(void);
+static void (*octeon_irq_ip3)(void);
+static void (*octeon_irq_ip4)(void);
+
+void __cpuinitdata (*octeon_irq_setup_secondary)(void);
+
+static void __cpuinit octeon_irq_percpu_enable(void)
 {
-	int cpu;
-	struct irq_desc *desc = irq_to_desc(irq);
-	int enable_one = (desc->status & IRQ_DISABLED) == 0;
-	unsigned long flags;
-	int bit = irq - OCTEON_IRQ_WDOG0;	/* Bit 0-63 of EN1 */
+	int i;
 
-	/*
-	 * For non-v2 CIU, we will allow only single CPU affinity.
-	 * This removes the need to do locking in the .ack/.eoi
-	 * functions.
-	 */
-	if (cpumask_weight(dest) != 1)
-		return -EINVAL;
+	/* Enable the percpu interrupts on this core */
+	for (i = OCTEON_IRQ_SW0; i < OCTEON_IRQ_LAST; i++)
+		irq_cpu_online(i);
+}
 
-	raw_spin_lock_irqsave(&octeon_irq_ciu1_lock, flags);
-	for_each_online_cpu(cpu) {
-		int coreid = octeon_coreid_for_cpu(cpu);
-		uint64_t en1 =
-			cvmx_read_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1));
-		if (cpumask_test_cpu(cpu, dest) && enable_one) {
-			enable_one = 0;
-			en1 |= 1ull << bit;
-		} else {
-			en1 &= ~(1ull << bit);
-		}
-		cvmx_write_csr(CVMX_CIU_INTX_EN1(coreid * 2 + 1), en1);
-	}
+static void __cpuinit octeon_irq_init_ciu_percpu(void)
+{
+	int coreid = cvmx_get_core_num();
 	/*
-	 * We need to do a read after the last update to make sure all
-	 * of them are done.
+	 * Disable All CIU Interrupts. The ones we need will be
+	 * enabled later.  Read the SUM register so we know the write
+	 * completed.
 	 */
-	cvmx_read_csr(CVMX_CIU_INTX_EN1(cvmx_get_core_num() * 2 + 1));
-	raw_spin_unlock_irqrestore(&octeon_irq_ciu1_lock, flags);
-
-	return 0;
+	cvmx_write_csr(CVMX_CIU_INTX_EN0((coreid * 2)), 0);
+	cvmx_write_csr(CVMX_CIU_INTX_EN0((coreid * 2 + 1)), 0);
+	cvmx_write_csr(CVMX_CIU_INTX_EN1((coreid * 2)), 0);
+	cvmx_write_csr(CVMX_CIU_INTX_EN1((coreid * 2 + 1)), 0);
+	cvmx_read_csr(CVMX_CIU_INTX_SUM0((coreid * 2)));
 }
 
-/*
- * Set affinity for the irq for chips that have the EN*_W1{S,C}
- * registers.
- */
-static int octeon_irq_ciu1_set_affinity_v2(unsigned int irq,
-					   const struct cpumask *dest)
+static void __cpuinit octeon_irq_setup_secondary_ciu(void)
 {
-	int cpu;
-	int index;
-	struct irq_desc *desc = irq_to_desc(irq);
-	int enable_one = (desc->status & IRQ_DISABLED) == 0;
-	u64 mask = 1ull << (irq - OCTEON_IRQ_WDOG0);
-	for_each_online_cpu(cpu) {
-		index = octeon_coreid_for_cpu(cpu) * 2 + 1;
-		if (cpumask_test_cpu(cpu, dest) && enable_one) {
-			enable_one = 0;
-			cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
-		} else {
-			cvmx_write_csr(CVMX_CIU_INTX_EN1_W1C(index), mask);
-		}
-	}
-	return 0;
-}
-#endif
 
-/*
- * Newer octeon chips have support for lockless CIU operation.
- */
-static struct irq_chip octeon_irq_chip_ciu1_v2 = {
-	.name = "CIU1",
-	.enable = octeon_irq_ciu1_enable_v2,
-	.disable = octeon_irq_ciu1_disable_all_v2,
-	.eoi = octeon_irq_ciu1_enable_v2,
-#ifdef CONFIG_SMP
-	.set_affinity = octeon_irq_ciu1_set_affinity_v2,
-#endif
-};
+	__get_cpu_var(octeon_irq_ciu0_en_mirror) = 0;
+	__get_cpu_var(octeon_irq_ciu1_en_mirror) = 0;
 
-static struct irq_chip octeon_irq_chip_ciu1 = {
-	.name = "CIU1",
-	.enable = octeon_irq_ciu1_enable,
-	.disable = octeon_irq_ciu1_disable,
-	.eoi = octeon_irq_ciu1_eoi,
-#ifdef CONFIG_SMP
-	.set_affinity = octeon_irq_ciu1_set_affinity,
-#endif
-};
+	octeon_irq_init_ciu_percpu();
+	octeon_irq_percpu_enable();
 
-static struct irq_chip octeon_irq_chip_ciu1_wd_v2 = {
-	.name = "CIU1-W",
-	.enable = octeon_irq_ciu1_wd_enable_v2,
-	.disable = octeon_irq_ciu1_disable_all_v2,
-	.eoi = octeon_irq_ciu1_wd_enable_v2,
-};
+	/* Enable the CIU lines */
+	set_c0_status(STATUSF_IP3 | STATUSF_IP2);
+	clear_c0_status(STATUSF_IP4);
+}
 
-static struct irq_chip octeon_irq_chip_ciu1_wd = {
-	.name = "CIU1-W",
-	.enable = octeon_irq_ciu1_wd_enable,
-	.disable = octeon_irq_ciu1_disable,
-	.eoi = octeon_irq_ciu1_eoi,
-};
+static void __init octeon_irq_init_ciu(void)
+{
+	unsigned int i;
+	struct irq_chip *chip;
+	struct irq_chip *chip_edge;
+	struct irq_chip *chip_mbox;
+	struct irq_chip *chip_wd;
 
-static void (*octeon_ciu0_ack)(unsigned int);
-static void (*octeon_ciu1_ack)(unsigned int);
+	octeon_irq_init_ciu_percpu();
+	octeon_irq_setup_secondary = octeon_irq_setup_secondary_ciu;
+
+	if (OCTEON_IS_MODEL(OCTEON_CN58XX_PASS2_X) ||
+	    OCTEON_IS_MODEL(OCTEON_CN56XX_PASS2_X) ||
+	    OCTEON_IS_MODEL(OCTEON_CN52XX_PASS2_X) ||
+	    OCTEON_IS_MODEL(OCTEON_CN6XXX)) {
+		octeon_irq_ip2 = octeon_irq_ip2_v2;
+		octeon_irq_ip3 = octeon_irq_ip3_v2;
+		chip = &octeon_irq_chip_ciu_v2;
+		chip_edge = &octeon_irq_chip_ciu_edge_v2;
+		chip_mbox = &octeon_irq_chip_ciu_mbox_v2;
+		chip_wd = &octeon_irq_chip_ciu_wd_v2;
+	} else {
+		octeon_irq_ip2 = octeon_irq_ip2_v1;
+		octeon_irq_ip3 = octeon_irq_ip3_v1;
+		chip = &octeon_irq_chip_ciu;
+		chip_edge = &octeon_irq_chip_ciu_edge;
+		chip_mbox = &octeon_irq_chip_ciu_mbox;
+		chip_wd = &octeon_irq_chip_ciu_wd;
+	}
+	octeon_irq_ip4 = octeon_irq_ip4_mask;
+
+	/* Mips internal */
+	octeon_irq_init_core();
+
+	/* CIU_0 */
+	for (i = 0; i < 16; i++)
+		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_WORKQ0, 0, i + 0, chip, handle_level_irq);
+	for (i = 0; i < 16; i++)
+		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_GPIO0, 0, i + 16, chip, handle_level_irq);
+
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX0, 0, 32, chip_mbox, handle_percpu_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX1, 0, 33, chip_mbox, handle_percpu_irq);
+
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_UART0, 0, 34, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_UART1, 0, 35, chip, handle_level_irq);
+
+	for (i = 0; i < 4; i++)
+		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_PCI_INT0, 0, i + 36, chip, handle_level_irq);
+	for (i = 0; i < 4; i++)
+		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_PCI_MSI0, 0, i + 40, chip, handle_level_irq);
+
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_TWSI, 0, 45, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_RML, 0, 46, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_TRACE0, 0, 47, chip, handle_level_irq);
+
+	for (i = 0; i < 2; i++)
+		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_GMX_DRP0, 0, i + 48, chip_edge, handle_edge_irq);
+
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_IPD_DRP, 0, 50, chip_edge, handle_edge_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_KEY_ZERO, 0, 51, chip_edge, handle_edge_irq);
+
+	for (i = 0; i < 4; i++)
+		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_TIMER0, 0, i + 52, chip_edge, handle_edge_irq);
+
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_USB0, 0, 56, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_PCM, 0, 57, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MPI, 0, 58, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_TWSI2, 0, 59, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_POWIQ, 0, 60, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_IPDPPTHR, 0, 61, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MII0, 0, 62, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_BOOTDMA, 0, 63, chip, handle_level_irq);
+
+	/* CIU_1 */
+	for (i = 0; i < 16; i++)
+		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_WDOG0, 1, i + 0, chip_wd, handle_level_irq);
+
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_UART2, 1, 16, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_USB1, 1, 17, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MII1, 1, 18, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_NAND, 1, 19, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MIO, 1, 20, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_IOB, 1, 21, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_FPA, 1, 22, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_POW, 1, 23, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_L2C, 1, 24, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_IPD, 1, 25, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_PIP, 1, 26, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_PKO, 1, 27, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_ZIP, 1, 28, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_TIM, 1, 29, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_RAD, 1, 30, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_KEY, 1, 31, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_DFA, 1, 32, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_USBCTL, 1, 33, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_SLI, 1, 34, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_DPI, 1, 35, chip, handle_level_irq);
+
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_AGX0, 1, 36, chip, handle_level_irq);
+
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_AGL, 1, 46, chip, handle_level_irq);
+
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_PTP, 1, 47, chip_edge, handle_edge_irq);
+
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_PEM0, 1, 48, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_PEM1, 1, 49, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_SRIO0, 1, 50, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_SRIO1, 1, 51, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_LMC0, 1, 52, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_DFM, 1, 56, chip, handle_level_irq);
+	octeon_irq_set_ciu_mapping(OCTEON_IRQ_RST, 1, 63, chip, handle_level_irq);
+
+	/* Enable the CIU lines */
+	set_c0_status(STATUSF_IP3 | STATUSF_IP2);
+	clear_c0_status(STATUSF_IP4);
+}
 
 void __init arch_init_irq(void)
 {
-	unsigned int irq;
-	struct irq_chip *chip0;
-	struct irq_chip *chip0_mbox;
-	struct irq_chip *chip1;
-	struct irq_chip *chip1_wd;
-
 #ifdef CONFIG_SMP
 	/* Set the default affinity to the boot cpu. */
 	cpumask_clear(irq_default_affinity);
 	cpumask_set_cpu(smp_processor_id(), irq_default_affinity);
 #endif
-
-	if (NR_IRQS < OCTEON_IRQ_LAST)
-		pr_err("octeon_irq_init: NR_IRQS is set too low\n");
-
-	if (OCTEON_IS_MODEL(OCTEON_CN58XX_PASS2_X) ||
-	    OCTEON_IS_MODEL(OCTEON_CN56XX_PASS2_X) ||
-	    OCTEON_IS_MODEL(OCTEON_CN52XX_PASS2_X)) {
-		octeon_ciu0_ack = octeon_irq_ciu0_ack_v2;
-		octeon_ciu1_ack = octeon_irq_ciu1_ack_v2;
-		chip0 = &octeon_irq_chip_ciu0_v2;
-		chip0_mbox = &octeon_irq_chip_ciu0_mbox_v2;
-		chip1 = &octeon_irq_chip_ciu1_v2;
-		chip1_wd = &octeon_irq_chip_ciu1_wd_v2;
-	} else {
-		octeon_ciu0_ack = octeon_irq_ciu0_ack;
-		octeon_ciu1_ack = octeon_irq_ciu1_ack;
-		chip0 = &octeon_irq_chip_ciu0;
-		chip0_mbox = &octeon_irq_chip_ciu0_mbox;
-		chip1 = &octeon_irq_chip_ciu1;
-		chip1_wd = &octeon_irq_chip_ciu1_wd;
-	}
-
-	/* 0 - 15 reserved for i8259 master and slave controller. */
-
-	/* 17 - 23 Mips internal */
-	for (irq = OCTEON_IRQ_SW0; irq <= OCTEON_IRQ_TIMER; irq++) {
-		set_irq_chip_and_handler(irq, &octeon_irq_chip_core,
-					 handle_percpu_irq);
-	}
-
-	/* 24 - 87 CIU_INT_SUM0 */
-	for (irq = OCTEON_IRQ_WORKQ0; irq <= OCTEON_IRQ_BOOTDMA; irq++) {
-		switch (irq) {
-		case OCTEON_IRQ_MBOX0:
-		case OCTEON_IRQ_MBOX1:
-			set_irq_chip_and_handler(irq, chip0_mbox, handle_percpu_irq);
-			break;
-		default:
-			set_irq_chip_and_handler(irq, chip0, handle_fasteoi_irq);
-			break;
-		}
-	}
-
-	/* 88 - 151 CIU_INT_SUM1 */
-	for (irq = OCTEON_IRQ_WDOG0; irq <= OCTEON_IRQ_WDOG15; irq++)
-		set_irq_chip_and_handler(irq, chip1_wd, handle_fasteoi_irq);
-
-	for (irq = OCTEON_IRQ_UART2; irq <= OCTEON_IRQ_RESERVED151; irq++)
-		set_irq_chip_and_handler(irq, chip1, handle_fasteoi_irq);
-
-	set_c0_status(0x300 << 2);
+	octeon_irq_init_ciu();
 }
 
 asmlinkage void plat_irq_dispatch(void)
 {
-	const unsigned long core_id = cvmx_get_core_num();
-	const uint64_t ciu_sum0_address = CVMX_CIU_INTX_SUM0(core_id * 2);
-	const uint64_t ciu_en0_address = CVMX_CIU_INTX_EN0(core_id * 2);
-	const uint64_t ciu_sum1_address = CVMX_CIU_INT_SUM1;
-	const uint64_t ciu_en1_address = CVMX_CIU_INTX_EN1(core_id * 2 + 1);
 	unsigned long cop0_cause;
 	unsigned long cop0_status;
-	uint64_t ciu_en;
-	uint64_t ciu_sum;
-	unsigned int irq;
 
 	while (1) {
 		cop0_cause = read_c0_cause();
@@ -757,33 +1034,16 @@ asmlinkage void plat_irq_dispatch(void)
 		cop0_cause &= cop0_status;
 		cop0_cause &= ST0_IM;
 
-		if (unlikely(cop0_cause & STATUSF_IP2)) {
-			ciu_sum = cvmx_read_csr(ciu_sum0_address);
-			ciu_en = cvmx_read_csr(ciu_en0_address);
-			ciu_sum &= ciu_en;
-			if (likely(ciu_sum)) {
-				irq = fls64(ciu_sum) + OCTEON_IRQ_WORKQ0 - 1;
-				octeon_ciu0_ack(irq);
-				do_IRQ(irq);
-			} else {
-				spurious_interrupt();
-			}
-		} else if (unlikely(cop0_cause & STATUSF_IP3)) {
-			ciu_sum = cvmx_read_csr(ciu_sum1_address);
-			ciu_en = cvmx_read_csr(ciu_en1_address);
-			ciu_sum &= ciu_en;
-			if (likely(ciu_sum)) {
-				irq = fls64(ciu_sum) + OCTEON_IRQ_WDOG0 - 1;
-				octeon_ciu1_ack(irq);
-				do_IRQ(irq);
-			} else {
-				spurious_interrupt();
-			}
-		} else if (likely(cop0_cause)) {
+		if (unlikely(cop0_cause & STATUSF_IP2))
+			octeon_irq_ip2();
+		else if (unlikely(cop0_cause & STATUSF_IP3))
+			octeon_irq_ip3();
+		else if (unlikely(cop0_cause & STATUSF_IP4))
+			octeon_irq_ip4();
+		else if (likely(cop0_cause))
 			do_IRQ(fls(cop0_cause) - 9 + MIPS_CPU_IRQ_BASE);
-		} else {
+		else
 			break;
-		}
 	}
 }
 
@@ -793,60 +1053,37 @@ void fixup_irqs(void)
 {
 	int irq;
 	struct irq_desc *desc;
+	struct irq_data *data;
+	struct irq_chip *chip;
 	cpumask_t new_affinity;
 	unsigned long flags;
-	int do_set_affinity;
 	int cpu;
 
 	cpu = smp_processor_id();
 
-	for (irq = OCTEON_IRQ_SW0; irq <= OCTEON_IRQ_TIMER; irq++)
-		octeon_irq_core_disable_local(irq);
+	for (irq = OCTEON_IRQ_SW0; irq < OCTEON_IRQ_LAST; irq++) {
+		irq_cpu_offline(irq);
 
-	for (irq = OCTEON_IRQ_WORKQ0; irq < OCTEON_IRQ_LAST; irq++) {
 		desc = irq_to_desc(irq);
-		switch (irq) {
-		case OCTEON_IRQ_MBOX0:
-		case OCTEON_IRQ_MBOX1:
-			/* The eoi function will disable them on this CPU. */
-			desc->chip->eoi(irq);
-			break;
-		case OCTEON_IRQ_WDOG0:
-		case OCTEON_IRQ_WDOG1:
-		case OCTEON_IRQ_WDOG2:
-		case OCTEON_IRQ_WDOG3:
-		case OCTEON_IRQ_WDOG4:
-		case OCTEON_IRQ_WDOG5:
-		case OCTEON_IRQ_WDOG6:
-		case OCTEON_IRQ_WDOG7:
-		case OCTEON_IRQ_WDOG8:
-		case OCTEON_IRQ_WDOG9:
-		case OCTEON_IRQ_WDOG10:
-		case OCTEON_IRQ_WDOG11:
-		case OCTEON_IRQ_WDOG12:
-		case OCTEON_IRQ_WDOG13:
-		case OCTEON_IRQ_WDOG14:
-		case OCTEON_IRQ_WDOG15:
-			/*
-			 * These have special per CPU semantics and
-			 * are handled in the watchdog driver.
-			 */
-			break;
-		default:
-			raw_spin_lock_irqsave(&desc->lock, flags);
-			/*
-			 * If this irq has an action, it is in use and
-			 * must be migrated if it has affinity to this
-			 * cpu.
-			 */
-			if (desc->action && cpumask_test_cpu(cpu, desc->affinity)) {
-				if (cpumask_weight(desc->affinity) > 1) {
+		if (desc == NULL)
+			continue;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		data = irq_get_irq_data(irq);
+		chip = get_irq_chip(irq);
+		if (!data || !chip)
+			goto loop_unlock;
+
+		if (chip->irq_set_affinity) {
+			if (cpumask_test_cpu(cpu, data->affinity)) {
+				if (cpumask_weight(data->affinity) > 1) {
 					/*
 					 * It has multi CPU affinity,
 					 * just remove this CPU from
 					 * the affinity set.
 					 */
-					cpumask_copy(&new_affinity, desc->affinity);
+					cpumask_copy(&new_affinity, data->affinity);
 					cpumask_clear_cpu(cpu, &new_affinity);
 				} else {
 					/*
@@ -856,17 +1093,16 @@ void fixup_irqs(void)
 					cpumask_clear(&new_affinity);
 					cpumask_set_cpu(cpumask_first(cpu_online_mask), &new_affinity);
 				}
-				do_set_affinity = 1;
 			} else {
-				do_set_affinity = 0;
+				goto loop_unlock;
 			}
 			raw_spin_unlock_irqrestore(&desc->lock, flags);
 
-			if (do_set_affinity)
-				irq_set_affinity(irq, &new_affinity);
-
-			break;
+			irq_set_affinity(irq, &new_affinity);
+			continue; /* Already unlocked */
 		}
+loop_unlock:
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 26e9bb3..7f8a522 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -413,7 +413,6 @@ void octeon_user_io_init(void)
 void __init prom_init(void)
 {
 	struct cvmx_sysinfo *sysinfo;
-	const int coreid = cvmx_get_core_num();
 	int i;
 	int argc;
 #ifdef CONFIG_CAVIUM_RESERVE32
@@ -530,17 +529,6 @@ void __init prom_init(void)
 
 	octeon_uart = octeon_get_boot_uart();
 
-	/*
-	 * Disable All CIU Interrupts. The ones we need will be
-	 * enabled later.  Read the SUM register so we know the write
-	 * completed.
-	 */
-	cvmx_write_csr(CVMX_CIU_INTX_EN0((coreid * 2)), 0);
-	cvmx_write_csr(CVMX_CIU_INTX_EN0((coreid * 2 + 1)), 0);
-	cvmx_write_csr(CVMX_CIU_INTX_EN1((coreid * 2)), 0);
-	cvmx_write_csr(CVMX_CIU_INTX_EN1((coreid * 2 + 1)), 0);
-	cvmx_read_csr(CVMX_CIU_INTX_SUM0((coreid * 2)));
-
 #ifdef CONFIG_SMP
 	octeon_write_lcd("LinuxSMP");
 #else
diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index 391cefe..ba78b21 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -171,41 +171,19 @@ static void octeon_boot_secondary(int cpu, struct task_struct *idle)
  * After we've done initial boot, this function is called to allow the
  * board code to clean up state, if needed
  */
-static void octeon_init_secondary(void)
+static void __cpuinit octeon_init_secondary(void)
 {
-	const int coreid = cvmx_get_core_num();
-	union cvmx_ciu_intx_sum0 interrupt_enable;
 	unsigned int sr;
 
-#ifdef CONFIG_HOTPLUG_CPU
-	struct linux_app_boot_info *labi;
-
-	labi = (struct linux_app_boot_info *)PHYS_TO_XKSEG_CACHED(LABI_ADDR_IN_BOOTLOADER);
-
-	if (labi->labi_signature != LABI_SIGNATURE)
-		panic("The bootloader version on this board is incorrect.");
-#endif
-
 	sr = set_c0_status(ST0_BEV);
 	write_c0_ebase((u32)ebase);
 	write_c0_status(sr);
 
 	octeon_check_cpu_bist();
 	octeon_init_cvmcount();
-	/*
-	pr_info("SMP: CPU%d (CoreId %lu) started\n", cpu, coreid);
-	*/
-	/* Enable Mailbox interrupts to this core. These are the only
-	   interrupts allowed on line 3 */
-	cvmx_write_csr(CVMX_CIU_MBOX_CLRX(coreid), 0xffffffff);
-	interrupt_enable.u64 = 0;
-	interrupt_enable.s.mbox = 0x3;
-	cvmx_write_csr(CVMX_CIU_INTX_EN0((coreid * 2)), interrupt_enable.u64);
-	cvmx_write_csr(CVMX_CIU_INTX_EN0((coreid * 2 + 1)), 0);
-	cvmx_write_csr(CVMX_CIU_INTX_EN1((coreid * 2)), 0);
-	cvmx_write_csr(CVMX_CIU_INTX_EN1((coreid * 2 + 1)), 0);
-	/* Enable core interrupt processing for 2,3 and 7 */
-	set_c0_status(0x8c01);
+
+	octeon_irq_setup_secondary();
+	raw_local_irq_enable();
 }
 
 /**
@@ -214,6 +192,15 @@ static void octeon_init_secondary(void)
  */
 void octeon_prepare_cpus(unsigned int max_cpus)
 {
+#ifdef CONFIG_HOTPLUG_CPU
+	struct linux_app_boot_info *labi;
+
+	labi = (struct linux_app_boot_info *)PHYS_TO_XKSEG_CACHED(LABI_ADDR_IN_BOOTLOADER);
+
+	if (labi->labi_signature != LABI_SIGNATURE)
+		panic("The bootloader version on this board is incorrect.");
+#endif
+
 	cvmx_write_csr(CVMX_CIU_MBOX_CLRX(cvmx_get_core_num()), 0xffffffff);
 	if (request_irq(OCTEON_IRQ_MBOX0, mailbox_interrupt, IRQF_DISABLED,
 			"mailbox0", mailbox_interrupt)) {
diff --git a/arch/mips/include/asm/mach-cavium-octeon/irq.h b/arch/mips/include/asm/mach-cavium-octeon/irq.h
index 6ddab8a..5b05f18 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/irq.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/irq.h
@@ -11,172 +11,91 @@
 #define NR_IRQS OCTEON_IRQ_LAST
 #define MIPS_CPU_IRQ_BASE OCTEON_IRQ_SW0
 
-/* 0 - 7 represent the i8259 master */
-#define OCTEON_IRQ_I8259M0	0
-#define OCTEON_IRQ_I8259M1	1
-#define OCTEON_IRQ_I8259M2	2
-#define OCTEON_IRQ_I8259M3	3
-#define OCTEON_IRQ_I8259M4	4
-#define OCTEON_IRQ_I8259M5	5
-#define OCTEON_IRQ_I8259M6	6
-#define OCTEON_IRQ_I8259M7	7
-/* 8 - 15 represent the i8259 slave */
-#define OCTEON_IRQ_I8259S0	8
-#define OCTEON_IRQ_I8259S1	9
-#define OCTEON_IRQ_I8259S2	10
-#define OCTEON_IRQ_I8259S3	11
-#define OCTEON_IRQ_I8259S4	12
-#define OCTEON_IRQ_I8259S5	13
-#define OCTEON_IRQ_I8259S6	14
-#define OCTEON_IRQ_I8259S7	15
-/* 16 - 23 represent the 8 MIPS standard interrupt sources */
-#define OCTEON_IRQ_SW0		16
-#define OCTEON_IRQ_SW1		17
-#define OCTEON_IRQ_CIU0		18
-#define OCTEON_IRQ_CIU1		19
-#define OCTEON_IRQ_CIU4		20
-#define OCTEON_IRQ_5		21
-#define OCTEON_IRQ_PERF		22
-#define OCTEON_IRQ_TIMER	23
-/* 24 - 87 represent the sources in CIU_INTX_EN0 */
-#define OCTEON_IRQ_WORKQ0	24
-#define OCTEON_IRQ_WORKQ1	25
-#define OCTEON_IRQ_WORKQ2	26
-#define OCTEON_IRQ_WORKQ3	27
-#define OCTEON_IRQ_WORKQ4	28
-#define OCTEON_IRQ_WORKQ5	29
-#define OCTEON_IRQ_WORKQ6	30
-#define OCTEON_IRQ_WORKQ7	31
-#define OCTEON_IRQ_WORKQ8	32
-#define OCTEON_IRQ_WORKQ9	33
-#define OCTEON_IRQ_WORKQ10	34
-#define OCTEON_IRQ_WORKQ11	35
-#define OCTEON_IRQ_WORKQ12	36
-#define OCTEON_IRQ_WORKQ13	37
-#define OCTEON_IRQ_WORKQ14	38
-#define OCTEON_IRQ_WORKQ15	39
-#define OCTEON_IRQ_GPIO0	40
-#define OCTEON_IRQ_GPIO1	41
-#define OCTEON_IRQ_GPIO2	42
-#define OCTEON_IRQ_GPIO3	43
-#define OCTEON_IRQ_GPIO4	44
-#define OCTEON_IRQ_GPIO5	45
-#define OCTEON_IRQ_GPIO6	46
-#define OCTEON_IRQ_GPIO7	47
-#define OCTEON_IRQ_GPIO8	48
-#define OCTEON_IRQ_GPIO9	49
-#define OCTEON_IRQ_GPIO10	50
-#define OCTEON_IRQ_GPIO11	51
-#define OCTEON_IRQ_GPIO12	52
-#define OCTEON_IRQ_GPIO13	53
-#define OCTEON_IRQ_GPIO14	54
-#define OCTEON_IRQ_GPIO15	55
-#define OCTEON_IRQ_MBOX0	56
-#define OCTEON_IRQ_MBOX1	57
-#define OCTEON_IRQ_UART0	58
-#define OCTEON_IRQ_UART1	59
-#define OCTEON_IRQ_PCI_INT0	60
-#define OCTEON_IRQ_PCI_INT1	61
-#define OCTEON_IRQ_PCI_INT2	62
-#define OCTEON_IRQ_PCI_INT3	63
-#define OCTEON_IRQ_PCI_MSI0	64
-#define OCTEON_IRQ_PCI_MSI1	65
-#define OCTEON_IRQ_PCI_MSI2	66
-#define OCTEON_IRQ_PCI_MSI3	67
-#define OCTEON_IRQ_RESERVED68	68	/* Summary of CIU_INT_SUM1 */
-#define OCTEON_IRQ_TWSI		69
-#define OCTEON_IRQ_RML		70
-#define OCTEON_IRQ_TRACE	71
-#define OCTEON_IRQ_GMX_DRP0	72
-#define OCTEON_IRQ_GMX_DRP1	73
-#define OCTEON_IRQ_IPD_DRP	74
-#define OCTEON_IRQ_KEY_ZERO	75
-#define OCTEON_IRQ_TIMER0	76
-#define OCTEON_IRQ_TIMER1	77
-#define OCTEON_IRQ_TIMER2	78
-#define OCTEON_IRQ_TIMER3	79
-#define OCTEON_IRQ_USB0		80
-#define OCTEON_IRQ_PCM		81
-#define OCTEON_IRQ_MPI		82
-#define OCTEON_IRQ_TWSI2	83
-#define OCTEON_IRQ_POWIQ	84
-#define OCTEON_IRQ_IPDPPTHR	85
-#define OCTEON_IRQ_MII0		86
-#define OCTEON_IRQ_BOOTDMA	87
-/* 88 - 151 represent the sources in CIU_INTX_EN1 */
-#define OCTEON_IRQ_WDOG0	88
-#define OCTEON_IRQ_WDOG1	89
-#define OCTEON_IRQ_WDOG2	90
-#define OCTEON_IRQ_WDOG3	91
-#define OCTEON_IRQ_WDOG4	92
-#define OCTEON_IRQ_WDOG5	93
-#define OCTEON_IRQ_WDOG6	94
-#define OCTEON_IRQ_WDOG7	95
-#define OCTEON_IRQ_WDOG8	96
-#define OCTEON_IRQ_WDOG9	97
-#define OCTEON_IRQ_WDOG10	98
-#define OCTEON_IRQ_WDOG11	99
-#define OCTEON_IRQ_WDOG12	100
-#define OCTEON_IRQ_WDOG13	101
-#define OCTEON_IRQ_WDOG14	102
-#define OCTEON_IRQ_WDOG15	103
-#define OCTEON_IRQ_UART2	104
-#define OCTEON_IRQ_USB1		105
-#define OCTEON_IRQ_MII1		106
-#define OCTEON_IRQ_RESERVED107	107
-#define OCTEON_IRQ_RESERVED108	108
-#define OCTEON_IRQ_RESERVED109	109
-#define OCTEON_IRQ_RESERVED110	110
-#define OCTEON_IRQ_RESERVED111	111
-#define OCTEON_IRQ_RESERVED112	112
-#define OCTEON_IRQ_RESERVED113	113
-#define OCTEON_IRQ_RESERVED114	114
-#define OCTEON_IRQ_RESERVED115	115
-#define OCTEON_IRQ_RESERVED116	116
-#define OCTEON_IRQ_RESERVED117	117
-#define OCTEON_IRQ_RESERVED118	118
-#define OCTEON_IRQ_RESERVED119	119
-#define OCTEON_IRQ_RESERVED120	120
-#define OCTEON_IRQ_RESERVED121	121
-#define OCTEON_IRQ_RESERVED122	122
-#define OCTEON_IRQ_RESERVED123	123
-#define OCTEON_IRQ_RESERVED124	124
-#define OCTEON_IRQ_RESERVED125	125
-#define OCTEON_IRQ_RESERVED126	126
-#define OCTEON_IRQ_RESERVED127	127
-#define OCTEON_IRQ_RESERVED128	128
-#define OCTEON_IRQ_RESERVED129	129
-#define OCTEON_IRQ_RESERVED130	130
-#define OCTEON_IRQ_RESERVED131	131
-#define OCTEON_IRQ_RESERVED132	132
-#define OCTEON_IRQ_RESERVED133	133
-#define OCTEON_IRQ_RESERVED134	134
-#define OCTEON_IRQ_RESERVED135	135
-#define OCTEON_IRQ_RESERVED136	136
-#define OCTEON_IRQ_RESERVED137	137
-#define OCTEON_IRQ_RESERVED138	138
-#define OCTEON_IRQ_RESERVED139	139
-#define OCTEON_IRQ_RESERVED140	140
-#define OCTEON_IRQ_RESERVED141	141
-#define OCTEON_IRQ_RESERVED142	142
-#define OCTEON_IRQ_RESERVED143	143
-#define OCTEON_IRQ_RESERVED144	144
-#define OCTEON_IRQ_RESERVED145	145
-#define OCTEON_IRQ_RESERVED146	146
-#define OCTEON_IRQ_RESERVED147	147
-#define OCTEON_IRQ_RESERVED148	148
-#define OCTEON_IRQ_RESERVED149	149
-#define OCTEON_IRQ_RESERVED150	150
-#define OCTEON_IRQ_RESERVED151	151
+enum octeon_irq {
+/* 1 - 8 represent the 8 MIPS standard interrupt sources */
+	OCTEON_IRQ_SW0 = 1,
+	OCTEON_IRQ_SW1,
+/* CIU0, CUI2, CIU4 are 3, 4, 5 */
+	OCTEON_IRQ_5 = 6,
+	OCTEON_IRQ_PERF,
+	OCTEON_IRQ_TIMER,
+/* sources in CIU_INTX_EN0 */
+	OCTEON_IRQ_WORKQ0,
+	OCTEON_IRQ_GPIO0 = OCTEON_IRQ_WORKQ0 + 16,
+	OCTEON_IRQ_WDOG0 = OCTEON_IRQ_GPIO0 + 16,
+	OCTEON_IRQ_WDOG15 = OCTEON_IRQ_WDOG0 + 15,
+	OCTEON_IRQ_MBOX0 = OCTEON_IRQ_WDOG0 + 16,
+	OCTEON_IRQ_MBOX1,
+	OCTEON_IRQ_UART0,
+	OCTEON_IRQ_UART1,
+	OCTEON_IRQ_UART2,
+	OCTEON_IRQ_PCI_INT0,
+	OCTEON_IRQ_PCI_INT1,
+	OCTEON_IRQ_PCI_INT2,
+	OCTEON_IRQ_PCI_INT3,
+	OCTEON_IRQ_PCI_MSI0,
+	OCTEON_IRQ_PCI_MSI1,
+	OCTEON_IRQ_PCI_MSI2,
+	OCTEON_IRQ_PCI_MSI3,
+
+	OCTEON_IRQ_TWSI,
+	OCTEON_IRQ_TWSI2,
+	OCTEON_IRQ_RML,
+	OCTEON_IRQ_TRACE0,
+	OCTEON_IRQ_GMX_DRP0 = OCTEON_IRQ_TRACE0 + 4,
+	OCTEON_IRQ_IPD_DRP = OCTEON_IRQ_GMX_DRP0 + 5,
+	OCTEON_IRQ_KEY_ZERO,
+	OCTEON_IRQ_TIMER0,
+	OCTEON_IRQ_TIMER1,
+	OCTEON_IRQ_TIMER2,
+	OCTEON_IRQ_TIMER3,
+	OCTEON_IRQ_USB0,
+	OCTEON_IRQ_USB1,
+	OCTEON_IRQ_PCM,
+	OCTEON_IRQ_MPI,
+	OCTEON_IRQ_POWIQ,
+	OCTEON_IRQ_IPDPPTHR,
+	OCTEON_IRQ_MII0,
+	OCTEON_IRQ_MII1,
+	OCTEON_IRQ_BOOTDMA,
+
+	OCTEON_IRQ_NAND,
+	OCTEON_IRQ_MIO,		/* Summary of MIO_BOOT_ERR */
+	OCTEON_IRQ_IOB,		/* Summary of IOB_INT_SUM */
+	OCTEON_IRQ_FPA,		/* Summary of FPA_INT_SUM */
+	OCTEON_IRQ_POW,		/* Summary of POW_ECC_ERR */
+	OCTEON_IRQ_L2C,		/* Summary of L2C_INT_STAT */
+	OCTEON_IRQ_IPD,		/* Summary of IPD_INT_SUM */
+	OCTEON_IRQ_PIP,		/* Summary of PIP_INT_REG */
+	OCTEON_IRQ_PKO,		/* Summary of PKO_REG_ERROR */
+	OCTEON_IRQ_ZIP,		/* Summary of ZIP_ERROR */
+	OCTEON_IRQ_TIM,		/* Summary of TIM_REG_ERROR */
+	OCTEON_IRQ_RAD,		/* Summary of RAD_REG_ERROR */
+	OCTEON_IRQ_KEY,		/* Summary of KEY_INT_SUM */
+	OCTEON_IRQ_DFA,		/* Summary of DFA */
+	OCTEON_IRQ_USBCTL,	/* Summary of USBN0_INT_SUM */
+	OCTEON_IRQ_SLI,		/* Summary of SLI_INT_SUM */
+	OCTEON_IRQ_DPI,		/* Summary of DPI_INT_SUM */
+	OCTEON_IRQ_AGX0,	/* Summary of GMX0*+PCS0_INT*_REG */
+	OCTEON_IRQ_AGL  = OCTEON_IRQ_AGX0 + 5,
+	OCTEON_IRQ_PTP,
+	OCTEON_IRQ_PEM0,
+	OCTEON_IRQ_PEM1,
+	OCTEON_IRQ_SRIO0,
+	OCTEON_IRQ_SRIO1,
+	OCTEON_IRQ_LMC0,
+	OCTEON_IRQ_DFM = OCTEON_IRQ_LMC0 + 4,		/* Summary of DFM */
+	OCTEON_IRQ_RST,
+};
 
 #ifdef CONFIG_PCI_MSI
-/* 152 - 215 represent the MSI interrupts 0-63 */
-#define OCTEON_IRQ_MSI_BIT0	152
-#define OCTEON_IRQ_MSI_LAST	(OCTEON_IRQ_MSI_BIT0 + 255)
+/* 152 - 407 represent the MSI interrupts 0-255 */
+#define OCTEON_IRQ_MSI_BIT0	(OCTEON_IRQ_RST + 1)
 
-#define OCTEON_IRQ_LAST		(OCTEON_IRQ_MSI_LAST + 1)
+#define OCTEON_IRQ_MSI_LAST      (OCTEON_IRQ_MSI_BIT0 + 255)
+#define OCTEON_IRQ_LAST          (OCTEON_IRQ_MSI_LAST + 1)
 #else
-#define OCTEON_IRQ_LAST         152
+#define OCTEON_IRQ_LAST         (OCTEON_IRQ_RST + 1)
 #endif
 
 #endif
diff --git a/arch/mips/include/asm/octeon/octeon.h b/arch/mips/include/asm/octeon/octeon.h
index 6b34afd0..f72f768 100644
--- a/arch/mips/include/asm/octeon/octeon.h
+++ b/arch/mips/include/asm/octeon/octeon.h
@@ -257,4 +257,6 @@ extern struct cvmx_bootinfo *octeon_bootinfo;
 
 extern uint64_t octeon_bootloader_entry_addr;
 
+extern void (*octeon_irq_setup_secondary)(void);
+
 #endif /* __ASM_OCTEON_OCTEON_H */
diff --git a/arch/mips/pci/msi-octeon.c b/arch/mips/pci/msi-octeon.c
index d808049..eebaf56 100644
--- a/arch/mips/pci/msi-octeon.c
+++ b/arch/mips/pci/msi-octeon.c
@@ -259,11 +259,11 @@ static DEFINE_RAW_SPINLOCK(octeon_irq_msi_lock);
 static u64 msi_rcv_reg[4];
 static u64 mis_ena_reg[4];
 
-static void octeon_irq_msi_enable_pcie(unsigned int irq)
+static void octeon_irq_msi_enable_pcie(struct irq_data *data)
 {
 	u64 en;
 	unsigned long flags;
-	int msi_number = irq - OCTEON_IRQ_MSI_BIT0;
+	int msi_number = data->irq - OCTEON_IRQ_MSI_BIT0;
 	int irq_index = msi_number >> 6;
 	int irq_bit = msi_number & 0x3f;
 
@@ -275,11 +275,11 @@ static void octeon_irq_msi_enable_pcie(unsigned int irq)
 	raw_spin_unlock_irqrestore(&octeon_irq_msi_lock, flags);
 }
 
-static void octeon_irq_msi_disable_pcie(unsigned int irq)
+static void octeon_irq_msi_disable_pcie(struct irq_data *data)
 {
 	u64 en;
 	unsigned long flags;
-	int msi_number = irq - OCTEON_IRQ_MSI_BIT0;
+	int msi_number = data->irq - OCTEON_IRQ_MSI_BIT0;
 	int irq_index = msi_number >> 6;
 	int irq_bit = msi_number & 0x3f;
 
@@ -293,11 +293,11 @@ static void octeon_irq_msi_disable_pcie(unsigned int irq)
 
 static struct irq_chip octeon_irq_chip_msi_pcie = {
 	.name = "MSI",
-	.enable = octeon_irq_msi_enable_pcie,
-	.disable = octeon_irq_msi_disable_pcie,
+	.irq_enable = octeon_irq_msi_enable_pcie,
+	.irq_disable = octeon_irq_msi_disable_pcie,
 };
 
-static void octeon_irq_msi_enable_pci(unsigned int irq)
+static void octeon_irq_msi_enable_pci(struct irq_data *data)
 {
 	/*
 	 * Octeon PCI doesn't have the ability to mask/unmask MSI
@@ -308,15 +308,15 @@ static void octeon_irq_msi_enable_pci(unsigned int irq)
 	 */
 }
 
-static void octeon_irq_msi_disable_pci(unsigned int irq)
+static void octeon_irq_msi_disable_pci(struct irq_data *data)
 {
 	/* See comment in enable */
 }
 
 static struct irq_chip octeon_irq_chip_msi_pci = {
 	.name = "MSI",
-	.enable = octeon_irq_msi_enable_pci,
-	.disable = octeon_irq_msi_disable_pci,
+	.irq_enable = octeon_irq_msi_enable_pci,
+	.irq_disable = octeon_irq_msi_disable_pci,
 };
 
 /*
-- 
1.7.2.3

