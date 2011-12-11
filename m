Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1LKUQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:16:49 -0500
Received: from d1.icnet.pl ([212.160.220.21]:48589 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab1LKUQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:16:46 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        alsa-devel@alsa-project.org, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 06/10] ARM: OMAP1: ams-delta: Use GPIO API in modem setup
Date: Sun, 11 Dec 2011 21:12:04 +0100
Message-Id: <1323634328-856-7-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use Amstrad Delta custom I/O functions for setting up modem
related pins, use GPIO API instead. However, keep old pin definitions
used by ams_delta_latch2_write() for now, as those are still used by the
Amstrad Delta ASoC driver.

While being at it, extend the device platform data with a power
management hook which toggles one of those new GPIO pins.

Depends on patch 2/10 "ARM: OMAP1: Convert Amstrad E3 latches to
basic_mmio_gpio".

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mach-omap1/board-ams-delta.c |   44 ++++++++++++++++++++------------
 1 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index 7670374..5705481 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -262,16 +262,6 @@ static struct gpio _latch_gpios[] __initconst = {
 		.label	= "scard_cmdvcc",
 	},
 	{
-		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_NRESET,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "modem_nreset",
-	},
-	{
-		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_CODEC,
-		.flags	= GPIOF_OUT_INIT_LOW,
-		.label	= "modem_codec",
-	},
-	{
 		.gpio	= AMS_DELTA_LATCH2_GPIO_BASE + 14,
 		.flags	= GPIOF_OUT_INIT_LOW,
 		.label	= "hookflash1",
@@ -482,6 +472,12 @@ static void __init ams_delta_init(void)
 	omap_writew(omap_readw(ARM_RSTCT1) | 0x0004, ARM_RSTCT1);
 }
 
+static void _modem_pm(struct uart_port *port, unsigned int state, unsigned old)
+{
+	if (state != old)
+		gpio_set_value(AMS_DELTA_GPIO_PIN_MODEM_NRESET, state == 0);
+}
+
 static struct plat_serial8250_port ams_delta_modem_ports[] = {
 	{
 		.membase	= IOMEM(_MODEM_VIRT),
@@ -492,6 +488,7 @@ static struct plat_serial8250_port ams_delta_modem_ports[] = {
 		.iotype		= UPIO_MEM,
 		.regshift	= 1,
 		.uartclk	= BASE_BAUD * 16,
+		.pm		= _modem_pm,
 	},
 	{ },
 };
@@ -504,6 +501,24 @@ static struct platform_device ams_delta_modem_device = {
 	},
 };
 
+static struct gpio _modem_gpios[] __initconst = {
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_IRQ,
+		.flags	= GPIOF_DIR_IN,
+		.label	= "modem_irq",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_NRESET,
+		.flags	= GPIOF_OUT_INIT_HIGH,
+		.label	= "modem_nreset",
+	},
+	{
+		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_CODEC,
+		.flags	= GPIOF_OUT_INIT_HIGH,
+		.label	= "modem_codec",
+	},
+};
+
 static int __init ams_delta_modem_init(void)
 {
 	int err;
@@ -515,16 +530,11 @@ static int __init ams_delta_modem_init(void)
 	ams_delta_modem_ports[0].irq =
 			gpio_to_irq(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
 
-	err = gpio_request(AMS_DELTA_GPIO_PIN_MODEM_IRQ, "modem");
+	err = gpio_request_array(_modem_gpios, ARRAY_SIZE(_modem_gpios));
 	if (err) {
-		pr_err("Couldn't request gpio pin for modem\n");
+		pr_err("Couldn't request gpio pins for modem\n");
 		return err;
 	}
-	gpio_direction_input(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
-
-	ams_delta_latch2_write(
-		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC,
-		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC);
 
 	return platform_device_register(&ams_delta_modem_device);
 }
-- 
1.7.3.4

