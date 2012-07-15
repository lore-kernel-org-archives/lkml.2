Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab2GOQHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 12:07:03 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:45832 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2GOQG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 12:06:57 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr3s7qE/Z2
X-RZG-CLASS-ID: mo00
Date: Sun, 15 Jul 2012 18:06:53 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Keir Fraser <keir.xen@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>, xen-devel@lists.xensource.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Message-ID: <20120715160653.GA22779@aepfle.de>
References: <20120710180953.GB20075@aepfle.de>
 <CC223C2F.3817C%keir.xen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CC223C2F.3817C%keir.xen@gmail.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, Keir Fraser wrote:

> Best thing to do, is possible, is map the shared-info page in the
> xen-platform pci device's BAR memory range. Then it will not conflict with
> any RAM.

This patch does that. I did a kexec boot and a save/restore.
It does not deal with the possible race were the old pfn is not backed
by a mfn.

Olaf


commit a9d5567c67a2317c9db174a4deef6c5690220749
Author: Olaf Hering <olaf@aepfle.de>
Date:   Thu Jul 12 19:38:39 2012 +0200

    xen PVonHVM: move shared info page from RAM to MMIO
    
    Signed-off-by: Olaf Hering <ohering@suse.de>

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ff962d4..8a743af 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1465,23 +1465,22 @@ static int init_hvm_pv_info(int *major, int *minor)
 	return 0;
 }
 
-void __ref xen_hvm_init_shared_info(void)
+static struct shared_info *hvm_shared_info;
+static unsigned long hvm_shared_info_pfn;
+
+static void __ref set_shared_info(struct shared_info *sip, unsigned long pfn)
 {
 	int cpu;
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
+	HYPERVISOR_shared_info = sip;
 
 	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
 	 * page, we use it in the event channel upcall and in some pvclock
@@ -1494,8 +1493,48 @@ void __ref xen_hvm_init_shared_info(void)
 	for_each_online_cpu(cpu) {
 		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 	}
+	mb();
 }
 
+/* Reconnect the pfn to a mfn */
+void __ref xen_hvm_resume_shared_info(void)
+{
+	set_shared_info(hvm_shared_info, hvm_shared_info_pfn);
+}
+
+/* Move the pfn in RAM to a pfn in MMIO space */
+void __ref xen_hvm_finalize_shared_info(struct shared_info *sip, unsigned long pfn)
+{
+	struct xen_memory_reservation reservation = {
+		.domid = DOMID_SELF,
+		.nr_extents = 1,
+	};
+	int rc;
+
+	set_xen_guest_handle(reservation.extent_start, &hvm_shared_info_pfn);
+
+	/* Move pfn, disconnects previous pfn from mfn */
+	set_shared_info(sip, pfn);
+
+	/* Allocate new mfn for previous pfn */
+	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
+	WARN_ON(rc != 1);
+
+	/* Remember final pfn and pointer for resume */
+	hvm_shared_info_pfn = pfn;
+	hvm_shared_info = sip;
+}
+
+/* Use a pfn in RAM until PCI init is done. */
+static void __ref xen_hvm_initial_shared_info(void)
+{
+	/* FIXME simply allocate a page and release it after pfn move (How at this stage?) */
+	hvm_shared_info = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	hvm_shared_info_pfn = __pa(hvm_shared_info) >> PAGE_SHIFT;
+	set_shared_info(hvm_shared_info, hvm_shared_info_pfn);
+}
+
+
 #ifdef CONFIG_XEN_PVHVM
 static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
@@ -1526,7 +1565,7 @@ static void __init xen_hvm_guest_init(void)
 	if (r < 0)
 		return;
 
-	xen_hvm_init_shared_info();
+	xen_hvm_initial_shared_info();
 
 	if (xen_feature(XENFEAT_hvm_callback_vector))
 		xen_have_vector_callback = 1;
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
index 202d4c1..1e4329e 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -41,7 +41,7 @@ void xen_enable_syscall(void);
 void xen_vcpu_restore(void);
 
 void xen_callback_vector(void);
-void xen_hvm_init_shared_info(void);
+void xen_hvm_resume_shared_info(void);
 void xen_unplug_emulated_devices(void);
 
 void __init xen_build_dynamic_phys_to_machine(void);
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index 97ca359..cbe866b 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -108,6 +108,8 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 	long ioaddr;
 	long mmio_addr, mmio_len;
 	unsigned int max_nr_gframes;
+	unsigned long addr;
+	struct shared_info *hvm_shared_info;
 
 	if (!xen_domain())
 		return -ENODEV;
@@ -138,6 +140,11 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 	platform_mmio = mmio_addr;
 	platform_mmiolen = mmio_len;
 
+	addr = alloc_xen_mmio(PAGE_SIZE);
+	hvm_shared_info = ioremap(addr, PAGE_SIZE);
+	memset(hvm_shared_info, 0, PAGE_SIZE);
+	xen_hvm_finalize_shared_info(hvm_shared_info, addr >> PAGE_SHIFT);
+
 	if (!xen_have_vector_callback) {
 		ret = xen_allocate_irq(pdev);
 		if (ret) {
diff --git a/include/xen/events.h b/include/xen/events.h
index 04399b2..3337698 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -58,6 +58,8 @@ void notify_remote_via_irq(int irq);
 
 void xen_irq_resume(void);
 
+void xen_hvm_finalize_shared_info(struct shared_info *sip, unsigned long pfn);
+
 /* Clear an irq's pending state, in preparation for polling on it */
 void xen_clear_irq_pending(int irq);
 void xen_set_irq_pending(int irq);
