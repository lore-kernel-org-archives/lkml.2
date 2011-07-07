Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab1GGTIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:08:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:57825 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab1GGTIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:08:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 03/10] xen/pci: Provide #ifdef CONFIG_ACPI to easy code squashing.
Date: Thu,  7 Jul 2011 15:08:19 -0400
Message-Id: <1310065706-18797-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
References: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4E160438.00C2:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the past we would guard those code segments to be dependent
on CONFIG_XEN_DOM0 (which depends on CONFIG_ACPI) so this patch is
not stricly necessary. But the next patch will merge common
HVM and initial domain code and we want to make sure the CONFIG_ACPI
dependency is preserved - as HVM code does not depend on CONFIG_XEN_DOM0.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 76b3980..7ee39cc 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -101,6 +101,7 @@ static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
 #endif
 
 #ifdef CONFIG_XEN_DOM0
+#ifdef CONFIG_ACPI
 static int xen_register_pirq(u32 gsi, int gsi_override, int triggering)
 {
 	int rc, pirq, irq = -1;
@@ -180,6 +181,7 @@ static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
 	return xen_register_gsi(gsi, -1 /* no GSI override */, trigger, polarity);
 }
 #endif
+#endif
 
 #if defined(CONFIG_PCI_MSI)
 #include <linux/msi.h>
@@ -409,6 +411,7 @@ int __init pci_xen_hvm_init(void)
 }
 
 #ifdef CONFIG_XEN_DOM0
+#ifdef CONFIG_ACPI
 static __init void xen_setup_acpi_sci(void)
 {
 	int rc;
@@ -455,16 +458,17 @@ static __init void xen_setup_acpi_sci(void)
 
 	return;
 }
-
+#endif
 static int __init pci_xen_initial_domain(void)
 {
 #ifdef CONFIG_PCI_MSI
 	x86_msi.setup_msi_irqs = xen_initdom_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
 #endif
+#ifdef CONFIG_ACPI
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
-
+#endif
 	return 0;
 }
 
@@ -484,7 +488,7 @@ void __init xen_setup_pirqs(void)
 		}
 		return;
 	}
-
+#ifdef CONFIG_ACPI
 	/* Pre-allocate legacy irqs */
 	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
 		int trigger, polarity;
@@ -495,6 +499,7 @@ void __init xen_setup_pirqs(void)
 		xen_register_pirq(irq, -1 /* no GSI override */,
 			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE);
 	}
+#endif
 }
 
 struct xen_device_domain_owner {
-- 
1.7.4.1

