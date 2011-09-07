Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1IGQv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:51:56 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48565 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1IGQp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:45:57 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/14] drbd: Converted drbd_try_outdate_peer() from mdev to tconn
Date: Wed,  7 Sep 2011 16:17:33 +0200
Message-Id: <1315405061-1473-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
References: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    4 +-
 drivers/block/drbd/drbd_nl.c       |  139 ++++++++++++++++--------------------
 drivers/block/drbd/drbd_receiver.c |    7 +-
 drivers/block/drbd/drbd_state.c    |   62 +++++++++++++----
 drivers/block/drbd/drbd_state.h    |    5 ++
 include/linux/drbd.h               |    3 +-
 6 files changed, 124 insertions(+), 96 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 04716df..47a435a 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1472,8 +1472,8 @@ extern void drbd_reconsider_max_bio_size(struct drbd_conf *mdev);
 extern enum drbd_state_rv drbd_set_role(struct drbd_conf *mdev,
 					enum drbd_role new_role,
 					int force);
-extern enum drbd_disk_state drbd_try_outdate_peer(struct drbd_conf *mdev);
-extern void drbd_try_outdate_peer_async(struct drbd_conf *mdev);
+extern bool conn_try_outdate_peer(struct drbd_tconn *tconn);
+extern void conn_try_outdate_peer_async(struct drbd_tconn *tconn);
 extern int drbd_khelper(struct drbd_conf *mdev, char *cmd);
 
 /* drbd_worker.c */
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 9a0e446..931ffc4 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -401,116 +401,113 @@ int conn_khelper(struct drbd_tconn *tconn, char *cmd)
 	return ret;
 }
 
