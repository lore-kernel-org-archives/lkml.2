Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2GQKZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:25:05 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:19638 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab2GQKY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:24:59 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJji0PEBZF
X-RZG-CLASS-ID: mo00
Date: Tue, 17 Jul 2012 12:24:56 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Keir Fraser <keir.xen@gmail.com>, xen-devel@lists.xensource.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Message-ID: <20120717102456.GA8197@aepfle.de>
References: <20120710180953.GB20075@aepfle.de>
 <CC223C2F.3817C%keir.xen@gmail.com>
 <20120715160653.GA22779@aepfle.de>
 <20120716154647.GC13540@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120716154647.GC13540@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, Konrad Rzeszutek Wilk wrote:

> On Sun, Jul 15, 2012 at 06:06:53PM +0200, Olaf Hering wrote:
> > -void __ref xen_hvm_init_shared_info(void)
> > +static struct shared_info *hvm_shared_info;
> > +static unsigned long hvm_shared_info_pfn;
> > +
> 
> Please include a big comment explainig what this machination is OK
> to do multiple times. If you can include the juicy snippets of the
> email converstation in this comment so that in 6 months if somebody
> looks at this they have a good understanding of it.

I have added a comment to the new patch, and I will extend it further in
the commit message.

> > +	/* Move pfn, disconnects previous pfn from mfn */
> > +	set_shared_info(sip, pfn);
> > +
> > +	/* Allocate new mfn for previous pfn */
> > +	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
> > +	WARN_ON(rc != 1);
> 
> Shouldn't you do some recovery if it fails? Like reassign the old RAM pfn
> back to the shared page?

I moved the whole reassignment into the shutdown path because there is
appearently no sane way to make the move atomic. Shortly before reboot
all vcpus are still online, but hopefully the other vcpus have no work
left.

See below, the change is on top of the two other patches I sent out
today.

Olaf

xen PVonHVM: move shared_info to MMIO before kexec

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 arch/x86/xen/enlighten.c   |  114 +++++++++++++++++++++++++++++++++++++++-----
 arch/x86/xen/suspend.c     |    2 +-
 arch/x86/xen/xen-ops.h     |    2 +-
 drivers/xen/platform-pci.c |   15 ++++++
 include/xen/events.h       |    2 +
 5 Dateien geändert, 122 Zeilen hinzugefügt(+), 13 Zeilen entfernt(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 184fa9c..3cf233b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -31,6 +31,7 @@
 #include <linux/pci.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
+#include <linux/syscore_ops.h>
 
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
@@ -1439,38 +1440,126 @@ asmlinkage void __init xen_start_kernel(void)
 #endif
 }
 
-void __ref xen_hvm_init_shared_info(void)
+#ifdef CONFIG_XEN_PVHVM
+/*
+ * The pfn containing the shared_info is located somewhere in RAM. This
+ * will cause trouble if the current kernel is doing a kexec boot into a
+ * new kernel. The new kernel (and its startup code) can not know where
+ * the pfn is, so it can not reserve the page. The hypervisor will
+ * continue to update the pfn, and as a result memory corruption occours
+ * in the new kernel.
+ *
+ * One way to work around this issue is to allocate a page in the
+ * xen-platform pci device's BAR memory range. But pci init is done very
+ * late and the shared_info page is already in use very early to read
+ * the pvclock. So moving the pfn from RAM to MMIO is racy because some
+ * code paths on other vcpus could access the pfn during the small
+ * window when the old pfn is moved to the new pfn. There is even a
+ * small window were the old pfn is not backed by a mfn, and during that
+ * time all reads return -1.
+ *
+ * Because it is not known upfront where the MMIO region is located it
+ * can not be used right from the start in xen_hvm_init_shared_info.
+ *
+ * To minimise trouble the move of the pfn is done shortly before kexec.
+ * This does not eliminate the race because all vcpus are still online
+ * when the syscore_ops will be called. But hopefully there is no work
+ * pending at this point in time. Also the syscore_op is run last which
+ * reduces the risk further.
+ */
+
+static struct shared_info *xen_hvm_shared_info;
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
+static void xen_hvm_set_shared_info(struct shared_info *sip)
+{
+	int cpu;
+
+	HYPERVISOR_shared_info = sip;
 
 	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
 	 * page, we use it in the event channel upcall and in some pvclock
 	 * related functions. We don't need the vcpu_info placement
 	 * optimizations because we don't use any pv_mmu or pv_irq op on
 	 * HVM.
-	 * When xen_hvm_init_shared_info is run at boot time only vcpu 0 is
-	 * online but xen_hvm_init_shared_info is run at resume time too and
+	 * When xen_hvm_set_shared_info is run at boot time only vcpu 0 is
+	 * online but xen_hvm_set_shared_info is run at resume time too and
 	 * in that case multiple vcpus might be online. */
 	for_each_online_cpu(cpu) {
 		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 	}
 }
 
