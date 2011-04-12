Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab1DLO5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:57:44 -0400
Received: from kroah.org ([198.145.64.141]:57426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038Ab1DLOhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:49 2011
Message-Id: <20110412143549.837107029@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arjan Mels <arjan.mels@gmx.net>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>,
        Max Vozeler <max@vozeler.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [018/105] staging: usbip: bugfixes related to kthread conversion
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arjan Mels <arjan.mels@gmx.net>

commit d2dd0b07c3e725d386d20294ec906f7ddef207fa upstream.

When doing a usb port reset do a queued reset instead to prevent a
deadlock: the reset will cause the driver to unbind, causing the
usb_driver_lock_for_reset to stall.

Signed-off-by: Arjan Mels <arjan.mels@gmx.net>
Cc: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
Cc: Max Vozeler <max@vozeler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/stub_rx.c |   40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -170,33 +170,23 @@ static int tweak_set_configuration_cmd(s
 
 static int tweak_reset_device_cmd(struct urb *urb)
 {
-	struct usb_ctrlrequest *req;
-	__u16 value;
-	__u16 index;
-	int ret;
+	struct stub_priv *priv = (struct stub_priv *) urb->context;
+	struct stub_device *sdev = priv->sdev;
 
-	req = (struct usb_ctrlrequest *) urb->setup_packet;
-	value = le16_to_cpu(req->wValue);
-	index = le16_to_cpu(req->wIndex);
+	usbip_uinfo("reset_device %s\n", dev_name(&urb->dev->dev));
 
-	usbip_uinfo("reset_device (port %d) to %s\n", index,
-						dev_name(&urb->dev->dev));
-
-	/* all interfaces should be owned by usbip driver, so just reset it.  */
-	ret = usb_lock_device_for_reset(urb->dev, NULL);
-	if (ret < 0) {
-		dev_err(&urb->dev->dev, "lock for reset\n");
-		return ret;
-	}
-
-	/* try to reset the device */
-	ret = usb_reset_device(urb->dev);
-	if (ret < 0)
-		dev_err(&urb->dev->dev, "device reset\n");
-
-	usb_unlock_device(urb->dev);
-
-	return ret;
+	/*
+	 * usb_lock_device_for_reset caused a deadlock: it causes the driver
+	 * to unbind. In the shutdown the rx thread is signalled to shut down
+	 * but this thread is pending in the usb_lock_device_for_reset.
+	 *
+	 * Instead queue the reset.
+	 *
+	 * Unfortunatly an existing usbip connection will be dropped due to
+	 * driver unbinding.
+	 */
+	usb_queue_reset_device(sdev->interface);
+	return 0;
 }
 
 /*


