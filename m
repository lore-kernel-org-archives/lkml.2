Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab0JURTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:19:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7541 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab0JURTD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fr3X+vzqMvD1DYcxTlgrmpCgrHt5jubv+3eet3AF3Tg4rnHREK6PEjM+GFw/zs9A/D
         KPB9fQrZsjUC+LYY/QXQ==
MIME-Version: 1.0
In-Reply-To: <1287662999.3488.117.camel@twins>
References: <20100929070153.GA2200@brouette>
	<20101014145813.GA2185@brouette>
	<20101020132732.GA30024@brouette>
	<1287581440.3488.16.camel@twins>
	<1287582208.3488.20.camel@twins>
	<1287584073.3488.22.camel@twins>
	<1287595605.3488.52.camel@twins>
	<1287662999.3488.117.camel@twins>
Date: Thu, 21 Oct 2010 10:18:59 -0700
Message-ID: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually
 high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 5:09 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-10-20 at 19:26 +0200, Peter Zijlstra wrote:
>
>> -static void calc_load_account_idle(struct rq *this_rq)
>> +void calc_load_account_idle(void)
>>  {
>> +     struct rq *this_rq = this_rq();
>>       long delta;
>>
>>       delta = calc_load_fold_active(this_rq);
>> +     this_rq->calc_load_inactive = delta;
>> +     this_rq->calc_load_seq = atomic_read(&calc_load_seq);
>> +
>>       if (delta)
>>               atomic_long_add(delta, &calc_load_tasks_idle);
>>  }
>>
>> +void calc_load_account_nonidle(void)
>> +{
>> +     struct rq *this_rq = this_rq();
>> +
>> +     if (atomic_read(&calc_load_seq) == this_rq->calc_load_seq) {
>> +             atomic_long_sub(this_rq->calc_load_inactive, &calc_load_tasks_idle);
>> +             /*
>> +              * Undo the _fold_active() from _account_idle(). This
>> +              * avoids us loosing active tasks and creating a negative
>> +              * bias
>> +              */
>> +             this_rq->calc_load_active -= this_rq->calc_load_inactive;
>> +     }
>> +}
>
> Ok, so while trying to write a changelog on this patch I got myself
> terribly confused again..
>
> calc_load_active_fold() is a relative operation and simply gives delta
> values since the last time it got called. That means that the sum of
> multiple invocations in a given time interval should be identical to a
> single invocation.
>
> Therefore, the going idle multiple times during LOAD_FREQ hypothesis
> doesn't really make sense.
>

Yes. Thats what I was thinking trying to understand this code yesterday.

Also with sequence number I don't think nr_interruptible would be
handled correctly
as tasks can move to CPU after it first went idle and may not get
accounted later.

I somehow feel the problem is with nr_interruptible, which gets
accounted multiple
times on idle tasks and only once per LOAD_FREQ on busy tasks.
However, things are
not fully clear to me yet. Have to look at the code a bit more.

Thanks,
Venki

> Even if it became idle but wasn't idle at the LOAD_FREQ turn-over it
> shouldn't matter, since the calc_load_account_active() call will simply
> fold the remaining delta with the accrued idle delta and the total
> should all match up once we fold into the global calc_load_tasks.
>
> So afaict its should all have worked and this patch is a big NOP,.
> except it isn't..
>
> Damn I hate this bug.. ;-) Anybody?
>
