Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab1JFNjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:39:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34152 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215Ab1JFNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 15/15] drbd: Turn no-tcp-cork into tcp-cork={yes|no}
Date: Thu,  6 Oct 2011 15:38:00 +0200
Message-Id: <1317908280-28951-16-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Change the --no-tcp-cork drbdsetup command line option as well as
the no_cork netlink packet.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    8 ++++----
 drivers/block/drbd/drbd_worker.c   |    2 +-
 include/linux/drbd_genl.h          |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a80f064..b014415 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -5022,7 +5022,7 @@ int drbd_asender(struct drbd_thread *thi)
 	int expect   = header_size;
 	bool ping_timeout_active = false;
 	struct net_conf *nc;
-	int ping_timeo, no_cork, ping_int;
+	int ping_timeo, tcp_cork, ping_int;
 
 	current->policy = SCHED_RR;  /* Make this a realtime task! */
 	current->rt_priority = 2;    /* more important than all other tasks */
@@ -5033,7 +5033,7 @@ int drbd_asender(struct drbd_thread *thi)
 		rcu_read_lock();
 		nc = rcu_dereference(tconn->net_conf);
 		ping_timeo = nc->ping_timeo;
-		no_cork = nc->no_cork;
+		tcp_cork = nc->tcp_cork;
 		ping_int = nc->ping_int;
 		rcu_read_unlock();
 
@@ -5048,14 +5048,14 @@ int drbd_asender(struct drbd_thread *thi)
 
 		/* TODO: conditionally cork; it may hurt latency if we cork without
 		   much to send */
-		if (!no_cork)
+		if (tcp_cork)
 			drbd_tcp_cork(tconn->meta.socket);
 		if (tconn_finish_peer_reqs(tconn)) {
 			conn_err(tconn, "tconn_finish_peer_reqs() failed\n");
 			goto reconnect;
 		}
 		/* but unconditionally uncork unless disabled */
-		if (!no_cork)
+		if (tcp_cork)
 			drbd_tcp_uncork(tconn->meta.socket);
 
 		/* short circuit, recv_msg would return EINTR anyways. */
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 484a08b..feb12b0 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1694,7 +1694,7 @@ int drbd_worker(struct drbd_thread *thi)
 
 			rcu_read_lock();
 			nc = rcu_dereference(tconn->net_conf);
-			cork = nc ? !nc->no_cork : 0;
+			cork = nc ? nc->tcp_cork : 0;
 			rcu_read_unlock();
 
 			if (tconn->data.socket && cork)
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 0fd79ea..601334b 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -164,7 +164,7 @@ GENL_struct(DRBD_NLA_NET_CONF, 5, net_conf,
 	__u32_field_def(25,	GENLA_F_MANDATORY,	cong_extents, DRBD_CONG_EXTENTS_DEF)
 	__flg_field_def(26, GENLA_F_MANDATORY,	two_primaries, 0)
 	__flg_field(27, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	want_lose)
-	__flg_field_def(28, GENLA_F_MANDATORY,	no_cork, 0)
+	__flg_field_def(28, GENLA_F_MANDATORY,	tcp_cork, 1)
 	__flg_field_def(29, GENLA_F_MANDATORY,	always_asbp, 0)
 	__flg_field(30, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	dry_run)
 	__flg_field_def(31,	GENLA_F_MANDATORY,	use_rle, 0)
-- 
1.7.4.1

