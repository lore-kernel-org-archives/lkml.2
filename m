Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab2HZQDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:03:15 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:56799
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637Ab2HZQBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:01:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="153852294"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: kernel-janitors@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/13] drivers/iio/adc/at91_adc.c: use clk_prepare_enable and clk_disable_unprepare
Date: Sun, 26 Aug 2012 18:00:58 +0200
Message-Id: <1345996865-32082-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
clk_enable, and clk_disable and clk_unprepare.  They make the code more
concise, and ensure that clk_unprepare is called when clk_enable fails.

A simplified version of the semantic patch that introduces calls to these
functions is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@

- clk_prepare(e);
- clk_enable(e);
+ clk_prepare_enable(e);

@@
expression e;
@@

- clk_disable(e);
- clk_unprepare(e);
+ clk_disable_unprepare(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/iio/adc/at91_adc.c |   33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index 98c96f9..c1e4690 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -589,18 +589,13 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
 		goto error_free_irq;
 	}
 
-	ret = clk_prepare(st->clk);
+	ret = clk_prepare_enable(st->clk);
 	if (ret) {
-		dev_err(&pdev->dev, "Could not prepare the clock.\n");
+		dev_err(&pdev->dev,
+			"Could not prepare or enable the clock.\n");
 		goto error_free_irq;
 	}
 
-	ret = clk_enable(st->clk);
-	if (ret) {
-		dev_err(&pdev->dev, "Could not enable the clock.\n");
-		goto error_unprepare_clk;
-	}
-
 	st->adc_clk = devm_clk_get(&pdev->dev, "adc_op_clk");
 	if (IS_ERR(st->adc_clk)) {
 		dev_err(&pdev->dev, "Failed to get the ADC clock.\n");
@@ -608,18 +603,13 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
 		goto error_disable_clk;
 	}
 
-	ret = clk_prepare(st->adc_clk);
+	ret = clk_prepare_enable(st->adc_clk);
 	if (ret) {
-		dev_err(&pdev->dev, "Could not prepare the ADC clock.\n");
+		dev_err(&pdev->dev,
+			"Could not prepare or enable the ADC clock.\n");
 		goto error_disable_clk;
 	}
 
-	ret = clk_enable(st->adc_clk);
-	if (ret) {
-		dev_err(&pdev->dev, "Could not enable the ADC clock.\n");
-		goto error_unprepare_adc_clk;
-	}
-
 	/*
 	 * Prescaler rate computation using the formula from the Atmel's
 	 * datasheet : ADC Clock = MCK / ((Prescaler + 1) * 2), ADC Clock being
@@ -681,13 +671,9 @@ error_remove_triggers:
 error_unregister_buffer:
 	at91_adc_buffer_remove(idev);
 error_disable_adc_clk:
-	clk_disable(st->adc_clk);
-error_unprepare_adc_clk:
-	clk_unprepare(st->adc_clk);
+	clk_disable_unprepare(st->adc_clk);
 error_disable_clk:
-	clk_disable(st->clk);
-error_unprepare_clk:
-	clk_unprepare(st->clk);
+	clk_disable_unprepare(st->clk);
 error_free_irq:
 	free_irq(st->irq, idev);
 error_free_device:
@@ -705,8 +691,7 @@ static int __devexit at91_adc_remove(struct platform_device *pdev)
 	at91_adc_trigger_remove(idev);
 	at91_adc_buffer_remove(idev);
 	clk_disable_unprepare(st->adc_clk);
-	clk_disable(st->clk);
-	clk_unprepare(st->clk);
+	clk_disable_unprepare(st->clk);
 	free_irq(st->irq, idev);
 	iio_device_free(idev);
 

