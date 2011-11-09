Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab1KJFBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:01:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935096Ab1KJD3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:18 2011
Message-Id: <20111109212718.236595916@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Steven.Li" <yongli@qca.qualcomm.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [176/262] Bluetooth: Add Atheros AR3012 one PID/VID supported
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven.Li" <Steven.Li@Atheros.com>

commit 2d25f8b462f3b849d8913d02978657ef06e67dd8 upstream.

The new Ath3k needs to download patch and radio table,
and it keeps same PID/VID even after downloading the patch and radio
table. This patch is to use the bcdDevice (Device Release Number) to
judge whether the chip has been patched or not. The init bcdDevice
value of the chip is 0x0001, this value increases after patch and
radio table downloading.

Signed-off-by: Steven.Li <yongli@qca.qualcomm.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/ath3k.c |    5 +++++
 drivers/bluetooth/btusb.c |   12 +++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -376,6 +376,11 @@ static int ath3k_probe(struct usb_interf
 
 	/* load patch and sysconfig files for AR3012 */
 	if (id->driver_info & BTUSB_ATH3012) {
+
+		/* New firmware with patch and sysconfig files already loaded */
+		if (le16_to_cpu(udev->descriptor.bcdDevice) > 0x0001)
+			return -ENODEV;
+
 		ret = ath3k_load_patch(udev);
 		if (ret < 0) {
 			BT_ERR("Loading patch file failed");
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -54,6 +54,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_BCM92035		0x10
 #define BTUSB_BROKEN_ISOC	0x20
 #define BTUSB_WRONG_SCO_MTU	0x40
+#define BTUSB_ATH3012		0x80
 
 static struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
@@ -114,7 +115,7 @@ static struct usb_device_id blacklist_ta
 	{ USB_DEVICE(0x03f0, 0x311d), .driver_info = BTUSB_IGNORE },
 
 	/* Atheros 3012 with sflash firmware */
-	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_IGNORE },
+	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
@@ -918,6 +919,15 @@ static int btusb_probe(struct usb_interf
 	if (ignore_sniffer && id->driver_info & BTUSB_SNIFFER)
 		return -ENODEV;
 
+	if (id->driver_info & BTUSB_ATH3012) {
+		struct usb_device *udev = interface_to_usbdev(intf);
+
+		/* Old firmware would otherwise let ath3k driver load
+		 * patch and sysconfig files */
+		if (le16_to_cpu(udev->descriptor.bcdDevice) <= 0x0001)
+			return -ENODEV;
+	}
+
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;


