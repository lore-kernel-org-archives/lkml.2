Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab2KHL4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:56:06 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:52823 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401Ab2KHL4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:56:00 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <arm@kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] pinctrl/nomadik: make independent of prcmu driver
Date: Thu, 8 Nov 2012 12:55:42 +0100
Message-ID: <1352375742-29611-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Currently there are some unnecessary criss-cross
dependencies between the PRCMU driver in MFD and a lot of
other drivers, mainly because other drivers need to poke
around in the PRCM register range.

In cases like this there are actually just a few select
registers that the pinctrl driver need to read/modify/write,
and it turns out that no other driver is actually using
these registers, so there are no concurrency issues
whatsoever.

So: don't let the location of the register range complicate
things, just poke into these registers directly and skip
a layer of indirection.

Cc: Loic Pallardy <loic.pallardy@st.com>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik-db8500.c  |  4 +--
 drivers/pinctrl/pinctrl-nomadik-db8540.c  |  4 +--
 drivers/pinctrl/pinctrl-nomadik-stn8815.c |  4 +--
 drivers/pinctrl/pinctrl-nomadik.c         | 52 ++++++++++++++++++-------------
 drivers/pinctrl/pinctrl-nomadik.h         | 14 +++++----
 5 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/pinctrl-nomadik-db8500.c
index 6de52e7..e73d75e 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8500.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8500.c
@@ -1230,7 +1230,7 @@ static const u16 db8500_prcm_gpiocr_regs[] = {
 	[PRCM_IDX_GPIOCR2] = 0x574,
 };
 
