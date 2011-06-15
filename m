Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1FOTUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:20:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63580 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab1FOTUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:20:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/8] xen/pci: Provide #ifdef CONFIG_ACPI to easy code squashing.
Date: Wed, 15 Jun 2011 15:19:42 -0400
Message-Id: <1308165587-24902-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
References: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DF905E0.0070:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. we guard those code segments to be dependent on CONFIG_XEN_DOM0
(and that config option depends on ACPI) so this patch is not
neccesary - but the next one will merge the HVM and initial domain
code as much as it can and we want to make sure the CONFIG_ACPI
dependency is preserved (HVM does not depend on CONFIG_XEN_DOM0).

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index f44446b..510dea5 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -101,6 +101,7 @@ static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
 #endif
 
 #ifdef CONFIG_XEN_DOM0
+#ifdef CONFIG_ACPI
 static int xen_register_pirq(u32 gsi, int triggering)
 {
 	int rc, pirq, irq = -1;
@@ -178,6 +179,7 @@ static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
 	return xen_register_gsi(gsi, trigger, polarity);
 }
 #endif
+#endif
 
 #if defined(CONFIG_PCI_MSI)
 #include <linux/msi.h>
@@ -407,6 +409,7 @@ int __init pci_xen_hvm_init(void)
 }
 
 #ifdef CONFIG_XEN_DOM0
+#ifdef CONFIG_ACPI
 static __init void xen_setup_acpi_sci(void)
 {
 	int rc;
@@ -433,16 +436,17 @@ static __init void xen_setup_acpi_sci(void)
 
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
 
@@ -462,7 +466,7 @@ void __init xen_setup_pirqs(void)
 		}
 		return;
 	}
-
+#ifdef CONFIG_ACPI
 	/* Pre-allocate legacy irqs */
 	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
 		int trigger, polarity;
@@ -473,6 +477,7 @@ void __init xen_setup_pirqs(void)
 		xen_register_pirq(irq,
 			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE);
 	}
+#endif
 }
 
 struct xen_device_domain_owner {
-- 
1.7.4.1

