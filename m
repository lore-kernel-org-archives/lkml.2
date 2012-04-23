Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2DWJQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:16:49 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:35455 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938Ab2DWJOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:14:32 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/9] gpio/nomadik: don't set SLPM to 1 for non-wakeup pins
Date: Mon, 23 Apr 2012 11:14:08 +0200
Message-ID: <1335172448-27506-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Setting GPIOs' SLPM value to 1 (WAKEUP_DISABLE) is seen to cause
increased power consumption in sleep/deep-sleep. So remove the code
which disables SLPM based on the wakeup settings and only ensure
it is on as needed.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-nomadik.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
index 839624f..f1ebd05 100644
--- a/drivers/gpio/gpio-nomadik.c
+++ b/drivers/gpio/gpio-nomadik.c
@@ -58,7 +58,6 @@ struct nmk_gpio_chip {
 	u32 real_wake;
 	u32 rwimsc;
 	u32 fwimsc;
-	u32 slpm;
 	u32 pull_up;
 };
 
@@ -583,10 +582,14 @@ static void __nmk_gpio_irq_modify(struct nmk_gpio_chip *nmk_chip,
 static void __nmk_gpio_set_wake(struct nmk_gpio_chip *nmk_chip,
 				int gpio, bool on)
 {
-	if (nmk_chip->sleepmode) {
+	/*
+	 * Ensure WAKEUP_ENABLE is on.  No need to disable it if wakeup is
+	 * disabled, since setting SLPM to 1 increases power consumption, and
+	 * wakeup is anyhow controlled by the RIMSC and FIMSC registers.
+	 */
+	if (nmk_chip->sleepmode && on) {
 		__nmk_gpio_set_slpm(nmk_chip, gpio - nmk_chip->chip.base,
-				    on ? NMK_GPIO_SLPM_WAKEUP_ENABLE
-				    : NMK_GPIO_SLPM_WAKEUP_DISABLE);
+				    NMK_GPIO_SLPM_WAKEUP_ENABLE);
 	}
 
 	__nmk_gpio_irq_modify(nmk_chip, gpio, WAKE, on);
@@ -1016,13 +1019,6 @@ void nmk_gpio_wakeups_suspend(void)
 		writel(chip->fwimsc & chip->real_wake,
 		       chip->addr + NMK_GPIO_FWIMSC);
 
-		if (chip->sleepmode) {
-			chip->slpm = readl(chip->addr + NMK_GPIO_SLPC);
-
-			/* 0 -> wakeup enable */
-			writel(~chip->real_wake, chip->addr + NMK_GPIO_SLPC);
-		}
-
 		clk_disable(chip->clk);
 	}
 }
@@ -1042,9 +1038,6 @@ void nmk_gpio_wakeups_resume(void)
 		writel(chip->rwimsc, chip->addr + NMK_GPIO_RWIMSC);
 		writel(chip->fwimsc, chip->addr + NMK_GPIO_FWIMSC);
 
-		if (chip->sleepmode)
-			writel(chip->slpm, chip->addr + NMK_GPIO_SLPC);
-
 		clk_disable(chip->clk);
 	}
 }
-- 
1.7.9.2

