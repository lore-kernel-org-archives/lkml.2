Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2BPT4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:56:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2BPT4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:56:31 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-aio@kvack.org, stable@kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [patch] aio: wake up waiters when freeing unused kiocbs
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 16 Feb 2012 14:56:15 -0500
Message-ID: <x49lio2y2lc.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Bart Van Assche reported a hung fio process when either hot-removing
storage or when interrupting the fio process itself.  The (pruned) call
trace for the latter looks like so:

fio             D 0000000000000001     0  6849   6848 0x00000004
 ffff880092541b88 0000000000000046 ffff880000000000 ffff88012fa11dc0
 ffff88012404be70 ffff880092541fd8 ffff880092541fd8 ffff880092541fd8
 ffff880128b894d0 ffff88012404be70 ffff880092541b88 000000018106f24d
Call Trace:
 [<ffffffff813b683f>] schedule+0x3f/0x60
 [<ffffffff813b68ef>] io_schedule+0x8f/0xd0
 [<ffffffff81174410>] wait_for_all_aios+0xc0/0x100
 [<ffffffff81175385>] exit_aio+0x55/0xc0
 [<ffffffff810413cd>] mmput+0x2d/0x110
 [<ffffffff81047c1d>] exit_mm+0x10d/0x130
 [<ffffffff810482b1>] do_exit+0x671/0x860
 [<ffffffff81048804>] do_group_exit+0x44/0xb0
 [<ffffffff81058018>] get_signal_to_deliver+0x218/0x5a0
 [<ffffffff81002065>] do_signal+0x65/0x700
 [<ffffffff81002785>] do_notify_resume+0x65/0x80
 [<ffffffff813c0333>] int_signal+0x12/0x17

The problem lies with the allocation batching code.  It will
opportunistically allocate kiocbs, and then trim back the list of iocbs
when there is not enough room in the completion ring to hold all of the
events.  In the case above, what happens is that the pruning back of
events ends up freeing up the last active request and the context is
marked as dead, so it is thus responsible for waking up waiters.
Unfortunately, the code does not check for this condition, so we end up
with a hung task.

Bart reports that the below patch has fixed the problem in his testing.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Reported-and-Tested-by: Bart Van Assche <bvanassche@acm.org>

---
Note for stable: this should be applied to 3.2.

diff --git a/fs/aio.c b/fs/aio.c
index 969beb0..67e4b90 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -490,6 +490,8 @@ static void kiocb_batch_free(struct kioctx *ctx, struct kiocb_batch *batch)
 		kmem_cache_free(kiocb_cachep, req);
 		ctx->reqs_active--;
 	}
+	if (unlikely(!ctx->reqs_active && ctx->dead))
+		wake_up_all(&ctx->wait);
 	spin_unlock_irq(&ctx->ctx_lock);
 }
 
