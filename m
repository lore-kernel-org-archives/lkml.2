Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424307Ab2LGUmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:42:14 -0500
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:57059 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1424123Ab2LGUmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:42:13 -0500
X-Greylist: delayed 12601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2012 15:42:12 EST
From: Boris BREZILLON <linux-arm@overkiz.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Boris BREZILLON <linux-arm@overkiz.com>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: [PATCH v2] pwm: atmel: add Timer Counter Block PWM driver
Date: Fri,  7 Dec 2012 16:54:20 +0100
Message-Id: <1354895660-9799-1-git-send-email-linux-arm@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 1240741699441439766
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehiedrtdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomhepuehorhhishcuueftgfgkkffnnffqpfcuoehlihhnuhigqdgrrhhmsehovhgvrhhkihiirdgtohhmqeenucfjughrpefhvffufffkofestddtredtredttd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehiedrudehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomhepuehorhhishcuueftgfgkkffnnffqpfcuoehlihhnuhigqdgrrhhmsehovhgvrhhkihiirdgtohhmqeenucfjughrpefhvffufffkofestddtredtredttd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch adds a PWM driver based on Atmel Timer Counter Block.
Timer Counter Block is used in Waveform generator mode.

A Timer Counter Block provides up to 6 PWM devices grouped by 2:
* group 0 = PWM 0 and 1
* group 1 = PWM 1 and 2
* group 2 = PMW 3 and 4

PWM devices in a given group must be configured with the same
period value.
If a PWM device in a group tries to change the period value and
the other device is already configured with a different value an
error will be returned.

This driver requires device tree support.
The Timer Counter Block number used to create a PWM chip is
given by tc-block field in an "atmel,pwm-tcb" compatible node.

Regards,

Boris

Changes since v1:
	- Fix device tree binding Documentation
	- Fix Kconfig issues (missing OF dependency, 
				deprecated HAVE_PWM select, ...)
	- Fix various coding style issues.
	- Cleanup code and add some comments.

Signed-off-by: Boris BREZILLON <linux-arm@overkiz.com>
---
 create mode 100644 Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
 create mode 100644 drivers/pwm/pwm-atmel-tcb.c

diff --git a/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
new file mode 100644
index 0000000..3f0f0f6
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
@@ -0,0 +1,15 @@
+Atmel TCB PWM controller
+
+Required properties:
+- compatible: should be "atmel,tcb-pwm"
+- #pwm-cells: should be 2.  The first cell specifies the per-chip index
+  of the PWM to use and the second cell is the period in nanoseconds.
+- tc-block: the Timer Counter block to use as a PWM chip.
+
+Example:
+
+pwm {
+	compatible = "atmel,tcb-pwm";
+	#pwm-cells = <2>;
+	tc-block = <1>;
+};
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index e513cd9..2f4941b 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -37,6 +37,18 @@ config PWM_AB8500
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-ab8500.
 
+config PWM_ATMEL_TCB
+	tristate "TC Block PWM"
+	depends on ATMEL_TCLIB && OF
+	help
+	  Generic PWM framework driver for Atmel Timer Counter Block.
+
+	  A Timer Counter Block provides 6 PWM devices grouped by 2.
+	  Devices in a given group must have the same period.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-atmel-tc.
+
 config PWM_BFIN
 	tristate "Blackfin PWM support"
 	depends on BFIN_GPTIMERS
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 62a2963..94ba21e 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_PWM)		+= core.o
 obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
+obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
 obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
 obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
