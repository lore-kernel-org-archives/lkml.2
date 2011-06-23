Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205Ab1FWSKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:10:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:34599 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374Ab1FWRgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Max Vozeler <max@vozeler.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 127/247] staging: usbip: vhci: refuse to enqueue for dead connections
Date: Thu, 23 Jun 2011 13:33:15 -0400
Message-Id: <1308850515-15242-68-git-send-email-paul.gortmaker@windriver.com>
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

commit 6d212153a838354078cc7d96f9bb23b7d1fd3d1b upstream.

There can be requests to enqueue URBs while we are shutting
down a connection.

Signed-off-by: Max Vozeler <max@vozeler.com>
Tested-by: Mark Wehby <MWehby@luxotticaRetail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/usbip/vhci_hcd.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 9878e5d..006d5f7 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -559,6 +559,7 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	struct device *dev = &urb->dev->dev;
 	int ret = 0;
 	unsigned long flags;
+	struct vhci_device *vdev;
 
 	usbip_dbg_vhci_hc("enter, usb_hcd %p urb %p mem_flags %d\n",
 		    hcd, urb, mem_flags);
@@ -574,6 +575,18 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 		return urb->status;
 	}
 
+	vdev = port_to_vdev(the_controller->pending_port);
+
+	/* refuse enqueue for dead connection */
+	spin_lock(&vdev->ud.lock);
+	if (vdev->ud.status == VDEV_ST_NULL || vdev->ud.status == VDEV_ST_ERROR) {
+		usbip_uerr("enqueue for inactive port %d\n", vdev->rhport);
+		spin_unlock(&vdev->ud.lock);
+		spin_unlock_irqrestore(&the_controller->lock, flags);
+		return -ENODEV;
+	}
+	spin_unlock(&vdev->ud.lock);
+
 	ret = usb_hcd_link_urb_to_ep(hcd, urb);
 	if (ret)
 		goto no_need_unlink;
@@ -592,8 +605,6 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 		__u8 type = usb_pipetype(urb->pipe);
 		struct usb_ctrlrequest *ctrlreq =
 				(struct usb_ctrlrequest *) urb->setup_packet;
-		struct vhci_device *vdev =
-				port_to_vdev(the_controller->pending_port);
 
 		if (type != PIPE_CONTROL || !ctrlreq) {
 			dev_err(dev, "invalid request to devnum 0\n");
-- 
1.7.4.4

