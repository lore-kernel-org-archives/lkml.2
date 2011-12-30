Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab1L3DI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 22:08:28 -0500
Received: from d1.icnet.pl ([212.160.220.21]:50882 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab1L3DHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 22:07:43 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH v2 3/4] ARM: OMAP1: ams-delta: update the modem to use regulator API
Date: Fri, 30 Dec 2011 04:04:55 +0100
Message-Id: <1325214296-2888-4-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
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

Depends on patch 1/4 "ARM: OMAP1: ams-delta: set up a regulator over the
modem reset GPIO pin" to apply cleanly, and requires patch 2/4 "ASoC:
cx20442: add bias control over a platform provided regulator" for the
sound card / codec bundle to still work.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
No functional changes against initial version.

 arch/arm/mach-omap1/board-ams-delta.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index 074d3b5..3389237 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -526,6 +526,16 @@ static void __init ams_delta_init(void)
 	omap_writew(omap_readw(ARM_RSTCT1) | 0x0004, ARM_RSTCT1);
 }
 
+static void modem_pm(struct uart_port *port, unsigned int state, unsigned old)
+{
+	struct modem_private_data *priv = port->private_data;
+
+	if (state == old)
+		return;
+
+	regulator_toggle(priv, state == 0);
+}
+
 static struct plat_serial8250_port ams_delta_modem_ports[] = {
 	{
 		.membase	= IOMEM(MODEM_VIRT),
@@ -536,6 +546,8 @@ static struct plat_serial8250_port ams_delta_modem_ports[] = {
 		.iotype		= UPIO_MEM,
 		.regshift	= 1,
 		.uartclk	= BASE_BAUD * 16,
+		.pm		= modem_pm,
+		.private_data	= &modem_priv,
 	},
 	{ },
 };
@@ -584,9 +596,8 @@ static int __init late_init(void)
 	mutex_init(&modem_priv.consumer.lock);
 	modem_priv.regulator = ERR_PTR(-ENODEV);
 
-	ams_delta_latch2_write(
-		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC,
-		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC);
+	ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_CODEC,
+			AMS_DELTA_LATCH2_MODEM_CODEC);
 
 	err = platform_device_register(&ams_delta_modem_device);
 	if (err)
@@ -595,8 +606,9 @@ static int __init late_init(void)
 	/*
 	 * Once the modem device is registered, the modem_nreset
 	 * regulator can be requested on behalf of that device.
-	 * The regulator is used via ams_delta_latch_write()
-	 * by the modem and ASoC drivers until updated.
+	 * In addition to the modem .pm callback, that regulator
+	 * is still used via the ams_delta_latch_write() wrapper
+	 * by the ASoC driver until updated.
 	 */
 	modem_priv.regulator = regulator_get(&ams_delta_modem_device.dev,
 			"RESET#");
-- 
1.7.3.4

