Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2CZXAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:00:41 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:19269 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2CZXAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:00:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1332802833!2210588!5
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: ep93xx-ac97: use devm_* helpers to cleanup probe
Date: Mon, 26 Mar 2012 16:00:08 -0700
User-Agent: KMail/1.9.9
CC: <alsa-devel@alsa-project.org>, <mika.westerberg@iki.fi>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <perex@perex.cz>,
        <tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203261600.09454.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the devm_* helpers to cleanup the probe routine. This also eliminates
having to carry the mem and irq values in the private data for the remove.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jaroslav Kysela <perex@perex.cz>
CC: Takashi Iwai <tiwai@suse.de>


---

diff --git a/sound/soc/ep93xx/ep93xx-ac97.c b/sound/soc/ep93xx/ep93xx-ac97.c
index 0678637..bdffab3 100644
--- a/sound/soc/ep93xx/ep93xx-ac97.c
+++ b/sound/soc/ep93xx/ep93xx-ac97.c
@@ -87,17 +87,13 @@
  * struct ep93xx_ac97_info - EP93xx AC97 controller info structure
  * @lock: mutex serializing access to the bus (slot 1 & 2 ops)
  * @dev: pointer to the platform device dev structure
- * @mem: physical memory resource for the registers
  * @regs: mapped AC97 controller registers
- * @irq: AC97 interrupt number
  * @done: bus ops wait here for an interrupt
  */
 struct ep93xx_ac97_info {
 	struct mutex		lock;
 	struct device		*dev;
-	struct resource		*mem;
 	void __iomem		*regs;
-	int			irq;
 	struct completion	done;
 };
 
@@ -359,66 +355,50 @@ static struct snd_soc_dai_driver ep93xx_ac97_dai = {
 static int __devinit ep93xx_ac97_probe(struct platform_device *pdev)
 {
 	struct ep93xx_ac97_info *info;
+	struct resource *res;
+	unsigned int irq;
 	int ret;
 
-	info = kzalloc(sizeof(struct ep93xx_ac97_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
-	dev_set_drvdata(&pdev->dev, info);
-
-	mutex_init(&info->lock);
-	init_completion(&info->done);
-	info->dev = &pdev->dev;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
 
-	info->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!info->mem) {
-		ret = -ENXIO;
-		goto fail_free_info;
-	}
+	info->regs = devm_request_and_ioremap(&pdev->dev, res);
+	if (!info->regs)
+		return -ENXIO;
 
-	info->irq = platform_get_irq(pdev, 0);
-	if (!info->irq) {
-		ret = -ENXIO;
-		goto fail_free_info;
-	}
+	irq = platform_get_irq(pdev, 0);
+	if (!irq)
+		return -ENODEV;
 
-	if (!request_mem_region(info->mem->start, resource_size(info->mem),
-				pdev->name)) {
-		ret = -EBUSY;
-		goto fail_free_info;
-	}
+	ret = devm_request_irq(&pdev->dev, irq, ep93xx_ac97_interrupt,
+			       IRQF_TRIGGER_HIGH, pdev->name, info);
+	if (ret)
+		goto fail;
 
-	info->regs = ioremap(info->mem->start, resource_size(info->mem));
-	if (!info->regs) {
-		ret = -ENOMEM;
-		goto fail_release_mem;
-	}
+	dev_set_drvdata(&pdev->dev, info);
 
-	ret = request_irq(info->irq, ep93xx_ac97_interrupt, IRQF_TRIGGER_HIGH,
-			  pdev->name, info);
-	if (ret)
-		goto fail_unmap_mem;
+	mutex_init(&info->lock);
+	init_completion(&info->done);
+	info->dev = &pdev->dev;
 
 	ep93xx_ac97_info = info;
 	platform_set_drvdata(pdev, info);
 
 	ret = snd_soc_register_dai(&pdev->dev, &ep93xx_ac97_dai);
 	if (ret)
-		goto fail_free_irq;
+		goto fail;
 
 	return 0;
 
-fail_free_irq:
+fail:
 	platform_set_drvdata(pdev, NULL);
-	free_irq(info->irq, info);
-fail_unmap_mem:
-	iounmap(info->regs);
-fail_release_mem:
-	release_mem_region(info->mem->start, resource_size(info->mem));
-fail_free_info:
-	kfree(info);
-
+	ep93xx_ac97_info = NULL;
+	dev_set_drvdata(&pdev->dev, NULL);
 	return ret;
 }
 
@@ -431,11 +411,9 @@ static int __devexit ep93xx_ac97_remove(struct platform_device *pdev)
 	/* disable the AC97 controller */
 	ep93xx_ac97_write_reg(info, AC97GCR, 0);
 
-	free_irq(info->irq, info);
-	iounmap(info->regs);
-	release_mem_region(info->mem->start, resource_size(info->mem));
 	platform_set_drvdata(pdev, NULL);
-	kfree(info);
+	ep93xx_ac97_info = NULL;
+	dev_set_drvdata(&pdev->dev, NULL);
 
 	return 0;
 }
