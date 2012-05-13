Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2EMSz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 14:55:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38592 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab2EMSzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 14:55:25 -0400
From: Volokh Konstantin <volokh84@gmail.com>
To: my84@bk.ru
Cc: volokh84@gmail.com, mchehab@infradead.org, gregkh@linuxfoundation.org,
        dhowells@redhat.com, rdunlap@xenotime.net, justinmattock@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, hverkuil@xs4all.nl
Subject: [PATCH 1/2] staging: media: go7007: Adlink MPG24 board
Date: Sun, 13 May 2012 22:52:41 +0400
Message-Id: <1336935162-5068-1-git-send-email-volokh84@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies only for Adlink MPG24 board with go7007, all these changes were tested for continuous loading & restarting modes

This is minimal changes needed for start up go7007 to work correctly
  in 3.4 branch

Changes:
  - When go7007 reset device, i2c was not working (need rewrite GPIO5)
  - As wis2804 has i2c_addr=0x00/*really*/, so Need set I2C_CLIENT_TEN flag for validity
  - some main nonzero initialization, rewrites with kzalloc instead kmalloc
  - STATUS_SHUTDOWN was placed in incorrect place, so if firmware wasn`t loaded, we
    failed v4l2_device_unregister with kernel panic (OOPS)
  - some new v4l2 style features as call_all(...s_stream...) for using subdev calls

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/README          |   22 +++++++++++++++++++++
 drivers/staging/media/go7007/go7007-driver.c |   27 +++++++++++++++++--------
 drivers/staging/media/go7007/go7007-priv.h   |    2 +-
 drivers/staging/media/go7007/go7007-usb.c    |    5 +---
 drivers/staging/media/go7007/go7007-v4l2.c   |    7 ++++-
 5 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/media/go7007/README b/drivers/staging/media/go7007/README
index 48f4476..22544a7 100644
--- a/drivers/staging/media/go7007/README
+++ b/drivers/staging/media/go7007/README
@@ -5,6 +5,28 @@ Todo:
 	  and added to the build.
 	- testing?
 	- handle churn in v4l layer.
+	- Some features for wis-tw2804 subdev control (comb filter,coring,IF comp,peak,more over...)
+	- Cropping&Scaling on tw2804
+	- Motion detector on tw2804, spatial&temporal sensitivity & masks control,velocity
+	- Control Output Format on tw2804
+	- go7007-v4l2.c need rewrite with new v4l2 style without nonstandard IO controls (set detector & bitrate)
+
+05/05/2012 3.4.0-rc+:
+Changes:
+	- When go7007 reset device, i2c was not working (need rewrite GPIO5)
+	- As wis2804 has i2c_addr=0x00/*really*/, so need to set I2C_CLIENT_TEN flag for validity
+	- Some main nonzero initialization, rewrites with kzalloc instead kmalloc
+	- STATUS_SHUTDOWN was placed in incorrect place, so if firmware wasn`t loaded, we
+		failed v4l2_device_unregister with kernel panic (OOPS)
+	- Some new v4l2 style features as call_all(...s_stream...) for using subdev calls
+	- wis-tw2804.ko module code was incompatible with 3.4.x branch in initialization v4l2_subdev parts.
+		now i2c_get_clientdata(...) contains v4l2_subdev struct instead non standard wis_tw2804 struct
+
+Adds:
+	- Switch between 2 composite video inputs on channel: VIN[1,2,3,4]A and VIN[1,2,3,4]B
+	- Additional chipset wis2804 controls with: gain,auto gain,inputs[0,1],color kill,chroma gain,gain balances,
+		for all 4 channels (from tw2804.pdf)
+	- Power control for each 4 ADC up when s_stream(...,1), down otherwise in wis-tw2804 module
 
 Please send patchs to Greg Kroah-Hartman <greg@kroah.com> and Cc: Ross
 Cohen <rcohen@snurgle.org> as well.
diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index ece2dd1..2dff9b5 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -173,6 +173,11 @@ static int go7007_init_encoder(struct go7007 *go)
 		go7007_write_addr(go, 0x3c82, 0x0001);
 		go7007_write_addr(go, 0x3c80, 0x00fe);
 	}
+	if (go->board_id == GO7007_BOARDID_ADLINK_MPG24) {
+		/* set GPIO5 to be an output, currently low */
+		go7007_write_addr(go, 0x3c82, 0x0000);
+		go7007_write_addr(go, 0x3c80, 0x00df);
+	}
 	return 0;
 }
 
@@ -192,17 +197,23 @@ int go7007_reset_encoder(struct go7007 *go)
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
+
+	memset(&info, 0, sizeof(info));
+	strlcpy(info.type, i2c->type, sizeof(info.type));
+	info.addr = i2c->addr;
 
-	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, type, addr, NULL))
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
@@ -238,9 +249,7 @@ int go7007_register_encoder(struct go7007 *go)
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
@@ -571,7 +580,7 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	struct go7007 *go;
 	int i;
 
-	go = kmalloc(sizeof(struct go7007), GFP_KERNEL);
+	go = kzalloc(sizeof(struct go7007), GFP_KERNEL);
 	if (go == NULL)
 		return NULL;
 	go->dev = dev;
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
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 5443e25..9dbf5ec 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1110,9 +1110,6 @@ static int go7007_usb_probe(struct usb_interface *intf,
 			} else {
 				u16 channel;
 
-				/* set GPIO5 to be an output, currently low */
-				go7007_write_addr(go, 0x3c82, 0x0000);
-				go7007_write_addr(go, 0x3c80, 0x00df);
 				/* read channel number from GPIO[1:0] */
 				go7007_read_addr(go, 0x3c81, &channel);
 				channel &= 0x3;
@@ -1245,7 +1242,6 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 	struct urb *vurb, *aurb;
 	int i;
 
-	go->status = STATUS_SHUTDOWN;
 	usb_kill_urb(usb->intr_urb);
 
 	/* Free USB-related structs */
@@ -1269,6 +1265,7 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 	kfree(go->hpi_context);
 
 	go7007_remove(go);
+	go->status = STATUS_SHUTDOWN;
 }
 
 static struct usb_driver go7007_usb_driver = {
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 3ef4cd8..e31b338 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -100,7 +100,7 @@ static int go7007_open(struct file *file)
 
 	if (go->status != STATUS_ONLINE)
 		return -EBUSY;
-	gofh = kmalloc(sizeof(struct go7007_file), GFP_KERNEL);
+	gofh = kzalloc(sizeof(struct go7007_file), GFP_KERNEL);
 	if (gofh == NULL)
 		return -ENOMEM;
 	++go->ref_count;
@@ -955,6 +955,7 @@ static int vidioc_streamon(struct file *file, void *priv,
 	}
 	mutex_unlock(&go->hw_lock);
 	mutex_unlock(&gofh->lock);
+	call_all(&go->v4l2_dev, video, s_stream, 1);
 
 	return retval;
 }
@@ -970,6 +971,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	mutex_lock(&gofh->lock);
 	go7007_streamoff(go);
 	mutex_unlock(&gofh->lock);
+	call_all(&go->v4l2_dev, video, s_stream, 0);
 
 	return 0;
 }
@@ -1834,5 +1836,6 @@ void go7007_v4l2_remove(struct go7007 *go)
 	mutex_unlock(&go->hw_lock);
 	if (go->video_dev)
 		video_unregister_device(go->video_dev);
-	v4l2_device_unregister(&go->v4l2_dev);
+	if (go->status != STATUS_SHUTDOWN)
+		v4l2_device_unregister(&go->v4l2_dev);
 }
-- 
1.7.7.6

