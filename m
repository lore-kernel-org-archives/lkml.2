Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0LLXqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36102 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab0LLXqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:40 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: tom.leiming@gmail.com, dbrownell@users.sourceforge.net,
        davem@davemloft.net, ben@decadent.org.uk, joe@perches.com,
        oliver@neukum.org, andy.shevchenko@gmail.com, davem@davemloft.net,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [99/223] usbnet: fix usb_autopm_get_interface failure(v1)
Message-Id: <20101212234639.6CED9B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ming Lei <tom.leiming@gmail.com>

commit b0786b430c982dffbb44d8030e6b6088671ce745 upstream.

Since usbnet already took usb runtime pm, we have to
enable runtime pm for usb interface of usbnet, otherwise
usb_autopm_get_interface may return failure and cause
'ifconfig usb0 up' failed if USB_SUSPEND(RUNTIME_PM) is
enabled.

Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Joe Perches <joe@perches.com>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/usb/usbnet.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux/drivers/net/usb/usbnet.c
===================================================================
--- linux.orig/drivers/net/usb/usbnet.c
+++ linux/drivers/net/usb/usbnet.c
@@ -44,6 +44,7 @@
 #include <linux/usb.h>
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 
 #define DRIVER_VERSION		"22-Aug-2005"
 
@@ -1272,6 +1273,16 @@ usbnet_probe (struct usb_interface *udev
 	struct usb_device		*xdev;
 	int				status;
 	const char			*name;
+	struct usb_driver 	*driver = to_usb_driver(udev->dev.driver);
+
+	/* usbnet already took usb runtime pm, so have to enable the feature
+	 * for usb interface, otherwise usb_autopm_get_interface may return
+	 * failure if USB_SUSPEND(RUNTIME_PM) is enabled.
+	 */
+	if (!driver->supports_autosuspend) {
+		driver->supports_autosuspend = 1;
+		pm_runtime_enable(&udev->dev);
+	}
 
 	name = udev->dev.driver->name;
 	info = (struct driver_info *) prod->driver_info;
