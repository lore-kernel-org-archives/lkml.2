Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab1IBKCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:02:40 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33146 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375Ab1IBKA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:00:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 13/16] drbd: Allow volumes to become primary only on one side
Date: Fri,  2 Sep 2011 12:00:45 +0200
Message-Id: <1314957648-13242-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
References: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c   |   21 ++++++++++++++++++---
 drivers/block/drbd/drbd_strings.c |    1 +
 include/linux/drbd.h              |    3 ++-
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 37b52d7..e2686b3 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -330,6 +330,18 @@ static void print_state_change(struct drbd_conf *mdev, union drbd_state os, unio
 		dev_info(DEV, "%s\n", pb);
 }
 
+static bool vol_has_primary_peer(struct drbd_tconn *tconn)
+{
+	struct drbd_conf *mdev;
+	int minor;
+
+	idr_for_each_entry(&tconn->volumes, mdev, minor) {
+		if (mdev->state.peer == R_PRIMARY)
+			return true;
+	}
+	return false;
+}
+
 /**
  * is_valid_state() - Returns an SS_ error code if ns is not valid
  * @mdev:	DRBD device.
@@ -350,9 +362,12 @@ is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
 	}
 
 	if (get_net_conf(mdev->tconn)) {
-		if (!mdev->tconn->net_conf->two_primaries &&
-		    ns.role == R_PRIMARY && ns.peer == R_PRIMARY)
-			rv = SS_TWO_PRIMARIES;
+		if (!mdev->tconn->net_conf->two_primaries && ns.role == R_PRIMARY) {
+			if (ns.peer == R_PRIMARY)
+				rv = SS_TWO_PRIMARIES;
+			else if (vol_has_primary_peer(mdev->tconn))
+				rv = SS_O_VOL_PEER_PRI;
+			}
 		put_net_conf(mdev->tconn);
 	}
 
diff --git a/drivers/block/drbd/drbd_strings.c b/drivers/block/drbd/drbd_strings.c
index c44a2a6..9a664bd 100644
--- a/drivers/block/drbd/drbd_strings.c
+++ b/drivers/block/drbd/drbd_strings.c
@@ -89,6 +89,7 @@ static const char *drbd_state_sw_errors[] = {
 	[-SS_LOWER_THAN_OUTDATED] = "Disk state is lower than outdated",
 	[-SS_IN_TRANSIENT_STATE] = "In transient state, retry after next state change",
 	[-SS_CONCURRENT_ST_CHG] = "Concurrent state changes detected and aborted",
+	[-SS_O_VOL_PEER_PRI] = "Other vol primary on peer not allowed by config",
 };
 
 const char *drbd_conn_str(enum drbd_conns s)
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index d28fdd8..9cdb888 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -300,7 +300,8 @@ enum drbd_state_rv {
 	SS_NOT_SUPPORTED = -17,      /* drbd-8.2 only */
 	SS_IN_TRANSIENT_STATE = -18,  /* Retry after the next state change */
 	SS_CONCURRENT_ST_CHG = -19,   /* Concurrent cluster side state change! */
-	SS_AFTER_LAST_ERROR = -20,    /* Keep this at bottom */
+	SS_O_VOL_PEER_PRI = -20,
+	SS_AFTER_LAST_ERROR = -21,    /* Keep this at bottom */
 };
 
 /* from drbd_strings.c */
-- 
1.7.4.1

