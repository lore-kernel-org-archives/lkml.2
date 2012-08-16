Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab2HPHje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:39:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42206 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab2HPHjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:39:33 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: [PATCH 1/3] iio: add iio_read_channel_offset() consumer api
Thread-Topic: [PATCH 1/3] iio: add iio_read_channel_offset() consumer api
Thread-Index: Ac17gj27zkdhHbJaQSqzTiFPSN7+ZQ==
Date: Thu, 16 Aug 2012 07:39:20 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EEFD6E@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.52]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the iio consumer to get the offset of the channel.
The value of offset can be used when calculating the result such
as 'result = raw * scale + offset'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/iio/inkern.c         |   21 +++++++++++++++++++++
 include/linux/iio/consumer.h |    9 +++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index b5afc2f..bd09245 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -269,6 +269,27 @@ err_unlock:
 }
 EXPORT_SYMBOL_GPL(iio_read_channel_scale);
 
+int iio_read_channel_offset(struct iio_channel *chan, int *val)
+{
+	int val2, ret;
+
+	mutex_lock(&chan->indio_dev->info_exist_lock);
+	if (chan->indio_dev->info == NULL) {
+		ret = -ENODEV;
+		goto err_unlock;
+	}
+
+	ret = chan->indio_dev->info->read_raw(chan->indio_dev,
+					      chan->channel,
+					      val, &val2,
+					      IIO_CHAN_INFO_OFFSET);
+err_unlock:
+	mutex_unlock(&chan->indio_dev->info_exist_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iio_read_channel_offset);
+
 int iio_get_channel_type(struct iio_channel *chan, enum iio_chan_type *type)
 {
 	int ret = 0;
diff --git a/include/linux/iio/consumer.h b/include/linux/iio/consumer.h
index e2657e6..d9d69fa 100644
--- a/include/linux/iio/consumer.h
+++ b/include/linux/iio/consumer.h
@@ -93,4 +93,13 @@ int iio_get_channel_type(struct iio_channel *channel,
 int iio_read_channel_scale(struct iio_channel *chan, int *val,
 			   int *val2);
 
+/**
+ * iio_read_channel_offset() - read offset from a given channel
+ * @channel:		The channel being queried.
+ * @val:		Offset Value read back.
+ *
+ * Note offset can be used in the consumer when calculating the result
+ * such as 'result = raw * scale + offset'.
+ */
+int iio_read_channel_offset(struct iio_channel *chan, int *val);
 #endif
-- 
1.7.2.5


Best Regards,
Milo


