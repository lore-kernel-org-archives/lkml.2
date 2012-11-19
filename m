Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab2KSOqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 09:46:37 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60787 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2KSOqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 09:46:36 -0500
MIME-Version: 1.0
In-Reply-To: <4FDD7AA8.6080601@gmail.com>
References: <4FDD7AA8.6080601@gmail.com>
Date: Mon, 19 Nov 2012 15:46:35 +0100
Message-ID: <CAFTL4hy4SedXQ1Bc6o_1BHZ-7a8tbbvpUcFwp50hDbgNnv79zQ@mail.gmail.com>
Subject: Re: [PATCH] nohz/cpuset: Make a CPU stick with do_timer() duty in the
 presence of nohz cpusets
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hakan Akkan <hakanakkan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hakan,

As I start to focus on timekeeing for full dynticks, I'm looking at
your patch. Sorry I haven't yet replied with a serious review until
now. But here is it, finally:

2012/6/17 Hakan Akkan <hakanakkan@gmail.com>:
> An adaptive nohz (AHZ) CPU may not do do_timer() for a while
> despite being non-idle. When all other CPUs are idle, AHZ
> CPUs might be using stale jiffies values. To prevent this
> always keep a CPU with ticks if there is one or more AHZ
> CPUs.
>
> The patch changes can_stop_{idle,adaptive}_tick functions
> and prevents either the last CPU who did the do_timer() duty
> or the AHZ CPU itself from stopping its sched timer if there
> is one or more AHZ CPUs in the system. This means AHZ CPUs
> might keep the ticks running for short periods until a
> non-AHZ CPU takes the charge away in
> tick_do_timer_check_handler() function. When a non-AHZ CPU
> takes the charge, it never gives it away so that AHZ CPUs
> can run tickless.
>
> Signed-off-by: Hakan Akkan <hakanakkan@gmail.com>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/linux/cpuset.h   |    3 ++-
>  kernel/cpuset.c          |    5 +++++
>  kernel/time/tick-sched.c |   31 ++++++++++++++++++++++++++++++-
>  3 files changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index ccbc2fd..19aa448 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -266,11 +266,12 @@ static inline bool cpuset_adaptive_nohz(void)
>
>  extern void cpuset_exit_nohz_interrupt(void *unused);
>  extern void cpuset_nohz_flush_cputimes(void);
> +extern bool nohz_cpu_exist(void);
>  #else
>  static inline bool cpuset_cpu_adaptive_nohz(int cpu) { return false; }
>  static inline bool cpuset_adaptive_nohz(void) { return false; }
>  static inline void cpuset_nohz_flush_cputimes(void) { }
> -
> +static inline bool nohz_cpu_exist(void) { return false; }
>  #endif /* CONFIG_CPUSETS_NO_HZ */
>
>  #endif /* _LINUX_CPUSET_H */
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 858217b..ccbaac9 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1231,6 +1231,11 @@ DEFINE_PER_CPU(int, cpu_adaptive_nohz_ref);
>
>  static cpumask_t nohz_cpuset_mask;
>
> +inline bool nohz_cpu_exist(void)
> +{
> +       return !cpumask_empty(&nohz_cpuset_mask);
> +}
> +
>  static void flush_cputime_interrupt(void *unused)
>  {
>         trace_printk("IPI: flush cputime\n");
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index bdc8aeb..e60d541 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -409,6 +409,25 @@ out:
>         return ret;
>  }
>
> +static inline bool must_take_timer_duty(int cpu)
> +{
> +       int handler = tick_do_timer_cpu;
> +       bool ret = false;
> +       bool tick_needed = nohz_cpu_exist();

Note this is racy because this fetches the value of the
nohz_cpuset_mask without locking.
We may "see" there is no nohz cpusets whereas we just set some of them
as nohz and they
could even have shut down their tick already.

> +
> +       /*
> +        * A CPU will have to take the timer duty if there is an adaptive
> +        * nohz CPU in the system. The last handler == cpu check ensures
> +        * that the last cpu that did the do_timer() sticks with the duty.
> +        * A normal (non nohz) cpu will take the charge from a nohz cpu in
> +        * tick_do_timer_check_handler anyway.
> +        */
> +       if (tick_needed && (handler == TICK_DO_TIMER_NONE || handler == cpu))
> +               ret = true;

This check is also racy due to the lack of locking. The previous
handler may have set TICK_DO_TIMER_NONE and gone to sleep. We have no
guarantee that the CPU can see that new value. It could believe there
is still a handler. This needs at least cmpxchg() to make the test and
set atomic.

> +
> +       return ret;
> +}
> +
>  static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>  {
>         /*
> @@ -421,6 +440,9 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>         if (unlikely(!cpu_online(cpu))) {
>                 if (cpu == tick_do_timer_cpu)
>                         tick_do_timer_cpu = TICK_DO_TIMER_NONE;
> +       } else if (must_take_timer_duty(cpu)) {
> +               tick_do_timer_cpu = cpu;
> +               return false;
>         }
>
>         if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
> @@ -512,6 +534,13 @@ void tick_nohz_idle_enter(void)
>  #ifdef CONFIG_CPUSETS_NO_HZ
>  static bool can_stop_adaptive_tick(void)
>  {
> +       int cpu = smp_processor_id();
> +
> +       if (must_take_timer_duty(cpu)) {
> +               tick_do_timer_cpu = cpu;
> +               return false;

One problem I see here is that you randomize the handler. It could be
an adaptive nohz CPU or an idle CPU. It's a problem if the user wants
CPU isolation.

I suggest to rather define a tunable timekeeping duty CPU affinity in
a cpumask file at /sys/devices/system/cpu/timekeeping and a toggle at
/sys/devices/system/cpu/cpuX/timekeeping (like the online file). This
way the user can decide whether adaptive nohz CPU can handle
timekeeping or this must be forced to other CPUs in order to enforce
isolation.

Concerning implementation details, a way to avoid locking while
ensuring there is always a CPU handling timekeeping is to define some
state machine through tick_do_timer_cpu values like the below
scenario:

* tick_do_timer_cpu = some CPU. In this case the timekeeping has a
running handler, everything is fine

* tick_do_timer_cpu = TICK_DO_TIMER_IDLE. The timekeeping handler
wants to go idle and stop its tick. He's going to keep its tick and
the timekeeping duty until some other CPU sees this value and sets
itself as the new handler. Then the previous handler can finally stop
its tick.

* tick_do_timer_cpu = TICK_DO_TIMER_NONE. There is no handler
currently. The next handler is the next CPU that will restart its
tick. This value is only possible if cpu_online_mask =
cpu_timekeeping_mask and there is no adaptive nohz running.

Does that look ok?

If so, tell me if you want to rework this patch with these
suggestions. Or I can do it, either way.

Thanks.
