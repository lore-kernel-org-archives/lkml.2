Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893Ab2KAU42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:56:28 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:58476 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab2KAU40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:56:26 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: [PATCH] snd-es1968: remove pm_whitelist
Date: Thu, 1 Nov 2012 21:55:54 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201211012155.54713.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_whitelist breaks suspend on all non-whitelisted cards for unknown purpose.
Remove it. This fixes suspend on Terratec DMX and SF64-PCE2 cards.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 sound/pci/es1968.c |   40 ----------------------------------------
 1 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 5d0e568..a9c92a4 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -137,7 +137,6 @@ static int total_bufsize[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1024 };
 static int pcm_substreams_p[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 4 };
 static int pcm_substreams_c[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1 };
 static int clock[SNDRV_CARDS];
-static int use_pm[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 2};
 static int enable_mpu[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 2};
 #ifdef SUPPORT_JOYSTICK
 static bool joystick[SNDRV_CARDS];
@@ -158,8 +157,6 @@ module_param_array(pcm_substreams_c, int, NULL, 0444);
 MODULE_PARM_DESC(pcm_substreams_c, "PCM Capture substreams for " CARD_NAME " soundcard.");
 module_param_array(clock, int, NULL, 0444);
 MODULE_PARM_DESC(clock, "Clock on " CARD_NAME " soundcard.  (0 = auto-detect)");
-module_param_array(use_pm, int, NULL, 0444);
-MODULE_PARM_DESC(use_pm, "Toggle power-management.  (0 = off, 1 = on, 2 = auto)");
 module_param_array(enable_mpu, int, NULL, 0444);
 MODULE_PARM_DESC(enable_mpu, "Enable MPU401.  (0 = off, 1 = on, 2 = auto)");
 #ifdef SUPPORT_JOYSTICK
@@ -519,7 +516,6 @@ struct es1968 {
 	struct pci_dev *pci;
 	struct snd_card *card;
 	struct snd_pcm *pcm;
-	int do_pm;		/* power-management enabled */
 
 	/* DMA memory block */
 	struct list_head buf_list;
@@ -2387,9 +2383,6 @@ static int es1968_suspend(struct device *dev)
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct es1968 *chip = card->private_data;
 
-	if (! chip->do_pm)
-		return 0;
-
 	chip->in_suspend = 1;
 	cancel_work_sync(&chip->hwvol_work);
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
@@ -2410,9 +2403,6 @@ static int es1968_resume(struct device *dev)
 	struct es1968 *chip = card->private_data;
 	struct esschan *es;
 
-	if (! chip->do_pm)
-		return 0;
-
 	/* restore all our config */
 	pci_set_power_state(pci, PCI_D0);
 	pci_restore_state(pci);
@@ -2648,15 +2638,6 @@ struct ess_device_list {
 	unsigned short vendor;	/* subsystem vendor id */
 };
 
-static struct ess_device_list pm_whitelist[] __devinitdata = {
-	{ TYPE_MAESTRO2E, 0x0e11 },	/* Compaq Armada */
-	{ TYPE_MAESTRO2E, 0x1028 },
-	{ TYPE_MAESTRO2E, 0x103c },
-	{ TYPE_MAESTRO2E, 0x1179 },
-	{ TYPE_MAESTRO2E, 0x14c0 },	/* HP omnibook 4150 */
-	{ TYPE_MAESTRO2E, 0x1558 },
-};
-
 static struct ess_device_list mpu_blacklist[] __devinitdata = {
 	{ TYPE_MAESTRO2, 0x125d },
 };
@@ -2667,7 +2648,6 @@ static int __devinit snd_es1968_create(struct snd_card *card,
 				       int play_streams,
 				       int capt_streams,
 				       int chip_type,
-				       int do_pm,
 				       int radio_nr,
 				       struct es1968 **chip_ret)
 {
@@ -2736,25 +2716,6 @@ static int __devinit snd_es1968_create(struct snd_card *card,
 	/* just to be sure */
 	pci_set_master(pci);
 
-	if (do_pm > 1) {
-		/* disable power-management if not on the whitelist */
-		unsigned short vend;
-		pci_read_config_word(chip->pci, PCI_SUBSYSTEM_VENDOR_ID, &vend);
-		for (i = 0; i < (int)ARRAY_SIZE(pm_whitelist); i++) {
-			if (chip->type == pm_whitelist[i].type &&
-			    vend == pm_whitelist[i].vendor) {
-				do_pm = 1;
-				break;
-			}
-		}
-		if (do_pm > 1) {
-			/* not matched; disabling pm */
-			printk(KERN_INFO "es1968: not attempting power management.\n");
-			do_pm = 0;
-		}
-	}
-	chip->do_pm = do_pm;
-
 	snd_es1968_chip_init(chip);
 
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
@@ -2817,7 +2778,6 @@ static int __devinit snd_es1968_probe(struct pci_dev *pci,
 				     pcm_substreams_p[dev], 
 				     pcm_substreams_c[dev],
 				     pci_id->driver_data,
-				     use_pm[dev],
 				     radio_nr[dev],
 				     &chip)) < 0) {
 		snd_card_free(card);
-- 
Ondrej Zary
