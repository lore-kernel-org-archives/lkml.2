Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965443Ab1JGL3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:29:41 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35845 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876Ab1JGL1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:27:50 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/12] drbd: Removing drbd_cfg_rwsem
Date: Fri,  7 Oct 2011 13:27:36 +0200
Message-Id: <1317986865-3706-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
References: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * Updates to all configuration items is done under genl_lock().
   Including removal of mdevs or tconns.
 * All read non sleeping read sides are protected by rcu
 * All sleeping read sides keep reference counts to keep the
   objects alive

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    9 ++---
 drivers/block/drbd/drbd_main.c     |   20 ++++--------
 drivers/block/drbd/drbd_nl.c       |   43 +++++++++----------------
 drivers/block/drbd/drbd_proc.c     |    6 +--
 drivers/block/drbd/drbd_receiver.c |   61 +++++++++++++++++++++++-------------
 drivers/block/drbd/drbd_worker.c   |    8 +++-
 6 files changed, 72 insertions(+), 75 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 8bc604e..56b190c 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -169,11 +169,8 @@ drbd_insert_fault(struct drbd_conf *mdev, unsigned int type) {
 #define DRBD_MD_MAGIC (DRBD_MAGIC+4)
 
 extern struct ratelimit_state drbd_ratelimit_state;
-extern struct idr minors;
-extern struct list_head drbd_tconns;
-extern struct rw_semaphore drbd_cfg_rwsem;
-/* drbd_cfg_rwsem protects: drbd_tconns list, minors idr, tconn->volumes idr 
-   note: non sleeping iterations over the idrs are protoected by RCU */
+extern struct idr minors; /* RCU, updates: genl_lock() */
+extern struct list_head drbd_tconns; /* RCU, updates: genl_lock() */
 
 /* on the wire */
 enum drbd_packet {
@@ -1477,7 +1474,7 @@ extern struct page *drbd_alloc_pages(struct drbd_conf *, unsigned int, bool);
 extern void drbd_set_recv_tcq(struct drbd_conf *mdev, int tcq_enabled);
 extern void _drbd_clear_done_ee(struct drbd_conf *mdev, struct list_head *to_be_freed);
 extern void conn_flush_workqueue(struct drbd_tconn *tconn);
-extern int drbd_connected(int vnr, void *p, void *data);
+extern int drbd_connected(struct drbd_conf *mdev);
 static inline void drbd_flush_workqueue(struct drbd_conf *mdev)
 {
 	conn_flush_workqueue(mdev->tconn);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c229448..dd5b56c 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -120,7 +120,6 @@ module_param_string(usermode_helper, usermode_helper, sizeof(usermode_helper), 0
  */
 struct idr minors;
 struct list_head drbd_tconns;  /* list of struct drbd_tconn */
-DECLARE_RWSEM(drbd_cfg_rwsem);
 
 struct kmem_cache *drbd_request_cache;
 struct kmem_cache *drbd_ee_cache;	/* peer requests */
@@ -2331,21 +2330,20 @@ static void drbd_cleanup(void)
 
 	drbd_genl_unregister();
 
-	down_write(&drbd_cfg_rwsem);
 	idr_for_each_entry(&minors, mdev, i) {
 		idr_remove(&minors, mdev_to_minor(mdev));
 		idr_remove(&mdev->tconn->volumes, mdev->vnr);
 		del_gendisk(mdev->vdisk);
-		synchronize_rcu();
+		/* synchronize_rcu(); No other threads running at this point */
 		kref_put(&mdev->kref, &drbd_minor_destroy);
 	}
 
+	/* not _rcu since, no other updater anymore. Genl already unregistered */
 	list_for_each_entry_safe(tconn, tmp, &drbd_tconns, all_tconn) {
-		list_del_rcu(&tconn->all_tconn);
-		synchronize_rcu();
+		list_del(&tconn->all_tconn); /* not _rcu no proc, not other threads */
+		/* synchronize_rcu(); */
 		kref_put(&tconn->kref, &conn_destroy);
 	}
-	up_write(&drbd_cfg_rwsem);
 
 	drbd_destroy_mempools();
 	unregister_blkdev(DRBD_MAJOR, "drbd");
@@ -2408,7 +2406,7 @@ struct drbd_tconn *conn_get_by_name(const char *name)
 	if (!name || !name[0])
 		return NULL;
 
-	down_read(&drbd_cfg_rwsem);
+	rcu_read_lock();
 	list_for_each_entry_rcu(tconn, &drbd_tconns, all_tconn) {
 		if (!strcmp(tconn->name, name)) {
 			kref_get(&tconn->kref);
@@ -2417,7 +2415,7 @@ struct drbd_tconn *conn_get_by_name(const char *name)
 	}
 	tconn = NULL;
 found:
-	up_read(&drbd_cfg_rwsem);
+	rcu_read_unlock();
 	return tconn;
 }
 
@@ -2502,10 +2500,8 @@ struct drbd_tconn *conn_create(const char *name)
 
 	drbd_set_res_opts_defaults(&tconn->res_opts);
 
-	down_write(&drbd_cfg_rwsem);
 	kref_init(&tconn->kref);
 	list_add_tail_rcu(&tconn->all_tconn, &drbd_tconns);
-	up_write(&drbd_cfg_rwsem);
 
 	return tconn;
 
@@ -2637,7 +2633,7 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	/* inherit the connection state */
 	mdev->state.conn = tconn->cstate;
 	if (mdev->state.conn == C_WF_REPORT_PARAMS)
-		drbd_connected(vnr, mdev, tconn);
+		drbd_connected(mdev);
 
 	return NO_ERROR;
 
@@ -2913,12 +2909,10 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	}
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	mutex_lock(&mdev->tconn->conf_update);
 	/* This blocks wants to be get removed... */
 	bdev->disk_conf->al_extents = be32_to_cpu(buffer->al_nr_extents);
 	if (bdev->disk_conf->al_extents < DRBD_AL_EXTENTS_MIN)
 		bdev->disk_conf->al_extents = DRBD_AL_EXTENTS_DEF;
-	mutex_unlock(&mdev->tconn->conf_update);
 
  err:
 	mutex_unlock(&mdev->md_io_mutex);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 49f3b8d..70f7dd8 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -370,10 +370,15 @@ static void conn_md_sync(struct drbd_tconn *tconn)
 	struct drbd_conf *mdev;
 	int vnr;
 
-	down_read(&drbd_cfg_rwsem);
-	idr_for_each_entry(&tconn->volumes, mdev, vnr)
+	rcu_read_lock();
+	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
+		kref_get(&mdev->kref);
+		rcu_read_unlock();
 		drbd_md_sync(mdev);
-	up_read(&drbd_cfg_rwsem);
+		kref_put(&mdev->kref, &drbd_minor_destroy);
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
 }
 
 int conn_khelper(struct drbd_tconn *tconn, char *cmd)
@@ -1229,12 +1234,12 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		rcu_assign_pointer(mdev->rs_plan_s, new_plan);
 	}
 
+	mutex_unlock(&mdev->tconn->conf_update);
 	drbd_md_sync(mdev);
 
 	if (mdev->state.conn >= C_CONNECTED)
 		drbd_send_sync_param(mdev);
 
-	mutex_unlock(&mdev->tconn->conf_update);
 	synchronize_rcu();
 	kfree(old_disk_conf);
 	kfree(old_plan);
@@ -2058,7 +2063,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	new_my_addr = (struct sockaddr *)&new_conf->my_addr;
 	new_peer_addr = (struct sockaddr *)&new_conf->peer_addr;
 
-	/* No need to take drbd_cfg_rwsem here.  All reconfiguration is
+	/* No need for _rcu here. All reconfiguration is
 	 * strictly serialized on genl_lock(). We are protected against
 	 * concurrent reconfiguration/addition/deletion */
 	list_for_each_entry(oconn, &drbd_tconns, all_tconn) {
@@ -2717,7 +2722,7 @@ int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	 */
 
 	/* synchronize with conn_create()/conn_destroy() */
-	down_read(&drbd_cfg_rwsem);
+	rcu_read_lock();
 	/* revalidate iterator position */
 	list_for_each_entry_rcu(tmp, &drbd_tconns, all_tconn) {
 		if (pos == NULL) {
@@ -2785,7 +2790,7 @@ next_tconn:
         }
 
 out:
-	up_read(&drbd_cfg_rwsem);
+	rcu_read_unlock();
 	/* where to start the next iteration */
         cb->args[0] = (long)pos;
         cb->args[1] = (pos == tconn) ? volume + 1 : 0;
@@ -3064,9 +3069,7 @@ int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	down_write(&drbd_cfg_rwsem);
 	retcode = conn_new_minor(adm_ctx.tconn, dh->minor, adm_ctx.volume);
-	up_write(&drbd_cfg_rwsem);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3099,9 +3102,7 @@ int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	down_write(&drbd_cfg_rwsem);
 	retcode = adm_delete_minor(adm_ctx.mdev);
-	up_write(&drbd_cfg_rwsem);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3124,52 +3125,43 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	down_read(&drbd_cfg_rwsem);
 	/* demote */
 	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
 		retcode = drbd_set_role(mdev, R_SECONDARY, 0);
 		if (retcode < SS_SUCCESS) {
 			drbd_msg_put_info("failed to demote");
-			goto out_unlock;
+			goto out;
 		}
 	}
-	up_read(&drbd_cfg_rwsem);
 
-	/* disconnect; may stop the receiver;
-	 * must not hold the drbd_cfg_rwsem */
 	retcode = conn_try_disconnect(adm_ctx.tconn, 0);
 	if (retcode < SS_SUCCESS) {
 		drbd_msg_put_info("failed to disconnect");
 		goto out;
 	}
 
-	down_read(&drbd_cfg_rwsem);
 	/* detach */
 	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
 		retcode = adm_detach(mdev);
 		if (retcode < SS_SUCCESS) {
 			drbd_msg_put_info("failed to detach");
-			goto out_unlock;
+			goto out;
 		}
 	}
-	up_read(&drbd_cfg_rwsem);
 
 	/* If we reach this, all volumes (of this tconn) are Secondary,
 	 * Disconnected, Diskless, aka Unconfigured. Make sure all threads have
-	 * actually stopped, state handling only does drbd_thread_stop_nowait().
-	 * This needs to be done without holding drbd_cfg_rwsem. */
+	 * actually stopped, state handling only does drbd_thread_stop_nowait(). */
 	drbd_thread_stop(&adm_ctx.tconn->worker);
 
 	/* Now, nothing can fail anymore */
 
 	/* delete volumes */
-	down_write(&drbd_cfg_rwsem);
 	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
 		retcode = adm_delete_minor(mdev);
 		if (retcode != NO_ERROR) {
 			/* "can not happen" */
 			drbd_msg_put_info("failed to delete volume");
-			up_write(&drbd_cfg_rwsem);
 			goto out;
 		}
 	}
