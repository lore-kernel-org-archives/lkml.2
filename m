Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab2FYOka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:40:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61386 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab2FYOk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:40:28 -0400
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] usb: gadget: mass_storage: make "file" and "ro" read only in some cases
Date: Mon, 25 Jun 2012 16:40:22 +0200
Message-Id: <814aca965c70c7dfef1200fbe840b7b404102256.1340634972.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

The “file” sysfs entry for LUNs was writable even for non-removable
LUNs and the fsg_store_file() function did not check whether LUN is
removable or not.  This made it possible to change or even close
LUN's backing file.

The same is true for “ro” sysfs entry and LUNs simulating CD-ROM.
For those LUNs, the file should not be writable.

This commit introduces two new device_attribute structures for those
two special cases so that the file/ro sysfs entries are made
non-writable when not desired.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |   26 +++++++++++++++++++++-----
 drivers/usb/gadget/storage_common.c |    1 -
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 71ce550..7cb165e 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2609,11 +2609,15 @@ static int fsg_main_thread(void *common_)
 
 /*************************** DEVICE ATTRIBUTES ***************************/
 
-/* Write permission is checked per LUN in store_*() functions. */
 static DEVICE_ATTR(ro, 0644, fsg_show_ro, fsg_store_ro);
 static DEVICE_ATTR(nofua, 0644, fsg_show_nofua, fsg_store_nofua);
 static DEVICE_ATTR(file, 0644, fsg_show_file, fsg_store_file);
 
+static struct device_attribute dev_attr_ro_cdrom =
+	__ATTR(ro, 0444, fsg_show_ro, NULL);
+static struct device_attribute dev_attr_file_nonremovable =
+	__ATTR(file, 0444, fsg_show_file, NULL);
+
 
 /****************************** FSG COMMON ******************************/
 
@@ -2724,10 +2728,16 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 			goto error_release;
 		}
 
-		rc = device_create_file(&curlun->dev, &dev_attr_ro);
+		rc = device_create_file(&curlun->dev,
+					curlun->cdrom
+				      ? &dev_attr_ro_cdrom
+				      : &dev_attr_ro);
 		if (rc)
 			goto error_luns;
-		rc = device_create_file(&curlun->dev, &dev_attr_file);
+		rc = device_create_file(&curlun->dev,
+					curlun->removable
+				      ? &dev_attr_file
+				      : &dev_attr_file_nonremovable);
 		if (rc)
 			goto error_luns;
 		rc = device_create_file(&curlun->dev, &dev_attr_nofua);
@@ -2862,8 +2872,14 @@ static void fsg_common_release(struct kref *ref)
 		/* In error recovery common->nluns may be zero. */
 		for (; i; --i, ++lun) {
 			device_remove_file(&lun->dev, &dev_attr_nofua);
-			device_remove_file(&lun->dev, &dev_attr_ro);
-			device_remove_file(&lun->dev, &dev_attr_file);
+			device_remove_file(&lun->dev,
+					   lun->cdrom
+					 ? &dev_attr_ro_cdrom
+					 : &dev_attr_ro);
+			device_remove_file(&lun->dev,
+					   lun->removable
+					 ? &dev_attr_file
+					 : &dev_attr_file_nonremovable);
 			fsg_lun_close(lun);
 			device_unregister(&lun->dev);
 		}
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index e576678..ae8b188 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -878,7 +878,6 @@ static ssize_t fsg_store_file(struct device *dev, struct device_attribute *attr,
 	if (count > 0 && buf[count-1] == '\n')
 		((char *) buf)[count-1] = 0;		/* Ugh! */
 
-
 	/* Load new medium */
 	down_write(filesem);
 	if (count > 0 && buf[0]) {
-- 
1.7.7.3

