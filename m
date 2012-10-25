Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935880Ab2JYQNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:13:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46715 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946299Ab2JYQMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:12:35 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-keystone@list.ti.com>, Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 05/11] clk: davinci - add dm644x clock initialization
Date: Thu, 25 Oct 2012 12:11:51 -0400
Message-ID: <1351181518-11882-6-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dm644x clock initialization code that consists of
clocks data for various clocks and clock register callouts to
various clock drivers. It uses following clk drivers for this

 1. clk-fixed-rate - for ref clock
 2. clk-mux - for mux at the input and output of main pll
 3. davinci specific clk-pll for main pll clock
 4. davinci specific clk-div for pll divider clock
 5. clk-fixed-factor for fixed factor clock such as auxclk
 6. davinci specific clk-psc for psc clocks

This patch also moves all of the PLL and PSC register definitions
from clock.h and psc.h under davinci to the clk/davinci folder so
that various soc specific clock initialization code can share these
definitions.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/clk/davinci/dm644x-clock.c |  304 ++++++++++++++++++++++++++++++++++++
 drivers/clk/davinci/pll.h          |   83 ++++++++++
 drivers/clk/davinci/psc.h          |  215 +++++++++++++++++++++++++
 3 files changed, 602 insertions(+)
 create mode 100644 drivers/clk/davinci/dm644x-clock.c
 create mode 100644 drivers/clk/davinci/pll.h
 create mode 100644 drivers/clk/davinci/psc.h

