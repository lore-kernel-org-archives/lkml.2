Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1HYPVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:21:08 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34594 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1HYPJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:46 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 075/118] drbd: Converted wake_asender() and request_ping() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:11 +0200
Message-Id: <1314284934-17999-76-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   12 ++++++------
 drivers/block/drbd/drbd_main.c     |    2 +-
 drivers/block/drbd/drbd_nl.c       |    2 +-
 drivers/block/drbd/drbd_receiver.c |    2 +-
 drivers/block/drbd/drbd_worker.c   |    4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 1c43975..e8c2c2a 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1857,16 +1857,16 @@ drbd_queue_work(struct drbd_work_queue *q, struct drbd_work *w)
 	spin_unlock_irqrestore(&q->q_lock, flags);
 }
 
-static inline void wake_asender(struct drbd_conf *mdev)
+static inline void wake_asender(struct drbd_tconn *tconn)
 {
-	if (test_bit(SIGNAL_ASENDER, &mdev->tconn->flags))
-		force_sig(DRBD_SIG, mdev->tconn->asender.task);
+	if (test_bit(SIGNAL_ASENDER, &tconn->flags))
+		force_sig(DRBD_SIG, tconn->asender.task);
 }
 
-static inline void request_ping(struct drbd_conf *mdev)
+static inline void request_ping(struct drbd_tconn *tconn)
 {
-	set_bit(SEND_PING, &mdev->tconn->flags);
-	wake_asender(mdev);
+	set_bit(SEND_PING, &tconn->flags);
+	wake_asender(tconn);
 }
 
 static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 45b8f67..4c31410 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1360,7 +1360,7 @@ static int we_should_drop_the_connection(struct drbd_conf *mdev, struct socket *
 	if (!drop_it) {
 		dev_err(DEV, "[%s/%d] sock_sendmsg time expired, ko = %u\n",
 		       current->comm, current->pid, mdev->tconn->ko_count);
-		request_ping(mdev);
+		request_ping(mdev->tconn);
 	}
 
 	return drop_it; /* && (mdev->state == R_PRIMARY) */;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index fda399a..df36a57 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -318,7 +318,7 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 	enum drbd_disk_state nps;
 
 	if (new_role == R_PRIMARY)
-		request_ping(mdev); /* Detect a dead peer ASAP */
+		request_ping(mdev->tconn); /* Detect a dead peer ASAP */
 
 	mutex_lock(&mdev->state_mutex);
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 5f44b43..409b8c8 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1868,7 +1868,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 				 * but I don't like the receiver using the msock */
 
 				put_ldev(mdev);
-				wake_asender(mdev);
+				wake_asender(mdev->tconn);
 				finish_wait(&mdev->misc_wait, &wait);
 				return true;
 			}
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index a705979..5be179b 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -145,7 +145,7 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 	if (do_al_complete_io)
 		drbd_al_complete_io(mdev, e_sector);
 
-	wake_asender(mdev);
+	wake_asender(mdev->tconn);
 	put_ldev(mdev);
 }
 
@@ -728,7 +728,7 @@ static int w_resync_finished(struct drbd_conf *mdev, struct drbd_work *w, int ca
 static void ping_peer(struct drbd_conf *mdev)
 {
 	clear_bit(GOT_PING_ACK, &mdev->flags);
-	request_ping(mdev);
+	request_ping(mdev->tconn);
 	wait_event(mdev->misc_wait,
 		   test_bit(GOT_PING_ACK, &mdev->flags) || mdev->state.conn < C_CONNECTED);
 }
-- 
1.7.4.1

