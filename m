Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab1JCVAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:00:53 -0400
Received: from mail09.linbit.com ([212.69.161.110]:41595 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584Ab1JCU6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:58:38 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/10] drbd: Take a reference on tconn when finding a tconn by name
Date: Mon,  3 Oct 2011 22:58:30 +0200
Message-Id: <1317675513-12745-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
References: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rule #3 of kref.txt

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    2 +-
 drivers/block/drbd/drbd_main.c |    6 ++++--
 drivers/block/drbd/drbd_nl.c   |   15 +++++++++++----
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 3abf982..7797879 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1381,7 +1381,7 @@ extern void drbd_delete_device(struct drbd_conf *mdev);
 
 struct drbd_tconn *conn_create(const char *name);
 extern void conn_destroy(struct kref *kref);
-struct drbd_tconn *conn_by_name(const char *name);
+struct drbd_tconn *conn_get_by_name(const char *name);
 extern void conn_free_crypto(struct drbd_tconn *tconn);
 
 extern int proc_details;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1c94d56..02efec5 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2359,7 +2359,7 @@ static void drbd_init_workqueue(struct drbd_work_queue* wq)
 	INIT_LIST_HEAD(&wq->q);
 }
 
-struct drbd_tconn *conn_by_name(const char *name)
+struct drbd_tconn *conn_get_by_name(const char *name)
 {
 	struct drbd_tconn *tconn;
 
@@ -2368,8 +2368,10 @@ struct drbd_tconn *conn_by_name(const char *name)
 
 	down_read(&drbd_cfg_rwsem);
 	list_for_each_entry(tconn, &drbd_tconns, all_tconn) {
-		if (!strcmp(tconn->name, name))
+		if (!strcmp(tconn->name, name)) {
+			kref_get(&tconn->kref);
 			goto found;
+		}
 	}
 	tconn = NULL;
 found:
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index b854427..3d03114 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -219,7 +219,7 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 
 	adm_ctx.minor = d_in->minor;
 	adm_ctx.mdev = minor_to_mdev(d_in->minor);
-	adm_ctx.tconn = conn_by_name(adm_ctx.conn_name);
+	adm_ctx.tconn = conn_get_by_name(adm_ctx.conn_name);
 
 	pr_info("adm request: cmd=%u[%s], flags=0x%x, minor=%d, conn=%s\n",
 		cmd, drbd_genl_cmd_to_str(cmd), d_in->flags,
@@ -251,8 +251,7 @@ static int drbd_adm_prepare(struct sk_buff *skb, struct genl_info *info,
 		drbd_msg_put_info("minor exists as different volume");
 		return ERR_INVALID_REQUEST;
 	}
-	if (adm_ctx.mdev && !adm_ctx.tconn)
-		adm_ctx.tconn = adm_ctx.mdev->tconn;
+
 	return NO_ERROR;
 
 fail:
@@ -267,6 +266,11 @@ static int drbd_adm_finish(struct genl_info *info, int retcode)
 	const char *conn_name = NULL;
 	const u8 cmd = info->genlhdr->cmd;
 
+	if (adm_ctx.tconn) {
+		kref_put(&adm_ctx.tconn->kref, &conn_destroy);
+		adm_ctx.tconn = NULL;
+	}
+
 	if (!adm_ctx.reply_skb)
 		return -ENOMEM;
 
@@ -2795,10 +2799,13 @@ int drbd_adm_get_status_all(struct sk_buff *skb, struct netlink_callback *cb)
 	if (!nla)
 		return -EINVAL;
 	conn_name = nla_data(nla);
-	tconn = conn_by_name(conn_name);
+	tconn = conn_get_by_name(conn_name);
+
 	if (!tconn)
 		return -ENODEV;
 
+	kref_put(&tconn->kref, &conn_destroy); /* get_one_status() (re)validates tconn by itself */
+
 	/* prime iterators, and set "filter" mode mark:
 	 * only dump this tconn. */
 	cb->args[0] = (long)tconn;
-- 
1.7.4.1

