Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab2IJIDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:03:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45913 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab2IJICz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:02:55 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] iio: inkern: add error case in iio_channel_get()
Thread-Topic: [PATCH 2/2] iio: inkern: add error case in iio_channel_get()
Thread-Index: Ac2PKqkZZFI0lKCnQcyWC+Ovo9lkGw==
Date: Mon, 10 Sep 2012 08:02:45 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF45EB@DQHE02.ent.ti.com>
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

 The datasheet name is defined in the IIO driver.
 On the other hand, the adc_channel_label is configured in
 the platform machine side.
 If the datasheet name is not matched with any adc_channel_label,
 the iio_channel_get() should be returned as error for preventing
 using invalid IIO channel data.

 Moreover, this patch detects NULL pointer dereference problem at early time.
 In general, the IIO driver just accesses to any member of the iio_chan_spec
 in own xxx_read_raw() function.
 If the iio_chan_spec is invalid pointer, NULL dereference problem may occur
 such like 'iio_chan_spec->channel' or 'iio_chan_spec->type'.
 If the iio_channel_get() gets failed in the IIO consumer,
 then no read_raw() operation proceeds.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/iio/inkern.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 1faa240..a5caf6b 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -136,11 +136,15 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
 
 	channel->indio_dev = c->indio_dev;
 
-	if (c->map->adc_channel_label)
+	if (c->map->adc_channel_label) {
 		channel->channel =
 			iio_chan_spec_from_name(channel->indio_dev,
 						c->map->adc_channel_label);
 
+		if (channel->channel == NULL)
+			return ERR_PTR(-ENODEV);
+	}
+
 	return channel;
 }
 EXPORT_SYMBOL_GPL(iio_channel_get);
-- 
1.7.9.5


Best Regards,
Milo


