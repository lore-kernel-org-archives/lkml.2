Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab2BAVJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:09:42 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36182 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757150Ab2BAVJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:39 -0500
X-Sasl-enc: y/a+guezwaTedip9n/xPX3e2nuF+dXo/vTYs+HSY12HY 1328130577
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:44 2012
Message-Id: <20120201210044.061535636@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [02/89] ALSA: hda - Fix silent outputs from docking-station jacks of Dell laptops
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b4ead019afc201f71c39cd0dfcaafed4a97b3dd2 upstream.

The recent change of the power-widget handling for IDT codecs caused
the silent output from the docking-station line-out jack.  This was
partially fixed by the commit f2cbba7602383cd9cdd21f0a5d0b8bd1aad47b33
"ALSA: hda - Fix the lost power-setup of seconary pins after PM resume".
But the line-out on the docking-station is still silent when booted
with the jack plugged even by this fix.

The remainig bug is that the power-widget is set off in stac92xx_init()
because the pins in cfg->line_out_pins[] aren't checked there properly
but only hp_pins[] are checked in is_nid_hp_pin().

This patch fixes the problem by checking both HP and line-out pins
and leaving the power-map correctly.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=42637

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4253,13 +4253,15 @@ static int enable_pin_detect(struct hda_
 	return 1;
 }
 
-static int is_nid_hp_pin(struct auto_pin_cfg *cfg, hda_nid_t nid)
+static int is_nid_out_jack_pin(struct auto_pin_cfg *cfg, hda_nid_t nid)
 {
 	int i;
 	for (i = 0; i < cfg->hp_outs; i++)
 		if (cfg->hp_pins[i] == nid)
 			return 1; /* nid is a HP-Out */
-
+	for (i = 0; i < cfg->line_outs; i++)
+		if (cfg->line_out_pins[i] == nid)
+			return 1; /* nid is a line-Out */
 	return 0; /* nid is not a HP-Out */
 };
 
@@ -4465,7 +4467,7 @@ static int stac92xx_init(struct hda_code
 			continue;
 		}
 
-		if (is_nid_hp_pin(cfg, nid))
+		if (is_nid_out_jack_pin(cfg, nid))
 			continue; /* already has an unsol event */
 
 		pinctl = snd_hda_codec_read(codec, nid, 0,


