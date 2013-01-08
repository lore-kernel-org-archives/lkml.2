Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab3AHQBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:01:50 -0500
Received: from 19.mo4.mail-out.ovh.net ([87.98.179.66]:58095 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750846Ab3AHQBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:01:49 -0500
X-Greylist: delayed 10801 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2013 11:01:49 EST
From: Boris BREZILLON <linux-arm@overkiz.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Boris BREZILLON <linux-arm@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH v5] pwm: atmel: add Timer Counter Block PWM driver
Date: Tue,  8 Jan 2013 16:36:42 +0100
Message-Id: <1357659402-4574-1-git-send-email-linux-arm@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 4399453887753663510
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds a PWM driver based on Atmel Timer Counter Block.
Timer Counter Block is used in Waveform generator mode.

A Timer Counter Block provides up to 6 PWM devices grouped by 2:
* group 0 = PWM 0 and 1
* group 1 = PWM 2 and 3
* group 2 = PMW 4 and 5

PWM devices in a given group must be configured with the same
period value.
If a PWM device in a group tries to change the period value and
the other device is already configured with a different value an
error will be returned.

This driver requires device tree support.
The Timer Counter Block number used to create a PWM chip is
given by tc-block field in an "atmel,tcb-pwm" compatible node.

This patch was tested on kizbox board (at91sam9g20 SoC) with 
pwm-leds.

Regards,

Boris

Signed-off-by: Boris BREZILLON <linux-arm@overkiz.com>
---
Changes since v1:
	- Fix device tree binding Documentation
	- Fix Kconfig issues (missing OF dependency, 
				deprecated HAVE_PWM select, ...)
	- Fix various coding style issues.
	- Cleanup code and add some comments.

Changes since v2:
	- Replace kzalloc/kfree with managed versions
	  (devm_kzalloc/devm_kfree).
	- Add one cell to device tree binding to support polarity
	  flag.
	- Replace min computation (2 div -> 1 mul + 1 div).

Changes since v3:
	- Fix device tree binding Documentation
	- Fix Kconfig description
	- Fix coding style issues (function parameters alignment)
	- Replace 1000000000 value with NSEC_PER_SEC macro
	- Get rid of newcmr variable in enable/disable functions
	- Remove unneeded devm_kfree
	- Add missing atmel_tc_free

Changes since v4:
	- Add missing comments
	- Fix coding style issues (multi-line error string)
	- Fix wrong MODULE_DEVICE_TABLE setting
	- Remove unneeded MODULE_ALIAS declaration

 .../devicetree/bindings/pwm/atmel-tcb-pwm.txt      |   18 +
 drivers/pwm/Kconfig                                |   12 +
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-atmel-tcb.c                        |  445 ++++++++++++++++++++
 4 files changed, 476 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
 create mode 100644 drivers/pwm/pwm-atmel-tcb.c

