Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2IYLiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:38:51 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38532 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab2IYLiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokju4=fVKtq=rG0y-_c54n0yErzredW1BEJ5eTSaDyHpg@mail.gmail.com>
References: <viresh.kumar@linaro.org>
	<cover.1348568074.git.viresh.kumar@linaro.org>
	<3232b3192e2e373cc4aaf43359d454c5ad53cddb.1348568074.git.viresh.kumar@linaro.org>
	<1348572145.3881.18.camel@twins>
	<CAKohpokju4=fVKtq=rG0y-_c54n0yErzredW1BEJ5eTSaDyHpg@mail.gmail.com>
Date: Tue, 25 Sep 2012 13:38:49 +0200
Message-ID: <CAKfTPtC5kFT1uDvw3vR5_48Y4-Zu3LzjgA-+xeVrFJzGEDPHfg@mail.gmail.com>
Subject: Re: [PATCH 3/3] workqueue: Schedule work on non-idle cpu instead of
 current one
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Arvind.Chauhan@arm.com, amit.kucheria@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2012 13:30, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 25 September 2012 16:52, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, 2012-09-25 at 16:06 +0530, Viresh Kumar wrote:
>>> @@ -1066,8 +1076,9 @@ int queue_work(struct workqueue_struct *wq,
>>> struct work_struct *work)
>>>  {
>>>         int ret;
>>>
>>> -       ret = queue_work_on(get_cpu(), wq, work);
>>> -       put_cpu();
>>> +       preempt_disable();
>>> +       ret = queue_work_on(wq_select_cpu(), wq, work);
>>> +       preempt_enable();
>>>
>>>         return ret;
>>>  }
>>
>> Right, so the problem I see here is that wq_select_cpu() is horridly
>> expensive..
>
> But this is what the initial idea during LPC we had. Any improvements here
> you can suggest?

The main outcome of the LPC was that we should be able to select
another CPU than the local one.
Using the same policy than timer, is a 1st step to consolidate
interface. A next step should be to update the policy of the function

Vincent
>
>>> @@ -1102,7 +1113,7 @@ static void delayed_work_timer_fn(unsigned long
>>> __data)
>>>         struct delayed_work *dwork = (struct delayed_work *)__data;
>>>         struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
>>>
>>> -       __queue_work(smp_processor_id(), cwq->wq, &dwork->work);
>>> +       __queue_work(wq_select_cpu(), cwq->wq, &dwork->work);
>>>  }
>>
>> Shouldn't timer migration have sorted this one?
>
> Maybe yes. Will investigate more on it.
>
> Thanks for your early feedback.
>
> --
> viresh
