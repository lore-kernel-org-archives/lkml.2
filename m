Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303Ab1JEJlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:41:31 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56203 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933732Ab1JEJiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/16] drbd: on reconfiguration requests, mind the SET_DEFAULTS flag
Date: Wed,  5 Oct 2011 11:37:50 +0200
Message-Id: <1317807484-24628-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

The DRBD_GENL_F_SET_DEFAULTS flag was ignored
for drbd_adm_disk_opts() and drbd_adm_net_opts().

Factor out drbd_set_*_defaults() helper functions,
and call them appropriately.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    1 +
 drivers/block/drbd/drbd_main.c |    5 +-
 drivers/block/drbd/drbd_nl.c   |  150 ++++++++++++++++++++++++----------------
 3 files changed, 91 insertions(+), 65 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 28e7ecc..e90bc9f 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1389,6 +1389,7 @@ extern int is_valid_ar_handle(struct drbd_request *, sector_t);
 
 
 /* drbd_nl.c */
+extern void drbd_set_res_opts_default(struct res_opts *r);
 extern int drbd_msg_put_info(const char *info);
 extern void drbd_suspend_io(struct drbd_conf *mdev);
 extern void drbd_resume_io(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 114ae3a..c5134c8 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2460,10 +2460,7 @@ struct drbd_tconn *conn_create(const char *name)
 	drbd_thread_init(tconn, &tconn->worker, drbd_worker, "worker");
 	drbd_thread_init(tconn, &tconn->asender, drbd_asender, "asender");
 
-	tconn->res_opts = (struct res_opts) {
-		{}, 0, /* cpu_mask */
-		DRBD_ON_NO_DATA_DEF, /* on_no_data */
-	};
+	drbd_set_res_opts_default(&tconn->res_opts);
 
 	down_write(&drbd_cfg_rwsem);
 	kref_init(&tconn->kref);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index b9e8456..7bfcb96 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1099,6 +1099,84 @@ static void drbd_suspend_al(struct drbd_conf *mdev)
 		dev_info(DEV, "Suspended AL updates\n");
 }
 
+
+static bool should_set_defaults(struct genl_info *info)
+{
+	unsigned flags = ((struct drbd_genlmsghdr*)info->userhdr)->flags;
+	return 0 != (flags & DRBD_GENL_F_SET_DEFAULTS);
+}
+
+/* Maybe we should we generate these functions
+ * from the drbd_genl.h magic as well?
+ * That way we would not "accidentally forget" to add defaults here. */
+
+#define RESET_ARRAY_FIELD(field) do { \
+	memset(field, 0, sizeof(field)); \
+	field ## _len = 0; \
+} while (0)
+void drbd_set_res_opts_default(struct res_opts *r)
+{
+	RESET_ARRAY_FIELD(r->cpu_mask);
+	r->on_no_data  = DRBD_ON_NO_DATA_DEF;
+}
+
+static void drbd_set_net_conf_defaults(struct net_conf *nc)
+{
+	/* Do NOT (re)set those fields marked as GENLA_F_INVARIANT
+	 * in drbd_genl.h, they can only be change with disconnect/reconnect */
+	RESET_ARRAY_FIELD(nc->shared_secret);
+
+	RESET_ARRAY_FIELD(nc->cram_hmac_alg);
+	RESET_ARRAY_FIELD(nc->integrity_alg);
+	RESET_ARRAY_FIELD(nc->verify_alg);
+	RESET_ARRAY_FIELD(nc->csums_alg);
+#undef RESET_ARRAY_FIELD
+
+	nc->wire_protocol = DRBD_PROTOCOL_DEF;
+	nc->try_connect_int = DRBD_CONNECT_INT_DEF;
+	nc->timeout = DRBD_TIMEOUT_DEF;
+	nc->ping_int = DRBD_PING_INT_DEF;
+	nc->ping_timeo = DRBD_PING_TIMEO_DEF;
+	nc->sndbuf_size = DRBD_SNDBUF_SIZE_DEF;
+	nc->rcvbuf_size = DRBD_RCVBUF_SIZE_DEF;
+	nc->ko_count = DRBD_KO_COUNT_DEF;
+	nc->max_buffers = DRBD_MAX_BUFFERS_DEF;
+	nc->max_epoch_size = DRBD_MAX_EPOCH_SIZE_DEF;
+	nc->unplug_watermark = DRBD_UNPLUG_WATERMARK_DEF;
+	nc->after_sb_0p = DRBD_AFTER_SB_0P_DEF;
+	nc->after_sb_1p = DRBD_AFTER_SB_1P_DEF;
+	nc->after_sb_2p = DRBD_AFTER_SB_2P_DEF;
+	nc->rr_conflict = DRBD_RR_CONFLICT_DEF;
+	nc->on_congestion = DRBD_ON_CONGESTION_DEF;
+	nc->cong_fill = DRBD_CONG_FILL_DEF;
+	nc->cong_extents = DRBD_CONG_EXTENTS_DEF;
+	nc->two_primaries = 0;
+	nc->no_cork = 0;
+	nc->always_asbp = 0;
+	nc->use_rle = 0;
+}
+
+static void drbd_set_disk_conf_defaults(struct disk_conf *dc)
+{
+	/* Do NOT (re)set those fields marked as GENLA_F_INVARIANT
+	 * in drbd_genl.h, they can only be change with detach/reattach */
+	dc->on_io_error = DRBD_ON_IO_ERROR_DEF;
+	dc->fencing = DRBD_FENCING_DEF;
+	dc->resync_rate = DRBD_RATE_DEF;
+	dc->resync_after = DRBD_AFTER_DEF;
+	dc->al_extents = DRBD_AL_EXTENTS_DEF;
+	dc->c_plan_ahead = DRBD_C_PLAN_AHEAD_DEF;
+	dc->c_delay_target = DRBD_C_DELAY_TARGET_DEF;
+	dc->c_fill_target = DRBD_C_FILL_TARGET_DEF;
+	dc->c_max_rate = DRBD_C_MAX_RATE_DEF;
+	dc->c_min_rate = DRBD_C_MIN_RATE_DEF;
+	dc->no_disk_barrier = 0;
+	dc->no_disk_flush = 0;
+	dc->no_disk_drain = 0;
+	dc->no_md_flush = 0;
+}
+
+
 int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
