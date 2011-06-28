Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab1F1KE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:04:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41654 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab1F1KC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:02:57 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/2] pwm: Add a i.MX23/28 pwm driver
Date: Tue, 28 Jun 2011 12:02:48 +0200
Message-Id: <1309255368-9775-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1309255368-9775-1-git-send-email-s.hauer@pengutronix.de>
References: <1309255368-9775-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/pwm/mxs-pwm.c |  275 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 275 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pwm/mxs-pwm.c

diff --git a/drivers/pwm/mxs-pwm.c b/drivers/pwm/mxs-pwm.c
new file mode 100644
index 0000000..052cb0c
--- /dev/null
+++ b/drivers/pwm/mxs-pwm.c
@@ -0,0 +1,275 @@
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
+#include <mach/mxs.h>
+#include <mach/mx23.h>
+#include <mach/mx28.h>
+#include <asm/div64.h>
+
+struct mxs_pwm_device {
+	struct device		*dev;
+
+	struct clk	*clk;
+
+	int		enabled;
+	void __iomem	*mmio_base;
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
+static void __iomem *pwm_base_common;
+#define REG_PWM_CTRL	0x0
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
+	if (enable)
+		__mxs_setl(PWM_ENABLE(pwm->chip.pwm_id), pwm_base_common + REG_PWM_CTRL);
+	else
+		__mxs_clrl(PWM_ENABLE(pwm->chip.pwm_id), pwm_base_common + REG_PWM_CTRL);
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
+};
+
+static int __devinit mxs_pwm_probe(struct platform_device *pdev)
+{
+	struct mxs_pwm_device *pwm;
+	struct resource *r;
+	int ret = 0;
+
+	pwm = devm_kzalloc(&pdev->dev, sizeof(struct mxs_pwm_device), GFP_KERNEL);
+	if (pwm == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	pwm->clk = clk_get(&pdev->dev, NULL);
+
+	if (IS_ERR(pwm->clk)) {
+		ret = PTR_ERR(pwm->clk);
+		goto err_free;
+	}
+
+	pwm->chip.ops = &mxs_pwm_ops;
+
+	pwm->enabled = 0;
+
+	pwm->chip.pwm_id = pdev->id;
+	pwm->chip.owner = THIS_MODULE;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (r == NULL) {
+		dev_err(&pdev->dev, "no memory resource defined\n");
+		ret = -ENODEV;
+		goto err_free_clk;
+	}
+
+	r = request_mem_region(r->start, resource_size(r), pdev->name);
+	if (r == NULL) {
+		dev_err(&pdev->dev, "failed to request memory resource\n");
+		ret = -EBUSY;
+		goto err_free_clk;
+	}
+
+	pwm->mmio_base = ioremap(r->start, resource_size(r));
+	if (pwm->mmio_base == NULL) {
+		dev_err(&pdev->dev, "failed to ioremap() registers\n");
+		ret = -ENODEV;
+		goto err_free_mem;
+	}
+
+	ret = pwmchip_add(&pwm->chip);
+	if (ret)
+		goto err_free_mem;
+
+	platform_set_drvdata(pdev, pwm);
+	return 0;
+
+err_free_mem:
+	release_mem_region(r->start, resource_size(r));
+err_free_clk:
+	clk_put(pwm->clk);
+err_free:
+	kfree(pwm);
+	return ret;
+}
+
+static int __devexit mxs_pwm_remove(struct platform_device *pdev)
+{
+	struct mxs_pwm_device *pwm;
+	struct resource *r;
+	int ret;
+
+	pwm = platform_get_drvdata(pdev);
+
+	ret = pwmchip_remove(&pwm->chip);
+	if (ret)
+		return ret;
+
+	iounmap(pwm->mmio_base);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(r->start, resource_size(r));
+
+	clk_put(pwm->clk);
+
+	return 0;
+}
+
+static struct platform_driver mxs_pwm_driver = {
+	.driver		= {
+		.name	= "mxs-pwm",
+	},
+	.probe		= mxs_pwm_probe,
+	.remove		= __devexit_p(mxs_pwm_remove),
+};
+
+static int __init mxs_pwm_init(void)
+{
+	if (cpu_is_mx28())
+		pwm_base_common = MX28_IO_ADDRESS(MX28_PWM_BASE_ADDR);
+	else
+		pwm_base_common = MX23_IO_ADDRESS(MX23_PWM_BASE_ADDR);
+
+	__mxs_clrl(PWM_SFTRST | PWM_CLKGATE, pwm_base_common + REG_PWM_CTRL);
+
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

