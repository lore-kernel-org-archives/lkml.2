Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935228Ab1KJDas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:30:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934722Ab1KJDam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:30:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:20 2011
Message-Id: <20111109212720.432400649@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [197/262] ALSA: hda/realtek - Skip invalid digital out pins
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 51e4152a969aa6d2306492ebf143932dcb535c9b upstream.

Some BIOS report invalid pins as digital output pins.  The driver checks
the connection but it doesn't do it fully correctly, and it leaves some
undefined value as the audio-out widget, which makes the driver spewing
warnings.  This patch fixes the issue.

Reference: https://bugzilla.novell.com/show_bug.cgi?id=727348

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2088,25 +2088,27 @@ static void alc_auto_init_digital(struct
 static void alc_auto_parse_digital(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
-	int i, err;
+	int i, err, nums;
 	hda_nid_t dig_nid;
 
 	/* support multiple SPDIFs; the secondary is set up as a slave */
+	nums = 0;
 	for (i = 0; i < spec->autocfg.dig_outs; i++) {
 		err = snd_hda_get_connections(codec,
 					      spec->autocfg.dig_out_pins[i],
 					      &dig_nid, 1);
-		if (err < 0)
+		if (err <= 0)
 			continue;
-		if (!i) {
+		if (!nums) {
 			spec->multiout.dig_out_nid = dig_nid;
 			spec->dig_out_type = spec->autocfg.dig_out_type[0];
 		} else {
 			spec->multiout.slave_dig_outs = spec->slave_dig_outs;
-			if (i >= ARRAY_SIZE(spec->slave_dig_outs) - 1)
+			if (nums >= ARRAY_SIZE(spec->slave_dig_outs) - 1)
 				break;
-			spec->slave_dig_outs[i - 1] = dig_nid;
+			spec->slave_dig_outs[nums - 1] = dig_nid;
 		}
+		nums++;
 	}
 
 	if (spec->autocfg.dig_in_pin) {


