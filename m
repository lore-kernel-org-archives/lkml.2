Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab1CQXca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:32:30 -0400
Received: from smtp23.services.sfr.fr ([93.17.128.19]:41750 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab1CQXc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:32:28 -0400
X-SFR-UUID: 20110317233223136.213FB700008F@msfrf2304.sfr.fr
Message-ID: <4D829A08.7070906@sfr.fr>
Date: Fri, 18 Mar 2011 00:32:24 +0100
From: Patrice Chotard <patrice.chotard@sfr.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  New Jeilin dual-mode camera support
References: <4D811835.5060303@sfr.fr> <20110317112835.2247810d@tele>
In-Reply-To: <20110317112835.2247810d@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17/03/2011 11:28, Jean-Francois Moine a écrit :
> 
> On Wed, 16 Mar 2011 21:06:13 +0100
> Patrice Chotard <patrice.chotard@sfr.fr> wrote:
> 
>> This patch add a new jeilin dual mode camera support and some
>> specific controls settings.
> 
> Hi Patrice and Theodore,
> 
> Here are somme comments about Patrice's patch.
> 
>>  #include <linux/workqueue.h>
>> +#include <linux/delay.h>
>>  #include <linux/slab.h>
> 
> It is not a good idea to use mdelay(): it is a loop. Better use
> msleep().
> 
>> -	u8 quality;			/* image quality */
>> -	u8 jpegqual;			/* webcam quality */
>> +	u8 camquality;			/* webcam quality */
>> +	u8 jpegquality;			/* jpeg quality */
> 
> The webcam (encoding) quality and the jpeg (decoding) quality must be
> the same. Then, looking carefully, jpegquality is not used!
> 
>> +	u8 freq;
>> +	u8 type;
>> +	/* below variables are only used for SPORTSCAM_DV15 */
>> +	u8 autogain;
>> +	u8 cyan;
>> +	u8 magenta;
>> +	u8 yellow;
> 
> You should use the new control mechanism (see stk014, sonixj, zc3xx...).
> 
>> +#define V4L2_CID_CAMQUALITY (V4L2_CID_USER_BASE + 1)
>> +		.id      = V4L2_CID_CAMQUALITY,
>> +		.type    = V4L2_CTRL_TYPE_INTEGER,
>> +		.name    = "Image quality",
> 
> The JPEG quality must be get/set by the VIDIOC_G_JPEGCOMP /
> VIDIOC_S_JPEGCOMP ioctl's.
> 
>> +#define V4L2_CID_CYAN_BALANCE (V4L2_CID_USER_BASE + 2)
> 	[snip]
>> +#define V4L2_CID_MAGENTA_BALANCE (V4L2_CID_USER_BASE + 3)
> 	[snip]
>> +#define V4L2_CID_YELLOW_BALANCE (V4L2_CID_USER_BASE + 4)
> 
> These values redefine V4L2_CID_SATURATION and V4L2_CID_HUE (user_base +
> 4 is no more defined). You should use V4L2_CID_RED_BALANCE,
> V4L2_CID_BLUE_BALANCE and V4L2_CID_GAIN to set these controls.
> 
>> +	if (sd->type == SPORTSCAM_DV15)
>> +		start_commands_size = 9;
>> +	else
>> +		start_commands_size = ARRAY_SIZE(start_commands);
> 
> Don't use magic values ('9').
> 
>> +			mdelay(start_commands[i].delay);
> 
> See above.
> 
> BTW, Theodore, as there is no USB command in the loop, there is no need
> to have a work queue (look at the SENSOR_OV772x in ov534).
> 
> Best regards.
> 

Hi,

Following Jean Francois's remark, here is a new version of my previous patch
for a new jeilin dual mode camera support with specific control settings.

Regards.

Signed-off-by: Patrice CHOTARD <patricechotard@free.fr>
Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>
---
 Documentation/video4linux/gspca.txt |    1 +
 drivers/media/video/gspca/jeilinj.c |  405 ++++++++++++++++++++++++++++++-----
 2 files changed, 354 insertions(+), 52 deletions(-)

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
index 06b777f..b417589 100644
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
@@ -34,6 +37,7 @@ MODULE_LICENSE("GPL");
 
 /* Default timeouts, in ms */
 #define JEILINJ_CMD_TIMEOUT 500
+#define JEILINJ_CMD_DELAY 160
 #define JEILINJ_DATA_TIMEOUT 1000
 
 /* Maximum transfer size to use. */
@@ -41,30 +45,40 @@ MODULE_LICENSE("GPL");
 
 #define FRAME_HEADER_LEN 0x10
 
+enum {
+	SAKAR_57379,
+	SPORTSCAM_DV15,
+};
+
+#define CAMQUALITY_MIN 0	/* highest cam quality */
+#define CAMQUALITY_MAX 97	/* lowest cam quality  */
+#define SPORTSCAM_DV15_CMD_SIZE 9
+
 /* Structure to hold all of our device specific stuff */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
-	const struct v4l2_pix_format *cap_mode;
 	/* Driver stuff */
 	struct work_struct work_struct;
 	struct workqueue_struct *work_thread;
-	u8 quality;				 /* image quality */
-	u8 jpegqual;				/* webcam quality */
+	u8 quality;
+#define QUALITY_MIN 35
+#define QUALITY_MAX 85
+#define QUALITY_DEF 85
+
 	u8 jpeg_hdr[JPEG_HDR_SZ];
+	u8 freq;
+	u8 type;
+	/* below variables are only used for SPORTSCAM_DV15 */
+	u8 autogain;
+	u8 blue;
+	u8 green;
+	u8 red;
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
@@ -80,7 +94,7 @@ static int jlj_write2(struct gspca_dev *gspca_dev, unsigned char *command)
 	memcpy(gspca_dev->usb_buf, command, 2);
 	retval = usb_bulk_msg(gspca_dev->dev,
 			usb_sndbulkpipe(gspca_dev->dev, 3),
-			gspca_dev->usb_buf, 2, NULL, 500);
+			gspca_dev->usb_buf, 2, NULL, JEILINJ_CMD_TIMEOUT);
 	if (retval < 0)
 		err("command write [%02x] error %d",
 				gspca_dev->usb_buf[0], retval);
