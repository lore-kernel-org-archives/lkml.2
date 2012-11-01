Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515Ab2KAVCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:02:47 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:47144 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759962Ab2KAVCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:02:45 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFHjS0IEKU=
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH v5] xen PVonHVM: use E820_Reserved area for shared_info
Date: Thu,  1 Nov 2012 22:02:30 +0100
Message-Id: <1351803750-7335-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a respin of 00e37bdb0113a98408de42db85be002f21dbffd3
("xen PVonHVM: move shared_info to MMIO before kexec").

Currently kexec in a PVonHVM guest fails with a triple fault because the
new kernel overwrites the shared info page. The exact failure depends on
the size of the kernel image. This patch moves the pfn from RAM into an
E820 reserved memory area.

The pfn containing the shared_info is located somewhere in RAM. This will
cause trouble if the current kernel is doing a kexec boot into a new
kernel. The new kernel (and its startup code) can not know where the pfn
is, so it can not reserve the page. The hypervisor will continue to update
the pfn, and as a result memory corruption occours in the new kernel.

The toolstack marks the memory area FC000000-FFFFFFFF as reserved in the
E820 map. Within that range newer toolstacks (4.3+) will keep 1MB
starting from FE700000 as reserved for guest use. Older Xen4 toolstacks
will usually not allocate areas up to FE700000, so FE700000 is expected
to work also with older toolstacks.

In Xen3 there is no reserved area at a fixed location. If the guest is
started on such old hosts the shared_info page will be placed in RAM. As
a result kexec can not be used.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
v5:
 reword subject
 handle Xen3, continue to use extend_brk on old hosts
v4:
 rebase to 3.7-rc3
v3:
 make xen_hvm_init_shared_info static
v2:
 add __init to xen_hvm_set_shared_info

 arch/x86/xen/enlighten.c | 75 ++++++++++++++++++++++++++++++++++--------------
 arch/x86/xen/suspend.c   |  2 +-
 arch/x86/xen/xen-ops.h   |  2 +-
 3 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 586d838..a90c3bb 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1495,51 +1495,72 @@ asmlinkage void __init xen_start_kernel(void)
 #endif
 }
 
-void __ref xen_hvm_init_shared_info(void)
+#ifdef CONFIG_XEN_PVHVM
+#define HVM_SHARED_INFO_ADDR 0xFE700000UL
+static struct shared_info *xen_hvm_shared_info;
+static unsigned long xen_hvm_sip_phys;
+static int xen_major, xen_minor;
+
+static void xen_hvm_connect_shared_info(unsigned long pfn)
 {
-	int cpu;
 	struct xen_add_to_physmap xatp;
-	static struct shared_info *shared_info_page = 0;
 
-	if (!shared_info_page)
-		shared_info_page = (struct shared_info *)
-			extend_brk(PAGE_SIZE, PAGE_SIZE);
 	xatp.domid = DOMID_SELF;
 	xatp.idx = 0;
 	xatp.space = XENMAPSPACE_shared_info;
-	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
+	xatp.gpfn = pfn;
 	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
 		BUG();
 
-	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
+}
+static void __init xen_hvm_set_shared_info(struct shared_info *sip)
+{
+	int cpu;
+
+	HYPERVISOR_shared_info = sip;
 
 	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
 	 * page, we use it in the event channel upcall and in some pvclock
 	 * related functions. We don't need the vcpu_info placement
 	 * optimizations because we don't use any pv_mmu or pv_irq op on
-	 * HVM.
-	 * When xen_hvm_init_shared_info is run at boot time only vcpu 0 is
-	 * online but xen_hvm_init_shared_info is run at resume time too and
-	 * in that case multiple vcpus might be online. */
-	for_each_online_cpu(cpu) {
+	 * HVM. */
+	for_each_online_cpu(cpu)
 		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
+}
+
+/* Reconnect the shared_info pfn to a (new) mfn */
+void xen_hvm_resume_shared_info(void)
+{
+	xen_hvm_connect_shared_info(xen_hvm_sip_phys >> PAGE_SHIFT);
+}
+
+/* Xen tools prior to Xen 4 do not provide a E820_Reserved area for guest usage.
+ * On these old tools the shared info page will be placed in E820_Ram.
+ * Xen 4 provides a E820_Reserved area at 0xFC000000, and this code expects
+ * that nothing is mapped up to HVM_SHARED_INFO_ADDR.
+ * Xen 4.3+ provides an explicit 1MB area at HVM_SHARED_INFO_ADDR which is used
+ * here for the shared info page. */
+static void __init xen_hvm_init_shared_info(void)
+{
+	if (xen_major < 4) {
+		xen_hvm_shared_info = extend_brk(PAGE_SIZE, PAGE_SIZE);
+		xen_hvm_sip_phys = __pa(xen_hvm_shared_info);
+	} else {
+		xen_hvm_sip_phys = HVM_SHARED_INFO_ADDR;
+		set_fixmap(FIX_PARAVIRT_BOOTMAP, xen_hvm_sip_phys);
+		xen_hvm_shared_info =
+		(struct shared_info *)fix_to_virt(FIX_PARAVIRT_BOOTMAP);
 	}
+	xen_hvm_connect_shared_info(xen_hvm_sip_phys >> PAGE_SHIFT);
+	xen_hvm_set_shared_info(xen_hvm_shared_info);
 }
 
-#ifdef CONFIG_XEN_PVHVM
 static void __init init_hvm_pv_info(void)
 {
-	int major, minor;
 	uint32_t eax, ebx, ecx, edx, pages, msr, base;
 	u64 pfn;
 
 	base = xen_cpuid_base();
-	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
-
-	major = eax >> 16;
-	minor = eax & 0xffff;
-	printk(KERN_INFO "Xen version %d.%d.\n", major, minor);
-
 	cpuid(base + 2, &pages, &msr, &ecx, &edx);
 
 	pfn = __pa(hypercall_page);
@@ -1590,12 +1611,22 @@ static void __init xen_hvm_guest_init(void)
 
 static bool __init xen_hvm_platform(void)
 {
+	uint32_t eax, ebx, ecx, edx, base;
+
 	if (xen_pv_domain())
 		return false;
 
-	if (!xen_cpuid_base())
+	base = xen_cpuid_base();
+	if (!base)
 		return false;
 
+	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
+
+	xen_major = eax >> 16;
+	xen_minor = eax & 0xffff;
+
+	printk(KERN_INFO "Xen version %d.%d.\n", xen_major, xen_minor);
+
 	return true;
 }
 
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 45329c8..ae8a00c 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -30,7 +30,7 @@ void xen_arch_hvm_post_suspend(int suspend_cancelled)
 {
 #ifdef CONFIG_XEN_PVHVM
 	int cpu;
-	xen_hvm_init_shared_info();
+	xen_hvm_resume_shared_info();
 	xen_callback_vector();
 	xen_unplug_emulated_devices();
 	if (xen_feature(XENFEAT_hvm_safe_pvclock)) {
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index a95b417..d2e73d1 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -40,7 +40,7 @@ void xen_enable_syscall(void);
 void xen_vcpu_restore(void);
 
 void xen_callback_vector(void);
-void xen_hvm_init_shared_info(void);
+void xen_hvm_resume_shared_info(void);
 void xen_unplug_emulated_devices(void);
 
 void __init xen_build_dynamic_phys_to_machine(void);
-- 
1.8.0

