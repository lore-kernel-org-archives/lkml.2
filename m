Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659Ab0GAWHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:07:05 -0400
Received: from kroah.org ([198.145.64.141]:47582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700Ab0GAUua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:30 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:33 2010
Message-Id: <20100701173433.459540655@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 079/164] md: manage redundancy group in sysfs when changing level.
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit a64c876fd357906a1f7193723866562ad290654c upstream.

Some levels expect the 'redundancy group' to be present,
others don't.
So when we change level of an array we might need to
add or remove this group.

This requires fixing up the current practice of overloading ->private
to indicate (when ->pers == NULL) that something needs to be removed.
So create a new ->to_remove to fill that role.

When changing levels, we may need to add or remove attributes.  When
changing RAID5 -> RAID6, we both add and remove the same thing.  It is
important to catch this and optimise it out as the removal is delayed
until a lock is released, so trying to add immediately would cause
problems.


Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c    |   43 ++++++++++++++++++++++++++++++++-----------
 drivers/md/md.h    |    1 +
 drivers/md/raid5.c |    7 +++++--
 3 files changed, 38 insertions(+), 13 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -509,9 +509,9 @@ static inline int mddev_trylock(mddev_t
 
 static struct attribute_group md_redundancy_group;
 
-static inline void mddev_unlock(mddev_t * mddev)
+static void mddev_unlock(mddev_t * mddev)
 {
-	if (mddev->pers == NULL && mddev->private) {
+	if (mddev->to_remove) {
 		/* These cannot be removed under reconfig_mutex as
 		 * an access to the files will try to take reconfig_mutex
 		 * while holding the file unremovable, which leads to
@@ -520,16 +520,20 @@ static inline void mddev_unlock(mddev_t
 		 * it while holding reconfig_mutex, and md_run can
 		 * use it to wait for the remove to complete.
 		 */
+		struct attribute_group *to_remove = mddev->to_remove;
+		mddev->to_remove = NULL;
 		mutex_lock(&mddev->open_mutex);
 		mutex_unlock(&mddev->reconfig_mutex);
 
-		sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
-		if (mddev->private != (void*)1)
-			sysfs_remove_group(&mddev->kobj, mddev->private);
-		if (mddev->sysfs_action)
-			sysfs_put(mddev->sysfs_action);
-		mddev->sysfs_action = NULL;
-		mddev->private = NULL;
+		if (to_remove != &md_redundancy_group)
+			sysfs_remove_group(&mddev->kobj, to_remove);
+		if (mddev->pers == NULL ||
+		    mddev->pers->sync_request == NULL) {
+			sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
+			if (mddev->sysfs_action)
+				sysfs_put(mddev->sysfs_action);
+			mddev->sysfs_action = NULL;
+		}
 		mutex_unlock(&mddev->open_mutex);
 	} else
 		mutex_unlock(&mddev->reconfig_mutex);
@@ -3002,6 +3006,23 @@ level_store(mddev_t *mddev, const char *
 	/* Looks like we have a winner */
 	mddev_suspend(mddev);
 	mddev->pers->stop(mddev);
+
+	if (mddev->pers->sync_request == NULL &&
+	    pers->sync_request != NULL) {
+		/* need to add the md_redundancy_group */
+		if (sysfs_create_group(&mddev->kobj, &md_redundancy_group))
+			printk(KERN_WARNING
+			       "md: cannot register extra attributes for %s\n",
+			       mdname(mddev));
+		mddev->sysfs_action = sysfs_get_dirent(mddev->kobj.sd, "sync_action");
+	}
+	if (mddev->pers->sync_request != NULL &&
+	    pers->sync_request == NULL) {
+		/* need to remove the md_redundancy_group */
+		if (mddev->to_remove == NULL)
+			mddev->to_remove = &md_redundancy_group;
+	}
+
 	module_put(mddev->pers->owner);
 	/* Invalidate devices that are now superfluous */
 	list_for_each_entry(rdev, &mddev->disks, same_set)
@@ -4556,8 +4577,8 @@ static int do_md_stop(mddev_t * mddev, i
 			mddev->queue->unplug_fn = NULL;
 			mddev->queue->backing_dev_info.congested_fn = NULL;
 			module_put(mddev->pers->owner);
-			if (mddev->pers->sync_request && mddev->private == NULL)
-				mddev->private = (void*)1;
+			if (mddev->pers->sync_request && mddev->to_remove == NULL)
+				mddev->to_remove = &md_redundancy_group;
 			mddev->pers = NULL;
 			/* tell userspace to handle 'inactive' */
 			sysfs_notify_dirent(mddev->sysfs_state);
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -305,6 +305,7 @@ struct mddev_s
 	atomic_t 			max_corr_read_errors; /* max read retries */
 	struct list_head		all_mddevs;
 
+	struct attribute_group		*to_remove;
 	/* Generic barrier handling.
 	 * If there is a pending barrier request, all other
 	 * writes are blocked while the devices are flushed.
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5086,7 +5086,9 @@ static int run(mddev_t *mddev)
 	}
 
 	/* Ok, everything is just fine now */
-	if (sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
+	if (mddev->to_remove == &raid5_attrs_group)
+		mddev->to_remove = NULL;
+	else if (sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
 		printk(KERN_WARNING
 		       "raid5: failed to create sysfs attributes for %s\n",
 		       mdname(mddev));
@@ -5133,7 +5135,8 @@ static int stop(mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_fn = NULL;
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	free_conf(conf);
-	mddev->private = &raid5_attrs_group;
+	mddev->private = NULL;
+	mddev->to_remove = &raid5_attrs_group;
 	return 0;
 }
 


