Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab1HaPOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:14:24 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59851 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab1HaPLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/16] drbd: Concurrent write detection fix
Date: Wed, 31 Aug 2011 17:10:53 +0200
Message-Id: <1314803468-1201-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Commit 9b1e63e changed the concurrent write detection algorithm to only insert
peer requests into write_requests tree after determining that there is no
conflict.  With this change, new conflicting local requests could be added
while the algorithm runs, but this case was not handled correctly.  Instead of
making the algorithm deal with this case, switch back to adding peer requests
to the write_requests tree immediately: this improves fairness.

When a peer request is discarded, remove that request from the write_requests

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   41 ++++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1b67426..987af1a 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1639,16 +1639,10 @@ static int e_send_discard_ack(struct drbd_work *w, int unused)
 	struct drbd_peer_request *peer_req =
 		container_of(w, struct drbd_peer_request, w);
 	struct drbd_conf *mdev = w->mdev;
-	int ok = 1;
+	int ok;
 
 	D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
 	ok = drbd_send_ack(mdev, P_DISCARD_ACK, peer_req);
-
-	spin_lock_irq(&mdev->tconn->req_lock);
-	D_ASSERT(!drbd_interval_empty(&peer_req->i));
-	drbd_remove_epoch_entry_interval(mdev, peer_req);
-	spin_unlock_irq(&mdev->tconn->req_lock);
-
 	dec_unacked(mdev);
 
 	return ok;
@@ -1839,6 +1833,12 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 		spin_lock_irq(&mdev->tconn->req_lock);
 
+		/*
+		 * Inserting the peer request into the write_requests tree will
+		 * prevent new conflicting local requests from being added.
+		 */
+		drbd_insert_interval(&mdev->write_requests, &peer_req->i);
+
 		first = 1;
 		for (;;) {
 			struct drbd_interval *i;
@@ -1847,26 +1847,26 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 			prepare_to_wait(&mdev->misc_wait, &wait,
 				TASK_INTERRUPTIBLE);
 
-			i = drbd_find_overlap(&mdev->write_requests, sector, size);
-			if (i) {
+			drbd_for_each_overlap(i, &mdev->write_requests, sector, size) {
+				struct drbd_request *req2;
+
+				if (i == &peer_req->i || !i->local)
+					continue;
+
 				/* only ALERT on first iteration,
 				 * we may be woken up early... */
 				if (first)
-					dev_alert(DEV, "%s[%u] Concurrent %s write detected!"
+					dev_alert(DEV, "%s[%u] Concurrent local write detected!"
 					      "	new: %llus +%u; pending: %llus +%u\n",
 					      current->comm, current->pid,
-					      i->local ? "local" : "remote",
 					      (unsigned long long)sector, size,
 					      (unsigned long long)i->sector, i->size);
 
-				if (i->local) {
-					struct drbd_request *req2;
-
-					req2 = container_of(i, struct drbd_request, i);
-					if (req2->rq_state & RQ_NET_PENDING)
-						++have_unacked;
-				}
+				req2 = container_of(i, struct drbd_request, i);
+				if (req2->rq_state & RQ_NET_PENDING)
+					++have_unacked;
 				++have_conflict;
+				break;
 			}
 			if (!have_conflict)
 				break;
@@ -1875,6 +1875,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 			if (first && discard && have_unacked) {
 				dev_alert(DEV, "Concurrent write! [DISCARD BY FLAG] sec=%llus\n",
 				     (unsigned long long)sector);
+				drbd_remove_epoch_entry_interval(mdev, peer_req);
 				inc_unacked(mdev);
 				peer_req->w.cb = e_send_discard_ack;
 				list_add_tail(&peer_req->w.list, &mdev->done_ee);
@@ -1891,6 +1892,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 			}
 
 			if (signal_pending(current)) {
+				drbd_remove_epoch_entry_interval(mdev, peer_req);
 				spin_unlock_irq(&mdev->tconn->req_lock);
 				finish_wait(&mdev->misc_wait, &wait);
 				goto out_interrupted;
@@ -1909,12 +1911,11 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 				 * there must be none now. */
 				D_ASSERT(have_unacked == 0);
 			}
+			/* FIXME: Introduce a timeout here after which we disconnect.  */
 			schedule();
 			spin_lock_irq(&mdev->tconn->req_lock);
 		}
 		finish_wait(&mdev->misc_wait, &wait);
-
-		drbd_insert_interval(&mdev->write_requests, &peer_req->i);
 	}
 
 	list_add(&peer_req->w.list, &mdev->active_ee);
-- 
1.7.4.1

