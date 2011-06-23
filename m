Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792Ab1FWRVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:21:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:62671 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759758Ab1FWRVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:21:51 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        =?UTF-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 001/247] staging: usbip: remove double giveback of URB
Date: Thu, 23 Jun 2011 13:17:24 -0400
Message-Id: <1308849690-14530-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7571f089d7522a95c103558faf313c7af8856ceb upstream.

In the vhci_urb_dequeue() function the TCP connection is checked twice.
Each time when the TCP connection is closed the URB is unlinked and given
back. Remove the second attempt of unlinking and giving back of the URB completely.

This patch fixes the bug described at https://bugzilla.kernel.org/show_bug.cgi?id=24872 .

Signed-off-by: Márton Németh <nm127@freemail.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/usbip/vhci_hcd.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 7604519..31317ff 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -799,20 +799,6 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		spin_unlock_irqrestore(&vdev->priv_lock, flags2);
 	}
 
-
-	if (!vdev->ud.tcp_socket) {
-		/* tcp connection is closed */
-		usbip_uinfo("vhci_hcd: vhci_urb_dequeue() gives back urb %p\n",
-									urb);
-
-		usb_hcd_unlink_urb_from_ep(hcd, urb);
-
-		spin_unlock_irqrestore(&the_controller->lock, flags);
-		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
-								urb->status);
-		spin_lock_irqsave(&the_controller->lock, flags);
-	}
-
 	spin_unlock_irqrestore(&the_controller->lock, flags);
 
 	usbip_dbg_vhci_hc("leave\n");
-- 
1.7.4.4

