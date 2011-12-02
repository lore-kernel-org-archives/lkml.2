Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab1LBScA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:32:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49665 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1LBSb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:31:59 -0500
Message-ID: <4ED9199A.3060108@numascale-asia.com>
Date: Fri, 02 Dec 2011 18:31:54 +0000
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steffen Persvold <sp@numascale.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/3] Add multi-node boot support
References: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com> <1319609230-18897-2-git-send-email-daniel@numascale-asia.com> <20111027073029.GD15923@elte.hu> <4EA93699.9000101@numascale.com> <20111027113819.GA19682@elte.hu>
In-Reply-To: <20111027113819.GA19682@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------010403040301020808040403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010403040301020808040403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 27/10/2011 12:38, Ingo Molnar wrote:
> * Steffen Persvold<sp@numascale.com>  wrote:
>
>>> If it's absolutely needed then add a proper quirk handler instead
>>> of polluting the generic code.
>> We wanted to reuse as much of the generic AMD code as possible, but
>> it's tricky because most of that code is based around a single HT
>> fabric design, whereas a NumaChip based systems consists of several
>> HT fabrics connected together thus you will have identical
>> NorthBridge IDs (0-7) etc. shared between all systems.
>>
>> How would you suggest we add a quirk handler for it ?
> So what we want on NumaChip systems is for the node ID in the BIOS
> SRAT table to override the node ID that is read from the hardware,
> right?
>
> Instead of making it a is_numachip_system() thing it would be better
> to detect that the two do not match, and override it if the platform
> says that we should override it - and warn about the mismatch
> otherwise.
>
> Whether to override could be a new srat_override() function in the
> x86_init structure or so.
>
> Thomas, Peter, what do you think?

I've attached the updated patch series to show this approach. Tested 
against 3.2-rc3 with and without Numaconnect on x86-64 and includes 
updates from all previous feedback.

Since the struct x86_init is marked __init, and srat_detect_node() is 
marked __cpuinit, would be it better to add an x86_cpu_init structure 
with appropriate annotation or otherwise?

Thanks,
   Daniel

-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia


--------------010403040301020808040403
Content-Type: text/x-patch;
 name="0001-Make-flat_init_apic_ldr_available.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Make-flat_init_apic_ldr_available.patch"

>From eb60eb6957983599ea8fddd7d626bc5955cf26a9 Mon Sep 17 00:00:00 2001
From: Daniel J Blueman <daniel@numascale-asia.com>
Date: Fri, 2 Dec 2011 17:17:19 +0000
Subject: [PATCH 1/3] Make flat_init_apic_ldr available for reuse

Allow flat_init_apic_ldr() to be used outside the compilation unit for
similar APIC implementations.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/apic_flat_64.h |    7 +++++++
 arch/x86/kernel/apic/apic_flat_64.c |    2 +-
 2 files changed, 8 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/apic_flat_64.h

diff --git a/arch/x86/include/asm/apic_flat_64.h b/arch/x86/include/asm/apic_flat_64.h
new file mode 100644
index 0000000..a2d3127
--- /dev/null
+++ b/arch/x86/include/asm/apic_flat_64.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_X86_APIC_FLAT_64_H
+#define _ASM_X86_APIC_FLAT_64_H
+
+extern void flat_init_apic_ldr(void);
+
+#endif
+
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index f7a41e4..57c1f41 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -62,7 +62,7 @@ static void flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
  * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
  * document number 292116).  So here it goes...
  */
