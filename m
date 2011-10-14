Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab1JNV54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:57:56 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60866 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1JNV5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:57:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/11] drbd: Correctly handle resources without volumes
Date: Fri, 14 Oct 2011 23:57:42 +0200
Message-Id: <1318629472-11110-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
References: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c    |    3 ++-
 drivers/block/drbd/drbd_state.c |   17 +++++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 20fa803..a71a5f5 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1119,7 +1119,8 @@ static void conn_reconfig_done(struct drbd_tconn *tconn)
 {
 	bool stop_threads;
 	spin_lock_irq(&tconn->req_lock);
-	stop_threads = conn_all_vols_unconf(tconn);
+	stop_threads = conn_all_vols_unconf(tconn) &&
+		tconn->cstate == C_STANDALONE;
 	spin_unlock_irq(&tconn->req_lock);
 	if (stop_threads) {
 		/* asender is implicitly stopped by receiver
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index c4dd667..eafc195 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1491,9 +1491,15 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum chg_state_flags *pf)
 {
 	enum chg_state_flags flags = ~0;
-	union drbd_dev_state os, cs = {}; /* old_state, common_state */
 	struct drbd_conf *mdev;
 	int vnr, first_vol = 1;
+	union drbd_dev_state os, cs = {
+		{ .role = R_SECONDARY,
+		  .peer = R_UNKNOWN,
+		  .conn = tconn->cstate,
+		  .disk = D_DISKLESS,
+		  .pdsk = D_UNKNOWN,
+		} };
 
 	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
@@ -1574,10 +1580,17 @@ void
 conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
 	       union drbd_state *pns_min, union drbd_state *pns_max, enum chg_state_flags flags)
 {
-	union drbd_state ns, os, ns_max = { };
+	union drbd_state ns, os, ns_max = {
+		{ .role = R_SECONDARY,
+		  .peer = R_UNKNOWN,
+		  .conn = val.conn,
+		  .disk = D_DISKLESS,
+		  .pdsk = D_UNKNOWN
+		} };
 	union drbd_state ns_min = {
 		{ .role = R_MASK,
 		  .peer = R_MASK,
+		  .conn = val.conn,
 		  .disk = D_MASK,
 		  .pdsk = D_MASK
 		} };
-- 
1.7.4.1

