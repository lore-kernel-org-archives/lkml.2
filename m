Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965445Ab1JGLal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:30:41 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35840 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759831Ab1JGL1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:27:49 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/12] drbd: Refcounting for mdev objects
Date: Fri,  7 Oct 2011 13:27:34 +0200
Message-Id: <1317986865-3706-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
References: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparing removal of drbd_cfg_rwsem

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    3 ++-
 drivers/block/drbd/drbd_main.c     |   27 +++++++++++++++++----------
 drivers/block/drbd/drbd_nl.c       |    8 ++++++--
 drivers/block/drbd/drbd_receiver.c |   12 ++++++------
 4 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 3f377e2..8bc604e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -867,6 +867,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 struct drbd_conf {
 	struct drbd_tconn *tconn;
 	int vnr;			/* volume number within the connection */
+	struct kref kref;
 
 	/* things that are stored as / read from meta data on disk */
 	unsigned long flags;
@@ -1373,7 +1374,7 @@ extern rwlock_t global_state_lock;
 
 extern int conn_lowest_minor(struct drbd_tconn *tconn);
 enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor, int vnr);
-extern void drbd_delete_device(struct drbd_conf *mdev);
+extern void drbd_minor_destroy(struct kref *kref);
 
 struct drbd_tconn *conn_create(const char *name);
 extern void conn_destroy(struct kref *kref);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 3560581..9e4c487 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2052,7 +2052,6 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	init_waitqueue_head(&mdev->al_wait);
 	init_waitqueue_head(&mdev->seq_wait);
 
-	/* mdev->tconn->agreed_pro_version gets initialized in drbd_connect() */
 	mdev->write_ordering = WO_bdev_flush;
 	mdev->resync_wenr = LC_FREE;
 	mdev->peer_max_bio_size = DRBD_MAX_BIO_SIZE_SAFE;
@@ -2272,21 +2271,16 @@ static void drbd_release_all_peer_reqs(struct drbd_conf *mdev)
 }
 
 /* caution. no locking. */
-void drbd_delete_device(struct drbd_conf *mdev)
+void drbd_minor_destroy(struct kref *kref)
 {
+	struct drbd_conf *mdev = container_of(kref, struct drbd_conf, kref);
 	struct drbd_tconn *tconn = mdev->tconn;
 
-	idr_remove(&mdev->tconn->volumes, mdev->vnr);
-	idr_remove(&minors, mdev_to_minor(mdev));
-	synchronize_rcu();
-
 	/* paranoia asserts */
 	D_ASSERT(mdev->open_cnt == 0);
 	D_ASSERT(list_empty(&mdev->tconn->data.work.q));
 	/* end paranoia asserts */
 
-	del_gendisk(mdev->vdisk);
-
 	/* cleanup stuff that may have been allocated during
 	 * device (re-)configuration or state changes */
 
@@ -2320,6 +2314,7 @@ static void drbd_cleanup(void)
 {
 	unsigned int i;
 	struct drbd_conf *mdev;
+	struct drbd_tconn *tconn, *tmp;
 
 	unregister_reboot_notifier(&drbd_notifier);
 
@@ -2337,8 +2332,19 @@ static void drbd_cleanup(void)
 	drbd_genl_unregister();
 
 	down_write(&drbd_cfg_rwsem);
-	idr_for_each_entry(&minors, mdev, i)
-		drbd_delete_device(mdev);
+	idr_for_each_entry(&minors, mdev, i) {
+		idr_remove(&minors, mdev_to_minor(mdev));
+		idr_remove(&mdev->tconn->volumes, mdev->vnr);
+		del_gendisk(mdev->vdisk);
+		synchronize_rcu();
+		kref_put(&mdev->kref, &drbd_minor_destroy);
+	}
+
+	list_for_each_entry_safe(tconn, tmp, &drbd_tconns, all_tconn) {
+		list_del(&tconn->all_tconn);
+		synchronize_rcu();
+		kref_put(&tconn->kref, &conn_destroy);
+	}
 	up_write(&drbd_cfg_rwsem);
 
 	drbd_destroy_mempools();
@@ -2625,6 +2631,7 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 		goto out_idr_remove_vol;
 	}
 	add_disk(disk);
+	kref_init(&mdev->kref); /* one ref for both idrs and the the add_disk */
 
 	/* inherit the connection state */
 	mdev->state.conn = tconn->cstate;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index ce5d519..3c55be5 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1087,7 +1087,7 @@ static void conn_reconfig_done(struct drbd_tconn *tconn)
 	spin_unlock_irq(&tconn->req_lock);
 	if (stop_threads) {
 		/* asender is implicitly stopped by receiver
-		 * in drbd_disconnect() */
+		 * in conn_disconnect() */
 		drbd_thread_stop(&tconn->receiver);
 		drbd_thread_stop(&tconn->worker);
 	}
@@ -3079,7 +3079,11 @@ static enum drbd_ret_code adm_delete_minor(struct drbd_conf *mdev)
 	     * we may want to delete a minor from a live replication group.
 	     */
 	    mdev->state.role == R_SECONDARY) {
-		drbd_delete_device(mdev);
+		idr_remove(&mdev->tconn->volumes, mdev->vnr);
+		idr_remove(&minors, mdev_to_minor(mdev));
+		del_gendisk(mdev->vdisk);
+		synchronize_rcu();
+		kref_put(&mdev->kref, &drbd_minor_destroy);
 		return NO_ERROR;
 	} else
 		return ERR_MINOR_CONFIGURED;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index b4858bb..7156e53 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -844,7 +844,7 @@ int drbd_connected(int vnr, void *p, void *data)
  *     no point in trying again, please go standalone.
  *  -2 We do not have a network config...
  */
-static int drbd_connect(struct drbd_tconn *tconn)
+static int conn_connect(struct drbd_tconn *tconn)
 {
 	struct socket *sock, *msock;
 	struct net_conf *nc;
@@ -878,7 +878,7 @@ static int drbd_connect(struct drbd_tconn *tconn)
 				tconn->meta.socket = s;
 				send_first_packet(tconn, &tconn->meta, P_INITIAL_META);
 			} else {
-				conn_err(tconn, "Logic error in drbd_connect()\n");
+				conn_err(tconn, "Logic error in conn_connect()\n");
 				goto out_release_sockets;
 			}
 		}
@@ -4240,7 +4240,7 @@ void conn_flush_workqueue(struct drbd_tconn *tconn)
 	wait_for_completion(&barr.done);
 }
 
-static void drbd_disconnect(struct drbd_tconn *tconn)
+static void conn_disconnect(struct drbd_tconn *tconn)
 {
 	enum drbd_conns oc;
 	int rv = SS_UNKNOWN_ERROR;
@@ -4636,9 +4636,9 @@ int drbdd_init(struct drbd_thread *thi)
 	conn_info(tconn, "receiver (re)started\n");
 
 	do {
-		h = drbd_connect(tconn);
+		h = conn_connect(tconn);
 		if (h == 0) {
-			drbd_disconnect(tconn);
+			conn_disconnect(tconn);
 			schedule_timeout_interruptible(HZ);
 		}
 		if (h == -1) {
@@ -4650,7 +4650,7 @@ int drbdd_init(struct drbd_thread *thi)
 	if (h > 0)
 		drbdd(tconn);
 
-	drbd_disconnect(tconn);
+	conn_disconnect(tconn);
 
 	conn_info(tconn, "receiver terminated\n");
 	return 0;
-- 
1.7.4.1