@@ -3186,10 +3178,7 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 		retcode = ERR_CONN_IN_USE;
 		drbd_msg_put_info("failed to delete connection");
 	}
-	up_write(&drbd_cfg_rwsem);
 	goto out;
-out_unlock:
-	up_read(&drbd_cfg_rwsem);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3205,7 +3194,6 @@ int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	down_write(&drbd_cfg_rwsem);
 	if (conn_lowest_minor(adm_ctx.tconn) < 0) {
 		list_del_rcu(&adm_ctx.tconn->all_tconn);
 		synchronize_rcu();
@@ -3215,7 +3203,6 @@ int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info)
 	} else {
 		retcode = ERR_CONN_IN_USE;
 	}
-	up_write(&drbd_cfg_rwsem);
 
 	if (retcode == NO_ERROR)
 		drbd_thread_stop(&adm_ctx.tconn->worker);
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 792a71e..6b226cc 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -229,7 +229,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 	 oos .. known out-of-sync kB
 	*/
 
-	down_read(&drbd_cfg_rwsem);
+	rcu_read_lock();
 	idr_for_each_entry(&minors, mdev, i) {
 		if (prev_i != i - 1)
 			seq_printf(seq, "\n");
@@ -242,10 +242,8 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 		    mdev->state.role == R_SECONDARY) {
 			seq_printf(seq, "%2d: cs:Unconfigured\n", i);
 		} else {
-			rcu_read_lock();
 			nc = rcu_dereference(mdev->tconn->net_conf);
 			wp = nc ? nc->wire_protocol - DRBD_PROT_A + 'A' : ' ';
-			rcu_read_unlock();
 			seq_printf(seq,
 			   "%2d: cs:%s ro:%s/%s ds:%s/%s %c %c%c%c%c%c%c\n"
 			   "    ns:%u nr:%u dw:%u dr:%u al:%u bm:%u "
@@ -299,7 +297,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 			}
 		}
 	}
