Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab2DYW1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 18:27:03 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:46594 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759364Ab2DYW05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 18:26:57 -0400
Date: Wed, 25 Apr 2012 15:26:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] USB: remove CONFIG_USB_DEVICE_CLASS
Message-ID: <20120425222654.GA27834@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option has been deprecated for many years now, and no userspace
tools use it anymore, so it should be safe to finally remove it.

Reported-by: Kay Sievers <kay@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

Anyone object to me queuing this up for the 3.5 kernel release?

 drivers/usb/core/Kconfig |   23 ----------------------
 drivers/usb/core/devio.c |   49 ----------------------------------------------
 include/linux/usb.h      |    3 ---
 3 files changed, 75 deletions(-)

diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index 18d02e3..df70b24 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -56,29 +56,6 @@ config USB_DEVICEFS
 	  The usbfs functionality is replaced by real device-nodes managed by
 	  udev.  These nodes lived in /dev/bus/usb and are used by libusb.
 
-config USB_DEVICE_CLASS
-	bool "USB device class-devices (DEPRECATED)"
-	depends on USB
-	default y
-	---help---
-	  Userspace access to USB devices is granted by device-nodes exported
-	  directly from the usbdev in sysfs. Old versions of the driver
-	  core and udev needed additional class devices to export device nodes.
-
-	  These additional devices are difficult to handle in userspace, if
-	  information about USB interfaces must be available. One device
-	  contains the device node, the other device contains the interface
-	  data. Both devices are at the same level in sysfs (siblings) and one
-	  can't access the other. The device node created directly by the
-	  usb device is the parent device of the interface and therefore
-	  easily accessible from the interface event.
-
-	  This option provides backward compatibility for libusb device
-	  nodes (lsusb) when usbfs is not used, and the following udev rule
-	  doesn't exist:
-	    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", \
-	    NAME="bus/usb/$env{BUSNUM}/$env{DEVNUM}", MODE="0644"
-
 config USB_DYNAMIC_MINORS
 	bool "Dynamic USB minor allocation"
 	depends on USB
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 8df4b76..b35f61f 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -2062,44 +2062,13 @@ static void usbdev_remove(struct usb_device *udev)
 	}
 }
 
-#ifdef CONFIG_USB_DEVICE_CLASS
-static struct class *usb_classdev_class;
-
-static int usb_classdev_add(struct usb_device *dev)
-{
-	struct device *cldev;
-
-	cldev = device_create(usb_classdev_class, &dev->dev, dev->dev.devt,
-			      NULL, "usbdev%d.%d", dev->bus->busnum,
-			      dev->devnum);
-	if (IS_ERR(cldev))
-		return PTR_ERR(cldev);
-	dev->usb_classdev = cldev;
-	return 0;
-}
-
-static void usb_classdev_remove(struct usb_device *dev)
-{
-	if (dev->usb_classdev)
-		device_unregister(dev->usb_classdev);
-}
-
-#else
-#define usb_classdev_add(dev)		0
-#define usb_classdev_remove(dev)	do {} while (0)
-
-#endif
-
 static int usbdev_notify(struct notifier_block *self,
 			       unsigned long action, void *dev)
 {
 	switch (action) {
 	case USB_DEVICE_ADD:
-		if (usb_classdev_add(dev))
-			return NOTIFY_BAD;
 		break;
 	case USB_DEVICE_REMOVE:
-		usb_classdev_remove(dev);
 		usbdev_remove(dev);
 		break;
 	}
@@ -2129,21 +2098,6 @@ int __init usb_devio_init(void)
 		       USB_DEVICE_MAJOR);
 		goto error_cdev;
 	}
-#ifdef CONFIG_USB_DEVICE_CLASS
-	usb_classdev_class = class_create(THIS_MODULE, "usb_device");
-	if (IS_ERR(usb_classdev_class)) {
-		printk(KERN_ERR "Unable to register usb_device class\n");
-		retval = PTR_ERR(usb_classdev_class);
-		cdev_del(&usb_device_cdev);
-		usb_classdev_class = NULL;
-		goto out;
-	}
-	/* devices of this class shadow the major:minor of their parent
-	 * device, so clear ->dev_kobj to prevent adding duplicate entries
-	 * to /sys/dev
-	 */
-	usb_classdev_class->dev_kobj = NULL;
-#endif
 	usb_register_notify(&usbdev_nb);
 out:
 	return retval;
@@ -2156,9 +2110,6 @@ error_cdev:
 void usb_devio_cleanup(void)
 {
 	usb_unregister_notify(&usbdev_nb);
-#ifdef CONFIG_USB_DEVICE_CLASS
-	class_destroy(usb_classdev_class);
-#endif
 	cdev_del(&usb_device_cdev);
 	unregister_chrdev_region(USB_DEVICE_DEV, USB_DEVICE_MAX);
 }
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 45bc7a5..6d616ce 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -493,9 +493,6 @@ struct usb_device {
 	char *serial;
 
 	struct list_head filelist;
-#ifdef CONFIG_USB_DEVICE_CLASS
-	struct device *usb_classdev;
-#endif
 #ifdef CONFIG_USB_DEVICEFS
 	struct dentry *usbfs_dentry;
 #endif
