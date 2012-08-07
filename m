Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030853Ab2HGWl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:41:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33528 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030840Ab2HGWlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:41:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 101/109] ALSA: hda - Fix mute-LED GPIO initialization for IDT codecs
Date: Tue,  7 Aug 2012 15:36:00 -0700
Message-Id: <20120807222051.928694094@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 1f43f6c1bc8d740e75b4177eb29110858bb5fea2 upstream.

The IDT codecs initializes the GPIO setup for mute LEDs via
snd_hda_sync_vmaster_hook().  This works in most cases except for the
very first call, which is called before PCM and control creations.
Thus before Master switch is set manually via alsactl, the mute LED
may show the wrong state, depending on the polarity.

Now it's fixed by calling the LED-status update function manually when
no vmaster is set yet.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4437,7 +4437,13 @@ static int stac92xx_init(struct hda_code
 	snd_hda_jack_report_sync(codec);
 
 	/* sync mute LED */
-	snd_hda_sync_vmaster_hook(&spec->vmaster_mute);
+	if (spec->gpio_led) {
+		if (spec->vmaster_mute.hook)
+			snd_hda_sync_vmaster_hook(&spec->vmaster_mute);
+		else /* the very first init call doesn't have vmaster yet */
+			stac92xx_update_led_status(codec, false);
+	}
+
 	if (spec->dac_list)
 		stac92xx_power_down(codec);
 	return 0;


