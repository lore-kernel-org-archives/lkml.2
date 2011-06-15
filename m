Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1FOTUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:20:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63594 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1FOTUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:20:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/8] xen/pci: In xen_register_pirq bind the GSI to the IRQ after the hypercall.
Date: Wed, 15 Jun 2011 15:19:43 -0400
Message-Id: <1308165587-24902-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
References: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DF905E0.010A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not before.. also that code segment starts looking like the HVM case.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 510dea5..251480f 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -112,24 +112,11 @@ static int xen_register_pirq(u32 gsi, int triggering)
 	if (!xen_pv_domain())
 		return -1;
 
-	if (triggering == ACPI_EDGE_SENSITIVE) {
-		shareable = 0;
-		name = "ioapic-edge";
-	} else {
-		shareable = 1;
-		name = "ioapic-level";
-	}
 
 	pirq = xen_allocate_pirq_gsi(gsi);
 	if (pirq < 0)
 		goto out;
 
-	irq = xen_bind_pirq_gsi_to_irq(gsi, pirq, shareable, name);
-	if (irq < 0)
-		goto out;
-
-	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d\n", pirq, irq);
-
 	map_irq.domid = DOMID_SELF;
 	map_irq.type = MAP_PIRQ_TYPE_GSI;
 	map_irq.index = gsi;
@@ -141,6 +128,20 @@ static int xen_register_pirq(u32 gsi, int triggering)
 		return -1;
 	}
 
+	if (triggering == ACPI_EDGE_SENSITIVE) {
+		shareable = 0;
+		name = "ioapic-edge";
+	} else {
+		shareable = 1;
+		name = "ioapic-level";
+	}
+
+	irq = xen_bind_pirq_gsi_to_irq(gsi, pirq, shareable, name);
+	if (irq < 0)
+		goto out;
+
+	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d\n", pirq, irq);
+
 out:
 	return irq;
 }
-- 
1.7.4.1

