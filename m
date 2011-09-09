Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798Ab1IILTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:19:39 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45599 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758764Ab1IILRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:17:39 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/11] drbd: Renamed id_susp(union drbd_state s) to drbd_suspended(struct drbd_conf *)
Date: Fri,  9 Sep 2011 13:17:27 +0200
Message-Id: <1315567056-32314-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
References: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    6 +++---
 drivers/block/drbd/drbd_nl.c       |    4 ++--
 drivers/block/drbd/drbd_proc.c     |    2 +-
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 drivers/block/drbd/drbd_req.c      |    6 +++---
 drivers/block/drbd/drbd_state.c    |    7 ++++++-
 6 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index ca07afd..4d17f9b 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -2217,16 +2217,16 @@ static inline int drbd_state_is_stable(struct drbd_conf *mdev)
 	return 1;
 }
 
-static inline int is_susp(union drbd_state s)
+static inline int drbd_suspended(struct drbd_conf *mdev)
 {
-	return s.susp || s.susp_nod || s.susp_fen;
+	return mdev->state.susp || mdev->state.susp_nod || mdev->state.susp_fen;
 }
 
 static inline bool may_inc_ap_bio(struct drbd_conf *mdev)
 {
 	int mxb = drbd_get_max_buffers(mdev);
 
-	if (is_susp(mdev->state))
+	if (drbd_suspended(mdev))
 		return false;
 	if (test_bit(SUSPEND_IO, &mdev->flags))
 		return false;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index e43b47a..57f320e 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -757,7 +757,7 @@ char *ppsize(char *buf, unsigned long long size)
 void drbd_suspend_io(struct drbd_conf *mdev)
 {
 	set_bit(SUSPEND_IO, &mdev->flags);
-	if (is_susp(mdev->state))
+	if (drbd_suspended(mdev))
 		return;
 	wait_event(mdev->misc_wait, !atomic_read(&mdev->ap_bio_cnt));
 }
@@ -1395,7 +1395,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 
 	drbd_suspend_io(mdev);
 	/* also wait for the last barrier ack. */
-	wait_event(mdev->misc_wait, !atomic_read(&mdev->ap_pending_cnt) || is_susp(mdev->state));
+	wait_event(mdev->misc_wait, !atomic_read(&mdev->ap_pending_cnt) || drbd_suspended(mdev));
 	/* and for any other previously queued work */
 	drbd_flush_workqueue(mdev);
 
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 36c9a6c..a4dbdbc 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -250,7 +250,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 			   drbd_disk_str(mdev->state.pdsk),
 			   (mdev->tconn->net_conf == NULL ? ' ' :
 			    (mdev->tconn->net_conf->wire_protocol - DRBD_PROT_A+'A')),
-			   is_susp(mdev->state) ? 's' : 'r',
+			   drbd_suspended(mdev) ? 's' : 'r',
 			   mdev->state.aftr_isp ? 'a' : '-',
 			   mdev->state.peer_isp ? 'p' : '-',
 			   mdev->state.user_isp ? 'u' : '-',
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index cd0fe24..d6afb3a 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3571,7 +3571,7 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 	if ((ns.conn == C_CONNECTED || ns.conn == C_WF_BITMAP_S) && ns.disk == D_NEGOTIATING)
 		ns.disk = mdev->new_state_tmp.disk;
 	cs_flags = CS_VERBOSE + (os.conn < C_CONNECTED && ns.conn >= C_CONNECTED ? 0 : CS_HARD);
-	if (ns.pdsk == D_CONSISTENT && is_susp(ns) && ns.conn == C_CONNECTED && os.conn < C_CONNECTED &&
+	if (ns.pdsk == D_CONSISTENT && drbd_suspended(mdev) && ns.conn == C_CONNECTED && os.conn < C_CONNECTED &&
 	    test_bit(NEW_CUR_UUID, &mdev->flags)) {
 		/* Do not allow tl_restart(RESEND) for a rebooted peer. We can only allow this
 		   for temporal network outages! */
@@ -4126,7 +4126,7 @@ static int drbd_disconnected(int vnr, void *p, void *data)
 	kfree(mdev->p_uuid);
 	mdev->p_uuid = NULL;
 
-	if (!is_susp(mdev->state))
+	if (!drbd_suspended(mdev))
 		tl_clear(mdev->tconn);
 
 	drbd_md_sync(mdev);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 6e0e3bb..e296d7e 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -303,7 +303,7 @@ static void _req_may_be_done_not_susp(struct drbd_request *req, struct bio_and_e
 {
 	struct drbd_conf *mdev = req->w.mdev;
 
-	if (!is_susp(mdev->state))
+	if (!drbd_suspended(mdev))
 		_req_may_be_done(req, m);
 }
 
@@ -789,7 +789,7 @@ int __drbd_make_request(struct drbd_conf *mdev, struct bio *bio, unsigned long s
 	send_oos = rw == WRITE && drbd_should_send_out_of_sync(mdev->state);
 	D_ASSERT(!(remote && send_oos));
 
-	if (!(local || remote) && !is_susp(mdev->state)) {
+	if (!(local || remote) && !drbd_suspended(mdev)) {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "IO ERROR: neither local nor remote disk\n");
 		err = -EIO;
@@ -830,7 +830,7 @@ allocate_barrier:
 		}
 	}
 
-	if (is_susp(mdev->state)) {
+	if (drbd_suspended(mdev)) {
 		/* If we got suspended, use the retry mechanism of
 		   generic_make_request() to restart processing of this
 		   bio. In the next call to drbd_make_request
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 2b7ba59..c9d9640 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -48,6 +48,11 @@ static enum drbd_state_rv is_valid_transition(union drbd_state os, union drbd_st
 static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state ns,
 				       const char **warn_sync_abort);
 
+static inline bool is_susp(union drbd_state s)
+{
+        return s.susp || s.susp_nod || s.susp_fen;
+}
+
 bool conn_all_vols_unconf(struct drbd_tconn *tconn)
 {
 	struct drbd_conf *mdev;
@@ -1143,7 +1148,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 		if (get_ldev(mdev)) {
 			if ((ns.role == R_PRIMARY || ns.peer == R_PRIMARY) &&
 			    mdev->ldev->md.uuid[UI_BITMAP] == 0 && ns.disk >= D_UP_TO_DATE) {
-				if (is_susp(mdev->state)) {
+				if (drbd_suspended(mdev)) {
 					set_bit(NEW_CUR_UUID, &mdev->flags);
 				} else {
 					drbd_uuid_new_current(mdev);
-- 
1.7.4.1

