Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab1FFUim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:38:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56514 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1FFUik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:38:40 -0400
From: Colin Cross <ccross@android.com>
To: linux-omap@vger.kernel.org
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, tarun.kanti@ti.com,
        linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@android.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ARM: omap4: gpio: fix setting IRQWAKEN bits
Date: Mon,  6 Jun 2011 13:38:17 -0700
Message-Id: <1307392698-21170-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the IRQWAKEN bit was overwriting previous IRQWAKEN bits,
causing only the last bit set to take effect, resulting in lost
wakeups when the GPIO controller is in idle.

Replace direct writes to IRQWAKEN with MOD_REG_BIT calls to
perform a read-modify-write on the register.

Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/gpio/gpio-omap.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

Santosh, I left your Acked-by off this patch because I changed
the register access to match the OMAP4 TRM.

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 6c51191..8ba6957 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -432,7 +432,6 @@ static inline void set_24xx_gpio_triggering(struct gpio_bank *bank, int gpio,
 {
 	void __iomem *base = bank->base;
 	u32 gpio_bit = 1 << gpio;
-	u32 val;
 
 	if (cpu_is_omap44xx()) {
 		MOD_REG_BIT(OMAP4_GPIO_LEVELDETECT0, gpio_bit,
@@ -455,15 +454,8 @@ static inline void set_24xx_gpio_triggering(struct gpio_bank *bank, int gpio,
 	}
 	if (likely(!(bank->non_wakeup_gpios & gpio_bit))) {
 		if (cpu_is_omap44xx()) {
-			if (trigger != 0)
-				__raw_writel(1 << gpio, bank->base+
-						OMAP4_GPIO_IRQWAKEN0);
-			else {
-				val = __raw_readl(bank->base +
-							OMAP4_GPIO_IRQWAKEN0);
-				__raw_writel(val & (~(1 << gpio)), bank->base +
-							 OMAP4_GPIO_IRQWAKEN0);
-			}
+			MOD_REG_BIT(OMAP4_GPIO_IRQWAKEN0, gpio_bit,
+				trigger != 0);
 		} else {
 			/*
 			 * GPIO wakeup request can only be generated on edge
-- 
1.7.4.1

