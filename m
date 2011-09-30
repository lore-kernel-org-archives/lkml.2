Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab1I3Muc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:50:32 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42752 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab1I3Msa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:48:30 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/11] drbd: protect all idr accesses that might sleep with drbd_cfg_rwsem
Date: Fri, 30 Sep 2011 14:48:20 +0200
Message-Id: <1317386906-19260-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
References: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this commit the locking for all accesses to IDRs is complete:

 * Non sleeping read accesses are protected by RCU
 * sleeping read accesses are protocted by a read lock on drbd_cfg_rwsem
 * accesses that add anything are protected by a write lock
 * accesses that remove an object are protoected by a write lock
   and a call to synchronize_rcu() after it is removed from the IDR
   and before the object is actually free()ed.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_main.c     |    2 ++
 drivers/block/drbd/drbd_nl.c       |    4 ++++
 drivers/block/drbd/drbd_proc.c     |    2 ++
 drivers/block/drbd/drbd_receiver.c |   13 +++++++++++--
 drivers/block/drbd/drbd_worker.c   |    2 ++
 6 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 7896a64..2119d9b 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -172,7 +172,7 @@ extern struct ratelimit_state drbd_ratelimit_state;
 extern struct idr minors;
 extern struct list_head drbd_tconns;
 extern struct rw_semaphore drbd_cfg_rwsem;
-/* drbd_cfg_rwsem protects: drbd_tconns list,
+/* drbd_cfg_rwsem protects: drbd_tconns list, minors idr, tconn->volumes idr 
    note: non sleeping iterations over the idrs are protoected by RCU */
 
 /* on the wire */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index d48efb4..a2cac15 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2257,8 +2257,10 @@ static void drbd_cleanup(void)
 
 	drbd_genl_unregister();
 
+	down_write(&drbd_cfg_rwsem);
 	idr_for_each_entry(&minors, mdev, i)
 		drbd_delete_device(mdev);
+	up_write(&drbd_cfg_rwsem);
 
 	drbd_destroy_mempools();
 	unregister_blkdev(DRBD_MAJOR, "drbd");
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 5667536..331da4f 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -363,8 +363,10 @@ static void conn_md_sync(struct drbd_tconn *tconn)
 	struct drbd_conf *mdev;
 	int vnr;
 
+	down_read(&drbd_cfg_rwsem);
 	idr_for_each_entry(&tconn->volumes, mdev, vnr)
 		drbd_md_sync(mdev);
+	up_read(&drbd_cfg_rwsem);
 }
 
 int conn_khelper(struct drbd_tconn *tconn, char *cmd)
@@ -2920,7 +2922,9 @@ int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
+	down_write(&drbd_cfg_rwsem);
 	retcode = conn_new_minor(adm_ctx.tconn, dh->minor, adm_ctx.volume);
+	up_write(&drbd_cfg_rwsem);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index a4dbdbc..4025d08 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -227,6 +227,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 	 oos .. known out-of-sync kB
 	*/
 
+	down_read(&drbd_cfg_rwsem);
 	idr_for_each_entry(&minors, mdev, i) {
 		if (prev_i != i - 1)
 			seq_printf(seq, "\n");
@@ -293,6 +294,7 @@ static int drbd_seq_show(struct seq_file *seq, void *v)
 			}
 		}
 	}
+	up_read(&drbd_cfg_rwsem);
 
 	return 0;
 }
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 92ecb22..4d9d71a 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -964,7 +964,10 @@ retry:
 	if (drbd_send_protocol(tconn) == -EOPNOTSUPP)
 		return -1;
 
-	return !idr_for_each(&tconn->volumes, drbd_connected, tconn);
+	down_read(&drbd_cfg_rwsem);
+	h = !idr_for_each(&tconn->volumes, drbd_connected, tconn);
+	up_read(&drbd_cfg_rwsem);
+	return h;
 
 out_release_sockets:
 	if (tconn->data.socket) {
@@ -4084,7 +4087,9 @@ static void drbd_disconnect(struct drbd_tconn *tconn)
 	drbd_thread_stop(&tconn->asender);
 	drbd_free_sock(tconn);
 
+	down_read(&drbd_cfg_rwsem);
 	idr_for_each(&tconn->volumes, drbd_disconnected, tconn);
+	up_read(&drbd_cfg_rwsem);
 	conn_info(tconn, "Connection closed\n");
 
 	if (conn_highest_role(tconn) == R_PRIMARY && conn_highest_pdsk(tconn) >= D_UNKNOWN)
@@ -4821,10 +4826,14 @@ static int tconn_finish_peer_reqs(struct drbd_tconn *tconn)
 	do {
 		clear_bit(SIGNAL_ASENDER, &tconn->flags);
 		flush_signals(current);
+		down_read(&drbd_cfg_rwsem);
 		idr_for_each_entry(&tconn->volumes, mdev, i) {
-			if (drbd_finish_peer_reqs(mdev))
+			if (drbd_finish_peer_reqs(mdev)) {
+				up_read(&drbd_cfg_rwsem);
 				return 1; /* error */
+			}
 		}
+		up_read(&drbd_cfg_rwsem);
 		set_bit(SIGNAL_ASENDER, &tconn->flags);
 
 		spin_lock_irq(&tconn->req_lock);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 536eb05..b63c08e 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1733,12 +1733,14 @@ int drbd_worker(struct drbd_thread *thi)
 	spin_unlock_irq(&tconn->data.work.q_lock);
 
 	drbd_thread_stop(&tconn->receiver);
+	down_read(&drbd_cfg_rwsem);
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		D_ASSERT(mdev->state.disk == D_DISKLESS && mdev->state.conn == C_STANDALONE);
 		/* _drbd_set_state only uses stop_nowait.
 		 * wait here for the exiting receiver. */
 		drbd_mdev_cleanup(mdev);
 	}
+	up_read(&drbd_cfg_rwsem);
 	clear_bit(OBJECT_DYING, &tconn->flags);
 	clear_bit(CONFIG_PENDING, &tconn->flags);
 	wake_up(&tconn->ping_wait);
-- 
1.7.4.1

