Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762Ab1FWRiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:35452 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933742Ab1FWRiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 215/247] ehci-hcd: Bug fix: don't set a QH's Halt bit
Date: Thu, 23 Jun 2011 13:34:43 -0400
Message-Id: <1308850515-15242-156-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/ehci-q.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 8952177..d1d4bb1 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -315,7 +315,6 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 	int			stopped;
 	unsigned		count = 0;
 	u8			state;
-	const __le32		halt = HALT_BIT(ehci);
 	struct ehci_qh_hw	*hw = qh->hw;
 
 	if (unlikely (list_empty (&qh->qtd_list)))
@@ -422,7 +421,6 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 					&& !(qtd->hw_alt_next
 						& EHCI_LIST_END(ehci))) {
 				stopped = 1;
-				goto halt;
 			}
 
 		/* stop scanning when we reach qtds the hc is using */
@@ -456,16 +454,6 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
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
-- 
1.7.4.4

