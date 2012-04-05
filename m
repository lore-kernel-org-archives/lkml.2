Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2DEJOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 05:14:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:28182 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab2DEJOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 05:14:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85587203"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/3] gpio: langwell: allocate IRQ descriptors dynamically for SPARSE_IRQ
Date: Thu,  5 Apr 2012 12:15:16 +0300
Message-Id: <1333617317-28437-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333617317-28437-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1333617317-28437-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since x86 is using SPARSE_IRQ by default nowadays it means that we need to
allocate IRQ descriptors dynamically using irq_alloc_descs() otherwise the
genirq code fails to convert our irq numbers to suitable descriptors.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpio-langwell.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 0bea41b..bc15ae3 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -306,6 +306,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	u32 irq_base;
 	u32 gpio_base;
 	int retval = 0;
+	int ngpio = id->driver_data;
 
 	retval = pci_enable_device(pdev);
 	if (retval)
@@ -344,8 +345,15 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 		retval = -ENOMEM;
 		goto err3;
 	}
+
+	retval = irq_alloc_descs(-1, irq_base, ngpio, 0);
+	if (retval < 0) {
+		dev_err(&pdev->dev, "can't allocate IRQ descs\n");
+		goto err3;
+	}
+	lnw->irq_base = retval;
+
 	lnw->reg_base = base;
-	lnw->irq_base = irq_base;
 	lnw->chip.label = dev_name(&pdev->dev);
 	lnw->chip.request = lnw_gpio_request;
 	lnw->chip.direction_input = lnw_gpio_direction_input;
@@ -354,14 +362,14 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 	lnw->chip.set = lnw_gpio_set;
 	lnw->chip.to_irq = lnw_gpio_to_irq;
 	lnw->chip.base = gpio_base;
-	lnw->chip.ngpio = id->driver_data;
+	lnw->chip.ngpio = ngpio;
 	lnw->chip.can_sleep = 0;
 	lnw->pdev = pdev;
 	pci_set_drvdata(pdev, lnw);
 	retval = gpiochip_add(&lnw->chip);
 	if (retval) {
 		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
-		goto err3;
+		goto err4;
 	}
 	irq_set_handler_data(pdev->irq, lnw);
 	irq_set_chained_handler(pdev->irq, lnw_irq_handler);
@@ -378,6 +386,8 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 
 	return 0;
 
+err4:
+	irq_free_descs(lnw->irq_base, ngpio);
 err3:
 	pci_release_regions(pdev);
 err2:
-- 
1.7.9.1

