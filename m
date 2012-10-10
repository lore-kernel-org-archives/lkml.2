Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2JJRtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:49:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab2JJRtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:49:20 -0400
Date: Wed, 10 Oct 2012 19:50:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH V2] task_work: avoid unneeded cmpxchg() in
	task_work_run()
Message-ID: <20121010175032.GA22642@redhat.com>
References: <50729A78.9090601@cn.fujitsu.com> <20121008123815.GA847@redhat.com> <1349780697.7880.14.camel@twins> <5075098E.9090808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5075098E.9090808@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10, Lai Jiangshan wrote:
>
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -52,16 +52,7 @@ void task_work_run(void)
>  	struct callback_head *work, *head, *next;
>
>  	for (;;) {
> -		/*
> -		 * work->func() can do task_work_add(), do not set
> -		 * work_exited unless the list is empty.
> -		 */
> -		do {
> -			work = ACCESS_ONCE(task->task_works);
> -			head = !work && (task->flags & PF_EXITING) ?
> -				&work_exited : NULL;
> -		} while (cmpxchg(&task->task_works, work, head) != work);
> -
> +		work = xchg(&task->task_works, NULL);
>  		if (!work)
>  			break;
>  		/*
> @@ -90,3 +81,17 @@ void task_work_run(void)
>  		} while (work);
>  	}
>  }
> +
> +void exit_task_work(struct task_struct *task)
> +{
> +	for (;;) {
> +		/*
> +		 * work->func() can do task_work_add(), do not set
> +		 * work_exited unless the list is empty.
> +		 */
> +		if (unlikely(task->task_works))
> +			task_work_run();
> +		if (cmpxchg(&task->task_works, NULL, &work_exited) == NULL)
> +			break;
> +	}
> +}

I agree, this looks fine.

But if you add "unlikely" before task_work_run(), then probably
it should do

	while (cmpxchg(&task->task_works, NULL, work_exited))
		task_work_run();

? it looks more simple/clean.

(OTOH I am not sure "unlikely" is true, note that exit_files() will
 offload ____fput() to task_work_run()).

But you did not answer, and I am curious. What was your original
motivation? Is xchg really faster than cmpxchg?

Oleg.

