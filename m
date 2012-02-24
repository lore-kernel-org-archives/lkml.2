Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab2BXXiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 18:38:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51549 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab2BXXiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 18:38:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.212.73 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 15:38:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] USB: create module_usb_serial_driver macro
Message-ID: <20120224233814.GA16588@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that Alan Stern has cleaned up the usb serial driver registration,
we have the ability to create a module_usb_serial_driver macro to make
things a bit simpler, like the other *_driver macros created.

But, as we need two functions here, we can't reuse the existing
module_driver() macro, so we need to roll our own.

Lars-Peter, or anyone else, am I missing something here and we can use
module_driver() somehow, or even modify it, to work for subsystems that
need 2 parameters for their function calls to register/deregister?

Actually, if we want to be tricky, we can go back to assigning the
usb_driver in the usb_serial_driver structure, and just use that pointer
in the first structure in the list as that option, but that's getting
pretty opaque just to reuse a single macro...

Thoughts anyone?

thanks,

greg k-h


Here's a patch implementing module_usb_serial_driver() and it converts
the pl2303 driver to use it, showing a nice cleanup.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>



--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -855,23 +855,7 @@ static struct usb_serial_driver * const serial_drivers[] = {
 	&pl2303_device, NULL
 };
 
-static int __init pl2303_init(void)
-{
-	int retval;
-
-	retval = usb_serial_register_drivers(&pl2303_driver, serial_drivers);
-	if (retval == 0)
-		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC "\n");
-	return retval;
-}
-
-static void __exit pl2303_exit(void)
-{
-	usb_serial_deregister_drivers(&pl2303_driver, serial_drivers);
-}
-
-module_init(pl2303_init);
-module_exit(pl2303_exit);
+module_usb_serial_driver(pl2303_driver, serial_drivers);
 
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 34c06a7..7b1db84 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -406,5 +406,33 @@ do {									\
 	}								\
 } while (0)
 
+/*
+ * module_usb_serial_driver() - Helper macro for registering a USB Serial driver
+ * @__usb_driver: usb_driver struct to register
+ * @__serial_drivers: list of usb_serial drivers to register
+ *
+ * Helper macro for USB serial drivers which do not do anything special
+ * in module init/exit. This eliminates a lot of boilerplate. Each
+ * module may only use this macro once, and calling it replaces
+ * module_init() and module_exit()
+ *
+ * Note, we can't use the generic module_driver() call here, due to the
+ * two parameters in the usb_serial_* functions, so we roll our own here
+ * :(
+ */
+#define module_usb_serial_driver(__usb_driver, __serial_drivers)	\
+static int __init usb_serial_driver_init(void)				\
+{									\
+	return usb_serial_register_drivers(&(__usb_driver),		\
+					   (__serial_drivers));		\
+}									\
+module_init(usb_serial_driver_init);					\
+static void __exit usb_serial_driver_exit(void)				\
+{									\
+	return usb_serial_deregister_drivers(&(__usb_driver),		\
+					     (__serial_drivers));	\
+}									\
+module_exit(usb_serial_driver_exit);
+
 #endif /* __LINUX_USB_SERIAL_H */
 