@@ -1149,6 +1227,9 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	memcpy(ndc, &mdev->ldev->dc, sizeof(*ndc));
+	if (should_set_defaults(info))
+		drbd_set_disk_conf_defaults(ndc);
+
 	err = disk_conf_from_attrs(ndc, info);
 	if (err) {
 		retcode = ERR_MANDATORY_TAG;
@@ -1264,27 +1345,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	nbc->dc = (struct disk_conf) {
-		{}, 0, /* backing_dev */
-		{}, 0, /* meta_dev */
-		0, /* meta_dev_idx */
-		DRBD_DISK_SIZE_SECT_DEF, /* disk_size */
-		DRBD_MAX_BIO_BVECS_DEF, /* max_bio_bvecs */
-		DRBD_ON_IO_ERROR_DEF, /* on_io_error */
-		DRBD_FENCING_DEF, /* fencing */
-		DRBD_RATE_DEF, /* resync_rate */
-		DRBD_AFTER_DEF, /* resync_after */
-		DRBD_AL_EXTENTS_DEF, /* al_extents */
-		DRBD_C_PLAN_AHEAD_DEF, /* c_plan_ahead */
-		DRBD_C_DELAY_TARGET_DEF, /* c_delay_target */
-		DRBD_C_FILL_TARGET_DEF, /* c_fill_target */
-		DRBD_C_MAX_RATE_DEF, /* c_max_rate */
-		DRBD_C_MIN_RATE_DEF, /* c_min_rate */
-		0, /* no_disk_barrier */
-		0, /* no_disk_flush */
-		0, /* no_disk_drain */
-		0, /* no_md_flush */
-	};
+	drbd_set_disk_conf_defaults(&nbc->dc);
 
 	err = disk_conf_from_attrs(&nbc->dc, info);
 	if (err) {
@@ -1890,6 +1951,8 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	*new_conf = *old_conf;
+	if (should_set_defaults(info))
+		drbd_set_net_conf_defaults(new_conf);
 
 	err = net_conf_from_attrs(new_conf, info);
 	if (err) {
@@ -1994,45 +2057,13 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* allocation not in the IO path, cqueue thread context */
-	new_conf = kmalloc(sizeof(struct net_conf), GFP_KERNEL);
+	new_conf = kzalloc(sizeof(*new_conf), GFP_KERNEL);
 	if (!new_conf) {
 		retcode = ERR_NOMEM;
 		goto fail;
 	}
 
-	*new_conf = (struct net_conf) {
-		{}, 0, /* my_addr */
-		{}, 0, /* peer_addr */
-		{}, 0, /* shared_secret */
-		{}, 0, /* cram_hmac_alg */
-		{}, 0, /* integrity_alg */
-		{}, 0, /* verify_alg */
-		{}, 0, /* csums_alg */
-		DRBD_PROTOCOL_DEF, /* wire_protocol */
-		DRBD_CONNECT_INT_DEF, /* try_connect_int */
-		DRBD_TIMEOUT_DEF, /* timeout */
-		DRBD_PING_INT_DEF, /* ping_int */
-		DRBD_PING_TIMEO_DEF, /* ping_timeo */
-		DRBD_SNDBUF_SIZE_DEF, /* sndbuf_size */
-		DRBD_RCVBUF_SIZE_DEF, /* rcvbuf_size */
-		DRBD_KO_COUNT_DEF, /* ko_count */
-		DRBD_MAX_BUFFERS_DEF, /* max_buffers */
-		DRBD_MAX_EPOCH_SIZE_DEF, /* max_epoch_size */
-		DRBD_UNPLUG_WATERMARK_DEF, /* unplug_watermark */
-		DRBD_AFTER_SB_0P_DEF, /* after_sb_0p */
-		DRBD_AFTER_SB_1P_DEF, /* after_sb_1p */
-		DRBD_AFTER_SB_2P_DEF, /* after_sb_2p */
-		DRBD_RR_CONFLICT_DEF, /* rr_conflict */
-		DRBD_ON_CONGESTION_DEF, /* on_congestion */
-		DRBD_CONG_FILL_DEF, /* cong_fill */
-		DRBD_CONG_EXTENTS_DEF, /* cong_extents */
-		0, /* two_primaries */
-		0, /* want_lose */
-		0, /* no_cork */
-		0, /* always_asbp */
-		0, /* dry_run */
-		0, /* use_rle */
-	};
+	drbd_set_net_conf_defaults(new_conf);
 
 	err = net_conf_from_attrs(new_conf, info);
 	if (err) {
@@ -2320,12 +2351,9 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	if (((struct drbd_genlmsghdr*)info->userhdr)->flags
-			& DRBD_GENL_F_SET_DEFAULTS) {
-		memset(&sc, 0, sizeof(struct res_opts));
-		sc.on_no_data  = DRBD_ON_NO_DATA_DEF;
-	} else
-		sc = tconn->res_opts;
+	sc = tconn->res_opts;
+	if (should_set_defaults(info))
+		drbd_set_res_opts_default(&sc);
 
 	err = res_opts_from_attrs(&sc, info);
 	if (err) {
-- 
1.7.4.1

