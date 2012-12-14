Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab2LNQX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:23:27 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61800 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2LNQUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:05 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Naga Radhesh <naga.radheshy@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/21] gpio: ab8500: Add support for AB8505 Chip
Date: Fri, 14 Dec 2012 16:19:29 +0000
Message-Id: <1355501979-1157-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naga Radhesh <naga.radheshy@stericsson.com>

Number of gpio pins has been changed for AB8505, so
change gpio configurations according to AB8505.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Naga Radhesh <naga.radheshy@stericsson.com>
Reviewed-by: Bibek BASU <bibek.basu@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Reviewed-by: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |   41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index b78cf2f..8616368 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -77,6 +77,7 @@
 #define AB9540_ALTFUN_REG_INDEX	7
 #define AB8500_NUM_GPIO		42
 #define AB9540_NUM_GPIO		54
+#define AB8505_NUM_GPIO		53
 #define AB8500_NUM_VIR_GPIO_IRQ	16
 
 enum ab8500_gpio_action {
@@ -127,6 +128,24 @@ static struct ab8500_gpio_irq_cluster ab9540_irq_clusters[] = {
 	{.start = 49, .end = 53},
 };
 
+/*
+ * For AB8505 Only some GPIOs are interrupt capable, and they are
+ * organized in discontiguous clusters:
+ *
+ *	GPIO10 to GPIO11
+ *	GPIO13
+ *	GPIO40 and GPIO41
+ *	GPIO50
+ *	GPIO52 to GPIO53
+ */
+static struct ab8500_gpio_irq_cluster ab8505_irq_clusters[] = {
+	{.start = 9,  .end = 10}, /* GPIO numbers start from 1 */
+	{.start = 12, .end = 12},
+	{.start = 39, .end = 40},
+	{.start = 49, .end = 49},
+	{.start = 51, .end = 52},
+};
+
 /**
  * to_ab8500_gpio() - get the pointer to ab8500_gpio
  * @chip:	Member of the structure ab8500_gpio
@@ -435,6 +454,7 @@ static void ab8500_gpio_irq_remove(struct ab8500_gpio *ab8500_gpio)
 
 static int __devinit ab8500_gpio_probe(struct platform_device *pdev)
 {
+	struct ab8500 *parent = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_platform_data *ab8500_pdata =
 				dev_get_platdata(pdev->dev.parent);
 	struct ab8500_gpio_platform_data *pdata;
@@ -471,12 +491,21 @@ static int __devinit ab8500_gpio_probe(struct platform_device *pdev)
 		last_gpio_sel_reg = AB9540_GPIO_SEL7_REG;
 		altfun_reg_index = AB9540_ALTFUN_REG_INDEX;
 	} else {
-		ab8500_gpio->chip.ngpio = AB8500_NUM_GPIO;
-		ab8500_gpio->irq_cluster = ab8500_irq_clusters;
-		ab8500_gpio->irq_cluster_size =
-			ARRAY_SIZE(ab8500_irq_clusters);
-		last_gpio_sel_reg = AB8500_GPIO_SEL6_REG;
-		altfun_reg_index = AB8500_ALTFUN_REG_INDEX;
+		if (is_ab8505(parent)) {
+			ab8500_gpio->chip.ngpio = AB8505_NUM_GPIO;
+			ab8500_gpio->irq_cluster = ab8505_irq_clusters;
+			ab8500_gpio->irq_cluster_size =
+				ARRAY_SIZE(ab8505_irq_clusters);
+			last_gpio_sel_reg = AB9540_GPIO_SEL7_REG;
+			altfun_reg_index = AB9540_ALTFUN_REG_INDEX;
+		} else {
+			ab8500_gpio->chip.ngpio = AB8500_NUM_GPIO;
+			ab8500_gpio->irq_cluster = ab8500_irq_clusters;
+			ab8500_gpio->irq_cluster_size =
+				ARRAY_SIZE(ab8500_irq_clusters);
+			last_gpio_sel_reg = AB8500_GPIO_SEL6_REG;
+			altfun_reg_index = AB8500_ALTFUN_REG_INDEX;
+		}
 	}
 
 	/* initialize the lock */
-- 
1.7.9.5

