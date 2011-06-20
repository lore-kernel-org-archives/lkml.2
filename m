Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1FTFwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:52:07 -0400
Received: from qmta11.westchester.pa.mail.comcast.net ([76.96.59.211]:51719
	"EHLO QMTA11.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558Ab1FTFwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:52:04 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/22] staging: usbip: userspace: libsrc: change all output messages to debug
Date: Sun, 19 Jun 2011 22:44:38 -0700
Message-Id: <322d228ac917df85008ac3e64143c1b1b394417a.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The library should not be displaying random messages intermixed with
those from the programs that use them. So, instead, change all of the
output from the library to debug only, and allow the programs to
decide what to tell the user. This also changes the messages to use
the same form, which makes understanding them easier.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/libsrc/stub_driver.c   |   55 ++++++------
 .../staging/usbip/userspace/libsrc/usbip_common.c  |   14 ++--
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |   94 ++++++++++----------
 3 files changed, 80 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.c b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
index 0f9593b..604aed1 100644
--- a/drivers/staging/usbip/userspace/libsrc/stub_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
@@ -27,7 +27,7 @@ static struct sysfs_driver *open_sysfs_stub_driver(void)
 
 	ret = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
 	if (ret < 0) {
-		err("sysfs must be mounted");
+		dbg("sysfs_get_mnt_path failed");
 		return NULL;
 	}
 
@@ -37,8 +37,7 @@ static struct sysfs_driver *open_sysfs_stub_driver(void)
 
 	stub_driver = sysfs_open_driver_path(stub_driver_path);
 	if (!stub_driver) {
-		err(USBIP_CORE_MOD_NAME ".ko and " USBIP_HOST_DRV_NAME
-		    ".ko must be loaded");
+		dbg("sysfs_open_driver_path failed");
 		return NULL;
 	}
 
@@ -82,7 +81,7 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 			break;
 
 		if (errno != ENOENT) {
-			err("error stat'ing %s", attrpath);
+			dbg("stat failed: %s", attrpath);
 			return -1;
 		}
 
@@ -91,21 +90,21 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 	}
 
 	if (retries == 0)
-		err("usbip_status not ready after %d retries",
-			SYSFS_OPEN_RETRIES);
+		dbg("usbip_status not ready after %d retries",
+		    SYSFS_OPEN_RETRIES);
 	else if (retries < SYSFS_OPEN_RETRIES)
-		info("warning: usbip_status ready after %d retries",
-			 SYSFS_OPEN_RETRIES - retries);
+		dbg("warning: usbip_status ready after %d retries",
+		    SYSFS_OPEN_RETRIES - retries);
 
 	attr = sysfs_open_attribute(attrpath);
 	if (!attr) {
-		err("open %s", attrpath);
+		dbg("sysfs_open_attribute failed: %s", attrpath);
 		return -1;
 	}
 
 	ret = sysfs_read_attribute(attr);
 	if (ret) {
-		err("read %s", attrpath);
+		dbg("sysfs_read_attribute failed: %s", attrpath);
 		sysfs_close_attribute(attr);
 		return -1;
 	}
@@ -134,13 +133,13 @@ static struct usbip_exported_device *usbip_exported_device_new(char *sdevpath)
 
 	edev = (struct usbip_exported_device *) calloc(1, sizeof(*edev));
 	if (!edev) {
-		err("alloc device");
+		dbg("calloc failed");
 		return NULL;
 	}
 
 	edev->sudev = sysfs_open_device_path(sdevpath);
 	if (!edev->sudev) {
-		err("open %s", sdevpath);
+		dbg("sysfs_open_device_path failed: %s", sdevpath);
 		goto err;
 	}
 
@@ -155,7 +154,7 @@ static struct usbip_exported_device *usbip_exported_device_new(char *sdevpath)
 		sizeof(struct usbip_usb_interface);
 	edev = (struct usbip_exported_device *) realloc(edev, size);
 	if (!edev) {
-		err("alloc device");
+		dbg("realloc failed");
 		goto err;
 	}
 
