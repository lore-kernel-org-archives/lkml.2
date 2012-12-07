Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab2LGBIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:08:04 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57000 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423232Ab2LGA5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:57:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mike Galbraith <mgalbraith@suse.de>, Tejun Heo <tj@kernel.org>
Subject: [ 05/11] workqueue: exit rescuer_thread() as TASK_RUNNING
Date: Thu,  6 Dec 2012 16:57:01 -0800
Message-Id: <20121207005614.825607876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005613.189054768@linuxfoundation.org>
References: <20121207005613.189054768@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2044,8 +2044,10 @@ static int rescuer_thread(void *__wq)
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	if (kthread_should_stop())
+	if (kthread_should_stop()) {
+		__set_current_state(TASK_RUNNING);
 		return 0;
+	}
 
 	/*
 	 * See whether any cpu is asking for help.  Unbounded


