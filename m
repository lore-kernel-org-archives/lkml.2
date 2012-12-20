Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2LTWpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:45:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:15177 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab2LTWo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:44:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,326,1355126400"; 
   d="scan'208";a="268018227"
From: David Cohen <david.a.cohen@intel.com>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        "Li, Ning" <ning.li@intel.com>, David Cohen <david.a.cohen@intel.com>
Subject: [PATCH v2 2/2] gpio-langwell: implement irq shutdown interface
Date: Thu, 20 Dec 2012 14:45:52 -0800
Message-Id: <1356043552-14579-3-git-send-email-david.a.cohen@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1356043552-14579-1-git-send-email-david.a.cohen@intel.com>
References: <1356043552-14579-1-git-send-email-david.a.cohen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Li, Ning" <ning.li@intel.com>

Disable falling/rising edge detection during irq shutdown operation.

Signed-off-by: David Cohen <david.a.cohen@intel.com>
Signed-off-by: Li, Ning <ning.li@intel.com>
---
 drivers/gpio/gpio-langwell.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 2be69fe..10cc520 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -225,11 +225,32 @@ static void lnw_irq_mask(struct irq_data *d)
 {
 }
 
+static void lnw_irq_shutdown(struct irq_data *d)
+{
+	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
+	u32 gpio = irqd_to_hwirq(d);
+	unsigned long flags;
+	u32 value;
+	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
+	void __iomem *gfer = gpio_reg(&lnw->chip, gpio, GFER);
+
+	spin_lock_irqsave(&lnw->lock, flags);
+
+	/* Disable falling/rising edge detection */
+	value = readl(grer) & ~BIT(gpio % 32);
+	writel(value, grer);
+	value = readl(gfer) & ~BIT(gpio % 32);
+	writel(value, gfer);
+
+	spin_unlock_irqrestore(&lnw->lock, flags);
+};
+
 static struct irq_chip lnw_irqchip = {
 	.name		= "LNW-GPIO",
 	.irq_mask	= lnw_irq_mask,
 	.irq_unmask	= lnw_irq_unmask,
 	.irq_set_type	= lnw_irq_type,
+	.irq_shutdown	= lnw_irq_shutdown,
 };
 
 static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
-- 
1.7.10.4

