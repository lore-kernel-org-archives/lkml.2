Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1EZNRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:17:45 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:33570
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757778Ab1EZNRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:17:41 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Arjan Mels <arjan.mels@nxp.com>, usbip-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] staging: usbip: userspace: vhci_driver: parameterize path names
Date: Thu, 26 May 2011 06:17:10 -0700
Message-Id: <e18fc63defbde358eb040d170f6739db0cec5726.1306414175.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306414175.git.mfm@muteddisk.com>
References: <cover.1306414175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a macro for the bus type and use libsysfs for class path.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |   22 +++++++++++++++----
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |    2 +-
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index 9296f96..f2030b1 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -186,9 +186,20 @@ static int refresh_class_device_list(void)
 	int ret;
 	struct dlist *cname_list;
 	char *cname;
+	char sysfs_mntpath[SYSFS_PATH_MAX];
+	char class_path[SYSFS_PATH_MAX];
+
+	ret = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
+	if (ret < 0) {
+		err("sysfs must be mounted");
+		return -1;
+	}
+
+	snprintf(class_path, sizeof(class_path), "%s/%s", sysfs_mntpath,
+		 SYSFS_CLASS_NAME);
 
 	/* search under /sys/class */
-	cname_list = sysfs_open_directory_list("/sys/class");
+	cname_list = sysfs_open_directory_list(class_path);
 	if (!cname_list) {
 		err("open class directory");
 		return -1;
@@ -274,9 +285,9 @@ static int get_hc_busid(char *sysfs_mntpath, char *hc_busid)
 
 	int found = 0;
 
-        snprintf(sdriver_path, SYSFS_PATH_MAX, "%s/%s/platform/%s/%s",
-                                sysfs_mntpath, SYSFS_BUS_NAME, SYSFS_DRIVERS_NAME,
-                                USBIP_VHCI_DRV_NAME);
+        snprintf(sdriver_path, SYSFS_PATH_MAX, "%s/%s/%s/%s/%s", sysfs_mntpath,
+		 SYSFS_BUS_NAME, USBIP_VHCI_BUS_TYPE, SYSFS_DRIVERS_NAME,
+		 USBIP_VHCI_DRV_NAME);
 
         sdriver = sysfs_open_driver_path(sdriver_path);
         if (!sdriver) {
@@ -333,7 +344,8 @@ int usbip_vhci_driver_open(void)
 		goto err;
 
 	/* will be freed in usbip_driver_close() */
-	vhci_driver->hc_device = sysfs_open_device("platform", hc_busid);
+	vhci_driver->hc_device = sysfs_open_device(USBIP_VHCI_BUS_TYPE,
+						   hc_busid);
 	if (!vhci_driver->hc_device) {
 		err("get sysfs vhci_driver");
 		goto err;
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
index 3af41c5..3395586 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
@@ -7,7 +7,7 @@
 
 #include "usbip.h"
 
-
+#define USBIP_VHCI_BUS_TYPE "platform"
 
 #define MAXNPORT 128
 
-- 
1.7.5.1

