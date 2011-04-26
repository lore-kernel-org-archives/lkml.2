Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab1DZVNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:13:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:61741 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758342Ab1DZVNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684326661"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: arjan.mels@gmx.net, ak@linux.intel.com, hirofuchi@users.sourceforge.net,
        max@vozeler.com, arnd@arndb.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [3/106] staging: usbip: bugfixes related to kthread conversion
Message-Id: <20110426211240.D8C933E1887@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Arjan Mels <arjan.mels@gmx.net>

commit d2dd0b07c3e725d386d20294ec906f7ddef207fa upstream.

When doing a usb port reset do a queued reset instead to prevent a
deadlock: the reset will cause the driver to unbind, causing the
usb_driver_lock_for_reset to stall.

Signed-off-by: Arjan Mels <arjan.mels@gmx.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
Cc: Max Vozeler <max@vozeler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/stub_rx.c |   40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

Index: linux-2.6.35.y/drivers/staging/usbip/stub_rx.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/usbip/stub_rx.c
+++ linux-2.6.35.y/drivers/staging/usbip/stub_rx.c
@@ -170,33 +170,23 @@ static int tweak_set_configuration_cmd(s
 
 static int tweak_reset_device_cmd(struct urb *urb)
 {
-	struct usb_ctrlrequest *req;
-	__u16 value;
-	__u16 index;
-	int ret;
-
-	req = (struct usb_ctrlrequest *) urb->setup_packet;
-	value = le16_to_cpu(req->wValue);
-	index = le16_to_cpu(req->wIndex);
-
-	usbip_uinfo("reset_device (port %d) to %s\n", index,
-						dev_name(&urb->dev->dev));
-
-	/* all interfaces should be owned by usbip driver, so just reset it.  */
-	ret = usb_lock_device_for_reset(urb->dev, NULL);
-	if (ret < 0) {
-		dev_err(&urb->dev->dev, "lock for reset\n");
-		return ret;
-	}
+	struct stub_priv *priv = (struct stub_priv *) urb->context;
+	struct stub_device *sdev = priv->sdev;
 
-	/* try to reset the device */
-	ret = usb_reset_device(urb->dev);
-	if (ret < 0)
-		dev_err(&urb->dev->dev, "device reset\n");
+	usbip_uinfo("reset_device %s\n", dev_name(&urb->dev->dev));
 
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
