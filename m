Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934324Ab2KZRUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:20:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48308 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934221Ab2KZRQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:16:13 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 261/270] qmi_wwan/cdc_ether: move Novatel 551 and E362 to qmi_wwan
Date: Mon, 26 Nov 2012 14:59:11 -0200
Message-Id: <1353949160-26803-262-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit f8295ec22cb0f1ee6849b862addbfa3ea9320755 upstream.

These devices provide QMI and ethernet functionality via a standard CDC
ethernet descriptor.  But when driven by cdc_ether, the QMI
functionality is unavailable because only cdc_ether can claim the USB
interface.  Thus blacklist the devices in cdc_ether and add their IDs to
qmi_wwan, which enables both QMI and ethernet simultaneously.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/usb/cdc_ether.c |   41 ++++++++++++++++++++++++++---------------
 drivers/net/usb/qmi_wwan.c  |   14 ++++++++++++++
 2 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index a03de71..d012982 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -592,6 +592,32 @@ static const struct usb_device_id	products [] = {
 	.driver_info		= 0,
 },
 
+/* Novatel USB551L and MC551 - handled by qmi_wwan */
+{
+	.match_flags    =   USB_DEVICE_ID_MATCH_VENDOR
+		 | USB_DEVICE_ID_MATCH_PRODUCT
+		 | USB_DEVICE_ID_MATCH_INT_INFO,
+	.idVendor               = NOVATEL_VENDOR_ID,
+	.idProduct		= 0xB001,
+	.bInterfaceClass	= USB_CLASS_COMM,
+	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET,
+	.bInterfaceProtocol	= USB_CDC_PROTO_NONE,
+	.driver_info = 0,
+},
+
+/* Novatel E362 - handled by qmi_wwan */
+{
+	.match_flags    =   USB_DEVICE_ID_MATCH_VENDOR
+		 | USB_DEVICE_ID_MATCH_PRODUCT
+		 | USB_DEVICE_ID_MATCH_INT_INFO,
+	.idVendor               = NOVATEL_VENDOR_ID,
+	.idProduct		= 0x9010,
+	.bInterfaceClass	= USB_CLASS_COMM,
+	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET,
+	.bInterfaceProtocol	= USB_CDC_PROTO_NONE,
+	.driver_info = 0,
+},
+
 /*
  * WHITELIST!!!
  *
@@ -604,21 +630,6 @@ static const struct usb_device_id	products [] = {
  * because of bugs/quirks in a given product (like Zaurus, above).
  */
 {
-	/* Novatel USB551L */
-	/* This match must come *before* the generic CDC-ETHER match so that
-	 * we get FLAG_WWAN set on the device, since it's descriptors are
-	 * generic CDC-ETHER.
-	 */
-	.match_flags    =   USB_DEVICE_ID_MATCH_VENDOR
-		 | USB_DEVICE_ID_MATCH_PRODUCT
-		 | USB_DEVICE_ID_MATCH_INT_INFO,
-	.idVendor               = NOVATEL_VENDOR_ID,
-	.idProduct		= 0xB001,
-	.bInterfaceClass	= USB_CLASS_COMM,
-	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET,
-	.bInterfaceProtocol	= USB_CDC_PROTO_NONE,
-	.driver_info = (unsigned long)&wwan_info,
-}, {
 	/* ZTE (Vodafone) K3805-Z */
 	.match_flags    =   USB_DEVICE_ID_MATCH_VENDOR
 		 | USB_DEVICE_ID_MATCH_PRODUCT
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index d124bdd..466af29 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -579,6 +579,20 @@ static const struct usb_device_id products[] = {
 		.bInterfaceProtocol = 0xff,
 		.driver_info        = (unsigned long)&qmi_wwan_sierra,
 	},
+	{	/* Novatel USB551L and MC551 */
+		USB_DEVICE_AND_INTERFACE_INFO(0x1410, 0xb001,
+		                              USB_CLASS_COMM,
+		                              USB_CDC_SUBCLASS_ETHERNET,
+		                              USB_CDC_PROTO_NONE),
+		.driver_info        = (unsigned long)&qmi_wwan_info,
+	},
+	{	/* Novatel E362 */
+		USB_DEVICE_AND_INTERFACE_INFO(0x1410, 0x9010,
+		                              USB_CLASS_COMM,
+		                              USB_CDC_SUBCLASS_ETHERNET,
+		                              USB_CDC_PROTO_NONE),
+		.driver_info        = (unsigned long)&qmi_wwan_info,
+	},
 
 	/* Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
1.7.9.5

