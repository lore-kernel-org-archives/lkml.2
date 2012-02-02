Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab2BBRfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:35:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47553 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740Ab2BBRbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:21 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Charulatha V <charu@ti.com>
Subject: [PATCH v9 12/25] gpio/omap: use pinctrl offset instead of macro
Date: Thu, 2 Feb 2012 23:00:38 +0530
Message-ID: <1328203851-20435-13-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charulatha V <charu@ti.com>

Use regs->pinctrl field instead of using the macro OMAP1510_GPIO_PIN_CONTROL

Signed-off-by: Charulatha V <charu@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/gpio15xx.c         |    1 +
 arch/arm/plat-omap/include/plat/gpio.h |    1 +
 drivers/gpio/gpio-omap.c               |    8 +++-----
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap1/gpio15xx.c b/arch/arm/mach-omap1/gpio15xx.c
index 2adfece..950e467 100644
--- a/arch/arm/mach-omap1/gpio15xx.c
+++ b/arch/arm/mach-omap1/gpio15xx.c
@@ -85,6 +85,7 @@ static struct omap_gpio_reg_offs omap15xx_gpio_regs = {
 	.irqenable	= OMAP1510_GPIO_INT_MASK,
 	.irqenable_inv	= true,
 	.irqctrl	= OMAP1510_GPIO_INT_CONTROL,
+	.pinctrl	= OMAP1510_GPIO_PIN_CONTROL,
 };
 
 static struct __initdata omap_gpio_platform_data omap15xx_gpio_config = {
diff --git a/arch/arm/plat-omap/include/plat/gpio.h b/arch/arm/plat-omap/include/plat/gpio.h
index 9e403e5..8be1651 100644
--- a/arch/arm/plat-omap/include/plat/gpio.h
+++ b/arch/arm/plat-omap/include/plat/gpio.h
@@ -198,6 +198,7 @@ struct omap_gpio_reg_offs {
 	u16 irqctrl;
 	u16 edgectrl1;
 	u16 edgectrl2;
+	u16 pinctrl;
 
 	bool irqenable_inv;
 };
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index a948351..485b6b2 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -490,15 +490,13 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 	 */
 	_set_gpio_triggering(bank, offset, IRQ_TYPE_NONE);
 
-#ifdef CONFIG_ARCH_OMAP15XX
-	if (bank->method == METHOD_GPIO_1510) {
-		void __iomem *reg;
+	if (bank->regs->pinctrl) {
+		void __iomem *reg = bank->base + bank->regs->pinctrl;
 
 		/* Claim the pin for MPU */
-		reg = bank->base + OMAP1510_GPIO_PIN_CONTROL;
 		__raw_writel(__raw_readl(reg) | (1 << offset), reg);
 	}
-#endif
+
 	if (bank->regs->ctrl && !bank->mod_usage) {
 		void __iomem *reg = bank->base + bank->regs->ctrl;
 		u32 ctrl;
-- 
1.7.0.4

