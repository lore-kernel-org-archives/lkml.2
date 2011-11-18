Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab1KSAJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:09:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321Ab1KSAJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:09:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:04 2011
Message-Id: <20111119000004.674219218@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [08/26] ALSA: usb-audio - Check the dB-range validity in the later read, too
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 9fcd0ab130579d9742538340edda3225f2b49a3e upstream.

When the initial check of dB-range failed due to the read error, try to
check again at the later read, too.  When an invalid dB range is found,
remove TLV flags and notify the mixer info change.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/mixer.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -881,8 +881,17 @@ static int mixer_ctl_feature_info(struct
 		uinfo->value.integer.min = 0;
 		uinfo->value.integer.max = 1;
 	} else {
-		if (! cval->initialized)
-			get_min_max(cval,  0);
+		if (!cval->initialized) {
+			get_min_max(cval, 0);
+			if (cval->initialized && cval->dBmin >= cval->dBmax) {
+				kcontrol->vd[0].access &=
+					~(SNDRV_CTL_ELEM_ACCESS_TLV_READ |
+					  SNDRV_CTL_ELEM_ACCESS_TLV_CALLBACK);
+				snd_ctl_notify(cval->mixer->chip->card,
+					       SNDRV_CTL_EVENT_MASK_INFO,
+					       &kcontrol->id);
+			}
+		}
 		uinfo->value.integer.min = 0;
 		uinfo->value.integer.max =
 			(cval->max - cval->min + cval->res - 1) / cval->res;


