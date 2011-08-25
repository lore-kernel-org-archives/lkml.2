Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab1HYPSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:18:11 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34594 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab1HYPJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 085/118] drbd: Converted drbd_recv_header() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:21 +0200
Message-Id: <1314284934-17999-86-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 66b35e9..4369651 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -952,20 +952,20 @@ static bool decode_header(struct drbd_tconn *tconn, struct p_header *h, struct p
 	return true;
 }
 
-static int drbd_recv_header(struct drbd_conf *mdev, struct packet_info *pi)
+static int drbd_recv_header(struct drbd_tconn *tconn, struct packet_info *pi)
 {
-	struct p_header *h = &mdev->tconn->data.rbuf.header;
+	struct p_header *h = &tconn->data.rbuf.header;
 	int r;
 
-	r = drbd_recv(mdev->tconn, h, sizeof(*h));
+	r = drbd_recv(tconn, h, sizeof(*h));
 	if (unlikely(r != sizeof(*h))) {
 		if (!signal_pending(current))
-			dev_warn(DEV, "short read expecting header on sock: r=%d\n", r);
+			conn_warn(tconn, "short read expecting header on sock: r=%d\n", r);
 		return false;
 	}
 
-	r = decode_header(mdev->tconn, h, pi);
-	mdev->tconn->last_received = jiffies;
+	r = decode_header(tconn, h, pi);
+	tconn->last_received = jiffies;
 
 	return r;
 }
@@ -3642,7 +3642,7 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 				goto out;
 			break;
 		}
-		if (!drbd_recv_header(mdev, &pi))
+		if (!drbd_recv_header(mdev->tconn, &pi))
 			goto out;
 		cmd = pi.cmd;
 		data_size = pi.size;
@@ -3779,7 +3779,7 @@ static void drbdd(struct drbd_conf *mdev)
 
 	while (get_t_state(&mdev->tconn->receiver) == RUNNING) {
 		drbd_thread_current_set_cpu(mdev, &mdev->tconn->receiver);
-		if (!drbd_recv_header(mdev, &pi))
+		if (!drbd_recv_header(mdev->tconn, &pi))
 			goto err_out;
 
 		if (unlikely(pi.cmd >= P_MAX_CMD || !drbd_cmd_handler[pi.cmd].function)) {
@@ -4006,7 +4006,7 @@ static int drbd_do_handshake(struct drbd_conf *mdev)
 	if (!rv)
 		return 0;
 
-	rv = drbd_recv_header(mdev, &pi);
+	rv = drbd_recv_header(mdev->tconn, &pi);
 	if (!rv)
 		return 0;
 
@@ -4100,7 +4100,7 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 	if (!rv)
 		goto fail;
 
-	rv = drbd_recv_header(mdev, &pi);
+	rv = drbd_recv_header(mdev->tconn, &pi);
 	if (!rv)
 		goto fail;
 
@@ -4155,7 +4155,7 @@ static int drbd_do_auth(struct drbd_conf *mdev)
 	if (!rv)
 		goto fail;
 
-	rv = drbd_recv_header(mdev, &pi);
+	rv = drbd_recv_header(mdev->tconn, &pi);
 	if (!rv)
 		goto fail;
 
-- 
1.7.4.1

