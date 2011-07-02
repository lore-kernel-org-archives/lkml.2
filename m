Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1GBCSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 22:18:41 -0400
Received: from lo.gmane.org ([80.91.229.12]:38950 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab1GBCSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 22:18:40 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Subject: Re: [PATCH] sched: Check nr_running before calling pick_next_task
 in schedule().
Date: Fri, 01 Jul 2011 19:18:26 -0700
Message-ID: <4E0E7FF2.5030209@google.com>
References: <1309545711.4303.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: 216-239-45-4.google.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
In-Reply-To: <1309545711.4303.2.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rakib,

This doesn't strike me as a very good trade.

It adds a branch to the case where we actually have work to save 
branches in the case when we're idle anyway?

- Paul

On 07/01/11 11:41, Rakib Mullick wrote:
> Currently at schedule(), when we call pick_next_task we don't check whether current rq is empty or not. Since idle_balance can fail,
> its nice to check whether we really have any task on rq or not. If not, we can call idle_sched_class.pick_next_task straight.
>
> Signed-off-by: Rakib Mullick<rakib.mullick@gmail.com>
> ---
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 5925275..a4f4f58 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4273,7 +4273,14 @@ need_resched:
>   		idle_balance(cpu, rq);
>
>   	put_prev_task(rq, prev);
> -	next = pick_next_task(rq);
> +	/*  Since idle_balance can fail, its better to check rq->nr_running.
> +	 *  Otherwise we can call idle_sched_class.pick_next_task straight,
> +	 *  cause we need to do some accounting.
> +	 */
> +	if (likely(rq->nr_running))
> +		next = pick_next_task(rq);
> +	else
> +		next = idle_sched_class.pick_next_task(rq);
>   	clear_tsk_need_resched(prev);
>   	rq->skip_clock_update = 0;
>
>
>


