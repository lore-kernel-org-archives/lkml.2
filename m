Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1I3Mto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:49:44 -0400
Received: from mail09.linbit.com ([212.69.161.110]:42759 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600Ab1I3Msb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:48:31 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/11] drbd: Check consistency of net options when the get changed online
Date: Fri, 30 Sep 2011 14:48:22 +0200
Message-Id: <1317386906-19260-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
References: <1317386906-19260-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   79 ++++++++++++++++++++++++------------------
 1 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 331da4f..0bf1c2e 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1705,6 +1705,45 @@ static bool conn_ov_running(struct drbd_tconn *tconn)
 	return rv;
 }
 
+static enum drbd_ret_code
+check_net_options(struct drbd_tconn *tconn, struct net_conf *new_conf)
+{
+	struct drbd_conf *mdev;
+	int i;
+
+	if (new_conf->two_primaries &&
+	    (new_conf->wire_protocol != DRBD_PROT_C))
+		return ERR_NOT_PROTO_C;
+
+	rcu_read_lock();
+	idr_for_each_entry(&tconn->volumes, mdev, i) {
+		if (get_ldev(mdev)) {
+			enum drbd_fencing_p fp = mdev->ldev->dc.fencing;
+			put_ldev(mdev);
+			if (new_conf->wire_protocol == DRBD_PROT_A && fp == FP_STONITH) {
+				rcu_read_unlock();
+				return ERR_STONITH_AND_PROT_A;
+			}
+		}
+		if (mdev->state.role == R_PRIMARY && new_conf->want_lose) {
+			rcu_read_unlock();
+			return ERR_DISCARD;
+		}
+		if (!mdev->bitmap) {
+			if(drbd_bm_init(mdev)) {
+				rcu_read_unlock();
+				return ERR_NOMEM;
+			}
+		}
+	}
+	rcu_read_unlock();
+
+	if (new_conf->on_congestion != OC_BLOCK && new_conf->wire_protocol != DRBD_PROT_A)
+		return ERR_CONG_NOT_PROTO_A;
+
+	return NO_ERROR;
+}
+
 int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
@@ -1763,6 +1802,10 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
+	retcode = check_net_options(tconn, new_conf);
+	if (retcode != NO_ERROR)
+		goto fail;
+
 	/* re-sync running */
 	rsr = conn_resync_running(tconn);
 	if (rsr && strcmp(new_conf->csums_alg, tconn->net_conf->csums_alg)) {
@@ -1922,39 +1965,9 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	if (new_conf->two_primaries
-	    && (new_conf->wire_protocol != DRBD_PROT_C)) {
-		retcode = ERR_NOT_PROTO_C;
-		goto fail;
-	}
-
-	rcu_read_lock();
-	idr_for_each_entry(&tconn->volumes, mdev, i) {
-		if (get_ldev(mdev)) {
-			enum drbd_fencing_p fp = mdev->ldev->dc.fencing;
-			put_ldev(mdev);
-			if (new_conf->wire_protocol == DRBD_PROT_A && fp == FP_STONITH) {
-				retcode = ERR_STONITH_AND_PROT_A;
-				goto fail_rcu_unlock;
-			}
-		}
-		if (mdev->state.role == R_PRIMARY && new_conf->want_lose) {
-			retcode = ERR_DISCARD;
-			goto fail_rcu_unlock;
-		}
-		if (!mdev->bitmap) {
-			if(drbd_bm_init(mdev)) {
-				retcode = ERR_NOMEM;
-				goto fail_rcu_unlock;
-			}
-		}
-	}
-	rcu_read_unlock();
-
-	if (new_conf->on_congestion != OC_BLOCK && new_conf->wire_protocol != DRBD_PROT_A) {
-		retcode = ERR_CONG_NOT_PROTO_A;
+	retcode = check_net_options(tconn, new_conf);
+	if (retcode != NO_ERROR)
 		goto fail;
-	}
 
 	retcode = NO_ERROR;
 
@@ -2074,8 +2087,6 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	drbd_adm_finish(info, retcode);
 	return 0;
 
-fail_rcu_unlock:
-	rcu_read_unlock();
 fail:
 	kfree(int_dig_in);
 	kfree(int_dig_vv);
-- 
1.7.4.1

