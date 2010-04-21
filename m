Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0DUWT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:19:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798Ab0DUWTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:19:25 -0400
Date: Wed, 21 Apr 2010 18:19:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Divyesh Shah <dpshah@google.com>, Nauman Rafique <nauman@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH] blkio: Fix another BUG_ON() crash due to cfqq movement
	across groups
Message-ID: <20100421221906.GG3275@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Once in a while, I was hitting a BUG_ON() in blkio code. empty_time was
  assuming that upon slice expiry, group can't be marked empty already (except
  forced dispatch).

  But this assumption is broken if cfqq can move (group_isolation=0) across
  groups after receiving a request.

  I think most likely in this case we got a request in a cfqq and accounted
  the rq in one group, later while adding the cfqq to tree, we moved the queue
  to a different group which was already marked empty and after dispatch from
  slice we found group already marked empty and raised alarm.

  This patch does not error out if group is already marked empty. This can
  introduce some empty_time stat error only in case of group_isolation=0. This
  is better than crashing. In case of group_isolation=1 we should still get
  same stats as before this patch.

[  222.308546] ------------[ cut here ]------------
[  222.309311] kernel BUG at block/blk-cgroup.c:236!
[  222.309311] invalid opcode: 0000 [#1] SMP
[  222.309311] last sysfs file: /sys/devices/virtual/block/dm-3/queue/scheduler
[  222.309311] CPU 1
[  222.309311] Modules linked in: dm_round_robin dm_multipath qla2xxx scsi_transport_fc dm_zero dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_wait_scan]
[  222.309311]
[  222.309311] Pid: 4780, comm: fio Not tainted 2.6.34-rc4-blkio-config #68 0A98h/HP xw8600 Workstation
[  222.309311] RIP: 0010:[<ffffffff8121ad88>]  [<ffffffff8121ad88>] blkiocg_set_start_empty_time+0x50/0x83
[  222.309311] RSP: 0018:ffff8800ba6e79f8  EFLAGS: 00010002
[  222.309311] RAX: 0000000000000082 RBX: ffff8800a13b7990 RCX: ffff8800a13b7808
[  222.309311] RDX: 0000000000002121 RSI: 0000000000000082 RDI: ffff8800a13b7a30
[  222.309311] RBP: ffff8800ba6e7a18 R08: 0000000000000000 R09: 0000000000000001
[  222.309311] R10: 000000000002f8c8 R11: ffff8800ba6e7ad8 R12: ffff8800a13b78ff
[  222.309311] R13: ffff8800a13b7990 R14: 0000000000000001 R15: ffff8800a13b7808
[  222.309311] FS:  00007f3beec476f0(0000) GS:ffff880001e40000(0000) knlGS:0000000000000000
[  222.309311] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  222.309311] CR2: 000000000040e7f0 CR3: 00000000a12d5000 CR4: 00000000000006e0
[  222.309311] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  222.309311] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  222.309311] Process fio (pid: 4780, threadinfo ffff8800ba6e6000, task ffff8800b3d6bf00)
[  222.309311] Stack:
[  222.309311]  0000000000000001 ffff8800bab17a48 ffff8800bab17a48 ffff8800a13b7800
[  222.309311] <0> ffff8800ba6e7a68 ffffffff8121da35 ffff880000000001 00ff8800ba5c5698
[  222.309311] <0> ffff8800ba6e7a68 ffff8800a13b7800 0000000000000000 ffff8800bab17a48
[  222.309311] Call Trace:
[  222.309311]  [<ffffffff8121da35>] __cfq_slice_expired+0x2af/0x3ec
[  222.309311]  [<ffffffff8121fd7b>] cfq_dispatch_requests+0x2c8/0x8e8
[  222.309311]  [<ffffffff8120f1cd>] ? spin_unlock_irqrestore+0xe/0x10
[  222.309311]  [<ffffffff8120fb1a>] ? blk_insert_cloned_request+0x70/0x7b
[  222.309311]  [<ffffffff81210461>] blk_peek_request+0x191/0x1a7
[  222.309311]  [<ffffffffa0002799>] dm_request_fn+0x38/0x14c [dm_mod]
[  222.309311]  [<ffffffff810ae61f>] ? sync_page_killable+0x0/0x35
[  222.309311]  [<ffffffff81210fd4>] __generic_unplug_device+0x32/0x37
[  222.309311]  [<ffffffff81211274>] generic_unplug_device+0x2e/0x3c
[  222.309311]  [<ffffffffa00011a6>] dm_unplug_all+0x42/0x5b [dm_mod]
[  222.309311]  [<ffffffff8120ca37>] blk_unplug+0x29/0x2d
[  222.309311]  [<ffffffff8120ca4d>] blk_backing_dev_unplug+0x12/0x14
[  222.309311]  [<ffffffff81109a7a>] block_sync_page+0x35/0x39
[  222.309311]  [<ffffffff810ae616>] sync_page+0x41/0x4a
[  222.309311]  [<ffffffff810ae62d>] sync_page_killable+0xe/0x35
[  222.309311]  [<ffffffff8158aa59>] __wait_on_bit_lock+0x46/0x8f
[  222.309311]  [<ffffffff810ae4f5>] __lock_page_killable+0x66/0x6d
[  222.309311]  [<ffffffff81056f9c>] ? wake_bit_function+0x0/0x33
[  222.309311]  [<ffffffff810ae528>] lock_page_killable+0x2c/0x2e
[  222.309311]  [<ffffffff810afbc5>] generic_file_aio_read+0x361/0x4f0
[  222.309311]  [<ffffffff810ea044>] do_sync_read+0xcb/0x108
[  222.309311]  [<ffffffff811e42f7>] ? security_file_permission+0x16/0x18
[  222.309311]  [<ffffffff810ea6ab>] vfs_read+0xab/0x108
[  222.309311]  [<ffffffff810ea7c8>] sys_read+0x4a/0x6e
[  222.309311]  [<ffffffff81002b5b>] system_call_fastpath+0x16/0x1b
[  222.309311] Code: 58 01 00 00 00 48 89 c6 75 0a 48 83 bb 60 01 00 00 00 74 09 48 8d bb a0 00 00 00 eb 35 41 fe cc 74 0d f6 83 c0 01 00 00 04 74 04 <0f> 0b eb fe 48 89 75 e8 e8 be e0 de ff 66 83 8b c0 01 00 00 04
[  222.309311] RIP  [<ffffffff8121ad88>] blkiocg_set_start_empty_time+0x50/0x83
[  222.309311]  RSP <ffff8800ba6e79f8>
[  222.309311] ---[ end trace 32b4f71dffc15712 ]---

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c  |   15 +++++++++------
 block/blk-cgroup.h  |    5 ++---
 block/cfq-iosched.c |   33 ++++++++++++++++-----------------
 3 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 83930f6..af42efb 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -213,7 +213,7 @@ void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg)
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_avg_queue_size_stats);
 
