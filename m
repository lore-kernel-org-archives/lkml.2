Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0EQKFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:05:15 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50177 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0EQKFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:05:11 -0400
From: felipe.balbi@nokia.com
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 2/5] arm: omap: gpio: implement set_debounce method
Date: Mon, 17 May 2010 13:02:31 +0300
Message-Id: <1274090554-19420-3-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
References: <1274090554-19420-1-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 17 May 2010 10:04:33.0052 (UTC) FILETIME=[59087DC0:01CAF5A8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

OMAP support debouncing of gpio lines, implement
the method using gpiolib.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 arch/arm/plat-omap/gpio.c |   68 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index 45a225d..4a17dc4 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -612,6 +612,59 @@ do {	\
 	__raw_writel(l, base + reg); \
 } while(0)
 
+/**
+ * _set_gpio_debounce - low level gpio debounce time
+ * @bank: the gpio bank we're acting upon
+ * @gpio: the gpio number on this @gpio
+ * @debounce: debounce time to use
+ *
+ * OMAP's debounce time is in 31us steps so we need
+ * to convert and round up to the closest unit.
+ */
+static void _set_gpio_debounce(struct gpio_bank *bank, unsigned gpio,
+		unsigned debounce)
+{
+	void __iomem		*reg = bank->base;
+	u32			val;
+	u32			l;
+
+	if (debounce < 32)
+		debounce = 0x01;
+	else if (debounce > 7936)
+		debounce = 0xff;
+	else
+		debounce = (debounce / 0x1f) - 1;
+
+	l = 1 << get_gpio_index(gpio);
+
+	if (cpu_is_omap44xx())
+		reg += OMAP4_GPIO_DEBOUNCINGTIME;
+	else
+		reg += OMAP24XX_GPIO_DEBOUNCE_VAL;
+
+	__raw_writel(debounce, reg);
+
+	reg = bank->base;
+	if (cpu_is_omap44xx())
+		reg += OMAP4_GPIO_DEBOUNCENABLE;
+	else
+		reg += OMAP24XX_GPIO_DEBOUNCE_EN;
+
+	val = __raw_readl(reg);
+
+	if (debounce) {
+		val |= l;
+		if (cpu_is_omap34xx() || cpu_is_omap44xx())
+			clk_enable(bank->dbck);
+	} else {
+		val &= ~l;
+		if (cpu_is_omap34xx() || cpu_is_omap44xx())
+			clk_disable(bank->dbck);
+	}
+
+	__raw_writel(val, reg);
+}
+
 void omap_set_gpio_debounce(int gpio, int enable)
 {
 	struct gpio_bank *bank;
@@ -1608,6 +1661,20 @@ static int gpio_output(struct gpio_chip *chip, unsigned offset, int value)
 	return 0;
 }
 
+static int gpio_debounce(struct gpio_chip *chip, unsigned offset,
+		unsigned debounce)
+{
+	struct gpio_bank *bank;
+	unsigned long flags;
+
+	bank = container_of(chip, struct gpio_bank, chip);
+	spin_lock_irqsave(&bank->lock, flags);
+	_set_gpio_debounce(bank, offset, debounce);
+	spin_unlock_irqrestore(&bank->lock, flags);
+
+	return 0;
+}
+
 static void gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct gpio_bank *bank;
@@ -1860,6 +1927,7 @@ static int __init _omap_gpio_init(void)
 		bank->chip.direction_input = gpio_input;
 		bank->chip.get = gpio_get;
 		bank->chip.direction_output = gpio_output;
+		bank->chip.set_debounce = gpio_debounce;
 		bank->chip.set = gpio_set;
 		bank->chip.to_irq = gpio_2irq;
 		if (bank_is_mpuio(bank)) {
-- 
1.7.1

