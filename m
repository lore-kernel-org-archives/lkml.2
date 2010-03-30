Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab0C3XUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:20:18 -0400
Received: from kroah.org ([198.145.64.141]:45651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab0C3XTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:17 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:25 2010
Message-Id: <20100330224725.067491143@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [007/156] ALSA: hda - Fix input source elements of secondary ADCs on Realtek
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 5311114d4867113c00f78829d4ce14be458ec925 upstream.

Since alc_auto_create_input_ctls() doesn't set the elements for the
secondary ADCs, "Input Source" elemtns for these also get empty, resulting
in buggy outputs of alsactl like:
	control.14 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		iface MIXER
		name 'Input Source'
		index 1
		value 0
	}

This patch fixes alc_mux_enum_*() (and others) to fall back to the
first entry if the secondary input mux is empty.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -407,6 +407,8 @@ static int alc_mux_enum_info(struct snd_
 	unsigned int mux_idx = snd_ctl_get_ioffidx(kcontrol, &uinfo->id);
 	if (mux_idx >= spec->num_mux_defs)
 		mux_idx = 0;
+	if (!spec->input_mux[mux_idx].num_items && mux_idx > 0)
+		mux_idx = 0;
 	return snd_hda_input_mux_info(&spec->input_mux[mux_idx], uinfo);
 }
 
@@ -435,6 +437,8 @@ static int alc_mux_enum_put(struct snd_k
 
 	mux_idx = adc_idx >= spec->num_mux_defs ? 0 : adc_idx;
 	imux = &spec->input_mux[mux_idx];
+	if (!imux->num_items && mux_idx > 0)
+		imux = &spec->input_mux[0];
 
 	type = get_wcaps_type(get_wcaps(codec, nid));
 	if (type == AC_WID_AUD_MIX) {
@@ -9941,6 +9945,8 @@ static void alc882_auto_init_input_src(s
 			continue;
 		mux_idx = c >= spec->num_mux_defs ? 0 : c;
 		imux = &spec->input_mux[mux_idx];
+		if (!imux->num_items && mux_idx > 0)
+			imux = &spec->input_mux[0];
 		for (idx = 0; idx < conns; idx++) {
 			/* if the current connection is the selected one,
 			 * unmute it as default - otherwise mute it


