Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1COGYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 02:24:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078Ab1COGYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 02:24:18 -0400
Date: Mon, 14 Mar 2011 23:21:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: Linux 2.6.38
Message-Id: <20110314232156.0c363813.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1103142137020.13734@chino.kir.corp.google.com>
References: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com>
	<alpine.DEB.2.00.1103142011550.16032@chino.kir.corp.google.com>
	<20110314213331.24229139.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1103142137020.13734@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 21:50:24 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Mon, 14 Mar 2011, Andrew Morton wrote:
> 
> > > once oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch is merged 
> > > from -mm
> > 
> > Please (re)send the patches which you believe should be merged into
> > 2.6.38 to address the problems which Oleg found, and any other critical
> > problems.  Not in a huge rush - let's get this right.
> > 
> 
> In my testing, Oleg's three test cases that he sent to the security list 
> and cc'd us on get appropriately oom killed once swap is exhausted or 
> swapoff -a is used on mmotm-2011-03-10-16-42 because of these two patches:
> 
> 	oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch
> 	oom-skip-zombies-when-iterating-tasklist.patch
> 
> He also presented a test case on linux-mm that caused the oom killer to 
> avoid acting if a thread is ptracing a thread in the exit path with 
> PTRACE_O_TRACEEXIT.  That should be fixed with
> 
> 	http://marc.info/?l=linux-mm&m=129997893430351
> 
> that has yet to see -mm.  There are no other test cases that have been 
> presented that cause undesired behavior.
> 
> That said, my approach to doing this has been to avoid arbitrary 
> heuristics for special cases and address known issues by adding the 
> appropriate logic in the oom killer.  For example, the ptrace problem that 
> Oleg presented showed that the oom killer logic incorrectly deferred doing 
> anything when an eligible thread was PF_EXITING.  It had done that 
> believing that nothing would stop the thread from exiting or current 
> would be given access to memory reserves itself and that assumption was 
> broken for PTRACE_O_TRACEEXIT.  My patch above, in combination with 
> Andrey's patch that only considers threads with valid mm's, fixes that 
> issue because we'll now only defer if you still have an attached mm, are 
> PF_EXITING, and are not being traced.
> 
> If, at some point, there is another gap in the exit code where a thread 
> may hold PF_EXITING with a valid mm for an indefinite period, we'll need 
> to address that in the oom killer as well.  We use PF_EXITING specifically 
> in the oom killer to identify tasks that are going to exit soon and need 
> handling for any case where that isn't guaranteed.  Anything else results 
> in needlessly killing other tasks or, in the worst case, panicking when 
> there is nothing left that is eligible.

So we're talking about three patches:

oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch
oom-skip-zombies-when-iterating-tasklist.patch
oom-avoid-deferring-oom-killer-if-exiting-task-is-being-traced.patch

all appended below.

About all of which Oleg had serious complaints, some of which haven't
yet been addressed.

And that's OK.  As I said, please let's work through it and get it right.



From: David Rientjes <rientjes@google.com>

This patch prevents unnecessary oom kills or kernel panics by reverting
two commits:

	495789a5 (oom: make oom_score to per-process value)
	cef1d352 (oom: multi threaded process coredump don't make deadlock)

First, 495789a5 (oom: make oom_score to per-process value) ignores the
fact that all threads in a thread group do not necessarily exit at the
same time.

It is imperative that select_bad_process() detect threads that are in the
exit path, specifically those with PF_EXITING set, to prevent needlessly
killing additional tasks.  If a process is oom killed and the thread group
leader exits, select_bad_process() cannot detect the other threads that
are PF_EXITING by iterating over only processes.  Thus, it currently
chooses another task unnecessarily for oom kill or panics the machine when
nothing else is eligible.

By iterating over threads instead, it is possible to detect threads that
are exiting and nominate them for oom kill so they get access to memory
reserves.

Second, cef1d352 (oom: multi threaded process coredump don't make
deadlock) erroneously avoids making the oom killer a no-op when an
eligible thread other than current isfound to be exiting.  We want to
detect this situation so that we may allow that exiting thread time to
exit and free its memory; if it is able to exit on its own, that should
free memory so current is no loner oom.  If it is not able to exit on its
own, the oom killer will nominate it for oom kill which, in this case,
only means it will get access to memory reserves.

Without this change, it is easy for the oom killer to unnecessarily target
tasks when all threads of a victim don't exit before the thread group
leader or, in the worst case, panic the machine.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: <stable@kernel.org>		[2.6.38.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/oom_kill.c~oom-prevent-unnecessary-oom-kills-or-kernel-panics mm/oom_kill.c
--- a/mm/oom_kill.c~oom-prevent-unnecessary-oom-kills-or-kernel-panics
+++ a/mm/oom_kill.c
@@ -292,11 +292,11 @@ static struct task_struct *select_bad_pr
 		unsigned long totalpages, struct mem_cgroup *mem,
 		const nodemask_t *nodemask)
 {
-	struct task_struct *p;
+	struct task_struct *g, *p;
 	struct task_struct *chosen = NULL;
 	*ppoints = 0;
 
-	for_each_process(p) {
+	do_each_thread(g, p) {
 		unsigned int points;
 
 		if (oom_unkillable_task(p, mem, nodemask))
@@ -324,7 +324,7 @@ static struct task_struct *select_bad_pr
 		 * the process of exiting and releasing its resources.
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
-		if (thread_group_empty(p) && (p->flags & PF_EXITING) && p->mm) {
+		if ((p->flags & PF_EXITING) && p->mm) {
 			if (p != current)
 				return ERR_PTR(-1UL);
 
@@ -337,7 +337,7 @@ static struct task_struct *select_bad_pr
 			chosen = p;
 			*ppoints = points;
 		}
-	}
+	} while_each_thread(g, p);
 
 	return chosen;
 }
_



From: Andrey Vagin <avagin@openvz.org>

We shouldn't defer oom killing if a thread has already detached its ->mm
and still has TIF_MEMDIE set.  Memory needs to be freed, so find kill
other threads that pin the same ->mm or find another task to kill.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <stable@kernel.org>		[2.6.38.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-skip-zombies-when-iterating-tasklist mm/oom_kill.c
--- a/mm/oom_kill.c~oom-skip-zombies-when-iterating-tasklist
+++ a/mm/oom_kill.c
@@ -299,6 +299,8 @@ static struct task_struct *select_bad_pr
 	do_each_thread(g, p) {
 		unsigned int points;
 
+		if (!p->mm)
+			continue;
 		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
 
@@ -324,7 +326,7 @@ static struct task_struct *select_bad_pr
 		 * the process of exiting and releasing its resources.
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
-		if ((p->flags & PF_EXITING) && p->mm) {
+		if (p->flags & PF_EXITING) {
 			if (p != current)
 				return ERR_PTR(-1UL);
 
_



From: David Rientjes <rientjes@google.com>

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
Cc: <stable@kernel.org>		[2.6.38.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff -puN mm/oom_kill.c~oom-avoid-deferring-oom-killer-if-exiting-task-is-being-traced mm/oom_kill.c
--- a/mm/oom_kill.c~oom-avoid-deferring-oom-killer-if-exiting-task-is-being-traced
+++ a/mm/oom_kill.c
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
_

