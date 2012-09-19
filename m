Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2ISJzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 05:55:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15142 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab2ISJzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 05:55:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,448,1344182400"; 
   d="scan'208";a="5871509"
Message-ID: <505996F8.1020506@cn.fujitsu.com>
Date: Wed, 19 Sep 2012 17:57:12 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] workqueue: Keep activate-order equals to queue_work()-order
References: <1347957414-6692-1-git-send-email-laijs@cn.fujitsu.com> <1347957414-6692-2-git-send-email-laijs@cn.fujitsu.com> <20120918170519.GB8474@google.com>
In-Reply-To: <20120918170519.GB8474@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/19 17:55:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/19 17:55:22,
	Serialize complete at 2012/09/19 17:55:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 01:05 AM, Tejun Heo wrote:
> On Tue, Sep 18, 2012 at 04:36:53PM +0800, Lai Jiangshan wrote:
>> The whole workqueue.c keeps activate-order equals to queue_work()-order
>> in any given cwq except workqueue_set_max_active().
>>
>> If this order is not kept, something may be not good:
>>
>> first_work_fn() { release some resource; }
>> second_work_fn() { wait and request the resource; use resource; }
>>
>> 1. user queues the first work.	# ->max_active is low, is queued on ->delayed_works.
>> 2. someone increases the >max_active via workqueue_set_max_active()
>> 3. user queues the second work.	# queued on cwq->pool.
>>
>> When the second work is launched to execute, it waits the first work
>> to release the resource. But the first work is still in ->delayed_works,
>> it waits the first work to finish and them it can be activated.
>>
>> It is bad. we fix it by activating the first work in the step 2.
>>
>> I can't fully determine that it is workqueue's responsibility
>> or the user's responsibility.
>> If it is workqueue's responsibility, the patch needs go to -stable.
>> If it is user's responsibility. it is a nice cleanup, it can go to for-next.
>> I prefer it is workqueue's responsibility.
> 
> Unless max_active == 1, workqueue doesn't give any guarantee on
> execution order.  I don't think we need to care about this.
> 
> 

(disorder of execution is OK for current WQ. because we can launch new worker
to execute the next work if the previous one is waiting something)

But I concern activate-order, not execution order. A non-delayed work
may delay a delayed work for ever, and if a non-delayed work needs something
which will be produced by delayed one, the two work may wait each other.

{
a subsystem queues a work to release resource.
and them
a subsystem queues a work to use the resource.
}
Is this behavior acceptable?

If this is acceptable, and if the first queued work go to ->delayed_works,
and a userspace user issues workqueue_set_max_active() via sysctl
before the second queuing. thus the second queued work will be activated
immediately. since the second work is activated,
the first work can't be activated before the first work finished.
thus the two work may wait each other.


All of this is abnormal thought. and it is not a real problem, merging them
as cleanup is enough.

Thanks,
Lai
