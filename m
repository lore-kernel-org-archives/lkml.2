Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0DWMVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 08:21:35 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38274 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0DWMVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 08:21:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=v7S4g9s1OkFWQgLFa7kjl8W1PrZbMsl8mnlRvL5FqeK1N5kWBqDTODx9+CHok5U1MV
         8AR3Z8ZsEZ5S5I7Ortj9Y31y56giuY/KwvQ84nYuWN8Lg1pw7ZAxP971Cfc1I2WEXLm1
         K645rt+CZ5ZHU4eh5pJBrQf7YpK+Ft8FOXtaY=
From: fabien.chouteau@gmail.com
To: linux-usb@vger.kernel.org
Cc: Fabien Chouteau <fabien.chouteau@barco.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Roel Kluin <roel.kluin@gmail.com>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH RESEND 1/2] Composite framework: Add suspended sysfs entry
Date: Fri, 23 Apr 2010 14:21:26 +0200
Message-Id: <1272025288-32555-1-git-send-email-fabien.chouteau@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabien Chouteau <fabien.chouteau@barco.com>

This patch adds a sysfs entry (/sys/devices/platform/_UDC_/gadget/suspended) to
show the suspend state of an USB composite gadget.

Signed-off-by: Fabien Chouteau <fabien.chouteau@barco.com>
---
 .../testing/sysfs-devices-platform-_UDC_-gadget    |    9 ++++++++
 drivers/usb/gadget/composite.c                     |   21 ++++++++++++++++++++
 include/linux/usb/composite.h                      |    1 +
 include/linux/usb/gadget.h                         |    4 +++
 4 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadget

diff --git a/Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadget b/Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadget
new file mode 100644
index 0000000..3403402
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadget
@@ -0,0 +1,9 @@
+What:		/sys/devices/platform/_UDC_/gadget/suspended
+Date:		April 2010
+Contact:	Fabien Chouteau <fabien.chouteau@barco.com>
+Description:
+		Show the suspend state of an USB composite gadget.
+		1 -> suspended
+		0 -> resumed
+
+		(_UDC_ is the name of the USB Device Controller driver)
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 09289bb..a5352f3 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -898,6 +898,18 @@ static void composite_disconnect(struct usb_gadget *gadget)
 
 /*-------------------------------------------------------------------------*/
 
+static ssize_t composite_show_suspended(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct usb_gadget *gadget = dev_to_usb_gadget(dev);
+	struct usb_composite_dev *cdev = get_gadget_data(gadget);
+
+	return sprintf(buf, "%d\n", cdev->suspended);
+}
+
+static DEVICE_ATTR(suspended, 0444, composite_show_suspended, NULL);
+
 static void /* __init_or_exit */
 composite_unbind(struct usb_gadget *gadget)
 {
@@ -944,6 +956,7 @@ composite_unbind(struct usb_gadget *gadget)
 	}
 	kfree(cdev);
 	set_gadget_data(gadget, NULL);
+	device_remove_file(&gadget->dev, &dev_attr_suspended);
 	composite = NULL;
 }
 
@@ -1036,6 +1049,10 @@ static int __init composite_bind(struct usb_gadget *gadget)
 		string_override(composite->strings,
 			cdev->desc.iSerialNumber, iSerialNumber);
 
+	status = device_create_file(&gadget->dev, &dev_attr_suspended);
+	if (status)
+		goto fail;
+
 	INFO(cdev, "%s ready\n", composite->name);
 	return 0;
 
@@ -1064,6 +1081,8 @@ composite_suspend(struct usb_gadget *gadget)
 	}
 	if (composite->suspend)
 		composite->suspend(cdev);
+
+	cdev->suspended = 1;
 }
 
 static void
@@ -1084,6 +1103,8 @@ composite_resume(struct usb_gadget *gadget)
 				f->resume(f);
 		}
 	}
+
+	cdev->suspended = 0;
 }
 
 /*-------------------------------------------------------------------------*/
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 738ea1a..139353e 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -326,6 +326,7 @@ struct usb_composite_dev {
 
 	/* private: */
 	/* internals */
+	unsigned int			suspended:1;
 	struct usb_device_descriptor	desc;
 	struct list_head		configs;
 	struct usb_composite_driver	*driver;
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index f4b7ca5..db6141c 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -494,6 +494,10 @@ static inline void set_gadget_data(struct usb_gadget *gadget, void *data)
 	{ dev_set_drvdata(&gadget->dev, data); }
 static inline void *get_gadget_data(struct usb_gadget *gadget)
 	{ return dev_get_drvdata(&gadget->dev); }
+static inline struct usb_gadget *dev_to_usb_gadget(struct device *dev)
+{
+	return container_of(dev, struct usb_gadget, dev);
+}
 
 /* iterates the non-control endpoints; 'tmp' is a struct usb_ep pointer */
 #define gadget_for_each_ep(tmp,gadget) \
-- 
1.7.0.5

