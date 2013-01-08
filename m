Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3AHX2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:28:31 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:54554 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab3AHX23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:28:29 -0500
MIME-Version: 1.0
In-Reply-To: <1357680056.5190.39.camel@gandalf.local.home>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
	<1357610913-1080-5-git-send-email-fweisbec@gmail.com>
	<1357680056.5190.39.camel@gandalf.local.home>
Date: Wed, 9 Jan 2013 00:22:33 +0100
Message-ID: <CAFTL4hzpgDyHZ9qySLmouNBMgr6jqNd--w=1R4spVHELMt-z2A@mail.gmail.com>
Subject: Re: [PATCH 04/33] cputime: Allow dynamic switch between tick/virtual
 based cputime accounting
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/8 Steven Rostedt <rostedt@goodmis.org>:
> On Tue, 2013-01-08 at 03:08 +0100, Frederic Weisbecker wrote:
>
>> @@ -439,29 +443,13 @@ void account_idle_ticks(unsigned long ticks)
>>
>>       account_idle_time(jiffies_to_cputime(ticks));
>>  }
>> -
>>  #endif
>>
>> +
>
> Spurious newline.

There may be even more around on the other patches :)

>> +#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
>> +void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
>> +{
>> +     *ut = p->utime;
>> +     *st = p->stime;
>> +}
>
> Why not keep this out in the open like:
>
> static void __task_cputime_adjusted() {
>         ...
> }
>
> #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
> void task_cputime_adjusted(...)
> {
>         __task_cputime_adjusted(p, ut, st);
> }
>
>> +
>> +void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st)
>> +{
>> +     struct task_cputime cputime;
>> +
>> +     thread_group_cputime(p, &cputime);
>> +
>> +     *ut = cputime.utime;
>> +     *st = cputime.stime;
>> +}
>> +#else /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
>>
>>  #ifndef nsecs_to_cputime
>>  # define nsecs_to_cputime(__nsecs)   nsecs_to_jiffies(__nsecs)
>> @@ -548,6 +553,12 @@ static void cputime_adjust(struct task_cputime *curr,
>>  {
>>       cputime_t rtime, utime, total;
>>
>> +     if (vtime_accounting_enabled()) {
>> +             *ut = curr->utime;
>> +             *st = curr->stime;
>
> Then here, we can do:
>
>                 __task_cputime_adjusted(curr, ut, st);
>> +             return;

Note curr above is not a task but a struct task_cputime. But it could be:

__task_cputime_adjusted(curr->utime, curr->stime, ut, st);

But thinking more about it, I should just remove this:

+     if (vtime_accounting_enabled()) {
+             *ut = curr->utime;
+             *st = curr->stime;

It concerns CONFIG_VIRT_CPU_ACCOUNTING_GEN which is actually not
enough precise (it's jiffies based) and thus needs the same adjusting
performed on normal tick based cputime.

>
> Isn't suppose to do basically the same thing, when
> vtime_accounting_enabled() is set?
>
>> +     }
>> +
>>       utime = curr->utime;
>>       total = utime + curr->stime;
>>
>> @@ -601,7 +612,7 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
>>       thread_group_cputime(p, &cputime);
>>       cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
>>  }
>> -#endif
>> +#endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
>>
>>  #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
>>  static DEFINE_PER_CPU(long, last_jiffies) = INITIAL_JIFFIES;
>> @@ -643,6 +654,11 @@ void vtime_account_idle(struct task_struct *tsk)
>>       account_idle_time(delta_cpu);
>>  }
>>
>> +bool vtime_accounting_enabled(void)
>> +{
>> +     return context_tracking_active();
>> +}
>> +
>>  static int __cpuinit vtime_cpu_notify(struct notifier_block *self,
>>                                     unsigned long action, void *hcpu)
>>  {
>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>> index fb8e5e4..314b9ee 100644
>> --- a/kernel/time/tick-sched.c
>> +++ b/kernel/time/tick-sched.c
>> @@ -632,8 +632,11 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
>>
>>  static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
>>  {
>> -#ifndef CONFIG_VIRT_CPU_ACCOUNTING
>> +#ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
>>       unsigned long ticks;
>> +
>> +     if (vtime_accounting_enabled())
>> +             return;
>
> If this can be dynamically changed at runtime, wouldn't some of these
> accounting variables get corrupted? Like the last_jiffies per_cpu
> variable?

It can't yet be dynamically changed at runtime because full dynticks
CPUs are defined through boot parameters. But it's indeed something
we'll need to care about when we'll have a runtime interface.
