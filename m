Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2CEQGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:06:55 -0500
Received: from d1.icnet.pl ([212.160.220.21]:36592 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab2CEQGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:06:53 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH v3 2/3] ARM: OMAP1: ams-delta: update the modem to use regulator API
Date: Mon,  5 Mar 2012 17:05:11 +0100
Message-Id: <1330963512-20413-3-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1330963512-20413-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1330963512-20413-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the CX20442 codec driver already takes care of enabling the codec
power for itself (commit f75a8ff67d161b5166a2c2360bb2ffaefd5eb853,
"ASoC: cx20442: add bias control over a platform provided regulator"),
but before dropping the old bias control method from the Amstrad Delta
ASoC sound card file, which in fact keeps the modem power always on,
even on the ASoC device close for now, extend the modem setup with a
power management callback which toggles the regulator up to the modem's
needs, reusing the previously set up regulator consumer for this. Also,
drop the MODEM_NRESET pin setup from the modem initialization procedure,
as this operation was already ineffective since patch 1/3, and not
needed because the regulator is set up as initially enabled.

Depends on patch 1/3 "ARM: OMAP1: ams-delta: set up regulator over modem
reset GPIO pin" to apply cleanly.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>
---
No functional changes against initial version.

 arch/arm/mach-omap1/board-ams-delta.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index 949997c..2fb2cbb 100644
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

