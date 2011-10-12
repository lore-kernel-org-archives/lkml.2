Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1JLM1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:27:46 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33924 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab1JLM1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:27:42 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/13] drbd: Allow to pass resource options to the new-resource command
Date: Wed, 12 Oct 2011 14:27:32 +0200
Message-Id: <1318422455-17539-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

This is equivalent to how the attach and connect commands work.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    4 +-
 drivers/block/drbd/drbd_main.c |   46 +++++++++++++++++++++++++++++++++--
 drivers/block/drbd/drbd_nl.c   |   51 ++++++++++++---------------------------
 3 files changed, 61 insertions(+), 40 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 6d6d105..ece2e4a 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1379,7 +1379,8 @@ extern int conn_lowest_minor(struct drbd_tconn *tconn);
 enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor, int vnr);
 extern void drbd_minor_destroy(struct kref *kref);
 
-struct drbd_tconn *conn_create(const char *name);
+extern int set_resource_options(struct drbd_tconn *tconn, struct res_opts *res_opts);
+extern struct drbd_tconn *conn_create(const char *name, struct res_opts *res_opts);
 extern void conn_destroy(struct kref *kref);
 struct drbd_tconn *conn_get_by_name(const char *name);
 extern struct drbd_tconn *conn_get_by_addrs(void *my_addr, int my_addr_len,
@@ -1397,7 +1398,6 @@ extern int is_valid_ar_handle(struct drbd_request *, sector_t);
 
 
 /* drbd_nl.c */
-extern void drbd_set_res_opts_defaults(struct res_opts *r);
 extern int drbd_msg_put_info(const char *info);
 extern void drbd_suspend_io(struct drbd_conf *mdev);
 extern void drbd_resume_io(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index bfcd1dc..a67b4ca 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2479,8 +2479,47 @@ void conn_free_crypto(struct drbd_tconn *tconn)
 	tconn->int_dig_vv = NULL;
 }
 
+int set_resource_options(struct drbd_tconn *tconn, struct res_opts *res_opts)
+{
+	cpumask_var_t new_cpu_mask;
+	int err;
+
+	if (!zalloc_cpumask_var(&new_cpu_mask, GFP_KERNEL))
+		return -ENOMEM;
+		/*
+		retcode = ERR_NOMEM;
+		drbd_msg_put_info("unable to allocate cpumask");
+		*/
+
+	/* silently ignore cpu mask on UP kernel */
+	if (nr_cpu_ids > 1 && res_opts->cpu_mask[0] != 0) {
+		/* FIXME: Get rid of constant 32 here */
+		err = __bitmap_parse(res_opts->cpu_mask, 32, 0,
+				cpumask_bits(new_cpu_mask), nr_cpu_ids);
+		if (err) {
+			conn_warn(tconn, "__bitmap_parse() failed with %d\n", err);
+			/* retcode = ERR_CPU_MASK_PARSE; */
+			goto fail;
+		}
+	}
+	tconn->res_opts = *res_opts;
+	if (!cpumask_equal(tconn->cpu_mask, new_cpu_mask)) {
+		cpumask_copy(tconn->cpu_mask, new_cpu_mask);
+		drbd_calc_cpu_mask(tconn);
+		tconn->receiver.reset_cpu_mask = 1;
+		tconn->asender.reset_cpu_mask = 1;
+		tconn->worker.reset_cpu_mask = 1;
+	}
+	err = 0;
+
+fail:
+	free_cpumask_var(new_cpu_mask);
+	return err;
+
+}
+
 /* caller must be under genl_lock() */
-struct drbd_tconn *conn_create(const char *name)
+struct drbd_tconn *conn_create(const char *name, struct res_opts *res_opts)
 {
 	struct drbd_tconn *tconn;
 
@@ -2500,6 +2539,9 @@ struct drbd_tconn *conn_create(const char *name)
 	if (!zalloc_cpumask_var(&tconn->cpu_mask, GFP_KERNEL))
 		goto fail;
 
+	if (set_resource_options(tconn, res_opts))
+		goto fail;
+
 	if (!tl_init(tconn))
 		goto fail;
 
@@ -2520,8 +2562,6 @@ struct drbd_tconn *conn_create(const char *name)
 	drbd_thread_init(tconn, &tconn->worker, drbd_worker, "worker");
 	drbd_thread_init(tconn, &tconn->asender, drbd_asender, "asender");
 
-	drbd_set_res_opts_defaults(&tconn->res_opts);
-
 	kref_init(&tconn->kref);
 	list_add_tail_rcu(&tconn->all_tconn, &drbd_tconns);
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 50f0980..d361a07 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2383,15 +2383,9 @@ int drbd_adm_resize(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-void drbd_set_res_opts_defaults(struct res_opts *r)
-{
-	return set_res_opts_defaults(r);
-}
-
 int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
-	cpumask_var_t new_cpu_mask;
 	struct drbd_tconn *tconn;
 	struct res_opts res_opts;
 	int err;
@@ -2403,12 +2397,6 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	tconn = adm_ctx.tconn;
 
-	if (!zalloc_cpumask_var(&new_cpu_mask, GFP_KERNEL)) {
-		retcode = ERR_NOMEM;
-		drbd_msg_put_info("unable to allocate cpumask");
-		goto fail;
-	}
-
 	res_opts = tconn->res_opts;
 	if (should_set_defaults(info))
 		set_res_opts_defaults(&res_opts);
@@ -2420,31 +2408,14 @@ int drbd_adm_resource_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	/* silently ignore cpu mask on UP kernel */
-	if (nr_cpu_ids > 1 && res_opts.cpu_mask[0] != 0) {
-		err = __bitmap_parse(res_opts.cpu_mask, 32, 0,
-				cpumask_bits(new_cpu_mask), nr_cpu_ids);
-		if (err) {
-			conn_warn(tconn, "__bitmap_parse() failed with %d\n", err);
-			retcode = ERR_CPU_MASK_PARSE;
-			goto fail;
-		}
-	}
-
-
-	tconn->res_opts = res_opts;
-
-	if (!cpumask_equal(tconn->cpu_mask, new_cpu_mask)) {
-		cpumask_copy(tconn->cpu_mask, new_cpu_mask);
-		drbd_calc_cpu_mask(tconn);
-		tconn->receiver.reset_cpu_mask = 1;
-		tconn->asender.reset_cpu_mask = 1;
-		tconn->worker.reset_cpu_mask = 1;
+	err = set_resource_options(tconn, &res_opts);
+	if (err) {
+		retcode = ERR_INVALID_REQUEST;
+		if (err == -ENOMEM)
+			retcode = ERR_NOMEM;
 	}
 
 fail:
-	free_cpumask_var(new_cpu_mask);
-
 	drbd_adm_finish(info, retcode);
 	return 0;
 }
@@ -3056,6 +3027,8 @@ drbd_check_resource_name(const char *name)
 int drbd_adm_new_resource(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
+	struct res_opts res_opts;
+	int err;
 
 	retcode = drbd_adm_prepare(skb, info, 0);
 	if (!adm_ctx.reply_skb)
@@ -3063,6 +3036,14 @@ int drbd_adm_new_resource(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
+	set_res_opts_defaults(&res_opts);
+	err = res_opts_from_attrs(&res_opts, info);
+	if (err && err != -ENOMSG) {
+		retcode = ERR_MANDATORY_TAG;
+		drbd_msg_put_info(from_attrs_err_to_txt(err));
+		goto out;
+	}
+
 	retcode = drbd_check_resource_name(adm_ctx.resource_name);
 	if (retcode != NO_ERROR)
 		goto out;
@@ -3076,7 +3057,7 @@ int drbd_adm_new_resource(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	if (!conn_create(adm_ctx.resource_name))
+	if (!conn_create(adm_ctx.resource_name, &res_opts))
 		retcode = ERR_NOMEM;
 out:
 	drbd_adm_finish(info, retcode);
-- 
1.7.4.1

