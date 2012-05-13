Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2EMSza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 14:55:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38592 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2EMSz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 14:55:27 -0400
From: Volokh Konstantin <volokh84@gmail.com>
To: my84@bk.ru
Cc: volokh84@gmail.com, mchehab@infradead.org, gregkh@linuxfoundation.org,
        dhowells@redhat.com, rdunlap@xenotime.net, justinmattock@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, hverkuil@xs4all.nl
Subject: [PATCH 2/2] staging: media: go7007: Adlink MPG24 board
Date: Sun, 13 May 2012 22:52:42 +0400
Message-Id: <1336935162-5068-2-git-send-email-volokh84@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336935162-5068-1-git-send-email-volokh84@gmail.com>
References: <1336935162-5068-1-git-send-email-volokh84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:
    - wis-tw2804.ko module code was incompatible with 3.4 branch in initialization v4l2_subdev parts. now i2c_get_clientdata(...) contains v4l2_subdev struct instead non standard wis_tw2804 struct
    - Use V4L2 control framework

Adds:
  - Additional chipset tw2804 controls with: gain,auto gain,inputs[0,1],color kill,chroma gain,gain balances, for all 4 channels (from tw2804.pdf)
  - Power control for each 4 ADC (tw2804) up when s_stream(...,1), down otherwise

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/wis-tw2804.c |  466 +++++++++++++++++++----------
 include/media/v4l2-chip-ident.h           |    4 +
 2 files changed, 315 insertions(+), 155 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-tw2804.c b/drivers/staging/media/go7007/wis-tw2804.c
