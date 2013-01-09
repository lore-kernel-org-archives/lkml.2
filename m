Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab3AIVtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:49:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:41577 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040Ab3AIUhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 022/123] ALSA: hda - Always turn on pins for HDMI/DP
Date: Wed,  9 Jan 2013 12:34:21 -0800
Message-Id: <20130109201501.340274182@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -431,9 +431,11 @@ static void hdmi_init_pin(struct hda_cod
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
@@ -1338,7 +1340,6 @@ static int generic_hdmi_playback_pcm_pre
 	struct hdmi_spec *spec = codec->spec;
 	int pin_idx = hinfo_to_pin_index(spec, hinfo);
 	hda_nid_t pin_nid = spec->pins[pin_idx].pin_nid;
-	int pinctl;
 	bool non_pcm;
 
 	non_pcm = check_non_pcm_per_cvt(codec, cvt_nid);
@@ -1347,11 +1348,6 @@ static int generic_hdmi_playback_pcm_pre
 
 	hdmi_setup_audio_infoframe(codec, pin_idx, non_pcm, substream);
 
-	pinctl = snd_hda_codec_read(codec, pin_nid, 0,
-				    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
-	snd_hda_codec_write(codec, pin_nid, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, pinctl | PIN_OUT);
-
 	return hdmi_setup_stream(codec, cvt_nid, pin_nid, stream_tag, format);
 }
 
@@ -1371,7 +1367,6 @@ static int hdmi_pcm_close(struct hda_pcm
 	int cvt_idx, pin_idx;
 	struct hdmi_spec_per_cvt *per_cvt;
 	struct hdmi_spec_per_pin *per_pin;
-	int pinctl;
 
 	if (hinfo->nid) {
 		cvt_idx = cvt_nid_to_cvt_index(spec, hinfo->nid);
@@ -1388,11 +1383,6 @@ static int hdmi_pcm_close(struct hda_pcm
 			return -EINVAL;
 		per_pin = &spec->pins[pin_idx];
 
-		pinctl = snd_hda_codec_read(codec, per_pin->pin_nid, 0,
-					    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
-		snd_hda_codec_write(codec, per_pin->pin_nid, 0,
-				    AC_VERB_SET_PIN_WIDGET_CONTROL,
-				    pinctl & ~PIN_OUT);
 		snd_hda_spdif_ctls_unassign(codec, pin_idx);
 		per_pin->chmap_set = false;
 		memset(per_pin->chmap, 0, sizeof(per_pin->chmap));


