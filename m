Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1L0RgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 12:36:07 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:63549 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612Ab1L0RgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 12:36:05 -0500
Date: Tue, 27 Dec 2011 09:35:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH block/for-3.3/core] block: remove WARN_ON_ONCE() in
 exit_io_context()
Message-ID: <20111227173559.GD17712@google.com>
References: <1324892810.31721.0.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324892810.31721.0.camel@lappy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

6e736be7 "block: make ioc get/put interface more conventional and fix
race on alloction" added WARN_ON_ONCE() in exit_io_context() which
triggers if !PF_EXITING.  All tasks hitting exit_io_context() from
task exit should have PF_EXITING set but task struct tearing down
after fork failure calls into the function without PF_EXITING,
triggering the condition.

  WARNING: at block/blk-ioc.c:234 exit_io_context+0x40/0x92()
  Pid: 17090, comm: trinity Not tainted 3.2.0-rc6-next-20111222-sasha-dirty #77
  Call Trace:
   [<ffffffff810b69a3>] warn_slowpath_common+0x8f/0xb2
   [<ffffffff810b6a77>] warn_slowpath_null+0x18/0x1a
   [<ffffffff8181a7a2>] exit_io_context+0x40/0x92
   [<ffffffff810b58c9>] copy_process+0x126f/0x1453
   [<ffffffff810b5c1b>] do_fork+0x120/0x3e9
   [<ffffffff8106242f>] sys_clone+0x26/0x28
   [<ffffffff82425803>] stub_clone+0x13/0x20
  ---[ end trace a2e4eb670b375238 ]---

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Heh, sorry about that.  Forgot about fork failure path.  Just removing
the WARN_ON_ONCE() should be enough.  Thanks for reporting the problem.

 block/blk-ioc.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 33fae7d..27a06e0 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -230,9 +230,6 @@ void exit_io_context(struct task_struct *task)
 {
 	struct io_context *ioc;
 
-	/* PF_EXITING prevents new io_context from being attached to @task */
-	WARN_ON_ONCE(!(current->flags & PF_EXITING));
-
 	task_lock(task);
 	ioc = task->io_context;
 	task->io_context = NULL;
