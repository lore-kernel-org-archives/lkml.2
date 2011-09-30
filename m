Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab1I3Mu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:50:58 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42735 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589Ab1I3Ms3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:48:29 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/11] drbd: rcu_read_[un]lock() for all idr accesses that do not sleep
Date: Fri, 30 Sep 2011 14:48:18 +0200
Message-Id: <1317386906-19260-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
References: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c     |   12 +++++++---
 drivers/block/drbd/drbd_nl.c       |   41 +++++++++++++++++++++++++----------
 drivers/block/drbd/drbd_receiver.c |    2 +
 drivers/block/drbd/drbd_state.c    |   34 +++++++++++++++++++++++++++--
 drivers/block/drbd/drbd_worker.c   |    4 +++
 5 files changed, 74 insertions(+), 19 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 03b3ffe..c4c0bc5 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -453,8 +453,10 @@ void tl_clear(struct drbd_tconn *tconn)
 	}
 
 	/* ensure bit indicating barrier is required is clear */
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr)
 		clear_bit(CREATE_BARRIER, &mdev->flags);
+	rcu_read_unlock();
 
 	spin_unlock_irq(&tconn->req_lock);
 }
@@ -634,13 +636,15 @@ char *drbd_task_to_thread_name(struct drbd_tconn *tconn, struct task_struct *tas
 
 int conn_lowest_minor(struct drbd_tconn *tconn)
 {
-	int vnr = 0;
 	struct drbd_conf *mdev;
+	int vnr = 0, m;
 
+	rcu_read_lock();
 	mdev = idr_get_next(&tconn->volumes, &vnr);
-	if (!mdev)
-		return -1;
-	return mdev_to_minor(mdev);
+	m = mdev ? mdev_to_minor(mdev) : -1;
+	rcu_read_unlock();
+
+	return m;
 }
 
 #ifdef CONFIG_SMP
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index be2ca81..fc918d0 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -407,12 +407,14 @@ static enum drbd_fencing_p highest_fencing_policy(struct drbd_tconn *tconn)
 	struct drbd_conf *mdev;
 	int vnr;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		if (get_ldev_if_state(mdev, D_CONSISTENT)) {
 			fp = max_t(enum drbd_fencing_p, fp, mdev->ldev->dc.fencing);
 			put_ldev(mdev);
 		}
 	}
+	rcu_read_unlock();
 
 	return fp;
 }
@@ -1664,29 +1666,41 @@ out:
 static bool conn_resync_running(struct drbd_tconn *tconn)
 {
 	struct drbd_conf *mdev;
+	bool rv = false;
 	int vnr;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		if (mdev->state.conn == C_SYNC_SOURCE ||
 		    mdev->state.conn == C_SYNC_TARGET ||
 		    mdev->state.conn == C_PAUSED_SYNC_S ||
-		    mdev->state.conn == C_PAUSED_SYNC_T)
-			return true;
+		    mdev->state.conn == C_PAUSED_SYNC_T) {
+			rv = true;
+			break;
+		}
 	}
-	return false;
+	rcu_read_unlock();
+
+	return rv;
 }
 
 static bool conn_ov_running(struct drbd_tconn *tconn)
 {
 	struct drbd_conf *mdev;
+	bool rv = false;
 	int vnr;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		if (mdev->state.conn == C_VERIFY_S ||
-		    mdev->state.conn == C_VERIFY_T)
-			return true;
+		    mdev->state.conn == C_VERIFY_T) {
+			rv = true;
+			break;
+		}
 	}
-	return false;
+	rcu_read_unlock();
+
+	return rv;
 }
 
 int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
@@ -1912,26 +1926,28 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, i) {
 		if (get_ldev(mdev)) {
 			enum drbd_fencing_p fp = mdev->ldev->dc.fencing;
 			put_ldev(mdev);
 			if (new_conf->wire_protocol == DRBD_PROT_A && fp == FP_STONITH) {
 				retcode = ERR_STONITH_AND_PROT_A;
-				goto fail;
+				goto fail_rcu_unlock;
 			}
 		}
 		if (mdev->state.role == R_PRIMARY && new_conf->want_lose) {
 			retcode = ERR_DISCARD;
-			goto fail;
+			goto fail_rcu_unlock;
 		}
 		if (!mdev->bitmap) {
 			if(drbd_bm_init(mdev)) {
 				retcode = ERR_NOMEM;
-				goto fail;
+				goto fail_rcu_unlock;
 			}
 		}
 	}
