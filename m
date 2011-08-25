Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab1HYP30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:29:26 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33400 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab1HYPJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:26 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 046/118] drbd: Move sequence number logic into drbd_receiver.c and simplify it
Date: Thu, 25 Aug 2011 17:07:42 +0200
Message-Id: <1314284934-17999-47-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

These things are only used there.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   27 ---------------------------
 drivers/block/drbd/drbd_receiver.c |   29 ++++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 7cc75dd9..fafadb6 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -2355,33 +2355,6 @@ static inline int drbd_set_ed_uuid(struct drbd_conf *mdev, u64 val)
 	return changed;
 }
 
-static inline int seq_cmp(u32 a, u32 b)
-{
-	/* we assume wrap around at 32bit.
-	 * for wrap around at 24bit (old atomic_t),
-	 * we'd have to
-	 *  a <<= 8; b <<= 8;
-	 */
-	return (s32)(a) - (s32)(b);
-}
-#define seq_lt(a, b) (seq_cmp((a), (b)) < 0)
-#define seq_gt(a, b) (seq_cmp((a), (b)) > 0)
-#define seq_ge(a, b) (seq_cmp((a), (b)) >= 0)
-#define seq_le(a, b) (seq_cmp((a), (b)) <= 0)
-/* CAUTION: please no side effects in arguments! */
-#define seq_max(a, b) ((u32)(seq_gt((a), (b)) ? (a) : (b)))
-
-static inline void update_peer_seq(struct drbd_conf *mdev, unsigned int new_seq)
-{
-	unsigned int m;
-	spin_lock(&mdev->peer_seq_lock);
-	m = seq_max(mdev->peer_seq, new_seq);
-	mdev->peer_seq = m;
-	spin_unlock(&mdev->peer_seq_lock);
-	if (m == new_seq)
-		wake_up(&mdev->seq_wait);
-}
-
 static inline void drbd_update_congested(struct drbd_conf *mdev)
 {
 	struct sock *sk = mdev->tconn->data.socket->sk;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 72b2512..0d9d777 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1625,6 +1625,33 @@ static int e_send_discard_ack(struct drbd_conf *mdev, struct drbd_work *w, int u
 	return ok;
 }
 
+static bool seq_greater(u32 a, u32 b)
+{
+	/*
+	 * We assume 32-bit wrap-around here.
+	 * For 24-bit wrap-around, we would have to shift:
+	 *  a <<= 8; b <<= 8;
+	 */
+	return (s32)a - (s32)b > 0;
+}
+
+static u32 seq_max(u32 a, u32 b)
+{
+	return seq_greater(a, b) ? a : b;
+}
+
+static void update_peer_seq(struct drbd_conf *mdev, unsigned int new_seq)
+{
+	unsigned int m;
+
+	spin_lock(&mdev->peer_seq_lock);
+	m = seq_max(mdev->peer_seq, new_seq);
+	mdev->peer_seq = m;
+	spin_unlock(&mdev->peer_seq_lock);
+	if (m == new_seq)
+		wake_up(&mdev->seq_wait);
+}
+
 /* Called from receive_Data.
  * Synchronize packets on sock with packets on msock.
  *
@@ -1655,7 +1682,7 @@ static int drbd_wait_peer_seq(struct drbd_conf *mdev, const u32 packet_seq)
 	spin_lock(&mdev->peer_seq_lock);
 	for (;;) {
 		prepare_to_wait(&mdev->seq_wait, &wait, TASK_INTERRUPTIBLE);
-		if (seq_le(packet_seq, mdev->peer_seq+1))
+		if (!seq_greater(packet_seq, mdev->peer_seq + 1))
 			break;
 		if (signal_pending(current)) {
 			ret = -ERESTARTSYS;
-- 
1.7.4.1

