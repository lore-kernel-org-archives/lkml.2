Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab1JJL4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:56:42 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45064 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab1JJLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:55:14 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/13] drbd: Send PROTOCOL_UPDATE packets when appropriate
Date: Mon, 10 Oct 2011 13:54:59 +0200
Message-Id: <1318247706-7732-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
References: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    2 +-
 drivers/block/drbd/drbd_main.c |    6 +++---
 drivers/block/drbd/drbd_nl.c   |   11 ++---------
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 75b26d8..c301973 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1051,7 +1051,7 @@ extern int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
 extern int drbd_send_all(struct drbd_tconn *, struct socket *, void *, size_t,
 			 unsigned);
 
-extern int __drbd_send_protocol(struct drbd_tconn *tconn);
+extern int __drbd_send_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd);
 extern int drbd_send_protocol(struct drbd_tconn *tconn);
 extern int drbd_send_uuids(struct drbd_conf *mdev);
 extern int drbd_send_uuids_skip_initial_sync(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index eecb0fb..73951cc 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -911,7 +911,7 @@ int drbd_send_sync_param(struct drbd_conf *mdev)
 	return drbd_send_command(mdev, sock, cmd, size, NULL, 0);
 }
 
-int __drbd_send_protocol(struct drbd_tconn *tconn)
+int __drbd_send_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd)
 {
 	struct drbd_socket *sock;
 	struct p_protocol *p;
@@ -953,7 +953,7 @@ int __drbd_send_protocol(struct drbd_tconn *tconn)
 		strcpy(p->integrity_alg, nc->integrity_alg);
 	rcu_read_unlock();
 
-	return __conn_send_command(tconn, sock, P_PROTOCOL, size, NULL, 0);
+	return __conn_send_command(tconn, sock, cmd, size, NULL, 0);
 }
 
 int drbd_send_protocol(struct drbd_tconn *tconn)
@@ -961,7 +961,7 @@ int drbd_send_protocol(struct drbd_tconn *tconn)
 	int err;
 
 	mutex_lock(&tconn->data.mutex);
-	err = __drbd_send_protocol(tconn);
+	err = __drbd_send_protocol(tconn, P_PROTOCOL);
 	mutex_unlock(&tconn->data.mutex);
 
 	return err;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 87fd3bf..fc0ea77 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1910,7 +1910,6 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	int ovr; /* online verify running */
 	int rsr; /* re-sync running */
 	struct crypto crypto = { };
-	bool change_integrity_alg;
 
 	retcode = drbd_adm_prepare(skb, info, DRBD_ADM_NEED_CONN);
 	if (!adm_ctx.reply_skb)
@@ -1981,9 +1980,6 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	change_integrity_alg = strcmp(old_conf->integrity_alg,
-				      new_conf->integrity_alg);
-
 	retcode = alloc_crypto(&crypto, new_conf);
 	if (retcode != NO_ERROR)
 		goto fail;
@@ -2007,13 +2003,10 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	tconn->int_dig_vv = crypto.int_dig_vv;
 	crypto_free_hash(tconn->integrity_tfm);
 	tconn->integrity_tfm = crypto.integrity_tfm;
-	if (change_integrity_alg) {
+	if (tconn->cstate >= C_WF_REPORT_PARAMS && tconn->agreed_pro_version >= 100)
 		/* Do this without trying to take tconn->data.mutex again.  */
-		if (__drbd_send_protocol(tconn))
-			goto fail;
-	}
+		__drbd_send_protocol(tconn, P_PROTOCOL_UPDATE);
 
-	/* FIXME Changing cram_hmac while the connection is established is useless */
 	crypto_free_hash(tconn->cram_hmac_tfm);
 	tconn->cram_hmac_tfm = crypto.cram_hmac_tfm;
 
-- 
1.7.4.1

