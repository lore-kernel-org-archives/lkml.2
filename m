Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1CVLaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:30:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56951 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1CVLaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WuYYW0R62qYxb7EThXw3USuMjVrM5mDPYyw5pGMtKUFCRLgMQlPHo7tfoKsGz7dnLy
         DFaxXBpvg/WQXXYgkY6UWLdPCpAWHHTxjKzn0umHuRyrquAoNfUtWWPQlpKiuMOTx9Gf
         FVhV8oRRmwUTjqb+NfWWyqKFVpG2wMbQmxWQ0=
Date: Tue, 22 Mar 2011 12:30:08 +0100
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: [PATCH UPDATED 7/8] job control: Notify the real parent of job
 control events regardless of ptrace
Message-ID: <20110322113008.GR12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299614199-25142-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent changes, job control and ptrace stopped states are
properly separated and accessible to the real parent and the ptracer
respectively; however, notifications of job control stopped/continued
events to the real parent while ptraced are still missing.

A ptracee participates in group stop in ptrace_stop() but the
completion isn't notified.  If participation results in completion of
group stop, notify the real parent of the event.  The ptrace and group
stops are separate and can be handled as such.

However, when the real parent and the ptracer are in the same thread
group, only the ptrace stop event is visible through wait(2) and the
duplicate notifications are different from the current behavior and
are confusing.  Suppress group stop notification in such cases.

The continued state is shared between the real parent and the ptracer
but is only meaningful to the real parent.  Always notify the real
parent and notify the ptracer too for backward compatibility.  Similar
to stop notification, if the real parent is the ptracer, suppress a
duplicate notification.

Test case follows.

  #include <stdio.h>
  #include <unistd.h>
  #include <time.h>
  #include <errno.h>
  #include <sys/types.h>
  #include <sys/ptrace.h>
  #include <sys/wait.h>

  int main(void)
  {
	  const struct timespec ts100ms = { .tv_nsec = 100000000 };
	  pid_t tracee, tracer;
	  siginfo_t si;
	  int i;

	  tracee = fork();
	  if (tracee == 0) {
		  while (1) {
			  printf("tracee: SIGSTOP\n");
			  raise(SIGSTOP);
			  nanosleep(&ts100ms, NULL);
			  printf("tracee: SIGCONT\n");
			  raise(SIGCONT);
			  nanosleep(&ts100ms, NULL);
		  }
	  }

	  waitid(P_PID, tracee, &si, WSTOPPED | WNOHANG | WNOWAIT);

	  tracer = fork();
	  if (tracer == 0) {
		  nanosleep(&ts100ms, NULL);
		  ptrace(PTRACE_ATTACH, tracee, NULL, NULL);

		  for (i = 0; i < 11; i++) {
			  si.si_pid = 0;
			  waitid(P_PID, tracee, &si, WSTOPPED);
			  if (si.si_pid && si.si_code == CLD_TRAPPED)
				  ptrace(PTRACE_CONT, tracee, NULL,
					 (void *)(long)si.si_status);
		  }
		  printf("tracer: EXITING\n");
		  return 0;
	  }

	  while (1) {
		  si.si_pid = 0;
		  waitid(P_PID, tracee, &si, WSTOPPED | WCONTINUED | WEXITED);
		  if (si.si_pid)
			  printf("mommy : WAIT status=%02d code=%02d\n",
				 si.si_status, si.si_code);
	  }
	  return 0;
  }

Before this patch, while ptraced, the real parent doesn't get
notifications for job control events, so although it can access those
events, the later waitid(2) call never wakes up.

  tracee: SIGSTOP
  mommy : WAIT status=19 code=05
  tracee: SIGCONT
  tracee: SIGSTOP
  tracee: SIGCONT
  tracee: SIGSTOP
  tracee: SIGCONT
  tracee: SIGSTOP
  tracer: EXITING
  mommy : WAIT status=19 code=05
  ^C

After this patch, it works as expected.

  tracee: SIGSTOP
  mommy : WAIT status=19 code=05
  tracee: SIGCONT
  mommy : WAIT status=18 code=06
  tracee: SIGSTOP
  mommy : WAIT status=19 code=05
  tracee: SIGCONT
  mommy : WAIT status=18 code=06
  tracee: SIGSTOP
  mommy : WAIT status=19 code=05
  tracee: SIGCONT
  mommy : WAIT status=18 code=06
  tracee: SIGSTOP
  tracer: EXITING
  mommy : WAIT status=19 code=05
  ^C

