Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0LFOr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:47:26 -0500
Received: from 93.100.122.208.pool.sknt.ru ([93.100.122.208]:34329 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751821Ab0LFOrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:47:24 -0500
Date: Mon, 6 Dec 2010 17:51:41 +0300
From: Valentine Barshak <vbarshak@mvista.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] USB: HID: Fix race between disconnect and hiddev_ioctl
Message-ID: <20101206145141.GA8462@mvista.com>
Reply-To: Valentine Barshak <vbarshak@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101206144519.GA8438@mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A USB HID device can be disconnected at any time.
If this happens right before or while hiddev_ioctl is in progress,
the hiddev_ioctl tries to access invalid hiddev->hid pointer.
When the hid device is disconnected, the hiddev_disconnect()
ends up with a call to hid_device_release() which frees
hid_device, but doesn't set the hiddev->hid pointer to NULL.
If the deallocated memory region has been re-used by the kernel,
this can cause a crash or memory corruption.

Since disconnect can happen at any time, we can't initialize
struct hid_device *hid = hiddev->hid at the beginning of ioctl
and then use it.

This change checks hiddev->exist flag while holding
the existancelock and uses hid_device only if it exists.

Signed-off-by: Valentine Barshak <vbarshak@mvista.com>
---
 drivers/hid/usbhid/hiddev.c |  168 +++++++++++++++++++++++++++++++++----------
 1 files changed, 131 insertions(+), 37 deletions(-)

diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 984feb3..cbb6974 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -585,7 +585,7 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct hiddev_list *list = file->private_data;
 	struct hiddev *hiddev = list->hiddev;
-	struct hid_device *hid = hiddev->hid;
+	struct hid_device *hid;
 	struct usb_device *dev;
 	struct hiddev_collection_info cinfo;
 	struct hiddev_report_info rinfo;
@@ -593,26 +593,33 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct hiddev_devinfo dinfo;
 	struct hid_report *report;
 	struct hid_field *field;
-	struct usbhid_device *usbhid = hid->driver_data;
+	struct usbhid_device *usbhid;
 	void __user *user_arg = (void __user *)arg;
 	int i, r;
-	
+
 	/* Called without BKL by compat methods so no BKL taken */
 
 	/* FIXME: Who or what stop this racing with a disconnect ?? */
-	if (!hiddev->exist || !hid)
+	if (!hiddev->exist)
 		return -EIO;
 
-	dev = hid_to_usb_dev(hid);
-
 	switch (cmd) {
 
 	case HIDIOCGVERSION:
 		return put_user(HID_VERSION, (int __user *)arg);
 
 	case HIDIOCAPPLICATION:
-		if (arg < 0 || arg >= hid->maxapplication)
-			return -EINVAL;
+		mutex_lock(&hiddev->existancelock);
+		if (!hiddev->exist) {
+			r = -ENODEV;
+			goto ret_unlock;
+		}
+
+		hid = hiddev->hid;
+		if (arg < 0 || arg >= hid->maxapplication) {
+			r = -EINVAL;
+			goto ret_unlock;
+		}
 
 		for (i = 0; i < hid->maxcollection; i++)
 			if (hid->collection[i].type ==
@@ -620,11 +627,22 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				break;
 
 		if (i == hid->maxcollection)
-			return -EINVAL;
-
-		return hid->collection[i].usage;
+			r = -EINVAL;
+		else
+			r = hid->collection[i].usage;
+		goto ret_unlock;
 
 	case HIDIOCGDEVINFO:
+		mutex_lock(&hiddev->existancelock);
+		if (!hiddev->exist) {
+			r = -ENODEV;
+			goto ret_unlock;
+		}
+
+		hid = hiddev->hid;
+		dev = hid_to_usb_dev(hid);
+		usbhid = hid->driver_data;
+
 		dinfo.bustype = BUS_USB;
 		dinfo.busnum = dev->bus->busnum;
 		dinfo.devnum = dev->devnum;
@@ -633,6 +651,8 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		dinfo.product = le16_to_cpu(dev->descriptor.idProduct);
 		dinfo.version = le16_to_cpu(dev->descriptor.bcdDevice);
 		dinfo.num_applications = hid->maxapplication;
+		mutex_unlock(&hiddev->existancelock);
+
 		if (copy_to_user(user_arg, &dinfo, sizeof(dinfo)))
 			return -EFAULT;
 
@@ -666,6 +686,7 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			r = hiddev_ioctl_string(hiddev, cmd, user_arg);
 		else
 			r = -ENODEV;
+ret_unlock:
 		mutex_unlock(&hiddev->existancelock);
 		return r;
 
@@ -675,6 +696,7 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			mutex_unlock(&hiddev->existancelock);
 			return -ENODEV;
 		}
+		hid = hiddev->hid;
 		usbhid_init_reports(hid);
 		mutex_unlock(&hiddev->existancelock);
 
@@ -687,14 +709,21 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (rinfo.report_type == HID_REPORT_TYPE_OUTPUT)
 			return -EINVAL;
 
-		if ((report = hiddev_lookup_report(hid, &rinfo)) == NULL)
-			return -EINVAL;
-
 		mutex_lock(&hiddev->existancelock);
-		if (hiddev->exist) {
-			usbhid_submit_report(hid, report, USB_DIR_IN);
-			usbhid_wait_io(hid);
+		if (!hiddev->exist) {
+			r = -ENODEV;
+			goto ret_unlock;
+		}
+
+		hid = hiddev->hid;
+		report = hiddev_lookup_report(hid, &rinfo);
+		if (report == NULL) {
+			r = -EINVAL;
+			goto ret_unlock;
 		}
+
+		usbhid_submit_report(hid, report, USB_DIR_IN);
+		usbhid_wait_io(hid);
 		mutex_unlock(&hiddev->existancelock);
 
 		return 0;
@@ -706,14 +735,21 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (rinfo.report_type == HID_REPORT_TYPE_INPUT)
 			return -EINVAL;
 
-		if ((report = hiddev_lookup_report(hid, &rinfo)) == NULL)
-			return -EINVAL;
-
 		mutex_lock(&hiddev->existancelock);
-		if (hiddev->exist) {
-			usbhid_submit_report(hid, report, USB_DIR_OUT);
-			usbhid_wait_io(hid);
+		if (!hiddev->exist) {
+			r = -ENODEV;
+			goto ret_unlock;
+		}
+
+		hid = hiddev->hid;
+		report = hiddev_lookup_report(hid, &rinfo);
+		if (report == NULL) {
+			r = -EINVAL;
+			goto ret_unlock;
 		}
+
+		usbhid_submit_report(hid, report, USB_DIR_OUT);
+		usbhid_wait_io(hid);
 		mutex_unlock(&hiddev->existancelock);
 
 		return 0;
@@ -722,10 +758,21 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&rinfo, user_arg, sizeof(rinfo)))
 			return -EFAULT;
 
-		if ((report = hiddev_lookup_report(hid, &rinfo)) == NULL)
-			return -EINVAL;
+		mutex_lock(&hiddev->existancelock);
+		if (!hiddev->exist) {
+			r = -ENODEV;
+			goto ret_unlock;
+		}
+
+		hid = hiddev->hid;
+		report = hiddev_lookup_report(hid, &rinfo);
+		if (report == NULL) {
+			r = -EINVAL;
+			goto ret_unlock;
+		}
 
 		rinfo.num_fields = report->maxfield;
+		mutex_unlock(&hiddev->existancelock);
 
 		if (copy_to_user(user_arg, &rinfo, sizeof(rinfo)))
 			return -EFAULT;
@@ -737,11 +784,23 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 		rinfo.report_type = finfo.report_type;
 		rinfo.report_id = finfo.report_id;
-		if ((report = hiddev_lookup_report(hid, &rinfo)) == NULL)
-			return -EINVAL;
+		mutex_lock(&hiddev->existancelock);
+		if (!hiddev->exist) {
+			r = -ENODEV;
+			goto ret_unlock;
+		}
 
-		if (finfo.field_index >= report->maxfield)
-			return -EINVAL;
+		hid = hiddev->hid;
+		report = hiddev_lookup_report(hid, &rinfo);
+		if (report == NULL) {
+			r = -EINVAL;
+			goto ret_unlock;
+		}
+
+		if (finfo.field_index >= report->maxfield) {
+			r = -EINVAL;
+			goto ret_unlock;
+		}
 
 		field = report->field[finfo.field_index];
 		memset(&finfo, 0, sizeof(finfo));
@@ -759,6 +818,7 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		finfo.physical_maximum = field->physical_maximum;
 		finfo.unit_exponent = field->unit_exponent;
 		finfo.unit = field->unit;
+		mutex_unlock(&hiddev->existancelock);
 
 		if (copy_to_user(user_arg, &finfo, sizeof(finfo)))
 			return -EFAULT;
@@ -784,12 +844,22 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&cinfo, user_arg, sizeof(cinfo)))
 			return -EFAULT;
 
