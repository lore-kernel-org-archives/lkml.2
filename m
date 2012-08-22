Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2HVIZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:25:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39403 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab2HVIWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:22:45 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/9] pinctrl: mvebu: dove pinctrl driver
Date: Wed, 22 Aug 2012 10:22:23 +0200
Message-Id: <1345623750-10645-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a SoC specific pinctrl driver for Marvell Dove SoCs
plus DT binding documentation. This driver will use the mvebu pinctrl
driver core.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
v2:
- restructured pinctrl/Kconfig to hide pinctrl driver as it will be
  always selected by arch/arm/mach-mvebu/Kconfig
- cleaned pinctrl-dove and replaced 'magic numbers' by defines
- use devm_clk_get for (now optional) pdma clock and add to required
  properties in devicetree binding documentation

Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Lior Amsalem <alior@marvell.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 .../bindings/pinctrl/marvell,dove-pinctrl.txt      |   72 +++
 drivers/pinctrl/Kconfig                            |    4 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-dove.c                     |  622 ++++++++++++++++++++
 4 files changed, 699 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-dove.c

diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt
new file mode 100644
index 0000000..a648aaa
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt
@@ -0,0 +1,72 @@
+* Marvell Dove SoC pinctrl driver for mpp
+
+Please refer to marvell,mvebu-pinctrl.txt in this directory for common binding
+part and usage.
+
+Required properties:
+- compatible: "marvell,dove-pinctrl"
+- clocks: (optional) phandle of pdma clock
+
+Available mpp pins/groups and functions:
+Note: brackets (x) are not part of the mpp name for marvell,function and given
+only for more detailed description in this document.
+
+name          pins     functions
+================================================================================
+mpp0          0        gpio, pmu, uart2(rts), sdio0(cd), lcd0(pwm)
+mpp1          1        gpio, pmu, uart2(cts), sdio0(wp), lcd1(pwm)
+mpp2          2        gpio, pmu, uart2(txd), sdio0(buspwr), sata(prsnt),
+                       uart1(rts)
+mpp3          3        gpio, pmu, uart2(rxd), sdio0(ledctrl), sata(act),
+                       uart1(cts), lcd-spi(cs1)
+mpp4          4        gpio, pmu, uart3(rts), sdio1(cd), spi1(miso)
+mpp5          5        gpio, pmu, uart3(cts), sdio1(wp), spi1(cs)
+mpp6          6        gpio, pmu, uart3(txd), sdio1(buspwr), spi1(mosi)
+mpp7          7        gpio, pmu, uart3(rxd), sdio1(ledctrl), spi1(sck)
+mpp8          8        gpio, pmu, watchdog(rstout)
+mpp9          9        gpio, pmu, pex1(clkreq)
+mpp10         10       gpio, pmu, ssp(sclk)
+mpp11         11       gpio, pmu, sata(prsnt), sata-1(act), sdio0(ledctrl),
+                       sdio1(ledctrl), pex0(clkreq)
+mpp12         12       gpio, pmu, uart2(rts), audio0(extclk), sdio1(cd), sata(act)
+mpp13         13       gpio, pmu, uart2(cts), audio1(extclk), sdio1(wp),
+                       ssp(extclk)
+mpp14         14       gpio, pmu, uart2(txd), sdio1(buspwr), ssp(rxd)
+mpp15         15       gpio, pmu, uart2(rxd), sdio1(ledctrl), ssp(sfrm)
+mpp16         16       gpio, uart3(rts), sdio0(cd), ac97(sdi1), lcd-spi(cs1)
+mpp17         17       gpio, uart3(cts), sdio0(wp), ac97(sdi2), twsi(sda),
+                       ac97-1(sysclko)
+mpp18         18       gpio, uart3(txd), sdio0(buspwr), ac97(sdi3), lcd0(pwm)
+mpp19         19       gpio, uart3(rxd), sdio0(ledctrl), twsi(sck)
+mpp20         20       gpio, sdio0(cd), sdio1(cd), spi1(miso), lcd-spi(miso),
+                       ac97(sysclko)
+mpp21         21       gpio, sdio0(wp), sdio1(wp), spi1(cs), lcd-spi(cs0),
+                       uart1(cts), ssp(sfrm)
+mpp22         22       gpio, sdio0(buspwr), sdio1(buspwr), spi1(mosi),
+                       lcd-spi(mosi), uart1(cts), ssp(txd)
+mpp23         23       gpio, sdio0(ledctrl), sdio1(ledctrl), spi1(sck),
+                       lcd-spi(sck), ssp(sclk)
+mpp_camera    24-39    gpio, camera
+mpp_sdio0     40-45    gpio, sdio0
+mpp_sdio1     46-51    gpio, sdio1
+mpp_audio1    52-57    gpio, i2s1/spdifo, i2s1, spdifo, twsi, ssp/spdifo, ssp,
+                       ssp/twsi
+mpp_spi0      58-61    gpio, spi0
+mpp_uart1     62-63    gpio, uart1
+mpp_nand      64-71    gpo, nand
+audio0        -        i2s, ac97
+twsi          -        none, opt1, opt2, opt3
+
+Notes:
+* group "mpp_audio1" allows the following functions and gpio pins:
+  - gpio          : gpio on pins 52-57
+  - i2s1/spdifo   : audio1 i2s on pins 52-55 and spdifo on 57, no gpios
+  - i2s1          : audio1 i2s on pins 52-55, gpio on pins 56,57
+  - spdifo        : spdifo on pin 57, gpio on pins 52-55
+  - twsi          : twsi on pins 56,57, gpio on pins 52-55
+  - ssp/spdifo    : ssp on pins 52-55, spdifo on pin 57, no gpios
+  - ssp           : ssp on pins 52-55, gpio on pins 56,57
+  - ssp/twsi      : ssp on pins 52-55, twsi on pins 56,57, no gpios
+* group "audio0" internally muxes i2s0 or ac97 controller to the dedicated
+  audio0 pins.
+* group "twsi" internally muxes twsi controller to the dedicated or option pins.
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 20bfdc3..f15eba4 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -151,6 +151,10 @@ config PINCTRL_MVEBU
 	select PINMUX
 	select PINCONF
 
