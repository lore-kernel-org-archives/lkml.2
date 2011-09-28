Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1I1W7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:59:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933205Ab1I1Wss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:47 2011
Message-Id: <20110928220147.520694867@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>, Takashi Iwai <tiwai@suse.de>
Subject: [210/244] ALSA: fm801: Gracefully handle failure of tuner auto-detect
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit c37279b92aba2893578f61076cd2eef5c5fa0e99 upstream.

Commit 9676001559fce06e37c7dc230ab275f605556176
("ALSA: fm801: add error handling if auto-detect fails") seems to
break systems that were previously working without a tuner.

As a bonus, this should fix init and cleanup for the case where the
tuner is explicitly disabled.

Reported-and-tested-by: Hor Jiun Shyong <jiunshyong@gmail.com>
References: http://bugs.debian.org/641946
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/fm801.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -68,6 +68,7 @@ MODULE_PARM_DESC(enable, "Enable FM801 s
 module_param_array(tea575x_tuner, int, NULL, 0444);
 MODULE_PARM_DESC(tea575x_tuner, "TEA575x tuner access method (0 = auto, 1 = SF256-PCS, 2=SF256-PCP, 3=SF64-PCR, 8=disable, +16=tuner-only).");
 
+#define TUNER_DISABLED		(1<<3)
 #define TUNER_ONLY		(1<<4)
 #define TUNER_TYPE_MASK		(~TUNER_ONLY & 0xFFFF)
 
@@ -1150,7 +1151,8 @@ static int snd_fm801_free(struct fm801 *
 
       __end_hw:
 #ifdef CONFIG_SND_FM801_TEA575X_BOOL
-	snd_tea575x_exit(&chip->tea);
+	if (!(chip->tea575x_tuner & TUNER_DISABLED))
+		snd_tea575x_exit(&chip->tea);
 #endif
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
@@ -1250,10 +1252,15 @@ static int __devinit snd_fm801_create(st
 		}
 		if (tea575x_tuner == 4) {
 			snd_printk(KERN_ERR "TEA575x radio not found\n");
-			return -ENODEV;
+			chip->tea575x_tuner = TUNER_DISABLED;
 		}
 	}
-	strlcpy(chip->tea.card, snd_fm801_tea575x_gpios[(tea575x_tuner & TUNER_TYPE_MASK) - 1].name, sizeof(chip->tea.card));
+	if (!(chip->tea575x_tuner & TUNER_DISABLED)) {
+		strlcpy(chip->tea.card,
+			snd_fm801_tea575x_gpios[(tea575x_tuner &
+						 TUNER_TYPE_MASK) - 1].name,
+			sizeof(chip->tea.card));
+	}
 #endif
 
 	*rchip = chip;


