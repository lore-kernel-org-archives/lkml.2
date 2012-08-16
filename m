Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2HPCRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 22:17:24 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:38166 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673Ab2HPCRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 22:17:06 -0400
From: Chao Xie <xiechao.mail@gmail.com>
To: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, chao.xie@marvell.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.or,
        arnd@arndb.de
Cc: Chao Xie <xiechao.mail@gmail.com>
Subject: [PATCH V2 4/5] clk: mmp: add clock definition for mmp2
Date: Thu, 16 Aug 2012 10:20:24 +0800
Message-Id: <1345083625-3041-5-git-send-email-xiechao.mail@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1345083625-3041-1-git-send-email-xiechao.mail@gmail.com>
References: <1345083625-3041-1-git-send-email-xiechao.mail@gmail.com>
X-OriginalArrivalTime: 16 Aug 2012 02:16:42.0204 (UTC) FILETIME=[2D0F81C0:01CD7B55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

Initialize the clocks for mmp2

Signed-off-by: Chao Xie <xiechao.mail@gmail.com>
---
 drivers/clk/mmp/Makefile   |    1 +
 drivers/clk/mmp/clk-mmp2.c |  544 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 545 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/mmp/clk-mmp2.c

diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index 6160ac2..392d780 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -6,3 +6,4 @@ obj-y += clk-apbc.o clk-apmu.o clk-frac.o
 
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
 obj-$(CONFIG_CPU_PXA910) += clk-pxa910.o
+obj-$(CONFIG_CPU_MMP2) += clk-mmp2.o
diff --git a/drivers/clk/mmp/clk-mmp2.c b/drivers/clk/mmp/clk-mmp2.c
new file mode 100644
index 0000000..410e6a6
--- /dev/null
+++ b/drivers/clk/mmp/clk-mmp2.c
@@ -0,0 +1,544 @@
+/*
+ * pxa168 clock framework source file
+ *
+ * Copyright (C) 2012 Marvell
+ * Chao Xie <xiechao.mail@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+
+#include <mach/addr-map.h>
+
+#include "clk.h"
+
+#define APBC_RTC	0x0
+#define APBC_TWSI0	0x4
+#define APBC_TWSI1	0x8
+#define APBC_TWSI2	0xc
+#define APBC_TWSI3	0x10
+#define APBC_TWSI4	0x7c
+#define APBC_TWSI5	0x80
+#define APBC_KPC	0x18
+#define APBC_UART0	0x2c
+#define APBC_UART1	0x30
+#define APBC_UART2	0x34
+#define APBC_UART3	0x88
+#define APBC_GPIO	0x38
+#define APBC_PWM0	0x3c
+#define APBC_PWM1	0x40
+#define APBC_PWM2	0x44
+#define APBC_PWM3	0x48
+#define APBC_SSP0	0x50
+#define APBC_SSP1	0x54
+#define APBC_SSP2	0x58
+#define APBC_SSP3	0x5c
+#define APMU_SDH0	0x54
+#define APMU_SDH1	0x58
+#define APMU_SDH2	0xe8
+#define APMU_SDH3	0xec
+#define APMU_USB	0x5c
+#define APMU_DISP0	0x4c
+#define APMU_DISP1	0x110
+#define APMU_CCIC0	0x50
+#define APMU_CCIC1	0xf4
+#define MPMU_UART_PLL	0x14
+
+static DEFINE_SPINLOCK(clk_lock);
+
+enum {
+	clk32, vctcxo, pll1, usb_pll, pll2, pll1_2, pll1_4, pll1_8, pll1_16,
+	pll1_20, pll1_3, pll1_6, pll1_12, pll2_2, pll2_4, pll2_8, pll2_16,
+	pll2_3, pll2_6, pll2_12, vctcxo_2, vctcxo_4, uart_pll, twsi0, twsi1,
+	twsi2, twsi3, twsi4, twsi5, gpio, kpc, rtc, pwm0, pwm1, pwm2, pwm3,
+	uart0_mux, uart0, uart1_mux, uart1, uart2_mux, uart2, uart3_mux,
+	uart3, ssp0_mux, ssp0, ssp1_mux, ssp1, ssp2_mux, ssp2, ssp3_mux,
+	ssp3, sdh_mux, sdh_div, sdh0, sdh1, sdh2, sdh3, usb, disp0_mux,
+	disp0_div, disp0, disp0_sphy_div, disp0_sphy, disp1_mux, disp1_div,
+	disp1, ccic_arbiter, ccic0_mux, ccic0_div, ccic0, ccic0_phy,
+	ccic0_sphy_div, ccic0_sphy, ccic1_mux, ccic1_div, ccic1, ccic1_phy,
+	ccic1_sphy_div, ccic1_sphy, clk_max
+};
+
+static struct clk_factor_masks uart_factor_masks = {
+	.factor = 2,
+	.num_mask = 0x1fff,
+	.den_mask = 0x1fff,
+	.num_shift = 16,
+	.den_shift = 0,
+};
+
+static struct clk_factor_tbl uart_factor_tbl[] = {
+	{.num = 14634, .den = 2165},	/*14.745MHZ */
+	{.num = 3521, .den = 689},	/*19.23MHZ */
+	{.num = 9679, .den = 5728},	/*58.9824MHZ */
+	{.num = 15850, .den = 9451},	/*59.429MHZ */
+};
+
+static const char *uart_parent[] = {"uart_pll", "vctcxo"};
+static const char *ssp_parent[] =
+	{"vctcxo_4", "vctcxo_2", "vctcxo", "pll1_16"};
+static const char *sdh_parent[] = {"pll1_4", "pll2", "usb_pll", "pll1"};
+static const char *disp_parent[] = {"pll1", "pll1_16", "pll2", "vctcxo"};
+static const char *ccic_parent[] = {"pll1_2", "pll1_16", "vctcxo"};
+
+void __init mmp2_clk_init(void)
+{
+	struct clk *clocks[clk_max];
+	void __iomem *mpmu_base;
+	void __iomem *apmu_base;
+	void __iomem *apbc_base;
+
+	mpmu_base = ioremap(APB_PHYS_BASE + 0x50000, SZ_4K);
+	if (mpmu_base == NULL) {
+		pr_err("error to ioremap MPMU base\n");
+		return;
+	}
+
+	apmu_base = ioremap(AXI_PHYS_BASE + 0x82800, SZ_4K);
+	if (apmu_base == NULL) {
+		pr_err("error to ioremap APMU base\n");
+		return;
+	}
+
+	apbc_base = ioremap(APB_PHYS_BASE + 0x15000, SZ_4K);
+	if (apbc_base == NULL) {
+		pr_err("error to ioremap APBC base\n");
+		return;
+	}
+
+	clocks[clk32] =
+	    clk_register_fixed_rate(NULL, "clk32", NULL, CLK_IS_ROOT, 3200);
+	clk_register_clkdev(clocks[clk32], "clk32", NULL);
+
+	clocks[vctcxo] =
+	    clk_register_fixed_rate(NULL, "vctcxo", NULL, CLK_IS_ROOT,
+				    26000000);
+	clk_register_clkdev(clocks[vctcxo], "vctcxo", NULL);
+
+	clocks[pll1] =
+	    clk_register_fixed_rate(NULL, "pll1", NULL, CLK_IS_ROOT, 800000000);
+	clk_register_clkdev(clocks[pll1], "pll1", NULL);
+
+	clocks[usb_pll] =
+	    clk_register_fixed_rate(NULL, "usb_pll", NULL, CLK_IS_ROOT,
+				    480000000);
+	clk_register_clkdev(clocks[usb_pll], "usb_pll", NULL);
+
+	clocks[pll2] =
+	    clk_register_fixed_rate(NULL, "pll2", NULL, CLK_IS_ROOT, 960000000);
+	clk_register_clkdev(clocks[pll2], "pll2", NULL);
+
+	clocks[pll1_2] =
+	    clk_register_fixed_factor(NULL, "pll1_2", "pll1",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[pll1_2], "pll1_2", NULL);
+
+	clocks[pll1_4] =
+	    clk_register_fixed_factor(NULL, "pll1_4", "pll1_2",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[pll1_4], "pll1_4", NULL);
+
+	clocks[pll1_8] =
+	    clk_register_fixed_factor(NULL, "pll1_8", "pll1_4",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[pll1_8], "pll1_8", NULL);
+
+	clocks[pll1_16] =
+	    clk_register_fixed_factor(NULL, "pll1_16", "pll1_8",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[pll1_16], "pll1_16", NULL);
+
+	clocks[pll1_20] =
+	    clk_register_fixed_factor(NULL, "pll1_20", "pll1_4",
+				      CLK_SET_RATE_PARENT, 1, 5);
+	clk_register_clkdev(clocks[pll1_20], "pll1_20", NULL);
+
+	clocks[pll1_3] =
+	    clk_register_fixed_factor(NULL, "pll1_3", "pll1",
+				      CLK_SET_RATE_PARENT, 1, 3);
+	clk_register_clkdev(clocks[pll1_3], "pll1_3", NULL);
+
+	clocks[pll1_6] =
+	    clk_register_fixed_factor(NULL, "pll1_6", "pll1_3",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[pll1_6], "pll1_6", NULL);
+
+	clocks[pll1_12] =
+	    clk_register_fixed_factor(NULL, "pll1_12", "pll1_6",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[pll1_12], "pll1_12", NULL);
+
+	clocks[pll2_2] =
+	    clk_register_fixed_factor(NULL, "pll2_2", "pll2",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[pll2_2], "pll2_2", NULL);
+
+	clocks[pll2_4] =
+	    clk_register_fixed_factor(NULL, "pll2_4", "pll2_2",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[pll2_4], "pll2_4", NULL);
+
+	clocks[pll2_8] =
+	    clk_register_fixed_factor(NULL, "pll2_8", "pll2_4",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[pll2_8], "pll2_8", NULL);
+
+	clocks[pll2_16] =
+	    clk_register_fixed_factor(NULL, "pll2_16", "pll2_8",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[pll2_16], "pll2_16", NULL);
+
+	clocks[pll2_3] =
+	    clk_register_fixed_factor(NULL, "pll2_3", "pll2",
+				      CLK_SET_RATE_PARENT, 1, 3);
+	clk_register_clkdev(clocks[pll2_3], "pll2_3", NULL);
+
+	clocks[pll2_6] =
+	    clk_register_fixed_factor(NULL, "pll2_6", "pll2_3",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[pll2_6], "pll2_6", NULL);
+
+	clocks[pll2_12] =
+	    clk_register_fixed_factor(NULL, "pll2_12", "pll2_6",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[pll2_12], "pll2_12", NULL);
+
+	clocks[vctcxo_2] =
+	    clk_register_fixed_factor(NULL, "vctcxo_2", "vctcxo",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[vctcxo_2], "vctcxo_2", NULL);
+
+	clocks[vctcxo_4] =
+	    clk_register_fixed_factor(NULL, "vctcxo_4", "vctcxo_2",
+				      CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clocks[vctcxo_4], "vctcxo_4", NULL);
+
+	clocks[uart_pll] =
+	    mmp_clk_register_factor("uart_pll", "pll1_4", 0,
+				    mpmu_base + MPMU_UART_PLL,
+				    &uart_factor_masks, uart_factor_tbl,
+				    ARRAY_SIZE(uart_factor_tbl));
+	clk_set_rate(clocks[uart_pll], 14745600);
+	clk_register_clkdev(clocks[uart_pll], "uart_pll", NULL);
+
+	clocks[twsi0] =
+	    mmp_clk_register_apbc("twsi0", "vctcxo", apbc_base + APBC_TWSI0, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[twsi0], NULL, "pxa2xx-i2c.0");
+
+	clocks[twsi1] =
+	    mmp_clk_register_apbc("twsi1", "vctcxo", apbc_base + APBC_TWSI1, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[twsi1], NULL, "pxa2xx-i2c.1");
+
+	clocks[twsi2] =
+	    mmp_clk_register_apbc("twsi2", "vctcxo", apbc_base + APBC_TWSI2, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[twsi2], NULL, "pxa2xx-i2c.2");
+
+	clocks[twsi3] =
+	    mmp_clk_register_apbc("twsi3", "vctcxo", apbc_base + APBC_TWSI3, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[twsi3], NULL, "pxa2xx-i2c.3");
+
+	clocks[twsi4] =
+	    mmp_clk_register_apbc("twsi4", "vctcxo", apbc_base + APBC_TWSI4, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[twsi4], NULL, "pxa2xx-i2c.4");
+
+	clocks[twsi5] =
+	    mmp_clk_register_apbc("twsi5", "vctcxo", apbc_base + APBC_TWSI5, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[twsi5], NULL, "pxa2xx-i2c.5");
+
+	clocks[gpio] =
+	    mmp_clk_register_apbc("gpio", "vctcxo", apbc_base + APBC_GPIO, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[gpio], NULL, "pxa-gpio");
+
+	clocks[kpc] =
+	    mmp_clk_register_apbc("kpc", "clk32", apbc_base + APBC_KPC, 10, 0,
+				  &clk_lock);
+	clk_register_clkdev(clocks[kpc], NULL, "pxa27x-keypad");
+
+	clocks[rtc] =
+	    mmp_clk_register_apbc("rtc", "clk32", apbc_base + APBC_RTC, 10, 0,
+				  &clk_lock);
+	clk_register_clkdev(clocks[rtc], NULL, "mmp-rtc");
+
+	clocks[pwm0] =
+	    mmp_clk_register_apbc("pwm0", "vctcxo", apbc_base + APBC_PWM0, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[pwm0], NULL, "mmp2-pwm.0");
+
+	clocks[pwm1] =
+	    mmp_clk_register_apbc("pwm1", "vctcxo", apbc_base + APBC_PWM1, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[pwm1], NULL, "mmp2-pwm.1");
+
+	clocks[pwm2] =
+	    mmp_clk_register_apbc("pwm2", "vctcxo", apbc_base + APBC_PWM2, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[pwm2], NULL, "mmp2-pwm.2");
+
+	clocks[pwm3] =
+	    mmp_clk_register_apbc("pwm3", "vctcxo", apbc_base + APBC_PWM3, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[pwm3], NULL, "mmp2-pwm.3");
+
+	clocks[uart0_mux] =
+	    clk_register_mux(NULL, "uart0_mux", uart_parent,
+			     ARRAY_SIZE(uart_parent), CLK_SET_RATE_PARENT,
+			     apbc_base + APBC_UART0, 4, 3, 0, &clk_lock);
+	clk_set_parent(clocks[uart0_mux], clocks[vctcxo]);
+	clk_register_clkdev(clocks[uart0_mux], "uart_mux.0", NULL);
+
+	clocks[uart0] =
+	    mmp_clk_register_apbc("uart0", "uart0_mux", apbc_base + APBC_UART0,
+				  10, 0, &clk_lock);
+	clk_register_clkdev(clocks[uart0], NULL, "pxa2xx-uart.0");
+
+	clocks[uart1_mux] =
+	    clk_register_mux(NULL, "uart1_mux", uart_parent,
+			     ARRAY_SIZE(uart_parent), CLK_SET_RATE_PARENT,
+			     apbc_base + APBC_UART1, 4, 3, 0, &clk_lock);
+	clk_set_parent(clocks[uart1_mux], clocks[vctcxo]);
+	clk_register_clkdev(clocks[uart1_mux], "uart_mux.1", NULL);
+
+	clocks[uart1] =
+	    mmp_clk_register_apbc("uart1", "uart1_mux", apbc_base + APBC_UART1,
+				  10, 0, &clk_lock);
+	clk_register_clkdev(clocks[uart1], NULL, "pxa2xx-uart.1");
+
+	clocks[uart2_mux] =
+	    clk_register_mux(NULL, "uart2_mux", uart_parent,
+			     ARRAY_SIZE(uart_parent), CLK_SET_RATE_PARENT,
+			     apbc_base + APBC_UART2, 4, 3, 0, &clk_lock);
+	clk_set_parent(clocks[uart2_mux], clocks[vctcxo]);
+	clk_register_clkdev(clocks[uart2_mux], "uart_mux.2", NULL);
+
+	clocks[uart2] =
+	    mmp_clk_register_apbc("uart2", "uart2_mux", apbc_base + APBC_UART2,
+				  10, 0, &clk_lock);
+	clk_register_clkdev(clocks[uart2], NULL, "pxa2xx-uart.2");
+
+	clocks[uart3_mux] =
+	    clk_register_mux(NULL, "uart3_mux", uart_parent,
+			     ARRAY_SIZE(uart_parent), CLK_SET_RATE_PARENT,
+			     apbc_base + APBC_UART3, 4, 3, 0, &clk_lock);
+	clk_set_parent(clocks[uart3_mux], clocks[vctcxo]);
+	clk_register_clkdev(clocks[uart3_mux], "uart_mux.3", NULL);
+
+	clocks[uart3] =
+	    mmp_clk_register_apbc("uart3", "uart3_mux", apbc_base + APBC_UART3,
+				  10, 0, &clk_lock);
+	clk_register_clkdev(clocks[uart3], NULL, "pxa2xx-uart.3");
+
+	clocks[ssp0_mux] =
+	    clk_register_mux(NULL, "ssp0_mux", ssp_parent,
+			     ARRAY_SIZE(ssp_parent), CLK_SET_RATE_PARENT,
+			     apbc_base + APBC_SSP0, 4, 3, 0, &clk_lock);
+	clk_register_clkdev(clocks[ssp0_mux], "uart_mux.0", NULL);
+
+	clocks[ssp0] =
+	    mmp_clk_register_apbc("ssp0", "ssp0_mux", apbc_base + APBC_SSP0, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[ssp0], NULL, "mmp-ssp.0");
+
+	clocks[ssp1_mux] =
+	    clk_register_mux(NULL, "ssp1_mux", ssp_parent,
+			     ARRAY_SIZE(ssp_parent), CLK_SET_RATE_PARENT,
+			     apbc_base + APBC_SSP1, 4, 3, 0, &clk_lock);
+	clk_register_clkdev(clocks[ssp1_mux], "ssp_mux.1", NULL);
+
+	clocks[ssp1] =
+	    mmp_clk_register_apbc("ssp1", "ssp1_mux", apbc_base + APBC_SSP1, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[ssp1], NULL, "mmp-ssp.1");
+
+	clocks[ssp2_mux] =
+	    clk_register_mux(NULL, "ssp2_mux", ssp_parent,
+			     ARRAY_SIZE(ssp_parent), CLK_SET_RATE_PARENT,
+			     apbc_base + APBC_SSP2, 4, 3, 0, &clk_lock);
+	clk_register_clkdev(clocks[ssp2_mux], "ssp_mux.2", NULL);
+
+	clocks[ssp2] =
+	    mmp_clk_register_apbc("ssp2", "ssp2_mux", apbc_base + APBC_SSP2, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[ssp2], NULL, "mmp-ssp.2");
+
+	clocks[ssp3_mux] =
+	    clk_register_mux(NULL, "ssp3_mux", ssp_parent,
+			     ARRAY_SIZE(ssp_parent), CLK_SET_RATE_PARENT,
+			     apbc_base + APBC_SSP3, 4, 3, 0, &clk_lock);
+	clk_register_clkdev(clocks[ssp3_mux], "ssp_mux.3", NULL);
+
+	clocks[ssp3] =
+	    mmp_clk_register_apbc("ssp3", "ssp3_mux", apbc_base + APBC_SSP3, 10,
+				  0, &clk_lock);
+	clk_register_clkdev(clocks[ssp3], NULL, "mmp-ssp.3");
+
+	clocks[sdh_mux] =
+	    clk_register_mux(NULL, "sdh_mux", sdh_parent,
+			     ARRAY_SIZE(sdh_parent), CLK_SET_RATE_PARENT,
+			     apmu_base + APMU_SDH0, 8, 2, 0, &clk_lock);
+	clk_register_clkdev(clocks[sdh_mux], "sdh_mux", NULL);
+
+	clocks[sdh_div] =
+	    clk_register_divider(NULL, "sdh_div", "sdh_mux",
+				 CLK_SET_RATE_PARENT, apmu_base + APMU_SDH0, 10,
+				 4, CLK_DIVIDER_ONE_BASED, &clk_lock);
+	clk_register_clkdev(clocks[sdh_div], "sdh_div", NULL);
+
+	clocks[sdh0] =
+	    mmp_clk_register_apmu("sdh0", "sdh_div", apmu_base + APMU_SDH0,
+				  0x1b, &clk_lock);
+	clk_register_clkdev(clocks[sdh0], NULL, "sdhci-pxav3.0");
+
+	clocks[sdh1] =
+	    mmp_clk_register_apmu("sdh1", "sdh_div", apmu_base + APMU_SDH1,
+				  0x1b, &clk_lock);
+	clk_register_clkdev(clocks[sdh1], NULL, "sdhci-pxav3.1");
+
+	clocks[sdh2] =
+	    mmp_clk_register_apmu("sdh2", "sdh_div", apmu_base + APMU_SDH2,
+				  0x1b, &clk_lock);
+	clk_register_clkdev(clocks[sdh2], NULL, "sdhci-pxav3.2");
+
+	clocks[sdh3] =
+	    mmp_clk_register_apmu("sdh3", "sdh_div", apmu_base + APMU_SDH3,
+				  0x1b, &clk_lock);
+	clk_register_clkdev(clocks[sdh3], NULL, "sdhci-pxav3.3");
+
+	clocks[usb] =
+	    mmp_clk_register_apmu("usb", "usb_pll", apmu_base + APMU_USB, 0x9,
+				  &clk_lock);
+	clk_register_clkdev(clocks[usb], "usb_clk", NULL);
+
+	clocks[disp0_mux] =
+	    clk_register_mux(NULL, "disp0_mux", disp_parent,
+			     ARRAY_SIZE(disp_parent), CLK_SET_RATE_PARENT,
+			     apmu_base + APMU_DISP0, 6, 2, 0, &clk_lock);
+	clk_register_clkdev(clocks[disp0_mux], "disp_mux.0", NULL);
+
+	clocks[disp0_div] =
+	    clk_register_divider(NULL, "disp0_div", "disp0_mux",
+				 CLK_SET_RATE_PARENT, apmu_base + APMU_DISP0, 8,
+				 4, CLK_DIVIDER_ONE_BASED, &clk_lock);
+	clk_register_clkdev(clocks[disp0_div], "disp_div.0", NULL);
+
+	clocks[disp0] =
+	    mmp_clk_register_apmu("disp0", "disp0_div", apmu_base + APMU_DISP0,
+				  0x1b, &clk_lock);
+	clk_register_clkdev(clocks[disp0], NULL, "mmp-disp.0");
+
+	clocks[disp0_sphy_div] =
+	    clk_register_divider(NULL, "disp0_sphy_div", "disp0_mux", 0,
+				 apmu_base + APMU_DISP0, 15, 5, 0, &clk_lock);
+	clk_register_clkdev(clocks[disp0_sphy_div], "disp_sphy_div.0", NULL);
+
+	clocks[disp0_sphy] =
+	    mmp_clk_register_apmu("disp0_sphy", "disp0_sphy_div",
+				  apmu_base + APMU_DISP0, 0x1024, &clk_lock);
+	clk_register_clkdev(clocks[disp0_sphy], "disp_sphy.0", NULL);
+
+	clocks[disp1_mux] =
+	    clk_register_mux(NULL, "disp1_mux", disp_parent,
+			     ARRAY_SIZE(disp_parent), CLK_SET_RATE_PARENT,
+			     apmu_base + APMU_DISP1, 6, 2, 0, &clk_lock);
+	clk_register_clkdev(clocks[disp1_mux], "disp_mux.1", NULL);
+
+	clocks[disp1_div] =
+	    clk_register_divider(NULL, "disp1_div", "disp1_mux",
+				 CLK_SET_RATE_PARENT, apmu_base + APMU_DISP1, 8,
+				 4, CLK_DIVIDER_ONE_BASED, &clk_lock);
+	clk_register_clkdev(clocks[disp1_div], "disp_div.1", NULL);
+
+	clocks[disp1] =
+	    mmp_clk_register_apmu("disp1", "disp1_div", apmu_base + APMU_DISP1,
+				  0x1b, &clk_lock);
+	clk_register_clkdev(clocks[disp1], NULL, "mmp-disp.1");
+
+	clocks[ccic_arbiter] =
+	    mmp_clk_register_apmu("ccic_arbiter", "vctcxo",
+				  apmu_base + APMU_CCIC0, 0x1800, &clk_lock);
+	clk_register_clkdev(clocks[ccic_arbiter], "ccic_arbiter", NULL);
+
+	clocks[ccic0_mux] =
+	    clk_register_mux(NULL, "ccic0_mux", ccic_parent,
+			     ARRAY_SIZE(ccic_parent), CLK_SET_RATE_PARENT,
+			     apmu_base + APMU_CCIC0, 6, 2, 0, &clk_lock);
+	clk_register_clkdev(clocks[ccic0_mux], "ccic_mux.0", NULL);
+
+	clocks[ccic0_div] =
+	    clk_register_divider(NULL, "ccic0_div", "ccic0_mux",
+				 CLK_SET_RATE_PARENT, apmu_base + APMU_CCIC0,
+				 17, 4, CLK_DIVIDER_ONE_BASED, &clk_lock);
+	clk_register_clkdev(clocks[ccic0_div], "ccic_div.0", NULL);
+
+	clocks[ccic0] =
+	    mmp_clk_register_apmu("ccic0", "ccic0_div", apmu_base + APMU_CCIC0,
+				  0x1b, &clk_lock);
+	clk_register_clkdev(clocks[ccic0], "fnclk", "mmp-ccic.0");
+
+	clocks[ccic0_phy] =
+	    mmp_clk_register_apmu("ccic0_phy", "ccic0_div",
+				  apmu_base + APMU_CCIC0, 0x24, &clk_lock);
+	clk_register_clkdev(clocks[ccic0_phy], "phyclk", "mmp-ccic.0");
+
+	clocks[ccic0_sphy_div] =
+	    clk_register_divider(NULL, "ccic0_sphy_div", "ccic0_div",
+				 CLK_SET_RATE_PARENT, apmu_base + APMU_CCIC0,
+				 10, 5, 0, &clk_lock);
+	clk_register_clkdev(clocks[ccic0_sphy_div], "sphyclk_div",
+			    "mmp-ccic.0");
+
+	clocks[ccic0_sphy] =
+	    mmp_clk_register_apmu("ccic0_sphy", "ccic0_sphy_div",
+				  apmu_base + APMU_CCIC0, 0x300, &clk_lock);
+	clk_register_clkdev(clocks[ccic0_sphy], "sphyclk", "mmp-ccic.0");
+
+	clocks[ccic1_mux] =
+	    clk_register_mux(NULL, "ccic1_mux", ccic_parent,
+			     ARRAY_SIZE(ccic_parent), CLK_SET_RATE_PARENT,
+			     apmu_base + APMU_CCIC1, 6, 2, 0, &clk_lock);
+	clk_register_clkdev(clocks[ccic1_mux], "ccic_mux.1", NULL);
+
+	clocks[ccic1_div] =
+	    clk_register_divider(NULL, "ccic1_div", "ccic1_mux",
+				 CLK_SET_RATE_PARENT, apmu_base + APMU_CCIC1,
+				 16, 4, CLK_DIVIDER_ONE_BASED, &clk_lock);
+	clk_register_clkdev(clocks[ccic1_div], "ccic_div.1", NULL);
+
+	clocks[ccic1] =
+	    mmp_clk_register_apmu("ccic1", "ccic1_div", apmu_base + APMU_CCIC1,
+				  0x1b, &clk_lock);
+	clk_register_clkdev(clocks[ccic1], "fnclk", "mmp-ccic.1");
+
+	clocks[ccic1_phy] =
+	    mmp_clk_register_apmu("ccic1_phy", "ccic1_div",
+				  apmu_base + APMU_CCIC1, 0x24, &clk_lock);
+	clk_register_clkdev(clocks[ccic1_phy], "phyclk", "mmp-ccic.1");
+
+	clocks[ccic1_sphy_div] =
+	    clk_register_divider(NULL, "ccic1_sphy_div", "ccic1_div",
+				 CLK_SET_RATE_PARENT, apmu_base + APMU_CCIC1,
+				 10, 5, 0, &clk_lock);
+	clk_register_clkdev(clocks[ccic1_sphy_div], "sphyclk_div",
+			    "mmp-ccic.1");
+
+	clocks[ccic1_sphy] =
+	    mmp_clk_register_apmu("ccic1_sphy", "ccic1_sphy_div",
+				  apmu_base + APMU_CCIC1, 0x300, &clk_lock);
+	clk_register_clkdev(clocks[ccic1_sphy], "sphyclk", "mmp-ccic.1");
+
+}
-- 
1.7.0.4

