Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab1IAMt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:49:26 -0400
Received: from mail09.linbit.com ([212.69.161.110]:55900 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab1IAMtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:49:17 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 18/18] drbd: introduce in-kernel "down" command
Date: Thu,  1 Sep 2011 14:49:05 +0200
Message-Id: <1314881345-6420-19-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
References: <1314881345-6420-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

This greatly simplifies deconfiguration of whole resources.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |    2 -
 drivers/block/drbd/drbd_nl.c   |  203 ++++++++++++++++++++++++++++++----------
 include/linux/drbd_genl.h      |    2 +
 3 files changed, 154 insertions(+), 53 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 2e79032..de49c8d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2303,9 +2303,7 @@ fail:
 
 void drbd_free_tconn(struct drbd_tconn *tconn)
 {
-	mutex_lock(&drbd_cfg_mutex);
 	list_del(&tconn->all_tconn);
-	mutex_unlock(&drbd_cfg_mutex);
 	idr_destroy(&tconn->volumes);
 
 	free_cpumask_var(tconn->cpu_mask);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 773946d..2970f45 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -73,6 +73,7 @@ int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info);
 
 int drbd_adm_create_connection(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info);
+int drbd_adm_down(struct sk_buff *skb, struct genl_info *info);
 
 int drbd_adm_set_role(struct sk_buff *skb, struct genl_info *info);
 int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info);
