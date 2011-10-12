Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1JLM1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:27:46 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33943 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1JLM1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:27:43 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/13] drbd: Rename --dry-run to --tentative
Date: Wed, 12 Oct 2011 14:27:34 +0200
Message-Id: <1318422455-17539-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

drbdadm already has a --dry-run option, so this option cannot directly be
passed through to drbdsetup.  Rename the drbdsetup option to resolve this
conflict.

For backward compatibility, make --dry-run an alias of --tentative.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c     |    4 ++--
 drivers/block/drbd/drbd_receiver.c |    6 +++---
 include/linux/drbd_genl.h          |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a67b4ca..1f53f95 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -926,7 +926,7 @@ int __drbd_send_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd)
 	rcu_read_lock();
 	nc = rcu_dereference(tconn->net_conf);
 
-	if (nc->dry_run && tconn->agreed_pro_version < 92) {
+	if (nc->tentative && tconn->agreed_pro_version < 92) {
 		rcu_read_unlock();
 		mutex_unlock(&sock->mutex);
 		conn_err(tconn, "--dry-run is not supported by peer");
@@ -945,7 +945,7 @@ int __drbd_send_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd)
 	cf = 0;
 	if (nc->discard_my_data)
 		cf |= CF_DISCARD_MY_DATA;
-	if (nc->dry_run)
+	if (nc->tentative)
 		cf |= CF_DRY_RUN;
 	p->conn_flags    = cpu_to_be32(cf);
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index ab1d36c..d55a3cb 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2836,7 +2836,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_conf *mdev, enum drbd_rol
 	enum drbd_conns rv = C_MASK;
 	enum drbd_disk_state mydisk;
 	struct net_conf *nc;
-	int hg, rule_nr, rr_conflict, dry_run;
+	int hg, rule_nr, rr_conflict, tentative;
 
 	mydisk = mdev->state.disk;
 	if (mydisk == D_NEGOTIATING)
@@ -2916,7 +2916,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_conf *mdev, enum drbd_rol
 			     (hg < 0) ? "peer" : "this");
 	}
 	rr_conflict = nc->rr_conflict;
-	dry_run = nc->dry_run;
+	tentative = nc->tentative;
 	rcu_read_unlock();
 
 	if (hg == -100) {
@@ -2949,7 +2949,7 @@ static enum drbd_conns drbd_sync_handshake(struct drbd_conf *mdev, enum drbd_rol
 		}
 	}
 
-	if (dry_run || test_bit(CONN_DRY_RUN, &mdev->tconn->flags)) {
+	if (tentative || test_bit(CONN_DRY_RUN, &mdev->tconn->flags)) {
 		if (hg == 0)
 			dev_info(DEV, "dry-run connect: No resync, would become Connected immediately.\n");
 		else
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index b93db6c..e879a93 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -164,7 +164,7 @@ GENL_struct(DRBD_NLA_NET_CONF, 5, net_conf,
 	__flg_field(25, DRBD_GENLA_F_MANDATORY | DRBD_F_INVARIANT,	discard_my_data)
 	__flg_field_def(26, DRBD_GENLA_F_MANDATORY,	tcp_cork, DRBD_TCP_CORK_DEF)
 	__flg_field_def(27, DRBD_GENLA_F_MANDATORY,	always_asbp, DRBD_ALWAYS_ASBP_DEF)
-	__flg_field(28, DRBD_GENLA_F_MANDATORY | DRBD_F_INVARIANT,	dry_run)
+	__flg_field(28, DRBD_GENLA_F_MANDATORY | DRBD_F_INVARIANT,	tentative)
 	__flg_field_def(29,	DRBD_GENLA_F_MANDATORY,	use_rle, DRBD_USE_RLE_DEF)
 )
 
-- 
1.7.4.1

