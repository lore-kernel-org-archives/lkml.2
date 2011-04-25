Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab1DYUdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:33:44 -0400
Received: from 1wt.eu ([62.212.114.60]:34571 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436Ab1DYUZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:22 -0400
Message-Id: <20110425200240.388881569@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 170/173] USB: EHCI: unlink unused QHs when the controller is stopped
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
Reported-and-Tested-by: Dan Duval <dan.duval@stratus.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-q.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -1224,24 +1224,27 @@ static void start_unlink_async (struct e
 
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
@@ -1262,9 +1265,9 @@ rescan:
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


