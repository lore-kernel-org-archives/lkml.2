Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0HQMlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:41:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54238 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab0HQMlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=CkKFL4X9AZ84zVw4ptlt8yaFeLpBZrIj+pzYsyrRbsu/93g4oVe1mW1ksnNoSuZA7T
         EHc5EetFMFe0vMWprVyJaAadzfOtYC3SU4cc0pp+xbyTk2keaZDtMiSkwAFRf2QyQfnh
         tZv/Od+Pb4jp1qrGJBXMhNl9EtrLCgrN8H6aE=
Subject: [PATCH v2] hwmon: (ads7871) Fix ads7871_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>, Paul Thomas <pthomas8589@gmail.com>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 20:41:24 +0800
Message-ID: <1282048884.2626.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves hwmon_device_register() to the end of ads7871_probe().
So we can make sure the device exists and is properly initialized
before the device is exposed to user-space.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/ads7871.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/ads7871.c b/drivers/hwmon/ads7871.c
index b300a20..45f5829 100644
--- a/drivers/hwmon/ads7871.c
+++ b/drivers/hwmon/ads7871.c
@@ -176,12 +176,6 @@ static int __devinit ads7871_probe(struct spi_device *spi)
 	if (status < 0)
 		goto error_free;
 
-	pdata->hwmon_dev = hwmon_device_register(&spi->dev);
-	if (IS_ERR(pdata->hwmon_dev)) {
-		err = PTR_ERR(pdata->hwmon_dev);
-		goto error_remove;
-	}
-
 	spi_set_drvdata(spi, pdata);
 
 	/* Configure the SPI bus */
@@ -204,6 +198,12 @@ static int __devinit ads7871_probe(struct spi_device *spi)
 		goto error_remove;
 	}
 
+	pdata->hwmon_dev = hwmon_device_register(&spi->dev);
+	if (IS_ERR(pdata->hwmon_dev)) {
+		err = PTR_ERR(pdata->hwmon_dev);
+		goto error_remove;
+	}
+
 	return 0;
 
 error_remove:
-- 
1.7.0.4



