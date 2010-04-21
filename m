Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0DUPgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:36:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679Ab0DUPge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:36:34 -0400
Date: Wed, 21 Apr 2010 11:36:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Divyesh Shah <dpshah@google.com>, Nauman Rafique <nauman@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH V2] blkio: Fix blkio crash during rq stat update
Message-ID: <20100421153623.GD3275@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


blkio + cfq was crashing even when two sequential readers were put in two
separate cgroups (group_isolation=0).

The reason being that cfqq can migrate across groups based on its being
sync-noidle or not, it can happen that at request insertion time, cfqq
belonged to one cfqg and at request dispatch time, it belonged to root
group. In this case request stats per cgroup can go wrong and it also runs
into BUG_ON().

This patch implements rq stashing away a cfq group pointer and not relying
on cfqq->cfqg pointer alone for rq stat accounting.

[   65.163523] ------------[ cut here ]------------
[   65.164301] kernel BUG at block/blk-cgroup.c:117!
[   65.164301] invalid opcode: 0000 [#1] SMP
[   65.164301] last sysfs file: /sys/devices/pci0000:00/0000:00:05.0/0000:60:00.1/host9/rport-9:0-0/target9:0:0/9:0:0:2/block/sde/stat
[   65.164301] CPU 1
[   65.164301] Modules linked in: dm_round_robin dm_multipath qla2xxx scsi_transport_fc dm_zero dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_wait_scan]
[   65.164301]
[   65.164301] Pid: 4505, comm: fio Not tainted 2.6.34-rc4-blk-for-35 #34 0A98h/HP xw8600 Workstation
[   65.164301] RIP: 0010:[<ffffffff8121924f>]  [<ffffffff8121924f>] blkiocg_update_io_remove_stats+0x5b/0xaf
[   65.164301] RSP: 0018:ffff8800ba5a79e8  EFLAGS: 00010046
[   65.164301] RAX: 0000000000000096 RBX: ffff8800bb268d60 RCX: 0000000000000000
[   65.164301] RDX: ffff8800bb268eb8 RSI: 0000000000000000 RDI: ffff8800bb268e00
[   65.164301] RBP: ffff8800ba5a7a08 R08: 0000000000000064 R09: 0000000000000001
[   65.164301] R10: 0000000000079640 R11: ffff8800a0bd5bf0 R12: ffff8800bab4af01
[   65.164301] R13: ffff8800bab4af00 R14: ffff8800bb1d8928 R15: 0000000000000000
[   65.164301] FS:  00007f18f75056f0(0000) GS:ffff880001e40000(0000) knlGS:0000000000000000
[   65.164301] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   65.164301] CR2: 000000000040e7f0 CR3: 00000000ba52b000 CR4: 00000000000006e0
[   65.164301] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   65.164301] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   65.164301] Process fio (pid: 4505, threadinfo ffff8800ba5a6000, task ffff8800ba45ae80)
[   65.164301] Stack:
[   65.164301]  ffff8800ba5a7a08 ffff8800ba722540 ffff8800bab4af68 ffff8800bab4af68
[   65.164301] <0> ffff8800ba5a7a38 ffffffff8121d814 ffff8800ba722540 ffff8800bab4af68
[   65.164301] <0> ffff8800ba722540 ffff8800a08f6800 ffff8800ba5a7a68 ffffffff8121d8ca
[   65.164301] Call Trace:
[   65.164301]  [<ffffffff8121d814>] cfq_remove_request+0xe4/0x116
[   65.164301]  [<ffffffff8121d8ca>] cfq_dispatch_insert+0x84/0xe1
[   65.164301]  [<ffffffff8121e833>] cfq_dispatch_requests+0x767/0x8e8
[   65.164301]  [<ffffffff8120e524>] ? submit_bio+0xc3/0xcc
[   65.164301]  [<ffffffff810ad657>] ? sync_page_killable+0x0/0x35
[   65.164301]  [<ffffffff8120ea8d>] blk_peek_request+0x191/0x1a7
[   65.164301]  [<ffffffffa000109c>] ? dm_get_live_table+0x44/0x4f [dm_mod]
[   65.164301]  [<ffffffffa0002799>] dm_request_fn+0x38/0x14c [dm_mod]
[   65.164301]  [<ffffffff810ad657>] ? sync_page_killable+0x0/0x35
[   65.164301]  [<ffffffff8120f600>] __generic_unplug_device+0x32/0x37
[   65.164301]  [<ffffffff8120f8a0>] generic_unplug_device+0x2e/0x3c
[   65.164301]  [<ffffffffa00011a6>] dm_unplug_all+0x42/0x5b [dm_mod]
[   65.164301]  [<ffffffff8120b063>] blk_unplug+0x29/0x2d
[   65.164301]  [<ffffffff8120b079>] blk_backing_dev_unplug+0x12/0x14
[   65.164301]  [<ffffffff81108a82>] block_sync_page+0x35/0x39
[   65.164301]  [<ffffffff810ad64e>] sync_page+0x41/0x4a
[   65.164301]  [<ffffffff810ad665>] sync_page_killable+0xe/0x35
[   65.164301]  [<ffffffff81589027>] __wait_on_bit_lock+0x46/0x8f
[   65.164301]  [<ffffffff810ad52d>] __lock_page_killable+0x66/0x6d
[   65.164301]  [<ffffffff81055fd4>] ? wake_bit_function+0x0/0x33
[   65.164301]  [<ffffffff810ad560>] lock_page_killable+0x2c/0x2e
[   65.164301]  [<ffffffff810aebfd>] generic_file_aio_read+0x361/0x4f0
[   65.164301]  [<ffffffff810e906c>] do_sync_read+0xcb/0x108
[   65.164301]  [<ffffffff811e32a3>] ? security_file_permission+0x16/0x18
[   65.164301]  [<ffffffff810e96d3>] vfs_read+0xab/0x108
[   65.164301]  [<ffffffff810e97f0>] sys_read+0x4a/0x6e
[   65.164301]  [<ffffffff81002b5b>] system_call_fastpath+0x16/0x1b
[   65.164301] Code: 00 74 1c 48 8b 8b 60 01 00 00 48 85 c9 75 04 0f 0b eb fe 48 ff c9 48 89 8b 60 01 00 00 eb 1a 48 8b 8b 58 01 00 00 48 85 c9 75 04 <0f> 0b eb fe 48 ff c9 48 89 8b 58 01 00 00 45 84 e4 74 16 48 8b
[   65.164301] RIP  [<ffffffff8121924f>] blkiocg_update_io_remove_stats+0x5b/0xaf
[   65.164301]  RSP <ffff8800ba5a79e8>
[   65.164301] ---[ end trace 1b2b828753032e68 ]---

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c    |   37 +++++++++++++++++++++++++++----------
 include/linux/blkdev.h |    3 ++-
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 62defd0..bb8fc07 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -55,6 +55,7 @@ static const int cfq_hist_divisor = 4;
 #define RQ_CIC(rq)		\
 	((struct cfq_io_context *) (rq)->elevator_private)
 #define RQ_CFQQ(rq)		(struct cfq_queue *) ((rq)->elevator_private2)
