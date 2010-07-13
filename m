Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0GMIbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 04:31:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60311 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0GMIbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 04:31:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cZncncL5boOUIg6DuIfQIZQ6wJh0NZCL/C9GjQ+jjSIpo1lU5qsMbyCiItoEDQXRDw
         lk7t5NYuaVqmDjw+HDlGb5tX2KWalkjnzOn05m8nYe3og2XaeAiDVVbFGDW76jwmmug/
         3lJYcoBGs7k7/WdiKYYWYaWaE3fic4fkV4z4s=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH] usb: gadget: storage: optional SCSI WRITE FUA bit
Date: Tue, 13 Jul 2010 11:36:49 +0300
Message-Id: <1279010209-31337-1-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MS Windows mounts removable storage in "Removal optimized mode" by
default. All the writes to the media are synchronous which is achieved
by setting FUA (Force Unit Access) bit in SCSI WRITE(10,12) commands.
This prevents I/O requests aggregation in block layer dramatically
decreasing performance.

This patch brings an option to accept or ignore mentioned bit
 a) via specifying module parameter "fua", or
 b) through sysfs entry
	/sys/devices/platform/musb_hdrc/gadget/gadget-lun-N/fua

Originally patch was written by Denis Karpov for Maemo5 platform.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/gadget/file_storage.c   |   24 ++++++++++++++++++------
 drivers/usb/gadget/storage_common.c |   26 ++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index b49d86e..ce40bfb 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -93,6 +93,8 @@
  *	removable		Default false, boolean for removable media
  *	luns=N			Default N = number of filenames, number of
  *					LUNs to support
+ *	fua=N			Default true, boolean for accepting FUA flag
+ *					in SCSI WRITE(10,12) commands
  *	stall			Default determined according to the type of
  *					USB device controller (usually true),
  *					boolean to permit the driver to halt
@@ -111,11 +113,11 @@
  *					PAGE_CACHE_SIZE)
  *
  * If CONFIG_USB_FILE_STORAGE_TEST is not set, only the "file", "ro",
- * "removable", "luns", "stall", and "cdrom" options are available; default
+ * "removable", "luns", "fua", "stall", and "cdrom" options are available; default
  * values are used for everything else.
  *
  * The pathnames of the backing files and the ro settings are available in
- * the attribute files "file" and "ro" in the lun<n> subdirectory of the
+ * the attribute files "file", "fua", and "ro" in the lun<n> subdirectory of the
  * gadget's sysfs directory.  If the "removable" option is set, writing to
  * these files will simulate ejecting/loading the medium (writing an empty
  * line means eject) and adjusting a write-enable tab.  Changes to the ro
@@ -307,6 +309,7 @@ static struct {
 
 	int		removable;
 	int		can_stall;
+	int		fua;
 	int		cdrom;
 
 	char		*transport_parm;
@@ -326,6 +329,7 @@ static struct {
 	.protocol_parm		= "SCSI",
 	.removable		= 0,
 	.can_stall		= 1,
+	.fua			= 1,
 	.cdrom			= 0,
 	.vendor			= FSG_VENDOR_ID,
 	.product		= FSG_PRODUCT_ID,
@@ -350,6 +354,9 @@ MODULE_PARM_DESC(removable, "true to simulate removable media");
 module_param_named(stall, mod_data.can_stall, bool, S_IRUGO);
 MODULE_PARM_DESC(stall, "false to prevent bulk stalls");
 
+module_param_named(fua, mod_data.fua, bool, S_IRUGO);
+MODULE_PARM_DESC(fua, "true to obey SCSI WRITE(6,10,12) FUA bit");
+
 module_param_named(cdrom, mod_data.cdrom, bool, S_IRUGO);
 MODULE_PARM_DESC(cdrom, "true to emulate cdrom instead of disk");
 
@@ -1272,7 +1279,8 @@ static int do_write(struct fsg_dev *fsg)
 			curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 			return -EINVAL;
 		}
-		if (fsg->cmnd[1] & 0x08) {	// FUA
+		/* FUA */
+		if (curlun->fua && (fsg->cmnd[1] & 0x08)) {
 			spin_lock(&curlun->filp->f_lock);
 			curlun->filp->f_flags |= O_DSYNC;
 			spin_unlock(&curlun->filp->f_lock);
@@ -3126,6 +3134,7 @@ static int fsg_main_thread(void *fsg_)
 
 /* The write permissions and store_xxx pointers are set in fsg_bind() */
 static DEVICE_ATTR(ro, 0444, fsg_show_ro, NULL);
+static DEVICE_ATTR(fua, 0644, show_fua, store_fua);
 static DEVICE_ATTR(file, 0444, fsg_show_file, NULL);
 
 
@@ -3330,6 +3339,7 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 		curlun->ro = mod_data.cdrom || mod_data.ro[i];
 		curlun->initially_ro = curlun->ro;
 		curlun->removable = mod_data.removable;
+		curlun->fua = mod_data.fua;
 		curlun->dev.release = lun_release;
 		curlun->dev.parent = &gadget->dev;
 		curlun->dev.driver = &fsg_driver.driver;
@@ -3344,7 +3354,9 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 		if ((rc = device_create_file(&curlun->dev,
 					&dev_attr_ro)) != 0 ||
 				(rc = device_create_file(&curlun->dev,
-					&dev_attr_file)) != 0) {
+					&dev_attr_file)) != 0 ||
+				(rc = device_create_file(&curlun->dev,
+					&dev_attr_fua)) != 0) {
 			device_unregister(&curlun->dev);
 			goto out;
 		}
@@ -3478,8 +3490,8 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 				if (IS_ERR(p))
 					p = NULL;
 			}
-			LINFO(curlun, "ro=%d, file: %s\n",
-					curlun->ro, (p ? p : "(error)"));
+			LINFO(curlun, "ro=%d, fua=%d file: %s\n",
+				curlun->ro, curlun->fua, (p ? p : "(error)"));
 		}
 	}
 	kfree(pathbuf);
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 04c462f..ec2ff30 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -269,6 +269,7 @@ struct fsg_lun {
 	unsigned int	prevent_medium_removal:1;
 	unsigned int	registered:1;
 	unsigned int	info_valid:1;
+	unsigned int	fua:1;
 
 	u32		sense_data;
 	u32		sense_data_info;
@@ -689,6 +690,14 @@ static ssize_t fsg_show_ro(struct device *dev, struct device_attribute *attr,
 				  : curlun->initially_ro);
 }
 
+static ssize_t show_fua(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
+
+	return sprintf(buf, "%u\n", curlun->fua);
+}
+
 static ssize_t fsg_show_file(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
@@ -743,6 +752,23 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 	return rc;
 }
 
+static ssize_t store_fua(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
+	unsigned long 	attr_val = 0;
+
+	if (strict_strtoul(buf, 2, &attr_val))
+		return -EINVAL;
+
+	if (!(curlun->fua))
+		fsg_lun_fsync_sub(curlun);
+
+	curlun->fua = attr_val ? 1 : 0;
+
+	return count;
+}
+
 static ssize_t fsg_store_file(struct device *dev, struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
-- 
1.6.3.3

