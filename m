Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0EQKFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:05:20 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50188 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab0EQKFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:05:16 -0400
From: felipe.balbi@nokia.com
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 4/5] arm: omap: remove the unused omap_gpio_set_debounce methods
Date: Mon, 17 May 2010 13:02:33 +0300
Message-Id: <1274090554-19420-5-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
References: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 17 May 2010 10:04:38.0474 (UTC) FILETIME=[5C43D2A0:01CAF5A8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

nobody uses that anymore, so remove and expect drivers
to use the gpiolib implementation.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 arch/arm/plat-omap/gpio.c |   73 ---------------------------------------------
 1 files changed, 0 insertions(+), 73 deletions(-)

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index 4a17dc4..95f92b0 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -665,79 +665,6 @@ static void _set_gpio_debounce(struct gpio_bank *bank, unsigned gpio,
 	__raw_writel(val, reg);
 }
 
-void omap_set_gpio_debounce(int gpio, int enable)
-{
-	struct gpio_bank *bank;
-	void __iomem *reg;
-	unsigned long flags;
-	u32 val, l = 1 << get_gpio_index(gpio);
-
-	if (cpu_class_is_omap1())
-		return;
-
-	bank = get_gpio_bank(gpio);
-	reg = bank->base;
-
-	if (cpu_is_omap44xx())
-		reg += OMAP4_GPIO_DEBOUNCENABLE;
-	else
-		reg += OMAP24XX_GPIO_DEBOUNCE_EN;
-
-	if (!(bank->mod_usage & l)) {
-		printk(KERN_ERR "GPIO %d not requested\n", gpio);
-		return;
-	}
-
-	spin_lock_irqsave(&bank->lock, flags);
-	val = __raw_readl(reg);
-
-	if (enable && !(val & l))
-		val |= l;
-	else if (!enable && (val & l))
-		val &= ~l;
-	else
-		goto done;
-
-	if (cpu_is_omap34xx() || cpu_is_omap44xx()) {
-		if (enable)
-			clk_enable(bank->dbck);
-		else
-			clk_disable(bank->dbck);
-	}
-
-	__raw_writel(val, reg);
-done:
-	spin_unlock_irqrestore(&bank->lock, flags);
-}
-EXPORT_SYMBOL(omap_set_gpio_debounce);
-
-void omap_set_gpio_debounce_time(int gpio, int enc_time)
-{
-	struct gpio_bank *bank;
-	void __iomem *reg;
-
-	if (cpu_class_is_omap1())
-		return;
-
-	bank = get_gpio_bank(gpio);
-	reg = bank->base;
-
-	if (!bank->mod_usage) {
-		printk(KERN_ERR "GPIO not requested\n");
-		return;
-	}
-
-	enc_time &= 0xff;
-
-	if (cpu_is_omap44xx())
-		reg += OMAP4_GPIO_DEBOUNCINGTIME;
-	else
-		reg += OMAP24XX_GPIO_DEBOUNCE_VAL;
-
-	__raw_writel(enc_time, reg);
-}
-EXPORT_SYMBOL(omap_set_gpio_debounce_time);
-
 #ifdef CONFIG_ARCH_OMAP2PLUS
 static inline void set_24xx_gpio_triggering(struct gpio_bank *bank, int gpio,
 						int trigger)
-- 
1.7.1

