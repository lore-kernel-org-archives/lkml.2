Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab0GHUvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:51:21 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26002 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab0GHUvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:51:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Thu, 08 Jul 2010 22:52:27 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv3 2/3] USB: Add a serial number parameter to g_file_storage
 module
In-reply-to: <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
To: m.nazarewicz@samsung.com
Cc: mina86@mina86.com, Yann Cantin <yann.cantin@laposte.net>,
       Greg KH <greg@kroah.com>, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Message-id: <d11707c57b68ae8112c3fd0de4eab9fcde8cb760.1278619472.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <20100708183425.GB31823@kroah.com>
 <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yann Cantin <yann.cantin@laposte.net>

This patch add a serial number parameter to the g_file_storage
module. There's validity checks against the string passed to comply
with the specs.

Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
[m.nazarewicz@samsung.com: modified to use fsg_string_serial_fill]
Cc: Michał Nazarewicz <m.nazarewicz@samsung.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/gadget/file_storage.c |   54 ++++++++++++++++++++++++++++++++++--
 1 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index f1e6956..9663176 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -56,7 +56,7 @@
  * following protocols: RBC (0x01), ATAPI or SFF-8020i (0x02), QIC-157 (0c03),
  * UFI (0x04), SFF-8070i (0x05), and transparent SCSI (0x06), selected by
  * the optional "protocol" module parameter.  In addition, the default
- * Vendor ID, Product ID, and release number can be overridden.
+ * Vendor ID, Product ID, release number and serial number can be overridden.
  *
  * There is support for multiple logical units (LUNs), each of which has
  * its own backing file.  The number of LUNs can be set using the optional
@@ -106,6 +106,7 @@
  *	vendor=0xVVVV		Default 0x0525 (NetChip), USB Vendor ID
  *	product=0xPPPP		Default 0xa4a5 (FSG), USB Product ID
  *	release=0xRRRR		Override the USB release number (bcdDevice)
+ *	serial=HHHH...		Override serial number (string of hex chars)
  *	buflen=N		Default N=16384, buffer size used (will be
  *					rounded down to a multiple of
  *					PAGE_CACHE_SIZE)
@@ -270,6 +271,8 @@
 
 #define DRIVER_DESC		"File-backed Storage Gadget"
 #define DRIVER_NAME		"g_file_storage"
+/* DRIVER_VERSION must be at least 6 characters long, as it is used
+ * to generate a fallback serial number. */
 #define DRIVER_VERSION		"20 November 2008"
 
 static       char fsg_string_manufacturer[64];
@@ -314,6 +317,7 @@ static struct {
 	unsigned short	vendor;
 	unsigned short	product;
 	unsigned short	release;
+	char		*serial_parm;
 	unsigned int	buflen;
 
 	int		transport_type;
@@ -374,6 +378,9 @@ MODULE_PARM_DESC(product, "USB Product ID");
 module_param_named(release, mod_data.release, ushort, S_IRUGO);
 MODULE_PARM_DESC(release, "USB release number");
 
+module_param_named(serial, mod_data.serial_parm, charp, S_IRUGO);
+MODULE_PARM_DESC(serial, "USB serial number");
+
 module_param_named(buflen, mod_data.buflen, uint, S_IRUGO);
 MODULE_PARM_DESC(buflen, "I/O buffer size");
 
@@ -3197,6 +3204,7 @@ static int __init check_parameters(struct fsg_dev *fsg)
 {
 	int	prot;
 	int	gcnum;
+	int	i;
 
 	/* Store the default values */
 	mod_data.transport_type = USB_PR_BULK;
@@ -3272,6 +3280,48 @@ static int __init check_parameters(struct fsg_dev *fsg)
 		ERROR(fsg, "invalid buflen\n");
 		return -ETOOSMALL;
 	}
+
+	/* Serial string handling.
+	 * On a real device, the serial string would be loaded
+	 * from permanent storage. */
+	if (mod_data.serial_parm) {
+		const char *ch;
+		unsigned len = 0;
+
+		/* Sanity check :
+		 * The CB[I] specification limits the serial string to
+		 * 12 uppercase hexadecimal characters.
+		 * BBB need at least 12 uppercase hexadecimal characters,
+		 * with a maximum of 126. */
+		for (ch = mod_data.serial_parm; *ch; ++ch) {
+			++len;
+			if ((*ch < '0' || *ch > '9') &&
+			    (*ch < 'A' || *ch > 'F')) { /* not uppercase hex */
+				WARNING(fsg,
+					"Invalid serial string character: %c; "
+					"Failing back to default\n",
+					*ch);
+				goto fill_serial;
+			}
+		}
+		if (len > 126 ||
+		    (mod_data.transport_type == USB_PR_BULK && len < 12) ||
+		    (mod_data.transport_type != USB_PR_BULK && len > 12)) {
+			WARNING(fsg,
+				"Invalid serial string length; "
+				"Failing back to default\n");
+			goto fill_serial;
+		}
+		fsg_strings[FSG_STRING_SERIAL - 1].s = mod_data.serial_parm;
+	} else {
+fill_serial:
+		fsg_string_serial_fill(fsg_string_serial, DRIVER_VERSION);
+	}
+
+#else /* !CONFIG_USB_FILE_STORAGE_TEST */
+
+	fsg_string_serial_fill(fsg_string_serial, DRIVER_VERSION);
+
 #endif /* CONFIG_USB_FILE_STORAGE_TEST */
 
 	return 0;
@@ -3447,8 +3497,6 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 			init_utsname()->sysname, init_utsname()->release,
 			gadget->name);
 
-	fsg_string_serial_fill(fsg_string_serial, DRIVER_VERSION);
-
 	fsg->thread_task = kthread_create(fsg_main_thread, fsg,
 			"file-storage-gadget");
 	if (IS_ERR(fsg->thread_task)) {
-- 
1.7.1

