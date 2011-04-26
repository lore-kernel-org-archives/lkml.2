Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab1DZVRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:17:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:1363 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562Ab1DZVPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="914749085"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: willy@linux.intel.com, sarah.a.sharp@linux.intel.com, ak@linux.intel.com,
        stable@kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [103/106] From: USB: Fix unplug of device with active streams
Message-Id: <20110426211426.09C543E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Date: Tue, 28 Sep 2010 00:57:32 -0400
Subject: USB: Fix unplug of device with active streams

upstream commit: b214f191d95ba4b5a35aebd69cd129cf7e3b1884

If I unplug a device while the UAS driver is loaded, I get an oops
in usb_free_streams().  This is because usb_unbind_interface() calls
usb_disable_interface() which calls usb_disable_endpoint() which sets
ep_out and ep_in to NULL.  Then the UAS driver calls usb_pipe_endpoint()
which returns a NULL pointer and passes an array of NULL pointers to
usb_free_streams().

I think the correct fix for this is to check for the NULL pointer
in usb_free_streams() rather than making the driver check for this
situation.  My original patch for this checked for dev->state ==
USB_STATE_NOTATTACHED, but the call to usb_disable_interface() is
conditional, so not all drivers would want this check.

Note from Sarah Sharp: This patch does avoid a potential dereference,
but the real fix (which will be implemented later) is to set the
.soft_unbind flag in the usb_driver structure for the UAS driver, and
all drivers that allocate streams.  The driver should free any streams
when it is unbound from the interface.  This avoids leaking stream rings
in the xHCI driver when usb_disable_interface() is called.

This should be queued for stable trees back to 2.6.35.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: stable@kernel.org
---
 drivers/usb/core/hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: linux-2.6.35.y/drivers/usb/core/hcd.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/core/hcd.c
+++ linux-2.6.35.y/drivers/usb/core/hcd.c
@@ -1874,7 +1874,7 @@ void usb_free_streams(struct usb_interfa
 
 	/* Streams only apply to bulk endpoints. */
 	for (i = 0; i < num_eps; i++)
-		if (!usb_endpoint_xfer_bulk(&eps[i]->desc))
+		if (!eps[i] || !usb_endpoint_xfer_bulk(&eps[i]->desc))
 			return;
 
 	hcd->driver->free_streams(hcd, dev, eps, num_eps, mem_flags);
