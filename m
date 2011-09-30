Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab1I3Mu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:50:56 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42742 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758590Ab1I3Ms3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:48:29 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/11] drbd: Converted drbd_cfg_mutex into drbd_cfg_rwsem
Date: Fri, 30 Sep 2011 14:48:19 +0200
Message-Id: <1317386906-19260-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
References: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    4 +++-
 drivers/block/drbd/drbd_main.c |   10 +++++-----
 drivers/block/drbd/drbd_nl.c   |   27 ++++++++++++++++-----------
 3 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c49dc08..7896a64 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -171,7 +171,9 @@ drbd_insert_fault(struct drbd_conf *mdev, unsigned int type) {
 extern struct ratelimit_state drbd_ratelimit_state;
 extern struct idr minors;
 extern struct list_head drbd_tconns;
-extern struct mutex drbd_cfg_mutex;
+extern struct rw_semaphore drbd_cfg_rwsem;
+/* drbd_cfg_rwsem protects: drbd_tconns list,
+   note: non sleeping iterations over the idrs are protoected by RCU */
 
 /* on the wire */
 enum drbd_packet {
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c4c0bc5..d48efb4 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -120,7 +120,7 @@ module_param_string(usermode_helper, usermode_helper, sizeof(usermode_helper), 0
  */
 struct idr minors;
 struct list_head drbd_tconns;  /* list of struct drbd_tconn */
-DEFINE_MUTEX(drbd_cfg_mutex);
+DECLARE_RWSEM(drbd_cfg_rwsem);
 
 struct kmem_cache *drbd_request_cache;
 struct kmem_cache *drbd_ee_cache;	/* peer requests */
@@ -2321,14 +2321,14 @@ struct drbd_tconn *conn_by_name(const char *name)
 	if (!name || !name[0])
 		return NULL;
 
-	mutex_lock(&drbd_cfg_mutex);
+	down_read(&drbd_cfg_rwsem);
 	list_for_each_entry(tconn, &drbd_tconns, all_tconn) {
 		if (!strcmp(tconn->name, name))
 			goto found;
 	}
 	tconn = NULL;
 found:
-	mutex_unlock(&drbd_cfg_mutex);
+	up_read(&drbd_cfg_rwsem);
 	return tconn;
 }
 
@@ -2395,9 +2395,9 @@ struct drbd_tconn *drbd_new_tconn(const char *name)
 		DRBD_ON_NO_DATA_DEF, /* on_no_data */
 	};
 
-	mutex_lock(&drbd_cfg_mutex);
+	down_write(&drbd_cfg_rwsem);
 	list_add_tail(&tconn->all_tconn, &drbd_tconns);
-	mutex_unlock(&drbd_cfg_mutex);
+	up_write(&drbd_cfg_rwsem);
 
 	return tconn;
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index fc918d0..5667536 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1959,7 +1959,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	new_my_addr = (struct sockaddr *)&new_conf->my_addr;
 	new_peer_addr = (struct sockaddr *)&new_conf->peer_addr;
 
-	/* No need to take drbd_cfg_mutex here.  All reconfiguration is
+	/* No need to take drbd_cfg_rwsem here.  All reconfiguration is
 	 * strictly serialized on genl_lock(). We are protected against
 	 * concurrent reconfiguration/addition/deletion */
 	list_for_each_entry(oconn, &drbd_tconns, all_tconn) {
@@ -2635,7 +2635,7 @@ int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
 	 */
 
 	/* synchronize with drbd_new_tconn/drbd_free_tconn */
-	mutex_lock(&drbd_cfg_mutex);
+	down_read(&drbd_cfg_rwsem);
 next_tconn:
 	/* revalidate iterator position */
 	list_for_each_entry(tmp, &drbd_tconns, all_tconn) {
@@ -2698,7 +2698,7 @@ next_tconn:
         }
 
 out:
-	mutex_unlock(&drbd_cfg_mutex);
+	up_read(&drbd_cfg_rwsem);
 	/* where to start the next iteration */
         cb->args[0] = (long)pos;
         cb->args[1] = (pos == tconn) ? volume + 1 : 0;
@@ -2949,9 +2949,9 @@ int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	mutex_lock(&drbd_cfg_mutex);
+	down_write(&drbd_cfg_rwsem);
 	retcode = adm_delete_minor(adm_ctx.mdev);
-	mutex_unlock(&drbd_cfg_mutex);
+	up_write(&drbd_cfg_rwsem);
 	/* if this was the last volume of this connection,
 	 * this will terminate all threads */
 	if (retcode == NO_ERROR)
@@ -2979,7 +2979,7 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	mutex_lock(&drbd_cfg_mutex);
+	down_read(&drbd_cfg_rwsem);
 	/* demote */
 	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
 		retcode = drbd_set_role(mdev, R_SECONDARY, 0);
@@ -3006,14 +3006,17 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 			goto out_unlock;
 		}
 	}
+	up_read(&drbd_cfg_rwsem);
 
 	/* delete volumes */
+	down_write(&drbd_cfg_rwsem);
 	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
 		retcode = adm_delete_minor(mdev);
 		if (retcode != NO_ERROR) {
 			/* "can not happen" */
 			drbd_msg_put_info("failed to delete volume");
-			goto out_unlock;
+			up_write(&drbd_cfg_rwsem);
+			goto out;
 		}
 	}
 
@@ -3028,10 +3031,12 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 		/* "can not happen" */
 		retcode = ERR_CONN_IN_USE;
 		drbd_msg_put_info("failed to delete connection");
-		goto out_unlock;
 	}
+
+	up_write(&drbd_cfg_rwsem);
+	goto out;
 out_unlock:
-	mutex_unlock(&drbd_cfg_mutex);
+	up_read(&drbd_cfg_rwsem);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3047,14 +3052,14 @@ int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	mutex_lock(&drbd_cfg_mutex);
+	down_write(&drbd_cfg_rwsem);
 	if (conn_lowest_minor(adm_ctx.tconn) < 0) {
 		drbd_free_tconn(adm_ctx.tconn);
 		retcode = NO_ERROR;
 	} else {
 		retcode = ERR_CONN_IN_USE;
 	}
-	mutex_unlock(&drbd_cfg_mutex);
+	up_write(&drbd_cfg_rwsem);
 
 out:
 	drbd_adm_finish(info, retcode);
-- 
1.7.4.1

