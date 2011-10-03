Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab1JCU7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:59:13 -0400
Received: from mail09.linbit.com ([212.69.161.110]:41587 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573Ab1JCU6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:58:37 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/10] drbd: Eliminated drbd_free_resoruces() it is superseeded by conn_free_crypto()
Date: Mon,  3 Oct 2011 22:58:28 +0200
Message-Id: <1317675513-12745-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
References: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    1 -
 drivers/block/drbd/drbd_main.c |   35 ++++++++++++-----------------------
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 3080192..0fb3fc3 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1046,7 +1046,6 @@ extern void drbd_calc_cpu_mask(struct drbd_tconn *tconn);
 #define drbd_thread_current_set_cpu(A) ({})
 #define drbd_calc_cpu_mask(A) ({})
 #endif
-extern void drbd_free_resources(struct drbd_conf *mdev);
 extern void tl_release(struct drbd_tconn *, unsigned int barrier_nr,
 		       unsigned int set_size);
 extern void tl_clear(struct drbd_tconn *);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 96add4e..28f1b74 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2054,7 +2054,9 @@ void drbd_mdev_cleanup(struct drbd_conf *mdev)
 		drbd_bm_cleanup(mdev);
 	}
 
-	drbd_free_resources(mdev);
+	drbd_free_bc(mdev->ldev);
+	mdev->ldev = NULL;
+
 	clear_bit(AL_SUSPENDED, &mdev->flags);
 
 	D_ASSERT(list_empty(&mdev->active_ee));
@@ -2249,7 +2251,8 @@ void drbd_delete_device(struct drbd_conf *mdev)
 	if (mdev->this_bdev)
 		bdput(mdev->this_bdev);
 
-	drbd_free_resources(mdev);
+	drbd_free_bc(mdev->ldev);
+	mdev->ldev = NULL;
 
 	drbd_release_all_peer_reqs(mdev);
 
@@ -2384,11 +2387,18 @@ static void drbd_free_socket(struct drbd_socket *socket)
 
 void conn_free_crypto(struct drbd_tconn *tconn)
 {
+	drbd_free_sock(tconn);
+
+	crypto_free_hash(tconn->csums_tfm);
+	crypto_free_hash(tconn->verify_tfm);
 	crypto_free_hash(tconn->cram_hmac_tfm);
 	crypto_free_hash(tconn->integrity_w_tfm);
 	crypto_free_hash(tconn->integrity_r_tfm);
 	kfree(tconn->int_dig_in);
 	kfree(tconn->int_dig_vv);
+
+	tconn->csums_tfm = NULL;
+	tconn->verify_tfm = NULL;
 	tconn->cram_hmac_tfm = NULL;
 	tconn->integrity_w_tfm = NULL;
 	tconn->integrity_r_tfm = NULL;
@@ -2697,27 +2707,6 @@ void drbd_free_sock(struct drbd_tconn *tconn)
 	}
 }
 
-
-void drbd_free_resources(struct drbd_conf *mdev)
-{
-	crypto_free_hash(mdev->tconn->csums_tfm);
-	mdev->tconn->csums_tfm = NULL;
-	crypto_free_hash(mdev->tconn->verify_tfm);
-	mdev->tconn->verify_tfm = NULL;
-	crypto_free_hash(mdev->tconn->cram_hmac_tfm);
-	mdev->tconn->cram_hmac_tfm = NULL;
-	crypto_free_hash(mdev->tconn->integrity_w_tfm);
-	mdev->tconn->integrity_w_tfm = NULL;
-	crypto_free_hash(mdev->tconn->integrity_r_tfm);
-	mdev->tconn->integrity_r_tfm = NULL;
-
-	drbd_free_sock(mdev->tconn);
-
-	__no_warn(local,
-		  drbd_free_bc(mdev->ldev);
-		  mdev->ldev = NULL;);
-}
-
 /* meta data management */
 
 struct meta_data_on_disk {
-- 
1.7.4.1

