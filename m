Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab0JLQfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:35:17 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30077 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab0JLQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:35:12 -0400
X-IronPort-AV: E=Sophos;i="4.57,320,1283745600"; 
   d="scan'208";a="117744612"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad.wilk@oracle.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 6/7] xen: support GSI -> pirq remapping in PV on HVM guests
Date: Tue, 12 Oct 2010 17:34:48 +0100
Message-Id: <1286901289-8156-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
X-OriginalArrivalTime: 12 Oct 2010 16:35:11.0998 (UTC) FILETIME=[70DED1E0:01CB6A2B]
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
 arch/x86/pci/xen.c               |   16 ++++++++++++++++
 drivers/xen/events.c             |    6 +++++-
 include/xen/interface/features.h |    3 +++
 4 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/xen/pci.h b/arch/x86/include/asm/xen/pci.h
index 449c82f..f89a42a 100644
--- a/arch/x86/include/asm/xen/pci.h
+++ b/arch/x86/include/asm/xen/pci.h
@@ -3,10 +3,15 @@
 
 #if defined(CONFIG_PCI_XEN)
 extern int __init pci_xen_init(void);
+extern int __init pci_xen_hvm_init(void);
 #define pci_xen 1
 #else
 #define pci_xen 0
 #define pci_xen_init (0)
+static inline int pci_xen_hvm_init(void)
+{
+	return -1;
+}
 #endif
 
 #if defined(CONFIG_PCI_MSI)
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index ef9b8b2..90a8f83 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -14,6 +14,7 @@
 
 #include <asm/xen/hypervisor.h>
 
+#include <xen/features.h>
 #include <xen/events.h>
 #include <asm/xen/pci.h>
 
@@ -189,3 +190,18 @@ int __init pci_xen_init(void)
 #endif
 	return 0;
 }
+
+int __init pci_xen_hvm_init(void)
+{
+	if (!xen_feature(XENFEAT_hvm_pirqs))
+		return 0;
+
+#ifdef CONFIG_ACPI
+	/*
+	 * We don't want to change the actual ACPI delivery model,
+	 * just how GSIs get registered.
+	 */
+	__acpi_register_gsi = acpi_register_gsi_xen_hvm;
+#endif
+	return 0;
+}
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 4fed942..5e4fe09 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -624,7 +624,8 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
 
 	/* If we are a PV guest, we don't have GSIs (no ACPI passed). Therefore
 	 * we are using the !xen_initial_domain() to drop in the function.*/
-	if (identity_mapped_irq(gsi) || !xen_initial_domain()) {
+	if (identity_mapped_irq(gsi) || (!xen_initial_domain() &&
+				xen_pv_domain())) {
 		irq = gsi;
 		irq_to_desc_alloc_node(irq, 0);
 		dynamic_irq_init(irq);
@@ -1399,6 +1400,9 @@ void __init xen_init_IRQ(void)
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

