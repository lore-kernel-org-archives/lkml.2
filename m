Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab2HZQEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:04:38 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:61272
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270Ab2HZQBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:01:14 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="153852286"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/13] drivers/staging/iio/adc/spear_adc.c: use clk_prepare_enable and clk_disable_unprepare
Date: Sun, 26 Aug 2012 18:00:53 +0200
Message-Id: <1345996865-32082-2-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/staging/iio/adc/spear_adc.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/iio/adc/spear_adc.c b/drivers/staging/iio/adc/spear_adc.c
index 675c427..0b83e2e 100644
--- a/drivers/staging/iio/adc/spear_adc.c
+++ b/drivers/staging/iio/adc/spear_adc.c
@@ -330,36 +330,30 @@ static int __devinit spear_adc_probe(struct platform_device *pdev)
 		goto errout3;
 	}
 
-	ret = clk_prepare(info->clk);
-	if (ret) {
-		dev_err(dev, "failed preparing clock\n");
-		goto errout4;
-	}
-
-	ret = clk_enable(info->clk);
+	ret = clk_prepare_enable(info->clk);
 	if (ret) {
 		dev_err(dev, "failed enabling clock\n");
-		goto errout5;
+		goto errout4;
 	}
 
 	irq = platform_get_irq(pdev, 0);
 	if ((irq < 0) || (irq >= NR_IRQS)) {
 		dev_err(dev, "failed getting interrupt resource\n");
 		ret = -EINVAL;
-		goto errout6;
+		goto errout5;
 	}
 
 	ret = devm_request_irq(dev, irq, spear_adc_isr, 0, MOD_NAME, info);
 	if (ret < 0) {
 		dev_err(dev, "failed requesting interrupt\n");
-		goto errout6;
+		goto errout5;
 	}
 
 	if (of_property_read_u32(np, "sampling-frequency",
 				 &info->sampling_freq)) {
 		dev_err(dev, "sampling-frequency missing in DT\n");
 		ret = -EINVAL;
-		goto errout6;
+		goto errout5;
 	}
 
 	/*
@@ -389,16 +383,14 @@ static int __devinit spear_adc_probe(struct platform_device *pdev)
 
 	ret = iio_device_register(iodev);
 	if (ret)
-		goto errout6;
+		goto errout5;
 
 	dev_info(dev, "SPEAR ADC driver loaded, IRQ %d\n", irq);
 
 	return 0;
 
-errout6:
-	clk_disable(info->clk);
 errout5:
-	clk_unprepare(info->clk);
+	clk_disable_unprepare(info->clk);
 errout4:
 	clk_put(info->clk);
 errout3:
@@ -416,8 +408,7 @@ static int __devexit spear_adc_remove(struct platform_device *pdev)
 
 	iio_device_unregister(iodev);
 	platform_set_drvdata(pdev, NULL);
-	clk_disable(info->clk);
-	clk_unprepare(info->clk);
+	clk_disable_unprepare(info->clk);
 	clk_put(info->clk);
 	iounmap(info->adc_base_spear6xx);
 	iio_device_free(iodev);