@@ -94,7 +108,7 @@ static int jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
 
 	retval = usb_bulk_msg(gspca_dev->dev,
 	usb_rcvbulkpipe(gspca_dev->dev, 0x84),
-				gspca_dev->usb_buf, 1, NULL, 500);
+			gspca_dev->usb_buf, 1, NULL, JEILINJ_CMD_TIMEOUT);
 	response = gspca_dev->usb_buf[0];
 	if (retval < 0)
 		err("read command [%02x] error %d",
@@ -102,49 +116,259 @@ static int jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
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
+	u8 camquality;
+
+	/* adapt camera quality from jpeg quality */
+	camquality = ((QUALITY_MAX - sd->quality) * CAMQUALITY_MAX)
+		/ (QUALITY_MAX - QUALITY_MIN);
+	quality_commands[0].instruction[1] += camquality;
+
+	jlj_write2(gspca_dev, quality_commands[0].instruction);
+	jlj_write2(gspca_dev, quality_commands[1].instruction);
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
+static void setred(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct jlj_command setred_commands[] = {
+		{{0x94, 0x02}, 0, 0},
+		{{0xe6, 0x00}, 0, 0}
+	};
+
+	setred_commands[1].instruction[1] = sd->red;
+
+	jlj_write2(gspca_dev, setred_commands[0].instruction);
+	jlj_write2(gspca_dev, setred_commands[1].instruction);
+}
+
+static void setgreen(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct jlj_command setgreen_commands[] = {
+		{{0x94, 0x02}, 0, 0},
+		{{0xe7, 0x00}, 0, 0}
+	};
+
+	setgreen_commands[1].instruction[1] = sd->green;
+
+	jlj_write2(gspca_dev, setgreen_commands[0].instruction);
+	jlj_write2(gspca_dev, setgreen_commands[1].instruction);
+}
+
+static void setblue(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct jlj_command setblue_commands[] = {
+		{{0x94, 0x02}, 0, 0},
+		{{0xe9, 0x00}, 0, 0}
+	};
+
+	setblue_commands[1].instruction[1] = sd->blue;
+
+	jlj_write2(gspca_dev, setblue_commands[0].instruction);
+	jlj_write2(gspca_dev, setblue_commands[1].instruction);
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
+SD_SETGET(autogain);
+SD_SETGET(blue);
+SD_SETGET(green);
+SD_SETGET(red);
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
+		.id = V4L2_CID_BLUE_BALANCE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "blue balance",
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+#define BLUE_BALANCE_DEF 2
+		.default_value = BLUE_BALANCE_DEF,
+	   },
+	   .set = sd_setblue,
+	   .get = sd_getblue,
+	},
+	{
+	    {
+		.id = V4L2_CID_GAIN,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "green balance",
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+#define GREEN_BALANCE_DEF 2
+		.default_value = GREEN_BALANCE_DEF,
+	   },
+	   .set = sd_setgreen,
+	   .get = sd_getgreen,
+	},
+	{
+	    {
+		.id = V4L2_CID_RED_BALANCE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "red balance",
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+#define RED_BALANCE_DEF 2
+		.default_value = RED_BALANCE_DEF,
+	   },
+	   .set = sd_setred,
+	   .get = sd_getred,
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
+		start_commands_size = SPORTSCAM_DV15_CMD_SIZE;
+	else
+		start_commands_size = ARRAY_SIZE(start_commands);
+
+	for (i = 0; i < start_commands_size; i++) {
 		retval = jlj_write2(gspca_dev, start_commands[i].instruction);
 		if (retval < 0)
 			return retval;
+		if (start_commands[i].delay)
+			msleep(start_commands[i].delay);
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
@@ -256,13 +480,17 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	struct cam *cam = &gspca_dev->cam;
 	struct sd *dev  = (struct sd *) gspca_dev;
 
-	dev->quality  = 85;
-	dev->jpegqual = 85;
+	dev->type = id->driver_info;
+	dev->quality = QUALITY_DEF;
+	dev->freq = V4L2_CID_POWER_LINE_FREQUENCY_60HZ;
+	dev->red = RED_BALANCE_DEF;
+	dev->blue = BLUE_BALANCE_DEF;
+	dev->green = GREEN_BALANCE_DEF;
 	PDEBUG(D_PROBE,
 		"JEILINJ camera detected"
 		" (vid/pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
 	cam->cam_mode = jlj_mode;
-	cam->nmodes = 1;
+	cam->nmodes = ARRAY_SIZE(jlj_mode);
 	cam->bulk = 1;
 	/* We don't use the buffer gspca allocates so make it small. */
 	cam->bulk_size = 32;
@@ -300,7 +528,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	jpeg_define(dev->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x21);          /* JPEG 422 */
 	jpeg_set_qual(dev->jpeg_hdr, dev->quality);
-	PDEBUG(D_STREAM, "Start streaming at 320x240");
+	PDEBUG(D_STREAM, "Start streaming at %dx%d",
+			gspca_dev->width, gspca_dev->height);
 	ret = jlj_start(gspca_dev);
 	if (ret < 0) {
 		PDEBUG(D_ERR, "Start streaming command failed");
@@ -315,14 +544,67 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
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
+static int sd_set_jcomp(struct gspca_dev *gspca_dev,
+			struct v4l2_jpegcompression *jcomp)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (jcomp->quality < QUALITY_MIN)
+		sd->quality = QUALITY_MIN;
+	else if (jcomp->quality > QUALITY_MAX)
+		sd->quality = QUALITY_MAX;
+	else
+		sd->quality = jcomp->quality;
+	if (gspca_dev->streaming) {
+		jpeg_set_qual(sd->jpeg_hdr, sd->quality);
+		setcamquality(gspca_dev);
+	}
+	return 0;
+}
+
+static int sd_get_jcomp(struct gspca_dev *gspca_dev,
+			struct v4l2_jpegcompression *jcomp)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	memset(jcomp, 0, sizeof *jcomp);
+	jcomp->quality = sd->quality;
+	jcomp->jpeg_markers = V4L2_JPEG_MARKER_DHT
+			| V4L2_JPEG_MARKER_DQT;
+	return 0;
+}
+
+
 /* sub-driver description */
-static const struct sd_desc sd_desc = {
+static const struct sd_desc sd_desc_sakar_57379 = {
 	.name   = MODULE_NAME,
 	.config = sd_config,
 	.init   = sd_init,
@@ -330,12 +612,31 @@ static const struct sd_desc sd_desc = {
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
+	.get_jcomp = sd_get_jcomp,
+	.set_jcomp = sd_set_jcomp,
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





