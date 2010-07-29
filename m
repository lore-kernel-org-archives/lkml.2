Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab0G2PPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:15:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab0G2PPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:15:00 -0400
Date: Thu, 29 Jul 2010 17:12:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        andi.kleen@intel.com, stable@kernel.org
Subject: [PATCH] ptrace: optimize exit_ptrace() for the likely case
Message-ID: <20100729151229.GA24754@redhat.com>
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com> <20100721144944.5351c741.akpm@linux-foundation.org> <20100721222529.EFBAA400B6@magilla.sf.frob.com> <20100722090524.GA6647@redhat.com> <1279874705.2096.1274.camel@ymzhang.sh.intel.com> <20100723173453.GA29831@redhat.com> <1280120732.2085.3.camel@ymzhang.sh.intel.com> <20100726085324.GA32223@redhat.com> <1280193353.2085.15.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280193353.2085.15.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(replaces ptrace-dont-run-write_locktasklist_lock-if-the-parent-doesnt-ptrace-other-processes.patch)

exit_ptrace() takes tasklist_lock unconditionally. We need this lock
to avoid the race with ptrace_traceme(), it acts as a barrier.

Change its caller, forget_original_parent(), to call exit_ptrace()
under tasklist_lock. Change exit_ptrace() to drop and reacquire this
lock if needed.

This allows us to add the fastpath list_empty(ptraced) check. In the
likely no-tracees case exit_ptrace() just returns and we avoid the
lock() + unlock() sequence.

"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> suggested to add this
check, and he reports that this change adds about 11% improvement in
some tests.

Suggested-and-tested-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |   12 +++++++++---
 kernel/exit.c   |    7 +++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

--- 35-rc3/kernel/ptrace.c~exit_ptrace_fastpath_check	2010-05-28 13:41:41.000000000 +0200
+++ 35-rc3/kernel/ptrace.c	2010-07-29 16:37:13.000000000 +0200
@@ -324,26 +324,32 @@ int ptrace_detach(struct task_struct *ch
 }
 
 /*
- * Detach all tasks we were using ptrace on.
+ * Detach all tasks we were using ptrace on. Called with tasklist held
+ * for writing, and returns with it held too. But note it can release
+ * and reacquire the lock.
  */
 void exit_ptrace(struct task_struct *tracer)
 {
 	struct task_struct *p, *n;
 	LIST_HEAD(ptrace_dead);
 
-	write_lock_irq(&tasklist_lock);
+	if (likely(list_empty(&tracer->ptraced)))
+		return;
+
 	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
 		if (__ptrace_detach(tracer, p))
 			list_add(&p->ptrace_entry, &ptrace_dead);
 	}
-	write_unlock_irq(&tasklist_lock);
 
+	write_unlock_irq(&tasklist_lock);
 	BUG_ON(!list_empty(&tracer->ptraced));
 
 	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
 		list_del_init(&p->ptrace_entry);
 		release_task(p);
 	}
+
+	write_lock_irq(&tasklist_lock);
 }
 
 int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)
--- 35-rc3/kernel/exit.c~exit_ptrace_fastpath_check	2010-05-28 13:41:41.000000000 +0200
+++ 35-rc3/kernel/exit.c	2010-07-29 16:38:37.000000000 +0200
@@ -771,9 +771,12 @@ static void forget_original_parent(struc
 	struct task_struct *p, *n, *reaper;
 	LIST_HEAD(dead_children);
 
-	exit_ptrace(father);
-
 	write_lock_irq(&tasklist_lock);
+	/*
+	 * Note that exit_ptrace() and find_new_reaper() might
+	 * drop tasklist_lock and reacquire it.
+	 */
+	exit_ptrace(father);
 	reaper = find_new_reaper(father);
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {

