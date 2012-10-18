Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab2JRAca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 20:32:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31035 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2JRAc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 20:32:29 -0400
Date: Wed, 17 Oct 2012 17:32:23 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH V3 4/6]: PVH:bootup and setup related changes.
Message-ID: <20121017173223.7ea1901d@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PVH: bootup and setup related changes. enlighten.c: for PVH we can trap cpuid via vmexit, so don't need to use emulated prefix call. Check for vector callback early on, as it is a required feature. PVH runs at default kernel iopl. setup.c: in xen_add_extra_mem() we can skip updating p2m as it's managed by xen. PVH maps the entire IO space, but only RAM pages need to be repopulated. Finally, pure PV settings are moved to a separate function that is only called for pure pv, ie, pv with pvmmu.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
---
 arch/x86/xen/enlighten.c |   77 ++++++++++++++++++++++++++++++++++-----------
 arch/x86/xen/setup.c     |   64 +++++++++++++++++++++++++++++++-------
 2 files changed, 110 insertions(+), 31 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2d932c3..18f5514 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -44,6 +44,7 @@
 #include <xen/hvm.h>
 #include <xen/hvc-console.h>
 #include <xen/acpi.h>
+#include <xen/features.h>
 
 #include <asm/paravirt.h>
 #include <asm/apic.h>
@@ -106,6 +107,9 @@ RESERVE_BRK(shared_info_page_brk, PAGE_SIZE);
 __read_mostly int xen_have_vector_callback;
 EXPORT_SYMBOL_GPL(xen_have_vector_callback);
 
+#define xen_pvh_domain() (xen_pv_domain() && \
+			  xen_feature(XENFEAT_auto_translated_physmap) && \
+			  xen_have_vector_callback)
 /*
  * Point at some empty memory to start with. We map the real shared_info
  * page as soon as fixmap is up and running.
@@ -218,8 +222,9 @@ static void __init xen_banner(void)
 	struct xen_extraversion extra;
 	HYPERVISOR_xen_version(XENVER_extraversion, &extra);
 
-	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
-	       pv_info.name);
+	pr_info("Booting paravirtualized kernel %son %s\n",
+		xen_feature(XENFEAT_auto_translated_physmap) ?
+			"with PVH extensions " : "", pv_info.name);
 	printk(KERN_INFO "Xen version: %d.%d%s%s\n",
 	       version >> 16, version & 0xffff, extra.extraversion,
 	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
@@ -272,12 +277,15 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 		break;
 	}
 
-	asm(XEN_EMULATE_PREFIX "cpuid"
-		: "=a" (*ax),
-		  "=b" (*bx),
-		  "=c" (*cx),
-		  "=d" (*dx)
-		: "0" (*ax), "2" (*cx));
+	if (xen_pvh_domain())
+		native_cpuid(ax, bx, cx, dx);
+	else
+		asm(XEN_EMULATE_PREFIX "cpuid"
+			: "=a" (*ax),
+			"=b" (*bx),
+			"=c" (*cx),
+			"=d" (*dx)
+			: "0" (*ax), "2" (*cx));
 
 	*bx &= maskebx;
 	*cx &= maskecx;
@@ -1045,6 +1053,10 @@ void xen_setup_shared_info(void)
 		HYPERVISOR_shared_info =
 			(struct shared_info *)__va(xen_start_info->shared_info);
 
+	/* PVH TBD/FIXME: vcpu info placement in phase 2 */
+	if (xen_pvh_domain())
+		return;
+
 #ifndef CONFIG_SMP
 	/* In UP this is as good a place as any to set up shared info */
 	xen_setup_vcpu_info_placement();
@@ -1275,6 +1287,11 @@ static const struct machine_ops xen_machine_ops __initconst = {
  */
 static void __init xen_setup_stackprotector(void)
 {
+	/* PVH TBD/FIXME: investigate setup_stack_canary_segment */
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		switch_to_new_gdt(0);
+		return;
+	}
 	pv_cpu_ops.write_gdt_entry = xen_write_gdt_entry_boot;
 	pv_cpu_ops.load_gdt = xen_load_gdt_boot;
 
@@ -1285,6 +1302,19 @@ static void __init xen_setup_stackprotector(void)
 	pv_cpu_ops.load_gdt = xen_load_gdt;
 }
 
+static void __init xen_pvh_early_guest_init(void)
+{
+	if (xen_feature(XENFEAT_hvm_callback_vector))
+		xen_have_vector_callback = 1;
+
+#ifdef CONFIG_X86_32
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		xen_raw_printk("ERROR: 32bit PVH guests are not supported\n");
+		BUG();
+	}
+#endif
+}
+
 /* First C function to be called on Xen boot */
 asmlinkage void __init xen_start_kernel(void)
 {
@@ -1296,13 +1326,18 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_domain_type = XEN_PV_DOMAIN;
 
+	xen_setup_features();
+	xen_pvh_early_guest_init();
 	xen_setup_machphys_mapping();
 
 	/* Install Xen paravirt ops */
 	pv_info = xen_info;
 	pv_init_ops = xen_init_ops;
-	pv_cpu_ops = xen_cpu_ops;
 	pv_apic_ops = xen_apic_ops;
+	if (xen_pvh_domain())
+		pv_cpu_ops.cpuid = xen_cpuid;
+	else
+		pv_cpu_ops = xen_cpu_ops;
 
 	x86_init.resources.memory_setup = xen_memory_setup;
 	x86_init.oem.arch_setup = xen_arch_setup;
@@ -1334,8 +1369,6 @@ asmlinkage void __init xen_start_kernel(void)
 	/* Work out if we support NX */
 	x86_configure_nx();
 
-	xen_setup_features();
-
 	/* Get mfn list */
 	if (!xen_feature(XENFEAT_auto_translated_physmap))
 		xen_build_dynamic_phys_to_machine();
@@ -1406,14 +1439,18 @@ asmlinkage void __init xen_start_kernel(void)
 	/* set the limit of our address space */
 	xen_reserve_top();
 
-	/* We used to do this in xen_arch_setup, but that is too late on AMD
-	 * were early_cpu_init (run before ->arch_setup()) calls early_amd_init
-	 * which pokes 0xcf8 port.
-	 */
-	set_iopl.iopl = 1;
-	rc = HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
-	if (rc != 0)
-		xen_raw_printk("physdev_op failed %d\n", rc);
+	/* PVH: runs at default kernel iopl of 0 */
+	if (!xen_pvh_domain()) {
+		/*
+		 * We used to do this in xen_arch_setup, but that is too late
+		 * on AMD were early_cpu_init (run before ->arch_setup()) calls
+		 * early_amd_init which pokes 0xcf8 port.
+		 */
+		set_iopl.iopl = 1;
+		rc = HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
+		if (rc != 0)
+			xen_raw_printk("physdev_op failed %d\n", rc);
+	}
 
 #ifdef CONFIG_X86_32
 	/* set up basic CPUID stuff */
@@ -1480,6 +1517,8 @@ asmlinkage void __init xen_start_kernel(void)
 #endif
 }
 
