Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1EHQIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 12:08:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800Ab1EHQIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 12:08:54 -0400
Date: Sun, 8 May 2011 18:07:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH ptrace] ptrace: use GROUP_STOP_TRAPPING for
	PTRACE_DETACH too
Message-ID: <20110508160720.GA11705@redhat.com>
References: <20110508144424.GB29783@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110508144424.GB29783@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Tejun Heo wrote:
>
> Currently GROUP_STOP_TRAPPING is used only for PTRACE_ATTACH to hide
> STOPPED -> RUNNING -> TRACED transition; however, DETACH involves
> similar transition in the reverse direction, which can be visible to
> the next ptracer if it attaches before the transition is complete.

Yes...

> This patch makes DETACH also use TRAPPING and ptrace_attach() always
> wait if TRAPPING is set to hide the transition.

I am not sure, please see below.

> Test program follows.
>
>   int main(int argc, char **argv)
>   {
> 	  pid_t tracee;
> 	  siginfo_t si = {};
> 	  int i, nr_wait_fails = 0, nr_ptrace_fails = 0;
>
> 	  tracee = fork();
> 	  if (!tracee)
> 		  while (1)
> 			  pause();
>
> 	  kill(tracee, SIGSTOP);
> 	  waitid(P_PID, tracee, NULL, WSTOPPED | WNOWAIT);
>
> 	  for (i = 0; i < 100000; i++) {
> 		  ptrace(PTRACE_ATTACH, tracee, NULL, NULL);
> 		  waitid(P_PID, tracee, &si, WSTOPPED | WNOHANG);
> 		  if (!si.si_pid)
> 			  nr_wait_fails++;

OK, this is clear, waitid(WSTOPPED | WNOHANG) can fail if it sees the
tracee inside the transition.

But,

> 		  if (ptrace(PTRACE_DETACH, tracee, NULL, NULL)) {
> 			  nr_ptrace_fails++;

I assume this can only fail for the same reason if waitid() fails?
Or there is something else?

> --- work.orig/kernel/ptrace.c
> +++ work/kernel/ptrace.c
> @@ -77,12 +77,15 @@ void __ptrace_unlink(struct task_struct
>
>  	/*
>  	 * Reinstate GROUP_STOP_PENDING if group stop is in effect and
> -	 * @child isn't dead.
> +	 * @child isn't dead.  This will trigger TRACED -> RUNNING ->
> +	 * STOPPED transition.  As this transition can affect the next
> +	 * ptracer if it attaches before the transition completes, set
> +	 * TRAPPING too.  Read comment in ptrace_attach() for more details.
>  	 */
>  	if (!(child->flags & PF_EXITING) &&
>  	    (child->signal->flags & SIGNAL_STOP_STOPPED ||
>  	     child->signal->group_stop_count))
> -		child->group_stop |= GROUP_STOP_PENDING;
> +		child->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;

This doesn't look safe, see below. We do not know what the tracee does,
it can be even running.

>  static int ptrace_attach(struct task_struct *task)
>  {
> -	bool wait_trap = false;
>  	int retval;
>
>  	audit_ptrace(task);
> @@ -245,7 +247,6 @@ static int ptrace_attach(struct task_str
>  	if (task_is_stopped(task)) {
>  		task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
>  		signal_wake_up(task, 1);
> -		wait_trap = true;
>  	}
>
>  	spin_unlock(&task->sighand->siglock);
> @@ -256,9 +257,8 @@ unlock_tasklist:
>  unlock_creds:
>  	mutex_unlock(&task->signal->cred_guard_mutex);
>  out:
> -	if (wait_trap)
> -		wait_event(current->signal->wait_chldexit,
> -			   !(task->group_stop & GROUP_STOP_TRAPPING));
> +	wait_event(current->signal->wait_chldexit,
> +		   !(task->group_stop & GROUP_STOP_TRAPPING));

Suppose that SIGCONT or, worse, SIGKILL comes in between.

Oleg.

