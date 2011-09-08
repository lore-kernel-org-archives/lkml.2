Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab1IHMuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:50:15 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37520 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab1IHMpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:40 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/16] drbd: Print common state changes of all volumes as connection state changes
Date: Thu,  8 Sep 2011 14:45:24 +0200
Message-Id: <1315485937-18989-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
References: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |  159 ++++++++++++++-------------------------
 drivers/block/drbd/drbd_state.h |   19 +++--
 2 files changed, 70 insertions(+), 108 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 3c3c141..ea2bf74 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -332,29 +332,29 @@ void print_st_err(struct drbd_conf *mdev, union drbd_state os,
 	print_st(mdev, "wanted", ns);
 }
 
-static void print_state_change(struct drbd_conf *mdev, union drbd_state os, union drbd_state ns,
+static long print_state_change(char *pb, union drbd_state os, union drbd_state ns,
 			       enum chg_state_flags flags)
 {
-	char *pbp, pb[300];
+	char *pbp;
 	pbp = pb;
 	*pbp = 0;
-	if (ns.role != os.role)
+	if (ns.role != os.role && flags & CS_DC_ROLE)
 		pbp += sprintf(pbp, "role( %s -> %s ) ",
 			       drbd_role_str(os.role),
 			       drbd_role_str(ns.role));
-	if (ns.peer != os.peer)
+	if (ns.peer != os.peer && flags & CS_DC_PEER)
 		pbp += sprintf(pbp, "peer( %s -> %s ) ",
 			       drbd_role_str(os.peer),
 			       drbd_role_str(ns.peer));
-	if (ns.conn != os.conn && !(flags & CS_NO_CSTATE_CHG))
+	if (ns.conn != os.conn && flags & CS_DC_CONN)
 		pbp += sprintf(pbp, "conn( %s -> %s ) ",
 			       drbd_conn_str(os.conn),
 			       drbd_conn_str(ns.conn));
-	if (ns.disk != os.disk)
+	if (ns.disk != os.disk && flags & CS_DC_DISK)
 		pbp += sprintf(pbp, "disk( %s -> %s ) ",
 			       drbd_disk_str(os.disk),
 			       drbd_disk_str(ns.disk));
-	if (ns.pdsk != os.pdsk)
+	if (ns.pdsk != os.pdsk && flags & CS_DC_PDSK)
 		pbp += sprintf(pbp, "pdsk( %s -> %s ) ",
 			       drbd_disk_str(os.pdsk),
 			       drbd_disk_str(ns.pdsk));
@@ -374,10 +374,29 @@ static void print_state_change(struct drbd_conf *mdev, union drbd_state os, unio
 		pbp += sprintf(pbp, "user_isp( %d -> %d ) ",
 			       os.user_isp,
 			       ns.user_isp);
-	if (pbp != pb)
+
+	return pbp - pb;
+}
+
+static void drbd_pr_state_change(struct drbd_conf *mdev, union drbd_state os, union drbd_state ns,
+				 enum chg_state_flags flags)
+{
+	char pb[300];
+
+	if (print_state_change(pb, os, ns, flags ^ CS_DC_MASK))
 		dev_info(DEV, "%s\n", pb);
 }
 
+static void conn_pr_state_change(struct drbd_tconn *tconn, union drbd_state os, union drbd_state ns,
+				 enum chg_state_flags flags)
+{
+	char pb[300];
+
+	if (print_state_change(pb, os, ns, flags))
+		conn_info(tconn, "%s\n", pb);
+}
+
+
 /**
  * is_valid_state() - Returns an SS_ error code if ns is not valid
  * @mdev:	DRBD device.
@@ -809,7 +828,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	if (warn_sync_abort)
 		dev_warn(DEV, "%s aborted.\n", warn_sync_abort);
 
-	print_state_change(mdev, os, ns, flags);
+	drbd_pr_state_change(mdev, os, ns, flags);
 
 	/* if we are going -> D_FAILED or D_DISKLESS, grab one extra reference
 	 * on the ldev here, to be sure the transition -> D_DISKLESS resp.
@@ -1346,98 +1365,41 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 	return 0;
 }
 
-static void print_conn_state_change(struct drbd_tconn *tconn, enum drbd_conns oc, enum drbd_conns nc)
-{
-	char *pbp, pb[300];
-	pbp = pb;
-	*pbp = 0;
-	if (nc != oc)
-		pbp += sprintf(pbp, "conn( %s -> %s ) ",
-			       drbd_conn_str(oc),
-			       drbd_conn_str(nc));
-
-	conn_info(tconn, "%s\n", pb);
-}
-
-enum sp_state {
-	OC_UNINITIALIZED,
-	OC_CONSISTENT,
-	OC_INCONSISTENT,
-} oc_state;
-
-static void common_state_part(enum sp_state *sps, int *sp, int nsp)
-{
-	switch (*sps) {
-	case OC_UNINITIALIZED:
-		*sp = nsp;
-		*sps = OC_CONSISTENT;
-		break;
-	case OC_CONSISTENT:
-		if (*sp != nsp)
-			*sps = OC_INCONSISTENT;
-		break;
-	case OC_INCONSISTENT:
-		break;
-	}
-}
-
-void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, union drbd_state *pmask)
+void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum chg_state_flags *pf)
 {
-	union drbd_state css = {}; /* common state state */
+	enum chg_state_flags flags = ~0;
 	union drbd_state os, cs = {}; /* old_state, common_state */
-	union drbd_state mask = {};
-	enum sp_state sps;       /* state part state */
-	int sp;                  /* state part */
 	struct drbd_conf *mdev;
-	int vnr;
+	int vnr, first_vol = 1;
 
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		os = mdev->state;
 
-		sps = css.role;
-		sp = cs.role;
-		common_state_part(&sps, &sp, os.role);
-		css.role = sps;
-		cs.role = sp;
-
-		sps = css.peer;
-		sp = cs.peer;
-		common_state_part(&sps, &sp, os.peer);
-		css.peer = sps;
-		cs.peer = sp;
-
-		sps = css.conn;
-		sp = cs.conn;
-		common_state_part(&sps, &sp, os.conn);
-		css.conn = sps;
-		cs.conn = sp;
-
-		sps = css.disk;
-		sp = cs.disk;
-		common_state_part(&sps, &sp, os.disk);
-		css.disk = sps;
-		cs.disk = sp;
-
-		sps = css.pdsk;
-		sp = cs.pdsk;
-		common_state_part(&sps, &sp, os.pdsk);
-		css.pdsk = sps;
-		cs.pdsk = sp;
-	}
+		if (first_vol) {
+			cs = os;
+			first_vol = 0;
+			continue;
+		}
+
+		if (cs.role != os.role)
+			flags &= ~CS_DC_ROLE;
+
+		if (cs.peer != os.peer)
+			flags &= ~CS_DC_PEER;
+
+		if (cs.conn != os.conn)
+			flags &= ~CS_DC_CONN;
 
-	if (css.role == OC_CONSISTENT)
-		mask.role = R_MASK;
-	if (css.peer == OC_CONSISTENT)
-		mask.peer = R_MASK;
-	if (css.conn == OC_CONSISTENT)
-		mask.conn = C_MASK;
-	if (css.disk == OC_CONSISTENT)
-		mask.disk = D_MASK;
-	if (css.pdsk == OC_CONSISTENT)
-		mask.pdsk = D_MASK;
+		if (cs.disk != os.disk)
+			flags &= ~CS_DC_DISK;
 
+		if (cs.pdsk != os.pdsk)
+			flags &= ~CS_DC_PDSK;
+	}
+
+	*pf |= CS_DC_MASK;
+	*pf &= flags;
 	*pcs = cs;
