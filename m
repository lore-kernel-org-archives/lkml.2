Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2GaEzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:55:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48818 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669Ab2GaEu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:59 -0400
Message-Id: <20120731044316.865191013@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Liam Girdwood <lrg@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 35/73] ASoC: dapm: Fix locking during codec shutdown
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam Girdwood <lrg@ti.com>

commit 01005a729a17ab419f61a366e22f3419e7a2c3fe upstream.

Codec shutdown performs a DAPM power sequence that might cause conflicts
and/or race conditions if another stream power event is running simultaneously.
Use card's dapm mutex to protect any potential race condition between them.

Signed-off-by: Misael Lopez Cruz <misael.lopez@ti.com>
Signed-off-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/soc-dapm.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 5be4f9a..114f2af 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3537,10 +3537,13 @@ EXPORT_SYMBOL_GPL(snd_soc_dapm_free);
 
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
@@ -3563,6 +3566,8 @@ static void soc_dapm_shutdown_codec(struct snd_soc_dapm_context *dapm)
 			snd_soc_dapm_set_bias_level(dapm,
 						    SND_SOC_BIAS_STANDBY);
 	}
+
+	mutex_unlock(&card->dapm_mutex);
 }
 
 /*