@@ -204,8 +203,8 @@ static int refresh_exported_devices(void)
 
 	suinf_list = sysfs_get_driver_devices(stub_driver->sysfs_driver);
 	if (!suinf_list) {
-		info("bind " USBIP_HOST_DRV_NAME ".ko to a usb device to be "
-		     "exportable!\n");
+		dbg("bind " USBIP_HOST_DRV_NAME ".ko to a usb device to be "
+		    "exportable!\n");
 		goto bye;
 	}
 
@@ -215,7 +214,7 @@ static int refresh_exported_devices(void)
 		/* get usb device of this usb interface */
 		sudev = sysfs_get_device_parent(suinf);
 		if (!sudev) {
-			err("get parent dev of %s", suinf->name);
+			dbg("sysfs_get_device_parent failed: %s", suinf->name);
 			continue;
 		}
 
@@ -229,7 +228,7 @@ static int refresh_exported_devices(void)
 
 		edev = usbip_exported_device_new(sudev->path);
 		if (!edev) {
-			err("usbip_exported_device new");
+			dbg("usbip_exported_device_new failed");
 			continue;
 		}
 
@@ -257,7 +256,7 @@ int usbip_stub_refresh_device_list(void)
 	stub_driver->edev_list = dlist_new_with_delete(sizeof(struct usbip_exported_device),
 			usbip_exported_device_delete);
 	if (!stub_driver->edev_list) {
-		err("alloc dlist");
+		dbg("dlist_new_with_delete failed");
 		return -1;
 	}
 
@@ -275,7 +274,7 @@ int usbip_stub_driver_open(void)
 
 	stub_driver = (struct usbip_stub_driver *) calloc(1, sizeof(*stub_driver));
 	if (!stub_driver) {
-		err("alloc stub_driver");
+		dbg("calloc failed");
 		return -1;
 	}
 
@@ -284,7 +283,7 @@ int usbip_stub_driver_open(void)
 	stub_driver->edev_list = dlist_new_with_delete(sizeof(struct usbip_exported_device),
 			usbip_exported_device_delete);
 	if (!stub_driver->edev_list) {
-		err("alloc dlist");
+		dbg("dlist_new_with_delete failed");
 		goto err;
 	}
 
@@ -334,16 +333,16 @@ int usbip_stub_export_device(struct usbip_exported_device *edev, int sockfd)
 
 
 	if (edev->status != SDEV_ST_AVAILABLE) {
-		info("device not available, %s", edev->udev.busid);
+		dbg("device not available: %s", edev->udev.busid);
 		switch( edev->status ) {
 			case SDEV_ST_ERROR:
-				info("     status SDEV_ST_ERROR");
+				dbg("status SDEV_ST_ERROR");
 				break;
 			case SDEV_ST_USED:
-				info("     status SDEV_ST_USED");
+				dbg("status SDEV_ST_USED");
 				break;
 			default:
-				info("     status unknown: 0x%x", edev->status);
+				dbg("status unknown: 0x%x", edev->status);
 		}
 		return -1;
 	}
@@ -357,21 +356,21 @@ int usbip_stub_export_device(struct usbip_exported_device *edev, int sockfd)
 
 	attr = sysfs_open_attribute(attrpath);
 	if (!attr) {
-		err("open %s", attrpath);
+		dbg("sysfs_open_attribute failed: %s", attrpath);
 		return -1;
 	}
 
 	snprintf(sockfd_buff, sizeof(sockfd_buff), "%d\n", sockfd);
 
 	dbg("write: %s", sockfd_buff);
-
 	ret = sysfs_write_attribute(attr, sockfd_buff, strlen(sockfd_buff));
 	if (ret < 0) {
-		err("write sockfd %s to %s", sockfd_buff, attrpath);
+		dbg("sysfs_write_attribute failed:  sockfd %s to %s",
+		    sockfd_buff, attrpath);
 		goto err_write_sockfd;
 	}
 
