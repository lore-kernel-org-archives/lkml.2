Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968235Ab2ESAqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:46:09 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:39931 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758797Ab2ESAqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:46:07 -0400
Message-ID: <4FB6ED55.6090805@xenotime.net>
Date: Fri, 18 May 2012 17:46:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        devel@driverdev.osuosl.org
Subject: [PATCH -next] comedi: fix build when USB is not enabled
References: <20120518184943.2c762e8441e53ea24748d1b8@canb.auug.org.au>
In-Reply-To: <20120518184943.2c762e8441e53ea24748d1b8@canb.auug.org.au>
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
