Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2FHAFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:05:39 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:14207 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab2FHAFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:05:37 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-127.messagelabs.com!1339113936!7812170!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor comedi_fops to remove most of the forward declarations
Date: Thu, 7 Jun 2012 17:05:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206071705.27596.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the comedi_unlocked_ioctl function in order to remove most of
the forward declarations in this file.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

There are still a couple forward declarations left but fixing them
in this patch makes it a bit hard to review.

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 7677657..5dba7ec 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -92,36 +92,6 @@ static DEFINE_SPINLOCK(comedi_file_info_table_lock);
 static struct comedi_device_file_info
 *comedi_file_info_table[COMEDI_NUM_MINORS];
 
-static int do_devconfig_ioctl(struct comedi_device *dev,
-			      struct comedi_devconfig __user *arg);
-static int do_bufconfig_ioctl(struct comedi_device *dev,
-			      struct comedi_bufconfig __user *arg);
-static int do_devinfo_ioctl(struct comedi_device *dev,
-			    struct comedi_devinfo __user *arg,
-			    struct file *file);
-static int do_subdinfo_ioctl(struct comedi_device *dev,
-			     struct comedi_subdinfo __user *arg, void *file);
-static int do_chaninfo_ioctl(struct comedi_device *dev,
-			     struct comedi_chaninfo __user *arg);
-static int do_bufinfo_ioctl(struct comedi_device *dev,
-			    struct comedi_bufinfo __user *arg, void *file);
-static int do_cmd_ioctl(struct comedi_device *dev,
-			struct comedi_cmd __user *arg, void *file);
-static int do_lock_ioctl(struct comedi_device *dev, unsigned int arg,
-			 void *file);
-static int do_unlock_ioctl(struct comedi_device *dev, unsigned int arg,
-			   void *file);
-static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
-			   void *file);
-static int do_cmdtest_ioctl(struct comedi_device *dev,
-			    struct comedi_cmd __user *arg, void *file);
-static int do_insnlist_ioctl(struct comedi_device *dev,
-			     struct comedi_insnlist __user *arg, void *file);
-static int do_insn_ioctl(struct comedi_device *dev,
-			 struct comedi_insn __user *arg, void *file);
-static int do_poll_ioctl(struct comedi_device *dev, unsigned int subd,
-			 void *file);
-
 static void do_become_nonbusy(struct comedi_device *dev,
 			      struct comedi_subdevice *s);
 static int do_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
@@ -407,98 +377,6 @@ static struct device_attribute comedi_dev_attrs[] = {
 	__ATTR_NULL
 };
 
