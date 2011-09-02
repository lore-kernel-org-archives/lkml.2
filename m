Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab1IBKBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:01:54 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33127 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360Ab1IBKA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:00:58 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 16/16] drbd: Fixed conn_lowest_minor
Date: Fri,  2 Sep 2011 12:00:48 +0200
Message-Id: <1314957648-13242-17-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
References: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It actually returned the lowest volume number. While doing that
renamed a few wrongly named variables.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c  |   12 +++++++-----
 drivers/block/drbd/drbd_nl.c    |    4 ++--
 drivers/block/drbd/drbd_state.c |    8 ++++----
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index b1de7e8..4d6207a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -434,7 +434,7 @@ void tl_clear(struct drbd_tconn *tconn)
 	struct drbd_conf *mdev;
 	struct list_head *le, *tle;
 	struct drbd_request *r;
-	int minor;
+	int vnr;
 
 	spin_lock_irq(&tconn->req_lock);
 
@@ -453,7 +453,7 @@ void tl_clear(struct drbd_tconn *tconn)
 	}
 
 	/* ensure bit indicating barrier is required is clear */
-	idr_for_each_entry(&tconn->volumes, mdev, minor)
+	idr_for_each_entry(&tconn->volumes, mdev, vnr)
 		clear_bit(CREATE_BARRIER, &mdev->flags);
 
 	spin_unlock_irq(&tconn->req_lock);
@@ -634,11 +634,13 @@ char *drbd_task_to_thread_name(struct drbd_tconn *tconn, struct task_struct *tas
 
 int conn_lowest_minor(struct drbd_tconn *tconn)
 {
-	int minor = 0;
+	int vnr = 0;
+	struct drbd_conf *mdev;
 
-	if (!idr_get_next(&tconn->volumes, &minor))
+	mdev = idr_get_next(&tconn->volumes, &vnr);
+	if (!mdev)
 		return -1;
-	return minor;
+	return mdev_to_minor(mdev);
 }
 
 #ifdef CONFIG_SMP
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index ab22019..fe4b106 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -361,9 +361,9 @@ int drbd_khelper(struct drbd_conf *mdev, char *cmd)
 static void conn_md_sync(struct drbd_tconn *tconn)
 {
 	struct drbd_conf *mdev;
-	int minor;
+	int vnr;
 
-	idr_for_each_entry(&tconn->volumes, mdev, minor)
+	idr_for_each_entry(&tconn->volumes, mdev, vnr)
 		drbd_md_sync(mdev);
 }
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index c4a0710..42a94cd 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -51,9 +51,9 @@ static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state
 bool conn_all_vols_unconf(struct drbd_tconn *tconn)
 {
 	struct drbd_conf *mdev;
-	int minor;
+	int vnr;
 
-	idr_for_each_entry(&tconn->volumes, mdev, minor) {
+	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		if (mdev->state.disk != D_DISKLESS ||
 		    mdev->state.conn != C_STANDALONE ||
 		    mdev->state.role != R_SECONDARY)
@@ -333,9 +333,9 @@ static void print_state_change(struct drbd_conf *mdev, union drbd_state os, unio
 static bool vol_has_primary_peer(struct drbd_tconn *tconn)
 {
 	struct drbd_conf *mdev;
-	int minor;
+	int vnr;
 
-	idr_for_each_entry(&tconn->volumes, mdev, minor) {
+	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		if (mdev->state.peer == R_PRIMARY)
 			return true;
 	}
-- 
1.7.4.1

