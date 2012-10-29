Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464Ab2J2V67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:58:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:48029 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761383Ab2J2ViF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:38:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dcbw@redhat.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20084/101=5D=20qmi=5Fwwan/cdc=5Fether=3A=20move=20Novatel=20551=20and=20E362=20to=20qmi=5Fwwan?=
Date: Mon, 29 Oct 2012 14:35:37 -0700
Message-Id: <20121029213249.649926820@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/cdc_ether.c |   41 ++++++++++++++++++++++++++---------------
 drivers/net/usb/qmi_wwan.c  |   14 ++++++++++++++
 2 files changed, 40 insertions(+), 15 deletions(-)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -592,6 +592,32 @@ static const struct usb_device_id	produc
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
@@ -604,21 +630,6 @@ static const struct usb_device_id	produc
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
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -364,6 +364,20 @@ static const struct usb_device_id produc
 		USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, USB_CLASS_VENDOR_SPEC, 1, 57),
 		.driver_info        = (unsigned long)&qmi_wwan_info,
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
 
 	/* 2. Combined interface devices matching on class+protocol */
 	{	/* Huawei E367 and possibly others in "Windows mode" */


