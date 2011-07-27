Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab1G0Lcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 07:32:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab1G0Lch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 07:32:37 -0400
Message-ID: <4E2FF73A.8090906@redhat.com>
Date: Wed, 27 Jul 2011 17:02:10 +0530
From: Gopal <gtiwari@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: DELL-ST2220T Touch Screen Monitor Driver Patch
Content-Type: multipart/mixed;
 boundary="------------070800040302040907040208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070800040302040907040208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

We have recently Created support for the DELL-ST2220T Touch Screen Monitor.

More of Technical Details :

We have Written separate driver and merge it with the different 
touchscreen monitor drivers in /driver/input/touchscreen/usbtouchscreen.c.

changes as in :

1) Device Specific USB Control Request.

    ctrl_buf[0] = 0x07;
         ctrl_buf[1] = 0x02;
         ctrl_buf[2] = 0x02;

         for (i = 0; i < 3; i++)
         {
                 ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x09,
                 0x21, 0x0307, 0x00, ctrl_buf,
                 0x03, USB_CTRL_SET_TIMEOUT);

                 dbg("%s - usb_control_msg - 0x21 0x09 - bytes|err: %d\n",
                     __func__, ret);

                 if (ret == 0 )
                         break;

                 msleep(150);
         }

         msleep(150);

         for (i = 0; i < 6; i++)
         {
                 ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
                                       0x01,
                                       0xA1,
                                       0x308, 0x00, ctrl_buf, 2, 
USB_CTRL_SET_TIMEOUT);
                 dbg("%s - usb_control_msg - bytes|err: %d",
                     __func__, ret);

                 dbg(" %x %x\n", ctrl_buf[0], ctrl_buf[1]);

                 msleep(50);
         }



2) Blacklisting from the HID Class as device does not support Standard 
Mouse Protocol as per the Interface Descriptor of the Device.
  So Instead of making it separate Driver we merge it with  
driver/input/touchscreen Section.



3) HID Data Fatching protocol parsing.


static int st2220t_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
{
         if(pkt[9] != 0xff && pkt[11])
         {
                 dev->x = (pkt[10]<< 8)| pkt[9];
                 dev->y = (pkt[12]<< 8)| pkt[11];
                 dev->x =  ((dev->x)* 9) - 0x200;
                 dev->y =  (dev->y)* 15;
                 input_report_abs(dev->input, ABS_X, dev->x);
                 input_report_abs(dev->input, ABS_Y, dev->y);
         }

         dev->x = (pkt[4]<< 8)| pkt[3];
         dev->y = (pkt[6]<< 8)| pkt[5];
         dev->x =  ((dev->x)* 9) - 0x200;
         dev->y =  (dev->y)* 15;

         dev->touch = (pkt[2] & 0x03) ? 1 : 0;

         return 1;
}

Some of the changes to the respective file is mentioned in the mail to 
get the full driver changes you can see with in the patch attach with 
this mail.

Please Verify this and reply me.

thanks
&
regards
Gopal krishna tiwari.




--------------070800040302040907040208
Content-Type: text/plain;
 name="DellST2220T.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="DellST2220T.patch"

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index c957c4b..228fd90 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1500,6 +1500,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON, USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
+	{ HID_USB_DEVICE(0x1f2d, 0x0064) },
 
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT) },
 	{ }
@@ -1837,6 +1838,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_1_PHIDGETSERVO_20) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_8_8_4_IF_KIT) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_YEALINK, USB_DEVICE_ID_YEALINK_P1K_P4K_B2K) },
+	{ HID_USB_DEVICE(0x1fd2, 0x0064) },
 	{ }
 };
 
@@ -1883,6 +1885,7 @@ static const struct hid_device_id hid_mouse_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING5_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
+	{ HID_USB_DEVICE(0x1fd2, 0x0064) },
 	{ }
 };
 
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 38c261a..9a79e9f 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -240,6 +240,7 @@ static void hid_irq_in(struct urb *urb)
 	struct usbhid_device 	*usbhid = hid->driver_data;
 	int			status;
 
