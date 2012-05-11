Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030217Ab2EKLCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:02:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:64406 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758999Ab2EKLCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:02:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98914876"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: [PATCH 2/3] testusb: using real device-nodes managed by udev
 instead of using usbfs
Thread-Topic: [PATCH 2/3] testusb: using real device-nodes managed by udev
 instead of using usbfs
Thread-Index: AQHNL1p/cPl9Qq41ikap8bVWXEqTwJbEa8gQ
Date: Fri, 11 May 2012 11:02:01 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A060D0C@SHSMSX101.ccr.corp.intel.com>
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

As the usbfs functionality have replaced by real device-nodes managed by udev whose nodes lived in /dev/bus/usb for a long time, testusb tool need update correspondingly.

Because udev path is fixed, so the "-A" option no longer need and it is removed.

Signed-off-by: Du Changbin <changbinx.du@intel.com>
---
 tools/usb/testusb.c |   53 +++++++++------------------------------------------
 1 file changed, 9 insertions(+), 44 deletions(-)

diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c index 6e0f567..4fcb656 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -253,9 +253,6 @@ static int find_testdev(const char *name, const struct stat *sb, int flag)
 
 	if (flag != FTW_F)
 		return 0;
-	/* ignore /proc/bus/usb/{devices,drivers} */
-	if (strrchr(name, '/')[1] == 'd')
-		return 0;
 
 	fd = fopen(name, "rb");
 	if (!fd) {
@@ -354,31 +351,6 @@ restart:
 	return arg;
 }
 
-static const char *usbfs_dir_find(void) -{
-	static char usbfs_path_0[] = "/dev/usb/devices";
-	static char usbfs_path_1[] = "/proc/bus/usb/devices";
-
-	static char *const usbfs_paths[] = {
-		usbfs_path_0, usbfs_path_1
-	};
-
-	static char *const *
-		end = usbfs_paths + sizeof usbfs_paths / sizeof *usbfs_paths;
-
-	char *const *it = usbfs_paths;
-	do {
-		int fd = open(*it, O_RDONLY);
-		close(fd);
-		if (fd >= 0) {
-			strrchr(*it, '/')[0] = '\0';
-			return *it;
-		}
-	} while (++it != end);
-
-	return NULL;
-}
-
 static int parse_num(unsigned *num, const char *str)  {
 	unsigned long val;
@@ -398,7 +370,7 @@ int main (int argc, char **argv)
 	int			c;
 	struct testdev		*entry;
 	char			*device;
-	const char		*usbfs_dir = NULL;
+	const char		*usb_dir = "/dev/bus/usb";
 	int			all = 0, forever = 0, not = 0;
 	int			test = -1 /* all */;
 	struct usbtest_param	param;
@@ -420,14 +392,11 @@ int main (int argc, char **argv)
 	/* for easy use when hotplugging */
 	device = getenv ("DEVICE");
 
-	while ((c = getopt (argc, argv, "D:aA:c:g:hns:t:v:")) != EOF)
+	while ((c = getopt (argc, argv, "D:ac:g:lhns:t:v:")) != EOF)
 	switch (c) {
 	case 'D':	/* device, if only one */
 		device = optarg;
 		continue;
-	case 'A':	/* use all devices with specified usbfs dir */
-		usbfs_dir = optarg;
-		/* FALL THROUGH */
 	case 'a':	/* use all devices */
 		device = NULL;
 		all = 1;
@@ -463,7 +432,7 @@ int main (int argc, char **argv)
 	case 'h':
 	default:
 usage:
-		fprintf (stderr, "usage: %s [-n] [-D dev | -a | -A usbfs-dir]\n"
+		fprintf (stderr, "usage: %s [-n] [-D dev | -a]\n"
 			"\t[-c iterations]  [-t testnum]\n"
 			"\t[-s packetsize] [-g sglen] [-v vary]\n",
 			argv [0]);
@@ -473,22 +442,18 @@ usage:
 		goto usage;
 	if (!all && !device) {
 		fprintf (stderr, "must specify '-a' or '-D dev', "
-			"or DEVICE=/proc/bus/usb/BBB/DDD in env\n");
+			"or DEVICE=%s/BBB/DDD in env\n", usb_dir);
 		goto usage;
 	}
 
-	/* Find usbfs mount point */
-	if (!usbfs_dir) {
-		usbfs_dir = usbfs_dir_find();
-		if (!usbfs_dir) {
-			fputs ("usbfs files are missing\n", stderr);
-			return -1;
-		}
+	if (access(usb_dir,F_OK) != 0) {
+		fprintf(stderr, "can not find path %s\n", usb_dir);
+		return -1;
 	}
 
 	/* collect and list the test devices */
-	if (ftw (usbfs_dir, find_testdev, 3) != 0) {
-		fputs ("ftw failed; is usbfs missing?\n", stderr);
+	if (ftw (usb_dir, find_testdev, 3) != 0) {
+		fputs ("ftw failed.\n", stderr);
 		return -1;
 	}
 
--
1.7.9.5

