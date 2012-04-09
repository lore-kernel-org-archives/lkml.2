Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2DIMgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:36:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8437 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab2DIMgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:36:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 09 Apr 2012 05:36:51 -0700
From: Preetham Chandru <pchandru@nvidia.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Andrew Chew <achew@nvidia.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Preetham Chandru <pchandru@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] staging: iio: ak8975: Remove i2c client data corruption
Date: Mon,  9 Apr 2012 18:05:01 +0530
Message-Id: <1333974901-24282-1-git-send-email-pchandru@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c client data set is of type struct indio_dev pointer and hence the
pointer returned from i2c_get_clientdata() should be assigned to
an object of type struct indio_dev and not to an object of type
struct ak8975_data.

Also in ak8975_probe() client data should be set first
before calling ak8975_setup() as it references the client data.

Signed-off-by: Preetham Chandru R <pchandru@nvidia.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/staging/iio/magnetometer/ak8975.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
index d5ddac3..ebc2d08 100644
--- a/drivers/staging/iio/magnetometer/ak8975.c
+++ b/drivers/staging/iio/magnetometer/ak8975.c
@@ -108,7 +108,8 @@ static const int ak8975_index_to_reg[] = {
 static int ak8975_write_data(struct i2c_client *client,
 			     u8 reg, u8 val, u8 mask, u8 shift)
 {
-	struct ak8975_data *data = i2c_get_clientdata(client);
+	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+	struct ak8975_data *data = iio_priv(indio_dev);
 	u8 regval;
 	int ret;
 
@@ -159,7 +160,8 @@ static int ak8975_read_data(struct i2c_client *client,
  */
 static int ak8975_setup(struct i2c_client *client)
 {
-	struct ak8975_data *data = i2c_get_clientdata(client);
+	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+	struct ak8975_data *data = iio_priv(indio_dev);
 	u8 device_id;
 	int ret;
 
@@ -509,6 +511,7 @@ static int ak8975_probe(struct i2c_client *client,
 		goto exit_gpio;
 	}
 	data = iio_priv(indio_dev);
+	i2c_set_clientdata(client, indio_dev);
 	/* Perform some basic start-of-day setup of the device. */
 	err = ak8975_setup(client);
 	if (err < 0) {
@@ -516,7 +519,6 @@ static int ak8975_probe(struct i2c_client *client,
 		goto exit_free_iio;
 	}
 
-	i2c_set_clientdata(client, indio_dev);
 	data->client = client;
 	mutex_init(&data->lock);
 	data->eoc_irq = client->irq;
-- 
1.7.0.4

