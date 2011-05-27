Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab1E0Ipv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:45:51 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:55157 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758726Ab1E0Iop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:44:45 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: usbip-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] staging: usbip: userspace: usbip_list.c: refactor local USB device listing
Date: Fri, 27 May 2011 01:44:13 -0700
Message-Id: <6b33021805719978f28ec087ae7cfa7d93bb48a7.1306485772.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <ec9a733eb388e3057d46ca451448e23ca24bd7e9.1306485772.git.mfm@muteddisk.com>
References: <ec9a733eb388e3057d46ca451448e23ca24bd7e9.1306485772.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combines the different list display types for local devices into one
function. Removes dependence on utils.h, which only exists as a way to
circumvent libsysfs and will be removed. The devices are now sorted as
an added benefit of this refactor.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbip_list.c |  180 ++++++++++------------
 1 files changed, 83 insertions(+), 97 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index 72236ae..4bbfae8 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -23,17 +23,15 @@
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 
-#include <dirent.h>
 #include <getopt.h>
 #include <netdb.h>
-#include <regex.h>
 #include <unistd.h>
 
 #include "usbip_common.h"
 #include "usbip_network.h"
-#include "utils.h"
 #include "usbip.h"
 
 static const char usbip_list_usage_string[] =
@@ -149,113 +147,104 @@ static int show_exported_devices(char *host)
 	return 0;
 }
 
-static int is_usb_device(char *busid)
+static void print_device(char *busid, char *vendor, char *product,
+			 bool parsable)
 {
-	int ret;
-
-	regex_t regex;
-	regmatch_t pmatch[1];
-
-	ret = regcomp(&regex, "^[0-9]+-[0-9]+(\\.[0-9]+)*$", REG_NOSUB|REG_EXTENDED);
-	if (ret < 0)
-		err("regcomp: %s\n", strerror(errno));
-
-	ret = regexec(&regex, busid, 0, pmatch, 0);
-	if (ret)
-		return 0;	/* not matched */
-
-	return 1;
+	if (parsable)
+		printf("busid=%s#usbid=%.4s:%.4s#", busid, vendor, product);
+	else
+		printf(" - busid %s (%.4s:%.4s)\n", busid, vendor, product);
 }
 
-static int show_devices(void)
+static void print_interface(char *busid, char *driver, bool parsable)
 {
-	DIR *dir;
-
-	dir = opendir("/sys/bus/usb/devices/");
-	if (!dir)
-		err("opendir: %s", strerror(errno));
-
-	printf("List USB devices\n");
-	for (;;) {
-		struct dirent *dirent;
-		char *busid;
-
-		dirent = readdir(dir);
-		if (!dirent)
-			break;
-
-		busid = dirent->d_name;
-
-		if (is_usb_device(busid)) {
-			char name[100] = {'\0'};
-			char driver[100] =  {'\0'};
-			int conf, ninf = 0;
-			int i;
-
-			conf = read_bConfigurationValue(busid);
-			ninf = read_bNumInterfaces(busid);
-
-			getdevicename(busid, name, sizeof(name));
-
-			printf(" - busid %s (%s)\n", busid, name);
-
-			for (i = 0; i < ninf; i++) {
-				getdriver(busid, conf, i, driver,
-					  sizeof(driver));
-				printf("         %s:%d.%d -> %s\n", busid, conf,
-				       i, driver);
-			}
-			printf("\n");
-		}
-	}
-
-	closedir(dir);
-
-	return 0;
+	if (parsable)
+		printf("%s=%s#", busid, driver);
+	else
+		printf("%9s%s -> %s\n", "", busid, driver);
 }
 
