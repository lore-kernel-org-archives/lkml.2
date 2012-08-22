Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab2HVHHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:07:32 -0400
Received: from mail.telros.ru ([83.136.244.21]:63034 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab2HVHHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:07:08 -0400
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, volokh@telros.ru
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 10/10] staging: media: go7007: some i2c initialization
Date: Wed, 22 Aug 2012 14:45:19 +0400
Message-Id: <1345632319-23224-10-git-send-email-volokh84@gmail.com>
In-Reply-To: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
References: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c initialization via struct item
as tw2804 have 0x00 i2c address, so need to use I2C_CLIENT_TEN
  flag for validity

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-driver.c |   20 ++++++++++++--------
 drivers/staging/media/go7007/go7007-priv.h   |    2 +-
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index c0ea312..2dff9b5 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -197,17 +197,23 @@ int go7007_reset_encoder(struct go7007 *go)
 /*
  * Attempt to instantiate an I2C client by ID, probably loading a module.
  */
-static int init_i2c_module(struct i2c_adapter *adapter, const char *type,
-			   int addr)
+static int init_i2c_module(struct i2c_adapter *adapter, const struct go_i2c *const i2c)
 {
 	struct go7007 *go = i2c_get_adapdata(adapter);
 	struct v4l2_device *v4l2_dev = &go->v4l2_dev;
+	struct i2c_board_info info;
 
-	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, type, addr, NULL))
+	memset(&info, 0, sizeof(info));
+	strlcpy(info.type, i2c->type, sizeof(info.type));
+	info.addr = i2c->addr;
+
+	if (i2c->id == I2C_DRIVERID_WIS_TW2804)
+		info.flags |= I2C_CLIENT_TEN;
+	if (v4l2_i2c_new_subdev_board(v4l2_dev, adapter, &info, NULL))
 		return 0;
 
-	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", type);
-	return -1;
+	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", i2c->type);
+	return -EINVAL;
 }
 
 /*
@@ -243,9 +249,7 @@ int go7007_register_encoder(struct go7007 *go)
 	}
 	if (go->i2c_adapter_online) {
 		for (i = 0; i < go->board_info->num_i2c_devs; ++i)
-			init_i2c_module(&go->i2c_adapter,
-					go->board_info->i2c_devs[i].type,
-					go->board_info->i2c_devs[i].addr);
+			init_i2c_module(&go->i2c_adapter, &go->board_info->i2c_devs[i]);
 		if (go->board_id == GO7007_BOARDID_ADLINK_MPG24)
 			i2c_clients_command(&go->i2c_adapter,
 				DECODER_SET_CHANNEL, &go->channel_number);
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index b58c394..b7b939a 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -88,7 +88,7 @@ struct go7007_board_info {
 	int audio_bclk_div;
 	int audio_main_div;
 	int num_i2c_devs;
-	struct {
+	struct go_i2c {
 		const char *type;
 		int id;
 		int addr;
-- 
1.7.7.6

