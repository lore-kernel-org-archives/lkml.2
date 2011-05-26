Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab1EZNSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:18:45 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:46419 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757685Ab1EZNRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:17:32 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Arjan Mels <arjan.mels@nxp.com>, usbip-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] staging: usbip: userspace: change struct class_device to usbip_class_device
Date: Thu, 26 May 2011 06:17:09 -0700
Message-Id: <69201f07ed1c328826924863c362320ac9acbe1d.1306414175.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306414175.git.mfm@muteddisk.com>
References: <cover.1306414175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename class_device struct to avoid confusion and change member names.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |   48 ++++++++++---------
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |   17 ++++---
 drivers/staging/usbip/userspace/src/usbip.c        |    9 ++--
 3 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index aa439c6..9296f96 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -20,10 +20,12 @@ static struct usbip_imported_device *imported_device_init(struct usbip_imported_
 	sysfs_close_device(sudev);
 
 	/* add class devices of this imported device */
-	struct class_device *cdev;
-	dlist_for_each_data(vhci_driver->cdev_list, cdev, struct class_device) {
-		if (!strncmp(cdev->devpath, idev->udev.path, strlen(idev->udev.path))) {
-			struct class_device *new_cdev;
+	struct usbip_class_device *cdev;
+	dlist_for_each_data(vhci_driver->cdev_list, cdev,
+			    struct usbip_class_device) {
+		if (!strncmp(cdev->dev_path, idev->udev.path,
+			     strlen(idev->udev.path))) {
+			struct usbip_class_device *new_cdev;
 
 			/* alloc and copy because dlist is linked from only one list */
 			new_cdev = calloc(1, sizeof(*new_cdev));
@@ -87,7 +89,7 @@ static int parse_status(char *value)
 			idev->busnum	= (devid >> 16);
 			idev->devnum	= (devid & 0x0000ffff);
 
-			idev->cdev_list = dlist_new(sizeof(struct class_device));
+			idev->cdev_list = dlist_new(sizeof(struct usbip_class_device));
 			if (!idev->cdev_list) {
 				err("init new device");
 				return -1;
@@ -115,29 +117,29 @@ static int parse_status(char *value)
 
 static int check_usbip_device(struct sysfs_class_device *cdev)
 {
-	char clspath[SYSFS_PATH_MAX];	/* /sys/class/video4linux/video0/device     */
-	char devpath[SYSFS_PATH_MAX];	/* /sys/devices/platform/vhci_hcd/usb6/6-1:1.1  */
-
+	char class_path[SYSFS_PATH_MAX]; /* /sys/class/video4linux/video0/device */
+	char dev_path[SYSFS_PATH_MAX];	 /* /sys/devices/platform/vhci_hcd/usb6/6-1:1.1 */
 	int ret;
+	struct usbip_class_device *usbip_cdev;
 
-	snprintf(clspath, sizeof(clspath), "%s/device", cdev->path);
+	snprintf(class_path, sizeof(class_path), "%s/device", cdev->path);
 
-	ret = sysfs_get_link(clspath, devpath, SYSFS_PATH_MAX);
-	if (!ret) {
-		if (!strncmp(devpath, vhci_driver->hc_device->path,
-					strlen(vhci_driver->hc_device->path))) {
+	ret = sysfs_get_link(class_path, dev_path, sizeof(dev_path));
+	if (ret == 0) {
+		if (!strncmp(dev_path, vhci_driver->hc_device->path,
+			     strlen(vhci_driver->hc_device->path))) {
 			/* found usbip device */
-			struct class_device *cdev;
-
-			cdev = calloc(1, sizeof(*cdev));
+			usbip_cdev = calloc(1, sizeof(*usbip_cdev));
 			if (!cdev) {
-				err("calloc cdev");
+				err("calloc usbip_cdev");
 				return -1;
 			}
-			dlist_unshift(vhci_driver->cdev_list, (void*) cdev);
-			strncpy(cdev->clspath, clspath, sizeof(cdev->clspath));
-			strncpy(cdev->devpath, devpath, sizeof(cdev->clspath));
-			dbg("  found %s %s", clspath, devpath);
+			dlist_unshift(vhci_driver->cdev_list, usbip_cdev);
+			strncpy(usbip_cdev->class_path, class_path,
+				sizeof(usbip_cdev->class_path));
+			strncpy(usbip_cdev->dev_path, dev_path,
+				sizeof(usbip_cdev->dev_path));
+			dbg("  found %s %s", class_path, dev_path);
 		}
 	}
 
@@ -341,7 +343,7 @@ int usbip_vhci_driver_open(void)
 
 	info("%d ports available\n", vhci_driver->nports);
 
-	vhci_driver->cdev_list = dlist_new(sizeof(struct class_device));
+	vhci_driver->cdev_list = dlist_new(sizeof(struct usbip_class_device));
 	if (!vhci_driver->cdev_list)
 		goto err;
 
@@ -400,7 +402,7 @@ int usbip_vhci_refresh_device_list(void)
 			dlist_destroy(vhci_driver->idev[i].cdev_list);
 	}
 
-	vhci_driver->cdev_list = dlist_new(sizeof(struct class_device));
+	vhci_driver->cdev_list = dlist_new(sizeof(struct usbip_class_device));
 	if (!vhci_driver->cdev_list)
 		goto err;
 
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
index cad8ad7..3af41c5 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
@@ -11,9 +11,9 @@
 
 #define MAXNPORT 128
 
-struct class_device {
-	char clspath[SYSFS_PATH_MAX];
-	char devpath[SYSFS_PATH_MAX];
+struct usbip_class_device {
+	char class_path[SYSFS_PATH_MAX];
+	char dev_path[SYSFS_PATH_MAX];
 };
 
 struct usbip_imported_device {
@@ -25,16 +25,19 @@ struct usbip_imported_device {
 	uint8_t busnum;
 	uint8_t devnum;
 
-
-	struct dlist *cdev_list;	/* list of class device */
+	/* usbip_class_device list */
+	struct dlist *cdev_list;
 	struct usb_device udev;
 };
 
 struct usbip_vhci_driver {
 	char sysfs_mntpath[SYSFS_PATH_MAX];
-	struct sysfs_device *hc_device; /* /sys/devices/platform/vhci_hcd */
 
-	struct dlist *cdev_list;	/* list of class device */
+	/* /sys/devices/platform/vhci_hcd */
+	struct sysfs_device *hc_device;
+
+	/* usbip_class_device list */
+	struct dlist *cdev_list;
 
 	int nports;
 	struct usbip_imported_device idev[MAXNPORT];
diff --git a/drivers/staging/usbip/userspace/src/usbip.c b/drivers/staging/usbip/userspace/src/usbip.c
index 01a5628..c73b355 100644
--- a/drivers/staging/usbip/userspace/src/usbip.c
+++ b/drivers/staging/usbip/userspace/src/usbip.c
@@ -174,12 +174,13 @@ int usbip_vhci_imported_device_dump(struct usbip_imported_device *idev)
 		sysfs_close_device(suinf);
 
 		/* show class device information */
-		struct class_device *cdev;
+		struct usbip_class_device *cdev;
 
-		dlist_for_each_data(idev->cdev_list, cdev, struct class_device) {
-			int ifnum = get_interface_number(cdev->devpath);
+		dlist_for_each_data(idev->cdev_list, cdev,
+				    struct usbip_class_device) {
+			int ifnum = get_interface_number(cdev->dev_path);
 			if (ifnum == i) {
-				info("           %s", cdev->clspath);
+				info("           %s", cdev->class_path);
 			}
 		}
 	}
-- 
1.7.5.1

