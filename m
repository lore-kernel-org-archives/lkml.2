Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab0GSAm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 20:42:56 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42008 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757803Ab0GSAmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 20:42:55 -0400
Message-ID: <4C439F89.5090609@fusionio.com>
Date: Sun, 18 Jul 2010 18:42:49 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Martin Pirker <lkml.collector@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc5 inconsistent lock state
References: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>	<201007142304.48660.rjw@sisk.pl>	<AANLkTin5Bj6HEEriLVFDQKptrZHmh698TsnMWHzVYt5H@mail.gmail.com>	<4C42099C.3070708@kernel.dk> <AANLkTikk_UNVoo9CC9DhCSwiI5mEB3j1RrXqqOPdei1L@mail.gmail.com> <4C439ED5.8010002@kernel.dk>
In-Reply-To: <4C439ED5.8010002@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2010 06:39 PM, Jens Axboe wrote:
> On 07/18/2010 11:56 AM, Martin Pirker wrote:
>> On Sat, Jul 17, 2010 at 9:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>> Can anyone try this completed untested patch?
>>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index 5ab3ac2..a108b8e 100644
>> ....
>>
>> /usr/src/linux-2.6.35-rc5 # patch -p1 <jens.patch
>> patching file block/blk-core.c
>> Hunk #1 FAILED at 451.
>> Hunk #2 FAILED at 515.
>> 2 out of 2 hunks FAILED -- saving rejects to file block/blk-core.c.rej
>> patching file include/linux/backing-dev.h
>> Hunk #1 FAILED at 84.
>> 1 out of 1 hunk FAILED -- saving rejects to file include/linux/backing-dev.h.rej
>> patching file include/linux/writeback.h
>> patching file mm/page-writeback.c
>> Hunk #1 FAILED at 698.
>> Hunk #2 FAILED at 719.
>> Hunk #3 FAILED at 739.
>> 3 out of 3 hunks FAILED -- saving rejects to file mm/page-writeback.c.rej
>>
>>
>> ummmm.... help?
> 
> Oh, the patch is for the next branches. I'll see if I can fiddle it into
> .35-rcX

The patch applies fine to 2.6.35-rc5:

axboe@carl:[.]axboe/git/linux-2.6-block $ patch -p1 --dry-run < ~/f
patching file block/blk-core.c
patching file include/linux/backing-dev.h
Hunk #1 succeeded at 87 (offset 3 lines).
patching file include/linux/writeback.h
patching file mm/page-writeback.c
Hunk #1 succeeded at 694 (offset -4 lines).
Hunk #2 succeeded at 715 (offset -4 lines).
Hunk #3 succeeded at 735 (offset -4 lines).

Including it again here below, check that your mailer isn't screwing it
up.


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

