Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab1IZIJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:09:43 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:52410 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855Ab1IZIJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:09:42 -0400
Subject: Re: [PATCH for 3.1] ptrace: PTRACE_LISTEN forgets to unlock
 ->siglock
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110925174622.GA18509@redhat.com>
References: <20110925174622.GA18509@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 09:09:11 +0100
Message-ID: <1317024551.3649.0.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-25 at 19:46 +0200, Oleg Nesterov wrote:
> If PTRACE_LISTEN fails after lock_task_sighand() it doesn't drop ->siglock.
> 
> Reported-by: Matt Fleming <matt.fleming@intel.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  kernel/ptrace.c |   23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> --- 3.1/kernel/ptrace.c~1_PTRACE_LISTEN_siglock	2011-09-25 19:14:32.000000000 +0200
> +++ 3.1/kernel/ptrace.c	2011-09-25 19:40:57.000000000 +0200
> @@ -744,20 +744,17 @@ int ptrace_request(struct task_struct *c
>  			break;
>  
>  		si = child->last_siginfo;
> -		if (unlikely(!si || si->si_code >> 8 != PTRACE_EVENT_STOP))
> -			break;
> -
> -		child->jobctl |= JOBCTL_LISTENING;
> -
> -		/*
> -		 * If NOTIFY is set, it means event happened between start
> -		 * of this trap and now.  Trigger re-trap immediately.
> -		 */
> -		if (child->jobctl & JOBCTL_TRAP_NOTIFY)
> -			signal_wake_up(child, true);
> -
> +		if (likely(si && (si->si_code >> 8) == PTRACE_EVENT_STOP)) {
> +			child->jobctl |= JOBCTL_LISTENING;
> +			/*
> +			 * If NOTIFY is set, it means event happened between
> +			 * start of this trap and now.  Trigger re-trap.
> +			 */
> +			if (child->jobctl & JOBCTL_TRAP_NOTIFY)
> +				signal_wake_up(child, true);
> +			ret = 0;
> +		}
>  		unlock_task_sighand(child, &flags);
> -		ret = 0;
>  		break;
>  
>  	case PTRACE_DETACH:	 /* detach a process that was attached. */
> 

Thanks Oleg, looks good to me.

-- 
Matt Fleming, Intel Open Source Technology Center

