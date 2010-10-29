Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab0J2QF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:05:56 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:64121 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683Ab0J2QFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:05:54 -0400
X-IronPort-AV: E=Sophos;i="4.58,260,1286150400"; 
   d="scan'208";a="2595778"
Date: Fri, 29 Oct 2010 17:04:53 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: linux-kernel@vger.kernel.org
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: [PATCH] xen: implement XENMEM_machphys_mapping
Message-ID: <alpine.DEB.2.00.1010291701140.1407@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ian Campbell <ian.campbell@citrix.com>

This hypercall allows Xen to specify a non-default location for the
machine to physical mapping. This capability is used when running a 32
bit domain 0 on a 64 bit hypervisor to shrink the hypervisor hole to
exactly the size required.

[ Impact: add Xen hypercall definitions ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/include/asm/xen/interface.h    |    6 +++---
 arch/x86/include/asm/xen/interface_32.h |    5 +++++
 arch/x86/include/asm/xen/interface_64.h |   13 +------------
 arch/x86/include/asm/xen/page.h         |    7 ++++---
 arch/x86/xen/enlighten.c                |    7 +++++++
 arch/x86/xen/mmu.c                      |   14 ++++++++++++++
 include/xen/interface/memory.h          |   13 +++++++++++++
 7 files changed, 47 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index e8506c1..1c10c88 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -61,9 +61,9 @@ DEFINE_GUEST_HANDLE(void);
 #define HYPERVISOR_VIRT_START mk_unsigned_long(__HYPERVISOR_VIRT_START)
 #endif
 
-#ifndef machine_to_phys_mapping
-#define machine_to_phys_mapping ((unsigned long *)HYPERVISOR_VIRT_START)
-#endif
+#define MACH2PHYS_VIRT_START  mk_unsigned_long(__MACH2PHYS_VIRT_START)
+#define MACH2PHYS_VIRT_END    mk_unsigned_long(__MACH2PHYS_VIRT_END)
+#define MACH2PHYS_NR_ENTRIES  ((MACH2PHYS_VIRT_END-MACH2PHYS_VIRT_START)>>__MACH2PHYS_SHIFT)
 
 /* Maximum number of virtual CPUs in multi-processor guests. */
 #define MAX_VIRT_CPUS 32
diff --git a/arch/x86/include/asm/xen/interface_32.h b/arch/x86/include/asm/xen/interface_32.h
index 42a7e00..8413688 100644
--- a/arch/x86/include/asm/xen/interface_32.h
+++ b/arch/x86/include/asm/xen/interface_32.h
@@ -32,6 +32,11 @@
 /* And the trap vector is... */
 #define TRAP_INSTR "int $0x82"
 
+#define __MACH2PHYS_VIRT_START 0xF5800000
+#define __MACH2PHYS_VIRT_END   0xF6800000
+
+#define __MACH2PHYS_SHIFT      2
+
 /*
  * Virtual addresses beyond this are not modifiable by guest OSes. The
  * machine->physical mapping table starts at this address, read-only.
diff --git a/arch/x86/include/asm/xen/interface_64.h b/arch/x86/include/asm/xen/interface_64.h
index 100d266..839a481 100644
--- a/arch/x86/include/asm/xen/interface_64.h
+++ b/arch/x86/include/asm/xen/interface_64.h
@@ -39,18 +39,7 @@
 #define __HYPERVISOR_VIRT_END   0xFFFF880000000000
 #define __MACH2PHYS_VIRT_START  0xFFFF800000000000
 #define __MACH2PHYS_VIRT_END    0xFFFF804000000000
-
-#ifndef HYPERVISOR_VIRT_START
-#define HYPERVISOR_VIRT_START mk_unsigned_long(__HYPERVISOR_VIRT_START)
-#define HYPERVISOR_VIRT_END   mk_unsigned_long(__HYPERVISOR_VIRT_END)
-#endif
-
-#define MACH2PHYS_VIRT_START  mk_unsigned_long(__MACH2PHYS_VIRT_START)
-#define MACH2PHYS_VIRT_END    mk_unsigned_long(__MACH2PHYS_VIRT_END)
-#define MACH2PHYS_NR_ENTRIES  ((MACH2PHYS_VIRT_END-MACH2PHYS_VIRT_START)>>3)
-#ifndef machine_to_phys_mapping
-#define machine_to_phys_mapping ((unsigned long *)HYPERVISOR_VIRT_START)
-#endif
+#define __MACH2PHYS_SHIFT       3
 
 /*
  * int HYPERVISOR_set_segment_base(unsigned int which, unsigned long base)
diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index bf5f7d3..d5fb2e8 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/pfn.h>
+#include <linux/mm.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -35,6 +36,8 @@ typedef struct xpaddr {
 #define MAX_DOMAIN_PAGES						\
     ((unsigned long)((u64)CONFIG_XEN_MAX_DOMAIN_MEMORY * 1024 * 1024 * 1024 / PAGE_SIZE))
 
+extern unsigned long *machine_to_phys_mapping;
+extern unsigned int   machine_to_phys_order;
 
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern void set_phys_to_machine(unsigned long pfn, unsigned long mfn);
@@ -62,10 +65,8 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return mfn;
 
-#if 0
 	if (unlikely((mfn >> machine_to_phys_order) != 0))
-		return max_mapnr;
-#endif
+		return ~0;
 
 	pfn = 0;
 	/*
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index d48a32b..7f0416d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -75,6 +75,11 @@ DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 enum xen_domain_type xen_domain_type = XEN_NATIVE;
 EXPORT_SYMBOL_GPL(xen_domain_type);
 
+unsigned long *machine_to_phys_mapping = (void *)MACH2PHYS_VIRT_START;
+EXPORT_SYMBOL(machine_to_phys_mapping);
+unsigned int   machine_to_phys_order;
+EXPORT_SYMBOL(machine_to_phys_order);
+
 struct start_info *xen_start_info;
 EXPORT_SYMBOL_GPL(xen_start_info);
 
@@ -1100,6 +1105,8 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_domain_type = XEN_PV_DOMAIN;
 
+	xen_setup_machphys_mapping();
+
 	/* Install Xen paravirt ops */
 	pv_info = xen_info;
 	pv_init_ops = xen_init_ops;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index eed9c7c..b318347 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1738,6 +1738,20 @@ static __init void xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 	set_page_prot(pmd, PAGE_KERNEL_RO);
 }
 
