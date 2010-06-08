Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0FHDwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:52:08 -0400
Received: from core.signal11.us ([64.251.29.136]:54653 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab0FHDwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:52:01 -0400
From: Alan Ott <alan@signal11.us>
To: Jiri Kosina <jkosina@suse.cz>, Antonio Ospite <ospite@studenti.unina.it>,
       Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH] HID: Add Support for Setting and Getting Feature Reports from hidraw
Date: Mon,  7 Jun 2010 23:51:48 -0400
Message-Id: <1275969108-14948-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Jun  7 23:52:00 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c0dbe60106864653919747
X-DSPAM-Factors: 27,
	Received*26+177, 0.01000,
	or, 0.01000,
	or, 0.01000,
	of, 0.01000,
	of, 0.01000,
	Received*ESMTP, 0.01000,
	Received*(c+76, 0.01000,
	Received*242.hsd1.fl.comcast.net+[76.26.177.242]), 0.01000,
	From*<alan, 0.01000,
	Subject*for, 0.01000,
	Received*core.signal11.us, 0.01000,
	Date*2010, 0.01000,
	Ott, 0.01000,
	Alan+Ott, 0.01000,
	From*Ott, 0.01000,
	Received*with, 0.01000,
	be, 0.01000,
	be, 0.01000,
	Received*id, 0.01000,
	Alan, 0.01000,
	Alan, 0.01000,
	Received*ESMTP+id, 0.01000,
	to+the, 0.01000,
	<alan, 0.01000,
	Received*76, 0.01000,
	Received*2010, 0.01000,
	From*Alan, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per the HID Specification, Feature reports must be sent and received on
the Configuration endpoint (EP 0) through the Set_Report/Get_Report
interfaces.  This patch adds two ioctls to hidraw to set and get feature
reports to and from the device.  Modifications were made to hidraw and
usbhid.

New hidraw ioctls:
  HIDIOCSFEATURE - Perform a Set_Report transfer of a Feature report.
  HIDIOCGFEATURE - Perform a Get_Report transfer of a Feature report.

Signed-off-by: Alan Ott <alan@signal11.us>
---
Instead of creating a new function to handle Set_Report(Feature) requests,
and to promote a bit of re-use, I re-named hidraw_write() to
hidraw_send_report() and made hidraw_write() call hidraw_send_report().
hidraw_send_report() takes one additional parameter, allowing it to handle
OUTPUT and FEATURE reports. Since hidraw_send_report() is called from both
hidraw_write() and from hidraw_ioctl(), the locking of minors_mutex had to
be moved outside of hidraw_send_report() into hidraw_write(), because
hidraw_send_report() locks minors_mutex.

To implement the Get_Report(Feature) request (ioctl HIDIOCGFEATURE), I made
a new function in usbhid/hid-core.c (usbhid_get_raw_report()) to
perform the transfer. To make it available to hidraw, I added an additional
function pointer into include/linux/hid.h, similar to the existing
hid_output_raw_report() pointer.

The steps I used to create this patch are as follows:
1. In hidraw.c Rename the current hidraw_write() function to
hidraw_send_report(), and add report_type parameter to it.

2. Change the call to hid->hid_output_raw_report() to use the new passed-in
report_type parameter.

3. Create a new hidraw_write() which calls hidraw_send_report() with the
minors_mutex held.

4. Remove the minors_mutex locking from hidraw_send_report() because it will
now be called from hidraw_write() and from hidraw_ioctl(). Locking must be
done outside it now (the reason for step 3).

5. Create a hidraw_get_report() function which is similar to
hidraw_set_report() except that it calls hid->hid_get_raw_report() instead
of hid->hid_output_raw_report().

6. Modify hidraw_ioctl() to accept read/write string arguments (remove the
check for _IOC_DIR(cmd) being _IOC_READ).

7. Add the two new ioctls, HIDIOCSFEATURE(len) and HIDIOCGFEATURE(len) which
make calls to hidraw_send_report() and hidraw_get_report(), respectively.

8. In usbhid/hid-core.c, create a new function usb_hid_get_raw_report()
which calls usb_control_msg with a GET_REPORT command.

9. Modify usbhid_output_raw_report() to NOT use the interrupt OUT endpoint
for Feature Reports (as dictated by the USB HID standard).

