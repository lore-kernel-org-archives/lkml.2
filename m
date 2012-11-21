Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab2KUC1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:27:03 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab2KUC1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:27:00 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 18/42] sh-pfc: Support pinmux info in driver data instead of platform data
Date: Wed, 21 Nov 2012 03:27:19 +0100
Message-Id: <1353464863-10281-19-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pinmux information should be provided by the pinmux driver, not arch
code. Make it possible to do so by supporting pinmux information passed
through the driver_data field in the platform ID table. Platform data
will remain supported until all arch code has been converted.

Rename the sh_pfc_platform_data structure to sh_pfc_soc_info to reflect
this.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/pinctrl/sh-pfc/core.c    |   52 +++++++++++++++++++------------------
 drivers/pinctrl/sh-pfc/core.h    |    2 +-
 drivers/pinctrl/sh-pfc/gpio.c    |   18 ++++++------
 drivers/pinctrl/sh-pfc/pinctrl.c |   28 ++++++++++----------
 include/linux/sh_pfc.h           |    4 +-
 5 files changed, 53 insertions(+), 51 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/core.c b/drivers/pinctrl/sh-pfc/core.c
index 68b40d8..e863334 100644
--- a/drivers/pinctrl/sh-pfc/core.c
+++ b/drivers/pinctrl/sh-pfc/core.c
@@ -232,8 +232,8 @@ static void write_config_reg(struct sh_pfc *pfc,
 	data &= mask;
 	data |= value;
 
-	if (pfc->pdata->unlock_reg)
-		gpio_write_raw_reg(pfc_phys_to_virt(pfc, pfc->pdata->unlock_reg),
+	if (pfc->info->unlock_reg)
+		gpio_write_raw_reg(pfc_phys_to_virt(pfc, pfc->info->unlock_reg),
 				   32, ~data);
 
 	gpio_write_raw_reg(mapped_reg, crp->reg_width, data);
@@ -241,16 +241,16 @@ static void write_config_reg(struct sh_pfc *pfc,
 
 static int setup_data_reg(struct sh_pfc *pfc, unsigned gpio)
 {
-	struct pinmux_gpio *gpiop = &pfc->pdata->gpios[gpio];
+	struct pinmux_gpio *gpiop = &pfc->info->gpios[gpio];
 	struct pinmux_data_reg *data_reg;
 	int k, n;
 
-	if (!enum_in_range(gpiop->enum_id, &pfc->pdata->data))
+	if (!enum_in_range(gpiop->enum_id, &pfc->info->data))
 		return -1;
 
 	k = 0;
 	while (1) {
-		data_reg = pfc->pdata->data_regs + k;
+		data_reg = pfc->info->data_regs + k;
 
 		if (!data_reg->reg_width)
 			break;
@@ -279,12 +279,12 @@ static void setup_data_regs(struct sh_pfc *pfc)
 	struct pinmux_data_reg *drp;
 	int k;
 
-	for (k = pfc->pdata->first_gpio; k <= pfc->pdata->last_gpio; k++)
+	for (k = pfc->info->first_gpio; k <= pfc->info->last_gpio; k++)
 		setup_data_reg(pfc, k);
 
 	k = 0;
 	while (1) {
-		drp = pfc->pdata->data_regs + k;
+		drp = pfc->info->data_regs + k;
 
 		if (!drp->reg_width)
 			break;
@@ -298,15 +298,15 @@ static void setup_data_regs(struct sh_pfc *pfc)
 int sh_pfc_get_data_reg(struct sh_pfc *pfc, unsigned gpio,
 			struct pinmux_data_reg **drp, int *bitp)
 {
-	struct pinmux_gpio *gpiop = &pfc->pdata->gpios[gpio];
+	struct pinmux_gpio *gpiop = &pfc->info->gpios[gpio];
 	int k, n;
 
-	if (!enum_in_range(gpiop->enum_id, &pfc->pdata->data))
+	if (!enum_in_range(gpiop->enum_id, &pfc->info->data))
 		return -1;
 
 	k = (gpiop->flags & PINMUX_FLAG_DREG) >> PINMUX_FLAG_DREG_SHIFT;
 	n = (gpiop->flags & PINMUX_FLAG_DBIT) >> PINMUX_FLAG_DBIT_SHIFT;
-	*drp = pfc->pdata->data_regs + k;
+	*drp = pfc->info->data_regs + k;
 	*bitp = n;
 	return 0;
 }
@@ -322,7 +322,7 @@ static int get_config_reg(struct sh_pfc *pfc, pinmux_enum_t enum_id,
 
 	k = 0;
 	while (1) {
-		config_reg = pfc->pdata->cfg_regs + k;
+		config_reg = pfc->info->cfg_regs + k;
 
 		r_width = config_reg->reg_width;
 		f_width = config_reg->field_width;
@@ -360,12 +360,12 @@ static int get_config_reg(struct sh_pfc *pfc, pinmux_enum_t enum_id,
 int sh_pfc_gpio_to_enum(struct sh_pfc *pfc, unsigned gpio, int pos,
 			pinmux_enum_t *enum_idp)
 {
-	pinmux_enum_t enum_id = pfc->pdata->gpios[gpio].enum_id;
-	pinmux_enum_t *data = pfc->pdata->gpio_data;
+	pinmux_enum_t enum_id = pfc->info->gpios[gpio].enum_id;
+	pinmux_enum_t *data = pfc->info->gpio_data;
 	int k;
 
-	if (!enum_in_range(enum_id, &pfc->pdata->data)) {
-		if (!enum_in_range(enum_id, &pfc->pdata->mark)) {
+	if (!enum_in_range(enum_id, &pfc->info->data)) {
+		if (!enum_in_range(enum_id, &pfc->info->mark)) {
 			pr_err("non data/mark enum_id for gpio %d\n", gpio);
 			return -1;
 		}
@@ -376,7 +376,7 @@ int sh_pfc_gpio_to_enum(struct sh_pfc *pfc, unsigned gpio, int pos,
 		return pos + 1;
 	}
 
-	for (k = 0; k < pfc->pdata->gpio_data_size; k++) {
+	for (k = 0; k < pfc->info->gpio_data_size; k++) {
 		if (data[k] == enum_id) {
 			*enum_idp = data[k + 1];
 			return k + 1;
@@ -403,19 +403,19 @@ int sh_pfc_config_gpio(struct sh_pfc *pfc, unsigned gpio, int pinmux_type,
 		break;
 
 	case PINMUX_TYPE_OUTPUT:
-		range = &pfc->pdata->output;
+		range = &pfc->info->output;
 		break;
 
 	case PINMUX_TYPE_INPUT:
-		range = &pfc->pdata->input;
+		range = &pfc->info->input;
 		break;
 
 	case PINMUX_TYPE_INPUT_PULLUP:
-		range = &pfc->pdata->input_pu;
+		range = &pfc->info->input_pu;
 		break;
 
 	case PINMUX_TYPE_INPUT_PULLDOWN:
-		range = &pfc->pdata->input_pd;
+		range = &pfc->info->input_pd;
 		break;
 
 	default:
@@ -435,7 +435,7 @@ int sh_pfc_config_gpio(struct sh_pfc *pfc, unsigned gpio, int pinmux_type,
 			break;
 
 		/* first check if this is a function enum */
-		in_range = enum_in_range(enum_id, &pfc->pdata->function);
+		in_range = enum_in_range(enum_id, &pfc->info->function);
 		if (!in_range) {
 			/* not a function enum */
 			if (range) {
@@ -501,7 +501,7 @@ int sh_pfc_config_gpio(struct sh_pfc *pfc, unsigned gpio, int pinmux_type,
 
 static int sh_pfc_probe(struct platform_device *pdev)
 {
-	struct sh_pfc_platform_data *pdata = pdev->dev.platform_data;
+	struct sh_pfc_soc_info *info;
 	struct sh_pfc *pfc;
 	int ret;
 
@@ -510,14 +510,16 @@ static int sh_pfc_probe(struct platform_device *pdev)
 	 */
 	BUILD_BUG_ON(PINMUX_FLAG_TYPE > ((1 << PINMUX_FLAG_DBIT_SHIFT) - 1));
 
-	if (pdata == NULL)
+	info = pdev->id_entry->driver_data
+	      ? (void *)pdev->id_entry->driver_data : pdev->dev.platform_data;
+	if (info == NULL)
 		return -ENODEV;
 
 	pfc = devm_kzalloc(&pdev->dev, sizeof(pfc), GFP_KERNEL);
 	if (pfc == NULL)
 		return -ENOMEM;
 
-	pfc->pdata = pdata;
+	pfc->info = info;
 	pfc->dev = &pdev->dev;
 
 	ret = pfc_ioremap(pfc, pdev);
@@ -553,7 +555,7 @@ static int sh_pfc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pfc);
 
-	pr_info("%s support registered\n", pdata->name);
+	pr_info("%s support registered\n", info->name);
 
 	return 0;
 
diff --git a/drivers/pinctrl/sh-pfc/core.h b/drivers/pinctrl/sh-pfc/core.h
index b71f559..9bcc5fe 100644
--- a/drivers/pinctrl/sh-pfc/core.h
+++ b/drivers/pinctrl/sh-pfc/core.h
@@ -25,7 +25,7 @@ struct sh_pfc_pinctrl;
 
 struct sh_pfc {
 	struct device *dev;
-	struct sh_pfc_platform_data *pdata;
+	struct sh_pfc_soc_info *info;
 	spinlock_t lock;
 
 	unsigned int num_windows;
diff --git a/drivers/pinctrl/sh-pfc/gpio.c b/drivers/pinctrl/sh-pfc/gpio.c
index 9f4f0fd..2a68c12 100644
--- a/drivers/pinctrl/sh-pfc/gpio.c
+++ b/drivers/pinctrl/sh-pfc/gpio.c
@@ -105,11 +105,11 @@ static int sh_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 		if (pos <= 0 || !enum_id)
 			break;
 
-		for (i = 0; i < pfc->pdata->gpio_irq_size; i++) {
-			enum_ids = pfc->pdata->gpio_irq[i].enum_ids;
+		for (i = 0; i < pfc->info->gpio_irq_size; i++) {
+			enum_ids = pfc->info->gpio_irq[i].enum_ids;
 			for (k = 0; enum_ids[k]; k++) {
 				if (enum_ids[k] == enum_id)
-					return pfc->pdata->gpio_irq[i].irq;
+					return pfc->info->gpio_irq[i].irq;
 			}
 		}
 	}
@@ -130,12 +130,12 @@ static void sh_pfc_gpio_setup(struct sh_pfc_chip *chip)
 	gc->set = sh_gpio_set;
 	gc->to_irq = sh_gpio_to_irq;
 
-	WARN_ON(pfc->pdata->first_gpio != 0); /* needs testing */
+	WARN_ON(pfc->info->first_gpio != 0); /* needs testing */
 
-	gc->label = pfc->pdata->name;
+	gc->label = pfc->info->name;
 	gc->owner = THIS_MODULE;
-	gc->base = pfc->pdata->first_gpio;
-	gc->ngpio = (pfc->pdata->last_gpio - pfc->pdata->first_gpio) + 1;
+	gc->base = pfc->info->first_gpio;
+	gc->ngpio = (pfc->info->last_gpio - pfc->info->first_gpio) + 1;
 }
 
 int sh_pfc_register_gpiochip(struct sh_pfc *pfc)
@@ -160,8 +160,8 @@ int sh_pfc_register_gpiochip(struct sh_pfc *pfc)
 	pfc->gpio = chip;
 
 	pr_info("%s handling gpio %d -> %d\n",
-		pfc->pdata->name, pfc->pdata->first_gpio,
-		pfc->pdata->last_gpio);
+		pfc->info->name, pfc->info->first_gpio,
+		pfc->info->last_gpio);
 
 	return 0;
 }
diff --git a/drivers/pinctrl/sh-pfc/pinctrl.c b/drivers/pinctrl/sh-pfc/pinctrl.c
index c0c8271..7f3187a 100644
--- a/drivers/pinctrl/sh-pfc/pinctrl.c
+++ b/drivers/pinctrl/sh-pfc/pinctrl.c
@@ -139,7 +139,7 @@ static int sh_pfc_reconfig_pin(struct sh_pfc *pfc, unsigned offset,
 
 	spin_lock_irqsave(&pfc->lock, flags);
 
-	pinmux_type = pfc->pdata->gpios[offset].flags & PINMUX_FLAG_TYPE;
+	pinmux_type = pfc->info->gpios[offset].flags & PINMUX_FLAG_TYPE;
 
 	/*
 	 * See if the present config needs to first be de-configured.
@@ -171,8 +171,8 @@ static int sh_pfc_reconfig_pin(struct sh_pfc *pfc, unsigned offset,
 			       GPIO_CFG_REQ) != 0)
 		goto err;
 
-	pfc->pdata->gpios[offset].flags &= ~PINMUX_FLAG_TYPE;
-	pfc->pdata->gpios[offset].flags |= new_type;
+	pfc->info->gpios[offset].flags &= ~PINMUX_FLAG_TYPE;
+	pfc->info->gpios[offset].flags |= new_type;
 
 	ret = 0;
 
@@ -194,7 +194,7 @@ static int sh_pfc_gpio_request_enable(struct pinctrl_dev *pctldev,
 
 	spin_lock_irqsave(&pfc->lock, flags);
 
-	pinmux_type = pfc->pdata->gpios[offset].flags & PINMUX_FLAG_TYPE;
+	pinmux_type = pfc->info->gpios[offset].flags & PINMUX_FLAG_TYPE;
 
 	switch (pinmux_type) {
 	case PINMUX_TYPE_FUNCTION:
@@ -235,7 +235,7 @@ static void sh_pfc_gpio_disable_free(struct pinctrl_dev *pctldev,
 
 	spin_lock_irqsave(&pfc->lock, flags);
 
-	pinmux_type = pfc->pdata->gpios[offset].flags & PINMUX_FLAG_TYPE;
+	pinmux_type = pfc->info->gpios[offset].flags & PINMUX_FLAG_TYPE;
 
 	sh_pfc_config_gpio(pfc, offset, pinmux_type, GPIO_CFG_FREE);
 
@@ -269,7 +269,7 @@ static int sh_pfc_pinconf_get(struct pinctrl_dev *pctldev, unsigned pin,
 	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
 	struct sh_pfc *pfc = pmx->pfc;
 
-	*config = pfc->pdata->gpios[pin].flags & PINMUX_FLAG_TYPE;
+	*config = pfc->info->gpios[pin].flags & PINMUX_FLAG_TYPE;
 
 	return 0;
 }
@@ -356,7 +356,7 @@ static int __devinit sh_pfc_map_gpios(struct sh_pfc *pfc,
 	unsigned long flags;
 	int i;
 
-	pmx->nr_pads = pfc->pdata->last_gpio - pfc->pdata->first_gpio + 1;
+	pmx->nr_pads = pfc->info->last_gpio - pfc->info->first_gpio + 1;
 
 	pmx->pads = kmalloc(sizeof(struct pinctrl_pin_desc) * pmx->nr_pads,
 			    GFP_KERNEL);
@@ -375,9 +375,9 @@ static int __devinit sh_pfc_map_gpios(struct sh_pfc *pfc,
 	 */
 	for (i = 0; i < pmx->nr_pads; i++) {
 		struct pinctrl_pin_desc *pin = pmx->pads + i;
-		struct pinmux_gpio *gpio = pfc->pdata->gpios + i;
+		struct pinmux_gpio *gpio = pfc->info->gpios + i;
 
-		pin->number = pfc->pdata->first_gpio + i;
+		pin->number = pfc->info->first_gpio + i;
 		pin->name = gpio->name;
 
 		/* XXX */
@@ -409,7 +409,7 @@ static int __devinit sh_pfc_map_functions(struct sh_pfc *pfc,
 	spin_lock_irqsave(&pmx->lock, flags);
 
 	for (i = fn = 0; i < pmx->nr_pads; i++) {
-		struct pinmux_gpio *gpio = pfc->pdata->gpios + i;
+		struct pinmux_gpio *gpio = pfc->info->gpios + i;
 
 		if ((gpio->flags & PINMUX_FLAG_TYPE) == PINMUX_TYPE_FUNCTION)
 			pmx->functions[fn++] = gpio;
@@ -448,10 +448,10 @@ int sh_pfc_register_pinctrl(struct sh_pfc *pfc)
 		goto free_functions;
 	}
 
-	sh_pfc_gpio_range.npins = pfc->pdata->last_gpio
-				- pfc->pdata->first_gpio + 1;
-	sh_pfc_gpio_range.base = pfc->pdata->first_gpio;
-	sh_pfc_gpio_range.pin_base = pfc->pdata->first_gpio;
+	sh_pfc_gpio_range.npins = pfc->info->last_gpio
+				- pfc->info->first_gpio + 1;
+	sh_pfc_gpio_range.base = pfc->info->first_gpio;
+	sh_pfc_gpio_range.pin_base = pfc->info->first_gpio;
 
 	pinctrl_add_gpio_range(pmx->pctl, &sh_pfc_gpio_range);
 
diff --git a/include/linux/sh_pfc.h b/include/linux/sh_pfc.h
index 4f94233..9fd6228 100644
--- a/include/linux/sh_pfc.h
+++ b/include/linux/sh_pfc.h
@@ -88,7 +88,7 @@ struct pinmux_range {
 	pinmux_enum_t force;
 };
 
-struct sh_pfc_platform_data {
+struct sh_pfc_soc_info {
 	char *name;
 	pinmux_enum_t reserved_id;
 	struct pinmux_range data;
@@ -115,7 +115,7 @@ struct sh_pfc_platform_data {
 };
 
 /* XXX compat for now */
-#define pinmux_info sh_pfc_platform_data
+#define pinmux_info sh_pfc_soc_info
 
 enum { GPIO_CFG_DRYRUN, GPIO_CFG_REQ, GPIO_CFG_FREE };
 
-- 
1.7.8.6

