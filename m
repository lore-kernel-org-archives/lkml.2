Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2FMLYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:24:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19958 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2FMLYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:24:38 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-fc-4fd87875e803
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Marek Vasut'" <marek.vasut@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Axel Lin'" <axel.lin@gmail.com>
Subject: [PATCH 5/7] backlight: lms283gf05: use devm_gpio_request()
Date: Wed, 13 Jun 2012 20:24:36 +0900
Message-id: <000601cd4957$1d7b88b0$58729a10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JVx1gex8vy5dkQgWvEprtjUeVaQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd3Sihv+BoemsFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Ma21uBTMEKr5fv87WwPiPp4uRg0NCwERi3d3gLkZOIFNM4sK9
	9WxdjFwcQgKLGCX2L7kI5cxmkmhdP4kJpIpNQE3iy5fD7CC2iECERPOMWcwgRcwCMxgljrVc
	ZgZJCAs4S+zr/cQKYrMIqEpMmfUDrJlXwFbi5rEZULagxI/J91hAbGYBLYn1O48zQdjyEpvX
	vGWGuE5d4tFfXYhdehJfFr1ghCgRkdj34h3jBEaBWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJERyWz6R3MK5qsDjEKMDBqMTDy1F6w1+INbGsuDL3EKMEB7OS
	CO+zbKAQb0piZVVqUX58UWlOavEhRmkOFiVx3ibrC/5CAumJJanZqakFqUUwWSYOTqkGRquc
	dO49S6qP/Ms5Hvf5i+ab/Ol6Ot+3tT9Si+SeNYU19J3w5WzTtesEFddzpdsdXbUqUsExNPXv
	MQtGkaqk0+esOwKe8v9c95vtzvUpDPcjs1N2mAU0n1l6bWF6SUlFWcPCgOILUcoyu241zKyw
	XHPHe0LQy/n2BRPtlK9ISE7yemHRHhe8VYmlOCPRUIu5qDgRAKusXdtHAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_gpio_request of these functions.

Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lms283gf05.c |   24 ++++++------------------
 1 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/video/backlight/lms283gf05.c b/drivers/video/backlight/lms283gf05.c
index a9f2c36..ea43f22 100644
--- a/drivers/video/backlight/lms283gf05.c
+++ b/drivers/video/backlight/lms283gf05.c
@@ -158,29 +158,27 @@ static int __devinit lms283gf05_probe(struct spi_device *spi)
 	int ret = 0;
 
 	if (pdata != NULL) {
-		ret = gpio_request(pdata->reset_gpio, "LMS285GF05 RESET");
+		ret = devm_gpio_request(&spi->dev, pdata->reset_gpio,
+					"LMS285GF05 RESET");
 		if (ret)
 			return ret;
 
 		ret = gpio_direction_output(pdata->reset_gpio,
 						!pdata->reset_inverted);
 		if (ret)
-			goto err;
+			return ret;
 	}
 
 	st = devm_kzalloc(&spi->dev, sizeof(struct lms283gf05_state),
 				GFP_KERNEL);
 	if (st == NULL) {
 		dev_err(&spi->dev, "No memory for device state\n");
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	ld = lcd_device_register("lms283gf05", &spi->dev, st, &lms_ops);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto err;
-	}
+	if (IS_ERR(ld))
+		return PTR_ERR(ld);
 
 	st->spi = spi;
 	st->ld = ld;
@@ -193,24 +191,14 @@ static int __devinit lms283gf05_probe(struct spi_device *spi)
 	lms283gf05_toggle(spi, disp_initseq, ARRAY_SIZE(disp_initseq));
 
 	return 0;
-
-err:
-	if (pdata != NULL)
-		gpio_free(pdata->reset_gpio);
-
-	return ret;
 }
 
 static int __devexit lms283gf05_remove(struct spi_device *spi)
 {
 	struct lms283gf05_state *st = dev_get_drvdata(&spi->dev);
-	struct lms283gf05_pdata *pdata = st->spi->dev.platform_data;
 
 	lcd_device_unregister(st->ld);
 
-	if (pdata != NULL)
-		gpio_free(pdata->reset_gpio);
-
 	return 0;
 }
 
-- 
1.7.1


