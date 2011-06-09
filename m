Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab1FILXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:23:50 -0400
Received: from smtp-out-035.synserver.de ([212.40.185.35]:1193 "EHLO
	smtp-out-035.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1FILXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:23:49 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 29105
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, stable@kernel.org
Subject: [PATCH] ASoC: snd_soc_new_{mixer,mux,pga} make sure to use right DAPM context
Date: Thu,  9 Jun 2011 13:22:36 +0200
Message-Id: <1307618556-32068-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it is possible that snd_soc_new_{mixer,mux,pga} is called with a
DAPM context not matching the widgets context. This can lead to a wrong
prefix_len calculation, which will result in undefined behaviour. To avoid
this always use the DAPM context from the widget itself.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: stable@kernel.org

---
 sound/soc/soc-dapm.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 34106bc..fd2d774 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -337,9 +337,9 @@ static int dapm_is_shared_kcontrol(struct snd_soc_dapm_context *dapm,
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
@@ -437,9 +437,9 @@ static int dapm_new_mixer(struct snd_soc_dapm_context *dapm,
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
@@ -522,8 +522,7 @@ static int dapm_new_mux(struct snd_soc_dapm_context *dapm,
 }
 
 /* create new dapm volume control */
-static int dapm_new_pga(struct snd_soc_dapm_context *dapm,
-	struct snd_soc_dapm_widget *w)
+static int dapm_new_pga(struct snd_soc_dapm_widget *w)
 {
 	if (w->num_kcontrols)
 		dev_err(w->dapm->dev,
@@ -1838,13 +1837,13 @@ int snd_soc_dapm_new_widgets(struct snd_soc_dapm_context *dapm)
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
@@ -1857,7 +1856,7 @@ int snd_soc_dapm_new_widgets(struct snd_soc_dapm_context *dapm)
 		case snd_soc_dapm_pga:
 		case snd_soc_dapm_out_drv:
 			w->power_check = dapm_generic_check_power;
-			dapm_new_pga(dapm, w);
+			dapm_new_pga(w);
 			break;
 		case snd_soc_dapm_input:
 		case snd_soc_dapm_output:
-- 
1.7.2.5

