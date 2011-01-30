Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1A3Mij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 07:38:39 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:55980 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753972Ab1A3Mib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 07:38:31 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-15.arcor-online.net 6D2CB1AB6E7
Subject: [PATCH 3/8] HID: roccat: Introduced module hid-roccat-common
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
Date: Sun, 30 Jan 2011 13:38:23 +0100
Message-ID: <1296391103.2283.182.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Module hid-roccat-common contains functions used by roccat device driver
modules to reduce code duplication.
At the moment it contains just two wrapper methods for usb_control_msg
that ensure that the buffer used for transfer is dma capable which wasn't
the case before.
The kconfig option is not visible to the user but will be selected by the
device specific drivers.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/Kconfig               |    7 ++
 drivers/hid/Makefile              |    1 +
 drivers/hid/hid-roccat-arvo.c     |  148 ++++++++++------------------------
 drivers/hid/hid-roccat-common.c   |   62 ++++++++++++++
 drivers/hid/hid-roccat-common.h   |   23 +++++
 drivers/hid/hid-roccat-kone.c     |  143 +++++++++------------------------
 drivers/hid/hid-roccat-koneplus.c |  135 +++++++++----------------------
 drivers/hid/hid-roccat-pyra.c     |  161 ++++++++++---------------------------
 8 files changed, 254 insertions(+), 426 deletions(-)
 create mode 100644 drivers/hid/hid-roccat-common.c
 create mode 100644 drivers/hid/hid-roccat-common.h

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 539865a..7952369 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -417,10 +417,14 @@ config HID_ROCCAT
 	Say Y here if you have a Roccat mouse or keyboard and want OSD or
 	macro execution support.
 
+config HID_ROCCAT_COMMON
+	tristate
+
 config HID_ROCCAT_ARVO
 	tristate "Roccat Arvo keyboard support"
 	depends on USB_HID
 	select HID_ROCCAT
+	select HID_ROCCAT_COMMON
 	---help---
 	Support for Roccat Arvo keyboard.
 
@@ -428,6 +432,7 @@ config HID_ROCCAT_KONE
 	tristate "Roccat Kone Mouse support"
 	depends on USB_HID
 	select HID_ROCCAT
+	select HID_ROCCAT_COMMON
 	---help---
 	Support for Roccat Kone mouse.
 
@@ -435,6 +440,7 @@ config HID_ROCCAT_KONEPLUS
 	tristate "Roccat Kone[+] mouse support"
 	depends on USB_HID
 	select HID_ROCCAT
+	select HID_ROCCAT_COMMON
 	---help---
 	Support for Roccat Kone[+] mouse.
 
@@ -442,6 +448,7 @@ config HID_ROCCAT_PYRA
 	tristate "Roccat Pyra mouse support"
 	depends on USB_HID
 	select HID_ROCCAT
+	select HID_ROCCAT_COMMON
 	---help---
 	Support for Roccat Pyra mouse.
 
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index fea4eb8..086cf62 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_HID_PANTHERLORD)	+= hid-pl.o
 obj-$(CONFIG_HID_PETALYNX)	+= hid-petalynx.o
 obj-$(CONFIG_HID_PICOLCD)	+= hid-picolcd.o
 obj-$(CONFIG_HID_ROCCAT)	+= hid-roccat.o
+obj-$(CONFIG_HID_ROCCAT_COMMON)	+= hid-roccat-common.o
 obj-$(CONFIG_HID_ROCCAT_ARVO)	+= hid-roccat-arvo.o
 obj-$(CONFIG_HID_ROCCAT_KONE)	+= hid-roccat-kone.o
 obj-$(CONFIG_HID_ROCCAT_KONEPLUS)	+= hid-roccat-koneplus.o
diff --git a/drivers/hid/hid-roccat-arvo.c b/drivers/hid/hid-roccat-arvo.c
index ebf3c15..d72ee41 100644
--- a/drivers/hid/hid-roccat-arvo.c
+++ b/drivers/hid/hid-roccat-arvo.c
@@ -19,41 +19,15 @@
 #include <linux/device.h>
 #include <linux/input.h>
 #include <linux/hid.h>
-#include <linux/usb.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include "hid-ids.h"
 #include "hid-roccat.h"
+#include "hid-roccat-common.h"
 #include "hid-roccat-arvo.h"
 
 static struct class *arvo_class;
 
