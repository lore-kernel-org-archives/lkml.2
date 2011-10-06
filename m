Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab1JFNkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:40:46 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34164 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311Ab1JFNiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:09 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/15] drbd: RCU for disk_conf
Date: Thu,  6 Oct 2011 15:37:52 +0200
Message-Id: <1317908280-28951-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   54 +++++++++++---
 drivers/block/drbd/drbd_main.c     |   25 ++++--
 drivers/block/drbd/drbd_nl.c       |  144 ++++++++++++++++++++++++------------
 drivers/block/drbd/drbd_receiver.c |  138 ++++++++++++++++++++++------------
 drivers/block/drbd/drbd_state.c    |   16 +++-
 drivers/block/drbd/drbd_worker.c   |   38 +++++++---
 6 files changed, 282 insertions(+), 133 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index f8d0ac3..cd77dd4 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -777,7 +777,7 @@ struct drbd_backing_dev {
 	struct block_device *backing_bdev;
 	struct block_device *md_bdev;
 	struct drbd_md md;
-	struct disk_conf dc; /* The user provided config... */
+	struct disk_conf *disk_conf; /* RCU, for updates: mdev->tconn->conf_update */
 	sector_t known_size; /* last known size of that backing device */
 };
 
@@ -1644,8 +1644,13 @@ static inline union drbd_state drbd_read_state(struct drbd_conf *mdev)
 #define __drbd_chk_io_error(m,f) __drbd_chk_io_error_(m,f, __func__)
 static inline void __drbd_chk_io_error_(struct drbd_conf *mdev, int forcedetach, const char *where)
 {
-	switch (mdev->ldev->dc.on_io_error) {
-	case EP_PASS_ON:
+	enum drbd_io_error_p ep;
+
+	rcu_read_lock();
+	ep = rcu_dereference(mdev->ldev->disk_conf)->on_io_error;
+	rcu_read_unlock();
+	switch (ep) {
+	case EP_PASS_ON: /* FIXME would this be better named "Ignore"? */
 		if (!forcedetach) {
 			if (__ratelimit(&drbd_ratelimit_state))
 				dev_err(DEV, "Local IO failed in %s.\n", where);
@@ -1694,9 +1699,9 @@ static inline void drbd_chk_io_error_(struct drbd_conf *mdev,
  * BTW, for internal meta data, this happens to be the maximum capacity
  * we could agree upon with our peer node.
  */
-static inline sector_t drbd_md_first_sector(struct drbd_backing_dev *bdev)
+static inline sector_t _drbd_md_first_sector(int meta_dev_idx, struct drbd_backing_dev *bdev)
 {
-	switch (bdev->dc.meta_dev_idx) {
+	switch (meta_dev_idx) {
 	case DRBD_MD_INDEX_INTERNAL:
 	case DRBD_MD_INDEX_FLEX_INT:
 		return bdev->md.md_offset + bdev->md.bm_offset;
@@ -1706,13 +1711,30 @@ static inline sector_t drbd_md_first_sector(struct drbd_backing_dev *bdev)
 	}
 }
 
+static inline sector_t drbd_md_first_sector(struct drbd_backing_dev *bdev)
+{
+	int meta_dev_idx;
+
+	rcu_read_lock();
+	meta_dev_idx = rcu_dereference(bdev->disk_conf)->meta_dev_idx;
+	rcu_read_unlock();
+
+	return _drbd_md_first_sector(meta_dev_idx, bdev);
+}
+
 /**
  * drbd_md_last_sector() - Return the last sector number of the meta data area
  * @bdev:	Meta data block device.
  */
 static inline sector_t drbd_md_last_sector(struct drbd_backing_dev *bdev)
 {
-	switch (bdev->dc.meta_dev_idx) {
+	int meta_dev_idx;
+
+	rcu_read_lock();
+	meta_dev_idx = rcu_dereference(bdev->disk_conf)->meta_dev_idx;
+	rcu_read_unlock();
+
+	switch (meta_dev_idx) {
 	case DRBD_MD_INDEX_INTERNAL:
 	case DRBD_MD_INDEX_FLEX_INT:
 		return bdev->md.md_offset + MD_AL_OFFSET - 1;
@@ -1740,12 +1762,18 @@ static inline sector_t drbd_get_capacity(struct block_device *bdev)
 static inline sector_t drbd_get_max_capacity(struct drbd_backing_dev *bdev)
 {
 	sector_t s;
-	switch (bdev->dc.meta_dev_idx) {
+	int meta_dev_idx;
+
+	rcu_read_lock();
+	meta_dev_idx = rcu_dereference(bdev->disk_conf)->meta_dev_idx;
+	rcu_read_unlock();
+
+	switch (meta_dev_idx) {
 	case DRBD_MD_INDEX_INTERNAL:
 	case DRBD_MD_INDEX_FLEX_INT:
 		s = drbd_get_capacity(bdev->backing_bdev)
 			? min_t(sector_t, DRBD_MAX_SECTORS_FLEX,
-					drbd_md_first_sector(bdev))
+				_drbd_md_first_sector(meta_dev_idx, bdev))
 			: 0;
 		break;
 	case DRBD_MD_INDEX_FLEX_EXT:
@@ -1771,9 +1799,15 @@ static inline sector_t drbd_get_max_capacity(struct drbd_backing_dev *bdev)
 static inline sector_t drbd_md_ss__(struct drbd_conf *mdev,
 				    struct drbd_backing_dev *bdev)
 {
-	switch (bdev->dc.meta_dev_idx) {
+	int meta_dev_idx;
+
+	rcu_read_lock();
+	meta_dev_idx = rcu_dereference(bdev->disk_conf)->meta_dev_idx;
+	rcu_read_unlock();
+
+	switch (meta_dev_idx) {
 	default: /* external, some index */
-		return MD_RESERVED_SECT * bdev->dc.meta_dev_idx;
+		return MD_RESERVED_SECT * meta_dev_idx;
 	case DRBD_MD_INDEX_INTERNAL:
 		/* with drbd08, internal meta data is always "flexible" */
 	case DRBD_MD_INDEX_FLEX_INT:
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 352c36f..32ebedb 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -866,6 +866,7 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 	const int apv = mdev->tconn->agreed_pro_version;
 	enum drbd_packet cmd;
 	struct net_conf *nc;
+	struct disk_conf *dc;
 
 	sock = &mdev->tconn->data;
 	p = drbd_prepare_command(mdev, sock);
@@ -887,11 +888,12 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
 
 	if (get_ldev(mdev)) {
-		p->rate = cpu_to_be32(mdev->ldev->dc.resync_rate);
-		p->c_plan_ahead = cpu_to_be32(mdev->ldev->dc.c_plan_ahead);
-		p->c_delay_target = cpu_to_be32(mdev->ldev->dc.c_delay_target);
-		p->c_fill_target = cpu_to_be32(mdev->ldev->dc.c_fill_target);
-		p->c_max_rate = cpu_to_be32(mdev->ldev->dc.c_max_rate);
+		dc = rcu_dereference(mdev->ldev->disk_conf);
+		p->rate = cpu_to_be32(dc->resync_rate);
+		p->c_plan_ahead = cpu_to_be32(dc->c_plan_ahead);
+		p->c_delay_target = cpu_to_be32(dc->c_delay_target);
+		p->c_fill_target = cpu_to_be32(dc->c_fill_target);
+		p->c_max_rate = cpu_to_be32(dc->c_max_rate);
 		put_ldev(mdev);
 	} else {
 		p->rate = cpu_to_be32(DRBD_RATE_DEF);
@@ -1056,7 +1058,9 @@ int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags fl
 	if (get_ldev_if_state(mdev, D_NEGOTIATING)) {
 		D_ASSERT(mdev->ldev->backing_bdev);
 		d_size = drbd_get_max_capacity(mdev->ldev);
-		u_size = mdev->ldev->dc.disk_size;
+		rcu_read_lock();
+		u_size = rcu_dereference(mdev->ldev->disk_conf)->disk_size;
+		rcu_read_unlock();
 		q_order_type = drbd_queue_order_type(mdev);
 		max_bio_size = queue_max_hw_sectors(mdev->ldev->backing_bdev->bd_disk->queue) << 9;
 		max_bio_size = min_t(int, max_bio_size, DRBD_MAX_BIO_SIZE);
@@ -2889,7 +2893,6 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	for (i = UI_CURRENT; i < UI_SIZE; i++)
 		bdev->md.uuid[i] = be64_to_cpu(buffer->uuid[i]);
 	bdev->md.flags = be32_to_cpu(buffer->flags);
-	bdev->dc.al_extents = be32_to_cpu(buffer->al_nr_extents);
 	bdev->md.device_uuid = be64_to_cpu(buffer->device_uuid);
 
 	spin_lock_irq(&mdev->tconn->req_lock);
@@ -2901,8 +2904,12 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	}
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-	if (bdev->dc.al_extents < 7)
-		bdev->dc.al_extents = 127;
+	mutex_lock(&mdev->tconn->conf_update);
+	/* This blocks wants to be get removed... */
+	bdev->disk_conf->al_extents = be32_to_cpu(buffer->al_nr_extents);
+	if (bdev->disk_conf->al_extents < DRBD_AL_EXTENTS_MIN)
+		bdev->disk_conf->al_extents = DRBD_AL_EXTENTS_DEF;
+	mutex_unlock(&mdev->tconn->conf_update);
 
  err:
 	mutex_unlock(&mdev->md_io_mutex);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 84b055f..a7d4c0e 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -419,7 +419,8 @@ static enum drbd_fencing_p highest_fencing_policy(struct drbd_tconn *tconn)
 	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		if (get_ldev_if_state(mdev, D_CONSISTENT)) {
-			fp = max_t(enum drbd_fencing_p, fp, mdev->ldev->dc.fencing);
+			fp = max_t(enum drbd_fencing_p, fp,
+				   rcu_dereference(mdev->ldev->disk_conf)->fencing);
 			put_ldev(mdev);
 		}
 	}
@@ -700,7 +701,12 @@ static void drbd_md_set_sector_offsets(struct drbd_conf *mdev,
 				       struct drbd_backing_dev *bdev)
 {
 	sector_t md_size_sect = 0;
-	switch (bdev->dc.meta_dev_idx) {
+	int meta_dev_idx;
+
+	rcu_read_lock();
+	meta_dev_idx = rcu_dereference(bdev->disk_conf)->meta_dev_idx;
+
+	switch (meta_dev_idx) {
 	default:
 		/* v07 style fixed size indexed meta data */
 		bdev->md.md_size_sect = MD_RESERVED_SECT;
@@ -735,6 +741,7 @@ static void drbd_md_set_sector_offsets(struct drbd_conf *mdev,
 		bdev->md.bm_offset   = -md_size_sect + MD_AL_OFFSET;
 		break;
 	}
+	rcu_read_unlock();
 }
 
 /* input size is expected to be in KB */
@@ -825,7 +832,9 @@ enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds
 	/* TODO: should only be some assert here, not (re)init... */
 	drbd_md_set_sector_offsets(mdev, mdev->ldev);
 
-	u_size = mdev->ldev->dc.disk_size;
+	rcu_read_lock();
+	u_size = rcu_dereference(mdev->ldev->disk_conf)->disk_size;
+	rcu_read_unlock();
 	size = drbd_new_dev_size(mdev, mdev->ldev, u_size, flags & DDSF_FORCED);
 
 	if (drbd_get_capacity(mdev->this_bdev) != size ||
@@ -1001,7 +1010,9 @@ static void drbd_setup_queue_param(struct drbd_conf *mdev, unsigned int max_bio_
 		struct request_queue * const b = mdev->ldev->backing_bdev->bd_disk->queue;
 
 		max_hw_sectors = min(queue_max_hw_sectors(b), max_bio_size >> 9);
-		max_segments = mdev->ldev->dc.max_bio_bvecs;
+		rcu_read_lock();
+		max_segments = rcu_dereference(mdev->ldev->disk_conf)->max_bio_bvecs;
+		rcu_read_unlock();
 		put_ldev(mdev);
 	}
 
@@ -1117,7 +1128,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
 	struct drbd_conf *mdev;
-	struct disk_conf *new_disk_conf;
+	struct disk_conf *new_disk_conf, *old_disk_conf;
 	int err, fifo_size;
 	int *rs_plan_s = NULL;
 
@@ -1150,19 +1161,15 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-/* FIXME freeze IO, cluster wide.
- *
- * We should make sure no-one uses
- * some half-updated struct when we
- * assign it later. */
-
-	new_disk_conf = kmalloc(sizeof(*new_disk_conf), GFP_KERNEL);
+	new_disk_conf = kmalloc(sizeof(struct disk_conf), GFP_KERNEL);
 	if (!new_disk_conf) {
 		retcode = ERR_NOMEM;
 		goto fail;
 	}
 
-	memcpy(new_disk_conf, &mdev->ldev->dc, sizeof(*new_disk_conf));
+	mutex_lock(&mdev->tconn->conf_update);
+	old_disk_conf = mdev->ldev->disk_conf;
+	*new_disk_conf = *old_disk_conf;
 	if (should_set_defaults(info))
 		set_disk_conf_defaults(new_disk_conf);
 
@@ -1187,7 +1194,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 		if (!rs_plan_s) {
 			dev_err(DEV, "kmalloc of fifo_buffer failed");
 			retcode = ERR_NOMEM;
-			goto fail;
+			goto fail_unlock;
 		}
 	}
 
@@ -1207,31 +1214,37 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 
 	if (err) {
 		retcode = ERR_NOMEM;
-		goto fail;
+		goto fail_unlock;
 	}
 
-	/* FIXME
-	 * To avoid someone looking at a half-updated struct, we probably
-	 * should have a rw-semaphor on net_conf and disk_conf.
-	 */
 	write_lock_irq(&global_state_lock);
 	retcode = drbd_sync_after_valid(mdev, new_disk_conf->resync_after);
 	if (retcode == NO_ERROR) {
-		mdev->ldev->dc = *new_disk_conf;
+		rcu_assign_pointer(mdev->ldev->disk_conf, new_disk_conf);
 		drbd_sync_after_changed(mdev);
 	}
 	write_unlock_irq(&global_state_lock);
 
-	drbd_md_sync(mdev);
+	if (retcode != NO_ERROR)
+		goto fail_unlock;
 
+	drbd_md_sync(mdev);
 
 	if (mdev->state.conn >= C_CONNECTED)
 		drbd_send_sync_param(mdev);
 
+	mutex_unlock(&mdev->tconn->conf_update);
+	synchronize_rcu();
+	kfree(old_disk_conf);
+	goto success;
+
+fail_unlock:
+	mutex_unlock(&mdev->tconn->conf_update);
  fail:
-	put_ldev(mdev);
 	kfree(new_disk_conf);
 	kfree(rs_plan_s);
+success:
+	put_ldev(mdev);
  out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -1246,6 +1259,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	sector_t max_possible_sectors;
 	sector_t min_md_device_sectors;
 	struct drbd_backing_dev *nbc = NULL; /* new_backing_conf */
+	struct disk_conf *new_disk_conf = NULL;
 	struct block_device *bdev;
 	struct lru_cache *resync_lru = NULL;
 	union drbd_state ns, os;
@@ -1279,17 +1293,22 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		retcode = ERR_NOMEM;
 		goto fail;
 	}
+	new_disk_conf = kzalloc(sizeof(struct disk_conf), GFP_KERNEL);
+	if (!new_disk_conf) {
+		retcode = ERR_NOMEM;
+		goto fail;
+	}
+	nbc->disk_conf = new_disk_conf;
 
-	set_disk_conf_defaults(&nbc->dc);
-
-	err = disk_conf_from_attrs(&nbc->dc, info);
+	set_disk_conf_defaults(new_disk_conf);
+	err = disk_conf_from_attrs(new_disk_conf, info);
 	if (err) {
 		retcode = ERR_MANDATORY_TAG;
 		drbd_msg_put_info(from_attrs_err_to_txt(err));
 		goto fail;
 	}
 
-	if (nbc->dc.meta_dev_idx < DRBD_MD_INDEX_FLEX_INT) {
+	if (new_disk_conf->meta_dev_idx < DRBD_MD_INDEX_FLEX_INT) {
 		retcode = ERR_MD_IDX_INVALID;
 		goto fail;
 	}
@@ -1297,7 +1316,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	rcu_read_lock();
 	nc = rcu_dereference(mdev->tconn->net_conf);
 	if (nc) {
-		if (nbc->dc.fencing == FP_STONITH && nc->wire_protocol == DRBD_PROT_A) {
+		if (new_disk_conf->fencing == FP_STONITH && nc->wire_protocol == DRBD_PROT_A) {
 			rcu_read_unlock();
 			retcode = ERR_STONITH_AND_PROT_A;
 			goto fail;
@@ -1305,10 +1324,10 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	}
 	rcu_read_unlock();
 
-	bdev = blkdev_get_by_path(nbc->dc.backing_dev,
+	bdev = blkdev_get_by_path(new_disk_conf->backing_dev,
 				  FMODE_READ | FMODE_WRITE | FMODE_EXCL, mdev);
 	if (IS_ERR(bdev)) {
-		dev_err(DEV, "open(\"%s\") failed with %ld\n", nbc->dc.backing_dev,
+		dev_err(DEV, "open(\"%s\") failed with %ld\n", new_disk_conf->backing_dev,
 			PTR_ERR(bdev));
 		retcode = ERR_OPEN_DISK;
 		goto fail;
@@ -1323,12 +1342,12 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	 * should check it for you already; but if you don't, or
 	 * someone fooled it, we need to double check here)
 	 */
-	bdev = blkdev_get_by_path(nbc->dc.meta_dev,
+	bdev = blkdev_get_by_path(new_disk_conf->meta_dev,
 				  FMODE_READ | FMODE_WRITE | FMODE_EXCL,
-				  (nbc->dc.meta_dev_idx < 0) ?
+				  (new_disk_conf->meta_dev_idx < 0) ?
 				  (void *)mdev : (void *)drbd_m_holder);
 	if (IS_ERR(bdev)) {
-		dev_err(DEV, "open(\"%s\") failed with %ld\n", nbc->dc.meta_dev,
+		dev_err(DEV, "open(\"%s\") failed with %ld\n", new_disk_conf->meta_dev,
 			PTR_ERR(bdev));
 		retcode = ERR_OPEN_MD_DISK;
 		goto fail;
@@ -1336,8 +1355,8 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	nbc->md_bdev = bdev;
 
 	if ((nbc->backing_bdev == nbc->md_bdev) !=
-	    (nbc->dc.meta_dev_idx == DRBD_MD_INDEX_INTERNAL ||
-	     nbc->dc.meta_dev_idx == DRBD_MD_INDEX_FLEX_INT)) {
+	    (new_disk_conf->meta_dev_idx == DRBD_MD_INDEX_INTERNAL ||
+	     new_disk_conf->meta_dev_idx == DRBD_MD_INDEX_FLEX_INT)) {
 		retcode = ERR_MD_IDX_INVALID;
 		goto fail;
 	}
@@ -1353,21 +1372,21 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	/* RT - for drbd_get_max_capacity() DRBD_MD_INDEX_FLEX_INT */
 	drbd_md_set_sector_offsets(mdev, nbc);
 
-	if (drbd_get_max_capacity(nbc) < nbc->dc.disk_size) {
+	if (drbd_get_max_capacity(nbc) < new_disk_conf->disk_size) {
 		dev_err(DEV, "max capacity %llu smaller than disk size %llu\n",
 			(unsigned long long) drbd_get_max_capacity(nbc),
-			(unsigned long long) nbc->dc.disk_size);
+			(unsigned long long) new_disk_conf->disk_size);
 		retcode = ERR_DISK_TO_SMALL;
 		goto fail;
 	}
 
-	if (nbc->dc.meta_dev_idx < 0) {
+	if (new_disk_conf->meta_dev_idx < 0) {
 		max_possible_sectors = DRBD_MAX_SECTORS_FLEX;
 		/* at least one MB, otherwise it does not make sense */
 		min_md_device_sectors = (2<<10);
 	} else {
 		max_possible_sectors = DRBD_MAX_SECTORS;
-		min_md_device_sectors = MD_RESERVED_SECT * (nbc->dc.meta_dev_idx + 1);
+		min_md_device_sectors = MD_RESERVED_SECT * (new_disk_conf->meta_dev_idx + 1);
 	}
 
 	if (drbd_get_capacity(nbc->md_bdev) < min_md_device_sectors) {
@@ -1392,7 +1411,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		dev_warn(DEV, "==> truncating very big lower level device "
 			"to currently maximum possible %llu sectors <==\n",
 			(unsigned long long) max_possible_sectors);
-		if (nbc->dc.meta_dev_idx >= 0)
+		if (new_disk_conf->meta_dev_idx >= 0)
 			dev_warn(DEV, "==>> using internal or flexible "
 				      "meta data may help <<==\n");
 	}
@@ -1435,14 +1454,14 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* Since we are diskless, fix the activity log first... */
-	if (drbd_check_al_size(mdev, &nbc->dc)) {
+	if (drbd_check_al_size(mdev, new_disk_conf)) {
 		retcode = ERR_NOMEM;
 		goto force_diskless_dec;
 	}
 
 	/* Prevent shrinking of consistent devices ! */
 	if (drbd_md_test_flag(nbc, MDF_CONSISTENT) &&
-	    drbd_new_dev_size(mdev, nbc, nbc->dc.disk_size, 0) < nbc->md.la_size_sect) {
+	    drbd_new_dev_size(mdev, nbc, nbc->disk_conf->disk_size, 0) < nbc->md.la_size_sect) {
 		dev_warn(DEV, "refusing to truncate a consistent device\n");
 		retcode = ERR_DISK_TO_SMALL;
 		goto force_diskless_dec;
@@ -1455,11 +1474,13 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 
 	/* Reset the "barriers don't work" bits here, then force meta data to
 	 * be written, to ensure we determine if barriers are supported. */
-	if (nbc->dc.no_md_flush)
+	if (new_disk_conf->no_md_flush)
 		set_bit(MD_NO_FUA, &mdev->flags);
 	else
 		clear_bit(MD_NO_FUA, &mdev->flags);
 
+	/* FIXME Missing stuff: rs_plan_s, clip al range */
+
 	/* Point of no return reached.
 	 * Devices and memory are no longer released by error cleanup below.
 	 * now mdev takes over responsibility, and the state engine should
@@ -1469,6 +1490,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	mdev->resync = resync_lru;
 	nbc = NULL;
 	resync_lru = NULL;
+	new_disk_conf = NULL;
 
 	mdev->write_ordering = WO_bdev_flush;
 	drbd_bump_write_ordering(mdev, WO_bdev_flush);
@@ -1566,9 +1588,11 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	if (drbd_md_test_flag(mdev->ldev, MDF_PEER_OUT_DATED))
 		ns.pdsk = D_OUTDATED;
 
-	if ( ns.disk == D_CONSISTENT &&
-	    (ns.pdsk == D_OUTDATED || mdev->ldev->dc.fencing == FP_DONT_CARE))
+	rcu_read_lock();
+	if (ns.disk == D_CONSISTENT &&
+	    (ns.pdsk == D_OUTDATED || rcu_dereference(mdev->ldev->disk_conf)->fencing == FP_DONT_CARE))
 		ns.disk = D_UP_TO_DATE;
+	rcu_read_unlock();
 
 	/* All tests on MDF_PRIMARY_IND, MDF_CONNECTED_IND,
 	   MDF_CONSISTENT and MDF_WAS_UP_TO_DATE must happen before
@@ -1625,6 +1649,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 				   FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 		kfree(nbc);
 	}
+	kfree(new_disk_conf);
 	lc_destroy(resync_lru);
 
  finish:
@@ -1727,7 +1752,7 @@ _check_net_options(struct drbd_tconn *tconn, struct net_conf *old_conf, struct n
 
 	idr_for_each_entry(&tconn->volumes, mdev, i) {
 		if (get_ldev(mdev)) {
-			enum drbd_fencing_p fp = mdev->ldev->dc.fencing;
+			enum drbd_fencing_p fp = rcu_dereference(mdev->ldev->disk_conf)->fencing;
 			put_ldev(mdev);
 			if (new_conf->wire_protocol == DRBD_PROT_A && fp == FP_STONITH)
 				return ERR_STONITH_AND_PROT_A;
@@ -2204,11 +2229,13 @@ void resync_after_online_grow(struct drbd_conf *mdev)
 
 int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 {
+	struct disk_conf *old_disk_conf, *new_disk_conf = NULL;
 	struct resize_parms rs;
 	struct drbd_conf *mdev;
 	enum drbd_ret_code retcode;
 	enum determine_dev_size dd;
 	enum dds_flags ddsf;
+	sector_t u_size;
 	int err;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
@@ -2249,10 +2276,31 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
+	rcu_read_lock();
+	u_size = rcu_dereference(mdev->ldev->disk_conf)->disk_size;
+	rcu_read_unlock();
+	if (u_size != (sector_t)rs.resize_size) {
+		new_disk_conf = kmalloc(sizeof(struct disk_conf), GFP_KERNEL);
+		if (!new_disk_conf) {
+			retcode = ERR_NOMEM;
+			goto fail;
+		}
+	}
+
 	if (mdev->ldev->known_size != drbd_get_capacity(mdev->ldev->backing_bdev))
 		mdev->ldev->known_size = drbd_get_capacity(mdev->ldev->backing_bdev);
 
-	mdev->ldev->dc.disk_size = (sector_t)rs.resize_size;
+	if (new_disk_conf) {
+		mutex_lock(&mdev->tconn->conf_update);
+		old_disk_conf = mdev->ldev->disk_conf;
+		*new_disk_conf = *old_disk_conf;
+		new_disk_conf->disk_size = (sector_t)rs.resize_size;
+		rcu_assign_pointer(mdev->ldev->disk_conf, new_disk_conf);
+		mutex_unlock(&mdev->tconn->conf_update);
+		synchronize_rcu();
+		kfree(old_disk_conf);
+	}
+
 	ddsf = (rs.resize_force ? DDSF_FORCED : 0) | (rs.no_resync ? DDSF_NO_RESYNC : 0);
 	dd = drbd_determine_dev_size(mdev, ddsf);
 	drbd_md_sync(mdev);
@@ -2546,11 +2594,11 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
 	if (res_opts_to_skb(skb, &mdev->tconn->res_opts, exclude_sensitive))
 		goto nla_put_failure;
 
+	rcu_read_lock();
 	if (got_ldev)
-		if (disk_conf_to_skb(skb, &mdev->ldev->dc, exclude_sensitive))
+		if (disk_conf_to_skb(skb, rcu_dereference(mdev->ldev->disk_conf), exclude_sensitive))
 			goto nla_put_failure;
 
-	rcu_read_lock();
 	nc = rcu_dereference(mdev->tconn->net_conf);
 	if (nc)
 		err = net_conf_to_skb(skb, nc, exclude_sensitive);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index bba0050..add4176 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1166,6 +1166,7 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_conf *mdev,
  */
 void drbd_bump_write_ordering(struct drbd_conf *mdev, enum write_ordering_e wo) __must_hold(local)
 {
+	struct disk_conf *dc;
 	enum write_ordering_e pwo;
 	static char *write_ordering_str[] = {
 		[WO_none] = "none",
@@ -1175,10 +1176,14 @@ void drbd_bump_write_ordering(struct drbd_conf *mdev, enum write_ordering_e wo)
 
 	pwo = mdev->write_ordering;
 	wo = min(pwo, wo);
-	if (wo == WO_bdev_flush && mdev->ldev->dc.no_disk_flush)
+	rcu_read_lock();
+	dc = rcu_dereference(mdev->ldev->disk_conf);
+
+	if (wo == WO_bdev_flush && dc->no_disk_flush)
 		wo = WO_drain_io;
-	if (wo == WO_drain_io && mdev->ldev->dc.no_disk_drain)
+	if (wo == WO_drain_io && dc->no_disk_drain)
 		wo = WO_none;
+	rcu_read_unlock();
 	mdev->write_ordering = wo;
 	if (pwo != mdev->write_ordering || wo == WO_bdev_flush)
 		dev_info(DEV, "Method to ensure write ordering: %s\n", write_ordering_str[mdev->write_ordering]);
@@ -2190,9 +2195,14 @@ int drbd_rs_should_slow_down(struct drbd_conf *mdev, sector_t sector)
 	struct lc_element *tmp;
 	int curr_events;
 	int throttle = 0;
+	unsigned int c_min_rate;
+
+	rcu_read_lock();
+	c_min_rate = rcu_dereference(mdev->ldev->disk_conf)->c_min_rate;
+	rcu_read_unlock();
 
 	/* feature disabled? */
-	if (mdev->ldev->dc.c_min_rate == 0)
+	if (c_min_rate == 0)
 		return 0;
 
 	spin_lock_irq(&mdev->al_lock);
@@ -2232,7 +2242,7 @@ int drbd_rs_should_slow_down(struct drbd_conf *mdev, sector_t sector)
 		db = mdev->rs_mark_left[i] - rs_left;
 		dbdt = Bit2KB(db/dt);
 
-		if (dbdt > mdev->ldev->dc.c_min_rate)
+		if (dbdt > c_min_rate)
 			throttle = 1;
 	}
 	return throttle;
@@ -3147,6 +3157,7 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	struct crypto_hash *verify_tfm = NULL;
 	struct crypto_hash *csums_tfm = NULL;
 	struct net_conf *old_net_conf, *new_net_conf = NULL;
+	struct disk_conf *old_disk_conf, *new_disk_conf = NULL;
 	const int apv = tconn->agreed_pro_version;
 	int *rs_plan_s = NULL;
 	int fifo_size = 0;
@@ -3189,24 +3200,34 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 	if (err)
 		return err;
 
-	if (get_ldev(mdev)) {
-		mdev->ldev->dc.resync_rate = be32_to_cpu(p->rate);
-		put_ldev(mdev);
+	new_disk_conf = kzalloc(sizeof(struct disk_conf), GFP_KERNEL);
+	if (!new_disk_conf) {
+		dev_err(DEV, "Allocation of new disk_conf failed\n");
+		return -ENOMEM;
 	}
 
+	mutex_lock(&mdev->tconn->conf_update);
+	old_net_conf = mdev->tconn->net_conf;
+	old_disk_conf = mdev->ldev->disk_conf;
+	*new_disk_conf = *old_disk_conf;
+
+	new_disk_conf->resync_rate = be32_to_cpu(p->rate);
+
 	if (apv >= 88) {
 		if (apv == 88) {
 			if (data_size > SHARED_SECRET_MAX) {
 				dev_err(DEV, "verify-alg too long, "
 				    "peer wants %u, accepting only %u byte\n",
 						data_size, SHARED_SECRET_MAX);
+				mutex_unlock(&mdev->tconn->conf_update);
 				return -EIO;
 			}
 
 			err = drbd_recv_all(mdev->tconn, p->verify_alg, data_size);
-			if (err)
+			if (err) {
+				mutex_unlock(&mdev->tconn->conf_update);
 				return err;
-
+			}
 			/* we expect NUL terminated string */
 			/* but just in case someone tries to be evil */
 			D_ASSERT(p->verify_alg[data_size-1] == 0);
@@ -3221,9 +3242,6 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 			p->csums_alg[SHARED_SECRET_MAX-1] = 0;
 		}
 
-		mutex_lock(&mdev->tconn->conf_update);
-		old_net_conf = mdev->tconn->net_conf;
-
 		if (strcmp(old_net_conf->verify_alg, p->verify_alg)) {
 			if (mdev->state.conn == C_WF_REPORT_PARAMS) {
 				dev_err(DEV, "Different verify-alg settings. me=\"%s\" peer=\"%s\"\n",
@@ -3252,14 +3270,13 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 			}
 		}
 
-		if (apv > 94 && get_ldev(mdev)) {
-			mdev->ldev->dc.resync_rate = be32_to_cpu(p->rate);
-			mdev->ldev->dc.c_plan_ahead = be32_to_cpu(p->c_plan_ahead);
-			mdev->ldev->dc.c_delay_target = be32_to_cpu(p->c_delay_target);
-			mdev->ldev->dc.c_fill_target = be32_to_cpu(p->c_fill_target);
-			mdev->ldev->dc.c_max_rate = be32_to_cpu(p->c_max_rate);
+		if (apv > 94) {
+			new_disk_conf->c_plan_ahead = be32_to_cpu(p->c_plan_ahead);
+			new_disk_conf->c_delay_target = be32_to_cpu(p->c_delay_target);
+			new_disk_conf->c_fill_target = be32_to_cpu(p->c_fill_target);
+			new_disk_conf->c_max_rate = be32_to_cpu(p->c_max_rate);
 
-			fifo_size = (mdev->ldev->dc.c_plan_ahead * 10 * SLEEP_TIME) / HZ;
+			fifo_size = (new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
 			if (fifo_size != mdev->rs_plan_s.size && fifo_size > 0) {
 				rs_plan_s   = kzalloc(sizeof(int) * fifo_size, GFP_KERNEL);
 				if (!rs_plan_s) {
@@ -3268,7 +3285,6 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 					goto disconnect;
 				}
 			}
-			put_ldev(mdev);
 		}
 
 		if (verify_tfm || csums_tfm) {
@@ -3296,21 +3312,24 @@ static int receive_SyncParam(struct drbd_tconn *tconn, struct packet_info *pi)
 			}
 			rcu_assign_pointer(tconn->net_conf, new_net_conf);
 		}
-		mutex_unlock(&mdev->tconn->conf_update);
-		if (new_net_conf) {
-			synchronize_rcu();
-			kfree(old_net_conf);
-		}
+	}
 
-		spin_lock(&mdev->peer_seq_lock);
-		if (fifo_size != mdev->rs_plan_s.size) {
-			kfree(mdev->rs_plan_s.values);
-			mdev->rs_plan_s.values = rs_plan_s;
-			mdev->rs_plan_s.size   = fifo_size;
-			mdev->rs_planed = 0;
-		}
-		spin_unlock(&mdev->peer_seq_lock);
+	rcu_assign_pointer(mdev->ldev->disk_conf, new_disk_conf);
+	spin_lock(&mdev->peer_seq_lock);
+	if (rs_plan_s) {
+		kfree(mdev->rs_plan_s.values);
+		mdev->rs_plan_s.values = rs_plan_s;
+		mdev->rs_plan_s.size   = fifo_size;
+		mdev->rs_planed = 0;
 	}
+	spin_unlock(&mdev->peer_seq_lock);
+
+	mutex_unlock(&mdev->tconn->conf_update);
+	synchronize_rcu();
+	if (new_net_conf)
+		kfree(old_net_conf);
+	kfree(old_disk_conf);
+
 	return 0;
 
 disconnect:
@@ -3358,37 +3377,56 @@ static int receive_sizes(struct drbd_tconn *tconn, struct packet_info *pi)
 	mdev->p_size = p_size;
 
 	if (get_ldev(mdev)) {
+		rcu_read_lock();
+		my_usize = rcu_dereference(mdev->ldev->disk_conf)->disk_size;
+		rcu_read_unlock();
+
 		warn_if_differ_considerably(mdev, "lower level device sizes",
 			   p_size, drbd_get_max_capacity(mdev->ldev));
 		warn_if_differ_considerably(mdev, "user requested size",
-					    p_usize, mdev->ldev->dc.disk_size);
+					    p_usize, my_usize);
 
 		/* if this is the first connect, or an otherwise expected
 		 * param exchange, choose the minimum */
 		if (mdev->state.conn == C_WF_REPORT_PARAMS)
-			p_usize = min_not_zero((sector_t)mdev->ldev->dc.disk_size,
-					     p_usize);
-
-		my_usize = mdev->ldev->dc.disk_size;
-
-		if (mdev->ldev->dc.disk_size != p_usize) {
-			mdev->ldev->dc.disk_size = p_usize;
-			dev_info(DEV, "Peer sets u_size to %lu sectors\n",
-			     (unsigned long)mdev->ldev->dc.disk_size);
-		}
+			p_usize = min_not_zero(my_usize, p_usize);
 
 		/* Never shrink a device with usable data during connect.
 		   But allow online shrinking if we are connected. */
 		if (drbd_new_dev_size(mdev, mdev->ldev, p_usize, 0) <
-		   drbd_get_capacity(mdev->this_bdev) &&
-		   mdev->state.disk >= D_OUTDATED &&
-		   mdev->state.conn < C_CONNECTED) {
+		    drbd_get_capacity(mdev->this_bdev) &&
+		    mdev->state.disk >= D_OUTDATED &&
+		    mdev->state.conn < C_CONNECTED) {
 			dev_err(DEV, "The peer's disk size is too small!\n");
 			conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
-			mdev->ldev->dc.disk_size = my_usize;
 			put_ldev(mdev);
 			return -EIO;
 		}
+
+		if (my_usize != p_usize) {
+			struct disk_conf *old_disk_conf, *new_disk_conf = NULL;
+
+			new_disk_conf = kzalloc(sizeof(struct disk_conf), GFP_KERNEL);
+			if (!new_disk_conf) {
+				dev_err(DEV, "Allocation of new disk_conf failed\n");
+				put_ldev(mdev);
+				return -ENOMEM;
+			}
+
+			mutex_lock(&mdev->tconn->conf_update);
+			old_disk_conf = mdev->ldev->disk_conf;
+			*new_disk_conf = *old_disk_conf;
+			new_disk_conf->disk_size = p_usize;
+
+			rcu_assign_pointer(mdev->ldev->disk_conf, new_disk_conf);
+			mutex_unlock(&mdev->tconn->conf_update);
+			synchronize_rcu();
+			kfree(old_disk_conf);
+
+			dev_info(DEV, "Peer sets u_size to %lu sectors\n",
+				 (unsigned long)my_usize);
+		}
+
 		put_ldev(mdev);
 	}
 
@@ -4268,7 +4306,9 @@ static int drbd_disconnected(int vnr, void *p, void *data)
 
 	fp = FP_DONT_CARE;
 	if (get_ldev(mdev)) {
-		fp = mdev->ldev->dc.fencing;
+		rcu_read_lock();
+		fp = rcu_dereference(mdev->ldev->disk_conf)->fencing;
+		rcu_read_unlock();
 		put_ldev(mdev);
 	}
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index befaf07..3f65365 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -465,13 +465,13 @@ is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
 	enum drbd_state_rv rv = SS_SUCCESS;
 	struct net_conf *nc;
 
+	rcu_read_lock();
 	fp = FP_DONT_CARE;
 	if (get_ldev(mdev)) {
-		fp = mdev->ldev->dc.fencing;
+		fp = rcu_dereference(mdev->ldev->disk_conf)->fencing;
 		put_ldev(mdev);
 	}
 
-	rcu_read_lock();
 	nc = rcu_dereference(mdev->tconn->net_conf);
 	if (nc) {
 		if (!nc->two_primaries && ns.role == R_PRIMARY) {
@@ -656,7 +656,9 @@ static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state
 
 	fp = FP_DONT_CARE;
 	if (get_ldev(mdev)) {
-		fp = mdev->ldev->dc.fencing;
+		rcu_read_lock();
+		fp = rcu_dereference(mdev->ldev->disk_conf)->fencing;
+		rcu_read_unlock();
 		put_ldev(mdev);
 	}
 
@@ -1114,7 +1116,9 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 
 	fp = FP_DONT_CARE;
 	if (get_ldev(mdev)) {
-		fp = mdev->ldev->dc.fencing;
+		rcu_read_lock();
+		fp = rcu_dereference(mdev->ldev->disk_conf)->fencing;
+		rcu_read_unlock();
 		put_ldev(mdev);
 	}
 
@@ -1269,7 +1273,9 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 		/* corresponding get_ldev was in __drbd_set_state, to serialize
 		 * our cleanup here with the transition to D_DISKLESS,
 		 * so it is safe to dreference ldev here. */
-		eh = mdev->ldev->dc.on_io_error;
+		rcu_read_lock();
+		eh = rcu_dereference(mdev->ldev->disk_conf)->on_io_error;
+		rcu_read_unlock();
 		was_io_error = test_and_clear_bit(WAS_IO_ERROR, &mdev->flags);
 
 		/* current state still has to be D_FAILED,
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index f8fdf75..840e787 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -436,6 +436,7 @@ static void fifo_add_val(struct fifo_buffer *fb, int value)
 
 static int drbd_rs_controller(struct drbd_conf *mdev)
 {
+	struct disk_conf *dc;
 	unsigned int sect_in;  /* Number of sectors that came in since the last turn */
 	unsigned int want;     /* The number of sectors we want in the proxy */
 	int req_sect; /* Number of sectors to request in this turn */
@@ -449,14 +450,16 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 	mdev->rs_in_flight -= sect_in;
 
 	spin_lock(&mdev->peer_seq_lock); /* get an atomic view on mdev->rs_plan_s */
+	rcu_read_lock();
+	dc = rcu_dereference(mdev->ldev->disk_conf);
 
-	steps = mdev->rs_plan_s.size; /* (mdev->ldev->dc.c_plan_ahead * 10 * SLEEP_TIME) / HZ; */
+	steps = mdev->rs_plan_s.size; /* (dc->c_plan_ahead * 10 * SLEEP_TIME) / HZ; */
 
 	if (mdev->rs_in_flight + sect_in == 0) { /* At start of resync */
-		want = ((mdev->ldev->dc.resync_rate * 2 * SLEEP_TIME) / HZ) * steps;
+		want = ((dc->resync_rate * 2 * SLEEP_TIME) / HZ) * steps;
 	} else { /* normal path */
-		want = mdev->ldev->dc.c_fill_target ? mdev->ldev->dc.c_fill_target :
-			sect_in * mdev->ldev->dc.c_delay_target * HZ / (SLEEP_TIME * 10);
+		want = dc->c_fill_target ? dc->c_fill_target :
+			sect_in * dc->c_delay_target * HZ / (SLEEP_TIME * 10);
 	}
 
 	correction = want - mdev->rs_in_flight - mdev->rs_planed;
@@ -468,14 +471,13 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 
 	/* What we do in this step */
 	curr_corr = fifo_push(&mdev->rs_plan_s, 0);
-	spin_unlock(&mdev->peer_seq_lock);
 	mdev->rs_planed -= curr_corr;
 
 	req_sect = sect_in + curr_corr;
 	if (req_sect < 0)
 		req_sect = 0;
 
-	max_sect = (mdev->ldev->dc.c_max_rate * 2 * SLEEP_TIME) / HZ;
+	max_sect = (dc->c_max_rate * 2 * SLEEP_TIME) / HZ;
 	if (req_sect > max_sect)
 		req_sect = max_sect;
 
@@ -484,6 +486,8 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 		 sect_in, mdev->rs_in_flight, want, correction,
 		 steps, cps, mdev->rs_planed, curr_corr, req_sect);
 	*/
+	rcu_read_unlock();
+	spin_unlock(&mdev->peer_seq_lock);
 
 	return req_sect;
 }
@@ -491,11 +495,13 @@ static int drbd_rs_controller(struct drbd_conf *mdev)
 static int drbd_rs_number_requests(struct drbd_conf *mdev)
 {
 	int number;
-	if (mdev->rs_plan_s.size) { /* mdev->ldev->dc.c_plan_ahead */
+	if (mdev->rs_plan_s.size) { /* rcu_dereference(mdev->ldev->disk_conf)->c_plan_ahead */
 		number = drbd_rs_controller(mdev) >> (BM_BLOCK_SHIFT - 9);
 		mdev->c_sync_rate = number * HZ * (BM_BLOCK_SIZE / 1024) / SLEEP_TIME;
 	} else {
-		mdev->c_sync_rate = mdev->ldev->dc.resync_rate;
+		rcu_read_lock();
+		mdev->c_sync_rate = rcu_dereference(mdev->ldev->disk_conf)->resync_rate;
+		rcu_read_unlock();
 		number = SLEEP_TIME * mdev->c_sync_rate  / ((BM_BLOCK_SIZE / 1024) * HZ);
 	}
 
@@ -1320,13 +1326,17 @@ int w_restart_disk_io(struct drbd_work *w, int cancel)
 static int _drbd_may_sync_now(struct drbd_conf *mdev)
 {
 	struct drbd_conf *odev = mdev;
+	int ra;
 
 	while (1) {
 		if (!odev->ldev)
 			return 1;
-		if (odev->ldev->dc.resync_after == -1)
+		rcu_read_lock();
+		ra = rcu_dereference(odev->ldev->disk_conf)->resync_after;
+		rcu_read_unlock();
+		if (ra == -1)
 			return 1;
-		odev = minor_to_mdev(odev->ldev->dc.resync_after);
+		odev = minor_to_mdev(ra);
 		if (!expect(odev))
 			return 1;
 		if ((odev->state.conn >= C_SYNC_SOURCE &&
@@ -1405,6 +1415,7 @@ void suspend_other_sg(struct drbd_conf *mdev)
 enum drbd_ret_code drbd_sync_after_valid(struct drbd_conf *mdev, int o_minor)
 {
 	struct drbd_conf *odev;
+	int ra;
 
 	if (o_minor == -1)
 		return NO_ERROR;
@@ -1417,12 +1428,15 @@ enum drbd_ret_code drbd_sync_after_valid(struct drbd_conf *mdev, int o_minor)
 		if (odev == mdev)
 			return ERR_SYNC_AFTER_CYCLE;
 
+		rcu_read_lock();
+		ra = rcu_dereference(odev->ldev->disk_conf)->resync_after;
+		rcu_read_unlock();
 		/* dependency chain ends here, no cycles. */
-		if (odev->ldev->dc.resync_after == -1)
+		if (ra == -1)
 			return NO_ERROR;
 
 		/* follow the dependency chain */
-		odev = minor_to_mdev(odev->ldev->dc.resync_after);
+		odev = minor_to_mdev(ra);
 	}
 }
 
-- 
1.7.4.1

