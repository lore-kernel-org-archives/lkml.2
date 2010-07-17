Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126Ab0GQTut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 15:50:49 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44308 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab0GQTus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 15:50:48 -0400
Message-ID: <4C42099C.3070708@kernel.dk>
Date: Sat, 17 Jul 2010 13:50:52 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dan Carpenter <error27.lkml@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Martin Pirker <lkml.collector@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>, mjg@redhat.com
Subject: Re: 2.6.35-rc5 inconsistent lock state
References: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>	<201007142304.48660.rjw@sisk.pl> <AANLkTin5Bj6HEEriLVFDQKptrZHmh698TsnMWHzVYt5H@mail.gmail.com>
In-Reply-To: <AANLkTin5Bj6HEEriLVFDQKptrZHmh698TsnMWHzVYt5H@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2010 01:04 PM, Dan Carpenter wrote:
> This is from:
> 
> commit 31373d09da5b7fe21fe6f781e92bd534a3495f00
> Author: Matthew Garrett <mjg@redhat.com>
> Date:   Tue Apr 6 14:25:14 2010 +0200
> 
>     laptop-mode: Make flushes per-device
> 
>     One of the features of laptop-mode is that it forces a writeout of dirty
>     pages if something else triggers a physical read or write from a device.
>     The current implementation flushes pages on all devices, rather than only
>     the one that triggered the flush. This patch alters the behaviour so that
>     only the recently accessed block device is flushed, preventing other
>     disks being spun up for no terribly good reason.
> 
> One way to fix it might be to change all the places that call
> spin_lock(&bdi->wb_lock); to spin_lock_bh(&bdi->wb_lock); but I'm not
> sure that's the right way.
> 
> I don't think Matthew Garrett has a bugzilla account?

I posted a patch for this the other day, but I just now notice
that it was a private list of CC addresses.

Can anyone try this completed untested patch?

diff --git a/block/blk-core.c b/block/blk-core.c
index 5ab3ac2..a108b8e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -451,7 +451,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	 */
 	blk_sync_queue(q);
 
-	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
+	cancel_delayed_work_sync(&q->backing_dev_info.laptop_mode_work);
 	mutex_lock(&q->sysfs_lock);
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
@@ -515,8 +515,9 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 		return NULL;
 	}
 
-	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
-		    laptop_mode_timer_fn, (unsigned long) q);
+	
+	INIT_DELAYED_WORK(&q->backing_dev_info.laptop_mode_work,
+				laptop_mode_work_fn);
 	init_timer(&q->unplug_timer);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index e536f3a..d51acff 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -84,7 +84,7 @@ struct backing_dev_info {
 
 	struct device *dev;
 
-	struct timer_list laptop_mode_wb_timer;
+	struct delayed_work laptop_mode_work;
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debug_dir;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index c24eca7..936ef5a 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -87,8 +87,7 @@ static inline void inode_sync_wait(struct inode *inode)
 #ifdef CONFIG_BLOCK
 void laptop_io_completion(struct backing_dev_info *info);
 void laptop_sync_completion(void);
-void laptop_mode_sync(struct work_struct *work);
-void laptop_mode_timer_fn(unsigned long data);
+void laptop_mode_work_fn(struct work_struct *);
 #else
 static inline void laptop_sync_completion(void) { }
 #endif
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3d2111a..9978e8e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -698,18 +698,20 @@ int dirty_writeback_centisecs_handler(ctl_table *table, int write,
 }
 
 #ifdef CONFIG_BLOCK
-void laptop_mode_timer_fn(unsigned long data)
+void laptop_mode_work_fn(struct work_struct *work)
 {
-	struct request_queue *q = (struct request_queue *)data;
+	struct backing_dev_info *bdi;
 	int nr_pages = global_page_state(NR_FILE_DIRTY) +
 		global_page_state(NR_UNSTABLE_NFS);
 
+	bdi = container_of(work, struct backing_dev_info, laptop_mode_work.work);
+
 	/*
 	 * We want to write everything out, not just down to the dirty
 	 * threshold
 	 */
-	if (bdi_has_dirty_io(&q->backing_dev_info))
-		bdi_start_writeback(&q->backing_dev_info, nr_pages);
+	if (bdi_has_dirty_io(bdi))
+		bdi_start_writeback(bdi, nr_pages);
 }
 
 /*
@@ -717,9 +719,12 @@ void laptop_mode_timer_fn(unsigned long data)
  * of all dirty data a few seconds from now.  If the flush is already scheduled
  * then push it back - the user is still using the disk.
  */
-void laptop_io_completion(struct backing_dev_info *info)
+void laptop_io_completion(struct backing_dev_info *bdi)
 {
-	mod_timer(&info->laptop_mode_wb_timer, jiffies + laptop_mode);
+	if (work_pending(&bdi->laptop_mode_work.work))
+		mod_timer(&bdi->laptop_mode_work.timer, jiffies + laptop_mode);
+	else
+		schedule_delayed_work(&bdi->laptop_mode_work, laptop_mode);
 }
 
 /*
@@ -734,7 +739,7 @@ void laptop_sync_completion(void)
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list)
-		del_timer(&bdi->laptop_mode_wb_timer);
+		__cancel_delayed_work(&bdi->laptop_mode_work);
 
 	rcu_read_unlock();
 }

-- 
Jens Axboe