+	rcu_read_unlock();
 
 	if (new_conf->on_congestion != OC_BLOCK && new_conf->wire_protocol != DRBD_PROT_A) {
 		retcode = ERR_CONG_NOT_PROTO_A;
@@ -2045,15 +2061,19 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	retcode = _conn_request_state(tconn, NS(conn, C_UNCONNECTED), CS_VERBOSE);
 	spin_unlock_irq(&tconn->req_lock);
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, i) {
 		mdev->send_cnt = 0;
 		mdev->recv_cnt = 0;
 		kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
 	}
+	rcu_read_unlock();
 	conn_reconfig_done(tconn);
 	drbd_adm_finish(info, retcode);
 	return 0;
 
+fail_rcu_unlock:
+	rcu_read_unlock();
 fail:
 	kfree(int_dig_in);
 	kfree(int_dig_vv);
@@ -2616,8 +2636,6 @@ int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
 
 	/* synchronize with drbd_new_tconn/drbd_free_tconn */
 	mutex_lock(&drbd_cfg_mutex);
-	/* synchronize with drbd_delete_device */
-	rcu_read_lock();
 next_tconn:
 	/* revalidate iterator position */
 	list_for_each_entry(tmp, &drbd_tconns, all_tconn) {
@@ -2680,7 +2698,6 @@ next_tconn:
         }
 
 out:
-	rcu_read_unlock();
 	mutex_unlock(&drbd_cfg_mutex);
 	/* where to start the next iteration */
         cb->args[0] = (long)pos;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 0c45eba..92ecb22 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4828,11 +4828,13 @@ static int tconn_finish_peer_reqs(struct drbd_tconn *tconn)
 		set_bit(SIGNAL_ASENDER, &tconn->flags);
 
 		spin_lock_irq(&tconn->req_lock);
+		rcu_read_lock();
 		idr_for_each_entry(&tconn->volumes, mdev, i) {
 			not_empty = !list_empty(&mdev->done_ee);
 			if (not_empty)
 				break;
 		}
+		rcu_read_unlock();
 		spin_unlock_irq(&tconn->req_lock);
 	} while (not_empty);
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 694bd3f..0aed33b 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -56,15 +56,21 @@ static inline bool is_susp(union drbd_state s)
 bool conn_all_vols_unconf(struct drbd_tconn *tconn)
 {
 	struct drbd_conf *mdev;
+	bool rv = true;
 	int vnr;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		if (mdev->state.disk != D_DISKLESS ||
 		    mdev->state.conn != C_STANDALONE ||
-		    mdev->state.role != R_SECONDARY)
-			return false;
+		    mdev->state.role != R_SECONDARY) {
+			rv = false;
+			break;
+		}
 	}
-	return true;
+	rcu_read_unlock();
+
+	return rv;
 }
 
 enum drbd_role conn_highest_role(struct drbd_tconn *tconn)
@@ -73,8 +79,10 @@ enum drbd_role conn_highest_role(struct drbd_tconn *tconn)
 	struct drbd_conf *mdev;
 	int vnr;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr)
 		role = max_t(enum drbd_role, role, mdev->state.role);
+	rcu_read_unlock();
 
 	return role;
 }
@@ -85,8 +93,10 @@ enum drbd_role conn_highest_peer(struct drbd_tconn *tconn)
 	struct drbd_conf *mdev;
 	int vnr;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr)
 		peer = max_t(enum drbd_role, peer, mdev->state.peer);
+	rcu_read_unlock();
 
 	return peer;
 }
@@ -97,8 +107,10 @@ enum drbd_disk_state conn_highest_disk(struct drbd_tconn *tconn)
 	struct drbd_conf *mdev;
 	int vnr;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr)
 		ds = max_t(enum drbd_disk_state, ds, mdev->state.disk);
+	rcu_read_unlock();
 
 	return ds;
 }
@@ -109,8 +121,10 @@ enum drbd_disk_state conn_lowest_disk(struct drbd_tconn *tconn)
 	struct drbd_conf *mdev;
 	int vnr;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr)
 		ds = min_t(enum drbd_disk_state, ds, mdev->state.disk);
+	rcu_read_unlock();
 
 	return ds;
 }
@@ -121,8 +135,10 @@ enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn)
 	struct drbd_conf *mdev;
 	int vnr;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr)
 		ds = max_t(enum drbd_disk_state, ds, mdev->state.pdsk);
+	rcu_read_unlock();
 
 	return ds;
 }
