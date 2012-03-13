Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab2CMASR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:18:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:46846 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab2CMASM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:18:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Arjan Mels <arjan.mels@gmx.net>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>,
        Max Vozeler <max@vozeler.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 016/196] staging: usbip: bugfixes related to kthread conversion
Date: Mon, 12 Mar 2012 20:12:24 -0400
Message-Id: <1331597724-31358-17-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan Mels <arjan.mels@gmx.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d2dd0b07c3e725d386d20294ec906f7ddef207fa upstream.

When doing a usb port reset do a queued reset instead to prevent a
deadlock: the reset will cause the driver to unbind, causing the
usb_driver_lock_for_reset to stall.

Signed-off-by: Arjan Mels <arjan.mels@gmx.net>
Cc: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
Cc: Max Vozeler <max@vozeler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/usbip/stub_rx.c |   40 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index bc26740..16a7df1 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -170,33 +170,23 @@ static int tweak_set_configuration_cmd(struct urb *urb)
 
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
+	struct stub_priv *priv = (struct stub_priv *) urb->context;
+	struct stub_device *sdev = priv->sdev;
 
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
-- 
1.7.9.3

