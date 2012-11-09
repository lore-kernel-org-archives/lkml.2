Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab2KIK3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 05:29:07 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:47684 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069Ab2KIK3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 05:29:03 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2] pinctrl/nomadik: make independent of prcmu driver
Date: Fri, 9 Nov 2012 11:28:35 +0100
Message-ID: <1352456915-28738-1-git-send-email-linus.walleij@stericsson.com>
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

Take this opportunity to add kerneldoc to the pinctrl
state container.

Cc: Loic Pallardy <loic.pallardy@st.com>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Have the pointer in the pin controller state container
  instead of as part of SoC data.
---
 drivers/pinctrl/pinctrl-nomadik.c | 59 ++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 22f6937..6a95d04 100644
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
@@ -82,10 +68,18 @@ struct nmk_gpio_chip {
 	u32 lowemi;
 };
 
+/**
+ * struct nmk_pinctrl - state container for the Nomadik pin controller
+ * @dev: containing device pointer
+ * @pctl: corresponding pin controller device
+ * @soc: SoC data for this specific chip
+ * @prcm_base: PRCM register range virtual base
+ */
 struct nmk_pinctrl {
 	struct device *dev;
 	struct pinctrl_dev *pctl;
 	const struct nmk_pinctrl_soc_data *soc;
+	void __iomem *prcm_base;
 };
 
 static struct nmk_gpio_chip *
@@ -247,6 +241,15 @@ nmk_gpio_disable_lazy_irq(struct nmk_gpio_chip *nmk_chip, unsigned offset)
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
@@ -285,8 +288,8 @@ static void nmk_prcm_altcx_set_mode(struct nmk_pinctrl *npct,
 			if (pin_desc->altcx[i].used == true) {
 				reg = gpiocr_regs[pin_desc->altcx[i].reg_index];
 				bit = pin_desc->altcx[i].control_bit;
-				if (prcmu_read(reg) & BIT(bit)) {
-					prcmu_write_masked(reg, BIT(bit), 0);
+				if (readl(npct->prcm_base + reg) & BIT(bit)) {
+					nmk_write_masked(npct->prcm_base + reg, BIT(bit), 0);
 					dev_dbg(npct->dev,
 						"PRCM GPIOCR: pin %i: alternate-C%i has been disabled\n",
 						offset, i+1);
@@ -314,8 +317,8 @@ static void nmk_prcm_altcx_set_mode(struct nmk_pinctrl *npct,
 		if (pin_desc->altcx[i].used == true) {
 			reg = gpiocr_regs[pin_desc->altcx[i].reg_index];
 			bit = pin_desc->altcx[i].control_bit;
-			if (prcmu_read(reg) & BIT(bit)) {
-				prcmu_write_masked(reg, BIT(bit), 0);
+			if (readl(npct->prcm_base + reg) & BIT(bit)) {
+				nmk_write_masked(npct->prcm_base + reg, BIT(bit), 0);
 				dev_dbg(npct->dev,
 					"PRCM GPIOCR: pin %i: alternate-C%i has been disabled\n",
 					offset, i+1);
@@ -327,7 +330,7 @@ static void nmk_prcm_altcx_set_mode(struct nmk_pinctrl *npct,
 	bit = pin_desc->altcx[alt_index].control_bit;
 	dev_dbg(npct->dev, "PRCM GPIOCR: pin %i: alternate-C%i has been selected\n",
 		offset, alt_index+1);
-	prcmu_write_masked(reg, BIT(bit), BIT(bit));
+	nmk_write_masked(npct->prcm_base + reg, BIT(bit), BIT(bit));
 }
 
 static void __nmk_config_pin(struct nmk_gpio_chip *nmk_chip, unsigned offset,
@@ -693,7 +696,7 @@ static int nmk_prcm_gpiocr_get_mode(struct pinctrl_dev *pctldev, int gpio)
 		if (pin_desc->altcx[i].used == true) {
 			reg = gpiocr_regs[pin_desc->altcx[i].reg_index];
 			bit = pin_desc->altcx[i].control_bit;
-			if (prcmu_read(reg) & BIT(bit))
+			if (readl(npct->prcm_base + reg) & BIT(bit))
 				return NMK_GPIO_ALT_C+i+1;
 		}
 	}
@@ -1851,6 +1854,7 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
 	const struct platform_device_id *platid = platform_get_device_id(pdev);
 	struct device_node *np = pdev->dev.of_node;
 	struct nmk_pinctrl *npct;
+	struct resource *res;
 	unsigned int version = 0;
 	int i;
 
@@ -1872,6 +1876,20 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
 	if (version == PINCTRL_NMK_DB8540)
 		nmk_pinctrl_db8540_init(&npct->soc);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res) {
+		npct->prcm_base = devm_ioremap(&pdev->dev, res->start,
+					       resource_size(res));
+		if (!npct->prcm_base) {
+			dev_err(&pdev->dev,
+				"failed to ioremap PRCM registers\n");
+			return -ENOMEM;
+		}
+	} else {
+		dev_info(&pdev->dev,
+			 "No PRCM base, assume no ALT-Cx control is available\n");
+	}
+
 	/*
 	 * We need all the GPIO drivers to probe FIRST, or we will not be able
 	 * to obtain references to the struct gpio_chip * for them, and we
@@ -1888,6 +1906,7 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
 	nmk_pinctrl_desc.pins = npct->soc->pins;
 	nmk_pinctrl_desc.npins = npct->soc->npins;
 	npct->dev = &pdev->dev;
+
 	npct->pctl = pinctrl_register(&nmk_pinctrl_desc, &pdev->dev, npct);
 	if (!npct->pctl) {
 		dev_err(&pdev->dev, "could not register Nomadik pinctrl driver\n");
-- 
1.7.11.3

