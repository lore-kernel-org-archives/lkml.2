Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab0LHBd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:33:56 -0500
Received: from kroah.org ([198.145.64.141]:49030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184Ab0LHBBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:35 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:35 2010
Message-Id: <20101208005735.503461799@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Brownell <dbrownell@users.sourceforge.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>, Joe Perches <joe@perches.com>,
        Oliver Neukum <oliver@neukum.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>
Subject: [141/289] usbnet: fix usb_autopm_get_interface failure(v1)
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/net/usb/usbnet.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -45,6 +45,7 @@
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
+#include <linux/pm_runtime.h>
 
 #define DRIVER_VERSION		"22-Aug-2005"
 
@@ -1273,6 +1274,16 @@ usbnet_probe (struct usb_interface *udev
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


