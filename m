Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab1IHMuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:50:17 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37518 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642Ab1IHMpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:40 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/16] drbd: Fixed logging of old connection state
Date: Thu,  8 Sep 2011 14:45:23 +0200
Message-Id: <1315485937-18989-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
References: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During a disconnect the oc variable in _conn_request_state()
could become outdated. Determin the common old state after
sleeping.
While at it, I implemented that for all parts of the state

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |  117 +++++++++++++++++++++++++++++----------
 1 files changed, 87 insertions(+), 30 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index e712da7..3c3c141 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1359,42 +1359,100 @@ static void print_conn_state_change(struct drbd_tconn *tconn, enum drbd_conns oc
 	conn_info(tconn, "%s\n", pb);
 }
 
-struct _is_valid_itr_params {
-	enum drbd_conns oc;
-	enum {
-		OC_UNINITIALIZED,
-		OC_CONSISTENT,
-		OC_INCONSISTENT,
-	} oc_state;
-};
+enum sp_state {
+	OC_UNINITIALIZED,
+	OC_CONSISTENT,
+	OC_INCONSISTENT,
+} oc_state;
+
+static void common_state_part(enum sp_state *sps, int *sp, int nsp)
+{
+	switch (*sps) {
+	case OC_UNINITIALIZED:
+		*sp = nsp;
+		*sps = OC_CONSISTENT;
+		break;
+	case OC_CONSISTENT:
+		if (*sp != nsp)
+			*sps = OC_INCONSISTENT;
+		break;
+	case OC_INCONSISTENT:
+		break;
+	}
+}
+
+void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, union drbd_state *pmask)
+{
+	union drbd_state css = {}; /* common state state */
+	union drbd_state os, cs = {}; /* old_state, common_state */
+	union drbd_state mask = {};
+	enum sp_state sps;       /* state part state */
+	int sp;                  /* state part */
+	struct drbd_conf *mdev;
+	int vnr;
+
+	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
+		os = mdev->state;
+
+		sps = css.role;
+		sp = cs.role;
+		common_state_part(&sps, &sp, os.role);
+		css.role = sps;
+		cs.role = sp;
+
+		sps = css.peer;
+		sp = cs.peer;
+		common_state_part(&sps, &sp, os.peer);
+		css.peer = sps;
+		cs.peer = sp;
+
+		sps = css.conn;
+		sp = cs.conn;
+		common_state_part(&sps, &sp, os.conn);
+		css.conn = sps;
+		cs.conn = sp;
+
+		sps = css.disk;
+		sp = cs.disk;
+		common_state_part(&sps, &sp, os.disk);
+		css.disk = sps;
+		cs.disk = sp;
+
+		sps = css.pdsk;
+		sp = cs.pdsk;
+		common_state_part(&sps, &sp, os.pdsk);
+		css.pdsk = sps;
+		cs.pdsk = sp;
+	}
+
+	if (css.role == OC_CONSISTENT)
+		mask.role = R_MASK;
+	if (css.peer == OC_CONSISTENT)
+		mask.peer = R_MASK;
+	if (css.conn == OC_CONSISTENT)
+		mask.conn = C_MASK;
+	if (css.disk == OC_CONSISTENT)
+		mask.disk = D_MASK;
+	if (css.pdsk == OC_CONSISTENT)
+		mask.pdsk = D_MASK;
+
+	*pcs = cs;
+	*pmask = mask;
+}
 
 static enum drbd_state_rv
 conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
-			 enum chg_state_flags flags, struct _is_valid_itr_params *params)
+			 enum chg_state_flags flags)
 {
 	enum drbd_state_rv rv = SS_SUCCESS;
 	union drbd_state ns, os;
 	struct drbd_conf *mdev;
 	int vnr;
 
-	params->oc_state = OC_UNINITIALIZED;
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		os = mdev->state;
 		ns = sanitize_state(mdev, apply_mask_val(os, mask, val), NULL);
 
-		switch (params->oc_state) {
-		case OC_UNINITIALIZED:
-			params->oc = os.conn;
-			params->oc_state = OC_CONSISTENT;
-			break;
-		case OC_CONSISTENT:
-			if (params->oc != os.conn)
-				params->oc_state = OC_INCONSISTENT;
-			break;
-		case OC_INCONSISTENT:
-			break;
-		}
-
 		if (ns.i == os.i)
 			continue;
 
@@ -1452,7 +1510,6 @@ conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 static enum drbd_state_rv
 _conn_rq_cond(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val)
 {
-	struct _is_valid_itr_params params;
 	enum drbd_conns oc = tconn->cstate;
 	enum drbd_state_rv rv;
 
@@ -1466,7 +1523,7 @@ _conn_rq_cond(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 	rv = oc != C_WF_REPORT_PARAMS ? SS_CW_NO_NEED : SS_UNKNOWN_ERROR;
 
 	if (rv == SS_UNKNOWN_ERROR)
-		rv = conn_is_valid_transition(tconn, mask, val, CS_NO_CSTATE_CHG, &params);
+		rv = conn_is_valid_transition(tconn, mask, val, CS_NO_CSTATE_CHG);
 
 	if (rv == SS_SUCCESS)
 		rv = SS_UNKNOWN_ERROR; /* cont waiting, otherwise fail. */
@@ -1506,16 +1563,15 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 		    enum chg_state_flags flags)
 {
 	enum drbd_state_rv rv = SS_SUCCESS;
-	struct _is_valid_itr_params params;
 	struct after_conn_state_chg_work *acscw;
 	enum drbd_conns oc = tconn->cstate;
-	union drbd_state ms;
+	union drbd_state ms, os_val, os_mask;
 
 	rv = is_valid_conn_transition(oc, val.conn);
 	if (rv < SS_SUCCESS)
 		goto abort;
 
-	rv = conn_is_valid_transition(tconn, mask, val, flags, &params);
+	rv = conn_is_valid_transition(tconn, mask, val, flags);
 	if (rv < SS_SUCCESS)
 		goto abort;
 
@@ -1525,8 +1581,9 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 			goto abort;
 	}
 
-	if (params.oc_state == OC_CONSISTENT) {
-		oc = params.oc;
+	conn_old_common_state(tconn, &os_val, &os_mask);
+	if (os_mask.conn == C_MASK) {
+		oc = os_val.conn;
 		print_conn_state_change(tconn, oc, val.conn);
 		flags |= CS_NO_CSTATE_CHG;
 	}
-- 
1.7.4.1

