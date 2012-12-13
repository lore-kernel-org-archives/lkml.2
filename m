Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab2LMOKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:10:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44743 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825Ab2LMOK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:10:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Galbraith <mgalbraith@suse.de>, Tejun Heo <tj@kernel.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 155/241] workqueue: exit rescuer_thread() as TASK_RUNNING
Date: Thu, 13 Dec 2012 11:58:40 -0200
Message-Id: <1355407206-17100-156-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Galbraith <mgalbraith@suse.de>

commit 412d32e6c98527078779e5b515823b2810e40324 upstream.

A rescue thread exiting TASK_INTERRUPTIBLE can lead to a task scheduling
off, never to be seen again.  In the case where this occurred, an exiting
thread hit reiserfs homebrew conditional resched while holding a mutex,
bringing the box to its knees.

PID: 18105  TASK: ffff8807fd412180  CPU: 5   COMMAND: "kdmflush"
 #0 [ffff8808157e7670] schedule at ffffffff8143f489
 #1 [ffff8808157e77b8] reiserfs_get_block at ffffffffa038ab2d [reiserfs]
 #2 [ffff8808157e79a8] __block_write_begin at ffffffff8117fb14
 #3 [ffff8808157e7a98] reiserfs_write_begin at ffffffffa0388695 [reiserfs]
 #4 [ffff8808157e7ad8] generic_perform_write at ffffffff810ee9e2
 #5 [ffff8808157e7b58] generic_file_buffered_write at ffffffff810eeb41
 #6 [ffff8808157e7ba8] __generic_file_aio_write at ffffffff810f1a3a
 #7 [ffff8808157e7c58] generic_file_aio_write at ffffffff810f1c88
 #8 [ffff8808157e7cc8] do_sync_write at ffffffff8114f850
 #9 [ffff8808157e7dd8] do_acct_process at ffffffff810a268f
    [exception RIP: kernel_thread_helper]
    RIP: ffffffff8144a5c0  RSP: ffff8808157e7f58  RFLAGS: 00000202
    RAX: 0000000000000000  RBX: 0000000000000000  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: ffffffff8107af60  RDI: ffff8803ee491d18
    RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000000  R12: 0000000000000000
    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/workqueue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 478f2ab..a6a4c90 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2045,8 +2045,10 @@ static int rescuer_thread(void *__wq)
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	if (kthread_should_stop())
+	if (kthread_should_stop()) {
+		__set_current_state(TASK_RUNNING);
 		return 0;
+	}
 
 	/*
 	 * See whether any cpu is asking for help.  Unbounded
-- 
1.7.9.5

