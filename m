Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966106Ab0GPQQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:16:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60203 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965945Ab0GPQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:16:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nH+e/WKqJNsxfIOL8z2UxBO7kQzSFRavKNU04IiYJ5VTHH/LilSKZ8QVOWtHE6Mknr
         wgGho2HuTCmoDLuFTXLgR2azZNXLmaYKsHXDrNn6x1KEa2dOii48Vxiw6FGhoKqmlima
         KWKNk8siSV2Y9lE+4xFihhH0+2sv591tVgyac=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/15] sound/soc: imx: check kzalloc() result and fix memory leak
Date: Fri, 16 Jul 2010 20:16:34 +0400
Message-Id: <1279296995-25307-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() fails we must exit with -ENOMEM. Also we must free
allocated runtime->private_data on error as it would be lost on next
call to snd_imx_open().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/soc/imx/imx-pcm-dma-mx2.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/sound/soc/imx/imx-pcm-dma-mx2.c b/sound/soc/imx/imx-pcm-dma-mx2.c
index 05f19c9..0a595da 100644
--- a/sound/soc/imx/imx-pcm-dma-mx2.c
+++ b/sound/soc/imx/imx-pcm-dma-mx2.c
@@ -292,12 +292,16 @@ static int snd_imx_open(struct snd_pcm_substream *substream)
 	int ret;
 
 	iprtd = kzalloc(sizeof(*iprtd), GFP_KERNEL);
+	if (iprtd == NULL)
+		return -ENOMEM;
 	runtime->private_data = iprtd;
 
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

