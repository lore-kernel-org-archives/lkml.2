Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294Ab1JEJjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:39:32 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56247 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934213Ab1JEJiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/16] drbd: fix race when forcefully disconnecting
Date: Wed,  5 Oct 2011 11:38:00 +0200
Message-Id: <1317807484-24628-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

If a forced disconnect hits a restarting receiver right after it passed
its final "if (C_DISCONNECTING)" test in drbdd_init(), but before it was
actually restarted by drbd_thread_setup, we could be left with a
connection stuck in C_DISCONNECTING, never reaching C_STANDALONE,
which would be necessary to take it down or reconfigure it.

Move the last cleanup into w_after_conn_state_ch(), and do an additional
state change request in conn_try_disconnect(), just in case.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c       |   85 ++++++++++++++++++++----------------
 drivers/block/drbd/drbd_receiver.c |   14 +------
 drivers/block/drbd/drbd_state.c    |   13 ++++++
 3 files changed, 62 insertions(+), 50 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0bf74b1..455b9a9 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2160,37 +2160,54 @@ out:
 static enum drbd_state_rv conn_try_disconnect(struct drbd_tconn *tconn, bool force)
 {
 	enum drbd_state_rv rv;
-	if (force) {
-		spin_lock_irq(&tconn->req_lock);
-		rv = _conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
-		spin_unlock_irq(&tconn->req_lock);
-		return rv;
-	}
 
-	rv = conn_request_state(tconn, NS(conn, C_DISCONNECTING), 0);
+	rv = conn_request_state(tconn, NS(conn, C_DISCONNECTING),
+			force ? CS_HARD : 0);
 
 	switch (rv) {
 	case SS_NOTHING_TO_DO:
+		break;
 	case SS_ALREADY_STANDALONE:
 		return SS_SUCCESS;
 	case SS_PRIMARY_NOP:
 		/* Our state checking code wants to see the peer outdated. */
 		rv = conn_request_state(tconn, NS2(conn, C_DISCONNECTING,
-							pdsk, D_OUTDATED), CS_VERBOSE);
+						pdsk, D_OUTDATED), CS_VERBOSE);
 		break;
 	case SS_CW_FAILED_BY_PEER:
 		/* The peer probably wants to see us outdated. */
 		rv = conn_request_state(tconn, NS2(conn, C_DISCONNECTING,
 							disk, D_OUTDATED), 0);
 		if (rv == SS_IS_DISKLESS || rv == SS_LOWER_THAN_OUTDATED) {
-			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
-			rv = SS_SUCCESS;
+			rv = conn_request_state(tconn, NS(conn, C_DISCONNECTING),
+					CS_HARD);
 		}
 		break;
 	default:;
 		/* no special handling necessary */
 	}
 
+	if (rv >= SS_SUCCESS) {
+		enum drbd_state_rv rv2;
+		/* No one else can reconfigure the network while I am here.
+		 * The state handling only uses drbd_thread_stop_nowait(),
+		 * we want to really wait here until the receiver is no more.
+		 */
+		drbd_thread_stop(&adm_ctx.tconn->receiver);
+
+		/* Race breaker.  This additional state change request may be
+		 * necessary, if this was a forced disconnect during a receiver
+		 * restart.  We may have "killed" the receiver thread just
+		 * after drbdd_init() returned.  Typically, we should be
+		 * C_STANDALONE already, now, and this becomes a no-op.
+		 */
+		rv2 = conn_request_state(tconn, NS(conn, C_STANDALONE),
+				CS_VERBOSE | CS_HARD);
+		if (rv2 < SS_SUCCESS)
+			conn_err(tconn,
+				"unexpected rv2=%d in conn_try_disconnect()\n",
+				rv2);
+	}
 	return rv;
 }
 
@@ -2221,19 +2238,9 @@ int drbd_adm_disconnect(struct sk_buff *skb, struct genl_info *info)
 
 	rv = conn_try_disconnect(tconn, parms.force_disconnect);
 	if (rv < SS_SUCCESS)
-		goto fail;
-
-	/* No one else can reconfigure the network while I am here.
-	 * The state handling only uses drbd_thread_stop_nowait(),
-	 * we want to really wait here until the receiver is no more. */
-	drbd_thread_stop(&tconn->receiver);
-	if (wait_event_interruptible(tconn->ping_wait,
-				     tconn->cstate == C_STANDALONE)) {
-		retcode = ERR_INTR;
-		goto fail;
-	}
-
-	retcode = NO_ERROR;
+		retcode = rv;  /* FIXME: Type mismatch. */
+	else
+		retcode = NO_ERROR;
  fail:
 	drbd_adm_finish(info, retcode);
 	return 0;
