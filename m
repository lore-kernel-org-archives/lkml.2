Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab0KZN2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:28:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59226 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab0KZN2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:28:50 -0500
Date: Fri, 26 Nov 2010 14:27:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20101126132725.GA19773@elte.hu>
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
include/linux/dmar.h               # 4917b28: dmar, x86: Use function stubs whe

 Thanks,

	Ingo

------------------>
Dimitri Sivanich (1):
      x86: UV: Address interrupt/IO port operation conflict

Jan Beulich (1):
      x86-64: Fix and clean up AMD Fam10 MMCONF enabling

Randy Dunlap (1):
      dmar, x86: Use function stubs when CONFIG_INTR_REMAP is disabled

Tetsuo Handa (1):
      x86, asm: Fix binutils 2.15 build failure

Yinghai Lu (1):
      x86: Use online node real index in calulate_tbl_offset()


 arch/x86/include/asm/msr-index.h   |    2 +-
 arch/x86/include/asm/uv/uv_hub.h   |    4 ++
 arch/x86/include/asm/uv/uv_mmrs.h  |   19 ++++++++++-
 arch/x86/kernel/apic/x2apic_uv_x.c |   25 +++++++++++++-
 arch/x86/kernel/entry_32.S         |    2 +-
 arch/x86/kernel/mmconf-fam10h_64.c |   64 +++++++++++++++++-------------------
 arch/x86/mm/tlb.c                  |    5 ++-
 arch/x86/platform/uv/tlb_uv.c      |    2 +-
 arch/x86/platform/uv/uv_time.c     |    4 ++-
 include/linux/dmar.h               |   17 ++++++++--
 10 files changed, 98 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3ea3dc4..6b89f5e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -128,7 +128,7 @@
 #define FAM10H_MMIO_CONF_ENABLE		(1<<0)
 #define FAM10H_MMIO_CONF_BUSRANGE_MASK	0xf
 #define FAM10H_MMIO_CONF_BUSRANGE_SHIFT 2
-#define FAM10H_MMIO_CONF_BASE_MASK	0xfffffff
+#define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
 
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index e969f69..a501741 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -199,6 +199,8 @@ union uvh_apicid {
 #define UVH_APICID		0x002D0E00L
 #define UV_APIC_PNODE_SHIFT	6
 
+#define UV_APICID_HIBIT_MASK	0xffff0000
+
 /* Local Bus from cpu's perspective */
 #define LOCAL_BUS_BASE		0x1c00000
 #define LOCAL_BUS_SIZE		(4 * 1024 * 1024)
@@ -491,8 +493,10 @@ static inline void uv_set_cpu_scir_bits(int cpu, unsigned char value)
 	}
 }
 
+extern unsigned int uv_apicid_hibits;
 static unsigned long uv_hub_ipi_value(int apicid, int vector, int mode)
 {
+	apicid |= uv_apicid_hibits;
 	return (1UL << UVH_IPI_INT_SEND_SHFT) |
 			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
 			(mode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index 6d90adf..20cafea 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -5,7 +5,7 @@
  *
  * SGI UV MMR definitions
  *
- * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2010 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_MMRS_H
@@ -754,6 +754,23 @@ union uvh_lb_bau_sb_descriptor_base_u {
 };
 
 /* ========================================================================= */
+/*                   UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK                     */
+/* ========================================================================= */
+#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK 0x320130UL
+#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK_32 0x009f0
+
+#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_SHFT 0
+#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_MASK 0x00000000ffffffffUL
+
+union uvh_lb_target_physical_apic_id_mask_u {
+	unsigned long v;
+	struct uvh_lb_target_physical_apic_id_mask_s {
+		unsigned long bit_enables : 32;  /* RW */
+		unsigned long rsvd_32_63  : 32;  /*    */
+	} s;
+};
+
+/* ========================================================================= */
 /*                               UVH_NODE_ID                                 */
 /* ========================================================================= */
 #define UVH_NODE_ID 0x0UL
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 194539a..c1c52c3 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -44,6 +44,8 @@ static u64 gru_start_paddr, gru_end_paddr;
 static union uvh_apicid uvh_apicid;
 int uv_min_hub_revision_id;
 EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
+unsigned int uv_apicid_hibits;
+EXPORT_SYMBOL_GPL(uv_apicid_hibits);
 static DEFINE_SPINLOCK(uv_nmi_lock);
 
 static inline bool is_GRU_range(u64 start, u64 end)
@@ -85,6 +87,23 @@ static void __init early_get_apic_pnode_shift(void)
 		uvh_apicid.s.pnode_shift = UV_APIC_PNODE_SHIFT;
 }
 
+/*
+ * Add an extra bit as dictated by bios to the destination apicid of
+ * interrupts potentially passing through the UV HUB.  This prevents
+ * a deadlock between interrupts and IO port operations.
+ */
+static void __init uv_set_apicid_hibit(void)
+{
+	union uvh_lb_target_physical_apic_id_mask_u apicid_mask;
+	unsigned long *mmr;
+
+	mmr = early_ioremap(UV_LOCAL_MMR_BASE |
+		UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK, sizeof(*mmr));
+	apicid_mask.v = *mmr;
+	early_iounmap(mmr, sizeof(*mmr));
+	uv_apicid_hibits = apicid_mask.s.bit_enables & UV_APICID_HIBIT_MASK;
+}
+
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	int nodeid;
@@ -102,6 +121,7 @@ static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 			__get_cpu_var(x2apic_extra_bits) =
 				nodeid << (uvh_apicid.s.pnode_shift - 1);
 			uv_system_type = UV_NON_UNIQUE_APIC;
+			uv_set_apicid_hibit();
 			return 1;
 		}
 	}
