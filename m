Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab0LHBT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:19:29 -0500
Received: from kroah.org ([198.145.64.141]:33632 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606Ab0LHBDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:12 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:43 2010
Message-Id: <20101208005743.173251953@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [217/289] USB: fix autosuspend bug in usb-serial
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit abf03184a31a3286fc0ab30f838ddee8ba9f9b7b upstream.

This patch (as1437) fixes a bug in the usb-serial autosuspend
handling.  Since the usb-serial core now has autosuspend support, it
must set the .supports_autosuspend member in every serial driver it
registers.  Otherwise the usb_autopm_get_interface() call won't work.

This fixes Bugzilla #23012.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Kevin Smith <thirdwiggin@gmail.com>
Reported-and-tested-by: Simon Gerber <gesimu@gmail.com>
Reported-and-tested-by: Matteo Croce <matteo@openwrt.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -52,6 +52,7 @@ static struct usb_driver usb_serial_driv
 	.suspend =	usb_serial_suspend,
 	.resume =	usb_serial_resume,
 	.no_dynamic_id = 	1,
+	.supports_autosuspend =	1,
 };
 
 /* There is no MODULE_DEVICE_TABLE for usbserial.c.  Instead
@@ -1331,6 +1332,8 @@ int usb_serial_register(struct usb_seria
 		return -ENODEV;
 
 	fixup_generic(driver);
+	if (driver->usb_driver)
+		driver->usb_driver->supports_autosuspend = 1;
 
 	if (!driver->description)
 		driver->description = driver->driver.name;


