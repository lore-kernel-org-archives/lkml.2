Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2JOFPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 01:15:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48125 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab2JOFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 01:15:34 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-pm@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>
Subject: [RFC PATCH 3/3] USB: forbid memory allocation with I/O during bus reset if storage interface exits
Date: Mon, 15 Oct 2012 13:14:19 +0800
Message-Id: <1350278059-14904-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350278059-14904-1-git-send-email-ming.lei@canonical.com>
References: <1350278059-14904-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one storage interface exists in the device, memory allocation
with GFP_KERNEL during usb_device_reset() might trigger I/O transfer
on the storage interface itself and cause deadlock because the
'us->dev_mutex' is held in .pre_reset() and the storage interface
can't do I/O transfer when the reset is triggered by other
interface, or the error handling can't be completed if the reset
is triggered by mass storage itself(error handling path).

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/usb/core/hub.c    |   42 +++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/storage/uas.c |    4 ++++
 drivers/usb/storage/usb.c |    4 ++++
 include/linux/usb.h       |    1 +
 4 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 9dc8ff2..f6958f7 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5004,6 +5004,33 @@ re_enumerate:
 	return -ENODEV;
 }
 
+static inline int is_bound_usb_storage_intf(struct usb_interface *intf)
+{
+	struct usb_driver *drv;
+
+	if (!intf->dev.driver)
+		return 0;
+
+	drv = to_usb_driver(intf->dev.driver);
+
+	return drv->for_storage;
+}
+
+static inline int has_bound_usb_storage_intf(struct usb_device *udev)
+{
+	struct usb_host_config *config = udev->actconfig;
+
+	if (config) {
+		int i;
+		for (i = 0; i < config->desc.bNumInterfaces; ++i) {
+			struct usb_interface *cintf = config->interface[i];
+			if (is_bound_usb_storage_intf(cintf))
+				return 1;
+		}
+	}
+	return 0;
+}
+
 /**
  * usb_reset_device - warn interface drivers and perform a USB port reset
  * @udev: device to reset (not in SUSPENDED or NOTATTACHED state)
@@ -5027,7 +5054,7 @@ re_enumerate:
 int usb_reset_device(struct usb_device *udev)
 {
 	int ret;
-	int i;
+	int i, no_io = 0;
 	struct usb_host_config *config = udev->actconfig;
 
 	if (udev->state == USB_STATE_NOTATTACHED ||
@@ -5037,6 +5064,15 @@ int usb_reset_device(struct usb_device *udev)
 		return -EINVAL;
 	}
 
+	/*
+	 * If bound mass storage interface exists, don't allocate memory
+	 * with GFP_KERNEL in current context to avoid possible deadlock
+	 */
+	if (has_bound_usb_storage_intf(udev)) {
+		no_io = 1;
+		tsk_memalloc_forbid_io(current);
+	}
+
 	/* Prevent autosuspend during the reset */
 	usb_autoresume_device(udev);
 
@@ -5081,6 +5117,10 @@ int usb_reset_device(struct usb_device *udev)
 	}
 
 	usb_autosuspend_device(udev);
+
+	if (no_io)
+		tsk_memalloc_allow_io(current);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(usb_reset_device);
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 98b98ee..89daecb 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -888,6 +888,10 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	struct Scsi_Host *shost;
 	struct uas_dev_info *devinfo;
 	struct usb_device *udev = interface_to_usbdev(intf);
+	struct usb_driver *drv = to_usb_driver(intf->dev.driver);
+
+	if (!drv->for_storage)
+		drv->for_storage = 1;
 
 	if (uas_switch_interface(udev, intf))
 		return -ENODEV;
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 12aa726..f11ed09 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -905,9 +905,13 @@ int usb_stor_probe1(struct us_data **pus,
 	struct Scsi_Host *host;
 	struct us_data *us;
 	int result;
+	struct usb_driver *drv = to_usb_driver(intf->dev.driver);
 
 	US_DEBUGP("USB Mass Storage device detected\n");
 
+	if (!drv->for_storage)
+		drv->for_storage = 1;
+
 	/*
 	 * Ask the SCSI layer to allocate a host structure, with extra
 	 * space at the end for our private us_data structure.
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 07915a3..3216b00 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1024,6 +1024,7 @@ struct usb_driver {
 	unsigned int supports_autosuspend:1;
 	unsigned int disable_hub_initiated_lpm:1;
 	unsigned int soft_unbind:1;
+	unsigned int for_storage:1;
 };
 #define	to_usb_driver(d) container_of(d, struct usb_driver, drvwrap.driver)
 
-- 
1.7.9.5

