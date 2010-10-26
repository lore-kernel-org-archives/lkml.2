Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477Ab0JZV1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 17:27:32 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50780 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760386Ab0JZV1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 17:27:31 -0400
Date: Tue, 26 Oct 2010 16:27:28 -0500
From: Russ Anderson <rja@sgi.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Russ Anderson <rja@sgi.com>
Subject: [PATCH] x86: Enable Westmere support on SGI UV
Message-ID: <20101026212728.GB15071@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable Westmere support on SGI UV.  The UV initialization code is dependent on
the APICID bits.  Westmere-EX uses different APIC bit mapping than Nehalem-EX.
This code reads the apic shift value from a UV MMR to do the proper bit 
decoding to determint the pnode.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/include/asm/uv/uv_hub.h   |   21 ++++++++++++++++++---
 arch/x86/kernel/apic/x2apic_uv_x.c |   25 +++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 5 deletions(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-10-26 16:24:12.687649188 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-10-26 16:24:17.059197761 -0500
@@ -5,7 +5,7 @@
  *
  * SGI UV APIC functions (note: not an Intel compatible APIC)
  *
- * Copyright (C) 2007-2009 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2010 Silicon Graphics, Inc. All rights reserved.
  */
 #include <linux/cpumask.h>
 #include <linux/hardirq.h>
@@ -41,6 +41,7 @@ DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
 static u64 gru_start_paddr, gru_end_paddr;
+static union uvh_apicid uvh_apicid;
 int uv_min_hub_revision_id;
 EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
 static DEFINE_SPINLOCK(uv_nmi_lock);
@@ -70,6 +71,22 @@ static int early_get_nodeid(void)
 	return node_id.s.node_id;
 }
 
+static int __init early_get_apic_pnode_shift(void)
+{
+	unsigned long *mmr;
+
+	mmr = early_ioremap(UV_LOCAL_MMR_BASE | UVH_APICID, sizeof(*mmr));
+	uvh_apicid.v = *mmr;
+	early_iounmap(mmr, sizeof(*mmr));
+	if (!uvh_apicid.v)
+		/*
+		 * Old bios, use default value
+		 */
+		uvh_apicid.s.pnode_shift = UV_APIC_PNODE_SHIFT;
+
+	return uvh_apicid.s.pnode_shift;
+}
+
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	int nodeid;
@@ -84,7 +101,7 @@ static int __init uv_acpi_madt_oem_check
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
 			__get_cpu_var(x2apic_extra_bits) =
-				nodeid << (UV_APIC_PNODE_SHIFT - 1);
+				nodeid << (early_get_apic_pnode_shift() - 1);
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			return 1;
 		}
@@ -716,6 +733,10 @@ void __init uv_system_init(void)
 		int apicid = per_cpu(x86_cpu_to_apicid, cpu);
 
 		nid = cpu_to_node(cpu);
+		/*
+		 * apic_pnode_shift must be set before calling uv_apicid_to_pnode();
+		 */
+		uv_cpu_hub_info(cpu)->apic_pnode_shift = uvh_apicid.s.pnode_shift;
 		pnode = uv_apicid_to_pnode(apicid);
 		blade = boot_pnode_to_blade(pnode);
 		lcpu = uv_blade_info[blade].nr_possible_cpus;
Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2010-10-26 16:24:12.687649188 -0500
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2010-10-26 16:24:17.075197875 -0500
@@ -5,7 +5,7 @@
  *
  * SGI UV architectural definitions
  *
- * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2010 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_HUB_H
@@ -77,7 +77,8 @@
  *
  *		1111110000000000
  *		5432109876543210
- *		pppppppppplc0cch
+ *		pppppppppplc0cch	Nehalem-EX
+ *		ppppppppplcc0cch	Westmere-EX
  *		sssssssssss
  *
  *			p  = pnode bits
@@ -148,12 +149,25 @@ struct uv_hub_info_s {
 	unsigned char		m_val;
 	unsigned char		n_val;
 	struct uv_scir_s	scir;
+	unsigned char		apic_pnode_shift;
 };
 
 DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define uv_hub_info		(&__get_cpu_var(__uv_hub_info))
 #define uv_cpu_hub_info(cpu)	(&per_cpu(__uv_hub_info, cpu))
 
+union uvh_apicid {
+    unsigned long       v;
+    struct uvh_apicid_s {
+        unsigned long   local_apic_mask  : 24;
+        unsigned long   local_apic_shift :  5;
+        unsigned long   unused1          :  3;
+        unsigned long   pnode_mask       : 24;
+        unsigned long   pnode_shift      :  5;
+        unsigned long   unused2          :  3;
+    } s;
+};
+
 /*
  * Local & Global MMR space macros.
  *	Note: macros are intended to be used ONLY by inline functions
@@ -182,6 +196,7 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 #define UV_GLOBAL_MMR64_PNODE_BITS(p)					\
 	(((unsigned long)(p)) << UV_GLOBAL_MMR64_PNODE_SHIFT)
 
+#define UVH_APICID		0x002D0E00L
 #define UV_APIC_PNODE_SHIFT	6
 
 /* Local Bus from cpu's perspective */
@@ -280,7 +295,7 @@ static inline void *uv_pnode_offset_to_v
  */
 static inline int uv_apicid_to_pnode(int apicid)
 {
-	return (apicid >> UV_APIC_PNODE_SHIFT);
+	return (apicid >> uv_hub_info->apic_pnode_shift);
 }
 
 /*
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
