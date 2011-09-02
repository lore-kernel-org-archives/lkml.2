Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435Ab1IBKB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:01:58 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33084 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933353Ab1IBKA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:00:58 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 15/16] drbd: distribute former syncer_conf settings to disk, connection, and resource level
Date: Fri,  2 Sep 2011 12:00:47 +0200
Message-Id: <1314957648-13242-16-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
References: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

This commit breaks the API again.

Move per-volume former syncer options into disk_conf.
Move per-connection former syncer options into net_conf.
Renamed the remainign sync_conf to res_opts

Syncer settings have been changeable at runtime, so we need to prepare
for these settings to be runtime-changeable in their new home as well.

Introduce new configuration operations, and share the netlink attribute
between "attach" (create new disk) and "disk-opts" (change options).
Same for "connect" and "net-opts".

Some fields cannot be changed at runtime, however.
Introduce a new flag GENLA_F_INVARIANT to be able to trigger on that in
the generated validation and assignment functions.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   10 +-
 drivers/block/drbd/drbd_main.c     |   70 +++---
 drivers/block/drbd/drbd_nl.c       |  477 +++++++++++++++++++++++-------------
 drivers/block/drbd/drbd_receiver.c |   44 ++--
 drivers/block/drbd/drbd_state.c    |    4 +-
 drivers/block/drbd/drbd_worker.c   |   50 ++--
 include/linux/drbd_genl.h          |  133 ++++++-----
 include/linux/drbd_limits.h        |    2 +
 include/linux/genl_magic_func.h    |   41 ++--
 include/linux/genl_magic_struct.h  |   18 +-
 10 files changed, 512 insertions(+), 337 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 99b34f9..a9138ff 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -860,7 +860,7 @@ struct drbd_md {
 	s32 bm_offset;	/* signed relative sector offset to bitmap */
 
 	/* u32 al_nr_extents;	   important for restoring the AL
-	 * is stored into  sync_conf.al_extents, which in turn
+	 * is stored into  ldev->dc.al_extents, which in turn
 	 * gets applied to act_log->nr_elements
 	 */
 };
@@ -929,6 +929,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 	atomic_t net_cnt;		/* Users of net_conf */
 	wait_queue_head_t net_cnt_wait;
 	wait_queue_head_t ping_wait;		/* Woken upon reception of a ping, and a state change */
+	struct res_opts res_opts;
 
 	struct drbd_socket data;	/* data/barrier/cstate/parameter packets */
 	struct drbd_socket meta;	/* ping/ack (metadata) packets */
