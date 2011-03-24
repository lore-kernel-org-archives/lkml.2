Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1CXPNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:13:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61258 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1CXPNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:13:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VUFM+RT2BjKHnBWMoEvSS10J6hnSyf9LLcd168Jm3/zEJ0xEfQTtp3D/LHMq9EZ3Gl
         xz6HL342UjGUylDUs3Pw==
From: Michal Nazarewicz <mnazarewicz@google.com>
To: "Alan Stern" <stern@rowland.harvard.edu>,
        "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Chris Wright" <chrisw@sous-sol.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] usb: core: Change usb_create_sysfs_intf_files()' return type to void
Date: Thu, 24 Mar 2011 16:13:41 +0100
Message-Id: <7269aca0469928347bbff55c8c2efd1c86cf1f4b.1300979212.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
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
 drivers/usb/core/sysfs.c |    7 +++----
 drivers/usb/core/usb.c   |    3 +--
 drivers/usb/core/usb.h   |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

The below patch has not been tested (not even compiled), just a quick scatch.

> On Thu, 24 Mar 2011, Sergey Senozhatsky wrote:
>> I just noticed that usb_create_sysfs_intf_files() ignores  
>> device_create_file() return code and sets intf->sysfs_files_created
>> to 1, even if sysfs_add_file_mode() returned -ENOMEM (or later
>> sysfs_add_one() returned -EEXIST).
>>
>> Shouldn't we check retval for 0 before setting  
>> intf->sysfs_files_created?

On Thu, 24 Mar 2011 15:55:08 +0100, Alan Stern <stern@rowland.harvard.edu> wrote:
> No.  We want this routine to succeed even if the sysfs files can't be
> created.  The interface string attribute is more or less optional.
>
> It would be okay to add a comment explaining this, so that other people
> don't make the same mistake (which has already happened -- you're not
> the first).

Can we also drop the return value completely then?


diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index 6781c36..e729480 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -842,11 +842,10 @@ const struct attribute_group *usb_interface_groups[] = {
 	NULL
 };
 
-int usb_create_sysfs_intf_files(struct usb_interface *intf)
+void usb_create_sysfs_intf_files(struct usb_interface *intf)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct usb_host_interface *alt = intf->cur_altsetting;
-	int retval;
 
 	if (intf->sysfs_files_created || intf->unregistering)
 		return 0;
@@ -855,9 +854,9 @@ int usb_create_sysfs_intf_files(struct usb_interface *intf)
 			!(udev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
 		alt->string = usb_cache_string(udev, alt->desc.iInterface);
 	if (alt->string)
-		retval = device_create_file(&intf->dev, &dev_attr_interface);
+		/* We don't care if the function actually fails. */
+		device_create_file(&intf->dev, &dev_attr_interface);
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

