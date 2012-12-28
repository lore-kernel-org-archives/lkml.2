Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab2L1Tsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:48:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55134 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499Ab2L1TRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:51 -0500
Message-Id: <20121228190357.509807514@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 133/173] ALSA: hda - Always turn on pins for HDMI/DP
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6169b673618bf0b2518ce413b54925782a603f06 upstream.

We've seen the broken HDMI *video* output on some machines with GM965,
and the debugging session pointed that the culprit is the disabled
audio output pins.  Toggling these pins dynamically on demand caused
flickering of HDMI TV.

This patch changes the behavior to keep the pin ON constantly.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=51421

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_hdmi.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -424,9 +424,11 @@ static void hdmi_init_pin(struct hda_cod
 	if (get_wcaps(codec, pin_nid) & AC_WCAP_OUT_AMP)
 		snd_hda_codec_write(codec, pin_nid, 0,
 				AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
-	/* Disable pin out until stream is active*/
+	/* Enable pin out: some machines with GM965 gets broken output when
+	 * the pin is disabled or changed while using with HDMI
+	 */
 	snd_hda_codec_write(codec, pin_nid, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, 0);
+			    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
 }
 
 static int hdmi_get_channel_count(struct hda_codec *codec, hda_nid_t cvt_nid)
@@ -1141,17 +1143,11 @@ static int generic_hdmi_playback_pcm_pre
 	struct hdmi_spec *spec = codec->spec;
 	int pin_idx = hinfo_to_pin_index(spec, hinfo);
 	hda_nid_t pin_nid = spec->pins[pin_idx].pin_nid;
-	int pinctl;
 
 	hdmi_set_channel_count(codec, cvt_nid, substream->runtime->channels);
 
 	hdmi_setup_audio_infoframe(codec, pin_idx, substream);
 
-	pinctl = snd_hda_codec_read(codec, pin_nid, 0,
-				    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
-	snd_hda_codec_write(codec, pin_nid, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, pinctl | PIN_OUT);
-
 	return hdmi_setup_stream(codec, cvt_nid, pin_nid, stream_tag, format);
 }
 
@@ -1163,7 +1159,6 @@ static int generic_hdmi_playback_pcm_cle
 	int cvt_idx, pin_idx;
 	struct hdmi_spec_per_cvt *per_cvt;
 	struct hdmi_spec_per_pin *per_pin;
-	int pinctl;
 
 	snd_hda_codec_cleanup_stream(codec, hinfo->nid);
 
@@ -1182,11 +1177,6 @@ static int generic_hdmi_playback_pcm_cle
 			return -EINVAL;
 		per_pin = &spec->pins[pin_idx];
 
-		pinctl = snd_hda_codec_read(codec, per_pin->pin_nid, 0,
-					    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
-		snd_hda_codec_write(codec, per_pin->pin_nid, 0,
-				    AC_VERB_SET_PIN_WIDGET_CONTROL,
-				    pinctl & ~PIN_OUT);
 		snd_hda_spdif_ctls_unassign(codec, pin_idx);
 	}
 


