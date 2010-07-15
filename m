Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab0GOJBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 05:01:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44763 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753Ab0GOJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ItqSkoUqbRCR80nObm2XViJp87WjtKQS86b4oBe2ExVqc2aJ1VIRbImh7s0Da7qfhB
         zkS96mWJDHM6LUQb5X5ClvMqAqYXyJKPWPbDmqBJqPjlVLHC/0y9frzvbGb9G8ZmzeAr
         1yXO+wQhtLtxAr8ash5M45Wels7bjAUb1dpFQ=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCHv3 2/2] usb: gadget: storage: optional SCSI WRITE FUA bit
Date: Thu, 15 Jul 2010 12:07:21 +0300
Message-Id: <1279184841-15097-2-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1279184841-15097-1-git-send-email-ext-andriy.shevchenko@nokia.com>
References: <op.vft7mxqm7p4s8u@pikus>
 <1279184841-15097-1-git-send-email-ext-andriy.shevchenko@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MS Windows mounts removable storage in "Removal optimized mode" by
default. All the writes to the media are synchronous which is achieved
by setting FUA (Force Unit Access) bit in SCSI WRITE(10,12) commands.
This prevents I/O requests aggregation in block layer dramatically
decreasing performance.

This patch brings an option to accept or ignore mentioned bit
 a) via specifying module parameter "nofua", or
 b) through sysfs entry
	/sys/devices/platform/musb_hdrc/gadget/gadget-lun-N/nofua

Patch is based on the work that was done by Denis Karpov for Maemo 5
platform.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/gadget/file_storage.c   |   31 ++++++++++++++++++++++++-------
 drivers/usb/gadget/storage_common.c |   28 ++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index b49d86e..20bd39e 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -93,6 +93,8 @@
  *	removable		Default false, boolean for removable media
  *	luns=N			Default N = number of filenames, number of
  *					LUNs to support
+ *	nofua=b[,b...]		Default false, booleans for ignore FUA flag
+ *					in SCSI WRITE(10,12) commands
  *	stall			Default determined according to the type of
  *					USB device controller (usually true),
  *					boolean to permit the driver to halt
@@ -111,12 +113,12 @@
  *					PAGE_CACHE_SIZE)
  *
  * If CONFIG_USB_FILE_STORAGE_TEST is not set, only the "file", "ro",
- * "removable", "luns", "stall", and "cdrom" options are available; default
- * values are used for everything else.
+ * "removable", "luns", "nofua", "stall", and "cdrom" options are available;
+ * default values are used for everything else.
  *
  * The pathnames of the backing files and the ro settings are available in
- * the attribute files "file" and "ro" in the lun<n> subdirectory of the
- * gadget's sysfs directory.  If the "removable" option is set, writing to
+ * the attribute files "file", "nofua", and "ro" in the lun<n> subdirectory of
+ * the gadget's sysfs directory.  If the "removable" option is set, writing to
  * these files will simulate ejecting/loading the medium (writing an empty
  * line means eject) and adjusting a write-enable tab.  Changes to the ro
  * setting are not allowed when the medium is loaded or if CD-ROM emulation
@@ -301,8 +303,10 @@ MODULE_LICENSE("Dual BSD/GPL");
 static struct {
 	char		*file[FSG_MAX_LUNS];
 	int		ro[FSG_MAX_LUNS];
+	int		nofua[FSG_MAX_LUNS];
 	unsigned int	num_filenames;
 	unsigned int	num_ros;
+	unsigned int	num_nofuas;
 	unsigned int	nluns;
 
 	int		removable;
@@ -341,6 +345,10 @@ MODULE_PARM_DESC(file, "names of backing files or devices");
 module_param_array_named(ro, mod_data.ro, bool, &mod_data.num_ros, S_IRUGO);
 MODULE_PARM_DESC(ro, "true to force read-only");
 
+module_param_array_named(nofua, mod_data.nofua, bool, &mod_data.num_nofuas,
+		S_IRUGO);
+MODULE_PARM_DESC(nofua, "true to ignore SCSI WRITE(10,12) FUA bit");
+
 module_param_named(luns, mod_data.nluns, uint, S_IRUGO);
 MODULE_PARM_DESC(luns, "number of LUNs");
 
@@ -1272,7 +1280,8 @@ static int do_write(struct fsg_dev *fsg)
 			curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 			return -EINVAL;
 		}
