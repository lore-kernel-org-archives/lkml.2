Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0FNLOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:14:32 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43495 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab0FNLOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:14:31 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] UBUNTU: SAUCE: khubd -- switch USB product/manufacturer/serial handling to RCU
Date: Mon, 14 Jun 2010 12:14:28 +0100
Message-Id: <1276514068-23668-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of wireless USB hubs the product, manufacturer,
and serial number are now mutable.  This necessitates new locking in the
consumers of these values including the sysfs read routines in order to
prevent use-after-free acces to these values.  These extra locks create
significant lock contention leading to increased boot times (0.3s for an
example Atom based system).  Move update of these values to RCU based
locking.

BugLink: http://bugs.launchpad.net/bugs/510937
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/usb/core/hub.c   |   34 ++++++++++++++++++++++++++++------
 drivers/usb/core/sysfs.c |    6 +++---
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 83e7bbb..6967421 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/freezer.h>
 #include <linux/pm_runtime.h>
+#include <linux/rcupdate.h>
 
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
@@ -1849,6 +1850,10 @@ fail:
  */
 int usb_deauthorize_device(struct usb_device *usb_dev)
 {
+	char *product = NULL;
+	char *manufacturer = NULL;
+	char *serial = NULL;
+
 	usb_lock_device(usb_dev);
 	if (usb_dev->authorized == 0)
 		goto out_unauthorized;
@@ -1856,11 +1861,12 @@ int usb_deauthorize_device(struct usb_device *usb_dev)
 	usb_dev->authorized = 0;
 	usb_set_configuration(usb_dev, -1);
 
-	kfree(usb_dev->product);
+	product = usb_dev->product;
+	manufacturer = usb_dev->manufacturer;
+	serial = usb_dev->serial;
+
 	usb_dev->product = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-	kfree(usb_dev->manufacturer);
 	usb_dev->manufacturer = kstrdup("n/a (unauthorized)", GFP_KERNEL);
-	kfree(usb_dev->serial);
 	usb_dev->serial = kstrdup("n/a (unauthorized)", GFP_KERNEL);
 
 	usb_destroy_configuration(usb_dev);
@@ -1868,6 +1874,12 @@ int usb_deauthorize_device(struct usb_device *usb_dev)
 
 out_unauthorized:
 	usb_unlock_device(usb_dev);
+	if (product || manufacturer || serial) {
+		synchronize_rcu();
+		kfree(product);
+		kfree(manufacturer);
+		kfree(serial);
+	}
 	return 0;
 }
 
@@ -1875,6 +1887,9 @@ out_unauthorized:
 int usb_authorize_device(struct usb_device *usb_dev)
 {
 	int result = 0, c;
+	char *product = NULL;
+	char *manufacturer = NULL;
+	char *serial = NULL;
 
 	usb_lock_device(usb_dev);
 	if (usb_dev->authorized == 1)
@@ -1893,11 +1908,12 @@ int usb_authorize_device(struct usb_device *usb_dev)
 		goto error_device_descriptor;
 	}
 
-	kfree(usb_dev->product);
+	product = usb_dev->product;
+	manufacturer = usb_dev->manufacturer;
+	serial = usb_dev->serial;
+
 	usb_dev->product = NULL;
-	kfree(usb_dev->manufacturer);
 	usb_dev->manufacturer = NULL;
-	kfree(usb_dev->serial);
 	usb_dev->serial = NULL;
 
 	usb_dev->authorized = 1;
@@ -1925,6 +1941,12 @@ error_device_descriptor:
 error_autoresume:
 out_authorized:
 	usb_unlock_device(usb_dev);	// complements locktree
+	if (product || manufacturer || serial) {
+		synchronize_rcu();
+		kfree(product);
+		kfree(manufacturer);
+		kfree(serial);
+	}
 	return result;
 }
 
diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index 448f5b4..98856d8 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -85,9 +85,9 @@ static ssize_t  show_##name(struct device *dev,				\
 	int retval;							\
 									\
 	udev = to_usb_device(dev);					\
-	usb_lock_device(udev);						\
-	retval = sprintf(buf, "%s\n", udev->name);			\
-	usb_unlock_device(udev);					\
+	rcu_read_lock();						\
+	retval = sprintf(buf, "%s\n", rcu_dereference(udev->name));	\
+	rcu_read_unlock();						\
 	return retval;							\
 }									\
 static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL);
-- 
1.7.0.4

