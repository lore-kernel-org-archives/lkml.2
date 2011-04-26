Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab1DZVYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:24:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:1612 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413Ab1DZVOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425951352"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: stern@rowland.harvard.edu, ak@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [74/106] USB: EHCI: unlink unused QHs when the controller is stopped
Message-Id: <20110426211355.A59353E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 94ae4976e253757e9b03a44d27d41b20f1829d80 upstream.

This patch (as1458) fixes a problem affecting ultra-reliable systems:
When hardware failover of an EHCI controller occurs, the data
structures do not get released correctly.  This is because the routine
responsible for removing unused QHs from the async schedule assumes
the controller is running properly (the frame counter is used in
determining how long the QH has been idle) -- but when a failover
causes the controller to be electronically disconnected from the PCI
bus, obviously it stops running.

The solution is simple: Allow scan_async() to remove a QH from the
async schedule if it has been idle for long enough _or_ if the
controller is stopped.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-and-Tested-by: Dan Duval <dan.duval@stratus.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-q.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/ehci-q.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/ehci-q.c
+++ linux-2.6.35.y/drivers/usb/host/ehci-q.c
@@ -1246,24 +1246,27 @@ static void start_unlink_async (struct e
 
 static void scan_async (struct ehci_hcd *ehci)
 {
+	bool			stopped;
 	struct ehci_qh		*qh;
 	enum ehci_timer_action	action = TIMER_IO_WATCHDOG;
 
 	ehci->stamp = ehci_readl(ehci, &ehci->regs->frame_index);
 	timer_action_done (ehci, TIMER_ASYNC_SHRINK);
 rescan:
+	stopped = !HC_IS_RUNNING(ehci_to_hcd(ehci)->state);
 	qh = ehci->async->qh_next.qh;
 	if (likely (qh != NULL)) {
 		do {
 			/* clean any finished work for this qh */
-			if (!list_empty (&qh->qtd_list)
-					&& qh->stamp != ehci->stamp) {
+			if (!list_empty(&qh->qtd_list) && (stopped ||
+					qh->stamp != ehci->stamp)) {
 				int temp;
 
 				/* unlinks could happen here; completion
 				 * reporting drops the lock.  rescan using
 				 * the latest schedule, but don't rescan
-				 * qhs we already finished (no looping).
+				 * qhs we already finished (no looping)
+				 * unless the controller is stopped.
 				 */
 				qh = qh_get (qh);
 				qh->stamp = ehci->stamp;
@@ -1284,9 +1287,9 @@ rescan:
 			 */
 			if (list_empty(&qh->qtd_list)
 					&& qh->qh_state == QH_STATE_LINKED) {
-				if (!ehci->reclaim
-					&& ((ehci->stamp - qh->stamp) & 0x1fff)
-						>= (EHCI_SHRINK_FRAMES * 8))
+				if (!ehci->reclaim && (stopped ||
+					((ehci->stamp - qh->stamp) & 0x1fff)
+						>= EHCI_SHRINK_FRAMES * 8))
 					start_unlink_async(ehci, qh);
 				else
 					action = TIMER_ASYNC_SHRINK;
