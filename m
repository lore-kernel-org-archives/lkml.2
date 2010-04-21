Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab0DUPiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:38:22 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:54260 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab0DUPiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ueJHtk0E9UEslYUDkGE+v4qj1VRRecQIJZXKmZCMrjzH9UgTzwurs4AwpBmMZDN7dw
         NA7ZN2Aod193D6F+oGMbEan/CVGJcUgOXNRSXKVBv14F762SdpXPFTZu7j5IgYgb40KM
         jDdTKgmtU+dqQpbWHwIfUMDPJ5nnH1rFEj6tQ=
From: fabien.chouteau@gmail.com
To: linux-usb@vger.kernel.org
Cc: Fabien Chouteau <fabien.chouteau@barco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Roel Kluin <roel.kluin@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Composite framework: Add suspended sysfs entry
Date: Wed, 21 Apr 2010 17:38:21 +0200
Message-Id: <1271864304-4279-1-git-send-email-fabien.chouteau@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabien Chouteau <fabien.chouteau@barco.com>


Signed-off-by: Fabien Chouteau <fabien.chouteau@barco.com>
---
 drivers/usb/gadget/composite.c |   21 +++++++++++++++++++++
 include/linux/usb/composite.h  |    1 +
 include/linux/usb/gadget.h     |    4 ++++
 3 files changed, 26 insertions(+), 0 deletions(-)

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

