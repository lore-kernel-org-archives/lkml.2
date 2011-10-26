Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1JZGHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:07:45 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62598 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1JZGHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:07:43 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        Steffen Persvold <sp@numascale.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH 1/3] Add Numachip APIC support
Date: Wed, 26 Oct 2011 14:07:08 +0800
Message-Id: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Persvold <sp@numascale.com>

From: Steffen Persvold <sp@numascale.com>

Add support for Numascale's NumaChip APIC mapping mechanism to allow
booting more than ~168 cores.

v2:
 - [Steffen] enumerate only accessible northbridges
 - [Daniel] rediffed and validated against 3.1-rc10

Signed-off-by: Steffen Persvold <sp@numascale.com>
Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/Kconfig                             |   12 +
 arch/x86/include/asm/numachip/numachip.h     |   29 +++
 arch/x86/include/asm/numachip/numachip_csr.h |  173 +++++++++++++
 arch/x86/kernel/apic/Makefile                |    1 +
 arch/x86/kernel/apic/apic_numachip.c         |  332 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel_cacheinfo.c        |    4 +
 arch/x86/kernel/smpboot.c                    |    6 +-
 7 files changed, 556 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/numachip/numachip.h
 create mode 100644 arch/x86/include/asm/numachip/numachip_csr.h
 create mode 100644 arch/x86/kernel/apic/apic_numachip.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a47bb2..712ea9c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -344,6 +344,7 @@ config X86_EXTENDED_PLATFORM
 
 	  If you enable this option then you'll be able to select support
 	  for the following (non-PC) 64 bit x86 platforms:
+		Numascale NumaChip
 		ScaleMP vSMP
 		SGI Ultraviolet
 
@@ -352,6 +353,17 @@ config X86_EXTENDED_PLATFORM
 endif
 # This is an alphabetically sorted list of 64 bit extended platforms
 # Please maintain the alphabetic order if and when there are additions
+config X86_NUMACHIP
+	bool "Numascale NumaChip"
+	depends on X86_64
+	depends on X86_EXTENDED_PLATFORM
+	depends on NUMA
+	depends on X86_X2APIC
+	depends on !EDAC_AMD64
+	---help---
+	  Adds support for Numascale NumaChip large-SMP systems. Needed to
+	  enable more than ~168 cores.
+	  If you don't have one of these, you should say N here.
 
 config X86_VSMP
 	bool "ScaleMP vSMP"