-	info("connect %s", edev->udev.busid);
+	dbg("connect: %s", edev->udev.busid);
 
 err_write_sockfd:
 	sysfs_close_attribute(attr);
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
index e0ec23f..154b4b1 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
@@ -120,19 +120,19 @@ int read_attr_value(struct sysfs_device *dev, const char *name, const char *form
 
 	attr = sysfs_open_attribute(attrpath);
 	if (!attr) {
-		err("open attr %s", attrpath);
+		dbg("sysfs_open_attribute failed: %s", attrpath);
 		return 0;
 	}
 
 	ret = sysfs_read_attribute(attr);
 	if (ret < 0) {
-		err("read attr");
+		dbg("sysfs_read_attribute failed");
 		goto err;
 	}
 
 	ret = sscanf(attr->value, format, &num);
 	if (ret < 1) {
-		err("sscanf");
+		dbg("sscanf failed");
 		goto err;
 	}
 
@@ -154,19 +154,19 @@ int read_attr_speed(struct sysfs_device *dev)
 
 	attr = sysfs_open_attribute(attrpath);
 	if (!attr) {
-		err("open attr");
+		dbg("sysfs_open_attribute failed: %s", attrpath);
 		return 0;
 	}
 
 	ret = sysfs_read_attribute(attr);
 	if (ret < 0) {
-		err("read attr");
+		dbg("sysfs_read_attribute failed");
 		goto err;
 	}
 
 	ret = sscanf(attr->value, "%s\n", speed);
 	if (ret < 1) {
-		err("sscanf");
+		dbg("sscanf failed");
 		goto err;
 	}
 err:
@@ -222,7 +222,7 @@ int read_usb_interface(struct usbip_usb_device *udev, int i,
 
 	sif = sysfs_open_device("usb", busid);
 	if (!sif) {
-		err("open sif of %s", busid);
+		dbg("sysfs_open_device(\"usb\", \"%s\") failed", busid);
 		return -1;
 	}
 
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index e663fab..abbc285 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -16,7 +16,7 @@ static struct usbip_imported_device *imported_device_init(struct usbip_imported_
 
 	sudev = sysfs_open_device("usb", busid);
 	if (!sudev) {
-		err("sysfs_open_device %s", busid);
+		dbg("sysfs_open_device failed: %s", busid);
 		goto err;
 	}
 	read_usb_device(sudev, &idev->udev);
@@ -71,7 +71,7 @@ static int parse_status(char *value)
 				&devid, &socket, lbusid);
 
 		if (ret < 5) {
-			err("scanf %d", ret);
+			dbg("sscanf failed: %d", ret);
 			BUG();
 		}
 
@@ -94,14 +94,14 @@ static int parse_status(char *value)
 
 			idev->cdev_list = dlist_new(sizeof(struct usbip_class_device));
 			if (!idev->cdev_list) {
-				err("init new device");
+				dbg("dlist_new failed");
 				return -1;
 			}
 
 			if (idev->status != VDEV_ST_NULL && idev->status != VDEV_ST_NOTASSIGNED) {
 				idev = imported_device_init(idev, lbusid);
 				if (!idev) {
-					err("init new device");
+					dbg("imported_device_init failed");
 					return -1;
 				}
 			}
@@ -134,7 +134,7 @@ static int check_usbip_device(struct sysfs_class_device *cdev)
 			/* found usbip device */
 			usbip_cdev = calloc(1, sizeof(*usbip_cdev));
 			if (!cdev) {
-				err("calloc usbip_cdev");
+				dbg("calloc failed");
 				return -1;
 			}
 			dlist_unshift(vhci_driver->cdev_list, usbip_cdev);
@@ -142,7 +142,7 @@ static int check_usbip_device(struct sysfs_class_device *cdev)
 				sizeof(usbip_cdev->class_path));
 			strncpy(usbip_cdev->dev_path, dev_path,
 				sizeof(usbip_cdev->dev_path));
-			dbg("  found %s %s", class_path, dev_path);
+			dbg("found: %s %s", class_path, dev_path);
 		}
 	}
 
