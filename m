Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab2B1Qji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:39:38 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35659 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2B1Qjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:39:35 -0500
From: Autif Khan <autifk@gmail.com>
To: gregkh@linuxfoundation.org, rusty@rustcorp.com.au, jhovold@gmail.com,
        stern@rowland.harvard.edu, mchehab@redhat.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Autif Khan <autifk@gmail.com>
Subject: [PATCH 1/3] drivers: usb: serial: sierra - upgrade to 1.7.40
Date: Tue, 28 Feb 2012 11:39:12 -0500
Message-Id: <1330447152-5770-1-git-send-email-autifk@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver was upgraded from 1.7.16 to 1.7.40
source of the driver at the time of this change:
http://www.sierrawireless.com/resources/support/drivers/linux/v3.2_1740_kernel-3.0.directIP.tar

The driver compiles (monolithic and module)
I have not tested it on any device

Signed-off-by: Autif Khan <autifk@gmail.com>
---
 drivers/usb/serial/sierra.c |  574 +++++++++++++++++++++++++++++++------------
 1 files changed, 413 insertions(+), 161 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index fdae0a4..e3ceda3 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -3,7 +3,7 @@
 
   Copyright (C) 2006, 2007, 2008  Kevin Lloyd <klloyd@sierrawireless.com>,
 
-  Copyright (C) 2008, 2009  Elina Pasheva, Matthew Safar, Rory Filer
+  Copyright (C) 2008 - 2011  Elina Pasheva, Matthew Safar, Rory Filer
 			<linux@sierrawireless.com>
 
   IMPORTANT DISCLAIMER: This driver is not commercially supported by
@@ -17,8 +17,12 @@
   Whom based his on the Keyspan driver by Hugh Blemings <hugh@blemings.org>
 */
 /* Uncomment to log function calls */
-/* #define DEBUG */
-#define DRIVER_VERSION "v.1.7.16"
+/*#define DEBUG*/
+/* Uncomment to force power level set to auto when attaching a device */
+/*#define POWER_LEVEL_AUTO*/
+
+/* Sierra driver - kernel 3.0 */
+#define DRIVER_VERSION "v.1.7.40"
 #define DRIVER_AUTHOR "Kevin Lloyd, Elina Pasheva, Matthew Safar, Rory Filer"
 #define DRIVER_DESC "USB Driver for Sierra Wireless USB modems"
 
@@ -31,9 +35,13 @@
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <asm/unaligned.h>
 
 #define SWIMS_USB_REQUEST_SetPower	0x00
+#define SWIMS_USB_REQUEST_GetFwAttr	0x06
 #define SWIMS_USB_REQUEST_SetNmea	0x07
+#define USB_REQUEST_TYPE_CLASS		0xA1
+#define USB_REQUEST_IFACE		0x20
 
 #define N_IN_URB_HM	8
 #define N_OUT_URB_HM	64
@@ -46,8 +54,16 @@
    allocations > PAGE_SIZE and the number of packets in a page
    is an integer 512 is the largest possible packet on EHCI */
 
-static bool debug;
-static bool nmea;
+#define SWI_FW_ATTR_PM_MASK		0x02
+/* PORTION_LEN defines the length of device attribute buffer */
+#define PORTION_LEN			4096
+
+static int debug;
+static int nmea;
+
+/* sysfs attributes */
+static int sierra_create_sysfs_attrs(struct usb_serial_port *port);
+static int sierra_remove_sysfs_attrs(struct usb_serial_port *port);
 
 /* Used in interface blacklisting */
 struct sierra_iface_info {
@@ -55,10 +71,30 @@ struct sierra_iface_info {
 	const u8  *ifaceinfo;	/* pointer to the array holding the numbers */
 };
 
+/* per interface statistics */
+struct sierra_intf_stats {
+	atomic_t	rx_bytes;		/* received bytes */
+	atomic_t	indat_cb_cnt;		/* indat callback count */
+	atomic_t	indat_cb_fail;		/* indat cb with error */
+
+	atomic_t	tx_bytes;		/* transmitted bytes */
+	atomic_t	write_cnt;		/* no. of writes */
+	atomic_t	write_err;		/* no. of failed writes */
+
+	atomic_t	delayed_writes;		/* no. of delayed writes */
+	atomic_t	delayed_write_err;	/* no. of delayed write errs */
+
+	atomic_t	outdat_cb_cnt;		/* outdat callback count */
+	atomic_t	outdat_cb_fail;		/* outdat cb with error */
+
+};
+
 struct sierra_intf_private {
 	spinlock_t susp_lock;
 	unsigned int suspended:1;
 	int in_flight;
+
+	struct sierra_intf_stats stats;
 };
 
 static int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
@@ -91,6 +127,38 @@ static int sierra_vsc_set_nmea(struct usb_device *udev, __u16 enable)
 	return result;
 }
 