new file mode 100644
index 0000000..5b24bdd
--- /dev/null
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -0,0 +1,433 @@
+/*
+ * Copyright (C) Overkiz SAS 2012
+ *
+ * Author: Boris BREZILLON <b.brezillon@overkiz.com>
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/atmel_tc.h>
+#include <linux/pwm.h>
+#include <linux/of_device.h>
+#include <linux/slab.h>
+
+#define NPWM	6
+
+struct atmel_tcb_pwm_device {
+	enum pwm_polarity polarity; /* PWM polarity */
+	unsigned clk; /* PWM clock divisor */
+	unsigned duty; /* PWM duty expressed in clk cycles */
+	unsigned period; /* PWM period expressed in clk cycles */
+};
+
+struct atmel_tcb_pwm_chip {
+	struct pwm_chip chip;
+	spinlock_t lock;
+	struct atmel_tc *tc;
+	struct atmel_tcb_pwm_device *pwms[NPWM];
+};
+
+static inline struct atmel_tcb_pwm_chip *to_tcb_chip(struct pwm_chip *chip)
+{
+	return container_of(chip, struct atmel_tcb_pwm_chip, chip);
+}
+
+static int atmel_tcb_pwm_set_polarity(struct pwm_chip *chip,
+					  struct pwm_device *pwm,
+					  enum pwm_polarity polarity)
+{
+	struct atmel_tcb_pwm_device *tcbpwm = pwm_get_chip_data(pwm);
+
+	tcbpwm->polarity = polarity;
+
+	return 0;
+}
+
+static int atmel_tcb_pwm_request(struct pwm_chip *chip,
+					  struct pwm_device *pwm)
+{
+	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
+	struct atmel_tcb_pwm_device *tcbpwm;
+	struct atmel_tc *tc = tcbpwmc->tc;
+	void __iomem *regs = tc->regs;
+	unsigned group = pwm->hwpwm / 2;
+	unsigned index = pwm->hwpwm % 2;
+	unsigned cmr;
+
+	tcbpwm = kzalloc(sizeof(*tcbpwm), GFP_KERNEL);
+	if (!tcbpwm)
+		return -ENOMEM;
+
+	pwm_set_chip_data(pwm, tcbpwm);
+	tcbpwm->polarity = PWM_POLARITY_NORMAL;
+	tcbpwm->duty = 0;
+	tcbpwm->period = 0;
+	tcbpwm->clk = 0;
+
+	spin_lock(&tcbpwmc->lock);
+	cmr = __raw_readl(regs + ATMEL_TC_REG(group, CMR));
+	/*
+	 * Get init config from Timer Counter registers if
+	 * Timer Counter is already configured as a PWM generator.
+	 */
+	if (cmr & ATMEL_TC_WAVE) {
+		if (index == 0)
+			tcbpwm->duty =
+				__raw_readl(regs + ATMEL_TC_REG(group, RA));
+		else
+			tcbpwm->duty =
+				__raw_readl(regs + ATMEL_TC_REG(group, RB));
+
+		tcbpwm->clk = cmr & ATMEL_TC_TCCLKS;
+		tcbpwm->period = __raw_readl(regs + ATMEL_TC_REG(group, RC));
+		cmr &= (ATMEL_TC_TCCLKS |
+				ATMEL_TC_ACPA | ATMEL_TC_ACPC |
+				ATMEL_TC_AEEVT | ATMEL_TC_ASWTRG |
+				ATMEL_TC_BCPB | ATMEL_TC_BCPC |
+				ATMEL_TC_BEEVT | ATMEL_TC_BSWTRG);
+	} else
+		cmr = 0;
+	cmr |= ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO | ATMEL_TC_EEVT_XC0;
+	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
+	spin_unlock(&tcbpwmc->lock);
+
+	clk_enable(tc->clk[group]);
+	tcbpwmc->pwms[pwm->hwpwm] = tcbpwm;
+
+	return 0;
+}
+
+static void atmel_tcb_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
+	struct atmel_tcb_pwm_device *tcbpwm = pwm_get_chip_data(pwm);
+	struct atmel_tc *tc = tcbpwmc->tc;
+
+	clk_disable(tc->clk[pwm->hwpwm / 2]);
+	tcbpwmc->pwms[pwm->hwpwm] = NULL;
+	kfree(tcbpwm);
+}
+
+static void atmel_tcb_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
+	struct atmel_tcb_pwm_device *tcbpwm = pwm_get_chip_data(pwm);
+	struct atmel_tc *tc = tcbpwmc->tc;
+	void __iomem *regs = tc->regs;
+	unsigned group = pwm->hwpwm / 2;
+	unsigned index = pwm->hwpwm % 2;
+	unsigned cmr;
+	unsigned newcmr = 0;
+	enum pwm_polarity polarity = tcbpwm->polarity;
+
+	/* If duty is 0 reverse polarity */
+	if (tcbpwm->duty == 0)
+		polarity = !polarity;
+
+	if (polarity == PWM_POLARITY_INVERSED) {
+		if (index == 0)
+			newcmr |= ATMEL_TC_ASWTRG_CLEAR;
+		else
+			newcmr |= ATMEL_TC_BSWTRG_CLEAR;
+	} else {
+		if (index == 0)
+			newcmr |= ATMEL_TC_ASWTRG_SET;
+		else
+			newcmr |= ATMEL_TC_BSWTRG_SET;
+	}
+
+	spin_lock(&tcbpwmc->lock);
+	cmr = __raw_readl(regs + ATMEL_TC_REG(group, CMR));
+
+	/* flush old setting */
+	if (index == 0)
+		cmr &= ~(ATMEL_TC_ACPA | ATMEL_TC_ACPC |
+				ATMEL_TC_AEEVT | ATMEL_TC_ASWTRG);
+	else
+		cmr &= ~(ATMEL_TC_BCPB | ATMEL_TC_BCPC |
+				ATMEL_TC_BEEVT | ATMEL_TC_BSWTRG);
+
+	/* configure new setting */
+	cmr |= newcmr;
+	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
+
+	/*
+	 * Use software trigger to apply the new setting.
+	 * If both pwm devices in this group are disabled we stop the clock.
+	 */
+	if (!(cmr & (ATMEL_TC_ACPC | ATMEL_TC_BCPC)))
+		__raw_writel(ATMEL_TC_SWTRG | ATMEL_TC_CLKDIS,
+				regs + ATMEL_TC_REG(group, CCR));
+	else
+		__raw_writel(ATMEL_TC_SWTRG, regs +
+				ATMEL_TC_REG(group, CCR));
+	spin_unlock(&tcbpwmc->lock);
+}
+
+static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
+	struct atmel_tcb_pwm_device *tcbpwm = pwm_get_chip_data(pwm);
+	struct atmel_tc *tc = tcbpwmc->tc;
+	void __iomem *regs = tc->regs;
+	unsigned group = pwm->hwpwm / 2;
+	unsigned index = pwm->hwpwm % 2;
+	u32 cmr;
+	u32 newcmr = 0;
+	enum pwm_polarity polarity = tcbpwm->polarity;
+
+	/* If duty is 0 reverse polarity */
+	if (tcbpwm->duty == 0)
+		polarity = !polarity;
+
+	/* Set CMR flags according to given polarity */
+	if (polarity == PWM_POLARITY_INVERSED) {
+		if (index == 0)
+			newcmr |= ATMEL_TC_ASWTRG_CLEAR;
+		else
+			newcmr |= ATMEL_TC_BSWTRG_CLEAR;
+	} else {
+		if (index == 0)
+			newcmr |= ATMEL_TC_ASWTRG_SET;
+		else
+			newcmr |= ATMEL_TC_BSWTRG_SET;
+	}
+
+	/*
+	 * If duty is 0 or equal to period there's no need to register
+	 * a specific action on RA/RB and RC compare.
+	 * The output will be configured on software trigger and keep
+	 * this config till next config call.
+	 */
+	if (tcbpwm->duty != tcbpwm->period && tcbpwm->duty > 0) {
+		if (polarity == PWM_POLARITY_INVERSED) {
+			if (index == 0)
+				newcmr |=
+					ATMEL_TC_ACPA_SET | ATMEL_TC_ACPC_CLEAR;
+			else
+				newcmr |=
+					ATMEL_TC_BCPB_SET | ATMEL_TC_BCPC_CLEAR;
+		} else {
+			if (index == 0)
+				newcmr |=
+					ATMEL_TC_ACPA_CLEAR | ATMEL_TC_ACPC_SET;
+			else
+				newcmr |=
+					ATMEL_TC_BCPB_CLEAR | ATMEL_TC_BCPC_SET;
+		}
+	}
+
+	newcmr |= tcbpwm->clk;
+
+	spin_lock(&tcbpwmc->lock);
+	cmr = __raw_readl(regs + ATMEL_TC_REG(group, CMR));
+
+	/* flush old setting */
+	cmr &= ~ATMEL_TC_TCCLKS;
+	if (index == 0)
+		cmr &= ~(ATMEL_TC_ACPA | ATMEL_TC_ACPC |
+				ATMEL_TC_AEEVT | ATMEL_TC_ASWTRG);
+	else
+		cmr &= ~(ATMEL_TC_BCPB | ATMEL_TC_BCPC |
+				ATMEL_TC_BEEVT | ATMEL_TC_BSWTRG);
+
+	/* configure new setting */
+	cmr |= newcmr;
+	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
+
+	if (index == 0)
+		__raw_writel(tcbpwm->duty, regs + ATMEL_TC_REG(group, RA));
+	else
+		__raw_writel(tcbpwm->duty, regs + ATMEL_TC_REG(group, RB));
+	__raw_writel(tcbpwm->period, regs + ATMEL_TC_REG(group, RC));
+
+	/* Use software trigger to apply the new setting */
+	__raw_writel(ATMEL_TC_CLKEN | ATMEL_TC_SWTRG,
+			regs + ATMEL_TC_REG(group, CCR));
+	spin_unlock(&tcbpwmc->lock);
+	return 0;
+}
+
+static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+		int duty_ns, int period_ns)
+{
+	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
+	struct atmel_tcb_pwm_device *tcbpwm = pwm_get_chip_data(pwm);
+	unsigned group = pwm->hwpwm / 2;
+	unsigned index = pwm->hwpwm % 2;
+	struct atmel_tcb_pwm_device *atcbpwm = NULL;
+	struct atmel_tc *tc = tcbpwmc->tc;
+	int i;
+	int slowclk = 0;
+	unsigned period;
+	unsigned duty;
+	unsigned rate = clk_get_rate(tc->clk[group]);
+	unsigned long long min;
+	unsigned long long max;
+
+	/*
+	 * Find best clk divisor:
+	 * the smallest divisor which can fulfill the period_ns requirements.
+	 */
+	for (i = 0; i < 5; ++i) {
+		if (atmel_tc_divisors[i] == 0) {
+			slowclk = i;
+			continue;
+		}
+		min = div_u64(1000000000, div_u64(rate, atmel_tc_divisors[i]));
+		max = min << tc->tcb_config->counter_width;
+		if (max >= period_ns)
+			break;
+	}
+
+	/*
+	 * If none of the divisor are small enough to represent period_ns
+	 * take slow clock (32KHz).
+	 */
+	if (i == 5) {
+		i = slowclk;
+		rate = 32768;
+		min = div_u64(1000000000, rate);
+		max = min << 16;
+
+		/* If period is too big return ERANGE error */
+		if (max < period_ns)
+			return -ERANGE;
+	}
+
+	duty = div_u64(duty_ns, min);
+	period = div_u64(period_ns, min);
+
+	if (index == 0)
+		atcbpwm = tcbpwmc->pwms[pwm->hwpwm + 1];
+	else
+		atcbpwm = tcbpwmc->pwms[pwm->hwpwm - 1];
+
+	/*
+	 * Check that associated PWM (if present) is configured
+	 * with the same period.
+	 * If not, return an error.
+	 */
+	if ((atcbpwm && atcbpwm->duty > 0 &&
+			atcbpwm->duty != atcbpwm->period) &&
+		(atcbpwm->clk != i || atcbpwm->period != period)) {
+		dev_err(chip->dev, "failed to configure period_ns\n");
+		return -EINVAL;
+	}
+
+	tcbpwm->period = period;
+	tcbpwm->clk = i;
+	tcbpwm->duty = duty;
+
+	/* If the PWM is enabled, call enable to apply the new conf */
+	if (test_bit(PWMF_ENABLED, &pwm->flags))
+		atmel_tcb_pwm_enable(chip, pwm);
+
+	return 0;
+}
+
+static const struct pwm_ops atmel_tcb_pwm_ops = {
+	.set_polarity = atmel_tcb_pwm_set_polarity,
+	.request = atmel_tcb_pwm_request,
+	.free = atmel_tcb_pwm_free,
+	.config = atmel_tcb_pwm_config,
+	.enable = atmel_tcb_pwm_enable,
+	.disable = atmel_tcb_pwm_disable,
+};
+
+static int atmel_tcb_pwm_probe(struct platform_device *pdev)
+{
+	struct atmel_tcb_pwm_chip *tcbpwm;
+	struct device_node *np = pdev->dev.of_node;
+	struct atmel_tc *tc;
+	int err;
+	int tcblock;
+
+	err = of_property_read_u32(np, "tc-block", &tcblock);
+	if (err < 0) {
+		dev_err(&pdev->dev,
+				"failed to get tc block number from device tree (error: %d)\n",
+				err);
+		return err;
+	}
+
+	tc = atmel_tc_alloc(tcblock, "tcb-pwm");
+	if (tc == NULL) {
+		dev_err(&pdev->dev, "failed to allocate Timer Counter Block\n");
+		return -ENOMEM;
+	}
+
+	tcbpwm = kzalloc(sizeof(*tcbpwm), GFP_KERNEL);
+	if (tcbpwm == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	tcbpwm->chip.dev = &pdev->dev;
+	tcbpwm->chip.ops = &atmel_tcb_pwm_ops;
+	tcbpwm->chip.base = -1;
+	tcbpwm->chip.npwm = NPWM;
+	tcbpwm->tc = tc;
+
+	spin_lock_init(&tcbpwm->lock);
+
+	err = pwmchip_add(&tcbpwm->chip);
+	if (err < 0) {
+		kfree(tcbpwm);
+		return err;
+	}
+
+	dev_dbg(&pdev->dev, "pwm probe successful\n");
+	platform_set_drvdata(pdev, tcbpwm);
+
+	return 0;
+}
+
+static int atmel_tcb_pwm_remove(struct platform_device *pdev)
+{
+	struct atmel_tcb_pwm_chip *tcbpwm = platform_get_drvdata(pdev);
+	int err;
+
+	err = pwmchip_remove(&tcbpwm->chip);
+	if (err < 0)
+		return err;
+
+	atmel_tc_free(tcbpwm->tc);
+
+	dev_dbg(&pdev->dev, "pwm driver removed\n");
+	kfree(tcbpwm);
+
+	return 0;
+}
+
+static struct of_device_id atmel_tcb_pwm_dt_ids[] = {
+	{ .compatible = "atmel,tcb-pwm", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, mxs_pwm_dt_ids);
+
+static struct platform_driver atmel_tcb_pwm_driver = {
+	.driver = {
+		.name = "atmel-tcb-pwm",
+		.of_match_table = atmel_tcb_pwm_dt_ids,
+	},
+	.probe = atmel_tcb_pwm_probe,
+	.remove = atmel_tcb_pwm_remove,
+};
+module_platform_driver(atmel_tcb_pwm_driver);
+
+MODULE_AUTHOR("Boris BREZILLON <b.brezillon@overkiz.com>");
+MODULE_DESCRIPTION("Atmel Timer Counter Pulse Width Modulation Driver");
+MODULE_ALIAS("platform:atmel-tcb-pwm");
+MODULE_LICENSE("GPL v2");
-- 
1.7.0.4

