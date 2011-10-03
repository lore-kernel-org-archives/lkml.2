Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab1JCU7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:59:34 -0400
Received: from mail09.linbit.com ([212.69.161.110]:41588 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578Ab1JCU6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:58:37 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/10] drbd: Basic refcounting for drbd_tconn
Date: Mon,  3 Oct 2011 22:58:29 +0200
Message-Id: <1317675513-12745-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
References: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

References hold by:
 * Each (running) drbd thread has a reference on tconn
 * Each mdev has a referenc on tconn
 * Beeing in the all_tconn list counts for one reference
 * Each after_conn_state_chg_work has a reference to tconn

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h   |    5 +++--
 drivers/block/drbd/drbd_main.c  |   20 +++++++++++++++++---
 drivers/block/drbd/drbd_nl.c    |   14 +++++++++-----
 drivers/block/drbd/drbd_state.c |    2 ++
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 0fb3fc3..3abf982 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -828,6 +828,7 @@ enum {
 struct drbd_tconn {			/* is a resource from the config file */
 	char *name;			/* Resource name */
 	struct list_head all_tconn;	/* linked on global drbd_tconns */
+	struct kref kref;
 	struct idr volumes;		/* <tconn, vnr> to mdev mapping */
 	enum drbd_conns cstate;		/* Only C_STANDALONE to C_WF_REPORT_PARAMS */
 	unsigned susp:1;		/* IO suspended by user */
@@ -1378,8 +1379,8 @@ extern int conn_lowest_minor(struct drbd_tconn *tconn);
 enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor, int vnr);
 extern void drbd_delete_device(struct drbd_conf *mdev);
 
-struct drbd_tconn *drbd_new_tconn(const char *name);
-extern void drbd_free_tconn(struct drbd_tconn *tconn);
+struct drbd_tconn *conn_create(const char *name);
+extern void conn_destroy(struct kref *kref);
 struct drbd_tconn *conn_by_name(const char *name);
 extern void conn_free_crypto(struct drbd_tconn *tconn);
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 28f1b74..1c94d56 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -509,6 +509,8 @@ restart:
 	conn_info(tconn, "Terminating %s\n", current->comm);
 
 	/* Release mod reference taken when thread was started */
+
+	kref_put(&tconn->kref, &conn_destroy);
 	module_put(THIS_MODULE);
 	return retval;
 }
@@ -546,6 +548,8 @@ int drbd_thread_start(struct drbd_thread *thi)
 			return false;
 		}
 
+		kref_get(&thi->tconn->kref);
+
 		init_completion(&thi->stop);
 		thi->reset_cpu_mask = 1;
 		thi->t_state = RUNNING;
@@ -558,6 +562,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 		if (IS_ERR(nt)) {
 			conn_err(tconn, "Couldn't start thread\n");
 
+			kref_put(&tconn->kref, &conn_destroy);
 			module_put(THIS_MODULE);
 			return false;
 		}
@@ -2234,6 +2239,8 @@ static void drbd_release_all_peer_reqs(struct drbd_conf *mdev)
 /* caution. no locking. */
 void drbd_delete_device(struct drbd_conf *mdev)
 {
+	struct drbd_tconn *tconn = mdev->tconn;
+
 	idr_remove(&mdev->tconn->volumes, mdev->vnr);
 	idr_remove(&minors, mdev_to_minor(mdev));
 	synchronize_rcu();
@@ -2269,6 +2276,8 @@ void drbd_delete_device(struct drbd_conf *mdev)
 	put_disk(mdev->vdisk);
 	blk_cleanup_queue(mdev->rq_queue);
 	kfree(mdev);
+
+	kref_put(&tconn->kref, &conn_destroy);
 }
 
 static void drbd_cleanup(void)
@@ -2406,7 +2415,7 @@ void conn_free_crypto(struct drbd_tconn *tconn)
 	tconn->int_dig_vv = NULL;
 }
 
