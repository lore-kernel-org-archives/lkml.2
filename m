Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2BTG2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:28:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3666 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2BTG2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:28:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 19 Feb 2012 22:27:56 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>
Cc: Chris Ball <cjb@laptop.org>, linux-doc@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/2] gpio: tegra: Delete tegra_gpio_enable/disable()
Date: Sun, 19 Feb 2012 23:27:43 -0700
Message-Id: <1329719263-18971-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329719263-18971-1-git-send-email-swarren@nvidia.com>
References: <1329719263-18971-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent pinctrl discussions concluded that gpio_request() and other gpiolib
APIs should in fact do whatever is required to mux a GPIO onto pins, by
calling pinctrl APIs if required. This change implements this for the
Tegra GPIO driver, and removes the old Tegra-specific APIs which did this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
I don't believe this depends on other patches.

There may be some slight context dependencies; this patch was generated
against next-20120217, with my recently posted "gpio: tegra: Fix build
issue due to irq_domain rework." applied on top.

 arch/arm/mach-tegra/board-dt-tegra20.c        |    1 -
 arch/arm/mach-tegra/board-harmony-pinmux.c    |   17 ---------
 arch/arm/mach-tegra/board-paz00-pinmux.c      |   14 --------
 arch/arm/mach-tegra/board-pinmux.c            |   34 +------------------
 arch/arm/mach-tegra/board-pinmux.h            |    5 ---
 arch/arm/mach-tegra/board-seaboard-pinmux.c   |   32 ------------------
 arch/arm/mach-tegra/board-seaboard.c          |    1 -
 arch/arm/mach-tegra/board-trimslice-pinmux.c  |   12 -------
 arch/arm/mach-tegra/include/mach/gpio-tegra.h |    9 -----
 arch/arm/mach-tegra/usb_phy.c                 |    1 -
 drivers/gpio/gpio-tegra.c                     |   44 +++++++++++++-----------
 drivers/mmc/host/sdhci-tegra.c                |   24 +++-----------
 12 files changed, 31 insertions(+), 163 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 7a95e0b..6d1dd19 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -55,7 +55,6 @@ void ventana_pinmux_init(void);
 
 struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-pinmux", TEGRA_APB_MISC_BASE + 0x14, "tegra-pinmux", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-gpio", TEGRA_GPIO_BASE, "tegra-gpio", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC2_BASE, "sdhci-tegra.1", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC3_BASE, "sdhci-tegra.2", NULL),
diff --git a/arch/arm/mach-tegra/board-harmony-pinmux.c b/arch/arm/mach-tegra/board-harmony-pinmux.c
index 465808c..77a6006 100644
--- a/arch/arm/mach-tegra/board-harmony-pinmux.c
+++ b/arch/arm/mach-tegra/board-harmony-pinmux.c
@@ -15,13 +15,11 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/gpio.h>
 #include <linux/of.h>
 
 #include <mach/pinmux.h>
 #include <mach/pinmux-tegra20.h>
 
-#include "gpio-names.h"
 #include "board-harmony.h"
 #include "board-pinmux.h"
 
@@ -144,24 +142,9 @@ static struct tegra_pingroup_config harmony_pinmux[] = {
 	{TEGRA_PINGROUP_XM2D,  TEGRA_MUX_NONE,          TEGRA_PUPD_NORMAL,    TEGRA_TRI_NORMAL},
 };
 
