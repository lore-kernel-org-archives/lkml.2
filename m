Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1LWXO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 18:14:29 -0500
Received: from d1.icnet.pl ([212.160.220.21]:36099 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758016Ab1LWXOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 18:14:24 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH 3/4] ARM: OMAP1: ams-delta: update the modem to use regulator API
Date: Sat, 24 Dec 2011 00:12:23 +0100
Message-Id: <1324681944-19067-4-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1324681944-19067-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1324681944-19067-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the CX20442 codec driver already takes care of enabling the codec
power for itself, but before dropping the old bias control method from
the Amstrad Delta ASoC sound card file, which in fact keeps the modem
power always on, even after the ASoC device close for now, extend the
modem setup with a power management callback, which toggles the
regulator up to the modem's needs, reusing the previously set up
regulator consumer for this. Also, drop the MODEM_NRESET pin setup from
the modem initialization procedure, as this operation was already
ineffective since patch 1/4, and not needed because the regulator is set
up as initially enabled.

Depends on patch 1/4 "ARM: OMAP1: ams-delta: set up regulator over modem
reset GPIO pin" to apply cleanly, and requires patch 2/4 "ASoC: cx20442:
add bias control over a platform provided regulator" for the sound card
/ codec bundle to still work correctly in coexistence with the modem.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mach-omap1/board-ams-delta.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index b5a1a3b..9b52aeb 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -528,6 +528,14 @@ static void __init ams_delta_init(void)
 	omap_writew(omap_readw(ARM_RSTCT1) | 0x0004, ARM_RSTCT1);
 }
 
+static void modem_pm(struct uart_port *port, unsigned int state, unsigned old)
+{
+	struct regulator_consumer_data *consumer = port->private_data;
+
+	if (state != old)
+		regulator_toggle(consumer, state == 0);
+}
+
 static struct plat_serial8250_port ams_delta_modem_ports[] = {
 	{
 		.membase	= IOMEM(MODEM_VIRT),
@@ -538,6 +546,8 @@ static struct plat_serial8250_port ams_delta_modem_ports[] = {
 		.iotype		= UPIO_MEM,
 		.regshift	= 1,
 		.uartclk	= BASE_BAUD * 16,
+		.pm		= modem_pm,
+		.private_data	= &modem_nreset,
 	},
 	{ },
 };
@@ -582,9 +592,8 @@ static int __init late_init(void)
 	}
 	gpio_direction_input(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
 
-	ams_delta_latch2_write(
-		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC,
-		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC);
+	ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_CODEC,
+			AMS_DELTA_LATCH2_MODEM_CODEC);
 
 	err = platform_device_register(&ams_delta_modem_device);
 	if (err)
@@ -593,8 +602,9 @@ static int __init late_init(void)
 	/*
 	 * Once the modem device is registered, the modem_nreset
 	 * regulator can be requested on behalf of that device.
-	 * The regulator is used via ams_delta_latch_write()
-	 * by the modem and ASoC drivers until updated.
+	 * In addition to the modem .pm callback, that regulator
+	 * is still used via the ams_delta_latch_write() wrapper
+	 * by the ASoC driver until updated.
 	 */
 	mutex_init(&modem_nreset.lock);
 	modem_nreset.regulator = regulator_get(&ams_delta_modem_device.dev,
-- 
1.7.3.4

