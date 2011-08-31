Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1HaPL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:11:57 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59911 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab1HaPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 15/16] drbd: Implemented new commands to create/delete connections/minors
Date: Wed, 31 Aug 2011 17:11:07 +0200
Message-Id: <1314803468-1201-16-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    4 +-
 drivers/block/drbd/drbd_main.c |   66 ++++++++++++++-----------
 drivers/block/drbd/drbd_nl.c   |  106 ++++++++++++++++++++++++---------------
 include/linux/drbd.h           |    3 +
 include/linux/drbd_nl.h        |   12 +++++
 5 files changed, 119 insertions(+), 72 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2ef168c..5fb5bd0 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1258,7 +1258,6 @@ extern int drbd_bmio_clear_n_write(struct drbd_conf *mdev);
 extern void drbd_go_diskless(struct drbd_conf *mdev);
 extern void drbd_ldev_destroy(struct drbd_conf *mdev);
 
-
 /* Meta data layout
    We reserve a 128MB Block (4k aligned)
    * either at the end of the backing device
@@ -1476,8 +1475,9 @@ extern wait_queue_head_t drbd_pp_wait;
 extern rwlock_t global_state_lock;
 
 extern int conn_lowest_minor(struct drbd_tconn *tconn);
-extern struct drbd_conf *drbd_new_device(unsigned int minor);
+enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor, int vnr);
 extern void drbd_free_mdev(struct drbd_conf *mdev);
+extern void drbd_delete_device(unsigned int minor);
 
 struct drbd_tconn *drbd_new_tconn(char *name);
 extern void drbd_free_tconn(struct drbd_tconn *tconn);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 004118e..1188fca 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -614,13 +614,16 @@ char *drbd_task_to_thread_name(struct drbd_tconn *tconn, struct task_struct *tas
 	return thi ? thi->name : task->comm;
 }
 
-#ifdef CONFIG_SMP
 int conn_lowest_minor(struct drbd_tconn *tconn)
 {
 	int minor = 0;
-	idr_get_next(&tconn->volumes, &minor);
+
+	if (!idr_get_next(&tconn->volumes, &minor))
+		return -1;
 	return minor;
 }
+
+#ifdef CONFIG_SMP
 /**
  * drbd_calc_cpu_mask() - Generate CPU masks, spread over all CPUs
  * @mdev:	DRBD device.
@@ -2078,15 +2081,16 @@ static void drbd_release_ee_lists(struct drbd_conf *mdev)
 		dev_err(DEV, "%d EEs in net list found!\n", rr);
 }
 
-/* caution. no locking.
- * currently only used from module cleanup code. */
-static void drbd_delete_device(unsigned int minor)
+/* caution. no locking. */
+void drbd_delete_device(unsigned int minor)
 {
 	struct drbd_conf *mdev = minor_to_mdev(minor);
 
 	if (!mdev)
 		return;
 
+	idr_remove(&mdev->tconn->volumes, minor);
+
 	/* paranoia asserts */
 	D_ASSERT(mdev->open_cnt == 0);
 	D_ASSERT(list_empty(&mdev->tconn->data.work.q));
@@ -2101,7 +2105,6 @@ static void drbd_delete_device(unsigned int minor)
 		bdput(mdev->this_bdev);
 
 	drbd_free_resources(mdev);
-	drbd_free_tconn(mdev->tconn);
 
 	drbd_release_ee_lists(mdev);
 
@@ -2223,6 +2226,9 @@ struct drbd_tconn *drbd_new_tconn(char *name)
 	if (!tconn->name)
 		goto fail;
 
+	if (!zalloc_cpumask_var(&tconn->cpu_mask, GFP_KERNEL))
+		goto fail;
+
 	if (!tl_init(tconn))
 		goto fail;
 
@@ -2252,6 +2258,7 @@ struct drbd_tconn *drbd_new_tconn(char *name)
 
 fail:
 	tl_cleanup(tconn);
+	free_cpumask_var(tconn->cpu_mask);
 	kfree(tconn->name);
 	kfree(tconn);
 
@@ -2265,6 +2272,7 @@ void drbd_free_tconn(struct drbd_tconn *tconn)
 	write_unlock_irq(&global_state_lock);
 	idr_destroy(&tconn->volumes);
 
+	free_cpumask_var(tconn->cpu_mask);
 	kfree(tconn->name);
 	kfree(tconn->int_dig_out);
 	kfree(tconn->int_dig_in);
@@ -2272,32 +2280,31 @@ void drbd_free_tconn(struct drbd_tconn *tconn)
 	kfree(tconn);
 }
 
