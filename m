Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1JJL4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:56:39 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45065 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab1JJLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:55:14 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/13] drbd: Receiving part for the PROTOCOL_UPDATE packet
Date: Mon, 10 Oct 2011 13:54:58 +0200
Message-Id: <1318247706-7732-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
References: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    3 +-
 drivers/block/drbd/drbd_main.c     |    2 +
 drivers/block/drbd/drbd_receiver.c |   73 +++++++++++++++++++++++++++++-------
 3 files changed, 63 insertions(+), 15 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c59012f..75b26d8 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -225,6 +225,7 @@ enum drbd_packet {
 	P_CONN_ST_CHG_REQ     = 0x2a, /* data sock: Connection wide state request */
 	P_CONN_ST_CHG_REPLY   = 0x2b, /* meta sock: Connection side state req reply */
 	P_RETRY_WRITE	      = 0x2c, /* Protocol C: retry conflicting write request */
+	P_PROTOCOL_UPDATE     = 0x2d, /* data sock: is used in established connections */
 
 	P_MAY_IGNORE	      = 0x100, /* Flag to test if (cmd > P_MAY_IGNORE) ... */
 	P_MAX_OPT_CMD	      = 0x101,
@@ -849,7 +850,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 
 	struct crypto_hash *cram_hmac_tfm;
 	struct crypto_hash *integrity_tfm;  /* checksums we compute, updates protected by tconn->data->mutex */
-	struct crypto_hash *peer_integrity_tfm;  /* checksums we verify */
+	struct crypto_hash *peer_integrity_tfm;  /* checksums we verify, only accessed from receiver thread  */
 	struct crypto_hash *csums_tfm;
 	struct crypto_hash *verify_tfm;
 	void *int_dig_in;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7c806b9..eecb0fb 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3290,6 +3290,8 @@ const char *cmdname(enum drbd_packet cmd)
 		[P_RS_CANCEL]		= "RSCancel",
 		[P_CONN_ST_CHG_REQ]	= "conn_st_chg_req",
 		[P_CONN_ST_CHG_REPLY]	= "conn_st_chg_reply",
+		[P_RETRY_WRITE]		= "retry_write",
+		[P_PROTOCOL_UPDATE]	= "protocol_update",
 
 		/* enum drbd_packet, but not commands - obsoleted flags:
 		 *	P_MAY_IGNORE
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 61b57fc..9611303 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3001,9 +3001,11 @@ static enum drbd_after_sb_p convert_after_sb(enum drbd_after_sb_p peer)
 static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct p_protocol *p = pi->data;
-	int p_proto, p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
-	int p_discard_my_data, p_two_primaries, cf;
-	struct net_conf *nc;
+	enum drbd_after_sb_p p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
+	int p_proto, p_discard_my_data, p_two_primaries, cf;
+	struct net_conf *nc, *old_net_conf, *new_net_conf = NULL;
+	char integrity_alg[SHARED_SECRET_MAX] = "";
+	struct crypto_hash *peer_tfm = NULL, *tfm = NULL;
 	void *int_dig_in = NULL, *int_dig_vv = NULL;
 
 	p_proto		= be32_to_cpu(p->protocol);
@@ -3015,8 +3017,6 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	p_discard_my_data = cf & CF_DISCARD_MY_DATA;
 
 	if (tconn->agreed_pro_version >= 87) {
-		char integrity_alg[SHARED_SECRET_MAX];
-		struct crypto_hash *tfm = NULL;
 		int err;
 
 		if (pi->size > sizeof(integrity_alg))
@@ -3024,35 +3024,70 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 		err = drbd_recv_all(tconn, integrity_alg, pi->size);
 		if (err)
 			return err;
-		integrity_alg[SHARED_SECRET_MAX-1] = 0;
+		integrity_alg[SHARED_SECRET_MAX - 1] = 0;
+	}
 
+	if (pi->cmd == P_PROTOCOL_UPDATE) {
 		if (integrity_alg[0]) {
 			int hash_size;
 
-			tfm = crypto_alloc_hash(integrity_alg, 0, CRYPTO_ALG_ASYNC);
-			if (!tfm) {
+			peer_tfm = crypto_alloc_hash(integrity_alg, 0, CRYPTO_ALG_ASYNC);
+			tfm      = crypto_alloc_hash(integrity_alg, 0, CRYPTO_ALG_ASYNC);
+			if (!(peer_tfm && tfm)) {
 				conn_err(tconn, "peer data-integrity-alg %s not supported\n",
 					 integrity_alg);
 				goto disconnect;
 			}
-			conn_info(tconn, "peer data-integrity-alg: %s\n", integrity_alg);
 
 			hash_size = crypto_hash_digestsize(tfm);
 			int_dig_in = kmalloc(hash_size, GFP_KERNEL);
 			int_dig_vv = kmalloc(hash_size, GFP_KERNEL);
 			if (!(int_dig_in && int_dig_vv)) {
-				crypto_free_hash(tfm);
+				conn_err(tconn, "Allocation of buffers for data integrity checking failed\n");
 				goto disconnect;
 			}
 		}
 
-		if (tconn->peer_integrity_tfm)
-			crypto_free_hash(tconn->peer_integrity_tfm);
-		tconn->peer_integrity_tfm = tfm;
+		new_net_conf = kmalloc(sizeof(struct net_conf), GFP_KERNEL);
+		if (!new_net_conf) {
+			conn_err(tconn, "Allocation of new net_conf failed\n");
+			goto disconnect;
+		}
+
+		mutex_lock(&tconn->data.mutex);
+		mutex_lock(&tconn->conf_update);
+		old_net_conf = tconn->net_conf;
+		*new_net_conf = *old_net_conf;
+
+		new_net_conf->wire_protocol = p_proto;
+		new_net_conf->after_sb_0p = convert_after_sb(p_after_sb_0p);
+		new_net_conf->after_sb_1p = convert_after_sb(p_after_sb_1p);
+		new_net_conf->after_sb_2p = convert_after_sb(p_after_sb_2p);
+		new_net_conf->two_primaries = p_two_primaries;
+		strcpy(new_net_conf->integrity_alg, integrity_alg);
+		new_net_conf->integrity_alg_len = strlen(integrity_alg) + 1;
+
+		crypto_free_hash(tconn->integrity_tfm);
+		tconn->integrity_tfm = tfm;
+
+		rcu_assign_pointer(tconn->net_conf, new_net_conf);
+		mutex_unlock(&tconn->conf_update);
+		mutex_unlock(&tconn->data.mutex);
+
+		crypto_free_hash(tconn->peer_integrity_tfm);
 		kfree(tconn->int_dig_in);
 		kfree(tconn->int_dig_vv);
+		tconn->peer_integrity_tfm = peer_tfm;
 		tconn->int_dig_in = int_dig_in;
 		tconn->int_dig_vv = int_dig_vv;
+
+		if (strcmp(old_net_conf->integrity_alg, integrity_alg))
+			conn_info(tconn, "peer data-integrity-alg: %s\n", integrity_alg);
+
+		synchronize_rcu();
+		kfree(old_net_conf);
+
+		return 0;
 	}
 
 	clear_bit(CONN_DRY_RUN, &tconn->flags);
@@ -3063,7 +3098,7 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	rcu_read_lock();
 	nc = rcu_dereference(tconn->net_conf);
 
-	if (p_proto != nc->wire_protocol && tconn->agreed_pro_version < 100) {
+	if (p_proto != nc->wire_protocol) {
 		conn_err(tconn, "incompatible communication protocols\n");
 		goto disconnect_rcu_unlock;
 	}
@@ -3093,6 +3128,11 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 		goto disconnect_rcu_unlock;
 	}
 
+	if (strcmp(integrity_alg, nc->integrity_alg)) {
+		conn_err(tconn, "incompatible setting of the data-integrity-alg\n");
+		goto disconnect_rcu_unlock;
+	}
+
 	rcu_read_unlock();
 
 	return 0;
@@ -3100,6 +3140,10 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 disconnect_rcu_unlock:
 	rcu_read_unlock();
 disconnect:
+	crypto_free_hash(peer_tfm);
+	crypto_free_hash(tfm);
+	kfree(int_dig_in);
+	kfree(int_dig_vv);
 	conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 	return -EIO;
 }
@@ -4197,6 +4241,7 @@ static struct data_cmd drbd_cmd_handler[] = {
 	[P_DELAY_PROBE]     = { 0, sizeof(struct p_delay_probe93), receive_skip },
 	[P_OUT_OF_SYNC]     = { 0, sizeof(struct p_block_desc), receive_out_of_sync },
 	[P_CONN_ST_CHG_REQ] = { 0, sizeof(struct p_req_state), receive_req_conn_state },
+	[P_PROTOCOL_UPDATE] = { 1, sizeof(struct p_protocol), receive_protocol },
 };
 
 static void drbdd(struct drbd_tconn *tconn)
-- 
1.7.4.1

