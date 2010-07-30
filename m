Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab0G3SAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:00:39 -0400
Received: from kroah.org ([198.145.64.141]:59321 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932860Ab0G3R6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:58:04 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:52 2010
Message-Id: <20100730175152.242134605@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [202/205] ALSA: hda - Fix pin-detection of Nvidia HDMI
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 38faddb1afdd37218c196ac3db1cb5fbe7fc9c75 upstream.

The behavior of Nvidia HDMI codec regarding the pin-detection unsol events
is based on the old HD-audio spec, i.e. PD bit indicates only the update
and doesn't show the current state.  Since the current code assumes the
new behavior, the pin-detection doesn't work relialby with these h/w.

This patch adds a flag for indicating the old spec, and fixes the issue
by checking the pin-detection explicitly for such hardware.

Tested-by: Wei Ni <wni@nvidia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_hdmi.c   |   13 +++++++++++++
 sound/pci/hda/patch_nvhdmi.c |    3 +++
 2 files changed, 16 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -52,6 +52,10 @@ struct hdmi_spec {
 	 */
 	struct hda_multi_out multiout;
 	unsigned int codec_type;
+
+	/* misc flags */
+	/* PD bit indicates only the update, not the current state */
+	unsigned int old_pin_detect:1;
 };
 
 
@@ -616,6 +620,9 @@ static void hdmi_setup_audio_infoframe(s
  * Unsolicited events
  */
 
+static void hdmi_present_sense(struct hda_codec *codec, hda_nid_t pin_nid,
+			       struct hdmi_eld *eld);
+
 static void hdmi_intrinsic_event(struct hda_codec *codec, unsigned int res)
 {
 	struct hdmi_spec *spec = codec->spec;
@@ -632,6 +639,12 @@ static void hdmi_intrinsic_event(struct
 	if (index < 0)
 		return;
 
+	if (spec->old_pin_detect) {
+		if (pind)
+			hdmi_present_sense(codec, tag, &spec->sink_eld[index]);
+		pind = spec->sink_eld[index].monitor_present;
+	}
+
 	spec->sink_eld[index].monitor_present = pind;
 	spec->sink_eld[index].eld_valid = eldv;
 
--- a/sound/pci/hda/patch_nvhdmi.c
+++ b/sound/pci/hda/patch_nvhdmi.c
@@ -478,6 +478,7 @@ static int patch_nvhdmi_8ch_89(struct hd
 
 	codec->spec = spec;
 	spec->codec_type = HDA_CODEC_NVIDIA_MCP89;
+	spec->old_pin_detect = 1;
 
 	if (hdmi_parse_codec(codec) < 0) {
 		codec->spec = NULL;
@@ -508,6 +509,7 @@ static int patch_nvhdmi_8ch_7x(struct hd
 	spec->multiout.max_channels = 8;
 	spec->multiout.dig_out_nid = nvhdmi_master_con_nid_7x;
 	spec->codec_type = HDA_CODEC_NVIDIA_MCP7X;
+	spec->old_pin_detect = 1;
 
 	codec->patch_ops = nvhdmi_patch_ops_8ch_7x;
 
@@ -528,6 +530,7 @@ static int patch_nvhdmi_2ch(struct hda_c
 	spec->multiout.max_channels = 2;
 	spec->multiout.dig_out_nid = nvhdmi_master_con_nid_7x;
 	spec->codec_type = HDA_CODEC_NVIDIA_MCP7X;
+	spec->old_pin_detect = 1;
 
 	codec->patch_ops = nvhdmi_patch_ops_2ch;
 


