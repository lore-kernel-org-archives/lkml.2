Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab1FDTEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 15:04:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1FDTEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 15:04:21 -0400
From: Colin Cross <ccross@android.com>
To: linux-omap@vger.kernel.org
Cc: Colin Cross <ccross@android.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: omap4: gpio: fix setting IRQWAKEN bits
Date: Sat,  4 Jun 2011 12:03:59 -0700
Message-Id: <1307214239-16316-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the IRQWAKEN bit was overwriting previous IRQWAKEN bits,
causing only the last bit set to take effect, resulting in lost
wakeups when the GPIO controller is in idle.

Replace direct writes to IRQWAKEN with writes to SETWKUENA and
CLEARWKUEN.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/plat-omap/gpio.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index c985652..23ac7b6 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -539,7 +539,6 @@ static inline void set_24xx_gpio_triggering(struct gpio_bank *bank, int gpio,
 {
 	void __iomem *base = bank->base;
 	u32 gpio_bit = 1 << gpio;
-	u32 val;
 
 	if (cpu_is_omap44xx()) {
 		MOD_REG_BIT(OMAP4_GPIO_LEVELDETECT0, gpio_bit,
@@ -563,14 +562,11 @@ static inline void set_24xx_gpio_triggering(struct gpio_bank *bank, int gpio,
 	if (likely(!(bank->non_wakeup_gpios & gpio_bit))) {
 		if (cpu_is_omap44xx()) {
 			if (trigger != 0)
-				__raw_writel(1 << gpio, bank->base+
-						OMAP4_GPIO_IRQWAKEN0);
-			else {
-				val = __raw_readl(bank->base +
-							OMAP4_GPIO_IRQWAKEN0);
-				__raw_writel(val & (~(1 << gpio)), bank->base +
-							 OMAP4_GPIO_IRQWAKEN0);
-			}
+				__raw_writel(gpio_bit,
+					bank->base + OMAP4_GPIO_SETWKUENA);
+			else
+				__raw_writel(gpio_bit,
+					bank->base + OMAP4_GPIO_CLEARWKUENA);
 		} else {
 			/*
 			 * GPIO wakeup request can only be generated on edge
-- 
1.7.4.1

