Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1HYPK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:10:26 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33393 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab1HYPKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 112/118] drbd: Introduced tconn->cstate_mutex
Date: Thu, 25 Aug 2011 17:08:48 +0200
Message-Id: <1314284934-17999-113-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In compatibility mode with old DRBDs, use that as the state_mutex
as well.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    8 +++++---
 drivers/block/drbd/drbd_main.c     |    4 +++-
 drivers/block/drbd/drbd_nl.c       |    8 ++++----
 drivers/block/drbd/drbd_receiver.c |   11 ++++++++---
 drivers/block/drbd/drbd_state.c    |    4 ++--
 drivers/block/drbd/drbd_worker.c   |    8 ++++----
 6 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d5e45c2..a321bf9 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -916,8 +916,9 @@ enum {
 struct drbd_tconn {			/* is a resource from the config file */
 	char *name;			/* Resource name */
 	struct list_head all_tconn;	/* List of all drbd_tconn, prot by global_state_lock */
-	struct idr volumes;             /* <tconn, vnr> to mdev mapping */
-	enum drbd_conns cstate;        /* Only C_STANDALONE to C_WF_REPORT_PARAMS */
+	struct idr volumes;		/* <tconn, vnr> to mdev mapping */
+	enum drbd_conns cstate;		/* Only C_STANDALONE to C_WF_REPORT_PARAMS */
+	struct mutex cstate_mutex;	/* Protects graceful disconnects */
 
 	unsigned long flags;
 	struct net_conf *net_conf;	/* protected by get_net_conf() and put_net_conf() */
@@ -1079,7 +1080,8 @@ struct drbd_conf {
 	unsigned long comm_bm_set; /* communicated number of set bits. */
 	struct bm_io_work bm_io_work;
 	u64 ed_uuid; /* UUID of the exposed data */
-	struct mutex state_mutex;
+	struct mutex own_state_mutex;
+	struct mutex *state_mutex; /* either own_state_mutex or mdev->tconn->cstate_mutex */
 	char congestion_reason;  /* Why we where congested... */
 	atomic_t rs_sect_in; /* for incoming resync data rate, SyncTarget */
 	atomic_t rs_sect_ev; /* for submitted resync data rate, both */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 2c1df75..adfef15 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1813,7 +1813,8 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	atomic_set(&mdev->ap_in_flight, 0);
 
 	mutex_init(&mdev->md_io_mutex);
-	mutex_init(&mdev->state_mutex);
+	mutex_init(&mdev->own_state_mutex);
+	mdev->state_mutex = &mdev->own_state_mutex;
 
 	spin_lock_init(&mdev->al_lock);
 	spin_lock_init(&mdev->peer_seq_lock);
@@ -2201,6 +2202,7 @@ struct drbd_tconn *drbd_new_tconn(char *name)
 		goto fail;
 
 	tconn->cstate = C_STANDALONE;
+	mutex_init(&tconn->cstate_mutex);
 	spin_lock_init(&tconn->req_lock);
 	atomic_set(&tconn->net_cnt, 0);
 	init_waitqueue_head(&tconn->net_cnt_wait);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index eeb284a..3d8e631 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -320,7 +320,7 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 	if (new_role == R_PRIMARY)
 		request_ping(mdev->tconn); /* Detect a dead peer ASAP */
 
-	mutex_lock(&mdev->state_mutex);
+	mutex_lock(mdev->state_mutex);
 
 	mask.i = 0; mask.role = R_MASK;
 	val.i  = 0; val.role  = new_role;
@@ -439,7 +439,7 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 
 	kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
  fail:
-	mutex_unlock(&mdev->state_mutex);
+	mutex_unlock(mdev->state_mutex);
 	return rv;
 }
 
@@ -2162,7 +2162,7 @@ static int drbd_nl_new_c_uuid(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
 		return 0;
 	}
 
-	mutex_lock(&mdev->state_mutex); /* Protects us against serialized state changes. */
+	mutex_lock(mdev->state_mutex); /* Protects us against serialized state changes. */
 
 	if (!get_ldev(mdev)) {
 		retcode = ERR_NO_DISK;
@@ -2204,7 +2204,7 @@ static int drbd_nl_new_c_uuid(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
 out_dec:
 	put_ldev(mdev);
 out:
-	mutex_unlock(&mdev->state_mutex);
+	mutex_unlock(mdev->state_mutex);
 
 	reply->ret_code = retcode;
 	return 0;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6a30180..86d1e9b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -753,6 +753,10 @@ static int drbd_connected(int vnr, void *p, void *data)
 	atomic_set(&mdev->packet_seq, 0);
 	mdev->peer_seq = 0;
 
+	mdev->state_mutex = mdev->tconn->agreed_pro_version < 100 ?
+		&mdev->tconn->cstate_mutex :
+		&mdev->own_state_mutex;
+
 	ok &= drbd_send_sync_param(mdev, &mdev->sync_conf);
 	ok &= drbd_send_sizes(mdev, 0, 0);
 	ok &= drbd_send_uuids(mdev);
@@ -760,6 +764,7 @@ static int drbd_connected(int vnr, void *p, void *data)
 	clear_bit(USE_DEGR_WFC_T, &mdev->flags);
 	clear_bit(RESIZE_PENDING, &mdev->flags);
 
+
 	return !ok;
 }
 
@@ -3170,8 +3175,8 @@ static int receive_uuids(struct drbd_conf *mdev, enum drbd_packet cmd,
 	   ongoing cluster wide state change is finished. That is important if
 	   we are primary and are detaching from our disk. We need to see the
 	   new disk state... */
-	mutex_lock(&mdev->state_mutex);
-	mutex_unlock(&mdev->state_mutex);
+	mutex_lock(mdev->state_mutex);
+	mutex_unlock(mdev->state_mutex);
 	if (mdev->state.conn >= C_CONNECTED && mdev->state.disk < D_INCONSISTENT)
 		updated_uuids |= drbd_set_ed_uuid(mdev, p_uuid[UI_CURRENT]);
 
@@ -3222,7 +3227,7 @@ static int receive_req_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 	val.i = be32_to_cpu(p->val);
 
 	if (test_bit(DISCARD_CONCURRENT, &mdev->tconn->flags) &&
-	    mutex_is_locked(&mdev->state_mutex)) {
+	    mutex_is_locked(mdev->state_mutex)) {
 		drbd_send_sr_reply(mdev, SS_CONCURRENT_ST_CHG);
 		return true;
 	}
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index bb05d67..29308e0 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -163,7 +163,7 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 	init_completion(&done);
 
 	if (f & CS_SERIALIZE)
-		mutex_lock(&mdev->state_mutex);
+		mutex_lock(mdev->state_mutex);
 
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	os = mdev->state;
@@ -215,7 +215,7 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 
 abort:
 	if (f & CS_SERIALIZE)
-		mutex_unlock(&mdev->state_mutex);
+		mutex_unlock(mdev->state_mutex);
 
 	return rv;
 }
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index e844871..9a9a00e 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1538,19 +1538,19 @@ void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side)
 	if (current == mdev->tconn->worker.task) {
 		/* The worker should not sleep waiting for state_mutex,
 		   that can take long */
-		if (!mutex_trylock(&mdev->state_mutex)) {
+		if (!mutex_trylock(mdev->state_mutex)) {
 			set_bit(B_RS_H_DONE, &mdev->flags);
 			mdev->start_resync_timer.expires = jiffies + HZ/5;
 			add_timer(&mdev->start_resync_timer);
 			return;
 		}
 	} else {
-		mutex_lock(&mdev->state_mutex);
+		mutex_lock(mdev->state_mutex);
 	}
 	clear_bit(B_RS_H_DONE, &mdev->flags);
 
 	if (!get_ldev_if_state(mdev, D_NEGOTIATING)) {
-		mutex_unlock(&mdev->state_mutex);
+		mutex_unlock(mdev->state_mutex);
 		return;
 	}
 
@@ -1639,7 +1639,7 @@ void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side)
 		drbd_md_sync(mdev);
 	}
 	put_ldev(mdev);
-	mutex_unlock(&mdev->state_mutex);
+	mutex_unlock(mdev->state_mutex);
 }
 
 static int _worker_dying(int vnr, void *p, void *data)
-- 
1.7.4.1

