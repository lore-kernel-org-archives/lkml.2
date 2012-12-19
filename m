Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab2LST1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 14:27:49 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64083 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab2LST1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 14:27:46 -0500
Date: Wed, 19 Dec 2012 11:27:40 -0800
From: Tejun Heo <tj@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] workqueue: fix find_worker_executing_work() brekage from
 hashtable conversion
Message-ID: <20121219192740.GT1844@htj.dyndns.org>
References: <20121219095241.GA27310@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219095241.GA27310@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 023f27d3d6fcc9048754d879fe5e7d63402a5b16 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 19 Dec 2012 11:24:06 -0800

42f8570f43 ("workqueue: use new hashtable implementation") incorrectly
made busy workers hashed by the pointer value of worker instead of
work.  This broke find_worker_executing_work() which in turn broke a
lot of fundamental operations of workqueue - non-reentrancy and
flushing among others.  The flush malfunction triggered warning in
disk event code in Fengguang's automated test.

 write_dev_root_ (3265) used greatest stack depth: 2704 bytes left
 ------------[ cut here ]------------
 WARNING: at /c/kernel-tests/src/stable/block/genhd.c:1574 disk_clear_events+0x\
cf/0x108()
 Hardware name: Bochs
 Modules linked in:
 Pid: 3328, comm: ata_id Not tainted 3.7.0-01930-gbff6343 #1167
 Call Trace:
  [<ffffffff810997c4>] warn_slowpath_common+0x83/0x9c
  [<ffffffff810997f7>] warn_slowpath_null+0x1a/0x1c
  [<ffffffff816aea77>] disk_clear_events+0xcf/0x108
  [<ffffffff811bd8be>] check_disk_change+0x27/0x59
  [<ffffffff822e48e2>] cdrom_open+0x49/0x68b
  [<ffffffff81ab0291>] idecd_open+0x88/0xb7
  [<ffffffff811be58f>] __blkdev_get+0x102/0x3ec
  [<ffffffff811bea08>] blkdev_get+0x18f/0x30f
  [<ffffffff811bebfd>] blkdev_open+0x75/0x80
  [<ffffffff8118f510>] do_dentry_open+0x1ea/0x295
  [<ffffffff8118f5f0>] finish_open+0x35/0x41
  [<ffffffff8119c720>] do_last+0x878/0xa25
  [<ffffffff8119c993>] path_openat+0xc6/0x333
  [<ffffffff8119cf37>] do_filp_open+0x38/0x86
  [<ffffffff81190170>] do_sys_open+0x6c/0xf9
  [<ffffffff8119021e>] sys_open+0x21/0x23
  [<ffffffff82c1c3d9>] system_call_fastpath+0x16/0x1b

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
---
Sorry that I didn't spot this earlier.  Fix applied to wq/for-3.9.

Thanks a lot Fengguang.  You're awesome!

 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d24a411..7967f34 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2172,7 +2172,7 @@ __acquires(&gcwq->lock)
 
 	/* claim and dequeue */
 	debug_work_deactivate(work);
-	hash_add(gcwq->busy_hash, &worker->hentry, (unsigned long)worker);
+	hash_add(gcwq->busy_hash, &worker->hentry, (unsigned long)work);
 	worker->current_work = work;
 	worker->current_func = work->func;
 	worker->current_cwq = cwq;
-- 
1.8.0.2