+#define RQ_CFQG(rq)		(struct cfq_group *) ((rq)->elevator_private3)
 
 static struct kmem_cache *cfq_pool;
 static struct kmem_cache *cfq_ioc_pool;
@@ -1001,6 +1002,11 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 	return cfqg;
 }
 
+static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg) {
+	atomic_inc(&cfqg->ref);
+	return cfqg;
+}
+
 static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 {
 	/* Currently, all async queues are mapped to root group */
@@ -1084,6 +1090,12 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 {
 	return &cfqd->root_group;
 }
+
+static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
+{
+	return NULL;
+}
+
 static inline void
 cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
 	cfqq->cfqg = cfqg;
@@ -1386,12 +1398,12 @@ static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
 {
 	elv_rb_del(&cfqq->sort_list, rq);
 	cfqq->queued[rq_is_sync(rq)]--;
-	blkiocg_update_io_remove_stats(&cfqq->cfqg->blkg, rq_data_dir(rq),
+	blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg, rq_data_dir(rq),
 						rq_is_sync(rq));
 	cfq_add_rq_rb(rq);
-	blkiocg_update_io_add_stats(
-			&cfqq->cfqg->blkg, &cfqq->cfqd->serving_group->blkg,
-			rq_data_dir(rq), rq_is_sync(rq));
+	blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
+			&cfqq->cfqd->serving_group->blkg, rq_data_dir(rq),
+			rq_is_sync(rq));
 }
 
 static struct request *
