Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab1ADUZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:25:30 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:54184 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1ADUZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:25:29 -0500
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>,
        Bart Van Assche <bart.vanassche@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: [PATCH] slub: Fix sysfs circular locking dependency
Date: Tue,  4 Jan 2011 22:25:17 +0200
Message-Id: <1294172717-6044-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Bart, does this patch fix the problem for you? ]

This patch fixes the following potential deadlock reported by Bart Van Assche:

  =======================================================
  [ INFO: possible circular locking dependency detected ]
  2.6.37-rc6+ #12
  -------------------------------------------------------
  grep/10562 is trying to acquire lock:
   (slub_lock){+++++.}, at: [<ffffffff8114baec>] show_slab_objects+0xfc/0x390

  but task is already holding lock:
   (s_active#182){++++.+}, at: [<ffffffff811c4b16>] sysfs_read_file+0x96/0x1c0

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (s_active#182){++++.+}:
         [<ffffffff81096b00>] lock_acquire+0xa0/0x150
         [<ffffffff811c5b77>] sysfs_deactivate+0x157/0x1c0
         [<ffffffff811c6273>] sysfs_addrm_finish+0x43/0x70
         [<ffffffff811c637e>] sysfs_remove_dir+0x7e/0xa0
         [<ffffffff812c3616>] kobject_del+0x16/0x40
         [<ffffffff8114c132>] kmem_cache_destroy+0x2f2/0x380
         [<ffffffffa01b4bd1>] 0xffffffffa01b4bd1
         [<ffffffff810a1682>] sys_delete_module+0x1a2/0x280
         [<ffffffff81003042>] system_call_fastpath+0x16/0x1b

  -> #0 (slub_lock){+++++.}:
         [<ffffffff810968c0>] __lock_acquire+0x1370/0x1510
         [<ffffffff81096b00>] lock_acquire+0xa0/0x150
         [<ffffffff81548f41>] down_read+0x51/0xa0
         [<ffffffff8114baec>] show_slab_objects+0xfc/0x390
         [<ffffffff8114be33>] objects_show+0x13/0x20
         [<ffffffff81145e92>] slab_attr_show+0x22/0x30
         [<ffffffff811c4b59>] sysfs_read_file+0xd9/0x1c0
         [<ffffffff81158f8d>] vfs_read+0xcd/0x1a0
         [<ffffffff81159854>] sys_read+0x54/0x90
         [<ffffffff81003042>] system_call_fastpath+0x16/0x1b

  other info that might help us debug this:

  2 locks held by grep/10562:
   #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff811c4ac6>] sysfs_read_file+0x46/0x1c0
   #1:  (s_active#182){++++.+}, at: [<ffffffff811c4b16>] sysfs_read_file+0x96/0x1c0

  stack backtrace:
  Pid: 10562, comm: grep Tainted: G        W   2.6.37-rc6+ #12
  Call Trace:
   [<ffffffff81094379>] print_circular_bug+0xf9/0x100
   [<ffffffff810968c0>] __lock_acquire+0x1370/0x1510
   [<ffffffff8100a3d9>] ? sched_clock+0x9/0x10
   [<ffffffff81148a5c>] ? check_object+0xac/0x250
   [<ffffffff81096b00>] lock_acquire+0xa0/0x150
   [<ffffffff8114baec>] ? show_slab_objects+0xfc/0x390
   [<ffffffff8109522d>] ? trace_hardirqs_on_caller+0x14d/0x190
   [<ffffffff81548f41>] down_read+0x51/0xa0
   [<ffffffff8114baec>] ? show_slab_objects+0xfc/0x390
   [<ffffffff8114baec>] show_slab_objects+0xfc/0x390
   [<ffffffff8114be33>] objects_show+0x13/0x20
   [<ffffffff81145e92>] slab_attr_show+0x22/0x30
   [<ffffffff811c4b59>] sysfs_read_file+0xd9/0x1c0
   [<ffffffff81158f8d>] vfs_read+0xcd/0x1a0
   [<ffffffff81159854>] sys_read+0x54/0x90
   [<ffffffff81003042>] system_call_fastpath+0x16/0x1b

The problem here is that locking order is implicitly (1) sysfs internals and
(2) slub_lock but we violate that in kmem_cache_destroy().

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=25622
Reported-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 mm/slub.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index bec0e35..9831004 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2516,7 +2516,13 @@ void kmem_cache_destroy(struct kmem_cache *s)
 		}
 		if (s->flags & SLAB_DESTROY_BY_RCU)
 			rcu_barrier();
+		/*
+		 * The locking order is (1) sysfs internal locks and (2)
+		 * slub_lock so drop the latter to avoid a deadlock.
+		 */
+		up_write(&slub_lock);
 		sysfs_slab_remove(s);
+		return;
 	}
 	up_write(&slub_lock);
 }
-- 
1.7.0.4

