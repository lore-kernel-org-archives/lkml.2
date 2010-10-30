Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201Ab0J3Bda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 21:33:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52937 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab0J3Bd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 21:33:27 -0400
Date: Fri, 29 Oct 2010 18:32:41 -0700
Message-Id: <201010300132.o9U1WfgY020703@voreg.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Additional x86 UV support for 2.6.37
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 44234d0c465d996145e9c821fa28a981f2e8309d:

  Merge branch 'for-2637/i2c-all' of git://git.fluff.org/bjdooks/linux (2010-10-29 16:15:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-uv-for-linus

Russ Anderson (2):
      x86, uv: Enable Westmere support on SGI UV
      x86, uv: More Westmere support on SGI UV

 arch/x86/include/asm/uv/uv_hub.h   |   21 ++++++++++++++++++---
 arch/x86/kernel/apic/x2apic_uv_x.c |   24 ++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index bf6b88e..e969f69 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
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
@@ -182,6 +196,7 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define UV_GLOBAL_MMR64_PNODE_BITS(p)					\
 	(((unsigned long)(p)) << UV_GLOBAL_MMR64_PNODE_SHIFT)
 
+#define UVH_APICID		0x002D0E00L
 #define UV_APIC_PNODE_SHIFT	6
 
 /* Local Bus from cpu's perspective */
@@ -280,7 +295,7 @@ static inline void *uv_pnode_offset_to_vaddr(int pnode, unsigned long offset)
  */
 static inline int uv_apicid_to_pnode(int apicid)
 {
-	return (apicid >> UV_APIC_PNODE_SHIFT);
+	return (apicid >> uv_hub_info->apic_pnode_shift);
 }
 
 /*
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index f744f54..ed4118d 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
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
@@ -70,12 +71,27 @@ static int early_get_nodeid(void)
 	return node_id.s.node_id;
 }
 
+static void __init early_get_apic_pnode_shift(void)
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
+}
+
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	int nodeid;
 
 	if (!strcmp(oem_id, "SGI")) {
 		nodeid = early_get_nodeid();
+		early_get_apic_pnode_shift();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
 		x86_platform.nmi_init = uv_nmi_init;
 		if (!strcmp(oem_table_id, "UVL"))
@@ -84,7 +100,7 @@ static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
 			__get_cpu_var(x2apic_extra_bits) =
-				nodeid << (UV_APIC_PNODE_SHIFT - 1);
+				nodeid << (uvh_apicid.s.pnode_shift - 1);
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			return 1;
 		}
@@ -716,6 +732,10 @@ void __init uv_system_init(void)
 		int apicid = per_cpu(x86_cpu_to_apicid, cpu);
 
 		nid = cpu_to_node(cpu);
+		/*
+		 * apic_pnode_shift must be set before calling uv_apicid_to_pnode();
+		 */
+		uv_cpu_hub_info(cpu)->apic_pnode_shift = uvh_apicid.s.pnode_shift;
 		pnode = uv_apicid_to_pnode(apicid);
 		blade = boot_pnode_to_blade(pnode);
 		lcpu = uv_blade_info[blade].nr_possible_cpus;
