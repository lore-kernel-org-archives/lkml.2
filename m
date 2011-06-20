Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab1FTFqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:46:55 -0400
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:38438
	"EHLO qmta05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199Ab1FTFpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:36 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/22] staging: usbip: userspace: usbip_bind.c: major rewrite of the implementation
Date: Sun, 19 Jun 2011 22:44:42 -0700
Message-Id: <7cbdf8477cc1abf4fd0c844d2c74b958524396aa.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite functions in terms of libsysfs, which eliminates a lot of
helper functions simplifying the file layout. Now, the two processes
taking place here, an unbind of the old driver and a bind of
usbip-host, are single functions and have been renamed along with the
controlling function. A check to see if the device is already bound to
usbip-host is now included.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbip_bind.c |  303 +++++++++++-----------
 1 files changed, 158 insertions(+), 145 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_bind.c b/drivers/staging/usbip/userspace/src/usbip_bind.c
index 978b7aa..9ecaf6e 100644
--- a/drivers/staging/usbip/userspace/src/usbip_bind.c
+++ b/drivers/staging/usbip/userspace/src/usbip_bind.c
@@ -18,18 +18,23 @@
 
 #include <sysfs/libsysfs.h>
 
-#include <limits.h>
+#include <errno.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 
-#include <fcntl.h>
 #include <getopt.h>
-#include <unistd.h>
 
 #include "usbip_common.h"
 #include "utils.h"
 #include "usbip.h"
 
+enum unbind_status {
+	UNBIND_ST_OK,
+	UNBIND_ST_USBIP_HOST,
+	UNBIND_ST_FAILED
+};
+
 static const char usbip_bind_usage_string[] =
 	"usbip bind <args>\n"
 	"    -b, --busid=<busid>    Bind " USBIP_HOST_DRV_NAME ".ko to device "
@@ -40,195 +45,202 @@ void usbip_bind_usage(void)
 	printf("usage: %s", usbip_bind_usage_string);
 }
 
