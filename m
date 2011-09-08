Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab1IHMpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:45:42 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37516 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640Ab1IHMpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:40 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: =?UTF-8?q?=5BPATCH=2001/16=5D=20drbd=3A=20Use=20the=20idr=5Ffor=5Feach=5Fentry=28=29=20iterator=20instead=20of=20idr=5Ffor=5Feach=28=29?=
Date: Thu,  8 Sep 2011 14:45:22 +0200
Message-Id: <1315485937-18989-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
References: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |  149 +++++++++++++++++++--------------------
 1 files changed, 74 insertions(+), 75 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 9159043..e712da7 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1360,9 +1360,6 @@ static void print_conn_state_change(struct drbd_tconn *tconn, enum drbd_conns oc
 }
 
 struct _is_valid_itr_params {
-	enum chg_state_flags flags;
-	union drbd_state mask, val;
-	union drbd_state ms; /* maximal state, over all mdevs */
 	enum drbd_conns oc;
 	enum {
 		OC_UNINITIALIZED,
@@ -1371,69 +1368,85 @@ struct _is_valid_itr_params {
 	} oc_state;
 };
 
-static int _is_valid_itr_fn(int vnr, void *p, void *data)
+static enum drbd_state_rv
+conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+			 enum chg_state_flags flags, struct _is_valid_itr_params *params)
 {
-	struct drbd_conf *mdev = (struct drbd_conf *)p;
-	struct _is_valid_itr_params *params = (struct _is_valid_itr_params *)data;
-	enum chg_state_flags flags = params->flags;
+	enum drbd_state_rv rv = SS_SUCCESS;
 	union drbd_state ns, os;
-	enum drbd_state_rv rv;
-
-	os = mdev->state;
-	ns = apply_mask_val(os, params->mask, params->val);
-	ns = sanitize_state(mdev, ns, NULL);
-	rv = is_valid_state(mdev, ns);
+	struct drbd_conf *mdev;
+	int vnr;
 
-	if (rv < SS_SUCCESS) {
-		/* If the old state was illegal as well, then let this happen...*/
+	params->oc_state = OC_UNINITIALIZED;
+	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
+		os = mdev->state;
+		ns = sanitize_state(mdev, apply_mask_val(os, mask, val), NULL);
+
+		switch (params->oc_state) {
+		case OC_UNINITIALIZED:
+			params->oc = os.conn;
+			params->oc_state = OC_CONSISTENT;
+			break;
+		case OC_CONSISTENT:
+			if (params->oc != os.conn)
+				params->oc_state = OC_INCONSISTENT;
+			break;
+		case OC_INCONSISTENT:
+			break;
+		}
 
-		if (is_valid_state(mdev, os) == rv)
-			rv = is_valid_soft_transition(os, ns);
-	} else
-		rv = is_valid_soft_transition(os, ns);
+		if (ns.i == os.i)
+			continue;
 
-	switch (params->oc_state) {
-	case OC_UNINITIALIZED:
-		params->oc = os.conn;
-		params->oc_state = OC_CONSISTENT;
-		break;
-	case OC_CONSISTENT:
-		if (params->oc != os.conn)
-			params->oc_state = OC_INCONSISTENT;
-		break;
-	case OC_INCONSISTENT:
-		break;
+		rv = is_valid_transition(os, ns);
+		if (rv < SS_SUCCESS)
+			break;
+
+		if (!(flags & CS_HARD)) {
+			rv = is_valid_state(mdev, ns);
+			if (rv < SS_SUCCESS) {
+				if (is_valid_state(mdev, os) == rv)
+					rv = is_valid_soft_transition(os, ns);
+			} else
+				rv = is_valid_soft_transition(os, ns);
+		}
+		if (rv < SS_SUCCESS)
+			break;
 	}
 
-	if (rv < SS_SUCCESS) {
-		if (flags & CS_VERBOSE)
-			print_st_err(mdev, os, ns, rv);
-		return rv;
-	} else
-		return 0;
+	if (rv < SS_SUCCESS && flags & CS_VERBOSE)
+		print_st_err(mdev, os, ns, rv);
+
+	return rv;
 }
 
