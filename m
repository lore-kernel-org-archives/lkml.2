Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1A3Mim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 07:38:42 -0500
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:44130 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754187Ab1A3Mie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 07:38:34 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-15.arcor-online.net BE2B11AB5F8
Subject: [PATCH 5/8] HID: roccat: Added ioctl command to retreive report
 size from chardev
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Weber <weber@corscience.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Jan 2011 13:38:25 +0100
Message-ID: <1296391105.2283.184.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roccat chardev was reworked to support only a defined report size per
device and this can be retreived by an ioctl now to enable future changes
in report definitions.
Header was moved/renamed from drivers/hid to include/linux for accessibility.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 drivers/hid/hid-roccat-arvo.c        |    9 +++---
 drivers/hid/hid-roccat-kone.c        |   11 +++----
 drivers/hid/hid-roccat-koneplus.c    |    8 +++---
 drivers/hid/hid-roccat-kovaplus.c    |    8 +++---
 drivers/hid/hid-roccat-pyra.c        |   11 +++----
 drivers/hid/hid-roccat.c             |   48 ++++++++++++++++++++++++++-------
 drivers/hid/hid-roccat.h             |   22 ---------------
 include/linux/roccat.h               |   29 ++++++++++++++++++++
 9 files changed, 91 insertions(+), 56 deletions(-)
 delete mode 100644 drivers/hid/hid-roccat.h
 create mode 100644 include/linux/roccat.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index ac293e9..b0f1fa0 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -133,6 +133,7 @@ Code  Seq#(hex)	Include File		Comments
 'H'	C0-DF	net/bluetooth/hidp/hidp.h	conflict!
 'H'	C0-DF	net/bluetooth/cmtp/cmtp.h	conflict!
 'H'	C0-DF	net/bluetooth/bnep/bnep.h	conflict!
+'H'	F1	linux/roccat.h		<mailto:erazor_de@users.sourceforge.net>
 'I'	all	linux/isdn.h		conflict!
 'I'	00-0F	drivers/isdn/divert/isdn_divert.h	conflict!
 'I'	40-4F	linux/mISDNif.h		conflict!
diff --git a/drivers/hid/hid-roccat-arvo.c b/drivers/hid/hid-roccat-arvo.c
index d72ee41..7b9a992 100644
--- a/drivers/hid/hid-roccat-arvo.c
+++ b/drivers/hid/hid-roccat-arvo.c
@@ -21,8 +21,8 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/roccat.h>
 #include "hid-ids.h"
-#include "hid-roccat.h"
 #include "hid-roccat-common.h"
 #include "hid-roccat-arvo.h"
 
@@ -303,7 +303,8 @@ static int arvo_init_specials(struct hid_device *hdev)
 		goto exit_free;
 	}
 
-	retval = roccat_connect(arvo_class, hdev);
+	retval = roccat_connect(arvo_class, hdev,
+			sizeof(struct arvo_roccat_report));
 	if (retval < 0) {
 		hid_err(hdev, "couldn't init char dev\n");
 	} else {
@@ -386,8 +387,8 @@ static void arvo_report_to_chrdev(struct arvo_device const *arvo,
 	else
 		roccat_report.action = ARVO_ROCCAT_REPORT_ACTION_RELEASE;
 
-	roccat_report_event(arvo->chrdev_minor, (uint8_t const *)&roccat_report,
-			sizeof(struct arvo_roccat_report));
+	roccat_report_event(arvo->chrdev_minor,
+			(uint8_t const *)&roccat_report);
 }
 
 static int arvo_raw_event(struct hid_device *hdev,
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 5516653..5cdb282 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -30,8 +30,8 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/roccat.h>
 #include "hid-ids.h"
-#include "hid-roccat.h"
 #include "hid-roccat-common.h"
 #include "hid-roccat-kone.h"
 
@@ -660,7 +660,8 @@ static int kone_init_specials(struct hid_device *hdev)
 			goto exit_free;
 		}
 
-		retval = roccat_connect(kone_class, hdev);
+		retval = roccat_connect(kone_class, hdev,
+				sizeof(struct kone_roccat_report));
 		if (retval < 0) {
 			hid_err(hdev, "couldn't init char dev\n");
 			/* be tolerant about not getting chrdev */
@@ -760,8 +761,7 @@ static void kone_report_to_chrdev(struct kone_device const *kone,
 		roccat_report.value = event->value;
 		roccat_report.key = 0;
 		roccat_report_event(kone->chrdev_minor,
-				(uint8_t *)&roccat_report,
-				sizeof(struct kone_roccat_report));
+				(uint8_t *)&roccat_report);
 		break;
 	case kone_mouse_event_call_overlong_macro:
 		if (event->value == kone_keystroke_action_press) {
@@ -769,8 +769,7 @@ static void kone_report_to_chrdev(struct kone_device const *kone,
 			roccat_report.value = kone->actual_profile;
 			roccat_report.key = event->macro_key;
 			roccat_report_event(kone->chrdev_minor,
-					(uint8_t *)&roccat_report,
-					sizeof(struct kone_roccat_report));
+					(uint8_t *)&roccat_report);
 		}
 		break;
 	}
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index d1c3a02..29a42b4 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -21,8 +21,8 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/roccat.h>
 #include "hid-ids.h"
-#include "hid-roccat.h"
 #include "hid-roccat-common.h"
 #include "hid-roccat-koneplus.h"
 
@@ -612,7 +612,8 @@ static int koneplus_init_specials(struct hid_device *hdev)
 			goto exit_free;
 		}
 