-	*pmask = mask;
 }
 
 static enum drbd_state_rv
@@ -1523,7 +1485,7 @@ _conn_rq_cond(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 	rv = oc != C_WF_REPORT_PARAMS ? SS_CW_NO_NEED : SS_UNKNOWN_ERROR;
 
 	if (rv == SS_UNKNOWN_ERROR)
-		rv = conn_is_valid_transition(tconn, mask, val, CS_NO_CSTATE_CHG);
+		rv = conn_is_valid_transition(tconn, mask, val, 0);
 
 	if (rv == SS_SUCCESS)
 		rv = SS_UNKNOWN_ERROR; /* cont waiting, otherwise fail. */
@@ -1565,7 +1527,7 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 	enum drbd_state_rv rv = SS_SUCCESS;
 	struct after_conn_state_chg_work *acscw;
 	enum drbd_conns oc = tconn->cstate;
-	union drbd_state ms, os_val, os_mask;
+	union drbd_state ms, os;
 
 	rv = is_valid_conn_transition(oc, val.conn);
 	if (rv < SS_SUCCESS)
@@ -1581,19 +1543,14 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 			goto abort;
 	}
 
-	conn_old_common_state(tconn, &os_val, &os_mask);
-	if (os_mask.conn == C_MASK) {
-		oc = os_val.conn;
-		print_conn_state_change(tconn, oc, val.conn);
-		flags |= CS_NO_CSTATE_CHG;
-	}
-
+	conn_old_common_state(tconn, &os, &flags);
 	ms = conn_set_state(tconn, mask, val, flags);
 	ms.conn = val.conn;
+	conn_pr_state_change(tconn, os, ms, flags);
 
 	acscw = kmalloc(sizeof(*acscw), GFP_ATOMIC);
 	if (acscw) {
-		acscw->oc = oc;
+		acscw->oc = os.conn;
 		acscw->nms = ms;
 		acscw->flags = flags;
 		acscw->w.cb = w_after_conn_state_ch;
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index 394a199..11fd0f8 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -57,13 +57,18 @@ struct drbd_tconn;
 	__ns.T2 = (S2); __ns.T3 = (S3); __ns; })
 
 enum chg_state_flags {
-	CS_HARD	= 1,
-	CS_VERBOSE = 2,
-	CS_WAIT_COMPLETE = 4,
-	CS_SERIALIZE    = 8,
-	CS_ORDERED      = CS_WAIT_COMPLETE + CS_SERIALIZE,
-	CS_NO_CSTATE_CHG = 16, /* Do not display changes in cstate. Internal to drbd_state.c */
-	CS_LOCAL_ONLY = 32, /* Do not consider a device pair wide state change */
+	CS_HARD	         = 1 << 0,
+	CS_VERBOSE       = 1 << 1,
+	CS_WAIT_COMPLETE = 1 << 2,
+	CS_SERIALIZE     = 1 << 3,
+	CS_ORDERED       = CS_WAIT_COMPLETE + CS_SERIALIZE,
+	CS_LOCAL_ONLY    = 1 << 4, /* Do not consider a device pair wide state change */
+	CS_DC_ROLE       = 1 << 5, /* DC = display as connection state change */
+	CS_DC_PEER       = 1 << 6,
+	CS_DC_CONN       = 1 << 7,
+	CS_DC_DISK       = 1 << 8,
+	CS_DC_PDSK       = 1 << 9,
+	CS_DC_MASK       = CS_DC_ROLE + CS_DC_PEER + CS_DC_CONN + CS_DC_DISK + CS_DC_PDSK,
 };
 
 extern enum drbd_state_rv drbd_change_state(struct drbd_conf *mdev,
-- 
1.7.4.1

