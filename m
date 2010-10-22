Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab0JVTY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:24:56 -0400
Received: from kroah.org ([198.145.64.141]:33908 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab0JVSzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:53 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:28 2010
Message-Id: <20101022185228.029323489@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>
Subject: [008/103] USB: fix bug in initialization of interface minor numbers
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 0026e00523a85b90a92a93ddf6660939ecef3e54 upstream.

Recent changes in the usbhid layer exposed a bug in usbcore.  If
CONFIG_USB_DYNAMIC_MINORS is enabled then an interface may be assigned
a minor number of 0.  However interfaces that aren't registered as USB
class devices also have their minor number set to 0, during
initialization.  As a result usb_find_interface() may return the
wrong interface, leading to a crash.

This patch (as1418) fixes the problem by initializing every
interface's minor number to -1.  It also cleans up the
usb_register_dev() function, which besides being somewhat awkwardly
written, does not unwind completely on all its error paths.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Philip J. Turmel <philip@turmel.org>
Tested-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Tested-by: Alex Riesen <raa.lkml@gmail.com>
Tested-by: Matthias Bayer <jackdachef@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/file.c    |   35 ++++++++++++++++-------------------
 drivers/usb/core/message.c |    1 +
 2 files changed, 17 insertions(+), 19 deletions(-)

--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -159,9 +159,9 @@ void usb_major_cleanup(void)
 int usb_register_dev(struct usb_interface *intf,
 		     struct usb_class_driver *class_driver)
 {
-	int retval = -EINVAL;
+	int retval;
 	int minor_base = class_driver->minor_base;
-	int minor = 0;
+	int minor;
 	char name[20];
 	char *temp;
 
@@ -173,12 +173,17 @@ int usb_register_dev(struct usb_interfac
 	 */
 	minor_base = 0;
 #endif
-	intf->minor = -1;
-
-	dbg ("looking for a minor, starting at %d", minor_base);
 
 	if (class_driver->fops == NULL)
-		goto exit;
+		return -EINVAL;
+	if (intf->minor >= 0)
+		return -EADDRINUSE;
+
+	retval = init_usb_class();
+	if (retval)
+		return retval;
+
+	dev_dbg(&intf->dev, "looking for a minor, starting at %d", minor_base);
 
 	down_write(&minor_rwsem);
 	for (minor = minor_base; minor < MAX_USB_MINORS; ++minor) {
@@ -186,20 +191,12 @@ int usb_register_dev(struct usb_interfac
 			continue;
 
 		usb_minors[minor] = class_driver->fops;
-
-		retval = 0;
+		intf->minor = minor;
 		break;
 	}
 	up_write(&minor_rwsem);
-
-	if (retval)
-		goto exit;
-
-	retval = init_usb_class();
-	if (retval)
-		goto exit;
-
-	intf->minor = minor;
+	if (intf->minor < 0)
+		return -EXFULL;
 
 	/* create a usb class device for this usb interface */
 	snprintf(name, sizeof(name), class_driver->name, minor - minor_base);
@@ -213,11 +210,11 @@ int usb_register_dev(struct usb_interfac
 				      "%s", temp);
 	if (IS_ERR(intf->usb_dev)) {
 		down_write(&minor_rwsem);
-		usb_minors[intf->minor] = NULL;
+		usb_minors[minor] = NULL;
+		intf->minor = -1;
 		up_write(&minor_rwsem);
 		retval = PTR_ERR(intf->usb_dev);
 	}
-exit:
 	return retval;
 }
 EXPORT_SYMBOL_GPL(usb_register_dev);
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1802,6 +1802,7 @@ free_interfaces:
 		intf->dev.groups = usb_interface_groups;
 		intf->dev.dma_mask = dev->dev.dma_mask;
 		INIT_WORK(&intf->reset_ws, __usb_queue_reset_device);
+		intf->minor = -1;
 		device_initialize(&intf->dev);
 		dev_set_name(&intf->dev, "%d-%s:%d.%d",
 			dev->bus->busnum, dev->devpath,


