Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab0KROIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:08:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:41282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758106Ab0KROIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:08:05 -0500
Date: Thu, 18 Nov 2010 14:07:41 GMT
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20101116222352.GA8155@sgi.com>
References: <20101116222352.GA8155@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: UV: Address interrupt/IO port operation conflict
Message-ID: <tip-8191c9f69202d4dbc66063cb92059b8a58640d34@git.kernel.org>
Git-Commit-ID: 8191c9f69202d4dbc66063cb92059b8a58640d34
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:07:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8191c9f69202d4dbc66063cb92059b8a58640d34
Gitweb:     http://git.kernel.org/tip/8191c9f69202d4dbc66063cb92059b8a58640d34
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Tue, 16 Nov 2010 16:23:52 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 10:41:25 +0100

x86: UV: Address interrupt/IO port operation conflict

This patch for SGI UV systems addresses a problem whereby
interrupt transactions being looped back from a local IOH,
through the hub to a local CPU can (erroneously) conflict with
IO port operations and other transactions.

To workaound this we set a high bit in the APIC IDs used for
interrupts. This bit appears to be ignored by the sockets, but
it avoids the conflict in the hub.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
LKML-Reference: <20101116222352.GA8155@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
___

 arch/x86/include/asm/uv/uv_hub.h   |    4 ++++
 arch/x86/include/asm/uv/uv_mmrs.h  |   19 ++++++++++++++++++-
 arch/x86/kernel/apic/x2apic_uv_x.c |   25 +++++++++++++++++++++++--
 arch/x86/platform/uv/tlb_uv.c      |    2 +-
 arch/x86/platform/uv/uv_time.c     |    4 +++-
 5 files changed, 49 insertions(+), 5 deletions(-)
---
 arch/x86/include/asm/uv/uv_hub.h   |    4 ++++
 arch/x86/include/asm/uv/uv_mmrs.h  |   19 ++++++++++++++++++-
 arch/x86/kernel/apic/x2apic_uv_x.c |   25 +++++++++++++++++++++++--
 arch/x86/platform/uv/tlb_uv.c      |    2 +-
 arch/x86/platform/uv/uv_time.c     |    4 +++-
 5 files changed, 49 insertions(+), 5 deletions(-)

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
