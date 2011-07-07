Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab1GGTJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:09:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:43794 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252Ab1GGTIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:08:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 07/10] xen/pci: Move the allocation of IRQs when there are no IOAPIC's to the end
Date: Thu,  7 Jul 2011 15:08:23 -0400
Message-Id: <1310065706-18797-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
References: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E160438.002C:SCFMA922111,ss=1,re=-4.000,fgs=0
X-Greylist: IP, sender and recipient auto-whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Thu, 07 Jul 2011 19:08:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. which means we can preset of NR_IRQS_LEGACY interrupts using
the 'acpi_get_override_irq' API before this loop.
This means that we can get the IRQ's polarity (and trigger) from either
the ACPI (or MP); or use the default values. This fixes a bug if we did
not have an IOAPIC we would not been able to preset the IRQ's polarity
if the MP table existed.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 54d5f31..e585bf5 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -441,18 +441,6 @@ int __init pci_xen_initial_domain(void)
 #ifdef CONFIG_ACPI
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
-#endif
-	if (0 == nr_ioapics) {
-		for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
-			pirq = xen_allocate_pirq_gsi(irq);
-			if (WARN(pirq < 0,
-				 "Could not allocate PIRQ for legacy interrupt\n"))
-				break;
-			irq = xen_bind_pirq_gsi_to_irq(irq, pirq, 0, "xt-pic");
-		}
-		return 0;
-	}
-#ifdef CONFIG_ACPI
 	/* Pre-allocate legacy irqs */
 	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
 		int trigger, polarity;
@@ -465,6 +453,15 @@ int __init pci_xen_initial_domain(void)
 			true /* allocate IRQ */);
 	}
 #endif
+	if (0 == nr_ioapics) {
+		for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
+			pirq = xen_allocate_pirq_gsi(irq);
+			if (WARN(pirq < 0,
+				 "Could not allocate PIRQ for legacy interrupt\n"))
+				break;
+			irq = xen_bind_pirq_gsi_to_irq(irq, pirq, 0, "xt-pic");
+		}
+	}
 	return 0;
 }
 
-- 
1.7.4.1

