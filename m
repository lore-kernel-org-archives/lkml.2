Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2HSV2G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 17:28:06 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:38659 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab2HSV17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 17:27:59 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Massimo Piccioni <dafastidio@libero.it>
Subject: [PATCH 2/2] snd-ad1816a: Implement suspend/resume
Date: Sun, 19 Aug 2012 23:27:26 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201208192327.27334.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement suspend/resume support for AD1816 chips.
Tested with Terratec SoundSystem Base-1.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff --git a/include/sound/ad1816a.h b/include/sound/ad1816a.h
index 62da41e..2a89f0d 100644
--- a/include/sound/ad1816a.h
+++ b/include/sound/ad1816a.h
@@ -147,6 +147,9 @@ struct snd_ad1816a {
 	unsigned int c_dma_size;
 
 	struct snd_timer *timer;
+#ifdef CONFIG_PM
+	unsigned short image[48];
+#endif
 };
 
 
@@ -171,5 +174,9 @@ extern int snd_ad1816a_pcm(struct snd_ad1816a *chip, int device, struct snd_pcm
 extern int snd_ad1816a_mixer(struct snd_ad1816a *chip);
 extern int snd_ad1816a_timer(struct snd_ad1816a *chip, int device,
 			     struct snd_timer **rtimer);
+#ifdef CONFIG_PM
+extern void snd_ad1816a_suspend(struct snd_ad1816a *chip);
+extern void snd_ad1816a_resume(struct snd_ad1816a *chip);
+#endif
 
 #endif	/* __SOUND_AD1816A_H */
diff --git a/sound/isa/ad1816a/ad1816a.c b/sound/isa/ad1816a/ad1816a.c
index 1a374e6..2c2f829 100644
--- a/sound/isa/ad1816a/ad1816a.c
+++ b/sound/isa/ad1816a/ad1816a.c
@@ -244,13 +244,37 @@ static void __devexit snd_ad1816a_pnp_remove(struct pnp_card_link * pcard)
 	pnp_set_card_drvdata(pcard, NULL);
 }
 
+#ifdef CONFIG_PM
+static int snd_ad1816a_pnp_suspend(struct pnp_card_link *pcard,
+				   pm_message_t state)
+{
+	struct snd_card *card = pnp_get_card_drvdata(pcard);
+
+	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
+	snd_ad1816a_suspend(card->private_data);
+	return 0;
+}
+
+static int snd_ad1816a_pnp_resume(struct pnp_card_link *pcard)
+{
+	struct snd_card *card = pnp_get_card_drvdata(pcard);
+
+	snd_ad1816a_resume(card->private_data);
+	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
+	return 0;
+}
+#endif
+
 static struct pnp_card_driver ad1816a_pnpc_driver = {
 	.flags		= PNP_DRIVER_RES_DISABLE,
 	.name		= "ad1816a",
 	.id_table	= snd_ad1816a_pnpids,
 	.probe		= snd_ad1816a_pnp_detect,
 	.remove		= __devexit_p(snd_ad1816a_pnp_remove),
-	/* FIXME: suspend/resume */
+#ifdef CONFIG_PM
+	.suspend	= snd_ad1816a_pnp_suspend,
+	.resume		= snd_ad1816a_pnp_resume,
+#endif
 };
 
 static int __init alsa_card_ad1816a_init(void)
diff --git a/sound/isa/ad1816a/ad1816a_lib.c b/sound/isa/ad1816a/ad1816a_lib.c
index de5cc1c..db64df6 100644
--- a/sound/isa/ad1816a/ad1816a_lib.c
+++ b/sound/isa/ad1816a/ad1816a_lib.c
@@ -491,7 +491,7 @@ static int snd_ad1816a_capture_close(struct snd_pcm_substream *substream)
 }
 
 
-static void __devinit snd_ad1816a_init(struct snd_ad1816a *chip)
+static void snd_ad1816a_init(struct snd_ad1816a *chip)
 {
 	unsigned long flags;
 
@@ -511,6 +511,32 @@ static void __devinit snd_ad1816a_init(struct snd_ad1816a *chip)
 	spin_unlock_irqrestore(&chip->lock, flags);
 }
 
+#ifdef CONFIG_PM
+void snd_ad1816a_suspend(struct snd_ad1816a *chip)
+{
+	int reg;
+	unsigned long flags;
+
+	snd_pcm_suspend_all(chip->pcm);
+	spin_lock_irqsave(&chip->lock, flags);
+	for (reg = 0; reg < 48; reg++)
+		chip->image[reg] = snd_ad1816a_read(chip, reg);
+	spin_unlock_irqrestore(&chip->lock, flags);
+}
+
+void snd_ad1816a_resume(struct snd_ad1816a *chip)
+{
+	int reg;
+	unsigned long flags;
+
+	snd_ad1816a_init(chip);
+	spin_lock_irqsave(&chip->lock, flags);
+	for (reg = 0; reg < 48; reg++)
+		snd_ad1816a_write(chip, reg, chip->image[reg]);
+	spin_unlock_irqrestore(&chip->lock, flags);
+}
+#endif
+
 static int __devinit snd_ad1816a_probe(struct snd_ad1816a *chip)
 {
 	unsigned long flags;




-- 
Ondrej Zary
