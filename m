Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab1JFNlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:41:17 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34165 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab1JFNiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:08 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/15] drbd: Made the fifo object a self contained object (preparing for RCU)
Date: Thu,  6 Oct 2011 15:37:53 +0200
Message-Id: <1317908280-28951-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Moved rs_planed into it, named total
* When having a pointer to the object the values can
  be embedded into the fifo object.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    7 ++++---
 drivers/block/drbd/drbd_main.c     |    1 +
 drivers/block/drbd/drbd_nl.c       |   34 ++++++++++++++++++++++------------
 drivers/block/drbd/drbd_receiver.c |   13 ++++++-------
 drivers/block/drbd/drbd_worker.c   |   33 ++++++++++++++++++++++++---------
 5 files changed, 57 insertions(+), 31 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index cd77dd4..2ecee6c 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -802,10 +802,12 @@ enum write_ordering_e {
 };
 
 struct fifo_buffer {
-	int *values;
 	unsigned int head_index;
 	unsigned int size;
+	int total; /* sum of all values */
+	int values[0];
 };
+extern struct fifo_buffer *fifo_alloc(int fifo_size);
 
 /* flag bits per tconn */
 enum {
@@ -996,9 +998,8 @@ struct drbd_conf {
 	int rs_last_events;  /* counter of read or write "events" (unit sectors)
 			      * on the lower level device when we last looked. */
 	int c_sync_rate; /* current resync rate after syncer throttle magic */
-	struct fifo_buffer rs_plan_s; /* correction values of resync planer */
+	struct fifo_buffer *rs_plan_s; /* correction values of resync planer */
 	int rs_in_flight; /* resync sectors in flight (to proxy, in proxy and from proxy) */
-	int rs_planed;    /* resync sectors already planned */
 	atomic_t ap_in_flight; /* App sectors in flight (waiting for ack) */
 	int peer_max_bio_size;
 	int local_max_bio_size;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 32ebedb..0cbdf4f 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2310,6 +2310,7 @@ void drbd_delete_device(struct drbd_conf *mdev)
 	__free_page(mdev->md_io_page);
 	put_disk(mdev->vdisk);
 	blk_cleanup_queue(mdev->rq_queue);
+	kfree(mdev->rs_plan_s);
 	kfree(mdev);
 
 	kref_put(&tconn->kref, &conn_destroy);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index a7d4c0e..ad81227 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1129,8 +1129,8 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	enum drbd_ret_code retcode;
 	struct drbd_conf *mdev;
 	struct disk_conf *new_disk_conf, *old_disk_conf;
+	struct fifo_buffer *rs_plan_s = NULL;
 	int err, fifo_size;
-	int *rs_plan_s = NULL;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
 	if (!adm_ctx.reply_skb)
@@ -1189,8 +1189,8 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		new_disk_conf->al_extents = DRBD_AL_EXTENTS_MAX;
 
 	fifo_size = (new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
-	if (fifo_size != mdev->rs_plan_s.size && fifo_size > 0) {
-		rs_plan_s   = kzalloc(sizeof(int) * fifo_size, GFP_KERNEL);
+	if (fifo_size != mdev->rs_plan_s->size) {
+		rs_plan_s = fifo_alloc(fifo_size);
 		if (!rs_plan_s) {
 			dev_err(DEV, "kmalloc of fifo_buffer failed");
 			retcode = ERR_NOMEM;
@@ -1198,14 +1198,6 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	if (fifo_size != mdev->rs_plan_s.size) {
-		kfree(mdev->rs_plan_s.values);
-		mdev->rs_plan_s.values = rs_plan_s;
-		mdev->rs_plan_s.size   = fifo_size;
-		mdev->rs_planed = 0;
-		rs_plan_s = NULL;
-	}
-
 	wait_event(mdev->al_wait, lc_try_lock(mdev->act_log));
 	drbd_al_shrink(mdev);
 	err = drbd_check_al_size(mdev, new_disk_conf);
@@ -1228,6 +1220,14 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto fail_unlock;
 
+	spin_lock(&mdev->peer_seq_lock);
+	if (rs_plan_s) {
+		kfree(mdev->rs_plan_s);
+		mdev->rs_plan_s = rs_plan_s;
+		rs_plan_s = NULL;
+	}
+	spin_unlock(&mdev->peer_seq_lock);
+
 	drbd_md_sync(mdev);
 
 	if (mdev->state.conn >= C_CONNECTED)
@@ -1262,6 +1262,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	struct disk_conf *new_disk_conf = NULL;
 	struct block_device *bdev;
 	struct lru_cache *resync_lru = NULL;
+	struct fifo_buffer *new_plan = NULL;
 	union drbd_state ns, os;
 	enum drbd_state_rv rv;
 	struct net_conf *nc;
@@ -1308,6 +1309,12 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
+	new_plan = fifo_alloc((new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ);
+	if (!new_plan) {
+		retcode = ERR_NOMEM;
+		goto fail;
+	}
+
 	if (new_disk_conf->meta_dev_idx < DRBD_MD_INDEX_FLEX_INT) {
 		retcode = ERR_MD_IDX_INVALID;
 		goto fail;
@@ -1479,7 +1486,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	else
 		clear_bit(MD_NO_FUA, &mdev->flags);
 
-	/* FIXME Missing stuff: rs_plan_s, clip al range */
+	/* FIXME Missing stuff: clip al range */
 
 	/* Point of no return reached.
 	 * Devices and memory are no longer released by error cleanup below.
@@ -1488,9 +1495,11 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	D_ASSERT(mdev->ldev == NULL);
 	mdev->ldev = nbc;
 	mdev->resync = resync_lru;
+	mdev->rs_plan_s = new_plan;
 	nbc = NULL;
 	resync_lru = NULL;
 	new_disk_conf = NULL;
+	new_plan = NULL;
 
 	mdev->write_ordering = WO_bdev_flush;
 	drbd_bump_write_ordering(mdev, WO_bdev_flush);
@@ -1651,6 +1660,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	}
 	kfree(new_disk_conf);
 	lc_destroy(resync_lru);
+	kfree(new_plan);
 
  finish:
 	drbd_adm_finish(info, retcode);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index add4176..19b421f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3159,7 +3159,7 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct net_conf *old_net_conf, *new_net_conf = NULL;
 	struct disk_conf *old_disk_conf, *new_disk_conf = NULL;
 	const int apv = tconn->agreed_pro_version;
-	int *rs_plan_s = NULL;
+	struct fifo_buffer *rs_plan_s = NULL;
 	int fifo_size = 0;
 	int err;
 
@@ -3277,8 +3277,8 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 			new_disk_conf->c_max_rate = be32_to_cpu(p->c_max_rate);
 
 			fifo_size = (new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
-			if (fifo_size != mdev->rs_plan_s.size && fifo_size > 0) {
-				rs_plan_s   = kzalloc(sizeof(int) * fifo_size, GFP_KERNEL);
+			if (fifo_size != mdev->rs_plan_s->size) {
+				rs_plan_s = fifo_alloc(fifo_size);
 				if (!rs_plan_s) {
 					dev_err(DEV, "kmalloc of fifo_buffer failed");
 					put_ldev(mdev);
@@ -3317,10 +3317,8 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	rcu_assign_pointer(mdev->ldev->disk_conf, new_disk_conf);
 	spin_lock(&mdev->peer_seq_lock);
 	if (rs_plan_s) {
-		kfree(mdev->rs_plan_s.values);
-		mdev->rs_plan_s.values = rs_plan_s;
-		mdev->rs_plan_s.size   = fifo_size;
-		mdev->rs_planed = 0;
+		kfree(mdev->rs_plan_s);
+		mdev->rs_plan_s = rs_plan_s;
 	}
 	spin_unlock(&mdev->peer_seq_lock);
 
@@ -3333,6 +3331,7 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	return 0;
 
 disconnect:
+	kfree(rs_plan_s);
 	mutex_unlock(&mdev->tconn->conf_update);
 	/* just for completeness: actually not needed,
 	 * as this is not reached if csums_tfm was ok. */
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 840e787..866924f 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -434,6 +434,21 @@ static void fifo_add_val(struct fifo_buffer *fb, int value)
 		fb->values[i] += value;
 }
 
+struct fifo_buffer *fifo_alloc(int fifo_size)
+{
+	struct fifo_buffer *fb;
+
+	fb = kzalloc(sizeof(struct fifo_buffer) + sizeof(int) * fifo_size, GFP_KERNEL);
+	if (!fb)
+		return NULL;
+
+	fb->head_index = 0;
+	fb->size = fifo_size;
+	fb->total = 0;
+
+	return fb;
+}
+
 static int drbd_rs_controller(struct drbd_conf *mdev)
 {
 	struct disk_conf *dc;
@@ -453,7 +468,7 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 	rcu_read_lock();
 	dc = rcu_dereference(mdev->ldev->disk_conf);
 
-	steps = mdev->rs_plan_s.size; /* (dc->c_plan_ahead * 10 * SLEEP_TIME) / HZ; */
+	steps = mdev->rs_plan_s->size; /* (dc->c_plan_ahead * 10 * SLEEP_TIME) / HZ; */
 
 	if (mdev->rs_in_flight + sect_in == 0) { /* At start of resync */
 		want = ((dc->resync_rate * 2 * SLEEP_TIME) / HZ) * steps;
@@ -462,16 +477,16 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 			sect_in * dc->c_delay_target * HZ / (SLEEP_TIME * 10);
 	}
 
-	correction = want - mdev->rs_in_flight - mdev->rs_planed;
+	correction = want - mdev->rs_in_flight - mdev->rs_plan_s->total;
 
 	/* Plan ahead */
 	cps = correction / steps;
-	fifo_add_val(&mdev->rs_plan_s, cps);
-	mdev->rs_planed += cps * steps;
+	fifo_add_val(mdev->rs_plan_s, cps);
+	mdev->rs_plan_s->total += cps * steps;
 
 	/* What we do in this step */
-	curr_corr = fifo_push(&mdev->rs_plan_s, 0);
-	mdev->rs_planed -= curr_corr;
+	curr_corr = fifo_push(mdev->rs_plan_s, 0);
+	mdev->rs_plan_s->total -= curr_corr;
 
 	req_sect = sect_in + curr_corr;
 	if (req_sect < 0)
@@ -495,7 +510,7 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 static int drbd_rs_number_requests(struct drbd_conf *mdev)
 {
 	int number;
-	if (mdev->rs_plan_s.size) { /* rcu_dereference(mdev->ldev->disk_conf)->c_plan_ahead */
+	if (mdev->rs_plan_s->size) { /* rcu_dereference(mdev->ldev->disk_conf)->c_plan_ahead */
 		number = drbd_rs_controller(mdev) >> (BM_BLOCK_SHIFT - 9);
 		mdev->c_sync_rate = number * HZ * (BM_BLOCK_SIZE / 1024) / SLEEP_TIME;
 	} else {
@@ -1456,9 +1471,9 @@ void drbd_rs_controller_reset(struct drbd_conf *mdev)
 	atomic_set(&mdev->rs_sect_in, 0);
 	atomic_set(&mdev->rs_sect_ev, 0);
 	mdev->rs_in_flight = 0;
-	mdev->rs_planed = 0;
+	mdev->rs_plan_s->total = 0;
 	spin_lock(&mdev->peer_seq_lock);
-	fifo_set(&mdev->rs_plan_s, 0);
+	fifo_set(mdev->rs_plan_s, 0);
 	spin_unlock(&mdev->peer_seq_lock);
 }
 
-- 
1.7.4.1