-#ifdef CONFIG_XEN_PVHVM
+/* Reconnect the shared_info pfn to a mfn */
+void xen_hvm_resume_shared_info(void)
+{
+	xen_hvm_connect_shared_info(__pa(xen_hvm_shared_info) >> PAGE_SHIFT);
+}
+
+#ifdef CONFIG_KEXEC
+static struct shared_info *xen_hvm_shared_info_kexec;
+static unsigned long xen_hvm_shared_info_pfn_kexec;
+
+/* Remember a pfn in MMIO space for kexec reboot */
+void __devinit xen_hvm_prepare_kexec(struct shared_info *sip, unsigned long pfn)
+{
+	xen_hvm_shared_info_kexec = sip;
+	xen_hvm_shared_info_pfn_kexec = pfn;
+}
+
+static void xen_hvm_syscore_shutdown(void)
+{
+	struct xen_memory_reservation reservation = {
+		.domid = DOMID_SELF,
+		.nr_extents = 1,
+	};
+	unsigned long prev_pfn;
+	int rc;
+
+	if (!xen_hvm_shared_info_kexec)
+		return;
+
+	prev_pfn = __pa(xen_hvm_shared_info) >> PAGE_SHIFT;
+	set_xen_guest_handle(reservation.extent_start, &prev_pfn);
+
+	/* Move pfn to MMIO, disconnects previous pfn from mfn */
+	xen_hvm_connect_shared_info(xen_hvm_shared_info_pfn_kexec);
+
+	/* Update pointers, following hypercall is also a memory barrier */
+	xen_hvm_set_shared_info(xen_hvm_shared_info_kexec);
+
+	/* Allocate new mfn for previous pfn */
+	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
+
+	/* Make sure the previous pfn is really connected to a (new) mfn */
+	BUG_ON(rc != 1);
+}
+
+static struct syscore_ops xen_hvm_syscore_ops = {
+	.shutdown = xen_hvm_syscore_shutdown,
+};
+#endif
+
+/* Use a pfn in RAM, may move to MMIO before kexec. */
+static void __init xen_hvm_init_shared_info(void)
+{
+	/* Remember pointer for resume */
+	xen_hvm_shared_info = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	xen_hvm_connect_shared_info(__pa(xen_hvm_shared_info) >> PAGE_SHIFT);
+	xen_hvm_set_shared_info(xen_hvm_shared_info);
+}
+
 static void __init init_hvm_pv_info(void)
 {
 	int major, minor;
@@ -1521,6 +1610,9 @@ static void __init xen_hvm_guest_init(void)
 	init_hvm_pv_info();
 
 	xen_hvm_init_shared_info();
+#ifdef CONFIG_KEXEC
+	register_syscore_ops(&xen_hvm_syscore_ops);
+#endif
 
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
index 97ca359..d4c50d6 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -101,6 +101,19 @@ static int platform_pci_resume(struct pci_dev *pdev)
 	return 0;
 }
 
+static void __devinit prepare_shared_info(void)
+{
+#ifdef CONFIG_KEXEC
+	unsigned long addr;
+	struct shared_info *hvm_shared_info;
+
+	addr = alloc_xen_mmio(PAGE_SIZE);
+	hvm_shared_info = ioremap(addr, PAGE_SIZE);
+	memset(hvm_shared_info, 0, PAGE_SIZE);
+	xen_hvm_prepare_kexec(hvm_shared_info, addr >> PAGE_SHIFT);
+#endif
+}
+
 static int __devinit platform_pci_init(struct pci_dev *pdev,
 				       const struct pci_device_id *ent)
 {
@@ -138,6 +151,8 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 	platform_mmio = mmio_addr;
 	platform_mmiolen = mmio_len;
 
+	prepare_shared_info();
+
 	if (!xen_have_vector_callback) {
 		ret = xen_allocate_irq(pdev);
 		if (ret) {
diff --git a/include/xen/events.h b/include/xen/events.h
index 04399b2..9c641de 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -58,6 +58,8 @@ void notify_remote_via_irq(int irq);
 
 void xen_irq_resume(void);
 
+void xen_hvm_prepare_kexec(struct shared_info *sip, unsigned long pfn);
+
 /* Clear an irq's pending state, in preparation for polling on it */
 void xen_clear_irq_pending(int irq);
 void xen_set_irq_pending(int irq);
-- 
1.7.10.4