@@ -3095,8 +3102,7 @@ out:
 
 int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 {
-	enum drbd_ret_code retcode;
-	enum drbd_state_rv rv;
+	int retcode; /* enum drbd_ret_code rsp. enum drbd_state_rv */
 	struct drbd_conf *mdev;
 	unsigned i;
 
@@ -3120,30 +3126,35 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 			goto out_unlock;
 		}
 	}
+	up_read(&drbd_cfg_rwsem);
 
-	/* disconnect */
-	rv = conn_try_disconnect(adm_ctx.tconn, 0);
-	if (rv < SS_SUCCESS) {
-		retcode = rv; /* enum type mismatch! */
+	/* disconnect; may stop the receiver;
+	 * must not hold the drbd_cfg_rwsem */
+	retcode = conn_try_disconnect(adm_ctx.tconn, 0);
+	if (retcode < SS_SUCCESS) {
 		drbd_msg_put_info("failed to disconnect");
-		goto out_unlock;
+		goto out;
 	}
 
-	/* Make sure the network threads have actually stopped,
-	 * state handling only does drbd_thread_stop_nowait(). */
-	drbd_thread_stop(&adm_ctx.tconn->receiver);
-
+	down_read(&drbd_cfg_rwsem);
 	/* detach */
 	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
-		rv = adm_detach(mdev);
-		if (rv < SS_SUCCESS) {
-			retcode = rv; /* enum type mismatch! */
+		retcode = adm_detach(mdev);
+		if (retcode < SS_SUCCESS) {
 			drbd_msg_put_info("failed to detach");
 			goto out_unlock;
 		}
 	}
 	up_read(&drbd_cfg_rwsem);
 
+	/* If we reach this, all volumes (of this tconn) are Secondary,
+	 * Disconnected, Diskless, aka Unconfigured. Make sure all threads have
+	 * actually stopped, state handling only does drbd_thread_stop_nowait().
+	 * This needs to be done without holding drbd_cfg_rwsem. */
+	drbd_thread_stop(&adm_ctx.tconn->worker);
+
+	/* Now, nothing can fail anymore */
+
 	/* delete volumes */
 	down_write(&drbd_cfg_rwsem);
 	idr_for_each_entry(&adm_ctx.tconn->volumes, mdev, i) {
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 9c8bcce..956cdda 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4213,20 +4213,8 @@ static void drbd_disconnect(struct drbd_tconn *tconn)
 
 	spin_unlock_irq(&tconn->req_lock);
 
-	if (oc == C_DISCONNECTING) {
-		struct net_conf *old_conf;
-
-		mutex_lock(&tconn->net_conf_update);
-		old_conf = tconn->net_conf;
-		rcu_assign_pointer(tconn->net_conf, NULL);
-		conn_free_crypto(tconn);
-		mutex_unlock(&tconn->net_conf_update);
-
-		synchronize_rcu();
-		kfree(old_conf);
-
+	if (oc == C_DISCONNECTING)
 		conn_request_state(tconn, NS(conn, C_STANDALONE), CS_VERBOSE | CS_HARD);
-	}
 }
 
 static int drbd_disconnected(int vnr, void *p, void *data)
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 978dcef..f2e1535 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1398,6 +1398,19 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 	if (oc == C_STANDALONE && ns_max.conn == C_UNCONNECTED)
 		drbd_thread_start(&tconn->receiver);
 
+	if (oc == C_DISCONNECTING && ns_max.conn == C_STANDALONE) {
+		struct net_conf *old_conf;
+
+		mutex_lock(&tconn->net_conf_update);
+		old_conf = tconn->net_conf;
+		rcu_assign_pointer(tconn->net_conf, NULL);
+		conn_free_crypto(tconn);
+		mutex_unlock(&tconn->net_conf_update);
+
+		synchronize_rcu();
+		kfree(old_conf);
+	}
+
 	if (ns_max.susp_fen) {
 		/* case1: The outdate peer handler is successful: */
 		if (ns_max.pdsk <= D_OUTDATED) {
-- 
1.7.4.1