-		retval = roccat_connect(koneplus_class, hdev);
+		retval = roccat_connect(koneplus_class, hdev,
+				sizeof(struct koneplus_roccat_report));
 		if (retval < 0) {
 			hid_err(hdev, "couldn't init char dev\n");
 		} else {
@@ -718,8 +719,7 @@ static void koneplus_report_to_chrdev(struct koneplus_device const *koneplus,
 	roccat_report.data2 = button_report->data2;
 	roccat_report.profile = koneplus->actual_profile + 1;
 	roccat_report_event(koneplus->chrdev_minor,
-			(uint8_t const *)&roccat_report,
-			sizeof(struct koneplus_roccat_report));
+			(uint8_t const *)&roccat_report);
 }
 
 static int koneplus_raw_event(struct hid_device *hdev,
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index 1f547a2..7664e2c 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -20,8 +20,8 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/roccat.h>
 #include "hid-ids.h"
-#include "hid-roccat.h"
 #include "hid-roccat-common.h"
 #include "hid-roccat-kovaplus.h"
 
@@ -524,7 +524,8 @@ static int kovaplus_init_specials(struct hid_device *hdev)
 			goto exit_free;
 		}
 
-		retval = roccat_connect(kovaplus_class, hdev);
+		retval = roccat_connect(kovaplus_class, hdev,
+				sizeof(struct kovaplus_roccat_report));
 		if (retval < 0) {
 			hid_err(hdev, "couldn't init char dev\n");
 		} else {
@@ -648,8 +649,7 @@ static void kovaplus_report_to_chrdev(struct kovaplus_device const *kovaplus,
 	roccat_report.data2 = button_report->data2;
 
 	roccat_report_event(kovaplus->chrdev_minor,
-			(uint8_t const *)&roccat_report,
-			sizeof(struct kovaplus_roccat_report));
+			(uint8_t const *)&roccat_report);
 }
 
 static int kovaplus_raw_event(struct hid_device *hdev,
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index abe77d3..be4daa9 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -22,8 +22,8 @@
 #include <linux/hid.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/roccat.h>
 #include "hid-ids.h"
-#include "hid-roccat.h"
 #include "hid-roccat-common.h"
 #include "hid-roccat-pyra.h"
 
@@ -506,7 +506,8 @@ static int pyra_init_specials(struct hid_device *hdev)
 			goto exit_free;
 		}
 
-		retval = roccat_connect(pyra_class, hdev);
+		retval = roccat_connect(pyra_class, hdev,
+				sizeof(struct pyra_roccat_report));
 		if (retval < 0) {
 			hid_err(hdev, "couldn't init char dev\n");
 		} else {
@@ -610,8 +611,7 @@ static void pyra_report_to_chrdev(struct pyra_device const *pyra,
 		roccat_report.value = button_event->data1;
 		roccat_report.key = 0;
 		roccat_report_event(pyra->chrdev_minor,
-				(uint8_t const *)&roccat_report,
-				sizeof(struct pyra_roccat_report));
+				(uint8_t const *)&roccat_report);
 		break;
 	case PYRA_MOUSE_EVENT_BUTTON_TYPE_MACRO:
 	case PYRA_MOUSE_EVENT_BUTTON_TYPE_SHORTCUT:
@@ -625,8 +625,7 @@ static void pyra_report_to_chrdev(struct pyra_device const *pyra,
 			 */
 			roccat_report.value = pyra->actual_profile + 1;
 			roccat_report_event(pyra->chrdev_minor,
-					(uint8_t const *)&roccat_report,
-					sizeof(struct pyra_roccat_report));
+					(uint8_t const *)&roccat_report);
 		}
 		break;
 	}
diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index a14c579..0fa23de 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -26,8 +26,7 @@
 #include <linux/cdev.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
-
-#include "hid-roccat.h"
+#include <linux/roccat.h>
 
 #define ROCCAT_FIRST_MINOR 0
 #define ROCCAT_MAX_DEVICES 8
