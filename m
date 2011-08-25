Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1HYPPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:15:53 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32931 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab1HYPKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 097/118] drbd: Converted drbdd_init() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:33 +0200
Message-Id: <1314284934-17999-98-git-send-email-philipp.reisner@linbit.com>
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
index 3fcc8dc..cc5e937 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4229,33 +4229,33 @@ static int drbd_do_auth(struct drbd_tconn *tconn)
 
 int drbdd_init(struct drbd_thread *thi)
 {
-	struct drbd_conf *mdev = thi->mdev;
+	struct drbd_tconn *tconn = thi->mdev->tconn;
 	int h;
 
-	dev_info(DEV, "receiver (re)started\n");
+	conn_info(tconn, "receiver (re)started\n");
 
 	do {
-		h = drbd_connect(mdev->tconn);
+		h = drbd_connect(tconn);
 		if (h == 0) {
-			drbd_disconnect(mdev->tconn);
+			drbd_disconnect(tconn);
 			schedule_timeout_interruptible(HZ);
 		}
 		if (h == -1) {
-			dev_warn(DEV, "Discarding network configuration.\n");
-			drbd_force_state(mdev, NS(conn, C_DISCONNECTING));
+			conn_warn(tconn, "Discarding network configuration.\n");
+			drbd_force_state(tconn->volume0, NS(conn, C_DISCONNECTING));
 		}
 	} while (h == 0);
 
 	if (h > 0) {
-		if (get_net_conf(mdev->tconn)) {
-			drbdd(mdev->tconn);
-			put_net_conf(mdev->tconn);
+		if (get_net_conf(tconn)) {
+			drbdd(tconn);
+			put_net_conf(tconn);
 		}
 	}
 
-	drbd_disconnect(mdev->tconn);
+	drbd_disconnect(tconn);
 
-	dev_info(DEV, "receiver terminated\n");
+	conn_info(tconn, "receiver terminated\n");
 	return 0;
 }
 
-- 
1.7.4.1

