Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030271Ab2EKLCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:02:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:25575 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759167Ab2EKLCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:02:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98914974"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: [PATCH 3/3] testusb: improve testing output pattern
Thread-Topic: [PATCH 3/3] testusb: improve testing output pattern
Thread-Index: AQHNL1p/AScWMv1/6EG7a+F8iVYplpbEa9Lw
Date: Fri, 11 May 2012 11:02:16 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A060D13@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. more help message to make it easier to use.
2. print VID/PID for each device found.
3. each case testing result is displayed by columns "DEVICE","TEST-NUM"," RESULT","DURATION(s)","ERROR".
output example:
$ ./testusb -a
/dev/bus/usb/002/083	VID/PID:0x0525/0xa4a0	speed:unknown	interface:0

DEVICE                TEST-NUM  RESULT  DURATION(s)  ERROR
/dev/bus/usb/002/083  0         pass    0.000007     (0)Success
/dev/bus/usb/002/083  1         pass    9.523400     (0)Success
/dev/bus/usb/002/083  2         pass    0.125101     (0)Success
/dev/bus/usb/002/083  3         pass    0.249602     (0)Success
/dev/bus/usb/002/083  4         pass    0.125075     (0)Success
/dev/bus/usb/002/083  5         pass    1.000218     (0)Success
/dev/bus/usb/002/083  6         pass    0.999864     (0)Success
/dev/bus/usb/002/083  7         pass    0.999987     (0)Success
/dev/bus/usb/002/083  8         pass    0.999883     (0)Success
/dev/bus/usb/002/083  9         pass    4.500352     (0)Success
/dev/bus/usb/002/083  10        fail    4.500352     (71)Protocol error
/dev/bus/usb/002/083  11        fail    4.500352     (71)Protocol error
/dev/bus/usb/002/083  12        fail    4.500352     (71)Protocol error

Signed-off-by: Du Changbin <changbinx.du@intel.com>
---
 tools/usb/testusb.c |  118 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 72 insertions(+), 46 deletions(-)

diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c index 4fcb656..e735ca0 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2002 by David Brownell
  * Copyright (c) 2010 by Samsung Electronics
  * Author: Michal Nazarewicz <mina86@mina86.com>
+ * Copyright (c) 2012 by Du Changbin <changbinx.du@intel.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the @@ -135,6 +136,7 @@ struct testdev {
 	int			test;
 
 	struct usbtest_param	param;
+	struct usb_device_descriptor	descriptor;
 };
 static struct testdev		*testdevs;
 
@@ -161,18 +163,16 @@ static int testdev_ffs_ifnum(FILE *fd)
 	}
 }
 
