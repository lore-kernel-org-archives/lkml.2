Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1H3Pcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab1H3Pca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:32:30 -0400
Date: Tue, 30 Aug 2011 17:28:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ying Han <yinghan@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/2] oom: remove oom_disable_count
Message-ID: <20110830152856.GA22754@redhat.com>
References: <20110727175624.GA3950@redhat.com> <20110728154324.GA22864@redhat.com> <alpine.DEB.2.00.1107281341060.16093@chino.kir.corp.google.com> <20110729141431.GA3501@redhat.com> <20110730143426.GA6061@redhat.com> <20110730152238.GA17424@redhat.com> <4E369372.80105@jp.fujitsu.com> <20110829183743.GA15216@redhat.com> <alpine.DEB.2.00.1108291611070.32495@chino.kir.corp.google.com> <alpine.DEB.2.00.1108300040490.21066@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108300040490.21066@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30, David Rientjes wrote:
>
> This removes mm->oom_disable_count entirely since it's unnecessary and
> currently buggy.  The counter was intended to be per-process but it's
> currently decremented in the exit path for each thread that exits, causing
> it to underflow.
>
> The count was originally intended to prevent oom killing threads that
> share memory with threads that cannot be killed since it doesn't lead to
> future memory freeing.  The counter could be fixed to represent all
> threads sharing the same mm, but it's better to remove the count since:
>
>  - it is possible that the OOM_DISABLE thread sharing memory with the
>    victim is waiting on that thread to exit and will actually cause
>    future memory freeing, and
>
>  - there is no guarantee that a thread is disabled from oom killing just
>    because another thread sharing its mm is oom disabled.

Great, thanks.

Even _if_ (I hope not) we decide to re-introduce this counter later,
I think it will be much more simple to start from the very beginning
and make the correct patch.

> @@ -447,6 +431,9 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
>  	for_each_process(q)
>  		if (q->mm == mm && !same_thread_group(q, p) &&
>  		    !(q->flags & PF_KTHREAD)) {

(I guess this is on top of -mm patch)

> +			if (q->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
> +				continue;
> +

Afaics, this is the only change apart from "removes mm->oom_disable_count
entirely", looks reasonable to me.

Oleg.

