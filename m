Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab2HGWho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:37:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851Ab2HGWhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:37:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dylan Reid <dgreid@chromium.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 021/109] ALSA: hda - Turn on PIN_OUT from hdmi playback prepare.
Date: Tue,  7 Aug 2012 15:34:40 -0700
Message-Id: <20120807222044.945090111@linuxfoundation.org>
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

From: Dylan Reid <dgreid@chromium.org>

commit 9e76e6d031482194a5b24d8e9ab88063fbd6b4b5 upstream.

Turn on the pin widget's PIN_OUT bit from playback prepare. The pin is
enabled in open, but is disabled in hdmi_init_pin which is called during
system resume.  This causes a system suspend/resume during playback to
mute HDMI/DP. Enabling the pin in prepare instead of open allows calling
snd_pcm_prepare after a system resume to restore audio.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -876,7 +876,6 @@ static int hdmi_pcm_open(struct hda_pcm_
 	struct hdmi_spec_per_pin *per_pin;
 	struct hdmi_eld *eld;
 	struct hdmi_spec_per_cvt *per_cvt = NULL;
-	int pinctl;
 
 	/* Validate hinfo */
 	pin_idx = hinfo_to_pin_index(spec, hinfo);
@@ -912,11 +911,6 @@ static int hdmi_pcm_open(struct hda_pcm_
 	snd_hda_codec_write(codec, per_pin->pin_nid, 0,
 			    AC_VERB_SET_CONNECT_SEL,
 			    mux_idx);
-	pinctl = snd_hda_codec_read(codec, per_pin->pin_nid, 0,
-				    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
-	snd_hda_codec_write(codec, per_pin->pin_nid, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL,
-			    pinctl | PIN_OUT);
 	snd_hda_spdif_ctls_assign(codec, pin_idx, per_cvt->cvt_nid);
 
 	/* Initially set the converter's capabilities */
@@ -1153,11 +1147,17 @@ static int generic_hdmi_playback_pcm_pre
 	struct hdmi_spec *spec = codec->spec;
 	int pin_idx = hinfo_to_pin_index(spec, hinfo);
 	hda_nid_t pin_nid = spec->pins[pin_idx].pin_nid;
+	int pinctl;
 
 	hdmi_set_channel_count(codec, cvt_nid, substream->runtime->channels);
 
 	hdmi_setup_audio_infoframe(codec, pin_idx, substream);
 
+	pinctl = snd_hda_codec_read(codec, pin_nid, 0,
+				    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
+	snd_hda_codec_write(codec, pin_nid, 0,
+			    AC_VERB_SET_PIN_WIDGET_CONTROL, pinctl | PIN_OUT);
+
 	return hdmi_setup_stream(codec, cvt_nid, pin_nid, stream_tag, format);
 }
 


