Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0LASXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:23:53 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:25448 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0LASXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:23:51 -0500
X-IronPort-AV: E=Sophos;i="4.59,284,1288584000"; 
   d="scan'208";a="124875287"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 1/5] xen: use PHYSDEVOP_get_free_pirq to implement find_unbound_pirq
Date: Wed,  1 Dec 2010 18:23:26 +0000
Message-Id: <1291227810-15094-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1012011442280.14723@kaball-desktop>
References: <alpine.DEB.2.00.1012011442280.14723@kaball-desktop>
X-OriginalArrivalTime: 01 Dec 2010 18:23:50.0439 (UTC) FILETIME=[E6D17B70:01CB9184]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Use the new hypercall PHYSDEVOP_get_free_pirq to ask Xen to allocate a
pirq. Remove the unsupported PHYSDEVOP_get_nr_pirqs hypercall to get the
amount of pirq available.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/events.c            |   45 +++++++++++++++++---------------------
 include/xen/interface/physdev.h |   10 ++++++++
 2 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 2811bb9..7ab43c3 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -105,7 +105,6 @@ struct irq_info
 
 static struct irq_info *irq_info;
 static int *pirq_to_irq;
-static int nr_pirqs;
 
 static int *evtchn_to_irq;
 struct cpu_evtchn_s {
@@ -385,12 +384,17 @@ static int get_nr_hw_irqs(void)
 	return ret;
 }
 
-/* callers of this function should make sure that PHYSDEVOP_get_nr_pirqs
- * succeeded otherwise nr_pirqs won't hold the right value */
-static int find_unbound_pirq(void)
+static int find_unbound_pirq(int type)
 {
-	int i;
-	for (i = nr_pirqs-1; i >= 0; i--) {
+	int rc, i;
+	struct physdev_get_free_pirq op_get_free_pirq;
+	op_get_free_pirq.type = type;
+
+	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_free_pirq, &op_get_free_pirq);
+	if (!rc)
+		return op_get_free_pirq.pirq;
+
+	for (i = 0; i < nr_irqs; i++) {
 		if (pirq_to_irq[i] < 0)
 			return i;
 	}
@@ -611,10 +615,10 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
 
 	spin_lock(&irq_mapping_update_lock);
 
-	if ((pirq > nr_pirqs) || (gsi > nr_irqs)) {
+	if ((pirq > nr_irqs) || (gsi > nr_irqs)) {
 		printk(KERN_WARNING "xen_map_pirq_gsi: %s %s is incorrect!\n",
-			pirq > nr_pirqs ? "nr_pirqs" :"",
-			gsi > nr_irqs ? "nr_irqs" : "");
+			pirq > nr_irqs ? "pirq" :"",
+			gsi > nr_irqs ? "gsi" : "");
 		goto out;
 	}
 
@@ -672,7 +676,7 @@ void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
 	if (*irq == -1)
 		goto out;
 
-	*pirq = find_unbound_pirq();
+	*pirq = find_unbound_pirq(MAP_PIRQ_TYPE_MSI);
 	if (*pirq == -1)
 		goto out;
 
@@ -1506,26 +1510,17 @@ void xen_callback_vector(void) {}
 
 void __init xen_init_IRQ(void)
 {
-	int i, rc;
-	struct physdev_nr_pirqs op_nr_pirqs;
+	int i;
 
 	cpu_evtchn_mask_p = kcalloc(nr_cpu_ids, sizeof(struct cpu_evtchn_s),
 				    GFP_KERNEL);
 	irq_info = kcalloc(nr_irqs, sizeof(*irq_info), GFP_KERNEL);
 
-	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_nr_pirqs, &op_nr_pirqs);
-	if (rc < 0) {
-		nr_pirqs = nr_irqs;
-		if (rc != -ENOSYS)
-			printk(KERN_WARNING "PHYSDEVOP_get_nr_pirqs returned rc=%d\n", rc);
-	} else {
-		if (xen_pv_domain() && !xen_initial_domain())
-			nr_pirqs = max((int)op_nr_pirqs.nr_pirqs, nr_irqs);
-		else
-			nr_pirqs = op_nr_pirqs.nr_pirqs;
-	}
-	pirq_to_irq = kcalloc(nr_pirqs, sizeof(*pirq_to_irq), GFP_KERNEL);
-	for (i = 0; i < nr_pirqs; i++)
+	/* We are using nr_irqs as the maximum number of pirq available but
+	 * that number is actually chosen by Xen and we don't know exactly
+	 * what it is. Be careful choosing high pirq numbers. */
+	pirq_to_irq = kcalloc(nr_irqs, sizeof(*pirq_to_irq), GFP_KERNEL);
+	for (i = 0; i < nr_irqs; i++)
 		pirq_to_irq[i] = -1;
 
 	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index 2b2c66c..534cac8 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -188,6 +188,16 @@ struct physdev_nr_pirqs {
     uint32_t nr_pirqs;
 };
 
+/* type is MAP_PIRQ_TYPE_GSI or MAP_PIRQ_TYPE_MSI
+ * the hypercall returns a free pirq */
+#define PHYSDEVOP_get_free_pirq    23
+struct physdev_get_free_pirq {
+    /* IN */ 
+    int type;
+    /* OUT */
+    uint32_t pirq;
+};
+
 /*
  * Notify that some PIRQ-bound event channels have been unmasked.
  * ** This command is obsolete since interface version 0x00030202 and is **
-- 
1.5.6.5

