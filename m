Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab0JLQfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:35:08 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:2945 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab0JLQfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:35:06 -0400
X-IronPort-AV: E=Sophos;i="4.57,320,1283745600"; 
   d="scan'208";a="117744595"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad.wilk@oracle.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 2/7] xen: get the maximum number of pirqs from xen
Date: Tue, 12 Oct 2010 17:34:44 +0100
Message-Id: <1286901289-8156-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
X-OriginalArrivalTime: 12 Oct 2010 16:35:06.0108 (UTC) FILETIME=[6D5C13C0:01CB6A2B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Use PHYSDEVOP_get_nr_pirqs to get the maximum number of pirqs from xen.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c            |   30 ++++++++++++++++++++++++++----
 include/xen/interface/physdev.h |    6 ++++++
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 943f140..c77a44b 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -102,6 +102,7 @@ struct irq_info
 
 static struct irq_info *irq_info;
 static int *pirq_to_irq;
+static int nr_pirqs;
 
 static int *evtchn_to_irq;
 struct cpu_evtchn_s {
@@ -378,10 +379,12 @@ static int get_nr_hw_irqs(void)
 	return ret;
 }
 
+/* callers of this function should make sure that PHYSDEVOP_get_nr_pirqs
+ * succeeded otherwise nr_pirqs won't hold the right value */
 static int find_unbound_pirq(void)
 {
 	int i;
-	for (i = 0; i < nr_irqs; i++) {
+	for (i = nr_pirqs-1; i >= 0; i--) {
 		if (pirq_to_irq[i] < 0)
 			return i;
 	}
@@ -603,6 +606,13 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
 
 	spin_lock(&irq_mapping_update_lock);
 
+	if ((pirq > nr_pirqs) || (gsi > nr_irqs)) {
+		printk(KERN_WARNING "xen_map_pirq_gsi: %s %s is incorrect!\n",
+			pirq > nr_pirqs ? "nr_pirqs" :"",
+			gsi > nr_irqs ? "nr_irqs" : "");
+		goto out;
+	}
+
 	irq = find_irq_by_gsi(gsi);
 	if (irq != -1) {
 		printk(KERN_INFO "xen_map_pirq_gsi: returning irq %d for gsi %u\n",
@@ -1351,14 +1361,26 @@ void xen_callback_vector(void) {}
 
 void __init xen_init_IRQ(void)
 {
-	int i;
+	int i, rc;
+	struct physdev_nr_pirqs op_nr_pirqs;
 
 	cpu_evtchn_mask_p = kcalloc(nr_cpu_ids, sizeof(struct cpu_evtchn_s),
 				    GFP_KERNEL);
 	irq_info = kcalloc(nr_irqs, sizeof(*irq_info), GFP_KERNEL);
 
-	pirq_to_irq = kcalloc(nr_irqs, sizeof(*pirq_to_irq), GFP_KERNEL);
-	for (i = 0; i < nr_irqs; i++)
+	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_nr_pirqs, &op_nr_pirqs);
+	if (rc < 0) {
+		nr_pirqs = nr_irqs;
+		if (rc != -ENOSYS)
+			printk(KERN_WARNING "PHYSDEVOP_get_nr_pirqs returned rc=%d\n", rc);
+	} else {
+		if (xen_pv_domain() && !xen_initial_domain())
+			nr_pirqs = max((int)op_nr_pirqs.nr_pirqs, nr_irqs);
+		else
+			nr_pirqs = op_nr_pirqs.nr_pirqs;
+	}
+	pirq_to_irq = kcalloc(nr_pirqs, sizeof(*pirq_to_irq), GFP_KERNEL);
+	for (i = 0; i < nr_pirqs; i++)
 		pirq_to_irq[i] = -1;
 
 	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index cd69391..fbb5883 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -121,6 +121,12 @@ struct physdev_op {
 	} u;
 };
 
+#define PHYSDEVOP_get_nr_pirqs    22
+struct physdev_nr_pirqs {
+    /* OUT */
+    uint32_t nr_pirqs;
+};
+
 /*
  * Notify that some PIRQ-bound event channels have been unmasked.
  * ** This command is obsolete since interface version 0x00030202 and is **
-- 
1.5.6.5

