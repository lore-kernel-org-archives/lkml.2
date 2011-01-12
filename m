Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab1ALNWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:22:14 -0500
Received: from mail.nusquama.org ([85.131.211.20]:50167 "EHLO
	mail.nusquama.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932381Ab1ALNVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:21:52 -0500
From: Max Vozeler <max@vozeler.com>
To: gregkh@suse.de
Cc: hirofuchi@users.sourceforge.net, rpjday@crashcourse.ca,
        bgmerrell@novell.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, mwehby@luxotticaRetail.com,
        marco@optikam.com, Max Vozeler <max@vozeler.com>
Subject: [PATCH 7/7] staging: usbip: vhci: use urb->dev->portnum to find port
Date: Wed, 12 Jan 2011 15:02:05 +0200
Message-Id: <1294837325-26187-8-git-send-email-max@vozeler.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1294837325-26187-1-git-send-email-max@vozeler.com>
References: <1294837325-26187-1-git-send-email-max@vozeler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The access to pending_port was racy when two devices
were being attached at the same time.

Signed-off-by: Max Vozeler <max@vozeler.com>
Tested-by: Mark Wehby <MWehby@luxotticaRetail.com>
---
 drivers/staging/usbip/vhci.h     |    3 ---
 drivers/staging/usbip/vhci_hcd.c |    4 +---
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/usbip/vhci.h b/drivers/staging/usbip/vhci.h
index 2cfd00e..afc3b1a 100644
--- a/drivers/staging/usbip/vhci.h
+++ b/drivers/staging/usbip/vhci.h
@@ -100,9 +100,6 @@ struct vhci_hcd {
 	 * But, the index of this array begins from 0.
 	 */
 	struct vhci_device vdev[VHCI_NPORTS];
-
-	/* vhci_device which has not been assiged its address yet */
-	int pending_port;
 };
 
 
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 22b1ad9..a35fe61 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -138,8 +138,6 @@ void rh_port_connect(int rhport, enum usb_device_speed speed)
 	 * the_controller->vdev[rhport].ud.status = VDEV_CONNECT;
 	 * spin_unlock(&the_controller->vdev[rhport].ud.lock); */
 
-	the_controller->pending_port = rhport;
-
 	spin_unlock_irqrestore(&the_controller->lock, flags);
 
 	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
@@ -575,7 +573,7 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 		return urb->status;
 	}
 
-	vdev = port_to_vdev(the_controller->pending_port);
+	vdev = port_to_vdev(urb->dev->portnum-1);
 
 	/* refuse enqueue for dead connection */
 	spin_lock(&vdev->ud.lock);
-- 
1.7.2.3

