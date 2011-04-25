Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab1DYUpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:45:51 -0400
Received: from 1wt.eu ([62.212.114.60]:34314 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab1DYUYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:47 -0400
Message-Id: <20110425200237.730224557@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <david-b@pacbell.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 109/173] ehci-hcd: Bug fix: dont set a QHs Halt bit
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit b5a3b3d985493c173925907adfebf3edab236fe7 upstream.

This patch (as1453) fixes a long-standing bug in the ehci-hcd driver.

There is no need to set the Halt bit in the overlay region for an
unlinked or blocked QH.  Contrary to what the comment says, setting
the Halt bit does not cause the QH to be patched later; that decision
(made in qh_refresh()) depends only on whether the QH is currently
pointing to a valid qTD.  Likewise, setting the Halt bit does not
prevent completions from activating the QH while it is "stopped"; they
are prevented by the fact that qh_completions() temporarily changes
qh->qh_state to QH_STATE_COMPLETING.

On the other hand, there are circumstances in which the QH will be
reactivated _without_ being patched; this happens after an URB beyond
the head of the queue is unlinked.  Setting the Halt bit will then
cause the hardware to see the QH with both the Active and Halt bits
set, an invalid combination that will prevent the queue from
advancing and may even crash some controllers.

Apparently the only reason this hasn't been reported before is that
unlinking URBs from the middle of a running queue is quite uncommon.
However Test 17, recently added to the usbtest driver, does exactly
this, and it confirms the presence of the bug.

In short, there is no reason to set the Halt bit for an unlinked or
blocked QH, and there is a very good reason not to set it.  Therefore
the code that sets it is removed.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Andiry Xu <andiry.xu@amd.com>
CC: David Brownell <david-b@pacbell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-q.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: longterm-2.6.27/drivers/usb/host/ehci-q.c
===================================================================
--- longterm-2.6.27.orig/drivers/usb/host/ehci-q.c	2011-01-23 10:52:26.000000000 +0100
+++ longterm-2.6.27/drivers/usb/host/ehci-q.c	2011-04-25 16:25:29.076280256 +0200
@@ -285,7 +285,6 @@
 	int			stopped;
 	unsigned		count = 0;
 	u8			state;
-	__le32			halt = HALT_BIT(ehci);
 
 	if (unlikely (list_empty (&qh->qtd_list)))
 		return count;
@@ -381,7 +380,6 @@
 					&& !(qtd->hw_alt_next
 						& EHCI_LIST_END(ehci))) {
 				stopped = 1;
-				goto halt;
 			}
 
 		/* stop scanning when we reach qtds the hc is using */
@@ -408,16 +406,6 @@
 					&& cpu_to_hc32(ehci, qtd->qtd_dma)
 						== qh->hw_current)
 				token = hc32_to_cpu(ehci, qh->hw_token);
-
-			/* force halt for unlinked or blocked qh, so we'll
-			 * patch the qh later and so that completions can't
-			 * activate it while we "know" it's stopped.
-			 */
-			if ((halt & qh->hw_token) == 0) {
-halt:
-				qh->hw_token |= halt;
-				wmb ();
-			}
 		}
 
 		/* unless we already know the urb's status, collect qtd status


