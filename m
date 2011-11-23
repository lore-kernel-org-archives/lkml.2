Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab1KWA7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:59:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386Ab1KWAei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:34:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:53 2011
Message-Id: <20111123002553.054880641@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [02/53] ALSA: hda - Fix the connection selection of ADCs on Cirrus codecs
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 05ee7964a470d29889ac48cc8274c1b5a1904a11 upstream.

spec->cur_adc isn't set until cs_capture_pcm_prepare() is called although
the driver tries to select the connection at init time and at auto-mic
switch.  This results in the access to the widget NID 0, which is
obviously invalid, also a wrong capture source.

This patch fixes the issue by issuing the connect-select verb conditionally
at appropriate places.

Reported-and-tested-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_cirrus.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -236,6 +236,15 @@ static int cs_dig_playback_pcm_cleanup(s
 	return snd_hda_multi_out_dig_cleanup(codec, &spec->multiout);
 }
 
+static void cs_update_input_select(struct hda_codec *codec)
+{
+	struct cs_spec *spec = codec->spec;
+	if (spec->cur_adc)
+		snd_hda_codec_write(codec, spec->cur_adc, 0,
+				    AC_VERB_SET_CONNECT_SEL,
+				    spec->adc_idx[spec->cur_input]);
+}
+
 /*
  * Analog capture
  */
@@ -249,6 +258,7 @@ static int cs_capture_pcm_prepare(struct
 	spec->cur_adc = spec->adc_nid[spec->cur_input];
 	spec->cur_adc_stream_tag = stream_tag;
 	spec->cur_adc_format = format;
+	cs_update_input_select(codec);
 	snd_hda_codec_setup_stream(codec, spec->cur_adc, stream_tag, 0, format);
 	return 0;
 }
@@ -688,10 +698,8 @@ static int change_cur_input(struct hda_c
 					   spec->cur_adc_stream_tag, 0,
 					   spec->cur_adc_format);
 	}
-	snd_hda_codec_write(codec, spec->cur_adc, 0,
-			    AC_VERB_SET_CONNECT_SEL,
-			    spec->adc_idx[idx]);
 	spec->cur_input = idx;
+	cs_update_input_select(codec);
 	return 1;
 }
 
@@ -972,10 +980,7 @@ static void cs_automic(struct hda_codec
 		} else  {
 			spec->cur_input = spec->last_input;
 		}
-
-		snd_hda_codec_write_cache(codec, spec->cur_adc, 0,
-					AC_VERB_SET_CONNECT_SEL,
-					spec->adc_idx[spec->cur_input]);
+		cs_update_input_select(codec);
 	} else {
 		if (present)
 			change_cur_input(codec, spec->automic_idx, 0);
@@ -1072,9 +1077,7 @@ static void init_input(struct hda_codec
 			cs_automic(codec);
 		else  {
 			spec->cur_adc = spec->adc_nid[spec->cur_input];
-			snd_hda_codec_write(codec, spec->cur_adc, 0,
-					AC_VERB_SET_CONNECT_SEL,
-					spec->adc_idx[spec->cur_input]);
+			cs_update_input_select(codec);
 		}
 	} else {
 		change_cur_input(codec, spec->cur_input, 1);


