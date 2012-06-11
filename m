Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2FKXgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 19:36:07 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:60305 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751069Ab2FKXgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 19:36:05 -0400
Message-ID: <4FD680D6.8010509@xenotime.net>
Date: Mon, 11 Jun 2012 16:35:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        devel@driverdev.osuosl.org, USB list <linux-usb@vger.kernel.org>
Subject: [PATCH] staging/comedi: fix build for USB not enabled
References: <Pine.LNX.4.44L0.1205191026400.1348-100000@netrider.rowland.org> <4FB7C0E4.4000008@xenotime.net> <20120611230723.GA25565@kroah.com>
In-Reply-To: <20120611230723.GA25565@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Calls to optional subsystems cannot be made indiscriminately.
Enclose all of the usb helper functions inside
#if IS_ENABLED(CONFIG_USB)
to fix these build errors.

(The pci helper functions are OK since there are stubs in
linux/pci.h for the called functions when PCI is not enabled.
Possibly the same could be done for the called USB functions.)

ERROR: "usb_deregister" [drivers/staging/comedi/comedi.ko] undefined!
ERROR: "usb_register_driver" [drivers/staging/comedi/comedi.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Ian Abbott <abbotti@mev.co.uk>
Cc:	Frank Mori Hess <fmhess@users.sourceforge.net>
---
 drivers/staging/comedi/drivers.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-next-20120518.orig/drivers/staging/comedi/drivers.c
+++ linux-next-20120518/drivers/staging/comedi/drivers.c
@@ -30,6 +30,7 @@
 #include <linux/pci.h>
 #include <linux/usb.h>
 #include <linux/errno.h>
+#include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/fcntl.h>
@@ -981,6 +982,8 @@ void comedi_pci_driver_unregister(struct
 }
 EXPORT_SYMBOL_GPL(comedi_pci_driver_unregister);
 
+#if IS_ENABLED(CONFIG_USB)
+
 static int comedi_old_usb_auto_config(struct usb_interface *intf,
 				      struct comedi_driver *driver)
 {
@@ -1043,3 +1046,5 @@ void comedi_usb_driver_unregister(struct
 	comedi_driver_unregister(comedi_driver);
 }
 EXPORT_SYMBOL_GPL(comedi_usb_driver_unregister);
+
+#endif
