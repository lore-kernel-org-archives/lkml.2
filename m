Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab1HYPKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:10:21 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33221 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab1HYPKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:19 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 108/118] drbd: Removed the os parameter form sanitize_state()
Date: Thu, 25 Aug 2011 17:08:44 +0200
Message-Id: <1314284934-17999-109-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index b381faa..02516ed 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -48,8 +48,8 @@ static void after_conn_state_ch(struct drbd_tconn *tconn, union drbd_state os,
 static enum drbd_state_rv is_valid_state(struct drbd_conf *, union drbd_state);
 static enum drbd_state_rv is_valid_soft_transition(union drbd_state, union drbd_state);
 static enum drbd_state_rv is_valid_transition(union drbd_state os, union drbd_state ns);
-static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state os,
-				       union drbd_state ns, const char **warn_sync_abort);
+static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state ns,
+				       const char **warn_sync_abort);
 
 /**
  * cl_wide_st_chg() - true if the state change is a cluster wide one
@@ -116,7 +116,7 @@ _req_st_cond(struct drbd_conf *mdev, union drbd_state mask,
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	os = mdev->state;
 	ns.i = (os.i & ~mask.i) | val.i;
-	ns = sanitize_state(mdev, os, ns, NULL);
+	ns = sanitize_state(mdev, ns, NULL);
 	rv = is_valid_transition(os, ns);
 	if (rv == SS_SUCCESS)
 		rv = SS_UNKNOWN_ERROR;  /* cont waiting, otherwise fail. */
@@ -163,7 +163,7 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	os = mdev->state;
 	ns.i = (os.i & ~mask.i) | val.i;
-	ns = sanitize_state(mdev, os, ns, NULL);
+	ns = sanitize_state(mdev, ns, NULL);
 	rv = is_valid_transition(os, ns);
 	if (rv < SS_SUCCESS)
 		goto abort;
@@ -436,6 +436,13 @@ is_valid_transition(union drbd_state os, union drbd_state ns)
 	if (ns.disk == D_FAILED && os.disk == D_DISKLESS)
 		rv = SS_IS_DISKLESS;
 
+	/* if we are only D_ATTACHING yet,
+	 * we can (and should) go directly to D_DISKLESS. */
+	if (ns.disk == D_FAILED && os.disk == D_ATTACHING) {
+		printk("TODO: FIX ME\n");
+		rv = SS_IS_DISKLESS;
+	}
+
 	return rv;
 }
 
@@ -449,8 +456,8 @@ is_valid_transition(union drbd_state os, union drbd_state ns)
  * When we loose connection, we have to set the state of the peers disk (pdsk)
  * to D_UNKNOWN. This rule and many more along those lines are in this function.
  */
-static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state os,
-				       union drbd_state ns, const char **warn_sync_abort)
+static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state ns,
+				       const char **warn_sync_abort)
 {
 	enum drbd_fencing_p fp;
 	enum drbd_disk_state disk_min, disk_max, pdsk_min, pdsk_max;
@@ -461,11 +468,6 @@ static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state
 		put_ldev(mdev);
 	}
 
-	/* if we are only D_ATTACHING yet,
-	 * we can (and should) go directly to D_DISKLESS. */
-	if (ns.disk == D_FAILED && os.disk == D_ATTACHING)
-		ns.disk = D_DISKLESS;
-
 	/* Implications from connection to peer and peer_isp */
 	if (ns.conn < C_CONNECTED) {
 		ns.peer_isp = 0;
@@ -478,12 +480,12 @@ static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state
 	if (ns.conn == C_STANDALONE && ns.disk == D_DISKLESS && ns.role == R_SECONDARY)
 		ns.aftr_isp = 0;
 
+	/* An implication of the disk states onto the connection state */
 	/* Abort resync if a disk fails/detaches */
-	if (os.conn > C_CONNECTED && ns.conn > C_CONNECTED &&
-	    (ns.disk <= D_FAILED || ns.pdsk <= D_FAILED)) {
+	if (ns.conn > C_CONNECTED && (ns.disk <= D_FAILED || ns.pdsk <= D_FAILED)) {
 		if (warn_sync_abort)
 			*warn_sync_abort =
-				os.conn == C_VERIFY_S || os.conn == C_VERIFY_T ?
+				ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T ?
 				"Online-verify" : "Resync";
 		ns.conn = C_CONNECTED;
 	}
@@ -591,13 +593,11 @@ static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state
 	}
 
 	if (fp == FP_STONITH &&
-	    (ns.role == R_PRIMARY && ns.conn < C_CONNECTED && ns.pdsk > D_OUTDATED) &&
-	    !(os.role == R_PRIMARY && os.conn < C_CONNECTED && os.pdsk > D_OUTDATED))
+	    (ns.role == R_PRIMARY && ns.conn < C_CONNECTED && ns.pdsk > D_OUTDATED))
 		ns.susp_fen = 1; /* Suspend IO while fence-peer handler runs (peer lost) */
 
 	if (mdev->sync_conf.on_no_data == OND_SUSPEND_IO &&
-	    (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE) &&
-	    !(os.role == R_PRIMARY && os.disk < D_UP_TO_DATE && os.pdsk < D_UP_TO_DATE))
+	    (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE))
 		ns.susp_nod = 1; /* Suspend IO while no data available (no accessible data available) */
 
 	if (ns.aftr_isp || ns.peer_isp || ns.user_isp) {
@@ -668,8 +668,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 
 	os = mdev->state;
 
-	ns = sanitize_state(mdev, os, ns, &warn_sync_abort);
-
+	ns = sanitize_state(mdev, ns, &warn_sync_abort);
 	if (ns.i == os.i)
 		return SS_NOTHING_TO_DO;
 
-- 
1.7.4.1

