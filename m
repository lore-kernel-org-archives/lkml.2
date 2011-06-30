Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1F3Kmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 06:42:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58390 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1F3KmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 06:42:01 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/3] pwm: Add a i.MX23/28 pwm driver
Date: Thu, 30 Jun 2011 12:41:57 +0200
Message-Id: <1309430517-23821-4-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de>
References: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/pwm/Kconfig   |    6 +-
 drivers/pwm/Makefile  |    1 +
 drivers/pwm/mxs-pwm.c |  312 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 318 insertions(+), 1 deletions(-)
 create mode 100644 drivers/pwm/mxs-pwm.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 93c1052..5694574 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -2,11 +2,15 @@ menuconfig PWM
 	bool "PWM Support"
 	help
 	  This enables PWM support through the generic PWM framework.
-	  You only need to enable this, if you also want to enable
+	  You only need to enable this if you also want to enable
 	  one or more of the PWM drivers below.
 
 	  If unsure, say N.
 
 if PWM
 
+config PWM_MXS
+	tristate "MXS pwm support"
+	depends on ARCH_MXS
+
 endif
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 3469c3d..2cadd50 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_PWM)		+= core.o
+obj-$(CONFIG_PWM_MXS)		+= mxs-pwm.o
diff --git a/drivers/pwm/mxs-pwm.c b/drivers/pwm/mxs-pwm.c
new file mode 100644
index 0000000..150ab32
--- /dev/null
+++ b/drivers/pwm/mxs-pwm.c
@@ -0,0 +1,312 @@
+/*
+ * Copyright (C) 2011 Pengutronix
+ * Sascha Hauer <s.hauer@pengutronix.de>
+ *
+ * simple driver for PWM (Pulse Width Modulator) controller
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Derived from pxa PWM driver by eric miao <eric.miao@marvell.com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/pwm.h>
+#include <mach/hardware.h>
+#include <asm/div64.h>
+
+enum mxs_pwm_devtype {
+	MXS_PWM_CORE,
+	MXS_PWM,
+};
+
+struct mxs_pwm_device {
+	struct device	*dev;
+
+	struct clk	*clk;
+
+	int		enabled;
+	void __iomem	*mmio_base;
+	void __iomem	*enable_base;
+
+	unsigned int	pwm_id;
+
+	u32		val_active;
+	u32		val_period;
+	int		period_us;
+	struct pwm_chip chip;
+};
+
+/* common register space */
+#define REG_PWM_CTRL		0x0
+#define REG_PWM_CTRL_SET	0x4
+#define REG_PWM_CTRL_CLEAR	0x8
+#define PWM_SFTRST	(1 << 31)
+#define PWM_CLKGATE	(1 << 30)
+#define PWM_ENABLE(p)	(1 << (p))
+
+/* per pwm register space */
+#define REG_ACTIVE	0x0
+#define REG_PERIOD	0x10
+
+#define PERIOD_PERIOD(p)	((p) & 0xffff)
+#define PERIOD_ACTIVE_HIGH	(3 << 16)
+#define PERIOD_INACTIVE_LOW	(2 << 18)
+#define PERIOD_CDIV(div)	(((div) & 0x7) << 20)
+
+static void pwm_update(struct mxs_pwm_device *pwm)
+{
+	writel(pwm->val_active, pwm->mmio_base + REG_ACTIVE);
+	writel(pwm->val_period, pwm->mmio_base + REG_PERIOD);
+}
+
+#define to_mxs_pwm_device(chip)	container_of(chip, struct mxs_pwm_device, chip)
+
+static int mxs_pwm_config(struct pwm_chip *chip, int duty_ns, int period_ns)
+{
+	struct mxs_pwm_device *pwm = to_mxs_pwm_device(chip);
+	int div = 0;
+	unsigned long rate;
+	unsigned long long c;
+	unsigned long period_cycles, duty_cycles;
+
+	rate = clk_get_rate(pwm->clk);
+
+	dev_dbg(pwm->dev, "config: duty_ns: %d, period_ns: %d (clkrate %ld)\n",
+			duty_ns, period_ns, rate);
+
+	while (1) {
+		c = rate / (1 << div);
+		c = c * period_ns;
+		do_div(c, 1000000000);
+		if (c < 0x10000)
+			break;
+		div++;
+
+		if (div > 8)
+			return -EINVAL;
+	}
+
+	period_cycles = c;
+	duty_cycles = period_cycles * duty_ns / period_ns;
+
+	dev_dbg(pwm->dev, "config period_cycles: %ld duty_cycles: %ld\n",
+			period_cycles, duty_cycles);
+
+	pwm->val_active = period_cycles << 16 | duty_cycles;
+	pwm->val_period = PERIOD_PERIOD(period_cycles) | PERIOD_ACTIVE_HIGH |
+			PERIOD_INACTIVE_LOW | PERIOD_CDIV(div);
+	pwm->period_us = period_ns / 1000;
+
+	pwm_update(pwm);
+
+	return 0;
+}
+
+static void __pwm_enable(struct mxs_pwm_device *pwm, int enable)
+{
+	void __iomem *reg;
+
+	if (enable)
+		reg = pwm->enable_base + REG_PWM_CTRL_SET;
+	else
+		reg = pwm->enable_base + REG_PWM_CTRL_CLEAR;
+
+	writel(PWM_ENABLE(pwm->chip.pwm_id), reg);
+}
+
+static int mxs_pwm_enable(struct pwm_chip *chip)
+{
+	struct mxs_pwm_device *pwm = to_mxs_pwm_device(chip);
+	int ret = 0;
+
+	dev_dbg(pwm->dev, "enable\n");
+
+	if (!pwm->enabled) {
+		ret = clk_enable(pwm->clk);
+		if (!ret) {
+			pwm->enabled = 1;
+			__pwm_enable(pwm, 1);
+			pwm_update(pwm);
+		}
+	}
+	return ret;
+}
+
+static void mxs_pwm_disable(struct pwm_chip *chip)
+{
+	struct mxs_pwm_device *pwm = to_mxs_pwm_device(chip);
+
+	dev_dbg(pwm->dev, "disable\n");
+
+	if (pwm->enabled) {
+		/*
+		 * We need a little delay here, it takes one period for
+		 * the last pwm_config call to take effect. If we disable
+		 * the pwm too early it just freezes the current output
+		 * state.
+		 */
+		usleep_range(pwm->period_us, pwm->period_us * 2);
+		__pwm_enable(pwm, 0);
+		clk_disable(pwm->clk);
+		pwm->enabled = 0;
+	}
+}
+
+static struct pwm_ops mxs_pwm_ops = {
+	.enable = mxs_pwm_enable,
+	.disable = mxs_pwm_disable,
+	.config = mxs_pwm_config,
+	.owner = THIS_MODULE,
+};
+
+static int mxs_pwm_core_probe(struct platform_device *pdev,
+		struct mxs_pwm_device *pwm)
+{
+	struct resource *r;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -ENODEV;
+
+	r = devm_request_mem_region(&pdev->dev, r->start, 0xf, pdev->name);
+	if (!r)
+		return -EBUSY;
+
+	pwm->mmio_base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
+	if (!pwm->mmio_base) {
+		dev_err(&pdev->dev, "failed to ioremap() registers\n");
+		return -ENOMEM;
+	}
+
+	writel(PWM_SFTRST | PWM_CLKGATE, pwm->mmio_base + REG_PWM_CTRL_CLEAR);
+
+	return 0;
+}
+
+static int mxs_pwm_device_probe(struct platform_device *pdev,
+		struct mxs_pwm_device *pwm)
+{
+	struct mxs_pwm_device *parent_pwm;
+	struct resource *r;
+	int ret;
+
+	pwm->chip.ops = &mxs_pwm_ops;
+	pwm->chip.pwm_id = pdev->id;
+
+	parent_pwm = dev_get_drvdata(pdev->dev.parent);
+	if (!parent_pwm) {
+		dev_err(&pdev->dev, "no parent driver data\n");
+		return -EINVAL;
+	}
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -ENODEV;
+
+	r = devm_request_mem_region(&pdev->dev, r->start, resource_size(r),
+			pdev->name);
+	if (!r)
+		return -EBUSY;
+
+	pwm->enable_base = parent_pwm->mmio_base;
+	pwm->mmio_base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
+
+	pwm->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(pwm->clk))
+		return PTR_ERR(pwm->clk);
+
+	ret = pwmchip_add(&pwm->chip);
+	if (ret) {
+		clk_put(pwm->clk);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __devinit mxs_pwm_probe(struct platform_device *pdev)
+{
+	struct mxs_pwm_device *pwm;
+
+	pwm = devm_kzalloc(&pdev->dev, sizeof(struct mxs_pwm_device), GFP_KERNEL);
+	if (!pwm) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	pwm->dev = &pdev->dev;
+
+	platform_set_drvdata(pdev, pwm);
+
+	if (pdev->id_entry->driver_data == MXS_PWM_CORE)
+		return mxs_pwm_core_probe(pdev, pwm);
+	else
+		return mxs_pwm_device_probe(pdev, pwm);
+
+	return 0;
+}
+
+static int __devexit mxs_pwm_remove(struct platform_device *pdev)
+{
+	struct mxs_pwm_device *pwm = platform_get_drvdata(pdev);
+	int ret;
+
+	switch (pdev->id_entry->driver_data) {
+	case MXS_PWM_CORE:
+		writel(PWM_CLKGATE, pwm->mmio_base + REG_PWM_CTRL_SET);
+		return 0;
+	case MXS_PWM:
+		ret = pwmchip_remove(&pwm->chip);
+		if (ret)
+			return ret;
+
+		clk_put(pwm->clk);
+	}
+
+	return 0;
+}
+
+static struct platform_device_id mxs_pwm_devtype[] = {
+	{
+		.name = "mxs-pwm-core",
+		.driver_data = MXS_PWM_CORE,
+	}, {
+		.name = "mxs-pwm",
+		.driver_data = MXS_PWM,
+	}, {
+		/* sentinel */
+	}
+};
+
+static struct platform_driver mxs_pwm_driver = {
+	.driver		= {
+		.name	= "mxs-pwm",
+	},
+	.id_table	= mxs_pwm_devtype,
+	.probe		= mxs_pwm_probe,
+	.remove		= __devexit_p(mxs_pwm_remove),
+};
+
+static int __init mxs_pwm_init(void)
+{
+	return platform_driver_register(&mxs_pwm_driver);
+}
+arch_initcall(mxs_pwm_init);
+
+static void __exit mxs_pwm_exit(void)
+{
+	platform_driver_unregister(&mxs_pwm_driver);
+}
+module_exit(mxs_pwm_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
-- 
1.7.5.3

