Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab1DNPrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:47:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52210 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759155Ab1DNPr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cvFp2emGzcgjMPTcmcdFeEjPjz2QIsJEQLt9s/YsR8dxjPM5x/0FMPQ6istll04nXO
         kymZKIw5mUBa2W0ytsyA==
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv3] usb: core: Change usb_create_sysfs_intf_files()' return type to void
Date: Thu, 14 Apr 2011 17:47:09 +0200
Message-Id: <8443bc847f5daeb55abbeb779068e7ff7e7332c9.1302795943.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20110413232315.GA9949@kroah.com>
References: <20110413232315.GA9949@kroah.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usb_create_sysfs_intf_files() function always returned zero even
if it failed to create sysfs fails.  Since this is a desired behaviour
there is no need to return return code at all.  This commit changes
function's return type (form int) to void.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/usb/core/sysfs.c |   13 +++++--------
 drivers/usb/core/usb.c   |    3 +--
 drivers/usb/core/usb.h   |    2 +-
 3 files changed, 7 insertions(+), 11 deletions(-)


On Thu, 14 Apr 2011 01:23:15 +0200, Greg KH <greg@kroah.com> wrote:
> I can't find this version of the patch in my email archive anywhere.
>
> Michal, can you resend it so I can apply it?

Here it is.


diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index 6781c36..cf05b97 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -842,22 +842,19 @@ const struct attribute_group *usb_interface_groups[] = {
 	NULL
 };
 
-int usb_create_sysfs_intf_files(struct usb_interface *intf)
+void usb_create_sysfs_intf_files(struct usb_interface *intf)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct usb_host_interface *alt = intf->cur_altsetting;
-	int retval;
 
 	if (intf->sysfs_files_created || intf->unregistering)
-		return 0;
+		return;
 
-	if (alt->string == NULL &&
-			!(udev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
+	if (!alt->string && !(udev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
 		alt->string = usb_cache_string(udev, alt->desc.iInterface);
-	if (alt->string)
-		retval = device_create_file(&intf->dev, &dev_attr_interface);
+	if (alt->string && device_create_file(&intf->dev, &dev_attr_interface))
+		;	/* We don't actually care if the function fails. */
 	intf->sysfs_files_created = 1;
-	return 0;
 }
 
 void usb_remove_sysfs_intf_files(struct usb_interface *intf)
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index d9d4b16..8706fc9 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -953,8 +953,7 @@ static int usb_bus_notify(struct notifier_block *nb, unsigned long action,
 		if (dev->type == &usb_device_type)
 			(void) usb_create_sysfs_dev_files(to_usb_device(dev));
 		else if (dev->type == &usb_if_device_type)
-			(void) usb_create_sysfs_intf_files(
-					to_usb_interface(dev));
+			usb_create_sysfs_intf_files(to_usb_interface(dev));
 		break;
 
 	case BUS_NOTIFY_DEL_DEVICE:
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index d450b74..d44d4b7 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -4,7 +4,7 @@
 
 extern int usb_create_sysfs_dev_files(struct usb_device *dev);
 extern void usb_remove_sysfs_dev_files(struct usb_device *dev);
-extern int usb_create_sysfs_intf_files(struct usb_interface *intf);
+extern void usb_create_sysfs_intf_files(struct usb_interface *intf);
 extern void usb_remove_sysfs_intf_files(struct usb_interface *intf);
 extern int usb_create_ep_devs(struct device *parent,
 				struct usb_host_endpoint *endpoint,
-- 
1.7.3.1

