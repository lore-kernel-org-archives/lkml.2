Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab1CCIWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:22:40 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33553 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab1CCIWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:22:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=sp1DcUaiqjRw+Ro4dZZcptr3he9ck8+wcIXNqhAWU7f8yBoaFz3Cz41pviDdvyXLFC
         sJAv25cdCWj1E1jA8VWELFMPqdKgRSkrmLCb5CrKVZC28dXjOwn5PZkpDGuvDA2AZGCY
         nKyrJdOe8dVBgg5Jc57O3Pep8L0jqHvWEiJew=
Subject: [PATCH] backlight: ltv350qv: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 16:22:03 +0800
Message-ID: <1299140523.3846.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/ltv350qv.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
index 8010aae..dd0e84a 100644
--- a/drivers/video/backlight/ltv350qv.c
+++ b/drivers/video/backlight/ltv350qv.c
@@ -239,11 +239,15 @@ static int __devinit ltv350qv_probe(struct spi_device *spi)
 	lcd->spi = spi;
 	lcd->power = FB_BLANK_POWERDOWN;
 	lcd->buffer = kzalloc(8, GFP_KERNEL);
+	if (!lcd->buffer) {
+		ret = -ENOMEM;
+		goto out_free_lcd;
+	}
 
 	ld = lcd_device_register("ltv350qv", &spi->dev, lcd, &ltv_ops);
 	if (IS_ERR(ld)) {
 		ret = PTR_ERR(ld);
-		goto out_free_lcd;
+		goto out_free_buffer;
 	}
 	lcd->ld = ld;
 
@@ -257,6 +261,8 @@ static int __devinit ltv350qv_probe(struct spi_device *spi)
 
 out_unregister:
 	lcd_device_unregister(ld);
+out_free_buffer:
+	kfree(lcd->buffer);
 out_free_lcd:
 	kfree(lcd);
 	return ret;
@@ -268,6 +274,7 @@ static int __devexit ltv350qv_remove(struct spi_device *spi)
 
 	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->ld);
+	kfree(lcd->buffer);
 	kfree(lcd);
 
 	return 0;
-- 
1.7.1



