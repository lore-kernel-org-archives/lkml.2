Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1LKURJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:17:09 -0500
Received: from d1.icnet.pl ([212.160.220.21]:48641 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab1LKURG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:17:06 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        alsa-devel@alsa-project.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 07/10] ASoC: OMAP: ams-delta: Drive modem/codec pins over GPIO API
Date: Sun, 11 Dec 2011 21:12:05 +0100
Message-Id: <1323634328-856-8-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use Amstrad Delta custom I/O functions any longer, replace them
with GPIO. Old pin definitions, no longer used by the modem bits either,
can be dropped.

Depends on patch 2/10 "ARM: OMAP1: Convert Amstrad E3 latches to
basic_mmio_gpio".

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/plat-omap/include/plat/board-ams-delta.h |    2 --
 sound/soc/omap/ams-delta.c                        |   21 ++++++++++++---------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/board-ams-delta.h b/arch/arm/plat-omap/include/plat/board-ams-delta.h
index b586078..73fdab9 100644
--- a/arch/arm/plat-omap/include/plat/board-ams-delta.h
+++ b/arch/arm/plat-omap/include/plat/board-ams-delta.h
@@ -34,8 +34,6 @@
 #define AMD_DELTA_LATCH2_KEYBRD_DATA	0x0200
 #define AMD_DELTA_LATCH2_SCARD_RSTIN	0x0400
 #define AMD_DELTA_LATCH2_SCARD_CMDVCC	0x0800
-#define AMS_DELTA_LATCH2_MODEM_NRESET	0x1000
-#define AMS_DELTA_LATCH2_MODEM_CODEC	0x2000
 
 #define AMS_DELTA_GPIO_PIN_KEYBRD_DATA	0
 #define AMS_DELTA_GPIO_PIN_KEYBRD_CLK	1
diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index ccb8a6a..389c488 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -268,7 +268,7 @@ static void cx81801_timeout(unsigned long data)
 	/* Reconnect the codec DAI back from the modem to the CPU DAI
 	 * only if digital mute still off */
 	if (!muted)
-		ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_CODEC, 0);
+		gpio_set_value(AMS_DELTA_GPIO_PIN_MODEM_CODEC, 0);
 }
 
 /*
@@ -378,8 +378,7 @@ static void cx81801_receive(struct tty_struct *tty,
 		/* Apply config pulse by connecting the codec to the modem
 		 * if not already done */
 		if (apply)
-			ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_CODEC,
-						AMS_DELTA_LATCH2_MODEM_CODEC);
+			gpio_set_value(AMS_DELTA_GPIO_PIN_MODEM_CODEC, 1);
 		break;
 	}
 }
@@ -438,13 +437,11 @@ static int ams_delta_set_bias_level(struct snd_soc_card *card,
 	case SND_SOC_BIAS_PREPARE:
 	case SND_SOC_BIAS_STANDBY:
 		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF)
-			ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_NRESET,
-						AMS_DELTA_LATCH2_MODEM_NRESET);
+			gpio_set_value(AMS_DELTA_GPIO_PIN_MODEM_NRESET, 1);
 		break;
 	case SND_SOC_BIAS_OFF:
 		if (codec->dapm.bias_level != SND_SOC_BIAS_OFF)
-			ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_NRESET,
-						0);
+			gpio_set_value(AMS_DELTA_GPIO_PIN_MODEM_NRESET, 0);
 	}
 	codec->dapm.bias_level = level;
 
@@ -468,8 +465,7 @@ static int ams_delta_digital_mute(struct snd_soc_dai *dai, int mute)
 	spin_unlock_bh(&ams_delta_lock);
 
 	if (apply)
-		ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_CODEC,
-				mute ? AMS_DELTA_LATCH2_MODEM_CODEC : 0);
+		gpio_set_value(AMS_DELTA_GPIO_PIN_MODEM_CODEC, mute);
 	return 0;
 }
 
@@ -503,6 +499,13 @@ static int ams_delta_cx20442_init(struct snd_soc_pcm_runtime *rtd)
 	int ret;
 	/* Codec is ready, now add/activate board specific controls */
 
+	/*
+	 * *_MODEM_CODEC and *_MODEM_NRESET GPIO pins manipulated above are
+	 * assumed to be already requested from the board initialisation code,
+	 * which should be done while setting up the modem device which those
+	 * pins are used for control of in the first place.
+	 */
+
 	/* Store a pointer to the codec structure for tty ldisc use */
 	cx20442_codec = codec;
 
-- 
1.7.3.4