@@ -133,8 +149,10 @@ enum drbd_disk_state conn_lowest_conn(struct drbd_tconn *tconn)
 	struct drbd_conf *mdev;
 	int vnr;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr)
 		conn = min_t(enum drbd_conns, conn, mdev->state.conn);
+	rcu_read_unlock();
 
 	return conn;
 }
@@ -1388,12 +1406,14 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 		/* case1: The outdate peer handler is successful: */
 		if (ns_max.pdsk <= D_OUTDATED) {
 			tl_clear(tconn);
+			rcu_read_lock();
 			idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 				if (test_bit(NEW_CUR_UUID, &mdev->flags)) {
 					drbd_uuid_new_current(mdev);
 					clear_bit(NEW_CUR_UUID, &mdev->flags);
 				}
 			}
+			rcu_read_unlock();
 			conn_request_state(tconn,
 					   (union drbd_state) { { .susp_fen = 1 } },
 					   (union drbd_state) { { .susp_fen = 0 } },
@@ -1401,8 +1421,10 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 		}
 		/* case2: The connection was established again: */
 		if (ns_min.conn >= C_CONNECTED) {
+			rcu_read_lock();
 			idr_for_each_entry(&tconn->volumes, mdev, vnr)
 				clear_bit(NEW_CUR_UUID, &mdev->flags);
+			rcu_read_unlock();
 			spin_lock_irq(&tconn->req_lock);
 			_tl_restart(tconn, RESEND);
 			_conn_request_state(tconn,
@@ -1427,6 +1449,7 @@ void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum
 	struct drbd_conf *mdev;
 	int vnr, first_vol = 1;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		os = mdev->state;
 
@@ -1451,6 +1474,7 @@ void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum
 		if (cs.pdsk != os.pdsk)
 			flags &= ~CS_DC_PDSK;
 	}
+	rcu_read_unlock();
 
 	*pf |= CS_DC_MASK;
 	*pf &= flags;
@@ -1466,6 +1490,7 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 	struct drbd_conf *mdev;
 	int vnr;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		os = drbd_read_state(mdev);
 		ns = sanitize_state(mdev, apply_mask_val(os, mask, val), NULL);
@@ -1491,6 +1516,7 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 		if (rv < SS_SUCCESS)
 			break;
 	}
+	rcu_read_unlock();
 
 	if (rv < SS_SUCCESS && flags & CS_VERBOSE)
 		print_st_err(mdev, os, ns, rv);
@@ -1516,6 +1542,7 @@ conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 	if (mask.conn == C_MASK)
 		tconn->cstate = val.conn;
 
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		os = drbd_read_state(mdev);
 		ns = apply_mask_val(os, mask, val);
@@ -1541,6 +1568,7 @@ conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 		ns_min.disk = min_t(enum drbd_disk_state, ns.disk, ns_min.disk);
 		ns_min.pdsk = min_t(enum drbd_disk_state, ns.pdsk, ns_min.pdsk);
 	}
+	rcu_read_unlock();
 
 	ns_min.susp = ns_max.susp = tconn->susp;
 	ns_min.susp_nod = ns_max.susp_nod = tconn->susp_nod;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 62536bc..536eb05 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1350,6 +1350,7 @@ static int _drbd_pause_after(struct drbd_conf *mdev)
 	struct drbd_conf *odev;
 	int i, rv = 0;
 
+	rcu_read_lock();
 	idr_for_each_entry(&minors, odev, i) {
 		if (odev->state.conn == C_STANDALONE && odev->state.disk == D_DISKLESS)
 			continue;
@@ -1357,6 +1358,7 @@ static int _drbd_pause_after(struct drbd_conf *mdev)
 			rv |= (__drbd_set_state(_NS(odev, aftr_isp, 1), CS_HARD, NULL)
 			       != SS_NOTHING_TO_DO);
 	}
+	rcu_read_unlock();
 
 	return rv;
 }
@@ -1372,6 +1374,7 @@ static int _drbd_resume_next(struct drbd_conf *mdev)
 	struct drbd_conf *odev;
 	int i, rv = 0;
 
+	rcu_read_lock();
 	idr_for_each_entry(&minors, odev, i) {
 		if (odev->state.conn == C_STANDALONE && odev->state.disk == D_DISKLESS)
 			continue;
@@ -1382,6 +1385,7 @@ static int _drbd_resume_next(struct drbd_conf *mdev)
 				       != SS_NOTHING_TO_DO) ;
 		}
 	}
+	rcu_read_unlock();
 	return rv;
 }
 
-- 
1.7.4.1

