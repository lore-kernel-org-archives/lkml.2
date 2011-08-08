Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1HHUfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:35:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48219 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab1HHUfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:35:37 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v2 2/3] ARM: Tegra: Seaboard board updates for audio
Date: Mon,  8 Aug 2011 14:35:14 -0600
Message-Id: <1312835715-893-3-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1312835715-893-1-git-send-email-swarren@nvidia.com>
References: <1312835715-893-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Initialize clock tree for audio
* Add GPIO base definitions
* Add audio GPIO definitions
* Define platform data for WM8903 and ASoC machine driver
* Add special case for Kaen to handle HP_MUTE GPIO
* Register platform devices for audio
* Update pinmux to cater for new GPIOs used for audio

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Simplify WM8903 interrupt GPIO registration, to match Harmony.
    ... It turns out the HW issue I was WARing in v1 (multiple signal
        drivers) is a non-issue, since both drivers drive the same value,
        hence we can handle this GPIO and pingroup just like any other.

 arch/arm/mach-tegra/board-seaboard-pinmux.c |    5 ++-
 arch/arm/mach-tegra/board-seaboard.c        |   51 +++++++++++++++++++++++++++
 arch/arm/mach-tegra/board-seaboard.h        |   12 ++++--
 3 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-tegra/board-seaboard-pinmux.c b/arch/arm/mach-tegra/board-seaboard-pinmux.c
