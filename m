Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965132Ab2B1BLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:11:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58461 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965120Ab2B1BLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:11:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.225.164 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010433.571953394@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 47/72] ALSA: hda/realtek - Fix overflow of vol/sw check bitmap
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c14c95f62ecb8710af14ae0d48e01991b70bb6f4 upstream.

The bitmap introduced in the commit [527e4d73: ALSA: hda/realtek - Fix
missing volume controls with ALC260] is too narrow for some codecs,
which may have more NIDs than 0x20, thus it may overflow the bitmap
array on them.

Just double the number to cover all and also add a sanity-check code
to be safer.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -79,6 +79,8 @@ enum {
 	ALC_AUTOMUTE_MIXER,	/* mute/unmute mixer widget AMP */
 };
 
+#define MAX_VOL_NIDS	0x40
+
 struct alc_spec {
 	/* codec parameterization */
 	const struct snd_kcontrol_new *mixers[5];	/* mixer arrays */
@@ -117,8 +119,8 @@ struct alc_spec {
 	const hda_nid_t *capsrc_nids;
 	hda_nid_t dig_in_nid;		/* digital-in NID; optional */
 	hda_nid_t mixer_nid;		/* analog-mixer NID */
-	DECLARE_BITMAP(vol_ctls, 0x20 << 1);
-	DECLARE_BITMAP(sw_ctls, 0x20 << 1);
+	DECLARE_BITMAP(vol_ctls, MAX_VOL_NIDS << 1);
+	DECLARE_BITMAP(sw_ctls, MAX_VOL_NIDS << 1);
 
 	/* capture setup for dynamic dual-adc switch */
 	hda_nid_t cur_adc;
@@ -3068,7 +3070,10 @@ static int alc_auto_fill_dac_nids(struct
 static inline unsigned int get_ctl_pos(unsigned int data)
 {
 	hda_nid_t nid = get_amp_nid_(data);
-	unsigned int dir = get_amp_direction_(data);
+	unsigned int dir;
+	if (snd_BUG_ON(nid >= MAX_VOL_NIDS))
+		return 0;
+	dir = get_amp_direction_(data);
 	return (nid << 1) | dir;
 }
 


