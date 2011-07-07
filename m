Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab1GGTJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:09:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:43799 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819Ab1GGTIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:08:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 06/10] xen/pci: Squash pci_xen_initial_domain and xen_setup_pirqs together.
Date: Thu,  7 Jul 2011 15:08:22 -0400
Message-Id: <1310065706-18797-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
References: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4E160438.00CC:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
X-Greylist: IP, sender and recipient auto-whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Thu, 07 Jul 2011 19:08:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since they are only called once and the rest of the pci_xen_*
functions follow the same pattern of setup.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/pci.h |    5 +++--
 arch/x86/pci/xen.c             |   17 ++++++-----------
 drivers/xen/events.c           |    2 +-
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/xen/pci.h b/arch/x86/include/asm/xen/pci.h
index 4fbda9a..968d57d 100644
--- a/arch/x86/include/asm/xen/pci.h
+++ b/arch/x86/include/asm/xen/pci.h
@@ -14,13 +14,14 @@ static inline int pci_xen_hvm_init(void)
 }
 #endif
 #if defined(CONFIG_XEN_DOM0)
-void __init xen_setup_pirqs(void);
+int __init pci_xen_initial_domain(void);
 int xen_find_device_domain_owner(struct pci_dev *dev);
 int xen_register_device_domain_owner(struct pci_dev *dev, uint16_t domain);
 int xen_unregister_device_domain_owner(struct pci_dev *dev);
 #else
-static inline void __init xen_setup_pirqs(void)
+static inline int __init pci_xen_initial_domain(void)
 {
+	return -1;
 }
 static inline int xen_find_device_domain_owner(struct pci_dev *dev)
 {
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 55c8cc3..54d5f31 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -429,8 +429,11 @@ static __init void xen_setup_acpi_sci(void)
 	return;
 }
 #endif
-static int __init pci_xen_initial_domain(void)
+
+int __init pci_xen_initial_domain(void)
 {
+	int pirq, irq;
+
 #ifdef CONFIG_PCI_MSI
 	x86_msi.setup_msi_irqs = xen_initdom_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
@@ -439,15 +442,6 @@ static int __init pci_xen_initial_domain(void)
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
 #endif
-	return 0;
-}
-
-void __init xen_setup_pirqs(void)
-{
-	int pirq, irq;
-
-	pci_xen_initial_domain();
-
 	if (0 == nr_ioapics) {
 		for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
 			pirq = xen_allocate_pirq_gsi(irq);
@@ -456,7 +450,7 @@ void __init xen_setup_pirqs(void)
 				break;
 			irq = xen_bind_pirq_gsi_to_irq(irq, pirq, 0, "xt-pic");
 		}
-		return;
+		return 0;
 	}
 #ifdef CONFIG_ACPI
 	/* Pre-allocate legacy irqs */
@@ -471,6 +465,7 @@ void __init xen_setup_pirqs(void)
 			true /* allocate IRQ */);
 	}
 #endif
+	return 0;
 }
 
 struct xen_device_domain_owner {
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 30df85d..23f1b81 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1693,6 +1693,6 @@ void __init xen_init_IRQ(void)
 	} else {
 		irq_ctx_init(smp_processor_id());
 		if (xen_initial_domain())
-			xen_setup_pirqs();
+			pci_xen_initial_domain();
 	}
 }
-- 
1.7.4.1