-struct drbd_conf *drbd_new_device(unsigned int minor)
+enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor, int vnr)
 {
 	struct drbd_conf *mdev;
 	struct gendisk *disk;
 	struct request_queue *q;
-	char conn_name[9]; /* drbd1234N */
-	int vnr;
+	int vnr_got = vnr;
+
+	mdev = minor_to_mdev(minor);
+	if (mdev)
+		return ERR_MINOR_EXISTS;
 
 	/* GFP_KERNEL, we are outside of all write-out paths */
 	mdev = kzalloc(sizeof(struct drbd_conf), GFP_KERNEL);
 	if (!mdev)
-		return NULL;
-	sprintf(conn_name, "drbd%d", minor);
-	mdev->tconn = drbd_new_tconn(conn_name);
-	if (!mdev->tconn)
-		goto out_no_tconn;
-	if (!idr_pre_get(&mdev->tconn->volumes, GFP_KERNEL))
-		goto out_no_cpumask;
-	if (idr_get_new(&mdev->tconn->volumes, mdev, &vnr))
-		goto out_no_cpumask;
-	if (vnr != 0) {
-		dev_err(DEV, "vnr = %d\n", vnr);
-		goto out_no_cpumask;
-	}
-	if (!zalloc_cpumask_var(&mdev->tconn->cpu_mask, GFP_KERNEL))
-		goto out_no_cpumask;
+		return ERR_NOMEM;
+
+	mdev->tconn = tconn;
+	if (!idr_pre_get(&tconn->volumes, GFP_KERNEL))
+		goto out_no_idr;
+	if (idr_get_new(&tconn->volumes, mdev, &vnr_got))
+		goto out_no_idr;
+	if (vnr_got != vnr) {
+		dev_err(DEV, "vnr_got (%d) != vnr (%d)\n", vnr_got, vnr);
+		goto out_no_q;
+	}
 
 	mdev->minor = minor;
 
@@ -2354,7 +2361,10 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 	INIT_LIST_HEAD(&mdev->current_epoch->list);
 	mdev->epochs = 1;
 
-	return mdev;
+	minor_table[minor] = mdev;
+	add_disk(disk);
+
+	return NO_ERROR;
 
 /* out_whatever_else:
 	kfree(mdev->current_epoch); */
@@ -2367,12 +2377,10 @@ out_no_io_page:
 out_no_disk:
 	blk_cleanup_queue(q);
 out_no_q:
-	free_cpumask_var(mdev->tconn->cpu_mask);
-out_no_cpumask:
-	drbd_free_tconn(mdev->tconn);
-out_no_tconn:
+	idr_remove(&tconn->volumes, vnr_got);
+out_no_idr:
 	kfree(mdev);
-	return NULL;
+	return ERR_NOMEM;
 }
 
 /* counterpart of drbd_new_device.
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 455a51d..f2739fd 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -443,40 +443,6 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 	return rv;
 }
 
-static struct drbd_conf *ensure_mdev(int minor, int create)
-{
-	struct drbd_conf *mdev;
-
-	if (minor >= minor_count)
-		return NULL;
-
-	mdev = minor_to_mdev(minor);
-
-	if (!mdev && create) {
-		struct gendisk *disk = NULL;
-		mdev = drbd_new_device(minor);
-
-		spin_lock_irq(&drbd_pp_lock);
-		if (minor_table[minor] == NULL) {
-			minor_table[minor] = mdev;
-			disk = mdev->vdisk;
-			mdev = NULL;
-		} /* else: we lost the race */
-		spin_unlock_irq(&drbd_pp_lock);
-
-		if (disk) /* we won the race above */
-			/* in case we ever add a drbd_delete_device(),
-			 * don't forget the del_gendisk! */
-			add_disk(disk);
-		else /* we lost the race above */
-			drbd_free_mdev(mdev);
-
-		mdev = minor_to_mdev(minor);
-	}
-
-	return mdev;
-}
-
 static int drbd_nl_primary(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 			   struct drbd_nl_cfg_reply *reply)
 {
@@ -1789,12 +1755,6 @@ static int drbd_nl_syncer_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *n
 	if (!expect(sc.al_extents <= DRBD_AL_EXTENTS_MAX))
 		sc.al_extents = DRBD_AL_EXTENTS_MAX;
 
-	/* to avoid spurious errors when configuring minors before configuring
-	 * the minors they depend on: if necessary, first create the minor we
-	 * depend on */
-	if (sc.after >= 0)
-		ensure_mdev(sc.after, 1);
-
 	/* most sanity checks done, try to assign the new sync-after
 	 * dependency.  need to hold the global lock in there,
 	 * to avoid a race in the dependency loop check. */
@@ -2184,13 +2144,73 @@ out:
 	return 0;
 }
 
