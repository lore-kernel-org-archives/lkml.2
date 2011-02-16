Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab1BPDx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:53:27 -0500
Received: from core.signal11.us ([64.251.29.136]:41407 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab1BPDxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:53:24 -0500
From: Alan Ott <alan@signal11.us>
To: Randy Dunlap <rdunlap@xenotime.net>, Alan Ott <alan@signal11.us>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, ospite@studenti.unina.it, linux-input@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v2 1/1] HID: Documentation for hidraw
Date: Tue, 15 Feb 2011 22:53:03 -0500
Message-Id: <1297828383-9527-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Feb 15 22:53:23 2011
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4d5b4a33144179569518951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documenation for the hidraw driver, with example program.

Signed-off-by: Alan Ott <alan@signal11.us>
---

 Now that my feature report patches have made it into -next. It seems         
 the time is right for the documentation to go in as well.


 Documentation/hid/Makefile      |    8 ++
 Documentation/hid/hid-example.c |  167 +++++++++++++++++++++++++++++++++++++++
 Documentation/hid/hidraw.txt    |  119 ++++++++++++++++++++++++++++
 3 files changed, 294 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hid/Makefile
 create mode 100644 Documentation/hid/hid-example.c
 create mode 100644 Documentation/hid/hidraw.txt

diff --git a/Documentation/hid/Makefile b/Documentation/hid/Makefile
new file mode 100644
index 0000000..7811cb0
--- /dev/null
+++ b/Documentation/hid/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := hid-example
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
diff --git a/Documentation/hid/hid-example.c b/Documentation/hid/hid-example.c
new file mode 100644
index 0000000..40e3d62
--- /dev/null
+++ b/Documentation/hid/hid-example.c
@@ -0,0 +1,167 @@
+/*
+ * Hidraw Userspace Example
+ *
+ * Copyright (c) 2010 Alan Ott <alan@signal11.us>
+ * Copyright (c) 2010 Signal 11 Software
+ *
+ * The code may be used by anyone for any purpose,
+ * and can serve as a starting point for developing
+ * applications using hidraw.
+ */
+
+/* Linux */
+#include <linux/types.h>
+#include <linux/input.h>
+#include <linux/hidraw.h>
+
+/* Unix */
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+
+/* C */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <errno.h>
+
+const char *bus_str(int bus);
+
+int main(int argc, char **argv)
+{
+	int fd;
+	int i, res, desc_size = 0;
+	char buf[256];
+	struct hidraw_report_descriptor rpt_desc;
+	struct hidraw_devinfo info;
+
+	/* Open the Device with non-blocking reads. In real life,
+	   don't use a hard coded path; use libudev instead. */
+	fd = open("/dev/hidraw0", O_RDWR|O_NONBLOCK);
+
+	if (fd < 0) {
+		perror("Unable to open device");
+		return 1;
+	}
+
+	memset(&rpt_desc, 0x0, sizeof(rpt_desc));
+	memset(&info, 0x0, sizeof(info));
+	memset(buf, 0x0, sizeof(buf));
+
+	/* Get Report Descriptor Size */
+	res = ioctl(fd, HIDIOCGRDESCSIZE, &desc_size);
+	if (res < 0)
+		perror("HIDIOCGRDESCSIZE");
+	else
+		printf("Report Descriptor Size: %d\n", desc_size);
+
+	/* Get Report Descriptor */
+	rpt_desc.size = desc_size;
+	res = ioctl(fd, HIDIOCGRDESC, &rpt_desc);
+	if (res < 0) {
+		perror("HIDIOCGRDESC");
+	} else {
+		printf("Report Descriptor:\n");
+		for (i = 0; i < rpt_desc.size; i++)
+			printf("%hhx ", rpt_desc.value[i]);
+		puts("\n");
+	}
+
+	/* Get Raw Name */
+	res = ioctl(fd, HIDIOCGRAWNAME(256), buf);
+	if (res < 0)
+		perror("HIDIOCGRAWNAME");
+	else
+		printf("Raw Name: %s\n", buf);
+
+	/* Get Physical Location */
+	res = ioctl(fd, HIDIOCGRAWPHYS(256), buf);
+	if (res < 0)
+		perror("HIDIOCGRAWPHYS");
+	else
+		printf("Raw Phys: %s\n", buf);
+
+	/* Get Raw Info */
+	res = ioctl(fd, HIDIOCGRAWINFO, &info);
+	if (res < 0) {
+		perror("HIDIOCGRAWINFO");
+	} else {
+		printf("Raw Info:\n");
+		printf("\tbustype: %d (%s)\n",
+			info.bustype, bus_str(info.bustype));
+		printf("\tvendor: 0x%04hx\n", info.vendor);
+		printf("\tproduct: 0x%04hx\n", info.product);
+	}
+
+	/* Set Feature */
+	buf[0] = 0x9; /* Report Number */
+	buf[1] = 0xff;
+	buf[2] = 0xff;
+	buf[3] = 0xff;
+	res = ioctl(fd, HIDIOCSFEATURE(4), buf);
+	if (res < 0)
+		perror("HIDIOCSFEATURE");
+	else
+		printf("ioctl HIDIOCGFEATURE returned: %d\n", res);
+
+	/* Get Feature */
+	buf[0] = 0x9; /* Report Number */
+	res = ioctl(fd, HIDIOCGFEATURE(256), buf);
+	if (res < 0) {
+		perror("HIDIOCGFEATURE");
+	} else {
+		printf("ioctl HIDIOCGFEATURE returned: %d\n", res);
+		printf("Report data (not containing the report number):\n\t");
+		for (i = 0; i < res; i++)
+			printf("%hhx ", buf[i]);
+		puts("\n");
+	}
+
+	/* Send a Report to the Device */
+	buf[0] = 0x1; /* Report Number */
+	buf[1] = 0x77;
+	res = write(fd, buf, 2);
+	if (res < 0) {
+		printf("Error: %d\n", errno);
+		perror("write");
+	} else {
+		printf("write() wrote %d bytes\n", res);
+	}
+
+	/* Get a report from the device */
+	res = read(fd, buf, 16);
+	if (res < 0) {
+		perror("read");
+	} else {
+		printf("read() read %d bytes:\n\t", res);
+		for (i = 0; i < res; i++)
+			printf("%hhx ", buf[i]);
+		puts("\n");
+	}
+	close(fd);
+	return 0;
+}
+
+const char *
+bus_str(int bus)
+{
+	switch (bus) {
+	case BUS_USB:
+		return "USB";
+		break;
+	case BUS_HIL:
+		return "HIL";
+		break;
+	case BUS_BLUETOOTH:
+		return "Bluetooth";
+		break;
+	case BUS_VIRTUAL:
+		return "Virtual";
+		break;
+	default:
+		return "Other";
+		break;
+	}
+}
diff --git a/Documentation/hid/hidraw.txt b/Documentation/hid/hidraw.txt
new file mode 100644
index 0000000..2e0d39a
--- /dev/null
+++ b/Documentation/hid/hidraw.txt
@@ -0,0 +1,119 @@
+      HIDRAW - Raw Access to USB and Bluetooth Human Interface Devices
+     ==================================================================
+
+The hidraw driver provides a raw interface to USB and Bluetooth Human
+Interface Devices (HIDs).  It differs from hiddev in that reports sent and
+received are not parsed by the HID parser, but are sent to and received from
+the device unmodified.
+
+Hidraw should be used if the userspace application knows exactly how to
+communicate with the hardware device, and is able to construct the HID
+reports manually.  This is often the case when making userspace drivers for
+custom HID devices.
+
+Hidraw is also useful for communicating with non-conformant HID devices
+which send and receive data in a way that is inconsistent with their report
+descriptors.  Because hiddev parses reports which are sent and received
+through it, checking them against the device's report descriptor, such
+communication with these non-conformant devices is impossible using hiddev.
+Hidraw is the only alternative, short of writing a custom kernel driver, for
+these non-conformant devices.
+
+A benefit of hidraw is that its use by userspace applications is independent
+of the underlying hardware type.  Currently, Hidraw is implemented for USB
+and Bluetooth.  In the future, as new hardware bus types are developed which
+use the HID specification, hidraw will be expanded to add support for these
+new bus types.
+
+Hidraw uses a dynamic major number, meaning that udev should be relied on to
+create hidraw device nodes.  Udev will typically create the device nodes
+directly under /dev (eg: /dev/hidraw0).  As this location is distribution-
+and udev rule-dependent, applications should use libudev to locate hidraw
+devices attached to the system.  There is a tutorial on libudev with a
+working example at:
+	http://www.signal11.us/oss/udev/
+
+The HIDRAW API
+---------------
+
+read()
+-------
+read() will read a queued report received from the HID device. On USB
+devices, the reports read using read() are the reports sent from the device
+on the INTERRUPT IN endpoint.  By default, read() will block until there is
+a report available to be read.  read() can be made non-blocking, by passing
+the O_NONBLOCK flag to open(), or by setting the O_NONBLOCK flag using
+fcntl().
+
+On a device which uses numbered reports, the first byte of the returned data
+will be the report number; the report data follows, beginning in the second
+byte.  For devices which do not use numbered reports, the report data
+will begin at the first byte.
+
+write()
+--------
+The write() function will write a report to the device. For USB devices, if
+the device has an INTERRUPT OUT endpoint, the report will be sent on that
+endpoint. If it does not, the report will be sent over the control endpoint,
+using a SET_REPORT transfer.
+
+The first byte of the buffer passed to write() should be set to the report
+number.  If the device does not use numbered reports, the first byte should
+be set to 0. The report data itself should begin at the second byte.
+
+ioctl()
+--------
+Hidraw supports the following ioctls:
+
+HIDIOCGRDESCSIZE: Get Report Descriptor Size
+This ioctl will get the size of the device's report descriptor.
+
+HIDIOCGRDESC: Get Report Descriptor
+This ioctl returns the device's report descriptor using a
+hidraw_report_descriptor struct.  Make sure to set the size field of the
+hidraw_report_descriptor struct to the size returned from HIDIOCGRDESCSIZE.
+
+HIDIOCGRAWINFO: Get Raw Info
+This ioctl will return a hidraw_devinfo struct containing the bus type, the
+vendor ID (VID), and product ID (PID) of the device. The bus type can be one
+of:
+	BUS_USB
+	BUS_HIL
+	BUS_BLUETOOTH
+	BUS_VIRTUAL
+which are defined in linux/input.h.
+
+HIDIOCGRAWNAME(len): Get Raw Name
+This ioctl returns a string containing the vendor and product strings of
+the device.  The returned string is Unicode, UTF-8 encoded.
+
+HIDIOCGRAWPHYS(len): Get Physical Address
+This ioctl returns a string representing the physical address of the device.
+For USB devices, the string contains the physical path to the device (the
+USB controller, hubs, ports, etc).  For Bluetooth devices, the string
+contains the hardware (MAC) address of the device.
+
+HIDIOCSFEATURE(len): Send a Feature Report
+This ioctl will send a feature report to the device.  Per the HID
+specification, feature reports are always sent using the control endpoint.
+Set the first byte of the supplied buffer to the report number.  For devices
+which do not use numbered reports, set the first byte to 0. The report data
+begins in the second byte. Make sure to set len accordingly, to one more
+than the length of the report (to account for the report number).
+
+HIDIOCGFEATURE(len): Get a Feature Report
+This ioctl will request a feature report from the device using the control
+endpoint.  The first byte of the supplied buffer should be set to the report
+number of the requested report.  For devices which do not use numbered
+reports, set the first byte to 0.  The report will be returned starting at
+the first byte of the buffer (ie: the report number is not returned).
+
+Example
+---------
+In this directory, find hid-example.c, which shows examples of read(),
+write(), and all the ioctls for hidraw.  The code may be used by anyone for
+any purpose, and can serve as a starting point for developing applications
+using hidraw.
+
+Document by:
+	Alan Ott <alan@signal11.us>, Signal 11 Software
-- 
1.7.0.4


