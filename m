Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269Ab1JEJit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:38:49 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56222 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934225Ab1JEJiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 16/16] drbd: Generate the drbd_set_*_defaults() functions from drbd_genl.h
Date: Wed,  5 Oct 2011 11:38:04 +0200
Message-Id: <1317807484-24628-17-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h     |    2 +-
 drivers/block/drbd/drbd_main.c    |    2 +-
 drivers/block/drbd/drbd_nl.c      |   86 ++++--------------------------------
 include/linux/drbd_genl.h         |   87 ++++++++++++++++++-------------------
 include/linux/genl_magic_func.h   |   30 ++++++++++++-
 include/linux/genl_magic_struct.h |    8 +++
 6 files changed, 91 insertions(+), 124 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 44f7726..8655fcb 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1390,7 +1390,7 @@ extern int is_valid_ar_handle(struct drbd_request *, sector_t);
 
 
 /* drbd_nl.c */
-extern void drbd_set_res_opts_default(struct res_opts *r);
+extern void drbd_set_res_opts_defaults(struct res_opts *r);
 extern int drbd_msg_put_info(const char *info);
 extern void drbd_suspend_io(struct drbd_conf *mdev);
 extern void drbd_resume_io(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index e0342d0..cd08136 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2488,7 +2488,7 @@ struct drbd_tconn *conn_create(const char *name)
 	drbd_thread_init(tconn, &tconn->worker, drbd_worker, "worker");
 	drbd_thread_init(tconn, &tconn->asender, drbd_asender, "asender");
 
-	drbd_set_res_opts_default(&tconn->res_opts);
+	drbd_set_res_opts_defaults(&tconn->res_opts);
 
 	down_write(&drbd_cfg_rwsem);
 	kref_init(&tconn->kref);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 414503a..d596900 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1112,77 +1112,6 @@ static bool should_set_defaults(struct genl_info *info)
 	return 0 != (flags & DRBD_GENL_F_SET_DEFAULTS);
 }
 
-/* Maybe we should we generate these functions
- * from the drbd_genl.h magic as well?
- * That way we would not "accidentally forget" to add defaults here. */
-
-#define RESET_ARRAY_FIELD(field) do { \
-	memset(field, 0, sizeof(field)); \
-	field ## _len = 0; \
-} while (0)
-void drbd_set_res_opts_default(struct res_opts *r)
-{
-	RESET_ARRAY_FIELD(r->cpu_mask);
-	r->on_no_data  = DRBD_ON_NO_DATA_DEF;
-}
-
-static void drbd_set_net_conf_defaults(struct net_conf *nc)
-{
-	/* Do NOT (re)set those fields marked as GENLA_F_INVARIANT
-	 * in drbd_genl.h, they can only be change with disconnect/reconnect */
-	RESET_ARRAY_FIELD(nc->shared_secret);
-
-	RESET_ARRAY_FIELD(nc->cram_hmac_alg);
-	RESET_ARRAY_FIELD(nc->integrity_alg);
-	RESET_ARRAY_FIELD(nc->verify_alg);
-	RESET_ARRAY_FIELD(nc->csums_alg);
-#undef RESET_ARRAY_FIELD
-
-	nc->wire_protocol = DRBD_PROTOCOL_DEF;
-	nc->try_connect_int = DRBD_CONNECT_INT_DEF;
-	nc->timeout = DRBD_TIMEOUT_DEF;
-	nc->ping_int = DRBD_PING_INT_DEF;
-	nc->ping_timeo = DRBD_PING_TIMEO_DEF;
-	nc->sndbuf_size = DRBD_SNDBUF_SIZE_DEF;
-	nc->rcvbuf_size = DRBD_RCVBUF_SIZE_DEF;
-	nc->ko_count = DRBD_KO_COUNT_DEF;
-	nc->max_buffers = DRBD_MAX_BUFFERS_DEF;
-	nc->max_epoch_size = DRBD_MAX_EPOCH_SIZE_DEF;
-	nc->unplug_watermark = DRBD_UNPLUG_WATERMARK_DEF;
-	nc->after_sb_0p = DRBD_AFTER_SB_0P_DEF;
-	nc->after_sb_1p = DRBD_AFTER_SB_1P_DEF;
-	nc->after_sb_2p = DRBD_AFTER_SB_2P_DEF;
-	nc->rr_conflict = DRBD_RR_CONFLICT_DEF;
-	nc->on_congestion = DRBD_ON_CONGESTION_DEF;
-	nc->cong_fill = DRBD_CONG_FILL_DEF;
-	nc->cong_extents = DRBD_CONG_EXTENTS_DEF;
-	nc->two_primaries = 0;
-	nc->no_cork = 0;
-	nc->always_asbp = 0;
-	nc->use_rle = 0;
-}
-
-static void drbd_set_disk_conf_defaults(struct disk_conf *dc)
-{
-	/* Do NOT (re)set those fields marked as GENLA_F_INVARIANT
-	 * in drbd_genl.h, they can only be change with detach/reattach */
-	dc->on_io_error = DRBD_ON_IO_ERROR_DEF;
-	dc->fencing = DRBD_FENCING_DEF;
-	dc->resync_rate = DRBD_RATE_DEF;
-	dc->resync_after = DRBD_AFTER_DEF;
-	dc->al_extents = DRBD_AL_EXTENTS_DEF;
-	dc->c_plan_ahead = DRBD_C_PLAN_AHEAD_DEF;
-	dc->c_delay_target = DRBD_C_DELAY_TARGET_DEF;
-	dc->c_fill_target = DRBD_C_FILL_TARGET_DEF;
-	dc->c_max_rate = DRBD_C_MAX_RATE_DEF;
-	dc->c_min_rate = DRBD_C_MIN_RATE_DEF;
-	dc->no_disk_barrier = 0;
-	dc->no_disk_flush = 0;
-	dc->no_disk_drain = 0;
-	dc->no_md_flush = 0;
-}
-
-
 int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
