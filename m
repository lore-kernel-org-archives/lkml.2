Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2IQIpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:45:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43264 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab2IQIo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:44:57 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] iio: inkern: put the IIO device when mem alloc gets
 failed
Thread-Topic: [PATCH 2/2] iio: inkern: put the IIO device when mem alloc
 gets failed
Thread-Index: Ac2UsLDnnWGaETPgRrGpn005azMcxw==
Date: Mon, 17 Sep 2012 08:44:47 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF50A5@DQHE02.ent.ti.com>
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

 The reference count of the IIO device is increased if the IIO map has
 matched consumer name.
 After then, it tries to allocate the iio_channel which is used by the consumer.
 If memory allocation gets failed, the reference count should be decreased.

 This patch enables restoring the reference count of the IIO device.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/iio/inkern.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 13748c0..aff034b 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -132,7 +132,7 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
 
 	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
 	if (channel == NULL)
-		return ERR_PTR(-ENOMEM);
+		goto error_no_mem;
 
 	channel->indio_dev = c->indio_dev;
 
@@ -151,6 +151,9 @@ error_no_chan:
 	iio_device_put(c->indio_dev);
 	kfree(channel);
 	return ERR_PTR(-EINVAL);
+error_no_mem:
+	iio_device_put(c->indio_dev);
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(iio_channel_get);
 
-- 
1.7.9.5


Best Regards,
Milo