@@ -155,6 +175,7 @@ static int __cpuinit uv_wakeup_secondary(int phys_apicid, unsigned long start_ri
 	int pnode;
 
 	pnode = uv_apicid_to_pnode(phys_apicid);
+	phys_apicid |= uv_apicid_hibits;
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
 	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
@@ -236,7 +257,7 @@ static unsigned int uv_cpu_mask_to_apicid(const struct cpumask *cpumask)
 	int cpu = cpumask_first(cpumask);
 
 	if ((unsigned)cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
+		return per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
 	else
 		return BAD_APICID;
 }
@@ -255,7 +276,7 @@ uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	}
-	return per_cpu(x86_cpu_to_apicid, cpu);
+	return per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
 }
 
 static unsigned int x2apic_get_apic_id(unsigned long x)
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 59e175e..591e601 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -395,7 +395,7 @@ sysenter_past_esp:
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
-	pushl_cfi (TI_sysenter_return-THREAD_SIZE_asm+8+4*4)(%esp)
+	pushl_cfi ((TI_sysenter_return)-THREAD_SIZE_asm+8+4*4)(%esp)
 	CFI_REL_OFFSET eip, 0
 
 	pushl_cfi %eax
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index 6da143c..ac861b8 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -25,7 +25,6 @@ struct pci_hostbridge_probe {
 };
 
 static u64 __cpuinitdata fam10h_pci_mmconf_base;
-static int __cpuinitdata fam10h_pci_mmconf_base_status;
 
 static struct pci_hostbridge_probe pci_probes[] __cpuinitdata = {
 	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
@@ -44,10 +43,12 @@ static int __cpuinit cmp_range(const void *x1, const void *x2)
 	return start1 - start2;
 }
 
-/*[47:0] */
-/* need to avoid (0xfd<<32) and (0xfe<<32), ht used space */
+#define MMCONF_UNIT (1ULL << FAM10H_MMIO_CONF_BASE_SHIFT)
+#define MMCONF_MASK (~(MMCONF_UNIT - 1))
+#define MMCONF_SIZE (MMCONF_UNIT << 8)
+/* need to avoid (0xfd<<32), (0xfe<<32), and (0xff<<32), ht used space */
 #define FAM10H_PCI_MMCONF_BASE (0xfcULL<<32)
-#define BASE_VALID(b) ((b != (0xfdULL << 32)) && (b != (0xfeULL << 32)))
+#define BASE_VALID(b) ((b) + MMCONF_SIZE <= (0xfdULL<<32) || (b) >= (1ULL<<40))
 static void __cpuinit get_fam10h_pci_mmconf_base(void)
 {
 	int i;
@@ -64,12 +65,11 @@ static void __cpuinit get_fam10h_pci_mmconf_base(void)
 	struct range range[8];
 
 	/* only try to get setting from BSP */
-	/* -1 or 1 */
-	if (fam10h_pci_mmconf_base_status)
+	if (fam10h_pci_mmconf_base)
 		return;
 
 	if (!early_pci_allowed())
-		goto fail;
+		return;
 
 	found = 0;
 	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
@@ -91,7 +91,7 @@ static void __cpuinit get_fam10h_pci_mmconf_base(void)
 	}
 
 	if (!found)