-void blkiocg_set_start_empty_time(struct blkio_group *blkg, bool ignore)
+void blkiocg_set_start_empty_time(struct blkio_group *blkg)
 {
 	unsigned long flags;
 	struct blkio_group_stats *stats;
@@ -228,12 +228,15 @@ void blkiocg_set_start_empty_time(struct blkio_group *blkg, bool ignore)
 	}
 
 	/*
-	 * If ignore is set, we do not panic on the empty flag being set
-	 * already. This is to avoid cases where there are superfluous timeslice
-	 * complete events (for eg., forced_dispatch in CFQ) when no IOs are
-	 * served which could result in triggering the empty check incorrectly.
+	 * group is already marked empty. This can happen if cfqq got new
+	 * request in parent group and moved to this group while being added
+	 * to service tree. Just ignore the event and move on.
 	 */
-	BUG_ON(!ignore && blkio_blkg_empty(stats));
+	if(blkio_blkg_empty(stats)) {
+		spin_unlock_irqrestore(&blkg->stats_lock, flags);
+		return;
+	}
+
 	stats->start_empty_time = sched_clock();
 	blkio_mark_blkg_empty(stats);
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2c956a0..a491a6d 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -174,7 +174,7 @@ void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 				unsigned long dequeue);
 void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg);
 void blkiocg_update_idle_time_stats(struct blkio_group *blkg);
-void blkiocg_set_start_empty_time(struct blkio_group *blkg, bool ignore);
+void blkiocg_set_start_empty_time(struct blkio_group *blkg);
 
 #define BLKG_FLAG_FNS(name)						\
 static inline void blkio_mark_blkg_##name(				\
@@ -205,8 +205,7 @@ static inline void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 static inline void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
 {}
 static inline void blkiocg_update_idle_time_stats(struct blkio_group *blkg) {}
-static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg,
-						bool ignore) {}
+static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg) {}
 #endif
 
 #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d5927b5..002a5b6 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -888,7 +888,7 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 }
 
 static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
-				struct cfq_queue *cfqq, bool forced)
+				struct cfq_queue *cfqq)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 	unsigned int used_sl, charge_sl;
@@ -918,7 +918,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
 	blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
