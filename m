Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1HYPfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:35:50 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33076 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab1HYPJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:04 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 017/118] drbd: Use the read and write request trees for request lookups
Date: Thu, 25 Aug 2011 17:07:13 +0200
Message-Id: <1314284934-17999-18-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_interval.h |    3 +-
 drivers/block/drbd/drbd_receiver.c |   44 +++++++++++++----------------------
 2 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/block/drbd/drbd_interval.h b/drivers/block/drbd/drbd_interval.h
index bf8dcf7..a847b4a 100644
--- a/drivers/block/drbd/drbd_interval.h
+++ b/drivers/block/drbd/drbd_interval.h
@@ -22,8 +22,7 @@ static inline bool drbd_interval_empty(struct drbd_interval *i)
 }
 
 bool drbd_insert_interval(struct rb_root *, struct drbd_interval *);
-struct drbd_interval *drbd_find_interval(struct rb_root *, sector_t,
-					 struct drbd_interval *);
+bool drbd_contains_interval(struct rb_root *, sector_t, struct drbd_interval *);
 void drbd_remove_interval(struct rb_root *, struct drbd_interval *);
 struct drbd_interval *drbd_find_overlap(struct rb_root *, sector_t,
 					unsigned int);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6b072584..b148398 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1470,27 +1470,15 @@ fail:
 }
 
 static struct drbd_request *
-find_request(struct drbd_conf *mdev,
-	     struct hlist_head *(*hash_slot)(struct drbd_conf *, sector_t),
-	     u64 id, sector_t sector, bool missing_ok, const char *func)
+find_request(struct drbd_conf *mdev, struct rb_root *root, u64 id,
+	     sector_t sector, bool missing_ok, const char *func)
 {
-	struct hlist_head *slot = hash_slot(mdev, sector);
-	struct hlist_node *n;
 	struct drbd_request *req;
 
-	hlist_for_each_entry(req, n, slot, collision) {
-		if ((unsigned long)req != (unsigned long)id)
-			continue;
-		if (req->i.sector != sector) {
-			dev_err(DEV, "%s: found request %lu but it has "
-				"wrong sector (%llus versus %llus)\n",
-				func, (unsigned long)req,
-				(unsigned long long)req->i.sector,
-				(unsigned long long)sector);
-			return NULL;
-		}
+	/* Request object according to our peer */
+	req = (struct drbd_request *)(unsigned long)id;
+	if (drbd_contains_interval(root, sector, &req->i))
 		return req;
-	}
 	if (!missing_ok) {
 		dev_err(DEV, "%s: failed to find request %lu, sector %llus\n", func,
 			(unsigned long)id, (unsigned long long)sector);
@@ -1508,7 +1496,7 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
 	sector = be64_to_cpu(p->sector);
 
 	spin_lock_irq(&mdev->req_lock);
-	req = find_request(mdev, ar_hash_slot, p->block_id, sector, false, __func__);
+	req = find_request(mdev, &mdev->read_requests, p->block_id, sector, false, __func__);
 	spin_unlock_irq(&mdev->req_lock);
 	if (unlikely(!req))
 		return false;
@@ -4245,16 +4233,16 @@ static int got_IsInSync(struct drbd_conf *mdev, struct p_header80 *h)
 	return true;
 }
 
-static int validate_req_change_req_state(struct drbd_conf *mdev,
-	u64 id, sector_t sector,
-	struct hlist_head *(*hash_slot)(struct drbd_conf *, sector_t),
-	const char *func, enum drbd_req_event what, bool missing_ok)
+static int
+validate_req_change_req_state(struct drbd_conf *mdev, u64 id, sector_t sector,
+			      struct rb_root *root, const char *func,
+			      enum drbd_req_event what, bool missing_ok)
 {
 	struct drbd_request *req;
 	struct bio_and_error m;
 
 	spin_lock_irq(&mdev->req_lock);
-	req = find_request(mdev, hash_slot, id, sector, missing_ok, func);
+	req = find_request(mdev, root, id, sector, missing_ok, func);
 	if (unlikely(!req)) {
 		spin_unlock_irq(&mdev->req_lock);
 		return false;
@@ -4304,8 +4292,8 @@ static int got_BlockAck(struct drbd_conf *mdev, struct p_header80 *h)
 	}
 
 	return validate_req_change_req_state(mdev, p->block_id, sector,
-					     tl_hash_slot, __func__, what,
-					     false);
+					     &mdev->write_requests, __func__,
+					     what, false);
 }
 
 static int got_NegAck(struct drbd_conf *mdev, struct p_header80 *h)
@@ -4326,7 +4314,7 @@ static int got_NegAck(struct drbd_conf *mdev, struct p_header80 *h)
 	}
 
 	found = validate_req_change_req_state(mdev, p->block_id, sector,
-					      tl_hash_slot, __func__,
+					      &mdev->write_requests, __func__,
 					      neg_acked, missing_ok);
 	if (!found) {
 		/* Protocol A has no P_WRITE_ACKs, but has P_NEG_ACKs.
@@ -4351,8 +4339,8 @@ static int got_NegDReply(struct drbd_conf *mdev, struct p_header80 *h)
 	    (unsigned long long)sector, be32_to_cpu(p->blksize));
 
 	return validate_req_change_req_state(mdev, p->block_id, sector,
-					     ar_hash_slot, __func__, neg_acked,
-					     false);
+					     &mdev->read_requests, __func__,
+					     neg_acked, false);
 }
 
 static int got_NegRSDReply(struct drbd_conf *mdev, struct p_header80 *h)
-- 
1.7.4.1

