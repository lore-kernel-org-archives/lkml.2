Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1EHOoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 10:44:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55000 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab1EHOo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 10:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HmpzgDWtUeTGDrSAkdzWMq7Jo5wisDcsUs+t94eB1OjwKNza1bBgToUNl0EXU1dwft
         HcSu2pJXhqY+bsEPZZsSAnG96hNk59NMvxzzavrtWiTujqCS5ek26oBB2sEHPGY3RfHi
         Q8nHIVq5i7kpNrxW0cJCrespIpchli2tV+oHQ=
Date: Sun, 8 May 2011 16:44:24 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH ptrace] ptrace: use GROUP_STOP_TRAPPING for PTRACE_DETACH
 too
Message-ID: <20110508144424.GB29783@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently GROUP_STOP_TRAPPING is used only for PTRACE_ATTACH to hide
STOPPED -> RUNNING -> TRACED transition; however, DETACH involves
similar transition in the reverse direction, which can be visible to
the next ptracer if it attaches before the transition is complete.

This patch makes DETACH also use TRAPPING and ptrace_attach() always
wait if TRAPPING is set to hide the transition.

Test program follows.

  int main(int argc, char **argv)
  {
	  pid_t tracee;
	  siginfo_t si = {};
	  int i, nr_wait_fails = 0, nr_ptrace_fails = 0;

	  tracee = fork();
	  if (!tracee)
		  while (1)
			  pause();

	  kill(tracee, SIGSTOP);
	  waitid(P_PID, tracee, NULL, WSTOPPED | WNOWAIT);

	  for (i = 0; i < 100000; i++) {
		  ptrace(PTRACE_ATTACH, tracee, NULL, NULL);
		  waitid(P_PID, tracee, &si, WSTOPPED | WNOHANG);
		  if (!si.si_pid)
			  nr_wait_fails++;
		  if (ptrace(PTRACE_DETACH, tracee, NULL, NULL)) {
			  nr_ptrace_fails++;
			  waitid(P_PID, tracee, NULL, WSTOPPED);
			  ptrace(PTRACE_DETACH, tracee, NULL, NULL);
		  }
	  }
	  printf("wait/ptrace failed %d/%d times out of %d tries\n",
		 nr_wait_fails, nr_ptrace_fails, i);
	  return 0;
  }

Before the patch, transition from DETACH causes sporadic failures on
waitid(2) and ptrace(2) calls after re-attaching.

  # ./test-trapping-race
  wait/ptrace failed 453/449 times out of 100000 tries

After, PTRACE_ATTACH waits for the previous transitions to complete
too and they don't fail.

  # ./test-trapping-race-simple 
  wait/ptrace failed 0/0 times out of 100000 tries

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/ptrace.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: work/kernel/ptrace.c
===================================================================
--- work.orig/kernel/ptrace.c
+++ work/kernel/ptrace.c
@@ -77,12 +77,15 @@ void __ptrace_unlink(struct task_struct
 
 	/*
 	 * Reinstate GROUP_STOP_PENDING if group stop is in effect and
-	 * @child isn't dead.
+	 * @child isn't dead.  This will trigger TRACED -> RUNNING ->
+	 * STOPPED transition.  As this transition can affect the next
+	 * ptracer if it attaches before the transition completes, set
+	 * TRAPPING too.  Read comment in ptrace_attach() for more details.
 	 */
 	if (!(child->flags & PF_EXITING) &&
 	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
 	     child->signal->group_stop_count))
-		child->group_stop |= GROUP_STOP_PENDING;
+		child->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
 
 	/*
 	 * If transition to TASK_STOPPED is pending or in TASK_TRACED, kick
@@ -183,7 +186,6 @@ bool ptrace_may_access(struct task_struc
 
 static int ptrace_attach(struct task_struct *task)
 {
-	bool wait_trap = false;
 	int retval;
 
 	audit_ptrace(task);
@@ -245,7 +247,6 @@ static int ptrace_attach(struct task_str
 	if (task_is_stopped(task)) {
 		task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
 		signal_wake_up(task, 1);
-		wait_trap = true;
 	}
 
 	spin_unlock(&task->sighand->siglock);
@@ -256,9 +257,8 @@ unlock_tasklist:
 unlock_creds:
 	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
-	if (wait_trap)
-		wait_event(current->signal->wait_chldexit,
-			   !(task->group_stop & GROUP_STOP_TRAPPING));
+	wait_event(current->signal->wait_chldexit,
+		   !(task->group_stop & GROUP_STOP_TRAPPING));
 	return retval;
 }
 
