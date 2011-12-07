Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab1LGQkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:40:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933689Ab1LGQXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:23:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:19 2011
Message-Id: <20111207161219.527922847@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:00 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Charles Chin <Charles.Chin@idt.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [058/104] ALSA: hda - Fix S3/S4 problem on machines with VREF-pin mute-LED
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Chin <Charles.Chin@idt.com>

commit 88d686027bb43f585914c77dd363f6e817b42c2a upstream.

The verb command in stac92xx_post_suspend caused the audio to stop
working after resuming from S3 mode on HP laptops with the VREF-pin
mute-LED control.  Removing relevant post_suspend registering.

Although removing D3 on AFG is no optimal solution, the impact should
be small in comparison with the broken S3/S4.

Signed-off-by: Charles Chin <Charles.Chin@idt.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -5035,20 +5035,6 @@ static int stac92xx_pre_resume(struct hd
 	return 0;
 }
 
-static int stac92xx_post_suspend(struct hda_codec *codec)
-{
-	struct sigmatel_spec *spec = codec->spec;
-	if (spec->gpio_led > 8) {
-		/* with vref-out pin used for mute led control
-		 * codec AFG is prevented from D3 state, but on
-		 * system suspend it can (and should) be used
-		 */
-		snd_hda_codec_read(codec, codec->afg, 0,
-				AC_VERB_SET_POWER_STATE, AC_PWRST_D3);
-	}
-	return 0;
-}
-
 static void stac92xx_set_power_state(struct hda_codec *codec, hda_nid_t fg,
 				unsigned int power_state)
 {
@@ -5655,8 +5641,6 @@ again:
 		} else {
 			codec->patch_ops.set_power_state =
 					stac92xx_set_power_state;
-			codec->patch_ops.post_suspend =
-					stac92xx_post_suspend;
 		}
 		codec->patch_ops.pre_resume = stac92xx_pre_resume;
 		codec->patch_ops.check_power_status =
@@ -5978,8 +5962,6 @@ again:
 		} else {
 			codec->patch_ops.set_power_state =
 					stac92xx_set_power_state;
-			codec->patch_ops.post_suspend =
-					stac92xx_post_suspend;
 		}
 		codec->patch_ops.pre_resume = stac92xx_pre_resume;
 		codec->patch_ops.check_power_status =


