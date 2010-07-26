Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab0GZIrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:47:35 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50642 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab0GZIre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:47:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: TEXT/PLAIN; CHARSET=EUC-KR
Date: Mon, 26 Jul 2010 10:48:45 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: file_storage: serial parameter even if not test
 mode
In-reply-to: <5A47E75E594F054BAF48C5E4FC4B92AB0323C3F5D1@dbde02.ent.ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Anand Gadiyar <gadiyar@ti.com>
Cc: linux-usb@vger.kernel.org, Yann Cantin <yann.cantin@laposte.net>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Message-id: <111d87fe40811e385a56992567b0a6be1911e2fe.1280133527.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <5A47E75E594F054BAF48C5E4FC4B92AB0323C3F5D1@dbde02.ent.ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved the serial parameter handling code out of "#ifdef
CONFIG_USB_FILE_STORAGE_TEST".  This fixes the bug where
serial was not set if CONFIG_USB_FILE_STORAGE_TEST was not
defined.  It also makes the serial module parameter work
without this option.

This modifies Yann Cantin's commit "USB: Add a serial number
parameter to g_file_storage" module as per Alan Stern's request.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Yann Cantin <yann.cantin@laposte.net>
---
Alan Stern wrote:
> I have only one objection to this [Yann Cantin's] patch: The new
> parameter's name should be "serial", not "serial_parm".

Alan Stern wrote:
> The serial number parameter is important enough that it should be
> available even on builds without CONFIG_USB_FILE_STORAGE_TEST.


>> Anand Gadiyar wrote:
>>> The following patch from the gregkh-07-usb-2.6.35-rc5.patch patchset
>>> breaks g_file_storage, at least on omap3/4 boards.
>>>
>>> <http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/usb/usb-add-a-serial-number-parameter-to-g_file_storage-module.patch>

> Michał Nazarewicz wrote:
>> Try applying <https://patchwork.kernel.org/patch/113580/>

Anand Gadiyar wrote:
> Thanks! This patch makes g_file_storage work again. It applies on
> top of greg's queue, but with some offsets.
>
> If you're re-submitting it, feel free to add my
>
> Tested-by: Anand Gadiyar <gadiyar@ti.com>


Resending version rebased on Friday's -next.


 drivers/usb/gadget/file_storage.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 88e5ad2..a857b7a 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -321,7 +321,7 @@ static struct {
 	unsigned short	vendor;
 	unsigned short	product;
 	unsigned short	release;
-	char		*serial_parm;
+	char		*serial;
 	unsigned int	buflen;
 
 	int		transport_type;
@@ -365,6 +365,8 @@ MODULE_PARM_DESC(stall, "false to prevent bulk stalls");
 module_param_named(cdrom, mod_data.cdrom, bool, S_IRUGO);
 MODULE_PARM_DESC(cdrom, "true to emulate cdrom instead of disk");
 
+module_param_named(serial, mod_data.serial, charp, S_IRUGO);
+MODULE_PARM_DESC(serial, "USB serial number");
 
 /* In the non-TEST version, only the module parameters listed above
  * are available. */
@@ -386,9 +388,6 @@ MODULE_PARM_DESC(product, "USB Product ID");
 module_param_named(release, mod_data.release, ushort, S_IRUGO);
 MODULE_PARM_DESC(release, "USB release number");
 
-module_param_named(serial, mod_data.serial_parm, charp, S_IRUGO);
-MODULE_PARM_DESC(serial, "USB serial number");
-
 module_param_named(buflen, mod_data.buflen, uint, S_IRUGO);
 MODULE_PARM_DESC(buflen, "I/O buffer size");
 
@@ -3291,10 +3290,12 @@ static int __init check_parameters(struct fsg_dev *fsg)
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
 
@@ -3303,7 +3304,7 @@ static int __init check_parameters(struct fsg_dev *fsg)
 		 * 12 uppercase hexadecimal characters.
 		 * BBB need at least 12 uppercase hexadecimal characters,
 		 * with a maximum of 126. */
-		for (ch = mod_data.serial_parm; *ch; ++ch) {
+		for (ch = mod_data.serial; *ch; ++ch) {
 			++len;
 			if ((*ch < '0' || *ch > '9') &&
 			    (*ch < 'A' || *ch > 'F')) { /* not uppercase hex */
@@ -3322,8 +3323,11 @@ static int __init check_parameters(struct fsg_dev *fsg)
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
@@ -3339,8 +3343,6 @@ fill_serial:
 		}
 	}
 
-#endif /* CONFIG_USB_FILE_STORAGE_TEST */
-
 	return 0;
 }
 
-- 
1.7.1

