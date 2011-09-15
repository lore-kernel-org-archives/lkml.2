Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab1IOMme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:42:34 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:51441 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933509Ab1IOMku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:50 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 17/17] ASoC: twl6040: Workaround for headset DC offset caused pop noise
Date: Thu, 15 Sep 2011 15:39:39 +0300
Message-Id: <1316090379-30760-18-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both Headset DAC need to be enabled at the same time, before any of
the output drivers are enabled.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/mfd/twl6040.h |    1 +
 sound/soc/codecs/twl6040.c  |   42 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index d9e05ea..0bbb1e7 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -122,6 +122,7 @@
 
 /* HSLCTL/R (0x10/0x11) fields */
 
+#define TWL6040_HSDACENA		(1 << 0)
 #define TWL6040_HSDACMODE		(1 << 1)
 #define TWL6040_HSDRVMODE		(1 << 3)
 
diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index abde625..063defc 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -90,6 +90,7 @@ struct twl6040_data {
 	int pll_power_mode;
 	int hs_power_mode;
 	int hs_power_mode_locked;
+	int hs_dac_enabled;
 	unsigned int clk_in;
 	unsigned int sysclk;
 	u16 hs_left_step;
@@ -660,6 +661,43 @@ static int headset_power_mode(struct snd_soc_codec *codec, int high_perf)
 static int twl6040_hs_dac_event(struct snd_soc_dapm_widget *w,
 			struct snd_kcontrol *kcontrol, int event)
 {
+	struct snd_soc_codec *codec = w->codec;
+	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
+	u8 hslctl, hsrctl;
+
+	/*
+	 * Workaround for Headset DC offset caused pop noise:
+	 * Both HS DAC need to be turned on (before the HS driver) and off at
+	 * the same time.
+	 */
+	if (SND_SOC_DAPM_EVENT_ON(event)) {
+		if (!priv->hs_dac_enabled++) {
+			hslctl = twl6040_read_reg_cache(codec,
+							TWL6040_REG_HSLCTL);
+			hslctl |= TWL6040_HSDACENA;
+
+			hsrctl = twl6040_read_reg_cache(codec,
+							TWL6040_REG_HSRCTL);
+			hsrctl |= TWL6040_HSDACENA;
+
+			twl6040_write(codec, TWL6040_REG_HSLCTL, hslctl);
+			twl6040_write(codec, TWL6040_REG_HSRCTL, hsrctl);
+		}
+	} else {
+		if (!--priv->hs_dac_enabled) {
+			hslctl = twl6040_read_reg_cache(codec,
+							TWL6040_REG_HSLCTL);
+			hslctl &= ~TWL6040_HSDACENA;
+
+			hsrctl = twl6040_read_reg_cache(codec,
+							TWL6040_REG_HSRCTL);
+			hsrctl &= ~TWL6040_HSDACENA;
+
+			twl6040_write(codec, TWL6040_REG_HSLCTL, hslctl);
+			twl6040_write(codec, TWL6040_REG_HSRCTL, hsrctl);
+		}
+	}
+
 	msleep(1);
 	return 0;
 }
@@ -1146,11 +1184,11 @@ static const struct snd_soc_dapm_widget twl6040_dapm_widgets[] = {
 
 	/* DACs */
 	SND_SOC_DAPM_DAC_E("HSDAC Left", "Headset Playback",
-			TWL6040_REG_HSLCTL, 0, 0,
+			SND_SOC_NOPM, 0, 0,
 			twl6040_hs_dac_event,
 			SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
 	SND_SOC_DAPM_DAC_E("HSDAC Right", "Headset Playback",
-			TWL6040_REG_HSRCTL, 0, 0,
+			SND_SOC_NOPM, 0, 0,
 			twl6040_hs_dac_event,
 			SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
 	SND_SOC_DAPM_DAC_E("HFDAC Left", "Handsfree Playback",
-- 
1.7.6.1