-static const struct nmk_pinctrl_soc_data nmk_db8500_soc = {
+static struct nmk_pinctrl_soc_data nmk_db8500_soc = {
 	.gpio_ranges = nmk_db8500_ranges,
 	.gpio_num_ranges = ARRAY_SIZE(nmk_db8500_ranges),
 	.pins = nmk_db8500_pins,
@@ -1245,7 +1245,7 @@ static const struct nmk_pinctrl_soc_data nmk_db8500_soc = {
 };
 
 void __devinit
-nmk_pinctrl_db8500_init(const struct nmk_pinctrl_soc_data **soc)
+nmk_pinctrl_db8500_init(struct nmk_pinctrl_soc_data **soc)
 {
 	*soc = &nmk_db8500_soc;
 }
diff --git a/drivers/pinctrl/pinctrl-nomadik-db8540.c b/drivers/pinctrl/pinctrl-nomadik-db8540.c
index 52fc301..1276ba3 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8540.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8540.c
@@ -1240,7 +1240,7 @@ static const u16 db8540_prcm_gpiocr_regs[] = {
 	[PRCM_IDX_GPIOCR3] = 0x2bc,
 };
 
-static const struct nmk_pinctrl_soc_data nmk_db8540_soc = {
+static struct nmk_pinctrl_soc_data nmk_db8540_soc = {
 	.gpio_ranges = nmk_db8540_ranges,
 	.gpio_num_ranges = ARRAY_SIZE(nmk_db8540_ranges),
 	.pins = nmk_db8540_pins,
@@ -1255,7 +1255,7 @@ static const struct nmk_pinctrl_soc_data nmk_db8540_soc = {
 };
 
 void __devinit
-nmk_pinctrl_db8540_init(const struct nmk_pinctrl_soc_data **soc)
+nmk_pinctrl_db8540_init(struct nmk_pinctrl_soc_data **soc)
 {
 	*soc = &nmk_db8540_soc;
 }
diff --git a/drivers/pinctrl/pinctrl-nomadik-stn8815.c b/drivers/pinctrl/pinctrl-nomadik-stn8815.c
index 7d432c3..ed5b144 100644
--- a/drivers/pinctrl/pinctrl-nomadik-stn8815.c
+++ b/drivers/pinctrl/pinctrl-nomadik-stn8815.c
@@ -339,7 +339,7 @@ static const struct nmk_function nmk_stn8815_functions[] = {
 	FUNCTION(i2cusb),
 };
 
-static const struct nmk_pinctrl_soc_data nmk_stn8815_soc = {
+static struct nmk_pinctrl_soc_data nmk_stn8815_soc = {
 	.gpio_ranges = nmk_stn8815_ranges,
 	.gpio_num_ranges = ARRAY_SIZE(nmk_stn8815_ranges),
 	.pins = nmk_stn8815_pins,
@@ -351,7 +351,7 @@ static const struct nmk_pinctrl_soc_data nmk_stn8815_soc = {
 };
 
 void __devinit
-nmk_pinctrl_stn8815_init(const struct nmk_pinctrl_soc_data **soc)
+nmk_pinctrl_stn8815_init(struct nmk_pinctrl_soc_data **soc)
 {
 	*soc = &nmk_stn8815_soc;
 }
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 22f6937..33c614e 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -30,20 +30,6 @@
 #include <linux/pinctrl/pinconf.h>
 /* Since we request GPIOs from ourself */
 #include <linux/pinctrl/consumer.h>
-/*
- * For the U8500 archs, use the PRCMU register interface, for the older
- * Nomadik, provide some stubs. The functions using these will only be
- * called on the U8500 series.
- */
-#ifdef CONFIG_ARCH_U8500
-#include <linux/mfd/dbx500-prcmu.h>
-#else
-static inline u32 prcmu_read(unsigned int reg) {
-	return 0;
-}
-static inline void prcmu_write(unsigned int reg, u32 value) {}
-static inline void prcmu_write_masked(unsigned int reg, u32 mask, u32 value) {}
-#endif
 #include <linux/platform_data/pinctrl-nomadik.h>
 
 #include <asm/mach/irq.h>
@@ -85,7 +71,7 @@ struct nmk_gpio_chip {
 struct nmk_pinctrl {
 	struct device *dev;
 	struct pinctrl_dev *pctl;
-	const struct nmk_pinctrl_soc_data *soc;
+	struct nmk_pinctrl_soc_data *soc;
 };
 
 static struct nmk_gpio_chip *
@@ -247,6 +233,15 @@ nmk_gpio_disable_lazy_irq(struct nmk_gpio_chip *nmk_chip, unsigned offset)
 	dev_dbg(nmk_chip->chip.dev, "%d: clearing interrupt mask\n", gpio);
 }
 
+static void nmk_write_masked(void __iomem *reg, u32 mask, u32 value)
+{
+	u32 val;
+
+	val = readl(reg);
+	val = ((val & ~mask) | (value & mask));
+	writel(val, reg);
+}
+
 static void nmk_prcm_altcx_set_mode(struct nmk_pinctrl *npct,
 	unsigned offset, unsigned alt_num)
 {
@@ -285,8 +280,8 @@ static void nmk_prcm_altcx_set_mode(struct nmk_pinctrl *npct,
 			if (pin_desc->altcx[i].used == true) {
 				reg = gpiocr_regs[pin_desc->altcx[i].reg_index];
 				bit = pin_desc->altcx[i].control_bit;
-				if (prcmu_read(reg) & BIT(bit)) {
-					prcmu_write_masked(reg, BIT(bit), 0);
+				if (readl(npct->soc->prcmu_base + reg) & BIT(bit)) {
+					nmk_write_masked(npct->soc->prcmu_base + reg, BIT(bit), 0);
 					dev_dbg(npct->dev,
 						"PRCM GPIOCR: pin %i: alternate-C%i has been disabled\n",
 						offset, i+1);
@@ -314,8 +309,8 @@ static void nmk_prcm_altcx_set_mode(struct nmk_pinctrl *npct,
 		if (pin_desc->altcx[i].used == true) {
 			reg = gpiocr_regs[pin_desc->altcx[i].reg_index];
 			bit = pin_desc->altcx[i].control_bit;
-			if (prcmu_read(reg) & BIT(bit)) {
-				prcmu_write_masked(reg, BIT(bit), 0);
+			if (readl(npct->soc->prcmu_base + reg) & BIT(bit)) {
+				nmk_write_masked(npct->soc->prcmu_base + reg, BIT(bit), 0);
 				dev_dbg(npct->dev,
 					"PRCM GPIOCR: pin %i: alternate-C%i has been disabled\n",
 					offset, i+1);
@@ -327,7 +322,7 @@ static void nmk_prcm_altcx_set_mode(struct nmk_pinctrl *npct,
 	bit = pin_desc->altcx[alt_index].control_bit;
 	dev_dbg(npct->dev, "PRCM GPIOCR: pin %i: alternate-C%i has been selected\n",
 		offset, alt_index+1);
-	prcmu_write_masked(reg, BIT(bit), BIT(bit));
+	nmk_write_masked(npct->soc->prcmu_base + reg, BIT(bit), BIT(bit));
 }
 
 static void __nmk_config_pin(struct nmk_gpio_chip *nmk_chip, unsigned offset,
@@ -693,7 +688,7 @@ static int nmk_prcm_gpiocr_get_mode(struct pinctrl_dev *pctldev, int gpio)
 		if (pin_desc->altcx[i].used == true) {
 			reg = gpiocr_regs[pin_desc->altcx[i].reg_index];
 			bit = pin_desc->altcx[i].control_bit;
-			if (prcmu_read(reg) & BIT(bit))
+			if (readl(npct->soc->prcmu_base + reg) & BIT(bit))
 				return NMK_GPIO_ALT_C+i+1;
 		}
 	}
@@ -1851,6 +1846,7 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
 	const struct platform_device_id *platid = platform_get_device_id(pdev);
 	struct device_node *np = pdev->dev.of_node;
 	struct nmk_pinctrl *npct;
+	struct resource *res;
 	unsigned int version = 0;
 	int i;
 
@@ -1872,6 +1868,20 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
 	if (version == PINCTRL_NMK_DB8540)
 		nmk_pinctrl_db8540_init(&npct->soc);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res) {
+		npct->soc->prcmu_base = devm_ioremap(&pdev->dev, res->start,
+						     resource_size(res));
+		if (!npct->soc->prcmu_base) {
+			dev_err(&pdev->dev,
+				"failed to ioremap prcmu registers\n");
+			return -ENOMEM;
+		}
+	} else {
+		dev_info(&pdev->dev,
+			 "No PRCMU base, assume no ALT-Cx control is available\n");
+	}
+
 	/*
 	 * We need all the GPIO drivers to probe FIRST, or we will not be able
 	 * to obtain references to the struct gpio_chip * for them, and we
diff --git a/drivers/pinctrl/pinctrl-nomadik.h b/drivers/pinctrl/pinctrl-nomadik.h
index bcd4191..9dd727a 100644
--- a/drivers/pinctrl/pinctrl-nomadik.h
+++ b/drivers/pinctrl/pinctrl-nomadik.h
@@ -125,6 +125,7 @@ struct nmk_pingroup {
  * @altcx_pins:	The pins that support Other alternate-C function on this SoC
  * @npins_altcx: The number of Other alternate-C pins
  * @prcm_gpiocr_registers: The array of PRCM GPIOCR registers on this SoC
+ * @prcmu_base: PRCMU virtual base
  */
 struct nmk_pinctrl_soc_data {
 	struct pinctrl_gpio_range *gpio_ranges;
@@ -138,16 +139,17 @@ struct nmk_pinctrl_soc_data {
 	const struct prcm_gpiocr_altcx_pin_desc *altcx_pins;
 	unsigned npins_altcx;
 	const u16 *prcm_gpiocr_registers;
+	void __iomem *prcmu_base;
 };
 
 #ifdef CONFIG_PINCTRL_STN8815
 
-void nmk_pinctrl_stn8815_init(const struct nmk_pinctrl_soc_data **soc);
+void nmk_pinctrl_stn8815_init(struct nmk_pinctrl_soc_data **soc);
 
 #else
 
 static inline void
-nmk_pinctrl_stn8815_init(const struct nmk_pinctrl_soc_data **soc)
+nmk_pinctrl_stn8815_init(struct nmk_pinctrl_soc_data **soc)
 {
 }
 
@@ -155,12 +157,12 @@ nmk_pinctrl_stn8815_init(const struct nmk_pinctrl_soc_data **soc)
 
 #ifdef CONFIG_PINCTRL_DB8500
 
-void nmk_pinctrl_db8500_init(const struct nmk_pinctrl_soc_data **soc);
+void nmk_pinctrl_db8500_init(struct nmk_pinctrl_soc_data **soc);
 
 #else
 
 static inline void
-nmk_pinctrl_db8500_init(const struct nmk_pinctrl_soc_data **soc)
+nmk_pinctrl_db8500_init(struct nmk_pinctrl_soc_data **soc)
 {
 }
 
@@ -168,12 +170,12 @@ nmk_pinctrl_db8500_init(const struct nmk_pinctrl_soc_data **soc)
 
 #ifdef CONFIG_PINCTRL_DB8540
 
-void nmk_pinctrl_db8540_init(const struct nmk_pinctrl_soc_data **soc);
+void nmk_pinctrl_db8540_init(struct nmk_pinctrl_soc_data **soc);
 
 #else
 
 static inline void
-nmk_pinctrl_db8540_init(const struct nmk_pinctrl_soc_data **soc)
+nmk_pinctrl_db8540_init(struct nmk_pinctrl_soc_data **soc)
 {
 }
 
-- 
1.7.11.3

