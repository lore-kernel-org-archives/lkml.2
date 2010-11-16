Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab0KPWX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:23:56 -0500
Received: from relay1.sgi.com ([192.48.179.29]:37263 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab0KPWXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:23:55 -0500
Date: Tue, 16 Nov 2010 16:23:52 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86 UV: Address interrupt/IO port operation conflict
Message-ID: <20101116222352.GA8155@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for SGI UV systems addresses a problem whereby interrupt
transactions being looped back from a local IOH, through the hub to a
local CPU can (erroneously) conflict with IO port operations and other
transactions.

To workaound this we set a high bit in the APIC IDs used for interrupts.
This bit appears to be ignored by the sockets, but it avoids the
conflict in the hub.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
___

 arch/x86/include/asm/uv/uv_hub.h   |    4 ++++
 arch/x86/include/asm/uv/uv_mmrs.h  |   19 ++++++++++++++++++-
 arch/x86/kernel/apic/x2apic_uv_x.c |   25 +++++++++++++++++++++++--
 arch/x86/platform/uv/tlb_uv.c      |    2 +-
 arch/x86/platform/uv/uv_time.c     |    4 +++-
 5 files changed, 49 insertions(+), 5 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h
+++ linux/arch/x86/include/asm/uv/uv_hub.h
@@ -199,6 +199,8 @@ union uvh_apicid {
 #define UVH_APICID		0x002D0E00L
 #define UV_APIC_PNODE_SHIFT	6
 
+#define UV_APICID_HIBIT_MASK	0xffff0000
+
 /* Local Bus from cpu's perspective */
 #define LOCAL_BUS_BASE		0x1c00000
 #define LOCAL_BUS_SIZE		(4 * 1024 * 1024)
@@ -491,8 +493,10 @@ static inline void uv_set_cpu_scir_bits(
 	}
 }
 
+extern unsigned int uv_apicid_hibits;
 static unsigned long uv_hub_ipi_value(int apicid, int vector, int mode)
 {
+	apicid |= uv_apicid_hibits;
 	return (1UL << UVH_IPI_INT_SEND_SHFT) |
 			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
 			(mode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
Index: linux/arch/x86/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h
@@ -5,7 +5,7 @@
  *
  * SGI UV MMR definitions
  *
- * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2010 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_MMRS_H
@@ -753,6 +753,23 @@ union uvh_lb_bau_sb_descriptor_base_u {
     } s;
 };
 
+/* ========================================================================= */
+/*                   UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK                     */
+/* ========================================================================= */
+#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK 0x320130UL
+#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK_32 0x009f0
+
+#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_SHFT 0
+#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_MASK 0x00000000ffffffffUL
+
+union uvh_lb_target_physical_apic_id_mask_u {
+    unsigned long	v;
+    struct uvh_lb_target_physical_apic_id_mask_s {
+	unsigned long	bit_enables : 32;  /* RW */
+	unsigned long	rsvd_32_63  : 32;  /*    */
+    } s;
+};
+
 /* ========================================================================= */
 /*                               UVH_NODE_ID                                 */
 /* ========================================================================= */
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -44,6 +44,8 @@ static u64 gru_start_paddr, gru_end_padd
 static union uvh_apicid uvh_apicid;
 int uv_min_hub_revision_id;
 EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
+unsigned int uv_apicid_hibits;
+EXPORT_SYMBOL_GPL(uv_apicid_hibits);
 static DEFINE_SPINLOCK(uv_nmi_lock);
 
 static inline bool is_GRU_range(u64 start, u64 end)
@@ -85,6 +87,23 @@ static void __init early_get_apic_pnode_
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
@@ -102,6 +121,7 @@ static int __init uv_acpi_madt_oem_check
 			__get_cpu_var(x2apic_extra_bits) =
 				nodeid << (uvh_apicid.s.pnode_shift - 1);
 			uv_system_type = UV_NON_UNIQUE_APIC;
+			uv_set_apicid_hibit();
 			return 1;
 		}
 	}
@@ -155,6 +175,7 @@ static int __cpuinit uv_wakeup_secondary
 	int pnode;
 
 	pnode = uv_apicid_to_pnode(phys_apicid);
+	phys_apicid |= uv_apicid_hibits;
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
 	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
@@ -236,7 +257,7 @@ static unsigned int uv_cpu_mask_to_apici
 	int cpu = cpumask_first(cpumask);
 
 	if ((unsigned)cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
+		return per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
 	else
 		return BAD_APICID;
 }
@@ -255,7 +276,7 @@ uv_cpu_mask_to_apicid_and(const struct c
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	}
-	return per_cpu(x86_cpu_to_apicid, cpu);
+	return per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
 }
 
 static unsigned int x2apic_get_apic_id(unsigned long x)
Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1455,7 +1455,7 @@ static void __init uv_init_uvhub(int uvh
 	 * the below initialization can't be in firmware because the
 	 * messaging IRQ will be determined by the OS
 	 */
-	apicid = uvhub_to_first_apicid(uvhub);
+	apicid = uvhub_to_first_apicid(uvhub) | uv_apicid_hibits;
 	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
 				      ((apicid << 32) | vector));
 }
Index: linux/arch/x86/platform/uv/uv_time.c
===================================================================
--- linux.orig/arch/x86/platform/uv/uv_time.c
+++ linux/arch/x86/platform/uv/uv_time.c
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
@@ -117,7 +119,7 @@ static int uv_setup_intr(int cpu, u64 ex
 		UVH_EVENT_OCCURRED0_RTC1_MASK);
 
 	val = (X86_PLATFORM_IPI_VECTOR << UVH_RTC1_INT_CONFIG_VECTOR_SHFT) |
-		((u64)cpu_physical_id(cpu) << UVH_RTC1_INT_CONFIG_APIC_ID_SHFT);
+		((u64)apicid << UVH_RTC1_INT_CONFIG_APIC_ID_SHFT);
 
 	/* Set configuration */
 	uv_write_global_mmr64(pnode, UVH_RTC1_INT_CONFIG, val);
