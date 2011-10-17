Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1JQErc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 00:47:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab1JQErb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 00:47:31 -0400
Message-ID: <4E9BB353.70606@redhat.com>
Date: Mon, 17 Oct 2011 10:17:15 +0530
From: Gopal <gtiwari@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Glenn Sommer <gsommer@datanordisk.dk>, gopal <gtiwari@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: patch for Dell ST220T Touch Screen Monitor
Content-Type: multipart/mixed;
 boundary="------------050701080200060603080805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050701080200060603080805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello Everybody,

We have recently created Support for Dell ST2220T Touch screen monitor 
with in the kernel hierarchy driver/input/touchscreen patch for this 
attach with this mail.
Please find the attachment. I have previously also send the patch didn't 
got any feedback so sending it again.

thanks
Gopal

--------------050701080200060603080805
Content-Type: text/plain;
 name="0001-We-have-created-Support-for-DELL-ST2220T-TochScreen-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-We-have-created-Support-for-DELL-ST2220T-TochScreen-.pa";
 filename*1="tch"

>From 9f4e8d811c1b9fc9552f243fb1d577b2cc67553f Mon Sep 17 00:00:00 2001
From: gopal <gtiwari@redhat.com>
Date: Tue, 9 Aug 2011 15:15:51 +0530
Subject: [PATCH] We have created Support for DELL-ST2220T TochScreen Monitor

Signed-off-by: gopal <gtiwari@redhat.com>
---
 drivers/input/touchscreen/usbtouchscreen.c |   99 +++++++++++++++++++++++++++-
 1 files changed, 98 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 73fd664..beef39f 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -59,6 +59,8 @@
 #define DRIVER_AUTHOR		"Daniel Ritz <daniel.ritz@gmx.ch>"
 #define DRIVER_DESC		"USB Touchscreen Driver"
 
+#define CONFIG_TOUCHSCREEN_USB_DELL_ST2220T
+
 static int swap_xy;
 module_param(swap_xy, bool, 0644);
 MODULE_PARM_DESC(swap_xy, "If set X and Y axes are swapped.");
@@ -138,6 +140,7 @@ enum {
 	DEVTYPE_ZYTRONIC,
 	DEVTYPE_TC45USB,
 	DEVTYPE_NEXIO,
+	DEVTYPE_DELL_ST2220T,
 };
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
@@ -238,6 +241,10 @@ static const struct usb_device_id usbtouch_devices[] = {
 	{USB_DEVICE_AND_INTERFACE_INFO(0x1870, 0x0001, 0x0a, 0x00, 0x00),
 		.driver_info = DEVTYPE_NEXIO},
 #endif
+#ifdef CONFIG_TOUCHSCREEN_USB_DELL_ST2220T
+/*Dell-st2220t*/
+{USB_DEVICE(0x1fd2, 0x0064), .driver_info = DEVTYPE_DELL_ST2220T},
+#endif
 
 	{}
 };
@@ -335,6 +342,84 @@ static int panjit_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
 }
 #endif
 
