Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab3AINmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 08:42:10 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52794 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab3AINmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 08:42:05 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Sekhar Nori <nsekhar@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH RFC 2/3] tvp514x: support asynchronous probing
Date: Wed,  9 Jan 2013 19:11:26 +0530
Message-Id: <1357738887-8701-3-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357738887-8701-1-git-send-email-prabhakar.lad@ti.com>
References: <1357738887-8701-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both synchronous and asynchronous tvp514x subdevice probing is supported by
this patch.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/i2c/tvp514x.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index aa94ebc..a4f0a70 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -34,6 +34,7 @@
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
+#include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-mediabus.h>
@@ -102,6 +103,7 @@ struct tvp514x_decoder {
 	struct v4l2_ctrl_handler hdl;
 	struct tvp514x_reg tvp514x_regs[ARRAY_SIZE(tvp514x_reg_list_default)];
 	const struct tvp514x_platform_data *pdata;
+	struct v4l2_async_subdev_list	asdl;
 
 	int ver;
 	int streaming;
@@ -941,22 +943,22 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct tvp514x_decoder *decoder;
 	struct v4l2_subdev *sd;
+	int ret;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	if (!client->dev.platform_data) {
-		v4l2_err(client, "No platform data!!\n");
-		return -ENODEV;
-	}
-
 	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
 	if (!decoder)
 		return -ENOMEM;
 
 	/* Initialize the tvp514x_decoder with default configuration */
 	*decoder = tvp514x_dev;
+	if (!client->dev.platform_data) {
+		v4l2_err(client, "No platform data!!\n");
+		return -EPROBE_DEFER;
+	}
 	/* Copy default register configuration */
 	memcpy(decoder->tvp514x_regs, tvp514x_reg_list_default,
 			sizeof(tvp514x_reg_list_default));
@@ -980,6 +982,11 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	/* Register with V4L2 layer as slave device */
 	sd = &decoder->sd;
+	decoder->asdl.subdev = &decoder->sd;
+	decoder->asdl.dev = &client->dev;
+	ret = v4l2_async_subdev_bind(&decoder->asdl);
+	if (ret < 0)
+		return ret;
 	v4l2_i2c_subdev_init(sd, client, &tvp514x_ops);
 
 	v4l2_ctrl_handler_init(&decoder->hdl, 5);
@@ -1004,7 +1011,7 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	v4l2_info(sd, "%s decoder driver registered !!\n", sd->name);
 
-	return 0;
+	return v4l2_async_subdev_bound(&decoder->asdl);
 
 }
 
@@ -1020,6 +1027,7 @@ static int tvp514x_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct tvp514x_decoder *decoder = to_decoder(sd);
 
+	v4l2_async_subdev_unbind(&decoder->asdl);
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&decoder->hdl);
 	return 0;
-- 
1.7.4.1

