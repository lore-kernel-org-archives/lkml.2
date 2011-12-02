Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab1LBFK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 00:10:57 -0500
Received: from matrix.voodoobox.net ([75.127.97.206]:38325 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1LBFK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 00:10:56 -0500
X-Greylist: delayed 2460 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Dec 2011 00:10:56 EST
Subject: [PATCH 2/2] ALSA: sis7019 - convert to dev_*() logging
From: David Dillow <dave@thedillows.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel mailing list <alsa-devel@alsa-project.org>,
        linux-kernel@vger.kernel.org, misiu <tjosko@yahoo.com>
Date: Thu, 01 Dec 2011 23:26:57 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1322800017.26859.5.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Dillow <dave@thedillows.org>
--
 sound/pci/sis7019.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/sound/pci/sis7019.c b/sound/pci/sis7019.c
index 28dfafb..7331b2d 100644
--- a/sound/pci/sis7019.c
+++ b/sound/pci/sis7019.c
@@ -983,7 +983,7 @@ timeout:
 	mutex_unlock(&sis->ac97_mutex);
 
 	if (!count) {
-		printk(KERN_ERR "sis7019: ac97 codec %d timeout cmd 0x%08x\n",
+		dev_err(&sis->pci->dev, "ac97 codec %d timeout cmd 0x%08x\n",
 					codec, cmd);
 	}
 
@@ -1142,13 +1142,13 @@ static int sis_chip_init(struct sis7019 *sis)
 	/* All done, check for errors.
 	 */
 	if (!sis->codecs_present) {
-		printk(KERN_ERR "sis7019: could not find any codecs\n");
+		dev_err(&sis->pci->dev, "could not find any codecs\n");
 		return -EIO;
 	}
 
 	if (sis->codecs_present != codecs) {
-		printk(KERN_WARNING "sis7019: missing codecs, found %0x, expected %0x\n",
-		       sis->codecs_present, codecs);
+		dev_warn(&sis->pci->dev, "missing codecs, found %0x, expected %0x\n",
+					 sis->codecs_present, codecs);
 	}
 
 	/* Let the hardware know that the audio driver is alive,
@@ -1256,18 +1256,18 @@ static int sis_resume(struct pci_dev *pci)
 	pci_restore_state(pci);
 
 	if (pci_enable_device(pci) < 0) {
-		printk(KERN_ERR "sis7019: unable to re-enable device\n");
+		dev_err(&pci->dev, "unable to re-enable device\n");
 		goto error;
 	}
 
 	if (sis_chip_init(sis)) {
-		printk(KERN_ERR "sis7019: unable to re-init controller\n");
+		dev_err(&pci->dev, "unable to re-init controller\n");
 		goto error;
 	}
 
 	if (request_irq(pci->irq, sis_interrupt, IRQF_SHARED,
 			KBUILD_MODNAME, sis)) {
-		printk(KERN_ERR "sis7019: unable to regain IRQ %d\n", pci->irq);
+		dev_err(&pci->dev, "unable to regain IRQ %d\n", pci->irq);
 		goto error;
 	}
 
@@ -1335,8 +1335,7 @@ static int __devinit sis_chip_create(struct snd_card *card,
 		goto error_out;
 
 	if (pci_set_dma_mask(pci, DMA_BIT_MASK(30)) < 0) {
-		printk(KERN_ERR "sis7019: architecture does not support "
-					"30-bit PCI busmaster DMA");
+		dev_err(&pci->dev, "architecture does not support 30-bit PCI busmaster DMA");
 		goto error_out_enabled;
 	}
 
@@ -1350,20 +1349,20 @@ static int __devinit sis_chip_create(struct snd_card *card,
 
 	rc = pci_request_regions(pci, "SiS7019");
 	if (rc) {
-		printk(KERN_ERR "sis7019: unable request regions\n");
+		dev_err(&pci->dev, "unable request regions\n");
 		goto error_out_enabled;
 	}
 
 	rc = -EIO;
 	sis->ioaddr = ioremap_nocache(pci_resource_start(pci, 1), 0x4000);
 	if (!sis->ioaddr) {
-		printk(KERN_ERR "sis7019: unable to remap MMIO, aborting\n");
+		dev_err(&pci->dev, "unable to remap MMIO, aborting\n");
 		goto error_out_cleanup;
 	}
 
 	rc = sis_alloc_suspend(sis);
 	if (rc < 0) {
-		printk(KERN_ERR "sis7019: unable to allocate state storage\n");
+		dev_err(&pci->dev, "unable to allocate state storage\n");
 		goto error_out_cleanup;
 	}
 
@@ -1371,9 +1370,9 @@ static int __devinit sis_chip_create(struct snd_card *card,
 	if (rc)
 		goto error_out_cleanup;
 
-	if (request_irq(pci->irq, sis_interrupt, IRQF_SHARED,
-			KBUILD_MODNAME, sis)) {
-		printk(KERN_ERR "unable to allocate irq %d\n", sis->irq);
+	if (request_irq(pci->irq, sis_interrupt, IRQF_SHARED, KBUILD_MODNAME,
+			sis)) {
+		dev_err(&pci->dev, "unable to allocate irq %d\n", sis->irq);
 		goto error_out_cleanup;
 	}
 


