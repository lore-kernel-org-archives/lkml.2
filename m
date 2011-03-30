Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208Ab1C3WLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:11:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:59268 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134Ab1C3VGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621235728"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: nm127@freemail.hu, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [7/275] staging: usbip: remove double giveback of URB
Message-Id: <20110330210401.138513E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: =?UTF-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>

commit 7571f089d7522a95c103558faf313c7af8856ceb upstream.

In the vhci_urb_dequeue() function the TCP connection is checked twice.
Each time when the TCP connection is closed the URB is unlinked and given
back. Remove the second attempt of unlinking and giving back of the URB completely.

This patch fixes the bug described at https://bugzilla.kernel.org/show_bug.cgi?id=24872 .

Signed-off-by: Márton Németh <nm127@freemail.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/usbip/vhci_hcd.c |   14 --------------
 1 file changed, 14 deletions(-)

Index: linux-2.6.35.y/drivers/staging/usbip/vhci_hcd.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/usbip/vhci_hcd.c	2011-03-29 22:52:04.724067043 -0700
+++ linux-2.6.35.y/drivers/staging/usbip/vhci_hcd.c	2011-03-29 23:54:39.657987678 -0700
@@ -799,20 +799,6 @@
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