+static int drbd_nl_new_conn(struct drbd_nl_cfg_req *nlp, struct drbd_nl_cfg_reply *reply)
+{
+	struct new_connection args;
+
+	if (!new_connection_from_tags(nlp->tag_list, &args)) {
+		reply->ret_code = ERR_MANDATORY_TAG;
+		return 0;
+	}
+
+	reply->ret_code = NO_ERROR;
+	if (!drbd_new_tconn(args.name))
+		reply->ret_code = ERR_NOMEM;
+
+	return 0;
+}
+
+static int drbd_nl_new_minor(struct drbd_tconn *tconn,
+		      struct drbd_nl_cfg_req *nlp, struct drbd_nl_cfg_reply *reply)
+{
+	struct new_minor args;
+
+	args.vol_nr = 0;
+	args.minor = 0;
+
+	if (!new_minor_from_tags(nlp->tag_list, &args)) {
+		reply->ret_code = ERR_MANDATORY_TAG;
+		return 0;
+	}
+
+	reply->ret_code = conn_new_minor(tconn, args.minor, args.vol_nr);
+
+	return 0;
+}
+
+static int drbd_nl_del_minor(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
+			     struct drbd_nl_cfg_reply *reply)
+{
+	if (mdev->state.disk == D_DISKLESS &&
+	    mdev->state.conn == C_STANDALONE &&
+	    mdev->state.role == R_SECONDARY) {
+		drbd_delete_device(mdev_to_minor(mdev));
+		reply->ret_code = NO_ERROR;
+	} else {
+		reply->ret_code = ERR_MINOR_CONFIGURED;
+	}
+	return 0;
+}
+
+static int drbd_nl_del_conn(struct drbd_tconn *tconn,
+			    struct drbd_nl_cfg_req *nlp, struct drbd_nl_cfg_reply *reply)
+{
+	if (conn_lowest_minor(tconn) < 0) {
+		drbd_free_tconn(tconn);
+		reply->ret_code = NO_ERROR;
+	} else {
+		reply->ret_code = ERR_CONN_IN_USE;
+	}
+
+	return 0;
+}
+
 enum cn_handler_type {
 	CHT_MINOR,
 	CHT_CONN,
 	CHT_CTOR,
 	/* CHT_RES, later */
 };
-
 struct cn_handler_struct {
 	enum cn_handler_type type;
 	union {
@@ -2235,6 +2255,10 @@ static struct cn_handler_struct cnd_table[] = {
 				    sizeof(struct get_timeout_flag_tag_len_struct)},
 	[ P_start_ov ]		= { CHT_MINOR, { &drbd_nl_start_ov },	0 },
 	[ P_new_c_uuid ]	= { CHT_MINOR, { &drbd_nl_new_c_uuid },	0 },
+	[ P_new_connection ]	= { CHT_CTOR,  { .constructor = &drbd_nl_new_conn }, 0 },
+	[ P_new_minor ]		= { CHT_CONN,  { .conn_based = &drbd_nl_new_minor }, 0 },
+	[ P_del_minor ]		= { CHT_MINOR, { &drbd_nl_del_minor },	0 },
+	[ P_del_connection ]    = { CHT_CONN,  { .conn_based = &drbd_nl_del_conn }, 0 },
 };
 
 static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms *nsp)
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 7683b4a..e192167 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -156,6 +156,9 @@ enum drbd_ret_code {
 	ERR_PIC_AFTER_DEP	= 156,
 	ERR_PIC_PEER_DEP	= 157,
 	ERR_CONN_NOT_KNOWN      = 158,
+	ERR_CONN_IN_USE         = 159,
+	ERR_MINOR_CONFIGURED    = 160,
+	ERR_MINOR_EXISTS	= 161,
 
 	/* insert new ones above this line */
 	AFTER_LAST_ERR_CODE
diff --git a/include/linux/drbd_nl.h b/include/linux/drbd_nl.h
index ab6159e4..1216c7a 100644
--- a/include/linux/drbd_nl.h
+++ b/include/linux/drbd_nl.h
@@ -152,6 +152,18 @@ NL_PACKET(new_c_uuid, 26,
 NL_RESPONSE(return_code_only, 27)
 #endif
 
+NL_PACKET(new_connection, 28, /* CHT_CTOR */
+	NL_STRING(	85,	T_MANDATORY,	name, DRBD_NL_OBJ_NAME_LEN)
+)
+
+NL_PACKET(new_minor, 29, /* CHT_CONN */
+	NL_INTEGER(	86,	T_MANDATORY,	minor)
+	NL_INTEGER(	87,	T_MANDATORY,	vol_nr)
+)
+
+NL_PACKET(del_minor, 30, ) /* CHT_MINOR */
+NL_PACKET(del_connection, 31, ) /* CHT_CONN */
+
 #undef NL_PACKET
 #undef NL_INTEGER
 #undef NL_INT64
-- 
1.7.4.1

