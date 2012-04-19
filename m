Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2DSHB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 03:01:27 -0400
Received: from asix.com.tw ([113.196.140.82]:52299 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab2DSHBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 03:01:23 -0400
From: "Donald" <donald@asix.com.tw>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: "'open list:USB SUBSYSTEM'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Patch "USB: serial: mos7840: Supported MCS7810 device"
Date: Thu, 19 Apr 2012 15:00:45 +0800
Message-ID: <007401cd1dfa$27acd4c0$77067e40$@com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac0d+iP3o7AWpKAiSjWQUNgbyvxbKA==
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I am re-submitting this patch that supports MCS7810 device for the mos7840 driver. This patch was created against 3.4-rc1 and has
been verified on 3.4-rc1 also. If you see any problem regarding this patch, please let me know at any time. Thank you for your help.

Regards,
Donald

Patch Description:
This patch added the support of MCS7810 device for the mos7840 driver. The MCS7810 device supports single USB2.0-to-Serial port with
a LED indicator for reflecting transmission or reception activity.

Signed-off-by: Donald Lee <donald@asix.com.tw>
---
 drivers/usb/serial/mos7840.c |  202 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 188 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index c526550..aaef523 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -114,6 +114,7 @@
 #define USB_VENDOR_ID_MOSCHIP           0x9710
 #define MOSCHIP_DEVICE_ID_7840          0x7840
 #define MOSCHIP_DEVICE_ID_7820          0x7820
+#define MOSCHIP_DEVICE_ID_7810          0x7810
 /* The native component can have its vendor/device id's overridden
  * in vendor-specific implementations.  Such devices can be handled
  * by making a change here, in moschip_port_id_table, and in
@@ -184,10 +185,16 @@
 #define NUM_URBS                        16	/* URB Count */
 #define URB_TRANSFER_BUFFER_SIZE        32	/* URB Size  */
 
+/* LED on/off milliseconds*/
+#define LED_ON_MS	500
+#define LED_OFF_MS	500
+
+static int device_type;
 
 static const struct usb_device_id moschip_port_id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
+	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7810)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_4)},
@@ -209,6 +216,7 @@ static const struct usb_device_id moschip_port_id_table[] = {
 static const struct usb_device_id moschip_id_table_combined[] __devinitconst = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
+	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7810)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_4)},
@@ -261,8 +269,13 @@ struct moschip_port {
 	struct urb *write_urb_pool[NUM_URBS];
 	char busy[NUM_URBS];
 	bool read_urb_busy;
-};
 
+	/* For device(s) with LED indicator */
+	bool has_led;
+	bool led_flag;
+	struct timer_list led_timer1;	/* Timer for LED on */
+	struct timer_list led_timer2;	/* Timer for LED off */
+};
 
 static bool debug;
 
@@ -572,6 +585,69 @@ static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
 	return ret;
 }
 
