Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1H0PEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 11:04:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1H0O55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:57:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:54 2011
Message-Id: <20110826215054.419297908@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [15/35] ALSA: usb-audio - Fix missing mixer dB information
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 38b65190c6ab0be8ce7cff69e734ca5b5e7fa309 upstream.

The recent fix for testing dB range at the mixer creation time seems
to cause regressions in some devices.  In such devices, reading the dB
info at probing time gives an error, thus both dBmin and dBmax are still
zero, and TLV flag isn't set although the later read of dB info succeeds.

This patch adds a workaround for such a case by assuming that the later
read will succeed.  In future, a similar test should be performed in a
case where a wrong dB range is seen even in the later read.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/mixer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -152,6 +152,7 @@ static inline void check_mapped_dB(const
 	if (p && p->dB) {
 		cval->dBmin = p->dB->min;
 		cval->dBmax = p->dB->max;
+		cval->initialized = 1;
 	}
 }
 
@@ -1092,7 +1093,7 @@ static void build_feature_ctl(struct mix
 				" Switch" : " Volume");
 		if (control == UAC_FU_VOLUME) {
 			check_mapped_dB(map, cval);
-			if (cval->dBmin < cval->dBmax) {
+			if (cval->dBmin < cval->dBmax || !cval->initialized) {
 				kctl->tlv.c = mixer_vol_tlv;
 				kctl->vd[0].access |= 
 					SNDRV_CTL_ELEM_ACCESS_TLV_READ |


