Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266Ab1C3VjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:39:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:33187 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964828Ab1C3VIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447751"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: max@vozeler.com, MWehby@luxotticaRetail.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [149/275] staging: usbip: vhci: use urb->dev->portnum to find port
Message-Id: <20110330210630.8F0993E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Max Vozeler <max@vozeler.com>

commit 01446ef5af4e8802369bf4d257806e24345a9371 upstream.

The access to pending_port was racy when two devices
were being attached at the same time.

Signed-off-by: Max Vozeler <max@vozeler.com>
Tested-by: Mark Wehby <MWehby@luxotticaRetail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/usbip/vhci.h     |    3 ---
 drivers/staging/usbip/vhci_hcd.c |    4 +---
 2 files changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6.35.y/drivers/staging/usbip/vhci.h
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/usbip/vhci.h	2011-03-29 23:03:01.319266414 -0700
+++ linux-2.6.35.y/drivers/staging/usbip/vhci.h	2011-03-29 23:03:01.359265390 -0700
@@ -100,9 +100,6 @@
 	 * But, the index of this array begins from 0.
 	 */
 	struct vhci_device vdev[VHCI_NPORTS];
-
-	/* vhci_device which has not been assiged its address yet */
-	int pending_port;
 };
 
 
Index: linux-2.6.35.y/drivers/staging/usbip/vhci_hcd.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/usbip/vhci_hcd.c	2011-03-29 23:03:01.341265850 -0700
+++ linux-2.6.35.y/drivers/staging/usbip/vhci_hcd.c	2011-03-29 23:03:01.360265365 -0700
@@ -138,8 +138,6 @@
 	 * the_controller->vdev[rhport].ud.status = VDEV_CONNECT;
 	 * spin_unlock(&the_controller->vdev[rhport].ud.lock); */
 
-	the_controller->pending_port = rhport;
-
 	spin_unlock_irqrestore(&the_controller->lock, flags);
 
 	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
@@ -575,7 +573,7 @@
 		return urb->status;
 	}
 
-	vdev = port_to_vdev(the_controller->pending_port);
+	vdev = port_to_vdev(urb->dev->portnum-1);
 
 	/* refuse enqueue for dead connection */
 	spin_lock(&vdev->ud.lock);