-	blkiocg_set_start_empty_time(&cfqg->blkg, forced);
+	blkiocg_set_start_empty_time(&cfqg->blkg);
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
@@ -1582,7 +1582,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
  */
 static void
 __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-		    bool timed_out, bool forced)
+		    bool timed_out)
 {
 	cfq_log_cfqq(cfqd, cfqq, "slice expired t=%d", timed_out);
 
@@ -1609,7 +1609,7 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
 	}
 
-	cfq_group_served(cfqd, cfqq->cfqg, cfqq, forced);
+	cfq_group_served(cfqd, cfqq->cfqg, cfqq);
 
 	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
 		cfq_del_cfqq_rr(cfqd, cfqq);
@@ -1628,13 +1628,12 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 }
 
-static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out,
-					bool forced)
+static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 
 	if (cfqq)
-		__cfq_slice_expired(cfqd, cfqq, timed_out, forced);
+		__cfq_slice_expired(cfqd, cfqq, timed_out);
 }
 
 /*
@@ -2202,7 +2201,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	}
 
 expire:
-	cfq_slice_expired(cfqd, 0, false);
+	cfq_slice_expired(cfqd, 0);
 new_queue:
 	/*
 	 * Current queue expired. Check if we have to switch to a new
@@ -2228,7 +2227,7 @@ static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 	BUG_ON(!list_empty(&cfqq->fifo));
 
 	/* By default cfqq is not expired if it is empty. Do it explicitly */
-	__cfq_slice_expired(cfqq->cfqd, cfqq, 0, true);
+	__cfq_slice_expired(cfqq->cfqd, cfqq, 0);
 	return dispatched;
 }
 
@@ -2242,7 +2241,7 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	int dispatched = 0;
 
 	/* Expire the timeslice of the current active queue first */
-	cfq_slice_expired(cfqd, 0, true);
+	cfq_slice_expired(cfqd, 0);
 	while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL) {
 		__cfq_set_active_queue(cfqd, cfqq);
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
@@ -2411,7 +2410,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 	    cfqq->slice_dispatch >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
 	    cfq_class_idle(cfqq))) {
 		cfqq->slice_end = jiffies + 1;
-		cfq_slice_expired(cfqd, 0, false);
+		cfq_slice_expired(cfqd, 0);
 	}
 
 	cfq_log_cfqq(cfqd, cfqq, "dispatched a request");
@@ -2442,7 +2441,7 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	orig_cfqg = cfqq->orig_cfqg;
 
 	if (unlikely(cfqd->active_queue == cfqq)) {
-		__cfq_slice_expired(cfqd, cfqq, 0, false);
+		__cfq_slice_expired(cfqd, cfqq, 0);
 		cfq_schedule_dispatch(cfqd);
 	}
 
@@ -2543,7 +2542,7 @@ static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	struct cfq_queue *__cfqq, *next;
 
 	if (unlikely(cfqq == cfqd->active_queue)) {
-		__cfq_slice_expired(cfqd, cfqq, 0, false);
+		__cfq_slice_expired(cfqd, cfqq, 0);
 		cfq_schedule_dispatch(cfqd);
 	}
 
@@ -3172,7 +3171,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	cfq_log_cfqq(cfqd, cfqq, "preempt");
-	cfq_slice_expired(cfqd, 1, false);
+	cfq_slice_expired(cfqd, 1);
 
 	/*
 	 * Put the new queue at the front of the of the current list,
@@ -3383,7 +3382,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		 * - when there is a close cooperator
 		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
-			cfq_slice_expired(cfqd, 1, false);
+			cfq_slice_expired(cfqd, 1);
 		else if (sync && cfqq_empty &&
 			 !cfq_close_cooperator(cfqd, cfqq)) {
 			cfqd->noidle_tree_requires_idle |= !rq_noidle(rq);
@@ -3648,7 +3647,7 @@ static void cfq_idle_slice_timer(unsigned long data)
 		cfq_clear_cfqq_deep(cfqq);
 	}
 expire:
-	cfq_slice_expired(cfqd, timed_out, false);
+	cfq_slice_expired(cfqd, timed_out);
 out_kick:
 	cfq_schedule_dispatch(cfqd);
 out_cont:
@@ -3691,7 +3690,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	spin_lock_irq(q->queue_lock);
 
 	if (cfqd->active_queue)
-		__cfq_slice_expired(cfqd, cfqd->active_queue, 0, false);
+		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
 
 	while (!list_empty(&cfqd->cic_list)) {
 		struct cfq_io_context *cic = list_entry(cfqd->cic_list.next,
-- 
1.6.2.5

