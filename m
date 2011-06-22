Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1FVOnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:43:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:64570 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab1FVOm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:42:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,406,1304319600"; 
   d="scan'208";a="16849906"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] sched: fix false lockdep warning in set_task_cpu()
Date: Wed, 22 Jun 2011 17:42:57 +0300
Message-Id: <1308753777-23024-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we have CONFIG_LOCKDEP enabled we get occasionally following warning
on the system console at boot:

 WARNING: at kernel/sched.c:2204 set_task_cpu+0x1a1/0x390()
 Modules linked in:
 Pid: 133, comm: mount Not tainted 3.0.0-rc2+ #70
 Call Trace:
  [<c104137d>] warn_slowpath_common+0x6d/0xa0
  [<c103d3b1>] ? set_task_cpu+0x1a1/0x390
  [<c103d3b1>] ? set_task_cpu+0x1a1/0x390
  [<c10413cd>] warn_slowpath_null+0x1d/0x20
  [<c103d3b1>] set_task_cpu+0x1a1/0x390
  [<c103e0a7>] try_to_wake_up+0x127/0x250
  [<c103e1db>] default_wake_function+0xb/0x10
  [<c106290e>] autoremove_wake_function+0x1e/0x50
  [<c102a2b0>] __wake_up_common+0x40/0x70
  [<c102f2d7>] __wake_up+0x37/0x50
  [<c12d36c0>] ? serial_m3110_enable_ms+0x10/0x10
  [<c12d3715>] serial_m3110_con_write+0x55/0x60
  [<c1041575>] __call_console_drivers+0x75/0x90
  [<c10415d9>] _call_console_drivers+0x49/0x80
  [<c1041baa>] console_unlock+0xca/0x1f0
  [<c10420ef>] vprintk+0x18f/0x4f0
  [<c10787cb>] ? trace_hardirqs_on+0xb/0x10
  [<c107985e>] ? lockdep_init_map+0x4e/0x4c0
  [<c10787cb>] ? trace_hardirqs_on+0xb/0x10
  [<c14928a3>] printk+0x18/0x1a
  [<c115dd4e>] ext3_msg+0x3e/0x40
  [<c116046a>] ext3_fill_super+0x16ba/0x1960
  [<c11478b8>] ? disk_name+0x88/0xc0
  [<c10fa88d>] mount_bdev+0x16d/0x1b0
  [<c10ed667>] ? __kmalloc_track_caller+0xf7/0x280
  [<c1112021>] ? alloc_vfsmnt+0x81/0x140
  [<c115d20a>] ext3_mount+0x1a/0x20
  [<c115edb0>] ? ext3_clear_journal_err+0xa0/0xa0
  [<c10f95dc>] mount_fs+0x1c/0xc0
  [<c10d763a>] ? __alloc_percpu+0xa/0x10
  [<c111203b>] ? alloc_vfsmnt+0x9b/0x140
  [<c1112896>] vfs_kern_mount+0x46/0xa0
  [<c1113609>] do_kern_mount+0x39/0xd0
  [<c1114087>] do_mount+0x2c7/0x680
  [<c10d31f9>] ? strndup_user+0x49/0x60
  [<c11144a6>] sys_mount+0x66/0xa0
  [<c14976d0>] sysenter_do_call+0x12/0x36

This is due the fact that printk() disables lockdep before the output is
passed to the actual console driver. If the console driver happens to call
some functions which eventually calls set_task_cpu() we end up failing the
following test:

       WARN_ON_ONCE(debug_locks && !(lockdep_is_held(&p->pi_lock) ||
                                     lockdep_is_held(&task_rq(p)->lock)));

This is because lockdep_is_held() returns 0 if lockdep is temporarily
disabled.

So we check whether lockdep is enabled and only then validate the locks.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
I'm not entirely sure if using current->lockdep_recursion is allowed here.
Maybe there is some cleaner way of fixing this, like adding lockdep_is_on()
function or something? RCU seems to use the same variable, though.

 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7928d8f..6c2bf57 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2211,8 +2211,9 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	 * Furthermore, all task_rq users should acquire both locks, see
 	 * task_rq_lock().
 	 */
-	WARN_ON_ONCE(debug_locks && !(lockdep_is_held(&p->pi_lock) ||
-				      lockdep_is_held(&task_rq(p)->lock)));
+	WARN_ON_ONCE(debug_locks && !current->lockdep_recursion &&
+			!(lockdep_is_held(&p->pi_lock) ||
+			  lockdep_is_held(&task_rq(p)->lock)));
 #endif
 #endif
 
-- 
1.7.5.4