-static int show_devices2(void)
+static int is_device(void *x)
 {
-	DIR *dir;
+	struct sysfs_attribute *devpath;
+	struct sysfs_device *dev = x;
+	int ret = 0;
 
-	dir = opendir("/sys/bus/usb/devices/");
-	if (!dir)
-		err("opendir: %s", strerror(errno));
+	devpath = sysfs_get_device_attr(dev, "devpath");
+	if (devpath && *devpath->value != '0')
+		ret = 1;
 
-	for (;;) {
-		struct dirent *dirent;
-		char *busid;
+	return ret;
+}
 
-		dirent = readdir(dir);
-		if (!dirent)
-			break;
+static int devcmp(void *a, void *b)
+{
+	return strcmp(a, b);
+}
 
-		busid = dirent->d_name;
+static int list_devices(bool parsable)
+{
+	char bus_type[] = "usb";
+	char busid[SYSFS_BUS_ID_SIZE];
+	struct sysfs_bus *ubus;
+	struct sysfs_device *dev;
+	struct sysfs_device *intf;
+	struct sysfs_attribute *idVendor;
+	struct sysfs_attribute *idProduct;
+	struct sysfs_attribute *bConfValue;
+	struct sysfs_attribute *bNumIntfs;
+	struct dlist *devlist;
+	int i;
+	int ret = -1;
 
-		if (is_usb_device(busid)) {
-			char name[100] = {'\0'};
-			char driver[100] =  {'\0'};
-			int conf, ninf = 0;
-			int i;
+	ubus = sysfs_open_bus(bus_type);
+	if (!ubus) {
+		err("sysfs_open_bus: %s", strerror(errno));
+		return -1;
+	}
 
-			conf = read_bConfigurationValue(busid);
-			ninf = read_bNumInterfaces(busid);
+	devlist = sysfs_get_bus_devices(ubus);
+	if (!devlist) {
+		err("sysfs_get_bus_devices: %s", strerror(errno));
+		goto err_out;
+	}
 
-			getdevicename(busid, name, sizeof(name));
+	/* remove interfaces and root hubs from device list */
+	dlist_filter_sort(devlist, is_device, devcmp);
 
-			printf("busid=%s#usbid=%s#", busid, name);
+	if (!parsable) {
+		printf("Local USB devices\n");
+		printf("=================\n");
+	}
+	dlist_for_each_data(devlist, dev, struct sysfs_device) {
+		idVendor   = sysfs_get_device_attr(dev, "idVendor");
+		idProduct  = sysfs_get_device_attr(dev, "idProduct");
+		bConfValue = sysfs_get_device_attr(dev, "bConfigurationValue");
+		bNumIntfs  = sysfs_get_device_attr(dev, "bNumInterfaces");
+		if (!idVendor || !idProduct || !bConfValue || !bNumIntfs)
+			goto err_out;
 
-			for (i = 0; i < ninf; i++) {
-				getdriver(busid, conf, i, driver, sizeof(driver));
-				printf("%s:%d.%d=%s#", busid, conf, i, driver);
-			}
-			printf("\n");
+		print_device(dev->bus_id, idVendor->value, idProduct->value,
+			     parsable);
+
+		for (i = 0; i < atoi(bNumIntfs->value); i++) {
+			snprintf(busid, sizeof(busid), "%s:%.1s.%d",
+				 dev->bus_id, bConfValue->value, i);
+			intf = sysfs_open_device(bus_type, busid);
+			if (!intf)
+				goto err_out;
+			print_interface(busid, intf->driver_name, parsable);
+			sysfs_close_device(intf);
 		}
+		printf("\n");
 	}
 
-	closedir(dir);
+	ret = 0;
 
-	return 0;
+err_out:
+	sysfs_close_bus(ubus);
+
+	return ret;
 }
 
 int usbip_list(int argc, char *argv[])
@@ -266,12 +255,12 @@ int usbip_list(int argc, char *argv[])
 		{ "local", no_argument, NULL, 'l' },
 		{ NULL, 0, NULL, 0 }
 	};
-	bool is_parsable = false;
+	bool parsable = false;
 	int opt;
 	int ret = -1;
 
 	if (usbip_names_init(USBIDS_FILE))
-		err("failed to open %s\n", USBIDS_FILE);
+		err("failed to open %s", USBIDS_FILE);
 
 	for (;;) {
 		opt = getopt_long(argc, argv, "pr:l", opts, NULL);
@@ -281,16 +270,13 @@ int usbip_list(int argc, char *argv[])
 
 		switch (opt) {
 		case 'p':
-			is_parsable = true;
+			parsable = true;
 			break;
 		case 'r':
 			ret = show_exported_devices(optarg);
 			goto out;
 		case 'l':
-			if (is_parsable)
-				ret = show_devices2();
-			else
-				ret = show_devices();
+			ret = list_devices(parsable);
 			goto out;
 		default:
 			goto err_out;
-- 
1.7.5.1

