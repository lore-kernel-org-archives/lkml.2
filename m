Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab1F1Emf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 00:42:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31476 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab1F1Ek7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 00:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qyGITUNArAQJBjbdtW7H4MWXdr0+VcMReYV91pMLKB8xUXRqcLwdCZiPzxzeXdvsCK
         k1bW2YZSvz85ZgD2dixQ==
MIME-Version: 1.0
In-Reply-To: <1308763751.1022.60.camel@twins>
References: <20110621071649.862846205@google.com> <20110621071700.599897751@google.com>
 <1308763751.1022.60.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Mon, 27 Jun 2011 21:40:26 -0700
Message-ID: <CAPM31RLbngLP-EuK6TwRCh11RHJMsh1+5vBNisVEvupkJ4q4ng@mail.gmail.com>
Subject: Re: [patch 09/16] sched: unthrottle cfs_rq(s) who ran out of quota at
 period refresh
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 10:29 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-06-21 at 00:16 -0700, Paul Turner wrote:
>>  static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
>>  {
>> -       int idle = 1;
>> +       int idle = 1, throttled = 0;
>> +       u64 runtime, runtime_expires;
>> +
>>
>>         raw_spin_lock(&cfs_b->lock);
>>         if (cfs_b->quota != RUNTIME_INF) {
>> -               idle = cfs_b->idle;
>> -               /* If we're going idle then defer handle the refill */
>> +               /* idle depends on !throttled in the case of a large deficit */
>> +               throttled = !list_empty(&cfs_b->throttled_cfs_rq);
>> +               idle = cfs_b->idle && !throttled;
>> +
>> +               /* If we're going idle then defer the refill */
>>                 if (!idle)
>>                         __refill_cfs_bandwidth_runtime(cfs_b);
>> +               if (throttled) {
>> +                       runtime = cfs_b->runtime;
>> +                       runtime_expires = cfs_b->runtime_expires;
>> +
>> +                       /* we must first distribute to throttled entities */
>> +                       cfs_b->runtime = 0;
>> +               }
>
> Why, whats so bad about letting someone take some concurrently and not
> getting throttled meanwhile? Starvation considerations? If so, that
> wants mentioning.

Yes -- we also particularly want to pay down all deficits first in
case someone has accumulated a *large* arrears (e.g. !CONFIG_PREEMPT).

Will expand the comment here.

>
>>
>>                 /*
>> -                * mark this bandwidth pool as idle so that we may deactivate
>> -                * the timer at the next expiration if there is no usage.
>> +                * conditionally mark this bandwidth pool as idle so that we may
>> +                * deactivate the timer at the next expiration if there is no
>> +                * usage.
>>                  */
>> -               cfs_b->idle = 1;
>> +               cfs_b->idle = !throttled;
>>         }
>>
>> -       if (idle)
>> +       if (idle) {
>>                 cfs_b->timer_active = 0;
>> +               goto out_unlock;
>> +       }
>> +       raw_spin_unlock(&cfs_b->lock);
>> +
>> +retry:
>> +       runtime = distribute_cfs_runtime(cfs_b, runtime, runtime_expires);
>> +
>> +       raw_spin_lock(&cfs_b->lock);
>> +       /* new bandwidth specification may exist */
>> +       if (unlikely(runtime_expires != cfs_b->runtime_expires))
>> +               goto out_unlock;
>
> it might help to explain how, runtime_expires is taken from cfs_b after
> calling __refill_cfs_bandwidth_runtime, and we're in the replenishment
> timer, so nobody is going to be adding new runtime.
>

Good idea -- thanks

>> +       /* ensure no-one was throttled while we unthrottling */
>> +       if (unlikely(!list_empty(&cfs_b->throttled_cfs_rq)) && runtime > 0) {
>> +               raw_spin_unlock(&cfs_b->lock);
>> +               goto retry;
>> +       }
>
> OK, I can see that.
>
>> +
>> +       /* return remaining runtime */
>> +       cfs_b->runtime = runtime;
>> +out_unlock:
>>         raw_spin_unlock(&cfs_b->lock);
>>
>>         return idle;
>
> This function hurts my brain, code flow is horrid.

Yeah.. I don't know why I didn't just make it a while loop, will fix.

>