-		if (cinfo.index >= hid->maxcollection)
-			return -EINVAL;
+		mutex_lock(&hiddev->existancelock);
+		if (!hiddev->exist) {
+			r = -ENODEV;
+			goto ret_unlock;
+		}
+
+		hid = hiddev->hid;
+		if (cinfo.index >= hid->maxcollection) {
+			r = -EINVAL;
+			goto ret_unlock;
+		}
 
 		cinfo.type = hid->collection[cinfo.index].type;
 		cinfo.usage = hid->collection[cinfo.index].usage;
 		cinfo.level = hid->collection[cinfo.index].level;
+		mutex_lock(&hiddev->existancelock);
 
 		if (copy_to_user(user_arg, &cinfo, sizeof(cinfo)))
 			return -EFAULT;
@@ -802,24 +872,48 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		if (_IOC_NR(cmd) == _IOC_NR(HIDIOCGNAME(0))) {
 			int len;
-			if (!hid->name)
-				return 0;
+
+			mutex_lock(&hiddev->existancelock);
+			if (!hiddev->exist) {
+				r = -ENODEV;
+				goto ret_unlock;
+			}
+
+			hid = hiddev->hid;
+			if (!hid->name) {
+				r = 0;
+				goto ret_unlock;
+			}
+
 			len = strlen(hid->name) + 1;
 			if (len > _IOC_SIZE(cmd))
 				 len = _IOC_SIZE(cmd);
-			return copy_to_user(user_arg, hid->name, len) ?
+			r = copy_to_user(user_arg, hid->name, len) ?
 				-EFAULT : len;
+			goto ret_unlock;
 		}
 
 		if (_IOC_NR(cmd) == _IOC_NR(HIDIOCGPHYS(0))) {
 			int len;
-			if (!hid->phys)
-				return 0;
+
+			mutex_lock(&hiddev->existancelock);
+			if (!hiddev->exist) {
+				r = -ENODEV;
+				goto ret_unlock;
+			}
+
+			hid = hiddev->hid;
+			if (!hid->phys) {
+				r = 0;
+				goto ret_unlock;
+			}
+
 			len = strlen(hid->phys) + 1;
 			if (len > _IOC_SIZE(cmd))
 				len = _IOC_SIZE(cmd);
-			return copy_to_user(user_arg, hid->phys, len) ?
+			r = copy_to_user(user_arg, hid->phys, len) ?
 				-EFAULT : len;
+			goto ret_unlock;
 		}
 	}
 	return -EINVAL;
-- 
1.6.0.6

