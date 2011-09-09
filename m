Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab1IILTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:19:38 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45598 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765Ab1IILRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:17:39 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/11] drbd: Introduced drbd_read_state()
Date: Fri,  9 Sep 2011 13:17:26 +0200
Message-Id: <1315567056-32314-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
References: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    9 +++++++++
 drivers/block/drbd/drbd_nl.c       |    5 ++---
 drivers/block/drbd/drbd_receiver.c |    6 +++---
 drivers/block/drbd/drbd_state.c    |   15 +++++++--------
 drivers/block/drbd/drbd_state.h    |    6 +++---
 drivers/block/drbd/drbd_worker.c   |    6 +++---
 6 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 54eb96a..ca07afd 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1682,6 +1682,15 @@ _drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	return rv;
 }
 
+static inline union drbd_state drbd_read_state(struct drbd_conf *mdev)
+{
+	union drbd_state rv;
+
+	rv = mdev->state;
+
+	return rv;
+}
+
 #define __drbd_chk_io_error(m,f) __drbd_chk_io_error_(m,f, __func__)
 static inline void __drbd_chk_io_error_(struct drbd_conf *mdev, int forcedetach, const char *where)
 {
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 76b98b8..e43b47a 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1543,8 +1543,8 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		drbd_suspend_al(mdev); /* IO is still suspended here... */
 
 	spin_lock_irq(&mdev->tconn->req_lock);
-	os = mdev->state;
-	ns.i = os.i;
+	os = drbd_read_state(mdev);
+	ns = os;
 	/* If MDF_CONSISTENT is not set go into inconsistent state,
 	   otherwise investigate MDF_WasUpToDate...
 	   If MDF_WAS_UP_TO_DATE is not set go into D_OUTDATED disk state,
@@ -1586,7 +1586,6 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	rv = _drbd_set_state(mdev, ns, CS_VERBOSE, NULL);
-	ns = mdev->state;
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	if (rv < SS_SUCCESS)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 0b51f29..cd0fe24 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3476,7 +3476,7 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 
 	spin_lock_irq(&mdev->tconn->req_lock);
  retry:
-	os = ns = mdev->state;
+	os = ns = drbd_read_state(mdev);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	/* peer says his disk is uptodate, while we think it is inconsistent,
@@ -3562,7 +3562,7 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 	}
 
 	spin_lock_irq(&mdev->tconn->req_lock);
-	if (mdev->state.i != os.i)
+	if (os.i != drbd_read_state(mdev).i)
 		goto retry;
 	clear_bit(CONSIDER_RESYNC, &mdev->flags);
 	ns.peer = peer_state.role;
@@ -3584,7 +3584,7 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 		return -EIO;
 	}
 	rv = _drbd_set_state(mdev, ns, cs_flags, NULL);
-	ns = mdev->state;
+	ns = drbd_read_state(mdev);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	if (rv < SS_SUCCESS) {
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index e2aab0d..2b7ba59 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -145,9 +145,8 @@ drbd_change_state(struct drbd_conf *mdev, enum chg_state_flags f,
 	enum drbd_state_rv rv;
 
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-	ns = apply_mask_val(mdev->state, mask, val);
+	ns = apply_mask_val(drbd_read_state(mdev), mask, val);
 	rv = _drbd_set_state(mdev, ns, f, NULL);
-	ns = mdev->state;
 	spin_unlock_irqrestore(&mdev->tconn->req_lock, flags);
 
 	return rv;
@@ -180,7 +179,7 @@ _req_st_cond(struct drbd_conf *mdev, union drbd_state mask,
 		return SS_CW_FAILED_BY_PEER;
 
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-	os = mdev->state;
+	os = drbd_read_state(mdev);
 	ns = sanitize_state(mdev, apply_mask_val(os, mask, val), NULL);
 	rv = is_valid_transition(os, ns);
 	if (rv == SS_SUCCESS)
@@ -226,7 +225,7 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 		mutex_lock(mdev->state_mutex);
 
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-	os = mdev->state;
+	os = drbd_read_state(mdev);
 	ns = sanitize_state(mdev, apply_mask_val(os, mask, val), NULL);
 	rv = is_valid_transition(os, ns);
 	if (rv < SS_SUCCESS) {
@@ -262,7 +261,7 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 			goto abort;
 		}
 		spin_lock_irqsave(&mdev->tconn->req_lock, flags);
-		ns = apply_mask_val(mdev->state, mask, val);
+		ns = apply_mask_val(drbd_read_state(mdev), mask, val);
 		rv = _drbd_set_state(mdev, ns, f, &done);
 	} else {
 		rv = _drbd_set_state(mdev, ns, f, &done);
@@ -794,7 +793,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	const char *warn_sync_abort = NULL;
 	struct after_state_chg_work *ascw;
 
-	os = mdev->state;
+	os = drbd_read_state(mdev);
 
 	ns = sanitize_state(mdev, ns, &warn_sync_abort);
 	if (ns.i == os.i)
@@ -1412,7 +1411,7 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 	int vnr;
 
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		os = mdev->state;
+		os = drbd_read_state(mdev);
 		ns = sanitize_state(mdev, apply_mask_val(os, mask, val), NULL);
 
 		if (flags & CS_IGN_OUTD_FAIL && ns.disk == D_OUTDATED && os.disk < D_OUTDATED)
@@ -1456,7 +1455,7 @@ conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 		tconn->cstate = val.conn;
 
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		os = mdev->state;
+		os = drbd_read_state(mdev);
 		ns = apply_mask_val(os, mask, val);
 		ns = sanitize_state(mdev, ns, NULL);
 
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index c0331f1..fdcfab9 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -48,12 +48,12 @@ struct drbd_tconn;
 	  val.T2 = (S2); val.T3 = (S3); val; })
 
 #define _NS(D, T, S) \
-	D, ({ union drbd_state __ns; __ns.i = D->state.i; __ns.T = (S); __ns; })
+	D, ({ union drbd_state __ns; __ns = drbd_read_state(D); __ns.T = (S); __ns; })
 #define _NS2(D, T1, S1, T2, S2) \
-	D, ({ union drbd_state __ns; __ns.i = D->state.i; __ns.T1 = (S1); \
+	D, ({ union drbd_state __ns; __ns = drbd_read_state(D); __ns.T1 = (S1); \
 	__ns.T2 = (S2); __ns; })
 #define _NS3(D, T1, S1, T2, S2, T3, S3) \
-	D, ({ union drbd_state __ns; __ns.i = D->state.i; __ns.T1 = (S1); \
+	D, ({ union drbd_state __ns; __ns = drbd_read_state(D); __ns.T1 = (S1); \
 	__ns.T2 = (S2); __ns.T3 = (S3); __ns; })
 
 enum chg_state_flags {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 640d04a..8059ea3 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -781,7 +781,7 @@ int drbd_resync_finished(struct drbd_conf *mdev)
 	ping_peer(mdev);
 
 	spin_lock_irq(&mdev->tconn->req_lock);
-	os = mdev->state;
+	os = drbd_read_state(mdev);
 
 	verify_done = (os.conn == C_VERIFY_S || os.conn == C_VERIFY_T);
 
@@ -1548,7 +1548,7 @@ void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side)
 	}
 
 	write_lock_irq(&global_state_lock);
-	ns = mdev->state;
+	ns = drbd_read_state(mdev);
 
 	ns.aftr_isp = !_drbd_may_sync_now(mdev);
 
@@ -1560,7 +1560,7 @@ void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side)
 		ns.pdsk = D_INCONSISTENT;
 
 	r = __drbd_set_state(mdev, ns, CS_VERBOSE, NULL);
-	ns = mdev->state;
+	ns = drbd_read_state(mdev);
 
 	if (ns.conn < C_CONNECTED)
 		r = SS_UNKNOWN_ERROR;
-- 
1.7.4.1

