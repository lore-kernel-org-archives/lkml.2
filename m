Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab3AHXye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:54:34 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:58147 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab3AHXy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:54:29 -0500
MIME-Version: 1.0
In-Reply-To: <50E73956.30900@windriver.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
	<1356799386-4212-3-git-send-email-fweisbec@gmail.com>
	<50E73956.30900@windriver.com>
Date: Wed, 9 Jan 2013 00:54:29 +0100
Message-ID: <CAFTL4hw8YAZ+_zoK0HSf7zxkX-ZbJNZtKBmV_kz83jjqkPsFgw@mail.gmail.com>
Subject: Re: [PATCH 02/27] cputime: Generic on-demand virtual cputime accounting
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/4 Paul Gortmaker <paul.gortmaker@windriver.com>:
> On 12-12-29 11:42 AM, Frederic Weisbecker wrote:
>> diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
>> index e24339c..9f33fbc 100644
>> --- a/include/linux/context_tracking.h
>> +++ b/include/linux/context_tracking.h
>> @@ -3,12 +3,40 @@
>>
>>  #ifdef CONFIG_CONTEXT_TRACKING
>>  #include <linux/sched.h>
>> +#include <linux/percpu.h>
>> +
>> +struct context_tracking {
>> +     /*
>> +      * When active is false, hooks are unset in order
>> +      * to minimize overhead: TIF flags are cleared
>> +      * and calls to user_enter/exit are ignored. This
>> +      * may be further optimized using static keys.
>> +      */
>> +     bool active;
>> +     enum {
>> +             IN_KERNEL = 0,
>> +             IN_USER,
>> +     } state;
>> +};
>
> I wonder if it is worthwhile to have a separate commit
> before this one, which does the basic move of the struct
> and associated prototypes from context_tracking.c file
> to here.  Then that commit would be mindlessly easy to
> review, and only the real technical vcpu accounting changes
> would remain here in this commit.

Sounds right. I've split that part into a seperate commit.

>
>> +
>> +DECLARE_PER_CPU(struct context_tracking, context_tracking);
>> +
>> +static inline bool context_tracking_in_user(void)
>> +{
>> +     return __this_cpu_read(context_tracking.state) == IN_USER;
>> +}
>
> Should we add a context_tracking_in_kernel() too?

Well, as long as we don't need it, I guess we can avoid it.

> And similar
> instances of set_context_tracking_in_user()/kernel()?  That would
> improve code readability a bit by avoiding having the long
> __this_cpu_write(....) type lines below.

I don't know, these are only used once. I'm not sure that level of
indirection would actually improve readability under this condition.

>
> Perhaps worth also considering to drop the "tracking" from the fcn
> names for brevity?  "in_user_context" and "set_kernel_context" seem
> like decent self descriptive function names at 1st glance, but that
> might violate the implicit "subsystem_subfunction()" naming guidelines
> that I think Andrew was talking about in another recent thread...

Indeed, I usually try to keep that naming convention. Ingo also
usually encourages me too. I just made an exception with user_enter()
and user_exit() because they intuitively mirror irq_enter() and such.
Or at least I hope they do.

That said we also have in_interrupt() / in_softirq() / .... So it
might be worth to expand with in_user(). I don't mind much. Are there
other people who would prefer that?

>> @@ -495,10 +496,24 @@ void vtime_task_switch(struct task_struct *prev)
>>  #ifndef __ARCH_HAS_VTIME_ACCOUNT
>>  void vtime_account(struct task_struct *tsk)
>>  {
>> -     if (in_interrupt() || !is_idle_task(tsk))
>> -             vtime_account_system(tsk);
>> -     else
>> -             vtime_account_idle(tsk);
>> +     if (!in_interrupt()) {
>> +             /*
>> +              * If we interrupted user, context_tracking_in_user()
>> +              * is 1 because the context tracking don't hook
>> +              * on irq entry/exit. This way we know if
>> +              * we need to flush user time on kernel entry.
>> +              */
>> +             if (context_tracking_in_user()) {
>> +                     vtime_account_user(tsk);
>
> If we called account_user_time() here directly, would that get rid of the
> need for the "unfortunate hack" below?  It wasn't 100% clear to me where
> or when the mis-accounting of user time as system time would happen without
> the hack.

Yeah that not obvious. Here is the scenario:

execution in userspace during a jiffy
===> irq (tick)
irq_enter() {
    vtime_account()
}

tick_sched_timer() {
      update jiffies
}

irq_exit()
<=====
back to userspace

We execute in userspace during one jiffy. When we enter the irq, we
account the pending time to user, because we were executing in
userspace before the irq. But the jiffies haven't been updated yet,
they will be later. Then on irq_exit() time we account the pending
time (time of execution of the irq) into the system area. So the new
jiffy is spuriously accounted to the system area while it actually
should belong to user area. This is why we do that fixup.

We still do the vtime_account_user() on irq entry, in case some other
CPU has the timekeeping duty and we have some pending jiffies to
account.

In the longer term we should perhaps use sched_clock(). This should
solve the problem if we have a better resolution than jiffies. We
still need to handle the case of the unoverriden default sched_clock()
that relies on jiffies though.