-static void flat_init_apic_ldr(void)
+void flat_init_apic_ldr(void)
 {
 	unsigned long val;
 	unsigned long num, id;
-- 
1.7.5.4


--------------010403040301020808040403
Content-Type: text/x-patch;
 name="0002-x86_init-core-numbering.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-x86_init-core-numbering.patch"

>From db09b17c79d7447b42a6807c5624e7ba6cdb0d72 Mon Sep 17 00:00:00 2001
From: Daniel J Blueman <daniel@numascale-asia.com>
Date: Fri, 2 Dec 2011 17:17:48 +0000
Subject: [PATCH 2/3] Add x86_init platform override to fix up core numbering

Add an x86_init vector for handling inconsistent core numbering. This is
useful for multi-fabric platforms, such as NumaScale Numaconnect.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/cpu/amd.c       |   11 +++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 1971e65..bb5fedb 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -7,6 +7,7 @@
 struct mpc_bus;
 struct mpc_cpu;
 struct mpc_table;
+struct cpuinfo_x86;
 
 /**
  * struct x86_init_mpparse - platform specific mpparse ops
@@ -23,6 +24,7 @@ struct x86_init_mpparse {
 	void (*mpc_record)(unsigned int mode);
 	void (*setup_ioapic_ids)(void);
 	int (*mpc_apic_id)(struct mpc_cpu *m);
+	void (*fixup_cpu_id)(struct cpuinfo_x86 *c, int node);
 	void (*smp_read_mpc_oem)(struct mpc_table *mpc);
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c7e46cb..6fb2345 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -353,6 +353,17 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 	if (node == NUMA_NO_NODE)
 		node = per_cpu(cpu_llc_id, cpu);
 
+	/*
+	 * If core numbers are inconsistent, it's likely a multi-fabric platform,
+	 * so invoke platform-specific handler
+	 */
+	if (c->phys_proc_id != node) {
+		if (x86_init.mpparse.fixup_cpu_id)
+			x86_init.mpparse.fixup_cpu_id(c, node);
+		else
+			pr_warning("NUMA core number %d differs from HT core number %d\n", node, c->phys_proc_id);
+	}
+
 	if (!node_online(node)) {
 		/*
 		 * Two possibilities here:
-- 
1.7.5.4


--------------010403040301020808040403
Content-Type: text/x-patch;
 name="0003-NumaChip-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-NumaChip-support.patch"

>From cf7fe3d00c14f9cd8f57bb94df5532c35fe0eac9 Mon Sep 17 00:00:00 2001
From: Steffen Persvold <sp@numascale.com>
Date: Fri, 2 Dec 2011 17:20:22 +0000
Subject: [PATCH 3/3] Add support for Numascale NumaChip

Add support for Numascale's NumaChip.

v2:
 - [Steffen] enumerate only accessible northbridges
 - [Daniel] rediffed and validated against 3.1-rc10
 
v3:
 - [Daniel] use x86_init core numbering override
 - [Daniel] cleanups as per feedback

Signed-off-by: Steffen Persvold <sp@numascale.com>
Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/Kconfig                             |   12 +
 arch/x86/include/asm/numachip/numachip_csr.h |  167 ++++++++++++++
 arch/x86/kernel/apic/Makefile                |    1 +
 arch/x86/kernel/apic/apic_numachip.c         |  312 ++++++++++++++++++++++++++
 4 files changed, 492 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/numachip/numachip_csr.h
 create mode 100644 arch/x86/kernel/apic/apic_numachip.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cb9a104..e67965a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -343,6 +343,7 @@ config X86_EXTENDED_PLATFORM
 
 	  If you enable this option then you'll be able to select support
 	  for the following (non-PC) 64 bit x86 platforms:
+		Numascale NumaChip
 		ScaleMP vSMP
 		SGI Ultraviolet
 
@@ -351,6 +352,17 @@ config X86_EXTENDED_PLATFORM
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
diff --git a/arch/x86/include/asm/numachip/numachip_csr.h b/arch/x86/include/asm/numachip/numachip_csr.h
new file mode 100644
index 0000000..660f843
--- /dev/null
+++ b/arch/x86/include/asm/numachip/numachip_csr.h
@@ -0,0 +1,167 @@
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
+#define CSR_NODE_SHIFT		16
+#define CSR_NODE_BITS(p)	(((unsigned long)(p)) << CSR_NODE_SHIFT)
+#define CSR_NODE_MASK		0x0fff		/* 4K nodes */
+
+/* 32K CSR space, b15 indicates geo/non-geo */
+#define CSR_OFFSET_MASK	0x7fffUL
+
+/* Global CSR space covers all 4K possible nodes with 64K CSR space per node */
+#define NUMACHIP_GCSR_BASE	0x3fff00000000ULL
+#define NUMACHIP_GCSR_LIM	0x3fff0fffffffULL
+#define NUMACHIP_GCSR_SIZE	(NUMACHIP_GCSR_LIM - NUMACHIP_GCSR_BASE + 1)
+
+/*
+ * Local CSR space starts in global CSR space with "nodeid" = 0xfff0, however
+ * when using the direct mapping on x86_64, both start and size needs to be
+ * aligned with PMD_SIZE which is 2M
+ */
+#define NUMACHIP_LCSR_BASE	0x3ffffe000000ULL
+#define NUMACHIP_LCSR_LIM	0x3fffffffffffULL
+#define NUMACHIP_LCSR_SIZE	(NUMACHIP_LCSR_LIM - NUMACHIP_LCSR_BASE + 1)
+
+static inline void *gcsr_address(int node, unsigned long offset)
+{
+	return __va(NUMACHIP_GCSR_BASE | (1UL << 15) |
+		CSR_NODE_BITS(node & CSR_NODE_MASK) | (offset & CSR_OFFSET_MASK));
+}
+
+static inline void *lcsr_address(unsigned long offset)
+{
+	return __va(NUMACHIP_LCSR_BASE | (1UL << 15) |
+		CSR_NODE_BITS(0xfff0) | (offset & CSR_OFFSET_MASK));
+}
+
+static inline unsigned int read_gcsr(int node, unsigned long offset)
+{
+	return swab32(readl(gcsr_address(node, offset)));
+}
+
+static inline void write_gcsr(int node, unsigned long offset, unsigned int val)
+{
+	writel(swab32(val), gcsr_address(node, offset));
+}
+
+static inline unsigned int read_lcsr(unsigned long offset)
+{
+	return swab32(readl(lcsr_address(offset)));
+}
+
+static inline void write_lcsr(unsigned long offset, unsigned int val)
+{
+	writel(swab32(val), lcsr_address(offset));
+}
+
+/* ========================================================================= */
+/*                   CSR_G0_STATE_CLEAR                                      */
+/* ========================================================================= */
+
+#define CSR_G0_STATE_CLEAR (0x000 + (0 << 12))
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
+/*                   CSR_G0_NODE_IDS                                         */
+/* ========================================================================= */
+
+#define CSR_G0_NODE_IDS (0x008 + (0 << 12))
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
+/*                   CSR_G3_EXT_IRQ_GEN                                      */
+/* ========================================================================= */
+
+#define CSR_G3_EXT_IRQ_GEN (0x030 + (3 << 12))
+union numachip_csr_g3_ext_irq_gen {
+	unsigned int v;
+	struct numachip_csr_g3_ext_irq_gen_s {
+		unsigned int _vector:8;
+		unsigned int _msgtype:3;
+		unsigned int _index:5;
+		unsigned int _destination_apic_id:16;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   CSR_G3_EXT_IRQ_STATUS                                   */
+/* ========================================================================= */
+
+#define CSR_G3_EXT_IRQ_STATUS (0x034 + (3 << 12))
+union numachip_csr_g3_ext_irq_status {
+	unsigned int v;
+	struct numachip_csr_g3_ext_irq_status_s {
+		unsigned int _result:32;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   CSR_G3_EXT_IRQ_DEST                                     */
+/* ========================================================================= */
+
+#define CSR_G3_EXT_IRQ_DEST (0x038 + (3 << 12))
+union numachip_csr_g3_ext_irq_dest {
+	unsigned int v;
+	struct numachip_csr_g3_ext_irq_dest_s {
+		unsigned int _irq:8;
+		unsigned int _rsvd_8_31:24;
+	} s;
+};
+
+/* ========================================================================= */
+/*                   CSR_G3_NC_ATT_MAP_SELECT                                */
+/* ========================================================================= */
+
+#define CSR_G3_NC_ATT_MAP_SELECT (0x7fc + (3 << 12))
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
+/*                   CSR_G3_NC_ATT_MAP_SELECT_0-255                          */
+/* ========================================================================= */
+
+#define CSR_G3_NC_ATT_MAP_SELECT_0 (0x800 + (3 << 12))
+
+#endif /* _ASM_X86_NUMACHIP_NUMACHIP_CSR_H */
+
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
index 0000000..5d1da04
--- /dev/null
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -0,0 +1,312 @@
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
+#include <asm/numachip/numachip_csr.h>
+#include <asm/smp.h>
+#include <asm/apic.h>
+#include <asm/ipi.h>
+#include <asm/apic_flat_64.h>
+
+static int numachip_system;
+
+static struct apic apic_numachip;
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
+static int __cpuinit numachip_wakeup_secondary(int phys_apicid, unsigned long start_rip)
+{
+#ifdef CONFIG_SMP
+	union numachip_csr_g3_ext_irq_gen int_gen;
+	unsigned long flags;
+
+	int_gen.s._destination_apic_id = phys_apicid;
+	int_gen.s._vector = 0;
+	int_gen.s._msgtype = APIC_DM_INIT >> 8;
+	int_gen.s._index = 0;
+
+	local_irq_save(flags);
+	write_lcsr(CSR_G3_EXT_IRQ_GEN, int_gen.v);
+	local_irq_restore(flags);
+
+	mdelay(10);
+
+	int_gen.s._msgtype = APIC_DM_STARTUP >> 8;
+	int_gen.s._vector = start_rip >> 12;
+
+	local_irq_save(flags);
+	write_lcsr(CSR_G3_EXT_IRQ_GEN, int_gen.v);
+	local_irq_restore(flags);
+
+	atomic_set(&init_deasserted, 1);
+#endif
+	return 0;
+}
+
+static void numachip_send_IPI_one(int cpu, int vector)
+{
+	union numachip_csr_g3_ext_irq_gen int_gen;
+	int apicid = per_cpu(x86_cpu_to_apicid, cpu);
+
+	int_gen.s._destination_apic_id = apicid;
+	int_gen.s._vector = vector;
+	int_gen.s._msgtype = (vector == NMI_VECTOR ? APIC_DM_NMI : APIC_DM_FIXED) >> 8;
+	int_gen.s._index = 0;
+
+	write_lcsr(CSR_G3_EXT_IRQ_GEN, int_gen.v);
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
+	if (likely((unsigned)cpu < nr_cpu_ids))
+		return per_cpu(x86_cpu_to_apicid, cpu);
+
+	return BAD_APICID;
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
+static void __init map_csrs(void)
+{
+	printk(KERN_INFO "NumaChip: Mapping local CSR space (%016llx - %016llx)\n",
+		NUMACHIP_LCSR_BASE, NUMACHIP_LCSR_BASE + NUMACHIP_LCSR_SIZE - 1);
+	init_extra_mapping_uc(NUMACHIP_LCSR_BASE, NUMACHIP_LCSR_SIZE);
+
+	printk(KERN_INFO "NumaChip: Mapping global CSR space (%016llx - %016llx)\n",
+		NUMACHIP_GCSR_BASE, NUMACHIP_GCSR_BASE + NUMACHIP_GCSR_SIZE - 1);
+	init_extra_mapping_uc(NUMACHIP_GCSR_BASE, NUMACHIP_GCSR_SIZE);
+}
+
+static void fixup_cpu_id(struct cpuinfo_x86 *c, int node)
+{
+	c->phys_proc_id = node;
+	per_cpu(cpu_llc_id, smp_processor_id()) = node;
+}
+
+static int __init numachip_system_init(void)
+{
+	unsigned int val;
+
+	if (!numachip_system)
+		return 0;
+
+	x86_init.mpparse.fixup_cpu_id = fixup_cpu_id;
+
+	map_csrs();
+
+	val = read_lcsr(CSR_G0_NODE_IDS);
+	printk(KERN_INFO "NumaChip: Local NodeID = %08x\n", val);
+
+	return 0;
+}
+early_initcall(numachip_system_init);
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
+	.init_apic_ldr			= flat_init_apic_ldr,
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
+apic_driver(apic_numachip);
+
-- 
1.7.5.4


--------------010403040301020808040403--
