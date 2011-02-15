Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab1BOW05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:26:57 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48928 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237Ab1BOWZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:25:35 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH 2/9] davinci_voicecodec: use mfd_data instead of driver_data
Date: Tue, 15 Feb 2011 14:25:22 -0800
Message-Id: <1297808729-21110-3-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297808729-21110-1-git-send-email-dilinger@queued.net>
References: <1297808729-21110-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mfd_data for passing information from mfd drivers to soc
clients.  The mfd_cell's driver_data field is being phased out.

Clients that were using driver_data now access .mfd_data
via mfd_get_data().

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/davinci_voicecodec.c |    4 ++--
 sound/soc/codecs/cq93vc.c        |    3 ++-
 sound/soc/davinci/davinci-vcif.c |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
index 33c923d..f946c0b 100644
--- a/drivers/mfd/davinci_voicecodec.c
+++ b/drivers/mfd/davinci_voicecodec.c
@@ -119,12 +119,12 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 	/* Voice codec interface client */
 	cell = &davinci_vc->cells[DAVINCI_VC_VCIF_CELL];
 	cell->name = "davinci_vcif";
-	cell->driver_data = davinci_vc;
+	cell->mfd_data = davinci_vc;
 
 	/* Voice codec CQ93VC client */
 	cell = &davinci_vc->cells[DAVINCI_VC_CQ93VC_CELL];
 	cell->name = "cq93vc";
-	cell->driver_data = davinci_vc;
+	cell->mfd_data = davinci_vc;
 
 	ret = mfd_add_devices(&pdev->dev, pdev->id, davinci_vc->cells,
 			      DAVINCI_VC_CELLS, NULL, 0);
diff --git a/sound/soc/codecs/cq93vc.c b/sound/soc/codecs/cq93vc.c
index 46dbfd0..b8066ef 100644
--- a/sound/soc/codecs/cq93vc.c
+++ b/sound/soc/codecs/cq93vc.c
@@ -153,7 +153,8 @@ static int cq93vc_resume(struct snd_soc_codec *codec)
 
 static int cq93vc_probe(struct snd_soc_codec *codec)
 {
-	struct davinci_vc *davinci_vc = codec->dev->platform_data;
+	struct davinci_vc *davinci_vc =
+			mfd_get_data(to_platform_device(codec->dev));
 
 	davinci_vc->cq93vc.codec = codec;
 	codec->control_data = davinci_vc;
diff --git a/sound/soc/davinci/davinci-vcif.c b/sound/soc/davinci/davinci-vcif.c
index 9d2afcc..13e05a3 100644
--- a/sound/soc/davinci/davinci-vcif.c
+++ b/sound/soc/davinci/davinci-vcif.c
@@ -205,7 +205,7 @@ static struct snd_soc_dai_driver davinci_vcif_dai = {
 
 static int davinci_vcif_probe(struct platform_device *pdev)
 {
-	struct davinci_vc *davinci_vc = platform_get_drvdata(pdev);
+	struct davinci_vc *davinci_vc = mfd_get_data(pdev);
 	struct davinci_vcif_dev *davinci_vcif_dev;
 	int ret;
 
-- 
1.7.2.3

