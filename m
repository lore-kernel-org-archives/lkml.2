Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2H2CAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 22:00:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52959 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab2H2CAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 22:00:36 -0400
X-IronPort-AV: E=Sophos;i="4.80,331,1344182400"; 
   d="scan'208";a="5742436"
Message-ID: <503D7822.9090205@cn.fujitsu.com>
Date: Wed, 29 Aug 2012 10:02:10 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 V2] workqueue: reimplement rebind_workers()
References: <1346153686-3380-1-git-send-email-laijs@cn.fujitsu.com> <20120828201725.GA24608@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120828201725.GA24608@dhcp-172-17-108-109.mtv.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/29 10:00:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/29 10:00:24,
	Serialize complete at 2012/08/29 10:00:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 04:17 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Tue, Aug 28, 2012 at 07:34:37PM +0800, Lai Jiangshan wrote:
>> So this implement adds an "all_done", thus rebind_workers() can't leave until
>> idle_worker_rebind() successful wait something until all other idle also done,
>> so this "wait something" will not cause deadlock as the old code.
>>
>> The code of "idle_worker_rebind() wait something until all other idle also done"
>> is also changed. It is changed to wait on "worker_rebind.idle_done". With
>> the help of "all_done" this "worker_rebind" is valid when they wait on
>> "worker_rebind.idle_done".
>>
>> The busy_worker_rebind_fn() also explicitly wait on all idle done. It adds
>> a small overhead on cold path, but it makes the rebind_workers() as single pass.
>> Clean Code/Readability wins.
>>
>> "all_cnt" 's decreasing is done without any lock, because this decreasing
>> only happens on the bound CPU, no lock needed. (the bound CPU can't go
>> until we notify on "all_done")
> 
> I really hope the fix and reimplementation are done in separate steps.
> All we need is an additional completion wait before leaving
> rebind_workers()(), so let's please just add that to fix the immediate
> bug.  If you think it can be further simplified by reimplmenting
> rebind_workers(), that's great but let's please do that as a separate
> step.
> 
> Also, I asked this previously but have you encounted this problem or
> is it only from code review?

I didn't notice your ask. I was off-office yesterday and I quickly looked
your replies and quickly code in a netbook.

This "problem" is from code review, I like randomly use "git log"
to show what has changed to the files that I'm interesting in.

I noticed that rebind_worker() is a little "ugly" and tried to make it as
single pass and found this possible problem.

If we have may high-priority task and do offline/online very high
frequently(use high-priority task do it), this problem may happen.

I will try it later.

> 
>>  static void idle_worker_rebind(struct worker *worker)
>>  {
>> -	struct global_cwq *gcwq = worker->pool->gcwq;
>> -
>>  	/* CPU must be online at this point */
>>  	WARN_ON(!worker_maybe_bind_and_lock(worker));
>> -	if (!--worker->idle_rebind->cnt)
>> -		complete(&worker->idle_rebind->done);
>> +	worker_clr_flags(worker, WORKER_REBIND);
>> +	if (!--worker->worker_rebind->idle_cnt)
>> +		complete_all(&worker->worker_rebind->idle_done);
>>  	spin_unlock_irq(&worker->pool->gcwq->lock);
>>  
>> -	/* we did our part, wait for rebind_workers() to finish up */
>> -	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
>> +	/* It did its part, wait for all other idle to finish up */
>> +	wait_for_completion(&worker->worker_rebind->idle_done);
>> +
>> +	/* all_cnt is only accessed by the bound CPU, don't need any lock */
>> +	if (!--worker->worker_rebind->all_cnt)
> 
> What if this worker gets preempted by another worker?  There's no
> point in this type of optimization in this path.  Let's please keep
> things straight-forward and robust.

OK, I was wrong.

> 
>>  static void busy_worker_rebind_fn(struct work_struct *work)
>>  {
>>  	struct worker *worker = container_of(work, struct worker, rebind_work);
>>  	struct global_cwq *gcwq = worker->pool->gcwq;
>>  
>> -	if (worker_maybe_bind_and_lock(worker))
>> -		worker_clr_flags(worker, WORKER_REBIND);
>> +	/* Wait for all idle to finish up */
>> +	wait_for_completion(&worker->worker_rebind->idle_done);
>>  
>> +	/* CPU must be online at this point */
>> +	WARN_ON(!worker_maybe_bind_and_lock(worker));
>> +	worker_clr_flags(worker, WORKER_REBIND);
>>  	spin_unlock_irq(&gcwq->lock);
>> +
>> +	/* all_cnt is only accessed by the bound CPU, don't need any lock */
>> +	if (!--worker->worker_rebind->all_cnt)
>> +		complete(&worker->worker_rebind->all_done);
> 
> You can't do this.  There is no guarantee that busy worker will
> execute busy_worker_rebind_fn() in definite amount of time.  A given
> work item may run indefinitely.

It can't wait the current running work item to finish and handle
rebind_work item. Do I get your meaning?

OK, I will drop this part.(I want to use a more simple implement to
fix the patch2/3 problem(or say patch 5/7 problem in V1), since the
fix in V1 is OK, It makes no sense to make rebind_workers() wait
busy_worker_rebind_fn())

Thanks
Lai