@@ -1234,7 +1163,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 
 	memcpy(new_disk_conf, &mdev->ldev->dc, sizeof(*new_disk_conf));
 	if (should_set_defaults(info))
-		drbd_set_disk_conf_defaults(new_disk_conf);
+		set_disk_conf_defaults(new_disk_conf);
 
 	err = disk_conf_from_attrs(new_disk_conf, info);
 	if (err) {
@@ -1351,7 +1280,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	drbd_set_disk_conf_defaults(&nbc->dc);
+	set_disk_conf_defaults(&nbc->dc);
 
 	err = disk_conf_from_attrs(&nbc->dc, info);
 	if (err) {
@@ -1956,7 +1885,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 	*new_conf = *old_conf;
 	if (should_set_defaults(info))
-		drbd_set_net_conf_defaults(new_conf);
+		set_net_conf_defaults(new_conf);
 
 	err = net_conf_from_attrs(new_conf, info);
 	if (err) {
@@ -2074,7 +2003,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	drbd_set_net_conf_defaults(new_conf);
+	set_net_conf_defaults(new_conf);
 
 	err = net_conf_from_attrs(new_conf, info);
 	if (err) {
@@ -2346,6 +2275,11 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+void drbd_set_res_opts_defaults(struct res_opts *r)
+{
+	return set_res_opts_defaults(r);
+}
+
 int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
@@ -2370,7 +2304,7 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 
 	res_opts = tconn->res_opts;
 	if (should_set_defaults(info))
-		drbd_set_res_opts_default(&res_opts);
+		set_res_opts_defaults(&res_opts);
 
 	err = res_opts_from_attrs(&res_opts, info);
 	if (err) {
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 938e856..8cad681 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -112,63 +112,62 @@ GENL_struct(DRBD_NLA_DISK_CONF, 3, disk_conf,
 	 * but it won't propagate through the stack */
 	__u32_field(5, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	max_bio_bvecs)
 
-	__u32_field(6, GENLA_F_MANDATORY,	on_io_error)
-	__u32_field(7, GENLA_F_MANDATORY,	fencing)
-
-	__u32_field(8,	GENLA_F_MANDATORY,	resync_rate)
-	__u32_field(9,	GENLA_F_MANDATORY,	resync_after)
-	__u32_field(10,	GENLA_F_MANDATORY,	al_extents)
-	__u32_field(11,	GENLA_F_MANDATORY,	c_plan_ahead)
-	__u32_field(12,	GENLA_F_MANDATORY,	c_delay_target)
-	__u32_field(13,	GENLA_F_MANDATORY,	c_fill_target)
-	__u32_field(14,	GENLA_F_MANDATORY,	c_max_rate)
-	__u32_field(15,	GENLA_F_MANDATORY,	c_min_rate)
-
-	__flg_field(16, GENLA_F_MANDATORY,	no_disk_barrier)
-	__flg_field(17, GENLA_F_MANDATORY,	no_disk_flush)
-	__flg_field(18, GENLA_F_MANDATORY,	no_disk_drain)
-	__flg_field(19, GENLA_F_MANDATORY,	no_md_flush)
-
+	__u32_field_def(6, GENLA_F_MANDATORY,	on_io_error, DRBD_ON_IO_ERROR_DEF)
+	__u32_field_def(7, GENLA_F_MANDATORY,	fencing, DRBD_FENCING_DEF)
+
+	__u32_field_def(8,	GENLA_F_MANDATORY,	resync_rate, DRBD_RATE_DEF)
+	__u32_field_def(9,	GENLA_F_MANDATORY,	resync_after, DRBD_AFTER_DEF)
+	__u32_field_def(10,	GENLA_F_MANDATORY,	al_extents, DRBD_AL_EXTENTS_DEF)
+	__u32_field_def(11,	GENLA_F_MANDATORY,	c_plan_ahead, DRBD_C_PLAN_AHEAD_DEF)
+	__u32_field_def(12,	GENLA_F_MANDATORY,	c_delay_target, DRBD_C_DELAY_TARGET_DEF)
+	__u32_field_def(13,	GENLA_F_MANDATORY,	c_fill_target, DRBD_C_FILL_TARGET_DEF)
+	__u32_field_def(14,	GENLA_F_MANDATORY,	c_max_rate, DRBD_C_MAX_RATE_DEF)
+	__u32_field_def(15,	GENLA_F_MANDATORY,	c_min_rate, DRBD_C_MIN_RATE_DEF)
+
+	__flg_field_def(16, GENLA_F_MANDATORY,	no_disk_barrier, 0)
+	__flg_field_def(17, GENLA_F_MANDATORY,	no_disk_flush, 0)
+	__flg_field_def(18, GENLA_F_MANDATORY,	no_disk_drain, 0)
+	__flg_field_def(19, GENLA_F_MANDATORY,	no_md_flush, 0)
 )
 
 GENL_struct(DRBD_NLA_RESOURCE_OPTS, 4, res_opts,
-	__str_field(1,	GENLA_F_MANDATORY,	cpu_mask,       32)
-	__u32_field(2,	GENLA_F_MANDATORY,	on_no_data)
+	__str_field_def(1,	GENLA_F_MANDATORY,	cpu_mask,       32)
+	__u32_field_def(2,	GENLA_F_MANDATORY,	on_no_data, DRBD_ON_NO_DATA_DEF)
 )
 
 GENL_struct(DRBD_NLA_NET_CONF, 5, net_conf,
 	__bin_field(1,	GENLA_F_REQUIRED | GENLA_F_INVARIANT,	my_addr,	128)
 	__bin_field(2,	GENLA_F_REQUIRED | GENLA_F_INVARIANT,	peer_addr,	128)
-	__str_field(3,	GENLA_F_MANDATORY | GENLA_F_SENSITIVE,
+	__str_field_def(3,	GENLA_F_MANDATORY | GENLA_F_SENSITIVE,
 						shared_secret,	SHARED_SECRET_MAX)
-	__str_field(4,	GENLA_F_MANDATORY,	cram_hmac_alg,	SHARED_SECRET_MAX)
-	__str_field(5,	GENLA_F_MANDATORY,	integrity_alg,	SHARED_SECRET_MAX)
-	__str_field(6,	GENLA_F_MANDATORY,	verify_alg,     SHARED_SECRET_MAX)
-	__str_field(7,	GENLA_F_MANDATORY,	csums_alg,	SHARED_SECRET_MAX)
-	__u32_field(8,	GENLA_F_MANDATORY,	wire_protocol)
-	__u32_field(9,	GENLA_F_MANDATORY,	try_connect_int)
-	__u32_field(10,	GENLA_F_MANDATORY,	timeout)
-	__u32_field(11,	GENLA_F_MANDATORY,	ping_int)
-	__u32_field(12,	GENLA_F_MANDATORY,	ping_timeo)
-	__u32_field(13,	GENLA_F_MANDATORY,	sndbuf_size)
-	__u32_field(14,	GENLA_F_MANDATORY,	rcvbuf_size)
-	__u32_field(15,	GENLA_F_MANDATORY,	ko_count)
-	__u32_field(16,	GENLA_F_MANDATORY,	max_buffers)
-	__u32_field(17,	GENLA_F_MANDATORY,	max_epoch_size)
-	__u32_field(18,	GENLA_F_MANDATORY,	unplug_watermark)
-	__u32_field(19,	GENLA_F_MANDATORY,	after_sb_0p)
-	__u32_field(20,	GENLA_F_MANDATORY,	after_sb_1p)
-	__u32_field(21,	GENLA_F_MANDATORY,	after_sb_2p)
-	__u32_field(22,	GENLA_F_MANDATORY,	rr_conflict)
-	__u32_field(23,	GENLA_F_MANDATORY,	on_congestion)
-	__u32_field(24,	GENLA_F_MANDATORY,	cong_fill)
-	__u32_field(25,	GENLA_F_MANDATORY,	cong_extents)
-	__flg_field(26, GENLA_F_MANDATORY,	two_primaries)
+	__str_field_def(4,	GENLA_F_MANDATORY,	cram_hmac_alg,	SHARED_SECRET_MAX)
+	__str_field_def(5,	GENLA_F_MANDATORY,	integrity_alg,	SHARED_SECRET_MAX)
+	__str_field_def(6,	GENLA_F_MANDATORY,	verify_alg,     SHARED_SECRET_MAX)
+	__str_field_def(7,	GENLA_F_MANDATORY,	csums_alg,	SHARED_SECRET_MAX)
+	__u32_field_def(8,	GENLA_F_MANDATORY,	wire_protocol, DRBD_PROTOCOL_DEF)
+	__u32_field_def(9,	GENLA_F_MANDATORY,	try_connect_int, DRBD_CONNECT_INT_DEF)
+	__u32_field_def(10,	GENLA_F_MANDATORY,	timeout, DRBD_TIMEOUT_DEF)
+	__u32_field_def(11,	GENLA_F_MANDATORY,	ping_int, DRBD_PING_INT_DEF)
+	__u32_field_def(12,	GENLA_F_MANDATORY,	ping_timeo, DRBD_PING_TIMEO_DEF)
+	__u32_field_def(13,	GENLA_F_MANDATORY,	sndbuf_size, DRBD_SNDBUF_SIZE_DEF)
+	__u32_field_def(14,	GENLA_F_MANDATORY,	rcvbuf_size, DRBD_RCVBUF_SIZE_DEF)
+	__u32_field_def(15,	GENLA_F_MANDATORY,	ko_count, DRBD_KO_COUNT_DEF)
+	__u32_field_def(16,	GENLA_F_MANDATORY,	max_buffers, DRBD_MAX_BUFFERS_DEF)
+	__u32_field_def(17,	GENLA_F_MANDATORY,	max_epoch_size, DRBD_MAX_EPOCH_SIZE_DEF)
+	__u32_field_def(18,	GENLA_F_MANDATORY,	unplug_watermark, DRBD_UNPLUG_WATERMARK_DEF)
+	__u32_field_def(19,	GENLA_F_MANDATORY,	after_sb_0p, DRBD_AFTER_SB_0P_DEF)
+	__u32_field_def(20,	GENLA_F_MANDATORY,	after_sb_1p, DRBD_AFTER_SB_1P_DEF)
+	__u32_field_def(21,	GENLA_F_MANDATORY,	after_sb_2p, DRBD_AFTER_SB_2P_DEF)
+	__u32_field_def(22,	GENLA_F_MANDATORY,	rr_conflict, DRBD_RR_CONFLICT_DEF)
+	__u32_field_def(23,	GENLA_F_MANDATORY,	on_congestion, DRBD_ON_CONGESTION_DEF)
+	__u32_field_def(24,	GENLA_F_MANDATORY,	cong_fill, DRBD_CONG_FILL_DEF)
+	__u32_field_def(25,	GENLA_F_MANDATORY,	cong_extents, DRBD_CONG_EXTENTS_DEF)
+	__flg_field_def(26, GENLA_F_MANDATORY,	two_primaries, 0)
 	__flg_field(27, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	want_lose)
-	__flg_field(28, GENLA_F_MANDATORY,	no_cork)
-	__flg_field(29, GENLA_F_MANDATORY,	always_asbp)
+	__flg_field_def(28, GENLA_F_MANDATORY,	no_cork, 0)
+	__flg_field_def(29, GENLA_F_MANDATORY,	always_asbp, 0)
 	__flg_field(30, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	dry_run)
-	__flg_field(31,	GENLA_F_MANDATORY,	use_rle)
+	__flg_field_def(31,	GENLA_F_MANDATORY,	use_rle, 0)
 )
 
 GENL_struct(DRBD_NLA_SET_ROLE_PARMS, 6, set_role_parms,
diff --git a/include/linux/genl_magic_func.h b/include/linux/genl_magic_func.h
index c71cb12..ce02500 100644
--- a/include/linux/genl_magic_func.h
+++ b/include/linux/genl_magic_func.h
@@ -190,8 +190,8 @@ static struct nlattr *nested_attr_tb[128];
 
 #undef GENL_struct
 #define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
-/* *_from_attrs functions are static, but potentially unused */		\
-int s_name ## _from_attrs(struct s_name *s, struct genl_info *info)	\
+static int s_name ## _from_attrs(struct s_name *s, struct genl_info *info) __attribute__((unused)); \
+static int s_name ## _from_attrs(struct s_name *s, struct genl_info *info)	\
 {									\
 	const int maxtype = ARRAY_SIZE(s_name ## _nl_policy)-1;		\
 	struct nlattr *tla = info->attrs[tag_number];			\
@@ -421,6 +421,32 @@ static inline int s_name ## _to_unpriv_skb(struct sk_buff *skb,		\
 
 #include GENL_MAGIC_INCLUDE_FILE
 
+
+/* Functions for initializing structs to default values.  */
+
+#undef __field
+#define __field(attr_nr, attr_flag, name, nla_type, type, __get, __put)
+#undef __array
+#define __array(attr_nr, attr_flag, name, nla_type, type, maxlen, __get, __put)
+#undef __u32_field_def
+#define __u32_field_def(attr_nr, attr_flag, name, default)		\
+	x->name = default;
+#undef __flg_field_def
+#define __flg_field_def(attr_nr, attr_flag, name, default)		\
+	x->name = default;
+#undef __str_field_def
+#define __str_field_def(attr_nr, attr_flag, name, maxlen)		\
+	memset(x->name, 0, sizeof(x->name));				\
+	x->name ## _len = 0;
+#undef GENL_struct
+#define GENL_struct(tag_name, tag_number, s_name, s_fields)		\
+static void set_ ## s_name ## _defaults(struct s_name *x) __attribute__((unused)); \
+static void set_ ## s_name ## _defaults(struct s_name *x) {	\
+s_fields								\
+}
+
+#include GENL_MAGIC_INCLUDE_FILE
+
 #endif /* __KERNEL__ */
 
 /* }}}1 */
diff --git a/include/linux/genl_magic_struct.h b/include/linux/genl_magic_struct.h
index 9a605b9..f2c7cc7 100644
--- a/include/linux/genl_magic_struct.h
+++ b/include/linux/genl_magic_struct.h
@@ -107,6 +107,14 @@ enum {
 	__array(attr_nr, attr_flag, name, NLA_BINARY, char, maxlen, \
 			nla_memcpy, NLA_PUT)
 
+/* fields with default values */
+#define __flg_field_def(attr_nr, attr_flag, name, default) \
+	__flg_field(attr_nr, attr_flag, name)
+#define __u32_field_def(attr_nr, attr_flag, name, default) \
+	__u32_field(attr_nr, attr_flag, name)
+#define __str_field_def(attr_nr, attr_flag, name, maxlen) \
+	__str_field(attr_nr, attr_flag, name, maxlen)
+
 #define __nla_put_flag(skb, attrtype, value)		\
 	do {						\
 		if (value)				\
-- 
1.7.4.1

