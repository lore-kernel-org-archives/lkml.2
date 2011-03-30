Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab1C3WL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:11:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:16640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140Ab1C3VGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132770"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: plagnioj@jcrosoft.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [27/275] USB: ftdi_sio: add ST Micro Connect Lite uart support
Message-Id: <20110330210422.200A43E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit 6ec2f46c4b4abf48c88c0ae7c476f347b97e1105 upstream.

on ST Micro Connect Lite we have 4 port
Part A and B for the JTAG
Port C Uart
Port D for PIO

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ftdi_sio.c     |   26 ++++++++++++++++++++++++++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 32 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio.c	2011-03-29 23:02:58.615335600 -0700
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio.c	2011-03-29 23:55:28.414740114 -0700
@@ -99,6 +99,7 @@
 static int   ftdi_jtag_probe(struct usb_serial *serial);
 static int   ftdi_mtxorb_hack_setup(struct usb_serial *serial);
 static int   ftdi_NDI_device_setup(struct usb_serial *serial);
+static int   ftdi_stmclite_probe(struct usb_serial *serial);
 static void  ftdi_USB_UIRT_setup(struct ftdi_private *priv);
 static void  ftdi_HE_TIRA1_setup(struct ftdi_private *priv);
 
@@ -122,6 +123,10 @@
 	.port_probe = ftdi_HE_TIRA1_setup,
 };
 
+static struct ftdi_sio_quirk ftdi_stmclite_quirk = {
+	.probe	= ftdi_stmclite_probe,
+};
+
 /*
  * The 8U232AM has the same API as the sio except for:
  * - it can support MUCH higher baudrates; up to:
@@ -809,6 +814,8 @@
 	{ USB_DEVICE(FTDI_VID, FTDI_DOTEC_PID) },
 	{ USB_DEVICE(QIHARDWARE_VID, MILKYMISTONE_JTAGSERIAL_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(ST_VID, ST_STMCLT1030_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_stmclite_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
@@ -1690,6 +1697,25 @@
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
Index: linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ftdi_sio_ids.h	2011-03-29 23:02:58.616335575 -0700
+++ linux-2.6.35.y/drivers/usb/serial/ftdi_sio_ids.h	2011-03-29 23:55:28.414740114 -0700
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
