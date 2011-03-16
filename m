Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1CPUGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:06:22 -0400
Received: from smtp22.services.sfr.fr ([93.17.128.12]:18067 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1CPUGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:06:16 -0400
X-SFR-UUID: 20110316200613804.C454D700008A@msfrf2212.sfr.fr
Message-ID: <4D811835.5060303@sfr.fr>
Date: Wed, 16 Mar 2011 21:06:13 +0100
From: Patrice Chotard <patrice.chotard@sfr.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH]  New Jeilin dual-mode camera support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a re-submission, my previous patch has not been send in plain text.

This patch add a new jeilin dual mode camera support and some specific controls settings.

Regards

Signed-off-by: Patrice CHOTARD <patricechotard@free.fr>
	       Theodore Kilgore <kilgota@banach.math.auburn.edu>
---
 Documentation/video4linux/gspca.txt |    1 +
 drivers/media/video/gspca/jeilinj.c |  396 ++++++++++++++++++++++++++++++-----
 2 files changed, 345 insertions(+), 52 deletions(-)

diff --git a/Documentation/video4linux/gspca.txt b/Documentation/video4linux/gspca.txt
index 261776e..c4245d2 100644
--- a/Documentation/video4linux/gspca.txt
+++ b/Documentation/video4linux/gspca.txt
@@ -265,6 +265,7 @@ pac7302		093a:2629	Genious iSlim 300
 pac7302		093a:262a	Webcam 300k
 pac7302		093a:262c	Philips SPC 230 NC
 jeilinj		0979:0280	Sakar 57379
+jeilinj		0979:0270	Sportscam DV15
 zc3xx		0ac8:0302	Z-star Vimicro zc0302
 vc032x		0ac8:0321	Vimicro generic vc0321
 vc032x		0ac8:0323	Vimicro Vc0323
diff --git a/drivers/media/video/gspca/jeilinj.c b/drivers/media/video/gspca/jeilinj.c
index 06b777f..6b14028 100644
--- a/drivers/media/video/gspca/jeilinj.c
+++ b/drivers/media/video/gspca/jeilinj.c
@@ -6,6 +6,9 @@
  *
  * Copyright (C) 2009 Theodore Kilgore
  *
+ * Sportscam DV15 support and control settings are
+ * Copyright (C) 2011 Patrice Chotard
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -24,6 +27,7 @@
 #define MODULE_NAME "jeilinj"
 
 #include <linux/workqueue.h>
+#include <linux/delay.h>
 #include <linux/slab.h>
 #include "gspca.h"
 #include "jpeg.h"
@@ -34,6 +38,7 @@ MODULE_LICENSE("GPL");
 
 /* Default timeouts, in ms */
 #define JEILINJ_CMD_TIMEOUT 500
+#define JEILINJ_CMD_DELAY 160
 #define JEILINJ_DATA_TIMEOUT 1000
 
 /* Maximum transfer size to use. */
@@ -41,6 +46,18 @@ MODULE_LICENSE("GPL");
 
 #define FRAME_HEADER_LEN 0x10
 
+enum {
+	SAKAR_57379,
+	SPORTSCAM_DV15,
+};
+
+#define CAMQUALITY_MIN 0	/* highest cam quality */
+#define CAMQUALITY_MAX 97	/* lowest cam quality  */
+
+#define JPEGQUALITY_MIN 35
+#define JPEGQUALITY_MAX 85
+#define JPEGQUALITY_DEF 85
+
 /* Structure to hold all of our device specific stuff */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
@@ -48,23 +65,22 @@ struct sd {
 	/* Driver stuff */
 	struct work_struct work_struct;
 	struct workqueue_struct *work_thread;
-	u8 quality;				 /* image quality */
-	u8 jpegqual;				/* webcam quality */
+	u8 camquality;			/* webcam quality */
+	u8 jpegquality;			/* jpeg quality */
 	u8 jpeg_hdr[JPEG_HDR_SZ];
+	u8 freq;
+	u8 type;
+	/* below variables are only used for SPORTSCAM_DV15 */
+	u8 autogain;
+	u8 cyan;
+	u8 magenta;
+	u8 yellow;
 };
 
