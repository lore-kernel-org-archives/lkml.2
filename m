Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab2GQHRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:17:00 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:56188 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab2GQHQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:16:56 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: [PATCH] snd-opti9xx: Implement suspend/resume
Date: Tue, 17 Jul 2012 09:16:44 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201207170916.44277.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement suspend/resume support for Opti 92x and 93x chips.
Tested with Opti 929A+AD1848 and Opti 931.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -136,8 +136,8 @@ struct snd_opti9xx {
 #ifdef OPTi93X
 	unsigned long mc_indir_index;
 	struct resource *res_mc_indir;
-	struct snd_wss *codec;
 #endif	/* OPTi93X */
+	struct snd_wss *codec;
 	unsigned long pwd_reg;
 
 	spinlock_t lock;
@@ -870,9 +870,7 @@ static int __devinit snd_opti9xx_probe(struct snd_card *card)
 			       &codec);
 	if (error < 0)
 		return error;
-#ifdef OPTi93X
 	chip->codec = codec;
-#endif
 	error = snd_wss_pcm(codec, 0, &pcm);
 	if (error < 0)
 		return error;
@@ -1053,11 +1051,55 @@ static int __devexit snd_opti9xx_isa_remove(struct device *devptr,
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int snd_opti9xx_suspend(struct snd_card *card)
+{
+	struct snd_opti9xx *chip = card->private_data;
+
+	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
+	chip->codec->suspend(chip->codec);
+	return 0;
+}
+
+static int snd_opti9xx_resume(struct snd_card *card)
+{
+	struct snd_opti9xx *chip = card->private_data;
+	int error, xdma2;
+#if defined(CS4231) || defined(OPTi93X)
+	xdma2 = dma2;
+#else
+	xdma2 = -1;
+#endif
+
+	error = snd_opti9xx_configure(chip, port, irq, dma1, xdma2,
+				      mpu_port, mpu_irq);
+	if (error)
+		return error;
+	chip->codec->resume(chip->codec);
+	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
+	return 0;
+}
+
+static int snd_opti9xx_isa_suspend(struct device *dev, unsigned int n,
+				   pm_message_t state)
+{
+	return snd_opti9xx_suspend(dev_get_drvdata(dev));
+}
+
+static int snd_opti9xx_isa_resume(struct device *dev, unsigned int n)
+{
+	return snd_opti9xx_resume(dev_get_drvdata(dev));
+}
+#endif
+
 static struct isa_driver snd_opti9xx_driver = {
 	.match		= snd_opti9xx_isa_match,
 	.probe		= snd_opti9xx_isa_probe,
 	.remove		= __devexit_p(snd_opti9xx_isa_remove),
-	/* FIXME: suspend/resume */
+#ifdef CONFIG_PM
+	.suspend	= snd_opti9xx_isa_suspend,
+	.resume		= snd_opti9xx_isa_resume,
+#endif
 	.driver		= {
 		.name	= DEV_NAME
 	},
@@ -1123,12 +1165,29 @@ static void __devexit snd_opti9xx_pnp_remove(struct pnp_card_link * pcard)
 	snd_opti9xx_pnp_is_probed = 0;
 }
 
+#ifdef CONFIG_PM
+static int snd_opti9xx_pnp_suspend(struct pnp_card_link *pcard,
+				   pm_message_t state)
+{
+	return snd_opti9xx_suspend(pnp_get_card_drvdata(pcard));
+}
+
+static int snd_opti9xx_pnp_resume(struct pnp_card_link *pcard)
+{
+	return snd_opti9xx_resume(pnp_get_card_drvdata(pcard));
+}
+#endif
+
 static struct pnp_card_driver opti9xx_pnpc_driver = {
 	.flags		= PNP_DRIVER_RES_DISABLE,
 	.name		= "opti9xx",
 	.id_table	= snd_opti9xx_pnpids,
 	.probe		= snd_opti9xx_pnp_probe,
 	.remove		= __devexit_p(snd_opti9xx_pnp_remove),
+#ifdef CONFIG_PM
+	.suspend	= snd_opti9xx_pnp_suspend,
+	.resume		= snd_opti9xx_pnp_resume,
+#endif
 };
 #endif
 

-- 
Ondrej Zary
