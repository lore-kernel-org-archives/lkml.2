Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1FTFwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:52:00 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:52483 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab1FTFv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:51:57 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 17/22] staging: usbip: userspace: usbip_host: update function and variable names
Date: Sun, 19 Jun 2011 22:44:47 -0700
Message-Id: <a4f9c746b207ee5671cf04f71319800285e88451.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Officially change stub_driver to usbip_host_driver. And, reorganize
usbip_host_driver.c while also cleaning up coding style.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../usbip/userspace/libsrc/usbip_host_driver.c     |  316 ++++++++++----------
 .../usbip/userspace/libsrc/usbip_host_driver.h     |   45 ++-
 2 files changed, 189 insertions(+), 172 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
index 604aed1..71a449c 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
@@ -1,5 +1,19 @@
 /*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <sys/types.h>
@@ -9,41 +23,12 @@
 #include <unistd.h>
 
 #include "usbip_common.h"
-#include "stub_driver.h"
+#include "usbip_host_driver.h"
 
 #undef  PROGNAME
 #define PROGNAME "libusbip"
 
-struct usbip_stub_driver *stub_driver;
-
-static struct sysfs_driver *open_sysfs_stub_driver(void)
-{
-	int ret;
-
-	char sysfs_mntpath[SYSFS_PATH_MAX];
-	char stub_driver_path[SYSFS_PATH_MAX];
-	struct sysfs_driver *stub_driver;
-
-
-	ret = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
-	if (ret < 0) {
-		dbg("sysfs_get_mnt_path failed");
-		return NULL;
-	}
-
-	snprintf(stub_driver_path, SYSFS_PATH_MAX, "%s/%s/usb/%s/%s",
-			sysfs_mntpath, SYSFS_BUS_NAME, SYSFS_DRIVERS_NAME,
-			USBIP_HOST_DRV_NAME);
-
-	stub_driver = sysfs_open_driver_path(stub_driver_path);
-	if (!stub_driver) {
-		dbg("sysfs_open_driver_path failed");
-		return NULL;
-	}
-
-	return stub_driver;
-}
-
+struct usbip_host_driver *host_driver;
 
 #define SYSFS_OPEN_RETRIES 100
 
@@ -53,7 +38,7 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 	char attrpath[SYSFS_PATH_MAX];
 	struct sysfs_attribute *attr;
 	int value = 0;
-	int  ret;
+	int rc;
 	struct stat s;
 	int retries = SYSFS_OPEN_RETRIES;
 
@@ -72,9 +57,7 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 	 */
 
 	snprintf(attrpath, SYSFS_PATH_MAX, "%s/%s:%d.%d/usbip_status",
-			udev->path, udev->busid,
-			udev->bConfigurationValue,
-			0);
+		 udev->path, udev->busid, udev->bConfigurationValue, 0);
 
 	while (retries > 0) {
 		if (stat(attrpath, &s) == 0)
@@ -102,8 +85,8 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 		return -1;
 	}
 
