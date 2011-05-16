Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab1EPMNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:13:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab1EPMM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:12:59 -0400
Date: Mon, 16 May 2011 14:11:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH UPDATED 8/9] ptrace: move JOBCTL_TRAPPING wait to
	wait(2) and ptrace_check_attach()
Message-ID: <20110516121142.GC4898@redhat.com>
References: <1305301580-9924-1-git-send-email-tj@kernel.org> <1305301580-9924-9-git-send-email-tj@kernel.org> <20110514142230.GD23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110514142230.GD23665@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14, Tejun Heo wrote:
>
> @@ -1409,15 +1409,29 @@ static int wait_task_stopped(struct wait
>  	if (!ptrace && !(wo->wo_flags & WUNTRACED))
>  		return 0;
>
> -	if (!task_stopped_code(p, ptrace))
> +	/*
> +	 * For ptrace waits, we can't reliably check whether wait condition
> +	 * exists without grabbing siglock due to JOBCTL_TRAPPING
> +	 * transitions.  A task might be temporarily in TASK_RUNNING while
> +	 * trapping which should be transparent to the ptracer.
> +	 *
> +	 * Note that we can avoid unconditionally grabbing siglock by
> +	 * wrapping TRAPPING test with two rmb's; however, let's stick with
> +	 * simpler implementation for now.
> +	 */
> +	if (!ptrace && !(p->signal->flags & SIGNAL_STOP_STOPPED))
>  		return 0;
>
>  	exit_code = 0;
>  	spin_lock_irq(&p->sighand->siglock);
>
>  	p_code = task_stopped_code(p, ptrace);
> -	if (unlikely(!p_code))
> +	if (unlikely(!p_code)) {
> +		/* if trapping, wait for it and restart the whole process */
> +		if (ptrace && ptrace_wait_trapping(p))
> +			return restart_syscall();

Hmm. I didn't even know we have restart_syscall()... It is a bit fragile,
it assumes recalc_sigpending() is not possible during return from syscall.
In particular this means recalc_sigpending() must not be called in irq.
OK, this seems to be true.

Anyway, restart_syscall() is not right for do_wait(), especially with the
next patch. If the caller was woken by the real signal which has a handler,
we should not restart without SA_RESTART.


It is very hard to review this series. Without the further changes, it is
not clear why do we need these preparations. IIUC, ptrace_wait_trapping()
is only needed because we are going to re-trap. Otherwise we could always
wait in ptrace_attach() afaics.

I am still worried we are loosing the tight control over JOBCTL_TRAPPING.
6/9 contributes to this too.

Oleg.

