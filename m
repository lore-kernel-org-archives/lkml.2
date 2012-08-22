Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab2HVHHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:07:43 -0400
Received: from mail.telros.ru ([83.136.244.21]:57996 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab2HVHHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:07:00 -0400
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, volokh@telros.ru
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 02/10] staging: media: go7007: TW2804 driver fix
Date: Wed, 22 Aug 2012 14:45:11 +0400
Message-Id: <1345632319-23224-2-git-send-email-volokh84@gmail.com>
In-Reply-To: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
References: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- correct cast private data from i2c_get_clientdata()
- initialization priv data
- destroy priv data
- using V4L2 controls framework

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/wis-tw2804.c |   72 +++++++++++++++++++++++------
 1 files changed, 57 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-tw2804.c b/drivers/staging/media/go7007/wis-tw2804.c
index 05851d3..13f0f63 100644
--- a/drivers/staging/media/go7007/wis-tw2804.c
+++ b/drivers/staging/media/go7007/wis-tw2804.c
@@ -367,10 +367,12 @@ static const struct v4l2_subdev_ops tw2804_ops = {
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
@@ -539,22 +541,59 @@ static int wis_tw2804_probe(struct i2c_client *client,
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
-		return -ENOMEM;
+	state = kzalloc(sizeof(struct wis_tw2804), GFP_KERNEL);
 
-	dec->channel = -1;
-	dec->norm = V4L2_STD_NTSC;
-	dec->brightness = 128;
-	dec->contrast = 128;
-	dec->saturation = 128;
-	dec->hue = 128;
-	i2c_set_clientdata(client, dec);
+	if (state == NULL)
+		return -ENOMEM;
+	sd = &state->sd;
+	v4l2_i2c_subdev_init(sd, client, &tw2804_ops);
+	state->channel = -1;
+	state->norm = V4L2_STD_NTSC;
+
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
@@ -564,9 +603,12 @@ static int wis_tw2804_probe(struct i2c_client *client,
 
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
 
-- 
1.7.7.6

