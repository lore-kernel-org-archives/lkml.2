Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1FPTyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:54:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758141Ab1FPTyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:54:02 -0400
Date: Thu, 16 Jun 2011 21:51:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCH 4/5] ptrace: implement TRAP_NOTIFY and use it for group
	stop events
Message-ID: <20110616195138.GB14786@redhat.com>
References: <1308043218-23619-1-git-send-email-tj@kernel.org> <1308043218-23619-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308043218-23619-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Tejun Heo wrote:
>
> When group stop state of a seized tracee changes, JOBCTL_TRAP_NOTIFY
> is set,

I already applied this series. But somehow I have the fuzzy feeling we
can simplify JOBCTL_TRAP_NOTIFY/JOBCTL_TRAP_STOP logic later. No, I can't
explain what I mean ;)

One question,

> @@ -1797,8 +1824,10 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
>  	if (why == CLD_STOPPED && (current->jobctl & JOBCTL_STOP_PENDING))
>  		gstop_done = task_participate_group_stop(current);
>
> -	/* any trap clears pending STOP trap */
> +	/* any trap clears pending STOP trap, STOP trap clears NOTIFY */
>  	task_clear_jobctl_pending(current, JOBCTL_TRAP_STOP);
> +	if (info && info->si_code >> 8 == PTRACE_EVENT_STOP)
> +		task_clear_jobctl_pending(current, JOBCTL_TRAP_NOTIFY);

OK, but can't we check why == CLD_STOPPED instead of PTRACE_EVENT_STOP?

In fact, can't we move all code above under 'if (why == CLD_STOPPED)' ?
JOBCTL_TRAP_STOP can't be set otherwise, no? I am almost sure I missed
something though.

Oleg.

