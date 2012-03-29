Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab2C2Nhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:37:45 -0400
Received: from asix.com.tw ([113.196.140.82]:58347 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab2C2Nhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:37:38 -0400
From: "Donald" <donald@asix.com.tw>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: "'open list:USB SUBSYSTEM'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <009c01cd00ee$924eb2e0$b6ec18a0$@com.tw> <20120313160951.GA18810@kroah.com>
In-Reply-To: <20120313160951.GA18810@kroah.com>
Subject: Patch "USB: serial: mos7840: Supported MCS7810 device"
Date: Thu, 29 Mar 2012 21:33:36 +0800
Message-ID: <005a01cd0db0$8ec89e50$ac59daf0$@com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac0BM8jzTnaxgB4KQFyXhs0wVki0hgMeBqqA
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I am submitting this patch that supports MCS7810 device for the mos7840
driver. If you see any problem regarding this patch, please let me know at
any time. Thank you for your help.

Regards,
Donald

Patch Description:
This patch added the support of MCS7810 device for the mos7840 driver. The
MCS7810 device supports single USB2.0-to-Serial port with a LED indicator
for reflecting transmission or reception activity. Please be noted that part
of codes in his patch are relating to the codes in last submitted patch that
fixed MCS7820 device attach problem.

Signed-off-by: Donald Lee <donald@asix.com.tw>
---
 drivers/usb/serial/mos7840.c |  203
++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 197 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index e4885b6..4a90092 100644
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
@@ -184,10 +185,10 @@
 #define NUM_URBS                        16	/* URB Count */
 #define URB_TRANSFER_BUFFER_SIZE        32	/* URB Size  */
 
-
 static const struct usb_device_id moschip_port_id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
+	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7810)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_4)},
@@ -209,6 +210,7 @@ static const struct usb_device_id
moschip_port_id_table[] = {
 static const struct usb_device_id moschip_id_table_combined[]
__devinitconst = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
+	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7810)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_4)},
@@ -261,6 +263,12 @@ struct moschip_port {
 	struct urb *write_urb_pool[NUM_URBS];
 	char busy[NUM_URBS];
 	bool read_urb_busy;
+
+	/* For MCS7810 LED */
+	int mos7810_led_flag;
+	struct timer_list mos7810_led_timer1;	/* For LED on 500ms */
+	struct timer_list mos7810_led_timer2;	/* For LED off 500ms */
+
 };
 
 
@@ -572,6 +580,68 @@ static int mos7840_get_reg(struct moschip_port *mcs,
__u16 Wval, __u16 reg,
 	return ret;
 }
 
+static void mos7810_control_callback(struct urb *urb)
+{
+	if (!urb)
+		return;
+
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
+static int mos7810_set_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg)
+{
+	struct usb_device *dev = mcs->port->serial->dev;
+	struct usb_ctrlrequest *dr = mcs->dr;
+
+	dr->bRequestType = MCS_WR_RTYPE;
+	dr->bRequest = MCS_WRREQ;
+	dr->wValue = cpu_to_le16(Wval);
+	dr->wIndex = cpu_to_le16(reg);
+	dr->wLength = cpu_to_le16(0);
+
+	usb_fill_control_urb(mcs->control_urb, dev, usb_sndctrlpipe(dev, 0),
+		(unsigned char *)dr, NULL, 0, mos7810_control_callback,
NULL);
+
+	return usb_submit_urb(mcs->control_urb, GFP_ATOMIC);
+}
+
+static void mos7810_led_off(unsigned long arg)
+{
+	struct moschip_port *mcs = (struct moschip_port *) arg;
+
+	if (!mcs)
+		return;
+
+	/* Turn off MCS7810 LED */
+	mos7810_set_reg(mcs, 0x0300, MODEM_CONTROL_REGISTER);
+	mod_timer(&mcs->mos7810_led_timer2, jiffies + 500);
+}
+
+static void mos7810_led_flag_off(unsigned long arg)
+{
+	struct moschip_port *mcs = (struct moschip_port *) arg;
+
+	if (!mcs)
+		return;
+
+	mcs->mos7810_led_flag = 0;
+
+}
+
 
/***************************************************************************
**
  * mos7840_interrupt_callback
  *	this is the callback function for when we have received data on the
@@ -792,6 +862,12 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 		return;
 	}
 
+	/* Turn on MCS7810 LED */
+	if (serial->num_ports == 1 && mos7840_port->mos7810_led_flag == 0) {
+		mos7840_port->mos7810_led_flag = 1;
+		mos7810_set_reg(mos7840_port, 0x0301,
MODEM_CONTROL_REGISTER);
+		mod_timer(&mos7840_port->mos7810_led_timer1, jiffies + 500);
+	}
 
 	mos7840_port->read_urb->dev = serial->dev;
 
@@ -1556,6 +1632,18 @@ static int mos7840_write(struct tty_struct *tty,
struct usb_serial_port *port,
 	data1 = urb->transfer_buffer;
 	dbg("bulkout endpoint is %d", port->bulk_out_endpointAddress);
 
+	/* Turn on MCS7810 LED */
+	if (serial->num_ports == 1 && mos7840_port->mos7810_led_flag == 0) {
+
+		mos7840_port->mos7810_led_flag = 1;
+
+		usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev,
0),
+			MCS_WRREQ, MCS_WR_RTYPE, 0x0301,
+			MODEM_CONTROL_REGISTER, NULL, 0, MOS_WDR_TIMEOUT);
+
+		mod_timer(&mos7840_port->mos7810_led_timer1, jiffies + 500);
+	}
+
 	/* send it down the pipe */
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 
@@ -2331,6 +2419,48 @@ static int mos7840_ioctl(struct tty_struct *tty,
 	return -ENOIOCTLCMD;
 }
 
