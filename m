Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143Ab2IFB0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 21:26:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:22544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab2IFB0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 21:26:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,377,1344182400"; 
   d="scan'208";a="5791292"
Message-ID: <5047FC43.2020706@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 09:28:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11 V5] workqueue: async idle rebinding
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com> <1346841475-4422-3-git-send-email-laijs@cn.fujitsu.com> <20120905180623.GA13737@google.com>
In-Reply-To: <20120905180623.GA13737@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 09:26:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 09:26:24,
	Serialize complete at 2012/09/06 09:26:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 02:06 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> Ooh, I like the approach.  That said, I think it's a bit too invasive
> for 3.6-fixes.  I'll merge the two patches I posted yesterday in
> 3.6-fixes.  Let's do this restructuring in for-3.7.

OK for me.
it is too complicated for 3.6.

> 
> On Wed, Sep 05, 2012 at 06:37:39PM +0800, Lai Jiangshan wrote:
>>  static void idle_worker_rebind(struct worker *worker)
>>  {
>>  	struct global_cwq *gcwq = worker->pool->gcwq;
>>  
>> -	/* CPU must be online at this point */
>> -	WARN_ON(!worker_maybe_bind_and_lock(worker));
>> -	if (!--worker->idle_rebind->cnt)
>> -		complete(&worker->idle_rebind->done);
>> -	spin_unlock_irq(&worker->pool->gcwq->lock);
>> +	if (worker_maybe_bind_and_lock(worker))
>> +		worker_clr_flags(worker, WORKER_UNBOUND);
>>  
>> -	/* we did our part, wait for rebind_workers() to finish up */
>> -	wait_event(gcwq->rebind_hold, !(worker->flags & WORKER_REBIND));
>> +	worker_clr_flags(worker, WORKER_REBIND);
>> +	list_add(&worker->entry, &worker->pool->idle_list);
>> +	spin_unlock_irq(&gcwq->lock);
> 
> This looks correct to me but it's still a bit scary.  Some comments
> explaining why the above is correct would be nice.

How to explain the correct, could you give some clues.
correctness for rebinding and the flags: comments is missing. (old code miss it too, so I forgot it)
correctness for idle management: list_del_init() and list_add(), I don't like to add comment for slef-explain-code.
correctness for quick-enabled-CMWQ, local-wake-up: comments is in the changelog. (I should also add it to the code)
correctness for integrating of above: ..

> 
> Yeah, other than that, looks good to me.  I'll prepare new for-3.7
> branch this can be based on, so please wait a bit.  Also, I think I'll
> probably update commit description / comments while committing.
> 

I was coding it based on wq/for-3.7. so you can merge it easier.
waiting for you merged-result.

Thanks.
Lai

