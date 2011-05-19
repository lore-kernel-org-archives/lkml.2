Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab1ESQeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:34:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933541Ab1ESQeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:34:03 -0400
Date: Thu, 19 May 2011 18:32:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for
	ptracer
Message-ID: <20110519163246.GF17265@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-11-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305569849-10448-11-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
> When group stop state of a seized tracee changes, JOBCTL_TRAP_NOTIFY
> is set, which triggers STOP trap but is sticky until the next
> PTRACE_GETSIGINFO.

I simply can't understand this patch. And the supposed API as it seen
by the user-space. I'll try to read it again and think more.

A couple of questions,

> +static void ptrace_trap_notify(struct task_struct *t)
> +{
> +	siginfo_t *si = t->last_siginfo;
> +
> +	WARN_ON_ONCE(!(t->ptrace & PT_SEIZED));
> +	assert_spin_locked(&t->sighand->siglock);
> +
> +	/*
> +	 * @t is being ptraced and new SEIZE behavior is in effect.
> +	 * Schedule sticky trap which will clear on the next GETSIGINFO.
> +	 */
> +	t->jobctl |= JOBCTL_TRAP_NOTIFY;

This is also set by do_signal_stop(). Cleared by PTRACE_GETSIGINFO.

How can this work? Doesn't this mean PTRACE_GETSIGINFO becomes mandatory
before PTRACE_CONT? IOW, unless the tracee does PTRACE_GETSIGINFO to clear
this bit, PTRACE_CONT just leads to another trap, no?

> +	if (task_is_traced(t) && si && si->si_code == PTRACE_STOP_SI_CODE) {

OK, this PTRACE_STOP_SI_CODE check is clear. But the same check in
ptrace_check_attach() looks confusing, why can't we set BLOCK_NOTIFY
unconditionally?

> +		t->jobctl |= JOBCTL_TRAPPING;
> +		if (!(t->jobctl & JOBCTL_BLOCK_NOTIFY))
> +			signal_wake_up(t, true);

Could you please remind me why we can't avoid the awful ptrace_wait_trapping()
in do_wait() paths? Assuming that ptrace_check_attach() does this. I got lost
a bit.

So. The tracee reports PTRACE_EVENT_STOP, debugger issues a lot of PTRACE_
requests. The tracee can report another trap "in between". Looks confusing...
Perhaps I need to get used to it.

Oleg.

