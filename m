Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694Ab2C3V4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:56:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965626Ab2C3VSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:18:37 -0400
Message-Id: <20120330194831.654083020@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Williams <dcbw@redhat.com>
Subject: [ 038/175] USB: qcserial: dont grab QMI port on Gobi 1000 devices
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit c192c8e71a2ded01170c1a992cd21aaedc822756 upstream.

Gobi 1000 devices have a different port layout, which wasn't respected
by the current driver, and thus it grabbed the QMI/net port.  In the
near future we'll be attaching another driver to the QMI/net port for
these devices (cdc-wdm and qmi_wwan) so make sure the qcserial driver
doesn't claim them.  This patch also prevents qcserial from binding to
interfaces 0 and 1 on 1K devices because those interfaces do not
respond.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |  105 ++++++++++++++++++++++++------------------
 1 file changed, 62 insertions(+), 43 deletions(-)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -24,39 +24,44 @@
 
 static bool debug;
 
+#define DEVICE_G1K(v, p) \
+	USB_DEVICE(v, p), .driver_info = 1
+
 static const struct usb_device_id id_table[] = {
-	{USB_DEVICE(0x05c6, 0x9211)},	/* Acer Gobi QDL device */
-	{USB_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-	{USB_DEVICE(0x03f0, 0x1f1d)},	/* HP un2400 Gobi Modem Device */
-	{USB_DEVICE(0x03f0, 0x201d)},	/* HP un2400 Gobi QDL Device */
-	{USB_DEVICE(0x03f0, 0x371d)},	/* HP un2430 Mobile Broadband Module */
-	{USB_DEVICE(0x04da, 0x250d)},	/* Panasonic Gobi Modem device */
-	{USB_DEVICE(0x04da, 0x250c)},	/* Panasonic Gobi QDL device */
-	{USB_DEVICE(0x413c, 0x8172)},	/* Dell Gobi Modem device */
-	{USB_DEVICE(0x413c, 0x8171)},	/* Dell Gobi QDL device */
-	{USB_DEVICE(0x1410, 0xa001)},	/* Novatel Gobi Modem device */
-	{USB_DEVICE(0x1410, 0xa008)},	/* Novatel Gobi QDL device */
-	{USB_DEVICE(0x1410, 0xa010)},	/* Novatel Gobi QDL device */
-	{USB_DEVICE(0x1410, 0xa011)},	/* Novatel Gobi QDL device */
-	{USB_DEVICE(0x1410, 0xa012)},	/* Novatel Gobi QDL device */
-	{USB_DEVICE(0x1410, 0xa013)},	/* Novatel Gobi QDL device */
-	{USB_DEVICE(0x1410, 0xa014)},	/* Novatel Gobi QDL device */
-	{USB_DEVICE(0x0b05, 0x1776)},	/* Asus Gobi Modem device */
-	{USB_DEVICE(0x0b05, 0x1774)},	/* Asus Gobi QDL device */
-	{USB_DEVICE(0x19d2, 0xfff3)},	/* ONDA Gobi Modem device */
-	{USB_DEVICE(0x19d2, 0xfff2)},	/* ONDA Gobi QDL device */
-	{USB_DEVICE(0x1557, 0x0a80)},	/* OQO Gobi QDL device */
-	{USB_DEVICE(0x05c6, 0x9001)},   /* Generic Gobi Modem device */
-	{USB_DEVICE(0x05c6, 0x9002)},	/* Generic Gobi Modem device */
-	{USB_DEVICE(0x05c6, 0x9202)},	/* Generic Gobi Modem device */
-	{USB_DEVICE(0x05c6, 0x9203)},	/* Generic Gobi Modem device */
-	{USB_DEVICE(0x05c6, 0x9222)},	/* Generic Gobi Modem device */
-	{USB_DEVICE(0x05c6, 0x9008)},	/* Generic Gobi QDL device */
-	{USB_DEVICE(0x05c6, 0x9009)},	/* Generic Gobi Modem device */
-	{USB_DEVICE(0x05c6, 0x9201)},	/* Generic Gobi QDL device */
-	{USB_DEVICE(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
-	{USB_DEVICE(0x05c6, 0x9231)},	/* Generic Gobi QDL device */
-	{USB_DEVICE(0x1f45, 0x0001)},	/* Unknown Gobi QDL device */
+	/* Gobi 1000 devices */
+	{DEVICE_G1K(0x05c6, 0x9211)},	/* Acer Gobi QDL device */
+	{DEVICE_G1K(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
+	{DEVICE_G1K(0x03f0, 0x1f1d)},	/* HP un2400 Gobi Modem Device */
+	{DEVICE_G1K(0x03f0, 0x201d)},	/* HP un2400 Gobi QDL Device */
+	{DEVICE_G1K(0x04da, 0x250d)},	/* Panasonic Gobi Modem device */
+	{DEVICE_G1K(0x04da, 0x250c)},	/* Panasonic Gobi QDL device */
+	{DEVICE_G1K(0x413c, 0x8172)},	/* Dell Gobi Modem device */
+	{DEVICE_G1K(0x413c, 0x8171)},	/* Dell Gobi QDL device */
+	{DEVICE_G1K(0x1410, 0xa001)},	/* Novatel Gobi Modem device */
+	{DEVICE_G1K(0x1410, 0xa008)},	/* Novatel Gobi QDL device */
+	{DEVICE_G1K(0x0b05, 0x1776)},	/* Asus Gobi Modem device */
+	{DEVICE_G1K(0x0b05, 0x1774)},	/* Asus Gobi QDL device */
+	{DEVICE_G1K(0x19d2, 0xfff3)},	/* ONDA Gobi Modem device */
+	{DEVICE_G1K(0x19d2, 0xfff2)},	/* ONDA Gobi QDL device */
+	{DEVICE_G1K(0x1557, 0x0a80)},	/* OQO Gobi QDL device */
+	{DEVICE_G1K(0x05c6, 0x9001)},   /* Generic Gobi Modem device */
+	{DEVICE_G1K(0x05c6, 0x9002)},	/* Generic Gobi Modem device */
+	{DEVICE_G1K(0x05c6, 0x9202)},	/* Generic Gobi Modem device */
+	{DEVICE_G1K(0x05c6, 0x9203)},	/* Generic Gobi Modem device */
+	{DEVICE_G1K(0x05c6, 0x9222)},	/* Generic Gobi Modem device */
+	{DEVICE_G1K(0x05c6, 0x9008)},	/* Generic Gobi QDL device */
+	{DEVICE_G1K(0x05c6, 0x9009)},	/* Generic Gobi Modem device */
+	{DEVICE_G1K(0x05c6, 0x9201)},	/* Generic Gobi QDL device */
+	{DEVICE_G1K(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
+	{DEVICE_G1K(0x05c6, 0x9231)},	/* Generic Gobi QDL device */
+	{DEVICE_G1K(0x1f45, 0x0001)},	/* Unknown Gobi QDL device */
+
+	/* Gobi 2000 devices */
+	{USB_DEVICE(0x1410, 0xa010)},	/* Novatel Gobi 2000 QDL device */
+	{USB_DEVICE(0x1410, 0xa011)},	/* Novatel Gobi 2000 QDL device */
+	{USB_DEVICE(0x1410, 0xa012)},	/* Novatel Gobi 2000 QDL device */
+	{USB_DEVICE(0x1410, 0xa013)},	/* Novatel Gobi 2000 QDL device */
+	{USB_DEVICE(0x1410, 0xa014)},	/* Novatel Gobi 2000 QDL device */
 	{USB_DEVICE(0x413c, 0x8185)},	/* Dell Gobi 2000 QDL device (N0218, VU936) */
 	{USB_DEVICE(0x413c, 0x8186)},	/* Dell Gobi 2000 Modem device (N0218, VU936) */
 	{USB_DEVICE(0x05c6, 0x9208)},	/* Generic Gobi 2000 QDL device */
@@ -92,6 +97,8 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(0x05c6, 0x9204)},	/* Gobi 2000 QDL device */
 	{USB_DEVICE(0x05c6, 0x9205)},	/* Gobi 2000 Modem device */
 
+	/* Gobi 3000 devices */
+	{USB_DEVICE(0x03f0, 0x371d)},	/* HP un2430 Gobi 3000 QDL */
 	{USB_DEVICE(0x05c6, 0x920c)},	/* Gobi 3000 QDL */
 	{USB_DEVICE(0x05c6, 0x920d)},	/* Gobi 3000 Composite */
 	{USB_DEVICE(0x1410, 0xa020)},   /* Novatel Gobi 3000 QDL */
@@ -122,8 +129,10 @@ static int qcprobe(struct usb_serial *se
 	int retval = -ENODEV;
 	__u8 nintf;
 	__u8 ifnum;
+	bool is_gobi1k = id->driver_info ? true : false;
 
 	dbg("%s", __func__);
+	dbg("Is Gobi 1000 = %d", is_gobi1k);
 
 	nintf = serial->dev->actconfig->desc.bNumInterfaces;
 	dbg("Num Interfaces = %d", nintf);
@@ -169,15 +178,25 @@ static int qcprobe(struct usb_serial *se
 
 	case 3:
 	case 4:
-		/* Composite mode */
-		/* ifnum == 0 is a broadband network adapter */
-		if (ifnum == 1) {
-			/*
-			 * Diagnostics Monitor (serial line 9600 8N1)
-			 * Qualcomm DM protocol
-			 * use "libqcdm" (ModemManager) for communication
-			 */
-			dbg("Diagnostics Monitor found");
+		/* Composite mode; don't bind to the QMI/net interface as that
+		 * gets handled by other drivers.
+		 */
+
+		/* Gobi 1K USB layout:
+		 * 0: serial port (doesn't respond)
+		 * 1: serial port (doesn't respond)
+		 * 2: AT-capable modem port
+		 * 3: QMI/net
+		 *
+		 * Gobi 2K+ USB layout:
+		 * 0: QMI/net
+		 * 1: DM/DIAG (use libqcdm from ModemManager for communication)
+		 * 2: AT-capable modem port
+		 * 3: NMEA
+		 */
+
+		if (ifnum == 1 && !is_gobi1k) {
+			dbg("Gobi 2K+ DM/DIAG interface found");
 			retval = usb_set_interface(serial->dev, ifnum, 0);
 			if (retval < 0) {
 				dev_err(&serial->dev->dev,
@@ -196,13 +215,13 @@ static int qcprobe(struct usb_serial *se
 				retval = -ENODEV;
 				kfree(data);
 			}
-		} else if (ifnum==3) {
+		} else if (ifnum==3 && !is_gobi1k) {
 			/*
 			 * NMEA (serial line 9600 8N1)
 			 * # echo "\$GPS_START" > /dev/ttyUSBx
 			 * # echo "\$GPS_STOP"  > /dev/ttyUSBx
 			 */
-			dbg("NMEA GPS interface found");
+			dbg("Gobi 2K+ NMEA GPS interface found");
 			retval = usb_set_interface(serial->dev, ifnum, 0);
 			if (retval < 0) {
 				dev_err(&serial->dev->dev,


