Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1GHFQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:16:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab1GHFCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:02:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:56 2011
Message-Id: <20110708001656.787329272@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
Subject: [042/107] USB: Add new FT232H chip to drivers/usb/serial/ftdi_sio.c
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>

commit 309427b6351b763917caac3e4b2ab5651df99823 upstream.

appended patch adds support for the new FTDI FT232H chip. This chip is a
single channel version of the dual FT2232H/quad FT4232H, coming with it's
own default PID 0x6014 (FT2232H uses the same PID 0x6010 like FT2232C,
FT4232H has also it's own PID).

The patch was checked on an UM232H module and a terminal program with TX/RX
shorted to that typing in the terminal reproduced the characters.

Signed-off-by: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c     |   19 ++++++++++++++-----
 drivers/usb/serial/ftdi_sio.h     |    3 ++-
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 3 files changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -179,6 +179,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_232RL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_8U2232C_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_4232H_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_232H_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MICRO_CHAMELEON_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RELAIS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_PID) },
@@ -848,7 +849,8 @@ static const char *ftdi_chip_name[] = {
 	[FT2232C] = "FT2232C",
 	[FT232RL] = "FT232RL",
 	[FT2232H] = "FT2232H",
-	[FT4232H] = "FT4232H"
+	[FT4232H] = "FT4232H",
+	[FT232H]  = "FT232H"
 };
 
 
@@ -1168,6 +1170,7 @@ static __u32 get_ftdi_divisor(struct tty
 		break;
 	case FT2232H: /* FT2232H chip */
 	case FT4232H: /* FT4232H chip */
+	case FT232H:  /* FT232H chip */
 		if ((baud <= 12000000) & (baud >= 1200)) {
 			div_value = ftdi_2232h_baud_to_divisor(baud);
 		} else if (baud < 1200) {
@@ -1429,9 +1432,12 @@ static void ftdi_determine_type(struct u
 	} else if (version < 0x600) {
 		/* Assume it's an FT232BM (or FT245BM) */
 		priv->chip_type = FT232BM;
-	} else {
-		/* Assume it's an FT232R */
+	} else if (version < 0x900) {
+		/* Assume it's an FT232RL */
 		priv->chip_type = FT232RL;
+	} else {
+		/* Assume it's an FT232H */
+		priv->chip_type = FT232H;
 	}
 	dev_info(&udev->dev, "Detected %s\n", ftdi_chip_name[priv->chip_type]);
 }
@@ -1559,7 +1565,8 @@ static int create_sysfs_attrs(struct usb
 		     priv->chip_type == FT2232C ||
 		     priv->chip_type == FT232RL ||
 		     priv->chip_type == FT2232H ||
-		     priv->chip_type == FT4232H)) {
+		     priv->chip_type == FT4232H ||
+		     priv->chip_type == FT232H)) {
 			retval = device_create_file(&port->dev,
 						    &dev_attr_latency_timer);
 		}
@@ -1580,7 +1587,8 @@ static void remove_sysfs_attrs(struct us
 		    priv->chip_type == FT2232C ||
 		    priv->chip_type == FT232RL ||
 		    priv->chip_type == FT2232H ||
-		    priv->chip_type == FT4232H) {
+		    priv->chip_type == FT4232H ||
+                    priv->chip_type == FT232H) {
 			device_remove_file(&port->dev, &dev_attr_latency_timer);
 		}
 	}
@@ -2212,6 +2220,7 @@ static int ftdi_tiocmget(struct tty_stru
 	case FT232RL:
 	case FT2232H:
 	case FT4232H:
+	case FT232H:
 		len = 2;
 		break;
 	default:
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -156,7 +156,8 @@ enum ftdi_chip_type {
 	FT2232C = 4,
 	FT232RL = 5,
 	FT2232H = 6,
-	FT4232H = 7
+	FT4232H = 7,
+	FT232H  = 8
 };
 
 enum ftdi_sio_baudrate {
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -22,6 +22,7 @@
 #define FTDI_8U232AM_ALT_PID 0x6006 /* FTDI's alternate PID for above */
 #define FTDI_8U2232C_PID 0x6010 /* Dual channel device */
 #define FTDI_4232H_PID 0x6011 /* Quad channel hi-speed device */
+#define FTDI_232H_PID  0x6014 /* Single channel hi-speed device */
 #define FTDI_SIO_PID	0x8372	/* Product Id SIO application of 8U100AX */
 #define FTDI_232RL_PID  0xFBFA  /* Product ID for FT232RL */
 