@@ -1449,6 +1450,18 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+static int adm_detach(struct drbd_conf *mdev)
+{
+	enum drbd_ret_code retcode;
+	drbd_suspend_io(mdev); /* so no-one is stuck in drbd_al_begin_io */
+	retcode = drbd_request_state(mdev, NS(disk, D_DISKLESS));
+	wait_event(mdev->misc_wait,
+			mdev->state.disk != D_DISKLESS ||
+			!atomic_read(&mdev->local_cnt));
+	drbd_resume_io(mdev);
+	return retcode;
+}
+
 /* Detaching the disk is a process in multiple stages.  First we need to lock
  * out application IO, in-flight IO, IO stuck in drbd_al_begin_io.
  * Then we transition to D_DISKLESS, and wait for put_ldev() to return all
@@ -1456,7 +1469,6 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
  * Only then we have finally detached. */
 int drbd_adm_detach(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_conf *mdev;
 	enum drbd_ret_code retcode;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
@@ -1465,13 +1477,7 @@ int drbd_adm_detach(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	mdev = adm_ctx.mdev;
-	drbd_suspend_io(mdev); /* so no-one is stuck in drbd_al_begin_io */
-	retcode = drbd_request_state(mdev, NS(disk, D_DISKLESS));
-	wait_event(mdev->misc_wait,
-			mdev->state.disk != D_DISKLESS ||
-			!atomic_read(&mdev->local_cnt));
-	drbd_resume_io(mdev);
+	retcode = adm_detach(adm_ctx.mdev);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -1713,10 +1719,49 @@ out:
 	return 0;
 }
 
+static enum drbd_state_rv conn_try_disconnect(struct drbd_tconn *tconn, bool force)
+{
+	enum drbd_state_rv rv;
+	if (force) {
+		spin_lock_irq(&tconn->req_lock);
+		if (tconn->cstate >= C_WF_CONNECTION)
+			_conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+		spin_unlock_irq(&tconn->req_lock);
+		return SS_SUCCESS;
+	}
+
+	rv = conn_request_state(tconn, NS(conn, C_DISCONNECTING), 0);
+
+	switch (rv) {
+	case SS_NOTHING_TO_DO:
+	case SS_ALREADY_STANDALONE:
+		return SS_SUCCESS;
+	case SS_PRIMARY_NOP:
+		/* Our state checking code wants to see the peer outdated. */
+		rv = conn_request_state(tconn, NS2(conn, C_DISCONNECTING,
+							pdsk, D_OUTDATED), CS_VERBOSE);
+		break;
+	case SS_CW_FAILED_BY_PEER:
+		/* The peer probably wants to see us outdated. */
+		rv = conn_request_state(tconn, NS2(conn, C_DISCONNECTING,
+							disk, D_OUTDATED), 0);
+		if (rv == SS_IS_DISKLESS || rv == SS_LOWER_THAN_OUTDATED) {
+			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+			rv = SS_SUCCESS;
+		}
+		break;
+	default:;
+		/* no special handling necessary */
+	}
+
+	return rv;
+}
+
 int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 {
 	struct disconnect_parms parms;
 	struct drbd_tconn *tconn;
+	enum drbd_state_rv rv;
 	enum drbd_ret_code retcode;
 	int err;
 
@@ -1737,35 +1782,8 @@ int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	if (parms.force_disconnect) {
-		spin_lock_irq(&tconn->req_lock);
-		if (tconn->cstate >= C_WF_CONNECTION)
-			_conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
-		spin_unlock_irq(&tconn->req_lock);
-		goto done;
-	}
-
-	retcode = conn_request_state(tconn, NS(conn, C_DISCONNECTING), 0);
-
-	if (retcode == SS_NOTHING_TO_DO)
-		goto done;
-	else if (retcode == SS_ALREADY_STANDALONE)
-		goto done;
-	else if (retcode == SS_PRIMARY_NOP) {
-		/* Our state checking code wants to see the peer outdated. */
-		retcode = conn_request_state(tconn, NS2(conn, C_DISCONNECTING,
-							pdsk, D_OUTDATED), CS_VERBOSE);
-	} else if (retcode == SS_CW_FAILED_BY_PEER) {
-		/* The peer probably wants to see us outdated. */
-		retcode = conn_request_state(tconn, NS2(conn, C_DISCONNECTING,
-							disk, D_OUTDATED), 0);
-		if (retcode == SS_IS_DISKLESS || retcode == SS_LOWER_THAN_OUTDATED) {
-			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
-			retcode = SS_SUCCESS;
-		}
-	}
-
-	if (retcode < SS_SUCCESS)
+	rv = conn_try_disconnect(tconn, parms.force_disconnect);
+	if (rv < SS_SUCCESS)
 		goto fail;
 
 	if (wait_event_interruptible(tconn->ping_wait,
@@ -1776,7 +1794,6 @@ int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
- done:
 	retcode = NO_ERROR;
  fail:
 	drbd_adm_finish(info, retcode);
@@ -2677,9 +2694,21 @@ out:
 	return 0;
 }
 
+static enum drbd_ret_code adm_delete_minor(struct drbd_conf *mdev)
+{
+	if (mdev->state.disk == D_DISKLESS &&
+	    /* no need to be mdev->state.conn == C_STANDALONE &&
+	     * we may want to delete a minor from a live replication group.
+	     */
+	    mdev->state.role == R_SECONDARY) {
+		drbd_delete_device(mdev_to_minor(mdev));
+		return NO_ERROR;
+	} else
+		return ERR_MINOR_CONFIGURED;
+}
+
 int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info)
 {
-	struct drbd_conf *mdev;
 	enum drbd_ret_code retcode;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
@@ -2688,19 +2717,89 @@ int drbd_adm_delete_minor(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	mdev = adm_ctx.mdev;
-	if (mdev->state.disk == D_DISKLESS &&
-	    /* no need to be mdev->state.conn == C_STANDALONE &&
-	     * we may want to delete a minor from a live replication group.
-	     */
-	    mdev->state.role == R_SECONDARY) {
-		drbd_delete_device(mdev_to_minor(mdev));
-		retcode = NO_ERROR;
-		/* if this was the last volume of this connection,
-		 * this will terminate all threads */
+	mutex_lock(&drbd_cfg_mutex);
+	retcode = adm_delete_minor(adm_ctx.mdev);
+	mutex_unlock(&drbd_cfg_mutex);
+	/* if this was the last volume of this connection,
+	 * this will terminate all threads */
+	if (retcode == NO_ERROR)
 		conn_reconfig_done(adm_ctx.tconn);
-	} else
-		retcode = ERR_MINOR_CONFIGURED;
+out:
+	drbd_adm_finish(info, retcode);
+	return 0;
+}
+
+int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
+{
+	enum drbd_ret_code retcode;
+	enum drbd_state_rv rv;
+	struct drbd_conf *mdev;
+	unsigned i;
+
+	retcode = drbd_adm_prepare(skb, info, 0);
+	if (!adm_ctx.reply_skb)
+		return retcode;
+	if (retcode != NO_ERROR)
+		goto out;
+
+	if (!adm_ctx.tconn) {
+		retcode = ERR_CONN_NOT_KNOWN;
+		goto out;
+	}
+
+	mutex_lock(&drbd_cfg_mutex);
+	/* demote */
+	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
+		retcode = drbd_set_role(mdev, R_SECONDARY, 0);
+		if (retcode < SS_SUCCESS) {
+			drbd_msg_put_info("failed to demote");
+			goto out_unlock;
+		}
+	}
+
+	/* disconnect */
+	rv = conn_try_disconnect(adm_ctx.tconn, 0);
+	if (rv < SS_SUCCESS) {
+		retcode = rv; /* enum type mismatch! */
+		drbd_msg_put_info("failed to disconnect");
+		goto out_unlock;
+	}
+
+	/* detach */
+	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
+		rv = adm_detach(mdev);
+		if (rv < SS_SUCCESS) {
+			retcode = rv; /* enum type mismatch! */
+			drbd_msg_put_info("failed to detach");
+			goto out_unlock;
+		}
+	}
+
+	/* delete volumes */
+	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
+		retcode = adm_delete_minor(mdev);
+		if (retcode != NO_ERROR) {
+			/* "can not happen" */
+			drbd_msg_put_info("failed to delete volume");
+			goto out_unlock;
+		}
+	}
+
+	/* stop all threads */
+	conn_reconfig_done(adm_ctx.tconn);
+
+	/* delete connection */
+	if (conn_lowest_minor(adm_ctx.tconn) < 0) {
+		drbd_free_tconn(adm_ctx.tconn);
+		retcode = NO_ERROR;
+	} else {
+		/* "can not happen" */
+		retcode = ERR_CONN_IN_USE;
+		drbd_msg_put_info("failed to delete connection");
+		goto out_unlock;
+	}
+out_unlock:
+	mutex_unlock(&drbd_cfg_mutex);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -2716,12 +2815,14 @@ int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
+	mutex_lock(&drbd_cfg_mutex);
 	if (conn_lowest_minor(adm_ctx.tconn) < 0) {
 		drbd_free_tconn(adm_ctx.tconn);
 		retcode = NO_ERROR;
 	} else {
 		retcode = ERR_CONN_IN_USE;
 	}
+	mutex_unlock(&drbd_cfg_mutex);
 
 out:
 	drbd_adm_finish(info, retcode);
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 84e1684..a07d692 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -347,3 +347,5 @@ GENL_op(DRBD_ADM_OUTDATE,	25, GENL_doit(drbd_adm_outdate),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
 GENL_op(DRBD_ADM_GET_TIMEOUT_TYPE, 26, GENL_doit(drbd_adm_get_timeout_type),
 	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
+GENL_op(DRBD_ADM_DOWN,		27, GENL_doit(drbd_adm_down),
+	GENL_tla_expected(DRBD_NLA_CFG_CONTEXT, GENLA_F_REQUIRED))
-- 
1.7.4.1

