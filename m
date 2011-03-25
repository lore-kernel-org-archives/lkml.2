Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab1CZAZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:25:44 -0400
Received: from kroah.org ([198.145.64.141]:41533 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572Ab1CYXw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:09 2011
Message-Id: <20110325234509.714664633@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:43:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Andrey Vagin <avagin@openvz.org>
Subject: [18/63] oom: avoid deferring oom killer if exiting task is being traced
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Rientjes <rientjes@google.com>

commit edd45544c6f09550df0a5491aa8a07af24767e73 upstream.

The oom killer naturally defers killing anything if it finds an eligible
task that is already exiting and has yet to detach its ->mm.  This avoids
unnecessarily killing tasks when one is already in the exit path and may
free enough memory that the oom killer is no longer needed.  This is
detected by PF_EXITING since threads that have already detached its ->mm
are no longer considered at all.

The problem with always deferring when a thread is PF_EXITING, however, is
that it may never actually exit when being traced, specifically if another
task is tracing it with PTRACE_O_TRACEEXIT.  The oom killer does not want
to defer in this case since there is no guarantee that thread will ever
exit without intervention.

This patch will now only defer the oom killer when a thread is PF_EXITING
and no ptracer has stopped its progress in the exit path.  It also ensures
that a child is sacrificed for the chosen parent only if it has a
different ->mm as the comment implies: this ensures that the thread group
leader is always targeted appropriately.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/oom_kill.c |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -31,6 +31,7 @@
 #include <linux/memcontrol.h>
 #include <linux/mempolicy.h>
 #include <linux/security.h>
+#include <linux/ptrace.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
@@ -316,22 +317,29 @@ static struct task_struct *select_bad_pr
 		if (test_tsk_thread_flag(p, TIF_MEMDIE))
 			return ERR_PTR(-1UL);
 
-		/*
-		 * This is in the process of releasing memory so wait for it
-		 * to finish before killing some other task by mistake.
-		 *
-		 * However, if p is the current task, we allow the 'kill' to
-		 * go ahead if it is exiting: this will simply set TIF_MEMDIE,
-		 * which will allow it to gain access to memory reserves in
-		 * the process of exiting and releasing its resources.
-		 * Otherwise we could get an easy OOM deadlock.
-		 */
 		if (p->flags & PF_EXITING) {
-			if (p != current)
-				return ERR_PTR(-1UL);
-
-			chosen = p;
-			*ppoints = 1000;
+			/*
+			 * If p is the current task and is in the process of
+			 * releasing memory, we allow the "kill" to set
+			 * TIF_MEMDIE, which will allow it to gain access to
+			 * memory reserves.  Otherwise, it may stall forever.
+			 *
+			 * The loop isn't broken here, however, in case other
+			 * threads are found to have already been oom killed.
+			 */
+			if (p == current) {
+				chosen = p;
+				*ppoints = 1000;
+			} else {
+				/*
+				 * If this task is not being ptraced on exit,
+				 * then wait for it to finish before killing
+				 * some other task unnecessarily.
+				 */
+				if (!(task_ptrace(p->group_leader) &
+							PT_TRACE_EXIT))
+					return ERR_PTR(-1UL);
+			}
 		}
 
 		points = oom_badness(p, mem, nodemask, totalpages);
@@ -493,6 +501,8 @@ static int oom_kill_process(struct task_
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
 
+			if (child->mm == p->mm)
+				continue;
 			/*
 			 * oom_badness() returns 0 if the thread is unkillable
 			 */


