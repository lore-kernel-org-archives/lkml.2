Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2LSBa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 20:30:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:13972 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029Ab2LSBaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:30:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,313,1355126400"; 
   d="scan'208";a="259397707"
Subject: [PATCH] ASoC: dapm: Fix the unpaired runtime_get/put cases
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com, perex@perex.cz,
        tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Dec 2012 18:36:37 +0800
Message-ID: <1355913397.17896.10.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit f1aac484f7(Take a pm_runtime reference on DAPM devices that are enabled)
introduced runtime_get/put calling when devices are in off/non-off bias.

It is based on:
1/ device from off to non-off bias is called thru dapm_pre_sequence_async;
2/ device from non-off to off bias is called thru dapm_post_sequence_async;

There are the above conditions which then make sure runtime_get/put() are pairs.

But some devices has been set to STANDY bias directly during device probing,
such as cs42l73_probe():
cs42l73_set_bias_level(codec, SND_SOC_BIAS_STANDBY);

Then it will cause runtime_get() not be called but laterly runtime_put() will
be called. Also found some other uppaired cases.

So here add new flag get_runtime, and the logic will be:
1/ when device is from off to non-off bias, runtime_get() will be called if not yet;
2/ When device is off bias, runtime_put() will be called if runtime_get() has
   been called;

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 include/sound/soc-dapm.h |    1 +
 sound/soc/soc-dapm.c     |   18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index e1ef63d..e52fdcc 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -586,6 +586,7 @@ struct snd_soc_dapm_context {
 	struct list_head list;
 
 	int (*stream_event)(struct snd_soc_dapm_context *dapm, int event);
+	bool get_runtime;
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debugfs_dapm;
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 1e36bc8..e6d030a 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1460,12 +1460,15 @@ static void dapm_pre_sequence_async(void *data, async_cookie_t cookie)
 	struct snd_soc_dapm_context *d = data;
 	int ret;
 
+	if ((d->target_bias_level != SND_SOC_BIAS_OFF) &&
+		(d->dev) && !(d->get_runtime)) {
+		pm_runtime_get_sync(d->dev);
+		d->get_runtime = true;
+	}
+
 	/* If we're off and we're not supposed to be go into STANDBY */
 	if (d->bias_level == SND_SOC_BIAS_OFF &&
 	    d->target_bias_level != SND_SOC_BIAS_OFF) {
-		if (d->dev)
-			pm_runtime_get_sync(d->dev);
-
 		ret = snd_soc_dapm_set_bias_level(d, SND_SOC_BIAS_STANDBY);
 		if (ret != 0)
 			dev_err(d->dev,
@@ -1506,9 +1509,6 @@ static void dapm_post_sequence_async(void *data, async_cookie_t cookie)
 		if (ret != 0)
 			dev_err(d->dev, "ASoC: Failed to turn off bias: %d\n",
 				ret);
-
-		if (d->dev)
-			pm_runtime_put(d->dev);
 	}
 
 	/* If we just powered up then move to active bias */
@@ -1519,6 +1519,12 @@ static void dapm_post_sequence_async(void *data, async_cookie_t cookie)
 			dev_err(d->dev, "ASoC: Failed to apply active bias: %d\n",
 				ret);
 	}
+
+	if ((d->bias_level == SND_SOC_BIAS_OFF) &&
+		(d->dev) && (d->get_runtime)) {
+		pm_runtime_put(d->dev);
+		d->get_runtime = false;
+	}
 }
 
 static void dapm_widget_set_peer_power(struct snd_soc_dapm_widget *peer,
-- 
1.7.0.4



