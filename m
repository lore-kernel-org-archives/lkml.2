Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab1JFNjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:39:10 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34174 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab1JFNiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:38:09 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/15] drbd: Enforce limits of disk_conf members; centralized these checks
Date: Thu,  6 Oct 2011 15:37:54 +0200
Message-Id: <1317908280-28951-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
References: <1317908280-28951-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index ad81227..6d05bf5 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -959,9 +959,6 @@ static int drbd_check_al_size(struct drbd_conf *mdev, struct disk_conf *dc)
 	unsigned int in_use;
 	int i;
 
-	if (!expect(dc->al_extents >= DRBD_AL_EXTENTS_MIN))
-		dc->al_extents = DRBD_AL_EXTENTS_MIN;
-
 	if (mdev->act_log &&
 	    mdev->act_log->nr_elements == dc->al_extents)
 		return 0;
@@ -1124,6 +1121,17 @@ static bool should_set_defaults(struct genl_info *info)
 	return 0 != (flags & DRBD_GENL_F_SET_DEFAULTS);
 }
 
+static void enforce_disk_conf_limits(struct disk_conf *dc)
+{
+	if (dc->al_extents < DRBD_AL_EXTENTS_MIN)
+		dc->al_extents = DRBD_AL_EXTENTS_MIN;
+	if (dc->al_extents > DRBD_AL_EXTENTS_MAX)
+		dc->al_extents = DRBD_AL_EXTENTS_MAX;
+
+	if (dc->c_plan_ahead > DRBD_C_PLAN_AHEAD_MAX)
+		dc->c_plan_ahead = DRBD_C_PLAN_AHEAD_MAX;
+}
+
 int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
@@ -1182,11 +1190,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	if (!expect(new_disk_conf->resync_rate >= 1))
 		new_disk_conf->resync_rate = 1;
 
-	/* clip to allowed range */
-	if (!expect(new_disk_conf->al_extents >= DRBD_AL_EXTENTS_MIN))
-		new_disk_conf->al_extents = DRBD_AL_EXTENTS_MIN;
-	if (!expect(new_disk_conf->al_extents <= DRBD_AL_EXTENTS_MAX))
-		new_disk_conf->al_extents = DRBD_AL_EXTENTS_MAX;
+	enforce_disk_conf_limits(new_disk_conf);
 
 	fifo_size = (new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
 	if (fifo_size != mdev->rs_plan_s->size) {
@@ -1309,6 +1313,8 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
+	enforce_disk_conf_limits(new_disk_conf);
+
 	new_plan = fifo_alloc((new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ);
 	if (!new_plan) {
 		retcode = ERR_NOMEM;
@@ -1486,8 +1492,6 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	else
 		clear_bit(MD_NO_FUA, &mdev->flags);
 
-	/* FIXME Missing stuff: clip al range */
-
 	/* Point of no return reached.
 	 * Devices and memory are no longer released by error cleanup below.
 	 * now mdev takes over responsibility, and the state engine should
-- 
1.7.4.1

