Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab2HGXRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:17:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378Ab2HGWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:37:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Misael Lopez Cruz <misael.lopez@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 017/109] ASoC: dapm: Fix locking during codec shutdown
Date: Tue,  7 Aug 2012 15:34:36 -0700
Message-Id: <20120807222044.607925717@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam Girdwood <lrg@ti.com>

commit 01005a729a17ab419f61a366e22f3419e7a2c3fe upstream.

Codec shutdown performs a DAPM power sequence that might cause conflicts
and/or race conditions if another stream power event is running simultaneously.
Use card's dapm mutex to protect any potential race condition between them.

Signed-off-by: Misael Lopez Cruz <misael.lopez@ti.com>
Signed-off-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3210,10 +3210,13 @@ EXPORT_SYMBOL_GPL(snd_soc_dapm_free);
 
 static void soc_dapm_shutdown_codec(struct snd_soc_dapm_context *dapm)
 {
+	struct snd_soc_card *card = dapm->card;
 	struct snd_soc_dapm_widget *w;
 	LIST_HEAD(down_list);
 	int powerdown = 0;
 
+	mutex_lock(&card->dapm_mutex);
+
 	list_for_each_entry(w, &dapm->card->widgets, list) {
 		if (w->dapm != dapm)
 			continue;
@@ -3236,6 +3239,8 @@ static void soc_dapm_shutdown_codec(stru
 			snd_soc_dapm_set_bias_level(dapm,
 						    SND_SOC_BIAS_STANDBY);
 	}
+
+	mutex_unlock(&card->dapm_mutex);
 }
 
 /*


