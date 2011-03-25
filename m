Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab1CYLnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:43:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:43997 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1CYLnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:43:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PD+oSS0dkJuBVE8UnOtDcA89KiiKEwFcnroHmJ4WVeBRZGyKU13YhISJ6CcW9Nqspf
         C9ufFtYB6k3iDt8XwL2w==
From: Michal Nazarewicz <mnazarewicz@google.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>,
        "Chris Wright" <chrisw@sous-sol.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv2] usb: core: Change usb_create_sysfs_intf_files()' return type to void
Date: Fri, 25 Mar 2011 12:22:26 +0100
Message-Id: <531a6364dd1220278e76479423ce697e32bf4082.1301003830.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <Pine.LNX.4.44L0.1103241150210.2006-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1103241150210.2006-100000@iolanthe.rowland.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

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

diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index 6781c36..f5b7b1c 100644
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
+		/* We don't actually care if the function fails. */;
 	intf->sysfs_files_created = 1;
-	return 0;
 }
 
 void usb_remove_sysfs_intf_files(struct usb_interface *intf)
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 079cb57..08b74f8 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -948,8 +948,7 @@ static int usb_bus_notify(struct notifier_block *nb, unsigned long action,
 		if (dev->type == &usb_device_type)
 			(void) usb_create_sysfs_dev_files(to_usb_device(dev));
 		else if (dev->type == &usb_if_device_type)
-			(void) usb_create_sysfs_intf_files(
-					to_usb_interface(dev));
+			usb_create_sysfs_intf_files(to_usb_interface(dev));
 		break;
 
 	case BUS_NOTIFY_DEL_DEVICE:
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index a9cf484..d51ab6a 100644
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

