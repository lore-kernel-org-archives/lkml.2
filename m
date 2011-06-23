Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab1FWRWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:22:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:62936 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759899Ab1FWRWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 021/247] USB: ftdi_sio: add ST Micro Connect Lite uart support
Date: Thu, 23 Jun 2011 13:17:44 -0400
Message-Id: <1308849690-14530-22-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6ec2f46c4b4abf48c88c0ae7c476f347b97e1105 upstream.

on ST Micro Connect Lite we have 4 port
Part A and B for the JTAG
Port C Uart
Port D for PIO

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |   26 ++++++++++++++++++++++++++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index c2900fc..f4b2527 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -104,6 +104,7 @@ struct ftdi_sio_quirk {
 static int   ftdi_jtag_probe(struct usb_serial *serial);
 static int   ftdi_mtxorb_hack_setup(struct usb_serial *serial);
 static int   ftdi_NDI_device_setup(struct usb_serial *serial);
+static int   ftdi_stmclite_probe(struct usb_serial *serial);
 static void  ftdi_USB_UIRT_setup(struct ftdi_private *priv);
 static void  ftdi_HE_TIRA1_setup(struct ftdi_private *priv);
 
@@ -127,6 +128,10 @@ static struct ftdi_sio_quirk ftdi_HE_TIRA1_quirk = {
 	.port_probe = ftdi_HE_TIRA1_setup,
 };
 
+static struct ftdi_sio_quirk ftdi_stmclite_quirk = {
+	.probe	= ftdi_stmclite_probe,
+};
+
 /*
  * The 8U232AM has the same API as the sio except for:
  * - it can support MUCH higher baudrates; up to:
@@ -815,6 +820,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_DOTEC_PID) },
 	{ USB_DEVICE(QIHARDWARE_VID, MILKYMISTONE_JTAGSERIAL_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(ST_VID, ST_STMCLT1030_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_stmclite_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
@@ -1735,6 +1742,25 @@ static int ftdi_jtag_probe(struct usb_serial *serial)
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
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index e3b6807..5f3f5da 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1041,6 +1041,12 @@
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
-- 
1.7.4.4

