Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1HHUfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:35:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39619 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab1HHUfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:35:43 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v2 3/3] ARM: Tegra: Seaboard: Add USB devices
Date: Mon,  8 Aug 2011 14:35:15 -0600
Message-Id: <1312835715-893-4-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1312835715-893-1-git-send-email-swarren@nvidia.com>
References: <1312835715-893-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seaboard has a couple of external USB ports. Add the platform devices and
GPIO infra-structure to enable these.

I tested both ports with a mouse on Seaboard non-clamshell.

This change is extracted from code in the ChromeOS 2.6.38 kernel.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: No change

 arch/arm/mach-tegra/board-seaboard-pinmux.c |    1 +
 arch/arm/mach-tegra/board-seaboard.c        |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/board-seaboard-pinmux.c b/arch/arm/mach-tegra/board-seaboard-pinmux.c
index 7879750..74f78b7 100644
--- a/arch/arm/mach-tegra/board-seaboard-pinmux.c
+++ b/arch/arm/mach-tegra/board-seaboard-pinmux.c
@@ -168,6 +168,7 @@ static struct tegra_gpio_table gpio_table[] = {
 	{ .gpio = TEGRA_GPIO_POWERKEY,		.enable = true },
 	{ .gpio = TEGRA_GPIO_ISL29018_IRQ,	.enable = true },
 	{ .gpio = TEGRA_GPIO_CDC_IRQ,		.enable = true },
+	{ .gpio = TEGRA_GPIO_USB1,		.enable = true },
 };
 
 void __init seaboard_pinmux_init(void)
diff --git a/arch/arm/mach-tegra/board-seaboard.c b/arch/arm/mach-tegra/board-seaboard.c
index 07cd8e4..237a94a 100644
--- a/arch/arm/mach-tegra/board-seaboard.c
+++ b/arch/arm/mach-tegra/board-seaboard.c
@@ -69,6 +69,8 @@ static __initdata struct tegra_clk_init_table seaboard_clk_init_table[] = {
 	{ "pll_a_out0",	"pll_a",	11289600,	true },
 	{ "cdev1",	NULL,		0,		true },
 	{ "i2s1",	"pll_a_out0",	11289600,	false},
+	{ "usbd",	"clk_m",	12000000,	true},
+	{ "usb3",	"clk_m",	12000000,	true},
 	{ NULL,		NULL,		0,		0},
 };
 
@@ -182,6 +184,29 @@ static struct i2c_board_info __initdata wm8903_device = {
 	.irq = TEGRA_GPIO_TO_IRQ(TEGRA_GPIO_CDC_IRQ),
 };
 
+static int seaboard_ehci_init(void)
+{
+	int gpio_status;
+
+	gpio_status = gpio_request(TEGRA_GPIO_USB1, "VBUS_USB1");
+	if (gpio_status < 0) {
+		pr_err("VBUS_USB1 request GPIO FAILED\n");
+		WARN_ON(1);
+	}
+
+	gpio_status = gpio_direction_output(TEGRA_GPIO_USB1, 1);
+	if (gpio_status < 0) {
+		pr_err("VBUS_USB1 request GPIO DIRECTION FAILED\n");
+		WARN_ON(1);
+	}
+	gpio_set_value(TEGRA_GPIO_USB1, 1);
+
+	platform_device_register(&tegra_ehci1_device);
+	platform_device_register(&tegra_ehci3_device);
+
+	return 0;
+}
+
 static void __init seaboard_i2c_init(void)
 {
 	gpio_request(TEGRA_GPIO_ISL29018_IRQ, "isl29018");
@@ -209,6 +234,8 @@ static void __init seaboard_common_init(void)
 	tegra_sdhci_device4.dev.platform_data = &sdhci_pdata4;
 
 	platform_add_devices(seaboard_devices, ARRAY_SIZE(seaboard_devices));
+
+	seaboard_ehci_init();
 }
 
 static void __init tegra_seaboard_init(void)
-- 
1.7.0.4