-static int _set_state_itr_fn(int vnr, void *p, void *data)
+static union drbd_state
+conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+	       enum chg_state_flags flags)
 {
-	struct drbd_conf *mdev = (struct drbd_conf *)p;
-	struct _is_valid_itr_params *params = (struct _is_valid_itr_params *)data;
-	enum chg_state_flags flags = params->flags;
-	union drbd_state os, ns, ms = params->ms;
+	union drbd_state ns, os, ms = { };
+	struct drbd_conf *mdev;
 	enum drbd_state_rv rv;
+	int vnr;
 
-	os = mdev->state;
-	ns = apply_mask_val(os, params->mask, params->val);
-	ns = sanitize_state(mdev, ns, NULL);
+	tconn->cstate = val.conn;
 
-	rv = __drbd_set_state(mdev, ns, flags, NULL);
+	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
+		os = mdev->state;
+		ns = apply_mask_val(os, mask, val);
+		ns = sanitize_state(mdev, ns, NULL);
 
-	ms.role = max_t(enum drbd_role, mdev->state.role, ms.role);
-	ms.peer = max_t(enum drbd_role, mdev->state.peer, ms.peer);
-	ms.disk = max_t(enum drbd_role, mdev->state.disk, ms.disk);
-	ms.pdsk = max_t(enum drbd_role, mdev->state.pdsk, ms.pdsk);
-	params->ms = ms;
+		rv = __drbd_set_state(mdev, ns, flags, NULL);
+		if (rv < SS_SUCCESS)
+			BUG();
 
-	return 0;
+		ms.role = max_t(enum drbd_role, mdev->state.role, ms.role);
+		ms.peer = max_t(enum drbd_role, mdev->state.peer, ms.peer);
+		ms.disk = max_t(enum drbd_disk_state, mdev->state.disk, ms.disk);
+		ms.pdsk = max_t(enum drbd_disk_state, mdev->state.pdsk, ms.pdsk);
+	}
+
+	return ms;
 }
 
 static enum drbd_state_rv
@@ -1449,18 +1462,14 @@ _conn_rq_cond(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 	if (test_and_clear_bit(CONN_WD_ST_CHG_FAIL, &tconn->flags))
 		return SS_CW_FAILED_BY_PEER;
 
-	params.flags = CS_NO_CSTATE_CHG; /* öö think */
-	params.mask = mask;
-	params.val = val;
-
 	spin_lock_irq(&tconn->req_lock);
 	rv = oc != C_WF_REPORT_PARAMS ? SS_CW_NO_NEED : SS_UNKNOWN_ERROR;
 
 	if (rv == SS_UNKNOWN_ERROR)
-		rv = idr_for_each(&tconn->volumes, _is_valid_itr_fn, &params);
+		rv = conn_is_valid_transition(tconn, mask, val, CS_NO_CSTATE_CHG, &params);
 
-	if (rv == 0)  /* idr_for_each semantics */
-		rv = SS_UNKNOWN_ERROR;  /* cont waiting, otherwise fail. */
+	if (rv == SS_SUCCESS)
+		rv = SS_UNKNOWN_ERROR; /* cont waiting, otherwise fail. */
 
 	spin_unlock_irq(&tconn->req_lock);
 
@@ -1500,22 +1509,13 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 	struct _is_valid_itr_params params;
 	struct after_conn_state_chg_work *acscw;
 	enum drbd_conns oc = tconn->cstate;
+	union drbd_state ms;
 
 	rv = is_valid_conn_transition(oc, val.conn);
 	if (rv < SS_SUCCESS)
 		goto abort;
 
-	params.flags = flags;
-	params.mask = mask;
-	params.val = val;
-	params.oc_state = OC_UNINITIALIZED;
-
-	if (!(flags & CS_HARD))
-		rv = idr_for_each(&tconn->volumes, _is_valid_itr_fn, &params);
-
-	if (rv == 0)  /* idr_for_each semantics */
-		rv = SS_SUCCESS;
-
+	rv = conn_is_valid_transition(tconn, mask, val, flags, &params);
 	if (rv < SS_SUCCESS)
 		goto abort;
 
@@ -1528,17 +1528,16 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 	if (params.oc_state == OC_CONSISTENT) {
 		oc = params.oc;
 		print_conn_state_change(tconn, oc, val.conn);
-		params.flags |= CS_NO_CSTATE_CHG;
+		flags |= CS_NO_CSTATE_CHG;
 	}
-	tconn->cstate = val.conn;
-	params.ms.i = 0;
-	params.ms.conn = val.conn;
-	idr_for_each(&tconn->volumes, _set_state_itr_fn, &params);
+
+	ms = conn_set_state(tconn, mask, val, flags);
+	ms.conn = val.conn;
 
 	acscw = kmalloc(sizeof(*acscw), GFP_ATOMIC);
 	if (acscw) {
 		acscw->oc = oc;
-		acscw->nms = params.ms;
+		acscw->nms = ms;
 		acscw->flags = flags;
 		acscw->w.cb = w_after_conn_state_ch;
 		acscw->w.tconn = tconn;
-- 
1.7.4.1

