Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab1CYXwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:52:30 -0400
Received: from kroah.org ([198.145.64.141]:41513 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab1CYXw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:09 2011
Message-Id: <20110325234509.522758506@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:43:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: [16/63] oom: prevent unnecessary oom kills or kernel panics
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Rientjes <rientjes@google.com>

commit 3a5dda7a17cf3706f79b86293f29db02d61e0d48 upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/oom_kill.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
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