-struct drbd_tconn *drbd_new_tconn(const char *name)
+struct drbd_tconn *conn_create(const char *name)
 {
 	struct drbd_tconn *tconn;
 
@@ -2452,6 +2461,7 @@ struct drbd_tconn *drbd_new_tconn(const char *name)
 	};
 
 	down_write(&drbd_cfg_rwsem);
+	kref_init(&tconn->kref);
 	list_add_tail(&tconn->all_tconn, &drbd_tconns);
 	up_write(&drbd_cfg_rwsem);
 
@@ -2468,9 +2478,10 @@ fail:
 	return NULL;
 }
 
-void drbd_free_tconn(struct drbd_tconn *tconn)
+void conn_destroy(struct kref *kref)
 {
-	list_del(&tconn->all_tconn);
+	struct drbd_tconn *tconn = container_of(kref, struct drbd_tconn, kref);
+
 	idr_destroy(&tconn->volumes);
 
 	free_cpumask_var(tconn->cpu_mask);
@@ -2500,7 +2511,9 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	if (!mdev)
 		return ERR_NOMEM;
 
+	kref_get(&tconn->kref);
 	mdev->tconn = tconn;
+
 	mdev->minor = minor;
 	mdev->vnr = vnr;
 
@@ -2602,6 +2615,7 @@ out_no_disk:
 	blk_cleanup_queue(q);
 out_no_q:
 	kfree(mdev);
+	kref_put(&tconn->kref, &conn_destroy);
 	return err;
 }
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0b6b5d8..b854427 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2676,7 +2676,7 @@ int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	 * on each iteration.
 	 */
 
-	/* synchronize with drbd_new_tconn/drbd_free_tconn */
+	/* synchronize with conn_create()/conn_destroy() */
 	down_read(&drbd_cfg_rwsem);
 	/* revalidate iterator position */
 	list_for_each_entry(tmp, &drbd_tconns, all_tconn) {
@@ -2983,7 +2983,7 @@ int drbd_adm_create_connection(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	if (!drbd_new_tconn(adm_ctx.conn_name))
+	if (!conn_create(adm_ctx.conn_name))
 		retcode = ERR_NOMEM;
 out:
 	drbd_adm_finish(info, retcode);
@@ -3058,7 +3058,7 @@ int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info)
 	/* if this was the last volume of this connection,
 	 * this will terminate all threads */
 	if (retcode == NO_ERROR)
-		conn_reconfig_done(adm_ctx.tconn);
+		conn_reconfig_done(adm_ctx.mdev->tconn);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3128,7 +3128,9 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 
 	/* delete connection */
 	if (conn_lowest_minor(adm_ctx.tconn) < 0) {
-		drbd_free_tconn(adm_ctx.tconn);
+		list_del(&adm_ctx.tconn->all_tconn);
+		kref_put(&adm_ctx.tconn->kref, &conn_destroy);
+
 		retcode = NO_ERROR;
 	} else {
 		/* "can not happen" */
@@ -3157,7 +3159,9 @@ int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info)
 
 	down_write(&drbd_cfg_rwsem);
 	if (conn_lowest_minor(adm_ctx.tconn) < 0) {
-		drbd_free_tconn(adm_ctx.tconn);
+		list_del(&adm_ctx.tconn->all_tconn);
+		kref_put(&adm_ctx.tconn->kref, &conn_destroy);
+
 		retcode = NO_ERROR;
 	} else {
 		retcode = ERR_CONN_IN_USE;
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 2423283..054b698 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1442,6 +1442,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 
 	//conn_err(tconn, STATE_FMT, STATE_ARGS("nms", nms));
 	after_all_state_ch(tconn);
+	kref_put(&tconn->kref, &conn_destroy);
 
 	return 0;
 }
@@ -1668,6 +1669,7 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 		acscw->ns_max = ns_max;
 		acscw->flags = flags;
 		acscw->w.cb = w_after_conn_state_ch;
+		kref_get(&tconn->kref);
 		acscw->w.tconn = tconn;
 		drbd_queue_work(&tconn->data.work, &acscw->w);
 	} else {
-- 
1.7.4.1

