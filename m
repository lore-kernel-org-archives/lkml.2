Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1GETu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:50:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33045 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab1GETuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:50:03 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 5/5] MFD: twl6040: Remove wrapper for threaded irq request
Date: Tue, 5 Jul 2011 22:49:36 +0300
Message-ID: <1309895376-17446-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
References: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the twl6040_request_irq/free_irq inline functions,
and use direct calls instead in the core driver to
register the threaded irq.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c  |   10 +++++-----
 include/linux/mfd/twl6040.h |   22 ----------------------
 2 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index f71bb14..6843977 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -502,9 +502,9 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 	if (ret)
 		goto gpio2_err;
 
-	ret = twl6040_request_irq(twl6040, TWL6040_IRQ_READY,
-					twl6040_naudint_handler, 0,
-					"twl6040_irq_ready", twl6040);
+	ret = request_threaded_irq(twl6040->irq_base + TWL6040_IRQ_READY,
+				   NULL, twl6040_naudint_handler, 0,
+				   "twl6040_irq_ready", twl6040);
 	if (ret) {
 		dev_err(twl6040->dev, "READY IRQ request failed: %d\n",
 			ret);
@@ -557,7 +557,7 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 	return 0;
 
 mfd_err:
-	twl6040_free_irq(twl6040, TWL6040_IRQ_READY, twl6040);
+	free_irq(twl6040->irq_base + TWL6040_IRQ_READY, twl6040);
 irq_err:
 	twl6040_irq_exit(twl6040);
 gpio2_err:
@@ -580,7 +580,7 @@ static int __devexit twl6040_remove(struct platform_device *pdev)
 	if (gpio_is_valid(twl6040->audpwron))
 		gpio_free(twl6040->audpwron);
 
-	twl6040_free_irq(twl6040, TWL6040_IRQ_READY, twl6040);
+	free_irq(twl6040->irq_base + TWL6040_IRQ_READY, twl6040);
 	twl6040_irq_exit(twl6040);
 
 	mfd_remove_devices(&pdev->dev);
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index c3c1de5..df890a2 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -215,28 +215,6 @@ struct twl6040 {
 	u8 irq_masks_cache;
 };
 
-static inline int twl6040_request_irq(struct twl6040 *twl6040, int irq,
-				      irq_handler_t handler,
-				      unsigned long irqflags,
-				      const char *name,
-				      void *data)
-{
-	if (!twl6040->irq_base)
-		return -EINVAL;
-
-	return request_threaded_irq(twl6040->irq_base + irq, NULL, handler,
-				    irqflags, name, data);
-}
-
-static inline void twl6040_free_irq(struct twl6040 *twl6040, int irq,
-				    void *data)
-{
-	if (!twl6040->irq_base)
-		return;
-
-	free_irq(twl6040->irq_base + irq, data);
-}
-
 int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg);
 int twl6040_reg_write(struct twl6040 *twl6040, unsigned int reg,
 		      u8 val);
-- 
1.7.6

