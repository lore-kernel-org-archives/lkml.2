Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab0IRTbF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:31:05 -0400
Received: from kroah.org ([198.145.64.141]:43410 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756826Ab0IRTPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:15 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:01 2010
Message-Id: <20100918191301.880506109@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [053/129] ALSA: virtuoso: work around missing reset in the Xonar DS Windows driver
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 4c25b93223340deff73381cc47f9244fb379a74d upstream.

For the WM8776 chip, this driver uses a different sample format and
more features than the Windows driver.  When rebooting from Linux into
Windows, the latter driver does not reset the chip but assumes all its
registers have their default settings, so we get garbled sound or, if
the output happened to be muted before rebooting, no sound.

To make that driver happy, hook our driver's cleanup function into the
shutdown notifier and ensure that the chip gets reset.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-and-tested-by: Nathan Schagen
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/oxygen.h       |    1 +
 sound/pci/oxygen/oxygen_lib.c   |   21 ++++++++++++++++++---
 sound/pci/oxygen/virtuoso.c     |    1 +
 sound/pci/oxygen/xonar_wm87x6.c |    1 +
 4 files changed, 21 insertions(+), 3 deletions(-)

--- a/sound/pci/oxygen/oxygen.h
+++ b/sound/pci/oxygen/oxygen.h
@@ -155,6 +155,7 @@ void oxygen_pci_remove(struct pci_dev *p
 int oxygen_pci_suspend(struct pci_dev *pci, pm_message_t state);
 int oxygen_pci_resume(struct pci_dev *pci);
 #endif
+void oxygen_pci_shutdown(struct pci_dev *pci);
 
 /* oxygen_mixer.c */
 
--- a/sound/pci/oxygen/oxygen_lib.c
+++ b/sound/pci/oxygen/oxygen_lib.c
@@ -519,16 +519,21 @@ static void oxygen_init(struct oxygen *c
 	}
 }
 
-static void oxygen_card_free(struct snd_card *card)
+static void oxygen_shutdown(struct oxygen *chip)
 {
-	struct oxygen *chip = card->private_data;
-
 	spin_lock_irq(&chip->reg_lock);
 	chip->interrupt_mask = 0;
 	chip->pcm_running = 0;
 	oxygen_write16(chip, OXYGEN_DMA_STATUS, 0);
 	oxygen_write16(chip, OXYGEN_INTERRUPT_MASK, 0);
 	spin_unlock_irq(&chip->reg_lock);
+}
+
+static void oxygen_card_free(struct snd_card *card)
+{
+	struct oxygen *chip = card->private_data;
+
+	oxygen_shutdown(chip);
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
 	flush_scheduled_work();
@@ -778,3 +783,13 @@ int oxygen_pci_resume(struct pci_dev *pc
 }
 EXPORT_SYMBOL(oxygen_pci_resume);
 #endif /* CONFIG_PM */
+
+void oxygen_pci_shutdown(struct pci_dev *pci)
+{
+	struct snd_card *card = pci_get_drvdata(pci);
+	struct oxygen *chip = card->private_data;
+
+	oxygen_shutdown(chip);
+	chip->model.cleanup(chip);
+}
+EXPORT_SYMBOL(oxygen_pci_shutdown);
--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -95,6 +95,7 @@ static struct pci_driver xonar_driver =
 	.suspend = oxygen_pci_suspend,
 	.resume = oxygen_pci_resume,
 #endif
+	.shutdown = oxygen_pci_shutdown,
 };
 
 static int __init alsa_card_xonar_init(void)
--- a/sound/pci/oxygen/xonar_wm87x6.c
+++ b/sound/pci/oxygen/xonar_wm87x6.c
@@ -193,6 +193,7 @@ static void xonar_ds_init(struct oxygen
 static void xonar_ds_cleanup(struct oxygen *chip)
 {
 	xonar_disable_output(chip);
+	wm8776_write(chip, WM8776_RESET, 0);
 }
 
 static void xonar_ds_suspend(struct oxygen *chip)


