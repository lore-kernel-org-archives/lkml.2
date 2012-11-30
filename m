Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868Ab2K3TmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:42:06 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40067 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759855Ab2K3TmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:42:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAFTL4hwSva0eBK1f=K7Hus0ybiEACtebQbhEUDsJjLZcmmeCtA@mail.gmail.com>
References: <1354091364-7920-1-git-send-email-hakanakkan@gmail.com>
 <1354125783-15816-1-git-send-email-hakanakkan@gmail.com> <CAFTL4hwSva0eBK1f=K7Hus0ybiEACtebQbhEUDsJjLZcmmeCtA@mail.gmail.com>
From: Hakan Akkan <hakanakkan@gmail.com>
Date: Fri, 30 Nov 2012 12:41:43 -0700
Message-ID: <CABVzNXp0pLFPP_0NhJfRmi_88Hcmw=ebX7Y+0C+3ZrPNOWmKnA@mail.gmail.com>
Subject: Re: [PATCH] nohz/cpuset: Make a CPU stick with do_timer() duty in the
 presence of nohz cpusets
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 10:38 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> 2012/11/28 Hakan Akkan <hakanakkan@gmail.com>:
>> +static int check_drop_timer_duty(int cpu)
>> +{
>> +       int curr_handler, prev_handler, new_handler;
>> +       int nrepeat = -1;
>> +       bool drop_recheck;
>> +
>> +repeat:
>> +       WARN_ON_ONCE(++nrepeat > 1);
>> +       drop_recheck = false;
>> +       curr_handler = cpu;
>> +       new_handler = TICK_DO_TIMER_NONE;
>> +
>> +#ifdef CONFIG_CPUSETS_NO_HZ
>> +       if (atomic_read(&nr_cpus_user_nohz) > 0) {
>
> Note atomic_read() is not SMP ordered. If another CPU does
> atomic_add() or atomic_add_return(), you may not see the new value as
> expected with atomic_read(). Doing atomic_add_return(0, &atomic_thing)
> returns the fully ordered result.

That code doesn't necessarily try to achieve a prefect ordering. I wasn't very
sure if we want the overhead of atomic_add_return(0, ...) in such a hot path
so this part of the function is racy. Nevertheless, it makes sure that someone
gets the duty.

#ifdef CONFIG_CPUSETS_NO_HZ
       if (atomic_read(&nr_cpus_user_nohz) > 0) {

The CPU who updated nr_cpus_user_nohz will certainly see the new
value and claim the duty if someone else hasn't yet. Another regular
CPU will eventually see the new value and assign itself to the duty.
So we can tolerate some race here for the sake of avoiding heavier locks.

>
> You also need to do that to ensure full ordering against
> tick_cpu_sched.user_nohz.
>
> On the current layout we have:
>
> (Write side)                                      (Read side)
>
> ts->user_nohz = 1;
> atomic_inc(&nr_cpus_user_nohz)
>
>                                                       if
> (atomic_read(&nr_cpus_user_nohz))
>                                                             if
> (per_cpu(tick_cpu_sched, curr_handler).user_nohz)
>                                                                 ....
>
> If you want to make sure that you see the expected value on user_nohz
> from the read side, you need to correctly order the write and read
> against nr_cpus_user_nohz.

Again, perfect ordering is not critical here. In the worst case we miss that
CPUs ts->user_nohz = 1 update and that adaptive nohz CPU will keep
the duty for a short while until someone else takes it. Trying to avoid this
would require more locking instructions like you suggest below.

If we really want to fully isolate nohz CPUs and avoid "being stuck with
jiffies update until someone else takes it away" situations, we can have a
cpumask denoting idle and/or non-adaptive-nohz CPUs and dump the duty
once we discover that we're "stuck".

>
> For this you can use atomic_add_return() which implies the full barrier:
>
>
> (Write side)                                      (Read side)
>
> ts->user_nohz = 1;
> atomic_inc_return(&nr_cpus_user_nohz)
>
>                                                       if
> (atomic_add_return(0, &nr_cpus_user_nohz))
>                                                             if
> (per_cpu(tick_cpu_sched, curr_handler).user_nohz)
>                                                                 ....
>
> I have much more comments on this patch, I will come back on this soon.
>
> Thanks.
