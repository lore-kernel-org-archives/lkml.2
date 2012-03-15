Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031765Ab2COQfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:35:52 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44717 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031620Ab2COQfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:35:50 -0400
Date: Thu, 15 Mar 2012 09:35:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH block/for-3.4/core] cfq: fix cfqg ref handling when
 BLK_CGROUP && !CFQ_GROUP_IOSCHED
Message-ID: <20120315163546.GA32137@google.com>
References: <20120315094945.GA3205@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315094945.GA3205@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When BLK_CGROUP is enabled but CFQ_GROUP_IOSCHED is, cfq ends up
calling blkg_get/put() on dummy cfqg leading to the following crash.

  BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
  IP: [<ffffffff813d44d8>] cfq_init_queue+0x258/0x430
  PGD 0
  Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
  CPU 0
  Modules linked in:

  Pid: 1, comm: swapper/0 Not tainted 3.3.0-rc6-work+ #125 Bochs Bochs
  RIP: 0010:[<ffffffff813d44d8>]  [<ffffffff813d44d8>] cfq_init_queue+0x258/0x430
  RSP: 0018:ffff88001f9dfd80  EFLAGS: 00010046
  RAX: ffff88001aefbbf0 RBX: ffff88001aeedbf0 RCX: 0000000000000100
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff820ffd40
  RBP: ffff88001f9dfdd0 R08: 0000000000000000 R09: 0000000000000001
  R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
  R13: 0000000000000009 R14: ffff88001aefbc30 R15: 0000000000000003
  FS:  0000000000000000(0000) GS:ffff88001fc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 00000000000000b0 CR3: 000000000206f000 CR4: 00000000000006f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Process swapper/0 (pid: 1, threadinfo ffff88001f9de000, task ffff88001f9dc040)
  Stack:
   ffff88001aeedbf0 ffff88001aefbdb0 ffff88001aef1548 ffff88001aefbbf0
   ffff88001f9dfdd0 ffff88001aef1548 ffffffff820d6320 ffffffff8165ce30
   ffffffff82c555e0 ffff88001aeebbf0 ffff88001f9dfe00 ffffffff813b0507
  Call Trace:
   [<ffffffff813b0507>] elevator_init+0xd7/0x140
   [<ffffffff813b83d5>] blk_init_allocated_queue+0x125/0x150
   [<ffffffff813b94d3>] blk_init_queue_node+0x43/0x80
   [<ffffffff813b9523>] blk_init_queue+0x13/0x20
   [<ffffffff821aec00>] floppy_init+0x82/0xec7
   [<ffffffff810001d2>] do_one_initcall+0x42/0x170
   [<ffffffff821835fc>] kernel_init+0xcb/0x14f
   [<ffffffff81b40b24>] kernel_thread_helper+0x4/0x10
  Code: 00 e8 1d 9e 76 00 48 8b 43 48 48 85 c0 48 89 83 28 03 00 00 74 07 4c 8b a0 10 ff ff ff 8b 15 b0 2e d0 00 85 d2 0f 85 49 01 00 00 <41> 8b 84 24 b0 00 00 00 85 c0 0f 8e 8c 01 00 00 83 e8 01 85 c0
  RIP  [<ffffffff813d44d8>] cfq_init_queue+0x258/0x430

Because cfq's blkcg support has a on/off switch, CFQ_GROUP_IOSCHED,
separate from BLK_CGROUP, blkg access through cfqg needs to be
conditioned on it.

* Make blkg_to_cfqg() and cfqg_to_blkg() conditioned on
  CFQ_GROUP_IOSCHED.  If disabled, they always return %NULL.

* Introduce cfqg_get() and cfqg_put() conditioned on
  CFQ_GROUP_IOSCHED.  If disabled, they are noops.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Yeap, forgot to test that config combination.  Fengguang, can you
please test this patch?  Jens, once Fengguang confirms the fix, can
you please apply this on top of for-3.4/core along with the pending
stats updates?

Thanks.

 block/cfq-iosched.c |   52 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 17 deletions(-)

Index: work/block/cfq-iosched.c
===================================================================
--- work.orig/block/cfq-iosched.c
+++ work/block/cfq-iosched.c
@@ -302,16 +302,6 @@ struct cfq_data {
 	unsigned long last_delayed_sync;
 };
 
