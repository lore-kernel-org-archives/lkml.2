Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0DZT3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:29:24 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51640 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab0DZT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 15/19] staging:iio:max1363 add support for 8 bit equivalent devices, max1036-9, max11600-5
Date: Mon, 26 Apr 2010 20:31:17 +0100
Message-Id: <1272310281-7418-16-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-15-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-7-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-8-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-9-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-10-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-11-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-12-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-13-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-14-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-15-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/adc/Kconfig        |   12 ++-
 drivers/staging/iio/adc/max1363_core.c |  143 ++++++++++++++++++++++++++++++--
 drivers/staging/iio/adc/max1363_ring.c |   23 ++++--
 3 files changed, 161 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
index afc8318..0835fbc 100644
--- a/drivers/staging/iio/adc/Kconfig
+++ b/drivers/staging/iio/adc/Kconfig
@@ -10,11 +10,13 @@ config MAX1363
 	select MAX1363_RING_BUFFER
 	help
 	  Say yes here to build support for many MAXIM i2c analog to digital
-	  convertors (ADC). (max1361, max1362, max1363, max1364, max1136,
-	  max1136, max1137, max1138, max1139, max1236, max1237, max11238,
-	  max1239, max11606, max11607, max11608, max11609, max11610,
-	  max11611, max11612, max11613, max11614, max11615, max11616,
-	  max11617) Provides direct access via sysfs.
+	  convertors (ADC). (max1361, max1362, max1363, max1364, max1036,
+	  max1037, max1038, max1039, max1136, max1136, max1137, max1138,
+	  max1139, max1236, max1237, max11238, max1239, max11600, max11601,
+	  max11602, max11603, max11604, max11605, max11606, max11607,
+	  max11608, max11609, max11610, max11611, max11612, max11613,
+	  max11614, max11615, max11616, max11617) Provides direct access
+	  via sysfs.
 
 config MAX1363_RING_BUFFER
 	bool "MAXIM max1363: use ring buffer"
diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
index c53bf6d..fa91cc1 100644
--- a/drivers/staging/iio/adc/max1363_core.c
+++ b/drivers/staging/iio/adc/max1363_core.c
@@ -226,13 +226,24 @@ static ssize_t max1363_read_single_channel(struct device *dev,
 			if (ret)
 				goto error_ret;
 		}
-		/* Get reading */
-		data = i2c_master_recv(client, rxbuf, 2);
-		if (data < 0) {
-			ret = data;
-			goto error_ret;
+		if (st->chip_info->bits != 8) {
+			/* Get reading */
+			data = i2c_master_recv(client, rxbuf, 2);
+			if (data < 0) {
+				ret = data;
+				goto error_ret;
+			}
+
+			data = (s32)(rxbuf[1]) | ((s32)(rxbuf[0] & 0x0F)) << 8;
+		} else {
+			/* Get reading */
+			data = i2c_master_recv(client, rxbuf, 1);
+			if (data < 0) {
+				ret = data;
+				goto error_ret;
+			}
+			data = rxbuf[0];
 		}
-		data = (s32)(rxbuf[1]) | ((s32)(rxbuf[0] & 0x0F)) << 8;
 	}
 	/* Pretty print the result */
 	len = sprintf(buf, "%u\n", data);