@@ -159,11 +159,11 @@ static int search_class_for_usbip_device(char *cname)
 
 	class = sysfs_open_class(cname);
 	if (!class) {
-		err("open class");
+		dbg("sysfs_open_class failed");
 		return -1;
 	}
 
-	dbg("class %s", class->name);
+	dbg("class: %s", class->name);
 
 	cdev_list = sysfs_get_class_devices(class);
 	if (!cdev_list)
@@ -171,7 +171,7 @@ static int search_class_for_usbip_device(char *cname)
 		goto out;
 
 	dlist_for_each_data(cdev_list, cdev, struct sysfs_class_device) {
-		dbg("   cdev %s", cdev->name);
+		dbg("cdev: %s", cdev->name);
 		ret = check_usbip_device(cdev);
 		if (ret < 0)
 			goto out;
@@ -194,7 +194,7 @@ static int refresh_class_device_list(void)
 
 	ret = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
 	if (ret < 0) {
-		err("sysfs must be mounted");
+		dbg("sysfs_get_mnt_path failed");
 		return -1;
 	}
 
@@ -204,7 +204,7 @@ static int refresh_class_device_list(void)
 	/* search under /sys/class */
 	cname_list = sysfs_open_directory_list(class_path);
 	if (!cname_list) {
-		err("open class directory");
+		dbg("sysfs_open_directory failed");
 		return -1;
 	}
 
@@ -234,45 +234,42 @@ static int refresh_imported_device_list(void)
 
 	attr_status = sysfs_get_device_attr(vhci_driver->hc_device, "status");
 	if (!attr_status) {
-		err("get attr %s of %s", "status", vhci_driver->hc_device->name);
+		dbg("sysfs_get_device_attr(\"status\") failed: %s",
+		    vhci_driver->hc_device->name);
 		return -1;
 	}
 
-	dbg("name %s, path %s, len %d, method %d\n", attr_status->name,
-			attr_status->path, attr_status->len, attr_status->method);
-
-	dbg("%s", attr_status->value);
+	dbg("name: %s  path: %s  len: %d  method: %d  value: %s",
+	    attr_status->name, attr_status->path, attr_status->len,
+	    attr_status->method, attr_status->value);
 
 	return parse_status(attr_status->value);
 }
 
 static int get_nports(void)
 {
+	char *c;
 	int nports = 0;
 	struct sysfs_attribute *attr_status;
 
 	attr_status = sysfs_get_device_attr(vhci_driver->hc_device, "status");
 	if (!attr_status) {
-		err("get attr %s of %s", "status", vhci_driver->hc_device->name);
+		dbg("sysfs_get_device_attr(\"status\") failed: %s",
+		    vhci_driver->hc_device->name);
 		return -1;
 	}
 
-	dbg("name %s, path %s, len %d, method %d\n", attr_status->name,
-			attr_status->path, attr_status->len, attr_status->method);
-
-	dbg("%s", attr_status->value);
+	dbg("name: %s  path: %s  len: %d  method: %d  value: %s",
+	    attr_status->name, attr_status->path, attr_status->len,
+	    attr_status->method, attr_status->value);
 
-	{
-		char *c;
-
-		/* skip a header line */
-		c = strchr(attr_status->value, '\n') + 1;
+	/* skip a header line */
+	c = strchr(attr_status->value, '\n') + 1;
 
-		while (*c != '\0') {
-			/* go to the next line */
-			c = strchr(c, '\n') + 1;
-			nports += 1;
-		}
+	while (*c != '\0') {
+		/* go to the next line */
+		c = strchr(c, '\n') + 1;
+		nports += 1;
 	}
 
 	return nports;
@@ -294,15 +291,15 @@ static int get_hc_busid(char *sysfs_mntpath, char *hc_busid)
 
         sdriver = sysfs_open_driver_path(sdriver_path);
         if (!sdriver) {
-		info("%s is not found", sdriver_path);
-                info("please load " USBIP_CORE_MOD_NAME ".ko and "
-		     USBIP_VHCI_DRV_NAME ".ko!");
+		dbg("sysfs_open_driver_path failed: %s", sdriver_path);
+                dbg("make sure " USBIP_CORE_MOD_NAME ".ko and "
+		    USBIP_VHCI_DRV_NAME ".ko are loaded!");
                 return -1;
         }
 
 	hc_devs = sysfs_get_driver_devices(sdriver);
 	if (!hc_devs) {
-		err("get hc list");
+		dbg("sysfs_get_driver failed");
 		goto err;
 	}
 
@@ -318,7 +315,7 @@ err:
 	if (found)
 		return 0;
 
-	err("not found usbip hc");
+	dbg("%s not found", hc_busid);
 	return -1;
 }
 
@@ -332,13 +329,13 @@ int usbip_vhci_driver_open(void)
 
 	vhci_driver = (struct usbip_vhci_driver *) calloc(1, sizeof(*vhci_driver));
 	if (!vhci_driver) {
-		err("alloc vhci_driver");
+		dbg("calloc failed");
 		return -1;
 	}
 
 	ret = sysfs_get_mnt_path(vhci_driver->sysfs_mntpath, SYSFS_PATH_MAX);
 	if (ret < 0) {
-		err("sysfs must be mounted");
+		dbg("sysfs_get_mnt_path failed");
 		goto err;
 	}
 
@@ -350,13 +347,13 @@ int usbip_vhci_driver_open(void)
 	vhci_driver->hc_device = sysfs_open_device(USBIP_VHCI_BUS_TYPE,
 						   hc_busid);
 	if (!vhci_driver->hc_device) {
-		err("get sysfs vhci_driver");
+		dbg("sysfs_open_device failed");
 		goto err;
 	}
 
 	vhci_driver->nports = get_nports();
 
-	info("%d ports available\n", vhci_driver->nports);
+	dbg("available ports: %d", vhci_driver->nports);
 
 	vhci_driver->cdev_list = dlist_new(sizeof(struct usbip_class_device));
 	if (!vhci_driver->cdev_list)
@@ -437,7 +434,7 @@ err:
 			dlist_destroy(vhci_driver->idev[i].cdev_list);
 	}
 