+/* Use a pfn in RAM, may move to MMIO before kexec.
+ * This function also called for PVH dom0 */
 void __ref xen_hvm_init_shared_info(void)
 {
 	int cpu;
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 8971a26..8cce47b 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -27,6 +27,7 @@
 #include <xen/interface/memory.h>
 #include <xen/interface/physdev.h>
 #include <xen/features.h>
+#include "mmu.h"
 #include "xen-ops.h"
 #include "vdso.h"
 
@@ -78,6 +79,9 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
 
 	memblock_reserve(start, size);
 
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
 	xen_max_p2m_pfn = PFN_DOWN(start + size);
 	for (pfn = PFN_DOWN(start); pfn < xen_max_p2m_pfn; pfn++) {
 		unsigned long mfn = pfn_to_mfn(pfn);
@@ -100,6 +104,7 @@ static unsigned long __init xen_do_chunk(unsigned long start,
 		.domid        = DOMID_SELF
 	};
 	unsigned long len = 0;
+	int xlated_phys = xen_feature(XENFEAT_auto_translated_physmap);
 	unsigned long pfn;
 	int ret;
 
@@ -113,7 +118,7 @@ static unsigned long __init xen_do_chunk(unsigned long start,
 				continue;
 			frame = mfn;
 		} else {
-			if (mfn != INVALID_P2M_ENTRY)
+			if (!xlated_phys && mfn != INVALID_P2M_ENTRY)
 				continue;
 			frame = pfn;
 		}
@@ -230,6 +235,27 @@ static void __init xen_set_identity_and_release_chunk(
 	*identity += set_phys_range_identity(start_pfn, end_pfn);
 }
 
+/* For PVH, the pfns [0..MAX] are mapped to mfn's in the EPT/NPT. The mfns
+ * are released as part of this 1:1 mapping hypercall back to the dom heap.
+ * Also, we map the entire IO space, ie, beyond max_pfn_mapped.
+ */
+static void __init xen_pvh_identity_map_chunk(unsigned long start_pfn,
+		unsigned long end_pfn, unsigned long *released,
+		unsigned long *identity, unsigned long max_pfn)
+{
+	unsigned long pfn;
+	int numpfns = 1, add_mapping = 1;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn++)
+		xen_set_clr_mmio_pvh_pte(pfn, pfn, numpfns, add_mapping);
+
+	if (start_pfn <= max_pfn) {
+		unsigned long end = min(max_pfn_mapped, end_pfn);
+		*released += end - start_pfn;
+	}
+	*identity += end_pfn - start_pfn;
+}
+
 static unsigned long __init xen_set_identity_and_release(
 	const struct e820entry *list, size_t map_size, unsigned long nr_pages)
 {
@@ -238,6 +264,7 @@ static unsigned long __init xen_set_identity_and_release(
 	unsigned long identity = 0;
 	const struct e820entry *entry;
 	int i;
+	int xlated_phys = xen_feature(XENFEAT_auto_translated_physmap);
 
 	/*
 	 * Combine non-RAM regions and gaps until a RAM region (or the
@@ -259,11 +286,17 @@ static unsigned long __init xen_set_identity_and_release(
 			if (entry->type == E820_RAM)
 				end_pfn = PFN_UP(entry->addr);
 
-			if (start_pfn < end_pfn)
-				xen_set_identity_and_release_chunk(
-					start_pfn, end_pfn, nr_pages,
-					&released, &identity);
-
+			if (start_pfn < end_pfn) {
+				if (xlated_phys) {
+					xen_pvh_identity_map_chunk(start_pfn,
+						end_pfn, &released, &identity,
+						nr_pages);
+				} else {
+					xen_set_identity_and_release_chunk(
+						start_pfn, end_pfn, nr_pages,
+						&released, &identity);
+				}
+			}
 			start = end;
 		}
 	}
@@ -526,16 +559,14 @@ void __cpuinit xen_enable_syscall(void)
 #endif /* CONFIG_X86_64 */
 }
 
-void __init xen_arch_setup(void)
+/* Non auto translated PV domain, ie, it's not PVH. */
+static __init void xen_pvmmu_arch_setup(void)
 {
-	xen_panic_handler_init();
-
 	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_4gb_segments);
 	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_writable_pagetables);
 
-	if (!xen_feature(XENFEAT_auto_translated_physmap))
-		HYPERVISOR_vm_assist(VMASST_CMD_enable,
-				     VMASST_TYPE_pae_extended_cr3);
+	HYPERVISOR_vm_assist(VMASST_CMD_enable,
+			     VMASST_TYPE_pae_extended_cr3);
 
 	if (register_callback(CALLBACKTYPE_event, xen_hypervisor_callback) ||
 	    register_callback(CALLBACKTYPE_failsafe, xen_failsafe_callback))
@@ -543,6 +574,15 @@ void __init xen_arch_setup(void)
 
 	xen_enable_sysenter();
 	xen_enable_syscall();
+}
+
+/* This function not called for HVM domain */
+void __init xen_arch_setup(void)
+{
+	xen_panic_handler_init();
+
+	if (!xen_feature(XENFEAT_auto_translated_physmap))
+		xen_pvmmu_arch_setup();
 
 #ifdef CONFIG_ACPI
 	if (!(xen_start_info->flags & SIF_INITDOMAIN)) {
-- 
1.7.2.3

