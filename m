Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668Ab1FXPg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 11:36:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab1FXPgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 11:36:55 -0400
Date: Fri, 24 Jun 2011 17:34:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        pedro@codesourcery.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ptrace: kill real_parent_is_ptracer() in in favor of
	ptrace_reparented()
Message-ID: <20110624153423.GC9346@redhat.com>
References: <20110624153330.GA9346@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110624153330.GA9346@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill real_parent_is_ptracer() and update the callers to use
ptrace_reparented(), after the previous patch they do the same.

Remove the unnecessary ->ptrace != 0 check in get_signal_to_deliver(),
if ptrace_reparented() == T then the task must be ptraced.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- ptrace/kernel/signal.c~10_kill_real_parent_is_ptracer	2011-06-24 16:53:25.000000000 +0200
+++ ptrace/kernel/signal.c	2011-06-24 16:59:20.000000000 +0200
@@ -1760,15 +1760,6 @@ static int sigkill_pending(struct task_s
 }
 
 /*
- * Test whether the target task of the usual cldstop notification - the
- * real_parent of @child - is in the same group as the ptracer.
- */
-static bool real_parent_is_ptracer(struct task_struct *child)
-{
-	return same_thread_group(child->parent, child->real_parent);
-}
-
-/*
  * This must be called with current->sighand->siglock held.
  *
  * This should be the path for all ptrace stops.
@@ -1848,7 +1839,7 @@ static void ptrace_stop(int exit_code, i
 		 * separately unless they're gonna be duplicates.
 		 */
 		do_notify_parent_cldstop(current, true, why);
-		if (gstop_done && !real_parent_is_ptracer(current))
+		if (gstop_done && ptrace_reparented(current))
 			do_notify_parent_cldstop(current, false, why);
 
 		/*
@@ -2154,7 +2145,6 @@ relock:
 	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
 	 */
 	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
-		struct task_struct *leader;
 		int why;
 
 		if (signal->flags & SIGNAL_CLD_CONTINUED)
@@ -2175,13 +2165,11 @@ relock:
 		 * a duplicate.
 		 */
 		read_lock(&tasklist_lock);
-
 		do_notify_parent_cldstop(current, false, why);
 
-		leader = current->group_leader;
-		if (leader->ptrace && !real_parent_is_ptracer(leader))
-			do_notify_parent_cldstop(leader, true, why);
-
+		if (ptrace_reparented(current->group_leader))
+			do_notify_parent_cldstop(current->group_leader,
+						true, why);
 		read_unlock(&tasklist_lock);
 
 		goto relock;

