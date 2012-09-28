Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2I1Jtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:49:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:22586 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab2I1Jts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:49:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,501,1344182400"; 
   d="scan'208";a="5934170"
Message-ID: <50657342.6000008@cn.fujitsu.com>
Date: Fri, 28 Sep 2012 17:52:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] workqueue: simplify is_chained_work()
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com> <1348680043-5077-5-git-send-email-laijs@cn.fujitsu.com> <20120926182837.GE12544@google.com>
In-Reply-To: <20120926182837.GE12544@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 17:49:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 17:49:56,
	Serialize complete at 2012/09/28 17:49:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 02:28 AM, Tejun Heo wrote:
> On Thu, Sep 27, 2012 at 01:20:35AM +0800, Lai Jiangshan wrote:
>> is_chained_work() is too complicated. we can simply found out
>> whether current task is worker by PF_WQ_WORKER or wq->rescuer.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>>  kernel/workqueue.c |   36 ++++++++++++------------------------
>>  1 files changed, 12 insertions(+), 24 deletions(-)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index e41c562..c718b94 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -1182,34 +1182,22 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
>>  
>>  /*
>>   * Test whether @work is being queued from another work executing on the
>> - * same workqueue.  This is rather expensive and should only be used from
>> - * cold paths.
>> + * same workqueue.
>>   */
>>  static bool is_chained_work(struct workqueue_struct *wq)
>>  {
>> -	unsigned long flags;
>> -	unsigned int cpu;
>> +	struct worker *worker = NULL;
>>  
>> -	for_each_gcwq_cpu(cpu) {
>> -		struct global_cwq *gcwq = get_gcwq(cpu);
>> -		struct worker *worker;
>> -		struct hlist_node *pos;
>> -		int i;
>> +	if (wq->rescuer && current == wq->rescuer->task) /* rescuer_thread() */
>> +		worker = wq->rescuer;
>> +	else if (current->flags & PF_WQ_WORKER) /* worker_thread() */
>> +		worker = kthread_data(current);
>>  
>> -		spin_lock_irqsave(&gcwq->lock, flags);
>> -		for_each_busy_worker(worker, i, pos, gcwq) {
>> -			if (worker->task != current)
>> -				continue;
>> -			spin_unlock_irqrestore(&gcwq->lock, flags);
>> -			/*
>> -			 * I'm @worker, no locking necessary.  See if @work
>> -			 * is headed to the same workqueue.
>> -			 */
>> -			return worker->current_cwq->wq == wq;
>> -		}
>> -		spin_unlock_irqrestore(&gcwq->lock, flags);
>> -	}
>> -	return false;
>> +	/*
>> +	 * I'm @worker, no locking necessary.  See if @work
>> +	 * is headed to the same workqueue.
>> +	 */
>> +	return worker && worker->current_cwq->wq == wq;

	if current is a worker and ...

> 
> How about,
> 
> 	if (wq->rescuer && current == wq->rescuer->task)
> 		worker = wq->rescuer;
> 	else if (current->flags & PF_WQ_WORKER)
> 		worker = kthread_data(current);
> 	else
> 		return NULL;
> 
> 	return worker->curent_cwq->wq == wq;
> 

Hi, Tejun

Your code is good, but I don't think I need to resend(and use your code).

Main reason: I think the readability of your is the same as mine,
and your add two lines.

Tiny reason: my code uses only one return. (I don't always keep one return,
but I try to keep it if it is still clean)

Is there any other reason to change it?

Thanks,
Lai.
