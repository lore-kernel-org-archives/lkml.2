Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab2IZLV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:21:59 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:32947 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab2IZLV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:21:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120925175657.GB16296@google.com>
References: <cover.1348568074.git.viresh.kumar@linaro.org>
	<3232b3192e2e373cc4aaf43359d454c5ad53cddb.1348568074.git.viresh.kumar@linaro.org>
	<20120925175657.GB16296@google.com>
Date: Wed, 26 Sep 2012 16:51:57 +0530
Message-ID: <CAKohpo=qLikJXWydsQoTHLk=Vn_aYkROOtYnkAKWfd1mMGZ2kw@mail.gmail.com>
Subject: Re: [PATCH 3/3] workqueue: Schedule work on non-idle cpu instead of
 current one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, paul.mckenney@linaro.org,
        tglx@linutronix.de, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2012 23:26, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Sep 25, 2012 at 04:06:08PM +0530, Viresh Kumar wrote:
>> +config MIGRATE_WQ
>> +     bool "(EXPERIMENTAL) Migrate Workqueues to non-idle cpu"
>> +     depends on SMP && EXPERIMENTAL
>> +     help
>> +       Workqueues queues work on current cpu, if the caller haven't passed a
>> +       preferred cpu. This may wake up an idle CPU, which is actually not
>> +       required. This work can be processed by any CPU and so we must select
>> +       a non-idle CPU here.  This patch adds in support in workqueue
>> +       framework to get preferred CPU details from the scheduler, instead of
>> +       using current CPU.
>
> I don't think it's a good idea to make behavior like this a config
> option.  The behavior difference is subtle and may induce incorrect
> behavior.

Ok. Will remove it.

>> @@ -1066,8 +1076,9 @@ int queue_work(struct workqueue_struct *wq, struct work_struct *work)
>>  {
>>       int ret;
>>
>> -     ret = queue_work_on(get_cpu(), wq, work);
>> -     put_cpu();
>> +     preempt_disable();
>> +     ret = queue_work_on(wq_select_cpu(), wq, work);
>> +     preempt_enable();
>
> First of all, I'm not entirely sure this is safe.  queue_work() used
> to *guarantee* that the work item would execute on the local CPU.  I
> don't think there are many which depend on that but I'd be surprised
> if this doesn't lead to some subtle problems somewhere.  It might not
> be realistic to audit all users and we might have to just let it
> happen and watch for the fallouts.  Dunno, still wanna see some level
> of auditing.

Ok.

> Also, I'm wondering why this is necessary at all for workqueues.  For
> schedule/queue_work(), you pretty much know the current cpu is not
> idle.  For delayed workqueue, sure but for immediate scheduling, why?

This was done for below scenario:
- A cpu has programmed a timer and is IDLE now.
- CPU gets into interrupt handler due to timer and queues a work. As the
CPU is currently IDLE, we should queue this work to some other CPU.

I know this patch did migrate works in all cases. Will fix it by queuing work
only for this case in V2.

--
viresh
