Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab2DSMCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:02:11 -0400
Received: from mail.telros.ru ([83.136.244.21]:62837 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab2DSMCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:02:09 -0400
X-Greylist: delayed 2050 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2012 08:02:09 EDT
Message-ID: <1334834777.9633.4.camel@VPir>
Subject: Subject: [PATCH] [Trivial] Staging: go7007: wis-tw2804 upstyle to
 v4l2
From: volokh <my84@bk.ru>
To: volokh@telros.ru
Cc: my84@bk.ru, Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <trivial@kernel.org>,
        Pradheep Shrinivasan <pradheep.sh@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Apr 2012 15:26:17 +0400
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Some update to new v4l2 controls

 Signed-off-by:Volokh Konstantin <my84@bk.ru>
---
 drivers/staging/media/go7007/wis-tw2804.c |  378 +++++++++++++++++------------
 1 files changed, 228 insertions(+), 150 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-tw2804.c b/drivers/staging/media/go7007/wis-tw2804.c
index 9134f03..cffaa2b 100644
--- a/drivers/staging/media/go7007/wis-tw2804.c
+++ b/drivers/staging/media/go7007/wis-tw2804.c
@@ -21,10 +21,13 @@
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
 #include <linux/slab.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-device.h>
 
 #include "wis-i2c.h"
 
 struct wis_tw2804 {
+	struct v4l2_subdev sd;
 	int channel;
 	int norm;
 	int brightness;
@@ -33,6 +36,13 @@ struct wis_tw2804 {
 	int hue;
 };
 
+static inline struct wis_tw2804 *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct wis_tw2804, sd);
+}
+
+static int tw2804_log_status(struct v4l2_subdev *sd);
+
 static u8 global_registers[] = {
 	0x39, 0x00,
 	0x3a, 0xff,
@@ -105,223 +115,291 @@ static u8 channel_registers[] = {
 
 static int write_reg(struct i2c_client *client, u8 reg, u8 value, int channel)
 {
-	return i2c_smbus_write_byte_data(client, reg | (channel << 6), value);
+	int i;
+
+	for (i = 0; i < 10; i++)
+		/*return */if (i2c_smbus_write_byte_data(client,
+				reg|(channel<<6), value) < 0)
+			return -1;
+	return 0;
 }
 
+/**static u8 read_reg(struct i2c_client *client, u8 reg, int channel)
+{
+  return i2c_smbus_read_byte_data(client,reg|(channel<<6));
+}*/
+
 static int write_regs(struct i2c_client *client, u8 *regs, int channel)
 {
 	int i;
 
 	for (i = 0; regs[i] != 0xff; i += 2)
-		if (i2c_smbus_write_byte_data(client,
-				regs[i] | (channel << 6), regs[i + 1]) < 0)
+		if (i2c_smbus_write_byte_data(client
+				, regs[i] | (channel << 6), regs[i + 1]) < 0)
 			return -1;
 	return 0;
 }
 
-static int wis_tw2804_command(struct i2c_client *client,
-				unsigned int cmd, void *arg)
+static int wis_tw2804_command(
+	struct i2c_client *client,
+	unsigned int cmd,
+	void *arg)
 {
-	struct wis_tw2804 *dec = i2c_get_clientdata(client);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct wis_tw2804 *dec = to_state(sd);
+	int *input;
+
+	printk(KERN_INFO"wis-tw2804: call command %d\n", cmd);
 
 	if (cmd == DECODER_SET_CHANNEL) {
-		int *input = arg;
+		printk(KERN_INFO"wis-tw2804: DecoderSetChannel call command %d\n", cmd);
+
+		input = arg;
 
 		if (*input < 0 || *input > 3) {
-			printk(KERN_ERR "wis-tw2804: channel %d is not "
-					"between 0 and 3!\n", *input);
+			printk(KERN_ERR"wis-tw2804: channel %d is not between 0 and 3!\n", *input);
 			return 0;
 		}
 		dec->channel = *input;
-		printk(KERN_DEBUG "wis-tw2804: initializing TW2804 "
-				"channel %d\n", dec->channel);
-		if (dec->channel == 0 &&
-				write_regs(client, global_registers, 0) < 0) {
-			printk(KERN_ERR "wis-tw2804: error initializing "
-					"TW2804 global registers\n");
+		printk(KERN_DEBUG"wis-tw2804: initializing TW2804 channel %d\n", dec->channel);
+		if (dec->channel == 0 && write_regs(client,
+				global_registers, 0) < 0) {
+			printk(KERN_ERR"wis-tw2804: error initializing TW2804 global registers\n");
 			return 0;
 		}
 		if (write_regs(client, channel_registers, dec->channel) < 0) {
-			printk(KERN_ERR "wis-tw2804: error initializing "
-					"TW2804 channel %d\n", dec->channel);
+			printk(KERN_ERR"wis-tw2804: error initializing TW2804 channel %d\n", dec->channel);
 			return 0;
 		}
 		return 0;
 	}
 
 	if (dec->channel < 0) {
-		printk(KERN_DEBUG "wis-tw2804: ignoring command %08x until "
-				"channel number is set\n", cmd);
+		printk(KERN_DEBUG"wis-tw2804: ignoring command %08x until channel number is set\n", cmd);
 		return 0;
 	}
 
-	switch (cmd) {
-	case VIDIOC_S_STD:
-	{
-		v4l2_std_id *input = arg;
-		u8 regs[] = {
-			0x01, *input & V4L2_STD_NTSC ? 0xc4 : 0x84,
-			0x09, *input & V4L2_STD_NTSC ? 0x07 : 0x04,
-			0x0a, *input & V4L2_STD_NTSC ? 0xf0 : 0x20,
-			0x0b, *input & V4L2_STD_NTSC ? 0x07 : 0x04,
-			0x0c, *input & V4L2_STD_NTSC ? 0xf0 : 0x20,
-			0x0d, *input & V4L2_STD_NTSC ? 0x40 : 0x4a,
-			0x16, *input & V4L2_STD_NTSC ? 0x00 : 0x40,
-			0x17, *input & V4L2_STD_NTSC ? 0x00 : 0x40,
-			0x20, *input & V4L2_STD_NTSC ? 0x07 : 0x0f,
-			0x21, *input & V4L2_STD_NTSC ? 0x07 : 0x0f,
-			0xff,	0xff,
-		};
-		write_regs(client, regs, dec->channel);
-		dec->norm = *input;
-		break;
+	return 0;
+}
+
+static int tw2804_log_status(struct v4l2_subdev *sd)
+{
+	struct wis_tw2804 *state = to_state(sd);
+	v4l2_info(sd, "Standard: %s\n", state->norm == V4L2_STD_NTSC
+		? "NTSC" : state->norm == V4L2_STD_PAL
+		? "PAL" : state->norm == V4L2_STD_SECAM
+		? "SECAM" : "unknown");
+	v4l2_info(sd, "Input: %d\n", state->channel);
+	v4l2_info(sd, "Brightness: %d\n", state->brightness);
+	v4l2_info(sd, "Contrast: %d\n", state->contrast);
+	v4l2_info(sd, "Saturation: %d\n", state->saturation);
+	v4l2_info(sd, "Hue: %d\n", state->hue);
+	return 0;
+}
+
+static int tw2804_queryctrl(
+	struct v4l2_subdev *sd,
+	struct v4l2_queryctrl *query)
+{
+	static const u32 user_ctrls[] = {
+		V4L2_CID_USER_CLASS,
+		V4L2_CID_BRIGHTNESS,
+		V4L2_CID_CONTRAST,
+		V4L2_CID_SATURATION,
+		V4L2_CID_HUE,
+		0
+	};
+
+	static const u32 *ctrl_classes[] = {
+		user_ctrls,
+		NULL
+	};
+
+	query->id = v4l2_ctrl_next(ctrl_classes, query->id);
+
+	switch (query->id) {
+	case V4L2_CID_USER_CLASS:
+		return v4l2_ctrl_query_fill(query, 0, 0, 0, 0);
+	case V4L2_CID_BRIGHTNESS:
+		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
+	case V4L2_CID_CONTRAST:
+		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
+	case V4L2_CID_SATURATION:
+		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
+	case V4L2_CID_HUE:
+		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
+	default:
+		return -EINVAL;
 	}
-	case VIDIOC_QUERYCTRL:
-	{
-		struct v4l2_queryctrl *ctrl = arg;
-
-		switch (ctrl->id) {
-		case V4L2_CID_BRIGHTNESS:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Brightness", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
-		case V4L2_CID_CONTRAST:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Contrast", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
-		case V4L2_CID_SATURATION:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Saturation", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
-		case V4L2_CID_HUE:
-			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
-			strncpy(ctrl->name, "Hue", sizeof(ctrl->name));
-			ctrl->minimum = 0;
-			ctrl->maximum = 255;
-			ctrl->step = 1;
-			ctrl->default_value = 128;
-			ctrl->flags = 0;
-			break;
-		}
+}
+
+static int tw2804_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct wis_tw2804 *dec = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	int Addr = 0x00;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		Addr = 0x12;
 		break;
-	}
-	case VIDIOC_S_CTRL:
-	{
-		struct v4l2_control *ctrl = arg;
-
-		switch (ctrl->id) {
-		case V4L2_CID_BRIGHTNESS:
-			if (ctrl->value > 255)
-				dec->brightness = 255;
-			else if (ctrl->value < 0)
-				dec->brightness = 0;
-			else
-				dec->brightness = ctrl->value;
-			write_reg(client, 0x12, dec->brightness, dec->channel);
-			break;
-		case V4L2_CID_CONTRAST:
-			if (ctrl->value > 255)
-				dec->contrast = 255;
-			else if (ctrl->value < 0)
-				dec->contrast = 0;
-			else
-				dec->contrast = ctrl->value;
-			write_reg(client, 0x11, dec->contrast, dec->channel);
-			break;
-		case V4L2_CID_SATURATION:
-			if (ctrl->value > 255)
-				dec->saturation = 255;
-			else if (ctrl->value < 0)
-				dec->saturation = 0;
-			else
-				dec->saturation = ctrl->value;
-			write_reg(client, 0x10, dec->saturation, dec->channel);
-			break;
-		case V4L2_CID_HUE:
-			if (ctrl->value > 255)
-				dec->hue = 255;
-			else if (ctrl->value < 0)
-				dec->hue = 0;
-			else
-				dec->hue = ctrl->value;
-			write_reg(client, 0x0f, dec->hue, dec->channel);
-			break;
-		}
+	case V4L2_CID_CONTRAST:
+		Addr = 0x11;
 		break;
-	}
-	case VIDIOC_G_CTRL:
-	{
-		struct v4l2_control *ctrl = arg;
-
-		switch (ctrl->id) {
-		case V4L2_CID_BRIGHTNESS:
-			ctrl->value = dec->brightness;
-			break;
-		case V4L2_CID_CONTRAST:
-			ctrl->value = dec->contrast;
-			break;
-		case V4L2_CID_SATURATION:
-			ctrl->value = dec->saturation;
-			break;
-		case V4L2_CID_HUE:
-			ctrl->value = dec->hue;
-			break;
-		}
+	case V4L2_CID_SATURATION:
+		Addr = 0x10;
+		break;
+	case V4L2_CID_HUE:
+		Addr = 0x0f;
 		break;
+	default:
+		return -EINVAL;
+	}
+	ctrl->value = ctrl->value > 255
+	? 255 : (ctrl->value < 0 ? 0 : ctrl->value);
+	Addr = write_reg(client, Addr, ctrl->value, dec->channel);
+
+	if (Addr < 0) {
+		printk(KERN_INFO"wis_tw2804: can`t set_ctrl value:id=%d;value=%d"
+			, ctrl->id, ctrl->value);
+		return Addr;
 	}
+	printk(KERN_INFO"wis_tw2804: set_ctrl value:id=%d;value=%d"
+		, ctrl->id, ctrl->value);
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		dec->brightness = ctrl->value;
+		break;
+	case V4L2_CID_CONTRAST:
+		dec->contrast = ctrl->value;
+		break;
+	case V4L2_CID_SATURATION:
+		dec->saturation = ctrl->value;
+		break;
+	case V4L2_CID_HUE:
+		dec->hue = ctrl->value;
+		break;
 	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int tw2804_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct wis_tw2804 *state = to_state(sd);
+	/*/ struct i2c_client *client=v4l2_get_subdevdata(sd);*/
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		ctrl->value = state->brightness;
+		/*=read_reg(client,0x12,state->channel);*/
+		break;
+	case V4L2_CID_CONTRAST:
+		ctrl->value = state->contrast;
+		/*=read_reg(client,0x11,state->channel);*/
 		break;
+	case V4L2_CID_SATURATION:
+		ctrl->value = state->saturation;
+		/*=read_reg(client,0x10,state->channel);*/
+		break;
+	case V4L2_CID_HUE:
+		ctrl->value = state->hue;
+		/*=read_reg(client,0x0f,state->channel);*/
+		break;
+	default:
+		return -EINVAL;
 	}
 	return 0;
 }
 
+static int tw2804_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
+{
+	struct wis_tw2804 *dec = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	/*/      v4l2_std_id *input=arg;*/
+	u8 regs[] = {
+		0x01, norm&V4L2_STD_NTSC ? 0xc4 : 0x84,
+		0x09, norm&V4L2_STD_NTSC ? 0x07 : 0x04,
+		0x0a, norm&V4L2_STD_NTSC ? 0xf0 : 0x20,
+		0x0b, norm&V4L2_STD_NTSC ? 0x07 : 0x04,
+		0x0c, norm&V4L2_STD_NTSC ? 0xf0 : 0x20,
+		0x0d, norm&V4L2_STD_NTSC ? 0x40 : 0x4a,
+		0x16, norm&V4L2_STD_NTSC ? 0x00 : 0x40,
+		0x17, norm&V4L2_STD_NTSC ? 0x00 : 0x40,
+		0x20, norm&V4L2_STD_NTSC ? 0x07 : 0x0f,
+		0x21, norm&V4L2_STD_NTSC ? 0x07 : 0x0f,
+		0xff, 0xff,
+	};
+	write_regs(client, regs, dec->channel);
+	dec->norm = norm;
+	return 0;
+}
+
+static const struct v4l2_subdev_core_ops tw2804_core_ops = {
+	.log_status = tw2804_log_status,
+	.g_ctrl = tw2804_g_ctrl,
+	.s_ctrl = tw2804_s_ctrl,
+	.queryctrl = tw2804_queryctrl,
+	.s_std = tw2804_s_std,
+};
+
+/*
+static const struct v4l2_subdev_video_ops tw2804_video_ops = {
+  .s_routing = tw2804_s_video_routing,
+  .s_fmt = tw2804_s_fmt,
+};*/
+
+static const struct v4l2_subdev_ops tw2804_ops = {
+	.core = &tw2804_core_ops,
+	/*/  .audio = &s2250_audio_ops,*/
+	/*/  .video = &s2250_video_ops,*/
+};
+
 static int wis_tw2804_probe(struct i2c_client *client,
-			    const struct i2c_device_id *id)
+	const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct wis_tw2804 *dec;
+	struct v4l2_subdev *sd;
+
+	printk(KERN_DEBUG "wis_tw2804 :probing %s adapter %s", id->name
+		, client->adapter->name);
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
 
 	dec = kmalloc(sizeof(struct wis_tw2804), GFP_KERNEL);
+
 	if (dec == NULL)
 		return -ENOMEM;
 
+	sd = &dec->sd;
 	dec->channel = -1;
 	dec->norm = V4L2_STD_NTSC;
 	dec->brightness = 128;
 	dec->contrast = 128;
 	dec->saturation = 128;
 	dec->hue = 128;
-	i2c_set_clientdata(client, dec);
+	v4l2_i2c_subdev_init(sd, client, &tw2804_ops);
+	v4l2_info(sd, "initializing %s at address 0x%x on %s\n"
+		, "tw 2804", client->addr, client->adapter->name);
 
-	printk(KERN_DEBUG "wis-tw2804: creating TW2804 at address %d on %s\n",
-		client->addr, adapter->name);
+	printk(KERN_DEBUG "wis-tw2804: creating TW2804 at address %d on %s\n"
+		, client->addr, adapter->name);
 
 	return 0;
 }
 
 static int wis_tw2804_remove(struct i2c_client *client)
 {
-	struct wis_tw2804 *dec = i2c_get_clientdata(client);
-
-	kfree(dec);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	printk(KERN_INFO"wis_tw2804: remove");
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
 	return 0;
 }
 
-- 
1.7.7.6



