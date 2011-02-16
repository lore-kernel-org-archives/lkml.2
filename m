Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab1BPCQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:16:04 -0500
Received: from kroah.org ([198.145.64.141]:38681 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660Ab1BPASg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:18:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:27 2011
Message-Id: <20110216001427.636758941@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        Roland Kletzing <devzero@web.de>, "Craig W. Nadler" <craig@nadler.us>
Subject: [026/272] USB: g_printer: fix bug in unregistration
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit d5aa475180d03d45c5dc6134aa833f1b3e89c45e upstream.

This patch (as1441) fixes a bug in g_printer.  The gadget driver, char
device number, and class device should be unregistered in reverse
order of registration.  As it is now, when the module is unloaded the
class device gets unregistered first, causing a crash when the unbind
method tries to access it.

This fixes Bugzilla #25882.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Roland Kletzing <devzero@web.de>
CC: Craig W. Nadler <craig@nadler.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/printer.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1596,13 +1596,12 @@ cleanup(void)
 	int status;
 
 	mutex_lock(&usb_printer_gadget.lock_printer_io);
-	class_destroy(usb_gadget_class);
-	unregister_chrdev_region(g_printer_devno, 2);
-
 	status = usb_gadget_unregister_driver(&printer_driver);
 	if (status)
 		ERROR(dev, "usb_gadget_unregister_driver %x\n", status);
 
+	unregister_chrdev_region(g_printer_devno, 2);
+	class_destroy(usb_gadget_class);
 	mutex_unlock(&usb_printer_gadget.lock_printer_io);
 }
 module_exit(cleanup);


