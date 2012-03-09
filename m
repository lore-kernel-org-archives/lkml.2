Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030579Ab2CITrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:47:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51812 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030517Ab2CITrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:47:02 -0500
Message-Id: <20120309190204.695213036@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Moyer <jmoyer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [ 29/95] aio: wake up waiters when freeing unused kiocbs
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Moyer <jmoyer@redhat.com>

commit 880641bb9da2473e9ecf6c708d993b29928c1b3c upstream.

Bart Van Assche reported a hung fio process when either hot-removing
storage or when interrupting the fio process itself.  The (pruned) call
trace for the latter looks like so:

  fio             D 0000000000000001     0  6849   6848 0x00000004
   ffff880092541b88 0000000000000046 ffff880000000000 ffff88012fa11dc0
   ffff88012404be70 ffff880092541fd8 ffff880092541fd8 ffff880092541fd8
   ffff880128b894d0 ffff88012404be70 ffff880092541b88 000000018106f24d
  Call Trace:
    schedule+0x3f/0x60
    io_schedule+0x8f/0xd0
    wait_for_all_aios+0xc0/0x100
    exit_aio+0x55/0xc0
    mmput+0x2d/0x110
    exit_mm+0x10d/0x130
    do_exit+0x671/0x860
    do_group_exit+0x44/0xb0
    get_signal_to_deliver+0x218/0x5a0
    do_signal+0x65/0x700
    do_notify_resume+0x65/0x80
    int_signal+0x12/0x17

The problem lies with the allocation batching code.  It will
opportunistically allocate kiocbs, and then trim back the list of iocbs
when there is not enough room in the completion ring to hold all of the
events.

In the case above, what happens is that the pruning back of events ends
up freeing up the last active request and the context is marked as dead,
so it is thus responsible for waking up waiters.  Unfortunately, the
code does not check for this condition, so we end up with a hung task.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -490,6 +490,8 @@ static void kiocb_batch_free(struct kioc
 		kmem_cache_free(kiocb_cachep, req);
 		ctx->reqs_active--;
 	}
+	if (unlikely(!ctx->reqs_active && ctx->dead))
+		wake_up_all(&ctx->wait);
 	spin_unlock_irq(&ctx->ctx_lock);
 }
 


