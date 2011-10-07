Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019Ab1JGL1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:27:52 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35842 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832Ab1JGL1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:27:49 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/12] drbd: Use RCU for the drbd_tconns list
Date: Fri,  7 Oct 2011 13:27:35 +0200
Message-Id: <1317986865-3706-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
References: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparing removal of drbd_cfg_rwsem

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |    7 ++++---
 drivers/block/drbd/drbd_nl.c   |   12 +++++++-----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9e4c487..c229448 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2341,7 +2341,7 @@ static void drbd_cleanup(void)
 	}
 
 	list_for_each_entry_safe(tconn, tmp, &drbd_tconns, all_tconn) {
-		list_del(&tconn->all_tconn);
+		list_del_rcu(&tconn->all_tconn);
 		synchronize_rcu();
 		kref_put(&tconn->kref, &conn_destroy);
 	}
@@ -2409,7 +2409,7 @@ struct drbd_tconn *conn_get_by_name(const char *name)
 		return NULL;
 
 	down_read(&drbd_cfg_rwsem);
-	list_for_each_entry(tconn, &drbd_tconns, all_tconn) {
+	list_for_each_entry_rcu(tconn, &drbd_tconns, all_tconn) {
 		if (!strcmp(tconn->name, name)) {
 			kref_get(&tconn->kref);
 			goto found;
@@ -2459,6 +2459,7 @@ void conn_free_crypto(struct drbd_tconn *tconn)
 	tconn->int_dig_vv = NULL;
 }
 
+/* caller must be under genl_lock() */
 struct drbd_tconn *conn_create(const char *name)
 {
 	struct drbd_tconn *tconn;
@@ -2503,7 +2504,7 @@ struct drbd_tconn *conn_create(const char *name)
 
 	down_write(&drbd_cfg_rwsem);
 	kref_init(&tconn->kref);
-	list_add_tail(&tconn->all_tconn, &drbd_tconns);
+	list_add_tail_rcu(&tconn->all_tconn, &drbd_tconns);
 	up_write(&drbd_cfg_rwsem);
 
 	return tconn;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 3c55be5..49f3b8d 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2719,7 +2719,7 @@ int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	/* synchronize with conn_create()/conn_destroy() */
 	down_read(&drbd_cfg_rwsem);
 	/* revalidate iterator position */
-	list_for_each_entry(tmp, &drbd_tconns, all_tconn) {
+	list_for_each_entry_rcu(tmp, &drbd_tconns, all_tconn) {
 		if (pos == NULL) {
 			/* first iteration */
 			pos = tmp;
@@ -2737,8 +2737,8 @@ next_tconn:
 		if (!mdev) {
 			/* No more volumes to dump on this tconn.
 			 * Advance tconn iterator. */
-			pos = list_entry(tconn->all_tconn.next,
-					struct drbd_tconn, all_tconn);
+			pos = list_entry_rcu(tconn->all_tconn.next,
+					     struct drbd_tconn, all_tconn);
 			/* Did we dump any volume on this tconn yet? */
 			if (volume != 0) {
 				/* If we reached the end of the list,
@@ -3176,7 +3176,8 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 
 	/* delete connection */
 	if (conn_lowest_minor(adm_ctx.tconn) < 0) {
-		list_del(&adm_ctx.tconn->all_tconn);
+		list_del_rcu(&adm_ctx.tconn->all_tconn);
+		synchronize_rcu();
 		kref_put(&adm_ctx.tconn->kref, &conn_destroy);
 
 		retcode = NO_ERROR;
@@ -3206,7 +3207,8 @@ int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info)
 
 	down_write(&drbd_cfg_rwsem);
 	if (conn_lowest_minor(adm_ctx.tconn) < 0) {
-		list_del(&adm_ctx.tconn->all_tconn);
+		list_del_rcu(&adm_ctx.tconn->all_tconn);
+		synchronize_rcu();
 		kref_put(&adm_ctx.tconn->kref, &conn_destroy);
 
 		retcode = NO_ERROR;
-- 
1.7.4.1

