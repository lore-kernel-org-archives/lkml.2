Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab1IHMtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:49:55 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37526 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664Ab1IHMpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/16] drbd: Allow to disconnect if one volume is diskless
Date: Thu,  8 Sep 2011 14:45:25 +0200
Message-Id: <1315485937-18989-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
References: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    2 +-
 drivers/block/drbd/drbd_state.c    |    6 ++++++
 drivers/block/drbd/drbd_state.h    |    1 +
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 0301775..e45a417 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3450,7 +3450,7 @@ static int receive_req_conn_state(struct drbd_tconn *tconn, struct packet_info *
 	mask = convert_state(mask);
 	val = convert_state(val);
 
-	rv = conn_request_state(tconn, mask, val, CS_VERBOSE | CS_LOCAL_ONLY);
+	rv = conn_request_state(tconn, mask, val, CS_VERBOSE | CS_LOCAL_ONLY | CS_IGN_OUTD_FAIL);
 	conn_send_sr_reply(tconn, rv);
 
 	return 0;
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index ea2bf74..c73be9e 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1415,6 +1415,9 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 		os = mdev->state;
 		ns = sanitize_state(mdev, apply_mask_val(os, mask, val), NULL);
 
+		if (flags & CS_IGN_OUTD_FAIL && ns.disk == D_OUTDATED && os.disk < D_OUTDATED)
+			ns.disk = os.disk;
+
 		if (ns.i == os.i)
 			continue;
 
@@ -1456,6 +1459,9 @@ conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state
 		ns = apply_mask_val(os, mask, val);
 		ns = sanitize_state(mdev, ns, NULL);
 
+		if (flags & CS_IGN_OUTD_FAIL && ns.disk == D_OUTDATED && os.disk < D_OUTDATED)
+			ns.disk = os.disk;
+
 		rv = __drbd_set_state(mdev, ns, flags, NULL);
 		if (rv < SS_SUCCESS)
 			BUG();
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index 11fd0f8..c0331f1 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -69,6 +69,7 @@ enum chg_state_flags {
 	CS_DC_DISK       = 1 << 8,
 	CS_DC_PDSK       = 1 << 9,
 	CS_DC_MASK       = CS_DC_ROLE + CS_DC_PEER + CS_DC_CONN + CS_DC_DISK + CS_DC_PDSK,
+	CS_IGN_OUTD_FAIL = 1 << 10,
 };
 
 extern enum drbd_state_rv drbd_change_state(struct drbd_conf *mdev,
-- 
1.7.4.1