-static struct tegra_gpio_table gpio_table[] = {
-	{ .gpio = TEGRA_GPIO_SD2_CD,		.enable = true	},
-	{ .gpio = TEGRA_GPIO_SD2_WP,		.enable = true	},
-	{ .gpio = TEGRA_GPIO_SD2_POWER,		.enable = true	},
-	{ .gpio = TEGRA_GPIO_SD4_CD,		.enable = true	},
-	{ .gpio = TEGRA_GPIO_SD4_WP,		.enable = true	},
-	{ .gpio = TEGRA_GPIO_SD4_POWER,		.enable = true	},
-	{ .gpio = TEGRA_GPIO_CDC_IRQ,		.enable = true	},
-	{ .gpio = TEGRA_GPIO_HP_DET,		.enable = true	},
-	{ .gpio = TEGRA_GPIO_INT_MIC_EN,	.enable = true	},
-	{ .gpio = TEGRA_GPIO_EXT_MIC_EN,	.enable = true	},
-};
-
 static struct tegra_board_pinmux_conf conf = {
 	.pgs = harmony_pinmux,
 	.pg_count = ARRAY_SIZE(harmony_pinmux),
-	.gpios = gpio_table,
-	.gpio_count = ARRAY_SIZE(gpio_table),
 };
 
 void harmony_pinmux_init(void)
diff --git a/arch/arm/mach-tegra/board-paz00-pinmux.c b/arch/arm/mach-tegra/board-paz00-pinmux.c
index c775572..f0ec466 100644
--- a/arch/arm/mach-tegra/board-paz00-pinmux.c
+++ b/arch/arm/mach-tegra/board-paz00-pinmux.c
@@ -15,13 +15,11 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/gpio.h>
 #include <linux/of.h>
 
 #include <mach/pinmux.h>
 #include <mach/pinmux-tegra20.h>
 
-#include "gpio-names.h"
 #include "board-paz00.h"
 #include "board-pinmux.h"
 
@@ -144,21 +142,9 @@ static struct tegra_pingroup_config paz00_pinmux[] = {
 	{TEGRA_PINGROUP_XM2D,  TEGRA_MUX_NONE,          TEGRA_PUPD_NORMAL,    TEGRA_TRI_NORMAL},
 };
 
-static struct tegra_gpio_table gpio_table[] = {
-	{ .gpio = TEGRA_GPIO_SD1_CD,	.enable = true },
-	{ .gpio = TEGRA_GPIO_SD1_WP,	.enable = true },
-	{ .gpio = TEGRA_GPIO_SD1_POWER,	.enable = true },
-	{ .gpio = TEGRA_ULPI_RST,	.enable = true },
-	{ .gpio = TEGRA_WIFI_PWRN,	.enable = true },
-	{ .gpio = TEGRA_WIFI_RST,	.enable = true },
-	{ .gpio = TEGRA_WIFI_LED,	.enable = true },
-};
-
 static struct tegra_board_pinmux_conf conf = {
 	.pgs = paz00_pinmux,
 	.pg_count = ARRAY_SIZE(paz00_pinmux),
-	.gpios = gpio_table,
-	.gpio_count = ARRAY_SIZE(gpio_table),
 };
 
 void paz00_pinmux_init(void)
diff --git a/arch/arm/mach-tegra/board-pinmux.c b/arch/arm/mach-tegra/board-pinmux.c
index adc3efe..e5e3a24 100644
--- a/arch/arm/mach-tegra/board-pinmux.c
+++ b/arch/arm/mach-tegra/board-pinmux.c
@@ -18,7 +18,6 @@
 #include <linux/of.h>
 #include <linux/string.h>
 
-#include <mach/gpio-tegra.h>
 #include <mach/pinmux.h>
 
 #include "board-pinmux.h"
@@ -26,18 +25,6 @@
 
 struct tegra_board_pinmux_conf *confs[2];
 
