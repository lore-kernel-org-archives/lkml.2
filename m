Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328Ab1IBKAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:00:54 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33016 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab1IBKAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:00:50 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/16] drbd: process_done_ee() has to handle unconfigured devices now
Date: Fri,  2 Sep 2011 12:00:33 +0200
Message-Id: <1314957648-13242-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
References: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Took the chance and converted tconn_process_done_ee() to use
idr_for_each_entry()

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   44 ++++++++++++++---------------------
 1 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index c57ef9f..956a0e2 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -404,7 +404,7 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 	LIST_HEAD(work_list);
 	LIST_HEAD(reclaimed);
 	struct drbd_peer_request *peer_req, *t;
-	int ok = (mdev->state.conn >= C_WF_REPORT_PARAMS);
+	int ok = 1;
 
 	spin_lock_irq(&mdev->tconn->req_lock);
 	reclaim_net_ee(mdev, &reclaimed);
@@ -4670,37 +4670,27 @@ static int got_skip(struct drbd_conf *mdev, enum drbd_packet cmd)
 	return true;
 }
 
-static int _drbd_process_done_ee(int vnr, void *p, void *data)
-{
-	struct drbd_conf *mdev = (struct drbd_conf *)p;
-	return !drbd_process_done_ee(mdev);
-}
-
-static int _check_ee_empty(int vnr, void *p, void *data)
-{
-	struct drbd_conf *mdev = (struct drbd_conf *)p;
-	struct drbd_tconn *tconn = mdev->tconn;
-	int not_empty;
-
-	spin_lock_irq(&tconn->req_lock);
-	not_empty = !list_empty(&mdev->done_ee);
-	spin_unlock_irq(&tconn->req_lock);
-
-	return not_empty;
-}
-
 static int tconn_process_done_ee(struct drbd_tconn *tconn)
 {
-	int not_empty, err;
+	struct drbd_conf *mdev;
+	int i, not_empty = 0;
 
 	do {
 		clear_bit(SIGNAL_ASENDER, &tconn->flags);
 		flush_signals(current);
-		err = idr_for_each(&tconn->volumes, _drbd_process_done_ee, NULL);
-		if (err)
-			return err;
+		idr_for_each_entry(&tconn->volumes, mdev, i) {
+			if (!drbd_process_done_ee(mdev))
+				return 1; /* error */
+		}
 		set_bit(SIGNAL_ASENDER, &tconn->flags);
-		not_empty = idr_for_each(&tconn->volumes, _check_ee_empty, NULL);
+
+		spin_lock_irq(&tconn->req_lock);
+		idr_for_each_entry(&tconn->volumes, mdev, i) {
+			not_empty = !list_empty(&mdev->done_ee);
+			if (not_empty)
+				break;
+		}
+		spin_unlock_irq(&tconn->req_lock);
 	} while (not_empty);
 
 	return 0;
@@ -4762,8 +4752,10 @@ int drbd_asender(struct drbd_thread *thi)
 		   much to send */
 		if (!tconn->net_conf->no_cork)
 			drbd_tcp_cork(tconn->meta.socket);
-		if (tconn_process_done_ee(tconn))
+		if (tconn_process_done_ee(tconn)) {
+			conn_err(tconn, "tconn_process_done_ee() failed\n");
 			goto reconnect;
+		}
 		/* but unconditionally uncork unless disabled */
 		if (!tconn->net_conf->no_cork)
 			drbd_tcp_uncork(tconn->meta.socket);
-- 
1.7.4.1