@@ -508,6 +519,10 @@ enum { max1361,
        max1362,
        max1363,
        max1364,
+       max1036,
+       max1037,
+       max1038,
+       max1039,
        max1136,
        max1137,
        max1138,
@@ -516,6 +531,12 @@ enum { max1361,
        max1237,
        max1238,
        max1239,
+       max11600,
+       max11601,
+       max11602,
+       max11603,
+       max11604,
+       max11605,
        max11606,
        max11607,
        max11608,
@@ -577,6 +598,46 @@ static const struct max1363_chip_info max1363_chip_info_tbl[] = {
 		.dev_attrs = &max1363_dev_attr_group,
 		.scan_attrs = &max1363_scan_el_group,
 	}, {
+		.name = "max1036",
+		.num_inputs = 4,
+		.bits = 8,
+		.int_vref_mv = 4096,
+		.mode_list = max1236_mode_list,
+		.num_modes = ARRAY_SIZE(max1236_mode_list),
+		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
+	}, {
+		.name = "max1037",
+		.num_inputs = 4,
+		.bits = 8,
+		.int_vref_mv = 2048,
+		.mode_list = max1236_mode_list,
+		.num_modes = ARRAY_SIZE(max1236_mode_list),
+		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
+	}, {
+		.name = "max1038",
+		.num_inputs = 12,
+		.bits = 8,
+		.int_vref_mv = 4096,
+		.mode_list = max1238_mode_list,
+		.num_modes = ARRAY_SIZE(max1238_mode_list),
+		.default_mode = s0to11,
+		.dev_attrs = &max1238_dev_attr_group,
+		.scan_attrs = &max1238_scan_el_group,
+	}, {
+		.name = "max1039",
+		.num_inputs = 12,
+		.bits = 8,
+		.int_vref_mv = 2048,
+		.mode_list = max1238_mode_list,
+		.num_modes = ARRAY_SIZE(max1238_mode_list),
+		.default_mode = s0to11,
+		.dev_attrs = &max1238_dev_attr_group,
+		.scan_attrs = &max1238_scan_el_group,
+	}, {
 		.name = "max1136",
 		.num_inputs = 4,
 		.bits = 10,
@@ -657,6 +718,66 @@ static const struct max1363_chip_info max1363_chip_info_tbl[] = {
 		.dev_attrs = &max1238_dev_attr_group,
 		.scan_attrs = &max1238_scan_el_group,
 	}, {
+		.name = "max11600",
+		.num_inputs = 4,
+		.bits = 8,
+		.int_vref_mv = 4096,
+		.mode_list = max11607_mode_list,
+		.num_modes = ARRAY_SIZE(max11607_mode_list),
+		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
+	}, {
+		.name = "max11601",
+		.num_inputs = 4,
+		.bits = 8,
+		.int_vref_mv = 2048,
+		.mode_list = max11607_mode_list,
+		.num_modes = ARRAY_SIZE(max11607_mode_list),
+		.default_mode = s0to3,
+		.dev_attrs = &max1363_dev_attr_group,
+		.scan_attrs = &max1363_scan_el_group,
+	}, {
+		.name = "max11602",
+		.num_inputs = 8,
+		.bits = 8,
+		.int_vref_mv = 4096,
+		.mode_list = max11608_mode_list,
+		.num_modes = ARRAY_SIZE(max11608_mode_list),
+		.default_mode = s0to7,
+		.dev_attrs = &max11608_dev_attr_group,
+		.scan_attrs = &max11608_scan_el_group,
+	}, {
+		.name = "max11603",
+		.num_inputs = 8,
+		.bits = 8,
+		.int_vref_mv = 2048,
+		.mode_list = max11608_mode_list,
+		.num_modes = ARRAY_SIZE(max11608_mode_list),
+		.default_mode = s0to7,
+		.dev_attrs = &max11608_dev_attr_group,
+		.scan_attrs = &max11608_scan_el_group,
+	}, {
+		.name = "max11604",
+		.num_inputs = 12,
+		.bits = 8,
+		.int_vref_mv = 4098,
+		.mode_list = max1238_mode_list,
+		.num_modes = ARRAY_SIZE(max1238_mode_list),
+		.default_mode = s0to11,
+		.dev_attrs = &max1238_dev_attr_group,
+		.scan_attrs = &max1238_scan_el_group,
+	}, {
+		.name = "max11605",
+		.num_inputs = 12,
+		.bits = 8,
+		.int_vref_mv = 2048,
+		.mode_list = max1238_mode_list,
+		.num_modes = ARRAY_SIZE(max1238_mode_list),
+		.default_mode = s0to11,
+		.dev_attrs = &max1238_dev_attr_group,
+		.scan_attrs = &max1238_scan_el_group,
+	}, {
 		.name = "max11606",
 		.num_inputs = 4,
 		.bits = 10,
@@ -920,6 +1041,10 @@ static const struct i2c_device_id max1363_id[] = {
 	{ "max1362", max1362 },
 	{ "max1363", max1363 },
 	{ "max1364", max1364 },
+	{ "max1036", max1036 },
+	{ "max1037", max1037 },
+	{ "max1038", max1038 },
+	{ "max1039", max1039 },
 	{ "max1136", max1136 },
 	{ "max1137", max1137 },
 	{ "max1138", max1138 },
@@ -928,6 +1053,12 @@ static const struct i2c_device_id max1363_id[] = {
 	{ "max1237", max1237 },
 	{ "max1238", max1238 },
 	{ "max1239", max1239 },
+	{ "max11600", max11600 },
+	{ "max11601", max11601 },
+	{ "max11602", max11602 },
+	{ "max11603", max11603 },
+	{ "max11604", max11604 },
+	{ "max11605", max11605 },
 	{ "max11606", max11606 },
 	{ "max11607", max11607 },
 	{ "max11608", max11608 },
diff --git a/drivers/staging/iio/adc/max1363_ring.c b/drivers/staging/iio/adc/max1363_ring.c
index f1e37f2..85fde75 100644
--- a/drivers/staging/iio/adc/max1363_ring.c
+++ b/drivers/staging/iio/adc/max1363_ring.c
@@ -55,8 +55,11 @@ int max1363_single_channel_from_ring(long mask, struct max1363_state *st)
 			count++;
 		mask >>= 1;
 	}
-	return ((int)(ring_data[count*2 + 0] & 0x0F) << 8)
-		+ (int)(ring_data[count*2 + 1]);
+	if (st->chip_info->bits != 8)
+		return ((int)(ring_data[count*2 + 0] & 0x0F) << 8)
+			+ (int)(ring_data[count*2 + 1]);
+	else
+		return ring_data[count];
 
 error_free_ring_data:
 	kfree(ring_data);
@@ -90,7 +93,10 @@ static int max1363_ring_preenable(struct iio_dev *indio_dev)
 
 	numvals = hweight_long(st->current_mode->modemask);
 	if (indio_dev->ring->access.set_bpd) {
-		d_size = numvals*2 + sizeof(s64);
+		if (st->chip_info->bits != 8)
+			d_size = numvals*2 + sizeof(s64);
+		else
+			d_size = numvals + sizeof(s64);
 		if (d_size % 8)
 			d_size += 8 - (d_size % 8);
 		indio_dev->ring->access.set_bpd(indio_dev->ring, d_size);
@@ -166,7 +172,10 @@ static void max1363_poll_bh_to_ring(struct work_struct *work_s)
 	unsigned long numvals = hweight_long(st->current_mode->modemask);
 
 	/* Ensure the timestamp is 8 byte aligned */
-	d_size = numvals*2 + sizeof(s64);
+	if (st->chip_info->bits != 8)
+		d_size = numvals*2 + sizeof(s64);
+	else
+		d_size = numvals + sizeof(s64);
 	if (d_size % sizeof(s64))
 		d_size += sizeof(s64) - (d_size % sizeof(s64));
 
@@ -184,8 +193,10 @@ static void max1363_poll_bh_to_ring(struct work_struct *work_s)
 	rxbuf = kmalloc(d_size,	GFP_KERNEL);
 	if (rxbuf == NULL)
 		return;
-
-	b_sent = i2c_master_recv(st->client, rxbuf, numvals*2);
+	if (st->chip_info->bits != 8)
+		b_sent = i2c_master_recv(st->client, rxbuf, numvals*2);
+	else
+		b_sent = i2c_master_recv(st->client, rxbuf, numvals);
 	if (b_sent < 0)
 		goto done;
 
-- 
1.6.4.4