+config PINCTRL_DOVE
+	bool
+	select PINCTRL_MVEBU
+
 source "drivers/pinctrl/spear/Kconfig"
 
 endmenu
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 007ed32..d1327df 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -30,5 +30,6 @@ obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
 obj-$(CONFIG_PINCTRL_MVEBU)	+= pinctrl-mvebu.o
+obj-$(CONFIG_PINCTRL_DOVE)	+= pinctrl-dove.o
 
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
diff --git a/drivers/pinctrl/pinctrl-dove.c b/drivers/pinctrl/pinctrl-dove.c
new file mode 100644
index 0000000..cb31b63
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-dove.c
@@ -0,0 +1,622 @@
+/*
+ * Marvell Dove pinctrl driver based on mvebu pinctrl core
+ *
+ * Author: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/bitops.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/pinctrl.h>
+
+#include "pinctrl-mvebu.h"
+
+#define DOVE_SB_REGS_VIRT_BASE		0xfde00000
+#define DOVE_MPP_VIRT_BASE		(DOVE_SB_REGS_VIRT_BASE | 0xd0200)
+#define DOVE_PMU_MPP_GENERAL_CTRL	(DOVE_MPP_VIRT_BASE + 0x10)
+#define  DOVE_AU0_AC97_SEL		BIT(16)
+#define DOVE_GLOBAL_CONFIG_1		(DOVE_SB_REGS_VIRT_BASE | 0xe802C)
+#define  DOVE_TWSI_ENABLE_OPTION1	BIT(7)
+#define DOVE_GLOBAL_CONFIG_2		(DOVE_SB_REGS_VIRT_BASE | 0xe8030)
+#define  DOVE_TWSI_ENABLE_OPTION2	BIT(20)
+#define  DOVE_TWSI_ENABLE_OPTION3	BIT(21)
+#define  DOVE_TWSI_OPTION3_GPIO		BIT(22)
+#define DOVE_SSP_CTRL_STATUS_1		(DOVE_SB_REGS_VIRT_BASE | 0xe8034)
+#define  DOVE_SSP_ON_AU1		BIT(0)
+#define DOVE_MPP_GENERAL_VIRT_BASE	(DOVE_SB_REGS_VIRT_BASE | 0xe803c)
+#define  DOVE_AU1_SPDIFO_GPIO_EN	BIT(1)
+#define  DOVE_NAND_GPIO_EN		BIT(0)
+#define DOVE_GPIO_LO_VIRT_BASE		(DOVE_SB_REGS_VIRT_BASE | 0xd0400)
+#define DOVE_MPP_CTRL4_VIRT_BASE	(DOVE_GPIO_LO_VIRT_BASE + 0x40)
+#define  DOVE_SPI_GPIO_SEL		BIT(5)
+#define  DOVE_UART1_GPIO_SEL		BIT(4)
+#define  DOVE_AU1_GPIO_SEL		BIT(3)
+#define  DOVE_CAM_GPIO_SEL		BIT(2)
+#define  DOVE_SD1_GPIO_SEL		BIT(1)
+#define  DOVE_SD0_GPIO_SEL		BIT(0)
+
+#define MPPS_PER_REG	8
+#define MPP_BITS	4
+#define MPP_MASK	0xf
+
+#define CONFIG_PMU	BIT(4)
+
+static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
+				 unsigned long *config)
+{
+	unsigned off = (ctrl->pid / MPPS_PER_REG) * MPP_BITS;
+	unsigned shift = (ctrl->pid % MPPS_PER_REG) * MPP_BITS;
+	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+	unsigned long mpp = readl(DOVE_MPP_VIRT_BASE + off);
+
+	if (pmu & (1 << ctrl->pid))
+		*config = CONFIG_PMU;
+	else
+		*config = (mpp >> shift) & MPP_MASK;
+	return 0;
+}
+
+static int dove_pmu_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
+				 unsigned long config)
+{
+	unsigned off = (ctrl->pid / MPPS_PER_REG) * MPP_BITS;
+	unsigned shift = (ctrl->pid % MPPS_PER_REG) * MPP_BITS;
+	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+	unsigned long mpp = readl(DOVE_MPP_VIRT_BASE + off);
+
+	if (config == CONFIG_PMU)
+		writel(pmu | (1 << ctrl->pid), DOVE_PMU_MPP_GENERAL_CTRL);
+	else {
+		writel(pmu & ~(1 << ctrl->pid), DOVE_PMU_MPP_GENERAL_CTRL);
+		mpp &= ~(MPP_MASK << shift);
+		mpp |= config << shift;
+		writel(mpp, DOVE_MPP_VIRT_BASE + off);
+	}
+	return 0;
+}
+
+static int dove_mpp4_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
+			      unsigned long *config)
+{
+	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
+	unsigned long mask;
+
+	switch (ctrl->pid) {
+	case 24: /* mpp_camera */
+		mask = DOVE_CAM_GPIO_SEL;
+		break;
+	case 40: /* mpp_sdio0 */
+		mask = DOVE_SD0_GPIO_SEL;
+		break;
+	case 46: /* mpp_sdio1 */
+		mask = DOVE_SD1_GPIO_SEL;
+		break;
+	case 58: /* mpp_spi0 */
+		mask = DOVE_SPI_GPIO_SEL;
+		break;
+	case 62: /* mpp_uart1 */
+		mask = DOVE_UART1_GPIO_SEL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*config = ((mpp4 & mask) != 0);
+
+	return 0;
+}
+
+static int dove_mpp4_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
+			      unsigned long config)
+{
+	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
+	unsigned long mask;
+
+	switch (ctrl->pid) {
+	case 24: /* mpp_camera */
+		mask = DOVE_CAM_GPIO_SEL;
+		break;
+	case 40: /* mpp_sdio0 */
+		mask = DOVE_SD0_GPIO_SEL;
+		break;
+	case 46: /* mpp_sdio1 */
+		mask = DOVE_SD1_GPIO_SEL;
+		break;
+	case 58: /* mpp_spi0 */
+		mask = DOVE_SPI_GPIO_SEL;
+		break;
+	case 62: /* mpp_uart1 */
+		mask = DOVE_UART1_GPIO_SEL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	mpp4 &= ~mask;
+	if (config)
+		mpp4 |= mask;
+
+	writel(mpp4, DOVE_MPP_CTRL4_VIRT_BASE);
+
+	return 0;
+}
+
+static int dove_nand_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
+			      unsigned long *config)
+{
+	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
+
+	*config = ((gmpp & DOVE_NAND_GPIO_EN) != 0);
+
+	return 0;
+}
+
+static int dove_nand_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
+			      unsigned long config)
+{
+	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
+
+	gmpp &= ~DOVE_NAND_GPIO_EN;
+	if (config)
+		gmpp |= DOVE_NAND_GPIO_EN;
+
+	writel(gmpp, DOVE_MPP_GENERAL_VIRT_BASE);
+
+	return 0;
+}
+
+static int dove_audio0_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
+				unsigned long *config)
+{
+	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+
+	*config = ((pmu & DOVE_AU0_AC97_SEL) != 0);
+
+	return 0;
+}
+
+static int dove_audio0_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
+				unsigned long config)
+{
+	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+
+	pmu &= ~DOVE_AU0_AC97_SEL;
+	if (config)
+		pmu |= DOVE_AU0_AC97_SEL;
+	writel(pmu, DOVE_PMU_MPP_GENERAL_CTRL);
+
+	return 0;
+}
+
+static int dove_audio1_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
+				unsigned long *config)
+{
+	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
+	unsigned long sspc1 = readl(DOVE_SSP_CTRL_STATUS_1);
+	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
+	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
+
+	*config = 0;
+	if (mpp4 & DOVE_AU1_GPIO_SEL)
+		*config |= BIT(3);
+	if (sspc1 & DOVE_SSP_ON_AU1)
+		*config |= BIT(2);
+	if (gmpp & DOVE_AU1_SPDIFO_GPIO_EN)
+		*config |= BIT(1);
+	if (gcfg2 & DOVE_TWSI_OPTION3_GPIO)
+		*config |= BIT(0);
+
+	/* SSP/TWSI only if I2S1 not set*/
+	if ((*config & BIT(3)) == 0)
+		*config &= ~(BIT(2) | BIT(0));
+	/* TWSI only if SPDIFO not set*/
+	if ((*config & BIT(1)) == 0)
+		*config &= ~BIT(0);
+	return 0;
+}
+
+static int dove_audio1_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
+				unsigned long config)
+{
+	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
+	unsigned long sspc1 = readl(DOVE_SSP_CTRL_STATUS_1);
+	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
+	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
+
+	if (config & BIT(0))
+		gcfg2 |= DOVE_TWSI_OPTION3_GPIO;
+	if (config & BIT(1))
+		gmpp |= DOVE_AU1_SPDIFO_GPIO_EN;
+	if (config & BIT(2))
+		sspc1 |= DOVE_SSP_ON_AU1;
+	if (config & BIT(3))
+		mpp4 |= DOVE_AU1_GPIO_SEL;
+
+	writel(mpp4, DOVE_MPP_CTRL4_VIRT_BASE);
+	writel(sspc1, DOVE_SSP_CTRL_STATUS_1);
+	writel(gmpp, DOVE_MPP_GENERAL_VIRT_BASE);
+	writel(gcfg2, DOVE_GLOBAL_CONFIG_2);
+
+	return 0;
+}
+
+/* mpp[52:57] gpio pins depend heavily on current config;
+ * gpio_req does not try to mux in gpio capabilities to not
+ * break other functions. If you require all mpps as gpio
+ * enforce gpio setting by pinctrl mapping.
+ */
+static int dove_audio1_ctrl_gpio_req(struct mvebu_mpp_ctrl *ctrl, u8 pid)
+{
+	unsigned long config;
+
+	dove_audio1_ctrl_get(ctrl, &config);
+
+	switch (config) {
+	case 0x02: /* i2s1 : gpio[56:57] */
+	case 0x0e: /* ssp  : gpio[56:57] */
+		if (pid >= 56)
+			return 0;
+		return -ENOTSUPP;
+	case 0x08: /* spdifo : gpio[52:55] */
+	case 0x0b: /* twsi   : gpio[52:55] */
+		if (pid <= 55)
+			return 0;
+		return -ENOTSUPP;
+	case 0x0a: /* all gpio */
+		return 0;
+	/* 0x00 : i2s1/spdifo : no gpio */
+	/* 0x0c : ssp/spdifo  : no gpio */
+	/* 0x0f : ssp/twsi    : no gpio */
+	}
+	return -ENOTSUPP;
+}
+
+/* mpp[52:57] has gpio pins capable of in and out */
+static int dove_audio1_ctrl_gpio_dir(struct mvebu_mpp_ctrl *ctrl, u8 pid,
+				bool input)
+{
+	if (pid < 52 || pid > 57)
+		return -ENOTSUPP;
+	return 0;
+}
+
+static int dove_twsi_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
+			      unsigned long *config)
+{
+	unsigned long gcfg1 = readl(DOVE_GLOBAL_CONFIG_1);
+	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
+
+	*config = 0;
+	if (gcfg1 & DOVE_TWSI_ENABLE_OPTION1)
+		*config = 1;
+	else if (gcfg2 & DOVE_TWSI_ENABLE_OPTION2)
+		*config = 2;
+	else if (gcfg2 & DOVE_TWSI_ENABLE_OPTION3)
+		*config = 3;
+
+	return 0;
+}
+
+static int dove_twsi_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
+				unsigned long config)
+{
+	unsigned long gcfg1 = readl(DOVE_GLOBAL_CONFIG_1);
+	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
+
+	gcfg1 &= ~DOVE_TWSI_ENABLE_OPTION1;
+	gcfg2 &= ~(DOVE_TWSI_ENABLE_OPTION2 | DOVE_TWSI_ENABLE_OPTION2);
+
+	switch (config) {
+	case 1:
+		gcfg1 |= DOVE_TWSI_ENABLE_OPTION1;
+		break;
+	case 2:
+		gcfg2 |= DOVE_TWSI_ENABLE_OPTION2;
+		break;
+	case 3:
+		gcfg2 |= DOVE_TWSI_ENABLE_OPTION3;
+		break;
+	}
+
+	writel(gcfg1, DOVE_GLOBAL_CONFIG_1);
+	writel(gcfg2, DOVE_GLOBAL_CONFIG_2);
+
+	return 0;
+}
+
+static struct mvebu_mpp_ctrl dove_mpp_controls[] = {
+	MPP_FUNC_CTRL(0, 0, "mpp0", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(1, 1, "mpp1", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(2, 2, "mpp2", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(3, 3, "mpp3", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(4, 4, "mpp4", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(5, 5, "mpp5", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(6, 6, "mpp6", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(7, 7, "mpp7", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(8, 8, "mpp8", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(9, 9, "mpp9", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(10, 10, "mpp10", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(11, 11, "mpp11", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(12, 12, "mpp12", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(13, 13, "mpp13", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(14, 14, "mpp14", dove_pmu_mpp_ctrl),
+	MPP_FUNC_CTRL(15, 15, "mpp15", dove_pmu_mpp_ctrl),
+	MPP_REG_CTRL(16, 23),
+	MPP_FUNC_CTRL(24, 39, "mpp_camera", dove_mpp4_ctrl),
+	MPP_FUNC_CTRL(40, 45, "mpp_sdio0", dove_mpp4_ctrl),
+	MPP_FUNC_CTRL(46, 51, "mpp_sdio1", dove_mpp4_ctrl),
+	MPP_FUNC_GPIO_CTRL(52, 57, "mpp_audio1", dove_audio1_ctrl),
+	MPP_FUNC_CTRL(58, 61, "mpp_spi0", dove_mpp4_ctrl),
+	MPP_FUNC_CTRL(62, 63, "mpp_uart1", dove_mpp4_ctrl),
+	MPP_FUNC_CTRL(64, 71, "mpp_nand", dove_nand_ctrl),
+	MPP_FUNC_CTRL(72, 72, "audio0", dove_audio0_ctrl),
+	MPP_FUNC_CTRL(73, 73, "twsi", dove_twsi_ctrl),
+};
+
+static struct mvebu_mpp_mode dove_mpp_modes[] = {
+	MPP_MODE(0,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart2", "rts"),
+		MPP_FUNCTION(0x03, "sdio0", "cd"),
+		MPP_FUNCTION(0x0f, "lcd0", "pwm"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(1,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart2", "cts"),
+		MPP_FUNCTION(0x03, "sdio0", "wp"),
+		MPP_FUNCTION(0x0f, "lcd1", "pwm"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(2,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x01, "sata", "prsnt"),
+		MPP_FUNCTION(0x02, "uart2", "txd"),
+		MPP_FUNCTION(0x03, "sdio0", "buspwr"),
+		MPP_FUNCTION(0x04, "uart1", "rts"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(3,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x01, "sata", "act"),
+		MPP_FUNCTION(0x02, "uart2", "rxd"),
+		MPP_FUNCTION(0x03, "sdio0", "ledctrl"),
+		MPP_FUNCTION(0x04, "uart1", "cts"),
+		MPP_FUNCTION(0x0f, "lcd-spi", "cs1"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(4,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart3", "rts"),
+		MPP_FUNCTION(0x03, "sdio1", "cd"),
+		MPP_FUNCTION(0x04, "spi1", "miso"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(5,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart3", "cts"),
+		MPP_FUNCTION(0x03, "sdio1", "wp"),
+		MPP_FUNCTION(0x04, "spi1", "cs"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(6,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart3", "txd"),
+		MPP_FUNCTION(0x03, "sdio1", "buspwr"),
+		MPP_FUNCTION(0x04, "spi1", "mosi"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(7,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart3", "rxd"),
+		MPP_FUNCTION(0x03, "sdio1", "ledctrl"),
+		MPP_FUNCTION(0x04, "spi1", "sck"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(8,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x01, "watchdog", "rstout"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(9,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x05, "pex1", "clkreq"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(10,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x05, "ssp", "sclk"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(11,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x01, "sata", "prsnt"),
+		MPP_FUNCTION(0x02, "sata-1", "act"),
+		MPP_FUNCTION(0x03, "sdio0", "ledctrl"),
+		MPP_FUNCTION(0x04, "sdio1", "ledctrl"),
+		MPP_FUNCTION(0x05, "pex0", "clkreq"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(12,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x01, "sata", "act"),
+		MPP_FUNCTION(0x02, "uart2", "rts"),
+		MPP_FUNCTION(0x03, "audio0", "extclk"),
+		MPP_FUNCTION(0x04, "sdio1", "cd"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(13,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart2", "cts"),
+		MPP_FUNCTION(0x03, "audio1", "extclk"),
+		MPP_FUNCTION(0x04, "sdio1", "wp"),
+		MPP_FUNCTION(0x05, "ssp", "extclk"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(14,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart2", "txd"),
+		MPP_FUNCTION(0x04, "sdio1", "buspwr"),
+		MPP_FUNCTION(0x05, "ssp", "rxd"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(15,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart2", "rxd"),
+		MPP_FUNCTION(0x04, "sdio1", "ledctrl"),
+		MPP_FUNCTION(0x05, "ssp", "sfrm"),
+		MPP_FUNCTION(0x10, "pmu", NULL)),
+	MPP_MODE(16,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart3", "rts"),
+		MPP_FUNCTION(0x03, "sdio0", "cd"),
+		MPP_FUNCTION(0x04, "lcd-spi", "cs1"),
+		MPP_FUNCTION(0x05, "ac97", "sdi1")),
+	MPP_MODE(17,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x01, "ac97-1", "sysclko"),
+		MPP_FUNCTION(0x02, "uart3", "cts"),
+		MPP_FUNCTION(0x03, "sdio0", "wp"),
+		MPP_FUNCTION(0x04, "twsi", "sda"),
+		MPP_FUNCTION(0x05, "ac97", "sdi2")),
+	MPP_MODE(18,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart3", "txd"),
+		MPP_FUNCTION(0x03, "sdio0", "buspwr"),
+		MPP_FUNCTION(0x04, "lcd0", "pwm"),
+		MPP_FUNCTION(0x05, "ac97", "sdi3")),
+	MPP_MODE(19,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "uart3", "rxd"),
+		MPP_FUNCTION(0x03, "sdio0", "ledctrl"),
+		MPP_FUNCTION(0x04, "twsi", "sck")),
+	MPP_MODE(20,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x01, "ac97", "sysclko"),
+		MPP_FUNCTION(0x02, "lcd-spi", "miso"),
+		MPP_FUNCTION(0x03, "sdio1", "cd"),
+		MPP_FUNCTION(0x05, "sdio0", "cd"),
+		MPP_FUNCTION(0x06, "spi1", "miso")),
+	MPP_MODE(21,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x01, "uart1", "rts"),
+		MPP_FUNCTION(0x02, "lcd-spi", "cs0"),
+		MPP_FUNCTION(0x03, "sdio1", "wp"),
+		MPP_FUNCTION(0x04, "ssp", "sfrm"),
+		MPP_FUNCTION(0x05, "sdio0", "wp"),
+		MPP_FUNCTION(0x06, "spi1", "cs")),
+	MPP_MODE(22,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x01, "uart1", "cts"),
+		MPP_FUNCTION(0x02, "lcd-spi", "mosi"),
+		MPP_FUNCTION(0x03, "sdio1", "buspwr"),
+		MPP_FUNCTION(0x04, "ssp", "txd"),
+		MPP_FUNCTION(0x05, "sdio0", "buspwr"),
+		MPP_FUNCTION(0x06, "spi1", "mosi")),
+	MPP_MODE(23,
+		MPP_FUNCTION(0x00, "gpio", NULL),
+		MPP_FUNCTION(0x02, "lcd-spi", "sck"),
+		MPP_FUNCTION(0x03, "sdio1", "ledctrl"),
+		MPP_FUNCTION(0x04, "ssp", "sclk"),
+		MPP_FUNCTION(0x05, "sdio0", "ledctrl"),
+		MPP_FUNCTION(0x06, "spi1", "sck")),
+	MPP_MODE(24,
+		MPP_FUNCTION(0x00, "camera", NULL),
+		MPP_FUNCTION(0x01, "gpio", NULL)),
+	MPP_MODE(40,
+		MPP_FUNCTION(0x00, "sdio0", NULL),
+		MPP_FUNCTION(0x01, "gpio", NULL)),
+	MPP_MODE(46,
+		MPP_FUNCTION(0x00, "sdio1", NULL),
+		MPP_FUNCTION(0x01, "gpio", NULL)),
+	MPP_MODE(52,
+		MPP_FUNCTION(0x00, "i2s1/spdifo", NULL),
+		MPP_FUNCTION(0x02, "i2s1", NULL),
+		MPP_FUNCTION(0x08, "spdifo", NULL),
+		MPP_FUNCTION(0x0a, "gpio", NULL),
+		MPP_FUNCTION(0x0b, "twsi", NULL),
+		MPP_FUNCTION(0x0c, "ssp/spdifo", NULL),
+		MPP_FUNCTION(0x0e, "ssp", NULL),
+		MPP_FUNCTION(0x0f, "ssp/twsi", NULL)),
+	MPP_MODE(58,
+		MPP_FUNCTION(0x00, "spi0", NULL),
+		MPP_FUNCTION(0x01, "gpio", NULL)),
+	MPP_MODE(62,
+		MPP_FUNCTION(0x00, "uart1", NULL),
+		MPP_FUNCTION(0x01, "gpio", NULL)),
+	MPP_MODE(64,
+		MPP_FUNCTION(0x00, "nand", NULL),
+		MPP_FUNCTION(0x01, "gpo", NULL)),
+	MPP_MODE(72,
+		MPP_FUNCTION(0x00, "i2s", NULL),
+		MPP_FUNCTION(0x01, "ac97", NULL)),
+	MPP_MODE(73,
+		MPP_FUNCTION(0x00, "none", NULL),
+		MPP_FUNCTION(0x01, "opt1", NULL),
+		MPP_FUNCTION(0x02, "opt2", NULL),
+		MPP_FUNCTION(0x03, "opt3", NULL)),
+};
+
+static struct pinctrl_gpio_range dove_mpp_gpio_ranges[] = {
+	MPP_GPIO_RANGE(0,  0,  0, 32),
+	MPP_GPIO_RANGE(1, 32, 32, 32),
+	MPP_GPIO_RANGE(2, 64, 64,  8),
+};
+
+static struct mvebu_pinctrl_soc_info dove_pinctrl_info = {
+	.controls = dove_mpp_controls,
+	.ncontrols = ARRAY_SIZE(dove_mpp_controls),
+	.modes = dove_mpp_modes,
+	.nmodes = ARRAY_SIZE(dove_mpp_modes),
+	.gpioranges = dove_mpp_gpio_ranges,
+	.ngpioranges = ARRAY_SIZE(dove_mpp_gpio_ranges),
+	.variant = 0,
+};
+
+static struct clk *clk;
+
+static struct of_device_id dove_pinctrl_of_match[] __devinitdata = {
+	{ .compatible = "marvell,dove-pinctrl", .data = &dove_pinctrl_info },
+	{ }
+};
+
+static int __devinit dove_pinctrl_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match =
+		of_match_device(dove_pinctrl_of_match, &pdev->dev);
+
+	if (match)
+		pdev->dev.platform_data = match->data;
+
+	/*
+	 * General MPP Configuration Register is part of pdma registers.
+	 * grab clk to make sure it is ticking.
+	 */
+	clk = devm_clk_get(&pdev->dev, NULL);
+	if (!IS_ERR(clk))
+		clk_prepare_enable(clk);
+
+	return mvebu_pinctrl_probe(pdev);
+}
+
+static int __devexit dove_pinctrl_remove(struct platform_device *pdev)
+{
+	int ret;
+
+	ret = mvebu_pinctrl_remove(pdev);
+	if (!IS_ERR(clk))
+		clk_disable_unprepare(clk);
+	return ret;
+}
+
+static struct platform_driver dove_pinctrl_driver = {
+	.driver = {
+		.name = "dove-pinctrl",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(dove_pinctrl_of_match),
+	},
+	.probe = dove_pinctrl_probe,
+	.remove = __devexit_p(dove_pinctrl_remove),
+};
+
+module_platform_driver(dove_pinctrl_driver);
+
+MODULE_AUTHOR("Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>");
+MODULE_DESCRIPTION("Marvell Dove pinctrl driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.10.4

