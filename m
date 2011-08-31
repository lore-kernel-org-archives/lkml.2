Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab1HaPLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:11:20 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59854 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1HaPLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/16] drbd: Replace atomic_add_return with atomic_inc_return
Date: Wed, 31 Aug 2011 17:10:54 +0200
Message-Id: <1314803468-1201-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |    4 ++--
 drivers/block/drbd/drbd_nl.c   |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 47c4bae..e9e60d8 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1242,7 +1242,7 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 	p.sector   = sector;
 	p.block_id = block_id;
 	p.blksize  = blksize;
-	p.seq_num  = cpu_to_be32(atomic_add_return(1, &mdev->packet_seq));
+	p.seq_num  = cpu_to_be32(atomic_inc_return(&mdev->packet_seq));
 
 	if (!mdev->tconn->meta.socket || mdev->state.conn < C_CONNECTED)
 		return false;
@@ -1530,7 +1530,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	prepare_header(mdev, &p.head, P_DATA, sizeof(p) - sizeof(struct p_header) + dgs + req->i.size);
 	p.sector   = cpu_to_be64(req->i.sector);
 	p.block_id = (unsigned long)req;
-	p.seq_num  = cpu_to_be32(req->seq_num = atomic_add_return(1, &mdev->packet_seq));
+	p.seq_num  = cpu_to_be32(req->seq_num = atomic_inc_return(&mdev->packet_seq));
 
 	dp_flags = bio_flags_to_wire(mdev, req->master_bio->bi_rw);
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 90d7317..0168587 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2374,7 +2374,7 @@ void drbd_bcast_state(struct drbd_conf *mdev, union drbd_state state)
 	cn_reply->id.idx = CN_IDX_DRBD;
 	cn_reply->id.val = CN_VAL_DRBD;
 
-	cn_reply->seq = atomic_add_return(1, &drbd_nl_seq);
+	cn_reply->seq = atomic_inc_return(&drbd_nl_seq);
 	cn_reply->ack = 0; /* not used here. */
 	cn_reply->len = sizeof(struct drbd_nl_cfg_reply) +
 		(int)((char *)tl - (char *)reply->tag_list);
@@ -2406,7 +2406,7 @@ void drbd_bcast_ev_helper(struct drbd_conf *mdev, char *helper_name)
 	cn_reply->id.idx = CN_IDX_DRBD;
 	cn_reply->id.val = CN_VAL_DRBD;
 
-	cn_reply->seq = atomic_add_return(1, &drbd_nl_seq);
+	cn_reply->seq = atomic_inc_return(&drbd_nl_seq);
 	cn_reply->ack = 0; /* not used here. */
 	cn_reply->len = sizeof(struct drbd_nl_cfg_reply) +
 		(int)((char *)tl - (char *)reply->tag_list);
@@ -2485,7 +2485,7 @@ void drbd_bcast_ee(struct drbd_conf *mdev, const char *reason, const int dgs,
 	cn_reply->id.idx = CN_IDX_DRBD;
 	cn_reply->id.val = CN_VAL_DRBD;
 
-	cn_reply->seq = atomic_add_return(1,&drbd_nl_seq);
+	cn_reply->seq = atomic_inc_return(&drbd_nl_seq);
 	cn_reply->ack = 0; // not used here.
 	cn_reply->len = sizeof(struct drbd_nl_cfg_reply) +
 		(int)((char*)tl - (char*)reply->tag_list);
@@ -2524,7 +2524,7 @@ void drbd_bcast_sync_progress(struct drbd_conf *mdev)
 	cn_reply->id.idx = CN_IDX_DRBD;
 	cn_reply->id.val = CN_VAL_DRBD;
 
-	cn_reply->seq = atomic_add_return(1, &drbd_nl_seq);
+	cn_reply->seq = atomic_inc_return(&drbd_nl_seq);
 	cn_reply->ack = 0; /* not used here. */
 	cn_reply->len = sizeof(struct drbd_nl_cfg_reply) +
 		(int)((char *)tl - (char *)reply->tag_list);
-- 
1.7.4.1

