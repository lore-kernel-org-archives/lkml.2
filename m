Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2IYLaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:30:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63859 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab2IYLao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:30:44 -0400
MIME-Version: 1.0
In-Reply-To: <1348572145.3881.18.camel@twins>
References: <viresh.kumar@linaro.org>
	<cover.1348568074.git.viresh.kumar@linaro.org>
	<3232b3192e2e373cc4aaf43359d454c5ad53cddb.1348568074.git.viresh.kumar@linaro.org>
	<1348572145.3881.18.camel@twins>
Date: Tue, 25 Sep 2012 17:00:44 +0530
Message-ID: <CAKohpokju4=fVKtq=rG0y-_c54n0yErzredW1BEJ5eTSaDyHpg@mail.gmail.com>
Subject: Re: [PATCH 3/3] workqueue: Schedule work on non-idle cpu instead of
 current one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, paul.mckenney@linaro.org,
        tglx@linutronix.de, tj@kernel.org, suresh.b.siddha@intel.com,
        venki@google.com, mingo@redhat.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2012 16:52, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-09-25 at 16:06 +0530, Viresh Kumar wrote:
>> @@ -1066,8 +1076,9 @@ int queue_work(struct workqueue_struct *wq,
>> struct work_struct *work)
>>  {
>>         int ret;
>>
>> -       ret = queue_work_on(get_cpu(), wq, work);
>> -       put_cpu();
>> +       preempt_disable();
>> +       ret = queue_work_on(wq_select_cpu(), wq, work);
>> +       preempt_enable();
>>
>>         return ret;
>>  }
>
> Right, so the problem I see here is that wq_select_cpu() is horridly
> expensive..

But this is what the initial idea during LPC we had. Any improvements here
you can suggest?

>> @@ -1102,7 +1113,7 @@ static void delayed_work_timer_fn(unsigned long
>> __data)
>>         struct delayed_work *dwork = (struct delayed_work *)__data;
>>         struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
>>
>> -       __queue_work(smp_processor_id(), cwq->wq, &dwork->work);
>> +       __queue_work(wq_select_cpu(), cwq->wq, &dwork->work);
>>  }
>
> Shouldn't timer migration have sorted this one?

Maybe yes. Will investigate more on it.

Thanks for your early feedback.

--
viresh
