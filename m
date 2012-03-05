Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab2CEQHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:07:03 -0500
Received: from d1.icnet.pl ([212.160.220.21]:36618 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab2CEQHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:07:00 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH v3 3/3] ASoC: OMAP: ams-delta: drop .set_bias_level callback
Date: Mon,  5 Mar 2012 17:05:12 +0100
Message-Id: <1330963512-20413-4-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1330963512-20413-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1330963512-20413-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This functionality has already been implemented in the cx20442 codec
driver (commit f75a8ff67d161b5166a2c2360bb2ffaefd5eb853, "ASoC: cx20442:
add bias control over a platform provided regulator"), no need to keep
it here duplicated.

Once done, remove the no longer used AMS_DELTA_LATCH2_MODEM_NRESET
symbol from the board header file and a call to the regulator_toggle()
helper function from the old API wrapper found in the board file.  While
being at it, simplify the way the modem .pm callback handles the
regulator and drop that helper function and its related consumer setup
completely.

Depends on patches 1/3 and 2/3 for clean apply and keep things working.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tony Lindgren <tony@atomide.com>
---
v2 -> v3 changes: none.

Changes against initial version:
* don't move consumer setup elements, now named to indicated their
  modem related purpose, down the file,
* don't track the regulator enable/disable state, compare new target
  power state with the old one instead; thanks to Mark Brown for
  suggesting this simplification,
* actually drop all references to AMS_DELTA_LATCH2_MODEM_NRESET.

 arch/arm/mach-omap1/board-ams-delta.c             |   42 +++-----------------
 arch/arm/plat-omap/include/plat/board-ams-delta.h |    1 -
 sound/soc/omap/ams-delta.c                        |   32 ----------------
 3 files changed, 7 insertions(+), 68 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index 2fb2cbb..cb6afe6 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -18,7 +18,6 @@
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/leds.h>
-#include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/fixed.h>
@@ -291,35 +290,8 @@ static struct platform_device modem_nreset_device = {
 
 struct modem_private_data {
 	struct regulator *regulator;
-	struct {
-		struct mutex lock;
-		bool enabled;
-	} consumer;
 };
 
-static int regulator_toggle(struct modem_private_data *priv, bool enable)
-{
-	int err = 0;
-
-	mutex_lock(&priv->consumer.lock);
-	if (IS_ERR(priv->regulator)) {
-		err = PTR_ERR(priv->regulator);
-	} else if (enable) {
-		if (!priv->consumer.enabled) {
-			err = regulator_enable(priv->regulator);
-			priv->consumer.enabled = true;
-		}
-	} else {
-		if (priv->consumer.enabled) {
-			err = regulator_disable(priv->regulator);
-			priv->consumer.enabled = false;
-		}
-	}
-	mutex_unlock(&priv->consumer.lock);
-
-	return err;
-}
-
 static struct modem_private_data modem_priv;
 
 void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value)
@@ -330,8 +302,6 @@ void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value)
 	for (; bit < ngpio; bit++, bitpos = bitpos << 1) {
 		if (!(mask & bitpos))
 			continue;
-		else if (base + bit == AMS_DELTA_GPIO_PIN_MODEM_NRESET)
-			regulator_toggle(&modem_priv, (value & bitpos) != 0);
 		else
 			gpio_set_value(base + bit, (value & bitpos) != 0);
 	}