@@ -1447,7 +1459,7 @@ static void cfq_remove_request(struct request *rq)
 	cfq_del_rq_rb(rq);
 
 	cfqq->cfqd->rq_queued--;
-	blkiocg_update_io_remove_stats(&cfqq->cfqg->blkg, rq_data_dir(rq),
+	blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg, rq_data_dir(rq),
 						rq_is_sync(rq));
 	if (rq_is_meta(rq)) {
 		WARN_ON(!cfqq->meta_pending);
@@ -1483,8 +1495,7 @@ static void cfq_merged_request(struct request_queue *q, struct request *req,
 static void cfq_bio_merged(struct request_queue *q, struct request *req,
 				struct bio *bio)
 {
-	struct cfq_queue *cfqq = RQ_CFQQ(req);
-	blkiocg_update_io_merged_stats(&cfqq->cfqg->blkg, bio_data_dir(bio),
+	blkiocg_update_io_merged_stats(&(RQ_CFQG(req))->blkg, bio_data_dir(bio),
 					cfq_bio_sync(bio));
 }
 
@@ -1505,7 +1516,7 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 	if (cfqq->next_rq == next)
 		cfqq->next_rq = rq;
 	cfq_remove_request(next);
-	blkiocg_update_io_merged_stats(&cfqq->cfqg->blkg, rq_data_dir(next),
+	blkiocg_update_io_merged_stats(&(RQ_CFQG(rq))->blkg, rq_data_dir(next),
 					rq_is_sync(next));
 }
 
@@ -3240,8 +3251,7 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
 	cfq_add_rq_rb(rq);
-
-	blkiocg_update_io_add_stats(&cfqq->cfqg->blkg,
+	blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,
 			&cfqd->serving_group->blkg, rq_data_dir(rq),
 			rq_is_sync(rq));
 	cfq_rq_enqueued(cfqd, cfqq, rq);
@@ -3472,6 +3482,10 @@ static void cfq_put_request(struct request *rq)
 		rq->elevator_private = NULL;
 		rq->elevator_private2 = NULL;
 
+		/* Put down rq reference on cfqg */
+		cfq_put_cfqg(RQ_CFQG(rq));
+		rq->elevator_private3 = NULL;
+
 		cfq_put_queue(cfqq);
 	}
 }
@@ -3560,6 +3574,9 @@ new_queue:
 
 	rq->elevator_private = cic;
 	rq->elevator_private2 = cfqq;
+	rq->elevator_private3 = cfqq->cfqg;
+	/* rq reference on cfqg */
+	cfq_ref_get_cfqg(RQ_CFQG(rq));
 	return 0;
 
 queue_fail:
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d483c49..5cf17a4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -186,11 +186,12 @@ struct request {
 	};
 
 	/*
-	 * two pointers are available for the IO schedulers, if they need
+	 * Three pointers are available for the IO schedulers, if they need
 	 * more they have to dynamically allocate it.
 	 */
 	void *elevator_private;
 	void *elevator_private2;
+	void *elevator_private3;
 
 	struct gendisk *rq_disk;
 	unsigned long start_time;
-- 
1.6.2.5

