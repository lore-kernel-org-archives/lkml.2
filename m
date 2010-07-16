Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966110Ab0GPQRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:17:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60203 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965945Ab0GPQRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=L+A0lD/WMOQtqt/DudjU8tP4H+YwtId25BYzmU0RSxlxYcs9uDA1oisWOysMujB1df
         PbzqUKrwSmMOkx4ecM9gdrpUgNM8kHShR8vgwfUNnBLC/xyHnjsiwf60AFBi1CV7640i
         7q9YFuEcDEk7D6sw2wymvtWheZKBYanpHin8o=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] sound/soc: imx: check kzalloc() result and fix memory leak
Date: Fri, 16 Jul 2010 20:16:54 +0400
Message-Id: <1279297014-25347-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() fails we must exit with -ENOMEM. Also we must free
allocated runtime->private_data on error as it would be lost on next
call to snd_imx_open().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/soc/imx/imx-pcm-fiq.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/sound/soc/imx/imx-pcm-fiq.c b/sound/soc/imx/imx-pcm-fiq.c
index 6b518e0..b2bf272 100644
--- a/sound/soc/imx/imx-pcm-fiq.c
+++ b/sound/soc/imx/imx-pcm-fiq.c
@@ -192,6 +192,8 @@ static int snd_imx_open(struct snd_pcm_substream *substream)
 	int ret;
 
 	iprtd = kzalloc(sizeof(*iprtd), GFP_KERNEL);
+	if (iprtd == NULL)
+		return -ENOMEM;
 	runtime->private_data = iprtd;
 
 	iprtd->substream = substream;
@@ -202,8 +204,10 @@ static int snd_imx_open(struct snd_pcm_substream *substream)
 
 	ret = snd_pcm_hw_constraint_integer(substream->runtime,
 			SNDRV_PCM_HW_PARAM_PERIODS);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(iprtd);
 		return ret;
+	}
 
 	snd_soc_set_runtime_hwparams(substream, &snd_imx_hardware);
 	return 0;
-- 
1.7.0.4