+
 	switch (urb->status) {
 	case 0:			/* success */
 		usbhid_mark_busy(usbhid);
@@ -654,6 +655,7 @@ int usbhid_open(struct hid_device *hid)
 	struct usbhid_device *usbhid = hid->driver_data;
 	int res;
 
+
 	mutex_lock(&hid_open_mut);
 	if (!hid->open++) {
 		res = usb_autopm_get_interface(usbhid->intf);
@@ -983,6 +985,7 @@ static int usbhid_start(struct hid_device *hid)
 	struct usbhid_device *usbhid = hid->driver_data;
 	unsigned int n, insize = 0;
 	int ret;
+	
 
 	clear_bit(HID_DISCONNECTED, &usbhid->iofl);
 
@@ -1156,6 +1159,7 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 	size_t len;
 	int ret;
 
+
 	dbg_hid("HID probe called for ifnum %d\n",
 			intf->altsetting->desc.bInterfaceNumber);
 
diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 73fd664..b5c1c0f 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -59,11 +59,13 @@
 #define DRIVER_AUTHOR		"Daniel Ritz <daniel.ritz@gmx.ch>"
 #define DRIVER_DESC		"USB Touchscreen Driver"
 
+#define CONFIG_TOUCHSCREEN_USB_DELL_ST2220T
+
 static int swap_xy;
 module_param(swap_xy, bool, 0644);
 MODULE_PARM_DESC(swap_xy, "If set X and Y axes are swapped.");
 
-static int hwcalib_xy;
+static int hwcalib_xy ;
 module_param(hwcalib_xy, bool, 0644);
 MODULE_PARM_DESC(hwcalib_xy, "If set hw-calibrated X/Y are used if available");
 
@@ -138,6 +140,7 @@ enum {
 	DEVTYPE_ZYTRONIC,
 	DEVTYPE_TC45USB,
 	DEVTYPE_NEXIO,
+	DEVTYPE_DELL_ST2220T,
 };
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
@@ -195,7 +198,6 @@ static const struct usb_device_id usbtouch_devices[] = {
 
 #ifdef CONFIG_TOUCHSCREEN_USB_IRTOUCH
 	{USB_DEVICE(0x595a, 0x0001), .driver_info = DEVTYPE_IRTOUCH},
-	{USB_DEVICE(0x6615, 0x0001), .driver_info = DEVTYPE_IRTOUCH},
 #endif
 
 #ifdef CONFIG_TOUCHSCREEN_USB_IDEALTEK
@@ -238,6 +240,11 @@ static const struct usb_device_id usbtouch_devices[] = {
 	{USB_DEVICE_AND_INTERFACE_INFO(0x1870, 0x0001, 0x0a, 0x00, 0x00),
 		.driver_info = DEVTYPE_NEXIO},
 #endif
+#ifdef CONFIG_TOUCHSCREEN_USB_DELL_ST2220T
+
+{USB_DEVICE(0x1fd2, 0x0064), .driver_info = DEVTYPE_DELL_ST2220T},
+
+#endif
 
 	{}
 };
@@ -335,6 +342,109 @@ static int panjit_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
 }
 #endif
 
+/*.................................................................
+ *      Dell - ST2220T Initialization
+ *...............................................................*/
+
+#ifdef CONFIG_TOUCHSCREEN_USB_DELL_ST2220T
+
+#define ST2220T_VENDOR_REQ      0x22
+
+static int st2220t_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
+{
+        if(pkt[9] != 0xff && pkt[11])
+        {
+        	dev->x = (pkt[10]<< 8)| pkt[9];
+                dev->y = (pkt[12]<< 8)| pkt[11];
+                dev->x =  ((dev->x)* 9) - 0x200;
+                dev->y =  (dev->y)* 15;
+                input_report_abs(dev->input, ABS_X, dev->x);
+                input_report_abs(dev->input, ABS_Y, dev->y);
+        }
+
+        dev->x = (pkt[4]<< 8)| pkt[3];
+        dev->y = (pkt[6]<< 8)| pkt[5];
+        dev->x =  ((dev->x)* 9) - 0x200;
+        dev->y =  (dev->y)* 15;
+
+        //dev->touch = (pkt[2] & 0x03) ? 1 : 0;
+
+        return 1;
+}
+
+
+static int st2220t_init(struct usbtouch_usb *usbtouch)
+{
+        int ret, i;
+        struct usb_device *udev = interface_to_usbdev(usbtouch->interface);
+        char *ctrl_buf;
+
+        /*......................................
+        *Allocate Memory For Control transfer
+         Buffer
+        *......................................*/
+
+        ctrl_buf = kmalloc(64, GFP_KERNEL);
+
+        if(!ctrl_buf)
+        {
+                printk("%s - Failed : to Get Memory \n",__func__);
+
+                return -1;
+        }
+
+        /*.......................................
+        *  Following Control Request is Very Imp
+        *  To Start USB Interrupt transaction
+        *  this request is SET_REPORT H->D
+        *  with Data as 07,02,02
+        * .......................................*/
+
+        ctrl_buf[0] = 0x07;
+        ctrl_buf[1] = 0x02;
+        ctrl_buf[2] = 0x02;
+
+        for (i = 0; i < 3; i++)
+        {
+                ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x09,
+                0x21, 0x0307, 0x00, ctrl_buf,
+                0x03, USB_CTRL_SET_TIMEOUT);
+
+                dbg("%s - usb_control_msg - 0x21 0x09 - bytes|err: %d\n",
+                    __func__, ret);
+
+                if (ret == 0 )
+                        break;
+
+                msleep(150);
+        }
+
+        msleep(150);
+
+        for (i = 0; i < 6; i++)
+        {
+                ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+                                      0x01,
+                                      0xA1,
+                                      0x308, 0x00, ctrl_buf, 2, USB_CTRL_SET_TIMEOUT);
+                dbg("%s - usb_control_msg - bytes|err: %d",
+                    __func__, ret);
+
+                dbg(" %x %x\n", ctrl_buf[0], ctrl_buf[1]);
+
+                msleep(50);
+        }
+
+        kfree(ctrl_buf);
+
+        return 0;
+}
+
+
+
+
+#endif
+
 
 /*****************************************************************************
  * 3M/Microtouch Part
@@ -1139,6 +1249,20 @@ static struct usbtouch_device_info usbtouch_dev_info[] = {
 		.exit		= nexio_exit,
 	},
 #endif
+
+#ifdef CONFIG_TOUCHSCREEN_USB_DELL_ST2220T
+
+        [DEVTYPE_DELL_ST2220T] = {
+                .min_xc         = 0x0,
+                .max_xc         = 0x4000,
+                .min_yc         = 0x0,
+                .max_yc         = 0x4000,
+                .rept_size      = 0x0e,
+                .read_data      = st2220t_read_data,
+                .init           = st2220t_init,
+        },
+#endif
+
 };
 
 

--------------070800040302040907040208--
