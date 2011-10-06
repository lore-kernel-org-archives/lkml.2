Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab1JFNjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:39:08 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34181 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351Ab1JFNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/15] drbd: RCU for rs_plan_s
Date: Thu,  6 Oct 2011 15:37:55 +0200
Message-Id: <1317908280-28951-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the issue with using peer_seq_lock out of different
contexts.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_nl.c       |   18 +++++++--------
 drivers/block/drbd/drbd_receiver.c |   17 +++++++--------
 drivers/block/drbd/drbd_worker.c   |   41 +++++++++++++++++++++---------------
 4 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2ecee6c..3f377e2 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -998,7 +998,7 @@ struct drbd_conf {
 	int rs_last_events;  /* counter of read or write "events" (unit sectors)
 			      * on the lower level device when we last looked. */
 	int c_sync_rate; /* current resync rate after syncer throttle magic */
-	struct fifo_buffer *rs_plan_s; /* correction values of resync planer */
+	struct fifo_buffer *rs_plan_s; /* correction values of resync planer (RCU, tconn->conn_update) */
 	int rs_in_flight; /* resync sectors in flight (to proxy, in proxy and from proxy) */
 	atomic_t ap_in_flight; /* App sectors in flight (waiting for ack) */
 	int peer_max_bio_size;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 6d05bf5..ca39deb 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1137,7 +1137,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	enum drbd_ret_code retcode;
 	struct drbd_conf *mdev;
 	struct disk_conf *new_disk_conf, *old_disk_conf;
-	struct fifo_buffer *rs_plan_s = NULL;
+	struct fifo_buffer *old_plan = NULL, *new_plan = NULL;
 	int err, fifo_size;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
@@ -1194,8 +1194,8 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 
 	fifo_size = (new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
 	if (fifo_size != mdev->rs_plan_s->size) {
-		rs_plan_s = fifo_alloc(fifo_size);
-		if (!rs_plan_s) {
+		new_plan = fifo_alloc(fifo_size);
+		if (!new_plan) {
 			dev_err(DEV, "kmalloc of fifo_buffer failed");
 			retcode = ERR_NOMEM;
 			goto fail_unlock;
@@ -1224,13 +1224,10 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto fail_unlock;
 
-	spin_lock(&mdev->peer_seq_lock);
-	if (rs_plan_s) {
-		kfree(mdev->rs_plan_s);
-		mdev->rs_plan_s = rs_plan_s;
-		rs_plan_s = NULL;
+	if (new_plan) {
+		old_plan = mdev->rs_plan_s;
+		rcu_assign_pointer(mdev->rs_plan_s, new_plan);
 	}
-	spin_unlock(&mdev->peer_seq_lock);
 
 	drbd_md_sync(mdev);
 
@@ -1240,13 +1237,14 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	mutex_unlock(&mdev->tconn->conf_update);
 	synchronize_rcu();
 	kfree(old_disk_conf);
+	kfree(old_plan);
 	goto success;
 
 fail_unlock:
 	mutex_unlock(&mdev->tconn->conf_update);
  fail:
 	kfree(new_disk_conf);
-	kfree(rs_plan_s);
+	kfree(new_plan);
 success:
 	put_ldev(mdev);
  out:
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 19b421f..73f605b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3159,7 +3159,7 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct net_conf *old_net_conf, *new_net_conf = NULL;
 	struct disk_conf *old_disk_conf, *new_disk_conf = NULL;
 	const int apv = tconn->agreed_pro_version;
-	struct fifo_buffer *rs_plan_s = NULL;
+	struct fifo_buffer *old_plan = NULL, *new_plan = NULL;
 	int fifo_size = 0;
 	int err;
 
@@ -3278,8 +3278,8 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 
 			fifo_size = (new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
 			if (fifo_size != mdev->rs_plan_s->size) {
-				rs_plan_s = fifo_alloc(fifo_size);
-				if (!rs_plan_s) {
+				new_plan = fifo_alloc(fifo_size);
+				if (!new_plan) {
 					dev_err(DEV, "kmalloc of fifo_buffer failed");
 					put_ldev(mdev);
 					goto disconnect;
@@ -3315,23 +3315,22 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	}
 
 	rcu_assign_pointer(mdev->ldev->disk_conf, new_disk_conf);
-	spin_lock(&mdev->peer_seq_lock);
-	if (rs_plan_s) {
-		kfree(mdev->rs_plan_s);
-		mdev->rs_plan_s = rs_plan_s;
+	if (new_plan) {
+		old_plan = mdev->rs_plan_s;
+		rcu_assign_pointer(mdev->rs_plan_s, new_plan);
 	}
-	spin_unlock(&mdev->peer_seq_lock);
 
 	mutex_unlock(&mdev->tconn->conf_update);
 	synchronize_rcu();
 	if (new_net_conf)
 		kfree(old_net_conf);
 	kfree(old_disk_conf);
+	kfree(old_plan);
 
 	return 0;
 
 disconnect:
-	kfree(rs_plan_s);
+	kfree(new_plan);
 	mutex_unlock(&mdev->tconn->conf_update);
 	/* just for completeness: actually not needed,
 	 * as this is not reached if csums_tfm was ok. */
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 866924f..484a08b 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -460,15 +460,15 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 	int steps; /* Number of time steps to plan ahead */
 	int curr_corr;
 	int max_sect;
+	struct fifo_buffer *plan;
 
 	sect_in = atomic_xchg(&mdev->rs_sect_in, 0); /* Number of sectors that came in */
 	mdev->rs_in_flight -= sect_in;
 
-	spin_lock(&mdev->peer_seq_lock); /* get an atomic view on mdev->rs_plan_s */
-	rcu_read_lock();
 	dc = rcu_dereference(mdev->ldev->disk_conf);
+	plan = rcu_dereference(mdev->rs_plan_s);
 
-	steps = mdev->rs_plan_s->size; /* (dc->c_plan_ahead * 10 * SLEEP_TIME) / HZ; */
+	steps = plan->size; /* (dc->c_plan_ahead * 10 * SLEEP_TIME) / HZ; */
 
 	if (mdev->rs_in_flight + sect_in == 0) { /* At start of resync */
 		want = ((dc->resync_rate * 2 * SLEEP_TIME) / HZ) * steps;
@@ -477,16 +477,16 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 			sect_in * dc->c_delay_target * HZ / (SLEEP_TIME * 10);
 	}
 
-	correction = want - mdev->rs_in_flight - mdev->rs_plan_s->total;
+	correction = want - mdev->rs_in_flight - plan->total;
 
 	/* Plan ahead */
 	cps = correction / steps;
-	fifo_add_val(mdev->rs_plan_s, cps);
-	mdev->rs_plan_s->total += cps * steps;
+	fifo_add_val(plan, cps);
+	plan->total += cps * steps;
 
 	/* What we do in this step */
-	curr_corr = fifo_push(mdev->rs_plan_s, 0);
-	mdev->rs_plan_s->total -= curr_corr;
+	curr_corr = fifo_push(plan, 0);
+	plan->total -= curr_corr;
 
 	req_sect = sect_in + curr_corr;
 	if (req_sect < 0)
@@ -501,8 +501,6 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 		 sect_in, mdev->rs_in_flight, want, correction,
 		 steps, cps, mdev->rs_planed, curr_corr, req_sect);
 	*/
-	rcu_read_unlock();
-	spin_unlock(&mdev->peer_seq_lock);
 
 	return req_sect;
 }
@@ -510,15 +508,16 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 static int drbd_rs_number_requests(struct drbd_conf *mdev)
 {
 	int number;
-	if (mdev->rs_plan_s->size) { /* rcu_dereference(mdev->ldev->disk_conf)->c_plan_ahead */
+
+	rcu_read_lock();
+	if (rcu_dereference(mdev->rs_plan_s)->size) {
 		number = drbd_rs_controller(mdev) >> (BM_BLOCK_SHIFT - 9);
 		mdev->c_sync_rate = number * HZ * (BM_BLOCK_SIZE / 1024) / SLEEP_TIME;
 	} else {
-		rcu_read_lock();
 		mdev->c_sync_rate = rcu_dereference(mdev->ldev->disk_conf)->resync_rate;
-		rcu_read_unlock();
 		number = SLEEP_TIME * mdev->c_sync_rate  / ((BM_BLOCK_SIZE / 1024) * HZ);
 	}
+	rcu_read_unlock();
 
 	/* ignore the amount of pending requests, the resync controller should
 	 * throttle down to incoming reply rate soon enough anyways. */
@@ -1468,13 +1467,21 @@ void drbd_sync_after_changed(struct drbd_conf *mdev)
 
 void drbd_rs_controller_reset(struct drbd_conf *mdev)
 {
+	struct fifo_buffer *plan;
+
 	atomic_set(&mdev->rs_sect_in, 0);
 	atomic_set(&mdev->rs_sect_ev, 0);
 	mdev->rs_in_flight = 0;
-	mdev->rs_plan_s->total = 0;
-	spin_lock(&mdev->peer_seq_lock);
-	fifo_set(mdev->rs_plan_s, 0);
-	spin_unlock(&mdev->peer_seq_lock);
+
+	/* Updating the RCU protected object in place is necessary since
+	   this function gets called from atomic context.
+	   It is valid since all other updates also lead to an completely
+	   empty fifo */
+	rcu_read_lock();
+	plan = rcu_dereference(mdev->rs_plan_s);
+	plan->total = 0;
+	fifo_set(plan, 0);
+	rcu_read_unlock();
 }
 
 void start_resync_timer_fn(unsigned long data)
-- 
1.7.4.1

