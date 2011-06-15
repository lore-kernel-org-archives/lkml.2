Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1FOTUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:20:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63587 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab1FOTUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:20:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 7/8] xen/pci: Move the allocation of IRQs when there is no IOAPIC to the end
Date: Wed, 15 Jun 2011 15:19:46 -0400
Message-Id: <1308165587-24902-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
References: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DF905E0.00AD:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. and also move the probing of ACPI (or MP tables) to be done before
this. Which means that we can actually get the IRQ's polarity (and trigger)
from either one of those entries. Previously - if we did not have an IOAPIC
we would not been able to do this.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 7425d7d..b53e1b7 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -417,18 +417,6 @@ int __init pci_xen_initial_domain(void)
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
@@ -440,6 +428,15 @@ int __init pci_xen_initial_domain(void)
 			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE, true);
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