-	struct jlj_command {
-		unsigned char instruction[2];
-		unsigned char ack_wanted;
-	};
-
-/* AFAICT these cameras will only do 320x240. */
-static struct v4l2_pix_format jlj_mode[] = {
-	{ 320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
-		.bytesperline = 320,
-		.sizeimage = 320 * 240,
-		.colorspace = V4L2_COLORSPACE_JPEG,
-		.priv = 0}
+struct jlj_command {
+	unsigned char instruction[2];
+	unsigned char ack_wanted;
+	unsigned char delay;
 };
 
 /*
@@ -80,7 +96,7 @@ static int jlj_write2(struct gspca_dev *gspca_dev, unsigned char *command)
 	memcpy(gspca_dev->usb_buf, command, 2);
 	retval = usb_bulk_msg(gspca_dev->dev,
 			usb_sndbulkpipe(gspca_dev->dev, 3),
-			gspca_dev->usb_buf, 2, NULL, 500);
+			gspca_dev->usb_buf, 2, NULL, JEILINJ_CMD_TIMEOUT);
 	if (retval < 0)
 		err("command write [%02x] error %d",
 				gspca_dev->usb_buf[0], retval);
@@ -94,7 +110,7 @@ static int jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
 
 	retval = usb_bulk_msg(gspca_dev->dev,
 	usb_rcvbulkpipe(gspca_dev->dev, 0x84),
-				gspca_dev->usb_buf, 1, NULL, 500);
+			gspca_dev->usb_buf, 1, NULL, JEILINJ_CMD_TIMEOUT);
 	response = gspca_dev->usb_buf[0];
 	if (retval < 0)
 		err("read command [%02x] error %d",
@@ -102,49 +118,282 @@ static int jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
 	return retval;
 }
 
+static void setfreq(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct jlj_command freq_commands[] = {
+		{{0x71, 0x80}, 0, 0},
+		{{0x70, 0x07}, 0, 0}
+	};
+
+	if (sd->freq)
+		freq_commands[0].instruction[1] & (sd->freq >> 1);
+
+	jlj_write2(gspca_dev, freq_commands[0].instruction);
+	jlj_write2(gspca_dev, freq_commands[1].instruction);
+}
+
+static void setcamquality(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct jlj_command quality_commands[] = {
+		{{0x71, 0x1E}, 0, 0},
+		{{0x70, 0x06}, 0, 0}
+	};
+	u8 jpegquality;
+	u8 temp;
+
+	quality_commands[0].instruction[1] += sd->camquality;
+
+	jlj_write2(gspca_dev, quality_commands[0].instruction);
+	jlj_write2(gspca_dev, quality_commands[1].instruction);
+
+	/* adapt quantification table to camera quality */
+	temp = ((JPEGQUALITY_MAX - JPEGQUALITY_MIN) * sd->camquality)
+		/ CAMQUALITY_MAX;
+	jpegquality = JPEGQUALITY_MAX - temp;
+	jpeg_set_qual(sd->jpeg_hdr, jpegquality);
+}
+
+static void setautogain(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct jlj_command autogain_commands[] = {
+		{{0x94, 0x02}, 0, 0},
+		{{0xcf, 0x00}, 0, 0}
+	};
+
+	autogain_commands[1].instruction[1] = (sd->autogain << 4);
+
+	jlj_write2(gspca_dev, autogain_commands[0].instruction);
+	jlj_write2(gspca_dev, autogain_commands[1].instruction);
+}
+
+static void setcyan(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct jlj_command setcyan_commands[] = {
+		{{0x94, 0x02}, 0, 0},
+		{{0xe6, 0x00}, 0, 0}
+	};
+
+	setcyan_commands[1].instruction[1] = sd->cyan;
+
+	jlj_write2(gspca_dev, setcyan_commands[0].instruction);
+	jlj_write2(gspca_dev, setcyan_commands[1].instruction);
+}
+
+static void setmagenta(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct jlj_command setmagenta_commands[] = {
+		{{0x94, 0x02}, 0, 0},
+		{{0xe7, 0x00}, 0, 0}
+	};
+
+	setmagenta_commands[1].instruction[1] = sd->magenta;
+
+	jlj_write2(gspca_dev, setmagenta_commands[0].instruction);
+	jlj_write2(gspca_dev, setmagenta_commands[1].instruction);
+}
+
+static void setyellow(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct jlj_command setyellow_commands[] = {
+		{{0x94, 0x02}, 0, 0},
+		{{0xe9, 0x00}, 0, 0}
+	};
+
+	setyellow_commands[1].instruction[1] = sd->yellow;
+
+	jlj_write2(gspca_dev, setyellow_commands[0].instruction);
+	jlj_write2(gspca_dev, setyellow_commands[1].instruction);
+}
+
+/* Functions to get and set a control value */
+#define SD_SETGET(thename) \
+static int sd_set##thename(struct gspca_dev *gspca_dev, s32 val)\
+{\
+	struct sd *sd = (struct sd *) gspca_dev;\
+\
+	sd->thename = val;\
+	if (gspca_dev->streaming)\
+		set##thename(gspca_dev);\
+	return 0;\
+} \
+static int sd_get##thename(struct gspca_dev *gspca_dev, s32 *val)\
+{\
+	struct sd *sd = (struct sd *) gspca_dev;\
+\
+	*val = sd->thename;\
+	return 0;\
+}
+
+SD_SETGET(freq);
+SD_SETGET(camquality);
+SD_SETGET(autogain);
+SD_SETGET(cyan);
+SD_SETGET(magenta);
+SD_SETGET(yellow);
+
+static struct ctrl sd_ctrls[] = {
+	{
+	    {
+		.id      = V4L2_CID_POWER_LINE_FREQUENCY,
+		.type    = V4L2_CTRL_TYPE_MENU,
+		.name    = "Light frequency filter",
+		.minimum = V4L2_CID_POWER_LINE_FREQUENCY_DISABLED, /* 0 */
+		.maximum = V4L2_CID_POWER_LINE_FREQUENCY_60HZ, /* 2 */
+		.step    = 1,
+		.default_value = V4L2_CID_POWER_LINE_FREQUENCY_60HZ,
+	    },
+	    .set = sd_setfreq,
+	    .get = sd_getfreq,
+	},
+	{
+	    {
+		.id = V4L2_CID_AUTOGAIN,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Automatic Gain (and Exposure)",
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+#define AUTOGAIN_DEF 0
+		.default_value = AUTOGAIN_DEF,
+	   },
+	   .set = sd_setautogain,
+	   .get = sd_getautogain,
+	},
+	{
+	    {
+#define V4L2_CID_CAMQUALITY (V4L2_CID_USER_BASE + 1)
+		.id      = V4L2_CID_CAMQUALITY,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Image quality",
+		.minimum = CAMQUALITY_MIN,
+		.maximum = CAMQUALITY_MAX,
+		.step    = 1,
+#define CAMQUALITY_DEF 0
+		.default_value = CAMQUALITY_DEF,
+	    },
+	    .set = sd_setcamquality,
+	    .get = sd_getcamquality,
+	},
+	{
+	    {
+#define V4L2_CID_CYAN_BALANCE (V4L2_CID_USER_BASE + 2)
+		.id = V4L2_CID_CYAN_BALANCE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Cyan balance",
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+#define CYAN_BALANCE_DEF 2
+		.default_value = CYAN_BALANCE_DEF,
+	   },
+	   .set = sd_setcyan,
+	   .get = sd_getcyan,
+	},
+	{
+	    {
+#define V4L2_CID_MAGENTA_BALANCE (V4L2_CID_USER_BASE + 3)
+		.id = V4L2_CID_MAGENTA_BALANCE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Magenta balance",
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+#define MAGENTA_BALANCE_DEF 2
+		.default_value = MAGENTA_BALANCE_DEF,
+	   },
+	   .set = sd_setmagenta,
+	   .get = sd_getmagenta,
+	},
+	{
+	    {
+#define V4L2_CID_YELLOW_BALANCE (V4L2_CID_USER_BASE + 4)
+		.id = V4L2_CID_YELLOW_BALANCE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Yellow balance",
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+#define YELLOW_BALANCE_DEF 2
+		.default_value = YELLOW_BALANCE_DEF,
+	   },
+	   .set = sd_setyellow,
+	   .get = sd_getyellow,
+	},
+};
+
+static struct v4l2_pix_format jlj_mode[] = {
+	{ 320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
+		.bytesperline = 320,
+		.sizeimage = 320 * 240,
+		.colorspace = V4L2_COLORSPACE_JPEG,
+		.priv = 0},
+	{ 640, 480, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
+		.bytesperline = 640,
+		.sizeimage = 640 * 480,
+		.colorspace = V4L2_COLORSPACE_JPEG,
+		.priv = 0}
+};
+
 static int jlj_start(struct gspca_dev *gspca_dev)
 {
+	struct sd *sd  = (struct sd *) gspca_dev;
 	int i;
 	int retval = -1;
+	int start_commands_size;
 	u8 response = 0xff;
 	struct jlj_command start_commands[] = {
-		{{0x71, 0x81}, 0},
-		{{0x70, 0x05}, 0},
-		{{0x95, 0x70}, 1},
-		{{0x71, 0x81}, 0},
-		{{0x70, 0x04}, 0},
-		{{0x95, 0x70}, 1},
-		{{0x71, 0x00}, 0},
-		{{0x70, 0x08}, 0},
-		{{0x95, 0x70}, 1},
-		{{0x94, 0x02}, 0},
-		{{0xde, 0x24}, 0},
-		{{0x94, 0x02}, 0},
-		{{0xdd, 0xf0}, 0},
-		{{0x94, 0x02}, 0},
-		{{0xe3, 0x2c}, 0},
-		{{0x94, 0x02}, 0},
-		{{0xe4, 0x00}, 0},
-		{{0x94, 0x02}, 0},
-		{{0xe5, 0x00}, 0},
-		{{0x94, 0x02}, 0},
-		{{0xe6, 0x2c}, 0},
-		{{0x94, 0x03}, 0},
-		{{0xaa, 0x00}, 0},
-		{{0x71, 0x1e}, 0},
-		{{0x70, 0x06}, 0},
-		{{0x71, 0x80}, 0},
-		{{0x70, 0x07}, 0}
+		{{0x71, 0x81}, 0, 0},
+		{{0x70, 0x05}, 0, JEILINJ_CMD_DELAY},
+		{{0x95, 0x70}, 1, 0},
+		{{0x71, 0x81 - gspca_dev->curr_mode}, 0, 0},
+		{{0x70, 0x04}, 0, JEILINJ_CMD_DELAY},
+		{{0x95, 0x70}, 1, 0},
+		{{0x71, 0x00}, 0, 0},   /* start streaming ??*/
+		{{0x70, 0x08}, 0, JEILINJ_CMD_DELAY},
+		{{0x95, 0x70}, 1, 0},
+		{{0x94, 0x02}, 0, 0},
+		{{0xde, 0x24}, 0, 0},
+		{{0x94, 0x02}, 0, 0},
+		{{0xdd, 0xf0}, 0, 0},
+		{{0x94, 0x02}, 0, 0},
+		{{0xe3, 0x2c}, 0, 0},
+		{{0x94, 0x02}, 0, 0},
+		{{0xe4, 0x00}, 0, 0},
+		{{0x94, 0x02}, 0, 0},
+		{{0xe5, 0x00}, 0, 0},
+		{{0x94, 0x02}, 0, 0},
+		{{0xe6, 0x2c}, 0, 0},
+		{{0x94, 0x03}, 0, 0},
+		{{0xaa, 0x00}, 0, 0}
 	};
-	for (i = 0; i < ARRAY_SIZE(start_commands); i++) {
+
+	/* Under Windows, USB spy shows that only the 9 first start
+	 * commands are used for SPORTSCAM_DV15 webcam
+	 */
+	if (sd->type == SPORTSCAM_DV15)
+		start_commands_size = 9;
+	else
+		start_commands_size = ARRAY_SIZE(start_commands);
+
+	for (i = 0; i < start_commands_size; i++) {
 		retval = jlj_write2(gspca_dev, start_commands[i].instruction);
 		if (retval < 0)
 			return retval;
+		if (start_commands[i].delay)
+			mdelay(start_commands[i].delay);
 		if (start_commands[i].ack_wanted)
 			retval = jlj_read1(gspca_dev, response);
 		if (retval < 0)
 			return retval;
 	}
+	setcamquality(gspca_dev);
+	setfreq(gspca_dev);
 	PDEBUG(D_ERR, "jlj_start retval is %d", retval);
 	return retval;
 }
@@ -256,13 +505,15 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	struct cam *cam = &gspca_dev->cam;
 	struct sd *dev  = (struct sd *) gspca_dev;
 
-	dev->quality  = 85;
-	dev->jpegqual = 85;
+	dev->type = id->driver_info;
+	dev->camquality = CAMQUALITY_DEF;
+	dev->jpegquality = JPEGQUALITY_DEF;
+	dev->freq = V4L2_CID_POWER_LINE_FREQUENCY_60HZ;
 	PDEBUG(D_PROBE,
 		"JEILINJ camera detected"
 		" (vid/pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
 	cam->cam_mode = jlj_mode;
-	cam->nmodes = 1;
+	cam->nmodes = ARRAY_SIZE(jlj_mode);
 	cam->bulk = 1;
 	/* We don't use the buffer gspca allocates so make it small. */
 	cam->bulk_size = 32;
@@ -299,8 +550,10 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	/* create the JPEG header */
 	jpeg_define(dev->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x21);          /* JPEG 422 */
-	jpeg_set_qual(dev->jpeg_hdr, dev->quality);
-	PDEBUG(D_STREAM, "Start streaming at 320x240");
+	dev->jpegquality = JPEGQUALITY_DEF;
+	jpeg_set_qual(dev->jpeg_hdr, dev->jpegquality);
+	PDEBUG(D_STREAM, "Start streaming at %dx%d",
+			gspca_dev->width, gspca_dev->height);
 	ret = jlj_start(gspca_dev);
 	if (ret < 0) {
 		PDEBUG(D_ERR, "Start streaming command failed");
@@ -315,14 +568,36 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 /* Table of supported USB devices */
 static const struct usb_device_id device_table[] = {
-	{USB_DEVICE(0x0979, 0x0280)},
+	{USB_DEVICE(0x0979, 0x0280), .driver_info = SAKAR_57379},
+	{USB_DEVICE(0x0979, 0x0270), .driver_info = SPORTSCAM_DV15},
 	{}
 };
 
 MODULE_DEVICE_TABLE(usb, device_table);
 
+static int sd_querymenu(struct gspca_dev *gspca_dev,
+			struct v4l2_querymenu *menu)
+{
+	switch (menu->id) {
+	case V4L2_CID_POWER_LINE_FREQUENCY:
+		switch (menu->index) {
+		case 0:	/* V4L2_CID_POWER_LINE_FREQUENCY_DISABLED */
+			strcpy((char *) menu->name, "NoFliker");
+			return 0;
+		case 1:	/* V4L2_CID_POWER_LINE_FREQUENCY_50HZ */
+			strcpy((char *) menu->name, "50 Hz");
+			return 0;
+		case 2:	/* V4L2_CID_POWER_LINE_FREQUENCY_60HZ */
+			strcpy((char *) menu->name, "60 Hz");
+			return 0;
+		}
+		break;
+	}
+	return -EINVAL;
+}
+
 /* sub-driver description */
-static const struct sd_desc sd_desc = {
+static const struct sd_desc sd_desc_sakar_57379 = {
 	.name   = MODULE_NAME,
 	.config = sd_config,
 	.init   = sd_init,
@@ -330,12 +605,29 @@ static const struct sd_desc sd_desc = {
 	.stop0  = sd_stop0,
 };
 
+/* sub-driver description */
+static const struct sd_desc sd_desc_sportscam_dv15 = {
+	.name   = MODULE_NAME,
+	.config = sd_config,
+	.init   = sd_init,
+	.start  = sd_start,
+	.stop0  = sd_stop0,
+	.ctrls = sd_ctrls,
+	.nctrls = ARRAY_SIZE(sd_ctrls),
+	.querymenu = sd_querymenu,
+};
+
+static const struct sd_desc *sd_desc[2] = {
+	&sd_desc_sakar_57379,
+	&sd_desc_sportscam_dv15
+};
+
 /* -- device connect -- */
 static int sd_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
 	return gspca_dev_probe(intf, id,
-			&sd_desc,
+			sd_desc[id->driver_info],
 			sizeof(struct sd),
 			THIS_MODULE);
 }
-- 
1.7.0.4