+static void mos7840_set_led_callback(struct urb *urb)
+{
+	switch (urb->status) {
+	case 0:
+		/* Success */
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/* This urb is terminated, clean up */
+		dbg("%s - urb shutting down with status: %d", __func__,
+			urb->status);
+		break;
+	default:
+		dbg("%s - nonzero urb status received: %d", __func__,
+			urb->status);
+	}
+}
+
+static void mos7840_set_led_async(struct moschip_port *mcs, __u16 wval,
+				__u16 reg)
+{
+	struct usb_device *dev = mcs->port->serial->dev;
+	struct usb_ctrlrequest *dr = mcs->dr;
+
+	dr->bRequestType = MCS_WR_RTYPE;
+	dr->bRequest = MCS_WRREQ;
+	dr->wValue = cpu_to_le16(wval);
+	dr->wIndex = cpu_to_le16(reg);
+	dr->wLength = cpu_to_le16(0);
+
+	usb_fill_control_urb(mcs->control_urb, dev, usb_sndctrlpipe(dev, 0),
+		(unsigned char *)dr, NULL, 0, mos7840_set_led_callback, NULL);
+
+	usb_submit_urb(mcs->control_urb, GFP_ATOMIC);
+}
+
+static void mos7840_set_led_sync(struct usb_serial_port *port, __u16 reg,
+				__u16 val)
+{
+	struct usb_device *dev = port->serial->dev;
+
+	usb_control_msg(dev, usb_sndctrlpipe(dev, 0), MCS_WRREQ, MCS_WR_RTYPE,
+			val, reg, NULL, 0, MOS_WDR_TIMEOUT);
+}
+
+static void mos7840_led_off(unsigned long arg)
+{
+	struct moschip_port *mcs = (struct moschip_port *) arg;
+
+	/* Turn off LED */
+	mos7840_set_led_async(mcs, 0x0300, MODEM_CONTROL_REGISTER);
+	mod_timer(&mcs->led_timer2,
+				jiffies + msecs_to_jiffies(LED_OFF_MS));
+}
+
+static void mos7840_led_flag_off(unsigned long arg)
+{
+	struct moschip_port *mcs = (struct moschip_port *) arg;
+
+	mcs->led_flag = false;
+}
+
 /*****************************************************************************
  * mos7840_interrupt_callback
  *	this is the callback function for when we have received data on the
@@ -792,6 +868,14 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 		return;
 	}
 
+	/* Turn on LED */
+	if (mos7840_port->has_led && !mos7840_port->led_flag) {
+		mos7840_port->led_flag = true;
+		mos7840_set_led_async(mos7840_port, 0x0301,
+					MODEM_CONTROL_REGISTER);
+		mod_timer(&mos7840_port->led_timer1,
+				jiffies + msecs_to_jiffies(LED_ON_MS));
+	}
 
 	mos7840_port->read_urb_busy = true;
 	retval = usb_submit_urb(mos7840_port->read_urb, GFP_ATOMIC);
@@ -1554,6 +1638,14 @@ static int mos7840_write(struct tty_struct *tty, struct usb_serial_port *port,
 	data1 = urb->transfer_buffer;
 	dbg("bulkout endpoint is %d", port->bulk_out_endpointAddress);
 
+	/* Turn on LED */
+	if (mos7840_port->has_led && !mos7840_port->led_flag) {
+		mos7840_port->led_flag = true;
+		mos7840_set_led_sync(port, MODEM_CONTROL_REGISTER, 0x0301);
+		mod_timer(&mos7840_port->led_timer1,
+				jiffies + msecs_to_jiffies(LED_ON_MS));
+	}
+
 	/* send it down the pipe */
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 
@@ -2327,28 +2419,74 @@ static int mos7840_ioctl(struct tty_struct *tty,
 	return -ENOIOCTLCMD;
 }
 
+static int mos7810_check(struct usb_serial *serial)
+{
+	int i, pass_count = 0;
+	__u16 data = 0, mcr_data = 0;
+	__u16 test_pattern = 0x55AA;
+
+	/* Store MCR setting */
+	usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+		MCS_RDREQ, MCS_RD_RTYPE, 0x0300, MODEM_CONTROL_REGISTER,
+		&mcr_data, VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+
+	for (i = 0; i < 16; i++) {
+		/* Send the 1-bit test pattern out to MCS7810 test pin */
+		usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
+			MCS_WRREQ, MCS_WR_RTYPE,
+			(0x0300 | (((test_pattern >> i) & 0x0001) << 1)),
+			MODEM_CONTROL_REGISTER, NULL, 0, MOS_WDR_TIMEOUT);
+
+		/* Read the test pattern back */
+		usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+			MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &data,
+			VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+
+		/* If this is a MCS7810 device, both test patterns must match */
+		if (((test_pattern >> i) ^ (~data >> 1)) & 0x0001)
+			break;
+
+		pass_count++;
+	}
+
+	/* Restore MCR setting */
+	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0), MCS_WRREQ,
+		MCS_WR_RTYPE, 0x0300 | mcr_data, MODEM_CONTROL_REGISTER, NULL,
+		0, MOS_WDR_TIMEOUT);
+
+	if (pass_count == 16)
+		return 1;
+
+	return 0;
+}
+
 static int mos7840_calc_num_ports(struct usb_serial *serial)
 {
-	__u16 Data = 0x00;
-	int ret = 0;
+	__u16 data = 0x00;
 	int mos7840_num_ports;
 
-	ret = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-		MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &Data,
+	usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+		MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &data,
 		VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
 
-	if ((Data & 0x01) == 0) {
-		mos7840_num_ports = 2;
-		serial->num_bulk_in = 2;
-		serial->num_bulk_out = 2;
-		serial->num_ports = 2;
+	if (serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7810 ||
+		serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7820) {
+		device_type = serial->dev->descriptor.idProduct;
 	} else {
-		mos7840_num_ports = 4;
-		serial->num_bulk_in = 4;
-		serial->num_bulk_out = 4;
-		serial->num_ports = 4;
+		/* For a MCS7840 device GPIO0 must be set to 1 */
+		if ((data & 0x01) == 1)
+			device_type = MOSCHIP_DEVICE_ID_7840;
+		else if (mos7810_check(serial))
+			device_type = MOSCHIP_DEVICE_ID_7810;
+		else
+			device_type = MOSCHIP_DEVICE_ID_7820;
 	}
 
+	mos7840_num_ports = (device_type >> 4) & 0x000F;
+	serial->num_bulk_in = mos7840_num_ports;
+	serial->num_bulk_out = mos7840_num_ports;
+	serial->num_ports = mos7840_num_ports;
+
 	return mos7840_num_ports;
 }
 
@@ -2563,6 +2701,34 @@ static int mos7840_startup(struct usb_serial *serial)
 			status = -ENOMEM;
 			goto error;
 		}
