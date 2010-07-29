Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0G2I1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:27:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37019 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab0G2I1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Q8Ljl0ZSTBFgEk3k4wFn01JJEVs3Tazs4C+7olHiRqlHRqv0cBru2n51dluAUvtTao
         T0aFa1JcEUWfgSHHHtlF/NMvaSxGHIbPTzwwMd65twadMSsG43RtlKWVwbbsKR5WjwFc
         iY5slpuSrVSZi0eGVkk1C+zjZay5kbySZF/6s=
Subject: [PATCH 2/2] jz4740-adc: fix resource reclaim in jz4740_adc_probe
	error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain
Date: Thu, 29 Jul 2010 16:28:25 +0800
Message-Id: <1280392105.21676.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If mfd_add_devices() fail, we need to relese allocated resources.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against linux-next.
 drivers/mfd/jz4740-adc.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 2846d24..3ad492c 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -326,9 +326,15 @@ static int __devinit jz4740_adc_probe(struct platform_device *pdev)
 	writeb(0x00, adc->base + JZ_REG_ADC_ENABLE);
 	writeb(0xff, adc->base + JZ_REG_ADC_CTRL);
 
-	return mfd_add_devices(&pdev->dev, 0, jz4740_adc_cells,
+	ret = mfd_add_devices(&pdev->dev, 0, jz4740_adc_cells,
 		ARRAY_SIZE(jz4740_adc_cells), mem_base, adc->irq_base);
+	if (ret < 0)
+		goto err_clk_put;
 
+	return 0;
+
+err_clk_put:
+	clk_put(adc->clk);
 err_iounmap:
 	platform_set_drvdata(pdev, NULL);
 	iounmap(adc->base);
-- 
1.5.4.3