@@ -945,6 +946,8 @@ struct drbd_tconn {			/* is a resource from the config file */
 	struct crypto_hash *cram_hmac_tfm;
 	struct crypto_hash *integrity_w_tfm; /* to be used by the worker thread */
 	struct crypto_hash *integrity_r_tfm; /* to be used by the receiver thread */
+	struct crypto_hash *csums_tfm;
+	struct crypto_hash *verify_tfm;
 	void *int_dig_out;
 	void *int_dig_in;
 	void *int_dig_vv;
@@ -963,7 +966,6 @@ struct drbd_conf {
 	unsigned long flags;
 
 	/* configured by drbdsetup */
-	struct syncer_conf sync_conf;
 	struct drbd_backing_dev *ldev __protected_by(local);
 
 	sector_t p_size;     /* partner's disk size */
@@ -1037,8 +1039,6 @@ struct drbd_conf {
 	/* size of out-of-sync range in sectors. */
 	sector_t ov_last_oos_size;
 	unsigned long ov_left; /* in bits */
-	struct crypto_hash *csums_tfm;
-	struct crypto_hash *verify_tfm;
 
 	struct drbd_bitmap *bitmap;
 	unsigned long bm_resync_fo; /* bit offset for drbd_bm_find_next */
@@ -1188,7 +1188,7 @@ extern int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd,
 			  char *data, size_t size);
 #define USE_DATA_SOCKET 1
 #define USE_META_SOCKET 0
-extern int drbd_send_sync_param(struct drbd_conf *mdev, struct syncer_conf *sc);
+extern int drbd_send_sync_param(struct drbd_conf *mdev);
 extern int drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr,
 			u32 set_size);
 extern int drbd_send_ack(struct drbd_conf *, enum drbd_packet,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 4bfffe9..b1de7e8 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -784,7 +784,7 @@ int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd, char *data,
 	return ok;
 }
 
-int drbd_send_sync_param(struct drbd_conf *mdev, struct syncer_conf *sc)
+int drbd_send_sync_param(struct drbd_conf *mdev)
 {
 	struct p_rs_param_95 *p;
 	struct socket *sock;
@@ -793,7 +793,7 @@ int drbd_send_sync_param(struct drbd_conf *mdev, struct syncer_conf *sc)
 
 	size = apv <= 87 ? sizeof(struct p_rs_param)
 		: apv == 88 ? sizeof(struct p_rs_param)
-			+ strlen(mdev->sync_conf.verify_alg) + 1
+			+ strlen(mdev->tconn->net_conf->verify_alg) + 1
 		: apv <= 94 ? sizeof(struct p_rs_param_89)
 		: /* apv >= 95 */ sizeof(struct p_rs_param_95);
 
@@ -812,16 +812,25 @@ int drbd_send_sync_param(struct drbd_conf *mdev, struct syncer_conf *sc)
 		/* initialize verify_alg and csums_alg */
 		memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
 
-		p->rate = cpu_to_be32(sc->rate);
-		p->c_plan_ahead = cpu_to_be32(sc->c_plan_ahead);
-		p->c_delay_target = cpu_to_be32(sc->c_delay_target);
-		p->c_fill_target = cpu_to_be32(sc->c_fill_target);
-		p->c_max_rate = cpu_to_be32(sc->c_max_rate);
+		if (get_ldev(mdev)) {
+			p->rate = cpu_to_be32(mdev->ldev->dc.resync_rate);
+			p->c_plan_ahead = cpu_to_be32(mdev->ldev->dc.c_plan_ahead);
+			p->c_delay_target = cpu_to_be32(mdev->ldev->dc.c_delay_target);
+			p->c_fill_target = cpu_to_be32(mdev->ldev->dc.c_fill_target);
+			p->c_max_rate = cpu_to_be32(mdev->ldev->dc.c_max_rate);
+			put_ldev(mdev);
+		} else {
+			p->rate = cpu_to_be32(DRBD_RATE_DEF);
+			p->c_plan_ahead = cpu_to_be32(DRBD_C_PLAN_AHEAD_DEF);
+			p->c_delay_target = cpu_to_be32(DRBD_C_DELAY_TARGET_DEF);
+			p->c_fill_target = cpu_to_be32(DRBD_C_FILL_TARGET_DEF);
+			p->c_max_rate = cpu_to_be32(DRBD_C_MAX_RATE_DEF);
+		}
 
 		if (apv >= 88)
-			strcpy(p->verify_alg, mdev->sync_conf.verify_alg);
+			strcpy(p->verify_alg, mdev->tconn->net_conf->verify_alg);
 		if (apv >= 89)
-			strcpy(p->csums_alg, mdev->sync_conf.csums_alg);
+			strcpy(p->csums_alg, mdev->tconn->net_conf->csums_alg);
 
 		rv = _drbd_send_cmd(mdev, sock, cmd, &p->head, size, 0);
 	} else
@@ -1043,7 +1052,7 @@ int fill_bitmap_rle_bits(struct drbd_conf *mdev,
 	int bits;
 
 	/* may we use this feature? */
-	if ((mdev->sync_conf.use_rle == 0) ||
+	if ((mdev->tconn->net_conf->use_rle == 0) ||
 		(mdev->tconn->agreed_pro_version < 90))
 			return 0;
 
@@ -1790,26 +1799,8 @@ static int drbd_release(struct gendisk *gd, fmode_t mode)
 
 static void drbd_set_defaults(struct drbd_conf *mdev)
 {
-	/* This way we get a compile error when sync_conf grows,
-	   and we forgot to initialize it here */
-	mdev->sync_conf = (struct syncer_conf) {
-		/* .rate = */		DRBD_RATE_DEF,
-		/* .after = */		DRBD_AFTER_DEF,
-		/* .al_extents = */	DRBD_AL_EXTENTS_DEF,
-		/* .verify_alg = */	{}, 0,
-		/* .cpu_mask = */	{}, 0,
-		/* .csums_alg = */	{}, 0,
-		/* .use_rle = */	0,
-		/* .on_no_data = */	DRBD_ON_NO_DATA_DEF,
-		/* .c_plan_ahead = */	DRBD_C_PLAN_AHEAD_DEF,
-		/* .c_delay_target = */	DRBD_C_DELAY_TARGET_DEF,
-		/* .c_fill_target = */	DRBD_C_FILL_TARGET_DEF,
-		/* .c_max_rate = */	DRBD_C_MAX_RATE_DEF,
-		/* .c_min_rate = */	DRBD_C_MIN_RATE_DEF
-	};
-
-	/* Have to use that way, because the layout differs between
-	   big endian and little endian */
+	/* Beware! The actual layout differs
+	 * between big endian and little endian */
 	mdev->state = (union drbd_state) {
 		{ .role = R_SECONDARY,
 		  .peer = R_UNKNOWN,
@@ -2286,6 +2277,9 @@ struct drbd_tconn *drbd_new_tconn(const char *name)
 	drbd_thread_init(tconn, &tconn->worker, drbd_worker, "worker");
 	drbd_thread_init(tconn, &tconn->asender, drbd_asender, "asender");
 
+	/* tconn->res_opts defaults happen to be all zeros,
+	 * which was taken care of by kzalloc */
+
 	mutex_lock(&drbd_cfg_mutex);
 	list_add_tail(&tconn->all_tconn, &drbd_tconns);
 	mutex_unlock(&drbd_cfg_mutex);
@@ -2560,10 +2554,10 @@ void drbd_free_sock(struct drbd_tconn *tconn)
 
 void drbd_free_resources(struct drbd_conf *mdev)
 {
-	crypto_free_hash(mdev->csums_tfm);
-	mdev->csums_tfm = NULL;
-	crypto_free_hash(mdev->verify_tfm);
-	mdev->verify_tfm = NULL;
+	crypto_free_hash(mdev->tconn->csums_tfm);
+	mdev->tconn->csums_tfm = NULL;
+	crypto_free_hash(mdev->tconn->verify_tfm);
+	mdev->tconn->verify_tfm = NULL;
 	crypto_free_hash(mdev->tconn->cram_hmac_tfm);
 	mdev->tconn->cram_hmac_tfm = NULL;
 	crypto_free_hash(mdev->tconn->integrity_w_tfm);
@@ -2590,7 +2584,7 @@ struct meta_data_on_disk {
 	u32 md_size_sect;
 	u32 al_offset;         /* offset to this block */
 	u32 al_nr_extents;     /* important for restoring the AL */
-	      /* `-- act_log->nr_elements <-- sync_conf.al_extents */
+	      /* `-- act_log->nr_elements <-- ldev->dc.al_extents */
 	u32 bm_offset;         /* offset to the bitmap, from here */
 	u32 bm_bytes_per_bit;  /* BM_BLOCK_SIZE */
 	u32 la_peer_max_bio_size;   /* last peer max_bio_size */
@@ -2716,7 +2710,7 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	for (i = UI_CURRENT; i < UI_SIZE; i++)
 		bdev->md.uuid[i] = be64_to_cpu(buffer->uuid[i]);
 	bdev->md.flags = be32_to_cpu(buffer->flags);
-	mdev->sync_conf.al_extents = be32_to_cpu(buffer->al_nr_extents);
+	mdev->ldev->dc.al_extents = be32_to_cpu(buffer->al_nr_extents);
 	bdev->md.device_uuid = be64_to_cpu(buffer->device_uuid);
 
 	spin_lock_irq(&mdev->tconn->req_lock);
@@ -2728,8 +2722,8 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	}
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	if (mdev->sync_conf.al_extents < 7)
-		mdev->sync_conf.al_extents = 127;
+	if (mdev->ldev->dc.al_extents < 7)
+		mdev->ldev->dc.al_extents = 127;
 
  err:
 	mutex_unlock(&mdev->md_io_mutex);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 8f427a1..ab22019 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -77,8 +77,10 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info);
 
 int drbd_adm_set_role(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_detach(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_start_ov(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info);
@@ -90,7 +92,7 @@ int drbd_adm_resume_sync(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_suspend_io(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_resume_io(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_outdate(struct sk_buff *skb, struct genl_info *info);
-int drbd_adm_syncer(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_get_status(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_get_timeout_type(struct sk_buff *skb, struct genl_info *info);
 /* .dumpit */
@@ -194,7 +196,7 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 	if (info->attrs[DRBD_NLA_CFG_CONTEXT]) {
 		struct nlattr *nla;
 		/* parse and validate only */
-		err = drbd_cfg_context_from_attrs(NULL, info->attrs);
+		err = drbd_cfg_context_from_attrs(NULL, info);
 		if (err)
 			goto fail;
 
@@ -651,6 +653,7 @@ static const char *from_attrs_err_to_txt(int err)
 {
 	return	err == -ENOMSG ? "required attribute missing" :
 		err == -EOPNOTSUPP ? "unknown mandatory attribute" :
+		err == -EEXIST ? "can not change invariant setting" :
 		"invalid attribute value";
 }
 
@@ -668,7 +671,7 @@ int drbd_adm_set_role(struct sk_buff *skb, struct genl_info *info)
 
 	memset(&parms, 0, sizeof(parms));
 	if (info->attrs[DRBD_NLA_SET_ROLE_PARMS]) {
-		err = set_role_parms_from_attrs(&parms, info->attrs);
+		err = set_role_parms_from_attrs(&parms, info);
 		if (err) {
 			retcode = ERR_MANDATORY_TAG;
 			drbd_msg_put_info(from_attrs_err_to_txt(err));
@@ -940,17 +943,17 @@ static int drbd_check_al_size(struct drbd_conf *mdev)
 	unsigned int in_use;
 	int i;
 
-	if (!expect(mdev->sync_conf.al_extents >= DRBD_AL_EXTENTS_MIN))
-		mdev->sync_conf.al_extents = DRBD_AL_EXTENTS_MIN;
+	if (!expect(mdev->ldev->dc.al_extents >= DRBD_AL_EXTENTS_MIN))
+		mdev->ldev->dc.al_extents = DRBD_AL_EXTENTS_MIN;
 
 	if (mdev->act_log &&
-	    mdev->act_log->nr_elements == mdev->sync_conf.al_extents)
+	    mdev->act_log->nr_elements == mdev->ldev->dc.al_extents)
 		return 0;
 
 	in_use = 0;
 	t = mdev->act_log;
 	n = lc_create("act_log", drbd_al_ext_cache, AL_UPDATES_PER_TRANSACTION,
-		mdev->sync_conf.al_extents, sizeof(struct lc_element), 0);
+		mdev->ldev->dc.al_extents, sizeof(struct lc_element), 0);
 
 	if (n == NULL) {
 		dev_err(DEV, "Cannot allocate act_log lru!\n");
@@ -1104,6 +1107,122 @@ static void drbd_suspend_al(struct drbd_conf *mdev)
 		dev_info(DEV, "Suspended AL updates\n");
 }
 
+int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
+{
+	enum drbd_ret_code retcode;
+	struct drbd_conf *mdev;
+	struct disk_conf *ndc; /* new disk conf */
+	int err, fifo_size;
+	int *rs_plan_s = NULL;
+
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
+
+	mdev = adm_ctx.mdev;
+
+	/* make sure this is a CHANGE request, as expected */
+	if (!(info->nlhdr->nlmsg_flags & NLM_F_REPLACE)) {
+		retcode = ERR_INVALID_REQUEST;
+		goto out;
+	}
+
+	/* we also need a disk
+	 * to change the options on */
+	if (!get_ldev(mdev)) {
+		retcode = ERR_NO_DISK;
+		goto out;
+	}
+
+/* FIXME freeze IO, cluster wide.
+ *
+ * We should make sure no-one uses
+ * some half-updated struct when we
+ * assign it later. */
+
+	ndc = kmalloc(sizeof(*ndc), GFP_KERNEL);
+	if (!ndc) {
+		retcode = ERR_NOMEM;
+		goto fail;
+	}
+
+	memcpy(ndc, &mdev->ldev->dc, sizeof(*ndc));
+	err = disk_conf_from_attrs(ndc, info);
+	if (err) {
+		retcode = ERR_MANDATORY_TAG;
+		drbd_msg_put_info(from_attrs_err_to_txt(err));
+	}
+
+	if (!expect(ndc->resync_rate >= 1))
+		ndc->resync_rate = 1;
+
+	/* clip to allowed range */
+	if (!expect(ndc->al_extents >= DRBD_AL_EXTENTS_MIN))
+		ndc->al_extents = DRBD_AL_EXTENTS_MIN;
+	if (!expect(ndc->al_extents <= DRBD_AL_EXTENTS_MAX))
+		ndc->al_extents = DRBD_AL_EXTENTS_MAX;
+
+	/* most sanity checks done, try to assign the new sync-after
+	 * dependency.  need to hold the global lock in there,
+	 * to avoid a race in the dependency loop check. */
+	retcode = drbd_alter_sa(mdev, ndc->resync_after);
+	if (retcode != NO_ERROR)
+		goto fail;
+
+	fifo_size = (ndc->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
+	if (fifo_size != mdev->rs_plan_s.size && fifo_size > 0) {
+		rs_plan_s   = kzalloc(sizeof(int) * fifo_size, GFP_KERNEL);
+		if (!rs_plan_s) {
+			dev_err(DEV, "kmalloc of fifo_buffer failed");
+			retcode = ERR_NOMEM;
+			goto fail;
+		}
+	}
+
+	/* FIXME
+	 * To avoid someone looking at a half-updated struct, we probably
+	 * should have a rw-semaphor on net_conf and disk_conf.
+	 */
+	mdev->ldev->dc = *ndc;
+
+	if (fifo_size != mdev->rs_plan_s.size) {
+		kfree(mdev->rs_plan_s.values);
+		mdev->rs_plan_s.values = rs_plan_s;
+		mdev->rs_plan_s.size   = fifo_size;
+		mdev->rs_planed = 0;
+		rs_plan_s = NULL;
+	}
+
+	wait_event(mdev->al_wait, lc_try_lock(mdev->act_log));
+	drbd_al_shrink(mdev);
+	err = drbd_check_al_size(mdev);
+	lc_unlock(mdev->act_log);
+	wake_up(&mdev->al_wait);
+
+	drbd_md_sync(mdev);
+
+	if (err) {
+/* FIXME cannot fail here just like that:
+ * we are already attached, and the new values are assigned!
+ */
+		retcode = ERR_NOMEM;
+		goto fail;
+	}
+
+	if (mdev->state.conn >= C_CONNECTED)
+		drbd_send_sync_param(mdev);
+
+ fail:
+	put_ldev(mdev);
+	kfree(ndc);
+	kfree(rs_plan_s);
+ out:
+	drbd_adm_finish(info, retcode);
+	return 0;
+}
+
 int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 {
 	struct drbd_conf *mdev;
@@ -1151,7 +1270,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	nbc->dc.fencing       = DRBD_FENCING_DEF;
 	nbc->dc.max_bio_bvecs = DRBD_MAX_BIO_BVECS_DEF;
 
-	err = disk_conf_from_attrs(&nbc->dc, info->attrs);
+	err = disk_conf_from_attrs(&nbc->dc, info);
 	if (err) {
 		retcode = ERR_MANDATORY_TAG;
 		drbd_msg_put_info(from_attrs_err_to_txt(err));
@@ -1533,6 +1652,164 @@ out:
 	return 0;
 }
 
+static bool conn_resync_running(struct drbd_tconn *tconn)
+{
+	struct drbd_conf *mdev;
+	int vnr;
+
+	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
+		if (mdev->state.conn == C_SYNC_SOURCE ||
+		    mdev->state.conn == C_SYNC_TARGET ||
+		    mdev->state.conn == C_PAUSED_SYNC_S ||
+		    mdev->state.conn == C_PAUSED_SYNC_T)
+			return true;
+	}
+	return false;
+}
+
+static bool conn_ov_running(struct drbd_tconn *tconn)
+{
+	struct drbd_conf *mdev;
+	int vnr;
+
+	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
+		if (mdev->state.conn == C_VERIFY_S ||
+		    mdev->state.conn == C_VERIFY_T)
+			return true;
+	}
+	return false;
+}
+
+int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
+{
+	enum drbd_ret_code retcode;
+	struct drbd_tconn *tconn;
+	struct net_conf *new_conf = NULL;
+	int err;
+	int ovr; /* online verify running */
+	int rsr; /* re-sync running */
+	struct crypto_hash *verify_tfm = NULL;
+	struct crypto_hash *csums_tfm = NULL;
+
+
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
+
+	tconn = adm_ctx.tconn;
+
+	/* make sure this is a CHANGE request, as expected */
+	if (!(info->nlhdr->nlmsg_flags & NLM_F_REPLACE)) {
+		retcode = ERR_INVALID_REQUEST;
+		goto out;
+	}
+
+	new_conf = kzalloc(sizeof(struct net_conf), GFP_KERNEL);
+	if (!new_conf) {
+		retcode = ERR_NOMEM;
+		goto out;
+	}
+
+	/* we also need a net config
+	 * to change the options on */
+	if (!get_net_conf(tconn)) {
+		drbd_msg_put_info("net conf missing, try connect");
+		retcode = ERR_INVALID_REQUEST;
+		goto out;
+	}
+
+	conn_reconfig_start(tconn);
+
+	memcpy(new_conf, tconn->net_conf, sizeof(*new_conf));
+	err = net_conf_from_attrs(new_conf, info);
+	if (err) {
+		retcode = ERR_MANDATORY_TAG;
+		drbd_msg_put_info(from_attrs_err_to_txt(err));
+		goto fail;
+	}
+
+	/* re-sync running */
+	rsr = conn_resync_running(tconn);
+	if (rsr && strcmp(new_conf->csums_alg, tconn->net_conf->csums_alg)) {
+		retcode = ERR_CSUMS_RESYNC_RUNNING;
+		goto fail;
+	}
+
+	if (!rsr && new_conf->csums_alg[0]) {
+		csums_tfm = crypto_alloc_hash(new_conf->csums_alg, 0, CRYPTO_ALG_ASYNC);
+		if (IS_ERR(csums_tfm)) {
+			csums_tfm = NULL;
+			retcode = ERR_CSUMS_ALG;
+			goto fail;
+		}
+
+		if (!drbd_crypto_is_hash(crypto_hash_tfm(csums_tfm))) {
+			retcode = ERR_CSUMS_ALG_ND;
+			goto fail;
+		}
+	}
+
+	/* online verify running */
+	ovr = conn_ov_running(tconn);
+	if (ovr) {
+		if (strcmp(new_conf->verify_alg, tconn->net_conf->verify_alg)) {
+			retcode = ERR_VERIFY_RUNNING;
+			goto fail;
+		}
+	}
+
+	if (!ovr && new_conf->verify_alg[0]) {
+		verify_tfm = crypto_alloc_hash(new_conf->verify_alg, 0, CRYPTO_ALG_ASYNC);
+		if (IS_ERR(verify_tfm)) {
+			verify_tfm = NULL;
+			retcode = ERR_VERIFY_ALG;
+			goto fail;
+		}
+
+		if (!drbd_crypto_is_hash(crypto_hash_tfm(verify_tfm))) {
+			retcode = ERR_VERIFY_ALG_ND;
+			goto fail;
+		}
+	}
+
+
+	/* For now, use struct assignment, not pointer assignment.
+	 * We don't have any means to determine who might still
+	 * keep a local alias into the struct,
+	 * so we cannot just free it and hope for the best :(
+	 * FIXME
+	 * To avoid someone looking at a half-updated struct, we probably
+	 * should have a rw-semaphor on net_conf and disk_conf.
+	 */
+	*tconn->net_conf = *new_conf;
+
+	if (!rsr) {
+		crypto_free_hash(tconn->csums_tfm);
+		tconn->csums_tfm = csums_tfm;
+		csums_tfm = NULL;
+	}
+	if (!ovr) {
+		crypto_free_hash(tconn->verify_tfm);
+		tconn->verify_tfm = verify_tfm;
+		verify_tfm = NULL;
+	}
+
+	if (tconn->cstate >= C_WF_REPORT_PARAMS)
+		drbd_send_sync_param(minor_to_mdev(conn_lowest_minor(tconn)));
+
+ fail:
+	crypto_free_hash(csums_tfm);
+	crypto_free_hash(verify_tfm);
+	kfree(new_conf);
+	put_net_conf(tconn);
+	conn_reconfig_done(tconn);
+ out:
+	drbd_adm_finish(info, retcode);
+	return 0;
+}
+
 int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 {
 	char hmac_name[CRYPTO_MAX_ALG_NAME];
@@ -1592,7 +1869,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	new_conf->on_congestion    = DRBD_ON_CONGESTION_DEF;
 	new_conf->cong_extents     = DRBD_CONG_EXTENTS_DEF;
 
-	err = net_conf_from_attrs(new_conf, info->attrs);
+	err = net_conf_from_attrs(new_conf, info);
 	if (err) {
 		retcode = ERR_MANDATORY_TAG;
 		drbd_msg_put_info(from_attrs_err_to_txt(err));
@@ -1824,7 +2101,7 @@ int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 	tconn = adm_ctx.tconn;
 	memset(&parms, 0, sizeof(parms));
 	if (info->attrs[DRBD_NLA_DISCONNECT_PARMS]) {
-		err = disconnect_parms_from_attrs(&parms, info->attrs);
+		err = disconnect_parms_from_attrs(&parms, info);
 		if (err) {
 			retcode = ERR_MANDATORY_TAG;
 			drbd_msg_put_info(from_attrs_err_to_txt(err));
@@ -1883,7 +2160,7 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 
 	memset(&rs, 0, sizeof(struct resize_parms));
 	if (info->attrs[DRBD_NLA_RESIZE_PARMS]) {
-		err = resize_parms_from_attrs(&rs, info->attrs);
+		err = resize_parms_from_attrs(&rs, info);
 		if (err) {
 			retcode = ERR_MANDATORY_TAG;
 			drbd_msg_put_info(from_attrs_err_to_txt(err));
@@ -1939,26 +2216,21 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-int drbd_adm_syncer(struct sk_buff *skb, struct genl_info *info)
+int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_conf *mdev;
 	enum drbd_ret_code retcode;
-	int err;
-	int ovr; /* online verify running */
-	int rsr; /* re-sync running */
-	struct crypto_hash *verify_tfm = NULL;
-	struct crypto_hash *csums_tfm = NULL;
-	struct syncer_conf sc;
 	cpumask_var_t new_cpu_mask;
+	struct drbd_tconn *tconn;
 	int *rs_plan_s = NULL;
-	int fifo_size;
+	struct res_opts sc;
+	int err;
 
-	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
+	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
 	if (!adm_ctx.reply_skb)
 		return retcode;
 	if (retcode != NO_ERROR)
 		goto fail;
-	mdev = adm_ctx.mdev;
+	tconn = adm_ctx.tconn;
 
 	if (!zalloc_cpumask_var(&new_cpu_mask, GFP_KERNEL)) {
 		retcode = ERR_NOMEM;
@@ -1968,172 +2240,43 @@ int drbd_adm_syncer(struct sk_buff *skb, struct genl_info *info)
 
 	if (((struct drbd_genlmsghdr*)info->userhdr)->flags
 			& DRBD_GENL_F_SET_DEFAULTS) {
-		memset(&sc, 0, sizeof(struct syncer_conf));
-		sc.rate       = DRBD_RATE_DEF;
-		sc.after      = DRBD_AFTER_DEF;
-		sc.al_extents = DRBD_AL_EXTENTS_DEF;
+		memset(&sc, 0, sizeof(struct res_opts));
 		sc.on_no_data  = DRBD_ON_NO_DATA_DEF;
-		sc.c_plan_ahead = DRBD_C_PLAN_AHEAD_DEF;
-		sc.c_delay_target = DRBD_C_DELAY_TARGET_DEF;
-		sc.c_fill_target = DRBD_C_FILL_TARGET_DEF;
-		sc.c_max_rate = DRBD_C_MAX_RATE_DEF;
-		sc.c_min_rate = DRBD_C_MIN_RATE_DEF;
 	} else
-		memcpy(&sc, &mdev->sync_conf, sizeof(struct syncer_conf));
+		sc = tconn->res_opts;
 
-	err = syncer_conf_from_attrs(&sc, info->attrs);
+	err = res_opts_from_attrs(&sc, info);
 	if (err) {
 		retcode = ERR_MANDATORY_TAG;
 		drbd_msg_put_info(from_attrs_err_to_txt(err));
 		goto fail;
 	}
 
-	/* re-sync running */
-	rsr = (	mdev->state.conn == C_SYNC_SOURCE ||
-		mdev->state.conn == C_SYNC_TARGET ||
-		mdev->state.conn == C_PAUSED_SYNC_S ||
-		mdev->state.conn == C_PAUSED_SYNC_T );
-
-	if (rsr && strcmp(sc.csums_alg, mdev->sync_conf.csums_alg)) {
-		retcode = ERR_CSUMS_RESYNC_RUNNING;
-		goto fail;
-	}
-
-	if (!rsr && sc.csums_alg[0]) {
-		csums_tfm = crypto_alloc_hash(sc.csums_alg, 0, CRYPTO_ALG_ASYNC);
-		if (IS_ERR(csums_tfm)) {
-			csums_tfm = NULL;
-			retcode = ERR_CSUMS_ALG;
-			goto fail;
-		}
-
-		if (!drbd_crypto_is_hash(crypto_hash_tfm(csums_tfm))) {
-			retcode = ERR_CSUMS_ALG_ND;
-			goto fail;
-		}
-	}
-
-	/* online verify running */
-	ovr = (mdev->state.conn == C_VERIFY_S || mdev->state.conn == C_VERIFY_T);
-
-	if (ovr) {
-		if (strcmp(sc.verify_alg, mdev->sync_conf.verify_alg)) {
-			retcode = ERR_VERIFY_RUNNING;
-			goto fail;
-		}
-	}
-
-	if (!ovr && sc.verify_alg[0]) {
-		verify_tfm = crypto_alloc_hash(sc.verify_alg, 0, CRYPTO_ALG_ASYNC);
-		if (IS_ERR(verify_tfm)) {
-			verify_tfm = NULL;
-			retcode = ERR_VERIFY_ALG;
-			goto fail;
-		}
-
-		if (!drbd_crypto_is_hash(crypto_hash_tfm(verify_tfm))) {
-			retcode = ERR_VERIFY_ALG_ND;
-			goto fail;
-		}
-	}
-
 	/* silently ignore cpu mask on UP kernel */
 	if (nr_cpu_ids > 1 && sc.cpu_mask[0] != 0) {
 		err = __bitmap_parse(sc.cpu_mask, 32, 0,
 				cpumask_bits(new_cpu_mask), nr_cpu_ids);
 		if (err) {
-			dev_warn(DEV, "__bitmap_parse() failed with %d\n", err);
+			conn_warn(tconn, "__bitmap_parse() failed with %d\n", err);
 			retcode = ERR_CPU_MASK_PARSE;
 			goto fail;
 		}
 	}
 
-	if (!expect(sc.rate >= 1))
-		sc.rate = 1;
 
-	/* clip to allowed range */
-	if (!expect(sc.al_extents >= DRBD_AL_EXTENTS_MIN))
-		sc.al_extents = DRBD_AL_EXTENTS_MIN;
-	if (!expect(sc.al_extents <= DRBD_AL_EXTENTS_MAX))
-		sc.al_extents = DRBD_AL_EXTENTS_MAX;
+	tconn->res_opts = sc;
 
-	/* most sanity checks done, try to assign the new sync-after
-	 * dependency.  need to hold the global lock in there,
-	 * to avoid a race in the dependency loop check. */
-	retcode = drbd_alter_sa(mdev, sc.after);
-	if (retcode != NO_ERROR)
-		goto fail;
-
-	fifo_size = (sc.c_plan_ahead * 10 * SLEEP_TIME) / HZ;
-	if (fifo_size != mdev->rs_plan_s.size && fifo_size > 0) {
-		rs_plan_s   = kzalloc(sizeof(int) * fifo_size, GFP_KERNEL);
-		if (!rs_plan_s) {
-			dev_err(DEV, "kmalloc of fifo_buffer failed");
-			retcode = ERR_NOMEM;
-			goto fail;
-		}
+	if (!cpumask_equal(tconn->cpu_mask, new_cpu_mask)) {
+		cpumask_copy(tconn->cpu_mask, new_cpu_mask);
+		drbd_calc_cpu_mask(tconn);
+		tconn->receiver.reset_cpu_mask = 1;
+		tconn->asender.reset_cpu_mask = 1;
+		tconn->worker.reset_cpu_mask = 1;
 	}
 
-	/* ok, assign the rest of it as well.
-	 * lock against receive_SyncParam() */
-	spin_lock(&mdev->peer_seq_lock);
-	mdev->sync_conf = sc;
-
-	if (!rsr) {
-		crypto_free_hash(mdev->csums_tfm);
-		mdev->csums_tfm = csums_tfm;
-		csums_tfm = NULL;
-	}
-
-	if (!ovr) {
-		crypto_free_hash(mdev->verify_tfm);
-		mdev->verify_tfm = verify_tfm;
-		verify_tfm = NULL;
-	}
-
-	if (fifo_size != mdev->rs_plan_s.size) {
-		kfree(mdev->rs_plan_s.values);
-		mdev->rs_plan_s.values = rs_plan_s;
-		mdev->rs_plan_s.size   = fifo_size;
-		mdev->rs_planed = 0;
-		rs_plan_s = NULL;
-	}
-
-	spin_unlock(&mdev->peer_seq_lock);
-
-	if (get_ldev(mdev)) {
-		wait_event(mdev->al_wait, lc_try_lock(mdev->act_log));
-		drbd_al_shrink(mdev);
-		err = drbd_check_al_size(mdev);
-		lc_unlock(mdev->act_log);
-		wake_up(&mdev->al_wait);
-
-		put_ldev(mdev);
-		drbd_md_sync(mdev);
-
-		if (err) {
-			retcode = ERR_NOMEM;
-			goto fail;
-		}
-	}
-
-	if (mdev->state.conn >= C_CONNECTED)
-		drbd_send_sync_param(mdev, &sc);
-
-	if (!cpumask_equal(mdev->tconn->cpu_mask, new_cpu_mask)) {
-		cpumask_copy(mdev->tconn->cpu_mask, new_cpu_mask);
-		drbd_calc_cpu_mask(mdev->tconn);
-		mdev->tconn->receiver.reset_cpu_mask = 1;
-		mdev->tconn->asender.reset_cpu_mask = 1;
-		mdev->tconn->worker.reset_cpu_mask = 1;
-	}
-
-	kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
 fail:
 	kfree(rs_plan_s);
 	free_cpumask_var(new_cpu_mask);
-	crypto_free_hash(csums_tfm);
-	crypto_free_hash(verify_tfm);
 
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -2342,6 +2485,9 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
 	if (nla_put_drbd_cfg_context(skb, mdev->tconn->name, mdev->vnr))
 		goto nla_put_failure;
 
+	if (res_opts_to_skb(skb, &mdev->tconn->res_opts, exclude_sensitive))
+		goto nla_put_failure;
+
 	if (got_ldev)
 		if (disk_conf_to_skb(skb, &mdev->ldev->dc, exclude_sensitive))
 			goto nla_put_failure;
@@ -2349,9 +2495,6 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
 		if (net_conf_to_skb(skb, mdev->tconn->net_conf, exclude_sensitive))
 			goto nla_put_failure;
 
-	if (syncer_conf_to_skb(skb, &mdev->sync_conf, exclude_sensitive))
-			goto nla_put_failure;
-
 	nla = nla_nest_start(skb, DRBD_NLA_STATE_INFO);
 	if (!nla)
 		goto nla_put_failure;
@@ -2569,7 +2712,7 @@ int drbd_adm_start_ov(struct sk_buff *skb, struct genl_info *info)
 		/* resume from last known position, if possible */
 		struct start_ov_parms parms =
 			{ .ov_start_sector = mdev->ov_start_sector };
-		int err = start_ov_parms_from_attrs(&parms, info->attrs);
+		int err = start_ov_parms_from_attrs(&parms, info);
 		if (err) {
 			retcode = ERR_MANDATORY_TAG;
 			drbd_msg_put_info(from_attrs_err_to_txt(err));
@@ -2605,7 +2748,7 @@ int drbd_adm_new_c_uuid(struct sk_buff *skb, struct genl_info *info)
 	mdev = adm_ctx.mdev;
 	memset(&args, 0, sizeof(args));
 	if (info->attrs[DRBD_NLA_NEW_C_UUID_PARMS]) {
-		err = new_c_uuid_parms_from_attrs(&args, info->attrs);
+		err = new_c_uuid_parms_from_attrs(&args, info);
 		if (err) {
 			retcode = ERR_MANDATORY_TAG;
 			drbd_msg_put_info(from_attrs_err_to_txt(err));
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 5fd78f4..6949f07 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -763,7 +763,7 @@ int drbd_connected(int vnr, void *p, void *data)
 		&mdev->tconn->cstate_mutex :
 		&mdev->own_state_mutex;
 
-	ok &= drbd_send_sync_param(mdev, &mdev->sync_conf);
+	ok &= drbd_send_sync_param(mdev);
 	ok &= drbd_send_sizes(mdev, 0, 0);
 	ok &= drbd_send_uuids(mdev);
 	ok &= drbd_send_state(mdev);
@@ -2088,7 +2088,7 @@ int drbd_rs_should_slow_down(struct drbd_conf *mdev, sector_t sector)
 	int throttle = 0;
 
 	/* feature disabled? */
-	if (mdev->sync_conf.c_min_rate == 0)
+	if (mdev->ldev->dc.c_min_rate == 0)
 		return 0;
 
 	spin_lock_irq(&mdev->al_lock);
@@ -2128,7 +2128,7 @@ int drbd_rs_should_slow_down(struct drbd_conf *mdev, sector_t sector)
 		db = mdev->rs_mark_left[i] - rs_left;
 		dbdt = Bit2KB(db/dt);
 
-		if (dbdt > mdev->sync_conf.c_min_rate)
+		if (dbdt > mdev->ldev->dc.c_min_rate)
 			throttle = 1;
 	}
 	return throttle;
@@ -3004,7 +3004,7 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 	if (drbd_recv(mdev->tconn, &p->head.payload, header_size) != header_size)
 		return false;
 
-	mdev->sync_conf.rate	  = be32_to_cpu(p->rate);
+	mdev->ldev->dc.resync_rate = be32_to_cpu(p->rate);
 
 	if (apv >= 88) {
 		if (apv == 88) {
@@ -3032,10 +3032,10 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 			p->csums_alg[SHARED_SECRET_MAX-1] = 0;
 		}
 
-		if (strcmp(mdev->sync_conf.verify_alg, p->verify_alg)) {
+		if (strcmp(mdev->tconn->net_conf->verify_alg, p->verify_alg)) {
 			if (mdev->state.conn == C_WF_REPORT_PARAMS) {
 				dev_err(DEV, "Different verify-alg settings. me=\"%s\" peer=\"%s\"\n",
-				    mdev->sync_conf.verify_alg, p->verify_alg);
+				    mdev->tconn->net_conf->verify_alg, p->verify_alg);
 				goto disconnect;
 			}
 			verify_tfm = drbd_crypto_alloc_digest_safe(mdev,
@@ -3046,10 +3046,10 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 			}
 		}
 
-		if (apv >= 89 && strcmp(mdev->sync_conf.csums_alg, p->csums_alg)) {
+		if (apv >= 89 && strcmp(mdev->tconn->net_conf->csums_alg, p->csums_alg)) {
 			if (mdev->state.conn == C_WF_REPORT_PARAMS) {
 				dev_err(DEV, "Different csums-alg settings. me=\"%s\" peer=\"%s\"\n",
-				    mdev->sync_conf.csums_alg, p->csums_alg);
+				    mdev->tconn->net_conf->csums_alg, p->csums_alg);
 				goto disconnect;
 			}
 			csums_tfm = drbd_crypto_alloc_digest_safe(mdev,
@@ -3061,13 +3061,13 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 		}
 
 		if (apv > 94) {
-			mdev->sync_conf.rate	  = be32_to_cpu(p->rate);
-			mdev->sync_conf.c_plan_ahead = be32_to_cpu(p->c_plan_ahead);
-			mdev->sync_conf.c_delay_target = be32_to_cpu(p->c_delay_target);
-			mdev->sync_conf.c_fill_target = be32_to_cpu(p->c_fill_target);
-			mdev->sync_conf.c_max_rate = be32_to_cpu(p->c_max_rate);
+			mdev->ldev->dc.resync_rate = be32_to_cpu(p->rate);
+			mdev->ldev->dc.c_plan_ahead = be32_to_cpu(p->c_plan_ahead);
+			mdev->ldev->dc.c_delay_target = be32_to_cpu(p->c_delay_target);
+			mdev->ldev->dc.c_fill_target = be32_to_cpu(p->c_fill_target);
+			mdev->ldev->dc.c_max_rate = be32_to_cpu(p->c_max_rate);
 
-			fifo_size = (mdev->sync_conf.c_plan_ahead * 10 * SLEEP_TIME) / HZ;
+			fifo_size = (mdev->ldev->dc.c_plan_ahead * 10 * SLEEP_TIME) / HZ;
 			if (fifo_size != mdev->rs_plan_s.size && fifo_size > 0) {
 				rs_plan_s   = kzalloc(sizeof(int) * fifo_size, GFP_KERNEL);
 				if (!rs_plan_s) {
@@ -3080,17 +3080,17 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 		spin_lock(&mdev->peer_seq_lock);
 		/* lock against drbd_nl_syncer_conf() */
 		if (verify_tfm) {
-			strcpy(mdev->sync_conf.verify_alg, p->verify_alg);
-			mdev->sync_conf.verify_alg_len = strlen(p->verify_alg) + 1;
-			crypto_free_hash(mdev->verify_tfm);
-			mdev->verify_tfm = verify_tfm;
+			strcpy(mdev->tconn->net_conf->verify_alg, p->verify_alg);
+			mdev->tconn->net_conf->verify_alg_len = strlen(p->verify_alg) + 1;
+			crypto_free_hash(mdev->tconn->verify_tfm);
+			mdev->tconn->verify_tfm = verify_tfm;
 			dev_info(DEV, "using verify-alg: \"%s\"\n", p->verify_alg);
 		}
 		if (csums_tfm) {
-			strcpy(mdev->sync_conf.csums_alg, p->csums_alg);
-			mdev->sync_conf.csums_alg_len = strlen(p->csums_alg) + 1;
-			crypto_free_hash(mdev->csums_tfm);
-			mdev->csums_tfm = csums_tfm;
+			strcpy(mdev->tconn->net_conf->csums_alg, p->csums_alg);
+			mdev->tconn->net_conf->csums_alg_len = strlen(p->csums_alg) + 1;
+			crypto_free_hash(mdev->tconn->csums_tfm);
+			mdev->tconn->csums_tfm = csums_tfm;
 			dev_info(DEV, "using csums-alg: \"%s\"\n", p->csums_alg);
 		}
 		if (fifo_size != mdev->rs_plan_s.size) {
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index e2686b3..c4a0710 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -403,7 +403,7 @@ is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
 		rv = SS_CONNECTED_OUTDATES;
 
 	else if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
-		 (mdev->sync_conf.verify_alg[0] == 0))
+		 (mdev->tconn->net_conf->verify_alg[0] == 0))
 		rv = SS_NO_VERIFY_ALG;
 
 	else if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
@@ -669,7 +669,7 @@ static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state
 	    (ns.role == R_PRIMARY && ns.conn < C_CONNECTED && ns.pdsk > D_OUTDATED))
 		ns.susp_fen = 1; /* Suspend IO while fence-peer handler runs (peer lost) */
 
-	if (mdev->sync_conf.on_no_data == OND_SUSPEND_IO &&
+	if (mdev->tconn->res_opts.on_no_data == OND_SUSPEND_IO &&
 	    (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE))
 		ns.susp_nod = 1; /* Suspend IO while no data available (no accessible data available) */
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index a730520..005876b 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -310,12 +310,12 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 	if (unlikely((peer_req->flags & EE_WAS_ERROR) != 0))
 		goto out;
 
-	digest_size = crypto_hash_digestsize(mdev->csums_tfm);
+	digest_size = crypto_hash_digestsize(mdev->tconn->csums_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (digest) {
 		sector_t sector = peer_req->i.sector;
 		unsigned int size = peer_req->i.size;
-		drbd_csum_ee(mdev, mdev->csums_tfm, peer_req, digest);
+		drbd_csum_ee(mdev, mdev->tconn->csums_tfm, peer_req, digest);
 		/* Free peer_req and pages before send.
 		 * In case we block on congestion, we could otherwise run into
 		 * some distributed deadlock, if the other side blocks on
@@ -451,13 +451,13 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 
 	spin_lock(&mdev->peer_seq_lock); /* get an atomic view on mdev->rs_plan_s */
 
-	steps = mdev->rs_plan_s.size; /* (mdev->sync_conf.c_plan_ahead * 10 * SLEEP_TIME) / HZ; */
+	steps = mdev->rs_plan_s.size; /* (mdev->ldev->dc.c_plan_ahead * 10 * SLEEP_TIME) / HZ; */
 
 	if (mdev->rs_in_flight + sect_in == 0) { /* At start of resync */
-		want = ((mdev->sync_conf.rate * 2 * SLEEP_TIME) / HZ) * steps;
+		want = ((mdev->ldev->dc.resync_rate * 2 * SLEEP_TIME) / HZ) * steps;
 	} else { /* normal path */
-		want = mdev->sync_conf.c_fill_target ? mdev->sync_conf.c_fill_target :
-			sect_in * mdev->sync_conf.c_delay_target * HZ / (SLEEP_TIME * 10);
+		want = mdev->ldev->dc.c_fill_target ? mdev->ldev->dc.c_fill_target :
+			sect_in * mdev->ldev->dc.c_delay_target * HZ / (SLEEP_TIME * 10);
 	}
 
 	correction = want - mdev->rs_in_flight - mdev->rs_planed;
@@ -476,7 +476,7 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 	if (req_sect < 0)
 		req_sect = 0;
 
-	max_sect = (mdev->sync_conf.c_max_rate * 2 * SLEEP_TIME) / HZ;
+	max_sect = (mdev->ldev->dc.c_max_rate * 2 * SLEEP_TIME) / HZ;
 	if (req_sect > max_sect)
 		req_sect = max_sect;
 
@@ -492,11 +492,11 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 static int drbd_rs_number_requests(struct drbd_conf *mdev)
 {
 	int number;
-	if (mdev->rs_plan_s.size) { /* mdev->sync_conf.c_plan_ahead */
+	if (mdev->rs_plan_s.size) { /* mdev->ldev->dc.c_plan_ahead */
 		number = drbd_rs_controller(mdev) >> (BM_BLOCK_SHIFT - 9);
 		mdev->c_sync_rate = number * HZ * (BM_BLOCK_SIZE / 1024) / SLEEP_TIME;
 	} else {
-		mdev->c_sync_rate = mdev->sync_conf.rate;
+		mdev->c_sync_rate = mdev->ldev->dc.resync_rate;
 		number = SLEEP_TIME * mdev->c_sync_rate  / ((BM_BLOCK_SIZE / 1024) * HZ);
 	}
 
@@ -619,7 +619,7 @@ next_sector:
 		/* adjust very last sectors, in case we are oddly sized */
 		if (sector + (size>>9) > capacity)
 			size = (capacity-sector)<<9;
-		if (mdev->tconn->agreed_pro_version >= 89 && mdev->csums_tfm) {
+		if (mdev->tconn->agreed_pro_version >= 89 && mdev->tconn->csums_tfm) {
 			switch (read_for_csum(mdev, sector, size)) {
 			case -EIO: /* Disk failure */
 				put_ldev(mdev);
@@ -810,7 +810,7 @@ int drbd_resync_finished(struct drbd_conf *mdev)
 		if (os.conn == C_SYNC_TARGET || os.conn == C_PAUSED_SYNC_T)
 			khelper_cmd = "after-resync-target";
 
-		if (mdev->csums_tfm && mdev->rs_total) {
+		if (mdev->tconn->csums_tfm && mdev->rs_total) {
 			const unsigned long s = mdev->rs_same_csum;
 			const unsigned long t = mdev->rs_total;
 			const int ratio =
@@ -1019,13 +1019,13 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 		/* quick hack to try to avoid a race against reconfiguration.
 		 * a real fix would be much more involved,
 		 * introducing more locking mechanisms */
-		if (mdev->csums_tfm) {
-			digest_size = crypto_hash_digestsize(mdev->csums_tfm);
+		if (mdev->tconn->csums_tfm) {
+			digest_size = crypto_hash_digestsize(mdev->tconn->csums_tfm);
 			D_ASSERT(digest_size == di->digest_size);
 			digest = kmalloc(digest_size, GFP_NOIO);
 		}
 		if (digest) {
-			drbd_csum_ee(mdev, mdev->csums_tfm, peer_req, digest);
+			drbd_csum_ee(mdev, mdev->tconn->csums_tfm, peer_req, digest);
 			eq = !memcmp(digest, di->digest, digest_size);
 			kfree(digest);
 		}
@@ -1069,7 +1069,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	if (unlikely(cancel))
 		goto out;
 
-	digest_size = crypto_hash_digestsize(mdev->verify_tfm);
+	digest_size = crypto_hash_digestsize(mdev->tconn->verify_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (!digest) {
 		ok = 0;	/* terminate the connection in case the allocation failed */
@@ -1077,7 +1077,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	}
 
 	if (likely(!(peer_req->flags & EE_WAS_ERROR)))
-		drbd_csum_ee(mdev, mdev->verify_tfm, peer_req, digest);
+		drbd_csum_ee(mdev, mdev->tconn->verify_tfm, peer_req, digest);
 	else
 		memset(digest, 0, digest_size);
 
@@ -1141,10 +1141,10 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	di = peer_req->digest;
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-		digest_size = crypto_hash_digestsize(mdev->verify_tfm);
+		digest_size = crypto_hash_digestsize(mdev->tconn->verify_tfm);
 		digest = kmalloc(digest_size, GFP_NOIO);
 		if (digest) {
-			drbd_csum_ee(mdev, mdev->verify_tfm, peer_req, digest);
+			drbd_csum_ee(mdev, mdev->tconn->verify_tfm, peer_req, digest);
 
 			D_ASSERT(digest_size == di->digest_size);
 			eq = !memcmp(digest, di->digest, digest_size);
@@ -1319,9 +1319,9 @@ static int _drbd_may_sync_now(struct drbd_conf *mdev)
 	struct drbd_conf *odev = mdev;
 
 	while (1) {
-		if (odev->sync_conf.after == -1)
+		if (odev->ldev->dc.resync_after == -1)
 			return 1;
-		odev = minor_to_mdev(odev->sync_conf.after);
+		odev = minor_to_mdev(odev->ldev->dc.resync_after);
 		if (!expect(odev))
 			return 1;
 		if ((odev->state.conn >= C_SYNC_SOURCE &&
@@ -1408,11 +1408,11 @@ static int sync_after_error(struct drbd_conf *mdev, int o_minor)
 			return ERR_SYNC_AFTER_CYCLE;
 
 		/* dependency chain ends here, no cycles. */
-		if (odev->sync_conf.after == -1)
+		if (odev->ldev->dc.resync_after == -1)
 			return NO_ERROR;
 
 		/* follow the dependency chain */
-		odev = minor_to_mdev(odev->sync_conf.after);
+		odev = minor_to_mdev(odev->ldev->dc.resync_after);
 	}
 }
 
@@ -1424,7 +1424,7 @@ int drbd_alter_sa(struct drbd_conf *mdev, int na)
 	write_lock_irq(&global_state_lock);
 	retcode = sync_after_error(mdev, na);
 	if (retcode == NO_ERROR) {
-		mdev->sync_conf.after = na;
+		mdev->ldev->dc.resync_after = na;
 		do {
 			changes  = _drbd_pause_after(mdev);
 			changes |= _drbd_resume_next(mdev);
@@ -1637,7 +1637,7 @@ int drbd_worker(struct drbd_thread *thi)
 	struct drbd_work *w = NULL;
 	struct drbd_conf *mdev;
 	LIST_HEAD(work_list);
-	int minor, intr = 0;
+	int vnr, intr = 0;
 
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
@@ -1722,7 +1722,7 @@ int drbd_worker(struct drbd_thread *thi)
 	spin_unlock_irq(&tconn->data.work.q_lock);
 
 	drbd_thread_stop(&tconn->receiver);
-	idr_for_each_entry(&tconn->volumes, mdev, minor) {
+	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		D_ASSERT(mdev->state.disk == D_DISKLESS && mdev->state.conn == C_STANDALONE);
 		/* _drbd_set_state only uses stop_nowait.
 		 * wait here for the exiting receiver. */
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index a07d692..edb5918 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -102,66 +102,73 @@ GENL_struct(DRBD_NLA_CFG_CONTEXT, 2, drbd_cfg_context,
 )
 
 GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
-	__u64_field(1, GENLA_F_MANDATORY,	disk_size)
-	__str_field(2, GENLA_F_REQUIRED,	backing_dev,	128)
-	__str_field(3, GENLA_F_REQUIRED,	meta_dev,	128)
-	__u32_field(4, GENLA_F_REQUIRED,	meta_dev_idx)
-	__u32_field(5, GENLA_F_MANDATORY,	max_bio_bvecs)
+	__str_field(1, GENLA_F_REQUIRED | GENLA_F_INVARIANT,	backing_dev,	128)
+	__str_field(2, GENLA_F_REQUIRED | GENLA_F_INVARIANT,	meta_dev,	128)
+	__u32_field(3, GENLA_F_REQUIRED | GENLA_F_INVARIANT,	meta_dev_idx)
+
+	/* use the resize command to try and change the disk_size */
+	__u64_field(4, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	disk_size)
+	/* we could change the max_bio_bvecs,
+	 * but it won't propagate through the stack */
+	__u32_field(5, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	max_bio_bvecs)
+
 	__u32_field(6, GENLA_F_MANDATORY,	on_io_error)
 	__u32_field(7, GENLA_F_MANDATORY,	fencing)
-	__flg_field(8, GENLA_F_MANDATORY,	no_disk_barrier)
-	__flg_field(9, GENLA_F_MANDATORY,	no_disk_flush)
-	__flg_field(10, GENLA_F_MANDATORY,	no_disk_drain)
-	__flg_field(11, GENLA_F_MANDATORY,	no_md_flush)
-	__flg_field(12, GENLA_F_MANDATORY,	use_bmbv)
+
+	__u32_field(8,	GENLA_F_MANDATORY,	resync_rate)
+	__u32_field(9,	GENLA_F_MANDATORY,	resync_after)
+	__u32_field(10,	GENLA_F_MANDATORY,	al_extents)
+	__u32_field(11,	GENLA_F_MANDATORY,	c_plan_ahead)
+	__u32_field(12,	GENLA_F_MANDATORY,	c_delay_target)
+	__u32_field(13,	GENLA_F_MANDATORY,	c_fill_target)
+	__u32_field(14,	GENLA_F_MANDATORY,	c_max_rate)
+	__u32_field(15,	GENLA_F_MANDATORY,	c_min_rate)
+
+	__flg_field(16, GENLA_F_MANDATORY,	no_disk_barrier)
+	__flg_field(17, GENLA_F_MANDATORY,	no_disk_flush)
+	__flg_field(18, GENLA_F_MANDATORY,	no_disk_drain)
+	__flg_field(19, GENLA_F_MANDATORY,	no_md_flush)
+
 )
 
-GENL_struct(DRBD_NLA_SYNCER_CONF, 4, syncer_conf,
-	__u32_field(1,	GENLA_F_MANDATORY,	rate)
-	__u32_field(2,	GENLA_F_MANDATORY,	after)
-	__u32_field(3,	GENLA_F_MANDATORY,	al_extents)
-	__str_field(4,	GENLA_F_MANDATORY,	cpu_mask,       32)
-	__str_field(5,	GENLA_F_MANDATORY,	verify_alg,     SHARED_SECRET_MAX)
-	__str_field(6,	GENLA_F_MANDATORY,	csums_alg,	SHARED_SECRET_MAX)
-	__flg_field(7,	GENLA_F_MANDATORY,	use_rle)
-	__u32_field(8,	GENLA_F_MANDATORY,	on_no_data)
-	__u32_field(9,	GENLA_F_MANDATORY,	c_plan_ahead)
-	__u32_field(10,	GENLA_F_MANDATORY,	c_delay_target)
-	__u32_field(11,	GENLA_F_MANDATORY,	c_fill_target)
-	__u32_field(12,	GENLA_F_MANDATORY,	c_max_rate)
-	__u32_field(13,	GENLA_F_MANDATORY,	c_min_rate)
+GENL_struct(DRBD_NLA_RESOURCE_OPTS, 4, res_opts,
+	__str_field(1,	GENLA_F_MANDATORY,	cpu_mask,       32)
+	__u32_field(2,	GENLA_F_MANDATORY,	on_no_data)
 )
 
 GENL_struct(DRBD_NLA_NET_CONF, 5, net_conf,
-	__str_field(1,	GENLA_F_MANDATORY | GENLA_F_SENSITIVE,
+	__str_field(1,	GENLA_F_REQUIRED | GENLA_F_INVARIANT,	my_addr,	128)
+	__str_field(2,	GENLA_F_REQUIRED | GENLA_F_INVARIANT,	peer_addr,	128)
+	__str_field(3,	GENLA_F_MANDATORY | GENLA_F_SENSITIVE,
 						shared_secret,	SHARED_SECRET_MAX)
-	__str_field(2,	GENLA_F_MANDATORY,	cram_hmac_alg,	SHARED_SECRET_MAX)
-	__str_field(3,	GENLA_F_MANDATORY,	integrity_alg,	SHARED_SECRET_MAX)
-	__str_field(4,	GENLA_F_REQUIRED,	my_addr,	128)
-	__str_field(5,	GENLA_F_REQUIRED,	peer_addr,	128)
-	__u32_field(6,	GENLA_F_REQUIRED,	wire_protocol)
-	__u32_field(7,	GENLA_F_MANDATORY,	try_connect_int)
-	__u32_field(8,	GENLA_F_MANDATORY,	timeout)
-	__u32_field(9,	GENLA_F_MANDATORY,	ping_int)
-	__u32_field(10,	GENLA_F_MANDATORY,	ping_timeo)
-	__u32_field(11,	GENLA_F_MANDATORY,	sndbuf_size)
-	__u32_field(12,	GENLA_F_MANDATORY,	rcvbuf_size)
-	__u32_field(13,	GENLA_F_MANDATORY,	ko_count)
-	__u32_field(14,	GENLA_F_MANDATORY,	max_buffers)
-	__u32_field(15,	GENLA_F_MANDATORY,	max_epoch_size)
-	__u32_field(16,	GENLA_F_MANDATORY,	unplug_watermark)
-	__u32_field(17,	GENLA_F_MANDATORY,	after_sb_0p)
-	__u32_field(18,	GENLA_F_MANDATORY,	after_sb_1p)
-	__u32_field(19,	GENLA_F_MANDATORY,	after_sb_2p)
-	__u32_field(20,	GENLA_F_MANDATORY,	rr_conflict)
-	__u32_field(21,	GENLA_F_MANDATORY,	on_congestion)
-	__u32_field(22,	GENLA_F_MANDATORY,	cong_fill)
-	__u32_field(23,	GENLA_F_MANDATORY,	cong_extents)
-	__flg_field(24, GENLA_F_MANDATORY,	two_primaries)
-	__flg_field(25, GENLA_F_MANDATORY,	want_lose)
-	__flg_field(26, GENLA_F_MANDATORY,	no_cork)
-	__flg_field(27, GENLA_F_MANDATORY,	always_asbp)
-	__flg_field(28, GENLA_F_MANDATORY,	dry_run)
+	__str_field(4,	GENLA_F_MANDATORY,	cram_hmac_alg,	SHARED_SECRET_MAX)
+	__str_field(5,	GENLA_F_MANDATORY,	integrity_alg,	SHARED_SECRET_MAX)
+	__str_field(6,	GENLA_F_MANDATORY,	verify_alg,     SHARED_SECRET_MAX)
+	__str_field(7,	GENLA_F_MANDATORY,	csums_alg,	SHARED_SECRET_MAX)
+	__u32_field(8,	GENLA_F_MANDATORY,	wire_protocol)
+	__u32_field(9,	GENLA_F_MANDATORY,	try_connect_int)
+	__u32_field(10,	GENLA_F_MANDATORY,	timeout)
+	__u32_field(11,	GENLA_F_MANDATORY,	ping_int)
+	__u32_field(12,	GENLA_F_MANDATORY,	ping_timeo)
+	__u32_field(13,	GENLA_F_MANDATORY,	sndbuf_size)
+	__u32_field(14,	GENLA_F_MANDATORY,	rcvbuf_size)
+	__u32_field(15,	GENLA_F_MANDATORY,	ko_count)
+	__u32_field(16,	GENLA_F_MANDATORY,	max_buffers)
+	__u32_field(17,	GENLA_F_MANDATORY,	max_epoch_size)
+	__u32_field(18,	GENLA_F_MANDATORY,	unplug_watermark)
+	__u32_field(19,	GENLA_F_MANDATORY,	after_sb_0p)
+	__u32_field(20,	GENLA_F_MANDATORY,	after_sb_1p)
+	__u32_field(21,	GENLA_F_MANDATORY,	after_sb_2p)
+	__u32_field(22,	GENLA_F_MANDATORY,	rr_conflict)
+	__u32_field(23,	GENLA_F_MANDATORY,	on_congestion)
+	__u32_field(24,	GENLA_F_MANDATORY,	cong_fill)
+	__u32_field(25,	GENLA_F_MANDATORY,	cong_extents)
+	__flg_field(26, GENLA_F_MANDATORY,	two_primaries)
+	__flg_field(27, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	want_lose)
+	__flg_field(28, GENLA_F_MANDATORY,	no_cork)
+	__flg_field(29, GENLA_F_MANDATORY,	always_asbp)
+	__flg_field(30, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	dry_run)
+	__flg_field(31,	GENLA_F_MANDATORY,	use_rle)
 )
 
 GENL_struct(DRBD_NLA_SET_ROLE_PARMS, 6, set_role_parms,
@@ -270,11 +277,10 @@ GENL_op(DRBD_ADM_ADD_LINK, 7, GENL_doit(drbd_adm_create_connection),
 GENL_op(DRBD_ADM_DEL_LINK, 8, GENL_doit(drbd_adm_delete_connection),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
 
-	/* operates on replication links */
-GENL_op(DRBD_ADM_SYNCER, 9,
-	GENL_doit(drbd_adm_syncer),
+GENL_op(DRBD_ADM_RESOURCE_OPTS, 9,
+	GENL_doit(drbd_adm_resource_opts),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
-	GENL_tla_expected(DRBD_NLA_SYNCER_CONF, GENLA_F_MANDATORY)
+	GENL_tla_expected(DRBD_NLA_RESOURCE_OPTS, GENLA_F_MANDATORY)
 )
 
 GENL_op(
@@ -284,16 +290,28 @@ GENL_op(
 	GENL_tla_expected(DRBD_NLA_NET_CONF, GENLA_F_REQUIRED)
 )
 
+GENL_op(
+	DRBD_ADM_CHG_NET_OPTS, 29,
+	GENL_doit(drbd_adm_net_opts),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_NET_CONF, GENLA_F_REQUIRED)
+)
+
 GENL_op(DRBD_ADM_DISCONNECT, 11, GENL_doit(drbd_adm_disconnect),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
 
-	/* operates on minors */
 GENL_op(DRBD_ADM_ATTACH, 12,
 	GENL_doit(drbd_adm_attach),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
 	GENL_tla_expected(DRBD_NLA_DISK_CONF, GENLA_F_REQUIRED)
 )
 
+GENL_op(DRBD_ADM_CHG_DISK_OPTS, 28,
+	GENL_doit(drbd_adm_disk_opts),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED)
+	GENL_tla_expected(DRBD_NLA_DISK_OPTS, GENLA_F_REQUIRED)
+)
+
 GENL_op(
 	DRBD_ADM_RESIZE, 13,
 	GENL_doit(drbd_adm_resize),
@@ -301,7 +319,6 @@ GENL_op(
 	GENL_tla_expected(DRBD_NLA_RESIZE_PARMS, GENLA_F_MANDATORY)
 )
 
-	/* operates on all volumes within a resource */
 GENL_op(
 	DRBD_ADM_PRIMARY, 14,
 	GENL_doit(drbd_adm_set_role),
diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 22920a8..659a8eb 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -166,5 +166,7 @@
 #define DRBD_CONG_EXTENTS_MAX	DRBD_AL_EXTENTS_MAX
 #define DRBD_CONG_EXTENTS_DEF	DRBD_AL_EXTENTS_DEF
 
+#define DRBD_PROTOCOL_DEF DRBD_PROT_C
+
 #undef RANGE
 #endif
diff --git a/include/linux/genl_magic_func.h b/include/linux/genl_magic_func.h
index 8a86f65..a2d70ac 100644
--- a/include/linux/genl_magic_func.h
+++ b/include/linux/genl_magic_func.h
@@ -190,13 +190,17 @@ static struct nlattr *nested_attr_tb[128];
 
 #undef GENL_struct
 #define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
-	/* static, potentially unused */				\
-int s_name ## _from_attrs(struct s_name *s, struct nlattr *tb[])	\
+/* *_from_attrs functions are static, but potentially unused */		\
+int s_name ## _from_attrs(struct s_name *s, struct genl_info *info)	\
 {									\
 	const int maxtype = ARRAY_SIZE(s_name ## _nl_policy)-1;		\
-	struct nlattr *tla = tb[tag_number];				\
+	struct nlattr *tla = info->attrs[tag_number];			\
 	struct nlattr **ntb = nested_attr_tb;				\
 	struct nlattr *nla;						\
+	/* invariants can only be set on object creation, */		\
+	/* not for CHANGE */						\
+	int exclude_invariants =					\
+		info->nlhdr->nlmsg_flags & NLM_F_REPLACE;		\
 	int err;							\
 	BUILD_BUG_ON(ARRAY_SIZE(s_name ## _nl_policy) > ARRAY_SIZE(nested_attr_tb));	\
 	if (!tla)							\
@@ -213,31 +217,38 @@ int s_name ## _from_attrs(struct s_name *s, struct nlattr *tb[])	\
 	return 0;							\
 }
 
-#undef __field
-#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put)	\
+
+#define __assign(attr_nr, attr_flag, name, nla_type, type, assignment...)	\
 		nla = ntb[__nla_type(attr_nr)];				\
 		if (nla) {						\
-			if (s)						\
-				s->name = __get(nla);			\
-			DPRINT_FIELD("<<", nla_type, name, s, nla);	\
+			if (exclude_invariants && ((attr_flag) & GENLA_F_INVARIANT)) {		\
+				pr_info("<< must not change invariant attr: %s\n", #name);	\
+				return -EEXIST;				\
+			}						\
+			assignment;					\
+		} else if (exclude_invariants && ((attr_flag) & GENLA_F_INVARIANT)) {		\
+			/* attribute missing from payload, */		\
+			/* which was expected */			\
 		} else if ((attr_flag) & GENLA_F_REQUIRED) {		\
 			pr_info("<< missing attr: %s\n", #name);	\
 			return -ENOMSG;					\
 		}
 
+#undef __field
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put)	\
+	__assign(attr_nr, attr_flag, name, nla_type, type,		\
+			if (s)						\
+				s->name = __get(nla);			\
+			DPRINT_FIELD("<<", nla_type, name, s, nla))
+
 /* validate_nla() already checked nla_len <= maxlen appropriately. */
 #undef __array
 #define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put) \
-		nla = ntb[__nla_type(attr_nr)];				\
-		if (nla) {						\
+	__assign(attr_nr, attr_flag, name, nla_type, type,		\
 			if (s)						\
 				s->name ## _len =			\
 					__get(s->name, nla, maxlen);	\
-			DPRINT_ARRAY("<<", nla_type, name, s, nla);	\
-		} else if ((attr_flag) & GENLA_F_REQUIRED) {		\
-			pr_info("<< missing attr: %s\n", #name);	\
-			return -ENOMSG;					\
-		}							\
+			DPRINT_ARRAY("<<", nla_type, name, s, nla))
 
 #include GENL_MAGIC_INCLUDE_FILE
 
diff --git a/include/linux/genl_magic_struct.h b/include/linux/genl_magic_struct.h
index 745ebfd..9a605b9 100644
--- a/include/linux/genl_magic_struct.h
+++ b/include/linux/genl_magic_struct.h
@@ -59,12 +59,20 @@ enum {
 	GENLA_F_MANDATORY	= 1 << 14,
 	GENLA_F_REQUIRED	= 1 << 15,
 
-	/* This will not be present in the __u16 .nla_type, but can be
-	 * triggered on in <struct>_to_skb, to exclude "sensitive"
-	 * information from broadcasts, or on unpriviledged get requests.
-	 * This is useful because genetlink multicast groups can be listened in
-	 * on by anyone.  */
+	/* Below will not be present in the __u16 .nla_type, but can be
+	 * triggered on in <struct>_to_skb resp. <struct>_from_attrs */
+
+	/* To exclude "sensitive" information from broadcasts, or on
+	 * unpriviledged get requests.  This is useful because genetlink
+	 * multicast groups can be listened in on by anyone.  */
 	GENLA_F_SENSITIVE	= 1 << 16,
+
+	/* INVARIAN options cannot be changed at runtime.
+	 * Useful to share an attribute policy and struct definition,
+	 * between some "create" and "change" commands,
+	 * but disallow certain fields to be changed online.
+	 */
+	GENLA_F_INVARIANT	= 1 << 17,
 };
 
 #define __nla_type(x)	((__u16)((__u16)(x) & (__u16)NLA_TYPE_MASK))
-- 
1.7.4.1

