Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1ACJfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 04:35:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57423 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1ACJfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 04:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=bPMaWziuxjmy1momnWts8jEySgi9Dzs3sDKRnR1td9N30fr2aljnkyQFSUDFpmlEvd
         XT2IbzeNYi81YUKRny5RVXF7HlLd2zS4ed/TzD50OSQa/RZtMsqA3P1euxza4pZMu6y4
         rzczOkaSfIaKRXf3L1DO9tbNjSapW47pxjOuU=
Subject: [PATCH] mfd: Move error handling to the end of mc13xxx_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain
Date: Mon, 03 Jan 2011 17:36:59 +0800
Message-Id: <1294047419.25173.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To improve readability, move error handling to the end of mc13xxx_probe.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/mc13xxx-core.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index b9fcaf0..18c29fc 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -732,28 +732,21 @@ static int mc13xxx_probe(struct spi_device *spi)
 
 	ret = mc13xxx_identify(mc13xxx, &id);
 	if (ret || id == MC13XXX_ID_INVALID)
-		goto err_revision;
+		goto err;
 
 	/* mask all irqs */
 	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK0, 0x00ffffff);
 	if (ret)
-		goto err_mask;
+		goto err;
 
 	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK1, 0x00ffffff);
 	if (ret)
-		goto err_mask;
+		goto err;
 
 	ret = request_threaded_irq(spi->irq, NULL, mc13xxx_irq_thread,
 			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13xxx", mc13xxx);
-
-	if (ret) {
-err_mask:
-err_revision:
-		mc13xxx_unlock(mc13xxx);
-		dev_set_drvdata(&spi->dev, NULL);
-		kfree(mc13xxx);
-		return ret;
-	}
+	if (ret)
+		goto err;
 
 	mc13xxx_unlock(mc13xxx);
 
@@ -785,6 +778,11 @@ err_revision:
 	}
 
 	return 0;
+err:
+	mc13xxx_unlock(mc13xxx);
+	dev_set_drvdata(&spi->dev, NULL);
+	kfree(mc13xxx);
+	return ret;
 }
 
 static int __devexit mc13xxx_remove(struct spi_device *spi)
-- 
1.7.2



