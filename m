Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030463Ab2HGWdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:33:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030438Ab2HGWdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:33:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 115/122] ALSA: hda - Fix mute-LED GPIO initialization for IDT codecs
Date: Tue,  7 Aug 2012 15:26:43 -0700
Message-Id: <20120807222000.448660945@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
 sound/pci/hda/patch_sigmatel.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4420,7 +4420,12 @@ static int stac92xx_init(struct hda_code
 	snd_hda_jack_report_sync(codec);
 
 	/* sync mute LED */
-	snd_hda_sync_vmaster_hook(&spec->vmaster_mute);
+	if (spec->gpio_led) {
+		if (spec->vmaster_mute.hook)
+			snd_hda_sync_vmaster_hook(&spec->vmaster_mute);
+		else /* the very first init call doesn't have vmaster yet */
+			stac92xx_update_led_status(codec, false);
+	}
 
 	/* sync the power-map */
 	if (spec->num_pwrs)


