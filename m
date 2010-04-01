Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab0DAT4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:56:25 -0400
Received: from mail-pz0-f201.google.com ([209.85.222.201]:35711 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0DAT4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=phWv8PS83mVOOTOTrM8mc1Lmu8uxXkETFMTC2WKv56X93sW0Mo5/t2/QKJ6vcAtDZH
         DcX1HtpE59HUkFiZDTigmrc8gMJwEPL9jRrVYkDpSrUZjnO32f3lePokJJJSltL5DYaL
         MUtCXKviNx7ZtvEMDlStnIvBj8Pm4iskf5xz0=
MIME-Version: 1.0
In-Reply-To: <20100401122740.a1ae80a7.akpm@linux-foundation.org>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>
	 <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>
	 <20100401122740.a1ae80a7.akpm@linux-foundation.org>
Date: Thu, 1 Apr 2010 15:56:20 -0400
X-Google-Sender-Auth: 2bfcc606f90ef965
Message-ID: <z2i40ec3ea41004011256p281cc601t277c3191fef5f87b@mail.gmail.com>
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting till 
	after load update period
From: Chase Douglas <chase.douglas@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 3:27 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 29 Mar 2010 09:41:12 -0400
> Chase Douglas <chase.douglas@canonical.com> wrote:
>
>> There's a period of 10 ticks where calc_load_tasks is updated by all the
>> cpus for the load avg. Usually all the cpus do this during the first
>> tick. If any cpus go idle, calc_load_tasks is decremented accordingly.
>> However, if they wake up calc_load_tasks is not incremented. Thus, if
>> cpus go idle during the 10 tick period, calc_load_tasks may be
>> decremented to a non-representative value. This issue can lead to
>> systems having a load avg of exactly 0, even though the real load avg
>> could theoretically be up to NR_CPUS.
>>
>> This change defers calc_load_tasks accounting after each cpu updates the
>> count until after the 10 tick period.
>>
>> BugLink: http://bugs.launchpad.net/bugs/513848
>>
>
> There was useful information in the [patch 0/1] email, such as the
> offending commit ID.  If possible, it's best to avoid the [patch 0/n]
> thing altogether - that information either has to be moved into the
> [patch 1/n] changelog by someone (ie: me), or it just gets ommitted and
> lost.

I'll be sure to fix that up in any future versions.

>
>> ---
>>  kernel/sched.c |   16 ++++++++++++++--
>>  1 files changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 9ab3cd7..c0aedac 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -3064,7 +3064,8 @@ void calc_global_load(void)
>>   */
>>  static void calc_load_account_active(struct rq *this_rq)
>>  {
>> -     long nr_active, delta;
>> +     static atomic_long_t deferred;
>> +     long nr_active, delta, deferred_delta;
>>
>>       nr_active = this_rq->nr_running;
>>       nr_active += (long) this_rq->nr_uninterruptible;
>> @@ -3072,6 +3073,17 @@ static void calc_load_account_active(struct rq *this_rq)
>>       if (nr_active != this_rq->calc_load_active) {
>>               delta = nr_active - this_rq->calc_load_active;
>>               this_rq->calc_load_active = nr_active;
>> +
>> +             /* Need to defer idle accounting during load update period: */
>> +             if (unlikely(time_before(jiffies, this_rq->calc_load_update) &&
>> +                          time_after_eq(jiffies, calc_load_update))) {
>> +                     atomic_long_add(delta, &deferred);
>> +                     return;
>> +             }
>
> That seems a sensible way to avoid the gross-looking "10 ticks" thing.
>
> What was the reason for "update the avenrun load estimates 10 ticks
> after the CPUs have updated calc_load_tasks"?  Can we do something
> smarter there to fix this?
>
>> +             deferred_delta = atomic_long_xchg(&deferred, 0);
>> +             delta += deferred_delta;
>> +
>>               atomic_long_add(delta, &calc_load_tasks);
>>       }
>>  }
>
> The global `deferred' is unfortunate from a design and possibly
> scalability POV.  Can it be moved into the `struct rq'?  That way it
> can become a plain old `unsigned long', too.

The reason it's global is that any given cpu may go NOHZ idle. If they
sleep through the next load accounting, then their deferred value
won't get accounted for. By keeping it global and having it checked by
every cpu, we ensure that in the worst case where only one cpu is
awake to do the accounting, the deferred values from all cpus are
taken into account.

After a review by Andy Whitcroft on the Ubuntu kernel team, we decided
to do a few things to improve performance:

1. Check if values are non-zero before atomically touching the
deferred variable (load avg accounting is imprecise anyways, we just
need to make sure we don't lose any tasks)
2. Rename the deferred variable to calc_load_tasks_deferred and move
it right after calc_load_tasks to hopefully catch it in the same cache
line

Thomas Gleixner seems to think this isn't the best approach (later
email in this thread), so I'm deferring sending it unless someone is
still interested in this approach.

-- Chase
