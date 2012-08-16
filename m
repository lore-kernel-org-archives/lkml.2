Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab2HPQBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:01:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27101 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab2HPQAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:00:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] Revert "xen PVonHVM: move shared_info to MMIO before kexec"
Date: Thu, 16 Aug 2012 11:50:14 -0400
Message-Id: <1345132214-15298-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345132214-15298-1-git-send-email-konrad.wilk@oracle.com>
References: <1345132214-15298-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 00e37bdb0113a98408de42db85be002f21dbffd3.

During shutdown of PVHVM guests with more than 2VCPUs on certain
machines we can hit the race where the replaced shared_info is not
replaced fast enough and the PV time clock retries reading the same
area over and over without any success and is stuck in an
infinite loop.

Acked-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c   |  118 ++++---------------------------------------
 arch/x86/xen/suspend.c     |    2 +-
 arch/x86/xen/xen-ops.h     |    2 +-
 drivers/xen/platform-pci.c |   15 ------
 include/xen/events.h       |    2 -
 5 files changed, 13 insertions(+), 126 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a6f8acb..f1814fc 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -31,7 +31,6 @@
 #include <linux/pci.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
-#include <linux/syscore_ops.h>
 
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
@@ -1472,130 +1471,38 @@ asmlinkage void __init xen_start_kernel(void)
 #endif
 }
 
-#ifdef CONFIG_XEN_PVHVM
-/*
- * The pfn containing the shared_info is located somewhere in RAM. This
- * will cause trouble if the current kernel is doing a kexec boot into a
- * new kernel. The new kernel (and its startup code) can not know where
- * the pfn is, so it can not reserve the page. The hypervisor will
- * continue to update the pfn, and as a result memory corruption occours
- * in the new kernel.
- *
- * One way to work around this issue is to allocate a page in the
- * xen-platform pci device's BAR memory range. But pci init is done very
- * late and the shared_info page is already in use very early to read
- * the pvclock. So moving the pfn from RAM to MMIO is racy because some
- * code paths on other vcpus could access the pfn during the small
- * window when the old pfn is moved to the new pfn. There is even a
- * small window were the old pfn is not backed by a mfn, and during that
- * time all reads return -1.
- *
- * Because it is not known upfront where the MMIO region is located it
- * can not be used right from the start in xen_hvm_init_shared_info.
- *
- * To minimise trouble the move of the pfn is done shortly before kexec.
- * This does not eliminate the race because all vcpus are still online
- * when the syscore_ops will be called. But hopefully there is no work
- * pending at this point in time. Also the syscore_op is run last which
- * reduces the risk further.
- */
-
-static struct shared_info *xen_hvm_shared_info;
-
-static void xen_hvm_connect_shared_info(unsigned long pfn)
+void __ref xen_hvm_init_shared_info(void)
 {
+	int cpu;
 	struct xen_add_to_physmap xatp;
+	static struct shared_info *shared_info_page = 0;
 
+	if (!shared_info_page)
+		shared_info_page = (struct shared_info *)
+			extend_brk(PAGE_SIZE, PAGE_SIZE);
 	xatp.domid = DOMID_SELF;
 	xatp.idx = 0;
 	xatp.space = XENMAPSPACE_shared_info;
-	xatp.gpfn = pfn;
+	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
 	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
 		BUG();
 
-}
-static void xen_hvm_set_shared_info(struct shared_info *sip)
-{
-	int cpu;
-
-	HYPERVISOR_shared_info = sip;
+	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
 
 	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
 	 * page, we use it in the event channel upcall and in some pvclock
 	 * related functions. We don't need the vcpu_info placement
 	 * optimizations because we don't use any pv_mmu or pv_irq op on
 	 * HVM.
-	 * When xen_hvm_set_shared_info is run at boot time only vcpu 0 is
-	 * online but xen_hvm_set_shared_info is run at resume time too and
+	 * When xen_hvm_init_shared_info is run at boot time only vcpu 0 is
+	 * online but xen_hvm_init_shared_info is run at resume time too and
 	 * in that case multiple vcpus might be online. */
 	for_each_online_cpu(cpu) {
 		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 	}
 }
 
