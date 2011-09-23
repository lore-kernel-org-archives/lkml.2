Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1IWMsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:48:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56092 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1IWMsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:48:11 -0400
thread-index: Acx57wjOB1HLh1E4T8y2S6uqQvJhNg==
Content-Transfer-Encoding: 8BIT
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
From: Tero Kristo <t-kristo@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Kevin Hilman" <khilman@ti.com>, "Paul Walmsley" <paul@pwsan.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>
Subject: [PATCHv9 07/18] mfd: omap-prm: added suspend prepare and complete callbacks
Date: Fri, 23 Sep 2011 15:46:15 +0300
Message-ID: <1316781986-30642-8-git-send-email-t-kristo@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are needed because runtime PM is disabled during suspend, and
it is bad if we get interrupts from the PRCM chain handler during it.
Now, PRCM interrupt forwarding is disabled until the suspend->complete,
which makes sure that all the needed drivers are up.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/omap-prm-common.c |   34 +++++++++++++++++++++++++++++++++-
 drivers/mfd/omap-prm.h        |    2 ++
 drivers/mfd/omap3xxx-prm.c    |    1 +
 drivers/mfd/omap4xxx-prm.c    |    1 +
 4 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/omap-prm-common.c b/drivers/mfd/omap-prm-common.c
index 2886eb2..e8522fc 100644
--- a/drivers/mfd/omap-prm-common.c
+++ b/drivers/mfd/omap-prm-common.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/platform_device.h>
 
 #include "omap-prm.h"
 
@@ -35,6 +36,7 @@ struct omap_prm_device {
 	int base_irq;
 	int irq;
 	void __iomem *base;
+	int suspended;
 };
 
 static struct omap_prm_device prm_dev;
@@ -92,12 +94,20 @@ static void prcm_irq_handler(unsigned int irq, struct irq_desc *desc)
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	unsigned int virtirq;
 	int nr_irqs = prm_dev.irq_setup->nr_regs * 32;
+	int i;
+
+	if (prm_dev.suspended)
+		for (i = 0; i < prm_dev.irq_setup->nr_regs; i++) {
+			prm_dev.saved_mask[i] =
+				prm_read_reg(prm_dev.irq_setup->mask + i * 4);
+			prm_write_reg(0, prm_dev.irq_setup->mask + i * 4);
+		}
 
 	/*
 	 * Loop until all pending irqs are handled, since
 	 * generic_handle_irq() can cause new irqs to come
 	 */
-	while (1) {
+	while (!prm_dev.suspended) {
 		prm_pending_events(pending);
 
 		/* No bit set, then all IRQs are handled */
@@ -258,6 +268,28 @@ err:
 	return -ENOMEM;
 }
 
+static int omap_prm_prepare(struct device *kdev)
+{
+	prm_dev.suspended = 1;
+	return 0;
+}
+
+static void omap_prm_complete(struct device *kdev)
+{
+	int i;
+
+	prm_dev.suspended = 0;
+
+	for (i = 0; i < prm_dev.irq_setup->nr_regs; i++)
+		prm_write_reg(prm_dev.saved_mask[i],
+			prm_dev.irq_setup->mask + i * 4);
+}
+
+const struct dev_pm_ops omap_prm_pm_ops = {
+	.prepare = omap_prm_prepare,
+	.complete = omap_prm_complete,
+};
+
 MODULE_AUTHOR("Tero Kristo <t-kristo@ti.com>");
 MODULE_DESCRIPTION("OMAP PRM core driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/omap-prm.h b/drivers/mfd/omap-prm.h
index 7ffefe1..c901810 100644
--- a/drivers/mfd/omap-prm.h
+++ b/drivers/mfd/omap-prm.h
@@ -32,6 +32,8 @@ struct omap_prcm_irq {
 	.priority = _priority				\
 	}
 
+extern const struct dev_pm_ops omap_prm_pm_ops;
+
 void omap_prcm_irq_cleanup(void);
 int omap_prcm_register_chain_handler(int irq, void __iomem *base,
 	const struct omap_prcm_irq_setup *irq_setup,
diff --git a/drivers/mfd/omap3xxx-prm.c b/drivers/mfd/omap3xxx-prm.c
index 9be21ee..38b88aa 100644
--- a/drivers/mfd/omap3xxx-prm.c
+++ b/drivers/mfd/omap3xxx-prm.c
@@ -66,6 +66,7 @@ static struct platform_driver omap3xxx_prm_driver = {
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= DRIVER_NAME,
+		.pm	= &omap_prm_pm_ops,
 	},
 };
 
diff --git a/drivers/mfd/omap4xxx-prm.c b/drivers/mfd/omap4xxx-prm.c
index 6e134a7..92cc67d 100644
--- a/drivers/mfd/omap4xxx-prm.c
+++ b/drivers/mfd/omap4xxx-prm.c
@@ -65,6 +65,7 @@ static struct platform_driver omap4xxx_prm_driver = {
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= DRIVER_NAME,
+		.pm	= &omap_prm_pm_ops,
 	},
 };
 
-- 
1.7.4.1


Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. Kotipaikka: Helsinki
 

