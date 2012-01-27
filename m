Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab2A0LuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:50:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35079 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab2A0LuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:50:11 -0500
MIME-Version: 1.0
In-Reply-To: <1327660258-27544-1-git-send-email-dmitry.antipov@linaro.org>
References: <1327660258-27544-1-git-send-email-dmitry.antipov@linaro.org>
Date: Fri, 27 Jan 2012 13:50:10 +0200
Message-ID: <CAHLCerPMLLp+YPiFmQrv1qpUF3EC7Fkdf2x0U+LE8YO21spKug@mail.gmail.com>
Subject: Re: [PATCH] hrtimers: move default_timer_slack_ns to system-wide sysctl
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On Fri, Jan 27, 2012 at 12:30 PM, Dmitry Antipov
<dmitry.antipov@linaro.org> wrote:
>  - moving default_timer_slack_ns from per-task field to global variable
>   controlled via sysctl() in [0..1000000] range (usecs) provides some
>   more system-wide control beyond per-task prctl();

What benefits do I get from this change? In other words, don't just
describe the change, please describe why it is desirable.

Have you done any tests where this improves things - reduction in
wakeups, increase in throughput? Those results will also help in
getting more attention on the patch.

>  - task_time_slack() should be used to get default timer slack if no
>   special requirements exists.
>
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
> ---
>  include/linux/hrtimer.h |    1 +
>  include/linux/sched.h   |   11 ++++++++---
>  kernel/fork.c           |    3 ---
>  kernel/futex.c          |    4 ++--
>  kernel/hrtimer.c        |   10 +++++++---
>  kernel/sys.c            |    3 ++-
>  kernel/sysctl.c         |   10 ++++++++++
>  7 files changed, 30 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index fd0dc30..855d45e 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -323,6 +323,7 @@ extern ktime_t ktime_get_monotonic_offset(void);
>
>  DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
>
> +extern int default_timer_slack_ns;
>
>  /* Exported timer functions: */
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 2234985..4f475aa 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1551,11 +1551,11 @@ struct task_struct {
>        struct latency_record latency_record[LT_SAVECOUNT];
>  #endif
>        /*
> -        * time slack values; these are used to round up poll() and
> -        * select() etc timeout values. These are in nanoseconds.
> +        * High-resolution timer slack value, in nanoseconds.
> +        * Used to round up poll()/select(), nanosleep, futex
> +        * waiting, etc. timeout values for non-realtime tasks.
>         */
>        unsigned long timer_slack_ns;
> -       unsigned long default_timer_slack_ns;
>
>        struct list_head        *scm_work_list;
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> @@ -2622,6 +2622,11 @@ static inline int spin_needbreak(spinlock_t *lock)
>  #endif
>  }
>
> +static inline unsigned long task_timer_slack(struct task_struct *tsk)
> +{
> +       return rt_task(tsk) ? 0 : tsk->timer_slack_ns;
> +}
> +
>  /*
>  * Thread group CPU time accounting.
>  */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 051f090..b0e8f63 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1144,9 +1144,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  #if defined(SPLIT_RSS_COUNTING)
>        memset(&p->rss_stat, 0, sizeof(p->rss_stat));
>  #endif
> -
> -       p->default_timer_slack_ns = current->timer_slack_ns;
> -
>        task_io_accounting_init(&p->ioac);
>        acct_clear_integrals(p);
>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 1614be2..a0d302d 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1887,7 +1887,7 @@ static int futex_wait(u32 __user *uaddr, unsigned int flags, u32 val,
>                                      HRTIMER_MODE_ABS);
>                hrtimer_init_sleeper(to, current);
>                hrtimer_set_expires_range_ns(&to->timer, *abs_time,
> -                                            current->timer_slack_ns);
> +                                            task_timer_slack(current));
>        }
>
>  retry:
> @@ -2281,7 +2281,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
>                                      HRTIMER_MODE_ABS);
>                hrtimer_init_sleeper(to, current);
>                hrtimer_set_expires_range_ns(&to->timer, *abs_time,
> -                                            current->timer_slack_ns);
> +                                            task_timer_slack(current));
>        }
>
>        /*
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index ae34bf5..0704559 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -51,6 +51,12 @@
>  #include <trace/events/timer.h>
>
>  /*
> + * Default hrtimer slack value, in nanoseconds. May be
> + * changed via sysctl within [0..1000000] range.
> + */
> +int default_timer_slack_ns = 50000;
> +
> +/*
>  * The timer bases:
>  *
>  * There are more clockids then hrtimer bases. Thus, we index
> @@ -1564,9 +1570,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
>        int ret = 0;
>        unsigned long slack;
>
> -       slack = current->timer_slack_ns;
> -       if (rt_task(current))
> -               slack = 0;
> +       slack = task_timer_slack(current);
>
>        hrtimer_init_on_stack(&t.timer, clockid, mode);
>        hrtimer_set_expires_range_ns(&t.timer, timespec_to_ktime(*rqtp), slack);
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 4070153..db36543 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -22,6 +22,7 @@
>  #include <linux/device.h>
>  #include <linux/key.h>
>  #include <linux/times.h>
> +#include <linux/hrtimer.h>
>  #include <linux/posix-timers.h>
>  #include <linux/security.h>
>  #include <linux/dcookies.h>
> @@ -1919,7 +1920,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>                case PR_SET_TIMERSLACK:
>                        if (arg2 <= 0)
>                                current->timer_slack_ns =
> -                                       current->default_timer_slack_ns;
> +                                       default_timer_slack_ns;
>                        else
>                                current->timer_slack_ns = arg2;
>                        error = 0;
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index f487f25..c9a731b 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -122,6 +122,7 @@ static int __maybe_unused two = 2;
>  static int __maybe_unused three = 3;
>  static unsigned long one_ul = 1;
>  static int one_hundred = 100;
> +static int million = 1000000;
>  #ifdef CONFIG_PRINTK
>  static int ten_thousand = 10000;
>  #endif
> @@ -1004,6 +1005,15 @@ static struct ctl_table kern_table[] = {
>                .proc_handler   = proc_dointvec,
>        },
>  #endif
> +       {
> +               .procname       = "timer_slack",
> +               .data           = &default_timer_slack_ns,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = proc_dointvec_minmax,
> +               .extra1         = &zero,
> +               .extra2         = &million,
> +       },
>        { }
>  };
>
> --
> 1.7.7.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
