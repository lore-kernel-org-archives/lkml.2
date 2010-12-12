Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab0LMAAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:00:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36530 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab0LLXrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:48 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: stern@rowland.harvard.edu, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [163/223] USB: fix autosuspend bug in usb-serial
Message-Id: <20101212234747.4052EB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/usb-serial.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/drivers/usb/serial/usb-serial.c
===================================================================
--- linux.orig/drivers/usb/serial/usb-serial.c
+++ linux/drivers/usb/serial/usb-serial.c
@@ -52,6 +52,7 @@ static struct usb_driver usb_serial_driv
 	.suspend =	usb_serial_suspend,
 	.resume =	usb_serial_resume,
 	.no_dynamic_id = 	1,
+	.supports_autosuspend =	1,
 };
 
 /* There is no MODULE_DEVICE_TABLE for usbserial.c.  Instead
@@ -1344,6 +1345,8 @@ int usb_serial_register(struct usb_seria
 		return -ENODEV;
 
 	fixup_generic(driver);
+	if (driver->usb_driver)
+		driver->usb_driver->supports_autosuspend = 1;
 
 	if (!driver->description)
 		driver->description = driver->driver.name;
