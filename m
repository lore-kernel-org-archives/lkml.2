Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1FPHcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:32:16 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51119 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971Ab1FPHB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:29 -0400
X-Sasl-enc: CqDF3ePxl9b9eXjfrvKu+u3ZdcPtHU1xGdUaGyxQXYGL 1308207688
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:35 2011
Message-Id: <20110616000235.750771233@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [69/89] ASoC: snd_soc_new_{mixer,mux,pga} make sure to use right
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 DAPM context

From: Lars-Peter Clausen <lars@metafoo.de>

commit 4b80b8c2eee5282dab57f094fd3893c0c09f750c upstream.

Currently it is possible that snd_soc_new_{mixer,mux,pga} is called with a
DAPM context not matching the widgets context. This can lead to a wrong
prefix_len calculation, which will result in undefined behaviour. To avoid
this always use the DAPM context from the widget itself.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/soc-dapm.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -362,9 +362,9 @@ static int dapm_update_bits(struct snd_s
 }
 
 /* create new dapm mixer control */
-static int dapm_new_mixer(struct snd_soc_dapm_context *dapm,
-	struct snd_soc_dapm_widget *w)
+static int dapm_new_mixer(struct snd_soc_dapm_widget *w)
 {
+	struct snd_soc_dapm_context *dapm = w->dapm;
 	int i, ret = 0;
 	size_t name_len, prefix_len;
 	struct snd_soc_dapm_path *path;
@@ -443,9 +443,9 @@ static int dapm_new_mixer(struct snd_soc
 }
 
 /* create new dapm mux control */
-static int dapm_new_mux(struct snd_soc_dapm_context *dapm,
-	struct snd_soc_dapm_widget *w)
+static int dapm_new_mux(struct snd_soc_dapm_widget *w)
 {
+	struct snd_soc_dapm_context *dapm = w->dapm;
 	struct snd_soc_dapm_path *path = NULL;
 	struct snd_kcontrol *kcontrol;
 	struct snd_card *card = dapm->card->snd_card;
@@ -490,8 +490,7 @@ err:
 }
 
 /* create new dapm volume control */
-static int dapm_new_pga(struct snd_soc_dapm_context *dapm,
-	struct snd_soc_dapm_widget *w)
+static int dapm_new_pga(struct snd_soc_dapm_widget *w)
 {
 	if (w->num_kcontrols)
 		dev_err(w->dapm->dev,
@@ -1735,13 +1734,13 @@ int snd_soc_dapm_new_widgets(struct snd_
 		case snd_soc_dapm_mixer:
 		case snd_soc_dapm_mixer_named_ctl:
 			w->power_check = dapm_generic_check_power;
-			dapm_new_mixer(dapm, w);
+			dapm_new_mixer(w);
 			break;
 		case snd_soc_dapm_mux:
 		case snd_soc_dapm_virt_mux:
 		case snd_soc_dapm_value_mux:
 			w->power_check = dapm_generic_check_power;
-			dapm_new_mux(dapm, w);
+			dapm_new_mux(w);
 			break;
 		case snd_soc_dapm_adc:
 		case snd_soc_dapm_aif_out:
@@ -1754,7 +1753,7 @@ int snd_soc_dapm_new_widgets(struct snd_
 		case snd_soc_dapm_pga:
 		case snd_soc_dapm_out_drv:
 			w->power_check = dapm_generic_check_power;
-			dapm_new_pga(dapm, w);
+			dapm_new_pga(w);
 			break;
 		case snd_soc_dapm_input:
 		case snd_soc_dapm_output:


