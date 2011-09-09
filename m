Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab1IILRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:17:47 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45615 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758767Ab1IILRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:17:40 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/11] drbd: Introduced a new type union drbd_dev_state
Date: Fri,  9 Sep 2011 13:17:29 +0200
Message-Id: <1315567056-32314-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
References: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h   |    6 +++---
 drivers/block/drbd/drbd_main.c  |    5 +----
 drivers/block/drbd/drbd_nl.c    |    4 ++--
 drivers/block/drbd/drbd_req.h   |    4 ++--
 drivers/block/drbd/drbd_state.c |    6 +++---
 drivers/block/drbd/drbd_state.h |   34 ++++++++++++++++++++++++++++++++++
 6 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e33a770..912ee5e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -935,7 +935,7 @@ struct drbd_conf {
 	/* Used after attach while negotiating new disk state. */
 	union drbd_state new_state_tmp;
 
-	union drbd_state state;
+	union drbd_dev_state state;
 	wait_queue_head_t misc_wait;
 	wait_queue_head_t state_wait;  /* upon each state change. */
 	unsigned int send_cnt;
@@ -1689,7 +1689,7 @@ static inline union drbd_state drbd_read_state(struct drbd_conf *mdev)
 {
 	union drbd_state rv;
 
-	rv = mdev->state;
+	rv.i = mdev->state.i;
 	rv.susp = mdev->tconn->susp;
 	rv.susp_nod = mdev->tconn->susp_nod;
 	rv.susp_fen = mdev->tconn->susp_fen;
@@ -2155,7 +2155,7 @@ static inline int drbd_get_max_buffers(struct drbd_conf *mdev)
 
 static inline int drbd_state_is_stable(struct drbd_conf *mdev)
 {
-	union drbd_state s = mdev->state;
+	union drbd_dev_state s = mdev->state;
 
 	/* DO NOT add a default clause, we want the compiler to warn us
 	 * for any newly introduced state we may have forgotten to add here */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a773d73..a6459f7 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1823,15 +1823,12 @@ static void drbd_set_defaults(struct drbd_conf *mdev)
 {
 	/* Beware! The actual layout differs
 	 * between big endian and little endian */
-	mdev->state = (union drbd_state) {
+	mdev->state = (union drbd_dev_state) {
 		{ .role = R_SECONDARY,
 		  .peer = R_UNKNOWN,
 		  .conn = C_STANDALONE,
 		  .disk = D_DISKLESS,
 		  .pdsk = D_UNKNOWN,
-		  .susp = 0,
-		  .susp_nod = 0,
-		  .susp_fen = 0
 		} };
 }
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 57f320e..02d4224 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1475,7 +1475,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		clear_bit(CRASHED_PRIMARY, &mdev->flags);
 
 	if (drbd_md_test_flag(mdev->ldev, MDF_PRIMARY_IND) &&
-	    !(mdev->state.role == R_PRIMARY && mdev->state.susp_nod)) {
+	    !(mdev->state.role == R_PRIMARY && mdev->tconn->susp_nod)) {
 		set_bit(CRASHED_PRIMARY, &mdev->flags);
 		cp_discovered = 1;
 	}
@@ -2402,7 +2402,7 @@ out:
 
 int drbd_adm_resume_sync(struct sk_buff *skb, struct genl_info *info)
 {
-	union drbd_state s;
+	union drbd_dev_state s;
 	enum drbd_ret_code retcode;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_MINOR);
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 4e1f129..b9f474a 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -294,7 +294,7 @@ static inline int req_mod(struct drbd_request *req,
 	return rv;
 }
 
-static inline bool drbd_should_do_remote(union drbd_state s)
+static inline bool drbd_should_do_remote(union drbd_dev_state s)
 {
 	return s.pdsk == D_UP_TO_DATE ||
 		(s.pdsk >= D_INCONSISTENT &&
@@ -304,7 +304,7 @@ static inline bool drbd_should_do_remote(union drbd_state s)
 	   That is equivalent since before 96 IO was frozen in the C_WF_BITMAP*
 	   states. */
 }
-static inline bool drbd_should_send_out_of_sync(union drbd_state s)
+static inline bool drbd_should_send_out_of_sync(union drbd_dev_state s)
 {
 	return s.conn == C_AHEAD || s.conn == C_WF_BITMAP_S;
 	/* pdsk = D_INCONSISTENT as a consequence. Protocol 96 check not necessary
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 9354006..64284b8 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -842,7 +842,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	    (os.disk != D_DISKLESS && ns.disk == D_DISKLESS))
 		atomic_inc(&mdev->local_cnt);
 
-	mdev->state = ns;
+	mdev->state.i = ns.i;
 	mdev->tconn->susp = ns.susp;
 	mdev->tconn->susp_nod = ns.susp_nod;
 	mdev->tconn->susp_fen = ns.susp_fen;
@@ -1375,7 +1375,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum chg_state_flags *pf)
 {
 	enum chg_state_flags flags = ~0;
-	union drbd_state os, cs = {}; /* old_state, common_state */
+	union drbd_dev_state os, cs = {}; /* old_state, common_state */
 	struct drbd_conf *mdev;
 	int vnr, first_vol = 1;
 
@@ -1406,7 +1406,7 @@ void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum
 
 	*pf |= CS_DC_MASK;
 	*pf &= flags;
-	*pcs = cs;
+	(*pcs).i = cs.i;
 }
 
 static enum drbd_state_rv
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index fdcfab9..0f8441d 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -72,6 +72,40 @@ enum chg_state_flags {
 	CS_IGN_OUTD_FAIL = 1 << 10,
 };
 
+/* drbd_dev_state and drbd_state are different types. This is to stress the
+   small difference. There is no suspended flag (.susp), and no suspended
+   while fence handler runs flas (susp_fen). */
+union drbd_dev_state {
+	struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+		unsigned role:2 ;   /* 3/4	 primary/secondary/unknown */
+		unsigned peer:2 ;   /* 3/4	 primary/secondary/unknown */
+		unsigned conn:5 ;   /* 17/32	 cstates */
+		unsigned disk:4 ;   /* 8/16	 from D_DISKLESS to D_UP_TO_DATE */
+		unsigned pdsk:4 ;   /* 8/16	 from D_DISKLESS to D_UP_TO_DATE */
+		unsigned _unused:1 ;
+		unsigned aftr_isp:1 ; /* isp .. imposed sync pause */
+		unsigned peer_isp:1 ;
+		unsigned user_isp:1 ;
+		unsigned _pad:11;   /* 0	 unused */
+#elif defined(__BIG_ENDIAN_BITFIELD)
+		unsigned _pad:11;
+		unsigned user_isp:1 ;
+		unsigned peer_isp:1 ;
+		unsigned aftr_isp:1 ; /* isp .. imposed sync pause */
+		unsigned _unused:1 ;
+		unsigned pdsk:4 ;   /* 8/16	 from D_DISKLESS to D_UP_TO_DATE */
+		unsigned disk:4 ;   /* 8/16	 from D_DISKLESS to D_UP_TO_DATE */
+		unsigned conn:5 ;   /* 17/32	 cstates */
+		unsigned peer:2 ;   /* 3/4	 primary/secondary/unknown */
+		unsigned role:2 ;   /* 3/4	 primary/secondary/unknown */
+#else
+# error "this endianess is not supported"
+#endif
+	};
+	unsigned int i;
+};
+
 extern enum drbd_state_rv drbd_change_state(struct drbd_conf *mdev,
 					    enum chg_state_flags f,
 					    union drbd_state mask,
-- 
1.7.4.1

