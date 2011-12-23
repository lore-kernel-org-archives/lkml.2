Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab1LWXOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 18:14:36 -0500
Received: from d1.icnet.pl ([212.160.220.21]:36123 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757999Ab1LWXOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 18:14:31 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH 4/4] ASoC: OMAP: ams-delta: drop .set_bias_level callback
Date: Sat, 24 Dec 2011 00:12:24 +0100
Message-Id: <1324681944-19067-5-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1324681944-19067-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1324681944-19067-1-git-send-email-jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This functionality has just been implemented in the cx20442 codec
driver, no need to keep it here duplicated.

Once done, remove the no longer needed AMS_DELTA_LATCH2_MODEM_NRESET
symbol from the Amstrad Delta header file, and a call to the
regulator_toggle() helper function from the old API wrapper found in the
board file.  While being at it, move that function definition, together
with the regulator consumer related data structure, down to the modem
related section for better readability.

Depends on patch 3/4 "ARM: OMAP1: ams-delta: update the modem to use
regulator API"

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mach-omap1/board-ams-delta.c             |   75 ++++++++++-----------
 arch/arm/plat-omap/include/plat/board-ams-delta.h |    1 -
 sound/soc/omap/ams-delta.c                        |   34 ---------
 3 files changed, 36 insertions(+), 74 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index 9b52aeb..945c4db 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -289,41 +289,6 @@ static struct platform_device modem_nreset_device = {
 	},
 };
 
-struct regulator_consumer_data {
-	struct mutex lock;
-	struct regulator *regulator;
-	bool enabled;
-};
-
-static int regulator_toggle(struct regulator_consumer_data *consumer,
-		bool enable)
-{
-	int err = 0;
-
-	if (!consumer->regulator)
-		return -ENODEV;
-
-	mutex_lock(&consumer->lock);
-	if (IS_ERR(consumer->regulator)) {
-		err = PTR_ERR(consumer->regulator);
-	} else if (enable) {
-		if (!consumer->enabled) {
-			err = regulator_enable(consumer->regulator);
-			consumer->enabled = true;
-		}
-	} else {
-		if (consumer->enabled) {
-			err = regulator_disable(consumer->regulator);
-			consumer->enabled = false;
-		}
-	}
-	mutex_unlock(&consumer->lock);
-
-	return err;
-}
-
-static struct regulator_consumer_data modem_nreset;
-
 void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value)
 {
 	int bit = 0;
@@ -333,7 +298,7 @@ void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value)
 		if (!(mask & bitpos))
 			continue;
 		if (base + bit == AMS_DELTA_GPIO_PIN_MODEM_NRESET)
-			regulator_toggle(&modem_nreset, (value & bitpos) != 0);
+			continue;
 		else
 			gpio_set_value(base + bit, (value & bitpos) != 0);
 	}
@@ -528,6 +493,39 @@ static void __init ams_delta_init(void)
 	omap_writew(omap_readw(ARM_RSTCT1) | 0x0004, ARM_RSTCT1);
 }
 
+struct regulator_consumer_data {
+	struct mutex lock;
+	struct regulator *regulator;
+	bool enabled;
+};
+
+static int regulator_toggle(struct regulator_consumer_data *consumer,
+		bool enable)
+{
+	int err = 0;
+
+	if (!consumer->regulator)
+		return -ENODEV;
+
+	mutex_lock(&consumer->lock);
+	if (IS_ERR(consumer->regulator)) {
+		err = PTR_ERR(consumer->regulator);
+	} else if (enable) {
+		if (!consumer->enabled) {
+			err = regulator_enable(consumer->regulator);
+			consumer->enabled = true;
+		}
+	} else {
+		if (consumer->enabled) {
+			err = regulator_disable(consumer->regulator);
+			consumer->enabled = false;
+		}
+	}
+	mutex_unlock(&consumer->lock);
+
+	return err;
+}
+
 static void modem_pm(struct uart_port *port, unsigned int state, unsigned old)
 {
 	struct regulator_consumer_data *consumer = port->private_data;
@@ -536,6 +534,8 @@ static void modem_pm(struct uart_port *port, unsigned int state, unsigned old)
 		regulator_toggle(consumer, state == 0);
 }
 
+static struct regulator_consumer_data modem_nreset;
+
 static struct plat_serial8250_port ams_delta_modem_ports[] = {
 	{
 		.membase	= IOMEM(MODEM_VIRT),
@@ -602,9 +602,6 @@ static int __init late_init(void)
 	/*
 	 * Once the modem device is registered, the modem_nreset
 	 * regulator can be requested on behalf of that device.
-	 * In addition to the modem .pm callback, that regulator
-	 * is still used via the ams_delta_latch_write() wrapper
-	 * by the ASoC driver until updated.
 	 */
 	mutex_init(&modem_nreset.lock);
 	modem_nreset.regulator = regulator_get(&ams_delta_modem_device.dev,
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
index be81bc7..d213d04 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -426,31 +426,6 @@ static struct snd_soc_ops ams_delta_ops = {
 };
 
 
-/* Board specific codec bias level control */
-static int ams_delta_set_bias_level(struct snd_soc_card *card,
-				    struct snd_soc_dapm_context *dapm,
-				    enum snd_soc_bias_level level)
-{
-	struct snd_soc_codec *codec = card->rtd->codec;
-
-	switch (level) {
-	case SND_SOC_BIAS_ON:
-	case SND_SOC_BIAS_PREPARE:
-	case SND_SOC_BIAS_STANDBY:
-		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF)
-			ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_NRESET,
-						AMS_DELTA_LATCH2_MODEM_NRESET);
-		break;
-	case SND_SOC_BIAS_OFF:
-		if (codec->dapm.bias_level != SND_SOC_BIAS_OFF)
-			ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_NRESET,
-						0);
-	}
-	codec->dapm.bias_level = level;
-
-	return 0;
-}
-
 /* Digital mute implemented using modem/CPU multiplexer.
  * Shares hardware with codec config pulse generation */
 static bool ams_delta_muted = 1;
@@ -514,9 +489,6 @@ static int ams_delta_cx20442_init(struct snd_soc_pcm_runtime *rtd)
 		ams_delta_ops.shutdown = ams_delta_shutdown;
 	}
 
-	/* Set codec bias level */
-	ams_delta_set_bias_level(card, dapm, SND_SOC_BIAS_STANDBY);
-
 	/* Add hook switch - can be used to control the codec from userspace
 	 * even if line discipline fails */
 	ret = snd_soc_jack_new(rtd->codec, "hook_switch",
@@ -599,7 +571,6 @@ static struct snd_soc_card ams_delta_audio_card = {
 	.name = "AMS_DELTA",
 	.dai_link = &ams_delta_dai_link,
 	.num_links = 1,
-	.set_bias_level = ams_delta_set_bias_level,
 };
 
 /* Module init/exit */
@@ -648,11 +619,6 @@ static void __exit ams_delta_module_exit(void)
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