diff --git a/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
new file mode 100644
index 0000000..de0eaed
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
@@ -0,0 +1,18 @@
+Atmel TCB PWM controller
+
+Required properties:
+- compatible: should be "atmel,tcb-pwm"
+- #pwm-cells: Should be 3.  The first cell specifies the per-chip index
+  of the PWM to use, the second cell is the period in nanoseconds and
+  bit 0 in the third cell is used to encode the polarity of PWM output.
+  Set bit 0 of the third cell in PWM specifier to 1 for inverse polarity &
+  set to 0 for normal polarity.
+- tc-block: The Timer Counter block to use as a PWM chip.
+
+Example:
+
+pwm {
+	compatible = "atmel,tcb-pwm";
+	#pwm-cells = <3>;
+	tc-block = <1>;
+};
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index e513cd9..10b6afc 100644
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
+	  will be called pwm-atmel-tcb.
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
index 0000000..16cb530
--- /dev/null
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -0,0 +1,445 @@
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
+#define ATMEL_TC_ACMR_MASK	(ATMEL_TC_ACPA | ATMEL_TC_ACPC |	\
+				 ATMEL_TC_AEEVT | ATMEL_TC_ASWTRG)
+
+#define ATMEL_TC_BCMR_MASK	(ATMEL_TC_BCPB | ATMEL_TC_BCPC |	\
+				 ATMEL_TC_BEEVT | ATMEL_TC_BSWTRG)
+
+struct atmel_tcb_pwm_device {
+	enum pwm_polarity polarity;	/* PWM polarity */
+	unsigned div;			/* PWM clock divider */
+	unsigned duty;			/* PWM duty expressed in clk cycles */
+	unsigned period;		/* PWM period expressed in clk cycles */
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
+				      struct pwm_device *pwm,
+				      enum pwm_polarity polarity)
+{
+	struct atmel_tcb_pwm_device *tcbpwm = pwm_get_chip_data(pwm);
+
+	tcbpwm->polarity = polarity;
+
+	return 0;
+}
+
+static int atmel_tcb_pwm_request(struct pwm_chip *chip,
+				 struct pwm_device *pwm)
+{
+	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
+	struct atmel_tcb_pwm_device *tcbpwm;
+	struct atmel_tc *tc = tcbpwmc->tc;
+	void __iomem *regs = tc->regs;
+	unsigned group = pwm->hwpwm / 2;
+	unsigned index = pwm->hwpwm % 2;
+	unsigned cmr;
+	int ret;
+
+	tcbpwm = devm_kzalloc(chip->dev, sizeof(*tcbpwm), GFP_KERNEL);
+	if (!tcbpwm)
+		return -ENOMEM;
+
+	ret = clk_enable(tc->clk[group]);
+	if (ret) {
+		devm_kfree(chip->dev, tcbpwm);
+		return ret;
+	}
+
+	pwm_set_chip_data(pwm, tcbpwm);
+	tcbpwm->polarity = PWM_POLARITY_NORMAL;
+	tcbpwm->duty = 0;
+	tcbpwm->period = 0;
+	tcbpwm->div = 0;
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
+		tcbpwm->div = cmr & ATMEL_TC_TCCLKS;
+		tcbpwm->period = __raw_readl(regs + ATMEL_TC_REG(group, RC));
+		cmr &= (ATMEL_TC_TCCLKS | ATMEL_TC_ACMR_MASK |
+			ATMEL_TC_BCMR_MASK);
+	} else
+		cmr = 0;
+
+	cmr |= ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO | ATMEL_TC_EEVT_XC0;
+	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
+	spin_unlock(&tcbpwmc->lock);
+
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
+	devm_kfree(chip->dev, tcbpwm);
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
+	enum pwm_polarity polarity = tcbpwm->polarity;
+
+	/*
+	 * If duty is 0 the timer will be stopped and we have to
+	 * configure the output correctly on software trigger:
+	 *  - set output to high if PWM_POLARITY_INVERSED
+	 *  - set output to low if PWM_POLARITY_NORMAL
+	 *
+	 * This is why we're reverting polarity in this case.
+	 */
+	if (tcbpwm->duty == 0)
+		polarity = !polarity;
+
+	spin_lock(&tcbpwmc->lock);
+	cmr = __raw_readl(regs + ATMEL_TC_REG(group, CMR));
+
+	/* flush old setting and set the new one */
+	if (index == 0) {
+		cmr &= ~ATMEL_TC_ACMR_MASK;
+		if (polarity == PWM_POLARITY_INVERSED)
+			cmr |= ATMEL_TC_ASWTRG_CLEAR;
+		else
+			cmr |= ATMEL_TC_ASWTRG_SET;
+	} else {
+		cmr &= ~ATMEL_TC_BCMR_MASK;
+		if (polarity == PWM_POLARITY_INVERSED)
+			cmr |= ATMEL_TC_BSWTRG_CLEAR;
+		else
+			cmr |= ATMEL_TC_BSWTRG_SET;
+	}
+
+	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
+
+	/*
+	 * Use software trigger to apply the new setting.
+	 * If both PWM devices in this group are disabled we stop the clock.
+	 */
+	if (!(cmr & (ATMEL_TC_ACPC | ATMEL_TC_BCPC)))
+		__raw_writel(ATMEL_TC_SWTRG | ATMEL_TC_CLKDIS,
+			     regs + ATMEL_TC_REG(group, CCR));
+	else
+		__raw_writel(ATMEL_TC_SWTRG, regs +
+			     ATMEL_TC_REG(group, CCR));
+
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
+	enum pwm_polarity polarity = tcbpwm->polarity;
+
+	/*
+	 * If duty is 0 the timer will be stopped and we have to
+	 * configure the output correctly on software trigger:
+	 *  - set output to high if PWM_POLARITY_INVERSED
+	 *  - set output to low if PWM_POLARITY_NORMAL
+	 *
+	 * This is why we're reverting polarity in this case.
+	 */
+	if (tcbpwm->duty == 0)
+		polarity = !polarity;
+
+	spin_lock(&tcbpwmc->lock);
+	cmr = __raw_readl(regs + ATMEL_TC_REG(group, CMR));
+
+	/* flush old setting and set the new one */
+	cmr &= ~ATMEL_TC_TCCLKS;
+
+	if (index == 0) {
+		cmr &= ~ATMEL_TC_ACMR_MASK;
+
+		/* Set CMR flags according to given polarity */
+		if (polarity == PWM_POLARITY_INVERSED)
+			cmr |= ATMEL_TC_ASWTRG_CLEAR;
+		else
+			cmr |= ATMEL_TC_ASWTRG_SET;
+	} else {
+		cmr &= ~ATMEL_TC_BCMR_MASK;
+		if (polarity == PWM_POLARITY_INVERSED)
+			cmr |= ATMEL_TC_BSWTRG_CLEAR;
+		else
+			cmr |= ATMEL_TC_BSWTRG_SET;
+	}
+
+	/*
+	 * If duty is 0 or equal to period there's no need to register
+	 * a specific action on RA/RB and RC compare.
+	 * The output will be configured on software trigger and keep
+	 * this config till next config call.
+	 */
+	if (tcbpwm->duty != tcbpwm->period && tcbpwm->duty > 0) {
+		if (index == 0) {
+			if (polarity == PWM_POLARITY_INVERSED)
+				cmr |= ATMEL_TC_ACPA_SET | ATMEL_TC_ACPC_CLEAR;
+			else
+				cmr |= ATMEL_TC_ACPA_CLEAR | ATMEL_TC_ACPC_SET;
+		} else {
+			if (polarity == PWM_POLARITY_INVERSED)
+				cmr |= ATMEL_TC_BCPB_SET | ATMEL_TC_BCPC_CLEAR;
+			else
+				cmr |= ATMEL_TC_BCPB_CLEAR | ATMEL_TC_BCPC_SET;
+		}
+	}
+
+	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
+
+	if (index == 0)
+		__raw_writel(tcbpwm->duty, regs + ATMEL_TC_REG(group, RA));
+	else
+		__raw_writel(tcbpwm->duty, regs + ATMEL_TC_REG(group, RB));
+
+	__raw_writel(tcbpwm->period, regs + ATMEL_TC_REG(group, RC));
+
+	/* Use software trigger to apply the new setting */
+	__raw_writel(ATMEL_TC_CLKEN | ATMEL_TC_SWTRG,
+		     regs + ATMEL_TC_REG(group, CCR));
+	spin_unlock(&tcbpwmc->lock);
+	return 0;
+}
+
+static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+				int duty_ns, int period_ns)
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
+		min = div_u64((u64)NSEC_PER_SEC * atmel_tc_divisors[i], rate);
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
+		min = div_u64(NSEC_PER_SEC, rate);
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
+	 * PWM devices provided by TCB driver are grouped by 2:
+	 * - group 0: PWM 0 & 1
+	 * - group 1: PWM 2 & 3
+	 * - group 2: PWM 4 & 5
+	 *
+	 * PWM devices in a given group must be configured with the
+	 * same period_ns.
+	 *
+	 * We're checking the period value of the second PWM device
+	 * in this group before applying the new config.
+	 */
+	if ((atcbpwm && atcbpwm->duty > 0 &&
+			atcbpwm->duty != atcbpwm->period) &&
+		(atcbpwm->div != i || atcbpwm->period != period)) {
+		dev_err(chip->dev,
+			"failed to configure period_ns: PWM group already configured with a different value\n");
+		return -EINVAL;
+	}
+
+	tcbpwm->period = period;
+	tcbpwm->div = i;
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
+	.request = atmel_tcb_pwm_request,
+	.free = atmel_tcb_pwm_free,
+	.config = atmel_tcb_pwm_config,
+	.set_polarity = atmel_tcb_pwm_set_polarity,
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
+			"failed to get Timer Counter Block number from device tree (error: %d)\n",
+			err);
+		return err;
+	}
+
+	tc = atmel_tc_alloc(tcblock, "tcb-pwm");
+	if (tc == NULL) {
+		dev_err(&pdev->dev, "failed to allocate Timer Counter Block\n");
+		return -ENOMEM;
+	}
+
+	tcbpwm = devm_kzalloc(&pdev->dev, sizeof(*tcbpwm), GFP_KERNEL);
+	if (tcbpwm == NULL) {
+		atmel_tc_free(tc);
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	tcbpwm->chip.dev = &pdev->dev;
+	tcbpwm->chip.ops = &atmel_tcb_pwm_ops;
+	tcbpwm->chip.of_xlate = of_pwm_xlate_with_flags;
+	tcbpwm->chip.of_pwm_n_cells = 3;
+	tcbpwm->chip.base = -1;
+	tcbpwm->chip.npwm = NPWM;
+	tcbpwm->tc = tc;
+
+	spin_lock_init(&tcbpwm->lock);
+
+	err = pwmchip_add(&tcbpwm->chip);
+	if (err < 0) {
+		atmel_tc_free(tc);
+		return err;
+	}
+
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
+	return 0;
+}
+
+static const struct of_device_id atmel_tcb_pwm_dt_ids[] = {
+	{ .compatible = "atmel,tcb-pwm", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, atmel_tcb_pwm_dt_ids);
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
+MODULE_LICENSE("GPL v2");
-- 
1.7.0.4

