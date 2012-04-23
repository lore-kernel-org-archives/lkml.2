Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2DWJOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:14:51 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:57517 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218Ab2DWJOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:14:48 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/9] gpio/nomadik: support low EMI mode
Date: Mon, 23 Apr 2012 11:14:35 +0200
Message-ID: <1335172475-27613-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Low EMI (Electro-Magnetic Interference) mode means lower slew
rate on the signals. The Nomadik GPIO controller supports
this so create an interface to enable it.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/plat-nomadik/include/plat/gpio-nomadik.h |    1 +
 arch/arm/plat-nomadik/include/plat/pincfg.h       |    6 +++++
 drivers/gpio/gpio-nomadik.c                       |   25 +++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h b/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
index 9605bf2..3e8b7f1 100644
--- a/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
+++ b/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
@@ -29,6 +29,7 @@
 #define NMK_GPIO_SLPC	0x1c
 #define NMK_GPIO_AFSLA	0x20
 #define NMK_GPIO_AFSLB	0x24
+#define NMK_GPIO_LOWEMI	0x28
 
 #define NMK_GPIO_RIMSC	0x40
 #define NMK_GPIO_FIMSC	0x44
diff --git a/arch/arm/plat-nomadik/include/plat/pincfg.h b/arch/arm/plat-nomadik/include/plat/pincfg.h
index 22cb97d..da6b1e3 100644
--- a/arch/arm/plat-nomadik/include/plat/pincfg.h
+++ b/arch/arm/plat-nomadik/include/plat/pincfg.h
@@ -105,6 +105,12 @@ typedef unsigned long pin_cfg_t;
 #define PIN_SLPM_VAL_LOW	((1 + 0) << PIN_SLPM_VAL_SHIFT)
 #define PIN_SLPM_VAL_HIGH	((1 + 1) << PIN_SLPM_VAL_SHIFT)
 
+#define PIN_LOWEMI_SHIFT	25
+#define PIN_LOWEMI_MASK		(0x1 << PIN_LOWEMI_SHIFT)
+#define PIN_LOWEMI(x)		(((x) & PIN_LOWEMI_MASK) >> PIN_LOWEMI_SHIFT)
+#define PIN_LOWEMI_DISABLED	(0 << PIN_LOWEMI_SHIFT)
+#define PIN_LOWEMI_ENABLED	(1 << PIN_LOWEMI_SHIFT)
+
 /* Shortcuts.  Use these instead of separate DIR, PULL, and VAL.  */
 #define PIN_INPUT_PULLDOWN	(PIN_DIR_INPUT | PIN_PULL_DOWN)
 #define PIN_INPUT_PULLUP	(PIN_DIR_INPUT | PIN_PULL_UP)
diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
index 681daee..7b45d88 100644
--- a/drivers/gpio/gpio-nomadik.c
+++ b/drivers/gpio/gpio-nomadik.c
@@ -61,6 +61,7 @@ struct nmk_gpio_chip {
 	u32 rimsc;
 	u32 fimsc;
 	u32 pull_up;
+	u32 lowemi;
 };
 
 static struct nmk_gpio_chip *
@@ -125,6 +126,24 @@ static void __nmk_gpio_set_pull(struct nmk_gpio_chip *nmk_chip,
 	}
 }
 
+static void __nmk_gpio_set_lowemi(struct nmk_gpio_chip *nmk_chip,
+				  unsigned offset, bool lowemi)
+{
+	u32 bit = BIT(offset);
+	bool enabled = nmk_chip->lowemi & bit;
+
+	if (lowemi == enabled)
+		return;
+
+	if (lowemi)
+		nmk_chip->lowemi |= bit;
+	else
+		nmk_chip->lowemi &= ~bit;
+
+	writel_relaxed(nmk_chip->lowemi,
+		       nmk_chip->addr + NMK_GPIO_LOWEMI);
+}
+
 static void __nmk_gpio_make_input(struct nmk_gpio_chip *nmk_chip,
 				  unsigned offset)
 {
@@ -269,6 +288,8 @@ static void __nmk_config_pin(struct nmk_gpio_chip *nmk_chip, unsigned offset,
 		__nmk_gpio_set_pull(nmk_chip, offset, pull);
 	}
 
+	__nmk_gpio_set_lowemi(nmk_chip, offset, PIN_LOWEMI(cfg));
+
 	/*
 	 * If the pin is switching to altfunc, and there was an interrupt
 	 * installed on it which has been lazy disabled, actually mask the
@@ -1181,6 +1202,10 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	chip->dev = &dev->dev;
 	chip->owner = THIS_MODULE;
 
+	clk_enable(nmk_chip->clk);
+	nmk_chip->lowemi = readl_relaxed(nmk_chip->addr + NMK_GPIO_LOWEMI);
+	clk_disable(nmk_chip->clk);
+
 	ret = gpiochip_add(&nmk_chip->chip);
 	if (ret)
 		goto out_free;
-- 
1.7.9.2

