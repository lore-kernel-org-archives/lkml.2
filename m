Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab0LTPGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:06:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab0LTPGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:06:36 -0500
Date: Mon, 20 Dec 2010 15:59:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 03/16] signal: remove superflous try_to_freeze() loop
	in do_signal_stop()
Message-ID: <20101220145937.GB11583@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Tejun Heo wrote:
>
> do_signal_stop() is used only by get_signal_to_deliver() and after a
> successful signal stop, it always calls try_to_freeze(), so the
> try_to_freeze() loop around schedule() in do_signal_stop() is
> superflous and confusing.  Remove it.

I think the patch is obvioulsy fine.

Acked-by: Oleg Nesterov <oleg@redhat.com>



But I am a bit confused, a couple of off-topic questions to Rafael.

> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1781,9 +1781,7 @@ static int do_signal_stop(int signr)
>  	}
>
>  	/* Now we don't run again until woken by SIGCONT or SIGKILL */
> -	do {
> -		schedule();
> -	} while (try_to_freeze());
> +	schedule();

I am wondering what was the purpose of this do/while loop. Probably
this was just oversight. We always return in TASK_RUNNING state from
schedule, try_to_freeze() should return the task in this state too.

My question is: refrigerator() tries to preserve the caller's state.
Why? I think it is just wrong to call refrigerator() unless the
task is TASK_RUNNING, no? If no, then the games with saving/restoring
->state look obviously racy/wrong.

Oleg.