@@ -530,10 +500,16 @@ static void modem_pm(struct uart_port *port, unsigned int state, unsigned old)
 {
 	struct modem_private_data *priv = port->private_data;
 
+	if (IS_ERR(priv->regulator))
+		return;
+
 	if (state == old)
 		return;
 
-	regulator_toggle(priv, state == 0);
+	if (state == 0)
+		regulator_enable(priv->regulator);
+	else if (old == 0)
+		regulator_disable(priv->regulator);
 }
 
 static struct plat_serial8250_port ams_delta_modem_ports[] = {
@@ -593,7 +569,6 @@ static int __init late_init(void)
 	gpio_direction_input(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
 
 	/* Initialize the modem_nreset regulator consumer before use */
-	mutex_init(&modem_priv.consumer.lock);
 	modem_priv.regulator = ERR_PTR(-ENODEV);
 
 	ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_CODEC,
@@ -606,9 +581,6 @@ static int __init late_init(void)
 	/*
 	 * Once the modem device is registered, the modem_nreset
 	 * regulator can be requested on behalf of that device.
-	 * In addition to the modem .pm callback, that regulator
-	 * is still used via the ams_delta_latch_write() wrapper
-	 * by the ASoC driver until updated.
 	 */
 	modem_priv.regulator = regulator_get(&ams_delta_modem_device.dev,
 			"RESET#");
diff --git a/arch/arm/plat-omap/include/plat/board-ams-delta.h b/arch/arm/plat-omap/include/plat/board-ams-delta.h
index 027e79e..ad6f865 100644
--- a/arch/arm/plat-omap/include/plat/board-ams-delta.h
+++ b/arch/arm/plat-omap/include/plat/board-ams-delta.h
@@ -30,7 +30,6 @@
 
 #define AMD_DELTA_LATCH2_SCARD_RSTIN	0x0400
 #define AMD_DELTA_LATCH2_SCARD_CMDVCC	0x0800
-#define AMS_DELTA_LATCH2_MODEM_NRESET	0x1000
 #define AMS_DELTA_LATCH2_MODEM_CODEC	0x2000
 
 #define AMS_DELTA_GPIO_PIN_KEYBRD_DATA	0
diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index da6e005..f610260 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -426,29 +426,6 @@ static struct snd_soc_ops ams_delta_ops = {
 };
 
 
-/* Board specific codec bias level control */
-static int ams_delta_set_bias_level(struct snd_soc_card *card,
-				    struct snd_soc_dapm_context *dapm,
-				    enum snd_soc_bias_level level)
-{
-	switch (level) {
-	case SND_SOC_BIAS_ON:
-	case SND_SOC_BIAS_PREPARE:
-	case SND_SOC_BIAS_STANDBY:
-		if (card->dapm.bias_level == SND_SOC_BIAS_OFF)
-			ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_NRESET,
-						AMS_DELTA_LATCH2_MODEM_NRESET);
-		break;
-	case SND_SOC_BIAS_OFF:
-		if (card->dapm.bias_level != SND_SOC_BIAS_OFF)
-			ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_NRESET,
-						0);
-	}
-	card->dapm.bias_level = level;
-
-	return 0;
-}
-
 /* Digital mute implemented using modem/CPU multiplexer.
  * Shares hardware with codec config pulse generation */
 static bool ams_delta_muted = 1;
@@ -512,9 +489,6 @@ static int ams_delta_cx20442_init(struct snd_soc_pcm_runtime *rtd)
 		ams_delta_ops.shutdown = ams_delta_shutdown;
 	}
 
-	/* Set codec bias level */
-	ams_delta_set_bias_level(card, dapm, SND_SOC_BIAS_STANDBY);
-
 	/* Add hook switch - can be used to control the codec from userspace
 	 * even if line discipline fails */
 	ret = snd_soc_jack_new(rtd->codec, "hook_switch",
@@ -598,7 +572,6 @@ static struct snd_soc_card ams_delta_audio_card = {
 	.owner = THIS_MODULE,
 	.dai_link = &ams_delta_dai_link,
 	.num_links = 1,
-	.set_bias_level = ams_delta_set_bias_level,
 };
 
 /* Module init/exit */
@@ -647,11 +620,6 @@ static void __exit ams_delta_module_exit(void)
 			ARRAY_SIZE(ams_delta_hook_switch_gpios),
 			ams_delta_hook_switch_gpios);
 
-	/* Keep modem power on */
-	ams_delta_set_bias_level(&ams_delta_audio_card,
-				 &ams_delta_audio_card.rtd[0].codec->dapm,
-				 SND_SOC_BIAS_STANDBY);
-
 	platform_device_unregister(cx20442_platform_device);
 	platform_device_unregister(ams_delta_audio_platform_device);
 }
-- 
1.7.3.4