+static int sierra_get_fw_attr(struct usb_device *udev, u16 *data)
+{
+	int result;
+	u16 *attrdata;
+
+	dev_dbg(&udev->dev, "%s\n", __func__);
+
+	attrdata = kmalloc(sizeof(*attrdata), GFP_KERNEL);
+	if (!attrdata)
+		return -ENOMEM;
+
+	result = usb_control_msg(udev,
+				usb_rcvctrlpipe(udev, 0),
+				SWIMS_USB_REQUEST_GetFwAttr,  /* __u8 request*/
+				USB_TYPE_VENDOR | USB_DIR_IN, /* request type*/
+				0x0000,			/* __u16 value       */
+				0x0000,			/* __u16 index       */
+				attrdata,		/* void *data        */
+				sizeof(*attrdata),	/* _u16 size         */
+				USB_CTRL_SET_TIMEOUT);	/* in timeout        */
+
+	if (result < 0) {
+		kfree(attrdata);
+		return -EIO;
+	}
+
+	*data = *attrdata;
+
+	kfree(attrdata);
+	return result;
+}
+
 static int sierra_calc_num_ports(struct usb_serial *serial)
 {
 	int num_ports = 0;
@@ -150,7 +218,6 @@ static int sierra_calc_interface(struct usb_serial *serial)
 	int interface;
 	struct usb_interface *p_interface;
 	struct usb_host_interface *p_host_interface;
-	dev_dbg(&serial->dev->dev, "%s\n", __func__);
 
 	/* Get the interface structure pointer from the serial struct */
 	p_interface = serial->interface;
@@ -159,8 +226,7 @@ static int sierra_calc_interface(struct usb_serial *serial)
 	p_host_interface = p_interface->cur_altsetting;
 
 	/* read the interface descriptor for this active altsetting
-	 * to find out the interface number we are on
-	*/
+	 * to find out the interface number we are on */
 	interface = p_host_interface->desc.bInterfaceNumber;
 
 	return interface;
@@ -171,7 +237,7 @@ static int sierra_probe(struct usb_serial *serial,
 {
 	int result = 0;
 	struct usb_device *udev;
-	struct sierra_intf_private *data;
+	struct sierra_intf_private *intfdata;
 	u8 ifnum;
 
 	udev = serial->dev;
@@ -185,7 +251,9 @@ static int sierra_probe(struct usb_serial *serial,
 	if (serial->interface->num_altsetting == 2) {
 		dev_dbg(&udev->dev, "Selecting alt setting for interface %d\n",
 			ifnum);
-		/* We know the alternate setting is 1 for the MC8785 */
+		/* We know the alternate setting is for composite USB interface
+		 * modems
+		 */
 		usb_set_interface(udev, ifnum, 1);
 	}
 
@@ -199,10 +267,11 @@ static int sierra_probe(struct usb_serial *serial,
 		return -ENODEV;
 	}
 
-	data = serial->private = kzalloc(sizeof(struct sierra_intf_private), GFP_KERNEL);
-	if (!data)
+	intfdata = serial->private = kzalloc(sizeof(struct sierra_intf_private),
+						GFP_KERNEL);
+	if (!intfdata)
 		return -ENOMEM;
-	spin_lock_init(&data->susp_lock);
+	spin_lock_init(&intfdata->susp_lock);
 
 	return result;
 }
@@ -223,15 +292,15 @@ static const struct sierra_iface_info typeB_interface_list = {
 /* 'blacklist' of interfaces not served by this driver */
 static const u8 direct_ip_non_serial_ifaces[] = { 7, 8, 9, 10, 11 };
 static const struct sierra_iface_info direct_ip_interface_blacklist = {
-	.infolen = ARRAY_SIZE(direct_ip_non_serial_ifaces),
+	.infolen = ARRAY_SIZE( direct_ip_non_serial_ifaces ),
 	.ifaceinfo = direct_ip_non_serial_ifaces,
 };
 
-static const struct usb_device_id id_table[] = {
+static const struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x0F3D, 0x0112) }, /* Airprime/Sierra PC 5220 */
 	{ USB_DEVICE(0x03F0, 0x1B1D) },	/* HP ev2200 a.k.a MC5720 */
-	{ USB_DEVICE(0x03F0, 0x211D) }, /* HP ev2210 a.k.a MC5725 */
 	{ USB_DEVICE(0x03F0, 0x1E1D) },	/* HP hs2300 a.k.a MC8775 */
+	{ USB_DEVICE(0x03F0, 0x211D) }, /* HP ev2210 a.k.a MC5725 */
 
 	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
 	{ USB_DEVICE(0x1199, 0x0018) },	/* Sierra Wireless MC5720 */
@@ -245,7 +314,10 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
 	{ USB_DEVICE(0x1199, 0x0112) }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U */
-	{ USB_DEVICE(0x1199, 0x0301) },	/* Sierra Wireless USB Dongle 250U */
+	{ USB_DEVICE(0x1199, 0x0301) },	/* Sierra Wireless USB Dongle 250U/3G */
+	/* Sierra Wireless MC5728 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x0400, 0xFF, 0xFF, 0xFF) },
+
 	/* Sierra Wireless C597 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x0023, 0xFF, 0xFF, 0xFF) },
 	/* Sierra Wireless T598 */
@@ -253,7 +325,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1199, 0x0026) }, /* Sierra Wireless T11 */
 	{ USB_DEVICE(0x1199, 0x0027) }, /* Sierra Wireless AC402 */
 	{ USB_DEVICE(0x1199, 0x0028) }, /* Sierra Wireless MC5728 */
-	{ USB_DEVICE(0x1199, 0x0029) }, /* Sierra Wireless Device */
+	{ USB_DEVICE(0x114F, 0x6000) }, /* Sierra Wireless Q26 Elite */
 
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6803) },	/* Sierra Wireless MC8765 */
@@ -277,7 +349,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1199, 0x683A) },	/* Sierra Wireless MC8785 */
 	{ USB_DEVICE(0x1199, 0x683B) },	/* Sierra Wireless MC8785 Composite */
 	/* Sierra Wireless MC8790, MC8791, MC8792 Composite */
-	{ USB_DEVICE(0x1199, 0x683C) },
+	{ USB_DEVICE(0x1199, 0x683C) },	
 	{ USB_DEVICE(0x1199, 0x683D) },	/* Sierra Wireless MC8791 Composite */
 	/* Sierra Wireless MC8790, MC8791, MC8792 */
 	{ USB_DEVICE(0x1199, 0x683E) },
