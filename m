Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab1ETWGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:06:20 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:37432 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247Ab1ETWFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:05:52 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/4] gpio/nomadik: add function to read GPIO pull down status
Date: Sat, 21 May 2011 00:05:37 +0200
Message-ID: <1305929137-9149-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Andersson <rickard.andersson@stericsson.com>

Signed-off-by: Rickard Andersson <rickard.andersson@stericsson.com>
Reviewed-by: Martin Persson <martin.persson@stericsson.com>
[Split off from larger patch]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/plat-nomadik/include/plat/gpio.h |    2 +
 drivers/gpio/gpio-nomadik.c               |   34 +++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/gpio.h b/arch/arm/plat-nomadik/include/plat/gpio.h
index 1b9f6f0..ea19a5b 100644
--- a/arch/arm/plat-nomadik/include/plat/gpio.h
+++ b/arch/arm/plat-nomadik/include/plat/gpio.h
@@ -78,6 +78,8 @@ extern int nmk_gpio_get_mode(int gpio);
 extern void nmk_gpio_wakeups_suspend(void);
 extern void nmk_gpio_wakeups_resume(void);
 
+extern void nmk_gpio_read_pull(int gpio_bank, u32 *pull_up);
+
 /*
  * Platform data to register a block: only the initial gpio/irq number.
  */
diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
index e6d62b9..978d26c 100644
--- a/drivers/gpio/gpio-nomadik.c
+++ b/drivers/gpio/gpio-nomadik.c
@@ -55,6 +55,7 @@ struct nmk_gpio_chip {
 	u32 fwimsc;
 	u32 slpm;
 	u32 enabled;
+	u32 pull_up;
 };
 
 static struct nmk_gpio_chip *
@@ -101,16 +102,22 @@ static void __nmk_gpio_set_pull(struct nmk_gpio_chip *nmk_chip,
 	u32 pdis;
 
 	pdis = readl(nmk_chip->addr + NMK_GPIO_PDIS);
-	if (pull == NMK_GPIO_PULL_NONE)
+	if (pull == NMK_GPIO_PULL_NONE) {
 		pdis |= bit;
-	else
+		nmk_chip->pull_up &= ~bit;
+	} else {
 		pdis &= ~bit;
+	}
+
 	writel(pdis, nmk_chip->addr + NMK_GPIO_PDIS);
 
-	if (pull == NMK_GPIO_PULL_UP)
+	if (pull == NMK_GPIO_PULL_UP) {
+		nmk_chip->pull_up |= bit;
 		writel(bit, nmk_chip->addr + NMK_GPIO_DATS);
-	else if (pull == NMK_GPIO_PULL_DOWN)
+	} else if (pull == NMK_GPIO_PULL_DOWN) {
+		nmk_chip->pull_up &= ~bit;
 		writel(bit, nmk_chip->addr + NMK_GPIO_DATC);
+	}
 }
 
 static void __nmk_gpio_make_input(struct nmk_gpio_chip *nmk_chip,
@@ -925,6 +932,25 @@ void nmk_gpio_wakeups_resume(void)
 	}
 }
 
+/*
+ * Read the pull up/pull down status.
+ * A bit set in 'pull_up' means that pull up
+ * is selected if pull is enabled in PDIS register.
+ * Note: only pull up/down set via this driver can
+ * be detected due to HW limitations.
+ */
+void nmk_gpio_read_pull(int gpio_bank, u32 *pull_up)
+{
+	if (gpio_bank < NUM_BANKS) {
+		struct nmk_gpio_chip *chip = nmk_gpio_chips[gpio_bank];
+
+		if (!chip)
+			return;
+
+		*pull_up = chip->pull_up;
+	}
+}
+
 static int __devinit nmk_gpio_probe(struct platform_device *dev)
 {
 	struct nmk_gpio_platform_data *pdata = dev->dev.platform_data;
-- 
1.7.3.2

