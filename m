Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab1JNV6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:58:50 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60888 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab1JNV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:57:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/11] drbd: receive_protocol(): We cannot change our own data-integrity-alg setting here
Date: Fri, 14 Oct 2011 23:57:52 +0200
Message-Id: <1318629472-11110-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
References: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index aa674bf..68a5aba 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3002,7 +3002,7 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	int p_proto, p_discard_my_data, p_two_primaries, cf;
 	struct net_conf *nc, *old_net_conf, *new_net_conf = NULL;
 	char integrity_alg[SHARED_SECRET_MAX] = "";
-	struct crypto_hash *peer_integrity_tfm = NULL, *integrity_tfm = NULL;
+	struct crypto_hash *peer_integrity_tfm = NULL;
 	void *int_dig_in = NULL, *int_dig_vv = NULL;
 
 	p_proto		= be32_to_cpu(p->protocol);
@@ -3028,15 +3028,23 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 		if (integrity_alg[0]) {
 			int hash_size;
 
+			/*
+			 * We can only change the peer data integrity algorithm
+			 * here.  Changing our own data integrity algorithm
+			 * requires that we send a P_PROTOCOL_UPDATE packet at
+			 * the same time; otherwise, the peer has no way to
+			 * tell between which packets the algorithm should
+			 * change.
+			 */
+
 			peer_integrity_tfm = crypto_alloc_hash(integrity_alg, 0, CRYPTO_ALG_ASYNC);
-			integrity_tfm = crypto_alloc_hash(integrity_alg, 0, CRYPTO_ALG_ASYNC);
-			if (!(peer_integrity_tfm && integrity_tfm)) {
+			if (!peer_integrity_tfm) {
 				conn_err(tconn, "peer data-integrity-alg %s not supported\n",
 					 integrity_alg);
 				goto disconnect;
 			}
 
-			hash_size = crypto_hash_digestsize(integrity_tfm);
+			hash_size = crypto_hash_digestsize(peer_integrity_tfm);
 			int_dig_in = kmalloc(hash_size, GFP_KERNEL);
 			int_dig_vv = kmalloc(hash_size, GFP_KERNEL);
 			if (!(int_dig_in && int_dig_vv)) {
@@ -3064,9 +3072,6 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 		strcpy(new_net_conf->integrity_alg, integrity_alg);
 		new_net_conf->integrity_alg_len = strlen(integrity_alg) + 1;
 
-		crypto_free_hash(tconn->integrity_tfm);
-		tconn->integrity_tfm = integrity_tfm;
-
 		rcu_assign_pointer(tconn->net_conf, new_net_conf);
 		mutex_unlock(&tconn->conf_update);
 		mutex_unlock(&tconn->data.mutex);
@@ -3079,7 +3084,8 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 		tconn->int_dig_vv = int_dig_vv;
 
 		if (strcmp(old_net_conf->integrity_alg, integrity_alg))
-			conn_info(tconn, "peer data-integrity-alg: %s\n", integrity_alg);
+			conn_info(tconn, "peer data-integrity-alg: %s\n",
+				  integrity_alg[0] ? integrity_alg : "(none)");
 
 		synchronize_rcu();
 		kfree(old_net_conf);
@@ -3135,7 +3141,6 @@ disconnect_rcu_unlock:
 	rcu_read_unlock();
 disconnect:
 	crypto_free_hash(peer_integrity_tfm);
-	crypto_free_hash(integrity_tfm);
 	kfree(int_dig_in);
 	kfree(int_dig_vv);
 	conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
-- 
1.7.4.1

