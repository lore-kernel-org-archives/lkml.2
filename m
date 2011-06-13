Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1FMDQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 23:16:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60071 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1FMDQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 23:16:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 13 Jun 2011 12:09:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Hugh Dickins <hughd@google.com>, davej@redhat.com
Subject: [BUGFIX][PATCH 3/5] memcg: clear mm->owner when last possible owner
 leaves
Message-Id: <20110613120951.d4542c5b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is Hugh's version.
==
>From c3d1fb5637dd01ae034cdf2106aaf3249856738e Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 13 Jun 2011 10:26:29 +0900
Subject: [PATCH 3/5] [BUGFIX] memcg: clear mm->owner when last possible owner leaves

The following crash was reported:

> Call Trace:
> [<ffffffff81139792>] mem_cgroup_from_task+0x15/0x17
> [<ffffffff8113a75a>] __mem_cgroup_try_charge+0x148/0x4b4
> [<ffffffff810493f3>] ? need_resched+0x23/0x2d
> [<ffffffff814cbf43>] ? preempt_schedule+0x46/0x4f
> [<ffffffff8113afe8>] mem_cgroup_charge_common+0x9a/0xce
> [<ffffffff8113b6d1>] mem_cgroup_newpage_charge+0x5d/0x5f
> [<ffffffff81134024>] khugepaged+0x5da/0xfaf
> [<ffffffff81078ea0>] ? __init_waitqueue_head+0x4b/0x4b
> [<ffffffff81133a4a>] ? add_mm_counter.constprop.5+0x13/0x13
> [<ffffffff81078625>] kthread+0xa8/0xb0
> [<ffffffff814d13e8>] ? sub_preempt_count+0xa1/0xb4
> [<ffffffff814d5664>] kernel_thread_helper+0x4/0x10
> [<ffffffff814ce858>] ? retint_restore_args+0x13/0x13
> [<ffffffff8107857d>] ? __init_kthread_worker+0x5a/0x5a

What happens is that khugepaged tries to charge a huge page against an
mm whose last possible owner has already exited, and the memory
controller crashes when the stale mm->owner is used to look up the
cgroup to charge.

mm->owner has never been set to NULL with the last owner going away,
but nobody cared until khugepaged came along.

Even then it wasn't a problem because the final mmput() on an mm was
forced to acquire and release mmap_sem in write-mode, preventing an
exiting owner to go away while the mmap_sem was held, and until
"692e0b3 mm: thp: optimize memcg charge in khugepaged", the memory
cgroup charge was protected by mmap_sem in read-mode.

Instead of going back to relying on the mmap_sem to enforce lifetime
of a task, this patch ensures that mm->owner is properly set to NULL
when the last possible owner is exiting, which the memory controller
can handle just fine.

Reported-by: Hugh Dickins <hughd@google.com>
Reported-by: Dave Jones <davej@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/exit.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 20a4064..26c5feb 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -561,29 +561,28 @@ void exit_files(struct task_struct *tsk)
 
 #ifdef CONFIG_MM_OWNER
 /*
- * Task p is exiting and it owned mm, lets find a new owner for it
+ * A task is exiting and if it owned mm, lets find a new owner for it
  */
-static inline int
-mm_need_new_owner(struct mm_struct *mm, struct task_struct *p)
-{
-	/*
-	 * If there are other users of the mm and the owner (us) is exiting
-	 * we need to find a new owner to take on the responsibility.
-	 */
-	if (atomic_read(&mm->mm_users) <= 1)
-		return 0;
-	if (mm->owner != p)
-		return 0;
-	return 1;
-}
-
 void mm_update_next_owner(struct mm_struct *mm)
 {
 	struct task_struct *c, *g, *p = current;
 
 retry:
-	if (!mm_need_new_owner(mm, p))
+	/*
+	 * If the exiting or execing task is not the owner, it's
+	 * someone else's problem.
+	 */
+	if (mm->owner != p)
 		return;
+	/*
+	 * The current owner is exiting/execing and there are no other
+	 * candidates.  Do not leave the mm pointing to a possibly
+	 * freed task structure.
+	 */
+	if (atomic_read(&mm->mm_users) <= 1) {
+		mm->owner = NULL;
+		return;
+	}
 
 	read_lock(&tasklist_lock);
 	/*
-- 
1.7.4.1


