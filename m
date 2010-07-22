Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab0GVMPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:15:33 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58574 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab0GVMPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:15:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 22 Jul 2010 14:16:37 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 5/5] USB: gadget: file_storage: serial parameter even if not
 test mode
In-reply-to: <d58a19b7f466f052fe4d7048bcb28ef883bb71c1.1279794290.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Yann Cantin <yann.cantin@laposte.net>
Message-id: <709d887b2249e9651060729eb62b29a1d3edc256.1279794290.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
 <89baa7d196b5e1d8427c90a78f2aa0cda4331d7a.1279794289.git.m.nazarewicz@samsung.com>
 <c50b89e66cc80f2f89e5c7d4948969e167eb9185.1279794289.git.m.nazarewicz@samsung.com>
 <1dece38844f330c5850cb021705c41a3be92c40d.1279794290.git.m.nazarewicz@samsung.com>
 <d58a19b7f466f052fe4d7048bcb28ef883bb71c1.1279794290.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved the serial parameter handling code out of "#ifdef
CONFIG_USB_FILE_STORAGE_TEST".

This modifies Yann Cantin's commit "USB: Add a serial number
parameter to g_file_storage" module as per Alan Stern's request.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Yann Cantin <yann.cantin@laposte.net>
---
Alan Stern wrote:
> I have only one objection to this [Yann Cantin's] patch: The new
> parameter's name should be "serial", not "serial_parm".

Alan Stern wrote:
> The serial number parameter is important enough that it should be
> available even on builds without CONFIG_USB_FILE_STORAGE_TEST.

 drivers/usb/gadget/file_storage.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index d57c09f..41af34c 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -317,7 +317,7 @@ static struct {
 	unsigned short	vendor;
 	unsigned short	product;
 	unsigned short	release;
-	char		*serial_parm;
+	char		*serial;
 	unsigned int	buflen;
 
 	int		transport_type;
@@ -357,6 +357,8 @@ MODULE_PARM_DESC(stall, "false to prevent bulk stalls");
 module_param_named(cdrom, mod_data.cdrom, bool, S_IRUGO);
 MODULE_PARM_DESC(cdrom, "true to emulate cdrom instead of disk");
 
+module_param_named(serial, mod_data.serial, charp, S_IRUGO);
+MODULE_PARM_DESC(serial, "USB serial number");
 
 /* In the non-TEST version, only the module parameters listed above
  * are available. */
@@ -378,9 +380,6 @@ MODULE_PARM_DESC(product, "USB Product ID");
 module_param_named(release, mod_data.release, ushort, S_IRUGO);
 MODULE_PARM_DESC(release, "USB release number");
 
-module_param_named(serial, mod_data.serial_parm, charp, S_IRUGO);
-MODULE_PARM_DESC(serial, "USB serial number");
-
 module_param_named(buflen, mod_data.buflen, uint, S_IRUGO);
 MODULE_PARM_DESC(buflen, "I/O buffer size");
 
@@ -3281,10 +3280,12 @@ static int __init check_parameters(struct fsg_dev *fsg)
 		return -ETOOSMALL;
 	}
 
+#endif /* CONFIG_USB_FILE_STORAGE_TEST */
+
 	/* Serial string handling.
 	 * On a real device, the serial string would be loaded
 	 * from permanent storage. */
-	if (mod_data.serial_parm) {
+	if (mod_data.serial) {
 		const char *ch;
 		unsigned len = 0;
 
@@ -3293,7 +3294,7 @@ static int __init check_parameters(struct fsg_dev *fsg)
 		 * 12 uppercase hexadecimal characters.
 		 * BBB need at least 12 uppercase hexadecimal characters,
 		 * with a maximum of 126. */
-		for (ch = mod_data.serial_parm; *ch; ++ch) {
+		for (ch = mod_data.serial; *ch; ++ch) {
 			++len;
 			if ((*ch < '0' || *ch > '9') &&
 			    (*ch < 'A' || *ch > 'F')) { /* not uppercase hex */
@@ -3312,8 +3313,11 @@ static int __init check_parameters(struct fsg_dev *fsg)
 				"Failing back to default\n");
 			goto fill_serial;
 		}
-		fsg_strings[FSG_STRING_SERIAL - 1].s = mod_data.serial_parm;
+		fsg_strings[FSG_STRING_SERIAL - 1].s = mod_data.serial;
 	} else {
+		WARNING(fsg,
+			"Userspace failed to provide serial number; "
+			"Failing back to default\n");
 fill_serial:
 		/* Serial number not specified or invalid, make our own.
 		 * We just encode it from the driver version string,
@@ -3329,8 +3333,6 @@ fill_serial:
 		}
 	}
 
-#endif /* CONFIG_USB_FILE_STORAGE_TEST */
-
 	return 0;
 }
 
-- 
1.7.1

