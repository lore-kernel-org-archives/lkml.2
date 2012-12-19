Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2LSBw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 20:52:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:32896 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156Ab2LSBwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:52:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,313,1355126400"; 
   d="scan'208";a="233627010"
From: David Cohen <david.a.cohen@intel.com>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        "Li, Ning" <ning.li@intel.com>, David Cohen <david.a.cohen@intel.com>
Subject: [PATCH 3/3] gpio-langwell: implement irq shutdown interface
Date: Tue, 18 Dec 2012 17:52:13 -0800
Message-Id: <1355881933-15182-4-git-send-email-david.a.cohen@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355881933-15182-1-git-send-email-david.a.cohen@intel.com>
References: <1355881933-15182-1-git-send-email-david.a.cohen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Li, Ning" <ning.li@intel.com>

Signed-off-by: David Cohen <david.a.cohen@intel.com>
Signed-off-by: Li, Ning <ning.li@intel.com>
---
 drivers/gpio/gpio-langwell.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index dc534a9..c702d3d 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -219,12 +219,30 @@ static int lnw_irq_type(struct irq_data *d, unsigned type)
 
 static void lnw_irq_noop(struct irq_data *d) {}
 
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
+	value = readl(grer) & ~BIT(gpio % 32);
+	writel(value, grer);
+	value = readl(gfer) & ~BIT(gpio % 32);
+	writel(value, gfer);
+	spin_unlock_irqrestore(&lnw->lock, flags);
+};
+
 static struct irq_chip lnw_irqchip = {
 	.name		= "LNW-GPIO",
 	.irq_mask	= lnw_irq_noop,
 	.irq_unmask	= lnw_irq_noop,
 	.irq_set_type	= lnw_irq_type,
 	.irq_ack	= lnw_irq_noop,
+	.irq_shutdown	= lnw_irq_shutdown,
 };
 
 static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
-- 
1.7.10.4

