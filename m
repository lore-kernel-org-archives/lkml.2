Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0H3LUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:20:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:55789 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab0H3LUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:20:51 -0400
X-IronPort-AV: E=Sophos;i="4.56,292,1280721600"; 
   d="scan'208";a="111744730"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad.wilk@oracle.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 6/7] xen: support GSI -> pirq remapping in PV on HVM guests
Date: Mon, 30 Aug 2010 12:21:15 +0100
Message-Id: <1283167276-7364-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop>
References: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop>
X-OriginalArrivalTime: 30 Aug 2010 11:20:46.0610 (UTC) FILETIME=[6475CF20:01CB4835]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Disable pcifront when running on HVM: it is meant to be used with pv
guests that don't have PCI bus.

Use acpi_register_gsi_xen_hvm to remap GSIs into pirqs.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/pci.h   |    5 +++++
 arch/x86/pci/xen.c               |   14 ++++++++++++++
 drivers/pci/xen-pcifront.c       |    2 +-
 drivers/xen/events.c             |    6 +++++-
 include/xen/interface/features.h |    3 +++
 5 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/xen/pci.h b/arch/x86/include/asm/xen/pci.h
index b4d908b..be3dc21 100644
--- a/arch/x86/include/asm/xen/pci.h
+++ b/arch/x86/include/asm/xen/pci.h
@@ -4,10 +4,15 @@
 #if defined(CONFIG_PCI_XEN)
 extern int __init pci_xen_init(void);
 int xen_hvm_register_pirq(u32 gsi, int triggering);
+extern int __init pci_xen_hvm_init(void);
 #define pci_xen 1
 #else
 #define pci_xen 0
 #define pci_xen_init (0)
+static inline int pci_xen_hvm_init(void)
+{
+	return -1;
+}
 static inline int xen_hvm_register_pirq(u32 gsi, int triggering)
 {
 	return -1;
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 0ed1cae..bfbe185 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -14,6 +14,7 @@
 
 #include <asm/xen/hypervisor.h>
 
+#include <xen/features.h>
 #include <xen/events.h>
 #include <asm/xen/pci.h>
 
@@ -188,3 +189,16 @@ int __init pci_xen_init(void)
 #endif
 	return 0;
 }
+
+int __init pci_xen_hvm_init(void)
+{
+	if (!xen_feature(XENFEAT_hvm_pirqs))
+		return 0;
+
+	/*
+	 * We don't want to change the actual ACPI delivery model,
+	 * just how GSIs get registered.
+	 */
+	__acpi_register_gsi = acpi_register_gsi_xen_hvm;
+	return 0;
+}
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index a48a733..0a5d673 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -1136,7 +1136,7 @@ static struct xenbus_driver xenbus_pcifront_driver = {
 
 static int __init pcifront_init(void)
 {
-	if (!xen_domain())
+	if (!xen_domain() || xen_hvm_domain())
 		return -ENODEV;
 
 	pci_frontend_registrar(1 /* enable */);
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 302dad1..ab4e393 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -618,7 +618,8 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
 
 	/* If we are a PV guest, we don't have GSIs (no ACPI passed). Therefore
 	 * we are using the !xen_initial_domain() to drop in the function.*/
-	if (identity_mapped_irq(gsi) || !xen_initial_domain()) {
+	if (identity_mapped_irq(gsi) || (!xen_initial_domain() &&
+				xen_pv_domain())) {
 		irq = gsi;
 		irq_to_desc_alloc_node(irq, 0);
 		dynamic_irq_init(irq);
@@ -1383,6 +1384,9 @@ void __init xen_init_IRQ(void)
 	if (xen_hvm_domain()) {
 		xen_callback_vector();
 		native_init_IRQ();
+		/* pci_xen_hvm_init must be called after native_init_IRQ so that
+		 * __acpi_register_gsi can point at the right function */
+		pci_xen_hvm_init();
 	} else {
 		irq_ctx_init(smp_processor_id());
 	}
diff --git a/include/xen/interface/features.h b/include/xen/interface/features.h
index 70d2563..b6ca39a 100644
--- a/include/xen/interface/features.h
+++ b/include/xen/interface/features.h
@@ -47,6 +47,9 @@
 /* x86: pvclock algorithm is safe to use on HVM */
 #define XENFEAT_hvm_safe_pvclock           9
 
+/* x86: pirq can be used by HVM guests */
+#define XENFEAT_hvm_pirqs           10
+
 #define XENFEAT_NR_SUBMAPS 1
 
 #endif /* __XEN_PUBLIC_FEATURES_H__ */
-- 
1.5.6.5

