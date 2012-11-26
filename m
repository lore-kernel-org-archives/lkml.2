Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2KZRnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:43:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47764 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933463Ab2KZRKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 162/270] ALSA: hda - Fix registration race of VGA switcheroo
Date: Mon, 26 Nov 2012 14:57:32 -0200
Message-Id: <1353949160-26803-163-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 128960a9ad67e2d119738f5211956e0304517551 upstream.

Delay the registration of VGA switcheroo client to the end of the
probing.  Otherwise a too quick switching may result in Oops during
probing.

Also add the check of the return value from snd_hda_lock_devices().

Reported-and-tested-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/hda_intel.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 7757536..ff2bf55 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -485,6 +485,7 @@ struct azx {
 
 	/* VGA-switcheroo setup */
 	unsigned int use_vga_switcheroo:1;
+	unsigned int vga_switcheroo_registered:1;
 	unsigned int init_failed:1; /* delayed init failed */
 	unsigned int disabled:1; /* disabled by VGA-switcher */
 
@@ -2523,7 +2524,9 @@ static void azx_vs_set_state(struct pci_dev *pci,
 		if (disabled) {
 			azx_suspend(pci, PMSG_FREEZE);
 			chip->disabled = true;
-			snd_hda_lock_devices(chip->bus);
+			if (snd_hda_lock_devices(chip->bus))
+				snd_printk(KERN_WARNING SFX
+					   "Cannot lock devices!\n");
 		} else {
 			snd_hda_unlock_devices(chip->bus);
 			chip->disabled = false;
@@ -2566,14 +2569,20 @@ static const struct vga_switcheroo_client_ops azx_vs_ops = {
 
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
@@ -2593,7 +2602,8 @@ static int azx_free(struct azx *chip)
 	if (use_vga_switcheroo(chip)) {
 		if (chip->disabled && chip->bus)
 			snd_hda_unlock_devices(chip->bus);
-		vga_switcheroo_unregister_client(chip->pci);
+		if (chip->vga_switcheroo_registered)
+			vga_switcheroo_unregister_client(chip->pci);
 	}
 
 	if (chip->initialized) {
@@ -2935,14 +2945,6 @@ static int __devinit azx_create(struct snd_card *card, struct pci_dev *pci,
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
@@ -3169,6 +3171,13 @@ static int __devinit azx_probe(struct pci_dev *pci,
 
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
 
-- 
1.7.9.5

