Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab1EJTLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:11:15 -0400
Received: from relay3.sgi.com ([192.48.152.1]:38534 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751505Ab1EJTLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:11:13 -0400
Date: Tue, 10 May 2011 14:11:10 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: Support for SGI UV2 hub chip
Message-ID: <20110510191110.GA18052@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for a new version of the SGI UV hub chip.
The hub chip is the node controller that connects multiple
blades into a larger coherent SSI.

For the most part, UV2 is compatible with UV1. The majority of the
changes are in the addresses of MMRs and in a few cases, the contents
of MMRs. These changes are the result in changes in the system topology
such as node configuration, processor types, maximum nodes, physical
address sizes, etc.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/include/asm/uv/uv_bau.h   |   42 +
 arch/x86/include/asm/uv/uv_hub.h   |   67 +-
 arch/x86/include/asm/uv/uv_mmrs.h  | 1010 ++++++++++++++++++++++++++++++-------
 arch/x86/kernel/apic/x2apic_uv_x.c |   38 +
 arch/x86/platform/uv/tlb_uv.c      |  162 ++++-
 arch/x86/platform/uv/uv_time.c     |   16 
 6 files changed, 1074 insertions(+), 261 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_bau.h	2011-05-10 13:45:38.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_bau.h	2011-05-10 13:46:24.339167761 -0500
@@ -44,7 +44,10 @@
 #define UV_ACT_STATUS_SIZE		2
 #define UV_DISTRIBUTION_SIZE		256
 #define UV_SW_ACK_NPENDING		8
-#define UV_NET_ENDPOINT_INTD		0x38
+#define UV1_NET_ENDPOINT_INTD		0x38
+#define UV2_NET_ENDPOINT_INTD		0x28
+#define UV_NET_ENDPOINT_INTD		(is_uv1_hub() ?			\
+			UV1_NET_ENDPOINT_INTD : UV2_NET_ENDPOINT_INTD)
 #define UV_DESC_BASE_PNODE_SHIFT	49
 #define UV_PAYLOADQ_PNODE_SHIFT		49
 #define UV_PTC_BASENAME			"sgi_uv/ptc_statistics"
@@ -53,10 +56,22 @@
 #define UV_BAU_TUNABLES_FILE		"bau_tunables"
 #define WHITESPACE			" \t\n"
 #define uv_physnodeaddr(x)		((__pa((unsigned long)(x)) & uv_mmask))
-#define UV_ENABLE_INTD_SOFT_ACK_MODE_SHIFT 15
-#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHIFT 16
-#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD 0x0000000009UL
+
+
 /* [19:16] SOFT_ACK timeout period  19: 1 is urgency 7  17:16 1 is multiplier */
+/*
+ * UV2: Bit 19 selects between
+ *  (0): 10 microsecond timebase and
+ *  (1): 80 microseconds
+ *  we're using 655us, similar to UV1: 65 units of 10us
+ */
+#define UV1_INTD_SOFT_ACK_TIMEOUT_PERIOD (9UL)
+#define UV2_INTD_SOFT_ACK_TIMEOUT_PERIOD (65*10UL)
+
+#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD	(is_uv1_hub() ?			\
+		UV1_INTD_SOFT_ACK_TIMEOUT_PERIOD :			\
+		UV2_INTD_SOFT_ACK_TIMEOUT_PERIOD)
+
 #define BAU_MISC_CONTROL_MULT_MASK 3
 
 #define UVH_AGING_PRESCALE_SEL 0x000000b000UL
@@ -76,6 +91,16 @@
 #define DESC_STATUS_ACTIVE		1
 #define DESC_STATUS_DESTINATION_TIMEOUT	2
 #define DESC_STATUS_SOURCE_TIMEOUT	3
+/*
+ * bits put together from HRP_LB_BAU_SB_ACTIVATION_STATUS_0/1/2
+ * values 1 and 5 will not occur
+ */
+#define UV2H_DESC_IDLE			0
+#define UV2H_DESC_DEST_TIMEOUT		2
+#define UV2H_DESC_DEST_STRONG_NACK	3
+#define UV2H_DESC_BUSY			4
+#define UV2H_DESC_SOURCE_TIMEOUT	6
+#define UV2H_DESC_DEST_PUT_ERR		7
 
 /*
  * delay for 'plugged' timeout retries, in microseconds
@@ -96,6 +121,15 @@
 
 #define UV_LB_SUBNODEID 0x10
 
+/* these two are the same for UV1 and UV2: */
+#define UV_SA_SHFT UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT
+#define UV_SA_MASK UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_MASK
+/* 4 bits of software ack period */
+#define UV2_ACK_MASK 0x7UL
+#define UV2_ACK_UNITS_SHFT 3
+#define UV2_LEG_SHFT UV2H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_SHFT
+#define UV2_EXT_SHFT UV2H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_SHFT
+
 /*
  * number of entries in the destination side payload queue
  */
Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2011-05-10 13:45:37.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2011-05-10 13:45:46.379167663 -0500
@@ -77,8 +77,9 @@
  *
  *		1111110000000000
  *		5432109876543210
- *		pppppppppplc0cch	Nehalem-EX
- *		ppppppppplcc0cch	Westmere-EX
+ *		pppppppppplc0cch	Nehalem-EX (12 bits in hdw reg)
+ *		ppppppppplcc0cch	Westmere-EX (12 bits in hdw reg)
+ *		pppppppppppcccch	SandyBridge (15 bits in hdw reg)
  *		sssssssssss
  *
  *			p  = pnode bits
@@ -87,7 +88,7 @@
  *			h  = hyperthread
  *			s  = bits that are in the SOCKET_ID CSR
  *
- *	Note: Processor only supports 12 bits in the APICID register. The ACPI
+ *	Note: Processor may support fewer bits in the APICID register. The ACPI
  *	      tables hold all 16 bits. Software needs to be aware of this.
  *
  *	      Unless otherwise specified, all references to APICID refer to