index 9134f03..2e613dc 100644
--- a/drivers/staging/media/go7007/wis-tw2804.c
+++ b/drivers/staging/media/go7007/wis-tw2804.c
@@ -21,16 +21,19 @@
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
 #include <linux/slab.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
 
 #include "wis-i2c.h"
 
 struct wis_tw2804 {
-	int channel;
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	u8 channel:2;
+	u8 input:1;
 	int norm;
-	int brightness;
-	int contrast;
-	int saturation;
-	int hue;
 };
 
 static u8 global_registers[] = {
@@ -41,6 +44,7 @@ static u8 global_registers[] = {
 	0x3d, 0x80,
 	0x3e, 0x82,
 	0x3f, 0x82,
+	0x78, 0x0f,
 	0xff, 0xff, /* Terminator (reg 0xff does not exist) */
 };
 
@@ -103,29 +107,271 @@ static u8 channel_registers[] = {
 	0xff, 0xff, /* Terminator (reg 0xff does not exist) */
 };
 
-static int write_reg(struct i2c_client *client, u8 reg, u8 value, int channel)
+static s32 write_reg(struct i2c_client *client, u8 reg, u8 value, u8 channel)
 {
 	return i2c_smbus_write_byte_data(client, reg | (channel << 6), value);
 }
 
-static int write_regs(struct i2c_client *client, u8 *regs, int channel)
+static int write_regs(struct i2c_client *client, u8 *regs, u8 channel)
 {
 	int i;
 
 	for (i = 0; regs[i] != 0xff; i += 2)
 		if (i2c_smbus_write_byte_data(client,
 				regs[i] | (channel << 6), regs[i + 1]) < 0)
-			return -1;
+			return -EINVAL;
 	return 0;
 }
 
+static s32 read_reg(struct i2c_client *client, u8 reg, u8 channel)
+{
+	return i2c_smbus_read_byte_data(client, (reg) | (channel << 6));
+}
+
+inline struct wis_tw2804 *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct wis_tw2804, sd);
+}
+
+inline struct wis_tw2804 *to_state_from_ctrl(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct wis_tw2804, hdl);
+}
+
+static int tw2804_log_status(struct v4l2_subdev *sd)
+{
+	struct wis_tw2804 *state = to_state(sd);
+	v4l2_info(sd, "Standard: %s\n",
+			state->norm == V4L2_STD_NTSC ? "NTSC" :
+			state->norm == V4L2_STD_PAL ? "PAL" : "unknown");
+	v4l2_info(sd, "Channel: %d\n", state->channel);
+	v4l2_info(sd, "Input: %d\n", state->input);
+	v4l2_ctrl_handler_log_status(&state->hdl, sd->name);
+	return 0;
+}
+
+s32 get_ctrl_addr(int ctrl)
+{
+	switch (ctrl) {
+	case V4L2_CID_BRIGHTNESS:
+		return 0x12;
+	case V4L2_CID_CONTRAST:
+		return 0x11;
+	case V4L2_CID_SATURATION:
+		return 0x10;
+	case V4L2_CID_HUE:
+		return 0x0f;
+	case V4L2_CID_AUTOGAIN:
+		return 0x02;
+	case V4L2_CID_COLOR_KILLER:
+		return 0x14;
+	case V4L2_CID_GAIN:
+		return 0x3c;
+	case V4L2_CID_CHROMA_GAIN:
+		return 0x3d;
+	case V4L2_CID_RED_BALANCE:
+		return 0x3f;
+	case V4L2_CID_BLUE_BALANCE:
+		return 0x3e;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int tw2804_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = &to_state_from_ctrl(ctrl)->sd;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	s32 addr = get_ctrl_addr(ctrl->id);
+
+	if (addr == -EINVAL)
+		return -EINVAL;
+
+	switch (ctrl->id) {
+	case V4L2_CID_GAIN:
+	case V4L2_CID_CHROMA_GAIN:
+	case V4L2_CID_RED_BALANCE:
+	case V4L2_CID_BLUE_BALANCE:
+		ctrl->cur.val = read_reg(client, addr, 0);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int tw2804_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct wis_tw2804 *state = to_state_from_ctrl(ctrl);
+	struct v4l2_subdev *sd = &state->sd;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	s32 reg = ctrl->val;
+	s32 addr = get_ctrl_addr(ctrl->id);
+
+	if (addr == -EINVAL)
+		return -EINVAL;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		reg = read_reg(client, addr, state->channel);
+		if (reg > 0) {
+			if (ctrl->val == 0)
+				reg &= ~(1<<7);
+			else
+				reg |= 1<<7;
+		} else
+			return reg;
+		break;
+	case V4L2_CID_COLOR_KILLER:
+		reg = read_reg(client, addr, state->channel);
+		if (reg > 0)
+			reg = (reg & ~(0x03)) | (ctrl->val == 0 ? 0x02 : 0x03);
+		else
+			return reg;
+		break;
+	default:
+		break;
+	}
+
+	reg = reg > 255 ? 255 : (reg < 0 ? 0 : reg);
+	reg = write_reg(client, addr, (u8)reg,
+			ctrl->id == V4L2_CID_GAIN ||
+			ctrl->id == V4L2_CID_CHROMA_GAIN ||
+			ctrl->id == V4L2_CID_RED_BALANCE ||
+			ctrl->id == V4L2_CID_BLUE_BALANCE ? 0 : state->channel);
+
+	if (reg < 0) {
+		v4l2_err(sd, "Can`t set_ctrl value:id=%d;value=%d\n", ctrl->id,
+								    ctrl->val);
+		return reg;
+	}
+	return 0;
+}
+
+static int tw2804_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
+{
+	struct wis_tw2804 *dec = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
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
+static int tw2804_g_chip_ident(struct v4l2_subdev *sd,
+				struct v4l2_dbg_chip_ident *chip)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	return v4l2_chip_ident_i2c_client(client, chip,
+					V4L2_IDENT_TW2804, 0x0e);
+}
+
+static const struct v4l2_ctrl_ops tw2804_ctrl_ops = {
+	.g_volatile_ctrl = tw2804_g_volatile_ctrl,
+	.s_ctrl = tw2804_s_ctrl,
+};
+
+static const struct v4l2_subdev_core_ops tw2804_core_ops = {
+	.log_status = tw2804_log_status,
+	.g_chip_ident = tw2804_g_chip_ident,
+	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+	.g_ctrl = v4l2_subdev_g_ctrl,
+	.s_ctrl = v4l2_subdev_s_ctrl,
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
+	.s_std = tw2804_s_std,
+};
+
+static int tw2804_s_video_routing(struct v4l2_subdev *sd, u32 input, u32 output,
+	u32 config)
+{
+	struct wis_tw2804 *dec = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	s32 reg = 0;
+
+	if (0 > input || input > 1)
+		return -EINVAL;
+
+	if (input == dec->input)
+		return 0;
+
+	reg = read_reg(client, 0x22, dec->channel);
+
+	if (reg >= 0) {
+		if (input == 0)
+			reg &= ~(1<<2);
+		else
+			reg |= 1<<2;
+		reg = write_reg(client, 0x22, (u8)reg, dec->channel);
+	}
+
+	if (reg >= 0)
+		dec->input = input;
+	else
+		return reg;
+	return 0;
+}
+
+static int tw2804_s_mbus_fmt(struct v4l2_subdev *sd,
+	struct v4l2_mbus_framefmt *fmt)
+{
+	/*TODO need select between 3fmt:
+	 * bt_656,
+	 * bt_601_8bit,
+	 * bt_656_dual,
+	 */
+	return 0;
+}
+
+int tw2804_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct wis_tw2804 *dec = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u32 reg = read_reg(client, 0x78, 0);
+
+	if (enable == 1)
+		write_reg(client, 0x78, reg & ~(1<<dec->channel), 0);
+	else
+		write_reg(client, 0x78, reg | (1<<dec->channel), 0);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_video_ops tw2804_video_ops = {
+	.s_routing = tw2804_s_video_routing,
+	.s_mbus_fmt = tw2804_s_mbus_fmt,
+	.s_stream = tw2804_s_stream,
+};
+
+static const struct v4l2_subdev_ops tw2804_ops = {
+	.core = &tw2804_core_ops,
+	.video = &tw2804_video_ops,
+};
+
 static int wis_tw2804_command(struct i2c_client *client,
 				unsigned int cmd, void *arg)
 {
-	struct wis_tw2804 *dec = i2c_get_clientdata(client);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct wis_tw2804 *dec = to_state(sd);
+	int *input;
 
 	if (cmd == DECODER_SET_CHANNEL) {
-		int *input = arg;
+		input = arg;
 
 		if (*input < 0 || *input > 3) {
 			printk(KERN_ERR "wis-tw2804: channel %d is not "
@@ -154,139 +400,6 @@ static int wis_tw2804_command(struct i2c_client *client,
 				"channel number is set\n", cmd);
 		return 0;
 	}
-
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
-	}
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
-		break;
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
-		break;
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
-		break;
-	}
-	default:
-		break;
-	}
 	return 0;
 }
 
