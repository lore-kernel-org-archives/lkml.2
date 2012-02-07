Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab2BGXC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 18:02:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46953 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab2BGXC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 18:02:27 -0500
Date: Tue, 7 Feb 2012 15:02:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH block/for-linus 2/2] block: don't call elevator callbacks
 for plug merges
Message-ID: <20120207230222.GL21292@google.com>
References: <20120207230153.GK21292@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207230153.GK21292@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plug merge calls two elevator callbacks outside queue lock -
elevator_allow_merge_fn() and elevator_bio_merged_fn().  Although
attempt_plug_merge() suggests that elevator is guaranteed to be there
through the existing request on the plug list, nothing prevents plug
merge from calling into dying or initializing elevator.

For regular merges, bypass ensures elvpriv count to reach zero, which
in turn prevents merges as all !ELVPRIV requests get REQ_SOFTBARRIER
from forced back insertion.  Plug merge doesn't check ELVPRIV, and, as
the requests haven't gone through elevator insertion yet, it doesn't
have SOFTBARRIER set allowing merges on a bypassed queue.

This, for example, leads to the following crash during elevator
switch.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
 IP: [<ffffffff813b34e9>] cfq_allow_merge+0x49/0xa0
 PGD 112cbc067 PUD 115d5c067 PMD 0
 Oops: 0000 [#1] PREEMPT SMP
 CPU 1
 Modules linked in: deadline_iosched

 Pid: 819, comm: dd Not tainted 3.3.0-rc2-work+ #76 Bochs Bochs
 RIP: 0010:[<ffffffff813b34e9>]  [<ffffffff813b34e9>] cfq_allow_merge+0x49/0xa0
 RSP: 0018:ffff8801143a38f8  EFLAGS: 00010297
 RAX: 0000000000000000 RBX: ffff88011817ce28 RCX: ffff880116eb6cc0
 RDX: 0000000000000000 RSI: ffff880118056e20 RDI: ffff8801199512f8
 RBP: ffff8801143a3908 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000000 R12: ffff880118195708
 R13: ffff880118052aa0 R14: ffff8801143a3d50 R15: ffff880118195708
 FS:  00007f19f82cb700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000008 CR3: 0000000112c6a000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process dd (pid: 819, threadinfo ffff8801143a2000, task ffff880116eb6cc0)
 Stack:
  ffff88011817ce28 ffff880118195708 ffff8801143a3928 ffffffff81391bba
  ffff88011817ce28 ffff880118195708 ffff8801143a3948 ffffffff81391bf1
  ffff88011817ce28 0000000000000000 ffff8801143a39a8 ffffffff81398e3e
 Call Trace:
  [<ffffffff81391bba>] elv_rq_merge_ok+0x4a/0x60
  [<ffffffff81391bf1>] elv_try_merge+0x21/0x40
  [<ffffffff81398e3e>] blk_queue_bio+0x8e/0x390
  [<ffffffff81396a5a>] generic_make_request+0xca/0x100
  [<ffffffff81396b04>] submit_bio+0x74/0x100
  [<ffffffff811d45c2>] __blockdev_direct_IO+0x1ce2/0x3450
  [<ffffffff811d0dc7>] blkdev_direct_IO+0x57/0x60
  [<ffffffff811460b5>] generic_file_aio_read+0x6d5/0x760
  [<ffffffff811986b2>] do_sync_read+0xe2/0x120
  [<ffffffff81199345>] vfs_read+0xc5/0x180
  [<ffffffff81199501>] sys_read+0x51/0x90
  [<ffffffff81aeac12>] system_call_fastpath+0x16/0x1b

There are multiple ways to fix this including making plug merge check
ELVPRIV; however,

* Calling into elevator outside queue lock is confusing and
  error-prone.

* Requests on plug list aren't known to the elevator.  They aren't on
  the elevator yet, so there's no elevator specific state to update.

* Given the nature of plug merges - collecting bio's for the same
  purpose from the same issuer - elevator specific restrictions aren't
  applicable.

So, simply don't call into elevator methods from plug merge by moving
elv_bio_merged() from bio_attempt_*_merge() to blk_queue_bio(), and
using blk_try_merge() in attempt_plug_merge().

This is based on Jens' patch to skip elevator_allow_merge_fn() from
plug merge.

Note that this makes per-cgroup merged stats skip plug merging.

Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <4F16F3CA.90904@kernel.dk>
Original-patch-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c         |   19 +++++++++----------
 block/cfq-iosched.c      |   15 ++++-----------
 include/linux/elevator.h |    6 ------
 3 files changed, 13 insertions(+), 27 deletions(-)

Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -1212,7 +1212,6 @@ static bool bio_attempt_back_merge(struc
 	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
 
 	drive_stat_acct(req, 0);
-	elv_bio_merged(q, req, bio);
 	return true;
 }
 
@@ -1243,7 +1242,6 @@ static bool bio_attempt_front_merge(stru
 	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
 
 	drive_stat_acct(req, 0);
-	elv_bio_merged(q, req, bio);
 	return true;
 }
 
@@ -1257,13 +1255,12 @@ static bool bio_attempt_front_merge(stru
  * on %current's plugged list.  Returns %true if merge was successful,
  * otherwise %false.
  *
- * This function is called without @q->queue_lock; however, elevator is
- * accessed iff there already are requests on the plugged list which in
- * turn guarantees validity of the elevator.
- *
- * Note that, on successful merge, elevator operation
- * elevator_bio_merged_fn() will be called without queue lock.  Elevator
- * must be ready for this.
+ * Plugging coalesces IOs from the same issuer for the same purpose without
+ * going through @q->queue_lock.  As such it's more of an issuing mechanism
+ * than scheduling, and the request, while may have elvpriv data, is not
+ * added on the elevator at this point.  In addition, we don't have
+ * reliable access to the elevator outside queue lock.  Only check basic
+ * merging parameters without querying the elevator.
  */
 static bool attempt_plug_merge(struct request_queue *q, struct bio *bio,
 			       unsigned int *request_count)
@@ -1282,7 +1279,7 @@ static bool attempt_plug_merge(struct re
 
 		(*request_count)++;
 
-		if (rq->q != q || !elv_rq_merge_ok(rq, bio))
+		if (rq->q != q || !blk_rq_merge_ok(rq, bio))
 			continue;
 
 		el_ret = blk_try_merge(rq, bio);
@@ -1347,12 +1344,14 @@ void blk_queue_bio(struct request_queue 
 	el_ret = elv_merge(q, &req, bio);
 	if (el_ret == ELEVATOR_BACK_MERGE) {
 		if (bio_attempt_back_merge(q, req, bio)) {
+			elv_bio_merged(q, req, bio);
 			if (!attempt_back_merge(q, req))
 				elv_merged_request(q, req, el_ret);
 			goto out_unlock;
 		}
 	} else if (el_ret == ELEVATOR_FRONT_MERGE) {
 		if (bio_attempt_front_merge(q, req, bio)) {
+			elv_bio_merged(q, req, bio);
 			if (!attempt_front_merge(q, req))
 				elv_merged_request(q, req, el_ret);
 			goto out_unlock;
Index: work/include/linux/elevator.h
===================================================================
--- work.orig/include/linux/elevator.h
+++ work/include/linux/elevator.h
@@ -42,12 +42,6 @@ struct elevator_ops
 	elevator_merged_fn *elevator_merged_fn;
 	elevator_merge_req_fn *elevator_merge_req_fn;
 	elevator_allow_merge_fn *elevator_allow_merge_fn;
-
-	/*
-	 * Used for both plugged list and elevator merging and in the
-	 * former case called without queue_lock.  Read comment on top of
-	 * attempt_plug_merge() for details.
-	 */
 	elevator_bio_merged_fn *elevator_bio_merged_fn;
 
 	elevator_dispatch_fn *elevator_dispatch_fn;
Index: work/block/cfq-iosched.c
===================================================================
--- work.orig/block/cfq-iosched.c
+++ work/block/cfq-iosched.c
@@ -1699,18 +1699,11 @@ static int cfq_allow_merge(struct reques
 
 	/*
 	 * Lookup the cfqq that this bio will be queued with and allow
-	 * merge only if rq is queued there.  This function can be called
-	 * from plug merge without queue_lock.  In such cases, ioc of @rq
-	 * and %current are guaranteed to be equal.  Avoid lookup which
-	 * requires queue_lock by using @rq's cic.
+	 * merge only if rq is queued there.
 	 */
-	if (current->io_context == RQ_CIC(rq)->icq.ioc) {
-		cic = RQ_CIC(rq);
-	} else {
-		cic = cfq_cic_lookup(cfqd, current->io_context);
-		if (!cic)
-			return false;
-	}
+	cic = cfq_cic_lookup(cfqd, current->io_context);
+	if (!cic)
+		return false;
 
 	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
 	return cfqq == RQ_CFQQ(rq);
