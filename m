Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab1EIAd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:47642 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab1EIAdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="744199501"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH 18/19] mfd: Use mfd cell platform_data for davinci cells platform bits
Date: Mon,  9 May 2011 02:32:10 +0200
Message-Id: <1304901131-7104-19-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a platform device mfd_cell pointer, MFD drivers
can go back to passing platform back to their sub drivers.
This allows for an mfd_cell->mfd_data removal and thus keep the
sub drivers MFD agnostic. This is mostly needed for non MFD aware
sub drivers.

Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/davinci_voicecodec.c |    6 ++++--
 sound/soc/codecs/cq93vc.c        |    3 +--
 sound/soc/davinci/davinci-vcif.c |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
index 414783b..4e2af2c 100644
--- a/drivers/mfd/davinci_voicecodec.c
+++ b/drivers/mfd/davinci_voicecodec.c
@@ -119,12 +119,14 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 	/* Voice codec interface client */
 	cell = &davinci_vc->cells[DAVINCI_VC_VCIF_CELL];
 	cell->name = "davinci-vcif";
-	cell->mfd_data = davinci_vc;
+	cell->platform_data = davinci_vc;
+	cell->pdata_size = sizeof(*davinci_vc);
 
 	/* Voice codec CQ93VC client */
 	cell = &davinci_vc->cells[DAVINCI_VC_CQ93VC_CELL];
 	cell->name = "cq93vc-codec";
-	cell->mfd_data = davinci_vc;
+	cell->platform_data = davinci_vc;
+	cell->pdata_size = sizeof(*davinci_vc);
 
 	ret = mfd_add_devices(&pdev->dev, pdev->id, davinci_vc->cells,
 			      DAVINCI_VC_CELLS, NULL, 0);
diff --git a/sound/soc/codecs/cq93vc.c b/sound/soc/codecs/cq93vc.c
index b8066ef..46dbfd0 100644
--- a/sound/soc/codecs/cq93vc.c
+++ b/sound/soc/codecs/cq93vc.c
@@ -153,8 +153,7 @@ static int cq93vc_resume(struct snd_soc_codec *codec)
 
 static int cq93vc_probe(struct snd_soc_codec *codec)
 {
-	struct davinci_vc *davinci_vc =
-			mfd_get_data(to_platform_device(codec->dev));
+	struct davinci_vc *davinci_vc = codec->dev->platform_data;
 
 	davinci_vc->cq93vc.codec = codec;
 	codec->control_data = davinci_vc;
diff --git a/sound/soc/davinci/davinci-vcif.c b/sound/soc/davinci/davinci-vcif.c
index 13e05a3..9259f1f 100644
--- a/sound/soc/davinci/davinci-vcif.c
+++ b/sound/soc/davinci/davinci-vcif.c
@@ -205,7 +205,7 @@ static struct snd_soc_dai_driver davinci_vcif_dai = {
 
 static int davinci_vcif_probe(struct platform_device *pdev)
 {
-	struct davinci_vc *davinci_vc = mfd_get_data(pdev);
+	struct davinci_vc *davinci_vc = pdev->dev.platform_data;
 	struct davinci_vcif_dev *davinci_vcif_dev;
 	int ret;
 
-- 
1.7.2.3

