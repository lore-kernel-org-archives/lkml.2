Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab1ISV6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:58:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50224 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab1ISV5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:57:49 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Chew <achew@nvidia.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/3] staging:iio:magnetometer:ak8975: Don't assume 0 is an invalid GPIO
Date: Mon, 19 Sep 2011 15:57:31 -0600
Message-Id: <1316469452-23575-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316469452-23575-1-git-send-email-swarren@nvidia.com>
References: <1316469452-23575-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_is_valid() is the defined mechanism to determine whether a GPIO is
valid. Use this instead of assuming that 0 is an invalid GPIO.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Andrew Chew <achew@nvidia.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/magnetometer/ak8975.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
index 6d17ae5..930ddef 100644
--- a/drivers/staging/iio/magnetometer/ak8975.c
+++ b/drivers/staging/iio/magnetometer/ak8975.c
@@ -373,7 +373,7 @@ static int ak8975_read_axis(struct iio_dev *indio_dev, int index, int *val)
 	}
 
 	/* Wait for the conversion to complete. */
-	if (data->eoc_gpio)
+	if (gpio_is_valid(data->eoc_gpio))
 		ret = wait_conversion_complete_gpio(data);
 	else
 		ret = wait_conversion_complete_polled(data);
@@ -484,7 +484,7 @@ static int ak8975_probe(struct i2c_client *client,
 
 	/* We may not have a GPIO based IRQ to scan, that is fine, we will
 	   poll if so */
-	if (eoc_gpio > 0) {
+	if (gpio_is_valid(eoc_gpio)) {
 		err = gpio_request(eoc_gpio, "ak_8975");
 		if (err < 0) {
 			dev_err(&client->dev,
@@ -500,8 +500,7 @@ static int ak8975_probe(struct i2c_client *client,
 						eoc_gpio, err);
 			goto exit_gpio;
 		}
-	} else
-		eoc_gpio = 0;	/* No GPIO available */
+	}
 
 	/* Register with IIO */
 	indio_dev = iio_allocate_device(sizeof(*data));
@@ -537,7 +536,7 @@ static int ak8975_probe(struct i2c_client *client,
 exit_free_iio:
 	iio_free_device(indio_dev);
 exit_gpio:
-	if (eoc_gpio)
+	if (gpio_is_valid(eoc_gpio))
 		gpio_free(eoc_gpio);
 exit:
 	return err;
@@ -552,7 +551,7 @@ static int ak8975_remove(struct i2c_client *client)
 	iio_device_unregister(indio_dev);
 	iio_free_device(indio_dev);
 
-	if (eoc_gpio)
+	if (gpio_is_valid(eoc_gpio))
 		gpio_free(eoc_gpio);
 
 	return 0;
-- 
1.7.0.4