@@ -298,22 +370,34 @@ static const struct usb_device_id id_table[] = {
 	/* Sierra Wireless HSPA Non-Composite Device */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6892, 0xFF, 0xFF, 0xFF)},
 	{ USB_DEVICE(0x1199, 0x6893) },	/* Sierra Wireless Device */
-	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
-	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
+	/* Sierra Wireless Direct IP modems */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68A3, 0xFF, 0xFF, 0xFF),
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist 
 	},
-	{ USB_DEVICE(0x0f3d, 0x68A3), 	/* Airprime/Sierra Wireless Direct IP modems */
-	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
+	/* AT&T Direct IP modems */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68A3, 0xFF, 0xFF, 0xFF),
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist 
 	},
-       { USB_DEVICE(0x413C, 0x08133) }, /* Dell Computer Corp. Wireless 5720 VZW Mobile Broadband (EVDO Rev-A) Minicard GPS Port */
+	/* Sierra Wireless Direct IP LTE modems */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68AA, 0xFF, 0xFF, 0xFF),
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist 
+	},
+	/* AT&T Direct IP LTE modems */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68AA, 0xFF, 0xFF, 0xFF),
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist 
+	},
+	/* Wireless 5720 VZW Mobile Broadband (EVDO Rev-A) Minicard GPS Port */
+	{ USB_DEVICE(0x413C, 0x8133) },
 
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, id_table);
 
-
+/* per port private data */
 struct sierra_port_private {
 	spinlock_t lock;	/* lock the structure */
 	int outstanding_urbs;	/* number of out urbs in flight */
+
 	struct usb_anchor active;
 	struct usb_anchor delayed;
 
@@ -335,7 +419,7 @@ struct sierra_port_private {
 static int sierra_send_setup(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
-	struct sierra_port_private *portdata;
+	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
 	__u16 interface = 0;
 	int val = 0;
 	int do_send = 0;
@@ -343,8 +427,6 @@ static int sierra_send_setup(struct usb_serial_port *port)
 
 	dev_dbg(&port->dev, "%s\n", __func__);
 
-	portdata = usb_get_serial_port_data(port);
-
 	if (portdata->dtr_state)
 		val |= 0x01;
 	if (portdata->rts_state)
@@ -376,10 +458,7 @@ static int sierra_send_setup(struct usb_serial_port *port)
 	if (!do_send)
 		return 0;
 
-	retval = usb_autopm_get_interface(serial->interface);
-	if (retval < 0)
-		return retval;
-
+	usb_autopm_get_interface(serial->interface);
 	retval = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 		0x22, 0x21, val, interface, NULL, 0, USB_CTRL_SET_TIMEOUT);
 	usb_autopm_put_interface(serial->interface);
@@ -440,11 +519,77 @@ static void sierra_release_urb(struct urb *urb)
 	if (urb) {
 		port =  urb->context;
 		dev_dbg(&port->dev, "%s: %p\n", __func__, urb);
-		kfree(urb->transfer_buffer);
 		usb_free_urb(urb);
 	}
 }
 
+/* Sysfs Attributes */
+
+static ssize_t show_suspend_status(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct usb_serial_port *port;
+	struct sierra_port_private *portdata;
+	struct sierra_intf_private *intfdata;
+	unsigned long flags;
+	unsigned int flag_suspended = 0;
+
+	port = to_usb_serial_port(dev);
+	portdata = usb_get_serial_port_data(port);
+	intfdata = port->serial->private;
+
+	spin_lock_irqsave(&intfdata->susp_lock, flags);
+	flag_suspended = intfdata->suspended;
+	spin_unlock_irqrestore(&intfdata->susp_lock, flags);
+
+	return snprintf(buf, PORTION_LEN, "%i\n", flag_suspended);
+}
+
+static ssize_t show_stats(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct usb_serial_port *port;
+	struct sierra_intf_private *intfdata;
+
+	port = to_usb_serial_port(dev);
+	intfdata = port->serial->private;
+
+	return snprintf(buf, PORTION_LEN,
+		"rx: %i B\tindat: %i\tindat err: %i\n"
+		"tx: %i B\toutdat: %i\toutdat err: %i\n"
+		"writes: %i\t\twrite err: %i\n"
+		"delayed writes: %i\tdelayed write err: %i\n",
+		atomic_read(&intfdata->stats.rx_bytes),	atomic_read(&intfdata->stats.indat_cb_cnt), atomic_read(&intfdata->stats.indat_cb_fail),
+		atomic_read(&intfdata->stats.tx_bytes), atomic_read(&intfdata->stats.outdat_cb_cnt), atomic_read(&intfdata->stats.outdat_cb_fail),
+		atomic_read(&intfdata->stats.write_cnt), atomic_read(&intfdata->stats.write_err),
+		atomic_read(&intfdata->stats.delayed_writes), atomic_read(&intfdata->stats.delayed_write_err)
+	);
+}
+
+/* Read only suspend status */
+static DEVICE_ATTR(suspend_status, S_IWUSR | S_IRUGO, show_suspend_status,
+							NULL);
+
+/* Read only statistics */
+static DEVICE_ATTR(stats, S_IWUSR | S_IRUGO, show_stats, NULL);
+
+static int sierra_create_sysfs_attrs(struct usb_serial_port *port)
+{
+	int result = 0;
+
+	result = device_create_file(&port->dev, &dev_attr_stats);
+	if (unlikely (result < 0)) 
+		return result;
+	return device_create_file(&port->dev, &dev_attr_suspend_status);
+}
+
+static int sierra_remove_sysfs_attrs(struct usb_serial_port *port)
+{
+	device_remove_file(&port->dev, &dev_attr_stats);
+	device_remove_file(&port->dev, &dev_attr_suspend_status);
+	return 0;
+}
+
 static void sierra_outdat_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
@@ -455,16 +600,20 @@ static void sierra_outdat_callback(struct urb *urb)
 	dev_dbg(&port->dev, "%s - port %d\n", __func__, port->number);
 	intfdata = port->serial->private;
 
-	/* free up the transfer buffer, as usb_free_urb() does not do this */
-	kfree(urb->transfer_buffer);
 	usb_autopm_put_interface_async(port->serial->interface);
-	if (status)
+
+	atomic_inc(&intfdata->stats.outdat_cb_cnt);
+
+	if (status) {
 		dev_dbg(&port->dev, "%s - nonzero write bulk status "
 		    "received: %d\n", __func__, status);
+		atomic_inc(&intfdata->stats.outdat_cb_fail);
+	}
 
 	spin_lock(&portdata->lock);
 	--portdata->outstanding_urbs;
 	spin_unlock(&portdata->lock);
+
 	spin_lock(&intfdata->susp_lock);
 	--intfdata->in_flight;
 	spin_unlock(&intfdata->susp_lock);
@@ -473,10 +622,11 @@ static void sierra_outdat_callback(struct urb *urb)
 }
 
 /* Write */
-static int sierra_write(struct tty_struct *tty, struct usb_serial_port *port,
-					const unsigned char *buf, int count)
+static int sierra_write(struct tty_struct *tty, 
+			struct usb_serial_port *port,
+			const unsigned char *buf, int count)
 {
-	struct sierra_port_private *portdata;
+	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
 	struct sierra_intf_private *intfdata;
 	struct usb_serial *serial = port->serial;
 	unsigned long flags;
@@ -489,46 +639,49 @@ static int sierra_write(struct tty_struct *tty, struct usb_serial_port *port,
 	if (count == 0)
 		return 0;
 
-	portdata = usb_get_serial_port_data(port);
+	dev_dbg(&port->dev, "%s: write (%zu bytes)\n", __func__, writesize);
+
 	intfdata = serial->private;
 
-	dev_dbg(&port->dev, "%s: write (%zd bytes)\n", __func__, writesize);
 	spin_lock_irqsave(&portdata->lock, flags);
-	dev_dbg(&port->dev, "%s - outstanding_urbs: %d\n", __func__,
-		portdata->outstanding_urbs);
 	if (portdata->outstanding_urbs > portdata->num_out_urbs) {
 		spin_unlock_irqrestore(&portdata->lock, flags);
 		dev_dbg(&port->dev, "%s - write limit hit\n", __func__);
 		return 0;
 	}
 	portdata->outstanding_urbs++;
-	dev_dbg(&port->dev, "%s - 1, outstanding_urbs: %d\n", __func__,
-		portdata->outstanding_urbs);
 	spin_unlock_irqrestore(&portdata->lock, flags);
 
 	retval = usb_autopm_get_interface_async(serial->interface);
-	if (retval < 0) {
+	if (unlikely(retval < 0)) {
 		spin_lock_irqsave(&portdata->lock, flags);
 		portdata->outstanding_urbs--;
 		spin_unlock_irqrestore(&portdata->lock, flags);
-		goto error_simple;
+		return retval;
 	}
 
 	buffer = kmalloc(writesize, GFP_ATOMIC);
 	if (!buffer) {
 		dev_err(&port->dev, "out of memory\n");
-		retval = -ENOMEM;
-		goto error_no_buffer;
+		spin_lock_irqsave(&portdata->lock, flags);
+		--portdata->outstanding_urbs;
+		spin_unlock_irqrestore(&portdata->lock, flags);
+		usb_autopm_put_interface_async(serial->interface);
+		return -ENOMEM;
 	}
 
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
 		dev_err(&port->dev, "no more free urbs\n");
-		retval = -ENOMEM;
-		goto error_no_urb;
+		kfree(buffer);
+		spin_lock_irqsave(&portdata->lock, flags);
+		--portdata->outstanding_urbs;
+		spin_unlock_irqrestore(&portdata->lock, flags);
+		usb_autopm_put_interface_async(serial->interface);
+		return -ENOMEM;
 	}
 
-	memcpy(buffer, buf, writesize);
+	memcpy(buffer, buf, writesize); 
 
 	usb_serial_debug_data(debug, &port->dev, __func__, writesize, buffer);
 
@@ -537,69 +690,73 @@ static int sierra_write(struct tty_struct *tty, struct usb_serial_port *port,
 					  port->bulk_out_endpointAddress),
 			  buffer, writesize, sierra_outdat_callback, port);
 
-	/* Handle the need to send a zero length packet */
-	urb->transfer_flags |= URB_ZERO_PACKET;
+	/* Handle the need to send a zero length packet and release the
+	 * transfer buffer
+	 */
+	urb->transfer_flags |= (URB_ZERO_PACKET | URB_FREE_BUFFER);
 
 	spin_lock_irqsave(&intfdata->susp_lock, flags);
 
 	if (intfdata->suspended) {
 		usb_anchor_urb(urb, &portdata->delayed);
 		spin_unlock_irqrestore(&intfdata->susp_lock, flags);
-		goto skip_power;
-	} else {
-		usb_anchor_urb(urb, &portdata->active);
+		/* release our reference to this urb, the USB core will 
+		 * eventually free it entirely */
+		usb_free_urb(urb);
+		return writesize;
 	}
+	usb_anchor_urb(urb, &portdata->active);
+
 	/* send it down the pipe */
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval) {
 		usb_unanchor_urb(urb);
 		spin_unlock_irqrestore(&intfdata->susp_lock, flags);
+
 		dev_err(&port->dev, "%s - usb_submit_urb(write bulk) failed "
 			"with status = %d\n", __func__, retval);
-		goto error;
+		usb_free_urb(urb);
+		spin_lock_irqsave(&portdata->lock, flags);
+		--portdata->outstanding_urbs;
+		spin_unlock_irqrestore(&portdata->lock, flags);
+		usb_autopm_put_interface_async(serial->interface);
+		atomic_inc(&intfdata->stats.write_err);
+		return retval;
 	} else {
 		intfdata->in_flight++;
 		spin_unlock_irqrestore(&intfdata->susp_lock, flags);
+		atomic_inc(&intfdata->stats.write_cnt);
+		atomic_add(writesize, &intfdata->stats.tx_bytes);
 	}
