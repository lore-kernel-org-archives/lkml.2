Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab0KBIaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 04:30:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64331 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0KBIaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 04:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=GJj3ZbAGReIRGaVYhJgiIpks/LTFjagymkY4kUObPUnrmmpWE1Z+UCsM+r3DyIspKQ
         H40YlZJDKj9gpV5x3gxEntcMU+sdP6DLPOHlvMgeOp2aawBX9LKOiCnKkloESgqkMKUA
         Ll2iPXo+jlgoVuuQ9v6Z/byvx7DwJRL34RGyw=
Subject: [PATCH] rtc: rtc-max6902 - set driver data in max6902_probe()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 02 Nov 2010 16:33:27 +0800
Message-Id: <1288686807.19912.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation does not set driver data in max6902_probe(),
thus calling platform_get_drvdata(spi) in max6902_remove() returns NULL.

Since this is a spi driver, use spi_set_drvdata/spi_get_drvdata to
set/get driver data.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/rtc/rtc-max6902.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-max6902.c b/drivers/rtc/rtc-max6902.c
index 657403e..23faecb 100644
--- a/drivers/rtc/rtc-max6902.c
+++ b/drivers/rtc/rtc-max6902.c
@@ -138,15 +138,17 @@ static int __devinit max6902_probe(struct spi_device *spi)
 				&spi->dev, &max6902_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
+	spi_set_drvdata(spi, rtc);
 
 	return 0;
 }
 
 static int __devexit max6902_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = platform_get_drvdata(spi);
+	struct rtc_device *rtc = spi_get_drvdata(spi);
 
 	rtc_device_unregister(rtc);
+	spi_set_drvdata(spi, NULL);
 	return 0;
 }
 
-- 
1.7.2