-static const char unbind_path_format[] = "/sys/bus/usb/devices/%s/driver/unbind";
-
-/* buggy driver may cause dead lock */
-static int unbind_interface_busid(char *busid)
+/* call at unbound state */
+static int bind_usbip(char *busid)
 {
-	char unbind_path[SYSFS_PATH_MAX];
-	int fd;
-	int ret;
-
-	snprintf(unbind_path, sizeof(unbind_path), unbind_path_format, busid);
-
-	fd = open(unbind_path, O_WRONLY);
-	if (fd < 0) {
-		dbg("opening unbind_path failed: %d", fd);
+	char bus_type[] = "usb";
+	char attr_name[] = "bind";
+	char sysfs_mntpath[SYSFS_PATH_MAX];
+	char bind_attr_path[SYSFS_PATH_MAX];
+	char intf_busid[SYSFS_BUS_ID_SIZE];
+	struct sysfs_device *busid_dev;
+	struct sysfs_attribute *bind_attr;
+	struct sysfs_attribute *bConfValue;
+	struct sysfs_attribute *bNumIntfs;
+	int i, failed = 0;
+	int rc, ret = -1;
+
+	rc = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
+	if (rc < 0) {
+		err("sysfs must be mounted: %s", strerror(errno));
 		return -1;
 	}
 
-	ret = write(fd, busid, strnlen(busid, SYSFS_BUS_ID_SIZE));
-	if (ret < 0) {
-		dbg("write to unbind_path failed: %d", ret);
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-static int unbind_interface(char *busid, int configvalue, int interface)
-{
-	char inf_busid[SYSFS_BUS_ID_SIZE];
-	dbg("unbinding interface");
-
-	snprintf(inf_busid, SYSFS_BUS_ID_SIZE, "%s:%d.%d", busid, configvalue,
-		 interface);
+	snprintf(bind_attr_path, sizeof(bind_attr_path), "%s/%s/%s/%s/%s/%s",
+		 sysfs_mntpath, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
+		 USBIP_HOST_DRV_NAME, attr_name);
 
-	return unbind_interface_busid(inf_busid);
-}
-
-static int unbind(char *busid)
-{
-	int configvalue = 0;
-	int ninterface = 0;
-	int devclass = 0;
-	int i;
-	int failed = 0;
-
-	configvalue = read_bConfigurationValue(busid);
-	ninterface  = read_bNumInterfaces(busid);
-	devclass  = read_bDeviceClass(busid);
-
-	if (configvalue < 0 || ninterface < 0 || devclass < 0) {
-		dbg("read config and ninf value, removed?");
+	bind_attr = sysfs_open_attribute(bind_attr_path);
+	if (!bind_attr) {
+		dbg("problem getting bind attribute: %s", strerror(errno));
 		return -1;
 	}
 
-	if (devclass == 0x09) {
-		dbg("skip unbinding of hub");
-		return -1;
+	busid_dev = sysfs_open_device(bus_type, busid);
+	if (!busid_dev) {
+		dbg("sysfs_open_device %s failed: %s", busid, strerror(errno));
+		goto err_close_bind_attr;
 	}
 
-	for (i = 0; i < ninterface; i++) {
-		char driver[PATH_MAX];
-		int ret;
-
-		memset(&driver, 0, sizeof(driver));
-
-		getdriver(busid, configvalue, i, driver, PATH_MAX-1);
+	bConfValue = sysfs_get_device_attr(busid_dev, "bConfigurationValue");
+	bNumIntfs  = sysfs_get_device_attr(busid_dev, "bNumInterfaces");
 
-		dbg(" %s:%d.%d	-> %s ", busid, configvalue, i, driver);
-
-		if (!strncmp("none", driver, PATH_MAX))
-			continue; /* unbound interface */
+	if (!bConfValue || !bNumIntfs) {
+		dbg("problem getting device attributes: %s",
+		    strerror(errno));
+		goto err_close_busid_dev;
+	}
 
-#if 0
-		if (!strncmp("usbip", driver, PATH_MAX))
-			continue; /* already bound to usbip */
-#endif
+	for (i = 0; i < atoi(bNumIntfs->value); i++) {
+		snprintf(intf_busid, SYSFS_BUS_ID_SIZE, "%s:%.1s.%d", busid,
+			 bConfValue->value, i);
 
-		/* unbinding */
-		ret = unbind_interface(busid, configvalue, i);
-		if (ret < 0) {
-			dbg("unbind driver at %s:%d.%d failed",
-			    busid, configvalue, i);
+		rc = sysfs_write_attribute(bind_attr, intf_busid,
+					   SYSFS_BUS_ID_SIZE);
+		if (rc < 0) {
+			dbg("bind driver at %s failed", intf_busid);
 			failed = 1;
 		}
 	}
 
-	if (failed)
-		return -1;
-	else
-		return 0;
-}
-
-static const char bind_path_format[] = "/sys/bus/usb/drivers/%s/bind";
+	if (!failed)
+		ret = 0;
 
-static int bind_interface_busid(char *busid, char *driver)
-{
-	char bind_path[PATH_MAX];
-	int fd;
-	int ret;
+err_close_busid_dev:
+	sysfs_close_device(busid_dev);
+err_close_bind_attr:
+	sysfs_close_attribute(bind_attr);
 
-	snprintf(bind_path, sizeof(bind_path), bind_path_format, driver);
+	return ret;
+}
 
-	fd = open(bind_path, O_WRONLY);
-	if (fd < 0)
+/* buggy driver may cause dead lock */
+static int unbind_other(char *busid)
+{
+	char bus_type[] = "usb";
+	char intf_busid[SYSFS_BUS_ID_SIZE];
+	struct sysfs_device *busid_dev;
+	struct sysfs_device *intf_dev;
+	struct sysfs_driver *intf_drv;
+	struct sysfs_attribute *unbind_attr;
+	struct sysfs_attribute *bConfValue;
+	struct sysfs_attribute *bDevClass;
+	struct sysfs_attribute *bNumIntfs;
+	int i, rc;
+	enum unbind_status status = UNBIND_ST_OK;
+
+	busid_dev = sysfs_open_device(bus_type, busid);
+	if (!busid_dev) {
+		dbg("sysfs_open_device %s failed: %s", busid, strerror(errno));
 		return -1;
+	}
 
-	ret = write(fd, busid, strnlen(busid, SYSFS_BUS_ID_SIZE));
-	if (ret < 0) {
-		close(fd);
-		return -1;
+	bConfValue = sysfs_get_device_attr(busid_dev, "bConfigurationValue");
+	bDevClass  = sysfs_get_device_attr(busid_dev, "bDeviceClass");
+	bNumIntfs  = sysfs_get_device_attr(busid_dev, "bNumInterfaces");
+	if (!bConfValue || !bDevClass || !bNumIntfs) {
+		dbg("problem getting device attributes: %s",
+		    strerror(errno));
+		goto err_close_busid_dev;
 	}
 
-	close(fd);
+	if (!strncmp(bDevClass->value, "09", bDevClass->len)) {
+		dbg("skip unbinding of hub");
+		goto err_close_busid_dev;
+	}
 
-	return 0;
-}
+	for (i = 0; i < atoi(bNumIntfs->value); i++) {
+		snprintf(intf_busid, SYSFS_BUS_ID_SIZE, "%s:%.1s.%d", busid,
+			 bConfValue->value, i);
+		intf_dev = sysfs_open_device(bus_type, intf_busid);
+		if (!intf_dev) {
+			dbg("could not open interface device: %s",
+			    strerror(errno));
+			goto err_close_busid_dev;
+		}
 
-static int bind_interface(char *busid, int configvalue, int interface, char *driver)
-{
-	char inf_busid[SYSFS_BUS_ID_SIZE];
+		dbg("%s -> %s", intf_dev->name,  intf_dev->driver_name);
 
-	snprintf(inf_busid, SYSFS_BUS_ID_SIZE, "%s:%d.%d", busid, configvalue,
-		 interface);
+		if (!strncmp("unknown", intf_dev->driver_name, SYSFS_NAME_LEN))
+			/* unbound interface */
+			continue;
 
-	return bind_interface_busid(inf_busid, driver);
-}
+		if (!strncmp(USBIP_HOST_DRV_NAME, intf_dev->driver_name,
+			     SYSFS_NAME_LEN)) {
+			/* already bound to usbip-host */
+			status = UNBIND_ST_USBIP_HOST;
+			continue;
+		}
 
-/* call at unbound state */
-static int bind_to_usbip(char *busid)
-{
-	int configvalue = 0;
-	int ninterface = 0;
-	int i;
-	int failed = 0;
+		/* unbinding */
+		intf_drv = sysfs_open_driver(bus_type, intf_dev->driver_name);
+		if (!intf_drv) {
+			dbg("could not open interface driver on %s: %s",
+			    intf_dev->name, strerror(errno));
+			goto err_close_intf_dev;
+		}
 
-	configvalue = read_bConfigurationValue(busid);
-	ninterface  = read_bNumInterfaces(busid);
+		unbind_attr = sysfs_get_driver_attr(intf_drv, "unbind");
+		if (!unbind_attr) {
+			dbg("problem getting interface driver attribute: %s",
+			    strerror(errno));
+			goto err_close_intf_drv;
+		}
 
-	if (configvalue < 0 || ninterface < 0) {
-		dbg("read config and ninf value, removed?");
-		return -1;
+		rc = sysfs_write_attribute(unbind_attr, intf_dev->bus_id,
+					   SYSFS_BUS_ID_SIZE);
+		if (rc < 0) {
+			/* NOTE: why keep unbinding other interfaces? */
+			dbg("unbind driver at %s failed", intf_dev->bus_id);
+			status = UNBIND_ST_FAILED;
+		}
+
+		sysfs_close_driver(intf_drv);
+		sysfs_close_device(intf_dev);
 	}
 
-	for (i = 0; i < ninterface; i++) {
-		int ret;
+	goto out;
 
-		ret = bind_interface(busid, configvalue, i,
-				     USBIP_HOST_DRV_NAME);
-		if (ret < 0) {
-			dbg("bind usbip at %s:%d.%d, failed",
-			    busid, configvalue, i);
-			failed = 1;
-			/* need to contine binding at other interfaces */
-		}
-	}
+err_close_intf_drv:
+	sysfs_close_driver(intf_drv);
+err_close_intf_dev:
+	sysfs_close_device(intf_dev);
+err_close_busid_dev:
+	status = UNBIND_ST_FAILED;
+out:
+	sysfs_close_device(busid_dev);
 
-	if (failed)
-		return -1;
-	else
-		return 0;
+	return status;
 }
 
-static int use_device_by_usbip(char *busid)
+static int bind_device(char *busid)
 {
-	int ret;
+	int rc;
 
-	ret = unbind(busid);
-	if (ret < 0) {
-		dbg("unbind drivers of %s, failed", busid);
+	rc = unbind_other(busid);
+	if (rc == UNBIND_ST_FAILED) {
+		err("could not unbind driver from device on busid %s", busid);
+		return -1;
+	} else if (rc == UNBIND_ST_USBIP_HOST) {
+		err("device on busid %s is already bound to %s", busid,
+		    USBIP_HOST_DRV_NAME);
 		return -1;
 	}
 
-	ret = modify_match_busid(busid, 1);
-	if (ret < 0) {
-		dbg("add %s to match_busid, failed", busid);
+	rc = modify_match_busid(busid, 1);
+	if (rc < 0) {
+		err("unable to bind device on %s", busid);
 		return -1;
 	}
 
-	ret = bind_to_usbip(busid);
-	if (ret < 0) {
-		dbg("bind usbip to %s, failed", busid);
+	rc = bind_usbip(busid);
+	if (rc < 0) {
+		err("could not bind device to %s", USBIP_HOST_DRV_NAME);
 		modify_match_busid(busid, 0);
 		return -1;
 	}
 
-	dbg("bind %s complete!", busid);
+	printf("bind device on busid %s: complete\n", busid);
 
 	return 0;
 }
@@ -237,8 +249,9 @@ int usbip_bind(int argc, char *argv[])
 {
 	static const struct option opts[] = {
 		{ "busid", required_argument, NULL, 'b' },
-		{ NULL, 0, NULL, 0 }
+		{ NULL,    0,                 NULL,  0  }
 	};
+
 	int opt;
 	int ret = -1;
 
@@ -250,7 +263,7 @@ int usbip_bind(int argc, char *argv[])
 
 		switch (opt) {
 		case 'b':
-			ret = use_device_by_usbip(optarg);
+			ret = bind_device(optarg);
 			goto out;
 		default:
 			goto err_out;
-- 
1.7.5.2

