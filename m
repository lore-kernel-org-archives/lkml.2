Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab1BLCMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 21:12:33 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:58281 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab1BLCMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 21:12:32 -0500
Date: Fri, 11 Feb 2011 18:12:28 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 10/17] wl1273: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110211181228.74a8cf5a@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The cell's platform_data is now accessed with a helper function;
change clients to use that, and remove the now-unused data_size.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/media/radio/radio-wl1273.c |    2 +-
 drivers/mfd/wl1273-core.c          |    2 --
 sound/soc/codecs/wl1273.c          |    3 ++-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 7ecc8e6..4698eb0 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -2138,7 +2138,7 @@ static int wl1273_fm_radio_remove(struct platform_device *pdev)
 
 static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
 {
-	struct wl1273_core **core = pdev->dev.platform_data;
+	struct wl1273_core **core = mfd_get_data(pdev);
 	struct wl1273_device *radio;
 	struct v4l2_ctrl *ctrl;
 	int r = 0;
diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
index d2ecc24..703085e 100644
--- a/drivers/mfd/wl1273-core.c
+++ b/drivers/mfd/wl1273-core.c
@@ -80,7 +80,6 @@ static int __devinit wl1273_core_probe(struct i2c_client *client,
 	cell = &core->cells[children];
 	cell->name = "wl1273_fm_radio";
 	cell->platform_data = &core;
-	cell->data_size = sizeof(core);
 	children++;
 
 	if (pdata->children & WL1273_CODEC_CHILD) {
@@ -89,7 +88,6 @@ static int __devinit wl1273_core_probe(struct i2c_client *client,
 		dev_dbg(&client->dev, "%s: Have codec.\n", __func__);
 		cell->name = "wl1273-codec";
 		cell->platform_data = &core;
-		cell->data_size = sizeof(core);
 		children++;
 	}
 
diff --git a/sound/soc/codecs/wl1273.c b/sound/soc/codecs/wl1273.c
index 861b28f..1ad0d5a 100644
--- a/sound/soc/codecs/wl1273.c
+++ b/sound/soc/codecs/wl1273.c
@@ -436,7 +436,8 @@ EXPORT_SYMBOL_GPL(wl1273_get_format);
 
 static int wl1273_probe(struct snd_soc_codec *codec)
 {
-	struct wl1273_core **core = codec->dev->platform_data;
+	struct wl1273_core **core =
+			mfd_get_data(to_platform_device(codec->dev));
 	struct wl1273_priv *wl1273;
 	int r;
 
-- 
1.7.2.3

