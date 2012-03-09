Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab2CIJTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 04:19:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50179 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2CIJTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:19:42 -0500
Date: Fri, 9 Mar 2012 10:19:12 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Mike Turquette <mturquette@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        linaro-dev@lists.linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH v5 0/4] common clk framework
Message-ID: <20120309091912.GD26882@pengutronix.de>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <20120309023418.GF3261@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309023418.GF3261@b20223-02.ap.freescale.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:15:06 up 117 days, 17:02, 36 users,  load average: 0.10, 0.13,
 0.09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Fri, Mar 09, 2012 at 10:34:19AM +0800, Richard Zhao wrote:
> Hello Mike,
> 
> The main interface for clk implementer is to register clocks dynamically.
> I think it highly depends on clk DT bindings. From the patch Grant sent
> out, it looks like he doesn't like one node per clk. So how do we
> register clocks dynamically? You have any sample code?

Find my current work based on this series here:

git://git.pengutronix.de/git/imx/linux-2.6.git work/imx-clkv5

This implements the generic clock support for the i.MX v4/v5 based
SoCs. i.MX1 and i.MX27 are runtime tested, i.MX21/25 are compile
tested only.

A typical clock file will then look like this, here the i.MX27
implementation:

8<-------------------------------------------------------


ARM i.MX27: implement clocks using common clock framework

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-imx/Makefile    |    2 +-
 arch/arm/mach-imx/clk-imx27.c |  227 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 228 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-imx/clk-imx27.c

diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index d96e2ce..b39f2d6 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_SOC_IMX21) += clk-imx21.o mm-imx21.o
 obj-$(CONFIG_SOC_IMX25) += clk-imx25.o mm-imx25.o ehci-imx25.o cpu-imx25.o
 
 obj-$(CONFIG_SOC_IMX27) += cpu-imx27.o pm-imx27.o
-obj-$(CONFIG_SOC_IMX27) += clock-imx27.o mm-imx27.o ehci-imx27.o
+obj-$(CONFIG_SOC_IMX27) += clk-imx27.o mm-imx27.o ehci-imx27.o
 
 obj-$(CONFIG_SOC_IMX31) += mm-imx3.o cpu-imx31.o clock-imx31.o iomux-imx31.o ehci-imx31.o
 obj-$(CONFIG_SOC_IMX35) += mm-imx3.o cpu-imx35.o clock-imx35.o ehci-imx35.o
diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
new file mode 100644
index 0000000..f54e4ee
--- /dev/null
+++ b/arch/arm/mach-imx/clk-imx27.c
@@ -0,0 +1,227 @@
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+
+#include <asm/div64.h>
+
+#include <mach/common.h>
+#include <mach/hardware.h>
+#include "clk.h"
+
+#define IO_ADDR_CCM(off)	(MX27_IO_ADDRESS(MX27_CCM_BASE_ADDR + (off)))
+
+/* Register offsets */
+#define CCM_CSCR		IO_ADDR_CCM(0x0)
+#define CCM_MPCTL0		IO_ADDR_CCM(0x4)
+#define CCM_MPCTL1		IO_ADDR_CCM(0x8)
+#define CCM_SPCTL0		IO_ADDR_CCM(0xc)
+#define CCM_SPCTL1		IO_ADDR_CCM(0x10)
+#define CCM_OSC26MCTL		IO_ADDR_CCM(0x14)
+#define CCM_PCDR0		IO_ADDR_CCM(0x18)
+#define CCM_PCDR1		IO_ADDR_CCM(0x1c)
+#define CCM_PCCR0		IO_ADDR_CCM(0x20)
+#define CCM_PCCR1		IO_ADDR_CCM(0x24)
+#define CCM_CCSR		IO_ADDR_CCM(0x28)
+#define CCM_PMCTL		IO_ADDR_CCM(0x2c)
+#define CCM_PMCOUNT		IO_ADDR_CCM(0x30)
+#define CCM_WKGDCTL		IO_ADDR_CCM(0x34)
+
+#define CCM_CSCR_UPDATE_DIS	(1 << 31)
+#define CCM_CSCR_SSI2		(1 << 23)
+#define CCM_CSCR_SSI1		(1 << 22)
+#define CCM_CSCR_VPU		(1 << 21)
+#define CCM_CSCR_MSHC           (1 << 20)
+#define CCM_CSCR_SPLLRES        (1 << 19)
+#define CCM_CSCR_MPLLRES        (1 << 18)
+#define CCM_CSCR_SP             (1 << 17)
+#define CCM_CSCR_MCU            (1 << 16)
+#define CCM_CSCR_OSC26MDIV      (1 << 4)
+#define CCM_CSCR_OSC26M         (1 << 3)
+#define CCM_CSCR_FPM            (1 << 2)
+#define CCM_CSCR_SPEN           (1 << 1)
+#define CCM_CSCR_MPEN           (1 << 0)
+
+/* i.MX27 TO 2+ */
+#define CCM_CSCR_ARM_SRC        (1 << 15)
+
+#define CCM_SPCTL1_LF           (1 << 15)
+#define CCM_SPCTL1_BRMO         (1 << 6)
+
+static char *vpu_sel_clks[] = { "spll", "mpll_main2", };
+static char *cpu_sel_clks[] = { "mpll_main2", "mpll", };
+
+struct clkl {
+	struct clk_lookup lookup;
+	const char *clkname;
+};
+
+#define clkdev(d, n, c) \
+	{ \
+		.lookup.dev_id = d, \
+		.lookup.con_id = n, \
+		.clkname = c, \
+	},
+
+static struct clkl lookups[] = {
+	clkdev("imx21-uart.0", "ipg", "uart1_ipg_gate")
+	clkdev("imx21-uart.0", "per", "per1_gate")
+	clkdev("imx21-uart.1", "ipg", "uart2_ipg_gate")
+	clkdev("imx21-uart.1", "per", "per1_gate")
+	clkdev("imx21-uart.2", "ipg", "uart3_ipg_gate")
+	clkdev("imx21-uart.2", "per", "per1_gate")
+	clkdev("imx21-uart.3", "ipg", "uart4_ipg_gate")
+	clkdev("imx21-uart.3", "per", "per1_gate")
+	clkdev("imx21-uart.4", "ipg", "uart5_ipg_gate")
+	clkdev("imx21-uart.4", "per", "per1_gate")
+	clkdev("imx21-uart.5", "ipg", "uart6_ipg_gate")
+	clkdev("imx21-uart.5", "per", "per1_gate")
+	clkdev("imx-gpt.0", "ipg", "gpt1_ipg_gate")
+	clkdev("imx-gpt.0", "per", "per1_gate")
+	clkdev("imx-gpt.1", "ipg", "gpt2_ipg_gate")
+	clkdev("imx-gpt.1", "per", "per1_gate")
+	clkdev("imx-gpt.2", "ipg", "gpt3_ipg_gate")
+	clkdev("imx-gpt.2", "per", "per1_gate")
+	clkdev("imx-gpt.3", "ipg", "gpt4_ipg_gate")
+	clkdev("imx-gpt.3", "per", "per1_gate")
+	clkdev("imx-gpt.4", "ipg", "gpt5_ipg_gate")
+	clkdev("imx-gpt.4", "per", "per1_gate")
+	clkdev("imx-gpt.5", "ipg", "gpt6_ipg_gate")
+	clkdev("imx-gpt.5", "per", "per1_gate")
+	clkdev("mxc_pwm.0", NULL, "pwm")
+	clkdev("mxc-mmc.0", "per", "per2_gate")
+	clkdev("mxc-mmc.0", "ipg", "sdhc1_ipg_gate")
+	clkdev("mxc-mmc.1", "per", "per2_gate")
+	clkdev("mxc-mmc.1", "ipg", "sdhc2_ipg_gate")
+	clkdev("mxc-mmc.2", "per", "per2_gate")
+	clkdev("mxc-mmc.2", "ipg", "sdhc2_ipg_gate")
+	clkdev("imx27-cspi.0", NULL, "cspi1")
+	clkdev("imx27-cspi.1", NULL, "cspi2")
+	clkdev("imx27-cspi.2", NULL, "cspi3")
+	clkdev("imx-fb.0", "per", "per3_gate")
+	clkdev("imx-fb.0", "ipg", "lcdc_ipg_gate")
+	clkdev("imx-fb.0", "ahb", "lcdc_ahb_gate")
+	clkdev("mx2-camera.0", NULL, "csi")
+	clkdev("fsl-usb2-udc", "usb", "usb")
+	clkdev("fsl-usb2-udc", "usb_ahb", "usb_ahb_gate")
+	clkdev("mxc-ehci.0", "usb", "usb")
+	clkdev("mxc-ehci.0", "usb_ahb", "usb_ahb_gate")
+	clkdev("mxc-ehci.1", "usb", "usb")
+	clkdev("mxc-ehci.1", "usb_ahb", "usb_ahb_gate")
+	clkdev("mxc-ehci.2", "usb", "usb")
+	clkdev("mxc-ehci.2", "usb_ahb", "usb_ahb_gate")
+	clkdev("imx-ssi.0", NULL, "ssi1_ipg_gate")
+	clkdev("imx-ssi.1", NULL, "ssi2_ipg_gate")
+	clkdev("mxc_nand.0", NULL, "nfc_baud_gate")
+	clkdev("imx-vpu", "per", "vpu_baud_gate")
+	clkdev("imx-vpu", "ahb", "vpu_ahb_gate")
+	clkdev("imx-dma", "ahb", "dma_ahb_gate")
+	clkdev("imx-dma", "ipg", "dma_ipg_gate")
+	clkdev("imx27-fec.0", "ipg", "fec_ipg_gate")
+	clkdev("imx27-fec.0", "ahb", "fec_ahb_gate")
+	clkdev("imx2-wdt.0", NULL, "wdog_ipg_gate")
+	clkdev("imx-i2c.0", NULL, "i2c1_ipg_gate")
+	clkdev("imx-i2c.1", NULL, "i2c2_ipg_gate")
+	clkdev("mxc_w1.0", NULL, "owire_ipg_gate")
+	clkdev("imx-keypad", NULL, "kpp_ipg_gate")
+	clkdev("imx-emma", "ahb", "emma_ahb_gate")
+	clkdev("imx-emma", "ipg", "emma_ipg_gate")
+	clkdev(NULL, "iim", "iim_ipg_gate")
+	clkdev(NULL, "gpio", "gpio_ipg_gate")
+	clkdev(NULL, "brom", "brom_ahb_gate")
+	clkdev(NULL, "ata", "ata_ahb_gate")
+	clkdev(NULL, "rtc", "rtc_ipg_gate")
+	clkdev(NULL, "scc", "scc_ipg_gate")
+	clkdev(NULL, "cpu", "cpu_div")
+};
+
+int __init mx27_clocks_init(unsigned long fref)
+{
+	int i;
+
+	imx_clk_fixed("dummy", 0);
+	imx_clk_fixed("ckih", fref);
+	imx_clk_pllv1("mpll", "ckih", CCM_MPCTL0);
+	imx_clk_pllv1("spll", "ckih", CCM_SPCTL0);
+	imx_clk_fixed_factor("mpll_main2", "mpll", 2, 3);
+	imx_clk_divider("ahb", "mpll_main2", CCM_CSCR, 8, 2);
+	imx_clk_fixed_factor("ipg", "ahb", 1, 1);
+	imx_clk_divider("nfc_div", "ahb", CCM_PCDR0, 6, 4);
+	imx_clk_divider("per1_div", "mpll_main2", CCM_PCDR1, 0, 6);
+	imx_clk_divider("per2_div", "mpll_main2", CCM_PCDR1, 8, 6);
+	imx_clk_divider("per3_div", "mpll_main2", CCM_PCDR1, 16, 6);
+	imx_clk_divider("per4_div", "mpll_main2", CCM_PCDR1, 24, 6);
+	imx_clk_mux("vpu_sel", CCM_CSCR, 21, 1, vpu_sel_clks, ARRAY_SIZE(vpu_sel_clks));
+	imx_clk_divider("vpu_div", "vpu_sel", CCM_PCDR0, 10, 6);
+	imx_clk_divider("usb_div", "spll", CCM_CSCR, 28, 3);
+	imx_clk_mux("cpu_sel", CCM_CSCR, 15, 1, cpu_sel_clks, ARRAY_SIZE(cpu_sel_clks));
+	imx_clk_divider("cpu_div", "cpu_sel", CCM_CSCR, 12, 2);
+	imx_clk_gate("ssi2_ipg_gate", "ipg", CCM_PCCR0, 0);
+	imx_clk_gate("ssi1_ipg_gate", "ipg", CCM_PCCR0, 1);
+	imx_clk_gate("slcdc_ipg_gate", "ipg", CCM_PCCR0, 2);
+	imx_clk_gate("sdhc3_ipg_gate", "ipg", CCM_PCCR0, 3);
+	imx_clk_gate("sdhc2_ipg_gate", "ipg", CCM_PCCR0, 4);
+	imx_clk_gate("sdhc1_ipg_gate", "ipg", CCM_PCCR0, 5);
+	imx_clk_gate("scc_ipg_gate", "ipg", CCM_PCCR0, 6);
+	imx_clk_gate("sahara_ipg_gate", "ipg", CCM_PCCR0, 7);
+	imx_clk_gate("rtc_ipg_gate", "ipg", CCM_PCCR0, 9);
+	imx_clk_gate("pwm_ipg_gate", "ipg", CCM_PCCR0, 11);
+	imx_clk_gate("owire_ipg_gate", "ipg", CCM_PCCR0, 12);
+	imx_clk_gate("lcdc_ipg_gate", "ipg", CCM_PCCR0, 14);
+	imx_clk_gate("kpp_ipg_gate", "ipg", CCM_PCCR0, 15);
+	imx_clk_gate("iim_ipg_gate", "ipg", CCM_PCCR0, 16);
+	imx_clk_gate("i2c2_ipg_gate", "ipg", CCM_PCCR0, 17);
+	imx_clk_gate("i2c1_ipg_gate", "ipg", CCM_PCCR0, 18);
+	imx_clk_gate("gpt6_ipg_gate", "ipg", CCM_PCCR0, 19);
+	imx_clk_gate("gpt5_ipg_gate", "ipg", CCM_PCCR0, 20);
+	imx_clk_gate("gpt4_ipg_gate", "ipg", CCM_PCCR0, 21);
+	imx_clk_gate("gpt3_ipg_gate", "ipg", CCM_PCCR0, 22);
+	imx_clk_gate("gpt2_ipg_gate", "ipg", CCM_PCCR0, 23);
+	imx_clk_gate("gpt1_ipg_gate", "ipg", CCM_PCCR0, 24);
+	imx_clk_gate("gpio_ipg_gate", "ipg", CCM_PCCR0, 25);
+	imx_clk_gate("fec_ipg_gate", "ipg", CCM_PCCR0, 26);
+	imx_clk_gate("emma_ipg_gate", "ipg", CCM_PCCR0, 27);
+	imx_clk_gate("dma_ipg_gate", "ipg", CCM_PCCR0, 28);
+	imx_clk_gate("cspi3_ipg_gate", "ipg", CCM_PCCR0, 29);
+	imx_clk_gate("cspi2_ipg_gate", "ipg", CCM_PCCR0, 30);
+	imx_clk_gate("cspi1_ipg_gate", "ipg", CCM_PCCR0, 31);
+	imx_clk_gate("nfc_baud_gate", "nfc_div", CCM_PCCR1,  3);
+	imx_clk_gate("ssi2_baud_gate", "dummy", CCM_PCCR1,  4);
+	imx_clk_gate("ssi1_baud_gate", "dummy", CCM_PCCR1,  5);
+	imx_clk_gate("vpu_baud_gate", "vpu_div", CCM_PCCR1,  6);
+	imx_clk_gate("per4_gate", "per4_div", CCM_PCCR1,  7);
+	imx_clk_gate("per3_gate", "per3_div", CCM_PCCR1,  8);
+	imx_clk_gate("per2_gate", "per2_div", CCM_PCCR1,  9);
+	imx_clk_gate("per1_gate", "per1_div", CCM_PCCR1, 10);
+	imx_clk_gate("usb_ahb_gate", "ahb", CCM_PCCR1, 11);
+	imx_clk_gate("slcdc_ahb_gate", "ahb", CCM_PCCR1, 12);
+	imx_clk_gate("sahara_ahb_gate", "ahb", CCM_PCCR1, 13);
+	imx_clk_gate("lcdc_ahb_gate", "ahb", CCM_PCCR1, 15);
+	imx_clk_gate("vpu_ahb_gate", "ahb", CCM_PCCR1, 16);
+	imx_clk_gate("fec_ahb_gate", "ahb", CCM_PCCR1, 17);
+	imx_clk_gate("emma_ahb_gate", "ahb", CCM_PCCR1, 18);
+	imx_clk_gate("emi_ahb_gate", "ahb", CCM_PCCR1, 19);
+	imx_clk_gate("dma_ahb_gate", "ahb", CCM_PCCR1, 20);
+	imx_clk_gate("csi_ahb_gate", "ahb", CCM_PCCR1, 21);
+	imx_clk_gate("brom_ahb_gate", "ahb", CCM_PCCR1, 22);
+	imx_clk_gate("ata_ahb_gate", "ahb", CCM_PCCR1, 23);
+	imx_clk_gate("wdog_ipg_gate", "ipg", CCM_PCCR1, 24);
+	imx_clk_gate("usb_ipg_gate", "ipg", CCM_PCCR1, 25);
+	imx_clk_gate("uart6_ipg_gate", "ipg", CCM_PCCR1, 26);
+	imx_clk_gate("uart5_ipg_gate", "ipg", CCM_PCCR1, 27);
+	imx_clk_gate("uart4_ipg_gate", "ipg", CCM_PCCR1, 28);
+	imx_clk_gate("uart3_ipg_gate", "ipg", CCM_PCCR1, 29);
+	imx_clk_gate("uart2_ipg_gate", "ipg", CCM_PCCR1, 30);
+	imx_clk_gate("uart1_ipg_gate", "ipg", CCM_PCCR1, 31);
+
+	for (i = 0; i < ARRAY_SIZE(lookups); i++) {
+		struct clkl *l = &lookups[i];
+		l->lookup.clk = __clk_lookup(l->clkname);
+		clkdev_add(&l->lookup);
+	}
+
+	mxc_timer_init(NULL, MX27_IO_ADDRESS(MX27_GPT1_BASE_ADDR),
+			MX27_INT_GPT1);
+	return 0;
+}
-- 
1.7.9.1

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
