Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747Ab1IILSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:18:35 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45688 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab1IILRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:17:42 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/11] drbd: Implemented IO thawing for multiple volumes
Date: Fri,  9 Sep 2011 13:17:34 +0200
Message-Id: <1315567056-32314-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
References: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |   72 +++++++++++++++++++++-----------------
 1 files changed, 40 insertions(+), 32 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 5db514e..441d80f 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1070,8 +1070,6 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags)
 {
 	enum drbd_fencing_p fp;
-	enum drbd_req_event what = NOTHING;
-	union drbd_state nsm;
 	struct sib_info sib;
 
 	sib.sib_reason = SIB_STATE_CHANGE;
@@ -1100,44 +1098,21 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 	/* Here we have the actions that are performed after a
 	   state change. This function might sleep */
 
-	nsm.i = -1;
 	if (ns.susp_nod) {
-		if (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED)
+		enum drbd_req_event what = NOTHING;
+
+		if (os.conn < C_CONNECTED && conn_lowest_conn(mdev->tconn) >= C_CONNECTED)
 			what = RESEND;
 
-		if (os.disk == D_ATTACHING && ns.disk > D_ATTACHING)
+		if (os.disk == D_ATTACHING && conn_lowest_disk(mdev->tconn) > D_ATTACHING)
 			what = RESTART_FROZEN_DISK_IO;
 
-		if (what != NOTHING)
-			nsm.susp_nod = 0;
-	}
-
-	if (ns.susp_fen) {
-		/* case1: The outdate peer handler is successful: */
-		if (os.pdsk > D_OUTDATED  && ns.pdsk <= D_OUTDATED) {
-			tl_clear(mdev->tconn);
-			if (test_bit(NEW_CUR_UUID, &mdev->flags)) {
-				drbd_uuid_new_current(mdev);
-				clear_bit(NEW_CUR_UUID, &mdev->flags);
-			}
+		if (what != NOTHING) {
 			spin_lock_irq(&mdev->tconn->req_lock);
-			_drbd_set_state(_NS(mdev, susp_fen, 0), CS_VERBOSE, NULL);
+			_tl_restart(mdev->tconn, what);
+			_drbd_set_state(_NS(mdev, susp_nod, 0), CS_VERBOSE, NULL);
 			spin_unlock_irq(&mdev->tconn->req_lock);
 		}
-		/* case2: The connection was established again: */
-		if (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED) {
-			clear_bit(NEW_CUR_UUID, &mdev->flags);
-			what = RESEND;
-			nsm.susp_fen = 0;
-		}
-	}
-
-	if (what != NOTHING) {
-		spin_lock_irq(&mdev->tconn->req_lock);
-		_tl_restart(mdev->tconn, what);
-		nsm.i &= mdev->state.i;
-		_drbd_set_state(mdev, nsm, CS_VERBOSE, NULL);
-		spin_unlock_irq(&mdev->tconn->req_lock);
 	}
 
 	/* Became sync source.  With protocol >= 96, we still need to send out
@@ -1384,6 +1359,9 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 	struct drbd_tconn *tconn = w->tconn;
 	enum drbd_conns oc = acscw->oc;
 	union drbd_state ns_max = acscw->ns_max;
+	union drbd_state ns_min = acscw->ns_min;
+	struct drbd_conf *mdev;
+	int vnr;
 
 	kfree(acscw);
 
@@ -1391,6 +1369,36 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 	if (oc == C_STANDALONE && ns_max.conn == C_UNCONNECTED)
 		drbd_thread_start(&tconn->receiver);
 
+	if (ns_max.susp_fen) {
+		/* case1: The outdate peer handler is successful: */
+		if (ns_max.pdsk <= D_OUTDATED) {
+			tl_clear(tconn);
+			idr_for_each_entry(&tconn->volumes, mdev, vnr) {
+				if (test_bit(NEW_CUR_UUID, &mdev->flags)) {
+					drbd_uuid_new_current(mdev);
+					clear_bit(NEW_CUR_UUID, &mdev->flags);
+				}
+			}
+			conn_request_state(tconn,
+					   (union drbd_state) { { .susp_fen = 1 } },
+					   (union drbd_state) { { .susp_fen = 0 } },
+					   CS_VERBOSE);
+		}
+		/* case2: The connection was established again: */
+		if (ns_min.conn >= C_CONNECTED) {
+			idr_for_each_entry(&tconn->volumes, mdev, vnr)
+				clear_bit(NEW_CUR_UUID, &mdev->flags);
+			spin_lock_irq(&tconn->req_lock);
+			_tl_restart(tconn, RESEND);
+			_conn_request_state(tconn,
+					    (union drbd_state) { { .susp_fen = 1 } },
+					    (union drbd_state) { { .susp_fen = 0 } },
+					    CS_VERBOSE);
+			spin_unlock_irq(&tconn->req_lock);
+		}
+	}
+
+
 	//conn_err(tconn, STATE_FMT, STATE_ARGS("nms", nms));
 	after_all_state_ch(tconn);
 
-- 
1.7.4.1

