Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1JLOwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:52:18 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:36081
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751759Ab1JLOwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:52:14 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [alsa-devel] [PATCH 5/9] ASoC: da7210: Add support for other DAI
 word lengths, format and mode
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 20:33:21 +0530
Message-ID: <1318431801.12107.416.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchs adds support for following,
(1) DAI 20 and 32 bit word sizes
(2) DAI left and right justified formats
(3) DAI slave mode

Signed-off-by: Ashish Chavan <ashish.chavan@kpitcummins.com>
Signed-off-by: David Dajun Chen <dchen@diasemi.com>
---
 sound/soc/codecs/da7210.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index 1b4554a..60f403b 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -120,12 +120,17 @@
 
 /* DAI_CFG1 bit fields */
 #define DA7210_DAI_WORD_S16_LE		(0 << 0)
+#define DA7210_DAI_WORD_S20_3LE		(1 << 0)
 #define DA7210_DAI_WORD_S24_LE		(2 << 0)
+#define DA7210_DAI_WORD_S32_LE		(3 << 0)
 #define DA7210_DAI_FLEN_64BIT		(1 << 2)
+#define DA7210_DAI_MODE_SLAVE		(0 << 7)
 #define DA7210_DAI_MODE_MASTER		(1 << 7)
 
 /* DAI_CFG3 bit fields */
 #define DA7210_DAI_FORMAT_I2SMODE	(0 << 0)
+#define DA7210_DAI_FORMAT_LEFT_J	(1 << 0)
+#define DA7210_DAI_FORMAT_RIGHT_J	(2 << 0)
 #define DA7210_DAI_OE			(1 << 3)
 #define DA7210_DAI_EN			(1 << 7)
 
@@ -401,9 +406,15 @@ static int da7210_hw_params(struct snd_pcm_substream *substream,
 	case SNDRV_PCM_FORMAT_S16_LE:
 		dai_cfg1 |= DA7210_DAI_WORD_S16_LE;
 		break;
+	case SNDRV_PCM_FORMAT_S20_3LE:
+		dai_cfg1 |= DA7210_DAI_WORD_S20_3LE;
+		break;
 	case SNDRV_PCM_FORMAT_S24_LE:
 		dai_cfg1 |= DA7210_DAI_WORD_S24_LE;
 		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		dai_cfg1 |= DA7210_DAI_WORD_S32_LE;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -508,6 +519,9 @@ static int da7210_set_dai_fmt(struct snd_soc_dai *codec_dai, u32 fmt)
 	case SND_SOC_DAIFMT_CBM_CFM:
 		dai_cfg1 |= DA7210_DAI_MODE_MASTER;
 		break;
+	case SND_SOC_DAIFMT_CBS_CFS:
+		dai_cfg1 |= DA7210_DAI_MODE_SLAVE;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -520,6 +534,12 @@ static int da7210_set_dai_fmt(struct snd_soc_dai *codec_dai, u32 fmt)
 	case SND_SOC_DAIFMT_I2S:
 		dai_cfg3 |= DA7210_DAI_FORMAT_I2SMODE;
 		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		dai_cfg3 |= DA7210_DAI_FORMAT_LEFT_J;
+		break;
+	case SND_SOC_DAIFMT_RIGHT_J:
+		dai_cfg3 |= DA7210_DAI_FORMAT_RIGHT_J;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -536,7 +556,8 @@ static int da7210_set_dai_fmt(struct snd_soc_dai *codec_dai, u32 fmt)
 	return 0;
 }
 
-#define DA7210_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE)
+#define DA7210_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE |\
+			SNDRV_PCM_FMTBIT_S24_LE | SNDRV_PCM_FMTBIT_S32_LE)
 
 /* DAI operations */
 static struct snd_soc_dai_ops da7210_dai_ops = {
-- 
1.7.1


