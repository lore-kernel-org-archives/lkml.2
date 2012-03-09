Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031767Ab2CIUEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:04:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54260 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab2CITwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:52:46 -0500
Message-Id: <20120309190217.700975621@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 34/68] ASoC: dapm: Check for bias level when powering down
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 7679e42ec833ed70aa34790a5f39dcb7e5bda4fe upstream.

Recent enhancements in the bias management means that we might not be
in standby when the CODEC is idle and can have active widgets without
being in full power mode but the shutdown functionality assumes these
things. Add checks for the bias level at each stage so that we don't
do transitions other than the ON->PREPARE->STANDBY->OFF ones that the
drivers are expecting.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2615,9 +2615,13 @@ static void soc_dapm_shutdown_codec(stru
 	 * standby.
 	 */
 	if (powerdown) {
-		snd_soc_dapm_set_bias_level(dapm, SND_SOC_BIAS_PREPARE);
+		if (dapm->bias_level == SND_SOC_BIAS_ON)
+			snd_soc_dapm_set_bias_level(dapm,
+						    SND_SOC_BIAS_PREPARE);
 		dapm_seq_run(dapm, &down_list, 0, false);
-		snd_soc_dapm_set_bias_level(dapm, SND_SOC_BIAS_STANDBY);
+		if (dapm->bias_level == SND_SOC_BIAS_PREPARE)
+			snd_soc_dapm_set_bias_level(dapm,
+						    SND_SOC_BIAS_STANDBY);
 	}
 }
 
@@ -2630,7 +2634,9 @@ void snd_soc_dapm_shutdown(struct snd_so
 
 	list_for_each_entry(codec, &card->codec_dev_list, list) {
 		soc_dapm_shutdown_codec(&codec->dapm);
-		snd_soc_dapm_set_bias_level(&codec->dapm, SND_SOC_BIAS_OFF);
+		if (codec->dapm.bias_level == SND_SOC_BIAS_STANDBY)
+			snd_soc_dapm_set_bias_level(&codec->dapm,
+						    SND_SOC_BIAS_OFF);
 	}
 }
 


