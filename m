Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab0GAVQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:16:31 -0400
Received: from kroah.org ([198.145.64.141]:60961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759017Ab0GAVN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:58 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:53 2010
Message-Id: <20100701174253.851931565@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [088/200] md: remove unneeded sysfs files more promptly
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit b6eb127d274385d81ce8dd45c98190f097bce1b4 upstream.

When an array is stopped we need to remove some
sysfs files which are dependent on the type of array.

We need to delay that deletion as deleting them while holding
reconfig_mutex can lead to deadlocks.

We currently delay them until the array is completely destroyed.
However it is possible to deactivate and then reactivate the array.
It is also possible to need to remove sysfs files when changing level,
which can potentially happen several times before an array is
destroyed.

So we need to delete these files more promptly: as soon as
reconfig_mutex is dropped.

We need to ensure this happens before do_md_run can restart the array,
so we use open_mutex for some extra locking.  This is not deadlock
prone.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |   41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -508,9 +508,32 @@ static inline int mddev_trylock(mddev_t
 	return mutex_trylock(&mddev->reconfig_mutex);
 }
 
+static struct attribute_group md_redundancy_group;
+
 static inline void mddev_unlock(mddev_t * mddev)
 {
-	mutex_unlock(&mddev->reconfig_mutex);
+	if (mddev->pers == NULL && mddev->private) {
+		/* These cannot be removed under reconfig_mutex as
+		 * an access to the files will try to take reconfig_mutex
+		 * while holding the file unremovable, which leads to
+		 * a deadlock.
+		 * So hold open_mutex instead - we are allowed to take
+		 * it while holding reconfig_mutex, and md_run can
+		 * use it to wait for the remove to complete.
+		 */
+		mutex_lock(&mddev->open_mutex);
+		mutex_unlock(&mddev->reconfig_mutex);
+
+		sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
+		if (mddev->private != (void*)1)
+			sysfs_remove_group(&mddev->kobj, mddev->private);
+		if (mddev->sysfs_action)
+			sysfs_put(mddev->sysfs_action);
+		mddev->sysfs_action = NULL;
+		mddev->private = NULL;
+		mutex_unlock(&mddev->open_mutex);
+	} else
+		mutex_unlock(&mddev->reconfig_mutex);
 
 	md_wakeup_thread(mddev->thread);
 }
@@ -4082,15 +4105,6 @@ static void mddev_delayed_delete(struct
 {
 	mddev_t *mddev = container_of(ws, mddev_t, del_work);
 
-	if (mddev->private) {
-		sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
-		if (mddev->private != (void*)1)
-			sysfs_remove_group(&mddev->kobj, mddev->private);
-		if (mddev->sysfs_action)
-			sysfs_put(mddev->sysfs_action);
-		mddev->sysfs_action = NULL;
-		mddev->private = NULL;
-	}
 	sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
 	kobject_del(&mddev->kobj);
 	kobject_put(&mddev->kobj);
@@ -4248,6 +4262,13 @@ static int do_md_run(mddev_t * mddev)
 	if (mddev->pers)
 		return -EBUSY;
 
+	/* These two calls synchronise us with the
+	 * sysfs_remove_group calls in mddev_unlock,
+	 * so they must have completed.
+	 */
+	mutex_lock(&mddev->open_mutex);
+	mutex_unlock(&mddev->open_mutex);
+
 	/*
 	 * Analyze all RAID superblock(s)
 	 */


