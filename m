Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab0ERK3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:29:49 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:64753 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab0ERK3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:29:38 -0400
X-IronPort-AV: E=Sophos;i="4.53,254,1272859200"; 
   d="scan'208";a="97477206"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 08/12] Allow xen platform pci device to be compiled as a module
Date: Tue, 18 May 2010 11:23:03 +0100
Message-Id: <1274178187-20602-8-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop>
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop>
X-OriginalArrivalTime: 18 May 2010 10:20:07.0247 (UTC) FILETIME=[B04515F0:01CAF673]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/enlighten.c          |    3 +++
 drivers/xen/events.c              |    1 +
 drivers/xen/grant-table.c         |    6 +++++-
 drivers/xen/manage.c              |   14 +++++++++++---
 drivers/xen/xenbus/xenbus_probe.c |    1 +
 include/xen/platform_pci.h        |   18 ++++--------------
 6 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 23b8200..77ba321 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -85,7 +85,9 @@ struct shared_info xen_dummy_shared_info;
 void *xen_initial_gdt;
 
 int xen_have_vector_callback;
+EXPORT_SYMBOL_GPL(xen_have_vector_callback);
 int xen_platform_pci;
+EXPORT_SYMBOL_GPL(xen_platform_pci);
 static int unplug;
 
 /*
@@ -1297,6 +1299,7 @@ int xen_set_callback_via(uint64_t via)
 	a.value = via;
 	return HYPERVISOR_hvm_op(HVMOP_set_param, &a);
 }
+EXPORT_SYMBOL_GPL(xen_set_callback_via);
 
 void do_hvm_pv_evtchn_intr(void)
 {
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index cfc6d96..4840a03 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -695,6 +695,7 @@ void xen_hvm_evtchn_do_upcall(struct pt_regs *regs)
 {
 	__xen_evtchn_do_upcall(regs);
 }
+EXPORT_SYMBOL_GPL(xen_hvm_evtchn_do_upcall);
 
 /* Rebind a new event channel to an existing irq. */
 void rebind_evtchn_irq(int evtchn, int irq)
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 6f5f3ba..f936d30 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -56,6 +56,9 @@
 #define GNTTAB_LIST_END 0xffffffff
 #define GREFS_PER_GRANT_FRAME (PAGE_SIZE / sizeof(struct grant_entry))
 
+unsigned long (*alloc_xen_mmio_hook)(unsigned long len);
+EXPORT_SYMBOL_GPL(alloc_xen_mmio_hook);
+
 static grant_ref_t **gnttab_list;
 static unsigned int nr_grant_frames;
 static unsigned int boot_max_nr_grant_frames;
@@ -514,7 +517,7 @@ int gnttab_resume(void)
 		return gnttab_map(0, nr_grant_frames - 1);
 
 	if (!hvm_pv_resume_frames) {
-		hvm_pv_resume_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
+		hvm_pv_resume_frames = alloc_xen_mmio_hook(PAGE_SIZE * max_nr_gframes);
 		shared = ioremap(hvm_pv_resume_frames, PAGE_SIZE * max_nr_gframes);
 		if (shared == NULL) {
 			printk(KERN_WARNING
@@ -600,6 +603,7 @@ int gnttab_init(void)
 	kfree(gnttab_list);
 	return -ENOMEM;
 }
+EXPORT_SYMBOL_GPL(gnttab_init);
 
 static int __devinit __gnttab_init(void)
 {
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index a73edd8..49ee52d 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -34,6 +34,13 @@ enum shutdown_state {
 	 SHUTDOWN_HALT = 4,
 };
 
+void (*platform_pci_resume_hook)(void);
+EXPORT_SYMBOL_GPL(platform_pci_resume_hook);
+void (*platform_pci_disable_irq_hook)(void);
+EXPORT_SYMBOL_GPL(platform_pci_disable_irq_hook);
+void (*platform_pci_enable_irq_hook)(void);
+EXPORT_SYMBOL_GPL(platform_pci_enable_irq_hook);
+
 /* Ignore multiple shutdown requests. */
 static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
 
@@ -52,7 +59,7 @@ static int xen_hvm_suspend(void *data)
 
 	if (!*cancelled) {
 		xen_irq_resume();
-		platform_pci_resume();
+		platform_pci_resume_hook();
 	}
 
 	return 0;
@@ -119,7 +126,7 @@ static void do_hvm_suspend(void)
 	printk(KERN_DEBUG "suspending xenstore... ");
 	xenbus_suspend();
 	printk(KERN_DEBUG "xenstore suspended\n");
-	platform_pci_disable_irq();
+	platform_pci_disable_irq_hook();
 	
 	err = stop_machine(xen_hvm_suspend, &cancelled, cpumask_of(0));
 	if (err) {
@@ -127,7 +134,7 @@ static void do_hvm_suspend(void)
 		cancelled = 1;
 	}
 
-	platform_pci_enable_irq();
+	platform_pci_enable_irq_hook();
 
 	if (!cancelled) {
 		xen_arch_resume();
@@ -357,5 +364,6 @@ int xen_setup_shutdown_event(void)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(xen_setup_shutdown_event);
 
 subsys_initcall(__setup_shutdown_event);
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index a679205..f83e083 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -892,6 +892,7 @@ int xenbus_probe_init(void)
   out_error:
 	return err;
 }
+EXPORT_SYMBOL_GPL(xenbus_probe_init);
 
 postcore_initcall(__xenbus_probe_init);
 
diff --git a/include/xen/platform_pci.h b/include/xen/platform_pci.h
index ced434d..c3c2527 100644
--- a/include/xen/platform_pci.h
+++ b/include/xen/platform_pci.h
@@ -29,19 +29,9 @@
 #define XEN_IOPORT_LINUX_PRODNUM 0xffff
 #define XEN_IOPORT_LINUX_DRVVER  ((LINUX_VERSION_CODE << 8) + 0x0)
 
-#ifdef CONFIG_XEN_PLATFORM_PCI
-unsigned long alloc_xen_mmio(unsigned long len);
-void platform_pci_resume(void);
-void platform_pci_disable_irq(void);
-void platform_pci_enable_irq(void);
-#else
-static inline unsigned long alloc_xen_mmio(unsigned long len)
-{
-	return ~0UL;
-}
-static inline void platform_pci_resume(void) {}
-static inline void platform_pci_disable_irq(void) {}
-static inline void platform_pci_enable_irq(void) {}
-#endif
+extern unsigned long (*alloc_xen_mmio_hook)(unsigned long len);
+extern void (*platform_pci_resume_hook)(void);
+extern void (*platform_pci_disable_irq_hook)(void);
+extern void (*platform_pci_enable_irq_hook)(void);
 
 #endif /* _XEN_PLATFORM_PCI_H */
-- 
1.5.4.3