index 0bda495..7879750 100644
--- a/arch/arm/mach-tegra/board-seaboard-pinmux.c
+++ b/arch/arm/mach-tegra/board-seaboard-pinmux.c
@@ -49,7 +49,7 @@ static __initdata struct tegra_pingroup_config seaboard_pinmux[] = {
 	{TEGRA_PINGROUP_CRTP,  TEGRA_MUX_CRT,           TEGRA_PUPD_PULL_UP,   TEGRA_TRI_TRISTATE},
 	{TEGRA_PINGROUP_CSUS,  TEGRA_MUX_VI_SENSOR_CLK, TEGRA_PUPD_NORMAL,    TEGRA_TRI_TRISTATE},
 	{TEGRA_PINGROUP_DAP1,  TEGRA_MUX_DAP1,          TEGRA_PUPD_NORMAL,    TEGRA_TRI_NORMAL},
-	{TEGRA_PINGROUP_DAP2,  TEGRA_MUX_DAP2,          TEGRA_PUPD_NORMAL,    TEGRA_TRI_TRISTATE},
+	{TEGRA_PINGROUP_DAP2,  TEGRA_MUX_DAP2,          TEGRA_PUPD_NORMAL,    TEGRA_TRI_NORMAL},
 	{TEGRA_PINGROUP_DAP3,  TEGRA_MUX_DAP3,          TEGRA_PUPD_NORMAL,    TEGRA_TRI_TRISTATE},
 	{TEGRA_PINGROUP_DAP4,  TEGRA_MUX_DAP4,          TEGRA_PUPD_NORMAL,    TEGRA_TRI_NORMAL},
 	{TEGRA_PINGROUP_DDC,   TEGRA_MUX_RSVD2,         TEGRA_PUPD_NORMAL,    TEGRA_TRI_TRISTATE},
@@ -133,7 +133,7 @@ static __initdata struct tegra_pingroup_config seaboard_pinmux[] = {
 	{TEGRA_PINGROUP_SPDO,  TEGRA_MUX_RSVD2,         TEGRA_PUPD_NORMAL,    TEGRA_TRI_NORMAL},
 	{TEGRA_PINGROUP_SPIA,  TEGRA_MUX_GMI,           TEGRA_PUPD_PULL_UP,   TEGRA_TRI_TRISTATE},
 	{TEGRA_PINGROUP_SPIB,  TEGRA_MUX_GMI,           TEGRA_PUPD_NORMAL,    TEGRA_TRI_TRISTATE},
-	{TEGRA_PINGROUP_SPIC,  TEGRA_MUX_GMI,           TEGRA_PUPD_NORMAL,    TEGRA_TRI_TRISTATE},
+	{TEGRA_PINGROUP_SPIC,  TEGRA_MUX_GMI,           TEGRA_PUPD_PULL_UP,   TEGRA_TRI_NORMAL},
 	{TEGRA_PINGROUP_SPID,  TEGRA_MUX_SPI1,          TEGRA_PUPD_NORMAL,    TEGRA_TRI_TRISTATE},
 	{TEGRA_PINGROUP_SPIE,  TEGRA_MUX_SPI1,          TEGRA_PUPD_NORMAL,    TEGRA_TRI_TRISTATE},
 	{TEGRA_PINGROUP_SPIF,  TEGRA_MUX_SPI1,          TEGRA_PUPD_PULL_DOWN, TEGRA_TRI_TRISTATE},
@@ -167,6 +167,7 @@ static struct tegra_gpio_table gpio_table[] = {
 	{ .gpio = TEGRA_GPIO_LIDSWITCH,		.enable = true },
 	{ .gpio = TEGRA_GPIO_POWERKEY,		.enable = true },
 	{ .gpio = TEGRA_GPIO_ISL29018_IRQ,	.enable = true },
+	{ .gpio = TEGRA_GPIO_CDC_IRQ,		.enable = true },
 };
 
 void __init seaboard_pinmux_init(void)
diff --git a/arch/arm/mach-tegra/board-seaboard.c b/arch/arm/mach-tegra/board-seaboard.c
index 56cbabf..07cd8e4 100644
--- a/arch/arm/mach-tegra/board-seaboard.c
+++ b/arch/arm/mach-tegra/board-seaboard.c
@@ -25,9 +25,12 @@
 #include <linux/gpio.h>
 #include <linux/gpio_keys.h>
 
+#include <sound/wm8903.h>
+
 #include <mach/iomap.h>
 #include <mach/irqs.h>
 #include <mach/sdhci.h>
+#include <mach/tegra_wm8903_pdata.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -62,6 +65,10 @@ static __initdata struct tegra_clk_init_table seaboard_clk_init_table[] = {
 	/* name		parent		rate		enabled */
 	{ "uartb",	"pll_p",	216000000,	true},
 	{ "uartd",	"pll_p",	216000000,	true},
+	{ "pll_a",	"pll_p_out1",	56448000,	true },
+	{ "pll_a_out0",	"pll_a",	11289600,	true },
+	{ "cdev1",	NULL,		0,		true },
+	{ "i2s1",	"pll_a_out0",	11289600,	false},
 	{ NULL,		NULL,		0,		0},
 };
 
@@ -117,6 +124,22 @@ static struct tegra_sdhci_platform_data sdhci_pdata4 = {
 	.is_8bit	= 1,
 };
 
+static struct tegra_wm8903_platform_data seaboard_audio_pdata = {
+	.gpio_spkr_en		= TEGRA_GPIO_SPKR_EN,
+	.gpio_hp_det		= TEGRA_GPIO_HP_DET,
+	.gpio_hp_mute		= -1,
+	.gpio_int_mic_en	= -1,
+	.gpio_ext_mic_en	= -1,
+};
+
+static struct platform_device seaboard_audio_device = {
+	.name	= "tegra-snd-wm8903",
+	.id	= 0,
+	.dev	= {
+		.platform_data  = &seaboard_audio_pdata,
+	},
+};
+
 static struct platform_device *seaboard_devices[] __initdata = {
 	&debug_uart,
 	&tegra_pmu_device,
@@ -124,6 +147,10 @@ static struct platform_device *seaboard_devices[] __initdata = {
 	&tegra_sdhci_device3,
 	&tegra_sdhci_device1,
 	&seaboard_gpio_keys_device,
+	&tegra_i2s_device1,
+	&tegra_das_device,
+	&tegra_pcm_device,
+	&seaboard_audio_device,
 };
 
 static struct i2c_board_info __initdata isl29018_device = {
@@ -135,12 +162,33 @@ static struct i2c_board_info __initdata adt7461_device = {
 	I2C_BOARD_INFO("adt7461", 0x4c),
 };
 
+static struct wm8903_platform_data wm8903_pdata = {
+	.irq_active_low = 0,
+	.micdet_cfg = 0,
+	.micdet_delay = 100,
+	.gpio_base = SEABOARD_GPIO_WM8903(0),
+	.gpio_cfg = {
+		WM8903_GPIO_NO_CONFIG,
+		WM8903_GPIO_NO_CONFIG,
+		0,
+		WM8903_GPIO_NO_CONFIG,
+		WM8903_GPIO_NO_CONFIG,
+	},
+};
+
+static struct i2c_board_info __initdata wm8903_device = {
+	I2C_BOARD_INFO("wm8903", 0x1a),
+	.platform_data = &wm8903_pdata,
+	.irq = TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_CDC_IRQ),
+};
+
 static void __init seaboard_i2c_init(void)
 {
 	gpio_request(TEGRA_GPIO_ISL29018_IRQ, "isl29018");
 	gpio_direction_input(TEGRA_GPIO_ISL29018_IRQ);
 
 	i2c_register_board_info(0, &isl29018_device, 1);
+	i2c_register_board_info(0, &wm8903_device, 1);
 
 	i2c_register_board_info(3, &adt7461_device, 1);
 
@@ -182,6 +230,9 @@ static void __init tegra_kaen_init(void)
 	debug_uart_platform_data[0].mapbase = TEGRA_UARTB_BASE;
 	debug_uart_platform_data[0].irq = INT_UARTB;
 
+	seaboard_audio_pdata.gpio_hp_mute = TEGRA_GPIO_KAEN_HP_MUTE;
+	tegra_gpio_enable(TEGRA_GPIO_KAEN_HP_MUTE);
+
 	seaboard_common_init();
 
 	seaboard_i2c_init();
diff --git a/arch/arm/mach-tegra/board-seaboard.h b/arch/arm/mach-tegra/board-seaboard.h
index d8415e1..d06c334 100644
--- a/arch/arm/mach-tegra/board-seaboard.h
+++ b/arch/arm/mach-tegra/board-seaboard.h
@@ -17,6 +17,9 @@
 #ifndef _MACH_TEGRA_BOARD_SEABOARD_H
 #define _MACH_TEGRA_BOARD_SEABOARD_H
 
+#define SEABOARD_GPIO_TPS6586X(_x_)	(TEGRA_NR_GPIOS + (_x_))
+#define SEABOARD_GPIO_WM8903(_x_)	(SEABOARD_GPIO_TPS6586X(4) + (_x_))
+
 #define TEGRA_GPIO_SD2_CD		TEGRA_GPIO_PI5
 #define TEGRA_GPIO_SD2_WP		TEGRA_GPIO_PH1
 #define TEGRA_GPIO_SD2_POWER		TEGRA_GPIO_PI6
@@ -31,10 +34,11 @@
 #define TEGRA_GPIO_MAGNETOMETER		TEGRA_GPIO_PN5
 #define TEGRA_GPIO_ISL29018_IRQ		TEGRA_GPIO_PZ2
 #define TEGRA_GPIO_AC_ONLINE		TEGRA_GPIO_PV3
-
-#define TPS_GPIO_BASE			TEGRA_NR_GPIOS
-
-#define TPS_GPIO_WWAN_PWR		(TPS_GPIO_BASE + 2)
+#define TEGRA_GPIO_WWAN_PWR		SEABOARD_GPIO_TPS6586X(2)
+#define TEGRA_GPIO_CDC_IRQ		TEGRA_GPIO_PX3
+#define TEGRA_GPIO_SPKR_EN		SEABOARD_GPIO_WM8903(2)
+#define TEGRA_GPIO_HP_DET		TEGRA_GPIO_PX1
+#define TEGRA_GPIO_KAEN_HP_MUTE		TEGRA_GPIO_PA5
 
 void seaboard_pinmux_init(void);
 
-- 
1.7.0.4

