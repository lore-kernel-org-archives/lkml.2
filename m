Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965433Ab1JGL3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:29:07 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35876 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759732Ab1JGL1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:27:51 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/12] drbd: Rename the want_lose field/flag to discard_my_data
Date: Fri,  7 Oct 2011 13:27:39 +0200
Message-Id: <1317986865-3706-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
References: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

This is what it is called in config files and on the command line as
well.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_main.c     |    6 +++---
 drivers/block/drbd/drbd_nl.c       |    4 ++--
 drivers/block/drbd/drbd_receiver.c |   14 +++++++-------
 include/linux/drbd_genl.h          |    2 +-
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 56b190c..fa36757 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -413,7 +413,7 @@ struct p_rs_param_95 {
 } __packed;
 
 enum drbd_conn_flags {
-	CF_WANT_LOSE = 1,
+	CF_DISCARD_MY_DATA = 1,
 	CF_DRY_RUN = 2,
 };
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index dd5b56c..a3154be 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -943,8 +943,8 @@ int __drbd_send_protocol(struct drbd_tconn *tconn)
 	p->after_sb_2p   = cpu_to_be32(nc->after_sb_2p);
 	p->two_primaries = cpu_to_be32(nc->two_primaries);
 	cf = 0;
-	if (nc->want_lose)
-		cf |= CF_WANT_LOSE;
+	if (nc->discard_my_data)
+		cf |= CF_DISCARD_MY_DATA;
 	if (nc->dry_run)
 		cf |= CF_DRY_RUN;
 	p->conn_flags    = cpu_to_be32(cf);
@@ -988,7 +988,7 @@ int _drbd_send_uuids(struct drbd_conf *mdev, u64 uuid_flags)
 	mdev->comm_bm_set = drbd_bm_total_weight(mdev);
 	p->uuid[UI_SIZE] = cpu_to_be64(mdev->comm_bm_set);
 	rcu_read_lock();
-	uuid_flags |= rcu_dereference(mdev->tconn->net_conf)->want_lose ? 1 : 0;
+	uuid_flags |= rcu_dereference(mdev->tconn->net_conf)->discard_my_data ? 1 : 0;
 	rcu_read_unlock();
 	uuid_flags |= test_bit(CRASHED_PRIMARY, &mdev->flags) ? 2 : 0;
 	uuid_flags |= mdev->new_state_tmp.disk == D_INCONSISTENT ? 4 : 0;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index caa8ba2..64de372 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -628,7 +628,7 @@ drbd_set_role(struct drbd_conf *mdev, enum drbd_role new_role, int force)
 		mutex_lock(&mdev->tconn->conf_update);
 		nc = mdev->tconn->net_conf;
 		if (nc)
-			nc->want_lose = 0; /* without copy; single bit op is atomic */
+			nc->discard_my_data = 0; /* without copy; single bit op is atomic */
 		mutex_unlock(&mdev->tconn->conf_update);
 
 		set_disk_ro(mdev->vdisk, false);
@@ -1774,7 +1774,7 @@ _check_net_options(struct drbd_tconn *tconn, struct net_conf *old_conf, struct n
 			if (new_conf->wire_protocol == DRBD_PROT_A && fp == FP_STONITH)
 				return ERR_STONITH_AND_PROT_A;
 		}
-		if (mdev->state.role == R_PRIMARY && new_conf->want_lose)
+		if (mdev->state.role == R_PRIMARY && new_conf->discard_my_data)
 			return ERR_DISCARD;
 
 		if (!mdev->bitmap) {
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index aa42967..e4e8f8a 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2908,9 +2908,9 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_conf *mdev, enum drbd_rol
 	}
 
 	if (hg == -100) {
-		if (nc->want_lose && !(mdev->p_uuid[UI_FLAGS]&1))
+		if (nc->discard_my_data && !(mdev->p_uuid[UI_FLAGS]&1))
 			hg = -1;
-		if (!nc->want_lose && (mdev->p_uuid[UI_FLAGS]&1))
+		if (!nc->discard_my_data && (mdev->p_uuid[UI_FLAGS]&1))
 			hg = 1;
 
 		if (abs(hg) < 100)
@@ -3009,7 +3009,7 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 {
 	struct p_protocol *p = pi->data;
 	int p_proto, p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
-	int p_want_lose, p_two_primaries, cf;
+	int p_discard_my_data, p_two_primaries, cf;
 	struct net_conf *nc;
 
 	p_proto		= be32_to_cpu(p->protocol);
@@ -3018,7 +3018,7 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 	p_after_sb_2p	= be32_to_cpu(p->after_sb_2p);
 	p_two_primaries = be32_to_cpu(p->two_primaries);
 	cf		= be32_to_cpu(p->conn_flags);
-	p_want_lose = cf & CF_WANT_LOSE;
+	p_discard_my_data = cf & CF_DISCARD_MY_DATA;
 
 	if (tconn->agreed_pro_version >= 87) {
 		char integrity_alg[SHARED_SECRET_MAX];
@@ -3075,8 +3075,8 @@ static int receive_protocol(struct drbd_tconn *tconn, struct packet_info *pi)
 		goto disconnect_rcu_unlock;
 	}
 
-	if (p_want_lose && nc->want_lose) {
-		conn_err(tconn, "both sides have the 'want_lose' flag set\n");
+	if (p_discard_my_data && nc->discard_my_data) {
+		conn_err(tconn, "both sides have the 'discard_my_data' flag set\n");
 		goto disconnect_rcu_unlock;
 	}
 
@@ -3806,7 +3806,7 @@ static int receive_state(struct drbd_tconn *tconn, struct packet_info *pi)
 	}
 
 	mutex_lock(&mdev->tconn->conf_update);
-	mdev->tconn->net_conf->want_lose = 0; /* without copy; single bit op is atomic */
+	mdev->tconn->net_conf->discard_my_data = 0; /* without copy; single bit op is atomic */
 	mutex_unlock(&mdev->tconn->conf_update);
 
 	drbd_md_sync(mdev); /* update connected indicator, la_size, ... */
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index eba635a..1d707f9 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -163,7 +163,7 @@ GENL_struct(DRBD_NLA_NET_CONF, 5, net_conf,
 	__u32_field_def(24,	GENLA_F_MANDATORY,	cong_fill, DRBD_CONG_FILL_DEF)
 	__u32_field_def(25,	GENLA_F_MANDATORY,	cong_extents, DRBD_CONG_EXTENTS_DEF)
 	__flg_field_def(26, GENLA_F_MANDATORY,	two_primaries, DRBD_ALLOW_TWO_PRIMARIES_DEF)
-	__flg_field(27, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	want_lose)
+	__flg_field(27, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	discard_my_data)
 	__flg_field_def(28, GENLA_F_MANDATORY,	tcp_cork, DRBD_TCP_CORK_DEF)
 	__flg_field_def(29, GENLA_F_MANDATORY,	always_asbp, DRBD_ALWAYS_ASBP_DEF)
 	__flg_field(30, GENLA_F_MANDATORY | GENLA_F_INVARIANT,	dry_run)
-- 
1.7.4.1