diff --git a/arch/x86/include/asm/numachip/numachip.h b/arch/x86/include/asm/numachip/numachip.h
new file mode 100644
index 0000000..ccc3584
--- /dev/null
+++ b/arch/x86/include/asm/numachip/numachip.h
@@ -0,0 +1,29 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Numascale NumaConnect-Specific Header file
+ *
+ * Copyright (C) 2011 Numascale AS. All rights reserved.
+ *
+ * Send feedback to <support@numascale.com>
+ *
+ */
+
+#ifndef _ASM_X86_NUMACHIP_NUMACHIP_H
+#define _ASM_X86_NUMACHIP_NUMACHIP_H
+
+#ifdef CONFIG_X86_NUMACHIP
+
+extern int is_numachip_system(void);
+extern void numachip_system_init(void);
+
+#else /* X86_NUMACHIP */
+
+static inline int is_numachip_system(void)	{ return 0; }
+static inline void numachip_system_init(void)	{ }
+
+#endif /* X86_NUMACHIP */
+
+#endif /* _ASM_X86_NUMACHIP_NUMACHIP_H */
diff --git a/arch/x86/include/asm/numachip/numachip_csr.h b/arch/x86/include/asm/numachip/numachip_csr.h
new file mode 100644
index 0000000..e6d8bc9
--- /dev/null
+++ b/arch/x86/include/asm/numachip/numachip_csr.h
@@ -0,0 +1,173 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Numascale NumaConnect-Specific Header file
+ *
+ * Copyright (C) 2011 Numascale AS. All rights reserved.
+ *
+ * Send feedback to <support@numascale.com>
+ *
+ */
+
+#ifndef _ASM_X86_NUMACHIP_NUMACHIP_CSR_H
+#define _ASM_X86_NUMACHIP_NUMACHIP_CSR_H
+
+#include <linux/numa.h>
+#include <linux/percpu.h>
+#include <linux/io.h>
+#include <linux/swab.h>
+#include <asm/types.h>
+#include <asm/processor.h>
+
+#define NUMACHIP_CSR_NODE_SHIFT		16
+#define NUMACHIP_CSR_NODE_BITS(p)	\
+	(((unsigned long)(p)) << NUMACHIP_CSR_NODE_SHIFT)
+
+#define NUMACHIP_CSR_NODE_MASK		0x0fff		/* 4K nodes */
+
+/* 32K CSR space, b15 indicates geo/non-geo */
+#define NUMACHIP_CSR_OFFSET_MASK	0x7fffUL
+
+/* Global CSR space covers all 4K possible nodes with 64K CSR space per node */
+#define NUMACHIP_GLOBAL_CSR_BASE	0x3fff00000000ULL
+#define NUMACHIP_GLOBAL_CSR_LIM		0x3fff0fffffffULL
+#define NUMACHIP_GLOBAL_CSR_SIZE	\
+	(NUMACHIP_GLOBAL_CSR_LIM - NUMACHIP_GLOBAL_CSR_BASE + 1)
+
+/* Local CSR space starts in global CSR space with "nodeid" = 0xfff0, however
+   when using the direct mapping on x86_64, both start and size needs to be
+   aligned with PMD_SIZE which is 2M */
+#define NUMACHIP_LOCAL_CSR_BASE		0x3ffffe000000ULL
+#define NUMACHIP_LOCAL_CSR_LIM		0x3fffffffffffULL
+#define NUMACHIP_LOCAL_CSR_SIZE		\
+	(NUMACHIP_LOCAL_CSR_LIM - NUMACHIP_LOCAL_CSR_BASE + 1)
+
+static inline void *numachip_global_csr_address(int node, unsigned long offset)
+{
+	return __va(NUMACHIP_GLOBAL_CSR_BASE | (1UL << 15) |
+		NUMACHIP_CSR_NODE_BITS(node & NUMACHIP_CSR_NODE_MASK) |
+		(offset & NUMACHIP_CSR_OFFSET_MASK));
+}
+
+static inline void *numachip_local_csr_address(unsigned long offset)
+{
+	return __va(NUMACHIP_LOCAL_CSR_BASE | (1UL << 15) |
+		NUMACHIP_CSR_NODE_BITS(0xfff0) |
+		(offset & NUMACHIP_CSR_OFFSET_MASK));
+}
+
+static inline unsigned int numachip_read_global_csr(int node,
+							unsigned long offset)
+{
+	return swab32(readl(numachip_global_csr_address(node, offset)));
+}
+
+static inline void numachip_write_global_csr(int node, unsigned long offset,
+							unsigned int val)
+{
+	writel(swab32(val), numachip_global_csr_address(node, offset));
+}
+
+static inline unsigned int numachip_read_local_csr(unsigned long offset)
+{
+	return swab32(readl(numachip_local_csr_address(offset)));
+}
+
+static inline void numachip_write_local_csr(unsigned long offset,
+							unsigned int val)
+{
+	writel(swab32(val), numachip_local_csr_address(offset));
+}
+
+/* ========================================================================= */
+/*                   NUMACHIP_CSR_G0_STATE_CLEAR                             */
+/* ========================================================================= */
+
+#define NUMACHIP_CSR_G0_STATE_CLEAR (0x000 + (0 << 12))
+union numachip_csr_g0_state_clear {
+	unsigned int v;
+	struct numachip_csr_g0_state_clear_s {
+		unsigned int _state:2;
+		unsigned int _rsvd_2_6:5;
+		unsigned int _lost:1;
+		unsigned int _rsvd_8_31:24;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   NUMACHIP_CSR_G0_NODE_IDS                                */
+/* ========================================================================= */
+
+#define NUMACHIP_CSR_G0_NODE_IDS (0x008 + (0 << 12))
+union numachip_csr_g0_node_ids {
+	unsigned int v;
+	struct numachip_csr_g0_node_ids_s {
+		unsigned int _initialid:16;
+		unsigned int _nodeid:12;
+		unsigned int _rsvd_28_31:4;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   NUMACHIP_CSR_G3_EXT_INTERRUPT_GEN                       */
+/* ========================================================================= */
+
+#define NUMACHIP_CSR_G3_EXT_INTERRUPT_GEN (0x030 + (3 << 12))
+union numachip_csr_g3_ext_interrupt_gen {
+	unsigned int v;
+	struct numachip_csr_g3_ext_interrupt_gen_s {
+		unsigned int _vector:8;
+		unsigned int _msgtype:3;
+		unsigned int _index:5;
+		unsigned int _destination_apic_id:16;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   NUMACHIP_CSR_G3_EXT_INTERRUPT_STATUS                    */
+/* ========================================================================= */
+
+#define NUMACHIP_CSR_G3_EXT_INTERRUPT_STATUS (0x034 + (3 << 12))
+union numachip_csr_g3_ext_interrupt_status {
+	unsigned int v;
+	struct numachip_csr_g3_ext_interrupt_status_s {
+		unsigned int _result:32;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   NUMACHIP_CSR_G3_EXT_INTERRUPT_DEST                      */
+/* ========================================================================= */
+
+#define NUMACHIP_CSR_G3_EXT_INTERRUPT_DEST (0x038 + (3 << 12))
+union numachip_csr_g3_ext_interrupt_dest {
+	unsigned int v;
+	struct numachip_csr_g3_ext_interrupt_dest_s {
+		unsigned int _interrupt:8;
+		unsigned int _rsvd_8_31:24;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   NUMACHIP_CSR_G3_NC_ATT_MAP_SELECT                       */
+/* ========================================================================= */
+
+#define NUMACHIP_CSR_G3_NC_ATT_MAP_SELECT (0x7fc + (3 << 12))
+union numachip_csr_g3_nc_att_map_select {
+	unsigned int v;
+	struct numachip_csr_g3_nc_att_map_select_s {
+		unsigned int _upper_address_bits:4;
+		unsigned int _select_ram:4;
+		unsigned int _rsvd_8_31:24;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   NUMACHIP_CSR_G3_NC_ATT_MAP_SELECT_0-255                 */
+/* ========================================================================= */
+
+#define NUMACHIP_CSR_G3_NC_ATT_MAP_SELECT_0 (0x800 + (3 << 12))
+
+#endif /* _ASM_X86_NUMACHIP_NUMACHIP_CSR_H */
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 767fd04..0ae0323 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_SMP)		+= ipi.o
 
 ifeq ($(CONFIG_X86_64),y)
 # APIC probe will depend on the listing order here
+obj-$(CONFIG_X86_NUMACHIP)	+= apic_numachip.o
 obj-$(CONFIG_X86_UV)		+= x2apic_uv_x.o
 obj-$(CONFIG_X86_X2APIC)	+= x2apic_phys.o
 obj-$(CONFIG_X86_X2APIC)	+= x2apic_cluster.o
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
new file mode 100644
index 0000000..e999afa
--- /dev/null
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -0,0 +1,332 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Numascale NumaConnect-Specific APIC Code
+ *
+ * Copyright (C) 2011 Numascale AS. All rights reserved.
+ *
+ * Send feedback to <support@numascale.com>
+ *
+ */
+
+#include <linux/errno.h>
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/hardirq.h>
+#include <linux/delay.h>
+
+#include <asm/numachip/numachip.h>
+#include <asm/numachip/numachip_csr.h>
+#include <asm/smp.h>
+#include <asm/apic.h>
+#include <asm/ipi.h>
+
+static int numachip_system;
+
+static struct apic apic_numachip;
+
+static int numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	if (!strncmp(oem_id, "NUMASC", 6)) {
+		numachip_system = 1;
+		return 1;
+	}
+
+	return 0;
+}
+
+int is_numachip_system(void)
+{
+	return numachip_system == 1;
+}
+EXPORT_SYMBOL_GPL(is_numachip_system);
+
+/*
+ * Set up the logical destination ID.
+ *
+ * Intel recommends to set DFR, LDR and TPR before enabling
+ * an APIC. See e.g. "AP-388 82489DX User's Manual" (Intel
+ * document number 292116).
+ */
+static void numachip_init_apic_ldr(void)
+{
+	unsigned long val;
+	unsigned long num, id;
+
+	num = smp_processor_id();
+	id = 1UL << num;
+	apic_write(APIC_DFR, APIC_DFR_FLAT);
+	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
+	val |= SET_APIC_LOGICAL_ID(id);
+	apic_write(APIC_LDR, val);
+}
+
+static unsigned int get_apic_id(unsigned long x)
+{
+	unsigned long value;
+	unsigned int id;
+
+	rdmsrl(MSR_FAM10H_NODE_ID, value);
+	id = ((x >> 24) & 0xffU) | ((value << 2) & 0x3f00U);
+
+	return id;
+}
+
+static unsigned long set_apic_id(unsigned int id)
+{
+	unsigned long x;
+
+	x = ((id & 0xffU) << 24);
+	return x;
+}
+
+static unsigned int read_xapic_id(void)
+{
+	return get_apic_id(apic_read(APIC_ID));
+}
+
+static int numachip_apic_id_registered(void)
+{
+	return physid_isset(read_xapic_id(), phys_cpu_present_map);
+}
+
+static int numachip_phys_pkg_id(int initial_apic_id, int index_msb)
+{
+	return initial_apic_id >> index_msb;
+}
+
+static const struct cpumask *numachip_target_cpus(void)
+{
+	return cpu_online_mask;
+}
+
+static void numachip_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
+}
+
+static int __cpuinit numachip_wakeup_secondary(int phys_apicid,
+						unsigned long start_rip)
+{
+#ifdef CONFIG_SMP
+	union numachip_csr_g3_ext_interrupt_gen int_gen;
+	unsigned long flags;
+
+	int_gen.s._destination_apic_id = phys_apicid;
+	int_gen.s._vector = 0;
+	int_gen.s._msgtype = APIC_DM_INIT >> 8;
+	int_gen.s._index = 0;
+
+	local_irq_save(flags);
+	numachip_write_local_csr(NUMACHIP_CSR_G3_EXT_INTERRUPT_GEN,
+				 int_gen.v);
+	local_irq_restore(flags);
+
+	mdelay(10);
+
+	int_gen.s._msgtype = APIC_DM_STARTUP >> 8;
+	int_gen.s._vector = start_rip >> 12;
+
+	local_irq_save(flags);
+	numachip_write_local_csr(NUMACHIP_CSR_G3_EXT_INTERRUPT_GEN,
+				 int_gen.v);
+	local_irq_restore(flags);
+
+	atomic_set(&init_deasserted, 1);
+#endif
+	return 0;
+}
+
+static void numachip_send_IPI_one(int cpu, int vector)
+{
+	union numachip_csr_g3_ext_interrupt_gen int_gen;
+	int apicid = per_cpu(x86_cpu_to_apicid, cpu);
+
+	int_gen.s._destination_apic_id = apicid;
+	int_gen.s._vector = vector;
+	int_gen.s._msgtype =
+		(vector == NMI_VECTOR ? APIC_DM_NMI : APIC_DM_FIXED) >> 8;
+	int_gen.s._index = 0;
+
+	numachip_write_local_csr(NUMACHIP_CSR_G3_EXT_INTERRUPT_GEN,
+				 int_gen.v);
+}
+
+static void numachip_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	unsigned int cpu;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	for_each_cpu(cpu, mask)
+		numachip_send_IPI_one(cpu, vector);
+	local_irq_restore(flags);
+}
+
+static void numachip_send_IPI_mask_allbutself(const struct cpumask *mask,
+						int vector)
+{
+	unsigned int this_cpu = smp_processor_id();
+	unsigned int cpu;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	for_each_cpu(cpu, mask) {
+		if (cpu != this_cpu)
+			numachip_send_IPI_one(cpu, vector);
+	}
+	local_irq_restore(flags);
+}
+
+static void numachip_send_IPI_allbutself(int vector)
+{
+	unsigned int this_cpu = smp_processor_id();
+	unsigned int cpu;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	for_each_online_cpu(cpu) {
+		if (cpu != this_cpu)
+			numachip_send_IPI_one(cpu, vector);
+	}
+	local_irq_restore(flags);
+}
+
+static void numachip_send_IPI_all(int vector)
+{
+	numachip_send_IPI_mask(cpu_online_mask, vector);
+}
+
+static void numachip_send_IPI_self(int vector)
+{
+	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
+}
+
+static unsigned int numachip_cpu_mask_to_apicid(const struct cpumask *cpumask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	cpu = cpumask_first(cpumask);
+	if ((unsigned)cpu < nr_cpu_ids)
+		return per_cpu(x86_cpu_to_apicid, cpu);
+	else
+		return BAD_APICID;
+}
+
+static unsigned int
+numachip_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+				const struct cpumask *andmask)
+{
+	int cpu;
+
+	/*
+	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
+	 * May as well be the first.
+	 */
+	for_each_cpu_and(cpu, cpumask, andmask) {
+		if (cpumask_test_cpu(cpu, cpu_online_mask))
+			break;
+	}
+	return per_cpu(x86_cpu_to_apicid, cpu);
+}
+
+static int __init numachip_probe(void)
+{
+	return apic == &apic_numachip;
+}
+
+static struct apic apic_numachip __refconst = {
+
+	.name				= "NumaConnect system",
+	.probe				= numachip_probe,
+	.acpi_madt_oem_check		= numachip_acpi_madt_oem_check,
+	.apic_id_registered		= numachip_apic_id_registered,
+
+	.irq_delivery_mode		= dest_Fixed,
+	.irq_dest_mode			= 0, /* physical */
+
+	.target_cpus			= numachip_target_cpus,
+	.disable_esr			= 0,
+	.dest_logical			= 0,
+	.check_apicid_used		= NULL,
+	.check_apicid_present		= NULL,
+
+	.vector_allocation_domain	= numachip_vector_allocation_domain,
+	.init_apic_ldr			= numachip_init_apic_ldr,
+
+	.ioapic_phys_id_map		= NULL,
+	.setup_apic_routing		= NULL,
+	.multi_timer_check		= NULL,
+	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
+	.apicid_to_cpu_present		= NULL,
+	.setup_portio_remap		= NULL,
+	.check_phys_apicid_present	= default_check_phys_apicid_present,
+	.enable_apic_mode		= NULL,
+	.phys_pkg_id			= numachip_phys_pkg_id,
+	.mps_oem_check			= NULL,
+
+	.get_apic_id			= get_apic_id,
+	.set_apic_id			= set_apic_id,
+	.apic_id_mask			= 0xffU << 24,
+
+	.cpu_mask_to_apicid		= numachip_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= numachip_cpu_mask_to_apicid_and,
+
+	.send_IPI_mask			= numachip_send_IPI_mask,
+	.send_IPI_mask_allbutself	= numachip_send_IPI_mask_allbutself,
+	.send_IPI_allbutself		= numachip_send_IPI_allbutself,
+	.send_IPI_all			= numachip_send_IPI_all,
+	.send_IPI_self			= numachip_send_IPI_self,
+
+	.wakeup_secondary_cpu		= numachip_wakeup_secondary,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
+	.wait_for_init_deassert		= NULL,
+	.smp_callin_clear_local_apic	= NULL,
+	.inquire_remote_apic		= NULL, /* REMRD not supported */
+
+	.read				= native_apic_mem_read,
+	.write				= native_apic_mem_write,
+	.icr_read			= native_apic_icr_read,
+	.icr_write			= native_apic_icr_write,
+	.wait_icr_idle			= native_apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
+};
+
+static void __init map_csrs(void)
+{
+	printk(KERN_INFO "NumaChip: Mapping local CSR space (%016llx - %016llx)\n",
+		NUMACHIP_LOCAL_CSR_BASE,
+		NUMACHIP_LOCAL_CSR_BASE + NUMACHIP_LOCAL_CSR_SIZE - 1);
+	init_extra_mapping_uc(NUMACHIP_LOCAL_CSR_BASE, NUMACHIP_LOCAL_CSR_SIZE);
+
+	printk(KERN_INFO "NumaChip: Mapping global CSR space (%016llx - %016llx)\n",
+		NUMACHIP_GLOBAL_CSR_BASE,
+		NUMACHIP_GLOBAL_CSR_BASE + NUMACHIP_GLOBAL_CSR_SIZE - 1);
+	init_extra_mapping_uc(NUMACHIP_GLOBAL_CSR_BASE,
+		NUMACHIP_GLOBAL_CSR_SIZE);
+}
+
+void __init numachip_system_init(void)
+{
+	unsigned int val;
+
+	map_csrs();
+
+	val = numachip_read_local_csr(NUMACHIP_CSR_G0_NODE_IDS);
+	printk(KERN_INFO "NumaChip: Local NodeID = %08x\n", val);
+}
+
+apic_driver(apic_numachip);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index c105c53..ca0b70e 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -354,6 +354,10 @@ static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf,
 
 	node = amd_get_nb_id(smp_processor_id());
 
+	/* sanity check, in case we haven't allocated enough */
+	if (node >= amd_nb_num())
+		return;
+
 	if (!l3_caches[node].nb) {
 		l3_caches[node].nb = node_to_amd_nb(node);
 		amd_calc_l3_indices(&l3_caches[node]);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f548cb..f4b93de 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -66,6 +66,7 @@
 #include <asm/apic.h>
 #include <asm/io_apic.h>
 #include <asm/setup.h>
+#include <asm/numachip/numachip.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
 
@@ -513,7 +514,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 	return (send_status | accept_status);
 }
 
-static int __cpuinit
+int __cpuinit
 wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
@@ -1094,6 +1095,9 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	print_cpu_info(&cpu_data(0));
 	x86_init.timers.setup_percpu_clockev();
 
+	if (is_numachip_system())
+		numachip_system_init();
+
 	if (is_uv_system())
 		uv_system_init();
 
-- 
1.7.5.4