-static int testdev_ifnum(FILE *fd)
+static int testdev_ifnum(FILE *fd, struct usb_device_descriptor *dev)
 {
-	struct usb_device_descriptor dev;
-
-	if (fread(&dev, sizeof dev, 1, fd) != 1)
+	if (fread(dev, sizeof *dev, 1, fd) != 1)
 		return -1;
 
-	if (dev.bLength != sizeof dev || dev.bDescriptorType != USB_DT_DEVICE)
+	if (dev->bLength != sizeof *dev || dev->bDescriptorType != 
+USB_DT_DEVICE)
 		return -1;
 
 	/* FX2 with (tweaked) bulksrc firmware */
-	if (dev.idVendor == 0x0547 && dev.idProduct == 0x1002)
+	if (dev->idVendor == 0x0547 && dev->idProduct == 0x1002)
 		return 0;
 
 	/*----------------------------------------------------*/
@@ -188,45 +188,45 @@ static int testdev_ifnum(FILE *fd)
 	 */
 
 	/* generic EZ-USB FX controller */
-	if (dev.idVendor == 0x0547 && dev.idProduct == 0x2235)
+	if (dev->idVendor == 0x0547 && dev->idProduct == 0x2235)
 		return 0;
 
 	/* generic EZ-USB FX2 controller */
-	if (dev.idVendor == 0x04b4 && dev.idProduct == 0x8613)
+	if (dev->idVendor == 0x04b4 && dev->idProduct == 0x8613)
 		return 0;
 
 	/* CY3671 development board with EZ-USB FX */
-	if (dev.idVendor == 0x0547 && dev.idProduct == 0x0080)
+	if (dev->idVendor == 0x0547 && dev->idProduct == 0x0080)
 		return 0;
 
 	/* Keyspan 19Qi uses an21xx (original EZ-USB) */
-	if (dev.idVendor == 0x06cd && dev.idProduct == 0x010b)
+	if (dev->idVendor == 0x06cd && dev->idProduct == 0x010b)
 		return 0;
 
 	/*----------------------------------------------------*/
 
 	/* "gadget zero", Linux-USB test software */
-	if (dev.idVendor == 0x0525 && dev.idProduct == 0xa4a0)
+	if (dev->idVendor == 0x0525 && dev->idProduct == 0xa4a0)
 		return 0;
 
 	/* user mode subset of that */
-	if (dev.idVendor == 0x0525 && dev.idProduct == 0xa4a4)
+	if (dev->idVendor == 0x0525 && dev->idProduct == 0xa4a4)
 		return testdev_ffs_ifnum(fd);
 		/* return 0; */
 
 	/* iso version of usermode code */
-	if (dev.idVendor == 0x0525 && dev.idProduct == 0xa4a3)
+	if (dev->idVendor == 0x0525 && dev->idProduct == 0xa4a3)
 		return 0;
 
 	/* some GPL'd test firmware uses these IDs */
 
-	if (dev.idVendor == 0xfff0 && dev.idProduct == 0xfff0)
+	if (dev->idVendor == 0xfff0 && dev->idProduct == 0xfff0)
 		return 0;
 
 	/*----------------------------------------------------*/
 
 	/* iBOT2 high speed webcam */
-	if (dev.idVendor == 0x0b62 && dev.idProduct == 0x0059)
+	if (dev->idVendor == 0x0b62 && dev->idProduct == 0x0059)
 		return 0;
 
 	/*----------------------------------------------------*/
@@ -235,9 +235,9 @@ static int testdev_ifnum(FILE *fd)
 	 * anywhere.  We look for an interface descriptor that match
 	 * what we expect.  We ignore configuratiens thou. */
 
-	if (dev.idVendor == 0x0525 && dev.idProduct == 0xa4ac
-	 && (dev.bDeviceClass == USB_CLASS_PER_INTERFACE
-	  || dev.bDeviceClass == USB_CLASS_VENDOR_SPEC))
+	if (dev->idVendor == 0x0525 && dev->idProduct == 0xa4ac
+	 && (dev->bDeviceClass == USB_CLASS_PER_INTERFACE
+	  || dev->bDeviceClass == USB_CLASS_VENDOR_SPEC))
 		return testdev_ffs_ifnum(fd);
 
 	return -1;
@@ -260,14 +260,15 @@ static int find_testdev(const char *name, const struct stat *sb, int flag)
 		return 0;
 	}
 
-	ifnum = testdev_ifnum(fd);
-	fclose(fd);
-	if (ifnum < 0)
-		return 0;
-
 	entry = calloc(1, sizeof *entry);
 	if (!entry)
 		goto nomem;
+	memset (entry, 0, sizeof *entry);
+
+	ifnum = testdev_ifnum(fd, &entry->descriptor);
+	fclose(fd);
+	if (ifnum < 0)
+		return 0;
 
 	entry->name = strdup(name);
 	if (!entry->name) {
@@ -282,8 +283,9 @@ nomem:
 	/* FIXME ask usbfs what speed; update USBDEVFS_CONNECTINFO so
 	 * it tells about high speed etc */
 
-	fprintf(stderr, "%s speed\t%s\t%u\n",
-		speed(entry->speed), entry->name, entry->ifnum);
+	fprintf(stderr, "%s\tVID/PID:0x%04x/0x%04x\tspeed:%s\tinterface:%u\n",
+			entry->name, entry->descriptor.idVendor, entry->descriptor.idProduct,
+			speed(entry->speed), entry->ifnum);
 
 	entry->next = testdevs;
 	testdevs = entry;
@@ -302,6 +304,36 @@ usbdev_ioctl (int fd, int ifno, unsigned request, void *param)
 	return ioctl (fd, USBDEVFS_IOCTL, &wrapper);  }
 
