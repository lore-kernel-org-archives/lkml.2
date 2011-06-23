Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab1FWRgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:36:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:34617 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933420Ab1FWRgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Max Vozeler <max@vozeler.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 128/247] staging: usbip: vhci: use urb->dev->portnum to find port
Date: Thu, 23 Jun 2011 13:33:16 -0400
Message-Id: <1308850515-15242-69-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Vozeler <max@vozeler.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 01446ef5af4e8802369bf4d257806e24345a9371 upstream.

The access to pending_port was racy when two devices
were being attached at the same time.

Signed-off-by: Max Vozeler <max@vozeler.com>
Tested-by: Mark Wehby <MWehby@luxotticaRetail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/usbip/vhci.h     |    3 ---
 drivers/staging/usbip/vhci_hcd.c |    4 +---
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/usbip/vhci.h b/drivers/staging/usbip/vhci.h
index ad3a19d..57f7946 100644
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
index 006d5f7..fd4cc48 100644
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
1.7.4.4

