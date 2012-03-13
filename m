Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab2CMAz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:55:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:47812 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab2CMAWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 074/196] USB: EHCI: unlink unused QHs when the controller is stopped
Date: Mon, 12 Mar 2012 20:19:47 -0400
Message-Id: <1331598109-31424-29-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/ehci-q.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index d1d4bb1..781c573 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -1246,24 +1246,27 @@ static void start_unlink_async (struct ehci_hcd *ehci, struct ehci_qh *qh)
 
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
-- 
1.7.9.3