@@ -138,6 +139,8 @@ struct uv_hub_info_s {
 	unsigned long		global_mmr_base;
 	unsigned long		gpa_mask;
 	unsigned int		gnode_extra;
+	unsigned char		hub_revision;
+	unsigned char		apic_pnode_shift;
 	unsigned long		gnode_upper;
 	unsigned long		lowmem_remap_top;
 	unsigned long		lowmem_remap_base;
@@ -149,13 +152,31 @@ struct uv_hub_info_s {
 	unsigned char		m_val;
 	unsigned char		n_val;
 	struct uv_scir_s	scir;
-	unsigned char		apic_pnode_shift;
 };
 
 DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define uv_hub_info		(&__get_cpu_var(__uv_hub_info))
 #define uv_cpu_hub_info(cpu)	(&per_cpu(__uv_hub_info, cpu))
 
+/*
+ * Hub revisions less than UV2_HUB_REVISION_BASE are UV1 hubs. All UV2
+ * hubs have revision numbers greater than or equal to UV2_HUB_REVISION_BASE.
+ * This is a software convention - NOT the hardware revision numbers in
+ * the hub chip.
+ */
+#define UV1_HUB_REVISION_BASE		1
+#define UV2_HUB_REVISION_BASE		3
+
+static inline int is_uv1_hub(void)
+{
+	return uv_hub_info->hub_revision < UV2_HUB_REVISION_BASE;
+}
+
+static inline int is_uv2_hub(void)
+{
+	return uv_hub_info->hub_revision >= UV2_HUB_REVISION_BASE;
+}
+
 union uvh_apicid {
     unsigned long       v;
     struct uvh_apicid_s {
@@ -180,11 +201,21 @@ union uvh_apicid {
 #define UV_PNODE_TO_GNODE(p)		((p) |uv_hub_info->gnode_extra)
 #define UV_PNODE_TO_NASID(p)		(UV_PNODE_TO_GNODE(p) << 1)
 
-#define UV_LOCAL_MMR_BASE		0xf4000000UL
-#define UV_GLOBAL_MMR32_BASE		0xf8000000UL
+#define UV1_LOCAL_MMR_BASE		0xf4000000UL
+#define UV1_GLOBAL_MMR32_BASE		0xf8000000UL
+#define UV1_LOCAL_MMR_SIZE		(64UL * 1024 * 1024)
+#define UV1_GLOBAL_MMR32_SIZE		(64UL * 1024 * 1024)
+
+#define UV2_LOCAL_MMR_BASE		0xfa000000UL
+#define UV2_GLOBAL_MMR32_BASE		0xfc000000UL
+#define UV2_LOCAL_MMR_SIZE		(32UL * 1024 * 1024)
+#define UV2_GLOBAL_MMR32_SIZE		(32UL * 1024 * 1024)
+
+#define UV_LOCAL_MMR_BASE		(is_uv1_hub() ? UV1_LOCAL_MMR_BASE : UV2_LOCAL_MMR_BASE)
+#define UV_GLOBAL_MMR32_BASE		(is_uv1_hub() ? UV1_GLOBAL_MMR32_BASE : UV2_GLOBAL_MMR32_BASE)
+#define UV_LOCAL_MMR_SIZE		(is_uv1_hub() ? UV1_LOCAL_MMR_SIZE : UV2_LOCAL_MMR_SIZE)
+#define UV_GLOBAL_MMR32_SIZE		(is_uv1_hub() ? UV1_GLOBAL_MMR32_SIZE : UV2_GLOBAL_MMR32_SIZE)
 #define UV_GLOBAL_MMR64_BASE		(uv_hub_info->global_mmr_base)
-#define UV_LOCAL_MMR_SIZE		(64UL * 1024 * 1024)
-#define UV_GLOBAL_MMR32_SIZE		(64UL * 1024 * 1024)
 
 #define UV_GLOBAL_GRU_MMR_BASE		0x4000000
 
@@ -301,6 +332,17 @@ static inline int uv_apicid_to_pnode(int
 }
 
 /*
+ * Convert an apicid to the socket number on the blade
+ */
+static inline int uv_apicid_to_socket(int apicid)
+{
+	if (is_uv1_hub())
+		return (apicid >> (uv_hub_info->apic_pnode_shift - 1)) & 1;
+	else
+		return 0;
+}
+
+/*
  * Access global MMRs using the low memory MMR32 space. This region supports
  * faster MMR access but not all MMRs are accessible in this space.
  */
@@ -519,14 +561,13 @@ static inline void uv_hub_send_ipi(int p
 
 /*
  * Get the minimum revision number of the hub chips within the partition.
- *     1 - initial rev 1.0 silicon
- *     2 - rev 2.0 production silicon
+ *     1 - UV1 rev 1.0 initial silicon
+ *     2 - UV1 rev 2.0 production silicon
+ *     3 - UV2 rev 1.0 initial silicon
  */
 static inline int uv_get_min_hub_revision_id(void)
 {
-	extern int uv_min_hub_revision_id;
-
-	return uv_min_hub_revision_id;
+	return uv_hub_info->hub_revision;
 }
 
 #endif /* CONFIG_X86_64 */
Index: linux/arch/x86/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h	2011-05-10 13:45:37.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h	2011-05-10 13:45:46.399167735 -0500
@@ -11,13 +11,64 @@
 #ifndef _ASM_X86_UV_UV_MMRS_H
 #define _ASM_X86_UV_UV_MMRS_H
 
+/*
+ * This file contains MMR definitions for both UV1 & UV2 hubs.
+ *
+ * In general, MMR addresses and structures are identical on both hubs.
+ * These MMRs are identified as:
+ *	#define UVH_xxx		<address>
+ *	union uvh_xxx {
+ *		unsigned long       v;
+ *		struct uvh_int_cmpd_s {
+ *		} s;
+ *	};
+ *
+ * If the MMR exists on both hub type but has different addresses or
+ * contents, the MMR definition is similar to:
+ *	#define UV1H_xxx	<uv1 address>
+ *	#define UV2H_xxx	<uv2address>
+ *	#define UVH_xxx		(is_uv1_hub() ? UV1H_xxx : UV2H_xxx)
+ *	union uvh_xxx {
+ *		unsigned long       v;
+ *		struct uv1h_int_cmpd_s {	 (Common fields only)
+ *		} s;
+ *		struct uv1h_int_cmpd_s {	 (Full UV1 definition)
+ *		} s1;
+ *		struct uv2h_int_cmpd_s {	 (Full UV2 definition)
+ *		} s2;
+ *	};
+ *
+ * Only essential difference are enumerated. For example, if the address is
+ * the same for both UV1 & UV2, only a single #define is generated. Likewise,
+ * if the contents is the same for both hubs, only the "s" structure is
+ * generated.
+ *
+ * If the MMR exists on ONLY 1 type of hub, no generic definition is
+ * generated:
+ *	#define UVnH_xxx	<uvn address>
+ *	union uvnh_xxx {
+ *		unsigned long       v;
+ *		struct uvh_int_cmpd_s {
+ *		} sn;
+ *	};
+ */
+
 #define UV_MMR_ENABLE		(1UL << 63)
 
+#define UV1_HUB_PART_NUMBER	0x88a5
+#define UV2_HUB_PART_NUMBER	0x8eb8
+
+/* Compat: if this #define is present, UV headers support UV2 */
+#define UV2_HUB_IS_SUPPORTED	1
+
+/* KABI compat: if this #define is present, KABI hacks are present */
+#define UV2_HUB_KABI_HACKS	1
+
 /* ========================================================================= */
 /*                          UVH_BAU_DATA_BROADCAST                           */
 /* ========================================================================= */
 #define UVH_BAU_DATA_BROADCAST 0x61688UL
-#define UVH_BAU_DATA_BROADCAST_32 0x0440
+#define UVH_BAU_DATA_BROADCAST_32 0x440
 
 #define UVH_BAU_DATA_BROADCAST_ENABLE_SHFT 0
 #define UVH_BAU_DATA_BROADCAST_ENABLE_MASK 0x0000000000000001UL
@@ -34,7 +85,7 @@ union uvh_bau_data_broadcast_u {
 /*                           UVH_BAU_DATA_CONFIG                             */
 /* ========================================================================= */
 #define UVH_BAU_DATA_CONFIG 0x61680UL
-#define UVH_BAU_DATA_CONFIG_32 0x0438
+#define UVH_BAU_DATA_CONFIG_32 0x438
 
 #define UVH_BAU_DATA_CONFIG_VECTOR_SHFT 0
 #define UVH_BAU_DATA_CONFIG_VECTOR_MASK 0x00000000000000ffUL
@@ -73,125 +124,245 @@ union uvh_bau_data_config_u {
 /*                           UVH_EVENT_OCCURRED0                             */
 /* ========================================================================= */
 #define UVH_EVENT_OCCURRED0 0x70000UL
-#define UVH_EVENT_OCCURRED0_32 0x005e8
+#define UVH_EVENT_OCCURRED0_32 0x5e8
+
+#define UV1H_EVENT_OCCURRED0_LB_HCERR_SHFT 0
+#define UV1H_EVENT_OCCURRED0_LB_HCERR_MASK 0x0000000000000001UL
+#define UV1H_EVENT_OCCURRED0_GR0_HCERR_SHFT 1
+#define UV1H_EVENT_OCCURRED0_GR0_HCERR_MASK 0x0000000000000002UL
+#define UV1H_EVENT_OCCURRED0_GR1_HCERR_SHFT 2
+#define UV1H_EVENT_OCCURRED0_GR1_HCERR_MASK 0x0000000000000004UL
+#define UV1H_EVENT_OCCURRED0_LH_HCERR_SHFT 3
+#define UV1H_EVENT_OCCURRED0_LH_HCERR_MASK 0x0000000000000008UL
+#define UV1H_EVENT_OCCURRED0_RH_HCERR_SHFT 4
+#define UV1H_EVENT_OCCURRED0_RH_HCERR_MASK 0x0000000000000010UL
+#define UV1H_EVENT_OCCURRED0_XN_HCERR_SHFT 5
+#define UV1H_EVENT_OCCURRED0_XN_HCERR_MASK 0x0000000000000020UL
+#define UV1H_EVENT_OCCURRED0_SI_HCERR_SHFT 6
+#define UV1H_EVENT_OCCURRED0_SI_HCERR_MASK 0x0000000000000040UL
+#define UV1H_EVENT_OCCURRED0_LB_AOERR0_SHFT 7
+#define UV1H_EVENT_OCCURRED0_LB_AOERR0_MASK 0x0000000000000080UL
+#define UV1H_EVENT_OCCURRED0_GR0_AOERR0_SHFT 8
+#define UV1H_EVENT_OCCURRED0_GR0_AOERR0_MASK 0x0000000000000100UL
+#define UV1H_EVENT_OCCURRED0_GR1_AOERR0_SHFT 9
+#define UV1H_EVENT_OCCURRED0_GR1_AOERR0_MASK 0x0000000000000200UL
+#define UV1H_EVENT_OCCURRED0_LH_AOERR0_SHFT 10
+#define UV1H_EVENT_OCCURRED0_LH_AOERR0_MASK 0x0000000000000400UL
+#define UV1H_EVENT_OCCURRED0_RH_AOERR0_SHFT 11
+#define UV1H_EVENT_OCCURRED0_RH_AOERR0_MASK 0x0000000000000800UL
+#define UV1H_EVENT_OCCURRED0_XN_AOERR0_SHFT 12
+#define UV1H_EVENT_OCCURRED0_XN_AOERR0_MASK 0x0000000000001000UL
+#define UV1H_EVENT_OCCURRED0_SI_AOERR0_SHFT 13
+#define UV1H_EVENT_OCCURRED0_SI_AOERR0_MASK 0x0000000000002000UL
+#define UV1H_EVENT_OCCURRED0_LB_AOERR1_SHFT 14
+#define UV1H_EVENT_OCCURRED0_LB_AOERR1_MASK 0x0000000000004000UL
+#define UV1H_EVENT_OCCURRED0_GR0_AOERR1_SHFT 15
+#define UV1H_EVENT_OCCURRED0_GR0_AOERR1_MASK 0x0000000000008000UL
+#define UV1H_EVENT_OCCURRED0_GR1_AOERR1_SHFT 16
+#define UV1H_EVENT_OCCURRED0_GR1_AOERR1_MASK 0x0000000000010000UL
+#define UV1H_EVENT_OCCURRED0_LH_AOERR1_SHFT 17
+#define UV1H_EVENT_OCCURRED0_LH_AOERR1_MASK 0x0000000000020000UL
+#define UV1H_EVENT_OCCURRED0_RH_AOERR1_SHFT 18
+#define UV1H_EVENT_OCCURRED0_RH_AOERR1_MASK 0x0000000000040000UL
+#define UV1H_EVENT_OCCURRED0_XN_AOERR1_SHFT 19
+#define UV1H_EVENT_OCCURRED0_XN_AOERR1_MASK 0x0000000000080000UL
+#define UV1H_EVENT_OCCURRED0_SI_AOERR1_SHFT 20
+#define UV1H_EVENT_OCCURRED0_SI_AOERR1_MASK 0x0000000000100000UL
+#define UV1H_EVENT_OCCURRED0_RH_VPI_INT_SHFT 21
+#define UV1H_EVENT_OCCURRED0_RH_VPI_INT_MASK 0x0000000000200000UL
+#define UV1H_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_SHFT 22
+#define UV1H_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_MASK 0x0000000000400000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_0_SHFT 23
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_0_MASK 0x0000000000800000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_1_SHFT 24
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_1_MASK 0x0000000001000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_2_SHFT 25
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_2_MASK 0x0000000002000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_3_SHFT 26
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_3_MASK 0x0000000004000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_4_SHFT 27
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_4_MASK 0x0000000008000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_5_SHFT 28
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_5_MASK 0x0000000010000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_6_SHFT 29
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_6_MASK 0x0000000020000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_7_SHFT 30
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_7_MASK 0x0000000040000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_8_SHFT 31
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_8_MASK 0x0000000080000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_9_SHFT 32
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_9_MASK 0x0000000100000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_10_SHFT 33
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_10_MASK 0x0000000200000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_11_SHFT 34
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_11_MASK 0x0000000400000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_12_SHFT 35
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_12_MASK 0x0000000800000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_13_SHFT 36
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_13_MASK 0x0000001000000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_14_SHFT 37
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_14_MASK 0x0000002000000000UL
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_15_SHFT 38
+#define UV1H_EVENT_OCCURRED0_LB_IRQ_INT_15_MASK 0x0000004000000000UL
+#define UV1H_EVENT_OCCURRED0_L1_NMI_INT_SHFT 39
+#define UV1H_EVENT_OCCURRED0_L1_NMI_INT_MASK 0x0000008000000000UL
+#define UV1H_EVENT_OCCURRED0_STOP_CLOCK_SHFT 40
+#define UV1H_EVENT_OCCURRED0_STOP_CLOCK_MASK 0x0000010000000000UL
+#define UV1H_EVENT_OCCURRED0_ASIC_TO_L1_SHFT 41
+#define UV1H_EVENT_OCCURRED0_ASIC_TO_L1_MASK 0x0000020000000000UL
+#define UV1H_EVENT_OCCURRED0_L1_TO_ASIC_SHFT 42
+#define UV1H_EVENT_OCCURRED0_L1_TO_ASIC_MASK 0x0000040000000000UL
+#define UV1H_EVENT_OCCURRED0_LTC_INT_SHFT 43
+#define UV1H_EVENT_OCCURRED0_LTC_INT_MASK 0x0000080000000000UL
+#define UV1H_EVENT_OCCURRED0_LA_SEQ_TRIGGER_SHFT 44
+#define UV1H_EVENT_OCCURRED0_LA_SEQ_TRIGGER_MASK 0x0000100000000000UL
+#define UV1H_EVENT_OCCURRED0_IPI_INT_SHFT 45
+#define UV1H_EVENT_OCCURRED0_IPI_INT_MASK 0x0000200000000000UL
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT0_SHFT 46
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT0_MASK 0x0000400000000000UL
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT1_SHFT 47
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT1_MASK 0x0000800000000000UL
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT2_SHFT 48
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT2_MASK 0x0001000000000000UL
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT3_SHFT 49
+#define UV1H_EVENT_OCCURRED0_EXTIO_INT3_MASK 0x0002000000000000UL
+#define UV1H_EVENT_OCCURRED0_PROFILE_INT_SHFT 50
+#define UV1H_EVENT_OCCURRED0_PROFILE_INT_MASK 0x0004000000000000UL
+#define UV1H_EVENT_OCCURRED0_RTC0_SHFT 51
+#define UV1H_EVENT_OCCURRED0_RTC0_MASK 0x0008000000000000UL
+#define UV1H_EVENT_OCCURRED0_RTC1_SHFT 52
+#define UV1H_EVENT_OCCURRED0_RTC1_MASK 0x0010000000000000UL
+#define UV1H_EVENT_OCCURRED0_RTC2_SHFT 53
+#define UV1H_EVENT_OCCURRED0_RTC2_MASK 0x0020000000000000UL
+#define UV1H_EVENT_OCCURRED0_RTC3_SHFT 54
+#define UV1H_EVENT_OCCURRED0_RTC3_MASK 0x0040000000000000UL
+#define UV1H_EVENT_OCCURRED0_BAU_DATA_SHFT 55
+#define UV1H_EVENT_OCCURRED0_BAU_DATA_MASK 0x0080000000000000UL
+#define UV1H_EVENT_OCCURRED0_POWER_MANAGEMENT_REQ_SHFT 56
+#define UV1H_EVENT_OCCURRED0_POWER_MANAGEMENT_REQ_MASK 0x0100000000000000UL
+
+#define UV2H_EVENT_OCCURRED0_LB_HCERR_SHFT 0
+#define UV2H_EVENT_OCCURRED0_LB_HCERR_MASK 0x0000000000000001UL
+#define UV2H_EVENT_OCCURRED0_QP_HCERR_SHFT 1
+#define UV2H_EVENT_OCCURRED0_QP_HCERR_MASK 0x0000000000000002UL
+#define UV2H_EVENT_OCCURRED0_RH_HCERR_SHFT 2
+#define UV2H_EVENT_OCCURRED0_RH_HCERR_MASK 0x0000000000000004UL
+#define UV2H_EVENT_OCCURRED0_LH0_HCERR_SHFT 3
+#define UV2H_EVENT_OCCURRED0_LH0_HCERR_MASK 0x0000000000000008UL
+#define UV2H_EVENT_OCCURRED0_LH1_HCERR_SHFT 4
+#define UV2H_EVENT_OCCURRED0_LH1_HCERR_MASK 0x0000000000000010UL
+#define UV2H_EVENT_OCCURRED0_GR0_HCERR_SHFT 5
+#define UV2H_EVENT_OCCURRED0_GR0_HCERR_MASK 0x0000000000000020UL
+#define UV2H_EVENT_OCCURRED0_GR1_HCERR_SHFT 6
+#define UV2H_EVENT_OCCURRED0_GR1_HCERR_MASK 0x0000000000000040UL
+#define UV2H_EVENT_OCCURRED0_NI0_HCERR_SHFT 7
+#define UV2H_EVENT_OCCURRED0_NI0_HCERR_MASK 0x0000000000000080UL
+#define UV2H_EVENT_OCCURRED0_NI1_HCERR_SHFT 8
+#define UV2H_EVENT_OCCURRED0_NI1_HCERR_MASK 0x0000000000000100UL
+#define UV2H_EVENT_OCCURRED0_LB_AOERR0_SHFT 9
+#define UV2H_EVENT_OCCURRED0_LB_AOERR0_MASK 0x0000000000000200UL
+#define UV2H_EVENT_OCCURRED0_QP_AOERR0_SHFT 10
+#define UV2H_EVENT_OCCURRED0_QP_AOERR0_MASK 0x0000000000000400UL
+#define UV2H_EVENT_OCCURRED0_RH_AOERR0_SHFT 11
+#define UV2H_EVENT_OCCURRED0_RH_AOERR0_MASK 0x0000000000000800UL
+#define UV2H_EVENT_OCCURRED0_LH0_AOERR0_SHFT 12
+#define UV2H_EVENT_OCCURRED0_LH0_AOERR0_MASK 0x0000000000001000UL
+#define UV2H_EVENT_OCCURRED0_LH1_AOERR0_SHFT 13
+#define UV2H_EVENT_OCCURRED0_LH1_AOERR0_MASK 0x0000000000002000UL
+#define UV2H_EVENT_OCCURRED0_GR0_AOERR0_SHFT 14
+#define UV2H_EVENT_OCCURRED0_GR0_AOERR0_MASK 0x0000000000004000UL
+#define UV2H_EVENT_OCCURRED0_GR1_AOERR0_SHFT 15
+#define UV2H_EVENT_OCCURRED0_GR1_AOERR0_MASK 0x0000000000008000UL
+#define UV2H_EVENT_OCCURRED0_XB_AOERR0_SHFT 16
+#define UV2H_EVENT_OCCURRED0_XB_AOERR0_MASK 0x0000000000010000UL
+#define UV2H_EVENT_OCCURRED0_RT_AOERR0_SHFT 17
+#define UV2H_EVENT_OCCURRED0_RT_AOERR0_MASK 0x0000000000020000UL
+#define UV2H_EVENT_OCCURRED0_NI0_AOERR0_SHFT 18
+#define UV2H_EVENT_OCCURRED0_NI0_AOERR0_MASK 0x0000000000040000UL
+#define UV2H_EVENT_OCCURRED0_NI1_AOERR0_SHFT 19
+#define UV2H_EVENT_OCCURRED0_NI1_AOERR0_MASK 0x0000000000080000UL
+#define UV2H_EVENT_OCCURRED0_LB_AOERR1_SHFT 20
+#define UV2H_EVENT_OCCURRED0_LB_AOERR1_MASK 0x0000000000100000UL
+#define UV2H_EVENT_OCCURRED0_QP_AOERR1_SHFT 21
+#define UV2H_EVENT_OCCURRED0_QP_AOERR1_MASK 0x0000000000200000UL
+#define UV2H_EVENT_OCCURRED0_RH_AOERR1_SHFT 22
+#define UV2H_EVENT_OCCURRED0_RH_AOERR1_MASK 0x0000000000400000UL
+#define UV2H_EVENT_OCCURRED0_LH0_AOERR1_SHFT 23
+#define UV2H_EVENT_OCCURRED0_LH0_AOERR1_MASK 0x0000000000800000UL
+#define UV2H_EVENT_OCCURRED0_LH1_AOERR1_SHFT 24
+#define UV2H_EVENT_OCCURRED0_LH1_AOERR1_MASK 0x0000000001000000UL
+#define UV2H_EVENT_OCCURRED0_GR0_AOERR1_SHFT 25
+#define UV2H_EVENT_OCCURRED0_GR0_AOERR1_MASK 0x0000000002000000UL
+#define UV2H_EVENT_OCCURRED0_GR1_AOERR1_SHFT 26
+#define UV2H_EVENT_OCCURRED0_GR1_AOERR1_MASK 0x0000000004000000UL
+#define UV2H_EVENT_OCCURRED0_XB_AOERR1_SHFT 27
+#define UV2H_EVENT_OCCURRED0_XB_AOERR1_MASK 0x0000000008000000UL
+#define UV2H_EVENT_OCCURRED0_RT_AOERR1_SHFT 28
+#define UV2H_EVENT_OCCURRED0_RT_AOERR1_MASK 0x0000000010000000UL
+#define UV2H_EVENT_OCCURRED0_NI0_AOERR1_SHFT 29
+#define UV2H_EVENT_OCCURRED0_NI0_AOERR1_MASK 0x0000000020000000UL
+#define UV2H_EVENT_OCCURRED0_NI1_AOERR1_SHFT 30
+#define UV2H_EVENT_OCCURRED0_NI1_AOERR1_MASK 0x0000000040000000UL
+#define UV2H_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_SHFT 31
+#define UV2H_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_MASK 0x0000000080000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_0_SHFT 32
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_0_MASK 0x0000000100000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_1_SHFT 33
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_1_MASK 0x0000000200000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_2_SHFT 34
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_2_MASK 0x0000000400000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_3_SHFT 35
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_3_MASK 0x0000000800000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_4_SHFT 36
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_4_MASK 0x0000001000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_5_SHFT 37
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_5_MASK 0x0000002000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_6_SHFT 38
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_6_MASK 0x0000004000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_7_SHFT 39
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_7_MASK 0x0000008000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_8_SHFT 40
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_8_MASK 0x0000010000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_9_SHFT 41
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_9_MASK 0x0000020000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_10_SHFT 42
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_10_MASK 0x0000040000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_11_SHFT 43
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_11_MASK 0x0000080000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_12_SHFT 44
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_12_MASK 0x0000100000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_13_SHFT 45
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_13_MASK 0x0000200000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_14_SHFT 46
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_14_MASK 0x0000400000000000UL
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_15_SHFT 47
+#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_15_MASK 0x0000800000000000UL
+#define UV2H_EVENT_OCCURRED0_L1_NMI_INT_SHFT 48
+#define UV2H_EVENT_OCCURRED0_L1_NMI_INT_MASK 0x0001000000000000UL
+#define UV2H_EVENT_OCCURRED0_STOP_CLOCK_SHFT 49
+#define UV2H_EVENT_OCCURRED0_STOP_CLOCK_MASK 0x0002000000000000UL
+#define UV2H_EVENT_OCCURRED0_ASIC_TO_L1_SHFT 50
+#define UV2H_EVENT_OCCURRED0_ASIC_TO_L1_MASK 0x0004000000000000UL
+#define UV2H_EVENT_OCCURRED0_L1_TO_ASIC_SHFT 51
+#define UV2H_EVENT_OCCURRED0_L1_TO_ASIC_MASK 0x0008000000000000UL
+#define UV2H_EVENT_OCCURRED0_LA_SEQ_TRIGGER_SHFT 52
+#define UV2H_EVENT_OCCURRED0_LA_SEQ_TRIGGER_MASK 0x0010000000000000UL
+#define UV2H_EVENT_OCCURRED0_IPI_INT_SHFT 53
+#define UV2H_EVENT_OCCURRED0_IPI_INT_MASK 0x0020000000000000UL
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT0_SHFT 54
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT0_MASK 0x0040000000000000UL
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT1_SHFT 55
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT1_MASK 0x0080000000000000UL
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT2_SHFT 56
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT2_MASK 0x0100000000000000UL
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT3_SHFT 57
+#define UV2H_EVENT_OCCURRED0_EXTIO_INT3_MASK 0x0200000000000000UL
+#define UV2H_EVENT_OCCURRED0_PROFILE_INT_SHFT 58
+#define UV2H_EVENT_OCCURRED0_PROFILE_INT_MASK 0x0400000000000000UL
 
-#define UVH_EVENT_OCCURRED0_LB_HCERR_SHFT 0
-#define UVH_EVENT_OCCURRED0_LB_HCERR_MASK 0x0000000000000001UL
-#define UVH_EVENT_OCCURRED0_GR0_HCERR_SHFT 1
-#define UVH_EVENT_OCCURRED0_GR0_HCERR_MASK 0x0000000000000002UL
-#define UVH_EVENT_OCCURRED0_GR1_HCERR_SHFT 2
-#define UVH_EVENT_OCCURRED0_GR1_HCERR_MASK 0x0000000000000004UL
-#define UVH_EVENT_OCCURRED0_LH_HCERR_SHFT 3
-#define UVH_EVENT_OCCURRED0_LH_HCERR_MASK 0x0000000000000008UL
-#define UVH_EVENT_OCCURRED0_RH_HCERR_SHFT 4
-#define UVH_EVENT_OCCURRED0_RH_HCERR_MASK 0x0000000000000010UL
-#define UVH_EVENT_OCCURRED0_XN_HCERR_SHFT 5
-#define UVH_EVENT_OCCURRED0_XN_HCERR_MASK 0x0000000000000020UL
-#define UVH_EVENT_OCCURRED0_SI_HCERR_SHFT 6
-#define UVH_EVENT_OCCURRED0_SI_HCERR_MASK 0x0000000000000040UL
-#define UVH_EVENT_OCCURRED0_LB_AOERR0_SHFT 7
-#define UVH_EVENT_OCCURRED0_LB_AOERR0_MASK 0x0000000000000080UL
-#define UVH_EVENT_OCCURRED0_GR0_AOERR0_SHFT 8
-#define UVH_EVENT_OCCURRED0_GR0_AOERR0_MASK 0x0000000000000100UL
-#define UVH_EVENT_OCCURRED0_GR1_AOERR0_SHFT 9
-#define UVH_EVENT_OCCURRED0_GR1_AOERR0_MASK 0x0000000000000200UL
-#define UVH_EVENT_OCCURRED0_LH_AOERR0_SHFT 10
-#define UVH_EVENT_OCCURRED0_LH_AOERR0_MASK 0x0000000000000400UL
-#define UVH_EVENT_OCCURRED0_RH_AOERR0_SHFT 11
-#define UVH_EVENT_OCCURRED0_RH_AOERR0_MASK 0x0000000000000800UL
-#define UVH_EVENT_OCCURRED0_XN_AOERR0_SHFT 12
-#define UVH_EVENT_OCCURRED0_XN_AOERR0_MASK 0x0000000000001000UL
-#define UVH_EVENT_OCCURRED0_SI_AOERR0_SHFT 13
-#define UVH_EVENT_OCCURRED0_SI_AOERR0_MASK 0x0000000000002000UL
-#define UVH_EVENT_OCCURRED0_LB_AOERR1_SHFT 14
-#define UVH_EVENT_OCCURRED0_LB_AOERR1_MASK 0x0000000000004000UL
-#define UVH_EVENT_OCCURRED0_GR0_AOERR1_SHFT 15
-#define UVH_EVENT_OCCURRED0_GR0_AOERR1_MASK 0x0000000000008000UL
-#define UVH_EVENT_OCCURRED0_GR1_AOERR1_SHFT 16
-#define UVH_EVENT_OCCURRED0_GR1_AOERR1_MASK 0x0000000000010000UL
-#define UVH_EVENT_OCCURRED0_LH_AOERR1_SHFT 17
-#define UVH_EVENT_OCCURRED0_LH_AOERR1_MASK 0x0000000000020000UL
-#define UVH_EVENT_OCCURRED0_RH_AOERR1_SHFT 18
-#define UVH_EVENT_OCCURRED0_RH_AOERR1_MASK 0x0000000000040000UL
-#define UVH_EVENT_OCCURRED0_XN_AOERR1_SHFT 19
-#define UVH_EVENT_OCCURRED0_XN_AOERR1_MASK 0x0000000000080000UL
-#define UVH_EVENT_OCCURRED0_SI_AOERR1_SHFT 20
-#define UVH_EVENT_OCCURRED0_SI_AOERR1_MASK 0x0000000000100000UL
-#define UVH_EVENT_OCCURRED0_RH_VPI_INT_SHFT 21
-#define UVH_EVENT_OCCURRED0_RH_VPI_INT_MASK 0x0000000000200000UL
-#define UVH_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_SHFT 22
-#define UVH_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_MASK 0x0000000000400000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_0_SHFT 23
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_0_MASK 0x0000000000800000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_1_SHFT 24
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_1_MASK 0x0000000001000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_2_SHFT 25
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_2_MASK 0x0000000002000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_3_SHFT 26
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_3_MASK 0x0000000004000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_4_SHFT 27
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_4_MASK 0x0000000008000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_5_SHFT 28
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_5_MASK 0x0000000010000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_6_SHFT 29
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_6_MASK 0x0000000020000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_7_SHFT 30
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_7_MASK 0x0000000040000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_8_SHFT 31
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_8_MASK 0x0000000080000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_9_SHFT 32
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_9_MASK 0x0000000100000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_10_SHFT 33
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_10_MASK 0x0000000200000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_11_SHFT 34
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_11_MASK 0x0000000400000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_12_SHFT 35
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_12_MASK 0x0000000800000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_13_SHFT 36
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_13_MASK 0x0000001000000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_14_SHFT 37
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_14_MASK 0x0000002000000000UL
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_15_SHFT 38
-#define UVH_EVENT_OCCURRED0_LB_IRQ_INT_15_MASK 0x0000004000000000UL
-#define UVH_EVENT_OCCURRED0_L1_NMI_INT_SHFT 39
-#define UVH_EVENT_OCCURRED0_L1_NMI_INT_MASK 0x0000008000000000UL
-#define UVH_EVENT_OCCURRED0_STOP_CLOCK_SHFT 40
-#define UVH_EVENT_OCCURRED0_STOP_CLOCK_MASK 0x0000010000000000UL
-#define UVH_EVENT_OCCURRED0_ASIC_TO_L1_SHFT 41
-#define UVH_EVENT_OCCURRED0_ASIC_TO_L1_MASK 0x0000020000000000UL
-#define UVH_EVENT_OCCURRED0_L1_TO_ASIC_SHFT 42
-#define UVH_EVENT_OCCURRED0_L1_TO_ASIC_MASK 0x0000040000000000UL
-#define UVH_EVENT_OCCURRED0_LTC_INT_SHFT 43
-#define UVH_EVENT_OCCURRED0_LTC_INT_MASK 0x0000080000000000UL
-#define UVH_EVENT_OCCURRED0_LA_SEQ_TRIGGER_SHFT 44
-#define UVH_EVENT_OCCURRED0_LA_SEQ_TRIGGER_MASK 0x0000100000000000UL
-#define UVH_EVENT_OCCURRED0_IPI_INT_SHFT 45
-#define UVH_EVENT_OCCURRED0_IPI_INT_MASK 0x0000200000000000UL
-#define UVH_EVENT_OCCURRED0_EXTIO_INT0_SHFT 46
-#define UVH_EVENT_OCCURRED0_EXTIO_INT0_MASK 0x0000400000000000UL
-#define UVH_EVENT_OCCURRED0_EXTIO_INT1_SHFT 47
-#define UVH_EVENT_OCCURRED0_EXTIO_INT1_MASK 0x0000800000000000UL
-#define UVH_EVENT_OCCURRED0_EXTIO_INT2_SHFT 48
-#define UVH_EVENT_OCCURRED0_EXTIO_INT2_MASK 0x0001000000000000UL
-#define UVH_EVENT_OCCURRED0_EXTIO_INT3_SHFT 49
-#define UVH_EVENT_OCCURRED0_EXTIO_INT3_MASK 0x0002000000000000UL
-#define UVH_EVENT_OCCURRED0_PROFILE_INT_SHFT 50
-#define UVH_EVENT_OCCURRED0_PROFILE_INT_MASK 0x0004000000000000UL
-#define UVH_EVENT_OCCURRED0_RTC0_SHFT 51
-#define UVH_EVENT_OCCURRED0_RTC0_MASK 0x0008000000000000UL
-#define UVH_EVENT_OCCURRED0_RTC1_SHFT 52
-#define UVH_EVENT_OCCURRED0_RTC1_MASK 0x0010000000000000UL
-#define UVH_EVENT_OCCURRED0_RTC2_SHFT 53
-#define UVH_EVENT_OCCURRED0_RTC2_MASK 0x0020000000000000UL
-#define UVH_EVENT_OCCURRED0_RTC3_SHFT 54
-#define UVH_EVENT_OCCURRED0_RTC3_MASK 0x0040000000000000UL
-#define UVH_EVENT_OCCURRED0_BAU_DATA_SHFT 55
-#define UVH_EVENT_OCCURRED0_BAU_DATA_MASK 0x0080000000000000UL
-#define UVH_EVENT_OCCURRED0_POWER_MANAGEMENT_REQ_SHFT 56
-#define UVH_EVENT_OCCURRED0_POWER_MANAGEMENT_REQ_MASK 0x0100000000000000UL
 union uvh_event_occurred0_u {
     unsigned long	v;
-    struct uvh_event_occurred0_s {
+    struct uv1h_event_occurred0_s {
 	unsigned long	lb_hcerr             :  1;  /* RW, W1C */
 	unsigned long	gr0_hcerr            :  1;  /* RW, W1C */
 	unsigned long	gr1_hcerr            :  1;  /* RW, W1C */
@@ -250,14 +421,76 @@ union uvh_event_occurred0_u {
 	unsigned long	bau_data             :  1;  /* RW, W1C */
 	unsigned long	power_management_req :  1;  /* RW, W1C */
 	unsigned long	rsvd_57_63           :  7;  /*    */
-    } s;
+    } s1;
+    struct uv2h_event_occurred0_s {
+	unsigned long	lb_hcerr            :  1;  /* RW */
+	unsigned long	qp_hcerr            :  1;  /* RW */
+	unsigned long	rh_hcerr            :  1;  /* RW */
+	unsigned long	lh0_hcerr           :  1;  /* RW */
+	unsigned long	lh1_hcerr           :  1;  /* RW */
+	unsigned long	gr0_hcerr           :  1;  /* RW */
+	unsigned long	gr1_hcerr           :  1;  /* RW */
+	unsigned long	ni0_hcerr           :  1;  /* RW */
+	unsigned long	ni1_hcerr           :  1;  /* RW */
+	unsigned long	lb_aoerr0           :  1;  /* RW */
+	unsigned long	qp_aoerr0           :  1;  /* RW */
+	unsigned long	rh_aoerr0           :  1;  /* RW */
+	unsigned long	lh0_aoerr0          :  1;  /* RW */
+	unsigned long	lh1_aoerr0          :  1;  /* RW */
+	unsigned long	gr0_aoerr0          :  1;  /* RW */
+	unsigned long	gr1_aoerr0          :  1;  /* RW */
+	unsigned long	xb_aoerr0           :  1;  /* RW */
+	unsigned long	rt_aoerr0           :  1;  /* RW */
+	unsigned long	ni0_aoerr0          :  1;  /* RW */
+	unsigned long	ni1_aoerr0          :  1;  /* RW */
+	unsigned long	lb_aoerr1           :  1;  /* RW */
+	unsigned long	qp_aoerr1           :  1;  /* RW */
+	unsigned long	rh_aoerr1           :  1;  /* RW */
+	unsigned long	lh0_aoerr1          :  1;  /* RW */
+	unsigned long	lh1_aoerr1          :  1;  /* RW */
+	unsigned long	gr0_aoerr1          :  1;  /* RW */
+	unsigned long	gr1_aoerr1          :  1;  /* RW */
+	unsigned long	xb_aoerr1           :  1;  /* RW */
+	unsigned long	rt_aoerr1           :  1;  /* RW */
+	unsigned long	ni0_aoerr1          :  1;  /* RW */
+	unsigned long	ni1_aoerr1          :  1;  /* RW */
+	unsigned long	system_shutdown_int :  1;  /* RW */
+	unsigned long	lb_irq_int_0        :  1;  /* RW */
+	unsigned long	lb_irq_int_1        :  1;  /* RW */
+	unsigned long	lb_irq_int_2        :  1;  /* RW */
+	unsigned long	lb_irq_int_3        :  1;  /* RW */
+	unsigned long	lb_irq_int_4        :  1;  /* RW */
+	unsigned long	lb_irq_int_5        :  1;  /* RW */
+	unsigned long	lb_irq_int_6        :  1;  /* RW */
+	unsigned long	lb_irq_int_7        :  1;  /* RW */
+	unsigned long	lb_irq_int_8        :  1;  /* RW */
+	unsigned long	lb_irq_int_9        :  1;  /* RW */
+	unsigned long	lb_irq_int_10       :  1;  /* RW */
+	unsigned long	lb_irq_int_11       :  1;  /* RW */
+	unsigned long	lb_irq_int_12       :  1;  /* RW */
+	unsigned long	lb_irq_int_13       :  1;  /* RW */
+	unsigned long	lb_irq_int_14       :  1;  /* RW */
+	unsigned long	lb_irq_int_15       :  1;  /* RW */
+	unsigned long	l1_nmi_int          :  1;  /* RW */
+	unsigned long	stop_clock          :  1;  /* RW */
+	unsigned long	asic_to_l1          :  1;  /* RW */
+	unsigned long	l1_to_asic          :  1;  /* RW */
+	unsigned long	la_seq_trigger      :  1;  /* RW */
+	unsigned long	ipi_int             :  1;  /* RW */
+	unsigned long	extio_int0          :  1;  /* RW */
+	unsigned long	extio_int1          :  1;  /* RW */
+	unsigned long	extio_int2          :  1;  /* RW */
+	unsigned long	extio_int3          :  1;  /* RW */
+	unsigned long	profile_int         :  1;  /* RW */
+	unsigned long	rsvd_59_63          :  5;  /*    */
+    } s2;
 };
 
 /* ========================================================================= */
 /*                        UVH_EVENT_OCCURRED0_ALIAS                          */
 /* ========================================================================= */
 #define UVH_EVENT_OCCURRED0_ALIAS 0x0000000000070008UL
-#define UVH_EVENT_OCCURRED0_ALIAS_32 0x005f0
+#define UVH_EVENT_OCCURRED0_ALIAS_32 0x5f0
 
 /* ========================================================================= */
 /*                         UVH_GR0_TLB_INT0_CONFIG                           */
@@ -432,8 +665,16 @@ union uvh_int_cmpb_u {
 /* ========================================================================= */
 #define UVH_INT_CMPC 0x22100UL
 
-#define UVH_INT_CMPC_REAL_TIME_CMPC_SHFT 0
-#define UVH_INT_CMPC_REAL_TIME_CMPC_MASK 0x00ffffffffffffffUL
+#define UV1H_INT_CMPC_REAL_TIME_CMPC_SHFT	0
+#define UV2H_INT_CMPC_REAL_TIME_CMPC_SHFT	0
+#define UVH_INT_CMPC_REAL_TIME_CMPC_SHFT	(is_uv1_hub() ?		\
+			UV1H_INT_CMPC_REAL_TIME_CMPC_SHFT :	\
+			UV2H_INT_CMPC_REAL_TIME_CMPC_SHFT)
+#define UV1H_INT_CMPC_REAL_TIME_CMPC_MASK	0xffffffffffffffUL
+#define UV2H_INT_CMPC_REAL_TIME_CMPC_MASK	0xffffffffffffffUL
+#define UVH_INT_CMPC_REAL_TIME_CMPC_MASK	(is_uv1_hub() ?		\
+			UV1H_INT_CMPC_REAL_TIME_CMPC_MASK :	\
+			UV2H_INT_CMPC_REAL_TIME_CMPC_MASK)
 
 union uvh_int_cmpc_u {
     unsigned long	v;
@@ -448,8 +689,16 @@ union uvh_int_cmpc_u {
 /* ========================================================================= */
 #define UVH_INT_CMPD 0x22180UL
 
-#define UVH_INT_CMPD_REAL_TIME_CMPD_SHFT 0
-#define UVH_INT_CMPD_REAL_TIME_CMPD_MASK 0x00ffffffffffffffUL
+#define UV1H_INT_CMPD_REAL_TIME_CMPD_SHFT	0
+#define UV2H_INT_CMPD_REAL_TIME_CMPD_SHFT	0
+#define UVH_INT_CMPD_REAL_TIME_CMPD_SHFT	(is_uv1_hub() ?		\
+			UV1H_INT_CMPD_REAL_TIME_CMPD_SHFT :	\
+			UV2H_INT_CMPD_REAL_TIME_CMPD_SHFT)
+#define UV1H_INT_CMPD_REAL_TIME_CMPD_MASK	0xffffffffffffffUL
+#define UV2H_INT_CMPD_REAL_TIME_CMPD_MASK	0xffffffffffffffUL
+#define UVH_INT_CMPD_REAL_TIME_CMPD_MASK	(is_uv1_hub() ?		\
+			UV1H_INT_CMPD_REAL_TIME_CMPD_MASK :	\
+			UV2H_INT_CMPD_REAL_TIME_CMPD_MASK)
 
 union uvh_int_cmpd_u {
     unsigned long	v;
@@ -463,7 +712,7 @@ union uvh_int_cmpd_u {
 /*                               UVH_IPI_INT                                 */
 /* ========================================================================= */
 #define UVH_IPI_INT 0x60500UL
-#define UVH_IPI_INT_32 0x0348
+#define UVH_IPI_INT_32 0x348
 
 #define UVH_IPI_INT_VECTOR_SHFT 0
 #define UVH_IPI_INT_VECTOR_MASK 0x00000000000000ffUL
@@ -493,7 +742,7 @@ union uvh_ipi_int_u {
 /*                   UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST                     */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST 0x320050UL
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_32 0x009c0
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_32 0x9c0
 
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_ADDRESS_SHFT 4
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_ADDRESS_MASK 0x000007fffffffff0UL
@@ -515,7 +764,7 @@ union uvh_lb_bau_intd_payload_queue_firs
 /*                    UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST                     */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST 0x320060UL
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_32 0x009c8
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_32 0x9c8
 
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_ADDRESS_SHFT 4
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_ADDRESS_MASK 0x000007fffffffff0UL
@@ -533,7 +782,7 @@ union uvh_lb_bau_intd_payload_queue_last
 /*                    UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL                     */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL 0x320070UL
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_32 0x009d0
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_32 0x9d0
 
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_ADDRESS_SHFT 4
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_ADDRESS_MASK 0x000007fffffffff0UL
@@ -551,7 +800,7 @@ union uvh_lb_bau_intd_payload_queue_tail
 /*                   UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE                    */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE 0x320080UL
-#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_32 0x0a68
+#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_32 0xa68
 
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_PENDING_0_SHFT 0
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_PENDING_0_MASK 0x0000000000000001UL
@@ -585,6 +834,7 @@ union uvh_lb_bau_intd_payload_queue_tail
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_TIMEOUT_6_MASK 0x0000000000004000UL
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_TIMEOUT_7_SHFT 15
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_TIMEOUT_7_MASK 0x0000000000008000UL
+
 union uvh_lb_bau_intd_software_acknowledge_u {
     unsigned long	v;
     struct uvh_lb_bau_intd_software_acknowledge_s {
@@ -612,13 +862,13 @@ union uvh_lb_bau_intd_software_acknowled
 /*                UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS                 */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS 0x0000000000320088UL
-#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS_32 0x0a70
+#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS_32 0xa70
 
 /* ========================================================================= */
 /*                         UVH_LB_BAU_MISC_CONTROL                           */
 /* ========================================================================= */
 #define UVH_LB_BAU_MISC_CONTROL 0x320170UL
-#define UVH_LB_BAU_MISC_CONTROL_32 0x00a10
+#define UVH_LB_BAU_MISC_CONTROL_32 0xa10
 
 #define UVH_LB_BAU_MISC_CONTROL_REJECTION_DELAY_SHFT 0
 #define UVH_LB_BAU_MISC_CONTROL_REJECTION_DELAY_MASK 0x00000000000000ffUL
@@ -628,8 +878,8 @@ union uvh_lb_bau_intd_software_acknowled
 #define UVH_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_MASK 0x0000000000000200UL
 #define UVH_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_SHFT 10
 #define UVH_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_MASK 0x0000000000000400UL
-#define UVH_LB_BAU_MISC_CONTROL_CSI_AGENT_PRESENCE_VECTOR_SHFT 11
-#define UVH_LB_BAU_MISC_CONTROL_CSI_AGENT_PRESENCE_VECTOR_MASK 0x0000000000003800UL
+#define UVH_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_SHFT 11
+#define UVH_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_MASK 0x0000000000003800UL
 #define UVH_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_SHFT 14
 #define UVH_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_MASK 0x0000000000004000UL
 #define UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT 15
@@ -650,8 +900,86 @@ union uvh_lb_bau_intd_software_acknowled
 #define UVH_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_MASK 0x0000000008000000UL
 #define UVH_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_SHFT 28
 #define UVH_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000010000000UL
-#define UVH_LB_BAU_MISC_CONTROL_FUN_SHFT 48
-#define UVH_LB_BAU_MISC_CONTROL_FUN_MASK 0xffff000000000000UL
+
+#define UV1H_LB_BAU_MISC_CONTROL_REJECTION_DELAY_SHFT 0
+#define UV1H_LB_BAU_MISC_CONTROL_REJECTION_DELAY_MASK 0x00000000000000ffUL
+#define UV1H_LB_BAU_MISC_CONTROL_APIC_MODE_SHFT 8
+#define UV1H_LB_BAU_MISC_CONTROL_APIC_MODE_MASK 0x0000000000000100UL
+#define UV1H_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_SHFT 9
+#define UV1H_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_MASK 0x0000000000000200UL
+#define UV1H_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_SHFT 10
+#define UV1H_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_MASK 0x0000000000000400UL
+#define UV1H_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_SHFT 11
+#define UV1H_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_MASK 0x0000000000003800UL
+#define UV1H_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_SHFT 14
+#define UV1H_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_MASK 0x0000000000004000UL
+#define UV1H_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT 15
+#define UV1H_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_MASK 0x0000000000008000UL
+#define UV1H_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT 16
+#define UV1H_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_MASK 0x00000000000f0000UL
+#define UV1H_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_SHFT 20
+#define UV1H_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_MASK 0x0000000000100000UL
+#define UV1H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_SHFT 21
+#define UV1H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_MASK 0x0000000000200000UL
+#define UV1H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_SHFT 22
+#define UV1H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_MASK 0x0000000000400000UL
+#define UV1H_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_SHFT 23
+#define UV1H_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_MASK 0x0000000000800000UL
+#define UV1H_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_SHFT 24
+#define UV1H_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000007000000UL
+#define UV1H_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_SHFT 27
+#define UV1H_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_MASK 0x0000000008000000UL
+#define UV1H_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_SHFT 28
+#define UV1H_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000010000000UL
+#define UV1H_LB_BAU_MISC_CONTROL_FUN_SHFT 48
+#define UV1H_LB_BAU_MISC_CONTROL_FUN_MASK 0xffff000000000000UL
+
+#define UV2H_LB_BAU_MISC_CONTROL_REJECTION_DELAY_SHFT 0
+#define UV2H_LB_BAU_MISC_CONTROL_REJECTION_DELAY_MASK 0x00000000000000ffUL
+#define UV2H_LB_BAU_MISC_CONTROL_APIC_MODE_SHFT 8
+#define UV2H_LB_BAU_MISC_CONTROL_APIC_MODE_MASK 0x0000000000000100UL
+#define UV2H_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_SHFT 9
+#define UV2H_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_MASK 0x0000000000000200UL
+#define UV2H_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_SHFT 10
+#define UV2H_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_MASK 0x0000000000000400UL
+#define UV2H_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_SHFT 11
+#define UV2H_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_MASK 0x0000000000003800UL
+#define UV2H_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_SHFT 14
+#define UV2H_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_MASK 0x0000000000004000UL
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT 15
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_MASK 0x0000000000008000UL
+#define UV2H_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT 16
+#define UV2H_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_MASK 0x00000000000f0000UL
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_SHFT 20
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_MASK 0x0000000000100000UL
+#define UV2H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_SHFT 21
+#define UV2H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_MASK 0x0000000000200000UL
+#define UV2H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_SHFT 22
+#define UV2H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_MASK 0x0000000000400000UL
+#define UV2H_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_SHFT 23
+#define UV2H_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_MASK 0x0000000000800000UL
+#define UV2H_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_SHFT 24
+#define UV2H_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000007000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_SHFT 27
+#define UV2H_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_MASK 0x0000000008000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_SHFT 28
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000010000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_AUTOMATIC_APIC_MODE_SELECTION_SHFT 29
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_AUTOMATIC_APIC_MODE_SELECTION_MASK 0x0000000020000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_APIC_MODE_STATUS_SHFT 30
+#define UV2H_LB_BAU_MISC_CONTROL_APIC_MODE_STATUS_MASK 0x0000000040000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_SUPPRESS_INTERRUPTS_TO_SELF_SHFT 31
+#define UV2H_LB_BAU_MISC_CONTROL_SUPPRESS_INTERRUPTS_TO_SELF_MASK 0x0000000080000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_LOCK_BASED_SYSTEM_FLUSH_SHFT 32
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_LOCK_BASED_SYSTEM_FLUSH_MASK 0x0000000100000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_SHFT 33
+#define UV2H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_MASK 0x0000000200000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_SUPPRESS_INT_PRIO_UDT_TO_SELF_SHFT 34
+#define UV2H_LB_BAU_MISC_CONTROL_SUPPRESS_INT_PRIO_UDT_TO_SELF_MASK 0x0000000400000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_SHFT 35
+#define UV2H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_MASK 0x0000000800000000UL
+#define UV2H_LB_BAU_MISC_CONTROL_FUN_SHFT 48
+#define UV2H_LB_BAU_MISC_CONTROL_FUN_MASK 0xffff000000000000UL
 
 union uvh_lb_bau_misc_control_u {
     unsigned long	v;
@@ -660,7 +988,25 @@ union uvh_lb_bau_misc_control_u {
 	unsigned long	apic_mode                          :  1;  /* RW */
 	unsigned long	force_broadcast                    :  1;  /* RW */
 	unsigned long	force_lock_nop                     :  1;  /* RW */
-	unsigned long	csi_agent_presence_vector          :  3;  /* RW */
+	unsigned long	qpi_agent_presence_vector          :  3;  /* RW */
+	unsigned long	descriptor_fetch_mode              :  1;  /* RW */
+	unsigned long	enable_intd_soft_ack_mode          :  1;  /* RW */
+	unsigned long	intd_soft_ack_timeout_period       :  4;  /* RW */
+	unsigned long	enable_dual_mapping_mode           :  1;  /* RW */
+	unsigned long	vga_io_port_decode_enable          :  1;  /* RW */
+	unsigned long	vga_io_port_16_bit_decode          :  1;  /* RW */
+	unsigned long	suppress_dest_registration         :  1;  /* RW */
+	unsigned long	programmed_initial_priority        :  3;  /* RW */
+	unsigned long	use_incoming_priority              :  1;  /* RW */
+	unsigned long	enable_programmed_initial_priority :  1;  /* RW */
+	unsigned long	rsvd_29_63    : 35;
+    } s;
+    struct uv1h_lb_bau_misc_control_s {
+	unsigned long	rejection_delay                    :  8;  /* RW */
+	unsigned long	apic_mode                          :  1;  /* RW */
+	unsigned long	force_broadcast                    :  1;  /* RW */
+	unsigned long	force_lock_nop                     :  1;  /* RW */
+	unsigned long	qpi_agent_presence_vector          :  3;  /* RW */
 	unsigned long	descriptor_fetch_mode              :  1;  /* RW */
 	unsigned long	enable_intd_soft_ack_mode          :  1;  /* RW */
 	unsigned long	intd_soft_ack_timeout_period       :  4;  /* RW */
@@ -673,14 +1019,40 @@ union uvh_lb_bau_misc_control_u {
 	unsigned long	enable_programmed_initial_priority :  1;  /* RW */
 	unsigned long	rsvd_29_47                         : 19;  /*    */
 	unsigned long	fun                                : 16;  /* RW */
-    } s;
+    } s1;
+    struct uv2h_lb_bau_misc_control_s {
+	unsigned long	rejection_delay                      :  8;  /* RW */
+	unsigned long	apic_mode                            :  1;  /* RW */
+	unsigned long	force_broadcast                      :  1;  /* RW */
+	unsigned long	force_lock_nop                       :  1;  /* RW */
+	unsigned long	qpi_agent_presence_vector            :  3;  /* RW */
+	unsigned long	descriptor_fetch_mode                :  1;  /* RW */
+	unsigned long	enable_intd_soft_ack_mode            :  1;  /* RW */
+	unsigned long	intd_soft_ack_timeout_period         :  4;  /* RW */
+	unsigned long	enable_dual_mapping_mode             :  1;  /* RW */
+	unsigned long	vga_io_port_decode_enable            :  1;  /* RW */
+	unsigned long	vga_io_port_16_bit_decode            :  1;  /* RW */
+	unsigned long	suppress_dest_registration           :  1;  /* RW */
+	unsigned long	programmed_initial_priority          :  3;  /* RW */
+	unsigned long	use_incoming_priority                :  1;  /* RW */
+	unsigned long	enable_programmed_initial_priority   :  1;  /* RW */
+	unsigned long	enable_automatic_apic_mode_selection :  1;  /* RW */
+	unsigned long	apic_mode_status                     :  1;  /* RO */
+	unsigned long	suppress_interrupts_to_self          :  1;  /* RW */
+	unsigned long	enable_lock_based_system_flush       :  1;  /* RW */
+	unsigned long	enable_extended_sb_status            :  1;  /* RW */
+	unsigned long	suppress_int_prio_udt_to_self        :  1;  /* RW */
+	unsigned long	use_legacy_descriptor_formats        :  1;  /* RW */
+	unsigned long	rsvd_36_47                           : 12;  /*    */
+	unsigned long	fun                                  : 16;  /* RW */
+    } s2;
 };
 
 /* ========================================================================= */
 /*                     UVH_LB_BAU_SB_ACTIVATION_CONTROL                      */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL 0x320020UL
-#define UVH_LB_BAU_SB_ACTIVATION_CONTROL_32 0x009a8
+#define UVH_LB_BAU_SB_ACTIVATION_CONTROL_32 0x9a8
 
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL_INDEX_SHFT 0
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL_INDEX_MASK 0x000000000000003fUL
@@ -703,7 +1075,7 @@ union uvh_lb_bau_sb_activation_control_u
 /*                    UVH_LB_BAU_SB_ACTIVATION_STATUS_0                      */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_0 0x320030UL
-#define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_32 0x009b0
+#define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_32 0x9b0
 
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_STATUS_SHFT 0
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_STATUS_MASK 0xffffffffffffffffUL
@@ -719,7 +1091,7 @@ union uvh_lb_bau_sb_activation_status_0_
 /*                    UVH_LB_BAU_SB_ACTIVATION_STATUS_1                      */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_1 0x320040UL
-#define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_32 0x009b8
+#define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_32 0x9b8
 
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_STATUS_SHFT 0
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_STATUS_MASK 0xffffffffffffffffUL
@@ -735,7 +1107,7 @@ union uvh_lb_bau_sb_activation_status_1_
 /*                      UVH_LB_BAU_SB_DESCRIPTOR_BASE                        */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_DESCRIPTOR_BASE 0x320010UL
-#define UVH_LB_BAU_SB_DESCRIPTOR_BASE_32 0x009a0
+#define UVH_LB_BAU_SB_DESCRIPTOR_BASE_32 0x9a0
 
 #define UVH_LB_BAU_SB_DESCRIPTOR_BASE_PAGE_ADDRESS_SHFT 12
 #define UVH_LB_BAU_SB_DESCRIPTOR_BASE_PAGE_ADDRESS_MASK 0x000007fffffff000UL
@@ -754,23 +1126,6 @@ union uvh_lb_bau_sb_descriptor_base_u {
 };
 
 /* ========================================================================= */
-/*                   UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK                     */
-/* ========================================================================= */
-#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK 0x320130UL
-#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK_32 0x009f0
-
-#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_SHFT 0
-#define UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_MASK 0x00000000ffffffffUL
-
-union uvh_lb_target_physical_apic_id_mask_u {
-	unsigned long v;
-	struct uvh_lb_target_physical_apic_id_mask_s {
-		unsigned long bit_enables : 32;  /* RW */
-		unsigned long rsvd_32_63  : 32;  /*    */
-	} s;
-};
-
-/* ========================================================================= */
 /*                               UVH_NODE_ID                                 */
 /* ========================================================================= */
 #define UVH_NODE_ID 0x0UL
@@ -785,10 +1140,36 @@ union uvh_lb_target_physical_apic_id_mas
 #define UVH_NODE_ID_REVISION_MASK 0x00000000f0000000UL
 #define UVH_NODE_ID_NODE_ID_SHFT 32
 #define UVH_NODE_ID_NODE_ID_MASK 0x00007fff00000000UL
-#define UVH_NODE_ID_NODES_PER_BIT_SHFT 48
-#define UVH_NODE_ID_NODES_PER_BIT_MASK 0x007f000000000000UL
-#define UVH_NODE_ID_NI_PORT_SHFT 56
-#define UVH_NODE_ID_NI_PORT_MASK 0x0f00000000000000UL
+
+#define UV1H_NODE_ID_FORCE1_SHFT 0
+#define UV1H_NODE_ID_FORCE1_MASK 0x0000000000000001UL
+#define UV1H_NODE_ID_MANUFACTURER_SHFT 1
+#define UV1H_NODE_ID_MANUFACTURER_MASK 0x0000000000000ffeUL
+#define UV1H_NODE_ID_PART_NUMBER_SHFT 12
+#define UV1H_NODE_ID_PART_NUMBER_MASK 0x000000000ffff000UL
+#define UV1H_NODE_ID_REVISION_SHFT 28
+#define UV1H_NODE_ID_REVISION_MASK 0x00000000f0000000UL
+#define UV1H_NODE_ID_NODE_ID_SHFT 32
+#define UV1H_NODE_ID_NODE_ID_MASK 0x00007fff00000000UL
+#define UV1H_NODE_ID_NODES_PER_BIT_SHFT 48
+#define UV1H_NODE_ID_NODES_PER_BIT_MASK 0x007f000000000000UL
+#define UV1H_NODE_ID_NI_PORT_SHFT 56
+#define UV1H_NODE_ID_NI_PORT_MASK 0x0f00000000000000UL
+
+#define UV2H_NODE_ID_FORCE1_SHFT 0
+#define UV2H_NODE_ID_FORCE1_MASK 0x0000000000000001UL
+#define UV2H_NODE_ID_MANUFACTURER_SHFT 1
+#define UV2H_NODE_ID_MANUFACTURER_MASK 0x0000000000000ffeUL
+#define UV2H_NODE_ID_PART_NUMBER_SHFT 12
+#define UV2H_NODE_ID_PART_NUMBER_MASK 0x000000000ffff000UL
+#define UV2H_NODE_ID_REVISION_SHFT 28
+#define UV2H_NODE_ID_REVISION_MASK 0x00000000f0000000UL
+#define UV2H_NODE_ID_NODE_ID_SHFT 32
+#define UV2H_NODE_ID_NODE_ID_MASK 0x00007fff00000000UL
+#define UV2H_NODE_ID_NODES_PER_BIT_SHFT 50
+#define UV2H_NODE_ID_NODES_PER_BIT_MASK 0x01fc000000000000UL
+#define UV2H_NODE_ID_NI_PORT_SHFT 57
+#define UV2H_NODE_ID_NI_PORT_MASK 0x3e00000000000000UL
 
 union uvh_node_id_u {
     unsigned long	v;
@@ -798,12 +1179,31 @@ union uvh_node_id_u {
 	unsigned long	part_number   : 16;  /* RO */
 	unsigned long	revision      :  4;  /* RO */
 	unsigned long	node_id       : 15;  /* RW */
+	unsigned long	rsvd_47_63    : 17;
+    } s;
+    struct uv1h_node_id_s {
+	unsigned long	force1        :  1;  /* RO */
+	unsigned long	manufacturer  : 11;  /* RO */
+	unsigned long	part_number   : 16;  /* RO */
+	unsigned long	revision      :  4;  /* RO */
+	unsigned long	node_id       : 15;  /* RW */
 	unsigned long	rsvd_47       :  1;  /*    */
 	unsigned long	nodes_per_bit :  7;  /* RW */
 	unsigned long	rsvd_55       :  1;  /*    */
 	unsigned long	ni_port       :  4;  /* RO */
 	unsigned long	rsvd_60_63    :  4;  /*    */
-    } s;
+    } s1;
+    struct uv2h_node_id_s {
+	unsigned long	force1        :  1;  /* RO */
+	unsigned long	manufacturer  : 11;  /* RO */
+	unsigned long	part_number   : 16;  /* RO */
+	unsigned long	revision      :  4;  /* RO */
+	unsigned long	node_id       : 15;  /* RW */
+	unsigned long	rsvd_47_49    :  3;  /*    */
+	unsigned long	nodes_per_bit :  7;  /* RO */
+	unsigned long	ni_port       :  5;  /* RO */
+	unsigned long	rsvd_62_63    :  2;  /*    */
+    } s2;
 };
 
 /* ========================================================================= */
@@ -954,18 +1354,38 @@ union uvh_rh_gam_alias210_redirect_confi
 #define UVH_RH_GAM_CONFIG_MMR_M_SKT_MASK 0x000000000000003fUL
 #define UVH_RH_GAM_CONFIG_MMR_N_SKT_SHFT 6
 #define UVH_RH_GAM_CONFIG_MMR_N_SKT_MASK 0x00000000000003c0UL
-#define UVH_RH_GAM_CONFIG_MMR_MMIOL_CFG_SHFT 12
-#define UVH_RH_GAM_CONFIG_MMR_MMIOL_CFG_MASK 0x0000000000001000UL
+
+#define UV1H_RH_GAM_CONFIG_MMR_M_SKT_SHFT 0
+#define UV1H_RH_GAM_CONFIG_MMR_M_SKT_MASK 0x000000000000003fUL
+#define UV1H_RH_GAM_CONFIG_MMR_N_SKT_SHFT 6
+#define UV1H_RH_GAM_CONFIG_MMR_N_SKT_MASK 0x00000000000003c0UL
+#define UV1H_RH_GAM_CONFIG_MMR_MMIOL_CFG_SHFT 12
+#define UV1H_RH_GAM_CONFIG_MMR_MMIOL_CFG_MASK 0x0000000000001000UL
+
+#define UV2H_RH_GAM_CONFIG_MMR_M_SKT_SHFT 0
+#define UV2H_RH_GAM_CONFIG_MMR_M_SKT_MASK 0x000000000000003fUL
+#define UV2H_RH_GAM_CONFIG_MMR_N_SKT_SHFT 6
+#define UV2H_RH_GAM_CONFIG_MMR_N_SKT_MASK 0x00000000000003c0UL
 
 union uvh_rh_gam_config_mmr_u {
     unsigned long	v;
     struct uvh_rh_gam_config_mmr_s {
 	unsigned long	m_skt     :  6;  /* RW */
 	unsigned long	n_skt     :  4;  /* RW */
+	unsigned long	rsvd_10_63    : 54;
+    } s;
+    struct uv1h_rh_gam_config_mmr_s {
+	unsigned long	m_skt     :  6;  /* RW */
+	unsigned long	n_skt     :  4;  /* RW */
 	unsigned long	rsvd_10_11:  2;  /*    */
 	unsigned long	mmiol_cfg :  1;  /* RW */
 	unsigned long	rsvd_13_63: 51;  /*    */
-    } s;
+    } s1;
+    struct uv2h_rh_gam_config_mmr_s {
+	unsigned long	m_skt :  6;  /* RW */
+	unsigned long	n_skt :  4;  /* RW */
+	unsigned long	rsvd_10_63: 54;  /*    */
+    } s2;
 };
 
 /* ========================================================================= */
@@ -975,25 +1395,49 @@ union uvh_rh_gam_config_mmr_u {
 
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT 28
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffff0000000UL
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_SHFT 48
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_MASK 0x0001000000000000UL
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_SHFT 52
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_MASK 0x00f0000000000000UL
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT 28
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffff0000000UL
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_SHFT 48
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_MASK 0x0001000000000000UL
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_SHFT 52
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_MASK 0x00f0000000000000UL
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT 28
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffff0000000UL
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_SHFT 52
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_MASK 0x00f0000000000000UL
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
 
 union uvh_rh_gam_gru_overlay_config_mmr_u {
     unsigned long	v;
     struct uvh_rh_gam_gru_overlay_config_mmr_s {
 	unsigned long	rsvd_0_27: 28;  /*    */
 	unsigned long	base   : 18;  /* RW */
+	unsigned long	rsvd_46_62    : 17;
+	unsigned long	enable :  1;  /* RW */
+    } s;
+    struct uv1h_rh_gam_gru_overlay_config_mmr_s {
+	unsigned long	rsvd_0_27: 28;  /*    */
+	unsigned long	base   : 18;  /* RW */
 	unsigned long	rsvd_46_47:  2;  /*    */
 	unsigned long	gr4    :  1;  /* RW */
 	unsigned long	rsvd_49_51:  3;  /*    */
 	unsigned long	n_gru  :  4;  /* RW */
 	unsigned long	rsvd_56_62:  7;  /*    */
 	unsigned long	enable :  1;  /* RW */
-    } s;
+    } s1;
+    struct uv2h_rh_gam_gru_overlay_config_mmr_s {
+	unsigned long	rsvd_0_27: 28;  /*    */
+	unsigned long	base   : 18;  /* RW */
+	unsigned long	rsvd_46_51:  6;  /*    */
+	unsigned long	n_gru  :  4;  /* RW */
+	unsigned long	rsvd_56_62:  7;  /*    */
+	unsigned long	enable :  1;  /* RW */
+    } s2;
 };
 
 /* ========================================================================= */
@@ -1001,25 +1445,42 @@ union uvh_rh_gam_gru_overlay_config_mmr_
 /* ========================================================================= */
 #define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR 0x1600030UL
 
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT 30
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003fffc0000000UL
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_SHFT 46
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_MASK 0x000fc00000000000UL
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_SHFT 52
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_MASK 0x00f0000000000000UL
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT 30
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003fffc0000000UL
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_SHFT 46
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_MASK 0x000fc00000000000UL
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_SHFT 52
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_MASK 0x00f0000000000000UL
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT 27
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffff8000000UL
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_SHFT 46
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_MASK 0x000fc00000000000UL
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_SHFT 52
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_N_IO_MASK 0x00f0000000000000UL
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
 
 union uvh_rh_gam_mmioh_overlay_config_mmr_u {
     unsigned long	v;
-    struct uvh_rh_gam_mmioh_overlay_config_mmr_s {
+    struct uv1h_rh_gam_mmioh_overlay_config_mmr_s {
 	unsigned long	rsvd_0_29: 30;  /*    */
 	unsigned long	base   : 16;  /* RW */
 	unsigned long	m_io   :  6;  /* RW */
 	unsigned long	n_io   :  4;  /* RW */
 	unsigned long	rsvd_56_62:  7;  /*    */
 	unsigned long	enable :  1;  /* RW */
-    } s;
+    } s1;
+    struct uv2h_rh_gam_mmioh_overlay_config_mmr_s {
+	unsigned long	rsvd_0_26: 27;  /*    */
+	unsigned long	base   : 19;  /* RW */
+	unsigned long	m_io   :  6;  /* RW */
+	unsigned long	n_io   :  4;  /* RW */
+	unsigned long	rsvd_56_62:  7;  /*    */
+	unsigned long	enable :  1;  /* RW */
+    } s2;
 };
 
 /* ========================================================================= */
@@ -1029,20 +1490,40 @@ union uvh_rh_gam_mmioh_overlay_config_mm
 
 #define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT 26
 #define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffffc000000UL
-#define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_DUAL_HUB_SHFT 46
-#define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_DUAL_HUB_MASK 0x0000400000000000UL
-#define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
-#define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT 26
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffffc000000UL
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_DUAL_HUB_SHFT 46
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_DUAL_HUB_MASK 0x0000400000000000UL
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
+
+#define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT 26
+#define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffffc000000UL
+#define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
+#define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
 
 union uvh_rh_gam_mmr_overlay_config_mmr_u {
     unsigned long	v;
     struct uvh_rh_gam_mmr_overlay_config_mmr_s {
 	unsigned long	rsvd_0_25: 26;  /*    */
 	unsigned long	base     : 20;  /* RW */
+	unsigned long	rsvd_46_62    : 17;
+	unsigned long	enable   :  1;  /* RW */
+    } s;
+    struct uv1h_rh_gam_mmr_overlay_config_mmr_s {
+	unsigned long	rsvd_0_25: 26;  /*    */
+	unsigned long	base     : 20;  /* RW */
 	unsigned long	dual_hub :  1;  /* RW */
 	unsigned long	rsvd_47_62: 16;  /*    */
 	unsigned long	enable   :  1;  /* RW */
-    } s;
+    } s1;
+    struct uv2h_rh_gam_mmr_overlay_config_mmr_s {
+	unsigned long	rsvd_0_25: 26;  /*    */
+	unsigned long	base   : 20;  /* RW */
+	unsigned long	rsvd_46_62: 17;  /*    */
+	unsigned long	enable :  1;  /* RW */
+    } s2;
 };
 
 /* ========================================================================= */
@@ -1103,10 +1584,11 @@ union uvh_rtc1_int_config_u {
 /*                               UVH_SCRATCH5                                */
 /* ========================================================================= */
 #define UVH_SCRATCH5 0x2d0200UL
-#define UVH_SCRATCH5_32 0x00778
+#define UVH_SCRATCH5_32 0x778
 
 #define UVH_SCRATCH5_SCRATCH5_SHFT 0
 #define UVH_SCRATCH5_SCRATCH5_MASK 0xffffffffffffffffUL
+
 union uvh_scratch5_u {
     unsigned long	v;
     struct uvh_scratch5_s {
@@ -1114,4 +1596,154 @@ union uvh_scratch5_u {
     } s;
 };
 
+/* ========================================================================= */
+/*                           UV2H_EVENT_OCCURRED2                            */
+/* ========================================================================= */
+#define UV2H_EVENT_OCCURRED2 0x70100UL
+#define UV2H_EVENT_OCCURRED2_32 0xb68
+
+#define UV2H_EVENT_OCCURRED2_RTC_0_SHFT 0
+#define UV2H_EVENT_OCCURRED2_RTC_0_MASK 0x0000000000000001UL
+#define UV2H_EVENT_OCCURRED2_RTC_1_SHFT 1
+#define UV2H_EVENT_OCCURRED2_RTC_1_MASK 0x0000000000000002UL
+#define UV2H_EVENT_OCCURRED2_RTC_2_SHFT 2
+#define UV2H_EVENT_OCCURRED2_RTC_2_MASK 0x0000000000000004UL
+#define UV2H_EVENT_OCCURRED2_RTC_3_SHFT 3
+#define UV2H_EVENT_OCCURRED2_RTC_3_MASK 0x0000000000000008UL
+#define UV2H_EVENT_OCCURRED2_RTC_4_SHFT 4
+#define UV2H_EVENT_OCCURRED2_RTC_4_MASK 0x0000000000000010UL
+#define UV2H_EVENT_OCCURRED2_RTC_5_SHFT 5
+#define UV2H_EVENT_OCCURRED2_RTC_5_MASK 0x0000000000000020UL
+#define UV2H_EVENT_OCCURRED2_RTC_6_SHFT 6
+#define UV2H_EVENT_OCCURRED2_RTC_6_MASK 0x0000000000000040UL
+#define UV2H_EVENT_OCCURRED2_RTC_7_SHFT 7
+#define UV2H_EVENT_OCCURRED2_RTC_7_MASK 0x0000000000000080UL
+#define UV2H_EVENT_OCCURRED2_RTC_8_SHFT 8
+#define UV2H_EVENT_OCCURRED2_RTC_8_MASK 0x0000000000000100UL
+#define UV2H_EVENT_OCCURRED2_RTC_9_SHFT 9
+#define UV2H_EVENT_OCCURRED2_RTC_9_MASK 0x0000000000000200UL
+#define UV2H_EVENT_OCCURRED2_RTC_10_SHFT 10
+#define UV2H_EVENT_OCCURRED2_RTC_10_MASK 0x0000000000000400UL
+#define UV2H_EVENT_OCCURRED2_RTC_11_SHFT 11
+#define UV2H_EVENT_OCCURRED2_RTC_11_MASK 0x0000000000000800UL
+#define UV2H_EVENT_OCCURRED2_RTC_12_SHFT 12
+#define UV2H_EVENT_OCCURRED2_RTC_12_MASK 0x0000000000001000UL
+#define UV2H_EVENT_OCCURRED2_RTC_13_SHFT 13
+#define UV2H_EVENT_OCCURRED2_RTC_13_MASK 0x0000000000002000UL
+#define UV2H_EVENT_OCCURRED2_RTC_14_SHFT 14
+#define UV2H_EVENT_OCCURRED2_RTC_14_MASK 0x0000000000004000UL
+#define UV2H_EVENT_OCCURRED2_RTC_15_SHFT 15
+#define UV2H_EVENT_OCCURRED2_RTC_15_MASK 0x0000000000008000UL
+#define UV2H_EVENT_OCCURRED2_RTC_16_SHFT 16
+#define UV2H_EVENT_OCCURRED2_RTC_16_MASK 0x0000000000010000UL
+#define UV2H_EVENT_OCCURRED2_RTC_17_SHFT 17
+#define UV2H_EVENT_OCCURRED2_RTC_17_MASK 0x0000000000020000UL
+#define UV2H_EVENT_OCCURRED2_RTC_18_SHFT 18
+#define UV2H_EVENT_OCCURRED2_RTC_18_MASK 0x0000000000040000UL
+#define UV2H_EVENT_OCCURRED2_RTC_19_SHFT 19
+#define UV2H_EVENT_OCCURRED2_RTC_19_MASK 0x0000000000080000UL
+#define UV2H_EVENT_OCCURRED2_RTC_20_SHFT 20
+#define UV2H_EVENT_OCCURRED2_RTC_20_MASK 0x0000000000100000UL
+#define UV2H_EVENT_OCCURRED2_RTC_21_SHFT 21
+#define UV2H_EVENT_OCCURRED2_RTC_21_MASK 0x0000000000200000UL
+#define UV2H_EVENT_OCCURRED2_RTC_22_SHFT 22
+#define UV2H_EVENT_OCCURRED2_RTC_22_MASK 0x0000000000400000UL
+#define UV2H_EVENT_OCCURRED2_RTC_23_SHFT 23
+#define UV2H_EVENT_OCCURRED2_RTC_23_MASK 0x0000000000800000UL
+#define UV2H_EVENT_OCCURRED2_RTC_24_SHFT 24
+#define UV2H_EVENT_OCCURRED2_RTC_24_MASK 0x0000000001000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_25_SHFT 25
+#define UV2H_EVENT_OCCURRED2_RTC_25_MASK 0x0000000002000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_26_SHFT 26
+#define UV2H_EVENT_OCCURRED2_RTC_26_MASK 0x0000000004000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_27_SHFT 27
+#define UV2H_EVENT_OCCURRED2_RTC_27_MASK 0x0000000008000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_28_SHFT 28
+#define UV2H_EVENT_OCCURRED2_RTC_28_MASK 0x0000000010000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_29_SHFT 29
+#define UV2H_EVENT_OCCURRED2_RTC_29_MASK 0x0000000020000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_30_SHFT 30
+#define UV2H_EVENT_OCCURRED2_RTC_30_MASK 0x0000000040000000UL
+#define UV2H_EVENT_OCCURRED2_RTC_31_SHFT 31
+#define UV2H_EVENT_OCCURRED2_RTC_31_MASK 0x0000000080000000UL
+
+union uv2h_event_occurred2_u {
+    unsigned long	v;
+    struct uv2h_event_occurred2_s {
+	unsigned long	rtc_0  :  1;  /* RW */
+	unsigned long	rtc_1  :  1;  /* RW */
+	unsigned long	rtc_2  :  1;  /* RW */
+	unsigned long	rtc_3  :  1;  /* RW */
+	unsigned long	rtc_4  :  1;  /* RW */
+	unsigned long	rtc_5  :  1;  /* RW */
+	unsigned long	rtc_6  :  1;  /* RW */
+	unsigned long	rtc_7  :  1;  /* RW */
+	unsigned long	rtc_8  :  1;  /* RW */
+	unsigned long	rtc_9  :  1;  /* RW */
+	unsigned long	rtc_10 :  1;  /* RW */
+	unsigned long	rtc_11 :  1;  /* RW */
+	unsigned long	rtc_12 :  1;  /* RW */
+	unsigned long	rtc_13 :  1;  /* RW */
+	unsigned long	rtc_14 :  1;  /* RW */
+	unsigned long	rtc_15 :  1;  /* RW */
+	unsigned long	rtc_16 :  1;  /* RW */
+	unsigned long	rtc_17 :  1;  /* RW */
+	unsigned long	rtc_18 :  1;  /* RW */
+	unsigned long	rtc_19 :  1;  /* RW */
+	unsigned long	rtc_20 :  1;  /* RW */
+	unsigned long	rtc_21 :  1;  /* RW */
+	unsigned long	rtc_22 :  1;  /* RW */
+	unsigned long	rtc_23 :  1;  /* RW */
+	unsigned long	rtc_24 :  1;  /* RW */
+	unsigned long	rtc_25 :  1;  /* RW */
+	unsigned long	rtc_26 :  1;  /* RW */
+	unsigned long	rtc_27 :  1;  /* RW */
+	unsigned long	rtc_28 :  1;  /* RW */
+	unsigned long	rtc_29 :  1;  /* RW */
+	unsigned long	rtc_30 :  1;  /* RW */
+	unsigned long	rtc_31 :  1;  /* RW */
+	unsigned long	rsvd_32_63: 32;  /*    */
+    } s1;
+};
+
+/* ========================================================================= */
+/*                        UV2H_EVENT_OCCURRED2_ALIAS                         */
+/* ========================================================================= */
+#define UV2H_EVENT_OCCURRED2_ALIAS 0x70108UL
+#define UV2H_EVENT_OCCURRED2_ALIAS_32 0xb70
+
+/* ========================================================================= */
+/*                    UV2H_LB_BAU_SB_ACTIVATION_STATUS_2                     */
+/* ========================================================================= */
+#define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2 0x320130UL
+#define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2_32 0x9f0
+
+#define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2_AUX_ERROR_SHFT 0
+#define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2_AUX_ERROR_MASK 0xffffffffffffffffUL
+
+union uv2h_lb_bau_sb_activation_status_2_u {
+    unsigned long	v;
+    struct uv2h_lb_bau_sb_activation_status_2_s {
+	unsigned long	aux_error : 64;  /* RW */
+    } s1;
+};
+
+/* ========================================================================= */
+/*                   UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK                    */
+/* ========================================================================= */
+#define UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK 0x320130UL
+#define UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK_32 0x9f0
+
+#define UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_SHFT 0
+#define UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK_BIT_ENABLES_MASK 0x00000000ffffffffUL
+
+union uv1h_lb_target_physical_apic_id_mask_u {
+    unsigned long	v;
+    struct uv1h_lb_target_physical_apic_id_mask_s {
+	unsigned long	bit_enables : 32;  /* RW */
+	unsigned long	rsvd_32_63  : 32;  /*    */
+    } s1;
+};
+
+
 #endif /* __ASM_UV_MMRS_X86_H__ */
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2011-05-10 13:45:37.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2011-05-10 13:45:46.439167832 -0500
@@ -89,6 +89,10 @@ static int __init early_get_pnodeid(void
 	m_n_config.v = uv_early_read_mmr(UVH_RH_GAM_CONFIG_MMR);
 	uv_min_hub_revision_id = node_id.s.revision;
 
+	if (node_id.s.part_number == UV2_HUB_PART_NUMBER)
+		uv_min_hub_revision_id += UV2_HUB_REVISION_BASE - 1;
+
+	uv_hub_info->hub_revision = uv_min_hub_revision_id;
 	pnode = (node_id.s.node_id >> 1) & ((1 << m_n_config.s.n_skt) - 1);
 	return pnode;
 }
@@ -110,17 +114,23 @@ static void __init early_get_apic_pnode_
  */
 static void __init uv_set_apicid_hibit(void)
 {
-	union uvh_lb_target_physical_apic_id_mask_u apicid_mask;
+	union uv1h_lb_target_physical_apic_id_mask_u apicid_mask;
 
-	apicid_mask.v = uv_early_read_mmr(UVH_LB_TARGET_PHYSICAL_APIC_ID_MASK);
-	uv_apicid_hibits = apicid_mask.s.bit_enables & UV_APICID_HIBIT_MASK;
+	if (is_uv1_hub()) {
+		apicid_mask.v = uv_early_read_mmr(UV1H_LB_TARGET_PHYSICAL_APIC_ID_MASK);
+		uv_apicid_hibits = apicid_mask.s1.bit_enables & UV_APICID_HIBIT_MASK;
+	}
 }
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	int pnodeid;
+	int pnodeid, is_uv1, is_uv2;
 
-	if (!strcmp(oem_id, "SGI")) {
+	is_uv1 = !strcmp(oem_id, "SGI");
+	is_uv2 = !strcmp(oem_id, "SGI2");
+	if (is_uv1 || is_uv2) {
+		uv_hub_info->hub_revision =
+			is_uv1 ? UV1_HUB_REVISION_BASE : UV2_HUB_REVISION_BASE;
 		pnodeid = early_get_pnodeid();
 		early_get_apic_pnode_shift();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
@@ -477,12 +487,19 @@ static __init void map_mmr_high(int max_
 static __init void map_mmioh_high(int max_pnode)
 {
 	union uvh_rh_gam_mmioh_overlay_config_mmr_u mmioh;
-	int shift = UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT;
+	int shift;
 
 	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
-	if (mmioh.s.enable)
-		map_high("MMIOH", mmioh.s.base, shift, mmioh.s.m_io,
+	if (is_uv1_hub() && mmioh.s1.enable) {
+		shift = UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT;
+		map_high("MMIOH", mmioh.s1.base, shift, mmioh.s1.m_io,
+			max_pnode, map_uc);
+	}
+	if (is_uv2_hub() && mmioh.s2.enable) {
+		shift = UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT;
+		map_high("MMIOH", mmioh.s2.base, shift, mmioh.s2.m_io,
 			max_pnode, map_uc);
+	}
 }
 
 static __init void map_low_mmrs(void)
@@ -729,13 +746,14 @@ void __init uv_system_init(void)
 	unsigned long mmr_base, present, paddr;
 	unsigned short pnode_mask, pnode_io_mask;
 
+	printk("UV: Found %s hub\n", is_uv1_hub() ? "UV1" : "UV2");
 	map_low_mmrs();
 
 	m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
 	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
-	n_io = mmioh.s.n_io;
+	n_io = is_uv1_hub() ? mmioh.s1.n_io : mmioh.s2.n_io;
 	mmr_base =
 	    uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR) &
 	    ~UV_MMR_ENABLE;
@@ -804,6 +822,8 @@ void __init uv_system_init(void)
 		 */
 		uv_cpu_hub_info(cpu)->pnode_mask = pnode_mask;
 		uv_cpu_hub_info(cpu)->apic_pnode_shift = uvh_apicid.s.pnode_shift;
+		uv_cpu_hub_info(cpu)->hub_revision = uv_hub_info->hub_revision;
+
 		pnode = uv_apicid_to_pnode(apicid);
 		blade = boot_pnode_to_blade(pnode);
 		lcpu = uv_blade_info[blade].nr_possible_cpus;
Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c	2011-05-10 13:45:38.000000000 -0500
+++ linux/arch/x86/platform/uv/tlb_uv.c	2011-05-10 13:45:46.487160049 -0500
@@ -402,50 +402,109 @@ static int uv_wait_completion(struct bau
 	struct bau_control *bcp, struct bau_control *smaster, long try)
 {
 	unsigned long descriptor_status;
+	unsigned long descriptor_status2;
+	int cpu;
 	cycles_t ttime;
 	struct ptc_stats *stat = bcp->statp;
 	struct bau_control *hmaster;
 
 	hmaster = bcp->uvhub_master;
 
-	/* spin on the status MMR, waiting for it to go idle */
-	while ((descriptor_status = (((unsigned long)
-		uv_read_local_mmr(mmr_offset) >>
-			right_shift) & UV_ACT_STATUS_MASK)) !=
-			DESC_STATUS_IDLE) {
-		/*
-		 * Our software ack messages may be blocked because there are
-		 * no swack resources available.  As long as none of them
-		 * has timed out hardware will NACK our message and its
-		 * state will stay IDLE.
-		 */
-		if (descriptor_status == DESC_STATUS_SOURCE_TIMEOUT) {
-			stat->s_stimeout++;
-			return FLUSH_GIVEUP;
-		} else if (descriptor_status ==
-					DESC_STATUS_DESTINATION_TIMEOUT) {
-			stat->s_dtimeout++;
-			ttime = get_cycles();
-
+	if (is_uv1_hub()) {
+		/* spin on the status MMR, waiting for it to go idle */
+		while ((descriptor_status = (((unsigned long)
+			uv_read_local_mmr(mmr_offset) >>
+				right_shift) & UV_ACT_STATUS_MASK)) !=
+				DESC_STATUS_IDLE) {
 			/*
-			 * Our retries may be blocked by all destination
-			 * swack resources being consumed, and a timeout
-			 * pending.  In that case hardware returns the
-			 * ERROR that looks like a destination timeout.
+			 * Our software ack messages may be blocked because
+			 * there are no swack resources available.  As long
+			 * as none of them has timed out hardware will NACK
+			 * our message and its state will stay IDLE.
 			 */
-			if (cycles_2_us(ttime - bcp->send_message) <
-							timeout_us) {
+			if (descriptor_status == DESC_STATUS_SOURCE_TIMEOUT) {
+				stat->s_stimeout++;
+				return FLUSH_GIVEUP;
+			} else if (descriptor_status ==
+					DESC_STATUS_DESTINATION_TIMEOUT) {
+				stat->s_dtimeout++;
+				ttime = get_cycles();
+
+				/*
+				 * Our retries may be blocked by all destination
+				 * swack resources being consumed, and a timeout
+				 * pending.  In that case hardware returns the
+				 * ERROR that looks like a destination timeout.
+				 */
+				if (cycles_2_us(ttime - bcp->send_message) <
+								timeout_us) {
+					bcp->conseccompletes = 0;
+					return FLUSH_RETRY_PLUGGED;
+				}
+
 				bcp->conseccompletes = 0;
-				return FLUSH_RETRY_PLUGGED;
+				return FLUSH_RETRY_TIMEOUT;
+			} else {
+				/*
+				 * descriptor_status is still BUSY
+				 */
+				cpu_relax();
 			}
-
-			bcp->conseccompletes = 0;
-			return FLUSH_RETRY_TIMEOUT;
-		} else {
+		}
+	} else {
+		/* UV2 has an extra bit of status */
+		cpu = bcp->uvhub_cpu;
+		/* spin on the status MMR, waiting for it to go idle */
+		descriptor_status = (((unsigned long)(uv_read_local_mmr
+			(mmr_offset)) >> right_shift) & UV_ACT_STATUS_MASK);
+		descriptor_status2 = (((unsigned long)uv_read_local_mmr
+			(UV2H_LB_BAU_SB_ACTIVATION_STATUS_2) >> cpu) & 0x1UL);
+		descriptor_status = (descriptor_status << 1) |
+			descriptor_status2;
+		while (descriptor_status != UV2H_DESC_IDLE) {
 			/*
-			 * descriptor_status is still BUSY
+			 * Our software ack messages may be blocked because
+			 * there are no swack resources available.  As long
+			 * as none of them has timed out hardware will NACK
+			 * our message and its state will stay IDLE.
 			 */
-			cpu_relax();
+			if ((descriptor_status == UV2H_DESC_SOURCE_TIMEOUT) ||
+			    (descriptor_status == UV2H_DESC_DEST_STRONG_NACK) ||
+			    (descriptor_status == UV2H_DESC_DEST_PUT_ERR)) {
+				stat->s_stimeout++;
+				return FLUSH_GIVEUP;
+			} else if (descriptor_status == UV2H_DESC_DEST_TIMEOUT) {
+				stat->s_dtimeout++;
+				ttime = get_cycles();
+
+				/*
+				 * Our retries may be blocked by all destination
+				 * swack resources being consumed, and a timeout
+				 * pending.  In that case hardware returns the
+				 * ERROR that looks like a destination timeout.
+				 */
+				if (cycles_2_us(ttime - bcp->send_message) <
+								timeout_us) {
+					bcp->conseccompletes = 0;
+					return FLUSH_RETRY_PLUGGED;
+				}
+
+				bcp->conseccompletes = 0;
+				return FLUSH_RETRY_TIMEOUT;
+			} else {
+				/*
+				 * descriptor_status is still BUSY
+				 */
+				cpu_relax();
+			}
+			descriptor_status = (((unsigned long)(uv_read_local_mmr
+				(mmr_offset)) >> right_shift) &
+				UV_ACT_STATUS_MASK);
+			descriptor_status2 = (((unsigned long)uv_read_local_mmr
+				(UV2H_LB_BAU_SB_ACTIVATION_STATUS_2) >> cpu) &
+				0x1UL);
+			descriptor_status = (descriptor_status << 1) |
+				descriptor_status2;
 		}
 	}
 	bcp->conseccompletes++;
@@ -585,8 +644,9 @@ int uv_flush_send_and_wait(struct bau_de
 	struct bau_control *smaster = bcp->socket_master;
 	struct bau_control *hmaster = bcp->uvhub_master;
 
-	if (!atomic_inc_unless_ge(&hmaster->uvhub_lock,
-			&hmaster->active_descriptor_count,
+	if (is_uv1_hub()  &&
+			!atomic_inc_unless_ge(&hmaster->uvhub_lock,
+			& hmaster->active_descriptor_count,
 			hmaster->max_bau_concurrent)) {
 		stat->s_throttles++;
 		do {
@@ -899,12 +959,17 @@ static void __init uv_enable_timeouts(vo
 		uv_write_global_mmr64
 		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
 		/*
+		 * UV1:
 		 * Subsequent reversals of the timebase bit (3) cause an
 		 * immediate timeout of one or all INTD resources as
 		 * indicated in bits 2:0 (7 causes all of them to timeout).
 		 */
 		mmr_image |= ((unsigned long)1 <<
 		    UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT);
+		if (is_uv2_hub()) {
+			mmr_image |= ((unsigned long)1 << UV2_LEG_SHFT);
+			mmr_image |= ((unsigned long)1 << UV2_EXT_SHFT);
+		}
 		uv_write_global_mmr64
 		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
 	}
@@ -1486,14 +1551,27 @@ calculate_destination_timeout(void)
 	int ret;
 	unsigned long ts_ns;
 
-	mult1 = UV_INTD_SOFT_ACK_TIMEOUT_PERIOD & BAU_MISC_CONTROL_MULT_MASK;
-	mmr_image = uv_read_local_mmr(UVH_AGING_PRESCALE_SEL);
-	index = (mmr_image >> BAU_URGENCY_7_SHIFT) & BAU_URGENCY_7_MASK;
-	mmr_image = uv_read_local_mmr(UVH_TRANSACTION_TIMEOUT);
-	mult2 = (mmr_image >> BAU_TRANS_SHIFT) & BAU_TRANS_MASK;
-	base = timeout_base_ns[index];
-	ts_ns = base * mult1 * mult2;
-	ret = ts_ns / 1000;
+	if (is_uv1_hub()) {
+		mult1 = UV1_INTD_SOFT_ACK_TIMEOUT_PERIOD &
+			BAU_MISC_CONTROL_MULT_MASK;
+		mmr_image = uv_read_local_mmr(UVH_AGING_PRESCALE_SEL);
+		index = (mmr_image >> BAU_URGENCY_7_SHIFT) & BAU_URGENCY_7_MASK;
+		mmr_image = uv_read_local_mmr(UVH_TRANSACTION_TIMEOUT);
+		mult2 = (mmr_image >> BAU_TRANS_SHIFT) & BAU_TRANS_MASK;
+		base = timeout_base_ns[index];
+		ts_ns = base * mult1 * mult2;
+		ret = ts_ns / 1000;
+	} else {
+		/* 4 bits  0/1 for 10/80us, 3 bits of multiplier */
+		mmr_image = uv_read_local_mmr(UVH_AGING_PRESCALE_SEL);
+		mmr_image = (mmr_image & UV_SA_MASK) >> UV_SA_SHFT;
+		if (mmr_image & ((unsigned long)1 << UV2_ACK_UNITS_SHFT))
+			mult1 = 80;
+		else
+			mult1 = 10;
+		base = mmr_image & UV2_ACK_MASK;
+		ret = mult1 * base;
+	}
 	return ret;
 }
 
Index: linux/arch/x86/platform/uv/uv_time.c
===================================================================
--- linux.orig/arch/x86/platform/uv/uv_time.c	2011-05-10 13:45:13.000000000 -0500
+++ linux/arch/x86/platform/uv/uv_time.c	2011-05-10 13:45:46.511167784 -0500
@@ -99,8 +99,12 @@ static void uv_rtc_send_IPI(int cpu)
 /* Check for an RTC interrupt pending */
 static int uv_intr_pending(int pnode)
 {
-	return uv_read_global_mmr64(pnode, UVH_EVENT_OCCURRED0) &
-		UVH_EVENT_OCCURRED0_RTC1_MASK;
+	if (is_uv1_hub())
+		return uv_read_global_mmr64(pnode, UVH_EVENT_OCCURRED0) &
+			UV1H_EVENT_OCCURRED0_RTC1_MASK;
+	else
+		return uv_read_global_mmr64(pnode, UV2H_EVENT_OCCURRED2) &
+			UV2H_EVENT_OCCURRED2_RTC_1_MASK;
 }
 
 /* Setup interrupt and return non-zero if early expiration occurred. */
@@ -114,8 +118,12 @@ static int uv_setup_intr(int cpu, u64 ex
 		UVH_RTC1_INT_CONFIG_M_MASK);
 	uv_write_global_mmr64(pnode, UVH_INT_CMPB, -1L);
 
-	uv_write_global_mmr64(pnode, UVH_EVENT_OCCURRED0_ALIAS,
-		UVH_EVENT_OCCURRED0_RTC1_MASK);
+	if (is_uv1_hub())
+		uv_write_global_mmr64(pnode, UVH_EVENT_OCCURRED0_ALIAS,
+				UV1H_EVENT_OCCURRED0_RTC1_MASK);
+	else
+		uv_write_global_mmr64(pnode, UV2H_EVENT_OCCURRED2_ALIAS,
+				UV2H_EVENT_OCCURRED2_RTC_1_MASK);
 
 	val = (X86_PLATFORM_IPI_VECTOR << UVH_RTC1_INT_CONFIG_VECTOR_SHFT) |
 		((u64)apicid << UVH_RTC1_INT_CONFIG_APIC_ID_SHFT);
