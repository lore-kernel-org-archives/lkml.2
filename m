Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1K2VMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:12:05 -0500
Received: from www17.your-server.de ([213.133.104.17]:59277 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab1K2VMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:12:03 -0500
Subject: [PATCH] staging:iio: Use kcalloc instead of kzalloc to allocate
 array
From: Thomas Meyer <thomas@m3y3r.de>
To: gregkh@suse.de, linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.334.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c 2011-11-13 11:07:47.933826988 +0100
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c 2011-11-28 20:00:44.704446880 +0100
@@ -93,8 +93,7 @@ static int lis3l02dq_read_all(struct iio
 	struct spi_message msg;
 	int ret, i, j = 0;
 
-	xfers = kzalloc((buffer->scan_count) * 2
-			* sizeof(*xfers), GFP_KERNEL);
+	xfers = kcalloc((buffer->scan_count) * 2, sizeof(*xfers), GFP_KERNEL);
 	if (!xfers)
 		return -ENOMEM;
 
diff -u -p a/drivers/staging/iio/adc/ad7280a.c b/drivers/staging/iio/adc/ad7280a.c
--- a/drivers/staging/iio/adc/ad7280a.c 2011-11-13 11:07:47.940493760 +0100
+++ b/drivers/staging/iio/adc/ad7280a.c 2011-11-28 20:00:45.707793964 +0100
@@ -487,8 +487,8 @@ static int ad7280_channel_init(struct ad
 {
 	int dev, ch, cnt;
 
-	st->channels = kzalloc(sizeof(*st->channels) *
-				((st->slave_num + 1) * 12 + 2), GFP_KERNEL);
+	st->channels = kcalloc((st->slave_num + 1) * 12 + 2,
+			       sizeof(*st->channels), GFP_KERNEL);
 	if (st->channels == NULL)
 		return -ENOMEM;
 
@@ -682,7 +682,7 @@ static irqreturn_t ad7280_event_handler(
 	unsigned *channels;
 	int i, ret;
 
-	channels = kzalloc(sizeof(*channels) * st->scan_cnt, GFP_KERNEL);
+	channels = kcalloc(st->scan_cnt, sizeof(*channels), GFP_KERNEL);
 	if (channels == NULL)
 		return IRQ_HANDLED;
 
diff -u -p a/drivers/staging/iio/meter/ade7758_core.c b/drivers/staging/iio/meter/ade7758_core.c
--- a/drivers/staging/iio/meter/ade7758_core.c 2011-11-13 11:07:48.030495178 +0100
+++ b/drivers/staging/iio/meter/ade7758_core.c 2011-11-28 20:00:42.151078595 +0100
@@ -746,12 +746,12 @@ static int __devinit ade7758_probe(struc
 	spi_set_drvdata(spi, indio_dev);
 
 	/* Allocate the comms buffers */
-	st->rx = kzalloc(sizeof(*st->rx)*ADE7758_MAX_RX, GFP_KERNEL);
+	st->rx = kcalloc(ADE7758_MAX_RX, sizeof(*st->rx), GFP_KERNEL);
 	if (st->rx == NULL) {
 		ret = -ENOMEM;
 		goto error_free_dev;
 	}
-	st->tx = kzalloc(sizeof(*st->tx)*ADE7758_MAX_TX, GFP_KERNEL);
+	st->tx = kcalloc(ADE7758_MAX_TX, sizeof(*st->tx), GFP_KERNEL);
 	if (st->tx == NULL) {
 		ret = -ENOMEM;
 		goto error_free_rx;
diff -u -p a/drivers/staging/iio/iio_simple_dummy.c b/drivers/staging/iio/iio_simple_dummy.c
--- a/drivers/staging/iio/iio_simple_dummy.c 2011-11-13 11:07:48.023828408 +0100
+++ b/drivers/staging/iio/iio_simple_dummy.c 2011-11-28 20:00:47.407817284 +0100
@@ -514,7 +514,8 @@ static __init int iio_dummy_init(void)
 		return -EINVAL;
 	}
 	/* Fake a bus */
-	iio_dummy_devs = kzalloc(sizeof(*iio_dummy_devs)*instances, GFP_KERNEL);
+	iio_dummy_devs = kcalloc(instances, sizeof(*iio_dummy_devs),
+				 GFP_KERNEL);
 	/* Here we have no actual device so call probe */
 	for (i = 0; i < instances; i++) {
 		ret = iio_dummy_probe(i);
diff -u -p a/drivers/staging/iio/industrialio-buffer.c b/drivers/staging/iio/industrialio-buffer.c
--- a/drivers/staging/iio/industrialio-buffer.c 2011-11-13 11:07:48.023828408 +0100
+++ b/drivers/staging/iio/industrialio-buffer.c 2011-11-28 20:00:42.931089264 +0100
@@ -313,10 +313,9 @@ int iio_buffer_register(struct iio_dev *
 			attrcount += ret;
 		}
 		if (indio_dev->masklength && buffer->scan_mask == NULL) {
-			buffer->scan_mask
-				= kzalloc(sizeof(*buffer->scan_mask)*
-					  BITS_TO_LONGS(indio_dev->masklength),
-					  GFP_KERNEL);
+			buffer->scan_mask = kcalloc(BITS_TO_LONGS(indio_dev->masklength),
+						    sizeof(*buffer->scan_mask),
+						    GFP_KERNEL);
 			if (buffer->scan_mask == NULL) {
 				ret = -ENOMEM;
 				goto error_cleanup_dynamic;
@@ -326,10 +325,9 @@ int iio_buffer_register(struct iio_dev *
 
 	buffer->scan_el_group.name = iio_scan_elements_group_name;
 
-	buffer->scan_el_group.attrs
-		= kzalloc(sizeof(buffer->scan_el_group.attrs[0])*
-			  (attrcount + 1),
-			  GFP_KERNEL);
+	buffer->scan_el_group.attrs = kcalloc(attrcount + 1,
+					      sizeof(buffer->scan_el_group.attrs[0]),
+					      GFP_KERNEL);
 	if (buffer->scan_el_group.attrs == NULL) {
 		ret = -ENOMEM;
 		goto error_free_scan_mask;
diff -u -p a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
--- a/drivers/staging/iio/industrialio-core.c 2011-11-28 19:36:47.980114184 +0100
+++ b/drivers/staging/iio/industrialio-core.c 2011-11-28 20:00:41.047730176 +0100
@@ -665,10 +665,9 @@ static int iio_device_register_sysfs(str
 	if (indio_dev->name)
 		attrcount++;
 
-	indio_dev->chan_attr_group.attrs
-		= kzalloc(sizeof(indio_dev->chan_attr_group.attrs[0])*
-			  (attrcount + 1),
-			  GFP_KERNEL);
+	indio_dev->chan_attr_group.attrs = kcalloc(attrcount + 1,
+						   sizeof(indio_dev->chan_attr_group.attrs[0]),
+						   GFP_KERNEL);
 	if (indio_dev->chan_attr_group.attrs == NULL) {
 		ret = -ENOMEM;
 		goto error_clear_attrs;
@@ -958,10 +957,9 @@ static int iio_device_register_eventset(
 	}
 
 	indio_dev->event_interface->group.name = iio_event_group_name;
-	indio_dev->event_interface->group.attrs =
-		kzalloc(sizeof(indio_dev->event_interface->group.attrs[0])
-			*(attrcount + 1),
-			GFP_KERNEL);
+	indio_dev->event_interface->group.attrs = kcalloc(attrcount + 1,
+							  sizeof(indio_dev->event_interface->group.attrs[0]),
+							  GFP_KERNEL);
 	if (indio_dev->event_interface->group.attrs == NULL) {
 		ret = -ENOMEM;
 		goto error_free_setup_event_lines;
