Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1BCELj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:11:39 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40959 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab1BCELi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:11:38 -0500
Date: Wed, 2 Feb 2011 20:11:33 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Matti Aaltonen <matti.j.aaltonen@nokia.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 09/19] wl1273: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110202201133.08dbd07e@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No need to explicitly set the cell's platform_data/data_size.

In this case, move the various platform_data pointers
to driver_data.  All of the clients which make use of it
are also changed.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/media/radio/radio-wl1273.c |    2 +-
 drivers/mfd/wl1273-core.c          |    6 ++----
 sound/soc/codecs/wl1273.c          |    2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 7ecc8e6..ebb6eb5 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -2138,7 +2138,7 @@ static int wl1273_fm_radio_remove(struct platform_device *pdev)
 
 static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
 {
-	struct wl1273_core **core = pdev->dev.platform_data;
+	struct wl1273_core **core = platform_get_drvdata(pdev);
 	struct wl1273_device *radio;
 	struct v4l2_ctrl *ctrl;
 	int r = 0;
diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
index d2ecc24..61ec252 100644
--- a/drivers/mfd/wl1273-core.c
+++ b/drivers/mfd/wl1273-core.c
@@ -79,8 +79,7 @@ static int __devinit wl1273_core_probe(struct i2c_client *client,
 
 	cell = &core->cells[children];
 	cell->name = "wl1273_fm_radio";
-	cell->platform_data = &core;
-	cell->data_size = sizeof(core);
+	cell->driver_data = &core;
 	children++;
 
 	if (pdata->children & WL1273_CODEC_CHILD) {
@@ -88,8 +87,7 @@ static int __devinit wl1273_core_probe(struct i2c_client *client,
 
 		dev_dbg(&client->dev, "%s: Have codec.\n", __func__);
 		cell->name = "wl1273-codec";
-		cell->platform_data = &core;
-		cell->data_size = sizeof(core);
+		cell->driver_data = &core;
 		children++;
 	}
 
diff --git a/sound/soc/codecs/wl1273.c b/sound/soc/codecs/wl1273.c
index 861b28f..0af2c2d 100644
--- a/sound/soc/codecs/wl1273.c
+++ b/sound/soc/codecs/wl1273.c
@@ -436,7 +436,7 @@ EXPORT_SYMBOL_GPL(wl1273_get_format);
 
 static int wl1273_probe(struct snd_soc_codec *codec)
 {
-	struct wl1273_core **core = codec->dev->platform_data;
+	struct wl1273_core **core = dev_get_drvdata(codec->dev);
 	struct wl1273_priv *wl1273;
 	int r;
 
-- 
1.7.2.3