-	up_read(&drbd_cfg_rwsem);
+	rcu_read_unlock();
 
 	return 0;
 }
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 7156e53..aa42967 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -63,7 +63,7 @@ enum finish_epoch {
 
 static int drbd_do_features(struct drbd_tconn *tconn);
 static int drbd_do_auth(struct drbd_tconn *tconn);
-static int drbd_disconnected(int vnr, void *p, void *data);
+static int drbd_disconnected(struct drbd_conf *mdev);
 
 static enum finish_epoch drbd_may_finish_epoch(struct drbd_conf *, struct drbd_epoch *, enum epoch_event);
 static int e_end_block(struct drbd_work *, int);
@@ -811,9 +811,8 @@ static int drbd_socket_okay(struct socket **sock)
 }
 /* Gets called if a connection is established, or if a new minor gets created
    in a connection */
-int drbd_connected(int vnr, void *p, void *data)
+int drbd_connected(struct drbd_conf *mdev)
 {
-	struct drbd_conf *mdev = (struct drbd_conf *)p;
 	int err;
 
 	atomic_set(&mdev->packet_seq, 0);
@@ -847,8 +846,9 @@ int drbd_connected(int vnr, void *p, void *data)
 static int conn_connect(struct drbd_tconn *tconn)
 {
 	struct socket *sock, *msock;
+	struct drbd_conf *mdev;
 	struct net_conf *nc;
-	int timeout, try, h, ok;
+	int vnr, timeout, try, h, ok;
 
 	if (conn_request_state(tconn, NS(conn, C_WF_CONNECTION), CS_VERBOSE) < SS_SUCCESS)
 		return -2;
@@ -1001,9 +1001,16 @@ retry:
 	if (drbd_send_protocol(tconn) == -EOPNOTSUPP)
 		return -1;
 
-	down_read(&drbd_cfg_rwsem);
-	h = !idr_for_each(&tconn->volumes, drbd_connected, tconn);
-	up_read(&drbd_cfg_rwsem);
+	rcu_read_lock();
+	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
+		kref_get(&mdev->kref);
+		rcu_read_unlock();
+		drbd_connected(mdev);
+		kref_put(&mdev->kref, &drbd_minor_destroy);
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+
 	return h;
 
 out_release_sockets:
@@ -4242,8 +4249,9 @@ void conn_flush_workqueue(struct drbd_tconn *tconn)
 
 static void conn_disconnect(struct drbd_tconn *tconn)
 {
+	struct drbd_conf *mdev;
 	enum drbd_conns oc;
-	int rv = SS_UNKNOWN_ERROR;
+	int vnr, rv = SS_UNKNOWN_ERROR;
 
 	if (tconn->cstate == C_STANDALONE)
 		return;
@@ -4252,9 +4260,16 @@ static void conn_disconnect(struct drbd_tconn *tconn)
 	drbd_thread_stop(&tconn->asender);
 	drbd_free_sock(tconn);
 
-	down_read(&drbd_cfg_rwsem);
-	idr_for_each(&tconn->volumes, drbd_disconnected, tconn);
-	up_read(&drbd_cfg_rwsem);
+	rcu_read_lock();
+	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
+		kref_get(&mdev->kref);
+		rcu_read_unlock();
+		drbd_disconnected(mdev);
+		kref_put(&mdev->kref, &drbd_minor_destroy);
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+
 	conn_info(tconn, "Connection closed\n");
 
 	if (conn_highest_role(tconn) == R_PRIMARY && conn_highest_pdsk(tconn) >= D_UNKNOWN)
@@ -4271,9 +4286,8 @@ static void conn_disconnect(struct drbd_tconn *tconn)
 		conn_request_state(tconn, NS(conn, C_STANDALONE), CS_VERBOSE | CS_HARD);
 }
 
-static int drbd_disconnected(int vnr, void *p, void *data)
+static int drbd_disconnected(struct drbd_conf *mdev)
 {
-	struct drbd_conf *mdev = (struct drbd_conf *)p;
 	enum drbd_fencing_p fp;
 	unsigned int i;
 
@@ -4974,30 +4988,33 @@ static int got_skip(struct drbd_tconn *tconn, struct packet_info *pi)
 static int tconn_finish_peer_reqs(struct drbd_tconn *tconn)
 {
 	struct drbd_conf *mdev;
-	int i, not_empty = 0;
+	int vnr, not_empty = 0;
 
 	do {
 		clear_bit(SIGNAL_ASENDER, &tconn->flags);
 		flush_signals(current);
-		down_read(&drbd_cfg_rwsem);
-		idr_for_each_entry(&tconn->volumes, mdev, i) {
+
+		rcu_read_lock();
+		idr_for_each_entry(&tconn->volumes, mdev, vnr) {
+			kref_get(&mdev->kref);
+			rcu_read_unlock();
 			if (drbd_finish_peer_reqs(mdev)) {
-				up_read(&drbd_cfg_rwsem);
-				return 1; /* error */
+				kref_put(&mdev->kref, &drbd_minor_destroy);
+				return 1;
 			}
+			kref_put(&mdev->kref, &drbd_minor_destroy);
+			rcu_read_lock();
 		}
-		up_read(&drbd_cfg_rwsem);
 		set_bit(SIGNAL_ASENDER, &tconn->flags);
 
 		spin_lock_irq(&tconn->req_lock);
-		rcu_read_lock();
-		idr_for_each_entry(&tconn->volumes, mdev, i) {
+		idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 			not_empty = !list_empty(&mdev->done_ee);
 			if (not_empty)
 				break;
 		}
-		rcu_read_unlock();
 		spin_unlock_irq(&tconn->req_lock);
+		rcu_read_unlock();
 	} while (not_empty);
 
 	return 0;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index feb12b0..46b5f7f 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1774,12 +1774,16 @@ int drbd_worker(struct drbd_thread *thi)
 	 */
 	spin_unlock_irq(&tconn->data.work.q_lock);
 
-	down_read(&drbd_cfg_rwsem);
+	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		D_ASSERT(mdev->state.disk == D_DISKLESS && mdev->state.conn == C_STANDALONE);
+		kref_get(&mdev->kref);
+		rcu_read_unlock();
 		drbd_mdev_cleanup(mdev);
+		kref_put(&mdev->kref, &drbd_minor_destroy);
+		rcu_read_lock();
 	}
-	up_read(&drbd_cfg_rwsem);
+	rcu_read_unlock();
 
 	return 0;
 }
-- 
1.7.4.1

