Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2LCOzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:55:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43613 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932137Ab2LCOfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:53 -0500
Message-Id: <20121203143200.119258717@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:33:13 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Galbraith <mgalbraith@suse.de>, Tejun Heo <tj@kernel.org>
Subject: [ 87/89] workqueue: exit rescuer_thread() as TASK_RUNNING
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/workqueue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 042d221..ac25db1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2407,8 +2407,10 @@ static int rescuer_thread(void *__wq)
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	if (kthread_should_stop())
+	if (kthread_should_stop()) {
+		__set_current_state(TASK_RUNNING);
 		return 0;
+	}
 
 	/*
 	 * See whether any cpu is asking for help.  Unbounded


