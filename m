Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab1ALAxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:53:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:19814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406Ab1ALAxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:53:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,309,1291622400"; 
   d="scan'208";a="645933790"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        sameo@linux.intel.com, alan@linux.intel.com
Cc: Feng Tang <feng.tang@intel.com>, Alek Du <alek.du@intel.com>
Subject: [PATCH] langwell_gpio: modify EOI handling following change of kernel irq subsystem
Date: Wed, 12 Jan 2011 08:54:05 +0800
Message-Id: <1294793645-32663-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest kernel has many changes in IRQ subsystem and its interfaces, like adding
"irq_eoi" for struct irq_chip, this patch is a follow up change for that.

Also remove the unnecessary caster for a "void *".

Cc: Alek Du <alek.du@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/gpio/langwell_gpio.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 64db9dc..6cb3954 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -187,7 +187,7 @@ MODULE_DEVICE_TABLE(pci, lnw_gpio_ids);
 
 static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	struct lnw_gpio *lnw = (struct lnw_gpio *)get_irq_data(irq);
+	struct lnw_gpio *lnw = get_irq_data(irq);
 	u32 base, gpio;
 	void __iomem *gedr;
 	u32 gedr_v;
@@ -206,7 +206,12 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 		/* clear the edge detect status bit */
 		writel(gedr_v, gedr);
 	}
-	desc->chip->eoi(irq);
+
+	if (desc->chip->irq_eoi)
+		desc->chip->irq_eoi(irq_get_irq_data(irq));
+	else
+		dev_warn(lnw->chip.dev, "missing EOI handler for irq %d\n", irq);
+
 }
 
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
-- 
1.7.0.4

