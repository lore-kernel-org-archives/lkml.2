Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771Ab1IILSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:18:37 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45637 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278Ab1IILRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:17:42 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/11] drbd: Improved logging of state changes
Date: Fri,  9 Sep 2011 13:17:35 +0200
Message-Id: <1315567056-32314-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
References: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |   44 ++++++++++++++++++++++++++------------
 drivers/block/drbd/drbd_state.h |    3 +-
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 441d80f..694bd3f 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -366,6 +366,7 @@ static long print_state_change(char *pb, union drbd_state os, union drbd_state n
 	char *pbp;
 	pbp = pb;
 	*pbp = 0;
+
 	if (ns.role != os.role && flags & CS_DC_ROLE)
 		pbp += sprintf(pbp, "role( %s -> %s ) ",
 			       drbd_role_str(os.role),
@@ -386,10 +387,18 @@ static long print_state_change(char *pb, union drbd_state os, union drbd_state n
 		pbp += sprintf(pbp, "pdsk( %s -> %s ) ",
 			       drbd_disk_str(os.pdsk),
 			       drbd_disk_str(ns.pdsk));
-	if (is_susp(ns) != is_susp(os))
-		pbp += sprintf(pbp, "susp( %d -> %d ) ",
-			       is_susp(os),
-			       is_susp(ns));
+
+	return pbp - pb;
+}
+
+static void drbd_pr_state_change(struct drbd_conf *mdev, union drbd_state os, union drbd_state ns,
+				 enum chg_state_flags flags)
+{
+	char pb[300];
+	char *pbp = pb;
+
+	pbp += print_state_change(pbp, os, ns, flags ^ CS_DC_MASK);
+
 	if (ns.aftr_isp != os.aftr_isp)
 		pbp += sprintf(pbp, "aftr_isp( %d -> %d ) ",
 			       os.aftr_isp,
@@ -403,15 +412,7 @@ static long print_state_change(char *pb, union drbd_state os, union drbd_state n
 			       os.user_isp,
 			       ns.user_isp);
 
-	return pbp - pb;
-}
-
-static void drbd_pr_state_change(struct drbd_conf *mdev, union drbd_state os, union drbd_state ns,
-				 enum chg_state_flags flags)
-{
-	char pb[300];
-
-	if (print_state_change(pb, os, ns, flags ^ CS_DC_MASK))
+	if (pbp != pb)
 		dev_info(DEV, "%s\n", pb);
 }
 
@@ -419,8 +420,16 @@ static void conn_pr_state_change(struct drbd_tconn *tconn, union drbd_state os,
 				 enum chg_state_flags flags)
 {
 	char pb[300];
+	char *pbp = pb;
+
+	pbp += print_state_change(pbp, os, ns, flags);
 
-	if (print_state_change(pb, os, ns, flags))
+	if (is_susp(ns) != is_susp(os) && flags & CS_DC_SUSP)
+		pbp += sprintf(pbp, "susp( %d -> %d ) ",
+			       is_susp(os),
+			       is_susp(ns));
+
+	if (pbp != pb)
 		conn_info(tconn, "%s\n", pb);
 }
 
@@ -858,6 +867,12 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 
 	drbd_pr_state_change(mdev, os, ns, flags);
 
+	/* Display changes to the susp* flags that where caused by the call to
+	   sanitize_state(). Only display it here if we where not called from
+	   _conn_request_state() */
+	if (!(flags & CS_DC_SUSP))
+		conn_pr_state_change(mdev->tconn, os, ns, (flags & ~CS_DC_MASK) | CS_DC_SUSP);
+
 	/* if we are going -> D_FAILED or D_DISKLESS, grab one extra reference
 	 * on the ldev here, to be sure the transition -> D_DISKLESS resp.
 	 * drbd_ldev_destroy() won't happen before our corresponding
@@ -1610,6 +1625,7 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 	}
 
 	conn_old_common_state(tconn, &os, &flags);
+	flags |= CS_DC_SUSP;
 	conn_set_state(tconn, mask, val, &ns_min, &ns_max, flags);
 	conn_pr_state_change(tconn, os, ns_max, flags);
 
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index 72e2053..a49bece 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -68,8 +68,9 @@ enum chg_state_flags {
 	CS_DC_CONN       = 1 << 7,
 	CS_DC_DISK       = 1 << 8,
 	CS_DC_PDSK       = 1 << 9,
+	CS_DC_SUSP       = 1 << 10,
 	CS_DC_MASK       = CS_DC_ROLE + CS_DC_PEER + CS_DC_CONN + CS_DC_DISK + CS_DC_PDSK,
-	CS_IGN_OUTD_FAIL = 1 << 10,
+	CS_IGN_OUTD_FAIL = 1 << 11,
 };
 
 /* drbd_dev_state and drbd_state are different types. This is to stress the
-- 
1.7.4.1