+
+		mos7840_port->has_led = false;
+
+		/* Initialize LED timers */
+		if (device_type == MOSCHIP_DEVICE_ID_7810) {
+			mos7840_port->has_led = true;
+
+			init_timer(&mos7840_port->led_timer1);
+			mos7840_port->led_timer1.function = mos7840_led_off;
+			mos7840_port->led_timer1.expires =
+					jiffies + msecs_to_jiffies(LED_ON_MS);
+			mos7840_port->led_timer1.data =
+						(unsigned long)mos7840_port;
+
+			init_timer(&mos7840_port->led_timer2);
+			mos7840_port->led_timer2.function =
+						mos7840_led_flag_off;
+			mos7840_port->led_timer2.expires =
+					jiffies + msecs_to_jiffies(LED_OFF_MS);
+			mos7840_port->led_timer2.data =
+						(unsigned long)mos7840_port;
+
+			mos7840_port->led_flag = false;
+
+			/* Turn off LED */
+			mos7840_set_led_sync(serial->port[i],
+						MODEM_CONTROL_REGISTER, 0x0300);
+		}
 	}
 	dbg ("mos7840_startup: all ports configured...........");
 
@@ -2654,6 +2820,14 @@ static void mos7840_release(struct usb_serial *serial)
 		mos7840_port = mos7840_get_port_private(serial->port[i]);
 		dbg("mos7840_port %d = %p", i, mos7840_port);
 		if (mos7840_port) {
+			if (mos7840_port->has_led) {
+				/* Turn off LED */
+				mos7840_set_led_sync(mos7840_port->port,
+						MODEM_CONTROL_REGISTER, 0x0300);
+
+				del_timer_sync(&mos7840_port->led_timer1);
+				del_timer_sync(&mos7840_port->led_timer2);
+			}
 			kfree(mos7840_port->ctrl_buf);
 			kfree(mos7840_port->dr);
 			kfree(mos7840_port);
-- 
1.7.7.6



