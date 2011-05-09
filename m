Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1EIQU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:20:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab1EIQUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:20:25 -0400
Date: Mon, 9 May 2011 18:18:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 02/11] ptrace: implement PTRACE_SEIZE
Message-ID: <20110509161838.GA27473@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304869745-1073-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Tejun Heo wrote:
>
> After PTRACE_SEIZE, tracee will trap.  Which trap will happen isn't
> fixed.  If other trap conditions exist (signal delivery or group
> stop), they might be taken; otherwise, a trap with exit_code SIGTRAP |
> (PTRACE_EVENT_INTERRUPT << 8) is taken.
> guaranteed.

Personally, I think the new behaviour is fine. But, as usual, I'd like
to know what Jan/Denys think.


As for the implementation,

> -static int ptrace_attach(struct task_struct *task)
> +static int ptrace_attach(struct task_struct *task, long request,
> +			 unsigned long flags)
>  {
> +	bool seize = request == PTRACE_SEIZE;

Cough. I really hate the cosmetic nits but can't resist...

	bool seize = (request == PTRACE_SEIZE);

looks more parseable, but feel free to ignore.

> @@ -247,6 +272,14 @@ static int ptrace_attach(struct task_struct *task)
>  	if (task_is_stopped(task)) {
>  		task->jobctl |= JOBCTL_STOP_PENDING | JOBCTL_TRAPPING;
>  		signal_wake_up(task, 1);
> +	} else if (seize) {
> +		/*
> +		 * Otherwise, SEIZE uses jobctl trap to put tracee into
> +		 * TASK_TRACED, which doesn't have the nasty side effects
> +		 * of sending SIGSTOP.
> +		 */
> +		task->jobctl |= JOBCTL_TRAP_SEIZE;
> +		signal_wake_up(task, 0);

OK... I am a bit worried we can set JOBCTL_TRAP_SEIZE even if the tracee
was already killed, and if it is killed later JOBCTL_TRAP_SEIZE won't be
cleared. Probably this is fine, ptrace_stop()->schedule() won't sleep in
this case.

Hmm. but see below.

> @@ -1752,12 +1752,13 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
>  	set_current_state(TASK_TRACED);
>
>  	/*
> -	 * We're committing to trapping.  Clearing JOBCTL_TRAPPING and
> -	 * transition to TASK_TRACED should be atomic with respect to
> -	 * siglock.  This should be done after the arch hook as siglock is
> -	 * released and regrabbed across it.
> +	 * We're committing to trapping.  Adjust ->jobctl.  Updates to
> +	 * these flags and transition to TASK_TRACED should be atomic with
> +	 * respect to siglock.  This should be done after the arch hook as
> +	 * siglock may be released and regrabbed across it.
>  	 */
>  	task_clear_jobctl_trapping(current);
> +	current->jobctl &= ~JOBCTL_TRAP_SEIZE;

Yes. But, it seems, this is too late.

Suppose that the JOBCTL_TRAP_SEIZE tracee was SIGKILLED before it reports
PTRACE_EVENT_INTERRUPT. Now, if arch_ptrace_stop_needed() == T, ptrace_stop()
returns without clearing JOBCTL_TRAP_SEIZE/TIF_SIGPENDING. This means
get_signal_to_deliver() will loop forever.

I never understood why ptrace_stop()->sigkill_pending() logic, I think
we should check fatal_signal_pending() unconditionally. Oh, and we have
other subtle issues here.

>  	for (;;) {
>  		struct k_sigaction *ka;
> +
> +		/*
> +		 * Check for ptrace trap conditions.  Jobctl traps are used
> +		 * to trap ptracee while staying transparent regarding
> +		 * signal and job control.
> +		 */
> +		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
> +			ptrace_notify_locked(SIGTRAP |
> +					     (PTRACE_EVENT_INTERRUPT << 8));
> +			continue;

Shouldn't we recheck SIGNAL_CLD_MASK after ptrace_notify_locked() returns?
Probably not, but I am not sure...

In any case. This doesn't really matter, but can't we check JOBCTL_TRAP_MASK
outside of the main loop? Unless we drop ->siglock this bit can't be changed,
and every time we drop ->siglock we go to "relock".

Oleg.