-static void tegra_board_pinmux_setup_gpios(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(confs); i++) {
-		if (!confs[i])
-			continue;
-
-		tegra_gpio_config(confs[i]->gpios, confs[i]->gpio_count);
-	}
-}
-
 static void tegra_board_pinmux_setup_pinmux(void)
 {
 	int i;
@@ -57,29 +44,12 @@ static void tegra_board_pinmux_setup_pinmux(void)
 static int tegra_board_pinmux_bus_notify(struct notifier_block *nb,
 					 unsigned long event, void *vdev)
 {
-	static bool had_gpio;
-	static bool had_pinmux;
-
-	struct device *dev = vdev;
-	const char *devname;
-
 	if (event != BUS_NOTIFY_BOUND_DRIVER)
 		return NOTIFY_DONE;
 
-	devname = dev_name(dev);
+	tegra_board_pinmux_setup_pinmux();
 
-	if (!had_gpio && !strcmp(devname, GPIO_DEV)) {
-		tegra_board_pinmux_setup_gpios();
-		had_gpio = true;
-	} else if (!had_pinmux && !strcmp(devname, PINMUX_DEV)) {
-		tegra_board_pinmux_setup_pinmux();
-		had_pinmux = true;
-	}
-
-	if (had_gpio && had_pinmux)
-		return NOTIFY_STOP_MASK;
-	else
-		return NOTIFY_DONE;
+	return NOTIFY_STOP_MASK;
 }
 
 static struct notifier_block nb = {
diff --git a/arch/arm/mach-tegra/board-pinmux.h b/arch/arm/mach-tegra/board-pinmux.h
index 4aac735..e08214d 100644
--- a/arch/arm/mach-tegra/board-pinmux.h
+++ b/arch/arm/mach-tegra/board-pinmux.h
@@ -15,11 +15,9 @@
 #ifndef __MACH_TEGRA_BOARD_PINMUX_H
 #define __MACH_TEGRA_BOARD_PINMUX_H
 
-#define GPIO_DEV "tegra-gpio"
 #define PINMUX_DEV "tegra-pinmux"
 
 struct tegra_pingroup_config;
-struct tegra_gpio_table;
 
 struct tegra_board_pinmux_conf {
 	struct tegra_pingroup_config *pgs;
@@ -27,9 +25,6 @@ struct tegra_board_pinmux_conf {
 
 	struct tegra_drive_pingroup_config *drives;
 	int drive_count;
-
-	struct tegra_gpio_table *gpios;
-	int gpio_count;
 };
 
 void tegra_board_pinmux_init(struct tegra_board_pinmux_conf *conf_a,
diff --git a/arch/arm/mach-tegra/board-seaboard-pinmux.c b/arch/arm/mach-tegra/board-seaboard-pinmux.c
index 55e7e43..3bf7e97 100644
--- a/arch/arm/mach-tegra/board-seaboard-pinmux.c
+++ b/arch/arm/mach-tegra/board-seaboard-pinmux.c
@@ -15,13 +15,11 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/gpio.h>
 #include <linux/of.h>
 
 #include <mach/pinmux.h>
 #include <mach/pinmux-tegra20.h>
 
-#include "gpio-names.h"
 #include "board-pinmux.h"
 #include "board-seaboard.h"
 
@@ -179,35 +177,9 @@ static struct tegra_pingroup_config ventana_pinmux[] = {
 	{TEGRA_PINGROUP_SPIG, TEGRA_MUX_SPI2_ALT, TEGRA_PUPD_NORMAL,    TEGRA_TRI_TRISTATE},
 };
 
-static struct tegra_gpio_table common_gpio_table[] = {
-	{ .gpio = TEGRA_GPIO_SD2_CD,		.enable = true },
-	{ .gpio = TEGRA_GPIO_SD2_WP,		.enable = true },
-	{ .gpio = TEGRA_GPIO_SD2_POWER,		.enable = true },
-	{ .gpio = TEGRA_GPIO_CDC_IRQ,		.enable = true },
-};
-
-static struct tegra_gpio_table seaboard_gpio_table[] = {
-	{ .gpio = TEGRA_GPIO_LIDSWITCH,		.enable = true },
-	{ .gpio = TEGRA_GPIO_POWERKEY,		.enable = true },
-	{ .gpio = TEGRA_GPIO_HP_DET,		.enable = true },
-	{ .gpio = TEGRA_GPIO_ISL29018_IRQ,	.enable = true },
-	{ .gpio = TEGRA_GPIO_USB1,		.enable = true },
-};
-
-static struct tegra_gpio_table ventana_gpio_table[] = {
-	/* hp_det */
-	{ .gpio = TEGRA_GPIO_PW2,		.enable = true },
-	/* int_mic_en */
-	{ .gpio = TEGRA_GPIO_PX0,		.enable = true },
-	/* ext_mic_en */
-	{ .gpio = TEGRA_GPIO_PX1,		.enable = true },
-};
-
 static struct tegra_board_pinmux_conf common_conf = {
 	.pgs = common_pinmux,
 	.pg_count = ARRAY_SIZE(common_pinmux),
-	.gpios = common_gpio_table,
-	.gpio_count = ARRAY_SIZE(common_gpio_table),
 };
 
 static struct tegra_board_pinmux_conf seaboard_conf = {
@@ -215,15 +187,11 @@ static struct tegra_board_pinmux_conf seaboard_conf = {
 	.pg_count = ARRAY_SIZE(seaboard_pinmux),
 	.drives = seaboard_drive_pinmux,
 	.drive_count = ARRAY_SIZE(seaboard_drive_pinmux),
-	.gpios = seaboard_gpio_table,
-	.gpio_count = ARRAY_SIZE(seaboard_gpio_table),
 };
 
 static struct tegra_board_pinmux_conf ventana_conf = {
 	.pgs = ventana_pinmux,
 	.pg_count = ARRAY_SIZE(ventana_pinmux),
-	.gpios = ventana_gpio_table,
-	.gpio_count = ARRAY_SIZE(ventana_gpio_table),
 };
 
 void seaboard_pinmux_init(void)
diff --git a/arch/arm/mach-tegra/board-seaboard.c b/arch/arm/mach-tegra/board-seaboard.c
index d669847..74a9db8 100644
--- a/arch/arm/mach-tegra/board-seaboard.c
+++ b/arch/arm/mach-tegra/board-seaboard.c
@@ -261,7 +261,6 @@ static void __init tegra_kaen_init(void)
 	debug_uart_platform_data[0].irq = INT_UARTB;
 
 	seaboard_audio_pdata.gpio_hp_mute = TEGRA_GPIO_KAEN_HP_MUTE;
-	tegra_gpio_enable(TEGRA_GPIO_KAEN_HP_MUTE);
 
 	seaboard_common_init();
 
diff --git a/arch/arm/mach-tegra/board-trimslice-pinmux.c b/arch/arm/mach-tegra/board-trimslice-pinmux.c
index a21a2be..a1902d4 100644
--- a/arch/arm/mach-tegra/board-trimslice-pinmux.c
+++ b/arch/arm/mach-tegra/board-trimslice-pinmux.c
@@ -13,7 +13,6 @@
  * GNU General Public License for more details.
  *
  */
-#include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/of.h>
@@ -21,7 +20,6 @@
 #include <mach/pinmux.h>
 #include <mach/pinmux-tegra20.h>
 
-#include "gpio-names.h"
 #include "board-pinmux.h"
 #include "board-trimslice.h"
 
@@ -144,19 +142,9 @@ static struct tegra_pingroup_config trimslice_pinmux[] = {
 	{TEGRA_PINGROUP_XM2D,  TEGRA_MUX_NONE,          TEGRA_PUPD_NORMAL,      TEGRA_TRI_NORMAL},
 };
 
-static struct tegra_gpio_table gpio_table[] = {
-	{ .gpio = TRIMSLICE_GPIO_SD4_CD, .enable = true	}, /* mmc4 cd */
-	{ .gpio = TRIMSLICE_GPIO_SD4_WP, .enable = true	}, /* mmc4 wp */
-
-	{ .gpio = TRIMSLICE_GPIO_USB1_MODE, .enable = true }, /* USB1 mode */
-	{ .gpio = TRIMSLICE_GPIO_USB2_RST,  .enable = true }, /* USB2 PHY rst */
-};
-
 static struct tegra_board_pinmux_conf conf = {
 	.pgs = trimslice_pinmux,
 	.pg_count = ARRAY_SIZE(trimslice_pinmux),
-	.gpios = gpio_table,
-	.gpio_count = ARRAY_SIZE(gpio_table),
 };
 
 void trimslice_pinmux_init(void)
diff --git a/arch/arm/mach-tegra/include/mach/gpio-tegra.h b/arch/arm/mach-tegra/include/mach/gpio-tegra.h
index 6140820..a978b3c 100644
--- a/arch/arm/mach-tegra/include/mach/gpio-tegra.h
+++ b/arch/arm/mach-tegra/include/mach/gpio-tegra.h
@@ -25,13 +25,4 @@
 
 #define TEGRA_NR_GPIOS		INT_GPIO_NR
 
-struct tegra_gpio_table {
-	int	gpio;	/* GPIO number */
-	bool	enable;	/* Enable for GPIO at init? */
-};
-
-void tegra_gpio_config(struct tegra_gpio_table *table, int num);
-void tegra_gpio_enable(int gpio);
-void tegra_gpio_disable(int gpio);
-
 #endif
diff --git a/arch/arm/mach-tegra/usb_phy.c b/arch/arm/mach-tegra/usb_phy.c
index 37576a7..9de6c6b 100644
--- a/arch/arm/mach-tegra/usb_phy.c
+++ b/arch/arm/mach-tegra/usb_phy.c
@@ -710,7 +710,6 @@ struct tegra_usb_phy *tegra_usb_phy_open(int instance, void __iomem *regs,
 			err = -ENXIO;
 			goto err1;
 		}
-		tegra_gpio_enable(ulpi_config->reset_gpio);
 		gpio_request(ulpi_config->reset_gpio, "ulpi_phy_reset_b");
 		gpio_direction_output(ulpi_config->reset_gpio, 0);
 		phy->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, 0);
diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 6f17671..1177199 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -29,7 +29,6 @@
 
 #include <asm/mach/irq.h>
 
-#include <mach/gpio-tegra.h>
 #include <mach/iomap.h>
 #include <mach/suspend.h>
 
@@ -105,14 +104,32 @@ static void tegra_gpio_mask_write(u32 reg, int gpio, int value)
 	tegra_gpio_writel(val, reg);
 }
 
-void tegra_gpio_enable(int gpio)
+int tegra_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
-	tegra_gpio_mask_write(GPIO_MSK_CNF(gpio), gpio, 1);
+	/*
+	 * We should call pinctrl_request_gpio() here. However, we can't. Tegra
+	 * muxes pins in groups not individually, and real boards exist where
+	 * most of a pin group needs to be used for some function, yet some of
+	 * the pins aren't actually used by that function in the mode the
+	 * controller operates on the board, and so those pins can be used as
+	 * GPIOs.
+	 *
+	 * This is true in practice on Seaboard/Springbank, where pin group ATC
+	 * is used by the NAND controller, but pin GMI_IORDY_PI5 is used as a
+	 * GPIO for the SD card slot's CD signal.
+	 *
+	 * On Tegra30, pins are muxed in groups and hence we could call
+	 * pinctrl here, but we don't for now.
+	 */
+	tegra_gpio_mask_write(GPIO_MSK_CNF(offset), offset, 1);
+
+	return 0;
 }
 
-void tegra_gpio_disable(int gpio)
+void tegra_gpio_free(struct gpio_chip *chip, unsigned offset)
 {
-	tegra_gpio_mask_write(GPIO_MSK_CNF(gpio), gpio, 0);
+	tegra_gpio_mask_write(GPIO_MSK_CNF(offset), offset, 0);
+	/* Similarly, we should call pinctrl_free_gpio() here */
 }
 
 static void tegra_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
@@ -146,13 +163,14 @@ static int tegra_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 
 static struct gpio_chip tegra_gpio_chip = {
 	.label			= "tegra-gpio",
+	.request		= tegra_gpio_request,
+	.free			= tegra_gpio_free,
 	.direction_input	= tegra_gpio_direction_input,
 	.get			= tegra_gpio_get,
 	.direction_output	= tegra_gpio_direction_output,
 	.set			= tegra_gpio_set,
 	.to_irq			= tegra_gpio_to_irq,
 	.base			= 0,
-	.ngpio			= TEGRA_NR_GPIOS,
 };
 
 static void tegra_gpio_irq_ack(struct irq_data *d)
@@ -459,20 +477,6 @@ static int __init tegra_gpio_init(void)
 }
 postcore_initcall(tegra_gpio_init);
 
-void __init tegra_gpio_config(struct tegra_gpio_table *table, int num)
-{
-	int i;
-
-	for (i = 0; i < num; i++) {
-		int gpio = table[i].gpio;
-
-		if (table[i].enable)
-			tegra_gpio_enable(gpio);
-		else
-			tegra_gpio_disable(gpio);
-	}
-}
-
 #ifdef	CONFIG_DEBUG_FS
 
 #include <linux/debugfs.h>
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index ccbca0b..1f63a07 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -270,7 +270,6 @@ static int __devinit sdhci_tegra_probe(struct platform_device *pdev)
 				"failed to allocate power gpio\n");
 			goto err_power_req;
 		}
