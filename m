Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1BRDMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:12:45 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51861 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab1BRDIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:06 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 13/29] twl4030: mfd_cell is now implicitly available to drivers (v2)
Date: Thu, 17 Feb 2011 19:07:20 -0800
Message-Id: <1297998456-7615-14-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cell's platform_data is now accessed with a helper function;
change clients to use that, and remove the now-unused data_size.

v2: add some missing mfd/core.h includes.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/input/misc/twl4030-vibra.c |    3 ++-
 drivers/mfd/twl4030-codec.c        |    2 --
 sound/soc/codecs/twl4030.c         |    6 ++++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
index 014dd4a..6a11694 100644
--- a/drivers/input/misc/twl4030-vibra.c
+++ b/drivers/input/misc/twl4030-vibra.c
@@ -29,6 +29,7 @@
 #include <linux/workqueue.h>
 #include <linux/i2c/twl.h>
 #include <linux/mfd/twl4030-codec.h>
+#include <linux/mfd/core.h>
 #include <linux/input.h>
 #include <linux/slab.h>
 
@@ -196,7 +197,7 @@ static SIMPLE_DEV_PM_OPS(twl4030_vibra_pm_ops,
 
 static int __devinit twl4030_vibra_probe(struct platform_device *pdev)
 {
-	struct twl4030_codec_vibra_data *pdata = pdev->dev.platform_data;
+	struct twl4030_codec_vibra_data *pdata = mfd_get_data(pdev);
 	struct vibra_info *info;
 	int ret;
 
diff --git a/drivers/mfd/twl4030-codec.c b/drivers/mfd/twl4030-codec.c
index 9a4b196..0f57426 100644
--- a/drivers/mfd/twl4030-codec.c
+++ b/drivers/mfd/twl4030-codec.c
@@ -209,14 +209,12 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 		cell = &codec->cells[childs];
 		cell->name = "twl4030-codec";
 		cell->platform_data = pdata->audio;
-		cell->data_size = sizeof(*pdata->audio);
 		childs++;
 	}
 	if (pdata->vibra) {
 		cell = &codec->cells[childs];
 		cell->name = "twl4030-vibra";
 		cell->platform_data = pdata->vibra;
-		cell->data_size = sizeof(*pdata->vibra);
 		childs++;
 	}
 
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index e4d464b..8512800 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -26,6 +26,7 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
+#include <linux/mfd/core.h>
 #include <linux/i2c/twl.h>
 #include <linux/slab.h>
 #include <sound/core.h>
@@ -732,7 +733,8 @@ static int aif_event(struct snd_soc_dapm_widget *w,
 
 static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 {
-	struct twl4030_codec_audio_data *pdata = codec->dev->platform_data;
+	struct twl4030_codec_audio_data *pdata =
+			mfd_get_data(to_platform_device(codec->dev));
 	unsigned char hs_gain, hs_pop;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
 	/* Base values for ramp delay calculation: 2^19 - 2^26 */
@@ -2297,7 +2299,7 @@ static struct snd_soc_codec_driver soc_codec_dev_twl4030 = {
 
 static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 {
-	struct twl4030_codec_audio_data *pdata = pdev->dev.platform_data;
+	struct twl4030_codec_audio_data *pdata = mfd_get_data(pdev);
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "platform_data is missing\n");
-- 
1.7.2.3

