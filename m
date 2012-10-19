Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2JSCxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:53:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:52595 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965017Ab2JSCtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 68/76] ALSA: hda - Fix registration race of VGA switcheroo
Date: Thu, 18 Oct 2012 19:47:32 -0700
Message-Id: <20121019024401.059608500@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 128960a9ad67e2d119738f5211956e0304517551 upstream.

Delay the registration of VGA switcheroo client to the end of the
probing.  Otherwise a too quick switching may result in Oops during
probing.

Also add the check of the return value from snd_hda_lock_devices().

Reported-and-tested-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -487,6 +487,7 @@ struct azx {
 
 	/* VGA-switcheroo setup */
 	unsigned int use_vga_switcheroo:1;
+	unsigned int vga_switcheroo_registered:1;
 	unsigned int init_failed:1; /* delayed init failed */
 	unsigned int disabled:1; /* disabled by VGA-switcher */
 
@@ -2556,7 +2557,9 @@ static void azx_vs_set_state(struct pci_
 		if (disabled) {
 			azx_suspend(&pci->dev);
 			chip->disabled = true;
-			snd_hda_lock_devices(chip->bus);
+			if (snd_hda_lock_devices(chip->bus))
+				snd_printk(KERN_WARNING SFX
+					   "Cannot lock devices!\n");
 		} else {
 			snd_hda_unlock_devices(chip->bus);
 			chip->disabled = false;
@@ -2599,14 +2602,20 @@ static const struct vga_switcheroo_clien
 
 static int __devinit register_vga_switcheroo(struct azx *chip)
 {
+	int err;
+
 	if (!chip->use_vga_switcheroo)
 		return 0;
 	/* FIXME: currently only handling DIS controller
 	 * is there any machine with two switchable HDMI audio controllers?
 	 */
-	return vga_switcheroo_register_audio_client(chip->pci, &azx_vs_ops,
+	err = vga_switcheroo_register_audio_client(chip->pci, &azx_vs_ops,
 						    VGA_SWITCHEROO_DIS,
 						    chip->bus != NULL);
+	if (err < 0)
+		return err;
+	chip->vga_switcheroo_registered = 1;
+	return 0;
 }
 #else
 #define init_vga_switcheroo(chip)		/* NOP */
@@ -2626,7 +2635,8 @@ static int azx_free(struct azx *chip)
 	if (use_vga_switcheroo(chip)) {
 		if (chip->disabled && chip->bus)
 			snd_hda_unlock_devices(chip->bus);
-		vga_switcheroo_unregister_client(chip->pci);
+		if (chip->vga_switcheroo_registered)
+			vga_switcheroo_unregister_client(chip->pci);
 	}
 
 	if (chip->initialized) {
@@ -2974,14 +2984,6 @@ static int __devinit azx_create(struct s
 	}
 
  ok:
-	err = register_vga_switcheroo(chip);
-	if (err < 0) {
-		snd_printk(KERN_ERR SFX
-			   "Error registering VGA-switcheroo client\n");
-		azx_free(chip);
-		return err;
-	}
-
 	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops);
 	if (err < 0) {
 		snd_printk(KERN_ERR SFX "Error creating device [card]!\n");
@@ -3208,6 +3210,13 @@ static int __devinit azx_probe(struct pc
 
 	pci_set_drvdata(pci, card);
 
+	err = register_vga_switcheroo(chip);
+	if (err < 0) {
+		snd_printk(KERN_ERR SFX
+			   "Error registering VGA-switcheroo client\n");
+		goto out_free;
+	}
+
 	dev++;
 	return 0;
 


