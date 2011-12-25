Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab1LYBCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 20:02:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38526 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1LYBCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 20:02:44 -0500
Date: Sat, 24 Dec 2011 17:02:38 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        x86@kernel.org
Subject: [PATCH block/for-3.3/core] block: an exiting task should be allowed
 to create io_context
Message-ID: <20111225010238.GA6013@htj.dyndns.org>
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
 <20111221151503.4d78f94f.akpm@linux-foundation.org>
 <20111222150836.af172886.akpm@linux-foundation.org>
 <20111222232036.GP17084@google.com>
 <20111222152427.c944c747.akpm@linux-foundation.org>
 <20111222233843.GR17084@google.com>
 <20111222154427.89b245c7.akpm@linux-foundation.org>
 <20111222234639.GS17084@google.com>
 <20111223004244.GU17084@google.com>
 <alpine.LSU.2.00.1112232058550.3225@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1112232058550.3225@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While fixing io_context creation / task exit race condition,
6e736be7f2 "block: make ioc get/put interface more conventional and
fix race on alloction" also prevented an exiting (%PF_EXITING) task
from creating its own io_context.  This is incorrect as exit path may
issue IOs, e.g. from exit_files(), and if those IOs are the first ones
issued by the task, io_context needs to be created to process the IOs.

Combined with the existing problem of io_context / io_cq creation
failure having the possibility of stalling IO, this problem results in
deterministic full IO lockup with certain workloads.

Fix it by allowing io_context creation regardless of %PF_EXITING for
%current.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Hugh Dickins <hughd@google.com>
---
Thanks a lot for the hint, Hugh.  My testing stuff (fio, dd and some
adhoc rawio testing programs) was issuing IOs before exiting, so I
didn't hit the problem and I suspect the reason why I didn't see the
boot failure Andrew was seeing was because of systemd - boot process
used to be dominated by lots of short-lived programs, many of which
touching/modifying files, and thus it triggered the first IO on exit
paths with Andrew's old userland.  With systemd, most of those are
gone, so...

Thanks.

 block/blk-ioc.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index ce9b35a..33fae7d 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -281,9 +281,16 @@ void create_io_context_slowpath(struct task_struct *task, gfp_t gfp_flags,
 	INIT_HLIST_HEAD(&ioc->icq_list);
 	INIT_WORK(&ioc->release_work, ioc_release_fn);
 
-	/* try to install, somebody might already have beaten us to it */
+	/*
+	 * Try to install.  ioc shouldn't be installed if someone else
+	 * already did or @task, which isn't %current, is exiting.  Note
+	 * that we need to allow ioc creation on exiting %current as exit
+	 * path may issue IOs from e.g. exit_files().  The exit path is
+	 * responsible for not issuing IO after exit_io_context().
+	 */
 	task_lock(task);
-	if (!task->io_context && !(task->flags & PF_EXITING))
+	if (!task->io_context &&
+	    (task == current || !(task->flags & PF_EXITING)))
 		task->io_context = ioc;
 	else
 		kmem_cache_free(iocontext_cachep, ioc);
