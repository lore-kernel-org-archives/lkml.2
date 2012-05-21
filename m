Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2EUPyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:54:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:60650 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2EUPyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:54:43 -0400
X-IronPort-AV: E=Sophos;i="4.75,631,1330923600"; 
   d="scan'208";a="195812786"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: xen-devel@lists.xensource.com
CC: stefano.stabellini@eu.citrix.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] xen: do not map the same GSI twice
Date: Mon, 21 May 2012 16:54:10 +0100
Message-ID: <1337615650-27911-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PV on HVM guests map GSIs into event channels; at restore time the
event channels are resumed by restore_pirqs.
Device drivers might try to register the same GSI again through ACPI at
restore time, but the GSI has already been mapped and bound by
restore_pirqs.
This patch detects these situations and avoid mapping the same GSI
multiple times.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/pci/xen.c   |    4 ++++
 drivers/xen/events.c |    5 +++--
 include/xen/events.h |    3 +++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 7415aa9..56ab749 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -64,6 +64,10 @@ static int xen_register_pirq(u32 gsi, int gsi_override, int triggering,
 	int shareable = 0;
 	char *name;
 
+	irq = xen_irq_from_gsi(gsi);
+	if (irq > 0)
+		return irq;
+
 	if (set_pirq)
 		pirq = gsi;
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 0a8a17c..6908e4c 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -611,7 +611,7 @@ static void disable_pirq(struct irq_data *data)
 	disable_dynirq(data);
 }
 
-static int find_irq_by_gsi(unsigned gsi)
+int xen_irq_from_gsi(unsigned gsi)
 {
 	struct irq_info *info;
 
@@ -625,6 +625,7 @@ static int find_irq_by_gsi(unsigned gsi)
 
 	return -1;
 }
+EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
 
 /*
  * Do not make any assumptions regarding the relationship between the
@@ -644,7 +645,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 
 	mutex_lock(&irq_mapping_update_lock);
 
-	irq = find_irq_by_gsi(gsi);
+	irq = xen_irq_from_gsi(gsi);
 	if (irq != -1) {
 		printk(KERN_INFO "xen_map_pirq_gsi: returning irq %d for gsi %u\n",
 		       irq, gsi);
diff --git a/include/xen/events.h b/include/xen/events.h
index 0f77370..b332bd7 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -103,6 +103,9 @@ int xen_irq_from_pirq(unsigned pirq);
 /* Return the pirq allocated to the irq. */
 int xen_pirq_from_irq(unsigned irq);
 
+/* Return the irq allocated to the gsi */
+int xen_irq_from_gsi (unsigned gsi);
+
 /* Determine whether to ignore this IRQ if it is passed to a guest. */
 int xen_test_irq_shared(int irq);
 
-- 
1.7.2.5

