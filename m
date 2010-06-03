Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0FCNL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:11:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4116 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0FCNLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:11:24 -0400
X-IronPort-AV: E=Sophos;i="4.53,354,1272859200"; 
   d="scan'208";a="99908936"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
       jeremy@goop.org, ddutile@redhat.com, sheng@linux.intel.com,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 05/12] Add suspend\resume support for PV on HVM guests.
Date: Thu,  3 Jun 2010 14:10:38 +0100
Message-Id: <1275570645-27189-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-OriginalArrivalTime: 03 Jun 2010 13:11:23.0256 (UTC) FILETIME=[43DB9F80:01CB031E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Suspend\resume requires few different thing on HVM: the suspend
hypercall is different, we don't need to save\restore any memory related
setting, but we need to reinitialize the shared info page and the
callback mechanism.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/enlighten.c   |   16 ++++++++++----
 arch/x86/xen/suspend.c     |    6 +++++
 arch/x86/xen/xen-ops.h     |    1 +
 drivers/xen/manage.c       |   45 ++++++++++++++++++++++++++++++++++++++++---
 drivers/xen/platform-pci.c |   23 +++++++++++++++++++++-
 include/xen/xen-ops.h      |    3 ++
 6 files changed, 84 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ed34b30..c71b0fa 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1263,12 +1263,14 @@ static int init_hvm_pv_info(int *major, int *minor)
 	return 0;
 }
 
-static void __init init_shared_info(void)
+void xen_hvm_init_shared_info(void)
 {
+	int cpu;
 	struct xen_add_to_physmap xatp;
-	struct shared_info *shared_info_page;
+	static struct shared_info *shared_info_page = 0;
 
-	shared_info_page = (struct shared_info *) alloc_bootmem_pages(PAGE_SIZE);
+	if (!shared_info_page)
+		shared_info_page = (struct shared_info *) alloc_bootmem_pages(PAGE_SIZE);
 	xatp.domid = DOMID_SELF;
 	xatp.idx = 0;
 	xatp.space = XENMAPSPACE_shared_info;
@@ -1280,7 +1282,11 @@ static void __init init_shared_info(void)
 
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
-	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
+	/* xen_hvm_init_shared_info is run at resume time too, in that case
+	 * multiple vcpus might be online */
+ 	for_each_online_cpu(cpu) {
+		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
+	}
 }
 
 static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
@@ -1313,7 +1319,7 @@ void __init xen_guest_init(void)
 	if (r < 0)
 		return;
 
-	init_shared_info();
+	xen_hvm_init_shared_info();
 
 	if (xen_feature(XENFEAT_hvm_callback_vector))
 		xen_have_vector_callback = 1;
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 987267f..6ff9665 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -26,6 +26,12 @@ void xen_pre_suspend(void)
 		BUG();
 }
 
