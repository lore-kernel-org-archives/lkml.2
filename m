Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2IUObe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:31:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30436 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2IUObd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:31:33 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5WSPnbb9cAwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=AUEDurwouHgA:10 a=vaJtXVxTAAAA:8 a=VCSZUmDIaYXwlS4j3wQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348237890.13080.72.camel@gandalf.local.home>
Subject: Re: [PATCH]sched/rt.c: leaf_rt_rq_list contains empty queues. Fix it
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Date: Fri, 21 Sep 2012 10:31:30 -0400
In-Reply-To: <668281348234555@web30d.yandex.ru>
References: <668281348234555@web30d.yandex.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 17:35 +0400, Kirill Tkhai wrote:
> Function __enqueue_rt_entity() adds an empty queue to leaf_rt_rq_list.
> 
> So, pick_next_highest_task_rt() picks empty queues. Fix it.

Do you have an example where this breaks?

> 
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> ---
>  kernel/sched/rt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 944cb68..b07edb9 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1103,7 +1103,7 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
>  	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
>  		return;
>  
> -	if (!rt_rq->rt_nr_running)
> +	if (rt_rq->rt_nr_running)
>  		list_add_leaf_rt_rq(rt_rq);

Note, the list_add_leaf_rt_rq() is called when the first task is queued
up. The function here is __enqueue_rt_entity(), which will increment
rt_rq->rt_nr_running. If this is the first entry we add the queue now,
as the __dequeue_rt_entity() does the list_del_leaf_rt_rq() when it goes
to zero.

-- Steve

>  
>  	if (head)


