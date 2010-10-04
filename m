Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0JDQz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:55:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23345 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0JDQz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DHof492x6OX3a67yibe/YkJ0LvShQn6kLj1fzHI/EF1rx+ph/0cf+qZjWXYEifmIIr
         kBmeqQhwSub7oqG3fhOw==
MIME-Version: 1.0
In-Reply-To: <1286066056.2144.114.camel@laptop>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	<1285788096-29471-2-git-send-email-venki@google.com>
	<1285844662.2144.9.camel@laptop>
	<AANLkTinEN8i=Tx-CrdVzv-FGJH5jXaxwsPm-GDf-M_hi@mail.gmail.com>
	<1285975006.2144.67.camel@laptop>
	<AANLkTikwUh57PKNk_fWzXApoYnCqK9NFi-MzSY-QKUc5@mail.gmail.com>
	<1286066056.2144.114.camel@laptop>
Date: Mon, 4 Oct 2010 09:54:56 -0700
Message-ID: <AANLkTim_YsX1u+w385bDDDD4p0Oi-QQvEgVsFwOiDWjk@mail.gmail.com>
Subject: Re: [PATCH 1/7] si time accounting accounts bh_disable'd time to si -v3
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 2, 2010 at 5:34 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2010-10-02 at 08:42 -0700, Venkatesh Pallipadi wrote:
>>
>> > The make in_serving_softirq() be something like:
>> >  (preempt_count() & SOFTIRQ_OFFSET) || (current->flags & PF_SOFTIRQ)
>> >
>>
>> Yes. I would also need in_softirq_at_hardirq_tail() for accounting calls :)
>
> Well, you could open-code it there or something.
>
>> >> Also, ksoftirqd adds to softirq counts, does trace softirq, etc. So,
>> >> it kind of made sense to add the time also to softirq stats as well.
>> >> If we dont account time to softirq stats, then if some user is looking
>> >> at say time per softirq using the softirq count will be misled. No?
>> >
>> > Simply add back the task accounting when you report it?
>> >
>> >> In the other thread you mentioned doing that will cause problems. Were
>> >> you thinking of scheduler issues or are there other problems charging
>> >> softirq time this way?
>> >
>> > Of course there are.. you're double accounting the time of ksoftirqd,
>> > and worse, you're adding that back into the equation as part of the !
>> > sched_fair time.
>> >
>>
>> No. There should not be any double accounting with this current
>> change. We account softirq processing both at hardirq tail and
>> ksoftirqd as CPU softirq time. It will be taken out of ksoftirqd sched
>> exec time as with any other thread. And it will be taken out of fair
>> time available on the CPU as well. Which to me seems to be the right
>> thing to do, as the this is more coupled with the CPU and ksoftirqd is
>> just giving context for softirqd to run.
>
> But ksoftirqd is a SCHED_OTHER task, so by taking it out of its runtime
> the scheduler will get all confused.
>
>> Changing only hardirq tail to have SOFTIRQ_OFFSET and changing
>> ksoftirqd to SOFTIRQ_OFFSET*2 would result in these additional
>> ksoftirqd softirqs staying as the part of sched_fair time.
>>
>> Or I am totally missing something here?
>
> Please keep ksoftirq scheduling normal, if people want it to be another
> scheduling class, let them change that, but since its a task it should
> be a normal task and get scheduled like everybody else, not have some
> magic properties.
>

OK. In that case we can leave the existing softirq accounting
(!IRQ_TIME_ACCOUNTING) users as they are. They don't have any
ksoftirqd and scheduler issues. So, this patch should be good as it
is.
I will however, change IRQ_TIME_ACCOUNTING case to not take out
scheduler time out of ksoftirqd due to softirqs. Sounds good?

Thanks,
Venki
