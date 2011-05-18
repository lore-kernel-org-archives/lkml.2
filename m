Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab1ERSTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:19:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932709Ab1ERSTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:19:53 -0400
Date: Wed, 18 May 2011 20:17:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110518181756.GA30250@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305569849-10448-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
> @@ -315,6 +338,9 @@ static int ptrace_attach(struct task_struct *task)
>  	if (task_is_stopped(task)) {
>  		task->jobctl |= JOBCTL_TRAP_STOP | JOBCTL_TRAPPING;
>  		signal_wake_up(task, 1);
> +	} else if (seize) {
> +		task->jobctl |= JOBCTL_TRAP_STOP;

So, this can race with do_signal_stop(), it can clear TRAP_STOP and
JOBCTL_STOP_PENDING can guarantee the tracee will trap later.

> +	 * When PT_SEIZED, it's used for both group stop and explicit
> +	 * SEIZE/INTERRUPT traps.  Both generate PTRACE_EVENT_STOP trap
> +	 * with accompanying siginfo.
> +	 *
> +	 * When !PT_SEIZED, it's used only for group stop trap with
> +	 * CLD_STOPPED as exit_code and no siginfo.
>  	 */
>  	if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
> -		signr = current->jobctl & JOBCTL_STOP_SIGMASK;
> -		WARN_ON_ONCE(!signr);
> -		ptrace_stop(signr, CLD_STOPPED, 0, NULL);
> -		current->exit_code = 0;
> +		if (current->ptrace & PT_SEIZED) {
> +			ptrace_do_notify(SIGTRAP | PTRACE_EVENT_STOP << 8,
> +					 CLD_STOPPED);

So. When PT_SEIZED, we always report PTRACE_EVENT_STOP and PTRACE_GET_SIGINFO
always works.

Personally I agree, this looks more clean and natural.

Oleg.