-		if (fsg->cmnd[1] & 0x08) {	// FUA
+		/* FUA */
+		if (!curlun->nofua && (fsg->cmnd[1] & 0x08)) {
 			spin_lock(&curlun->filp->f_lock);
 			curlun->filp->f_flags |= O_DSYNC;
 			spin_unlock(&curlun->filp->f_lock);
@@ -3126,6 +3135,7 @@ static int fsg_main_thread(void *fsg_)
 
 /* The write permissions and store_xxx pointers are set in fsg_bind() */
 static DEVICE_ATTR(ro, 0444, fsg_show_ro, NULL);
+static DEVICE_ATTR(nofua, 0644, fsg_show_nofua, NULL);
 static DEVICE_ATTR(file, 0444, fsg_show_file, NULL);
 
 
@@ -3305,6 +3315,10 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 		}
 	}
 
+	/* Only for removable media? */
+	dev_attr_nofua.attr.mode = 0644;
+	dev_attr_nofua.store = fsg_store_nofua;
+
 	/* Find out how many LUNs there should be */
 	i = mod_data.nluns;
 	if (i == 0)
@@ -3330,6 +3344,7 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 		curlun->ro = mod_data.cdrom || mod_data.ro[i];
 		curlun->initially_ro = curlun->ro;
 		curlun->removable = mod_data.removable;
+		curlun->nofua = mod_data.nofua[i];
 		curlun->dev.release = lun_release;
 		curlun->dev.parent = &gadget->dev;
 		curlun->dev.driver = &fsg_driver.driver;
@@ -3344,6 +3359,8 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 		if ((rc = device_create_file(&curlun->dev,
 					&dev_attr_ro)) != 0 ||
 				(rc = device_create_file(&curlun->dev,
+					&dev_attr_nofua)) != 0 ||
+				(rc = device_create_file(&curlun->dev,
 					&dev_attr_file)) != 0) {
 			device_unregister(&curlun->dev);
 			goto out;
@@ -3478,8 +3495,8 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 				if (IS_ERR(p))
 					p = NULL;
 			}
-			LINFO(curlun, "ro=%d, file: %s\n",
-					curlun->ro, (p ? p : "(error)"));
+			LINFO(curlun, "ro=%d, nofua=%d, file: %s\n",
+			      curlun->ro, curlun->nofua, (p ? p : "(error)"));
 		}
 	}
 	kfree(pathbuf);
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 7123929..d631b27 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -269,6 +269,7 @@ struct fsg_lun {
 	unsigned int	prevent_medium_removal:1;
 	unsigned int	registered:1;
 	unsigned int	info_valid:1;
+	unsigned int	nofua:1;
 
 	u32		sense_data;
 	u32		sense_data_info;
@@ -689,6 +690,14 @@ static ssize_t fsg_show_ro(struct device *dev, struct device_attribute *attr,
 				  : curlun->initially_ro);
 }
 
+static ssize_t fsg_show_nofua(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
+
+	return sprintf(buf, "%u\n", curlun->nofua);
+}
+
 static ssize_t fsg_show_file(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
@@ -743,6 +752,25 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 	return rc;
 }
 
+static ssize_t fsg_store_nofua(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
+	unsigned long	nofua;
+
+	if (strict_strtoul(buf, 2, &nofua))
+		return -EINVAL;
+
+	/* Sync data when switching from async mode to sync */
+	if (!nofua && curlun->nofua)
+		fsg_lun_fsync_sub(curlun);
+
+	curlun->nofua = nofua;
+
+	return count;
+}
+
 static ssize_t fsg_store_file(struct device *dev, struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
-- 
1.6.3.3