-static int arvo_receive(struct usb_device *usb_dev, uint usb_command,
-		void *buf, uint size)
-{
-	int len;
-
-	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-			USB_REQ_CLEAR_FEATURE,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
-			usb_command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
-
-	return (len != size) ? -EIO : 0;
-}
-
-static int arvo_send(struct usb_device *usb_dev, uint usb_command,
-		void const *buf, uint size)
-{
-	int len;
-
-	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
-			USB_REQ_SET_CONFIGURATION,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-			usb_command, 0, (void *)buf, size, USB_CTRL_SET_TIMEOUT);
-
-	return (len != size) ? -EIO : 0;
-}
-
 static ssize_t arvo_sysfs_show_mode_key(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -61,24 +35,17 @@ static ssize_t arvo_sysfs_show_mode_key(struct device *dev,
 			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
 	struct usb_device *usb_dev =
 			interface_to_usbdev(to_usb_interface(dev->parent->parent));
-	struct arvo_mode_key *temp_buf;
+	struct arvo_mode_key temp_buf;
 	int retval;
 
-	temp_buf = kmalloc(sizeof(struct arvo_mode_key), GFP_KERNEL);
-	if (!temp_buf)
-		return -ENOMEM;
-
 	mutex_lock(&arvo->arvo_lock);
-	retval = arvo_receive(usb_dev, ARVO_USB_COMMAND_MODE_KEY,
-			temp_buf, sizeof(struct arvo_mode_key));
+	retval = roccat_common_receive(usb_dev, ARVO_USB_COMMAND_MODE_KEY,
+			&temp_buf, sizeof(struct arvo_mode_key));
 	mutex_unlock(&arvo->arvo_lock);
 	if (retval)
-		goto out;
+		return retval;
 
-	retval = snprintf(buf, PAGE_SIZE, "%d\n", temp_buf->state);
-out:
-	kfree(temp_buf);
-	return retval;
+	return snprintf(buf, PAGE_SIZE, "%d\n", temp_buf.state);
 }
 
 static ssize_t arvo_sysfs_set_mode_key(struct device *dev,
@@ -88,32 +55,25 @@ static ssize_t arvo_sysfs_set_mode_key(struct device *dev,
 			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
 	struct usb_device *usb_dev =
 			interface_to_usbdev(to_usb_interface(dev->parent->parent));
-	struct arvo_mode_key *temp_buf;
+	struct arvo_mode_key temp_buf;
 	unsigned long state;
 	int retval;
 
-	temp_buf = kmalloc(sizeof(struct arvo_mode_key), GFP_KERNEL);
-	if (!temp_buf)
-		return -ENOMEM;
-
 	retval = strict_strtoul(buf, 10, &state);
 	if (retval)
-		goto out;
+		return retval;
 
-	temp_buf->command = ARVO_COMMAND_MODE_KEY;
-	temp_buf->state = state;
+	temp_buf.command = ARVO_COMMAND_MODE_KEY;
+	temp_buf.state = state;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = arvo_send(usb_dev, ARVO_USB_COMMAND_MODE_KEY,
-			temp_buf, sizeof(struct arvo_mode_key));
+	retval = roccat_common_send(usb_dev, ARVO_USB_COMMAND_MODE_KEY,
+			&temp_buf, sizeof(struct arvo_mode_key));
 	mutex_unlock(&arvo->arvo_lock);
 	if (retval)
-		goto out;
+		return retval;
 
-	retval = size;
-out:
-	kfree(temp_buf);
-	return retval;
+	return size;
 }
 
 static ssize_t arvo_sysfs_show_key_mask(struct device *dev,
@@ -123,24 +83,17 @@ static ssize_t arvo_sysfs_show_key_mask(struct device *dev,
 			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
 	struct usb_device *usb_dev =
 			interface_to_usbdev(to_usb_interface(dev->parent->parent));
-	struct arvo_key_mask *temp_buf;
+	struct arvo_key_mask temp_buf;
 	int retval;
 
-	temp_buf = kmalloc(sizeof(struct arvo_key_mask), GFP_KERNEL);
-	if (!temp_buf)
-		return -ENOMEM;
-
 	mutex_lock(&arvo->arvo_lock);
-	retval = arvo_receive(usb_dev, ARVO_USB_COMMAND_KEY_MASK,
-			temp_buf, sizeof(struct arvo_key_mask));
+	retval = roccat_common_receive(usb_dev, ARVO_USB_COMMAND_KEY_MASK,
+			&temp_buf, sizeof(struct arvo_key_mask));
 	mutex_unlock(&arvo->arvo_lock);
 	if (retval)
-		goto out;
+		return retval;
 
-	retval = snprintf(buf, PAGE_SIZE, "%d\n", temp_buf->key_mask);
-out:
-	kfree(temp_buf);
-	return retval;
+	return snprintf(buf, PAGE_SIZE, "%d\n", temp_buf.key_mask);
 }
 
 static ssize_t arvo_sysfs_set_key_mask(struct device *dev,
@@ -150,52 +103,40 @@ static ssize_t arvo_sysfs_set_key_mask(struct device *dev,
 			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
 	struct usb_device *usb_dev =
 			interface_to_usbdev(to_usb_interface(dev->parent->parent));
-	struct arvo_key_mask *temp_buf;
+	struct arvo_key_mask temp_buf;
 	unsigned long key_mask;
 	int retval;
 
-	temp_buf = kmalloc(sizeof(struct arvo_key_mask), GFP_KERNEL);
-	if (!temp_buf)
-		return -ENOMEM;
-
 	retval = strict_strtoul(buf, 10, &key_mask);
 	if (retval)
-		goto out;
+		return retval;
 
-	temp_buf->command = ARVO_COMMAND_KEY_MASK;
-	temp_buf->key_mask = key_mask;
+	temp_buf.command = ARVO_COMMAND_KEY_MASK;
+	temp_buf.key_mask = key_mask;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = arvo_send(usb_dev, ARVO_USB_COMMAND_KEY_MASK,
-			temp_buf, sizeof(struct arvo_key_mask));
+	retval = roccat_common_send(usb_dev, ARVO_USB_COMMAND_KEY_MASK,
+			&temp_buf, sizeof(struct arvo_key_mask));
 	mutex_unlock(&arvo->arvo_lock);
 	if (retval)
-		goto out;
+		return retval;
 
-	retval = size;
-out:
-	kfree(temp_buf);
-	return retval;
+	return size;
 }
 
 /* retval is 1-5 on success, < 0 on error */
 static int arvo_get_actual_profile(struct usb_device *usb_dev)
 {
-	struct arvo_actual_profile *temp_buf;
+	struct arvo_actual_profile temp_buf;
 	int retval;
 
-	temp_buf = kmalloc(sizeof(struct arvo_actual_profile), GFP_KERNEL);
-	if (!temp_buf)
-		return -ENOMEM;
-
-	retval = arvo_receive(usb_dev, ARVO_USB_COMMAND_ACTUAL_PROFILE,
-			temp_buf, sizeof(struct arvo_actual_profile));
+	retval = roccat_common_receive(usb_dev, ARVO_USB_COMMAND_ACTUAL_PROFILE,
+			&temp_buf, sizeof(struct arvo_actual_profile));
 
-	if (!retval)
-		retval = temp_buf->actual_profile;
+	if (retval)
+		return retval;
 
-	kfree(temp_buf);
-	return retval;
+	return temp_buf.actual_profile;
 }
 
 static ssize_t arvo_sysfs_show_actual_profile(struct device *dev,
@@ -214,32 +155,25 @@ static ssize_t arvo_sysfs_set_actual_profile(struct device *dev,
 			hid_get_drvdata(dev_get_drvdata(dev->parent->parent));
 	struct usb_device *usb_dev =
 			interface_to_usbdev(to_usb_interface(dev->parent->parent));
-	struct arvo_actual_profile *temp_buf;
+	struct arvo_actual_profile temp_buf;
 	unsigned long profile;
 	int retval;
 
-	temp_buf = kmalloc(sizeof(struct arvo_actual_profile), GFP_KERNEL);
-	if (!temp_buf)
-		return -ENOMEM;
-
 	retval = strict_strtoul(buf, 10, &profile);
 	if (retval)
-		goto out;
+		return retval;
 
-	temp_buf->command = ARVO_COMMAND_ACTUAL_PROFILE;
-	temp_buf->actual_profile = profile;
+	temp_buf.command = ARVO_COMMAND_ACTUAL_PROFILE;
+	temp_buf.actual_profile = profile;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = arvo_send(usb_dev, ARVO_USB_COMMAND_ACTUAL_PROFILE,
-			temp_buf, sizeof(struct arvo_actual_profile));
+	retval = roccat_common_send(usb_dev, ARVO_USB_COMMAND_ACTUAL_PROFILE,
+			&temp_buf, sizeof(struct arvo_actual_profile));
 	if (!retval) {
 		arvo->actual_profile = profile;
 		retval = size;
 	}
 	mutex_unlock(&arvo->arvo_lock);
-
-out:
-	kfree(temp_buf);
 	return retval;
 }
 
@@ -257,7 +191,7 @@ static ssize_t arvo_sysfs_write(struct file *fp,
 		return -EINVAL;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = arvo_send(usb_dev, command, buf, real_size);
+	retval = roccat_common_send(usb_dev, command, buf, real_size);
 	mutex_unlock(&arvo->arvo_lock);
 
 	return (retval ? retval : real_size);
@@ -280,7 +214,7 @@ static ssize_t arvo_sysfs_read(struct file *fp,
 		return -EINVAL;
 
 	mutex_lock(&arvo->arvo_lock);
-	retval = arvo_receive(usb_dev, command, buf, real_size);
+	retval = roccat_common_receive(usb_dev, command, buf, real_size);
 	mutex_unlock(&arvo->arvo_lock);
 
 	return (retval ? retval : real_size);
diff --git a/drivers/hid/hid-roccat-common.c b/drivers/hid/hid-roccat-common.c
new file mode 100644
index 0000000..13b1eb0
--- /dev/null
+++ b/drivers/hid/hid-roccat-common.c
@@ -0,0 +1,62 @@
+/*
+ * Roccat common functions for device specific drivers
+ *
+ * Copyright (c) 2011 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/slab.h>
+#include "hid-roccat-common.h"
+
+int roccat_common_receive(struct usb_device *usb_dev, uint usb_command,
+		void *data, uint size)
+{
+	char *buf;
+	int len;
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
+			usb_command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
+
+	memcpy(data, buf, size);
+	kfree(buf);
+	return ((len < 0) ? len : ((len != size) ? -EIO : 0));
+}
+EXPORT_SYMBOL_GPL(roccat_common_receive);
+
+int roccat_common_send(struct usb_device *usb_dev, uint usb_command,
+		void const *data, uint size)
+{
+	char *buf;
+	int len;
+
+	buf = kmalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	memcpy(buf, data, size);
+
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			USB_REQ_SET_CONFIGURATION,
+			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
+			usb_command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
+
+	kfree(buf);
+	return ((len < 0) ? len : ((len != size) ? -EIO : 0));
+}
+EXPORT_SYMBOL_GPL(roccat_common_send);
+
+MODULE_AUTHOR("Stefan Achatz");
+MODULE_DESCRIPTION("USB Roccat common driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-common.h b/drivers/hid/hid-roccat-common.h
new file mode 100644
index 0000000..fe45fae
--- /dev/null
+++ b/drivers/hid/hid-roccat-common.h
@@ -0,0 +1,23 @@
+#ifndef __HID_ROCCAT_COMMON_H
+#define __HID_ROCCAT_COMMON_H
+
+/*
+ * Copyright (c) 2011 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/usb.h>
+#include <linux/types.h>
+
+int roccat_common_receive(struct usb_device *usb_dev, uint usb_command,
+		void *data, uint size);
+int roccat_common_send(struct usb_device *usb_dev, uint usb_command,
+		void const *data, uint size);
+
+#endif
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index cbd8cc4..5516653 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -28,11 +28,11 @@
 #include <linux/device.h>
 #include <linux/input.h>
 #include <linux/hid.h>
-#include <linux/usb.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include "hid-ids.h"
 #include "hid-roccat.h"
+#include "hid-roccat-common.h"
 #include "hid-roccat-kone.h"
 
 static uint profile_numbers[5] = {0, 1, 2, 3, 4};
@@ -58,12 +58,8 @@ static void kone_set_settings_checksum(struct kone_settings *settings)
  */
 static int kone_check_write(struct usb_device *usb_dev)
 {
-	int len;
-	unsigned char *data;
-
-	data = kmalloc(1, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	int retval;
+	uint8_t data;
 
 	do {
 		/*
@@ -72,56 +68,36 @@ static int kone_check_write(struct usb_device *usb_dev)
 		 */
 		msleep(80);
 
-		len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-				USB_REQ_CLEAR_FEATURE,
-				USB_TYPE_CLASS | USB_RECIP_INTERFACE |
-				USB_DIR_IN,
-				kone_command_confirm_write, 0, data, 1,
-				USB_CTRL_SET_TIMEOUT);
-
-		if (len != 1) {
-			kfree(data);
-			return -EIO;
-		}
+		retval = roccat_common_receive(usb_dev,
+				kone_command_confirm_write, &data, 1);
+		if (retval)
+			return retval;
 
 		/*
 		 * value of 3 seems to mean something like
 		 * "not finished yet, but it looks good"
 		 * So check again after a moment.
 		 */
-	} while (*data == 3);
+	} while (data == 3);
 
-	if (*data == 1) { /* everything alright */
-		kfree(data);
+	if (data == 1) /* everything alright */
 		return 0;
-	} else { /* unknown answer */
-		hid_err(usb_dev, "got retval %d when checking write\n", *data);
-		kfree(data);
-		return -EIO;
-	}
+
+	/* unknown answer */
+	hid_err(usb_dev, "got retval %d when checking write\n", data);
+	return -EIO;
 }
 
 /*
  * Reads settings from mouse and stores it in @buf
- * @buf has to be alloced with GFP_KERNEL
  * On success returns 0
  * On failure returns errno
  */
 static int kone_get_settings(struct usb_device *usb_dev,
 		struct kone_settings *buf)
 {
-	int len;
-
-	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-			USB_REQ_CLEAR_FEATURE,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
-			kone_command_settings, 0, buf,
-			sizeof(struct kone_settings), USB_CTRL_SET_TIMEOUT);
-
-	if (len != sizeof(struct kone_settings))
-		return -EIO;
-
-	return 0;
+	return roccat_common_receive(usb_dev, kone_command_settings, buf,
+			sizeof(struct kone_settings));
 }
 
 /*
@@ -132,22 +108,12 @@ static int kone_get_settings(struct usb_device *usb_dev,
 static int kone_set_settings(struct usb_device *usb_dev,
 		struct kone_settings const *settings)
 {
-	int len;
-
-	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
-			USB_REQ_SET_CONFIGURATION,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-			kone_command_settings, 0, (char *)settings,
-			sizeof(struct kone_settings),
-			USB_CTRL_SET_TIMEOUT);
-
-	if (len != sizeof(struct kone_settings))
-		return -EIO;
-
-	if (kone_check_write(usb_dev))
-		return -EIO;
-
-	return 0;
+	int retval;
+	retval = roccat_common_send(usb_dev, kone_command_settings,
+			settings, sizeof(struct kone_settings));
+	if (retval)
+		return retval;
+	return kone_check_write(usb_dev);
 }
 
 /*
@@ -193,7 +159,7 @@ static int kone_set_profile(struct usb_device *usb_dev,
 	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
 			USB_REQ_SET_CONFIGURATION,
 			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-			kone_command_profile, number, (char *)profile,
+			kone_command_profile, number, (void *)profile,
 			sizeof(struct kone_profile),
 			USB_CTRL_SET_TIMEOUT);
 
@@ -213,24 +179,15 @@ static int kone_set_profile(struct usb_device *usb_dev,
  */
 static int kone_get_weight(struct usb_device *usb_dev, int *result)
 {
-	int len;
-	uint8_t *data;
+	int retval;
+	uint8_t data;
 
-	data = kmalloc(1, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	retval = roccat_common_receive(usb_dev, kone_command_weight, &data, 1);
 
-	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-			USB_REQ_CLEAR_FEATURE,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
-			kone_command_weight, 0, data, 1, USB_CTRL_SET_TIMEOUT);
+	if (retval)
+		return retval;
 
-	if (len != 1) {
-		kfree(data);
-		return -EIO;
-	}
-	*result = (int)*data;
-	kfree(data);
+	*result = (int)data;
 	return 0;
 }
 
@@ -241,25 +198,15 @@ static int kone_get_weight(struct usb_device *usb_dev, int *result)
  */
 static int kone_get_firmware_version(struct usb_device *usb_dev, int *result)
 {
-	int len;
-	unsigned char *data;
-
-	data = kmalloc(2, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	int retval;
+	uint16_t data;
 
-	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-			USB_REQ_CLEAR_FEATURE,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
-			kone_command_firmware_version, 0, data, 2,
-			USB_CTRL_SET_TIMEOUT);
+	retval = roccat_common_receive(usb_dev, kone_command_firmware_version,
+			&data, 2);
+	if (retval)
+		return retval;
 
-	if (len != 2) {
-		kfree(data);
-		return -EIO;
-	}
-	*result = le16_to_cpu(*data);
-	kfree(data);
+	*result = le16_to_cpu(data);
 	return 0;
 }
 
@@ -435,23 +382,9 @@ static ssize_t kone_sysfs_show_tcu(struct device *dev,
 
 static int kone_tcu_command(struct usb_device *usb_dev, int number)
 {
-	int len;
-	char *value;
-
-	value = kmalloc(1, GFP_KERNEL);
-	if (!value)
-		return -ENOMEM;
-
-	*value = number;
-
-	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
-			USB_REQ_SET_CONFIGURATION,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-			kone_command_calibrate, 0, value, 1,
-			USB_CTRL_SET_TIMEOUT);
-
-	kfree(value);
-	return ((len != 1) ? -EIO : 0);
+	unsigned char value;
+	value = number;
+	return roccat_common_send(usb_dev, kone_command_calibrate, &value, 1);
 }
 
 /*
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index c826c0d..d1c3a02 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -19,11 +19,11 @@
 #include <linux/device.h>
 #include <linux/input.h>
 #include <linux/hid.h>
-#include <linux/usb.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include "hid-ids.h"
 #include "hid-roccat.h"
+#include "hid-roccat-common.h"
 #include "hid-roccat-koneplus.h"
 
 static uint profile_numbers[5] = {0, 1, 2, 3, 4};
@@ -39,110 +39,63 @@ static void koneplus_profile_activated(struct koneplus_device *koneplus,
 static int koneplus_send_control(struct usb_device *usb_dev, uint value,
 		enum koneplus_control_requests request)
 {
-	int len;
-	struct koneplus_control *control;
+	struct koneplus_control control;
 
 	if ((request == KONEPLUS_CONTROL_REQUEST_PROFILE_SETTINGS ||
 			request == KONEPLUS_CONTROL_REQUEST_PROFILE_BUTTONS) &&
 			value > 4)
 		return -EINVAL;
 
-	control = kmalloc(sizeof(struct koneplus_control), GFP_KERNEL);
-	if (!control)
-		return -ENOMEM;
+	control.command = KONEPLUS_COMMAND_CONTROL;
+	control.value = value;
+	control.request = request;
 
-	control->command = KONEPLUS_COMMAND_CONTROL;
-	control->value = value;
-	control->request = request;
-
-	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
-			USB_REQ_SET_CONFIGURATION,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-			KONEPLUS_USB_COMMAND_CONTROL, 0, control,
-			sizeof(struct koneplus_control),
-			USB_CTRL_SET_TIMEOUT);
-
-	kfree(control);
-
-	if (len != sizeof(struct koneplus_control))
-		return len;
-
-	return 0;
-}
-
-static int koneplus_receive(struct usb_device *usb_dev, uint usb_command,
-		void *buf, uint size) {
-	int len;
-
-	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-			USB_REQ_CLEAR_FEATURE,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
-			usb_command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
-
-	return (len != size) ? -EIO : 0;
+	return roccat_common_send(usb_dev, KONEPLUS_USB_COMMAND_CONTROL,
+			&control, sizeof(struct koneplus_control));
 }
 
 static int koneplus_receive_control_status(struct usb_device *usb_dev)
 {
 	int retval;
-	struct koneplus_control *control;
-
-	control = kmalloc(sizeof(struct koneplus_control), GFP_KERNEL);
-	if (!control)
-		return -ENOMEM;
+	struct koneplus_control control;
 
 	do {
-		retval = koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_CONTROL,
-				control, sizeof(struct koneplus_control));
+		retval = roccat_common_receive(usb_dev, KONEPLUS_USB_COMMAND_CONTROL,
+				&control, sizeof(struct koneplus_control));
 
 		/* check if we get a completely wrong answer */
 		if (retval)
-			goto out;
+			return retval;
 
-		if (control->value == KONEPLUS_CONTROL_REQUEST_STATUS_OK) {
-			retval = 0;
-			goto out;
-		}
+		if (control.value == KONEPLUS_CONTROL_REQUEST_STATUS_OK)
+			return 0;
 
 		/* indicates that hardware needs some more time to complete action */
-		if (control->value == KONEPLUS_CONTROL_REQUEST_STATUS_WAIT) {
+		if (control.value == KONEPLUS_CONTROL_REQUEST_STATUS_WAIT) {
 			msleep(500); /* windows driver uses 1000 */
 			continue;
 		}
 
 		/* seems to be critical - replug necessary */
-		if (control->value == KONEPLUS_CONTROL_REQUEST_STATUS_OVERLOAD) {
-			retval = -EINVAL;
-			goto out;
-		}
+		if (control.value == KONEPLUS_CONTROL_REQUEST_STATUS_OVERLOAD)
+			return -EINVAL;
 
 		hid_err(usb_dev, "koneplus_receive_control_status: "
-				"unknown response value 0x%x\n", control->value);
-		retval = -EINVAL;
-		goto out;
-
+				"unknown response value 0x%x\n", control.value);
+		return -EINVAL;
 	} while (1);
-out:
-	kfree(control);
-	return retval;
 }
 
 static int koneplus_send(struct usb_device *usb_dev, uint command,
-		void *buf, uint size) {
-	int len;
-
-	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
-			USB_REQ_SET_CONFIGURATION,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-			command, 0, buf, size, USB_CTRL_SET_TIMEOUT);
-
-	if (len != size)
-		return -EIO;
+		void const *buf, uint size)
+{
+	int retval;
 
-	if (koneplus_receive_control_status(usb_dev))
-		return -EIO;
+	retval = roccat_common_send(usb_dev, command, buf, size);
+	if (retval)
+		return retval;
 
-	return 0;
+	return koneplus_receive_control_status(usb_dev);
 }
 
 static int koneplus_select_profile(struct usb_device *usb_dev, uint number,
@@ -167,7 +120,7 @@ static int koneplus_select_profile(struct usb_device *usb_dev, uint number,
 static int koneplus_get_info(struct usb_device *usb_dev,
 		struct koneplus_info *buf)
 {
-	return koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_INFO,
+	return roccat_common_receive(usb_dev, KONEPLUS_USB_COMMAND_INFO,
 			buf, sizeof(struct koneplus_info));
 }
 
@@ -181,7 +134,7 @@ static int koneplus_get_profile_settings(struct usb_device *usb_dev,
 	if (retval)
 		return retval;
 
-	return koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_SETTINGS,
+	return roccat_common_receive(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_SETTINGS,
 			buf, sizeof(struct koneplus_profile_settings));
 }
 
@@ -189,7 +142,7 @@ static int koneplus_set_profile_settings(struct usb_device *usb_dev,
 		struct koneplus_profile_settings const *settings)
 {
 	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_SETTINGS,
-			(void *)settings, sizeof(struct koneplus_profile_settings));
+			settings, sizeof(struct koneplus_profile_settings));
 }
 
 static int koneplus_get_profile_buttons(struct usb_device *usb_dev,
@@ -202,7 +155,7 @@ static int koneplus_get_profile_buttons(struct usb_device *usb_dev,
 	if (retval)
 		return retval;
 
-	return koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_BUTTONS,
+	return roccat_common_receive(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_BUTTONS,
 			buf, sizeof(struct koneplus_profile_buttons));
 }
 
@@ -210,29 +163,19 @@ static int koneplus_set_profile_buttons(struct usb_device *usb_dev,
 		struct koneplus_profile_buttons const *buttons)
 {
 	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_PROFILE_BUTTONS,
-			(void *)buttons, sizeof(struct koneplus_profile_buttons));
+			buttons, sizeof(struct koneplus_profile_buttons));
 }
 
 /* retval is 0-4 on success, < 0 on error */
 static int koneplus_get_startup_profile(struct usb_device *usb_dev)
 {
-	struct koneplus_startup_profile *buf;
+	struct koneplus_startup_profile buf;
 	int retval;
 
-	buf = kmalloc(sizeof(struct koneplus_startup_profile), GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	retval = koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_STARTUP_PROFILE,
-			buf, sizeof(struct koneplus_startup_profile));
+	retval = roccat_common_receive(usb_dev, KONEPLUS_USB_COMMAND_STARTUP_PROFILE,
+			&buf, sizeof(struct koneplus_startup_profile));
 
-	if (retval)
-		goto out;
-
-	retval = buf->startup_profile;
-out:
-	kfree(buf);
-	return retval;
+	return retval ? retval : buf.startup_profile;
 }
 
 static int koneplus_set_startup_profile(struct usb_device *usb_dev,
@@ -245,7 +188,7 @@ static int koneplus_set_startup_profile(struct usb_device *usb_dev,
 	buf.startup_profile = startup_profile;
 
 	return koneplus_send(usb_dev, KONEPLUS_USB_COMMAND_STARTUP_PROFILE,
-			(char *)&buf, sizeof(struct koneplus_profile_buttons));
+			&buf, sizeof(struct koneplus_profile_buttons));
 }
 
 static ssize_t koneplus_sysfs_read(struct file *fp, struct kobject *kobj,
@@ -265,7 +208,7 @@ static ssize_t koneplus_sysfs_read(struct file *fp, struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&koneplus->koneplus_lock);
-	retval = koneplus_receive(usb_dev, command, buf, real_size);
+	retval = roccat_common_receive(usb_dev, command, buf, real_size);
 	mutex_unlock(&koneplus->koneplus_lock);
 
 	if (retval)
@@ -288,7 +231,7 @@ static ssize_t koneplus_sysfs_write(struct file *fp, struct kobject *kobj,
 		return -EINVAL;
 
 	mutex_lock(&koneplus->koneplus_lock);
-	retval = koneplus_send(usb_dev, command, (void *)buf, real_size);
+	retval = koneplus_send(usb_dev, command, buf, real_size);
 	mutex_unlock(&koneplus->koneplus_lock);
 
 	if (retval)
@@ -352,7 +295,7 @@ static ssize_t koneplus_sysfs_read_profilex_settings(struct file *fp,
 		count = sizeof(struct koneplus_profile_settings) - off;
 
 	mutex_lock(&koneplus->koneplus_lock);
-	memcpy(buf, ((void const *)&koneplus->profile_settings[*(uint *)(attr->private)]) + off,
+	memcpy(buf, ((char const *)&koneplus->profile_settings[*(uint *)(attr->private)]) + off,
 			count);
 	mutex_unlock(&koneplus->koneplus_lock);
 
@@ -411,7 +354,7 @@ static ssize_t koneplus_sysfs_read_profilex_buttons(struct file *fp,
 		count = sizeof(struct koneplus_profile_buttons) - off;
 
 	mutex_lock(&koneplus->koneplus_lock);
-	memcpy(buf, ((void const *)&koneplus->profile_buttons[*(uint *)(attr->private)]) + off,
+	memcpy(buf, ((char const *)&koneplus->profile_buttons[*(uint *)(attr->private)]) + off,
 			count);
 	mutex_unlock(&koneplus->koneplus_lock);
 
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index 02c58e0..abe77d3 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -20,11 +20,11 @@
 #include <linux/device.h>
 #include <linux/input.h>
 #include <linux/hid.h>
-#include <linux/usb.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include "hid-ids.h"
 #include "hid-roccat.h"
+#include "hid-roccat-common.h"
 #include "hid-roccat-pyra.h"
 
 static uint profile_numbers[5] = {0, 1, 2, 3, 4};
@@ -42,7 +42,6 @@ static void profile_activated(struct pyra_device *pyra,
 static int pyra_send_control(struct usb_device *usb_dev, int value,
 		enum pyra_control_requests request)
 {
-	int len;
 	struct pyra_control control;
 
 	if ((request == PYRA_CONTROL_REQUEST_PROFILE_SETTINGS ||
@@ -54,47 +53,31 @@ static int pyra_send_control(struct usb_device *usb_dev, int value,
 	control.value = value;
 	control.request = request;
 
-	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
-			USB_REQ_SET_CONFIGURATION,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-			PYRA_USB_COMMAND_CONTROL, 0, (char *)&control,
-			sizeof(struct pyra_control),
-			USB_CTRL_SET_TIMEOUT);
-
-	if (len != sizeof(struct pyra_control))
-		return len;
-
-	return 0;
+	return roccat_common_send(usb_dev, PYRA_USB_COMMAND_CONTROL,
+			&control, sizeof(struct pyra_control));
 }
 
 static int pyra_receive_control_status(struct usb_device *usb_dev)
 {
-	int len;
+	int retval;
 	struct pyra_control control;
 
 	do {
 		msleep(10);
-
-		len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-				USB_REQ_CLEAR_FEATURE,
-				USB_TYPE_CLASS | USB_RECIP_INTERFACE |
-				USB_DIR_IN,
-				PYRA_USB_COMMAND_CONTROL, 0, (char *)&control,
-				sizeof(struct pyra_control),
-				USB_CTRL_SET_TIMEOUT);
+		retval = roccat_common_receive(usb_dev, PYRA_USB_COMMAND_CONTROL,
+				&control, sizeof(struct pyra_control));
 
 		/* requested too early, try again */
-	} while (len == -EPROTO);
+	} while (retval == -EPROTO);
 
-	if (len == sizeof(struct pyra_control) &&
-			control.command == PYRA_COMMAND_CONTROL &&
+	if (!retval && control.command == PYRA_COMMAND_CONTROL &&
 			control.request == PYRA_CONTROL_REQUEST_STATUS &&
 			control.value == 1)
-			return 0;
+		return 0;
 	else {
 		hid_err(usb_dev, "receive control status: unknown response 0x%x 0x%x\n",
 			control.request, control.value);
-		return -EINVAL;
+		return retval ? retval : -EINVAL;
 	}
 }
 
@@ -102,125 +85,72 @@ static int pyra_get_profile_settings(struct usb_device *usb_dev,
 		struct pyra_profile_settings *buf, int number)
 {
 	int retval;
-
 	retval = pyra_send_control(usb_dev, number,
 			PYRA_CONTROL_REQUEST_PROFILE_SETTINGS);
-
 	if (retval)
 		return retval;
-
-	retval = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-			USB_REQ_CLEAR_FEATURE,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
-			PYRA_USB_COMMAND_PROFILE_SETTINGS, 0, (char *)buf,
-			sizeof(struct pyra_profile_settings),
-			USB_CTRL_SET_TIMEOUT);
-
-	if (retval != sizeof(struct pyra_profile_settings))
-		return retval;
-
-	return 0;
+	return roccat_common_receive(usb_dev, PYRA_USB_COMMAND_PROFILE_SETTINGS,
+			buf, sizeof(struct pyra_profile_settings));
 }
 
 static int pyra_get_profile_buttons(struct usb_device *usb_dev,
 		struct pyra_profile_buttons *buf, int number)
 {
 	int retval;
-
 	retval = pyra_send_control(usb_dev, number,
 			PYRA_CONTROL_REQUEST_PROFILE_BUTTONS);
-
 	if (retval)
 		return retval;
-
-	retval = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-			USB_REQ_CLEAR_FEATURE,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
-			PYRA_USB_COMMAND_PROFILE_BUTTONS, 0, (char *)buf,
-			sizeof(struct pyra_profile_buttons),
-			USB_CTRL_SET_TIMEOUT);
-
-	if (retval != sizeof(struct pyra_profile_buttons))
-		return retval;
-
-	return 0;
+	return roccat_common_receive(usb_dev, PYRA_USB_COMMAND_PROFILE_BUTTONS,
+			buf, sizeof(struct pyra_profile_buttons));
 }
 
 static int pyra_get_settings(struct usb_device *usb_dev,
 		struct pyra_settings *buf)
 {
-	int len;
-	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-			USB_REQ_CLEAR_FEATURE,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
-			PYRA_USB_COMMAND_SETTINGS, 0, buf,
-			sizeof(struct pyra_settings), USB_CTRL_SET_TIMEOUT);
-	if (len != sizeof(struct pyra_settings))
-		return -EIO;
-	return 0;
+	return roccat_common_receive(usb_dev, PYRA_USB_COMMAND_SETTINGS,
+			buf, sizeof(struct pyra_settings));
 }
 
 static int pyra_get_info(struct usb_device *usb_dev, struct pyra_info *buf)
 {
-	int len;
-	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-			USB_REQ_CLEAR_FEATURE,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
-			PYRA_USB_COMMAND_INFO, 0, buf,
-			sizeof(struct pyra_info), USB_CTRL_SET_TIMEOUT);
-	if (len != sizeof(struct pyra_info))
-		return -EIO;
-	return 0;
+	return roccat_common_receive(usb_dev, PYRA_USB_COMMAND_INFO,
+			buf, sizeof(struct pyra_info));
+}
+
+static int pyra_send(struct usb_device *usb_dev, uint command,
+		void const *buf, uint size)
+{
+	int retval;
+	retval = roccat_common_send(usb_dev, command, buf, size);
+	if (retval)
+		return retval;
+	return pyra_receive_control_status(usb_dev);
 }
 
 static int pyra_set_profile_settings(struct usb_device *usb_dev,
 		struct pyra_profile_settings const *settings)
 {
-	int len;
-	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
-			USB_REQ_SET_CONFIGURATION,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-			PYRA_USB_COMMAND_PROFILE_SETTINGS, 0, (char *)settings,
-			sizeof(struct pyra_profile_settings),
-			USB_CTRL_SET_TIMEOUT);
-	if (len != sizeof(struct pyra_profile_settings))
-		return -EIO;
-	if (pyra_receive_control_status(usb_dev))
-		return -EIO;
-	return 0;
+	return pyra_send(usb_dev, PYRA_USB_COMMAND_PROFILE_SETTINGS, settings,
+			sizeof(struct pyra_profile_settings));
 }
 
 static int pyra_set_profile_buttons(struct usb_device *usb_dev,
 		struct pyra_profile_buttons const *buttons)
 {
-	int len;
-	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
-			USB_REQ_SET_CONFIGURATION,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-			PYRA_USB_COMMAND_PROFILE_BUTTONS, 0, (char *)buttons,
-			sizeof(struct pyra_profile_buttons),
-			USB_CTRL_SET_TIMEOUT);
-	if (len != sizeof(struct pyra_profile_buttons))
-		return -EIO;
-	if (pyra_receive_control_status(usb_dev))
-		return -EIO;
-	return 0;
+	return pyra_send(usb_dev, PYRA_USB_COMMAND_PROFILE_BUTTONS, buttons,
+			sizeof(struct pyra_profile_buttons));
 }
 
 static int pyra_set_settings(struct usb_device *usb_dev,
 		struct pyra_settings const *settings)
 {
-	int len;
-	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
-			USB_REQ_SET_CONFIGURATION,
-			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
-			PYRA_USB_COMMAND_SETTINGS, 0, (char *)settings,
-			sizeof(struct pyra_settings), USB_CTRL_SET_TIMEOUT);
-	if (len != sizeof(struct pyra_settings))
-		return -EIO;
-	if (pyra_receive_control_status(usb_dev))
-		return -EIO;
-	return 0;
+	int retval;
+	retval = roccat_common_send(usb_dev, PYRA_USB_COMMAND_SETTINGS, settings,
+			sizeof(struct pyra_settings));
+	if (retval)
+		return retval;
+	return pyra_receive_control_status(usb_dev);
 }
 
 static ssize_t pyra_sysfs_read_profilex_settings(struct file *fp,
@@ -521,21 +451,16 @@ static struct bin_attribute pyra_bin_attributes[] = {
 static int pyra_init_pyra_device_struct(struct usb_device *usb_dev,
 		struct pyra_device *pyra)
 {
-	struct pyra_info *info;
+	struct pyra_info info;
 	int retval, i;
 
 	mutex_init(&pyra->pyra_lock);
 
-	info = kmalloc(sizeof(struct pyra_info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-	retval = pyra_get_info(usb_dev, info);
-	if (retval) {
-		kfree(info);
+	retval = pyra_get_info(usb_dev, &info);
+	if (retval)
 		return retval;
-	}
-	pyra->firmware_version = info->firmware_version;
-	kfree(info);
+
+	pyra->firmware_version = info.firmware_version;
 
 	retval = pyra_get_settings(usb_dev, &pyra->settings);
 	if (retval)
-- 
1.7.3.4



