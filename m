Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764Ab0G3RzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:55:06 -0400
Received: from kroah.org ([198.145.64.141]:57928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759643Ab0G3Ryb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:31 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:36 2010
Message-Id: <20100730175135.964701830@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [026/205] ALSA: hda - Dont check capture source mixer if no ADC is available
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit fbe618f216830f47b183858c3380d4767b1ad02f upstream.

With multiple codec configurations, some codec might have no ADC, thus
it keeps spec->adc_nids = NULL.  This causes an Oops in alc_build_controls().

Reference: kernel bug #16156
	https://bugzilla.kernel.org/show_bug.cgi?id=16156

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2550,16 +2550,18 @@ static int alc_build_controls(struct hda
 	}
 
 	/* assign Capture Source enums to NID */
-	kctl = snd_hda_find_mixer_ctl(codec, "Capture Source");
-	if (!kctl)
-		kctl = snd_hda_find_mixer_ctl(codec, "Input Source");
-	for (i = 0; kctl && i < kctl->count; i++) {
-		hda_nid_t *nids = spec->capsrc_nids;
-		if (!nids)
-			nids = spec->adc_nids;
-		err = snd_hda_add_nid(codec, kctl, i, nids[i]);
-		if (err < 0)
-			return err;
+	if (spec->capsrc_nids || spec->adc_nids) {
+		kctl = snd_hda_find_mixer_ctl(codec, "Capture Source");
+		if (!kctl)
+			kctl = snd_hda_find_mixer_ctl(codec, "Input Source");
+		for (i = 0; kctl && i < kctl->count; i++) {
+			hda_nid_t *nids = spec->capsrc_nids;
+			if (!nids)
+				nids = spec->adc_nids;
+			err = snd_hda_add_nid(codec, kctl, i, nids[i]);
+			if (err < 0)
+				return err;
+		}
 	}
 	if (spec->cap_mixer) {
 		const char *kname = kctl ? kctl->id.name : NULL;


