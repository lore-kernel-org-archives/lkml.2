Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab1IAMvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:51:10 -0400
Received: from mail09.linbit.com ([212.69.161.110]:55742 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab1IAMtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:49:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/18] drbd: drbd_adm_get_status needs to show some more detail
Date: Thu,  1 Sep 2011 14:48:59 +0200
Message-Id: <1314881345-6420-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
References: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

We want to see existing connection objects, even if they do not
currently have volumes attached.

Change the .dumpit variant of drbd_adm_get_status to iterate not over
minor devices, but over connections + volumes.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    3 +-
 drivers/block/drbd/drbd_main.c |   15 +++---
 drivers/block/drbd/drbd_nl.c   |  117 +++++++++++++++++++++++++++++++++-------
 3 files changed, 107 insertions(+), 28 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index f4c3c71..d84a073 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -171,6 +171,7 @@ drbd_insert_fault(struct drbd_conf *mdev, unsigned int type) {
 extern struct ratelimit_state drbd_ratelimit_state;
 extern struct idr minors;
 extern struct list_head drbd_tconns;
+extern struct mutex drbd_cfg_mutex;
 
 /* on the wire */
 enum drbd_packet {
@@ -918,7 +919,7 @@ enum {
 
 struct drbd_tconn {			/* is a resource from the config file */
 	char *name;			/* Resource name */
-	struct list_head all_tconn;	/* List of all drbd_tconn, prot by global_state_lock */
+	struct list_head all_tconn;	/* linked on global drbd_tconns */
 	struct idr volumes;		/* <tconn, vnr> to mdev mapping */
 	enum drbd_conns cstate;		/* Only C_STANDALONE to C_WF_REPORT_PARAMS */
 	struct mutex cstate_mutex;	/* Protects graceful disconnects */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 64bf9b6..2e79032 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -120,6 +120,7 @@ module_param_string(usermode_helper, usermode_helper, sizeof(usermode_helper), 0
  */
 struct idr minors;
 struct list_head drbd_tconns;  /* list of struct drbd_tconn */
+DEFINE_MUTEX(drbd_cfg_mutex);
 
 struct kmem_cache *drbd_request_cache;
 struct kmem_cache *drbd_ee_cache;	/* peer requests */
@@ -2238,14 +2239,14 @@ struct drbd_tconn *conn_by_name(const char *name)
 	if (!name || !name[0])
 		return NULL;
 
-	write_lock_irq(&global_state_lock);
+	mutex_lock(&drbd_cfg_mutex);
 	list_for_each_entry(tconn, &drbd_tconns, all_tconn) {
 		if (!strcmp(tconn->name, name))
 			goto found;
 	}
 	tconn = NULL;
 found:
-	write_unlock_irq(&global_state_lock);
+	mutex_unlock(&drbd_cfg_mutex);
 	return tconn;
 }
 
@@ -2285,9 +2286,9 @@ struct drbd_tconn *drbd_new_tconn(const char *name)
 	drbd_thread_init(tconn, &tconn->worker, drbd_worker, "worker");
 	drbd_thread_init(tconn, &tconn->asender, drbd_asender, "asender");
 
-	write_lock_irq(&global_state_lock);
-	list_add(&tconn->all_tconn, &drbd_tconns);
-	write_unlock_irq(&global_state_lock);
+	mutex_lock(&drbd_cfg_mutex);
+	list_add_tail(&tconn->all_tconn, &drbd_tconns);
+	mutex_unlock(&drbd_cfg_mutex);
 
 	return tconn;
 
@@ -2302,9 +2303,9 @@ fail:
 
 void drbd_free_tconn(struct drbd_tconn *tconn)
 {
-	write_lock_irq(&global_state_lock);
+	mutex_lock(&drbd_cfg_mutex);
 	list_del(&tconn->all_tconn);
-	write_unlock_irq(&global_state_lock);
+	mutex_unlock(&drbd_cfg_mutex);
 	idr_destroy(&tconn->volumes);
 
 	free_cpumask_var(tconn->cpu_mask);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index b40c83d..c389995 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1577,6 +1577,10 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 
 	new_my_addr = (struct sockaddr *)&new_conf->my_addr;
 	new_peer_addr = (struct sockaddr *)&new_conf->peer_addr;
+
+	/* No need to take drbd_cfg_mutex here.  All reconfiguration is
+	 * strictly serialized on genl_lock(). We are protected against
+	 * concurrent reconfiguration/addition/deletion */
 	list_for_each_entry(oconn, &drbd_tconns, all_tconn) {
 		if (oconn == tconn)
 			continue;
@@ -2220,6 +2224,24 @@ int drbd_adm_outdate(struct sk_buff *skb, struct genl_info *info)
 	return drbd_adm_simple_request_state(skb, info, NS(disk, D_OUTDATED));
 }
 
+int nla_put_drbd_cfg_context(struct sk_buff *skb, const char *conn_name, unsigned vnr)
+{
+	struct nlattr *nla;
+	nla = nla_nest_start(skb, DRBD_NLA_CFG_CONTEXT);
+	if (!nla)
+		goto nla_put_failure;
+	if (vnr != VOLUME_UNSPECIFIED)
+		NLA_PUT_U32(skb, T_ctx_volume, vnr);
+	NLA_PUT_STRING(skb, T_ctx_conn_name, conn_name);
+	nla_nest_end(skb, nla);
+	return 0;
+
+nla_put_failure:
+	if (nla)
+		nla_nest_cancel(skb, nla);
+	return -EMSGSIZE;
+}
+
 int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
 		const struct sib_info *sib)
 {
@@ -2248,12 +2270,8 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
 
 	/* We need to add connection name and volume number information still.
 	 * Minor number is in drbd_genlmsghdr. */
-	nla = nla_nest_start(skb, DRBD_NLA_CFG_CONTEXT);
-	if (!nla)
+	if (nla_put_drbd_cfg_context(skb, mdev->tconn->name, mdev->vnr))
 		goto nla_put_failure;
-	NLA_PUT_U32(skb, T_ctx_volume, mdev->vnr);
-	NLA_PUT_STRING(skb, T_ctx_conn_name, mdev->tconn->name);
-	nla_nest_end(skb, nla);
 
 	if (got_ldev)
 		if (disk_conf_to_skb(skb, &mdev->ldev->dc, exclude_sensitive))
@@ -2340,43 +2358,102 @@ int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct drbd_conf *mdev;
 	struct drbd_genlmsghdr *dh;
-	int minor = cb->args[0];
-
-	/* Open coded deferred single idr_for_each_entry iteration.
+	struct drbd_tconn *pos = (struct drbd_tconn*)cb->args[0];
+	struct drbd_tconn *tconn = NULL;
+	struct drbd_tconn *tmp;
+	unsigned volume = cb->args[1];
+
+	/* Open coded, deferred, iteration:
+	 * list_for_each_entry_safe(tconn, tmp, &drbd_tconns, all_tconn) {
+	 *	idr_for_each_entry(&tconn->volumes, mdev, i) {
+	 *	  ...
+	 *	}
+	 * }
+	 * where tconn is cb->args[0];
+	 * and i is cb->args[1];
+	 *
 	 * This may miss entries inserted after this dump started,
 	 * or entries deleted before they are reached.
-	 * But we need to make sure the mdev won't disappear while
-	 * we are looking at it. */
+	 *
+	 * We need to make sure the mdev won't disappear while
+	 * we are looking at it, and revalidate our iterators
+	 * on each iteration.
+	 */
 
+	/* synchronize with drbd_new_tconn/drbd_free_tconn */
+	mutex_lock(&drbd_cfg_mutex);
+	/* synchronize with drbd_delete_device */
 	rcu_read_lock();
-	mdev = idr_get_next(&minors, &minor);
-	if (mdev) {
+next_tconn:
+	/* revalidate iterator position */
+	list_for_each_entry(tmp, &drbd_tconns, all_tconn) {
+		if (pos == NULL) {
+			/* first iteration */
+			pos = tmp;
+			tconn = pos;
+			break;
+		}
+		if (tmp == pos) {
+			tconn = pos;
+			break;
+		}
+	}
+	if (tconn) {
+		mdev = idr_get_next(&tconn->volumes, &volume);
+		if (!mdev) {
+			/* No more volumes to dump on this tconn.
+			 * Advance tconn iterator. */
+			pos = list_entry(tconn->all_tconn.next,
+					struct drbd_tconn, all_tconn);
+			/* But, did we dump any volume on this tconn yet? */
+			if (volume != 0) {
+				tconn = NULL;
+				volume = 0;
+				goto next_tconn;
+			}
+		}
+
 		dh = genlmsg_put(skb, NETLINK_CB(cb->skb).pid,
 				cb->nlh->nlmsg_seq, &drbd_genl_family,
 				NLM_F_MULTI, DRBD_ADM_GET_STATUS);
 		if (!dh)
-			goto errout;
+			goto out;
+
+		if (!mdev) {
+			/* this is a tconn without a single volume */
+			dh->minor = -1U;
+			dh->ret_code = NO_ERROR;
+			if (nla_put_drbd_cfg_context(skb, tconn->name, VOLUME_UNSPECIFIED))
+				genlmsg_cancel(skb, dh);
+			else
+				genlmsg_end(skb, dh);
+			goto out;
+		}
 
-		D_ASSERT(mdev->minor == minor);
+		D_ASSERT(mdev->vnr == volume);
+		D_ASSERT(mdev->tconn == tconn);
 
-		dh->minor = minor;
+		dh->minor = mdev_to_minor(mdev);
 		dh->ret_code = NO_ERROR;
 
 		pr_info("dump: minor=%u, conn=%s[%u]\n",
 			dh->minor, mdev->tconn->name, mdev->vnr);
 		if (nla_put_status_info(skb, mdev, NULL)) {
 			genlmsg_cancel(skb, dh);
-			goto errout;
+			goto out;
 		}
 		genlmsg_end(skb, dh);
         }
 
-errout:
+out:
 	rcu_read_unlock();
-	/* where to start idr_get_next with the next iteration */
-        cb->args[0] = minor+1;
+	mutex_unlock(&drbd_cfg_mutex);
+	/* where to start the next iteration */
+        cb->args[0] = (long)pos;
+        cb->args[1] = (pos == tconn) ? volume + 1 : 0;
 
-	/* No more minors found: empty skb. Which will terminate the dump. */
+	/* No more tconns/volumes/minors found results in an empty skb.
+	 * Which will terminate the dump. */
         return skb->len;
 }
 
-- 
1.7.4.1

