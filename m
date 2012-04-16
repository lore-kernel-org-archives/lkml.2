Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab2DPQG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:06:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2DPQG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:06:26 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=JomeGkWH5N8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Ug0_pOaCpn2EX9nnvT8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334592379.28106.4.camel@gandalf.stny.rr.com>
Subject: Re: [sched/rt] Optimization of function pull_rt_task()
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Mon, 16 Apr 2012 12:06:19 -0400
In-Reply-To: <1334519122.8698.3.camel@hp>
References: <1334519122.8698.3.camel@hp>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-15 at 23:45 +0400, Kirill Tkhai wrote:
> The condition (src_rq->rt.rt_nr_running) is weak because it doesn't
> consider the cases when src_rq has only processes bound to it (when
> single cpu is allowed). It may be running kernel thread like
> migration/x etc.
> 
> So it's better to use more stronger condition which is able to exclude
> above conditions. The function has_pushable_tasks() complitely does
> this. A task may be pullable for another cpu rq only if he is pushable
> for his own queue.

I considered this before, and for some reason I never did the change.
I'll have to think about it. It seems like this would be the obvious
case, but I think there was something not so obvious that caused issues.
But I don't remember what it was.

I'll have to rethink this again.

Thanks,

-- Steve

> 
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> ---
>  kernel/sched/rt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index c5565c3..61e3086 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1729,7 +1729,7 @@ static int pull_rt_task(struct rq *this_rq)
>  		/*
>  		 * Are there still pullable RT tasks?
>  		 */
> -		if (src_rq->rt.rt_nr_running <= 1)
> +		if (!has_pushable_tasks(src_rq))
>  			goto skip;
>  
>  		p = pick_next_highest_task_rt(src_rq, this_cpu);
> 


