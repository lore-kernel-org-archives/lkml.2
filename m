Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab1DGPqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:46:16 -0400
Received: from smtp206.alice.it ([82.57.200.102]:58942 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab1DGPqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:46:12 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Steven Toth <stoth@kernellabs.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Drew Fisher <drew.m.fisher@gmail.com>,
        OpenKinect <openkinect@googlegroups.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] gspca: add a subdriver for the Microsoft Kinect sensor device
Date: Thu,  7 Apr 2011 17:45:52 +0200
Message-Id: <1302191152-7218-3-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302191152-7218-1-git-send-email-ospite@studenti.unina.it>
References: <1302191152-7218-1-git-send-email-ospite@studenti.unina.it>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kinect sensor is a device used by Microsoft for its Kinect project,
which is a system for controller-less Human-Computer interaction
targeted for Xbox 360.

In the Kinect device, RGBD data is captured from two distinct sensors: a
regular RGB sensor and a monochrome sensor which, with the aid of a IR
structured light, captures what is finally exposed as a depth map; so
what we have is basically a Structured-light 3D scanner.

The Kinect gspca subdriver just supports the video stream for now,
exposing the output from the RGB sensor or the unprocessed output from
the monochrome sensor; it does not deal with the processed depth stream
yet, but it allows using the sensor as a Webcam or as an IR camera (an
external source of IR light might be needed for this use).

The low level implementation is based on code from the OpenKinect
project (http://openkinect.org).

Cc: Steven Toth <stoth@kernellabs.com>
Cc: OpenKinect <openkinect@googlegroups.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/video/gspca/Kconfig  |    9 +
 drivers/media/video/gspca/Makefile |    2 +
 drivers/media/video/gspca/kinect.c |  427 ++++++++++++++++++++++++++++++++++++
 3 files changed, 438 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/gspca/kinect.c

diff --git a/drivers/media/video/gspca/Kconfig b/drivers/media/video/gspca/Kconfig
index eb04e8b..34ae2c2 100644
--- a/drivers/media/video/gspca/Kconfig
+++ b/drivers/media/video/gspca/Kconfig
@@ -77,6 +77,15 @@ config USB_GSPCA_JEILINJ
 	  To compile this driver as a module, choose M here: the
 	  module will be called gspca_jeilinj.
 
+config USB_GSPCA_KINECT
+	tristate "Kinect sensor device USB Camera Driver"
+	depends on VIDEO_V4L2 && USB_GSPCA
+	help
+	  Say Y here if you want support for the Microsoft Kinect sensor device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_kinect.
+
 config USB_GSPCA_KONICA
 	tristate "Konica USB Camera V4L2 driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
diff --git a/drivers/media/video/gspca/Makefile b/drivers/media/video/gspca/Makefile
index 855fbc8..802fbe1 100644
--- a/drivers/media/video/gspca/Makefile
+++ b/drivers/media/video/gspca/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_USB_GSPCA_CPIA1)    += gspca_cpia1.o
 obj-$(CONFIG_USB_GSPCA_ETOMS)    += gspca_etoms.o
 obj-$(CONFIG_USB_GSPCA_FINEPIX)  += gspca_finepix.o
 obj-$(CONFIG_USB_GSPCA_JEILINJ)  += gspca_jeilinj.o
+obj-$(CONFIG_USB_GSPCA_KINECT)   += gspca_kinect.o
 obj-$(CONFIG_USB_GSPCA_KONICA)   += gspca_konica.o
 obj-$(CONFIG_USB_GSPCA_MARS)     += gspca_mars.o
 obj-$(CONFIG_USB_GSPCA_MR97310A) += gspca_mr97310a.o
@@ -46,6 +47,7 @@ gspca_cpia1-objs    := cpia1.o
 gspca_etoms-objs    := etoms.o
 gspca_finepix-objs  := finepix.o
 gspca_jeilinj-objs  := jeilinj.o
+gspca_kinect-objs   := kinect.o
 gspca_konica-objs   := konica.o
 gspca_mars-objs     := mars.o
 gspca_mr97310a-objs := mr97310a.o
diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/gspca/kinect.c
new file mode 100644
index 0000000..f85e746
--- /dev/null
+++ b/drivers/media/video/gspca/kinect.c
@@ -0,0 +1,427 @@
+/*
+ * kinect sensor device camera, gspca driver
+ *
+ * Copyright (C) 2011  Antonio Ospite <ospite@studenti.unina.it>
+ *
+ * Based on the OpenKinect project and libfreenect
+ * http://openkinect.org/wiki/Init_Analysis
+ *
+ * Special thanks to Steven Toth and kernellabs.com for sponsoring a Kinect
+ * sensor device which I tested the driver on.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#define MODULE_NAME "kinect"
+
+#include "gspca.h"
+
+#define CTRL_TIMEOUT 500
+
+MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
+MODULE_DESCRIPTION("GSPCA/Kinect Sensor Device USB Camera Driver");
+MODULE_LICENSE("GPL");
+
+#ifdef DEBUG
+int gspca_debug = D_ERR | D_PROBE | D_CONF | D_STREAM | D_FRAM | D_PACK |
+	D_USBI | D_USBO | D_V4L2;
+#endif
+
+struct pkt_hdr {
+	uint8_t magic[2];
+	uint8_t pad;
+	uint8_t flag;
+	uint8_t unk1;
+	uint8_t seq;
+	uint8_t unk2;
+	uint8_t unk3;
+	uint32_t timestamp;
+};
+
+struct cam_hdr {
+	uint8_t magic[2];
+	uint16_t len;
+	uint16_t cmd;
+	uint16_t tag;
+};
+
+/* specific webcam descriptor */
+struct sd {
+	struct gspca_dev gspca_dev; /* !! must be the first item */
+	uint16_t cam_tag;           /* a sequence number for packets */
+	uint8_t stream_flag;        /* to identify different steram types */
+};
+
+/* V4L2 controls supported by the driver */
+/* controls prototypes here */
+
+static const struct ctrl sd_ctrls[] = {
+};
+
+#define MODE_640x480   0x0001
+#define MODE_640x488   0x0002
+#define MODE_1280x1024 0x0004
+
+#define FORMAT_BAYER   0x0010
+#define FORMAT_UYVY    0x0020
+#define FORMAT_Y10B    0x0040
+
+#define FPS_HIGH       0x0100
+
+static const struct v4l2_pix_format video_camera_mode[] = {
+	{640, 480, V4L2_PIX_FMT_SGRBG8, V4L2_FIELD_NONE,
+	 .bytesperline = 640,
+	 .sizeimage = 640 * 480,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = MODE_640x480 | FORMAT_BAYER | FPS_HIGH},
+	{640, 480, V4L2_PIX_FMT_UYVY, V4L2_FIELD_NONE,
+	 .bytesperline = 640 * 2,
+	 .sizeimage = 640 * 480 * 2,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = MODE_640x480 | FORMAT_UYVY},
+	{1280, 1024, V4L2_PIX_FMT_SGRBG8, V4L2_FIELD_NONE,
+	 .bytesperline = 1280,
+	 .sizeimage = 1280 * 1024,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = MODE_1280x1024 | FORMAT_BAYER},
+	{640, 488, V4L2_PIX_FMT_Y10BPACK, V4L2_FIELD_NONE,
+	 .bytesperline = 640 * 10 / 8,
+	 .sizeimage =  640 * 488 * 10 / 8,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = MODE_640x488 | FORMAT_Y10B | FPS_HIGH},
+	{1280, 1024, V4L2_PIX_FMT_Y10BPACK, V4L2_FIELD_NONE,
+	 .bytesperline = 1280 * 10 / 8,
+	 .sizeimage =  1280 * 1024 * 10 / 8,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = MODE_1280x1024 | FORMAT_Y10B},
+};
+
+static int kinect_write(struct usb_device *udev, uint8_t *data,
+			uint16_t wLength)
+{
+	return usb_control_msg(udev,
+			      usb_sndctrlpipe(udev, 0),
+			      0x00,
+			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      0, 0, data, wLength, CTRL_TIMEOUT);
+}
+
+static int kinect_read(struct usb_device *udev, uint8_t *data, uint16_t wLength)
+{
+	return usb_control_msg(udev,
+			      usb_rcvctrlpipe(udev, 0),
+			      0x00,
+			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			      0, 0, data, wLength, CTRL_TIMEOUT);
+}
+
+static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
+		unsigned int cmd_len, void *replybuf, unsigned int reply_len)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct usb_device *udev = gspca_dev->dev;
+	int res, actual_len;
+	uint8_t obuf[0x400];
+	uint8_t ibuf[0x200];
+	struct cam_hdr *chdr = (void *)obuf;
+	struct cam_hdr *rhdr = (void *)ibuf;
+
+	if (cmd_len & 1 || cmd_len > (0x400 - sizeof(*chdr))) {
+		err("send_cmd: Invalid command length (0x%x)", cmd_len);
+		return -1;
+	}
+
+	chdr->magic[0] = 0x47;
+	chdr->magic[1] = 0x4d;
+	chdr->cmd = cpu_to_le16(cmd);
+	chdr->tag = cpu_to_le16(sd->cam_tag);
+	chdr->len = cpu_to_le16(cmd_len / 2);
+
+	memcpy(obuf+sizeof(*chdr), cmdbuf, cmd_len);
+
+	res = kinect_write(udev, obuf, cmd_len + sizeof(*chdr));
+	PDEBUG(D_USBO, "Control cmd=%04x tag=%04x len=%04x: %d", cmd,
+		sd->cam_tag, cmd_len, res);
+	if (res < 0) {
+		err("send_cmd: Output control transfer failed (%d)", res);
+		return res;
+	}
+
+	do {
+		actual_len = kinect_read(udev, ibuf, 0x200);
+	} while (actual_len == 0);
+	PDEBUG(D_USBO, "Control reply: %d", res);
+	if (actual_len < sizeof(*rhdr)) {
+		err("send_cmd: Input control transfer failed (%d)", res);
+		return res;
+	}
+	actual_len -= sizeof(*rhdr);
+
+	if (rhdr->magic[0] != 0x52 || rhdr->magic[1] != 0x42) {
+		err("send_cmd: Bad magic %02x %02x", rhdr->magic[0],
+			rhdr->magic[1]);
+		return -1;
+	}
+	if (rhdr->cmd != chdr->cmd) {
+		err("send_cmd: Bad cmd %02x != %02x", rhdr->cmd, chdr->cmd);
+		return -1;
+	}
+	if (rhdr->tag != chdr->tag) {
+		err("send_cmd: Bad tag %04x != %04x", rhdr->tag, chdr->tag);
+		return -1;
+	}
+	if (cpu_to_le16(rhdr->len) != (actual_len/2)) {
+		err("send_cmd: Bad len %04x != %04x",
+				cpu_to_le16(rhdr->len), (int)(actual_len/2));
+		return -1;
+	}
+
+	if (actual_len > reply_len) {
+		warn("send_cmd: Data buffer is %d bytes long, but got %d bytes",
+				reply_len, actual_len);
+		memcpy(replybuf, ibuf+sizeof(*rhdr), reply_len);
+	} else {
+		memcpy(replybuf, ibuf+sizeof(*rhdr), actual_len);
+	}
+
+	sd->cam_tag++;
+
+	return actual_len;
+}
+
+static int write_register(struct gspca_dev *gspca_dev, uint16_t reg,
+			uint16_t data)
+{
+	uint16_t reply[2];
+	uint16_t cmd[2];
+	int res;
+
+	cmd[0] = cpu_to_le16(reg);
+	cmd[1] = cpu_to_le16(data);
+
+	PDEBUG(D_USBO, "Write Reg 0x%04x <= 0x%02x", reg, data);
+	res = send_cmd(gspca_dev, 0x03, cmd, 4, reply, 4);
+	if (res < 0)
+		return res;
+	if (res != 2) {
+		warn("send_cmd returned %d [%04x %04x], 0000 expected",
+				res, reply[0], reply[1]);
+	}
+	return 0;
+}
+
+/* this function is called at probe time */
+static int sd_config(struct gspca_dev *gspca_dev,
+		     const struct usb_device_id *id)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct cam *cam;
+
+	sd->cam_tag = 0;
+
+	/* Only color camera is supported for now,
+	 * which has stream flag = 0x80 */
+	sd->stream_flag = 0x80;
+
+	cam = &gspca_dev->cam;
+
+	cam->cam_mode = video_camera_mode;
+	cam->nmodes = ARRAY_SIZE(video_camera_mode);
+
+#if 0
+	/* Setting those values is not needed for color camera */
+	cam->npkt = 15;
+	gspca_dev->pkt_size = 960 * 2;
+#endif
+
+	return 0;
+}
+
+/* this function is called at probe and resume time */
+static int sd_init(struct gspca_dev *gspca_dev)
+{
+	PDEBUG(D_PROBE, "Kinect Camera device.");
+
+	return 0;
+}
+
+static int sd_start(struct gspca_dev *gspca_dev)
+{
+	int mode;
+	uint8_t fmt_reg, fmt_val;
+	uint8_t res_reg, res_val;
+	uint8_t fps_reg, fps_val;
+	uint8_t mode_val;
+
+	mode = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].priv;
+
+	if (mode & FORMAT_Y10B) {
+		fmt_reg = 0x19;
+		res_reg = 0x1a;
+		fps_reg = 0x1b;
+		mode_val = 0x03;
+	} else {
+		fmt_reg = 0x0c;
+		res_reg = 0x0d;
+		fps_reg = 0x0e;
+		mode_val = 0x01;
+	}
+
+	/* format */
+	if (mode & FORMAT_UYVY)
+		fmt_val = 0x05;
+	else
+		fmt_val = 0x00;
+
+	if (mode & MODE_1280x1024)
+		res_val = 0x02;
+	else
+		res_val = 0x01;
+
+	if (mode & FPS_HIGH)
+		fps_val = 0x1e;
+	else
+		fps_val = 0x0f;
+
+
+	/* turn off IR-reset function */
+	write_register(gspca_dev, 0x105, 0x00);
+
+	/* Reset video stream */
+	write_register(gspca_dev, 0x05, 0x00);
+
+	/* Due to some ridiculous condition in the firmware, we have to start
+	 * and stop the depth stream before the camera will hand us 1280x1024
+	 * IR.  This is a stupid workaround, but we've yet to find a better
+	 * solution.
+	 *
+	 * Thanks to Drew Fisher for figuring this out.
+	 */
+	if (mode & (FORMAT_Y10B | MODE_1280x1024)) {
+		write_register(gspca_dev, 0x13, 0x01);
+		write_register(gspca_dev, 0x14, 0x1e);
+		write_register(gspca_dev, 0x06, 0x02);
+		write_register(gspca_dev, 0x06, 0x00);
+	}
+
+	write_register(gspca_dev, fmt_reg, fmt_val);
+	write_register(gspca_dev, res_reg, res_val);
+	write_register(gspca_dev, fps_reg, fps_val);
+
+	/* Start video stream */
+	write_register(gspca_dev, 0x05, mode_val);
+
+	/* disable Hflip */
+	write_register(gspca_dev, 0x47, 0x00);
+
+	return 0;
+}
+
+static void sd_stopN(struct gspca_dev *gspca_dev)
+{
+	/* reset video stream */
+	write_register(gspca_dev, 0x05, 0x00);
+}
+
+static void sd_pkt_scan(struct gspca_dev *gspca_dev, u8 *__data, int len)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	struct pkt_hdr *hdr = (void *)__data;
+	uint8_t *data = __data + sizeof(*hdr);
+	int datalen = len - sizeof(*hdr);
+
+	uint8_t sof = sd->stream_flag | 1;
+	uint8_t mof = sd->stream_flag | 2;
+	uint8_t eof = sd->stream_flag | 5;
+
+	if (len < 12)
+		return;
+
+	if (hdr->magic[0] != 'R' || hdr->magic[1] != 'B') {
+		warn("[Stream %02x] Invalid magic %02x%02x", sd->stream_flag,
+				hdr->magic[0], hdr->magic[1]);
+		return;
+	}
+
+	if (hdr->flag == sof)
+		gspca_frame_add(gspca_dev, FIRST_PACKET, data, datalen);
+
+	else if (hdr->flag == mof)
+		gspca_frame_add(gspca_dev, INTER_PACKET, data, datalen);
+
+	else if (hdr->flag == eof)
+		gspca_frame_add(gspca_dev, LAST_PACKET, data, datalen);
+
+	else
+		warn("Packet type not recognized...");
+}
+
+/* sub-driver description */
+static const struct sd_desc sd_desc = {
+	.name      = MODULE_NAME,
+	.ctrls     = sd_ctrls,
+	.nctrls    = ARRAY_SIZE(sd_ctrls),
+	.config    = sd_config,
+	.init      = sd_init,
+	.start     = sd_start,
+	.stopN     = sd_stopN,
+	.pkt_scan  = sd_pkt_scan,
+	/*
+	.querymenu = sd_querymenu,
+	.get_streamparm = sd_get_streamparm,
+	.set_streamparm = sd_set_streamparm,
+	*/
+};
+
+/* -- module initialisation -- */
+static const __devinitdata struct usb_device_id device_table[] = {
+	{USB_DEVICE(0x045e, 0x02ae)},
+	{}
+};
+
+MODULE_DEVICE_TABLE(usb, device_table);
+
+/* -- device connect -- */
+static int sd_probe(struct usb_interface *intf, const struct usb_device_id *id)
+{
+	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
+				THIS_MODULE);
+}
+
+static struct usb_driver sd_driver = {
+	.name       = MODULE_NAME,
+	.id_table   = device_table,
+	.probe      = sd_probe,
+	.disconnect = gspca_disconnect,
+#ifdef CONFIG_PM
+	.suspend    = gspca_suspend,
+	.resume     = gspca_resume,
+#endif
+};
+
+/* -- module insert / remove -- */
+static int __init sd_mod_init(void)
+{
+	return usb_register(&sd_driver);
+}
+
+static void __exit sd_mod_exit(void)
+{
+	usb_deregister(&sd_driver);
+}
+
+module_init(sd_mod_init);
+module_exit(sd_mod_exit);
-- 
1.7.4.1

