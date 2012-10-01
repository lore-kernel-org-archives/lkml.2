Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab2JATS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:18:29 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:61958 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2JATS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:18:28 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGiy0IFwQ=
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] xen pv-on-hvm: add pfn_is_ram helper for kdump
Date: Mon,  1 Oct 2012 21:18:01 +0200
Message-Id: <1349119081-9081-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register pfn_is_ram helper speed up reading /proc/vmcore in the kdump
kernel. See commit message of 997c136f518c ("fs/proc/vmcore.c: add hook
to read_from_oldmem() to check for non-ram pages") for details.

It makes use of a new hvmop HVMOP_get_mem_type which was introduced in
xen 4.2 (23298:26413986e6e0) and backported to 4.1.1.

The new function is currently only enabled for reading /proc/vmcore.
Later it will be used also for the kexec kernel. Since that requires
more changes in the generic kernel make it static for the time being.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
v2:
 - remove typedefs

 arch/x86/xen/mmu.c                 | 41 ++++++++++++++++++++++++++++++++++++++
 include/xen/interface/hvm/hvm_op.h | 19 ++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5141d80..973962a 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -47,6 +47,7 @@
 #include <linux/gfp.h>
 #include <linux/memblock.h>
 #include <linux/seq_file.h>
+#include <linux/crash_dump.h>
 
 #include <trace/events/xen.h>
 
@@ -2272,6 +2273,43 @@ void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order)
 EXPORT_SYMBOL_GPL(xen_destroy_contiguous_region);
 
 #ifdef CONFIG_XEN_PVHVM
+#ifdef CONFIG_PROC_VMCORE
+/*
+ * This function is used in two contexts:
+ * - the kdump kernel has to check whether a pfn of the crashed kernel
+ *   was a ballooned page. vmcore is using this function to decide
+ *   whether to access a pfn of the crashed kernel.
+ * - the kexec kernel has to check whether a pfn was ballooned by the
+ *   previous kernel. If the pfn is ballooned, handle it properly.
+ * Returns 0 if the pfn is not backed by a RAM page, the caller may
+ * handle the pfn special in this case.
+ */
+static int xen_oldmem_pfn_is_ram(unsigned long pfn)
+{
+	struct xen_hvm_get_mem_type a = {
+		.domid = DOMID_SELF,
+		.pfn = pfn,
+	};
+	int ram;
+
+	if (HYPERVISOR_hvm_op(HVMOP_get_mem_type, &a))
+		return -ENXIO;
+
+	switch (a.mem_type) {
+		case HVMMEM_mmio_dm:
+			ram = 0;
+			break;
+		case HVMMEM_ram_rw:
+		case HVMMEM_ram_ro:
+		default:
+			ram = 1;
+			break;
+	}
+
+	return ram;
+}
+#endif
+
 static void xen_hvm_exit_mmap(struct mm_struct *mm)
 {
 	struct xen_hvm_pagetable_dying a;
@@ -2302,6 +2340,9 @@ void __init xen_hvm_init_mmu_ops(void)
 {
 	if (is_pagetable_dying_supported())
 		pv_mmu_ops.exit_mmap = xen_hvm_exit_mmap;
+#ifdef CONFIG_PROC_VMCORE
+	register_oldmem_pfn_is_ram(&xen_oldmem_pfn_is_ram);
+#endif
 }
 #endif
 
diff --git a/include/xen/interface/hvm/hvm_op.h b/include/xen/interface/hvm/hvm_op.h
index a4827f4..956a046 100644
--- a/include/xen/interface/hvm/hvm_op.h
+++ b/include/xen/interface/hvm/hvm_op.h
@@ -43,4 +43,23 @@ struct xen_hvm_pagetable_dying {
 typedef struct xen_hvm_pagetable_dying xen_hvm_pagetable_dying_t;
 DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_pagetable_dying_t);
  
+enum hvmmem_type_t {
+    HVMMEM_ram_rw,             /* Normal read/write guest RAM */
+    HVMMEM_ram_ro,             /* Read-only; writes are discarded */
+    HVMMEM_mmio_dm,            /* Reads and write go to the device model */
+};
+
+#define HVMOP_get_mem_type    15
+/* Return hvmmem_type_t for the specified pfn. */
+struct xen_hvm_get_mem_type {
+    /* Domain to be queried. */
+    domid_t domid;
+    /* OUT variable. */
+    uint16_t mem_type;
+    uint16_t pad[2]; /* align next field on 8-byte boundary */
+    /* IN variable. */
+    uint64_t pfn;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_get_mem_type);
+
 #endif /* __XEN_PUBLIC_HVM_HVM_OP_H__ */
-- 
1.7.12

