Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0GNJAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:00:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54806 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab0GNJAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=df6CVSSG5cB+4VI0ETiIqrJ5oPNA+eG+oSL+ictTpfvn2HKAG4I/+wkcKTUcY4EIVw
         yVLSyAYJU1NTBewZgIpT/ImlnHJ4l+71kN1Xvq4I/ynTkfH871gcwVghEP3FF/U4kMMi
         8LB1og9gW5Gp0V7l708FQ99v8e4dIsMkxyVmI=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCHv2] usb: gadget: storage: optional SCSI WRITE FUA bit
Date: Wed, 14 Jul 2010 12:05:31 +0300
Message-Id: <1279098331-7872-1-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <Pine.LNX.4.44L0.1007131003560.1568-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1007131003560.1568-100000@iolanthe.rowland.org>
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

Patch is based on work done by Denis Karpov for Maemo5 platform.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/gadget/file_storage.c   |   30 +++++++++++++++++++++++-------
 drivers/usb/gadget/storage_common.c |   27 +++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index b49d86e..45f58d9 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -93,6 +93,8 @@
  *	removable		Default false, boolean for removable media
  *	luns=N			Default N = number of filenames, number of
  *					LUNs to support
+ *	fua=b[,b...]		Default false, booleans for ignore FUA flag
+ *					in SCSI WRITE(6,10,12) commands
  *	stall			Default determined according to the type of
  *					USB device controller (usually true),
  *					boolean to permit the driver to halt
@@ -111,12 +113,12 @@
  *					PAGE_CACHE_SIZE)
  *
  * If CONFIG_USB_FILE_STORAGE_TEST is not set, only the "file", "ro",
- * "removable", "luns", "stall", and "cdrom" options are available; default
- * values are used for everything else.
+ * "removable", "luns", "fua", "stall", and "cdrom" options are available;
+ * default values are used for everything else.
  *
  * The pathnames of the backing files and the ro settings are available in
- * the attribute files "file" and "ro" in the lun<n> subdirectory of the
- * gadget's sysfs directory.  If the "removable" option is set, writing to
+ * the attribute files "file", "fua", and "ro" in the lun<n> subdirectory of
+ * the gadget's sysfs directory.  If the "removable" option is set, writing to
  * these files will simulate ejecting/loading the medium (writing an empty
  * line means eject) and adjusting a write-enable tab.  Changes to the ro
  * setting are not allowed when the medium is loaded or if CD-ROM emulation
@@ -301,8 +303,10 @@ MODULE_LICENSE("Dual BSD/GPL");
 static struct {
 	char		*file[FSG_MAX_LUNS];
 	int		ro[FSG_MAX_LUNS];
+	int		fua[FSG_MAX_LUNS];
 	unsigned int	num_filenames;
 	unsigned int	num_ros;
+	unsigned int	num_fuas;
 	unsigned int	nluns;
 
 	int		removable;
@@ -341,6 +345,9 @@ MODULE_PARM_DESC(file, "names of backing files or devices");
 module_param_array_named(ro, mod_data.ro, bool, &mod_data.num_ros, S_IRUGO);
 MODULE_PARM_DESC(ro, "true to force read-only");
 
+module_param_array_named(fua, mod_data.fua, bool, &mod_data.num_fuas, S_IRUGO);
+MODULE_PARM_DESC(fua, "true to ignore SCSI WRITE(6,10,12) FUA bit");
+
 module_param_named(luns, mod_data.nluns, uint, S_IRUGO);
 MODULE_PARM_DESC(luns, "number of LUNs");
 
@@ -1272,7 +1279,8 @@ static int do_write(struct fsg_dev *fsg)
 			curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 			return -EINVAL;
 		}
-		if (fsg->cmnd[1] & 0x08) {	// FUA
+		/* FUA */
+		if (!curlun->fua && (fsg->cmnd[1] & 0x08)) {
 			spin_lock(&curlun->filp->f_lock);
 			curlun->filp->f_flags |= O_DSYNC;
 			spin_unlock(&curlun->filp->f_lock);
@@ -3126,6 +3134,7 @@ static int fsg_main_thread(void *fsg_)
 
 /* The write permissions and store_xxx pointers are set in fsg_bind() */
 static DEVICE_ATTR(ro, 0444, fsg_show_ro, NULL);
+static DEVICE_ATTR(fua, 0644, fsg_show_fua, NULL);
 static DEVICE_ATTR(file, 0444, fsg_show_file, NULL);
 
 
@@ -3305,6 +3314,10 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 		}
 	}
 
+	/* Only for removable media? */
+	dev_attr_fua.attr.mode = 0644;
+	dev_attr_fua.store = fsg_store_fua;
+
 	/* Find out how many LUNs there should be */
 	i = mod_data.nluns;
 	if (i == 0)
@@ -3330,6 +3343,7 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 		curlun->ro = mod_data.cdrom || mod_data.ro[i];
 		curlun->initially_ro = curlun->ro;
 		curlun->removable = mod_data.removable;
+		curlun->fua = mod_data.fua[i];
 		curlun->dev.release = lun_release;
 		curlun->dev.parent = &gadget->dev;
 		curlun->dev.driver = &fsg_driver.driver;
@@ -3344,6 +3358,8 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 		if ((rc = device_create_file(&curlun->dev,
 					&dev_attr_ro)) != 0 ||
 				(rc = device_create_file(&curlun->dev,
+					&dev_attr_fua)) != 0 ||
+				(rc = device_create_file(&curlun->dev,
 					&dev_attr_file)) != 0) {
 			device_unregister(&curlun->dev);
 			goto out;
@@ -3478,8 +3494,8 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 				if (IS_ERR(p))
 					p = NULL;
 			}
-			LINFO(curlun, "ro=%d, file: %s\n",
-					curlun->ro, (p ? p : "(error)"));
+			LINFO(curlun, "ro=%d, fua=%d, file: %s\n",
+				curlun->ro, curlun->fua, (p ? p : "(error)"));
 		}
 	}
 	kfree(pathbuf);
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 04c462f..80c93d7 100644
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
 
+static ssize_t fsg_show_fua(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
+
+	return sprintf(buf, "%u\n", curlun->fua);
+}
+
 static ssize_t fsg_show_file(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
@@ -743,6 +752,24 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 	return rc;
 }
 
+static ssize_t fsg_store_fua(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	ssize_t		rc = count;
+	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
+	int		i;
+
+	if (sscanf(buf, "%d", &i) != 1)
+		return -EINVAL;
+
+	if (curlun->fua)
+		fsg_lun_fsync_sub(curlun);
+
+	curlun->fua = !!i;
+
+	return rc;
+}
+
 static ssize_t fsg_store_file(struct device *dev, struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
-- 
1.6.3.3