-	err("refresh device list");
+	dbg("failed to refresh device list");
 	return -1;
 }
 
@@ -460,7 +457,8 @@ int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
 
 	attr_attach = sysfs_get_device_attr(vhci_driver->hc_device, "attach");
 	if (!attr_attach) {
-		err("get attach");
+		dbg("sysfs_get_device_attr(\"attach\") failed: %s",
+		    vhci_driver->hc_device->name);
 		return -1;
 	}
 
@@ -470,11 +468,11 @@ int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
 
 	ret = sysfs_write_attribute(attr_attach, buff, strlen(buff));
 	if (ret < 0) {
-		err("write to attach failed");
+		dbg("sysfs_write_attribute failed");
 		return -1;
 	}
 
-	info("port %d attached", port);
+	dbg("attached port: %d", port);
 
 	return 0;
 }
@@ -501,21 +499,21 @@ int usbip_vhci_detach_device(uint8_t port)
 
 	attr_detach = sysfs_get_device_attr(vhci_driver->hc_device, "detach");
 	if (!attr_detach) {
-		err("get detach");
+		dbg("sysfs_get_device_attr(\"detach\") failed: %s",
+		    vhci_driver->hc_device->name);
 		return -1;
 	}
 
 	snprintf(buff, sizeof(buff), "%u", port);
-	dbg("writing to detach");
 	dbg("writing: %s", buff);
 
 	ret = sysfs_write_attribute(attr_detach, buff, strlen(buff));
 	if (ret < 0) {
-		err("write to detach failed");
+		dbg("sysfs_write_attribute failed");
 		return -1;
 	}
 
-	info("port %d detached", port);
+	dbg("detached port: %d", port);
 
 	return 0;
 }
-- 
1.7.5.2

