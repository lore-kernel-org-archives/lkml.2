Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab1GGTJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:09:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:43796 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922Ab1GGTIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:08:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 04/10] xen/pci: In xen_register_pirq bind the GSI to the IRQ after the hypercall.
Date: Thu,  7 Jul 2011 15:08:20 -0400
Message-Id: <1310065706-18797-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
References: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E160438.0030:SCFMA922111,ss=1,re=-4.000,fgs=0
X-Greylist: Delayed for 52:54:53 by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Thu, 07 Jul 2011 19:08:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not before .. also that code segment starts looking like the HVM one.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 7ee39cc..6b7d849 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -112,26 +112,10 @@ static int xen_register_pirq(u32 gsi, int gsi_override, int triggering)
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
 
-	if (gsi_override >= 0)
-		irq = xen_bind_pirq_gsi_to_irq(gsi_override, pirq, shareable, name);
-	else
-		irq = xen_bind_pirq_gsi_to_irq(gsi, pirq, shareable, name);
-	if (irq < 0)
-		goto out;
-
-	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d (gsi=%d)\n", pirq, irq, gsi);
-
 	map_irq.domid = DOMID_SELF;
 	map_irq.type = MAP_PIRQ_TYPE_GSI;
 	map_irq.index = gsi;
@@ -143,6 +127,22 @@ static int xen_register_pirq(u32 gsi, int gsi_override, int triggering)
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
+	if (gsi_override >= 0)
+		gsi = gsi_override;
+
+	irq = xen_bind_pirq_gsi_to_irq(gsi, pirq, shareable, name);
+	if (irq < 0)
+		goto out;
+
+	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d (gsi=%d)\n", pirq, irq, gsi);
 out:
 	return irq;
 }
-- 
1.7.4.1