-static inline struct cfq_group *blkg_to_cfqg(struct blkio_group *blkg)
-{
-	return blkg_to_pdata(blkg, &blkio_policy_cfq);
-}
-
-static inline struct blkio_group *cfqg_to_blkg(struct cfq_group *cfqg)
-{
-	return pdata_to_blkg(cfqg, &blkio_policy_cfq);
-}
-
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
@@ -373,6 +363,26 @@ CFQ_CFQQ_FNS(wait_busy);
 #undef CFQ_CFQQ_FNS
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
+static inline struct cfq_group *blkg_to_cfqg(struct blkio_group *blkg)
+{
+	return blkg_to_pdata(blkg, &blkio_policy_cfq);
+}
+
+static inline struct blkio_group *cfqg_to_blkg(struct cfq_group *cfqg)
+{
+	return pdata_to_blkg(cfqg, &blkio_policy_cfq);
+}
+
+static inline void cfqg_get(struct cfq_group *cfqg)
+{
+	return blkg_get(cfqg_to_blkg(cfqg));
+}
+
+static inline void cfqg_put(struct cfq_group *cfqg)
+{
+	return blkg_put(cfqg_to_blkg(cfqg));
+}
+
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq%d%c %s " fmt, (cfqq)->pid, \
 			cfq_cfqq_sync((cfqq)) ? 'S' : 'A', \
@@ -382,11 +392,19 @@ CFQ_CFQQ_FNS(wait_busy);
 	blk_add_trace_msg((cfqd)->queue, "%s " fmt,			\
 			blkg_path(cfqg_to_blkg((cfqg))), ##args)	\
 
-#else
+#else	/* CONFIG_CFQ_GROUP_IOSCHED */
+
+static inline struct cfq_group *blkg_to_cfqg(struct blkio_group *blkg) { return NULL; }
+static inline struct blkio_group *cfqg_to_blkg(struct cfq_group *cfqg) { return NULL; }
+static inline void cfqg_get(struct cfq_group *cfqg) { }
+static inline void cfqg_put(struct cfq_group *cfqg) { }
+
 #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq%d " fmt, (cfqq)->pid, ##args)
 #define cfq_log_cfqg(cfqd, cfqg, fmt, args...)		do {} while (0)
-#endif
+
+#endif	/* CONFIG_CFQ_GROUP_IOSCHED */
+
 #define cfq_log(cfqd, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq " fmt, ##args)
 
@@ -1086,7 +1104,7 @@ static void cfq_link_cfqq_cfqg(struct cf
 
 	cfqq->cfqg = cfqg;
 	/* cfqq reference on cfqg */
-	blkg_get(cfqg_to_blkg(cfqg));
+	cfqg_get(cfqg);
 }
 
 #else /* GROUP_IOSCHED */
@@ -2501,7 +2519,7 @@ static void cfq_put_queue(struct cfq_que
 
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	kmem_cache_free(cfq_pool, cfqq);
-	blkg_put(cfqg_to_blkg(cfqg));
+	cfqg_put(cfqg);
 }
 
 static void cfq_put_cooperator(struct cfq_queue *cfqq)
@@ -3256,7 +3274,7 @@ static void cfq_put_request(struct reque
 		cfqq->allocated[rw]--;
 
 		/* Put down rq reference on cfqg */
-		blkg_put(cfqg_to_blkg(RQ_CFQG(rq)));
+		cfqg_put(RQ_CFQG(rq));
 		rq->elv.priv[0] = NULL;
 		rq->elv.priv[1] = NULL;
 
@@ -3352,7 +3370,7 @@ new_queue:
 	cfqq->allocated[rw]++;
 
 	cfqq->ref++;
-	blkg_get(cfqg_to_blkg(cfqq->cfqg));
+	cfqg_get(cfqq->cfqg);
 	rq->elv.priv[0] = cfqq;
 	rq->elv.priv[1] = cfqq->cfqg;
 	spin_unlock_irq(q->queue_lock);
@@ -3533,7 +3551,7 @@ static int cfq_init_queue(struct request
 
 	spin_lock_irq(q->queue_lock);
 	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, cfqd->root_group);
-	blkg_put(cfqg_to_blkg(cfqd->root_group));
+	cfqg_put(cfqd->root_group);
 	spin_unlock_irq(q->queue_lock);
 
 	init_timer(&cfqd->idle_slice_timer);
