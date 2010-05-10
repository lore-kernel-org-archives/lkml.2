Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab0EJXCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:02:20 -0400
Received: from kroah.org ([198.145.64.141]:51848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890Ab0EJW6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:09 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:39 2010
Message-Id: <20100510223539.267345022@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hans de Goede <hdegoede@redhat.com>, Takashi Iwai <tiwai@suse.de>
Subject: [54/98] ALSA: snd-meastro3: Ignore spurious HV interrupts during suspend / resume
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 715aa675338ce6e1a3b4f77cf87ea611f93058a8 upstream.

Ignore spurious HV interrupts during suspend / resume, this avoids
mistaking them for a mute button press. This is not very pretty but
it seems the only way to fix the master volume control gets muted
after suspend issue I'm seeing. Note that the es1968 driver is doing
exactly the same.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/maestro3.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -849,6 +849,7 @@ struct snd_m3 {
 	struct snd_kcontrol *master_switch;
 	struct snd_kcontrol *master_volume;
 	struct tasklet_struct hwvol_tq;
+	unsigned int in_suspend;
 
 #ifdef CONFIG_PM
 	u16 *suspend_mem;
@@ -1614,6 +1615,11 @@ static void snd_m3_update_hw_volume(unsi
 	outb(0x88, chip->iobase + SHADOW_MIX_REG_MASTER);
 	outb(0x88, chip->iobase + HW_VOL_COUNTER_MASTER);
 
+	/* Ignore spurious HV interrupts during suspend / resume, this avoids
+	   mistaking them for a mute button press. */
+	if (chip->in_suspend)
+		return;
+
 	if (!chip->master_switch || !chip->master_volume)
 		return;
 
@@ -2425,6 +2431,7 @@ static int m3_suspend(struct pci_dev *pc
 	if (chip->suspend_mem == NULL)
 		return 0;
 
+	chip->in_suspend = 1;
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
 	snd_pcm_suspend_all(chip->pcm);
 	snd_ac97_suspend(chip->ac97);
@@ -2498,6 +2505,7 @@ static int m3_resume(struct pci_dev *pci
 	snd_m3_hv_init(chip);
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
+	chip->in_suspend = 0;
 	return 0;
 }
 #endif /* CONFIG_PM */


