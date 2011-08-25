Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1HYPNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:13:34 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33197 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab1HYPKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 106/118] drbd: Extracted is_valid_transition() out of sanitize_state()
Date: Thu, 25 Aug 2011 17:08:42 +0200
Message-Id: <1314284934-17999-107-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |   71 +++++++++++++++++++++++++++------------
 1 files changed, 49 insertions(+), 22 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index d577715..3199bf9 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -47,6 +47,7 @@ static void after_conn_state_ch(struct drbd_tconn *tconn, union drbd_state os,
 				union drbd_state ns, enum chg_state_flags flags);
 static enum drbd_state_rv is_valid_state(struct drbd_conf *, union drbd_state);
 static enum drbd_state_rv is_valid_soft_transition(union drbd_state, union drbd_state);
+static enum drbd_state_rv is_valid_transition(union drbd_state os, union drbd_state ns);
 static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state os,
 				       union drbd_state ns, const char **warn_sync_abort);
 
@@ -112,15 +113,17 @@ _req_st_cond(struct drbd_conf *mdev, union drbd_state mask,
 	if (test_and_clear_bit(CL_ST_CHG_FAIL, &mdev->flags))
 		return SS_CW_FAILED_BY_PEER;
 
-	rv = 0;
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	os = mdev->state;
 	ns.i = (os.i & ~mask.i) | val.i;
 	ns = sanitize_state(mdev, os, ns, NULL);
+	rv = is_valid_transition(os, ns);
+	if (rv == SS_SUCCESS)
+		rv = SS_UNKNOWN_ERROR;  /* cont waiting, otherwise fail. */
 
 	if (!cl_wide_st_chg(mdev, os, ns))
 		rv = SS_CW_NO_NEED;
-	if (!rv) {
+	if (rv == SS_UNKNOWN_ERROR) {
 		rv = is_valid_state(mdev, ns);
 		if (rv == SS_SUCCESS) {
 			rv = is_valid_soft_transition(os, ns);
@@ -160,8 +163,10 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 	spin_lock_irqsave(&mdev->tconn->req_lock, flags);
 	os = mdev->state;
 	ns.i = (os.i & ~mask.i) | val.i;
-
 	ns = sanitize_state(mdev, os, ns, NULL);
+	rv = is_valid_transition(os, ns);
+	if (rv < SS_SUCCESS)
+		goto abort;
 
 	if (cl_wide_st_chg(mdev, os, ns)) {
 		rv = is_valid_state(mdev, ns);
@@ -340,6 +345,8 @@ is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
 
 /**
  * is_valid_soft_transition() - Returns an SS_ error code if the state transition is not possible
+ * This function limits state transitions that may be declined by DRBD. I.e.
+ * user requests (aka soft transitions).
  * @mdev:	DRBD device.
  * @ns:		new state.
  * @os:		old state.
@@ -390,6 +397,40 @@ is_valid_soft_transition(union drbd_state os, union drbd_state ns)
 }
 
 /**
+ * is_valid_transition() - Returns an SS_ error code if the state transition is not possible
+ * This limits hard state transitions. Hard state transitions are facts there are
+ * imposed on DRBD by the environment. E.g. disk broke or network broke down.
+ * But those hard state transitions are still not allowed to do everything.
+ * @ns:		new state.
+ * @os:		old state.
+ */
+static enum drbd_state_rv
+is_valid_transition(union drbd_state os, union drbd_state ns)
+{
+	enum drbd_state_rv rv = SS_SUCCESS;
+
+	/* Disallow Network errors to configure a device's network part */
+	if ((ns.conn >= C_TIMEOUT && ns.conn <= C_TEAR_DOWN) &&
+	    os.conn <= C_DISCONNECTING)
+		rv = SS_NEED_CONNECTION;
+
+	/* After a network error only C_UNCONNECTED or C_DISCONNECTING may follow. */
+	if (os.conn >= C_TIMEOUT && os.conn <= C_TEAR_DOWN &&
+	    ns.conn != C_UNCONNECTED && ns.conn != C_DISCONNECTING)
+		rv = SS_IN_TRANSIENT_STATE;
+
+	/* After C_DISCONNECTING only C_STANDALONE may follow */
+	if (os.conn == C_DISCONNECTING && ns.conn != C_STANDALONE)
+		rv = SS_IN_TRANSIENT_STATE;
+
+	/* we cannot fail (again) if we already detached */
+	if (ns.disk == D_FAILED && os.disk == D_DISKLESS)
+		rv = SS_IS_DISKLESS;
+
+	return rv;
+}
+
+/**
  * sanitize_state() - Resolves implicitly necessary additional changes to a state transition
  * @mdev:	DRBD device.
  * @os:		old state.
@@ -411,30 +452,12 @@ static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state
 		put_ldev(mdev);
 	}
 
-	/* Disallow Network errors to configure a device's network part */
-	if ((ns.conn >= C_TIMEOUT && ns.conn <= C_TEAR_DOWN) &&
-	    os.conn <= C_DISCONNECTING)
-		ns.conn = os.conn;
-
-	/* After a network error (+C_TEAR_DOWN) only C_UNCONNECTED or C_DISCONNECTING can follow.
-	 * If you try to go into some Sync* state, that shall fail (elsewhere). */
-	if (os.conn >= C_TIMEOUT && os.conn <= C_TEAR_DOWN &&
-	    ns.conn != C_UNCONNECTED && ns.conn != C_DISCONNECTING && ns.conn <= C_TEAR_DOWN)
-		ns.conn = os.conn;
-
-	/* we cannot fail (again) if we already detached */
-	if (ns.disk == D_FAILED && os.disk == D_DISKLESS)
-		ns.disk = D_DISKLESS;
-
 	/* if we are only D_ATTACHING yet,
 	 * we can (and should) go directly to D_DISKLESS. */
 	if (ns.disk == D_FAILED && os.disk == D_ATTACHING)
 		ns.disk = D_DISKLESS;
 
-	/* After C_DISCONNECTING only C_STANDALONE may follow */
-	if (os.conn == C_DISCONNECTING && ns.conn != C_STANDALONE)
-		ns.conn = os.conn;
-
+	/* Implications from connection to peer and peer_isp */
 	if (ns.conn < C_CONNECTED) {
 		ns.peer_isp = 0;
 		ns.peer = R_UNKNOWN;
@@ -641,6 +664,10 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	if (ns.i == os.i)
 		return SS_NOTHING_TO_DO;
 
+	rv = is_valid_transition(os, ns);
+	if (rv < SS_SUCCESS)
+		return rv;
+
 	if (!(flags & CS_HARD)) {
 		/*  pre-state-change checks ; only look at ns  */
 		/* See drbd_state_sw_errors in drbd_strings.c */
-- 
1.7.4.1