+void __init xen_setup_machphys_mapping(void)
+{
+	struct xen_machphys_mapping mapping;
+	unsigned long machine_to_phys_nr_ents;
+
+	if (HYPERVISOR_memory_op(XENMEM_machphys_mapping, &mapping) == 0) {
+		machine_to_phys_mapping = (unsigned long *)mapping.v_start;
+		machine_to_phys_nr_ents = mapping.max_mfn + 1;
+	} else {
+		machine_to_phys_nr_ents = MACH2PHYS_NR_ENTRIES;
+	}
+	machine_to_phys_order = fls(machine_to_phys_nr_ents - 1);
+}
+
 #ifdef CONFIG_X86_64
 static void convert_pfn_mfn(void *v)
 {
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index d3938d3..134d33d 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -141,6 +141,19 @@ struct xen_machphys_mfn_list {
 DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mfn_list);
 
 /*
+ * Returns the location in virtual address space of the machine_to_phys
+ * mapping table. Architectures which do not have a m2p table, or which do not
+ * map it by default into guest address space, do not implement this command.
+ * arg == addr of xen_machphys_mapping_t.
+ */
+#define XENMEM_machphys_mapping     12
+struct xen_machphys_mapping {
+    unsigned long v_start, v_end; /* Start and end virtual addresses.   */
+    unsigned long max_mfn;        /* Maximum MFN that can be looked up. */
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mapping_t);
+
+/*
  * Sets the GPFN at which a particular page appears in the specified guest's
  * pseudophysical address space.
  * arg == addr of xen_add_to_physmap_t.
-- 
1.5.6.5