-v2: Oleg pointed out that

     * Group stop notification to the real parent should also happen
       when ptracer detach races with ptrace_stop().

     * real_parent_is_ptracer() should be testing thread group
       equality not the task itself as wait(2) and stop/cont
       notifications are normally thread-group wide.

     Both issues are fixed accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

Index: work/kernel/signal.c
===================================================================
--- work.orig/kernel/signal.c
+++ work/kernel/signal.c
@@ -1694,6 +1694,17 @@ static int sigkill_pending(struct task_s
 }
 
 /*
+ * Test whether the target task of the usual cldstop notification - the
+ * real_parent of the group_leader of @child - is in the same group as the
+ * ptracer.
+ */
+static bool real_parent_is_ptracer(struct task_struct *child)
+{
+	return same_thread_group(child->parent,
+				 child->group_leader->real_parent);
+}
+
+/*
  * This must be called with current->sighand->siglock held.
  *
  * This should be the path for all ptrace stops.
@@ -1708,6 +1719,8 @@ static void ptrace_stop(int exit_code, i
 	__releases(&current->sighand->siglock)
 	__acquires(&current->sighand->siglock)
 {
+	bool gstop_done = false;
+
 	if (arch_ptrace_stop_needed(exit_code, info)) {
 		/*
 		 * The arch code has something special to do before a
@@ -1735,7 +1748,7 @@ static void ptrace_stop(int exit_code, i
 	 * is entered - ignore it.
 	 */
 	if (why == CLD_STOPPED && (current->group_stop & GROUP_STOP_PENDING))
-		task_participate_group_stop(current);
+		gstop_done = task_participate_group_stop(current);
 
 	current->last_siginfo = info;
 	current->exit_code = exit_code;
@@ -1757,7 +1770,20 @@ static void ptrace_stop(int exit_code, i
 	spin_unlock_irq(&current->sighand->siglock);
 	read_lock(&tasklist_lock);
 	if (may_ptrace_stop()) {
-		do_notify_parent_cldstop(current, task_ptrace(current), why);
+		/*
+		 * Notify parents of the stop.
+		 *
+		 * While ptraced, there are two parents - the ptracer and
+		 * the real_parent of the group_leader.  The ptracer should
+		 * know about every stop while the real parent is only
+		 * interested in the completion of group stop.  The states
+		 * for the two don't interact with each other.  Notify
+		 * separately unless they're gonna be duplicates.
+		 */
+		do_notify_parent_cldstop(current, true, why);
+		if (gstop_done && !real_parent_is_ptracer(current))
+			do_notify_parent_cldstop(current, false, why);
+
 		/*
 		 * Don't want to allow preemption here, because
 		 * sys_ptrace() needs this task to be inactive.
@@ -1772,7 +1798,16 @@ static void ptrace_stop(int exit_code, i
 		/*
 		 * By the time we got the lock, our tracer went away.
 		 * Don't drop the lock yet, another tracer may come.
+		 *
+		 * If @gstop_done, the ptracer went away between group stop
+		 * completion and here.  During detach, it would have set
+		 * GROUP_STOP_PENDING on us and we'll re-enter TASK_STOPPED
+		 * in do_signal_stop() on return, so notifying the real
+		 * parent of the group stop completion is enough.
 		 */
+		if (gstop_done)
+			do_notify_parent_cldstop(current, false, why);
+
 		__set_current_state(TASK_RUNNING);
 		if (clear_code)
 			current->exit_code = 0;
@@ -2017,10 +2052,24 @@ relock:
 
 		spin_unlock_irq(&sighand->siglock);
 
+		/*
+		 * Notify the parent that we're continuing.  This event is
+		 * always per-process and doesn't make whole lot of sense
+		 * for ptracers, who shouldn't consume the state via
+		 * wait(2) either, but, for backward compatibility, notify
+		 * the ptracer of the group leader too unless it's gonna be
+		 * a duplicate.
+		 */
 		read_lock(&tasklist_lock);
+
+		do_notify_parent_cldstop(current, false, why);
+
 		leader = current->group_leader;
-		do_notify_parent_cldstop(leader, task_ptrace(leader), why);
+		if (task_ptrace(leader) && !real_parent_is_ptracer(leader))
+			do_notify_parent_cldstop(leader, true, why);
+
 		read_unlock(&tasklist_lock);
+
 		goto relock;
 	}
 
