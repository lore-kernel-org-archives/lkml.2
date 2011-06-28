Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab1F1LVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 07:21:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47280 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab1F1LTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:19:21 -0400
Date: Tue, 28 Jun 2011 14:18:53 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cfq: Suspicious rcu_dereference_check() usage at
 __cfq_exit_single_io_context()
Message-ID: <20110628111853.GA3189@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect __cfq_exit_single_io_context() call with rcu_read_lock(), since it 
modifies RCU pointer ioc->ioc_data.

[ 1349.369446] rcu_scheduler_active = 1, debug_locks = 0
[ 1349.369451] 3 locks held by scsi_scan_4/5203:
[ 1349.369454]  #0:  (&shost->scan_mutex){+.+.+.}, at: [<ffffffff81392768>] scsi_scan_host_selected+0xba/0x18c
[ 1349.369473]  #1:  (&eq->sysfs_lock){+.+...}, at: [<ffffffff8121f3cb>] elevator_exit+0x18/0x49
[ 1349.369489]  #2:  (&(&q->__queue_lock)->rlock){-.-...}, at: [<ffffffff812354b1>] cfq_exit_queue+0x42/0x171
[ 1349.369503] 
[ 1349.369504] stack backtrace:
[ 1349.369510] Pid: 5203, comm: scsi_scan_4 Not tainted 3.0.0-rc5-dbg-00479-gbe4a634 #629
[ 1349.369515] Call Trace:
[ 1349.369526]  [<ffffffff8106e5a6>] lockdep_rcu_dereference+0xa7/0xaf
[ 1349.369534]  [<ffffffff812353b6>] __cfq_exit_single_io_context+0x85/0xe1
[ 1349.369541]  [<ffffffff812354d5>] cfq_exit_queue+0x66/0x171
[ 1349.369548]  [<ffffffff8121f3df>] elevator_exit+0x2c/0x49
[ 1349.369556]  [<ffffffff81223a34>] blk_cleanup_queue+0x4a/0x63
[ 1349.369563]  [<ffffffff81390614>] scsi_free_queue+0x9/0xb
[ 1349.369571]  [<ffffffff81393d39>] __scsi_remove_device+0xa7/0xb4
[ 1349.369577]  [<ffffffff81391ca2>] scsi_probe_and_add_lun+0xa78/0xab5
[ 1349.369586]  [<ffffffff813923fc>] __scsi_scan_target+0x5d3/0x625
[ 1349.369594]  [<ffffffff8138470f>] ? __pm_runtime_resume+0x2f/0x59
[ 1349.369603]  [<ffffffff81071d17>] ? mark_held_locks+0x4b/0x6d
[ 1349.369613]  [<ffffffff8147ce16>] ? _raw_spin_unlock_irqrestore+0x42/0x74
[ 1349.369622]  [<ffffffff81033899>] ? get_parent_ip+0xf/0x40
[ 1349.369630]  [<ffffffff8147ff09>] ? sub_preempt_count+0x8f/0xa3
[ 1349.369637]  [<ffffffff813924a0>] scsi_scan_channel.part.8+0x52/0x6d
[ 1349.369645]  [<ffffffff813927b2>] scsi_scan_host_selected+0x104/0x18c
[ 1349.369652]  [<ffffffff813928aa>] ? do_scsi_scan_host+0x70/0x70
[ 1349.369658]  [<ffffffff813928a5>] do_scsi_scan_host+0x6b/0x70
[ 1349.369665]  [<ffffffff813928c7>] do_scan_async+0x1d/0x15d
[ 1349.369671]  [<ffffffff813928aa>] ? do_scsi_scan_host+0x70/0x70
[ 1349.369680]  [<ffffffff8105cdfa>] kthread+0x9a/0xa2
[ 1349.369689]  [<ffffffff81483ee4>] kernel_thread_helper+0x4/0x10
[ 1349.369696]  [<ffffffff8102d70f>] ? finish_task_switch+0x76/0xf0
[ 1349.369703]  [<ffffffff8147d318>] ? retint_restore_args+0x13/0x13
[ 1349.369710]  [<ffffffff8105cd60>] ? __init_kthread_worker+0x53/0x53
[ 1349.369717]  [<ffffffff81483ee0>] ? gs_change+0x13/0x13


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 block/cfq-iosched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f379943..04561ee 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3897,6 +3897,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	if (cfqd->active_queue)
 		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
 
+	rcu_read_lock();
 	while (!list_empty(&cfqd->cic_list)) {
 		struct cfq_io_context *cic = list_entry(cfqd->cic_list.next,
 							struct cfq_io_context,
@@ -3904,6 +3905,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 
 		__cfq_exit_single_io_context(cfqd, cic);
 	}
+	rcu_read_unlock();
 
 	cfq_put_async_queues(cfqd);
 	cfq_release_cfq_groups(cfqd);

