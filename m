Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030925Ab2ERC6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:58:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40558 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030722Ab2ERCwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:49 -0400
Message-Id: <20120518023258.031023376@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Josh Cartwright <joshc@linux.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 27/53] jffs2: Fix lock acquisition order bug in gc path
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Cartwright <joshc@linux.com>

commit 226bb7df3d22bcf4a1c0fe8206c80cc427498eae upstream.

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

This was introduce in '81cfc9f jffs2: Fix serious write stall due to erase'.

Signed-off-by: Josh Cartwright <joshc@linux.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jffs2/gc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/fs/jffs2/gc.c
+++ linux/fs/jffs2/gc.c
@@ -225,8 +225,8 @@
 			return 0;
 
 		D1(printk(KERN_DEBUG "No progress from erasing blocks; doing GC anyway\n"));
-		spin_lock(&c->erase_completion_lock);
 		mutex_lock(&c->alloc_sem);
+		spin_lock(&c->erase_completion_lock);
 	}
 
 	/* First, work out which block we're garbage-collecting */



