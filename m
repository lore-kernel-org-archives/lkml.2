Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2IHRun (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:50:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38379 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab2IHRum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:50:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120908174044.GD10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
	<1347124383-18723-5-git-send-email-laijs@cn.fujitsu.com>
	<20120908174044.GD10788@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Sun, 9 Sep 2012 01:50:41 +0800
Message-ID: <CACvQF53dj+fVdYf6uSPREGbtLTBvLcaqX1CJN6XVQOCPx3ttsA@mail.gmail.com>
Subject: Re: [PATCH 4/7 V6] workqueue: fix idle worker depletion
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 1:40 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Lai.
>
> On Sun, Sep 09, 2012 at 01:12:53AM +0800, Lai Jiangshan wrote:
>> +/* does the manager need to be rebind after we just release gcwq->lock */
>> +static void maybe_rebind_manager(struct worker *manager)
>> +{
>> +     struct global_cwq *gcwq = manager->pool->gcwq;
>> +     bool assoc = !(gcwq->flags & GCWQ_DISASSOCIATED);
>> +
>> +     if (assoc && (manager->flags & WORKER_UNBOUND)) {
>> +             spin_unlock_irq(&gcwq->lock);
>> +
>> +             if (worker_maybe_bind_and_lock(manager))
>> +                     worker_clr_flags(manager, WORKER_UNBOUND);
>> +     }
>> +}
>
> We can reuse busy_worker_rebind_fn(), right?

busy_worker_rebind_fn() releases the gcwq->lock. we can't release the lock here.

>
>>       pool->manager = worker;
>> +     if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
>> +             /*
>> +              * Ouch! rebind_workers() or gcwq_unbind_fn() beats we.
>> +              * it can't return false here, otherwise it will lead to
>> +              * worker depletion. So we release gcwq->lock and then
>> +              * grab manager_mutex again.
>> +              */
>> +             spin_unlock_irq(&gcwq->lock);
>> +             mutex_lock(&pool->manager_mutex);
>> +             spin_lock_irq(&gcwq->lock);
>> +
>> +             /* rebind_workers() can happen when we release gcwq->lock */
>> +             maybe_rebind_manager(worker);
>
> And we can call process_scheduled_works() here and make the CPU
> hotplug check pool->manager and schedule rebind_work there.
>

sorry again. don't need.

Thanks.
Lai

>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