-static long comedi_unlocked_ioctl(struct file *file, unsigned int cmd,
-				  unsigned long arg)
-{
-	const unsigned minor = iminor(file->f_dentry->d_inode);
-	struct comedi_device_file_info *dev_file_info =
-	    comedi_get_device_file_info(minor);
-	struct comedi_device *dev;
-	int rc;
-
-	if (dev_file_info == NULL || dev_file_info->device == NULL)
-		return -ENODEV;
-	dev = dev_file_info->device;
-
-	mutex_lock(&dev->mutex);
-
-	/* Device config is special, because it must work on
-	 * an unconfigured device. */
-	if (cmd == COMEDI_DEVCONFIG) {
-		rc = do_devconfig_ioctl(dev,
-					(struct comedi_devconfig __user *)arg);
-		goto done;
-	}
-
-	if (!dev->attached) {
-		DPRINTK("no driver configured on /dev/comedi%i\n", dev->minor);
-		rc = -ENODEV;
-		goto done;
-	}
-
-	switch (cmd) {
-	case COMEDI_BUFCONFIG:
-		rc = do_bufconfig_ioctl(dev,
-					(struct comedi_bufconfig __user *)arg);
-		break;
-	case COMEDI_DEVINFO:
-		rc = do_devinfo_ioctl(dev, (struct comedi_devinfo __user *)arg,
-				      file);
-		break;
-	case COMEDI_SUBDINFO:
-		rc = do_subdinfo_ioctl(dev,
-				       (struct comedi_subdinfo __user *)arg,
-				       file);
-		break;
-	case COMEDI_CHANINFO:
-		rc = do_chaninfo_ioctl(dev, (void __user *)arg);
-		break;
-	case COMEDI_RANGEINFO:
-		rc = do_rangeinfo_ioctl(dev, (void __user *)arg);
-		break;
-	case COMEDI_BUFINFO:
-		rc = do_bufinfo_ioctl(dev,
-				      (struct comedi_bufinfo __user *)arg,
-				      file);
-		break;
-	case COMEDI_LOCK:
-		rc = do_lock_ioctl(dev, arg, file);
-		break;
-	case COMEDI_UNLOCK:
-		rc = do_unlock_ioctl(dev, arg, file);
-		break;
-	case COMEDI_CANCEL:
-		rc = do_cancel_ioctl(dev, arg, file);
-		break;
-	case COMEDI_CMD:
-		rc = do_cmd_ioctl(dev, (struct comedi_cmd __user *)arg, file);
-		break;
-	case COMEDI_CMDTEST:
-		rc = do_cmdtest_ioctl(dev, (struct comedi_cmd __user *)arg,
-				      file);
-		break;
-	case COMEDI_INSNLIST:
-		rc = do_insnlist_ioctl(dev,
-				       (struct comedi_insnlist __user *)arg,
-				       file);
-		break;
-	case COMEDI_INSN:
-		rc = do_insn_ioctl(dev, (struct comedi_insn __user *)arg,
-				   file);
-		break;
-	case COMEDI_POLL:
-		rc = do_poll_ioctl(dev, arg, file);
-		break;
-	default:
-		rc = -ENOTTY;
-		break;
-	}
-
-done:
-	mutex_unlock(&dev->mutex);
-	return rc;
-}
-
 /*
 	COMEDI_DEVCONFIG
 	device config ioctl
@@ -1709,6 +1587,98 @@ static int do_poll_ioctl(struct comedi_device *dev, unsigned int arg,
 	return -EINVAL;
 }
 
+static long comedi_unlocked_ioctl(struct file *file, unsigned int cmd,
+				  unsigned long arg)
+{
+	const unsigned minor = iminor(file->f_dentry->d_inode);
+	struct comedi_device_file_info *dev_file_info =
+	    comedi_get_device_file_info(minor);
+	struct comedi_device *dev;
+	int rc;
+
+	if (dev_file_info == NULL || dev_file_info->device == NULL)
+		return -ENODEV;
+	dev = dev_file_info->device;
+
+	mutex_lock(&dev->mutex);
+
+	/* Device config is special, because it must work on
+	 * an unconfigured device. */
+	if (cmd == COMEDI_DEVCONFIG) {
+		rc = do_devconfig_ioctl(dev,
+					(struct comedi_devconfig __user *)arg);
+		goto done;
+	}
+
+	if (!dev->attached) {
+		DPRINTK("no driver configured on /dev/comedi%i\n", dev->minor);
+		rc = -ENODEV;
+		goto done;
+	}
+
+	switch (cmd) {
+	case COMEDI_BUFCONFIG:
+		rc = do_bufconfig_ioctl(dev,
+					(struct comedi_bufconfig __user *)arg);
+		break;
+	case COMEDI_DEVINFO:
+		rc = do_devinfo_ioctl(dev, (struct comedi_devinfo __user *)arg,
+				      file);
+		break;
+	case COMEDI_SUBDINFO:
+		rc = do_subdinfo_ioctl(dev,
+				       (struct comedi_subdinfo __user *)arg,
+				       file);
+		break;
+	case COMEDI_CHANINFO:
+		rc = do_chaninfo_ioctl(dev, (void __user *)arg);
+		break;
+	case COMEDI_RANGEINFO:
+		rc = do_rangeinfo_ioctl(dev, (void __user *)arg);
+		break;
+	case COMEDI_BUFINFO:
+		rc = do_bufinfo_ioctl(dev,
+				      (struct comedi_bufinfo __user *)arg,
+				      file);
+		break;
+	case COMEDI_LOCK:
+		rc = do_lock_ioctl(dev, arg, file);
+		break;
+	case COMEDI_UNLOCK:
+		rc = do_unlock_ioctl(dev, arg, file);
+		break;
+	case COMEDI_CANCEL:
+		rc = do_cancel_ioctl(dev, arg, file);
+		break;
+	case COMEDI_CMD:
+		rc = do_cmd_ioctl(dev, (struct comedi_cmd __user *)arg, file);
+		break;
+	case COMEDI_CMDTEST:
+		rc = do_cmdtest_ioctl(dev, (struct comedi_cmd __user *)arg,
+				      file);
+		break;
+	case COMEDI_INSNLIST:
+		rc = do_insnlist_ioctl(dev,
+				       (struct comedi_insnlist __user *)arg,
+				       file);
+		break;
+	case COMEDI_INSN:
+		rc = do_insn_ioctl(dev, (struct comedi_insn __user *)arg,
+				   file);
+		break;
+	case COMEDI_POLL:
+		rc = do_poll_ioctl(dev, arg, file);
+		break;
+	default:
+		rc = -ENOTTY;
+		break;
+	}
+
+done:
+	mutex_unlock(&dev->mutex);
+	return rc;
+}
+
 static int do_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	int ret = 0;