-		goto fail;
+		return;
 
 	/* SYS_CFG */
 	address = MSR_K8_SYSCFG;
@@ -99,16 +99,16 @@ static void __cpuinit get_fam10h_pci_mmconf_base(void)
 
 	/* TOP_MEM2 is not enabled? */
 	if (!(val & (1<<21))) {
-		tom2 = 0;
+		tom2 = 1ULL << 32;
 	} else {
 		/* TOP_MEM2 */
 		address = MSR_K8_TOP_MEM2;
 		rdmsrl(address, val);
-		tom2 = val & (0xffffULL<<32);
+		tom2 = max(val & 0xffffff800000ULL, 1ULL << 32);
 	}
 
 	if (base <= tom2)
-		base = tom2 + (1ULL<<32);
+		base = (tom2 + 2 * MMCONF_UNIT - 1) & MMCONF_MASK;
 
 	/*
 	 * need to check if the range is in the high mmio range that is
@@ -123,11 +123,11 @@ static void __cpuinit get_fam10h_pci_mmconf_base(void)
 		if (!(reg & 3))
 			continue;
 
-		start = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
+		start = (u64)(reg & 0xffffff00) << 8; /* 39:16 on 31:8*/
 		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
-		end = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
+		end = ((u64)(reg & 0xffffff00) << 8) | 0xffff; /* 39:16 on 31:8*/
 
-		if (!end)
+		if (end < tom2)
 			continue;
 
 		range[hi_mmio_num].start = start;
@@ -143,32 +143,27 @@ static void __cpuinit get_fam10h_pci_mmconf_base(void)
 
 	if (range[hi_mmio_num - 1].end < base)
 		goto out;
-	if (range[0].start > base)
+	if (range[0].start > base + MMCONF_SIZE)
 		goto out;
 
 	/* need to find one window */
-	base = range[0].start - (1ULL << 32);
+	base = (range[0].start & MMCONF_MASK) - MMCONF_UNIT;
 	if ((base > tom2) && BASE_VALID(base))
 		goto out;
-	base = range[hi_mmio_num - 1].end + (1ULL << 32);
-	if ((base > tom2) && BASE_VALID(base))
+	base = (range[hi_mmio_num - 1].end + MMCONF_UNIT) & MMCONF_MASK;
+	if (BASE_VALID(base))
 		goto out;
 	/* need to find window between ranges */
-	if (hi_mmio_num > 1)
-	for (i = 0; i < hi_mmio_num - 1; i++) {
-		if (range[i + 1].start > (range[i].end + (1ULL << 32))) {
-			base = range[i].end + (1ULL << 32);
-			if ((base > tom2) && BASE_VALID(base))
-				goto out;
-		}
+	for (i = 1; i < hi_mmio_num; i++) {
+		base = (range[i - 1].end + MMCONF_UNIT) & MMCONF_MASK;
+		val = range[i].start & MMCONF_MASK;
+		if (val >= base + MMCONF_SIZE && BASE_VALID(base))
+			goto out;
 	}
-
-fail:
-	fam10h_pci_mmconf_base_status = -1;
 	return;
+
 out:
 	fam10h_pci_mmconf_base = base;
-	fam10h_pci_mmconf_base_status = 1;
 }
 
 void __cpuinit fam10h_check_enable_mmcfg(void)