-	ret = sysfs_read_attribute(attr);
-	if (ret) {
+	rc = sysfs_read_attribute(attr);
+	if (rc) {
 		dbg("sysfs_read_attribute failed: %s", attrpath);
 		sysfs_close_attribute(attr);
 		return -1;
@@ -116,22 +99,13 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 	return value;
 }
 
-
-static void usbip_exported_device_delete(void *dev)
-{
-	struct usbip_exported_device *edev =
-		(struct usbip_exported_device *) dev;
-
-	sysfs_close_device(edev->sudev);
-	free(dev);
-}
-
-
 static struct usbip_exported_device *usbip_exported_device_new(char *sdevpath)
 {
 	struct usbip_exported_device *edev = NULL;
+	size_t size;
+	int i;
 
-	edev = (struct usbip_exported_device *) calloc(1, sizeof(*edev));
+	edev = calloc(1, sizeof(*edev));
 	if (!edev) {
 		dbg("calloc failed");
 		return NULL;
@@ -150,223 +124,255 @@ static struct usbip_exported_device *usbip_exported_device_new(char *sdevpath)
 		goto err;
 
 	/* reallocate buffer to include usb interface data */
-	size_t size = sizeof(*edev) + edev->udev.bNumInterfaces *
+	size = sizeof(*edev) + edev->udev.bNumInterfaces *
 		sizeof(struct usbip_usb_interface);
-	edev = (struct usbip_exported_device *) realloc(edev, size);
+
+	edev = realloc(edev, size);
 	if (!edev) {
 		dbg("realloc failed");
 		goto err;
 	}
 
-	for (int i=0; i < edev->udev.bNumInterfaces; i++)
+	for (i = 0; i < edev->udev.bNumInterfaces; i++)
 		read_usb_interface(&edev->udev, i, &edev->uinf[i]);
 
 	return edev;
-
 err:
 	if (edev && edev->sudev)
 		sysfs_close_device(edev->sudev);
 	if (edev)
 		free(edev);
+
 	return NULL;
 }
 
-
 static int check_new(struct dlist *dlist, struct sysfs_device *target)
 {
 	struct sysfs_device *dev;
 
 	dlist_for_each_data(dlist, dev, struct sysfs_device) {
 		if (!strncmp(dev->bus_id, target->bus_id, SYSFS_BUS_ID_SIZE))
-			/* found. not new */
+			/* device found and is not new */
 			return 0;
 	}
-
 	return 1;
 }
 
-static void delete_nothing(void *dev __attribute__((unused)))
+static void delete_nothing(void *unused_data)
 {
-	/* do not delete anything. but, its container will be deleted. */
+	/*
+	 * NOTE: Do not delete anything, but the container will be deleted.
+	 */
+	(void) unused_data;
 }
 
 static int refresh_exported_devices(void)
 {
-	struct sysfs_device	*suinf;  /* sysfs_device of usb_interface */
-	struct dlist		*suinf_list;
-
-	struct sysfs_device	*sudev;  /* sysfs_device of usb_device */
+	/* sysfs_device of usb_interface */
+	struct sysfs_device	*suintf;
+	struct dlist		*suintf_list;
+	/* sysfs_device of usb_device */
+	struct sysfs_device	*sudev;
 	struct dlist		*sudev_list;
+	struct usbip_exported_device *edev;
 
+	sudev_list = dlist_new_with_delete(sizeof(struct sysfs_device),
+					   delete_nothing);
 
-	sudev_list = dlist_new_with_delete(sizeof(struct sysfs_device), delete_nothing);
-
-	suinf_list = sysfs_get_driver_devices(stub_driver->sysfs_driver);
-	if (!suinf_list) {
+	suintf_list = sysfs_get_driver_devices(host_driver->sysfs_driver);
+	if (!suintf_list) {
+		/*
+		 * Not an error condition. There are simply no devices bound to
+		 * the driver yet.
+		 */
 		dbg("bind " USBIP_HOST_DRV_NAME ".ko to a usb device to be "
-		    "exportable!\n");
-		goto bye;
+		    "exportable!");
+		return 0;
 	}
 
 	/* collect unique USB devices (not interfaces) */
-	dlist_for_each_data(suinf_list, suinf, struct sysfs_device) {
-
+	dlist_for_each_data(suintf_list, suintf, struct sysfs_device) {
 		/* get usb device of this usb interface */
-		sudev = sysfs_get_device_parent(suinf);
+		sudev = sysfs_get_device_parent(suintf);
 		if (!sudev) {
-			dbg("sysfs_get_device_parent failed: %s", suinf->name);
+			dbg("sysfs_get_device_parent failed: %s", suintf->name);
 			continue;
 		}
 
 		if (check_new(sudev_list, sudev)) {
+			/* insert item at head of list */
 			dlist_unshift(sudev_list, sudev);
 		}
 	}
 
 	dlist_for_each_data(sudev_list, sudev, struct sysfs_device) {
-		struct usbip_exported_device *edev;
-
 		edev = usbip_exported_device_new(sudev->path);
 		if (!edev) {
 			dbg("usbip_exported_device_new failed");
 			continue;
 		}
 
-		dlist_unshift(stub_driver->edev_list, (void *) edev);
-		stub_driver->ndevs++;
+		dlist_unshift(host_driver->edev_list, edev);
+		host_driver->ndevs++;
 	}
 
-
 	dlist_destroy(sudev_list);
 
-bye:
-
 	return 0;
 }
 
-int usbip_stub_refresh_device_list(void)
+static struct sysfs_driver *open_sysfs_host_driver(void)
 {
-	int ret;
+	char bus_type[] = "usb";
+	char sysfs_mntpath[SYSFS_PATH_MAX];
+	char host_drv_path[SYSFS_PATH_MAX];
+	struct sysfs_driver *host_drv;
+	int rc;
 
-	if (stub_driver->edev_list)
-		dlist_destroy(stub_driver->edev_list);
+	rc = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
+	if (rc < 0) {
+		dbg("sysfs_get_mnt_path failed");
+		return NULL;
+	}
 
-	stub_driver->ndevs = 0;
+	snprintf(host_drv_path, SYSFS_PATH_MAX, "%s/%s/%s/%s/%s",
+		 sysfs_mntpath, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
+		 USBIP_HOST_DRV_NAME);
 
-	stub_driver->edev_list = dlist_new_with_delete(sizeof(struct usbip_exported_device),
-			usbip_exported_device_delete);
-	if (!stub_driver->edev_list) {
-		dbg("dlist_new_with_delete failed");
-		return -1;
+	host_drv = sysfs_open_driver_path(host_drv_path);
+	if (!host_drv) {
+		dbg("sysfs_open_driver_path failed");
+		return NULL;
 	}
 
-	ret = refresh_exported_devices();
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return host_drv;
 }
 
-int usbip_stub_driver_open(void)
+static void usbip_exported_device_delete(void *dev)
 {
-	int ret;
+	struct usbip_exported_device *edev = dev;
+	sysfs_close_device(edev->sudev);
+	free(dev);
+}
 
+int usbip_host_driver_open(void)
+{
+	int rc;
 
-	stub_driver = (struct usbip_stub_driver *) calloc(1, sizeof(*stub_driver));
-	if (!stub_driver) {
+	host_driver = calloc(1, sizeof(*host_driver));
+	if (!host_driver) {
 		dbg("calloc failed");
 		return -1;
 	}
 
-	stub_driver->ndevs = 0;
-
-	stub_driver->edev_list = dlist_new_with_delete(sizeof(struct usbip_exported_device),
-			usbip_exported_device_delete);
-	if (!stub_driver->edev_list) {
+	host_driver->ndevs = 0;
+	host_driver->edev_list =
+		dlist_new_with_delete(sizeof(struct usbip_exported_device),
+				      usbip_exported_device_delete);
+	if (!host_driver->edev_list) {
 		dbg("dlist_new_with_delete failed");
-		goto err;
+		goto err_free_host_driver;
 	}
 
-	stub_driver->sysfs_driver = open_sysfs_stub_driver();
-	if (!stub_driver->sysfs_driver)
-		goto err;
+	host_driver->sysfs_driver = open_sysfs_host_driver();
+	if (!host_driver->sysfs_driver)
+		goto err_destroy_edev_list;
 
-	ret = refresh_exported_devices();
-	if (ret < 0)
-		goto err;
+	rc = refresh_exported_devices();
+	if (rc < 0)
+		goto err_close_sysfs_driver;
 
 	return 0;
 
+err_close_sysfs_driver:
+	sysfs_close_driver(host_driver->sysfs_driver);
+err_destroy_edev_list:
+	dlist_destroy(host_driver->edev_list);
+err_free_host_driver:
+	free(host_driver);
+	host_driver = NULL;
 
-err:
-	if (stub_driver->sysfs_driver)
-		sysfs_close_driver(stub_driver->sysfs_driver);
-	if (stub_driver->edev_list)
-		dlist_destroy(stub_driver->edev_list);
-	free(stub_driver);
-
-	stub_driver = NULL;
 	return -1;
 }
 
-
-void usbip_stub_driver_close(void)
+void usbip_host_driver_close(void)
 {
-	if (!stub_driver)
+	if (!host_driver)
 		return;
 
-	if (stub_driver->edev_list)
-		dlist_destroy(stub_driver->edev_list);
-	if (stub_driver->sysfs_driver)
-		sysfs_close_driver(stub_driver->sysfs_driver);
-	free(stub_driver);
+	if (host_driver->edev_list)
+		dlist_destroy(host_driver->edev_list);
+	if (host_driver->sysfs_driver)
+		sysfs_close_driver(host_driver->sysfs_driver);
 
-	stub_driver = NULL;
+	free(host_driver);
+	host_driver = NULL;
 }
 
-int usbip_stub_export_device(struct usbip_exported_device *edev, int sockfd)
+int usbip_host_refresh_device_list(void)
 {
-	char attrpath[SYSFS_PATH_MAX];
+	int rc;
+
+	if (host_driver->edev_list)
+		dlist_destroy(host_driver->edev_list);
+
+	host_driver->ndevs = 0;
+	host_driver->edev_list =
+		dlist_new_with_delete(sizeof(struct usbip_exported_device),
+				      usbip_exported_device_delete);
+	if (!host_driver->edev_list) {
+		dbg("dlist_new_with_delete failed");
+		return -1;
+	}
+
+	rc = refresh_exported_devices();
+	if (rc < 0)
+		return -1;
+
+	return 0;
+}
+
+int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd)
+{
+	char attr_name[] = "usbip_sockfd";
+	char attr_path[SYSFS_PATH_MAX];
 	struct sysfs_attribute *attr;
 	char sockfd_buff[30];
 	int ret;
 
-
 	if (edev->status != SDEV_ST_AVAILABLE) {
 		dbg("device not available: %s", edev->udev.busid);
-		switch( edev->status ) {
-			case SDEV_ST_ERROR:
-				dbg("status SDEV_ST_ERROR");
-				break;
-			case SDEV_ST_USED:
-				dbg("status SDEV_ST_USED");
-				break;
-			default:
-				dbg("status unknown: 0x%x", edev->status);
+		switch (edev->status) {
+		case SDEV_ST_ERROR:
+			dbg("status SDEV_ST_ERROR");
+			break;
+		case SDEV_ST_USED:
+			dbg("status SDEV_ST_USED");
+			break;
+		default:
+			dbg("status unknown: 0x%x", edev->status);
 		}
 		return -1;
 	}
 
 	/* only the first interface is true */
-	snprintf(attrpath, sizeof(attrpath), "%s/%s:%d.%d/%s",
-			edev->udev.path,
-			edev->udev.busid,
-			edev->udev.bConfigurationValue, 0,
-			"usbip_sockfd");
+	snprintf(attr_path, sizeof(attr_path), "%s/%s:%d.%d/%s",
+		 edev->udev.path, edev->udev.busid,
+		 edev->udev.bConfigurationValue, 0, attr_name);
 
-	attr = sysfs_open_attribute(attrpath);
+	attr = sysfs_open_attribute(attr_path);
 	if (!attr) {
-		dbg("sysfs_open_attribute failed: %s", attrpath);
+		dbg("sysfs_open_attribute failed: %s", attr_path);
 		return -1;
 	}
 
 	snprintf(sockfd_buff, sizeof(sockfd_buff), "%d\n", sockfd);
-
 	dbg("write: %s", sockfd_buff);
+
 	ret = sysfs_write_attribute(attr, sockfd_buff, strlen(sockfd_buff));
 	if (ret < 0) {
-		dbg("sysfs_write_attribute failed:  sockfd %s to %s",
-		    sockfd_buff, attrpath);
+		dbg("sysfs_write_attribute failed: sockfd %s to %s",
+		    sockfd_buff, attr_path);
 		goto err_write_sockfd;
 	}
 
@@ -378,17 +384,17 @@ err_write_sockfd:
 	return ret;
 }
 
-struct usbip_exported_device *usbip_stub_get_device(int num)
+struct usbip_exported_device *usbip_host_get_device(int num)
 {
 	struct usbip_exported_device *edev;
-	struct dlist		*dlist = stub_driver->edev_list;
-	int count = 0;
+	struct dlist *dlist = host_driver->edev_list;
+	int cnt = 0;
 
 	dlist_for_each_data(dlist, edev, struct usbip_exported_device) {
-		if (num == count)
+		if (num == cnt)
 			return edev;
 		else
-			count++ ;
+			cnt++;
 	}
 
 	return NULL;
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
index 9eaf92c..34fd14c 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
@@ -1,37 +1,48 @@
 /*
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifndef __USBIP_STUB_DRIVER_H
-#define __USBIP_STUB_DRIVER_H
+#ifndef __USBIP_HOST_DRIVER_H
+#define __USBIP_HOST_DRIVER_H
 
 #include <stdint.h>
 #include "usbip_common.h"
 
-struct usbip_stub_driver {
+struct usbip_host_driver {
 	int ndevs;
 	struct sysfs_driver *sysfs_driver;
-
-	struct dlist *edev_list;	/* list of exported device */
+	/* list of exported device */
+	struct dlist *edev_list;
 };
 
 struct usbip_exported_device {
 	struct sysfs_device *sudev;
-
 	int32_t status;
-	struct usbip_usb_device    udev;
+	struct usbip_usb_device udev;
 	struct usbip_usb_interface uinf[];
 };
 
+extern struct usbip_host_driver *host_driver;
 
-extern struct usbip_stub_driver *stub_driver;
-
-int usbip_stub_driver_open(void);
-void usbip_stub_driver_close(void);
-
-int usbip_stub_refresh_device_list(void);
-int usbip_stub_export_device(struct usbip_exported_device *edev, int sockfd);
+int usbip_host_driver_open(void);
+void usbip_host_driver_close(void);
 
-struct usbip_exported_device *usbip_stub_get_device(int num);
+int usbip_host_refresh_device_list(void);
+int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd);
+struct usbip_exported_device *usbip_host_get_device(int num);
 
-#endif /* __USBIP_STUB_DRIVER_H */
+#endif /* __USBIP_HOST_DRIVER_H */
-- 
1.7.5.2

