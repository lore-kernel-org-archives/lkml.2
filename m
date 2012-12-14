Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2LNQXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:23:46 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44360 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab2LNQUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:03 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Michel JAOUEN <michel.jaouen@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Maxime Coquelin <maxime.coquelin@st-ericsson.com>,
        Alex MACRO <alex.macro@stericsson.com>
Subject: [PATCH 10/21] gpio: ab8500: Add support for the AB9540
Date: Fri, 14 Dec 2012 16:19:28 +0000
Message-Id: <1355501979-1157-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st-ericsson.com>
Signed-off-by: Alex MACRO <alex.macro@stericsson.com>
Signed-off-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Reviewed-by: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Reviewed-by: Bibek BASU <bibek.basu@stericsson.com>
---
 drivers/gpio/gpio-ab8500.c |   92 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 70 insertions(+), 22 deletions(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index 273f7ca..b78cf2f 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -23,6 +23,13 @@
 
 
 /*
+ * The AB9540 GPIO support is an extended version of the
+ * AB8500 GPIO support. The AB9540 supports an additional
+ * (7th) register so that more GPIO may be configured and
+ * used.
+ */
+
+/*
  * GPIO registers offset
  * Bank: 0x10
  */
@@ -32,6 +39,7 @@
 #define AB8500_GPIO_SEL4_REG	0x03
 #define AB8500_GPIO_SEL5_REG	0x04
 #define AB8500_GPIO_SEL6_REG	0x05
+#define AB9540_GPIO_SEL7_REG	0x06
 
 #define AB8500_GPIO_DIR1_REG	0x10
 #define AB8500_GPIO_DIR2_REG	0x11
@@ -39,6 +47,7 @@
 #define AB8500_GPIO_DIR4_REG	0x13
 #define AB8500_GPIO_DIR5_REG	0x14
 #define AB8500_GPIO_DIR6_REG	0x15
+#define AB9540_GPIO_DIR7_REG	0x16
 
 #define AB8500_GPIO_OUT1_REG	0x20
 #define AB8500_GPIO_OUT2_REG	0x21
@@ -46,6 +55,7 @@
 #define AB8500_GPIO_OUT4_REG	0x23
 #define AB8500_GPIO_OUT5_REG	0x24
 #define AB8500_GPIO_OUT6_REG	0x25
+#define AB9540_GPIO_OUT7_REG	0x26
 
 #define AB8500_GPIO_PUD1_REG	0x30
 #define AB8500_GPIO_PUD2_REG	0x31
@@ -53,6 +63,7 @@
 #define AB8500_GPIO_PUD4_REG	0x33
 #define AB8500_GPIO_PUD5_REG	0x34
 #define AB8500_GPIO_PUD6_REG	0x35
+#define AB9540_GPIO_PUD7_REG	0x36
 
 #define AB8500_GPIO_IN1_REG	0x40
 #define AB8500_GPIO_IN2_REG	0x41
@@ -60,9 +71,12 @@
 #define AB8500_GPIO_IN4_REG	0x43
 #define AB8500_GPIO_IN5_REG	0x44
 #define AB8500_GPIO_IN6_REG	0x45
+#define AB9540_GPIO_IN7_REG	0x46
 #define AB8500_GPIO_ALTFUN_REG	0x50
-#define ALTFUN_REG_INDEX	6
+#define AB8500_ALTFUN_REG_INDEX	6
+#define AB9540_ALTFUN_REG_INDEX	7
 #define AB8500_NUM_GPIO		42
+#define AB9540_NUM_GPIO		54
 #define AB8500_NUM_VIR_GPIO_IRQ	16
 
 enum ab8500_gpio_action {
@@ -73,6 +87,11 @@ enum ab8500_gpio_action {
 	UNMASK
 };
 
+struct ab8500_gpio_irq_cluster {
+	int start;
+	int end;
+};
+
 struct ab8500_gpio {
 	struct gpio_chip chip;
 	struct ab8500 *parent;
@@ -82,7 +101,32 @@ struct ab8500_gpio {
 	enum ab8500_gpio_action irq_action;
 	u16 rising;
 	u16 falling;
+	struct ab8500_gpio_irq_cluster *irq_cluster;
+	int irq_cluster_size;
+};
+
+/*
+ * Only some GPIOs are interrupt capable, and they are
+ * organized in discontiguous clusters:
+ *
+ *	GPIO6 to GPIO13
+ *	GPIO24 and GPIO25
+ *	GPIO36 to GPIO41
+ *	GPIO50 to GPIO54 (AB9540 only)
+ */
+static struct ab8500_gpio_irq_cluster ab8500_irq_clusters[] = {
+	{.start = 5,  .end = 12}, /* GPIO numbers start from 1 */
+	{.start = 23, .end = 24},
+	{.start = 35, .end = 40},
+};
+
+static struct ab8500_gpio_irq_cluster ab9540_irq_clusters[] = {
+	{.start = 5,  .end = 12}, /* GPIO numbers start from 1 */
+	{.start = 23, .end = 24},
+	{.start = 35, .end = 40},
+	{.start = 49, .end = 53},
 };
+
 /**
  * to_ab8500_gpio() - get the pointer to ab8500_gpio
  * @chip:	Member of the structure ab8500_gpio
@@ -162,28 +206,13 @@ static int ab8500_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 
 static int ab8500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	/*
-	 * Only some GPIOs are interrupt capable, and they are
-	 * organized in discontiguous clusters:
-	 *
-	 *	GPIO6 to GPIO13
-	 *	GPIO24 and GPIO25
-	 *	GPIO36 to GPIO41
-	 */
-	static struct ab8500_gpio_irq_cluster {
-		int start;
-		int end;
-	} clusters[] = {
-		{.start = 5,  .end = 12}, /* GPIO numbers start from 1 */
-		{.start = 23, .end = 24},
-		{.start = 35, .end = 40},
-	};
 	struct ab8500_gpio *ab8500_gpio = to_ab8500_gpio(chip);
 	int base = ab8500_gpio->irq_base;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(clusters); i++) {
-		struct ab8500_gpio_irq_cluster *cluster = &clusters[i];
+	for (i = 0; i < ab8500_gpio->irq_cluster_size; i++) {
+		struct ab8500_gpio_irq_cluster *cluster =
+			&ab8500_gpio->irq_cluster[i];
 
 		if (offset >= cluster->start && offset <= cluster->end)
 			return base + offset - cluster->start;
@@ -412,6 +441,8 @@ static int __devinit ab8500_gpio_probe(struct platform_device *pdev)
 	struct ab8500_gpio *ab8500_gpio;
 	int ret;
 	int i;
+	int last_gpio_sel_reg;
+	int altfun_reg_index;
 
 	pdata = ab8500_pdata->gpio;
 	if (!pdata)	{
@@ -427,10 +458,27 @@ static int __devinit ab8500_gpio_probe(struct platform_device *pdev)
 	ab8500_gpio->dev = &pdev->dev;
 	ab8500_gpio->parent = dev_get_drvdata(pdev->dev.parent);
 	ab8500_gpio->chip = ab8500gpio_chip;
-	ab8500_gpio->chip.ngpio = AB8500_NUM_GPIO;
 	ab8500_gpio->chip.dev = &pdev->dev;
 	ab8500_gpio->chip.base = pdata->gpio_base;
 	ab8500_gpio->irq_base = pdata->irq_base;
+
+	/* Configure GPIO Settings for specific AB devices */
+	if (cpu_is_u9540()) {
+		ab8500_gpio->chip.ngpio = AB9540_NUM_GPIO;
+		ab8500_gpio->irq_cluster = ab9540_irq_clusters;
+		ab8500_gpio->irq_cluster_size =
+			ARRAY_SIZE(ab9540_irq_clusters);
+		last_gpio_sel_reg = AB9540_GPIO_SEL7_REG;
+		altfun_reg_index = AB9540_ALTFUN_REG_INDEX;
+	} else {
+		ab8500_gpio->chip.ngpio = AB8500_NUM_GPIO;
+		ab8500_gpio->irq_cluster = ab8500_irq_clusters;
+		ab8500_gpio->irq_cluster_size =
+			ARRAY_SIZE(ab8500_irq_clusters);
+		last_gpio_sel_reg = AB8500_GPIO_SEL6_REG;
+		altfun_reg_index = AB8500_ALTFUN_REG_INDEX;
+	}
+
 	/* initialize the lock */
 	mutex_init(&ab8500_gpio->lock);
 	/*
@@ -439,7 +487,7 @@ static int __devinit ab8500_gpio_probe(struct platform_device *pdev)
 	 * These values are for selecting the PINs as
 	 * GPIO or alternate function
 	 */
-	for (i = AB8500_GPIO_SEL1_REG; i <= AB8500_GPIO_SEL6_REG; i++)	{
+	for (i = AB8500_GPIO_SEL1_REG; i <= last_gpio_sel_reg; i++) {
 		ret = abx500_set_register_interruptible(ab8500_gpio->dev,
 				AB8500_MISC, i,
 				pdata->config_reg[i]);
@@ -460,7 +508,7 @@ static int __devinit ab8500_gpio_probe(struct platform_device *pdev)
 	}
 	ret = abx500_set_register_interruptible(ab8500_gpio->dev, AB8500_MISC,
 				AB8500_GPIO_ALTFUN_REG,
-				pdata->config_reg[ALTFUN_REG_INDEX]);
+				pdata->config_reg[altfun_reg_index]);
 	if (ret < 0)
 		goto out_free;
 
-- 
1.7.9.5

