Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1CVKUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:20:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54891 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab1CVKUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cd97Wop2VYYe+p/YffQIE9ZrE7fDsMWzsJ5eyMtdO9IYIXzfg2v5LkyjJ757XQzJ+O
         x9bVtWRpMKvsmT3frzFgfmt9Ih3dMdgz1ZB9tG+/sdimmFwEHkyzzaPhOrq9Ee1IqNyw
         pffsSSmOUh1KFEsjk0/QxawsxMdNQLnjkmcqc=
Date: Tue, 22 Mar 2011 11:20:46 +0100
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: [PATCH 0.2/8] ptrace: Always put ptracee into appropriate
 execution state
Message-ID: <20110322102046.GO12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299614199-25142-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, __ptrace_unlink() wakes up the tracee iff it's in
TASK_TRACED.  For unlinking from PTRACE_DETACH, this is correct as the
tracee is guaranteed to be in TASK_TRACED or dead; however, unlinking
also happens when the ptracer exits and in this case the ptracee can
be in any state and ptrace might be left running even if the group it
belongs to is stopped.

This patch updates __ptrace_unlink() such that GROUP_STOP_PENDING is
reinstated regardless of the ptracee's current state as long as it's
alive and makes sure that signal_wake_up() is called if execution
state transition is necessary.

Test case follows.

  #include <unistd.h>
  #include <time.h>
  #include <sys/types.h>
  #include <sys/ptrace.h>
  #include <sys/wait.h>

  static const struct timespec ts1s = { .tv_sec = 1 };

  int main(void)
  {
	  pid_t tracee;
	  siginfo_t si;

	  tracee = fork();
	  if (tracee == 0) {
		  while (1) {
			  nanosleep(&ts1s, NULL);
			  write(1, ".", 1);
		  }
	  }

	  ptrace(PTRACE_ATTACH, tracee, NULL, NULL);
	  waitid(P_PID, tracee, &si, WSTOPPED);
	  ptrace(PTRACE_CONT, tracee, NULL, (void *)(long)si.si_status);
	  waitid(P_PID, tracee, &si, WSTOPPED);
	  ptrace(PTRACE_CONT, tracee, NULL, (void *)(long)si.si_status);
	  write(1, "exiting", 7);
	  return 0;
  }

Before the patch, after the parent process exits, the child is left
running and prints out "." every second.

  exiting..... (continues)

After the patch, the group stop initiated by the implied SIGSTOP from
PTRACE_ATTACH is re-established when the parent exits.

  exiting

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/ptrace.c |   59 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 20 deletions(-)

Index: work/kernel/ptrace.c
===================================================================
--- work.orig/kernel/ptrace.c
+++ work/kernel/ptrace.c
@@ -41,7 +41,26 @@ void __ptrace_link(struct task_struct *c
  * __ptrace_unlink - unlink ptracee and restore its execution state
  * @child: ptracee to be unlinked
  *
- * Remove @child from the ptrace list, move it back to the original parent.
+ * Remove @child from the ptrace list, move it back to the original parent,
+ * and restore the execution state so that it conforms to the group stop
+ * state.
+ *
+ * Unlinking can happen via two paths - explicit PTRACE_DETACH or ptracer
+ * exiting.  For PTRACE_DETACH, unless the ptracee has been killed between
+ * ptrace_check_attach() and here, it's guaranteed to be in TASK_TRACED.
+ * If the ptracer is exiting, the ptracee can be in any state.
+ *
+ * After detach, the ptracee should be in a state which conforms to the
+ * group stop.  If the group is stopped or in the process of stopping, the
+ * ptracee should be put into TASK_STOPPED; otherwise, it should be woken
+ * up from TASK_TRACED.
+ *
+ * If the ptracee is in TASK_TRACED and needs to be moved to TASK_STOPPED,
+ * it goes through TRACED -> RUNNING -> STOPPED transition which is similar
+ * to but in the opposite direction of what happens while attaching to a
+ * stopped task.  However, in this direction, the intermediate RUNNING
+ * state is not hidden even from the current ptracer and if it immediately
+ * re-attaches and performs a WNOHANG wait(2), it may fail.
  *
  * CONTEXT:
  * write_lock_irq(tasklist_lock)
@@ -55,25 +74,25 @@ void __ptrace_unlink(struct task_struct
 	list_del_init(&child->ptrace_entry);
 
 	spin_lock(&child->sighand->siglock);
-	if (task_is_traced(child)) {
-		/*
-		 * If group stop is completed or in progress, it should
-		 * participate in the group stop.  Set GROUP_STOP_PENDING
-		 * before kicking it.
-		 *
-		 * This involves TRACED -> RUNNING -> STOPPED transition
-		 * which is similar to but in the opposite direction of
-		 * what happens while attaching to a stopped task.
-		 * However, in this direction, the intermediate RUNNING
-		 * state is not hidden even from the current ptracer and if
-		 * it immediately re-attaches and performs a WNOHANG
-		 * wait(2), it may fail.
-		 */
-		if (child->signal->flags & SIGNAL_STOP_STOPPED ||
-		    child->signal->group_stop_count)
-			child->group_stop |= GROUP_STOP_PENDING;
-		signal_wake_up(child, 1);
-	}
+
+	/*
+	 * Reinstate GROUP_STOP_PENDING if group stop is in effect and
+	 * @child isn't dead.
+	 */
+	if (!(child->flags & PF_EXITING) &&
+	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
+	     child->signal->group_stop_count))
+		child->group_stop |= GROUP_STOP_PENDING;
+
+	/*
+	 * If transition to TASK_STOPPED is pending or in TASK_TRACED, kick
+	 * @child in the butt.  Note that @resume should be used iff @child
+	 * is in TASK_TRACED; otherwise, we might unduly disrupt
+	 * TASK_KILLABLE sleeps.
+	 */
+	if (child->group_stop & GROUP_STOP_PENDING || task_is_traced(child))
+		signal_wake_up(child, task_is_traced(child));
+
 	spin_unlock(&child->sighand->siglock);
 }
 