-		tegra_gpio_enable(plat->power_gpio);
 		gpio_direction_output(plat->power_gpio, 1);
 	}
 
@@ -281,7 +280,6 @@ static int __devinit sdhci_tegra_probe(struct platform_device *pdev)
 				"failed to allocate cd gpio\n");
 			goto err_cd_req;
 		}
-		tegra_gpio_enable(plat->cd_gpio);
 		gpio_direction_input(plat->cd_gpio);
 
 		rc = request_irq(gpio_to_irq(plat->cd_gpio), carddetect_irq,
@@ -302,7 +300,6 @@ static int __devinit sdhci_tegra_probe(struct platform_device *pdev)
 				"failed to allocate wp gpio\n");
 			goto err_wp_req;
 		}
-		tegra_gpio_enable(plat->wp_gpio);
 		gpio_direction_input(plat->wp_gpio);
 	}
 
@@ -330,23 +327,17 @@ err_add_host:
 	clk_disable(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
 err_clk_get:
-	if (gpio_is_valid(plat->wp_gpio)) {
-		tegra_gpio_disable(plat->wp_gpio);
+	if (gpio_is_valid(plat->wp_gpio))
 		gpio_free(plat->wp_gpio);
-	}
 err_wp_req:
 	if (gpio_is_valid(plat->cd_gpio))
 		free_irq(gpio_to_irq(plat->cd_gpio), host);
 err_cd_irq_req:
-	if (gpio_is_valid(plat->cd_gpio)) {
-		tegra_gpio_disable(plat->cd_gpio);
+	if (gpio_is_valid(plat->cd_gpio))
 		gpio_free(plat->cd_gpio);
-	}
 err_cd_req:
-	if (gpio_is_valid(plat->power_gpio)) {
-		tegra_gpio_disable(plat->power_gpio);
+	if (gpio_is_valid(plat->power_gpio))
 		gpio_free(plat->power_gpio);
-	}
 err_power_req:
 err_no_plat:
 	sdhci_pltfm_free(pdev);
@@ -363,21 +354,16 @@ static int __devexit sdhci_tegra_remove(struct platform_device *pdev)
 
 	sdhci_remove_host(host, dead);
 
-	if (gpio_is_valid(plat->wp_gpio)) {
-		tegra_gpio_disable(plat->wp_gpio);
+	if (gpio_is_valid(plat->wp_gpio))
 		gpio_free(plat->wp_gpio);
-	}
 
 	if (gpio_is_valid(plat->cd_gpio)) {
 		free_irq(gpio_to_irq(plat->cd_gpio), host);
-		tegra_gpio_disable(plat->cd_gpio);
 		gpio_free(plat->cd_gpio);
 	}
 
-	if (gpio_is_valid(plat->power_gpio)) {
-		tegra_gpio_disable(plat->power_gpio);
+	if (gpio_is_valid(plat->power_gpio))
 		gpio_free(plat->power_gpio);
-	}
 
 	clk_disable(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
-- 
1.7.5.4

