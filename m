Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965885Ab1KJDq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:46:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965870Ab1KJDqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:46:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:01 2011
Message-Id: <20111109213201.548354162@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [191/264] ALSA: hda/realtek - Dont create alt-stream for capture when unnecessary
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1fa1757366783fb52e6e85c2d735db49b818d382 upstream.

When the driver finds multiple ADCs, it tries to create an alternative
capture PCM stream.  However, these secondary ADCs might be useless or
in uncontrolled paths in some cases, e.g. when auto-mic or dynamic
ADC-switching is enabled.  Also, when only a single capture source is
available, the multi-streams don't make sense, too.

With this patch, the driver checks such condition and skips the alt
stream appropriately.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2232,6 +2232,7 @@ static int alc_build_pcms(struct hda_cod
 	struct alc_spec *spec = codec->spec;
 	struct hda_pcm *info = spec->pcm_rec;
 	const struct hda_pcm_stream *p;
+	bool have_multi_adcs;
 	int i;
 
 	codec->num_pcms = 1;
@@ -2310,8 +2311,11 @@ static int alc_build_pcms(struct hda_cod
 	/* If the use of more than one ADC is requested for the current
 	 * model, configure a second analog capture-only PCM.
 	 */
+	have_multi_adcs = (spec->num_adc_nids > 1) &&
+		!spec->dyn_adc_switch && !spec->auto_mic &&
+		(!spec->input_mux || spec->input_mux->num_items > 1);
 	/* Additional Analaog capture for index #2 */
-	if (spec->alt_dac_nid || spec->num_adc_nids > 1) {
+	if (spec->alt_dac_nid || have_multi_adcs) {
 		codec->num_pcms = 3;
 		info = spec->pcm_rec + 2;
 		info->name = spec->stream_name_analog;
@@ -2327,7 +2331,7 @@ static int alc_build_pcms(struct hda_cod
 				alc_pcm_null_stream;
 			info->stream[SNDRV_PCM_STREAM_PLAYBACK].nid = 0;
 		}
-		if (spec->num_adc_nids > 1) {
+		if (have_multi_adcs) {
 			p = spec->stream_analog_alt_capture;
 			if (!p)
 				p = &alc_pcm_analog_alt_capture;