+void xen_hvm_post_suspend(int suspend_cancelled)
+{
+	xen_hvm_init_shared_info();
+	xen_callback_vector();
+}
+
 void xen_post_suspend(int suspend_cancelled)
 {
 	xen_build_mfn_list_list();
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 0d0e0e6..01c9dd3 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -39,6 +39,7 @@ void xen_enable_syscall(void);
 void xen_vcpu_restore(void);
 
 void xen_callback_vector(void);
+void xen_hvm_init_shared_info(void);
 
 void __init xen_build_dynamic_phys_to_machine(void);
 
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 2ac4440..0716ba6 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -9,6 +9,7 @@
 #include <linux/stop_machine.h>
 #include <linux/freezer.h>
 
+#include <xen/xen.h>
 #include <xen/xenbus.h>
 #include <xen/grant_table.h>
 #include <xen/events.h>
@@ -17,6 +18,7 @@
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/page.h>
+#include <asm/xen/hypervisor.h>
 
 enum shutdown_state {
 	SHUTDOWN_INVALID = -1,
@@ -33,10 +35,30 @@ enum shutdown_state {
 static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
 
 #ifdef CONFIG_PM_SLEEP
-static int xen_suspend(void *data)
+static int xen_hvm_suspend(void *data)
 {
+	struct sched_shutdown r = { .reason = SHUTDOWN_suspend };
 	int *cancelled = data;
+
+	BUG_ON(!irqs_disabled());
+
+	*cancelled = HYPERVISOR_sched_op(SCHEDOP_shutdown, &r);
+
+	xen_hvm_post_suspend(*cancelled);
+	gnttab_resume();
+
+	if (!*cancelled) {
+		xen_irq_resume();
+		xen_timer_resume();
+	}
+
+	return 0;
+}
+
+static int xen_suspend(void *data)
+{
 	int err;
+	int *cancelled = data;
 
 	BUG_ON(!irqs_disabled());
 
@@ -112,7 +134,10 @@ static void do_suspend(void)
 		goto out_resume;
 	}
 
-	err = stop_machine(xen_suspend, &cancelled, cpumask_of(0));
+	if (xen_hvm_domain())
+		err = stop_machine(xen_hvm_suspend, &cancelled, cpumask_of(0));
+	else
+		err = stop_machine(xen_suspend, &cancelled, cpumask_of(0));
 
 	dpm_resume_noirq(PMSG_RESUME);
 
@@ -261,7 +286,19 @@ static int shutdown_event(struct notifier_block *notifier,
 	return NOTIFY_DONE;
 }
 
-static int __init setup_shutdown_event(void)
+static int __init __setup_shutdown_event(void)
+{
+	/* Delay initialization in the PV on HVM case */
+	if (xen_hvm_domain())
+		return 0;
+
+	if (!xen_pv_domain())
+		return -ENODEV;
+
+	return xen_setup_shutdown_event();
+}
+
+int xen_setup_shutdown_event(void)
 {
 	static struct notifier_block xenstore_notifier = {
 		.notifier_call = shutdown_event
@@ -271,4 +308,4 @@ static int __init setup_shutdown_event(void)
 	return 0;
 }
 
-subsys_initcall(setup_shutdown_event);
+subsys_initcall(__setup_shutdown_event);
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index 9cb7242..43f5aa8 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -31,6 +31,7 @@
 #include <xen/xenbus.h>
 #include <xen/events.h>
 #include <xen/hvm.h>
+#include <xen/xen-ops.h>
 
 #define DRV_NAME    "xen-platform-pci"
 
@@ -41,6 +42,7 @@ MODULE_LICENSE("GPL");
 static unsigned long platform_mmio;
 static unsigned long platform_mmio_alloc;
 static unsigned long platform_mmiolen;
+static uint64_t callback_via;
 
 unsigned long alloc_xen_mmio(unsigned long len)
 {
@@ -85,13 +87,25 @@ static int xen_allocate_irq(struct pci_dev *pdev)
 			"xen-platform-pci", pdev);
 }
 
+static int platform_pci_resume(struct pci_dev *pdev)
+{
+	int err;
+	if (xen_have_vector_callback)
+		return 0;
+	err = xen_set_callback_via(callback_via);
+	if (err) {
+		printk("platform_pci_resume failure!\n");
+		return err;
+	}
+	return 0;
+}
+
 static int __devinit platform_pci_init(struct pci_dev *pdev,
 				       const struct pci_device_id *ent)
 {
 	int i, ret;
 	long ioaddr, iolen;
 	long mmio_addr, mmio_len;
-	uint64_t callback_via;
 
 	i = pci_enable_device(pdev);
 	if (i)
@@ -145,6 +159,10 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 	ret = xenbus_probe_init();
 	if (ret)
 		goto out;
+	ret = xen_setup_shutdown_event();
+	if (ret)
+		goto out;
+
 
 out:
 	if (ret) {
@@ -168,6 +186,9 @@ static struct pci_driver platform_driver = {
 	.name =           DRV_NAME,
 	.probe =          platform_pci_init,
 	.id_table =       platform_pci_tbl,
+#ifdef CONFIG_PM
+	.resume_early =   platform_pci_resume,
+#endif
 };
 
 static int __init platform_pci_module_init(void)
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 883a21b..46bc81e 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -7,6 +7,7 @@ DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
 
 void xen_pre_suspend(void);
 void xen_post_suspend(int suspend_cancelled);
+void xen_hvm_post_suspend(int suspend_cancelled);
 
 void xen_mm_pin_all(void);
 void xen_mm_unpin_all(void);
@@ -14,4 +15,6 @@ void xen_mm_unpin_all(void);
 void xen_timer_resume(void);
 void xen_arch_resume(void);
 
+int xen_setup_shutdown_event(void);
+
 #endif /* INCLUDE_XEN_OPS_H */
-- 
1.7.0.4

