Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab0DGNm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 09:42:58 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60839 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908Ab0DGNmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:42:25 -0400
Date: Wed, 07 Apr 2010 15:41:35 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 8/8] USB: testusb: testusb compatibility with FunctionFS gadget
In-reply-to: <3c4f11cdfb08952e964879c343d6ed7ceedc9542.1270644740.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <a333dd3a5ec0ce230038c0ec3f2457d22349f2c8.1270644740.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1270644740.git.mina86@mina86.com>
 <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
 <b866157fc128769a3cdf9ae76f9fc21743776778.1270644740.git.mina86@mina86.com>
 <d8e956ce78914750460877b87ba2b0f707ab8a0f.1270644740.git.mina86@mina86.com>
 <a5ed8238af68738effaf1610f4653d98b9435098.1270644740.git.mina86@mina86.com>
 <922265f162fd3b45408c234d0d17e924b6f61671.1270644740.git.mina86@mina86.com>
 <15d6fb76583235c380569d11d904cc0e8d019067.1270644740.git.mina86@mina86.com>
 <3c4f11cdfb08952e964879c343d6ed7ceedc9542.1270644740.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FunctionFS gadget may provide the source/sink interface
not as the first interface (with id == 0) but some different
interface hence a code to find the interface number is
required.

(Note that you will still configure the gadget to report
idProduct == 0xa4a4 (an "echo 0xa4a4
>/sys/module/g_ffs/parameters/usb_product" should suffice) or
configure host to handle 0x0525:0xa4ac devices using the
usbtest driver.)

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 tools/usb/testusb.c |  176 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 119 insertions(+), 57 deletions(-)

diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
index 28e25ca..beaeea3 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -56,6 +56,13 @@ struct usbtest_param {
 
 /* #include <linux/usb_ch9.h> */
 
+#define USB_DT_DEVICE			0x01
+#define USB_DT_INTERFACE		0x04
+
+#define USB_CLASS_PER_INTERFACE		0	/* for DeviceClass */
+#define USB_CLASS_VENDOR_SPEC		0xff
+
+
 struct usb_device_descriptor {
 	__u8  bLength;
 	__u8  bDescriptorType;
@@ -73,6 +80,19 @@ struct usb_device_descriptor {
 	__u8  bNumConfigurations;
 } __attribute__ ((packed));
 
+struct usb_interface_descriptor {
+	__u8  bLength;
+	__u8  bDescriptorType;
+
+	__u8  bInterfaceNumber;
+	__u8  bAlternateSetting;
+	__u8  bNumEndpoints;
+	__u8  bInterfaceClass;
+	__u8  bInterfaceSubClass;
+	__u8  bInterfaceProtocol;
+	__u8  iInterface;
+} __attribute__ ((packed));
+
 enum usb_device_speed {
 	USB_SPEED_UNKNOWN = 0,			/* enumerating */
 	USB_SPEED_LOW, USB_SPEED_FULL,		/* usb 1.1 */
@@ -105,11 +125,42 @@ struct testdev {
 };
 static struct testdev		*testdevs;
 
-static int is_testdev (struct usb_device_descriptor *dev)
+static int testdev_ffs_ifnum(FILE *fd)
+{
+	union {
+		char buf[255];
+		struct usb_interface_descriptor intf;
+	} u;
+
+	for (;;) {
+		if (fread(u.buf, 1, 1, fd) != 1)
+			return -1;
+		if (fread(u.buf + 1, (unsigned char)u.buf[0] - 1, 1, fd) != 1)
+			return -1;
+
+		if (u.intf.bLength == sizeof u.intf
+		 && u.intf.bDescriptorType == USB_DT_INTERFACE
+		 && u.intf.bNumEndpoints == 2
+		 && u.intf.bInterfaceClass == USB_CLASS_VENDOR_SPEC
+		 && u.intf.bInterfaceSubClass == 0
+		 && u.intf.bInterfaceProtocol == 0)
+			return (unsigned char)u.intf.bInterfaceNumber;
+	}
+}
+
+static int testdev_ifnum(FILE *fd)
 {
+	struct usb_device_descriptor dev;
+
+	if (fread(&dev, sizeof dev, 1, fd) != 1)
+		return -1;
+
+	if (dev.bLength != sizeof dev || dev.bDescriptorType != USB_DT_DEVICE)
+		return -1;
+
 	/* FX2 with (tweaked) bulksrc firmware */
-	if (dev->idVendor == 0x0547 && dev->idProduct == 0x1002)
-		return 1;
+	if (dev.idVendor == 0x0547 && dev.idProduct == 0x1002)
+		return 0;
 
 	/*----------------------------------------------------*/
 
@@ -124,95 +175,106 @@ static int is_testdev (struct usb_device_descriptor *dev)
 	 */
 
 	/* generic EZ-USB FX controller */
-	if (dev->idVendor == 0x0547 && dev->idProduct == 0x2235)
-		return 1;
+	if (dev.idVendor == 0x0547 && dev.idProduct == 0x2235)
+		return 0;
 
 	/* generic EZ-USB FX2 controller */
-	if (dev->idVendor == 0x04b4 && dev->idProduct == 0x8613)
-		return 1;
+	if (dev.idVendor == 0x04b4 && dev.idProduct == 0x8613)
+		return 0;
 
 	/* CY3671 development board with EZ-USB FX */
-	if (dev->idVendor == 0x0547 && dev->idProduct == 0x0080)
-		return 1;
+	if (dev.idVendor == 0x0547 && dev.idProduct == 0x0080)
+		return 0;
 
 	/* Keyspan 19Qi uses an21xx (original EZ-USB) */
-	if (dev->idVendor == 0x06cd && dev->idProduct == 0x010b)
-		return 1;
+	if (dev.idVendor == 0x06cd && dev.idProduct == 0x010b)
+		return 0;
 
 	/*----------------------------------------------------*/
 
 	/* "gadget zero", Linux-USB test software */
-	if (dev->idVendor == 0x0525 && dev->idProduct == 0xa4a0)
-		return 1;
+	if (dev.idVendor == 0x0525 && dev.idProduct == 0xa4a0)
+		return 0;
 
 	/* user mode subset of that */
-	if (dev->idVendor == 0x0525 && dev->idProduct == 0xa4a4)
-		return 1;
+	if (dev.idVendor == 0x0525 && dev.idProduct == 0xa4a4)
+		return testdev_ffs_ifnum(fd);
+		/* return 0; */
 
 	/* iso version of usermode code */
-	if (dev->idVendor == 0x0525 && dev->idProduct == 0xa4a3)
-		return 1;
+	if (dev.idVendor == 0x0525 && dev.idProduct == 0xa4a3)
+		return 0;
 
 	/* some GPL'd test firmware uses these IDs */
 
-	if (dev->idVendor == 0xfff0 && dev->idProduct == 0xfff0)
-		return 1;
+	if (dev.idVendor == 0xfff0 && dev.idProduct == 0xfff0)
+		return 0;
 
 	/*----------------------------------------------------*/
 
 	/* iBOT2 high speed webcam */
-	if (dev->idVendor == 0x0b62 && dev->idProduct == 0x0059)
-		return 1;
+	if (dev.idVendor == 0x0b62 && dev.idProduct == 0x0059)
+		return 0;
 
-	return 0;
+	/*----------------------------------------------------*/
+
+	/* the FunctionFS gadget can have the source/sink interface
+	 * anywhere.  We look for an interface descriptor that match
+	 * what we expect.  We ignore configuratiens thou. */
+
+	if (dev.idVendor == 0x0525 && dev.idProduct == 0xa4ac
+	 && (dev.bDeviceClass == USB_CLASS_PER_INTERFACE
+	  || dev.bDeviceClass == USB_CLASS_VENDOR_SPEC))
+		return testdev_ffs_ifnum(fd);
+
+	return -1;
 }
 
-static int find_testdev (const char *name, const struct stat *sb, int flag)
+static int find_testdev(const char *name, const struct stat *sb, int flag)
 {
-	int				fd;
-	struct usb_device_descriptor	dev;
+	FILE				*fd;
+	int				ifnum;
+	struct testdev			*entry;
 
 	if (flag != FTW_F)
 		return 0;
 	/* ignore /proc/bus/usb/{devices,drivers} */
-	if (strrchr (name, '/')[1] == 'd')
+	if (strrchr(name, '/')[1] == 'd')
 		return 0;
 
-	if ((fd = open (name, O_RDONLY)) < 0) {
-		perror ("can't open dev file r/o");
+	fd = fopen(name, "rb");
+	if (!fd) {
+		perror(name);
 		return 0;
 	}
-	if (read (fd, &dev, sizeof dev) != sizeof dev)
-		fputs ("short devfile read!\n", stderr);
-	else if (is_testdev (&dev)) {
-		struct testdev		*entry;
-
-		if ((entry = calloc (1, sizeof *entry)) == 0) {
-			fputs ("no mem!\n", stderr);
-			goto done;
-		}
-		entry->name = strdup (name);
-		if (!entry->name) {
-			free (entry);
-			goto done;
-		}
-
-		// FIXME better to look at each interface and ask if it's
-		// bound to 'usbtest', rather than assume interface 0
-		entry->ifnum = 0;
 
-		// FIXME ask usbfs what speed; update USBDEVFS_CONNECTINFO
-		// so it tells about high speed etc
+	ifnum = testdev_ifnum(fd);
+	fclose(fd);
+	if (ifnum < 0)
+		return 0;
 
-		fprintf (stderr, "%s speed\t%s\n",
-				speed (entry->speed), entry->name);
+	entry = calloc(1, sizeof *entry);
+	if (!entry)
+		goto nomem;
 
-		entry->next = testdevs;
-		testdevs = entry;
+	entry->name = strdup(name);
+	if (!entry->name) {
+		free(entry);
+nomem:
+		perror("malloc");
+		return 0;
 	}
 
-done:
-	close (fd);
+	entry->ifnum = ifnum;
+
+	/* FIXME ask usbfs what speed; update USBDEVFS_CONNECTINFO so
+	 * it tells about high speed etc */
+
+	fprintf(stderr, "%s speed\t%s\t%u\n",
+		speed(entry->speed), entry->name, entry->ifnum);
+
+	entry->next = testdevs;
+	testdevs = entry;
 	return 0;
 }
 
-- 
1.7.0

