Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab0CYFRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:17:32 -0400
Received: from mail.perches.com ([173.55.12.10]:1087 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab0CYFR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:29 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 04/13] drivers/staging/otus: Hoist assign from if
Date: Wed, 24 Mar 2010 22:16:58 -0700
Message-Id: <a8f369b1dfec256275ebf0c4459b6d1052b55b7e.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269493047.git.joe@perches.com>
References: <cover.1269493047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/otus/hal/hpmain.c |   30 ++++++++++++++++++------------
 drivers/staging/otus/usbdrv.c     |    6 ++++--
 drivers/staging/otus/zdusb.c      |    3 ++-
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/otus/hal/hpmain.c b/drivers/staging/otus/hal/hpmain.c
index 8dff5b9..5f412e0 100644
--- a/drivers/staging/otus/hal/hpmain.c
+++ b/drivers/staging/otus/hal/hpmain.c
@@ -142,8 +142,9 @@ u16_t zfHpInit(zdev_t* dev, u32_t frequency)
     if (wd->modeMDKEnable)
     {
         /* download the MDK firmware */
-        if ((ret = zfFirmwareDownload(dev, (u32_t*)zcDKFwImage,
-                (u32_t)zcDKFwImageSize, ZM_FIRMWARE_WLAN_ADDR)) != ZM_SUCCESS)
+        ret = zfFirmwareDownload(dev, (u32_t*)zcDKFwImage,
+                (u32_t)zcDKFwImageSize, ZM_FIRMWARE_WLAN_ADDR);
+        if (ret != ZM_SUCCESS)
         {
             /* TODO : exception handling */
             //return 1;
@@ -153,8 +154,9 @@ u16_t zfHpInit(zdev_t* dev, u32_t frequency)
     {
     #ifndef ZM_OTUS_LINUX_PHASE_2
         /* download the normal firmware */
-        if ((ret = zfFirmwareDownload(dev, (u32_t*)zcFwImage,
-                (u32_t)zcFwImageSize, ZM_FIRMWARE_WLAN_ADDR)) != ZM_SUCCESS)
+        ret = zfFirmwareDownload(dev, (u32_t*)zcFwImage,
+                (u32_t)zcFwImageSize, ZM_FIRMWARE_WLAN_ADDR);
+        if (ret != ZM_SUCCESS)
         {
             /* TODO : exception handling */
             //return 1;
@@ -162,16 +164,18 @@ u16_t zfHpInit(zdev_t* dev, u32_t frequency)
     #else
 
         // 1-PH fw: ReadMac() store some global variable
-        if ((ret = zfFirmwareDownloadNotJump(dev, (u32_t*)zcFwBufImage,
-                (u32_t)zcFwBufImageSize, 0x102800)) != ZM_SUCCESS)
+        ret = zfFirmwareDownloadNotJump(dev, (u32_t*)zcFwBufImage,
+                (u32_t)zcFwBufImageSize, 0x102800);
+        if (ret != ZM_SUCCESS)
         {
             DbgPrint("Dl zcFwBufImage failed!");
         }
 
         zfwSleep(dev, 1000);
 
-        if ((ret = zfFirmwareDownload(dev, (u32_t*)zcFwImage,
-                (u32_t)zcFwImageSize, ZM_FIRMWARE_WLAN_ADDR)) != ZM_SUCCESS)
+        ret = zfFirmwareDownload(dev, (u32_t*)zcFwImage,
+                (u32_t)zcFwImageSize, ZM_FIRMWARE_WLAN_ADDR);
+        if (ret != ZM_SUCCESS)
         {
             DbgPrint("Dl zcFwBufImage failed!");
         }
@@ -249,15 +253,17 @@ u16_t zfHpReinit(zdev_t* dev, u32_t frequency)
 
     #ifndef ZM_OTUS_LINUX_PHASE_2
     /* Download firmware */
-    if ((ret = zfFirmwareDownload(dev, (u32_t*)zcFwImage,
-            (u32_t)zcFwImageSize, ZM_FIRMWARE_WLAN_ADDR)) != ZM_SUCCESS)
+    ret = zfFirmwareDownload(dev, (u32_t*)zcFwImage,
+            (u32_t)zcFwImageSize, ZM_FIRMWARE_WLAN_ADDR);
+    if (ret != ZM_SUCCESS)
     {
         /* TODO : exception handling */
         //return 1;
     }
     #else
-    if ((ret = zfFirmwareDownload(dev, (u32_t*)zcP2FwImage,
-            (u32_t)zcP2FwImageSize, ZM_FIRMWARE_WLAN_ADDR)) != ZM_SUCCESS)
+    ret = zfFirmwareDownload(dev, (u32_t*)zcP2FwImage,
+            (u32_t)zcP2FwImageSize, ZM_FIRMWARE_WLAN_ADDR);
+    if (ret != ZM_SUCCESS)
     {
         /* TODO : exception handling */
         //return 1;
diff --git a/drivers/staging/otus/usbdrv.c b/drivers/staging/otus/usbdrv.c
index 5e6a120..7c8e34d 100644
--- a/drivers/staging/otus/usbdrv.c
+++ b/drivers/staging/otus/usbdrv.c
@@ -349,7 +349,8 @@ int usbdrv_open(struct net_device *dev)
     }
 
     size = zfiGlobalDataSize(dev);
-    if ((mem = kmalloc(size, GFP_KERNEL)) == NULL)
+    mem = kmalloc(size, GFP_KERNEL);
+    if (mem == NULL)
     {
         rc = -EBUSY;
         goto exit;
@@ -697,7 +698,8 @@ void usbdrv_remove1(struct pci_dev *pcid)
     struct net_device *dev;
     struct usbdrv_private *macp;
 
-    if (!(dev = (struct net_device *) pci_get_drvdata(pcid)))
+    dev = (struct net_device *)pci_get_drvdata(pcid);
+    if (!dev)
         return;
 
     macp = dev->ml_priv;
diff --git a/drivers/staging/otus/zdusb.c b/drivers/staging/otus/zdusb.c
index 4cd9b7f..e7cdb48 100644
--- a/drivers/staging/otus/zdusb.c
+++ b/drivers/staging/otus/zdusb.c
@@ -94,7 +94,8 @@ static int zfLnxProbe(struct usb_interface *interface,
         printk(KERN_NOTICE "USB 1.1 Host\n");
 #endif
 
-    if (!(macp = kmalloc(sizeof(struct usbdrv_private), GFP_KERNEL)))
+    macp = kmalloc(sizeof(struct usbdrv_private), GFP_KERNEL);
+    if (!macp)
     {
         printk(KERN_ERR "out of memory allocating device structure\n");
         result = -ENOMEM;
-- 
1.7.0.14.g7e948

