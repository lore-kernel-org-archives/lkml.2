Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0JBPmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 11:42:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49075 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab0JBPmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 11:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MA0Fdz7BMrM/PkR7xLcU7a+ck8seBvC42fVW01EBgHr6zJHD648vLVbyWXyo/aWBER
         46DZVcRdxa3TxmvInUaw==
MIME-Version: 1.0
In-Reply-To: <1285975006.2144.67.camel@laptop>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	<1285788096-29471-2-git-send-email-venki@google.com>
	<1285844662.2144.9.camel@laptop>
	<AANLkTinEN8i=Tx-CrdVzv-FGJH5jXaxwsPm-GDf-M_hi@mail.gmail.com>
	<1285975006.2144.67.camel@laptop>
Date: Sat, 2 Oct 2010 08:42:02 -0700
Message-ID: <AANLkTikwUh57PKNk_fWzXApoYnCqK9NFi-MzSY-QKUc5@mail.gmail.com>
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

On Fri, Oct 1, 2010 at 4:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-09-30 at 09:26 -0700, Venkatesh Pallipadi wrote:
>> > One nit: in_serving_softirq() doesn't seem right as either:
>> >
>> >  - we're not accounting ksoftirq in it, or
>> >  - we're are and VIRT_CPU_ACCOUNTING is again broken ;-)
>> >
>> > So only the softirq from irq tails wants to have SOFTIRQ_OFFSET set, the
>> > ksoftirqd stuff can be tested for using PF_flags or something (ksoftirq
>> > doesn't currently have a PF_SOFTIRQ flag, but -rt does and we could
>> > bring that over).
>> >
>>
>> The problem is that ksoftirqd is also handling softirq's and some
>> eventual users of in_serving_softirq (like the network code in this
>> patch) want to differentiate between whether it is the softirq thats
>> running or some real process (!ksoftirqd) context.
>
> The make in_serving_softirq() be something like:
>  (preempt_count() & SOFTIRQ_OFFSET) || (current->flags & PF_SOFTIRQ)
>

Yes. I would also need in_softirq_at_hardirq_tail() for accounting calls :)

>> Also, ksoftirqd adds to softirq counts, does trace softirq, etc. So,
>> it kind of made sense to add the time also to softirq stats as well.
>> If we dont account time to softirq stats, then if some user is looking
>> at say time per softirq using the softirq count will be misled. No?
>
> Simply add back the task accounting when you report it?
>
>> In the other thread you mentioned doing that will cause problems. Were
>> you thinking of scheduler issues or are there other problems charging
>> softirq time this way?
>
> Of course there are.. you're double accounting the time of ksoftirqd,
> and worse, you're adding that back into the equation as part of the !
> sched_fair time.
>

No. There should not be any double accounting with this current
change. We account softirq processing both at hardirq tail and
ksoftirqd as CPU softirq time. It will be taken out of ksoftirqd sched
exec time as with any other thread. And it will be taken out of fair
time available on the CPU as well. Which to me seems to be the right
thing to do, as the this is more coupled with the CPU and ksoftirqd is
just giving context for softirqd to run.

Changing only hardirq tail to have SOFTIRQ_OFFSET and changing
ksoftirqd to SOFTIRQ_OFFSET*2 would result in these additional
ksoftirqd softirqs staying as the part of sched_fair time.

Or I am totally missing something here?

Thanks,
Venki
