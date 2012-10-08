Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab2JHMg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:36:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2JHMgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:36:54 -0400
Date: Mon, 8 Oct 2012 14:38:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] task_work: avoid unneeded cmpxchg() in task_work_run()
Message-ID: <20121008123815.GA847@redhat.com>
References: <50729A78.9090601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50729A78.9090601@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08, Lai Jiangshan wrote:
>
> We only require cmpxchg()&retry when task is exiting.
> xchg() is enough in other cases like original code in ac3d0da8.

Yes, we can probably do xchg/cmpxchg depending on NULL/work_exited.

Not sure it makes sense to complicate the code though. Is xchg()
really faster than cmpxchg?

> Also remove the inner loop

Yes, it is not really needed, only for readability.
"do while (!cmpxchg)" can be replaced with "if (!cmpxchg) continue".

> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -56,14 +56,13 @@ void task_work_run(void)
>  		 * work->func() can do task_work_add(), do not set
>  		 * work_exited unless the list is empty.
>  		 */
> -		do {
> -			work = ACCESS_ONCE(task->task_works);
> -			head = !work && (task->flags & PF_EXITING) ?
> -				&work_exited : NULL;
> -		} while (cmpxchg(&task->task_works, work, head) != work);
> -
> -		if (!work)
> +		if (!ACCESS_ONCE(task->task_works) ||

ACCESS_ONCE() looks confusing. It is not needed with this patch.

> +		    !(work = xchg(&task->task_works, NULL))) {
> +			if ((task->flags & PF_EXITING) &&
> +			    cmpxchg(&task->task_works, NULL, &work_exited))
> +				continue;
>  			break;
> +		}

I think the patch is correct.

But the code looks more complex, and the only advantage is that
non-exiting task does xchg() instead of cmpxchg(). Not sure this
worth the trouble, in this case task_work_run() will likey run
the callbacks (the caller checks ->task_works != NULL), I do not
think this can add any noticeable speedup.

But, as for correctness,
Reviewed-by: Oleg Nesterov <oleg@redhat.com>

