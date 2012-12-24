Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2LXGZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 01:25:08 -0500
Received: from mail.active-venture.com ([67.228.131.205]:51114 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2LXGZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 01:25:06 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Mon, 24 Dec 2012 00:25:01 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] iio: (max1363) Fix probe error path
Date: Sun, 23 Dec 2012 22:24:58 -0800
Message-Id: <1356330298-11443-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instantiating the driver with no available regulator results in:

[39711.686393] i2c i2c-7: new_device: Instantiated device max1139 at 0x35
[39711.688687] BUG: unable to handle kernel paging request at fffffffffffffe13
[39711.688734] IP: [<ffffffff813e835b>] regulator_disable+0x1b/0x80
[39711.688788] PGD 1c0e067 PUD 1c0f067 PMD 0
[39711.688835] Oops: 0000 [#1] SMP

Caused by bad probe error path. Fix it.

Driver should also not attempt to free the interrupt in its error path if
none was allocated. Fix that problem as well.

Finally, testing if the regulator was allocated is not necessary in the
remove function, since the probe function bails out if this is the case.
Remove that check.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/iio/adc/max1363.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/max1363.c b/drivers/iio/adc/max1363.c
index 1e84b5b..31f3485 100644
--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -1605,19 +1605,20 @@ static int __devinit max1363_probe(struct i2c_client *client,
 
 	return 0;
 error_free_irq:
-	free_irq(st->client->irq, indio_dev);
+	if (client->irq)
+		free_irq(st->client->irq, indio_dev);
 error_uninit_buffer:
 	iio_buffer_unregister(indio_dev);
 error_cleanup_buffer:
 	max1363_buffer_cleanup(indio_dev);
 error_free_available_scan_masks:
 	kfree(indio_dev->available_scan_masks);
-error_unregister_map:
-	iio_map_array_unregister(indio_dev, client->dev.platform_data);
 error_disable_reg:
 	regulator_disable(st->reg);
 error_put_reg:
 	regulator_put(st->reg);
+error_unregister_map:
+	iio_map_array_unregister(indio_dev, client->dev.platform_data);
 error_free_device:
 	iio_device_free(indio_dev);
 error_out:
@@ -1635,10 +1636,8 @@ static int __devexit max1363_remove(struct i2c_client *client)
 	iio_buffer_unregister(indio_dev);
 	max1363_buffer_cleanup(indio_dev);
 	kfree(indio_dev->available_scan_masks);
-	if (!IS_ERR(st->reg)) {
-		regulator_disable(st->reg);
-		regulator_put(st->reg);
-	}
+	regulator_disable(st->reg);
+	regulator_put(st->reg);
 	iio_map_array_unregister(indio_dev, client->dev.platform_data);
 	iio_device_free(indio_dev);
 
-- 
1.7.9.7