@@ -190,11 +185,10 @@ void __cpuinit fam10h_check_enable_mmcfg(void)
 
 		/* only trust the one handle 256 buses, if acpi=off */
 		if (!acpi_pci_disabled || busnbits >= 8) {
-			u64 base;
-			base = val & (0xffffULL << 32);
-			if (fam10h_pci_mmconf_base_status <= 0) {
+			u64 base = val & MMCONF_MASK;
+
+			if (!fam10h_pci_mmconf_base) {
 				fam10h_pci_mmconf_base = base;
-				fam10h_pci_mmconf_base_status = 1;
 				return;
 			} else if (fam10h_pci_mmconf_base ==  base)
 				return;
@@ -206,8 +200,10 @@ void __cpuinit fam10h_check_enable_mmcfg(void)
 	 * with 256 buses
 	 */
 	get_fam10h_pci_mmconf_base();
-	if (fam10h_pci_mmconf_base_status <= 0)
+	if (!fam10h_pci_mmconf_base) {
+		pci_probe &= ~PCI_CHECK_ENABLE_AMD_MMCONF;
 		return;
+	}
 
 	printk(KERN_INFO "Enable MMCONFIG on AMD Family 10h\n");
 	val &= ~((FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT) |
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 12cdbb1..6acc724 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -223,7 +223,7 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 
 static void __cpuinit calculate_tlb_offset(void)
 {
-	int cpu, node, nr_node_vecs;
+	int cpu, node, nr_node_vecs, idx = 0;
 	/*
 	 * we are changing tlb_vector_offset for each CPU in runtime, but this
 	 * will not cause inconsistency, as the write is atomic under X86. we
@@ -239,7 +239,7 @@ static void __cpuinit calculate_tlb_offset(void)
 		nr_node_vecs = NUM_INVALIDATE_TLB_VECTORS/nr_online_nodes;
 
 	for_each_online_node(node) {
-		int node_offset = (node % NUM_INVALIDATE_TLB_VECTORS) *
+		int node_offset = (idx % NUM_INVALIDATE_TLB_VECTORS) *
 			nr_node_vecs;
 		int cpu_offset = 0;
 		for_each_cpu(cpu, cpumask_of_node(node)) {
@@ -248,6 +248,7 @@ static void __cpuinit calculate_tlb_offset(void)
 			cpu_offset++;
 			cpu_offset = cpu_offset % nr_node_vecs;
 		}
+		idx++;
 	}
 }
 
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index a318194..ba9caa8 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1455,7 +1455,7 @@ static void __init uv_init_uvhub(int uvhub, int vector)
 	 * the below initialization can't be in firmware because the
 	 * messaging IRQ will be determined by the OS
 	 */
-	apicid = uvhub_to_first_apicid(uvhub);
+	apicid = uvhub_to_first_apicid(uvhub) | uv_apicid_hibits;
 	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
 				      ((apicid << 32) | vector));
 }
diff --git a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
index 56e421b..9daf5d1 100644
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
@@ -89,6 +89,7 @@ static void uv_rtc_send_IPI(int cpu)
 
 	apicid = cpu_physical_id(cpu);
 	pnode = uv_apicid_to_pnode(apicid);
+	apicid |= uv_apicid_hibits;
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	      (apicid << UVH_IPI_INT_APIC_ID_SHFT) |
 	      (X86_PLATFORM_IPI_VECTOR << UVH_IPI_INT_VECTOR_SHFT);
@@ -107,6 +108,7 @@ static int uv_intr_pending(int pnode)
 static int uv_setup_intr(int cpu, u64 expires)
 {
 	u64 val;
+	unsigned long apicid = cpu_physical_id(cpu) | uv_apicid_hibits;
 	int pnode = uv_cpu_to_pnode(cpu);
 
 	uv_write_global_mmr64(pnode, UVH_RTC1_INT_CONFIG,
@@ -117,7 +119,7 @@ static int uv_setup_intr(int cpu, u64 expires)
 		UVH_EVENT_OCCURRED0_RTC1_MASK);
 
 	val = (X86_PLATFORM_IPI_VECTOR << UVH_RTC1_INT_CONFIG_VECTOR_SHFT) |
-		((u64)cpu_physical_id(cpu) << UVH_RTC1_INT_CONFIG_APIC_ID_SHFT);
+		((u64)apicid << UVH_RTC1_INT_CONFIG_APIC_ID_SHFT);
 
 	/* Set configuration */
 	uv_write_global_mmr64(pnode, UVH_RTC1_INT_CONFIG, val);
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index a7d9dc2..7b776d7 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -175,10 +175,21 @@ static inline int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 	return 0;
 }
 
-#define enable_intr_remapping(mode)	(-1)
-#define disable_intr_remapping()	(0)
-#define reenable_intr_remapping(mode)	(0)
 #define intr_remapping_enabled		(0)
+
+static inline int enable_intr_remapping(int eim)
+{
+	return -1;
+}
+
+static inline void disable_intr_remapping(void)
+{
+}
+
+static inline int reenable_intr_remapping(int eim)
+{
+	return 0;
+}
 #endif
 
 /* Can't use the common MSI interrupt functions
