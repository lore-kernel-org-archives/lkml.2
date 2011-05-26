Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab1EZNRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:17:34 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:50344 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757684Ab1EZNRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:17:31 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Arjan Mels <arjan.mels@nxp.com>, usbip-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] staging: usbip: userspace: set kernel module names in one place
Date: Thu, 26 May 2011 06:17:08 -0700
Message-Id: <d8bbe57055b9f7b97349a6fdeb6253fe759f8cb2.1306414175.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306414175.git.mfm@muteddisk.com>
References: <cover.1306414175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move kernel module name setting to usbip_common.h so that macros can
be used instead of hard coding the names in multiple places.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/libsrc/stub_driver.c   |   12 ++++------
 .../staging/usbip/userspace/libsrc/usbip_common.h  |    6 ++++-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |    8 ++----
 drivers/staging/usbip/userspace/src/bind-driver.c  |   23 +++++++++++++------
 4 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.c b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
index cc33643..0355604 100644
--- a/drivers/staging/usbip/userspace/libsrc/stub_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
@@ -8,10 +8,6 @@
 
 #include "usbip.h"
 
-/* kernel module name */
-static const char *usbip_stub_driver_name = "usbip-host";
-
-
 struct usbip_stub_driver *stub_driver;
 
 static struct sysfs_driver *open_sysfs_stub_driver(void)
@@ -31,11 +27,12 @@ static struct sysfs_driver *open_sysfs_stub_driver(void)
 
 	snprintf(stub_driver_path, SYSFS_PATH_MAX, "%s/%s/usb/%s/%s",
 			sysfs_mntpath, SYSFS_BUS_NAME, SYSFS_DRIVERS_NAME,
-			usbip_stub_driver_name);
+			USBIP_HOST_DRV_NAME);
 
 	stub_driver = sysfs_open_driver_path(stub_driver_path);
 	if (!stub_driver) {
-		err("usbip-core.ko and usbip-host.ko must be loaded");
+		err(USBIP_CORE_MOD_NAME ".ko and " USBIP_HOST_DRV_NAME
+		    ".ko must be loaded");
 		return NULL;
 	}
 
@@ -200,7 +197,8 @@ static int refresh_exported_devices(void)
 
 	suinf_list = sysfs_get_driver_devices(stub_driver->sysfs_driver);
 	if (!suinf_list) {
-		printf("Bind usbip-host.ko to a usb device to be exportable!\n");
+		info("bind " USBIP_HOST_DRV_NAME ".ko to a usb device to be "
+		     "exportable!\n");
 		goto bye;
 	}
 
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index c254b54..2c58af5 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -26,7 +26,11 @@
 #define VHCI_STATE_PATH "/var/run/vhci_hcd"
 #endif
 
-//#include <linux/usb_ch9.h>
+/* kernel module names */
+#define USBIP_CORE_MOD_NAME	"usbip-core"
+#define USBIP_HOST_DRV_NAME	"usbip-host"
+#define USBIP_VHCI_DRV_NAME	"vhci_hcd"
+
 enum usb_device_speed {
 	USB_SPEED_UNKNOWN = 0,                  /* enumerating */
 	USB_SPEED_LOW, USB_SPEED_FULL,          /* usb 1.1 */
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index db43f8d..aa439c6 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -5,9 +5,6 @@
 
 #include "usbip.h"
 
-
-static const char vhci_driver_name[] = "vhci_hcd";
-
 struct usbip_vhci_driver *vhci_driver;
 
 static struct usbip_imported_device *imported_device_init(struct usbip_imported_device *idev, char *busid)
@@ -277,12 +274,13 @@ static int get_hc_busid(char *sysfs_mntpath, char *hc_busid)
 
         snprintf(sdriver_path, SYSFS_PATH_MAX, "%s/%s/platform/%s/%s",
                                 sysfs_mntpath, SYSFS_BUS_NAME, SYSFS_DRIVERS_NAME,
-                                vhci_driver_name);
+                                USBIP_VHCI_DRV_NAME);
 
         sdriver = sysfs_open_driver_path(sdriver_path);
         if (!sdriver) {
 		info("%s is not found", sdriver_path);
-                info("load usbip-core.ko and vhci-hcd.ko !");
+                info("please load " USBIP_CORE_MOD_NAME ".ko and "
+		     USBIP_VHCI_DRV_NAME ".ko!");
                 return -1;
         }
 
diff --git a/drivers/staging/usbip/userspace/src/bind-driver.c b/drivers/staging/usbip/userspace/src/bind-driver.c
index dcc540a..1396ff9 100644
--- a/drivers/staging/usbip/userspace/src/bind-driver.c
+++ b/drivers/staging/usbip/userspace/src/bind-driver.c
@@ -3,13 +3,12 @@
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
 
-#include "utils.h"
-
 #define _GNU_SOURCE
 #include <getopt.h>
 #include <glib.h>
 
-
+#include "usbip.h"
+#include "utils.h"
 
 static const struct option longopts[] = {
 	{"usbip",	required_argument,	NULL, 'u'},
@@ -27,9 +26,6 @@ static const struct option longopts[] = {
 	{NULL,		0,			NULL,  0}
 };
 
-static const char match_busid_path[] = "/sys/bus/usb/drivers/usbip-host/match_busid";
-
-
 static void show_help(void)
 {
 	printf("Usage: usbip_bind_driver [OPTION]\n");
@@ -51,6 +47,18 @@ static int modify_match_busid(char *busid, int add)
 	int fd;
 	int ret;
 	char buff[BUS_ID_SIZE + 4];
+	char sysfs_mntpath[SYSFS_PATH_MAX];
+	char match_busid_path[SYSFS_PATH_MAX];
+
+	ret = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
+	if (ret < 0) {
+		err("sysfs must be mounted");
+		return -1;
+	}
+
+	snprintf(match_busid_path, sizeof(match_busid_path),
+		 "%s/%s/usb/%s/%s/match_busid", sysfs_mntpath, SYSFS_BUS_NAME,
+		 SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME);
 
 	/* BUS_IS_SIZE includes NULL termination? */
 	if (strnlen(busid, BUS_ID_SIZE) > BUS_ID_SIZE - 1) {
@@ -228,7 +236,8 @@ static int bind_to_usbip(char *busid)
 	for (i = 0; i < ninterface; i++) {
 		int ret;
 
-		ret = bind_interface(busid, configvalue, i, "usbip-host");
+		ret = bind_interface(busid, configvalue, i,
+				     USBIP_HOST_DRV_NAME);
 		if (ret < 0) {
 			g_warning("bind usbip at %s:%d.%d, failed",
 					busid, configvalue, i);
-- 
1.7.5.1

