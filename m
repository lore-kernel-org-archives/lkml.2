Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab2JVDwD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 23:52:03 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:41139 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083Ab2JVDwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 23:52:01 -0400
From: Shiraz Hashim <shiraz.hashim@st.com>
To: <thierry.reding@avionic-design.de>
Cc: <linux-kernel@vger.kernel.org>, <spear-devel@list.st.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3] PWM: Add SPEAr PWM chip driver support
Date: Mon, 22 Oct 2012 09:21:43 +0530
Message-ID: <1350877903-8578-1-git-send-email-shiraz.hashim@st.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for PWM chips present on SPEAr platforms. These PWM
chips support 4 channel output with programmable duty cycle and
frequency.

More details on these PWM chips can be obtained from relevant
chapter of reference manual, present at following[1] location.

1. http://www.st.com/internet/mcu/product/251211.jsp

Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Shiraz Hashim <shiraz.hashim@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Vipin Kumar <vipin.kumar@st.com>
---
Changes:-
V2 --> V3:
   * remove "disabled" line from pwm dt binding documentation
   * remove un-necessary check on pwm chip (for NULL) in remove.
  
V1 --> V2:
   * make proper reference to pwm and pwm chip
   * take care to capitalize PWM at appropriate places
   * fix compatible string to the SoC where pwm chip was introduced
   * Rename the documentation file to the name of driver
   * Fix cosmetic changes like names, function name alignment, paragraph
     formating, comments placement and formating, etc.
   * Group and associate the bit field definitions to their registers
   * Fix kerneldoc for structure definition
   * Use chip to name pwm device and pwm for the channel instance
   * Remove init section qualifiers
   * Remove ifdefs around device tree from code and add dependency on CONFIG_OF
   * prepare/unprepare clock once in probe/remove and just enable/disable
     at rest of the places.
   * Use _relaxed for readl/writel.
   * Fix pwm disable part in remove
 
 .../devicetree/bindings/pwm/spear-pwm.txt          |   18 ++
 drivers/pwm/Kconfig                                |   11 +
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-spear.c                            |  280 ++++++++++++++++++++
 4 files changed, 310 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/spear-pwm.txt
 create mode 100644 drivers/pwm/pwm-spear.c

diff --git a/Documentation/devicetree/bindings/pwm/spear-pwm.txt b/Documentation/devicetree/bindings/pwm/spear-pwm.txt
new file mode 100644
index 0000000..3ac779d
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/spear-pwm.txt
@@ -0,0 +1,18 @@
+== ST SPEAr SoC PWM controller ==
+
+Required properties:
+- compatible: should be one of:
+  - "st,spear320-pwm"
+  - "st,spear1340-pwm"
+- reg: physical base address and length of the controller's registers
+- #pwm-cells: number of cells used to specify PWM which is fixed to 2 on
+  SPEAr. The first cell specifies the per-chip index of the PWM to use and
+  the second cell is the period in nanoseconds.
+
+Example:
+
+        pwm: pwm@a8000000 {
+            compatible ="st,spear320-pwm";
+            reg = <0xa8000000 0x1000>;
+            #pwm-cells = <2>;
+        };
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index ed81720..6e556c7 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -112,6 +112,17 @@ config PWM_SAMSUNG
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-samsung.
 
+config PWM_SPEAR
+	tristate "STMicroelectronics SPEAr PWM support"
+	depends on PLAT_SPEAR
+	depends on OF
+	help
+	  Generic PWM framework driver for the PWM controller on ST
+	  SPEAr SoCs.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-spear.
+
 config PWM_TEGRA
 	tristate "NVIDIA Tegra PWM support"
 	depends on ARCH_TEGRA
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index acfe482..6512786 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_PWM_PUV3)		+= pwm-puv3.o
 obj-$(CONFIG_PWM_PXA)		+= pwm-pxa.o
 obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
 obj-$(CONFIG_PWM_TEGRA)		+= pwm-tegra.o
+obj-$(CONFIG_PWM_SPEAR)		+= pwm-spear.o
 obj-$(CONFIG_PWM_TIECAP)	+= pwm-tiecap.o
 obj-$(CONFIG_PWM_TIEHRPWM)	+= pwm-tiehrpwm.o
 obj-$(CONFIG_PWM_TWL6030)	+= pwm-twl6030.o
diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
new file mode 100644
index 0000000..bb63508
--- /dev/null
+++ b/drivers/pwm/pwm-spear.c
@@ -0,0 +1,280 @@
+/*
+ * ST Microelectronics SPEAr Pulse Width Modulator driver
+ *
+ * Copyright (C) 2012 ST Microelectronics
+ * Shiraz Hashim <shiraz.hashim@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/math64.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#define NUM_PWM		4
+
+/* PWM registers and bits definitions */
+#define PWMCR			0x00	/* Control Register */
+#define PWMCR_PWM_ENABLE	0x1
+#define PWMCR_PRESCALE_SHIFT	2
+#define PWMCR_MIN_PRESCALE	0x00
+#define PWMCR_MAX_PRESCALE	0x3FFF
+
+#define PWMDCR			0x04	/* Duty Cycle Register */
+#define PWMDCR_MIN_DUTY		0x0001
+#define PWMDCR_MAX_DUTY		0xFFFF
+
+#define PWMPCR			0x08	/* Period Register */
+#define PWMPCR_MIN_PERIOD	0x0001
+#define PWMPCR_MAX_PERIOD	0xFFFF
+
+/* Following only available on 13xx SoCs */
+#define PWMMCR			0x3C	/* Master Control Register */
+#define PWMMCR_PWM_ENABLE	0x1
+
+/**
+ * struct spear_pwm_chip - struct representing pwm chip
+ *
+ * @mmio_base: base address of pwm chip
+ * @clk: pointer to clk structure of pwm chip
+ * @chip: linux pwm chip representation
+ * @dev: pointer to device structure of pwm chip
+ */
+struct spear_pwm_chip {
+	void __iomem *mmio_base;
+	struct clk *clk;
+	struct pwm_chip	chip;
+	struct device *dev;
+};
+
+static inline struct spear_pwm_chip *to_spear_pwm_chip(struct pwm_chip *chip)
+{
+	return container_of(chip, struct spear_pwm_chip, chip);
+}
+
+static inline u32 spear_pwm_readl(struct spear_pwm_chip *chip, unsigned int num,
+				  unsigned long offset)
+{
+	return readl_relaxed(chip->mmio_base + (num << 4) + offset);
+}
+
+static inline void spear_pwm_writel(struct spear_pwm_chip *chip,
+				    unsigned int num, unsigned long offset,
+				    unsigned long val)
+{
+	writel_relaxed(val, chip->mmio_base + (num << 4) + offset);
+}
+
+int spear_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm, int duty_ns,
+		     int period_ns)
+{
+	struct spear_pwm_chip *pc = to_spear_pwm_chip(chip);
+	u64 val, div, clk_rate;
+	unsigned long prescale = PWMCR_MIN_PRESCALE, pv, dc;
+	int ret;
+
+	/*
+	 * Find pv, dc and prescale to suit duty_ns and period_ns. This is done
+	 * according to formulas described below:
+	 *
+	 * period_ns = 10^9 * (PRESCALE + 1) * PV / PWM_CLK_RATE
+	 * duty_ns = 10^9 * (PRESCALE + 1) * DC / PWM_CLK_RATE
+	 *
+	 * PV = (PWM_CLK_RATE * period_ns) / (10^9 * (PRESCALE + 1))
+	 * DC = (PWM_CLK_RATE * duty_ns) / (10^9 * (PRESCALE + 1))
+	 */
+	clk_rate = clk_get_rate(pc->clk);
+	while (1) {
+		div = 1000000000;
+		div *= 1 + prescale;
+		val = clk_rate * period_ns;
+		pv = div64_u64(val, div);
+		val = clk_rate * duty_ns;
+		dc = div64_u64(val, div);
+
+		/* if duty_ns and period_ns are not achievable then return */
+		if (pv < PWMPCR_MIN_PERIOD || dc < PWMDCR_MIN_DUTY)
+			return -EINVAL;
+
+		/*
+		 * if pv and dc have crossed their upper limit, then increase
+		 * prescale and recalculate pv and dc.
+		 */
+		if (pv > PWMPCR_MAX_PERIOD || dc > PWMDCR_MAX_DUTY) {
+			if (++prescale > PWMCR_MAX_PRESCALE)
+				return -EINVAL;
+			continue;
+		}
+		break;
+	}
+
+	/*
+	 * NOTE: the clock to PWM has to be enabled first before writing to the
+	 * registers.
+	 */
+	ret = clk_enable(pc->clk);
+	if (ret)
+		return ret;
+
+	spear_pwm_writel(pc, pwm->hwpwm, PWMCR,
+			prescale << PWMCR_PRESCALE_SHIFT);
+	spear_pwm_writel(pc, pwm->hwpwm, PWMDCR, dc);
+	spear_pwm_writel(pc, pwm->hwpwm, PWMPCR, pv);
+	clk_disable(pc->clk);
+
+	return 0;
+}
+
+static int spear_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct spear_pwm_chip *pc = to_spear_pwm_chip(chip);
+	int rc = 0;
+	u32 val;
+
+	rc = clk_enable(pc->clk);
+	if (rc < 0)
+		return rc;
+
+	val = spear_pwm_readl(pc, pwm->hwpwm, PWMCR);
+	val |= PWMCR_PWM_ENABLE;
+	spear_pwm_writel(pc, pwm->hwpwm, PWMCR, val);
+
+	return 0;
+}
+
+static void spear_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct spear_pwm_chip *pc = to_spear_pwm_chip(chip);
+	u32 val;
+
+	val = spear_pwm_readl(pc, pwm->hwpwm, PWMCR);
+	val &= ~PWMCR_PWM_ENABLE;
+	spear_pwm_writel(pc, pwm->hwpwm, PWMCR, val);
+
+	clk_disable(pc->clk);
+}
+
+static const struct pwm_ops spear_pwm_ops = {
+	.config = spear_pwm_config,
+	.enable = spear_pwm_enable,
+	.disable = spear_pwm_disable,
+	.owner = THIS_MODULE,
+};
+
+static int spear_pwm_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct spear_pwm_chip *pc;
+	struct resource *r;
+	int ret;
+	u32 val;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "no memory resources defined\n");
+		return -ENODEV;
+	}
+
+	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
+	if (!pc) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	pc->dev = &pdev->dev;
+
+	pc->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
+	if (!pc->mmio_base)
+		return -EADDRNOTAVAIL;
+
+	platform_set_drvdata(pdev, pc);
+
+	pc->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(pc->clk))
+		return PTR_ERR(pc->clk);
+
+	pc->chip.dev = &pdev->dev;
+	pc->chip.ops = &spear_pwm_ops;
+	pc->chip.base = -1;
+	pc->chip.npwm = NUM_PWM;
+
+	ret = pwmchip_add(&pc->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(pc->clk);
+	if (ret < 0)
+		return pwmchip_remove(&pc->chip);
+
+	if (np && of_device_is_compatible(np, "st,spear1340-pwm")) {
+		/*
+		 * Following enables PWM chip, channels would still be
+		 * enabled individually through their control register
+		 */
+		val = readl_relaxed(pc->mmio_base + PWMMCR);
+		val |= PWMMCR_PWM_ENABLE;
+		writel_relaxed(val, pc->mmio_base + PWMMCR);
+
+	}
+
+	/* only disable the clk and leave it prepared */
+	clk_disable(pc->clk);
+
+	return 0;
+}
+
+static int spear_pwm_remove(struct platform_device *pdev)
+{
+	struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < NUM_PWM; i++) {
+		struct pwm_device *pwm = &pc->chip.pwms[i];
+
+		if (test_bit(PWMF_ENABLED, &pwm->flags)) {
+			spear_pwm_writel(pc, i, PWMCR, 0);
+			clk_disable(pc->clk);
+		}
+	}
+
+	/* clk was prepared in probe, hence unprepare it here */
+	clk_unprepare(pc->clk);
+	return pwmchip_remove(&pc->chip);
+}
+
+static struct of_device_id spear_pwm_of_match[] = {
+	{ .compatible = "st,spear320-pwm" },
+	{ .compatible = "st,spear1340-pwm" },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(of, spear_pwm_of_match);
+
+static struct platform_driver spear_pwm_driver = {
+	.driver = {
+		.name = "spear-pwm",
+		.of_match_table = spear_pwm_of_match,
+	},
+	.probe = spear_pwm_probe,
+	.remove = spear_pwm_remove,
+};
+
+module_platform_driver(spear_pwm_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Shiraz Hashim <shiraz.hashim@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.kumar@linaro.com>");
+MODULE_ALIAS("platform:spear-pwm");
-- 
1.7.10