@@ -37,11 +36,11 @@
 
 struct roccat_report {
 	uint8_t *value;
-	int len;
 };
 
 struct roccat_device {
 	unsigned int minor;
+	int report_size;
 	int open;
 	int exist;
 	wait_queue_head_t wait;
@@ -123,7 +122,7 @@ static ssize_t roccat_read(struct file *file, char __user *buffer,
 	 * If report is larger than requested amount of data, rest of report
 	 * is lost!
 	 */
-	len = report->len > count ? count : report->len;
+	len = device->report_size > count ? count : device->report_size;
 
 	if (copy_to_user(buffer, report->value, len)) {
 		retval = -EFAULT;
@@ -248,26 +247,25 @@ static int roccat_release(struct inode *inode, struct file *file)
  *
  * This is called from interrupt handler.
  */
-int roccat_report_event(int minor, u8 const *data, int len)
+int roccat_report_event(int minor, u8 const *data)
 {
 	struct roccat_device *device;
 	struct roccat_reader *reader;
 	struct roccat_report *report;
 	uint8_t *new_value;
 
-	new_value = kmemdup(data, len, GFP_ATOMIC);
+	device = devices[minor];
+
+	new_value = kmemdup(data, device->report_size, GFP_ATOMIC);
 	if (!new_value)
 		return -ENOMEM;
 
-	device = devices[minor];
-
 	report = &device->cbuf[device->cbuf_end];
 
 	/* passing NULL is safe */
 	kfree(report->value);
 
 	report->value = new_value;
-	report->len = len;
 	device->cbuf_end = (device->cbuf_end + 1) % ROCCAT_CBUF_SIZE;
 
 	list_for_each_entry(reader, &device->readers, node) {
@@ -295,7 +293,7 @@ EXPORT_SYMBOL_GPL(roccat_report_event);
  * Return value is minor device number in Range [0, ROCCAT_MAX_DEVICES] on
  * success, a negative error code on failure.
  */
-int roccat_connect(struct class *klass, struct hid_device *hid)
+int roccat_connect(struct class *klass, struct hid_device *hid, int report_size)
 {
 	unsigned int minor;
 	struct roccat_device *device;
@@ -343,6 +341,7 @@ int roccat_connect(struct class *klass, struct hid_device *hid)
 	device->hid = hid;
 	device->exist = 1;
 	device->cbuf_end = 0;
+	device->report_size = report_size;
 
 	return minor;
 }
@@ -373,6 +372,34 @@ void roccat_disconnect(int minor)
 }
 EXPORT_SYMBOL_GPL(roccat_disconnect);
 
+static long roccat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct roccat_device *device;
+	unsigned int minor = iminor(inode);
+	long retval = 0;
+
+	mutex_lock(&devices_lock);
+
+	device = devices[minor];
+	if (!device) {
+		retval = -ENODEV;
+		goto out;
+	}
+
+	switch (cmd) {
+	case ROCCATIOCGREPSIZE:
+		if (put_user(device->report_size, (int __user *)arg))
+			retval = -EFAULT;
+		break;
+	default:
+		retval = -ENOTTY;
+	}
+out:
+	mutex_unlock(&devices_lock);
+	return retval;
+}
+
 static const struct file_operations roccat_ops = {
 	.owner = THIS_MODULE,
 	.read = roccat_read,
@@ -380,6 +407,7 @@ static const struct file_operations roccat_ops = {
 	.open = roccat_open,
 	.release = roccat_release,
 	.llseek = noop_llseek,
+	.unlocked_ioctl = roccat_ioctl,
 };
 
 static int __init roccat_init(void)
diff --git a/drivers/hid/hid-roccat.h b/drivers/hid/hid-roccat.h
deleted file mode 100644
index c739337..0000000
--- a/drivers/hid/hid-roccat.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef __HID_ROCCAT_H
-#define __HID_ROCCAT_H
-
-/*
- * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- */
-
-#include <linux/hid.h>
-#include <linux/types.h>
-
-int roccat_connect(struct class *klass, struct hid_device *hid);
-void roccat_disconnect(int minor);
-int roccat_report_event(int minor, u8 const *data, int len);
-
-#endif
diff --git a/include/linux/roccat.h b/include/linux/roccat.h
new file mode 100644
index 0000000..24e1ca0
--- /dev/null
+++ b/include/linux/roccat.h
@@ -0,0 +1,29 @@
+#ifndef __HID_ROCCAT_H
+#define __HID_ROCCAT_H
+
+/*
+ * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/hid.h>
+#include <linux/types.h>
+
+#define ROCCATIOCGREPSIZE _IOR('H', 0xf1, int)
+
+#ifdef __KERNEL__
+
+int roccat_connect(struct class *klass, struct hid_device *hid,
+		int report_size);
+void roccat_disconnect(int minor);
+int roccat_report_event(int minor, u8 const *data);
+
+#endif
+
+#endif
-- 
1.7.3.4