diff --git a/drivers/clk/davinci/dm644x-clock.c b/drivers/clk/davinci/dm644x-clock.c
new file mode 100644
index 0000000..8f74f72
--- /dev/null
+++ b/drivers/clk/davinci/dm644x-clock.c
@@ -0,0 +1,304 @@
+/*
+ * DM644x clock initialization
+ *
+ * Copyright (C) 2012 Texas Instruments.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+
+#include "clk-pll.h"
+#include "clk-psc.h"
+#include "clk-div.h"
+#include "clock.h"
+#include "pll.h"
+#include "psc.h"
+
+#define DM644X_CLKIN_FREQ         27000000
+#define DM644X_OSCIN_FREQ         27000000
+
+/* all clocks available in DM644x SoCs */
+enum dm644x_clk {
+	clkin, oscin, ref_clk_mux, pll1, pll1_plldiv_clk_mux, auxclk,
+	clk_pll1_sysclk1, clk_pll1_sysclk2, clk_pll1_sysclk3, clk_pll1_sysclk4,
+	clk_pll1_sysclk5, clk_pll1_sysclkbp, pll2, pll2_plldiv_clk_mux,
+	clk_pll2_sysclk1, clk_pll2_sysclk2, clk_pll2_sysclkbp, dsp, arm, vicp,
+	vpss_master, vpss_slave, uart0, uart1, uart2, emac, i2c, ide, asp,
+	mmcsd, spi, gpio, usb, vlynq, aemif, pwm0, pwm1, pwm2, timer0, timer1,
+	timer2, clk_max
+};
+
+static struct clk *clks[clk_max];
+
+static u32 dm644x_psc_bases[] = { DAVINCI_PWR_SLEEP_CNTRL_BASE };
+
+static const char *ref_clk_mux_parents[] = {"clkin", "oscin"};
+
+static struct clk_mux_data ref_clk_mux_data = {
+	.shift		= PLLCTL_CLKMODE_SHIFT,
+	.width		= PLLCTL_CLKMODE_WIDTH,
+	.phys_reg	= DAVINCI_PLL1_BASE + PLLCTL,
+};
+
+static const char *pll1_plldiv_clk_mux_parents[] = {
+						"ref_clk_mux", "pll1"};
+
+static struct clk_pll_data pll1_data = {
+	.pllm_mask	= PLLM_PLLM_MASK,
+	.prediv_mask	= PLLDIV_RATIO_MASK,
+	.postdiv_mask	= PLLDIV_RATIO_MASK,
+	.num		= 1,
+};
+
+static struct clk_mux_data pll1_plldiv_clk_mux_data = {
+	.shift		= PLLCTL_PLLEN_SHIFT,
+	.width		= PLLCTL_PLLEN_WIDTH,
+	.phys_reg	= DAVINCI_PLL1_BASE + PLLCTL,
+};
+
+#define define_pll1_div_clk(__name, __parent_name, __div)		\
+	static struct clk_plldiv_data pll1_div_data##__div = {		\
+		.phys_div_reg	= DAVINCI_PLL1_BASE + PLLDIV##__div,	\
+		.width		= 5,				\
+		.en_id		= 15,				\
+	};							\
+								\
+	static struct davinci_clk __name = {			\
+		.name		= #__name,			\
+		.parent		= #__parent_name,		\
+		.data		=  &pll1_div_data##__div,	\
+	};
+
+define_pll1_div_clk(pll1_sysclk1, pll1_plldiv_clk_mux, 1);
+define_pll1_div_clk(pll1_sysclk2, pll1_plldiv_clk_mux, 2);
+define_pll1_div_clk(pll1_sysclk3, pll1_plldiv_clk_mux, 3);
+define_pll1_div_clk(pll1_sysclk4, pll1_plldiv_clk_mux, 4);
+define_pll1_div_clk(pll1_sysclk5, pll1_plldiv_clk_mux, 5);
+
+static struct clk_plldiv_data pll1_sysclkbp_data = {
+	.phys_div_reg	= DAVINCI_PLL1_BASE + BPDIV,
+	.width		= 5,
+	.en_id		= 15,
+};
+
+static struct davinci_clk pll1_sysclkbp = {
+	.name		= "pll1_sysclkbp",
+	.parent		= "ref_clk_mux",
+	.data		= &pll1_sysclkbp_data,
+};
+
+static struct davinci_clk *pll1_plldiv_clocks[] = {
+	&pll1_sysclk1, &pll1_sysclk2, &pll1_sysclk3, &pll1_sysclk4,
+	&pll1_sysclk5, &pll1_sysclkbp,
+};
+
+static struct clk_pll_data pll2_data = {
+	.pllm_mask	= PLLM_PLLM_MASK,
+	.prediv_mask	= PLLDIV_RATIO_MASK,
+	.postdiv_mask	= PLLDIV_RATIO_MASK,
+	.num		= 2,
+};
+
+#define define_pll2_div_clk(__name, __parent_name, __div)	\
+	static struct clk_plldiv_data pll2_div_data##__div = {		\
+		.phys_div_reg	= DAVINCI_PLL2_BASE + PLLDIV##__div,	\
+		.width		= 5,				\
+		.en_id		= 15,				\
+	};							\
+								\
+	static struct davinci_clk __name = {			\
+		.name		= #__name,			\
+		.parent		= #__parent_name,		\
+		.data		=  &pll2_div_data##__div,	\
+	};
+
+static const char *pll2_plldiv_clk_mux_parents[] = {
+					"ref_clk_mux", "pll2"};
+
+static struct clk_mux_data pll2_plldiv_clk_mux_data = {
+	.shift		= PLLCTL_PLLEN_SHIFT,
+	.width		= PLLCTL_PLLEN_WIDTH,
+	.phys_reg	= DAVINCI_PLL2_BASE + PLLCTL,
+};
+
+define_pll2_div_clk(pll2_sysclk1, pll2_plldiv_clk_mux, 1);
+define_pll2_div_clk(pll2_sysclk2, pll2_plldiv_clk_mux, 2);
+
+static struct clk_plldiv_data pll2_sysclkbp_data = {
+	.phys_div_reg	= DAVINCI_PLL2_BASE + BPDIV,
+	.width		= 5,
+	.en_id		= 15,
+};
+
+static struct davinci_clk pll2_sysclkbp = {
+	.name		= "pll2_sysclkbp",
+	.parent		= "ref_clk_mux",
+	.data		= &pll2_sysclkbp_data,
+};
+
+static struct davinci_clk *pll2_plldiv_clocks[] = {
+	&pll2_sysclk1, &pll2_sysclk2, &pll2_sysclkbp,
+};
+
+#define __lpsc_clk(__name, __parent_name, mod, flgs, _flgs, dom, _dev_id) \
+	static struct clk_psc_data clk_psc_data_##__name = {	\
+		.domain_id	= DAVINCI_GPSC_##dom,		\
+		.lpsc_id	= DAVINCI_LPSC_##mod,		\
+		.flags		= flgs | CLK_PSC_HAS_EXT_POWER_CNTL,	\
+	};							\
+								\
+	static struct davinci_clk clk_##__name = {		\
+		.name		= #__name,			\
+		.parent		= #__parent_name,		\
+		.flags		= _flgs,			\
+		.dev_id		= _dev_id,			\
+		.data		= &clk_psc_data_##__name	\
+	};
+
+#define lpsc_clk_enabled(name, parent, mod, dev_id)		\
+	__lpsc_clk(name, parent, mod, 0, ALWAYS_ENABLED, ARMDOMAIN, dev_id)
+
+#define lpsc_clk(name, flgs, parent, mod, dom, dev_id)		\
+	__lpsc_clk(name, parent, mod, flgs, 0, dom, dev_id)
+
+lpsc_clk_enabled(arm, pll1_sysclk2, ARM, NULL);
+lpsc_clk(dsp, CLK_IGNORE_UNUSED, pll1_sysclk1, GEM, DSPDOMAIN, NULL);
+lpsc_clk(vicp, CLK_IGNORE_UNUSED, pll1_sysclk2, IMCOP, DSPDOMAIN, NULL);
+lpsc_clk(vpss_master, 0, pll1_sysclk3, VPSSMSTR, ARMDOMAIN, "dm644x_ccdc");
+lpsc_clk(vpss_slave, 0, pll1_sysclk3, VPSSSLV, ARMDOMAIN, "dm644x_ccdc");
+lpsc_clk(uart0, 0, auxclk, UART0, ARMDOMAIN, NULL);
+lpsc_clk(uart1, 0, auxclk, UART1, ARMDOMAIN, NULL);
+lpsc_clk(uart2, 0, auxclk, UART2, ARMDOMAIN, NULL);
+lpsc_clk(emac, 0, pll1_sysclk5, EMAC_WRAPPER, ARMDOMAIN, "davinci_emac.1");
+lpsc_clk(i2c, 0, auxclk, I2C, ARMDOMAIN, "i2c_davinci.1");
+lpsc_clk(ide, 0, pll1_sysclk5, ATA, ARMDOMAIN, "palm_bk3710");
+lpsc_clk(asp0, 0, pll1_sysclk5, McBSP, ARMDOMAIN, "davinci-mcbsp");
+lpsc_clk(mmcsd, 0, pll1_sysclk5, MMC_SD, ARMDOMAIN, "davinci_mmc.0");
+lpsc_clk(spi, 0, pll1_sysclk5, SPI, ARMDOMAIN, NULL);
+lpsc_clk(gpio, 0, pll1_sysclk5, GPIO, ARMDOMAIN, NULL);
+lpsc_clk(usb, 0, pll1_sysclk5, USB, ARMDOMAIN, NULL);
+lpsc_clk(vlynq, 0, pll1_sysclk5, VLYNQ, ARMDOMAIN, NULL);
+lpsc_clk(aemif, 0, pll1_sysclk5, AEMIF, ARMDOMAIN, NULL);
+lpsc_clk(pwm0, 0, auxclk, PWM0, ARMDOMAIN, NULL);
+lpsc_clk(pwm1, 0, auxclk, PWM1, ARMDOMAIN, NULL);
+lpsc_clk(pwm2, 0, auxclk, PWM2, ARMDOMAIN, NULL);
+lpsc_clk(timer0, 0, auxclk, TIMER0, ARMDOMAIN, NULL);
+lpsc_clk(timer1, 0, auxclk, TIMER1, ARMDOMAIN, NULL);
+lpsc_clk(timer2, CLK_IGNORE_UNUSED, auxclk, TIMER2, ARMDOMAIN, "watchdog");
+
+static struct davinci_clk *psc_clocks[] = {
+	&clk_dsp, &clk_arm, &clk_vicp, &clk_vpss_master, &clk_vpss_slave,
+	&clk_uart0, &clk_uart1, &clk_uart2, &clk_emac, &clk_i2c, &clk_ide,
+	&clk_asp0, &clk_mmcsd, &clk_spi, &clk_gpio, &clk_usb, &clk_vlynq,
+	&clk_aemif, &clk_pwm0, &clk_pwm1, &clk_pwm2, &clk_timer0, &clk_timer1,
+	&clk_timer2
+};
+
+void __init dm644x_clk_init(void)
+{
+	void __iomem *psc_base;
+	int i, ret;
+
+	psc_base = ioremap(dm644x_psc_bases[0], SZ_4K);
+	if (WARN_ON(!psc_base))
+		return;
+
+	/* Input clocks to the SoC */
+	clks[clkin] = davinci_fixed_ref_clk("clkin", DM644X_CLKIN_FREQ);
+	clks[oscin] = davinci_fixed_ref_clk("oscin", DM644X_OSCIN_FREQ);
+
+	/* The mux at the input selected by CLKMODE bit */
+	clks[ref_clk_mux] = davinci_mux_clk("ref_clk_mux",
+				ARRAY_SIZE(ref_clk_mux_parents),
+				ref_clk_mux_parents, &ref_clk_mux_data);
+
+	/* Main PLL1 clock */
+	clks[pll1] = davinci_pll_clk("pll1", "ref_clk_mux",
+		DAVINCI_PLL1_BASE + PLLM, 0, 0, &pll1_data);
+
+	/* The mux at the output of PLL1 and selected by PLLEN bit */
+	clks[pll1_plldiv_clk_mux] = davinci_mux_clk("pll1_plldiv_clk_mux",
+			ARRAY_SIZE(pll1_plldiv_clk_mux_parents),
+			pll1_plldiv_clk_mux_parents,
+			&pll1_plldiv_clk_mux_data);
+
+	/* Auxiliary clock that comes from the ref_clk_mux output */
+	clks[auxclk] = davinci_fixed_factor_clk("auxclk",
+			"ref_clk_mux", 0, 1, 1);
+
+	/*
+	 * PLL1 divider clocks that has an EN bit to enable or bypass the
+	 * PLL divider
+	 */
+	for (i = 0; i < ARRAY_SIZE(pll1_plldiv_clocks); i++)
+		clks[clk_pll1_sysclk1 + i] =
+			davinci_plldiv_clk(pll1_plldiv_clocks[i]->name,
+				pll1_plldiv_clocks[i]->parent,
+				pll1_plldiv_clocks[i]->data);
+
+	/* Main PLL2 clock */
+	clks[pll2] = davinci_pll_clk("pll2", "ref_clk_mux",
+		DAVINCI_PLL2_BASE + PLLM, 0, 0, &pll2_data);
+
+	/* The mux at the output of PLL2 and selected by PLLEN bit */
+	clks[pll2_plldiv_clk_mux] = davinci_mux_clk("pll2_plldiv_clk_mux",
+			ARRAY_SIZE(pll2_plldiv_clk_mux_parents),
+			pll2_plldiv_clk_mux_parents,
+			&pll2_plldiv_clk_mux_data);
+
+	/*
+	 * PLL2 divider clocks that has an EN bit to enable or bypass the
+	 * PLL divider
+	 */
+	for (i = 0; i < ARRAY_SIZE(pll2_plldiv_clocks); i++)
+		clks[clk_pll2_sysclk1 + i] =
+			davinci_plldiv_clk(pll2_plldiv_clocks[i]->name,
+					pll2_plldiv_clocks[i]->parent,
+					pll2_plldiv_clocks[i]->data);
+
+	/* PSC clocks */
+	for (i = 0; i < ARRAY_SIZE(psc_clocks); i++) {
+		struct clk_psc_data *data = psc_clocks[i]->data;
+
+		data->reg_base = psc_base;
+		clks[dsp + i] = davinci_psc_clk(psc_clocks[i]->name,
+				psc_clocks[i]->parent, data);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(clks); i++) {
+		if (IS_ERR(clks[i])) {
+			pr_err("DM644x clk %d: register failed with %ld\n",
+				i, PTR_ERR(clks[i]));
+			return;
+		}
+	}
+
+	/* register clkdev for leaf clocks */
+	for (i = 0; i < ARRAY_SIZE(psc_clocks); i++) {
+		if (psc_clocks[i]->dev_id)
+			ret = clk_register_clkdev(clks[dsp + i], NULL,
+					psc_clocks[i]->dev_id);
+		else
+			ret = clk_register_clkdev(clks[dsp + i],
+					psc_clocks[i]->name, NULL);
+		if (ret < 0) {
+			pr_err("clk_register_clkdev failed for %s\n",
+				psc_clocks[i]->name);
+			return;
+		}
+
+		/* Enable always on clocks */
+		if (psc_clocks[i]->flags & ALWAYS_ENABLED)
+			clk_prepare_enable(clks[dsp + i]);
+	}
+	pr_notice("DM644x clock initialization complete\n");
+}
+EXPORT_SYMBOL_GPL(dm644x_clk_init);
diff --git a/drivers/clk/davinci/pll.h b/drivers/clk/davinci/pll.h
new file mode 100644
index 0000000..5000e6f
--- /dev/null
+++ b/drivers/clk/davinci/pll.h
@@ -0,0 +1,83 @@
+/*
+ * TI DaVinci PLL definitions
+ *
+ * Copyright (C) 2006-2012 Texas Instruments.
+ * Copyright (C) 2008-2009 Deep Root Systems, LLC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#ifndef __DAVINCI_PLL_H
+#define __DAVINCI_PLL_H
+
+#define DAVINCI_PLL1_BASE 0x01c40800
+#define DAVINCI_PLL2_BASE 0x01c40c00
+#define MAX_PLL 2
+
+/* PLL/Reset register offsets */
+#define PLLCTL          0x100
+#define PLLCTL_PLLEN    BIT(0)
+#define PLLCTL_PLLPWRDN	BIT(1)
+#define PLLCTL_PLLRST	BIT(3)
+#define PLLCTL_PLLDIS	BIT(4)
+#define PLLCTL_PLLENSRC	BIT(5)
+#define PLLCTL_CLKMODE  BIT(8)
+
+#define PLLCTL_CLKMODE_SHIFT	8
+#define PLLCTL_CLKMODE_WIDTH	1
+#define PLLCTL_PLLEN_SHIFT	0
+#define PLLCTL_PLLEN_WIDTH	1
+
+#define PLLDIV1         0x118
+#define PLLDIV2         0x11c
+#define PLLDIV3         0x120
+#define OSCDIV1         0x124
+#define BPDIV           0x12c
+#define PLLCMD		0x138
+#define PLLSTAT		0x13c
+#define PLLALNCTL	0x140
+#define PLLDCHANGE	0x144
+#define PLLCKEN		0x148
+#define PLLCKSTAT	0x14c
+#define PLLSYSTAT	0x150
+#define PLLDIV4         0x160
+#define PLLDIV5         0x164
+#define PLLDIV6         0x168
+#define PLLDIV7         0x16c
+#define PLLDIV8         0x170
+#define PLLDIV9         0x174
+#define PLLDIV10        0x178
+#define PLLDIV11        0x17c
+#define PLLDIV12        0x180
+#define PLLDIV13        0x184
+#define PLLDIV14        0x188
+#define PLLDIV15        0x18c
+#define PLLDIV16        0x190
+#define PLLDIV_RATIO_MASK 0x1f
+#define PLLDIV_EN       BIT(15)
+
+/*
+ * OMAP-L138 system reference guide recommends a wait for 4 OSCIN/CLKIN
+ * cycles to ensure that the PLLC has switched to bypass mode. Delay of 1us
+ * ensures we are good for all > 4MHz OSCIN/CLKIN inputs. Typically the input
+ * is ~25MHz. Units are micro seconds.
+ */
+#define PLL_BYPASS_TIME		1
+/* From OMAP-L138 datasheet table 6-4. Units are micro seconds */
+#define PLL_RESET_TIME		1
+/*
+ * From OMAP-L138 datasheet table 6-4; assuming prediv = 1, sqrt(pllm) = 4
+ * Units are micro seconds.
+ */
+#define PLL_LOCK_TIME		20
+#define PLLSTAT_GOSTAT		BIT(0)
+#define PLLCMD_GOSET		BIT(0)
+
+#define PLLM		0x110
+#define PREDIV          0x114
+#define POSTDIV         0x128
+#define PLLM_PLLM_MASK  0xff
+
+#endif /* __ASM_ARCH_PLL_H */
diff --git a/drivers/clk/davinci/psc.h b/drivers/clk/davinci/psc.h
new file mode 100644
index 0000000..1f704d6
--- /dev/null
+++ b/drivers/clk/davinci/psc.h
@@ -0,0 +1,215 @@
+/*
+ *  DaVinci Power & Sleep Controller (PSC) defines
+ *
+ *  Copyright (C) 2006-2012 Texas Instruments.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+#ifndef __DAVINCI_PSC_H
+#define __DAVINCI_PSC_H
+
+#define	DAVINCI_PWR_SLEEP_CNTRL_BASE	0x01C41000
+
+/* Power and Sleep Controller (PSC) Domains */
+#define DAVINCI_GPSC_ARMDOMAIN		0
+#define DAVINCI_GPSC_DSPDOMAIN		1
+
+#define DAVINCI_LPSC_VPSSMSTR		0
+#define DAVINCI_LPSC_VPSSSLV		1
+#define DAVINCI_LPSC_TPCC		2
+#define DAVINCI_LPSC_TPTC0		3
+#define DAVINCI_LPSC_TPTC1		4
+#define DAVINCI_LPSC_EMAC		5
+#define DAVINCI_LPSC_EMAC_WRAPPER	6
+#define DAVINCI_LPSC_USB		9
+#define DAVINCI_LPSC_ATA		10
+#define DAVINCI_LPSC_VLYNQ		11
+#define DAVINCI_LPSC_UHPI		12
+#define DAVINCI_LPSC_DDR_EMIF		13
+#define DAVINCI_LPSC_AEMIF		14
+#define DAVINCI_LPSC_MMC_SD		15
+#define DAVINCI_LPSC_McBSP		17
+#define DAVINCI_LPSC_I2C		18
+#define DAVINCI_LPSC_UART0		19
+#define DAVINCI_LPSC_UART1		20
+#define DAVINCI_LPSC_UART2		21
+#define DAVINCI_LPSC_SPI		22
+#define DAVINCI_LPSC_PWM0		23
+#define DAVINCI_LPSC_PWM1		24
+#define DAVINCI_LPSC_PWM2		25
+#define DAVINCI_LPSC_GPIO		26
+#define DAVINCI_LPSC_TIMER0		27
+#define DAVINCI_LPSC_TIMER1		28
+#define DAVINCI_LPSC_TIMER2		29
+#define DAVINCI_LPSC_SYSTEM_SUBSYS	30
+#define DAVINCI_LPSC_ARM		31
+#define DAVINCI_LPSC_SCR2		32
+#define DAVINCI_LPSC_SCR3		33
+#define DAVINCI_LPSC_SCR4		34
+#define DAVINCI_LPSC_CROSSBAR		35
+#define DAVINCI_LPSC_CFG27		36
+#define DAVINCI_LPSC_CFG3		37
+#define DAVINCI_LPSC_CFG5		38
+#define DAVINCI_LPSC_GEM		39
+#define DAVINCI_LPSC_IMCOP		40
+
+#define DM355_LPSC_TIMER3		5
+#define DM355_LPSC_SPI1			6
+#define DM355_LPSC_MMC_SD1		7
+#define DM355_LPSC_McBSP1		8
+#define DM355_LPSC_PWM3			10
+#define DM355_LPSC_SPI2			11
+#define DM355_LPSC_RTO			12
+#define DM355_LPSC_VPSS_DAC		41
+
+/* DM365 */
+#define DM365_LPSC_TIMER3		5
+#define DM365_LPSC_SPI1			6
+#define DM365_LPSC_MMC_SD1		7
+#define DM365_LPSC_McBSP1		8
+#define DM365_LPSC_PWM3			10
+#define DM365_LPSC_SPI2			11
+#define DM365_LPSC_RTO			12
+#define DM365_LPSC_TIMER4		17
+#define DM365_LPSC_SPI0			22
+#define DM365_LPSC_SPI3			38
+#define DM365_LPSC_SPI4			39
+#define DM365_LPSC_EMAC			40
+#define DM365_LPSC_VOICE_CODEC		44
+#define DM365_LPSC_DAC_CLK		46
+#define DM365_LPSC_VPSSMSTR		47
+#define DM365_LPSC_MJCP			50
+
+/*
+ * LPSC Assignments
+ */
+#define DM646X_LPSC_ARM			0
+#define DM646X_LPSC_C64X_CPU		1
+#define DM646X_LPSC_HDVICP0		2
+#define DM646X_LPSC_HDVICP1		3
+#define DM646X_LPSC_TPCC		4
+#define DM646X_LPSC_TPTC0		5
+#define DM646X_LPSC_TPTC1		6
+#define DM646X_LPSC_TPTC2		7
+#define DM646X_LPSC_TPTC3		8
+#define DM646X_LPSC_PCI			13
+#define DM646X_LPSC_EMAC		14
+#define DM646X_LPSC_VDCE		15
+#define DM646X_LPSC_VPSSMSTR		16
+#define DM646X_LPSC_VPSSSLV		17
+#define DM646X_LPSC_TSIF0		18
+#define DM646X_LPSC_TSIF1		19
+#define DM646X_LPSC_DDR_EMIF		20
+#define DM646X_LPSC_AEMIF		21
+#define DM646X_LPSC_McASP0		22
+#define DM646X_LPSC_McASP1		23
+#define DM646X_LPSC_CRGEN0		24
+#define DM646X_LPSC_CRGEN1		25
+#define DM646X_LPSC_UART0		26
+#define DM646X_LPSC_UART1		27
+#define DM646X_LPSC_UART2		28
+#define DM646X_LPSC_PWM0		29
+#define DM646X_LPSC_PWM1		30
+#define DM646X_LPSC_I2C			31
+#define DM646X_LPSC_SPI			32
+#define DM646X_LPSC_GPIO		33
+#define DM646X_LPSC_TIMER0		34
+#define DM646X_LPSC_TIMER1		35
+#define DM646X_LPSC_ARM_INTC		45
+
+/* PSC0 defines */
+#define DA8XX_LPSC0_TPCC		0
+#define DA8XX_LPSC0_TPTC0		1
+#define DA8XX_LPSC0_TPTC1		2
+#define DA8XX_LPSC0_EMIF25		3
+#define DA8XX_LPSC0_SPI0		4
+#define DA8XX_LPSC0_MMC_SD		5
+#define DA8XX_LPSC0_AINTC		6
+#define DA8XX_LPSC0_ARM_RAM_ROM		7
+#define DA8XX_LPSC0_SECU_MGR		8
+#define DA8XX_LPSC0_UART0		9
+#define DA8XX_LPSC0_SCR0_SS		10
+#define DA8XX_LPSC0_SCR1_SS		11
+#define DA8XX_LPSC0_SCR2_SS		12
+#define DA8XX_LPSC0_PRUSS		13
+#define DA8XX_LPSC0_ARM			14
+#define DA8XX_LPSC0_GEM			15
+
+/* PSC1 defines */
+#define DA850_LPSC1_TPCC1		0
+#define DA8XX_LPSC1_USB20		1
+#define DA8XX_LPSC1_USB11		2
+#define DA8XX_LPSC1_GPIO		3
+#define DA8XX_LPSC1_UHPI		4
+#define DA8XX_LPSC1_CPGMAC		5
+#define DA8XX_LPSC1_EMIF3C		6
+#define DA8XX_LPSC1_McASP0		7
+#define DA830_LPSC1_McASP1		8
+#define DA850_LPSC1_SATA		8
+#define DA830_LPSC1_McASP2		9
+#define DA8XX_LPSC1_SPI1		10
+#define DA8XX_LPSC1_I2C			11
+#define DA8XX_LPSC1_UART1		12
+#define DA8XX_LPSC1_UART2		13
+#define DA8XX_LPSC1_LCDC		16
+#define DA8XX_LPSC1_PWM			17
+#define DA850_LPSC1_MMC_SD1		18
+#define DA8XX_LPSC1_ECAP		20
+#define DA830_LPSC1_EQEP		21
+#define DA850_LPSC1_TPTC2		21
+#define DA8XX_LPSC1_SCR_P0_SS		24
+#define DA8XX_LPSC1_SCR_P1_SS		25
+#define DA8XX_LPSC1_CR_P3_SS		26
+#define DA8XX_LPSC1_L3_CBA_RAM		31
+
+/* TNETV107X LPSC Assignments */
+#define TNETV107X_LPSC_ARM		0
+#define TNETV107X_LPSC_GEM		1
+#define TNETV107X_LPSC_DDR2_PHY		2
+#define TNETV107X_LPSC_TPCC		3
+#define TNETV107X_LPSC_TPTC0		4
+#define TNETV107X_LPSC_TPTC1		5
+#define TNETV107X_LPSC_RAM		6
+#define TNETV107X_LPSC_MBX_LITE		7
+#define TNETV107X_LPSC_LCD		8
+#define TNETV107X_LPSC_ETHSS		9
+#define TNETV107X_LPSC_AEMIF		10
+#define TNETV107X_LPSC_CHIP_CFG		11
+#define TNETV107X_LPSC_TSC		12
+#define TNETV107X_LPSC_ROM		13
+#define TNETV107X_LPSC_UART2		14
+#define TNETV107X_LPSC_PKTSEC		15
+#define TNETV107X_LPSC_SECCTL		16
+#define TNETV107X_LPSC_KEYMGR		17
+#define TNETV107X_LPSC_KEYPAD		18
+#define TNETV107X_LPSC_GPIO		19
+#define TNETV107X_LPSC_MDIO		20
+#define TNETV107X_LPSC_SDIO0		21
+#define TNETV107X_LPSC_UART0		22
+#define TNETV107X_LPSC_UART1		23
+#define TNETV107X_LPSC_TIMER0		24
+#define TNETV107X_LPSC_TIMER1		25
+#define TNETV107X_LPSC_WDT_ARM		26
+#define TNETV107X_LPSC_WDT_DSP		27
+#define TNETV107X_LPSC_SSP		28
+#define TNETV107X_LPSC_TDM0		29
+#define TNETV107X_LPSC_VLYNQ		30
+#define TNETV107X_LPSC_MCDMA		31
+#define TNETV107X_LPSC_USB0		32
+#define TNETV107X_LPSC_TDM1		33
+#define TNETV107X_LPSC_DEBUGSS		34
+#define TNETV107X_LPSC_ETHSS_RGMII	35
+#define TNETV107X_LPSC_SYSTEM		36
+#define TNETV107X_LPSC_IMCOP		37
+#define TNETV107X_LPSC_SPARE		38
+#define TNETV107X_LPSC_SDIO1		39
+#define TNETV107X_LPSC_USB1		40
+#define TNETV107X_LPSC_USBSS		41
+#define TNETV107X_LPSC_DDR2_EMIF1_VRST		42
+#define TNETV107X_LPSC_DDR2_EMIF2_VCTL_RST	43
+#define TNETV107X_LPSC_MAX			44
+#endif /* __DAVINCI_PSC_H */
-- 
1.7.9.5

