Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab1EIAds (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:12753 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab1EIAdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="919713029"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 15/19] mfd: Use mfd cell platform_data for twl4030 codec cells platform bits
Date: Mon,  9 May 2011 02:32:07 +0200
Message-Id: <1304901131-7104-16-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a platform device mfd_cell pointer, MFD drivers
can go back to passing platform data back to their sub drivers.
This allows for an mfd_cell->mfd_data removal and thus keep the
sub drivers MFD agnostic. This is mostly needed for non MFD aware
sub drivers.

Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/input/misc/twl4030-vibra.c |    3 +--
 drivers/mfd/twl4030-codec.c        |    6 ++++--
 sound/soc/codecs/twl4030.c         |    6 ++----
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
index 6a11694..014dd4a 100644
--- a/drivers/input/misc/twl4030-vibra.c
+++ b/drivers/input/misc/twl4030-vibra.c
@@ -29,7 +29,6 @@
 #include <linux/workqueue.h>
 #include <linux/i2c/twl.h>
 #include <linux/mfd/twl4030-codec.h>
-#include <linux/mfd/core.h>
 #include <linux/input.h>
 #include <linux/slab.h>
 
@@ -197,7 +196,7 @@ static SIMPLE_DEV_PM_OPS(twl4030_vibra_pm_ops,
 
 static int __devinit twl4030_vibra_probe(struct platform_device *pdev)
 {
-	struct twl4030_codec_vibra_data *pdata = mfd_get_data(pdev);
+	struct twl4030_codec_vibra_data *pdata = pdev->dev.platform_data;
 	struct vibra_info *info;
 	int ret;
 
diff --git a/drivers/mfd/twl4030-codec.c b/drivers/mfd/twl4030-codec.c
index c02fded..315b5ea 100644
--- a/drivers/mfd/twl4030-codec.c
+++ b/drivers/mfd/twl4030-codec.c
@@ -208,13 +208,15 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 	if (pdata->audio) {
 		cell = &codec->cells[childs];
 		cell->name = "twl4030-codec";
-		cell->mfd_data = pdata->audio;
+		cell->platform_data = pdata->audio;
+		cell->pdata_size = sizeof(*pdata->audio);
 		childs++;
 	}
 	if (pdata->vibra) {
 		cell = &codec->cells[childs];
 		cell->name = "twl4030-vibra";
-		cell->mfd_data = pdata->vibra;
+		cell->platform_data = pdata->vibra;
+		cell->pdata_size = sizeof(*pdata->vibra);
 		childs++;
 	}
 
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 575238d..bec788b 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -26,7 +26,6 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/core.h>
 #include <linux/i2c/twl.h>
 #include <linux/slab.h>
 #include <sound/core.h>
@@ -733,8 +732,7 @@ static int aif_event(struct snd_soc_dapm_widget *w,
 
 static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 {
-	struct twl4030_codec_audio_data *pdata =
-			mfd_get_data(to_platform_device(codec->dev));
+	struct twl4030_codec_audio_data *pdata = codec->dev->platform_data;
 	unsigned char hs_gain, hs_pop;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
 	/* Base values for ramp delay calculation: 2^19 - 2^26 */
@@ -2299,7 +2297,7 @@ static struct snd_soc_codec_driver soc_codec_dev_twl4030 = {
 
 static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 {
-	struct twl4030_codec_audio_data *pdata = mfd_get_data(pdev);
+	struct twl4030_codec_audio_data *pdata = pdev->dev.platform_data;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "platform_data is missing\n");
-- 
1.7.2.3