+static void print_result(const char *device, const struct usbtest_param *p,
+		int status, int err)
+{
+	static int first = 1;
+	char	testnum[5];
+	char	duration[10];
+	char	result[5] = "pass";
+	char	error[80];
+	char	formate[] = "%-22s%-10s%-8s%-13s%-s";
+
+	snprintf(testnum, sizeof testnum, "%d", p->test_num);
+	snprintf(duration, sizeof duration, "%-d.%-.06d",
+			(int) p->duration.tv_sec, (int) p->duration.tv_usec);
+	if (status < 0)
+		snprintf(result, sizeof result, "fail");
+	snprintf(error, sizeof error, "(%d)", err);
+	strerror_r(err, error + strlen(error), sizeof error - strlen(error));
+	
+	if (first) {
+		printf("\n");
+		printf(formate, "DEVICE", "TEST-NUM", "RESULT", "DURATION(s)", "ERROR");
+		printf("\n");
+		first = 0;
+	}
+	printf(formate, device, testnum, result, duration, error);
+	printf("\n");
+	fflush (stdout);
+}
+
+/* do test work on specific device */
 static void *handle_testdev (void *arg)  {
 	struct testdev		*dev = arg;
@@ -327,22 +359,7 @@ restart:
 		/* FIXME need a "syslog it" option for background testing */
 
 		/* NOTE: each thread emits complete lines; no fragments! */
-		if (status < 0) {
-			char	buf [80];
-			int	err = errno;
-
-			if (strerror_r (errno, buf, sizeof buf)) {
-				snprintf (buf, sizeof buf, "error %d", err);
-				errno = err;
-			}
-			printf ("%s test %d --> %d (%s)\n",
-				dev->name, i, errno, buf);
-		} else
-			printf ("%s test %d, %4d.%.06d secs\n", dev->name, i,
-				(int) dev->param.duration.tv_sec,
-				(int) dev->param.duration.tv_usec);
-
-		fflush (stdout);
+		print_result(dev->name, &dev->param, status, errno);
 	}
 	if (dev->forever)
 		goto restart;
@@ -432,10 +449,19 @@ int main (int argc, char **argv)
 	case 'h':
 	default:
 usage:
-		fprintf (stderr, "usage: %s [-n] [-D dev | -a]\n"
-			"\t[-c iterations]  [-t testnum]\n"
-			"\t[-s packetsize] [-g sglen] [-v vary]\n",
-			argv [0]);
+		fprintf (stderr,
+			"usage: %s [options]\n"
+			"Options:\n"
+			"	-n		no test running, just show devices to be tested\n"
+			"	-D dev		only test specific device: %s/BBB/DDD\n"
+			"	-a		test all recognized devices\n"
+			"	-l		loop forever(for stress test)\n"
+			"	-t testnum	only run a specific case\n"
+			"	-c iterations	default 1000\n"
+			"	-s packetsize	default 512\n"
+			"	-g sglen	default 32\n"
+			"	-v vary		default 512\n",
+			argv [0], usb_dir);
 		return 1;
 	}
 	if (optind != argc)
@@ -446,7 +472,7 @@ usage:
 		goto usage;
 	}
 
-	if (access(usb_dir,F_OK) != 0) {
+	if (access(usb_dir, F_OK) != 0) {
 		fprintf(stderr, "can not find path %s\n", usb_dir);
 		return -1;
 	}
--
1.7.9.5

