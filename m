Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab0JONgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:36:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:59959 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab0JONgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:36:13 -0400
Message-ID: <4CB858C8.30203@kernel.org>
Date: Fri, 15 Oct 2010 15:36:08 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2.6.36-rc7] md: fix and update workqueue usage
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 13:36:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue usage in md has two problems.

* Flush can be used during or depended upon by memory reclaim, but md
  uses the system workqueue for flush_work which may lead to deadlock.

* md depends on flush_scheduled_work() to achieve exclusion against
  completion of removal of previous instances.  flush_scheduled_work()
  may incur unexpected amount of delay and is scheduled to be removed.

This patch adds two workqueues to md - md_wq and md_misc_wq.  The
former is guaranteed to make forward progress under memory pressure
and serves flush_work.  The latter serves as the flush domain for
other works.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Neil, this patch doesn't conflict with the pending barrier changes in
block tree and should be safe to apply to md tree.

Thanks.

 drivers/md/md.c |   64 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 21 deletions(-)

Index: work/drivers/md/md.c
===================================================================
--- work.orig/drivers/md/md.c
+++ work/drivers/md/md.c
@@ -68,6 +68,8 @@ static DEFINE_SPINLOCK(pers_lock);
 static void md_print_devices(void);

 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
+static struct workqueue_struct *md_wq;
+static struct workqueue_struct *md_misc_wq;

 #define MD_BUG(x...) { printk("md: bug in file %s, line %d\n", __FILE__, __LINE__); md_print_devices(); }

@@ -299,7 +301,7 @@ static void md_end_flush(struct bio *bio

 	if (atomic_dec_and_test(&mddev->flush_pending)) {
 		/* The pre-request flush has finished */
-		schedule_work(&mddev->flush_work);
+		queue_work(md_wq, &mddev->flush_work);
 	}
 	bio_put(bio);
 }
@@ -368,7 +370,7 @@ void md_flush_request(mddev_t *mddev, st
 	submit_flushes(mddev);

 	if (atomic_dec_and_test(&mddev->flush_pending))
-		schedule_work(&mddev->flush_work);
+		queue_work(md_wq, &mddev->flush_work);
 }
 EXPORT_SYMBOL(md_flush_request);

@@ -435,14 +437,13 @@ static void mddev_put(mddev_t *mddev)
 		 * so destroy it */
 		list_del(&mddev->all_mddevs);
 		if (mddev->gendisk) {
-			/* we did a probe so need to clean up.
-			 * Call schedule_work inside the spinlock
-			 * so that flush_scheduled_work() after
-			 * mddev_find will succeed in waiting for the
-			 * work to be done.
+			/* We did a probe so need to clean up.  Call
+			 * queue_work inside the spinlock so that
+			 * flush_workqueue() after mddev_find will
+			 * succeed in waiting for the work to be done.
 			 */
 			INIT_WORK(&mddev->del_work, mddev_delayed_delete);
-			schedule_work(&mddev->del_work);
+			queue_work(md_misc_wq, &mddev->del_work);
 		} else
 			kfree(mddev);
 	}
@@ -1849,7 +1850,7 @@ static void unbind_rdev_from_array(mdk_r
 	synchronize_rcu();
 	INIT_WORK(&rdev->del_work, md_delayed_delete);
 	kobject_get(&rdev->kobj);
-	schedule_work(&rdev->del_work);
+	queue_work(md_misc_wq, &rdev->del_work);
 }

 /*
@@ -4191,10 +4192,10 @@ static int md_alloc(dev_t dev, char *nam
 	shift = partitioned ? MdpMinorShift : 0;
 	unit = MINOR(mddev->unit) >> shift;

-	/* wait for any previous instance if this device
-	 * to be completed removed (mddev_delayed_delete).
+	/* wait for any previous instance if this device to be
+	 * completely removed (mddev_delayed_delete).
 	 */
-	flush_scheduled_work();
+	flush_workqueue(md_misc_wq);

 	mutex_lock(&disks_mutex);
 	error = -EEXIST;
@@ -5891,7 +5892,7 @@ static int md_open(struct block_device *
 		 */
 		mddev_put(mddev);
 		/* Wait until bdev->bd_disk is definitely gone */
-		flush_scheduled_work();
+		flush_workqueue(md_misc_wq);
 		/* Then retry the open from the top */
 		unlock_kernel();
 		return -ERESTARTSYS;
@@ -6051,7 +6052,7 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 	if (mddev->event_work.func)
-		schedule_work(&mddev->event_work);
+		queue_work(md_misc_wq, &mddev->event_work);
 	md_new_event_inintr(mddev);
 }

@@ -7211,12 +7212,23 @@ static void md_geninit(void)

 static int __init md_init(void)
 {
-	if (register_blkdev(MD_MAJOR, "md"))
-		return -1;
-	if ((mdp_major=register_blkdev(0, "mdp"))<=0) {
-		unregister_blkdev(MD_MAJOR, "md");
-		return -1;
-	}
+	int ret = -ENOMEM;
+
+	md_wq = alloc_workqueue("md", WQ_RESCUER, 0);
+	if (!md_wq)
+		goto err_wq;
+
+	md_misc_wq = alloc_workqueue("md_misc", 0, 0);
+	if (!md_misc_wq)
+		goto err_misc_wq;
+
+	if ((ret = register_blkdev(MD_MAJOR, "md")) < 0)
+		goto err_md;
+
+	if ((ret = register_blkdev(0, "mdp")) < 0)
+		goto err_mdp;
+	mdp_major = ret;
+
 	blk_register_region(MKDEV(MD_MAJOR, 0), 1UL<<MINORBITS, THIS_MODULE,
 			    md_probe, NULL, NULL);
 	blk_register_region(MKDEV(mdp_major, 0), 1UL<<MINORBITS, THIS_MODULE,
@@ -7227,8 +7239,16 @@ static int __init md_init(void)

 	md_geninit();
 	return 0;
-}

+err_mdp:
+	unregister_blkdev(MD_MAJOR, "md");
+err_md:
+	destroy_workqueue(md_misc_wq);
+err_misc_wq:
+	destroy_workqueue(md_wq);
+err_wq:
+	return ret;
+}

 #ifndef MODULE

@@ -7315,6 +7335,8 @@ static __exit void md_exit(void)
 		export_array(mddev);
 		mddev->hold_active = 0;
 	}
+	destroy_workqueue(md_misc_wq);
+	destroy_workqueue(md_wq);
 }

 subsys_initcall(md_init);
