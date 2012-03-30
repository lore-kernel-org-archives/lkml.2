Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935491Ab2C3VJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:09:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935461Ab2C3VJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:09:14 -0400
Message-Id: <20120330194835.221012610@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jim Paris <jim@jtan.com>
Subject: [ 010/149] USB: ftdi_sio: add support for FT-X series devices
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Paris <jim@jtan.com>

commit dc0827c128c0ee5a58b822b99d662b59f4b8e970 upstream.

Add PID 0x6015, corresponding to the new series of FT-X chips
(FT220XD, FT201X, FT220X, FT221X, FT230X, FT231X, FT240X).  They all
appear as serial devices, and seem indistinguishable except for the
default product string stored in their EEPROM.  The baudrate
generation matches FT232RL devices.

Tested with a FT201X and FT230X at various baudrates (100 - 3000000).

Sample dmesg:
    ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
    usb 2-1: new full-speed USB device number 6 using ohci_hcd
    usb 2-1: New USB device found, idVendor=0403, idProduct=6015
    usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
    usb 2-1: Product: FT230X USB Half UART
    usb 2-1: Manufacturer: FTDI
    usb 2-1: SerialNumber: DC001WI6
    ftdi_sio 2-1:1.0: FTDI USB Serial Device converter detected
    drivers/usb/serial/ftdi_sio.c: ftdi_sio_port_probe
    drivers/usb/serial/ftdi_sio.c: ftdi_determine_type: bcdDevice = 0x1000, bNumInterfaces = 1
    usb 2-1: Detected FT-X
    usb 2-1: Number of endpoints 2
    usb 2-1: Endpoint 1 MaxPacketSize 64
    usb 2-1: Endpoint 2 MaxPacketSize 64
    usb 2-1: Setting MaxPacketSize 64
    drivers/usb/serial/ftdi_sio.c: read_latency_timer
    drivers/usb/serial/ftdi_sio.c: write_latency_timer: setting latency timer = 1
    drivers/usb/serial/ftdi_sio.c: create_sysfs_attrs
    drivers/usb/serial/ftdi_sio.c: sysfs attributes for FT-X
    usb 2-1: FTDI USB Serial Device converter now attached to ttyUSB0

Signed-off-by: Jim Paris <jim@jtan.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |   20 +++++++++++++++-----
 drivers/usb/serial/ftdi_sio.h     |    3 ++-
 drivers/usb/serial/ftdi_sio_ids.h |    1 +
 3 files changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -188,6 +188,7 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_8u2232c_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_4232H_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_232H_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_FTX_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MICRO_CHAMELEON_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RELAIS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_PID) },
@@ -870,7 +871,8 @@ static const char *ftdi_chip_name[] = {
 	[FT232RL] = "FT232RL",
 	[FT2232H] = "FT2232H",
 	[FT4232H] = "FT4232H",
-	[FT232H]  = "FT232H"
+	[FT232H]  = "FT232H",
+	[FTX]     = "FT-X"
 };
 
 
@@ -1171,7 +1173,8 @@ static __u32 get_ftdi_divisor(struct tty
 		break;
 	case FT232BM: /* FT232BM chip */
 	case FT2232C: /* FT2232C chip */
-	case FT232RL:
+	case FT232RL: /* FT232RL chip */
+	case FTX:     /* FT-X series */
 		if (baud <= 3000000) {
 			__u16 product_id = le16_to_cpu(
 				port->serial->dev->descriptor.idProduct);
@@ -1460,10 +1463,14 @@ static void ftdi_determine_type(struct u
 	} else if (version < 0x900) {
 		/* Assume it's an FT232RL */
 		priv->chip_type = FT232RL;
-	} else {
+	} else if (version < 0x1000) {
 		/* Assume it's an FT232H */
 		priv->chip_type = FT232H;
+	} else {
+		/* Assume it's an FT-X series device */
+		priv->chip_type = FTX;
 	}
+
 	dev_info(&udev->dev, "Detected %s\n", ftdi_chip_name[priv->chip_type]);
 }
 
@@ -1591,7 +1598,8 @@ static int create_sysfs_attrs(struct usb
 		     priv->chip_type == FT232RL ||
 		     priv->chip_type == FT2232H ||
 		     priv->chip_type == FT4232H ||
-		     priv->chip_type == FT232H)) {
+		     priv->chip_type == FT232H ||
+		     priv->chip_type == FTX)) {
 			retval = device_create_file(&port->dev,
 						    &dev_attr_latency_timer);
 		}
@@ -1613,7 +1621,8 @@ static void remove_sysfs_attrs(struct us
 		    priv->chip_type == FT232RL ||
 		    priv->chip_type == FT2232H ||
 		    priv->chip_type == FT4232H ||
-                    priv->chip_type == FT232H) {
+		    priv->chip_type == FT232H ||
+		    priv->chip_type == FTX) {
 			device_remove_file(&port->dev, &dev_attr_latency_timer);
 		}
 	}
@@ -2287,6 +2296,7 @@ static int ftdi_tiocmget(struct tty_stru
 	case FT2232H:
 	case FT4232H:
 	case FT232H:
+	case FTX:
 		len = 2;
 		break;
 	default:
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -157,7 +157,8 @@ enum ftdi_chip_type {
 	FT232RL = 5,
 	FT2232H = 6,
 	FT4232H = 7,
-	FT232H  = 8
+	FT232H  = 8,
+	FTX     = 9,
 };
 
 enum ftdi_sio_baudrate {
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -23,6 +23,7 @@
 #define FTDI_8U2232C_PID 0x6010 /* Dual channel device */
 #define FTDI_4232H_PID 0x6011 /* Quad channel hi-speed device */
 #define FTDI_232H_PID  0x6014 /* Single channel hi-speed device */
+#define FTDI_FTX_PID   0x6015 /* FT-X series (FT201X, FT230X, FT231X, etc) */
 #define FTDI_SIO_PID	0x8372	/* Product Id SIO application of 8U100AX */
 #define FTDI_232RL_PID  0xFBFA  /* Product ID for FT232RL */
 