-
-skip_power:
-	/* we are done with this urb, so let the host driver
-	 * really free it when it is finished with it */
-	usb_free_urb(urb);
+	/* release our reference to this urb, the USB core will eventually
+	 * free it entirely */
+	usb_free_urb(urb); 
 
 	return writesize;
-error:
-	usb_free_urb(urb);
-error_no_urb:
-	kfree(buffer);
-error_no_buffer:
-	spin_lock_irqsave(&portdata->lock, flags);
-	--portdata->outstanding_urbs;
-	dev_dbg(&port->dev, "%s - 2. outstanding_urbs: %d\n", __func__,
-		portdata->outstanding_urbs);
-	spin_unlock_irqrestore(&portdata->lock, flags);
-	usb_autopm_put_interface_async(serial->interface);
-error_simple:
-	return retval;
 }
 
 static void sierra_indat_callback(struct urb *urb)
 {
 	int err;
 	int endpoint;
-	struct usb_serial_port *port;
+	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty;
+	struct sierra_intf_private *intfdata;
 	unsigned char *data = urb->transfer_buffer;
 	int status = urb->status;
 
 	endpoint = usb_pipeendpoint(urb->pipe);
-	port = urb->context;
 
 	dev_dbg(&port->dev, "%s: %p\n", __func__, urb);
 
+	intfdata = port->serial->private;
+
+	atomic_inc(&intfdata->stats.indat_cb_cnt); /* indat calls */
+
 	if (status) {
 		dev_dbg(&port->dev, "%s: nonzero status: %d on"
 			" endpoint %02x\n", __func__, status, endpoint);
+		atomic_inc(&intfdata->stats.indat_cb_fail); /* indat fails */
 	} else {
 		if (urb->actual_length) {
 			tty = tty_port_tty_get(&port->port);
@@ -609,6 +766,10 @@ static void sierra_indat_callback(struct urb *urb)
 				tty_flip_buffer_push(tty);
 
 				tty_kref_put(tty);
+				/* tty invalid after this point */
+				/* rx'd bytes */
+				atomic_add(urb->actual_length,
+				&intfdata->stats.rx_bytes);
 				usb_serial_debug_data(debug, &port->dev,
 					__func__, urb->actual_length, data);
 			}
@@ -619,13 +780,15 @@ static void sierra_indat_callback(struct urb *urb)
 	}
 
 	/* Resubmit urb so we continue receiving */
-	if (status != -ESHUTDOWN && status != -EPERM) {
+	if (status != -ESHUTDOWN && status != -ENOENT && status != -ENODEV) {
 		usb_mark_last_busy(port->serial->dev);
 		err = usb_submit_urb(urb, GFP_ATOMIC);
-		if (err && err != -EPERM)
+		if (err && err != -ENODEV)
 			dev_err(&port->dev, "resubmit read urb failed."
 				"(%d)\n", err);
 	}
+
+	return;
 }
 
 static void sierra_instat_callback(struct urb *urb)
@@ -636,31 +799,29 @@ static void sierra_instat_callback(struct urb *urb)
 	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
 	struct usb_serial *serial = port->serial;
 
-	dev_dbg(&port->dev, "%s: urb %p port %p has data %p\n", __func__,
-		urb, port, portdata);
+	dev_dbg(&port->dev, "%s: %p\n", __func__, urb);
 
 	if (status == 0) {
 		struct usb_ctrlrequest *req_pkt =
 				(struct usb_ctrlrequest *)urb->transfer_buffer;
 
-		if (!req_pkt) {
-			dev_dbg(&port->dev, "%s: NULL req_pkt\n",
-				__func__);
-			return;
-		}
-		if ((req_pkt->bRequestType == 0xA1) &&
-				(req_pkt->bRequest == 0x20)) {
+		const u16 *sigp = (u16 *)(req_pkt + 1);
+		/* usb_ctrlrequest we parsed is followed by two bytes of data
+		 * make sure we received that many bytes
+		 */
+		if (urb->actual_length >= sizeof(*req_pkt) + sizeof(*sigp) &&
+			req_pkt->bRequestType == USB_REQUEST_TYPE_CLASS && 
+			req_pkt->bRequest == USB_REQUEST_IFACE) {
 			int old_dcd_state;
-			unsigned char signals = *((unsigned char *)
-					urb->transfer_buffer +
-					sizeof(struct usb_ctrlrequest));
+			const u16 signals = get_unaligned_le16(sigp);
 			struct tty_struct *tty;
 
-			dev_dbg(&port->dev, "%s: signal x%x\n", __func__,
+			dev_dbg(&port->dev, "%s: signal 0x%x\n", __func__,
 				signals);
 
 			old_dcd_state = portdata->dcd_state;
-			portdata->cts_state = 1;
+			/* Note: CTS from modem is in reverse logic! */
+			portdata->cts_state = ((signals & 0x100) ? 0 : 1);
 			portdata->dcd_state = ((signals & 0x01) ? 1 : 0);
 			portdata->dsr_state = ((signals & 0x02) ? 1 : 0);
 			portdata->ri_state = ((signals & 0x08) ? 1 : 0);
@@ -671,18 +832,19 @@ static void sierra_instat_callback(struct urb *urb)
 				tty_hangup(tty);
 			tty_kref_put(tty);
 		} else {
-			dev_dbg(&port->dev, "%s: type %x req %x\n",
-				__func__, req_pkt->bRequestType,
-				req_pkt->bRequest);
+			/* dump the data we don't understand to log */
+			usb_serial_debug_data(1, &port->dev, __func__,
+				urb->actual_length, urb->transfer_buffer);
 		}
 	} else
 		dev_dbg(&port->dev, "%s: error %d\n", __func__, status);
 
 	/* Resubmit urb so we continue receiving IRQ data */
-	if (status != -ESHUTDOWN && status != -ENOENT) {
+	if (status != -ESHUTDOWN && status != -ENOENT && status != -ENODEV) {
 		usb_mark_last_busy(serial->dev);
+		urb->dev = serial->dev;
 		err = usb_submit_urb(urb, GFP_ATOMIC);
-		if (err && err != -EPERM)
+		if (err && err != -ENODEV)
 			dev_err(&port->dev, "%s: resubmit intr urb "
 				"failed. (%d)\n", __func__, err);
 	}
@@ -693,20 +855,21 @@ static int sierra_write_room(struct tty_struct *tty)
 	struct usb_serial_port *port = tty->driver_data;
 	struct sierra_port_private *portdata = usb_get_serial_port_data(port);
 	unsigned long flags;
+	int retval;
 
 	dev_dbg(&port->dev, "%s - port %d\n", __func__, port->number);
 
 	/* try to give a good number back based on if we have any free urbs at
 	 * this point in time */
+	retval = MAX_TRANSFER;
+
 	spin_lock_irqsave(&portdata->lock, flags);
-	if (portdata->outstanding_urbs > (portdata->num_out_urbs * 2) / 3) {
-		spin_unlock_irqrestore(&portdata->lock, flags);
-		dev_dbg(&port->dev, "%s - write limit hit\n", __func__);
-		return 0;
+	if (portdata->outstanding_urbs >= portdata->num_out_urbs) {
+		retval = 0;
 	}
 	spin_unlock_irqrestore(&portdata->lock, flags);
 
-	return 2048;
+	return retval;
 }
 
 static void sierra_stop_rx_urbs(struct usb_serial_port *port)
@@ -733,6 +896,7 @@ static int sierra_submit_rx_urbs(struct usb_serial_port *port, gfp_t mem_flags)
 		urb = portdata->in_urbs[i];
 		if (!urb)
 			continue;
+		urb->transfer_flags |= URB_FREE_BUFFER;
 		err = usb_submit_urb(urb, mem_flags);
 		if (err) {
 			dev_err(&port->dev, "%s: submit urb failed: %d\n",
@@ -794,38 +958,31 @@ static struct urb *sierra_setup_urb(struct usb_serial *serial, int endpoint,
 
 	return urb;
 }
-
 static void sierra_close(struct usb_serial_port *port)
 {
 	int i;
+	struct urb	*urb;
 	struct usb_serial *serial = port->serial;
 	struct sierra_port_private *portdata;
 	struct sierra_intf_private *intfdata = port->serial->private;
 
-
 	dev_dbg(&port->dev, "%s\n", __func__);
 	portdata = usb_get_serial_port_data(port);
 
 	portdata->rts_state = 0;
 	portdata->dtr_state = 0;
 
+	usb_autopm_get_interface(serial->interface);
+
 	if (serial->dev) {
 		mutex_lock(&serial->disc_mutex);
-		if (!serial->disconnected) {
-			serial->interface->needs_remote_wakeup = 0;
-			/* odd error handling due to pm counters */
-			if (!usb_autopm_get_interface(serial->interface))
-				sierra_send_setup(port);
-			else
-				usb_autopm_get_interface_no_resume(serial->interface);
-				
-		}
+		if (!serial->disconnected)
+			sierra_send_setup(port);
 		mutex_unlock(&serial->disc_mutex);
 		spin_lock_irq(&intfdata->susp_lock);
 		portdata->opened = 0;
 		spin_unlock_irq(&intfdata->susp_lock);
 
-
 		/* Stop reading urbs */
 		sierra_stop_rx_urbs(port);
 		/* .. and release them */
@@ -833,6 +990,14 @@ static void sierra_close(struct usb_serial_port *port)
 			sierra_release_urb(portdata->in_urbs[i]);
 			portdata->in_urbs[i] = NULL;
 		}
+		while((urb = usb_get_from_anchor(&portdata->delayed))) {
+			sierra_release_urb(urb);
+			usb_autopm_put_interface(serial->interface);
+		}
+		/* wait for active to finish */
+		usb_wait_anchor_empty_timeout(&portdata->active, 500);
+		usb_kill_anchored_urbs(&portdata->active);
+
 	}
 }
 
@@ -866,18 +1031,41 @@ static int sierra_open(struct tty_struct *tty, struct usb_serial_port *port)
 	usb_clear_halt(serial->dev,
 			usb_sndbulkpipe(serial->dev, endpoint) | USB_DIR_IN);
 
+	/* reset outstanding out urbs counter */
+	spin_lock_irq(&portdata->lock);
+	portdata->outstanding_urbs = 0;
+	spin_unlock_irq(&portdata->lock);
+
 	err = sierra_submit_rx_urbs(port, GFP_KERNEL);
 	if (err) {
-		/* get rid of everything as in close */
-		sierra_close(port);
-		/* restore balance for autopm */
-		if (!serial->disconnected)
+		/* do everything as in close() but do not call close() because
+		 * usbserial calls sierra_open() with mutex taken;
+		 * then if we call sierra_close() inside sierra_open() we
+		 * violate 'no nested mutexes' kernel condition
+		 */
+		portdata->rts_state = 0;
+		portdata->dtr_state = 0;
+		usb_autopm_get_interface(serial->interface);
+		/* Stop reading urbs */
+		sierra_stop_rx_urbs(port);
+		/* .. and release them */
+		for (i = 0; i < portdata->num_in_urbs; i++) {
+			sierra_release_urb(portdata->in_urbs[i]);
+			portdata->in_urbs[i] = NULL;
+		}
+		while((urb = usb_get_from_anchor(&portdata->delayed))) {
+			sierra_release_urb(urb);
 			usb_autopm_put_interface(serial->interface);
+		}
+		/* wait for active to finish */
+		usb_wait_anchor_empty_timeout(&portdata->active, 500);
+		usb_kill_anchored_urbs(&portdata->active);
+		/* restore balance for autopm */
+		usb_autopm_put_interface(serial->interface);
 		return err;
 	}
 	sierra_send_setup(port);
 
-	serial->interface->needs_remote_wakeup = 1;
 	spin_lock_irq(&intfdata->susp_lock);
 	portdata->opened = 1;
 	spin_unlock_irq(&intfdata->susp_lock);
@@ -886,7 +1074,6 @@ static int sierra_open(struct tty_struct *tty, struct usb_serial_port *port)
 	return 0;
 }
 
-
 static void sierra_dtr_rts(struct usb_serial_port *port, int on)
 {
 	struct usb_serial *serial = port->serial;
@@ -906,11 +1093,13 @@ static void sierra_dtr_rts(struct usb_serial_port *port, int on)
 
 static int sierra_startup(struct usb_serial *serial)
 {
-	struct usb_serial_port *port;
-	struct sierra_port_private *portdata;
+	struct usb_serial_port *port = NULL;
+	struct sierra_port_private *portdata = NULL;
 	struct sierra_iface_info *himemoryp = NULL;
 	int i;
 	u8 ifnum;
+	u16 fw_attr;
+	int result;
 
 	dev_dbg(&serial->dev->dev, "%s\n", __func__);
 
@@ -921,19 +1110,30 @@ static int sierra_startup(struct usb_serial *serial)
 	if (nmea)
 		sierra_vsc_set_nmea(serial->dev, 1);
 
-	/* Now setup per port private data */
-	for (i = 0; i < serial->num_ports; i++) {
-		port = serial->port[i];
-		portdata = kzalloc(sizeof(*portdata), GFP_KERNEL);
+	if (serial->num_ports) {
+		/* Note: One big piece of memory is allocated for all ports 
+		 * private data in one shot. This memory is split into equal 
+		 * pieces for each port. 
+		 */
+		portdata = (struct sierra_port_private *)kzalloc
+			(sizeof(*portdata) * serial->num_ports, GFP_KERNEL);
 		if (!portdata) {
-			dev_dbg(&port->dev, "%s: kmalloc for "
-				"sierra_port_private (%d) failed!\n",
-				__func__, i);
+			dev_dbg(&serial->dev->dev, "%s: No memory!\n", __func__);
 			return -ENOMEM;
 		}
+	}
+
+	/* Now setup per port private data */
+	for (i = 0; i < serial->num_ports; i++, portdata++) {
+		port = serial->port[i];
+		/* Initialize selected members of private data because these
+		 * may be referred to right away */
 		spin_lock_init(&portdata->lock);
 		init_usb_anchor(&portdata->active);
 		init_usb_anchor(&portdata->delayed);
+
+		portdata->cts_state = 1;
+
 		ifnum = i;
 		/* Assume low memory requirements */
 		portdata->num_out_urbs = N_OUT_URB;
@@ -958,12 +1158,29 @@ static int sierra_startup(struct usb_serial *serial)
 				portdata->num_in_urbs  = N_IN_URB_HM;
 			}
 		}
-		dev_dbg(&serial->dev->dev,
+		dev_dbg(&serial->dev->dev, 
 			"Memory usage (urbs) interface #%d, in=%d, out=%d\n",
 			ifnum,portdata->num_in_urbs, portdata->num_out_urbs );
 		/* Set the port private data pointer */
 		usb_set_serial_port_data(port, portdata);
 	}
+	serial->interface->needs_remote_wakeup = 1;
+
+	result = sierra_get_fw_attr(serial->dev, &fw_attr);
+	if (result == sizeof(fw_attr) && (fw_attr & SWI_FW_ATTR_PM_MASK) ) {
+		dev_info(&serial->dev->dev,
+			"APM supported, enabling autosuspend.\n");
+/******************************************************************************* 
+ * If you want the default /sys/bus/usb/devices/.../.../power/level to be forced
+ * to auto, the following needs to be compiled in.
+ */ 
+#ifdef POWER_LEVEL_AUTO
+		/* make power level default be 'auto' */
+		usb_enable_autosuspend(serial->dev);
+#endif
+	} else {
+		usb_disable_autosuspend(serial->dev);
+	}
 
 	return 0;
 }
@@ -972,19 +1189,29 @@ static void sierra_release(struct usb_serial *serial)
 {
 	int i;
 	struct usb_serial_port *port;
-	struct sierra_port_private *portdata;
+	struct sierra_intf_private *intfdata = serial->private;
 
 	dev_dbg(&serial->dev->dev, "%s\n", __func__);
 
+	if (serial->num_ports > 0) {
+		port = serial->port[0];
+		if (port)
+			/* Note: The entire piece of memory that was allocated 
+			 * in the startup routine can be released by passing
+			 * a pointer to the beginning of the piece.
+			 * This address corresponds to the address of the chunk
+			 * that was given to port 0.
+		 	 */
+			kfree(usb_get_serial_port_data(port));
+	}
+
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		if (!port)
 			continue;
-		portdata = usb_get_serial_port_data(port);
-		if (!portdata)
-			continue;
-		kfree(portdata);
+		usb_set_serial_port_data(port, NULL);
 	}
+	kfree(intfdata);
 }
 
 #ifdef CONFIG_PM
@@ -1006,21 +1233,21 @@ static void stop_read_write_urbs(struct usb_serial *serial)
 static int sierra_suspend(struct usb_serial *serial, pm_message_t message)
 {
 	struct sierra_intf_private *intfdata;
-	int b;
 
-	if (PMSG_IS_AUTO(message)) {
-		intfdata = serial->private;
-		spin_lock_irq(&intfdata->susp_lock);
-		b = intfdata->in_flight;
+	dev_dbg(&serial->dev->dev, "%s\n", __func__);
+
+	intfdata = serial->private;
+	spin_lock_irq(&intfdata->susp_lock);
 
-		if (b) {
+	if (message.event & PM_EVENT_AUTO) {
+		if (intfdata->in_flight) {
 			spin_unlock_irq(&intfdata->susp_lock);
 			return -EBUSY;
-		} else {
-			intfdata->suspended = 1;
-			spin_unlock_irq(&intfdata->susp_lock);
 		}
 	}
+	intfdata->suspended = 1;
+	spin_unlock_irq(&intfdata->susp_lock);
+
 	stop_read_write_urbs(serial);
 
 	return 0;
@@ -1034,22 +1261,35 @@ static int sierra_resume(struct usb_serial *serial)
 	struct urb *urb;
 	int ec = 0;
 	int i, err;
+	int len;
+	int failed_submits;
 
+	dev_dbg(&serial->dev->dev, "%s\n", __func__);
+	
 	spin_lock_irq(&intfdata->susp_lock);
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
-
+		failed_submits = 0;
 		while ((urb = usb_get_from_anchor(&portdata->delayed))) {
 			usb_anchor_urb(urb, &portdata->active);
 			intfdata->in_flight++;
+			len = urb->transfer_buffer_length;
 			err = usb_submit_urb(urb, GFP_ATOMIC);
 			if (err < 0) {
 				intfdata->in_flight--;
 				usb_unanchor_urb(urb);
-				usb_scuttle_anchored_urbs(&portdata->delayed);
-				break;
+				failed_submits++;
+				atomic_inc(&intfdata->stats.delayed_write_err);
+				/* fix pm_usage_cnt */
+				usb_autopm_put_interface_async(
+					port->serial->interface);
+			} else {
+				atomic_inc(&intfdata->stats.delayed_writes);
+				atomic_add(len, &intfdata->stats.tx_bytes);
 			}
+			/* release urb - usb_get_from_anchor increased kref */
+			usb_free_urb(urb);
 		}
 
 		if (portdata->opened) {
@@ -1057,12 +1297,24 @@ static int sierra_resume(struct usb_serial *serial)
 			if (err)
 				ec++;
 		}
+		if (failed_submits) {
+			/* fix outstanding_urbs counter */
+			spin_lock(&portdata->lock); /* assuming irq disabled */
+			portdata->outstanding_urbs -= failed_submits;
+			spin_unlock(&portdata->lock);
+			/* unblock a writer */
+			usb_serial_port_softint(port);
+		}
 	}
 	intfdata->suspended = 0;
 	spin_unlock_irq(&intfdata->susp_lock);
 
 	return ec ? -EIO : 0;
 }
+#else
+#define sierra_suspend NULL
+#define sierra_resume NULL
+#endif
 
 static int sierra_reset_resume(struct usb_interface *intf)
 {
@@ -1070,11 +1322,6 @@ static int sierra_reset_resume(struct usb_interface *intf)
 	dev_err(&serial->dev->dev, "%s\n", __func__);
 	return usb_serial_resume(intf);
 }
-#else
-#define sierra_suspend NULL
-#define sierra_resume NULL
-#define sierra_reset_resume NULL
-#endif
 
 static struct usb_driver sierra_driver = {
 	.name       = "sierra",
@@ -1084,10 +1331,12 @@ static struct usb_driver sierra_driver = {
 	.resume     = usb_serial_resume,
 	.reset_resume = sierra_reset_resume,
 	.id_table   = id_table,
-	.no_dynamic_id = 	1,
-	.supports_autosuspend =	1,
+
+	.no_dynamic_id        =	1,
+	.supports_autosuspend = 1,
 };
 
+
 static struct usb_serial_driver sierra_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
@@ -1108,9 +1357,12 @@ static struct usb_serial_driver sierra_device = {
 	.tiocmset          = sierra_tiocmset,
 	.attach            = sierra_startup,
 	.release           = sierra_release,
-	.suspend	   = sierra_suspend,
-	.resume		   = sierra_resume,
+	.port_probe        = sierra_create_sysfs_attrs,
+	.port_remove       = sierra_remove_sysfs_attrs,
+	.suspend           = sierra_suspend,
+	.resume            = sierra_resume,
 	.read_int_callback = sierra_instat_callback,
+
 };
 
 /* Functions used by new usb-serial code. */
@@ -1121,7 +1373,6 @@ static int __init sierra_init(void)
 	if (retval)
 		goto failed_device_register;
 
-
 	retval = usb_register(&sierra_driver);
 	if (retval)
 		goto failed_driver_register;
@@ -1151,8 +1402,9 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
-module_param(nmea, bool, S_IRUGO | S_IWUSR);
+module_param(nmea, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(nmea, "NMEA streaming");
 
-module_param(debug, bool, S_IRUGO | S_IWUSR);
+module_param(debug, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug messages");
+
-- 
1.7.5.4

