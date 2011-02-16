Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1BPBU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:20:58 -0500
Received: from kroah.org ([198.145.64.141]:45252 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932844Ab1BPAsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:02 2011
Message-Id: <20110216002102.001296081@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:19:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [patch 029/176] USB: ftdi_sio: add ST Micro Connect Lite uart support
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit 6ec2f46c4b4abf48c88c0ae7c476f347b97e1105 upstream.

on ST Micro Connect Lite we have 4 port
Part A and B for the JTAG
Port C Uart
Port D for PIO

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |   26 ++++++++++++++++++++++++++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 32 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -99,6 +99,7 @@ struct ftdi_sio_quirk {
 static int   ftdi_jtag_probe(struct usb_serial *serial);
 static int   ftdi_mtxorb_hack_setup(struct usb_serial *serial);
 static int   ftdi_NDI_device_setup(struct usb_serial *serial);
+static int   ftdi_stmclite_probe(struct usb_serial *serial);
 static void  ftdi_USB_UIRT_setup(struct ftdi_private *priv);
 static void  ftdi_HE_TIRA1_setup(struct ftdi_private *priv);
 
@@ -122,6 +123,10 @@ static struct ftdi_sio_quirk ftdi_HE_TIR
 	.port_probe = ftdi_HE_TIRA1_setup,
 };
 
+static struct ftdi_sio_quirk ftdi_stmclite_quirk = {
+	.probe	= ftdi_stmclite_probe,
+};
+
 /*
  * The 8U232AM has the same API as the sio except for:
  * - it can support MUCH higher baudrates; up to:
@@ -809,6 +814,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_DOTEC_PID) },
 	{ USB_DEVICE(QIHARDWARE_VID, MILKYMISTONE_JTAGSERIAL_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(ST_VID, ST_STMCLT1030_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_stmclite_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
@@ -1690,6 +1697,25 @@ static int ftdi_jtag_probe(struct usb_se
 }
 
 /*
+ * First and second port on STMCLiteadaptors is reserved for JTAG interface
+ * and the forth port for pio
+ */
+static int ftdi_stmclite_probe(struct usb_serial *serial)
+{
+	struct usb_device *udev = serial->dev;
+	struct usb_interface *interface = serial->interface;
+
+	dbg("%s", __func__);
+
+	if (interface == udev->actconfig->interface[2])
+		return 0;
+
+	dev_info(&udev->dev, "Ignoring serial port reserved for JTAG\n");
+
+	return -ENODEV;
+}
+
+/*
  * The Matrix Orbital VK204-25-USB has an invalid IN endpoint.
  * We have to correct it if we want to read from it.
  */
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1034,6 +1034,12 @@
 #define WHT_PID			0x0004 /* Wireless Handheld Terminal */
 
 /*
+ * STMicroelectonics
+ */
+#define ST_VID			0x0483
+#define ST_STMCLT1030_PID	0x3747 /* ST Micro Connect Lite STMCLT1030 */
+
+/*
  * Papouch products (http://www.papouch.com/)
  * Submitted by Folkert van Heusden
  */


