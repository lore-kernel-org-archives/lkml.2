Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0DITW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:22:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19726 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab0DITVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:21:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 09 Apr 2010 21:21:25 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv2 8/8] USB: testusb: testusb compatibility with FunctionFS
 gadget
In-reply-to: <bc9d1ab4bd3fc9a3dfa3792054cfb410cf9c6411.1270835924.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Message-id: <b6a514337954b5f8372e5808556a3c5f4dadaf98.1270835924.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.0
References: <cover.1270835924.git.mina86@mina86.com>
 <3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com>
 <e6cbed26355492a8cde57973da56bccbb55b85a1.1270835924.git.mina86@mina86.com>
 <aa83c43874f8aa490300d6bd03472646f2727eb1.1270835924.git.mina86@mina86.com>
 <7edafe56416c4355b85d7627e9a025e8c589a1e6.1270835924.git.mina86@mina86.com>
 <6f40ed65715fbf1862bb443820277da7b5114838.1270835924.git.mina86@mina86.com>
 <85a3083a4134020cc17ef2555d5063fb23e781a3.1270835924.git.mina86@mina86.com>
 <bc9d1ab4bd3fc9a3dfa3792054cfb410cf9c6411.1270835924.git.mina86@mina86.com>
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
 tools/usb/testusb.c |  252 ++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 181 insertions(+), 71 deletions(-)

diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
index 28e25ca..0a1a5b5 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -1,8 +1,10 @@
-/* $(CROSS_COMPILE)cc -Wall -g -lpthread -o testusb testusb.c */
+/* $(CROSS_COMPILE)cc -Wall -Wextra -g -lpthread -o testusb testusb.c */
 
 /*
  * Copyright (c) 2002 by David Brownell
- * 
+ * Copyright (c) 2010 by Samsung Electronics
+ * Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2 of the License, or (at your
@@ -25,6 +27,7 @@
 #include <pthread.h>
 #include <unistd.h>
 #include <errno.h>
+#include <limits.h>
 
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -56,6 +59,13 @@ struct usbtest_param {
 
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
@@ -73,6 +83,19 @@ struct usb_device_descriptor {
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
@@ -105,11 +128,42 @@ struct testdev {
 };
 static struct testdev		*testdevs;
 
-static int is_testdev (struct usb_device_descriptor *dev)
+static int testdev_ffs_ifnum(FILE *fd)
 {
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
+{
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
 
@@ -124,95 +178,108 @@ static int is_testdev (struct usb_device_descriptor *dev)
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
+
+	(void)sb; /* unused */
 
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
 
@@ -277,11 +344,51 @@ restart:
 	return arg;
 }
 
+static const char *usbfs_dir_find(void)
+{
+	static char usbfs_path_0[] = "/dev/bus/usb/devices";
+	static char usbfs_path_1[] = "/proc/bus/usb/devices";
+
+	static char *const usbfs_paths[] = {
+		usbfs_path_0, usbfs_path_1
+	};
+
+	static char *const *
+		end = usbfs_paths + sizeof usbfs_paths / sizeof *usbfs_paths;
+
+	char *const *it = usbfs_paths;
+	do {
+		int fd = open(*it, O_RDONLY);
+		close(fd);
+		if (fd >= 0) {
+			strrchr(*it, '/')[0] = '\0';
+			return *it;
+		}
+	} while (++it != end);
+
+	return NULL;
+}
+
+static int parse_num(unsigned *num, const char *str)
+{
+	unsigned long val;
+	char *end;
+
+	errno = 0;
+	val = strtoul(str, &end, 0);
+	if (errno || *end || val > UINT_MAX)
+		return -1;
+	*num = val;
+	return 0;
+}
+
 int main (int argc, char **argv)
 {
+
 	int			c;
 	struct testdev		*entry;
 	char			*device;
+	const char		*usbfs_dir = NULL;
 	int			all = 0, forever = 0, not = 0;
 	int			test = -1 /* all */;
 	struct usbtest_param	param;
@@ -303,23 +410,24 @@ int main (int argc, char **argv)
 	/* for easy use when hotplugging */
 	device = getenv ("DEVICE");
 
-	while ((c = getopt (argc, argv, "D:ac:g:hns:t:v:")) != EOF)
+	while ((c = getopt (argc, argv, "D:aA:c:g:hns:t:v:")) != EOF)
 	switch (c) {
 	case 'D':	/* device, if only one */
 		device = optarg;
 		continue;
+	case 'A':	/* use all devices with specified usbfs dir */
+		usbfs_dir = optarg;
+		/* FALL THROUGH */
 	case 'a':	/* use all devices */
-		device = 0;
+		device = NULL;
 		all = 1;
 		continue;
 	case 'c':	/* count iterations */
-		param.iterations = atoi (optarg);
-		if (param.iterations < 0)
+		if (parse_num(&param.iterations, optarg))
 			goto usage;
 		continue;
 	case 'g':	/* scatter/gather entries */
-		param.sglen = atoi (optarg);
-		if (param.sglen < 0)
+		if (parse_num(&param.sglen, optarg))
 			goto usage;
 		continue;
 	case 'l':	/* loop forever */
@@ -329,8 +437,7 @@ int main (int argc, char **argv)
 		not = 1;
 		continue;
 	case 's':	/* size of packet */
-		param.length = atoi (optarg);
-		if (param.length < 0)
+		if (parse_num(&param.length, optarg))
 			goto usage;
 		continue;
 	case 't':	/* run just one test */
@@ -339,15 +446,14 @@ int main (int argc, char **argv)
 			goto usage;
 		continue;
 	case 'v':	/* vary packet size by ... */
-		param.vary = atoi (optarg);
-		if (param.vary < 0)
+		if (parse_num(&param.vary, optarg))
 			goto usage;
 		continue;
 	case '?':
 	case 'h':
 	default:
 usage:
-		fprintf (stderr, "usage: %s [-an] [-D dev]\n"
+		fprintf (stderr, "usage: %s [-n] [-D dev | -a | -A usbfs-dir]\n"
 			"\t[-c iterations]  [-t testnum]\n"
 			"\t[-s packetsize] [-g sglen] [-v vary]\n",
 			argv [0]);
@@ -361,13 +467,17 @@ usage:
 		goto usage;
 	}
 
-	if ((c = open ("/proc/bus/usb/devices", O_RDONLY)) < 0) {
-		fputs ("usbfs files are missing\n", stderr);
-		return -1;
+	/* Find usbfs mount point */
+	if (!usbfs_dir) {
+		usbfs_dir = usbfs_dir_find();
+		if (!usbfs_dir) {
+			fputs ("usbfs files are missing\n", stderr);
+			return -1;
+		}
 	}
 
 	/* collect and list the test devices */
-	if (ftw ("/proc/bus/usb", find_testdev, 3) != 0) {
+	if (ftw (usbfs_dir, find_testdev, 3) != 0) {
 		fputs ("ftw failed; is usbfs missing?\n", stderr);
 		return -1;
 	}
-- 
1.7.0