10. Create a new pointer in hid.h suitable for handling our new
*_get_raw_report() function.

11. Back in usbhid/hid-core.c, set the pointer to hid_get_raw_report to
usbhid_get_raw_report().

12. In include/linux/hidraw.h, add the two new ioctls for our Set and Get
Feature Reports.

Alan.

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 3ccd478..f611300 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -103,14 +103,14 @@ out:
 }
 
 /* the first byte is expected to be a report number */
-static ssize_t hidraw_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
+/* This function is to be called with the minors_lock mutex held */
+static ssize_t hidraw_send_report(struct file *file, const char __user *buffer, size_t count, unsigned char report_type)
 {
 	unsigned int minor = iminor(file->f_path.dentry->d_inode);
 	struct hid_device *dev;
 	__u8 *buf;
 	int ret = 0;
 
-	mutex_lock(&minors_lock);
 	dev = hidraw_table[minor]->hid;
 
 	if (!dev->hid_output_raw_report) {
@@ -143,14 +143,93 @@ static ssize_t hidraw_write(struct file *file, const char __user *buffer, size_t
 		goto out_free;
 	}
 
-	ret = dev->hid_output_raw_report(dev, buf, count, HID_OUTPUT_REPORT);
+	ret = dev->hid_output_raw_report(dev, buf, count, report_type);
 out_free:
 	kfree(buf);
 out:
+	return ret;
+}
+
+/* the first byte is expected to be a report number */
+static ssize_t hidraw_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
+{
+	ssize_t ret;
+	mutex_lock(&minors_lock);
+	ret = hidraw_send_report(file, buffer, count, HID_OUTPUT_REPORT);
 	mutex_unlock(&minors_lock);
 	return ret;
 }
 
+
+/* This function performs a Get_Report transfer over the control endpoint
+   per section 7.2.1 of the HID specification, version 1.1.  The first byte
+   of buffer is the report number to request, or 0x0 if the defice does not
+   use numbered reports. The report_type parameter can be HID_FEATURE_REPORT
+   or HID_INPUT_REPORT.  This function is to be called with the minors_lock
+   mutex held.  */
+static ssize_t hidraw_get_report(struct file *file, char __user *buffer, size_t count, unsigned char report_type)
+{
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
+	struct hid_device *dev;
+	__u8 *buf;
+	int ret = 0, len;
+	unsigned char report_number;
+
+	dev = hidraw_table[minor]->hid;
+
+	if (!dev->hid_get_raw_report) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (count > HID_MAX_BUFFER_SIZE) {
+		printk(KERN_WARNING "hidraw: pid %d passed too large report\n",
+				task_pid_nr(current));
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (count < 2) {
+		printk(KERN_WARNING "hidraw: pid %d passed too short report\n",
+				task_pid_nr(current));
+		ret = -EINVAL;
+		goto out;
+	}
+	
+	buf = kmalloc(count * sizeof(__u8), GFP_KERNEL);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	
+	/* Read the first byte from the user. This is the report number,
+	   which is passed to dev->hid_get_raw_report(). */
+	if (copy_from_user(&report_number, buffer, 1)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+	
+	ret = dev->hid_get_raw_report(dev, report_number, buf, count, report_type);
+	
+	if (ret < 0) {
+		goto out_free;
+	}
+	
+	len = (ret < count)? ret: count;
+	
+	if (copy_to_user(buffer, buf, len)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+	
+	ret = len;
+	
+out_free:
+	kfree(buf);
+out:
+	return ret;
+}
+
 static unsigned int hidraw_poll(struct file *file, poll_table *wait)
 {
 	struct hidraw_list *list = file->private_data;
@@ -283,7 +362,24 @@ static long hidraw_ioctl(struct file *file, unsigned int cmd,
 		default:
 			{
 				struct hid_device *hid = dev->hid;
-				if (_IOC_TYPE(cmd) != 'H' || _IOC_DIR(cmd) != _IOC_READ) {
+				if (_IOC_TYPE(cmd) != 'H') {
+					ret = -EINVAL;
+					break;
+				}
+
+				if (_IOC_NR(cmd) == _IOC_NR(HIDIOCSFEATURE(0))) {
+					int len = _IOC_SIZE(cmd);
+					ret = hidraw_send_report(file, user_arg, len, HID_FEATURE_REPORT);
+					break;
+				}
+				if (_IOC_NR(cmd) == _IOC_NR(HIDIOCGFEATURE(0))) {
+					int len = _IOC_SIZE(cmd);
+					ret = hidraw_get_report(file, user_arg, len, HID_FEATURE_REPORT);
+					break;
+				}
+
+				/* Begin Read-only ioctls. */
+				if (_IOC_DIR(cmd) != _IOC_READ) {
 					ret = -EINVAL;
 					break;
 				}
@@ -315,7 +411,7 @@ static long hidraw_ioctl(struct file *file, unsigned int cmd,
 						-EFAULT : len;
 					break;
 				}
-		}
+			}
 
 		ret = -ENOTTY;
 	}
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 1ebd324..986b5ac 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -798,6 +798,34 @@ static int hid_alloc_buffers(struct usb_device *dev, struct hid_device *hid)
 	return 0;
 }
 
+static int usbhid_get_raw_report(struct hid_device *hid,
+		unsigned char report_number, __u8 *buf, size_t count,
+		unsigned char report_type)
+{
+	struct usbhid_device *usbhid = hid->driver_data;
+	struct usb_device *dev = hid_to_usb_dev(hid);
+	struct usb_interface *intf = usbhid->intf;
+	struct usb_host_interface *interface = intf->cur_altsetting;
+	int ret;
+	
+	/* Byte 0 is the report number. Report data starts at byte 1.*/
+	buf[0] = report_number;
+	
+	ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
+		HID_REQ_GET_REPORT,
+		USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+		((report_type + 1) << 8) | report_number,
+		interface->desc.bInterfaceNumber, buf + 1, count - 1,
+		USB_CTRL_SET_TIMEOUT);
+
+	/* count also the report id */
+	if (ret > 0) {
+		ret++;
+	}
+	
+	return ret;
+}
+
 static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t count,
 		unsigned char report_type)
 {
@@ -807,7 +835,7 @@ static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t co
 	struct usb_host_interface *interface = intf->cur_altsetting;
 	int ret;
 
-	if (usbhid->urbout) {
+	if (usbhid->urbout && report_type != HID_FEATURE_REPORT) {
 		int actual_length;
 		int skipped_report_id = 0;
 		if (buf[0] == 0x0) {
@@ -1142,6 +1170,7 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 
 	usb_set_intfdata(intf, hid);
 	hid->ll_driver = &usb_hid_driver;
+	hid->hid_get_raw_report = usbhid_get_raw_report;
 	hid->hid_output_raw_report = usbhid_output_raw_report;
 	hid->ff_init = hid_pidff_init;
 #ifdef CONFIG_USB_HIDDEV
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 895001f..e6796c5 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -502,6 +502,9 @@ struct hid_device {							/* device report descriptor */
 				  struct hid_usage *, __s32);
 	void (*hiddev_report_event) (struct hid_device *, struct hid_report *);
 
+	/* handler for raw input (Get_Report) data, used by hidraw */
+	int (*hid_get_raw_report) (struct hid_device *, unsigned char, __u8 *, size_t, unsigned char);
+
 	/* handler for raw output data, used by hidraw */
 	int (*hid_output_raw_report) (struct hid_device *, __u8 *, size_t, unsigned char);
 
diff --git a/include/linux/hidraw.h b/include/linux/hidraw.h
index dd8d692..4b88e69 100644
--- a/include/linux/hidraw.h
+++ b/include/linux/hidraw.h
@@ -35,6 +35,9 @@ struct hidraw_devinfo {
 #define HIDIOCGRAWINFO		_IOR('H', 0x03, struct hidraw_devinfo)
 #define HIDIOCGRAWNAME(len)     _IOC(_IOC_READ, 'H', 0x04, len)
 #define HIDIOCGRAWPHYS(len)     _IOC(_IOC_READ, 'H', 0x05, len)
+/* The first byte of SFEATURE and GFEATURE is the report number */
+#define HIDIOCSFEATURE(len)    _IOC(_IOC_WRITE|_IOC_READ, 'H', 0x06, len)
+#define HIDIOCGFEATURE(len)    _IOC(_IOC_WRITE|_IOC_READ, 'H', 0x07, len)
 
 #define HIDRAW_FIRST_MINOR 0
 #define HIDRAW_MAX_DEVICES 64

