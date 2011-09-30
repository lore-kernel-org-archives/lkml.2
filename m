Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab1I3MtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:49:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42752 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab1I3Msc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:48:32 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/11] drbd: Considering that the two_primaries config flag can change
Date: Fri, 30 Sep 2011 14:48:26 +0200
Message-Id: <1317386906-19260-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
References: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now since it is possible to change the two_primaries config
flag while the connection is up, make sure we treat a peer_req
in a consistent way if the config flag changes while the peer_req
is under IO.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    4 ++++
 drivers/block/drbd/drbd_receiver.c |   19 ++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 83e6cad..3833d56 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -661,6 +661,9 @@ enum {
 
 	/* The peer wants a write ACK for this (wire proto C) */
 	__EE_SEND_WRITE_ACK,
+
+	/* Is set when net_conf had two_primaries set while creating this peer_req */
+	__EE_IN_INTERVAL_TREE,
 };
 #define EE_CALL_AL_COMPLETE_IO (1<<__EE_CALL_AL_COMPLETE_IO)
 #define EE_MAY_SET_IN_SYNC     (1<<__EE_MAY_SET_IN_SYNC)
@@ -669,6 +672,7 @@ enum {
 #define EE_HAS_DIGEST          (1<<__EE_HAS_DIGEST)
 #define EE_RESTART_REQUESTS	(1<<__EE_RESTART_REQUESTS)
 #define EE_SEND_WRITE_ACK	(1<<__EE_SEND_WRITE_ACK)
+#define EE_IN_INTERVAL_TREE	(1<<__EE_IN_INTERVAL_TREE)
 
 /* flag bits per mdev */
 enum {
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 05b214c..ec5b923 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1752,7 +1752,7 @@ static int e_end_block(struct drbd_work *w, int cancel)
 	}
 	/* we delete from the conflict detection hash _after_ we sent out the
 	 * P_WRITE_ACK / P_NEG_ACK, to get the sequence number right.  */
-	if (mdev->tconn->net_conf->two_primaries) {
+	if (peer_req->flags & EE_IN_INTERVAL_TREE) {
 		spin_lock_irq(&mdev->tconn->req_lock);
 		D_ASSERT(!drbd_interval_empty(&peer_req->i));
 		drbd_remove_epoch_entry_interval(mdev, peer_req);
@@ -1811,14 +1811,19 @@ static u32 seq_max(u32 a, u32 b)
 static bool need_peer_seq(struct drbd_conf *mdev)
 {
 	struct drbd_tconn *tconn = mdev->tconn;
+	int tp;
 
 	/*
 	 * We only need to keep track of the last packet_seq number of our peer
 	 * if we are in dual-primary mode and we have the discard flag set; see
 	 * handle_write_conflicts().
 	 */
-	return tconn->net_conf->two_primaries &&
-	       test_bit(DISCARD_CONCURRENT, &tconn->flags);
+
+	rcu_read_lock();
+	tp = rcu_dereference(mdev->tconn->net_conf)->two_primaries;
+	rcu_read_unlock();
+
+	return tp && test_bit(DISCARD_CONCURRENT, &tconn->flags);
 }
 
 static void update_peer_seq(struct drbd_conf *mdev, unsigned int peer_seq)
@@ -2049,7 +2054,7 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 	u32 peer_seq = be32_to_cpu(p->seq_num);
 	int rw = WRITE;
 	u32 dp_flags;
-	int err;
+	int err, tp;
 
 	mdev = vnr_to_mdev(tconn, pi->vnr);
 	if (!mdev)
@@ -2094,7 +2099,11 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 	atomic_inc(&peer_req->epoch->active);
 	spin_unlock(&mdev->epoch_lock);
 
-	if (mdev->tconn->net_conf->two_primaries) {
+	rcu_read_lock();
+	tp = rcu_dereference(mdev->tconn->net_conf)->two_primaries;
+	rcu_read_unlock();
+	if (tp) {
+		peer_req->flags |= EE_IN_INTERVAL_TREE;
 		err = wait_for_and_update_peer_seq(mdev, peer_seq);
 		if (err)
 			goto out_interrupted;
-- 
1.7.4.1

