Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965Ab1DNShJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:37:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:37255 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab1DNRpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, NeilBrown <neilb@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 008/209] md: fix another deadlock with removing sysfs attributes.
Date: Thu, 14 Apr 2011 13:40:38 -0400
Message-Id: <1302803039-9400-9-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit bb4f1e9d0e2ef93de8e36ca0f5f26625fcd70b7d upstream.

Move the deletion of sysfs attributes from reconfig_mutex to
open_mutex didn't really help as a process can try to take
open_mutex while holding reconfig_mutex, so the same deadlock can
happen, just requiring one more process to be involved in the chain.

I looks like I cannot easily use locking to wait for the sysfs
deletion to complete, so don't.

The only things that we cannot do while the deletions are still
pending is other things which can change the sysfs namespace: run,
takeover, stop.  Each of these can fail with -EBUSY.
So set a flag while doing a sysfs deletion, and fail run, takeover,
stop if that flag is set.

This is suitable for 2.6.35.x

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/md.c |   31 +++++++++++++++++--------------
 drivers/md/md.h |    4 ++++
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 336792e..81c0282 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -517,13 +517,17 @@ static void mddev_unlock(mddev_t * mddev)
 		 * an access to the files will try to take reconfig_mutex
 		 * while holding the file unremovable, which leads to
 		 * a deadlock.
-		 * So hold open_mutex instead - we are allowed to take
-		 * it while holding reconfig_mutex, and md_run can
-		 * use it to wait for the remove to complete.
+		 * So hold set sysfs_active while the remove in happeing,
+		 * and anything else which might set ->to_remove or my
+		 * otherwise change the sysfs namespace will fail with
+		 * -EBUSY if sysfs_active is still set.
+		 * We set sysfs_active under reconfig_mutex and elsewhere
+		 * test it under the same mutex to ensure its correct value
+		 * is seen.
 		 */
 		struct attribute_group *to_remove = mddev->to_remove;
 		mddev->to_remove = NULL;
-		mutex_lock(&mddev->open_mutex);
+		mddev->sysfs_active = 1;
 		mutex_unlock(&mddev->reconfig_mutex);
 
 		if (to_remove != &md_redundancy_group)
@@ -535,7 +539,7 @@ static void mddev_unlock(mddev_t * mddev)
 				sysfs_put(mddev->sysfs_action);
 			mddev->sysfs_action = NULL;
 		}
-		mutex_unlock(&mddev->open_mutex);
+		mddev->sysfs_active = 0;
 	} else
 		mutex_unlock(&mddev->reconfig_mutex);
 
@@ -2949,7 +2953,9 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	 *  - new personality will access other array.
 	 */
 
-	if (mddev->sync_thread || mddev->reshape_position != MaxSector)
+	if (mddev->sync_thread ||
+	    mddev->reshape_position != MaxSector ||
+	    mddev->sysfs_active)
 		return -EBUSY;
 
 	if (!mddev->pers->quiesce) {
@@ -4282,13 +4288,9 @@ static int do_md_run(mddev_t * mddev)
 
 	if (mddev->pers)
 		return -EBUSY;
-
-	/* These two calls synchronise us with the
-	 * sysfs_remove_group calls in mddev_unlock,
-	 * so they must have completed.
-	 */
-	mutex_lock(&mddev->open_mutex);
-	mutex_unlock(&mddev->open_mutex);
+	/* Cannot run until previous stop completes properly */
+	if (mddev->sysfs_active)
+		return -EBUSY;
 
 	/*
 	 * Analyze all RAID superblock(s)
@@ -4545,7 +4547,8 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 	mdk_rdev_t *rdev;
 
 	mutex_lock(&mddev->open_mutex);
-	if (atomic_read(&mddev->openers) > is_open) {
+	if (atomic_read(&mddev->openers) > is_open ||
+	    mddev->sysfs_active) {
 		printk("md: %s still in use.\n",mdname(mddev));
 		err = -EBUSY;
 	} else if (mddev->pers) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 722f5df..1d49c4e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -125,6 +125,10 @@ struct mddev_s
 	int				suspended;
 	atomic_t			active_io;
 	int				ro;
+	int				sysfs_active; /* set when sysfs deletes
+						       * are happening, so run/
+						       * takeover/stop are not safe
+						       */
 
 	struct gendisk			*gendisk;
 
-- 
1.7.4.4