@@ -294,22 +407,59 @@ static int wis_tw2804_probe(struct i2c_client *client,
 			    const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = client->adapter;
-	struct wis_tw2804 *dec;
+	struct wis_tw2804 *state;
+	struct v4l2_subdev *sd;
+	struct v4l2_ctrl *ctrl = NULL;
+	int err;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
 
-	dec = kmalloc(sizeof(struct wis_tw2804), GFP_KERNEL);
-	if (dec == NULL)
+	state = kzalloc(sizeof(struct wis_tw2804), GFP_KERNEL);
+
+	if (state == NULL)
 		return -ENOMEM;
+	sd = &state->sd;
+	v4l2_i2c_subdev_init(sd, client, &tw2804_ops);
+	state->channel = -1;
+	state->norm = V4L2_STD_NTSC;
 
-	dec->channel = -1;
-	dec->norm = V4L2_STD_NTSC;
-	dec->brightness = 128;
-	dec->contrast = 128;
-	dec->saturation = 128;
-	dec->hue = 128;
-	i2c_set_clientdata(client, dec);
+	v4l2_ctrl_handler_init(&state->hdl, 10);
+	v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+					V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+					V4L2_CID_CONTRAST, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+					V4L2_CID_SATURATION, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+					V4L2_CID_HUE, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+					V4L2_CID_AUTOGAIN, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+					V4L2_CID_COLOR_KILLER, 0, 1, 1, 0);
+	ctrl = v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+					V4L2_CID_GAIN, 0, 255, 1, 128);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	ctrl = v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+					V4L2_CID_CHROMA_GAIN, 0, 255, 1, 128);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	ctrl = v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+					V4L2_CID_BLUE_BALANCE, 0, 255, 1, 122);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	ctrl = v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+					V4L2_CID_RED_BALANCE, 0, 255, 1, 122);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	sd->ctrl_handler = &state->hdl;
+	err = state->hdl.error;
+	if (err) {
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+		return err;
+	}
 
 	printk(KERN_DEBUG "wis-tw2804: creating TW2804 at address %d on %s\n",
 		client->addr, adapter->name);
@@ -319,9 +469,12 @@ static int wis_tw2804_probe(struct i2c_client *client,
 
 static int wis_tw2804_remove(struct i2c_client *client)
 {
-	struct wis_tw2804 *dec = i2c_get_clientdata(client);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct wis_tw2804 *state = to_state(sd);
 
-	kfree(dec);
+	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&state->hdl);
+	kfree(state);
 	return 0;
 }
 
@@ -355,3 +508,6 @@ module_init(wis_tw2804_init);
 module_exit(wis_tw2804_cleanup);
 
 MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("TW2804/TW2802 V4L2 i2c driver");
+MODULE_AUTHOR("Volokh Konstantin <volokh84@gmail.com>");
+MODULE_AUTHOR("Micronas USA Inc");
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 7395c81..5395495 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -113,6 +113,10 @@ enum {
 	/* module vp27smpx: just ident 2700 */
 	V4L2_IDENT_VP27SMPX = 2700,
 
+	/* module wis-tw2804: 2802/2804 */
+	V4L2_IDENT_TW2802 = 2802,
+	V4L2_IDENT_TW2804 = 2804,
+
 	/* module vpx3220: reserved range: 3210-3229 */
 	V4L2_IDENT_VPX3214C = 3214,
 	V4L2_IDENT_VPX3216B = 3216,
-- 
1.7.7.6

