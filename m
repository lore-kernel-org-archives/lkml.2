Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2IRE4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 00:56:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56723 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab2IRE4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 00:56:14 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] iio: inkern: clean up error return code
Thread-Topic: [PATCH 2/2] iio: inkern: clean up error return code
Thread-Index: Ac2VWejG8IffaxpIQhW8lMT5j2DT7g==
Date: Tue, 18 Sep 2012 04:56:06 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF539F@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 When the IIO consumer tries to get specific IIO channel,
 few error cases can be happened.
 (a) Memory allocation failure
 (b) No matched ADC channel error
 (c) Invalid input arguments
 This patch enables cleaning up error handling in case of (a) and (b).

 In error handling code,
 (a): the reference count of the IIO device should be decreased.
 (b): the allocated memory should be freed with restoring the reference count.
 Therefore iio_deivce_put() is called in both cases.
 This can be handled in the last error statement.

 Additionally, integer variable is used for stating each error case explicitly.
 Then, the error returns as ERR_PTR() with this value.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/iio/inkern.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index aff034b..656d4d4 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -111,6 +111,7 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
 {
 	struct iio_map_internal *c_i = NULL, *c = NULL;
 	struct iio_channel *channel;
+	int err;
 
 	if (name == NULL && channel_name == NULL)
 		return ERR_PTR(-ENODEV);
@@ -131,8 +132,10 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
 		return ERR_PTR(-ENODEV);
 
 	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
-	if (channel == NULL)
+	if (channel == NULL) {
+		err = -ENOMEM;
 		goto error_no_mem;
+	}
 
 	channel->indio_dev = c->indio_dev;
 
@@ -141,19 +144,19 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
 			iio_chan_spec_from_name(channel->indio_dev,
 						c->map->adc_channel_label);
 
-		if (channel->channel == NULL)
+		if (channel->channel == NULL) {
+			err = -EINVAL;
 			goto error_no_chan;
+		}
 	}
 
 	return channel;
 
 error_no_chan:
-	iio_device_put(c->indio_dev);
 	kfree(channel);
-	return ERR_PTR(-EINVAL);
 error_no_mem:
 	iio_device_put(c->indio_dev);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(iio_channel_get);
 
-- 
1.7.9.5


Best Regards,
Milo


