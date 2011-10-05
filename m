Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248Ab1JEJiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:38:14 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56218 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934187Ab1JEJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:09 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/16] drbd: Wrong use of RCU in receive_protocol()
Date: Wed,  5 Oct 2011 11:37:54 +0200
Message-Id: <1317807484-24628-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

It is not enough to grab net_conf->integrity_alg under rcu_read_lock()
and access it outside of it; the entire net_conf object may be gone by
then.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6da7aeb..98f03b1 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2998,7 +2998,6 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	int p_proto, p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
 	int p_want_lose, p_two_primaries, cf;
 	char p_integrity_alg[SHARED_SECRET_MAX] = "";
-	unsigned char *my_alg;
 	struct net_conf *nc;
 
 	p_proto		= be32_to_cpu(p->protocol);
@@ -3009,6 +3008,18 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	cf		= be32_to_cpu(p->conn_flags);
 	p_want_lose = cf & CF_WANT_LOSE;
 
+	if (tconn->agreed_pro_version >= 87) {
+		int err;
+
+		if (pi->size > sizeof(p_integrity_alg))
+			return -EIO;
+		err = drbd_recv_all(tconn, p_integrity_alg, pi->size);
+		if (err)
+			return err;
+
+		p_integrity_alg[SHARED_SECRET_MAX-1] = 0;
+	}
+
 	clear_bit(CONN_DRY_RUN, &tconn->flags);
 
 	if (cf & CF_DRY_RUN)
@@ -3047,23 +3058,18 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 		goto disconnect_rcu_unlock;
 	}
 
-	my_alg = nc->integrity_alg;
-	rcu_read_unlock();
-
 	if (tconn->agreed_pro_version >= 87) {
-		int err;
-
-		err = drbd_recv_all(tconn, p_integrity_alg, pi->size);
-		if (err)
-			return err;
-
-		p_integrity_alg[SHARED_SECRET_MAX-1] = 0;
-		if (strcmp(p_integrity_alg, my_alg)) {
+		if (strcmp(p_integrity_alg, nc->integrity_alg)) {
 			conn_err(tconn, "incompatible setting of the data-integrity-alg\n");
 			goto disconnect;
 		}
+	}
+
+	rcu_read_unlock();
+
+	if (tconn->agreed_pro_version >= 87) {
 		conn_info(tconn, "data-integrity-alg: %s\n",
-		     my_alg[0] ? my_alg : (unsigned char *)"<not-used>");
+			  nc->integrity_alg[0] ? nc->integrity_alg : (unsigned char *)"<not-used>");
 	}
 
 	return 0;
-- 
1.7.4.1

