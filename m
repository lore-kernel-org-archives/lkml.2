Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2AWN7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 08:59:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50559 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356Ab2AWN7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 08:59:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] mfd/ASoC: Convert WM8994 driver to use regmap patches
Date: Mon, 23 Jan 2012 13:59:31 +0000
Message-Id: <1327327172-8411-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327327172-8411-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1327327172-8411-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early revisions of several of the WM8994 variants have register updates
to improve performance. Move these over to using the regmap patch system
instead of open coding them in the audio driver. Since the regmap init
is done by the MFD the code is moved there.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

If possible I'd like to merge this via regmap as the regmap patch
support is new and won't be in mainline until 3.4.  Is that OK Samuel?

 drivers/mfd/wm8994-core.c |   61 ++++++++++++++++++++++++++++++++++++++++++++-
 sound/soc/codecs/wm8994.c |   25 +-----------------
 2 files changed, 61 insertions(+), 25 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index a215b15..f275427 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -359,6 +359,27 @@ static int wm8994_ldo_in_use(struct wm8994_pdata *pdata, int ldo)
 }
 #endif
 
+static const __devinitdata struct reg_default wm8994_revc_patch[] = {
+	{ 0x102, 0x3 },
+	{ 0x56, 0x3 },
+	{ 0x817, 0x0 },
+	{ 0x102, 0x0 },
+};
+
+static const __devinitdata struct reg_default wm8958_reva_patch[] = {
+	{ 0x102, 0x3 },
+	{ 0xcb, 0x81 },
+	{ 0x817, 0x0 },
+	{ 0x102, 0x0 },
+};
+
+static const __devinitdata struct reg_default wm1811_reva_patch[] = {
+	{ 0x102, 0x3 },
+	{ 0x5d, 0x7e },
+	{ 0x5e, 0x0 },
+	{ 0x102, 0x0 },
+};
+
 /*
  * Instantiate the generic non-control parts of the device.
  */
@@ -366,8 +387,9 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 {
 	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
 	struct regmap_config *regmap_config;
+	const struct reg_default *regmap_patch = NULL;
 	const char *devname;
-	int ret, i;
+	int ret, i, patch_regs;
 	int pulls = 0;
 
 	dev_set_drvdata(wm8994->dev, wm8994);
@@ -488,15 +510,42 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 				 "revision %c not fully supported\n",
 				 'A' + wm8994->revision);
 			break;
+		case 2:
+		case 3:
+			regmap_patch = wm8994_revc_patch;
+			patch_regs = ARRAY_SIZE(wm8994_revc_patch);
+			break;
+		default:
+			break;
+		}
+		break;
+
+	case WM8958:
+		switch (wm8994->revision) {
+		case 0:
+			regmap_patch = wm8958_reva_patch;
+			patch_regs = ARRAY_SIZE(wm8958_reva_patch);
+			break;
 		default:
 			break;
 		}
 		break;
+
 	case WM1811:
 		/* Revision C did not change the relevant layer */
 		if (wm8994->revision > 1)
 			wm8994->revision++;
+		switch (wm8994->revision) {
+		case 0:
+		case 1:
+			regmap_patch = wm1811_reva_patch;
+			patch_regs = ARRAY_SIZE(wm1811_reva_patch);
+			break;
+		default:
+			break;
+		}
 		break;
+
 	default:
 		break;
 	}
@@ -526,6 +575,16 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		return ret;
 	}
 
+	if (regmap_patch) {
+		ret = regmap_register_patch(wm8994->regmap, regmap_patch,
+					    patch_regs);
+		if (ret != 0) {
+			dev_err(wm8994->dev, "Failed to register patch: %d\n",
+				ret);
+			goto err_regmap;
+		}
+	}
+
 	if (pdata) {
 		wm8994->irq_base = pdata->irq_base;
 		wm8994->gpio_base = pdata->gpio_base;
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index b047bfa..143f1c4 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2090,26 +2090,9 @@ static int wm8994_set_bias_level(struct snd_soc_codec *codec,
 	case SND_SOC_BIAS_STANDBY:
 		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
 			switch (control->type) {
-			case WM8994:
-				if (wm8994->revision < 4) {
-					/* Tweak DC servo and DSP
-					 * configuration for improved
-					 * performance. */
-					snd_soc_write(codec, 0x102, 0x3);
-					snd_soc_write(codec, 0x56, 0x3);
-					snd_soc_write(codec, 0x817, 0);
-					snd_soc_write(codec, 0x102, 0);
-				}
-				break;
-
 			case WM8958:
 				if (wm8994->revision == 0) {
 					/* Optimise performance for rev A */
-					snd_soc_write(codec, 0x102, 0x3);
-					snd_soc_write(codec, 0xcb, 0x81);
-					snd_soc_write(codec, 0x817, 0);
-					snd_soc_write(codec, 0x102, 0);
-
 					snd_soc_update_bits(codec,
 							    WM8958_CHARGE_PUMP_2,
 							    WM8958_CP_DISCH,
@@ -2117,13 +2100,7 @@ static int wm8994_set_bias_level(struct snd_soc_codec *codec,
 				}
 				break;
 
-			case WM1811:
-				if (wm8994->revision < 2) {
-					snd_soc_write(codec, 0x102, 0x3);
-					snd_soc_write(codec, 0x5d, 0x7e);
-					snd_soc_write(codec, 0x5e, 0x0);
-					snd_soc_write(codec, 0x102, 0x0);
-				}
+			default:
 				break;
 			}
 
-- 
1.7.7.3