-/* Reconnect the shared_info pfn to a mfn */
-void xen_hvm_resume_shared_info(void)
-{
-	xen_hvm_connect_shared_info(__pa(xen_hvm_shared_info) >> PAGE_SHIFT);
-}
-
-#ifdef CONFIG_KEXEC
-static struct shared_info *xen_hvm_shared_info_kexec;
-static unsigned long xen_hvm_shared_info_pfn_kexec;
-
-/* Remember a pfn in MMIO space for kexec reboot */
-void __devinit xen_hvm_prepare_kexec(struct shared_info *sip, unsigned long pfn)
-{
-	xen_hvm_shared_info_kexec = sip;
-	xen_hvm_shared_info_pfn_kexec = pfn;
-}
-
-static void xen_hvm_syscore_shutdown(void)
-{
-	struct xen_memory_reservation reservation = {
-		.domid = DOMID_SELF,
-		.nr_extents = 1,
-	};
-	unsigned long prev_pfn;
-	int rc;
-
-	if (!xen_hvm_shared_info_kexec)
-		return;
-
-	prev_pfn = __pa(xen_hvm_shared_info) >> PAGE_SHIFT;
-	set_xen_guest_handle(reservation.extent_start, &prev_pfn);
-
-	/* Move pfn to MMIO, disconnects previous pfn from mfn */
-	xen_hvm_connect_shared_info(xen_hvm_shared_info_pfn_kexec);
-
-	/* Update pointers, following hypercall is also a memory barrier */
-	xen_hvm_set_shared_info(xen_hvm_shared_info_kexec);
-
-	/* Allocate new mfn for previous pfn */
-	do {
-		rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
-		if (rc == 0)
-			msleep(123);
-	} while (rc == 0);
-
-	/* Make sure the previous pfn is really connected to a (new) mfn */
-	BUG_ON(rc != 1);
-}
-
-static struct syscore_ops xen_hvm_syscore_ops = {
-	.shutdown = xen_hvm_syscore_shutdown,
-};
-#endif
-
-/* Use a pfn in RAM, may move to MMIO before kexec. */
-static void __init xen_hvm_init_shared_info(void)
-{
-	/* Remember pointer for resume */
-	xen_hvm_shared_info = extend_brk(PAGE_SIZE, PAGE_SIZE);
-	xen_hvm_connect_shared_info(__pa(xen_hvm_shared_info) >> PAGE_SHIFT);
-	xen_hvm_set_shared_info(xen_hvm_shared_info);
-}
-
+#ifdef CONFIG_XEN_PVHVM
 static void __init init_hvm_pv_info(void)
 {
 	int major, minor;
@@ -1646,9 +1553,6 @@ static void __init xen_hvm_guest_init(void)
 	init_hvm_pv_info();
 
 	xen_hvm_init_shared_info();
-#ifdef CONFIG_KEXEC
-	register_syscore_ops(&xen_hvm_syscore_ops);
-#endif
 
 	if (xen_feature(XENFEAT_hvm_callback_vector))
 		xen_have_vector_callback = 1;
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index ae8a00c..45329c8 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -30,7 +30,7 @@ void xen_arch_hvm_post_suspend(int suspend_cancelled)
 {
 #ifdef CONFIG_XEN_PVHVM
 	int cpu;
-	xen_hvm_resume_shared_info();
+	xen_hvm_init_shared_info();
 	xen_callback_vector();
 	xen_unplug_emulated_devices();
 	if (xen_feature(XENFEAT_hvm_safe_pvclock)) {
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 1e4329e..202d4c1 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -41,7 +41,7 @@ void xen_enable_syscall(void);
 void xen_vcpu_restore(void);
 
 void xen_callback_vector(void);
-void xen_hvm_resume_shared_info(void);
+void xen_hvm_init_shared_info(void);
 void xen_unplug_emulated_devices(void);
 
 void __init xen_build_dynamic_phys_to_machine(void);
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index d4c50d6..97ca359 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -101,19 +101,6 @@ static int platform_pci_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-static void __devinit prepare_shared_info(void)
-{
-#ifdef CONFIG_KEXEC
-	unsigned long addr;
-	struct shared_info *hvm_shared_info;
-
-	addr = alloc_xen_mmio(PAGE_SIZE);
-	hvm_shared_info = ioremap(addr, PAGE_SIZE);
-	memset(hvm_shared_info, 0, PAGE_SIZE);
-	xen_hvm_prepare_kexec(hvm_shared_info, addr >> PAGE_SHIFT);
-#endif
-}
-
 static int __devinit platform_pci_init(struct pci_dev *pdev,
 				       const struct pci_device_id *ent)
 {
@@ -151,8 +138,6 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 	platform_mmio = mmio_addr;
 	platform_mmiolen = mmio_len;
 
-	prepare_shared_info();
-
 	if (!xen_have_vector_callback) {
 		ret = xen_allocate_irq(pdev);
 		if (ret) {
diff --git a/include/xen/events.h b/include/xen/events.h
index 9c641de..04399b2 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -58,8 +58,6 @@ void notify_remote_via_irq(int irq);
 
 void xen_irq_resume(void);
 
-void xen_hvm_prepare_kexec(struct shared_info *sip, unsigned long pfn);
-
 /* Clear an irq's pending state, in preparation for polling on it */
 void xen_clear_irq_pending(int irq);
 void xen_set_irq_pending(int irq);
-- 
1.7.7.6

