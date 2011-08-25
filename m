Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1HYPKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:10:49 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33273 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab1HYPKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:25 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: =?UTF-8?q?=5BPATCH=20118/118=5D=20drbd=3A=20Implemented=20connection=20wide=20state=20changes?=
Date: Thu, 25 Aug 2011 17:08:54 +0200
Message-Id: <1314284934-17999-119-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is used for graceful disconnect only

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c    |   28 +++++++++---------
 drivers/block/drbd/drbd_state.c |   62 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 14 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 3d8e631..d6832f8 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1572,6 +1572,7 @@ fail:
 static int drbd_nl_disconnect(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 			      struct drbd_nl_cfg_reply *reply)
 {
+	struct drbd_tconn *tconn = mdev->tconn;
 	int retcode;
 	struct disconnect dc;
 
@@ -1582,30 +1583,29 @@ static int drbd_nl_disconnect(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
 	}
 
 	if (dc.force) {
-		spin_lock_irq(&mdev->tconn->req_lock);
-		if (mdev->state.conn >= C_WF_CONNECTION)
-			_drbd_set_state(_NS(mdev, conn, C_DISCONNECTING), CS_HARD, NULL);
-		spin_unlock_irq(&mdev->tconn->req_lock);
+		spin_lock_irq(&tconn->req_lock);
+		if (tconn->cstate >= C_WF_CONNECTION)
+			_conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
+		spin_unlock_irq(&tconn->req_lock);
 		goto done;
 	}
 
-	retcode = _drbd_request_state(mdev, NS(conn, C_DISCONNECTING), CS_ORDERED);
+	retcode = conn_request_state(tconn, NS(conn, C_DISCONNECTING), 0);
 
 	if (retcode == SS_NOTHING_TO_DO)
 		goto done;
 	else if (retcode == SS_ALREADY_STANDALONE)
 		goto done;
 	else if (retcode == SS_PRIMARY_NOP) {
-		/* Our statche checking code wants to see the peer outdated. */
-		retcode = drbd_request_state(mdev, NS2(conn, C_DISCONNECTING,
-						      pdsk, D_OUTDATED));
+		/* Our state checking code wants to see the peer outdated. */
+		retcode = conn_request_state(tconn, NS2(conn, C_DISCONNECTING,
+							pdsk, D_OUTDATED), CS_VERBOSE);
 	} else if (retcode == SS_CW_FAILED_BY_PEER) {
 		/* The peer probably wants to see us outdated. */
-		retcode = _drbd_request_state(mdev, NS2(conn, C_DISCONNECTING,
-							disk, D_OUTDATED),
-					      CS_ORDERED);
+		retcode = conn_request_state(tconn, NS2(conn, C_DISCONNECTING,
+							disk, D_OUTDATED), 0);
 		if (retcode == SS_IS_DISKLESS || retcode == SS_LOWER_THAN_OUTDATED) {
-			drbd_force_state(mdev, NS(conn, C_DISCONNECTING));
+			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 			retcode = SS_SUCCESS;
 		}
 	}
@@ -1613,8 +1613,8 @@ static int drbd_nl_disconnect(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
 	if (retcode < SS_SUCCESS)
 		goto fail;
 
-	if (wait_event_interruptible(mdev->state_wait,
-				     mdev->state.conn != C_DISCONNECTING)) {
+	if (wait_event_interruptible(tconn->ping_wait,
+				     tconn->cstate != C_DISCONNECTING)) {
 		/* Do not test for mdev->state.conn == C_STANDALONE, since
 		   someone else might connect us in the mean time! */
 		retcode = ERR_INTR;
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 81f66b3..61c65f5 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1366,6 +1366,62 @@ static int _set_state_itr_fn(int vnr, void *p, void *data)
 	return 0;
 }
 
+static enum drbd_state_rv
+_conn_rq_cond(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val)
+{
+	struct _is_valid_itr_params params;
+	enum drbd_conns oc = tconn->cstate;
+	enum drbd_state_rv rv;
+
+	if (test_and_clear_bit(CONN_WD_ST_CHG_OKAY, &tconn->flags))
+		return SS_CW_SUCCESS;
+
+	if (test_and_clear_bit(CONN_WD_ST_CHG_FAIL, &tconn->flags))
+		return SS_CW_FAILED_BY_PEER;
+
+	params.flags = CS_NO_CSTATE_CHG; /* öö think */
+	params.mask = mask;
+	params.val = val;
+
+	spin_lock_irq(&tconn->req_lock);
+	rv = oc != C_WF_REPORT_PARAMS ? SS_CW_NO_NEED : SS_UNKNOWN_ERROR;
+
+	if (rv == SS_UNKNOWN_ERROR)
+		rv = idr_for_each(&tconn->volumes, _is_valid_itr_fn, &params);
+
+	if (rv == 0)  /* idr_for_each semantics */
+		rv = SS_UNKNOWN_ERROR;  /* cont waiting, otherwise fail. */
+
+	spin_unlock_irq(&tconn->req_lock);
+
+	return rv;
+}
+
+static enum drbd_state_rv
+conn_cl_wide(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+	     enum chg_state_flags f)
+{
+	enum drbd_state_rv rv;
+
+	spin_unlock_irq(&tconn->req_lock);
+	mutex_lock(&tconn->cstate_mutex);
+
+	if (!conn_send_state_req(tconn, mask, val)) {
+		rv = SS_CW_FAILED_BY_PEER;
+		/* if (f & CS_VERBOSE)
+		   print_st_err(mdev, os, ns, rv); */
+		goto abort;
+	}
+
+	wait_event(tconn->ping_wait, (rv = _conn_rq_cond(tconn, mask, val)));
+
+abort:
+	mutex_unlock(&tconn->cstate_mutex);
+	spin_lock_irq(&tconn->req_lock);
+
+	return rv;
+}
+
 enum drbd_state_rv
 _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
 		    enum chg_state_flags flags)
@@ -1393,6 +1449,12 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 	if (rv < SS_SUCCESS)
 		goto abort;
 
+	if (oc == C_WF_REPORT_PARAMS && val.conn == C_DISCONNECTING && !(flags & CS_LOCAL_ONLY)) {
+		rv = conn_cl_wide(tconn, mask, val, flags);
+		if (rv < SS_SUCCESS)
+			goto abort;
+	}
+
 	if (params.oc_state == OC_CONSISTENT) {
 		oc = params.oc;
 		print_conn_state_change(tconn, oc, val.conn);
-- 
1.7.4.1