+/*****************************************************************************
+*	Dell-ST2220T
+*/
+#ifdef CONFIG_TOUCHSCREEN_USB_DELL_ST2220T
+#define ST2220T_VENDOR_REQ      0x22
+static int st2220t_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
+{
+	if (pkt[9] != 0xff && pkt[11]) {
+		dev->x = (pkt[10] << 8) | pkt[9];
+		dev->y = (pkt[12] << 8) | pkt[11];
+		dev->x =  ((dev->x) * 9) - 0x200;
+		dev->y =  (dev->y) * 15;
+		input_report_abs(dev->input, ABS_X, dev->x)
+		input_report_abs(dev->input, ABS_Y, dev->y);
+	}
+	dev->x = (pkt[4] << 8) | pkt[3];
+	dev->y = (pkt[6] << 8) | pkt[5];
+	dev->x =  ((dev->x) * 9) - 0x200;
+	dev->y =  (dev->y) * 15;
+	return 1;
+}
+
+static int st2220t_init(struct usbtouch_usb *usbtouch)
+{
+	int ret, i;
+	struct usb_device *udev = interface_to_usbdev(usbtouch->interface);
+	char *ctrl_buf;
+
+	/*Allocate Memory For Control transfer Buffer */
+
+	ctrl_buf = kmalloc(64, GFP_KERNEL);
+	if (ctrl_buf == NULL) {
+		dbg("%s - Failed : to Get Memory",
+		__func__);
+		return -1;
+	}
+
+	/* Following Control Request is Very Imp
+	To Start USB Interrupt transaction
+	this request is SET_REPORT H->D with Data as 07,02,02 */
+
+	ctrl_buf[0] = 0x07;
+	ctrl_buf[1] = 0x02;
+	ctrl_buf[2] = 0x02;
+	for (i = 0; i < 3; i++) {
+		ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x09,
+		0x21, 0x0307, 0x00, ctrl_buf,
+		0x03, USB_CTRL_SET_TIMEOUT);
+		dbg("%s - usb_control_msg - 0x21 0x09 - bytes|err: %d\n",
+		__func__, ret);
+
+		if (ret == 0)
+			break;
+		msleep(150);
+	}
+
+	if (ret < 0) {
+		dbg("%s - Failed to Initialize the DELL-ST2220 Touch Monitor\n",
+		__func__);
+		return -1;
+	}
+
+	msleep(150);
+	for (i = 0; i < 6; i++) {
+		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+		0x01, 0xA1, 0x308, 0x00, ctrl_buf, 2,
+		USB_CTRL_SET_TIMEOUT);
+
+		dbg("%s - usb_control_msg - bytes|err: %d",
+		__func__, ret);
+		dbg(" %x %x\n", ctrl_buf[0], ctrl_buf[1]);
+		msleep(50);
+	}
+
+	kfree(ctrl_buf);
+	return 0;
+}
+#endif
 
 /*****************************************************************************
  * 3M/Microtouch Part
@@ -1139,8 +1224,20 @@ static struct usbtouch_device_info usbtouch_dev_info[] = {
 		.exit		= nexio_exit,
 	},
 #endif
-};
 
+#ifdef CONFIG_TOUCHSCREEN_USB_DELL_ST2220T
+
+	[DEVTYPE_DELL_ST2220T] = {
+		.min_xc         = 0x0,
+		.max_xc         = 0x4000,
+		.min_yc         = 0x0,
+		.max_yc         = 0x4000,
+		.rept_size      = 0x0e,
+		.read_data      = st2220t_read_data,
+		.init           = st2220t_init,
+	},
+#endif
+};
 
 /*****************************************************************************
  * Generic Part
-- 
1.7.6


--------------050701080200060603080805
Content-Type: text/plain;
 name="0001-Blacklist-the-ST2220T-from-the-hid-core-so-as-to-get.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Blacklist-the-ST2220T-from-the-hid-core-so-as-to-get.pa";
 filename*1="tch"

>From 5ef1836407a6c44f889a64e9935069f3820f4e3e Mon Sep 17 00:00:00 2001
From: gopal <gtiwari@redhat.com>
Date: Mon, 17 Oct 2011 10:06:50 +0530
Subject: [PATCH] Blacklist the ST2220T from the hid core so as to get the
 driver access from the driver/input/touchscreen hierarchy

Signed-off-by: gopal <gtiwari@redhat.com>
---
 drivers/hid/hid-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 242353d..00a8b3a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1511,6 +1511,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON, USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
+	{ HID_USB_DEVICE(0x1fd2, 0x0064) },
 
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO, USB_DEVICE_ID_NINTENDO_WIIMOTE) },
@@ -1894,6 +1895,7 @@ static const struct hid_device_id hid_mouse_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
+	{ HID_USB_DEVICE(0x1fd2, 0x0064) },
 	{ }
 };
 
-- 
1.7.6


--------------050701080200060603080805--
