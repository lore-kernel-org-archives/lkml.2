Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2CLAtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:49:17 -0400
Received: from 1wt.eu ([62.212.114.60]:63042 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab2CLAsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:17 -0400
Message-Id: <20120312002046.081639698@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:20:48 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 03/12] writeback: fixups for !dirty_writeback_centisecs
In-Reply-To: <feb44625a10a45049eddf27890e95d54@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <jens.axboe@oracle.com>

commit 6423104b6a1e6f0c18be60e8c33f02d263331d5e upstream.

Commit 69b62d01 fixed up most of the places where we would enter
busy schedule() spins when disabling the periodic background
writeback. This fixes up the sb timer so that it doesn't get
hammered on with the delay disabled, and ensures that it gets
rearmed if needed when /proc/sys/vm/dirty_writeback_centisecs
gets modified.

bdi_forker_task() also needs to check for !dirty_writeback_centisecs
and use schedule() appropriately, fix that up too.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Tested-by: Xavier Roche <roche@httrack.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 include/linux/backing-dev.h |    1 +
 mm/backing-dev.c            |   15 ++++++++++-----
 mm/page-writeback.c         |    1 +
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index b449e73..61e43a6 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -105,6 +105,7 @@ void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 				long nr_pages);
 int bdi_writeback_task(struct bdi_writeback *wb);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
+void bdi_arm_supers_timer(void);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 67a33a5..d824401 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -41,7 +41,6 @@ static struct timer_list sync_supers_timer;
 
 static int bdi_sync_supers(void *);
 static void sync_supers_timer_fn(unsigned long);
-static void arm_supers_timer(void);
 
 static void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
 
@@ -242,7 +241,7 @@ static int __init default_bdi_init(void)
 
 	init_timer(&sync_supers_timer);
 	setup_timer(&sync_supers_timer, sync_supers_timer_fn, 0);
-	arm_supers_timer();
+	bdi_arm_supers_timer();
 
 	err = bdi_init(&default_backing_dev_info);
 	if (!err)
@@ -364,10 +363,13 @@ static int bdi_sync_supers(void *unused)
 	return 0;
 }
 
-static void arm_supers_timer(void)
+void bdi_arm_supers_timer(void)
 {
 	unsigned long next;
 
+	if (!dirty_writeback_interval)
+		return;
+
 	next = msecs_to_jiffies(dirty_writeback_interval * 10) + jiffies;
 	mod_timer(&sync_supers_timer, round_jiffies_up(next));
 }
@@ -375,7 +377,7 @@ static void arm_supers_timer(void)
 static void sync_supers_timer_fn(unsigned long unused)
 {
 	wake_up_process(sync_supers_tsk);
-	arm_supers_timer();
+	bdi_arm_supers_timer();
 }
 
 static int bdi_forker_task(void *ptr)
@@ -418,7 +420,10 @@ static int bdi_forker_task(void *ptr)
 
 			spin_unlock_bh(&bdi_lock);
 			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
-			schedule_timeout(wait);
+			if (wait)
+				schedule_timeout(wait);
+			else
+				schedule();
 			try_to_freeze();
 			continue;
 		}
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2c5d792..52f71ae 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -694,6 +694,7 @@ int dirty_writeback_centisecs_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, buffer, length, ppos);
+	bdi_arm_supers_timer();
 	return 0;
 }
 
-- 
1.7.2.1.45.g54fbc



