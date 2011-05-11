Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab1EKPub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:50:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab1EKPuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:50:23 -0400
Date: Wed, 11 May 2011 17:48:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 09/11] job control: reorganize wait_task_stopped()
Message-ID: <20110511154854.GB23688@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304869745-1073-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Tejun Heo wrote:
>
> wait_task_stopped() tested task_stopped_code() without acquiring
> siglock and, if stop condition existed, called wait_task_stopped() and
> directly returned the result.
>
>   it may race against SIGCONT generation.

Hmm. This is the plain bug, even if unlikely and minor.

>   It seems that WNOHANG wait correctness has never been guaranteed and
>   everybody has been happy with it for very long time.

Yes, the window is tiny. May be it was never noticed or never
reported because this is hard to diagnose/reproduced.

> As such,
>   although this reorganization improves the situation a bit, I don't
>   consider this to be a bug fix.

But it is?

Can't we push this patch ahead of these changes? I can merge it into
ptrace branch.


>  static int wait_task_stopped(struct wait_opts *wo,
>  				int ptrace, struct task_struct *p)
> @@ -1397,6 +1409,9 @@ static int wait_task_stopped(struct wait_opts *wo,
>  	if (!ptrace && !(wo->wo_flags & WUNTRACED))
>  		return 0;
>
> +	if (!task_stopped_code(p, ptrace))
> +		return 0;
> +
>  	exit_code = 0;
>  	spin_lock_irq(&p->sighand->siglock);
>
> @@ -1607,8 +1622,9 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
>  	 * Wait for stopped.  Depending on @ptrace, different stopped state
>  	 * is used and the two don't interact with each other.
>  	 */
> -	if (task_stopped_code(p, ptrace))
> -		return wait_task_stopped(wo, ptrace, p);
> +	ret = wait_task_stopped(wo, ptrace, p);
> +	if (ret)
> +		return ret;

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

