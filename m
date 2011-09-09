Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab1IILRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:17:44 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45646 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781Ab1IILRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:17:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/11] drbd: Calculate and provide ns_min to the w_after_conn_state_ch() work
Date: Fri,  9 Sep 2011 13:17:31 +0200
Message-Id: <1315567056-32314-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
References: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |   42 ++++++++++++++++++++++++++++----------
 1 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index bd50644..cfd923e 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1340,6 +1340,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 struct after_conn_state_chg_work {
 	struct drbd_work w;
 	enum drbd_conns oc;
+	union drbd_state ns_min;
 	union drbd_state ns_max; /* new, max state, over all mdevs */
 	enum chg_state_flags flags;
 };
@@ -1450,11 +1451,17 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 	return rv;
 }
 
-static union drbd_state
+void
 conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
-	       enum chg_state_flags flags)
+	       union drbd_state *pns_min, union drbd_state *pns_max, enum chg_state_flags flags)
 {
-	union drbd_state ns, os, ms = { };
+	union drbd_state ns, os, ns_max = { };
+	union drbd_state ns_min = {
+		{ .role = R_MASK,
+		  .peer = R_MASK,
+		  .disk = D_MASK,
+		  .pdsk = D_MASK
+		} };
 	struct drbd_conf *mdev;
 	enum drbd_state_rv rv;
 	int vnr;
@@ -1474,13 +1481,26 @@ conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 		if (rv < SS_SUCCESS)
 			BUG();
 
-		ms.role = max_t(enum drbd_role, mdev->state.role, ms.role);
-		ms.peer = max_t(enum drbd_role, mdev->state.peer, ms.peer);
-		ms.disk = max_t(enum drbd_disk_state, mdev->state.disk, ms.disk);
-		ms.pdsk = max_t(enum drbd_disk_state, mdev->state.pdsk, ms.pdsk);
+		ns.i = mdev->state.i;
+		ns_max.role = max_t(enum drbd_role, ns.role, ns_max.role);
+		ns_max.peer = max_t(enum drbd_role, ns.peer, ns_max.peer);
+		ns_max.conn = max_t(enum drbd_role, ns.conn, ns_max.conn);
+		ns_max.disk = max_t(enum drbd_disk_state, ns.disk, ns_max.disk);
+		ns_max.pdsk = max_t(enum drbd_disk_state, ns.pdsk, ns_max.pdsk);
+
+		ns_min.role = min_t(enum drbd_role, ns.role, ns_min.role);
+		ns_min.peer = min_t(enum drbd_role, ns.peer, ns_min.peer);
+		ns_min.conn = min_t(enum drbd_role, ns.conn, ns_min.conn);
+		ns_min.disk = min_t(enum drbd_disk_state, ns.disk, ns_min.disk);
+		ns_min.pdsk = min_t(enum drbd_disk_state, ns.pdsk, ns_min.pdsk);
 	}
 
-	return ms;
+	ns_min.susp = ns_max.susp = tconn->susp;
+	ns_min.susp_nod = ns_max.susp_nod = tconn->susp_nod;
+	ns_min.susp_fen = ns_max.susp_fen = tconn->susp_fen;
+
+	*pns_min = ns_min;
+	*pns_max = ns_max;
 }
 
 static enum drbd_state_rv
@@ -1541,7 +1561,7 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 	enum drbd_state_rv rv = SS_SUCCESS;
 	struct after_conn_state_chg_work *acscw;
 	enum drbd_conns oc = tconn->cstate;
-	union drbd_state ns_max, os;
+	union drbd_state ns_max, ns_min, os;
 
 	rv = is_valid_conn_transition(oc, val.conn);
 	if (rv < SS_SUCCESS)
@@ -1558,13 +1578,13 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 	}
 
 	conn_old_common_state(tconn, &os, &flags);
-	ns_max = conn_set_state(tconn, mask, val, flags);
-	ns_max.conn = val.conn;
+	conn_set_state(tconn, mask, val, &ns_min, &ns_max, flags);
 	conn_pr_state_change(tconn, os, ns_max, flags);
 
 	acscw = kmalloc(sizeof(*acscw), GFP_ATOMIC);
 	if (acscw) {
 		acscw->oc = os.conn;
+		acscw->ns_min = ns_min;
 		acscw->ns_max = ns_max;
 		acscw->flags = flags;
 		acscw->w.cb = w_after_conn_state_ch;
-- 
1.7.4.1

