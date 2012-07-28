Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2G1POA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 11:14:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56024 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2G1PN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 11:13:58 -0400
Message-ID: <501401B1.4070108@gmail.com>
Date: Sat, 28 Jul 2012 17:13:53 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Krzysztof Helt <krzysztof.h1@wp.pl>, LKML <linux-kernel@vger.kernel.org>,
        Rene Herman <rene.herman@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: genirq: Flags mismatch irq 5. 00000000 (ES1688) vs. 00000000
References: <20120728132046.GA14210@localhost>
In-Reply-To: <20120728132046.GA14210@localhost>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/mixed;
 boundary="------------030007080408060209050303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030007080408060209050303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 28.07.2012 15:20, Fengguang Wu wrote:
> (ES1688)
> Reply-To: 
> 
> Hi all,
> 
> snd_es1688_create() seems not doing things right. It never frees the
> previously allocated resources on error return..  Anyone cares about
> this driver now?

Could you try the (not even compile-tested) patch attached?


Daniel


--------------030007080408060209050303
Content-Type: text/x-patch;
 name="es1688.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="es1688.diff"

diff --git a/sound/isa/es1688/es1688_lib.c b/sound/isa/es1688/es1688_lib.c
index 1d47be8..7cb309a 100644
--- a/sound/isa/es1688/es1688_lib.c
+++ b/sound/isa/es1688/es1688_lib.c
@@ -658,18 +658,25 @@ int snd_es1688_create(struct snd_card *card,
 	chip->irq = -1;
 	chip->dma8 = -1;
 	
-	if ((chip->res_port = request_region(port + 4, 12, "ES1688")) == NULL) {
+	chip->res_port = request_region(port + 4, 12, "ES1688");
+	if (chip->res_port == NULL) {
 		snd_printk(KERN_ERR "es1688: can't grab port 0x%lx\n", port + 4);
-		return -EBUSY;
+		err = -EBUSY;
+		goto exit;
 	}
-	if (request_irq(irq, snd_es1688_interrupt, 0, "ES1688", (void *) chip)) {
+
+	err = request_irq(irq, snd_es1688_interrupt, 0, "ES1688", (void *) chip);
+	if (err < 0) {
 		snd_printk(KERN_ERR "es1688: can't grab IRQ %d\n", irq);
-		return -EBUSY;
+		goto exit_release_region;
 	}
+
 	chip->irq = irq;
-	if (request_dma(dma8, "ES1688")) {
+	err = request_dma(dma8, "ES1688");
+
+	if (err < 0) {
 		snd_printk(KERN_ERR "es1688: can't grab DMA8 %d\n", dma8);
-		return -EBUSY;
+		goto exit_release_irq;
 	}
 	chip->dma8 = dma8;
 
@@ -685,14 +692,23 @@ int snd_es1688_create(struct snd_card *card,
 
 	err = snd_es1688_probe(chip);
 	if (err < 0)
-		return err;
+		goto exit_release_dma;
 
 	err = snd_es1688_init(chip, 1);
 	if (err < 0)
-		return err;
+		goto exit_release_dma;
 
 	/* Register device */
 	return snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops);
+
+exit_release_dma:
+	free_dma(chip->dma8);
+exit_release_irq:
+	free_irq(chip->irq, chip);
+exit_release_region:
+	release_and_free_resource(chip->res_port);
+exit:
+	return err;
 }
 
 static struct snd_pcm_ops snd_es1688_playback_ops = {

--------------030007080408060209050303--
