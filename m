Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379Ab2C2XfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:35:18 -0400
Received: from joshcartwright.net ([69.164.192.171]:56393 "EHLO
	li107-171.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933398Ab2C2Xe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:34:56 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2012 19:34:56 EDT
Date: Thu, 29 Mar 2012 19:34:53 -0400
From: Josh Cartwright <joshc@linux.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH V2] jffs2: Fix lock acquisition order bug in gc path
Message-ID: <20120329233453.GA23698@joshcartwright.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN8TOE-9fxbc8PM8oNVBc_tUdkYBhV6jTG8_M5GdjLNGpLhKKA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The locking policy is such that the erase_complete_block spinlock is
nested within the alloc_sem mutex.  This fixes a case in which the
acquisition order was erroneously reversed.  This issue was caught by
the following lockdep splat:

   =======================================================
   [ INFO: possible circular locking dependency detected ]
   3.0.5 #1
   -------------------------------------------------------
   jffs2_gcd_mtd6/299 is trying to acquire lock:
    (&c->alloc_sem){+.+.+.}, at: [<c01f7714>] jffs2_garbage_collect_pass+0x314/0x890

   but task is already holding lock:
    (&(&c->erase_completion_lock)->rlock){+.+...}, at: [<c01f7708>] jffs2_garbage_collect_pass+0x308/0x890

   which lock already depends on the new lock.

   the existing dependency chain (in reverse order) is:

   -> #1 (&(&c->erase_completion_lock)->rlock){+.+...}:
          [<c008bec4>] validate_chain+0xe6c/0x10bc
          [<c008c660>] __lock_acquire+0x54c/0xba4
          [<c008d240>] lock_acquire+0xa4/0x114
          [<c046780c>] _raw_spin_lock+0x3c/0x4c
          [<c01f744c>] jffs2_garbage_collect_pass+0x4c/0x890
          [<c01f937c>] jffs2_garbage_collect_thread+0x1b4/0x1cc
          [<c0071a68>] kthread+0x98/0xa0
          [<c000f264>] kernel_thread_exit+0x0/0x8

   -> #0 (&c->alloc_sem){+.+.+.}:
          [<c008ad2c>] print_circular_bug+0x70/0x2c4
          [<c008c08c>] validate_chain+0x1034/0x10bc
          [<c008c660>] __lock_acquire+0x54c/0xba4
          [<c008d240>] lock_acquire+0xa4/0x114
          [<c0466628>] mutex_lock_nested+0x74/0x33c
          [<c01f7714>] jffs2_garbage_collect_pass+0x314/0x890
          [<c01f937c>] jffs2_garbage_collect_thread+0x1b4/0x1cc
          [<c0071a68>] kthread+0x98/0xa0
          [<c000f264>] kernel_thread_exit+0x0/0x8

   other info that might help us debug this:

    Possible unsafe locking scenario:

          CPU0                    CPU1
          ----                    ----
     lock(&(&c->erase_completion_lock)->rlock);
                                  lock(&c->alloc_sem);
                                  lock(&(&c->erase_completion_lock)->rlock);
     lock(&c->alloc_sem);

    *** DEADLOCK ***

   1 lock held by jffs2_gcd_mtd6/299:
    #0:  (&(&c->erase_completion_lock)->rlock){+.+...}, at: [<c01f7708>] jffs2_garbage_collect_pass+0x308/0x890

   stack backtrace:
   [<c00155dc>] (unwind_backtrace+0x0/0x100) from [<c0463dc0>] (dump_stack+0x20/0x24)
   [<c0463dc0>] (dump_stack+0x20/0x24) from [<c008ae84>] (print_circular_bug+0x1c8/0x2c4)
   [<c008ae84>] (print_circular_bug+0x1c8/0x2c4) from [<c008c08c>] (validate_chain+0x1034/0x10bc)
   [<c008c08c>] (validate_chain+0x1034/0x10bc) from [<c008c660>] (__lock_acquire+0x54c/0xba4)
   [<c008c660>] (__lock_acquire+0x54c/0xba4) from [<c008d240>] (lock_acquire+0xa4/0x114)
   [<c008d240>] (lock_acquire+0xa4/0x114) from [<c0466628>] (mutex_lock_nested+0x74/0x33c)
   [<c0466628>] (mutex_lock_nested+0x74/0x33c) from [<c01f7714>] (jffs2_garbage_collect_pass+0x314/0x890)
   [<c01f7714>] (jffs2_garbage_collect_pass+0x314/0x890) from [<c01f937c>] (jffs2_garbage_collect_thread+0x1b4/0x1cc)
   [<c01f937c>] (jffs2_garbage_collect_thread+0x1b4/0x1cc) from [<c0071a68>] (kthread+0x98/0xa0)
   [<c0071a68>] (kthread+0x98/0xa0) from [<c000f264>] (kernel_thread_exit+0x0/0x8)

Signed-off-by: Josh Cartwright <joshc@linux.com>
---
 fs/jffs2/gc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/gc.c b/fs/jffs2/gc.c
index ad271c7..5a2dec2 100644
--- a/fs/jffs2/gc.c
+++ b/fs/jffs2/gc.c
@@ -234,8 +234,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 			return 0;
 
 		jffs2_dbg(1, "No progress from erasing block; doing GC anyway\n");
-		spin_lock(&c->erase_completion_lock);
 		mutex_lock(&c->alloc_sem);
+		spin_lock(&c->erase_completion_lock);
 	}
 
 	/* First, work out which block we're garbage-collecting */
-- 
1.7.2.5