-enum drbd_disk_state drbd_try_outdate_peer(struct drbd_conf *mdev)
+static enum drbd_fencing_p highest_fencing_policy(struct drbd_tconn *tconn)
 {
+	enum drbd_fencing_p fp = FP_NOT_AVAIL;
+	struct drbd_conf *mdev;
+	int vnr;
+
+	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
+		if (get_ldev_if_state(mdev, D_CONSISTENT)) {
+			fp = max_t(enum drbd_fencing_p, fp, mdev->ldev->dc.fencing);
+			put_ldev(mdev);
+		}
+	}
+
+	return fp;
+}
+
+bool conn_try_outdate_peer(struct drbd_tconn *tconn)
+{
+	union drbd_state mask = { { .susp_fen = 1 } };
+	union drbd_state val = { };
+	enum drbd_fencing_p fp;
 	char *ex_to_string;
 	int r;
-	enum drbd_disk_state nps;
-	enum drbd_fencing_p fp;
 
-	D_ASSERT(mdev->state.pdsk == D_UNKNOWN);
+	if (tconn->cstate >= C_WF_REPORT_PARAMS) {
+		conn_err(tconn, "Expected cstate < C_WF_REPORT_PARAMS\n");
+		return false;
+	}
 
-	if (get_ldev_if_state(mdev, D_CONSISTENT)) {
-		fp = mdev->ldev->dc.fencing;
-		put_ldev(mdev);
-	} else {
-		dev_warn(DEV, "Not fencing peer, I'm not even Consistent myself.\n");
-		nps = mdev->state.pdsk;
+	fp = highest_fencing_policy(tconn);
+	switch (fp) {
+	case FP_NOT_AVAIL:
+		conn_warn(tconn, "Not fencing peer, I'm not even Consistent myself.\n");
 		goto out;
+	case FP_DONT_CARE:
+		return true;
+	default: ;
 	}
 
-	r = drbd_khelper(mdev, "fence-peer");
+	r = conn_khelper(tconn, "fence-peer");
 
 	switch ((r>>8) & 0xff) {
 	case 3: /* peer is inconsistent */
 		ex_to_string = "peer is inconsistent or worse";
-		nps = D_INCONSISTENT;
+		mask.pdsk = D_MASK;
+		val.pdsk = D_INCONSISTENT;
 		break;
 	case 4: /* peer got outdated, or was already outdated */
 		ex_to_string = "peer was fenced";
-		nps = D_OUTDATED;
+		mask.pdsk = D_MASK;
+		val.pdsk = D_OUTDATED;
 		break;
 	case 5: /* peer was down */
-		if (mdev->state.disk == D_UP_TO_DATE) {
+		if (conn_highest_disk(tconn) == D_UP_TO_DATE) {
 			/* we will(have) create(d) a new UUID anyways... */
 			ex_to_string = "peer is unreachable, assumed to be dead";
-			nps = D_OUTDATED;
+			mask.pdsk = D_MASK;
+			val.pdsk = D_OUTDATED;
 		} else {
 			ex_to_string = "peer unreachable, doing nothing since disk != UpToDate";
-			nps = mdev->state.pdsk;
 		}
 		break;
 	case 6: /* Peer is primary, voluntarily outdate myself.
 		 * This is useful when an unconnected R_SECONDARY is asked to
 		 * become R_PRIMARY, but finds the other peer being active. */
 		ex_to_string = "peer is active";
-		dev_warn(DEV, "Peer is primary, outdating myself.\n");
-		nps = D_UNKNOWN;
-		_drbd_request_state(mdev, NS(disk, D_OUTDATED), CS_WAIT_COMPLETE);
+		conn_warn(tconn, "Peer is primary, outdating myself.\n");
+		mask.disk = D_MASK;
+		val.disk = D_OUTDATED;
 		break;
 	case 7:
 		if (fp != FP_STONITH)
-			dev_err(DEV, "fence-peer() = 7 && fencing != Stonith !!!\n");
+			conn_err(tconn, "fence-peer() = 7 && fencing != Stonith !!!\n");
 		ex_to_string = "peer was stonithed";
-		nps = D_OUTDATED;
+		mask.pdsk = D_MASK;
+		val.pdsk = D_OUTDATED;
 		break;
 	default:
 		/* The script is broken ... */
-		nps = D_UNKNOWN;
-		dev_err(DEV, "fence-peer helper broken, returned %d\n", (r>>8)&0xff);
-		return nps;
+		conn_err(tconn, "fence-peer helper broken, returned %d\n", (r>>8)&0xff);
+		return false; /* Eventually leave IO frozen */
 	}
 
-	dev_info(DEV, "fence-peer helper returned %d (%s)\n",
-			(r>>8) & 0xff, ex_to_string);
-
-out:
-	if (mdev->state.susp_fen && nps >= D_UNKNOWN) {
-		/* The handler was not successful... unfreeze here, the
-		   state engine can not unfreeze... */
-		_drbd_request_state(mdev, NS(susp_fen, 0), CS_VERBOSE);
-	}
+	conn_info(tconn, "fence-peer helper returned %d (%s)\n",
+		  (r>>8) & 0xff, ex_to_string);
 
-	return nps;
+ out:
+	conn_request_state(tconn, mask, val, CS_VERBOSE);
+	return conn_highest_pdsk(tconn) <= D_OUTDATED;
 }
 
 static int _try_outdate_peer_async(void *data)
 {
-	struct drbd_conf *mdev = (struct drbd_conf *)data;
-	enum drbd_disk_state nps;
-	union drbd_state ns;
-
-	nps = drbd_try_outdate_peer(mdev);
-
-	/* Not using
-	   drbd_request_state(mdev, NS(pdsk, nps));
-	   here, because we might were able to re-establish the connection
-	   in the meantime. This can only partially be solved in the state's
-	   engine is_valid_state() and is_valid_state_transition()
-	   functions.
+	struct drbd_tconn *tconn = (struct drbd_tconn *)data;
 
-	   nps can be D_INCONSISTENT, D_OUTDATED or D_UNKNOWN.
-	   pdsk == D_INCONSISTENT while conn >= C_CONNECTED is valid,
-	   therefore we have to have the pre state change check here.
-	*/
-	spin_lock_irq(&mdev->tconn->req_lock);
-	ns = mdev->state;
-	if (ns.conn < C_WF_REPORT_PARAMS) {
-		ns.pdsk = nps;
-		_drbd_set_state(mdev, ns, CS_VERBOSE, NULL);
-	}
-	spin_unlock_irq(&mdev->tconn->req_lock);
+	conn_try_outdate_peer(tconn);
 
 	return 0;
 }
 
-void drbd_try_outdate_peer_async(struct drbd_conf *mdev)
+void conn_try_outdate_peer_async(struct drbd_tconn *tconn)
 {
 	struct task_struct *opa;
 
-	opa = kthread_run(_try_outdate_peer_async, mdev, "drbd%d_a_helper", mdev_to_minor(mdev));
+	opa = kthread_run(_try_outdate_peer_async, tconn, "drbd_async_h");
 	if (IS_ERR(opa))
-		dev_err(DEV, "out of mem, failed to invoke fence-peer helper\n");
+		conn_err(tconn, "out of mem, failed to invoke fence-peer helper\n");
 }
 
 enum drbd_state_rv
@@ -521,7 +518,6 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 	int try = 0;
 	int forced = 0;
 	union drbd_state mask, val;
-	enum drbd_disk_state nps;
 
 	if (new_role == R_PRIMARY)
 		request_ping(mdev->tconn); /* Detect a dead peer ASAP */
@@ -554,32 +550,23 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 		if (rv == SS_NO_UP_TO_DATE_DISK &&
 		    mdev->state.disk == D_CONSISTENT && mask.pdsk == 0) {
 			D_ASSERT(mdev->state.pdsk == D_UNKNOWN);
-			nps = drbd_try_outdate_peer(mdev);
 
-			if (nps == D_OUTDATED || nps == D_INCONSISTENT) {
+			if (conn_try_outdate_peer(mdev->tconn)) {
 				val.disk = D_UP_TO_DATE;
 				mask.disk = D_MASK;
 			}
-
-			val.pdsk = nps;
-			mask.pdsk = D_MASK;
-
 			continue;
 		}
 
 		if (rv == SS_NOTHING_TO_DO)
 			goto out;
 		if (rv == SS_PRIMARY_NOP && mask.pdsk == 0) {
-			nps = drbd_try_outdate_peer(mdev);
-
-			if (force && nps > D_OUTDATED) {
+			if (!conn_try_outdate_peer(mdev->tconn) && force) {
 				dev_warn(DEV, "Forced into split brain situation!\n");
-				nps = D_OUTDATED;
-			}
-
-			mask.pdsk = D_MASK;
-			val.pdsk  = nps;
+				mask.pdsk = D_MASK;
+				val.pdsk  = D_OUTDATED;
 
+			}
 			continue;
 		}
 		if (rv == SS_TWO_PRIMARIES) {
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 449637f..08140d9 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4028,9 +4028,11 @@ static void drbd_disconnect(struct drbd_tconn *tconn)
 	drbd_free_sock(tconn);
 
 	idr_for_each(&tconn->volumes, drbd_disconnected, tconn);
-
 	conn_info(tconn, "Connection closed\n");
 
+	if (conn_highest_role(tconn) == R_PRIMARY && conn_highest_pdsk(tconn) >= D_UNKNOWN)
+		conn_try_outdate_peer_async(tconn);
+
 	spin_lock_irq(&tconn->req_lock);
 	oc = tconn->cstate;
 	if (oc >= C_UNCONNECTED)
@@ -4107,9 +4109,6 @@ static int drbd_disconnected(int vnr, void *p, void *data)
 		put_ldev(mdev);
 	}
 
-	if (mdev->state.role == R_PRIMARY && fp >= FP_RESOURCE && mdev->state.pdsk >= D_UNKNOWN)
-		drbd_try_outdate_peer_async(mdev);
-
 	/* serialize with bitmap writeout triggered by the state change,
 	 * if any. */
 	wait_event(mdev->misc_wait, !test_bit(BITMAP_IO, &mdev->flags));
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index a14511b..280b31c 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -62,6 +62,54 @@ bool conn_all_vols_unconf(struct drbd_tconn *tconn)
 	return true;
 }
 
+enum drbd_role conn_highest_role(struct drbd_tconn *tconn)
+{
+	enum drbd_role role = R_UNKNOWN;
+	struct drbd_conf *mdev;
+	int vnr;
+
+	idr_for_each_entry(&tconn->volumes, mdev, vnr)
+		role = max_t(enum drbd_role, role, mdev->state.role);
+
+	return role;
+}
+
+enum drbd_role conn_highest_peer(struct drbd_tconn *tconn)
+{
+	enum drbd_role peer = R_UNKNOWN;
+	struct drbd_conf *mdev;
+	int vnr;
+
+	idr_for_each_entry(&tconn->volumes, mdev, vnr)
+		peer = max_t(enum drbd_role, peer, mdev->state.role);
+
+	return peer;
+}
+
+enum drbd_disk_state conn_highest_disk(struct drbd_tconn *tconn)
+{
+	enum drbd_disk_state ds = D_DISKLESS;
+	struct drbd_conf *mdev;
+	int vnr;
+
+	idr_for_each_entry(&tconn->volumes, mdev, vnr)
+		ds = max_t(enum drbd_disk_state, ds, mdev->state.disk);
+
+	return ds;
+}
+
+enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn)
+{
+	enum drbd_disk_state ds = D_DISKLESS;
+	struct drbd_conf *mdev;
+	int vnr;
+
+	idr_for_each_entry(&tconn->volumes, mdev, vnr)
+		ds = max_t(enum drbd_disk_state, ds, mdev->state.pdsk);
+
+	return ds;
+}
+
 /**
  * cl_wide_st_chg() - true if the state change is a cluster wide one
  * @mdev:	DRBD device.
@@ -330,18 +378,6 @@ static void print_state_change(struct drbd_conf *mdev, union drbd_state os, unio
 		dev_info(DEV, "%s\n", pb);
 }
 
-static bool vol_has_primary_peer(struct drbd_tconn *tconn)
-{
-	struct drbd_conf *mdev;
-	int vnr;
-
-	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
-		if (mdev->state.peer == R_PRIMARY)
-			return true;
-	}
-	return false;
-}
-
 /**
  * is_valid_state() - Returns an SS_ error code if ns is not valid
  * @mdev:	DRBD device.
@@ -365,7 +401,7 @@ is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
 		if (!mdev->tconn->net_conf->two_primaries && ns.role == R_PRIMARY) {
 			if (ns.peer == R_PRIMARY)
 				rv = SS_TWO_PRIMARIES;
-			else if (vol_has_primary_peer(mdev->tconn))
+			else if (conn_highest_peer(mdev->tconn) == R_PRIMARY)
 				rv = SS_O_VOL_PEER_PRI;
 			}
 		put_net_conf(mdev->tconn);
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index 55df072..394a199 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -110,4 +110,9 @@ static inline int drbd_request_state(struct drbd_conf *mdev,
 	return _drbd_request_state(mdev, mask, val, CS_VERBOSE + CS_ORDERED);
 }
 
+enum drbd_role conn_highest_role(struct drbd_tconn *tconn);
+enum drbd_role conn_highest_peer(struct drbd_tconn *tconn);
+enum drbd_disk_state conn_highest_disk(struct drbd_tconn *tconn);
+enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn);
+
 #endif
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 9cdb888..60d3088 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -65,7 +65,8 @@ enum drbd_io_error_p {
 };
 
 enum drbd_fencing_p {
-	FP_DONT_CARE,
+	FP_NOT_AVAIL = -1, /* Not a policy */
+	FP_DONT_CARE = 0,
 	FP_RESOURCE,
 	FP_STONITH
 };
-- 
1.7.4.1

