Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965221Ab1C3VTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:19:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:9067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965053Ab1C3VJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238832"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stern@rowland.harvard.edu, andiry.xu@amd.com, david-b@pacbell.net,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [234/275] ehci-hcd: Bug fix: don't set a QH's Halt bit
Message-Id: <20110330210800.18DD33E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/ehci-q.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/ehci-q.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/ehci-q.c	2011-03-29 22:50:20.995721192 -0700
+++ linux-2.6.35.y/drivers/usb/host/ehci-q.c	2011-03-29 23:03:03.099220870 -0700
@@ -315,7 +315,6 @@
 	int			stopped;
 	unsigned		count = 0;
 	u8			state;
-	const __le32		halt = HALT_BIT(ehci);
 	struct ehci_qh_hw	*hw = qh->hw;
 
 	if (unlikely (list_empty (&qh->qtd_list)))
@@ -422,7 +421,6 @@
 					&& !(qtd->hw_alt_next
 						& EHCI_LIST_END(ehci))) {
 				stopped = 1;
-				goto halt;
 			}
 
 		/* stop scanning when we reach qtds the hc is using */
@@ -456,16 +454,6 @@
 				 */
 				ehci_clear_tt_buffer(ehci, qh, urb, token);
 			}
-
-			/* force halt for unlinked or blocked qh, so we'll
-			 * patch the qh later and so that completions can't
-			 * activate it while we "know" it's stopped.
-			 */
-			if ((halt & hw->hw_token) == 0) {
-halt:
-				hw->hw_token |= halt;
-				wmb ();
-			}
 		}
 
 		/* unless we already know the urb's status, collect qtd status
