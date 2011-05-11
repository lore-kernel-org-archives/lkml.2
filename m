Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1EKUAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:00:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab1EKUAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:00:19 -0400
Date: Wed, 11 May 2011 21:58:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 11/11] ptrace: implement group stop notification for
	ptracer
Message-ID: <20110511195824.GA4047@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304869745-1073-12-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Tejun Heo wrote:
>
> +static void ptrace_trap_notify(struct task_struct *t)
> +{
> +	WARN_ON_ONCE(!(t->ptrace & PT_SEIZED));
> +	assert_spin_locked(&t->sighand->siglock);
> +
> +	/*
> +	 * @t is being ptraced and new SEIZE behavior is in effect.
> +	 * Schedule sticky trap which will clear on the next GETSIGINFO.
> +	 */
> +	t->jobctl |= JOBCTL_TRAP_NOTIFY;
> +
> +	/*
> +	 * If @t is currently trapped for group stop or INTERRUPT
> +	 * (JOBCTL_TRAPPED set), it should re-trap with new exit_code
> +	 * indicating continuation so that the ptracer can notice the
> +	 * event; otherwise, use normal signal delivery wake up.
> +	 *
> +	 * The re-trapping sets JOBCTL_TRAPPING such that the transition is
> +	 * hidden from the ptracer.
> +	 *
> +	 * This means that if @t is trapped for other reasons than group
> +	 * stop or INTERRUPT, the notification trap won't be delievered
> +	 * until the current one is complete.  This is the intended
> +	 * behavior.
> +	 */
> +	if (task_is_traced(t) && (t->jobctl & JOBCTL_TRAPPED)) {
> +		t->jobctl |= JOBCTL_TRAPPING;
> +		signal_wake_up(t, true);

and its tracer can be inside sys_ptrace().

No, I don't think this can be right. Otherwise, why ptrace_check_attach()
calls wait_task_inactive() ? The tracee can be scheduled but only if killed,
in this case we don't care.

I know very little about this low-level (and worse, arch dependant) magic,
but even on x86 this doesn't look safe. Suppose that the tracer changes the
fpu state of the tracer and __switch_to(next_p == tracee) does
__math_state_restore() before the tracer finishes.

Or PTRACE_GETSIGINFO can fail while it shouldn't, but this is minor.


Hmm. I think we need a bit more discussion, even ignoring the implementation
details.

Oleg.

