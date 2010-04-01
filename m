Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab0DAUA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:00:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36173 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0DAUA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:00:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sI/8fLgxx5uD0n/Yb94vzzpFpBr8IzI540eT7Ldg/UmBIjejTUA9o4UgZ44fnMKU/a
         Z5toroyl4+/XLme8xlsG1mMyJNGf7Gg3C34E7937uJEjTIZfL8Whmi68UEiOINhc/RJB
         IcVh1EPdaZDegQaJMtqU97+sB58mzxxjmX/84=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004012133570.32352@localhost.localdomain>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>
	 <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>
	 <20100401122740.a1ae80a7.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1004012133570.32352@localhost.localdomain>
Date: Thu, 1 Apr 2010 16:00:24 -0400
X-Google-Sender-Auth: 97d165bc5418b22a
Message-ID: <h2s40ec3ea41004011300zaa5699f0kcf07434fec9b1aab@mail.gmail.com>
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting till 
	after load update period
From: Chase Douglas <chase.douglas@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 3:37 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 1 Apr 2010, Andrew Morton wrote:
>> On Mon, 29 Mar 2010 09:41:12 -0400
>> Chase Douglas <chase.douglas@canonical.com> wrote:
>>
>> > There's a period of 10 ticks where calc_load_tasks is updated by all the
>> > cpus for the load avg. Usually all the cpus do this during the first
>> > tick. If any cpus go idle, calc_load_tasks is decremented accordingly.
>> > However, if they wake up calc_load_tasks is not incremented. Thus, if
>> > cpus go idle during the 10 tick period, calc_load_tasks may be
>> > decremented to a non-representative value. This issue can lead to
>> > systems having a load avg of exactly 0, even though the real load avg
>> > could theoretically be up to NR_CPUS.
>> >
>> > This change defers calc_load_tasks accounting after each cpu updates the
>> > count until after the 10 tick period.
>> >
>> > BugLink: http://bugs.launchpad.net/bugs/513848
>> >
>>
>> There was useful information in the [patch 0/1] email, such as the
>> offending commit ID.  If possible, it's best to avoid the [patch 0/n]
>> thing altogether - that information either has to be moved into the
>> [patch 1/n] changelog by someone (ie: me), or it just gets ommitted and
>> lost.
>>
>>
>> > ---
>> >  kernel/sched.c |   16 ++++++++++++++--
>> >  1 files changed, 14 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/kernel/sched.c b/kernel/sched.c
>> > index 9ab3cd7..c0aedac 100644
>> > --- a/kernel/sched.c
>> > +++ b/kernel/sched.c
>> > @@ -3064,7 +3064,8 @@ void calc_global_load(void)
>> >   */
>> >  static void calc_load_account_active(struct rq *this_rq)
>> >  {
>> > -   long nr_active, delta;
>> > +   static atomic_long_t deferred;
>> > +   long nr_active, delta, deferred_delta;
>> >
>> >     nr_active = this_rq->nr_running;
>> >     nr_active += (long) this_rq->nr_uninterruptible;
>> > @@ -3072,6 +3073,17 @@ static void calc_load_account_active(struct rq *this_rq)
>> >     if (nr_active != this_rq->calc_load_active) {
>> >             delta = nr_active - this_rq->calc_load_active;
>> >             this_rq->calc_load_active = nr_active;
>> > +
>> > +           /* Need to defer idle accounting during load update period: */
>> > +           if (unlikely(time_before(jiffies, this_rq->calc_load_update) &&
>> > +                        time_after_eq(jiffies, calc_load_update))) {
>> > +                   atomic_long_add(delta, &deferred);
>> > +                   return;
>> > +           }
>>
>> That seems a sensible way to avoid the gross-looking "10 ticks" thing.
>>
>> What was the reason for "update the avenrun load estimates 10 ticks
>> after the CPUs have updated calc_load_tasks"?  Can we do something
>> smarter there to fix this?
>
> The reason was to make sure that all cpus have updated their stuff
> halfways before we start to calculate and we spread out stuff among
> cpus to avoid contention on those global atomic variables.
>
> Yes, we can do something smarter. First thing is to fix the
> nr_uninterruptible accounting which can become negative. Peter looked
> into that already and we really need to fix this first before doing
> anything smart about that load avg stuff.

I noticed this too, and figured it was some clever accounting :). If
this is a real bug, I'd be happy to take a look at it as well.

What do you have in mind as a smarter way of fixing this issue, and
why is it dependent on fixing the absolute values of each runqueue's
nr_uninterruptible count?

-- Chase
