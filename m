Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab1JKGzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 02:55:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:48936 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab1JKGzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 02:55:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,521,1312182000"; 
   d="scan'208";a="76832969"
From: Adrian Hunter <adrian.hunter@intel.com>
To: grant.likely@secretlab.ca
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] gpio: langwell: declare reg_base as __iomem
Date: Tue, 11 Oct 2011 09:55:28 +0300
Message-Id: <1318316128-21982-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.6.4
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg_base is __iomem so add that to the declaration
and fix up assigment casts and types.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---



Sending again because forgot to cc lkml



 drivers/gpio/gpio-langwell.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 00692e8..b7465e5 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -64,7 +64,7 @@ enum GPIO_REG {
 
 struct lnw_gpio {
 	struct gpio_chip		chip;
-	void				*reg_base;
+	void __iomem			*reg_base;
 	spinlock_t			lock;
 	unsigned			irq_base;
 	struct pci_dev			*pdev;
@@ -78,7 +78,7 @@ static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
 	u8 reg = offset / 32;
 	void __iomem *ptr;
 
-	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
+	ptr = lnw->reg_base + reg_type * nreg * 4 + reg * 4;
 	return ptr;
 }
 
@@ -90,7 +90,7 @@ static void __iomem *gpio_reg_2bit(struct gpio_chip *chip, unsigned offset,
 	u8 reg = offset / 16;
 	void __iomem *ptr;
 
-	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
+	ptr = lnw->reg_base + reg_type * nreg * 4 + reg * 4;
 	return ptr;
 }
 
@@ -299,7 +299,7 @@ static const struct dev_pm_ops lnw_gpio_pm_ops = {
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 			const struct pci_device_id *id)
 {
-	void *base;
+	void __iomem *base;
 	int i;
 	resource_size_t start, len;
 	struct lnw_gpio *lnw;
@@ -324,8 +324,8 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "error mapping bar1\n");
 		goto err3;
 	}
-	irq_base = *(u32 *)base;
-	gpio_base = *((u32 *)base + 1);
+	irq_base = *(__force u32 *)base;
+	gpio_base = *((__force u32 *)base + 1);
 	/* release the IO mapping, since we already get the info from bar1 */
 	iounmap(base);
 	/* get the register base from bar0 */
-- 
1.7.6.4

