Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab2IQIo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:44:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46773 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab2IQIo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:44:56 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] iio: inkern: add error case in iio_channel_get()
Thread-Topic: [PATCH 1/2] iio: inkern: add error case in iio_channel_get()
Thread-Index: Ac2UsK0y+tGYJrEWTmW8aT3jaNHw1Q==
Date: Mon, 17 Sep 2012 08:44:42 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF509D@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The datasheet name is defined in the IIO driver.
 On the other hand, the adc_channel_label is configured in
 the platform side.
 If the datasheet name is not matched with any adc_channel_label,
 the iio_channel_get() should be returned as error for preventing
 invalid channel data access.

 This can be handled either way.
 (a) checking null data when using it : in the xxx_read_raw()
 or
 (b) error returns when the channel is requested : this patch

 The IIO consumer can't use the channel with invalid channel spec.
 Therefore case (b) is more reasonable.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/iio/inkern.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 1faa240..13748c0 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -136,12 +136,21 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
 
 	channel->indio_dev = c->indio_dev;
 
-	if (c->map->adc_channel_label)
+	if (c->map->adc_channel_label) {
 		channel->channel =
 			iio_chan_spec_from_name(channel->indio_dev,
 						c->map->adc_channel_label);
 
+		if (channel->channel == NULL)
+			goto error_no_chan;
+	}
+
 	return channel;
+
+error_no_chan:
+	iio_device_put(c->indio_dev);
+	kfree(channel);
+	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(iio_channel_get);
 
-- 
1.7.9.5


Best Regards,
Milo

