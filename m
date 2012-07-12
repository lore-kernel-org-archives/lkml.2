Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161981Ab2GLX2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:28:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161872Ab2GLWlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:41:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Heinrich Siebmanns (Harvey)" <H.Siebmanns@t-online.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?y?q?=5B=20108/187=5D=20net=3A=20qmi=5Fwwan=3A=20fix=20Gobi=20device=20probing?=
Date: Thu, 12 Jul 2012 15:34:24 -0700
Message-Id: <20120712191532.402055704@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit b9f90eb2740203ff2592efe640409ad48335d1c2 upstream.

Ignoring interfaces with additional descriptors is not a reliable
method for locating the correct interface on Gobi devices.  There
is at least one device where this method fails:
https://bbs.archlinux.org/viewtopic.php?id=143506

The result is that the AT command port (interface #2) is hidden
from qcserial, preventing traditional serial modem usage:

[   15.562552] qmi_wwan 4-1.6:1.0: cdc-wdm0: USB WDM device
[   15.562691] qmi_wwan 4-1.6:1.0: wwan0: register 'qmi_wwan' at usb-0000:00:1d.0-1.6, Qualcomm Gobi wwan/QMI device, 1e:df:3c:3a:4e:3b
[   15.563383] qmi_wwan: probe of 4-1.6:1.1 failed with error -22
[   15.564189] qmi_wwan 4-1.6:1.2: cdc-wdm1: USB WDM device
[   15.564302] qmi_wwan 4-1.6:1.2: wwan1: register 'qmi_wwan' at usb-0000:00:1d.0-1.6, Qualcomm Gobi wwan/QMI device, 1e:df:3c:3a:4e:3b
[   15.564328] qmi_wwan: probe of 4-1.6:1.3 failed with error -22
[   15.569376] qcserial 4-1.6:1.1: Qualcomm USB modem converter detected
[   15.569440] usb 4-1.6: Qualcomm USB modem converter now attached to ttyUSB0
[   15.570372] qcserial 4-1.6:1.3: Qualcomm USB modem converter detected
[   15.570430] usb 4-1.6: Qualcomm USB modem converter now attached to ttyUSB1

Use static interface numbers taken from the interface map in
qcserial for all Gobi devices instead:

	Gobi 1K USB layout:
	0: serial port (doesn't respond)
	1: serial port (doesn't respond)
	2: AT-capable modem port
	3: QMI/net

	Gobi 2K+ USB layout:
	0: QMI/net
	1: DM/DIAG (use libqcdm from ModemManager for communication)
	2: AT-capable modem port
	3: NMEA

This should be more reliable over all, and will also prevent the
noisy "probe failed" messages.  The whitelisting logic is expected
to be replaced by direct interface number matching in 3.6.

Reported-by: Heinrich Siebmanns (Harvey) <H.Siebmanns@t-online.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/qmi_wwan.c |   83 +++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 43 deletions(-)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -257,29 +257,6 @@ err:
 	return rv;
 }
 
-/* Gobi devices uses identical class/protocol codes for all interfaces regardless
- * of function. Some of these are CDC ACM like and have the exact same endpoints
- * we are looking for. This leaves two possible strategies for identifying the
- * correct interface:
- *   a) hardcoding interface number, or
- *   b) use the fact that the wwan interface is the only one lacking additional
- *      (CDC functional) descriptors
- *
- * Let's see if we can get away with the generic b) solution.
- */
-static int qmi_wwan_bind_gobi(struct usbnet *dev, struct usb_interface *intf)
-{
-	int rv = -EINVAL;
-
-	/* ignore any interface with additional descriptors */
-	if (intf->cur_altsetting->extralen)
-		goto err;
-
-	rv = qmi_wwan_bind_shared(dev, intf);
-err:
-	return rv;
-}
-
 static void qmi_wwan_unbind_shared(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct usb_driver *subdriver = (void *)dev->data[0];
@@ -347,15 +324,15 @@ static const struct driver_info	qmi_wwan
 	.manage_power	= qmi_wwan_manage_power,
 };
 
-static const struct driver_info	qmi_wwan_gobi = {
-	.description	= "Qualcomm Gobi wwan/QMI device",
+static const struct driver_info	qmi_wwan_force_int0 = {
+	.description	= "Qualcomm WWAN/QMI device",
 	.flags		= FLAG_WWAN,
-	.bind		= qmi_wwan_bind_gobi,
+	.bind		= qmi_wwan_bind_shared,
 	.unbind		= qmi_wwan_unbind_shared,
 	.manage_power	= qmi_wwan_manage_power,
+	.data		= BIT(0), /* interface whitelist bitmap */
 };
 
-/* ZTE suck at making USB descriptors */
 static const struct driver_info	qmi_wwan_force_int1 = {
 	.description	= "Qualcomm WWAN/QMI device",
 	.flags		= FLAG_WWAN,
@@ -365,6 +342,15 @@ static const struct driver_info	qmi_wwan
 	.data		= BIT(1), /* interface whitelist bitmap */
 };
 
+static const struct driver_info	qmi_wwan_force_int3 = {
+	.description	= "Qualcomm WWAN/QMI device",
+	.flags		= FLAG_WWAN,
+	.bind		= qmi_wwan_bind_shared,
+	.unbind		= qmi_wwan_unbind_shared,
+	.manage_power	= qmi_wwan_manage_power,
+	.data		= BIT(3), /* interface whitelist bitmap */
+};
+
 static const struct driver_info	qmi_wwan_force_int4 = {
 	.description	= "Qualcomm WWAN/QMI device",
 	.flags		= FLAG_WWAN,
@@ -390,16 +376,23 @@ static const struct driver_info	qmi_wwan
 static const struct driver_info	qmi_wwan_sierra = {
 	.description	= "Sierra Wireless wwan/QMI device",
 	.flags		= FLAG_WWAN,
-	.bind		= qmi_wwan_bind_gobi,
+	.bind		= qmi_wwan_bind_shared,
 	.unbind		= qmi_wwan_unbind_shared,
 	.manage_power	= qmi_wwan_manage_power,
 	.data		= BIT(8) | BIT(19), /* interface whitelist bitmap */
 };
 
 #define HUAWEI_VENDOR_ID	0x12D1
+
+/* Gobi 1000 QMI/wwan interface number is 3 according to qcserial */
+#define QMI_GOBI1K_DEVICE(vend, prod) \
+	USB_DEVICE(vend, prod), \
+	.driver_info = (unsigned long)&qmi_wwan_force_int3
+
+/* Gobi 2000 and Gobi 3000 QMI/wwan interface number is 0 according to qcserial */
 #define QMI_GOBI_DEVICE(vend, prod) \
 	USB_DEVICE(vend, prod), \
-	.driver_info = (unsigned long)&qmi_wwan_gobi
+	.driver_info = (unsigned long)&qmi_wwan_force_int0
 
 static const struct usb_device_id products[] = {
 	{	/* Huawei E392, E398 and possibly others sharing both device id and more... */
@@ -493,20 +486,24 @@ static const struct usb_device_id produc
 		.bInterfaceProtocol = 0xff,
 		.driver_info        = (unsigned long)&qmi_wwan_sierra,
 	},
-	{QMI_GOBI_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-	{QMI_GOBI_DEVICE(0x03f0, 0x1f1d)},	/* HP un2400 Gobi Modem Device */
-	{QMI_GOBI_DEVICE(0x03f0, 0x371d)},	/* HP un2430 Mobile Broadband Module */
-	{QMI_GOBI_DEVICE(0x04da, 0x250d)},	/* Panasonic Gobi Modem device */
-	{QMI_GOBI_DEVICE(0x413c, 0x8172)},	/* Dell Gobi Modem device */
-	{QMI_GOBI_DEVICE(0x1410, 0xa001)},	/* Novatel Gobi Modem device */
-	{QMI_GOBI_DEVICE(0x0b05, 0x1776)},	/* Asus Gobi Modem device */
-	{QMI_GOBI_DEVICE(0x19d2, 0xfff3)},	/* ONDA Gobi Modem device */
-	{QMI_GOBI_DEVICE(0x05c6, 0x9001)},	/* Generic Gobi Modem device */
-	{QMI_GOBI_DEVICE(0x05c6, 0x9002)},	/* Generic Gobi Modem device */
-	{QMI_GOBI_DEVICE(0x05c6, 0x9202)},	/* Generic Gobi Modem device */
-	{QMI_GOBI_DEVICE(0x05c6, 0x9203)},	/* Generic Gobi Modem device */
-	{QMI_GOBI_DEVICE(0x05c6, 0x9222)},	/* Generic Gobi Modem device */
-	{QMI_GOBI_DEVICE(0x05c6, 0x9009)},	/* Generic Gobi Modem device */
+
+	/* Gobi 1000 devices */
+	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
+	{QMI_GOBI1K_DEVICE(0x03f0, 0x1f1d)},	/* HP un2400 Gobi Modem Device */
+	{QMI_GOBI1K_DEVICE(0x03f0, 0x371d)},	/* HP un2430 Mobile Broadband Module */
+	{QMI_GOBI1K_DEVICE(0x04da, 0x250d)},	/* Panasonic Gobi Modem device */
+	{QMI_GOBI1K_DEVICE(0x413c, 0x8172)},	/* Dell Gobi Modem device */
+	{QMI_GOBI1K_DEVICE(0x1410, 0xa001)},	/* Novatel Gobi Modem device */
+	{QMI_GOBI1K_DEVICE(0x0b05, 0x1776)},	/* Asus Gobi Modem device */
+	{QMI_GOBI1K_DEVICE(0x19d2, 0xfff3)},	/* ONDA Gobi Modem device */
+	{QMI_GOBI1K_DEVICE(0x05c6, 0x9001)},	/* Generic Gobi Modem device */
+	{QMI_GOBI1K_DEVICE(0x05c6, 0x9002)},	/* Generic Gobi Modem device */
+	{QMI_GOBI1K_DEVICE(0x05c6, 0x9202)},	/* Generic Gobi Modem device */
+	{QMI_GOBI1K_DEVICE(0x05c6, 0x9203)},	/* Generic Gobi Modem device */
+	{QMI_GOBI1K_DEVICE(0x05c6, 0x9222)},	/* Generic Gobi Modem device */
+	{QMI_GOBI1K_DEVICE(0x05c6, 0x9009)},	/* Generic Gobi Modem device */
+
+	/* Gobi 2000 and 3000 devices */
 	{QMI_GOBI_DEVICE(0x413c, 0x8186)},	/* Dell Gobi 2000 Modem device (N0218, VU936) */
 	{QMI_GOBI_DEVICE(0x05c6, 0x920b)},	/* Generic Gobi 2000 Modem device */
 	{QMI_GOBI_DEVICE(0x05c6, 0x9225)},	/* Sony Gobi 2000 Modem device (N0279, VU730) */


