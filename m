Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1IWOdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:33:03 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39538 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab1IWOba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:31:30 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/10] drbd: Remove now-unused int_dig_out buffer
Date: Fri, 23 Sep 2011 16:31:20 +0200
Message-Id: <1316788285-17433-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    1 -
 drivers/block/drbd/drbd_main.c |    1 -
 drivers/block/drbd/drbd_nl.c   |    9 ---------
 3 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e5dc772..c58b327 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -893,7 +893,6 @@ struct drbd_tconn {			/* is a resource from the config file */
 	struct crypto_hash *integrity_r_tfm; /* to be used by the receiver thread */
 	struct crypto_hash *csums_tfm;
 	struct crypto_hash *verify_tfm;
-	void *int_dig_out;
 	void *int_dig_in;
 	void *int_dig_vv;
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 4aec4af..9e94ead 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2380,7 +2380,6 @@ void drbd_free_tconn(struct drbd_tconn *tconn)
 	drbd_free_socket(&tconn->meta);
 	drbd_free_socket(&tconn->data);
 	kfree(tconn->name);
-	kfree(tconn->int_dig_out);
 	kfree(tconn->int_dig_in);
 	kfree(tconn->int_dig_vv);
 	kfree(tconn);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 02d4224..4b60673 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1835,7 +1835,6 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	struct crypto_hash *tfm = NULL;
 	struct crypto_hash *integrity_w_tfm = NULL;
 	struct crypto_hash *integrity_r_tfm = NULL;
-	void *int_dig_out = NULL;
 	void *int_dig_in = NULL;
 	void *int_dig_vv = NULL;
 	struct drbd_tconn *oconn;
@@ -2009,11 +2008,6 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	/* allocation not in the IO path, cqueue thread context */
 	if (integrity_w_tfm) {
 		i = crypto_hash_digestsize(integrity_w_tfm);
-		int_dig_out = kmalloc(i, GFP_KERNEL);
-		if (!int_dig_out) {
-			retcode = ERR_NOMEM;
-			goto fail;
-		}
 		int_dig_in = kmalloc(i, GFP_KERNEL);
 		if (!int_dig_in) {
 			retcode = ERR_NOMEM;
@@ -2044,10 +2038,8 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	crypto_free_hash(tconn->integrity_r_tfm);
 	tconn->integrity_r_tfm = integrity_r_tfm;
 
-	kfree(tconn->int_dig_out);
 	kfree(tconn->int_dig_in);
 	kfree(tconn->int_dig_vv);
-	tconn->int_dig_out=int_dig_out;
 	tconn->int_dig_in=int_dig_in;
 	tconn->int_dig_vv=int_dig_vv;
 	retcode = _conn_request_state(tconn, NS(conn, C_UNCONNECTED), CS_VERBOSE);
@@ -2063,7 +2055,6 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 fail:
-	kfree(int_dig_out);
 	kfree(int_dig_in);
 	kfree(int_dig_vv);
 	crypto_free_hash(tfm);
-- 
1.7.4.1