+static int mos7810_check(struct usb_serial *serial)
+{
+	int i, pass_count = 0;
+	__u16 Data = 0, MCR_Data = 0;
+	__u16 test_pattern = 0x55AA, write_pattern;
+
+	/* Store MCR setting */
+	usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+		MCS_RDREQ, MCS_RD_RTYPE, 0x0300, MODEM_CONTROL_REGISTER,
+		&MCR_Data, VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+
+	for (i = 0; i < 16; i++) {
+		write_pattern = 0x0300 | (((test_pattern >> i) & 0x0001) <<
1);
+
+		/* Send the 1-bit test pattern out to RTS pin */
+		usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev,
0),
+			MCS_WRREQ, MCS_WR_RTYPE, write_pattern,
+			MODEM_CONTROL_REGISTER, NULL, 0, MOS_WDR_TIMEOUT);
+
+		/* Read the test pattern back from GPIO1 pin */
+		usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev,
0),
+			MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &Data,
+			VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+
+		/* If this a MCS7810 device, both test patterns must match
*/
+		if (((test_pattern >> i) & 0x0001) != ((~(Data >> 1)) &
0x0001))
+			break;
+
+		pass_count++;
+	}
+
+	/* Restore MCR setting */
+	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
MCS_WRREQ,
+		MCS_WR_RTYPE, 0x0300 | MCR_Data, MODEM_CONTROL_REGISTER,
NULL,
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
 	__u16 Data = 0x00;
@@ -2341,16 +2471,35 @@ static int mos7840_calc_num_ports(struct usb_serial
*serial)
 		MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &Data,
 		VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
 
-	if ((Data&0x01) == 0) {
+	if (serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7810) {
+		mos7840_num_ports = 1;
+		serial->num_bulk_in = 1;
+		serial->num_bulk_out = 1;
+		serial->num_ports = 1;
+	} else if (serial->dev->descriptor.idProduct ==
+						MOSCHIP_DEVICE_ID_7820) {
 		mos7840_num_ports = 2;
 		serial->num_bulk_in = 2;
 		serial->num_bulk_out = 2;
 		serial->num_ports = 2;
 	} else {
-		mos7840_num_ports = 4;
-		serial->num_bulk_in = 4;
-		serial->num_bulk_out = 4;
-		serial->num_ports = 4;
+		/* For a MCS7840 device GPIO0 must be set to 1*/
+		if ((Data & 0x01) == 1) {
+			mos7840_num_ports = 4;
+			serial->num_bulk_in = 4;
+			serial->num_bulk_out = 4;
+			serial->num_ports = 4;
+		} else if (mos7810_check(serial)) {
+			mos7840_num_ports = 1;
+			serial->num_bulk_in = 1;
+			serial->num_bulk_out = 1;
+			serial->num_ports = 1;
+		} else {
+			mos7840_num_ports = 2;
+			serial->num_bulk_in = 2;
+			serial->num_bulk_out = 2;
+			serial->num_ports = 2;
+		}
 	}
 
 	return mos7840_num_ports;
@@ -2567,6 +2716,33 @@ static int mos7840_startup(struct usb_serial *serial)
 			status = -ENOMEM;
 			goto error;
 		}
+
+		/* Initialize MCS7810 LED timers */
+		if (serial->num_ports == 1) {
+			init_timer(&mos7840_port->mos7810_led_timer1);
+			mos7840_port->mos7810_led_timer1.function =
+							mos7810_led_off;
+			mos7840_port->mos7810_led_timer1.expires =
+							jiffies + 500;
+			mos7840_port->mos7810_led_timer1.data =
+						(unsigned long)mos7840_port;
+
+			init_timer(&mos7840_port->mos7810_led_timer2);
+			mos7840_port->mos7810_led_timer2.function =
+
mos7810_led_flag_off;
+			mos7840_port->mos7810_led_timer2.expires =
+							jiffies + 500;
+			mos7840_port->mos7810_led_timer2.data =
+						(unsigned long)mos7840_port;
+
+			mos7840_port->mos7810_led_flag = 0;
+
+			/* Turn off MCS7810 LED */
+			usb_control_msg(serial->dev,
+				usb_sndctrlpipe(serial->dev, 0), MCS_WRREQ,
+				MCS_WR_RTYPE, 0x0300,
MODEM_CONTROL_REGISTER,
+				NULL, 0, MOS_WDR_TIMEOUT);
+		}
 	}
 	dbg ("mos7840_startup: all ports configured...........");
 
@@ -2658,6 +2834,21 @@ static void mos7840_release(struct usb_serial
*serial)
 		mos7840_port = mos7840_get_port_private(serial->port[i]);
 		dbg("mos7840_port %d = %p", i, mos7840_port);
 		if (mos7840_port) {
+
+			if (serial->num_ports == 1) {
+				/* Turn off MCS7810 LED */
+				usb_control_msg(serial->dev,
+					usb_sndctrlpipe(serial->dev, 0),
+					MCS_WRREQ, MCS_WR_RTYPE, 0x0300,
+					MODEM_CONTROL_REGISTER,	NULL, 0,
+					MOS_WDR_TIMEOUT);
+
+				del_timer_sync(&mos7840_port->
+							mos7810_led_timer1);
+				del_timer_sync(&mos7840_port->
+							mos7810_led_timer2);
+			}
+
 			kfree(mos7840_port->ctrl_buf);
 			kfree(mos7840_port->dr);
 			kfree(mos7840_port);
-- 
1.7.7.6



