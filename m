Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab1EKPuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496Ab1EKPuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:50:15 -0400
Date: Wed, 11 May 2011 17:48:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 08/11] ptrace: move fallback JOBCTL_TRAPPING clearing
	to get_signal_to_deliver()
Message-ID: <20110511154834.GA23688@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304869745-1073-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Tejun Heo wrote:
>
> Move the fallback clearing to the end of get_signal_to_deliver() so
> that TRAPPING is maintained while tracee is inside signal delivery
> path.  When killed, tracee is guaranteed to leave signal delivery path
> in finite amount of time and thus TRAPPING is still guaranteed to be
> cleared on kill.

Mostly yes, but we can race with freeze_processes() and deadlock.

> @@ -1978,9 +1981,6 @@ retry:
>  		goto retry;
>  	}
>
> -	/* PTRACE_ATTACH might have raced with task killing, clear trapping */
> -	task_clear_jobctl_trapping(current);
> -
>  	spin_unlock_irq(&current->sighand->siglock);
>
>  	tracehook_finish_jctl();
> @@ -2226,6 +2226,13 @@ relock:
>  		do_group_exit(info->si_signo);
>  		/* NOTREACHED */
>  	}
> +
> +	/*
> +	 * PTRACE_ATTACH might have raced with task killing.  Make sure
> +	 * trapping is clear before leaving signal delivery path.
> +	 */
> +	task_clear_jobctl_trapping(current);

before the tracee does this, it returns from do_signal_stop(), goes to
relock:, and calls try_to_freeze(). If it becomes frozen,
try_to_freeze_tasks() can't succeed because the tracer waits for
!JOBCTL_TRAPPING.

And. The main problem is that "leave signal delivery path" is not true
at all. When the tracee dequeues SIGKILL it calls do_group_exit() inside
the main loop.

So far this all looks easily fixeable though...

Oleg.

