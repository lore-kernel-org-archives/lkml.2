Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2AWQ5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:57:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33633 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2AWQ5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:57:42 -0500
MIME-Version: 1.0
In-Reply-To: <1327333258-20734-1-git-send-email-dmitry.antipov@linaro.org>
References: <1327333258-20734-1-git-send-email-dmitry.antipov@linaro.org>
Date: Mon, 23 Jan 2012 18:57:41 +0200
Message-ID: <CAP245DWRwaiPyPq1m6eNGWdxBd9vCZ3sJ0sejS4Jevps=NEgZw@mail.gmail.com>
Subject: Re: [PATCH] hrtimers, timers: eliminate some jiffies-backed code
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Cc: Steve Glendinning <steve.glendinning@smsc.com>,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Thomas since he is maintainer of hrtimers and John since he
knows a bit about timekeeping. :)

On Mon, Jan 23, 2012 at 5:40 PM, Dmitry Antipov
<dmitry.antipov@linaro.org> wrote:
> This patch provides an attempt to get away from jiffies in msleep()
> and msleep_interruptible() to hrtimers-backed usleep_range() and
> usleep_range_interruptible(). Both of the latter now returns an amount
> of microseconds really spent in sleep; another rationale for this
> was to convert msleep()-based wait-for-hardware loops to usleep_range(),
> like this:
>
> unsigned long timeout = jiffies + msecs_to_jiffies(1000);
> while (hw_is_not_ready()) {
>        if (time_after(jiffies, timeout))
>                return -ETIMEDOUT;
>        msleep(1);
> }
>
> to:
>
> unsigned long timeout = 0;
> while (hw_is_not_ready()) {
>      if (timeout > USEC_PER_SEC)
>              return -ETIMEDOUT;
>      timeout += usleep_range(500, 1500);
> }
>
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
> ---
>  fs/eventpoll.c          |    3 ++-
>  fs/select.c             |    3 ++-
>  include/linux/delay.h   |    3 ++-
>  include/linux/hrtimer.h |    8 +++++---
>  ipc/mqueue.c            |    4 ++--
>  kernel/hrtimer.c        |   38 +++++++++++++++++++++++++++++++-------
>  kernel/timer.c          |   39 +++++++++++++++++++++++++--------------
>  7 files changed, 69 insertions(+), 29 deletions(-)
>
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index aabdfc3..a374944 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1349,7 +1349,8 @@ fetch_events:
>                        }
>
>                        spin_unlock_irqrestore(&ep->lock, flags);
> -                       if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
> +                       if (!schedule_hrtimeout_range(to, NULL, slack,
> +                                                     HRTIMER_MODE_ABS))
>                                timed_out = 1;
>
>                        spin_lock_irqsave(&ep->lock, flags);
> diff --git a/fs/select.c b/fs/select.c
> index d33418f..b4354b2 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -236,7 +236,8 @@ int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
>
>        set_current_state(state);
>        if (!pwq->triggered)
> -               rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
> +               rc = schedule_hrtimeout_range(expires, NULL, slack,
> +                                             HRTIMER_MODE_ABS);
>        __set_current_state(TASK_RUNNING);
>
>        /*
> diff --git a/include/linux/delay.h b/include/linux/delay.h
> index a6ecb34..bad6d49 100644
> --- a/include/linux/delay.h
> +++ b/include/linux/delay.h
> @@ -45,7 +45,8 @@ extern unsigned long lpj_fine;
>  void calibrate_delay(void);
>  void msleep(unsigned int msecs);
>  unsigned long msleep_interruptible(unsigned int msecs);
> -void usleep_range(unsigned long min, unsigned long max);
> +unsigned long usleep_range(unsigned long min, unsigned long max);
> +unsigned long usleep_range_interruptible(unsigned long min, unsigned long max);
>
>  static inline void ssleep(unsigned int seconds)
>  {
> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index fd0dc30..01d782b 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -126,6 +126,7 @@ struct hrtimer {
>  * task is set to NULL, when the timer expires.
>  */
>  struct hrtimer_sleeper {
> +       ktime_t kt;
>        struct hrtimer timer;
>        struct task_struct *task;
>  };
> @@ -428,9 +429,10 @@ extern long hrtimer_nanosleep_restart(struct restart_block *restart_block);
>  extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
>                                 struct task_struct *tsk);
>
> -extern int schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
> -                                               const enum hrtimer_mode mode);
> -extern int schedule_hrtimeout_range_clock(ktime_t *expires,
> +extern int schedule_hrtimeout_range(ktime_t *expires, ktime_t *elapsed,
> +                                   unsigned long delta,
> +                                   const enum hrtimer_mode mode);
> +extern int schedule_hrtimeout_range_clock(ktime_t *expires, ktime_t *elapsed,
>                unsigned long delta, const enum hrtimer_mode mode, int clock);
>  extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
>
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 9b7c8ab..e57d7c1 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -449,8 +449,8 @@ static int wq_sleep(struct mqueue_inode_info *info, int sr,
>                set_current_state(TASK_INTERRUPTIBLE);
>
>                spin_unlock(&info->lock);
> -               time = schedule_hrtimeout_range_clock(timeout, 0,
> -                       HRTIMER_MODE_ABS, CLOCK_REALTIME);
> +               time = schedule_hrtimeout_range_clock(timeout, NULL,
> +                       0, HRTIMER_MODE_ABS, CLOCK_REALTIME);
>
>                while (ewp->state == STATE_PENDING)
>                        cpu_relax();
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index ae34bf5..8642c3f 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1475,6 +1475,12 @@ static enum hrtimer_restart hrtimer_wakeup(struct hrtimer *timer)
>        struct hrtimer_sleeper *t =
>                container_of(timer, struct hrtimer_sleeper, timer);
>        struct task_struct *task = t->task;
> +       struct hrtimer_clock_base *base;
> +       unsigned long flags;
> +
> +       base = lock_hrtimer_base(timer, &flags);
> +       t->kt = ktime_sub(base->get_time(), t->kt);
> +       unlock_hrtimer_base(timer, &flags);
>
>        t->task = NULL;
>        if (task)
> @@ -1485,6 +1491,13 @@ static enum hrtimer_restart hrtimer_wakeup(struct hrtimer *timer)
>
>  void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
>  {
> +       struct hrtimer_clock_base *base;
> +       unsigned long flags;
> +
> +       base = lock_hrtimer_base(&sl->timer, &flags);
> +       sl->kt = base->get_time();
> +       unlock_hrtimer_base(&sl->timer, &flags);
> +
>        sl->timer.function = hrtimer_wakeup;
>        sl->task = task;
>  }
> @@ -1747,12 +1760,14 @@ void __init hrtimers_init(void)
>  /**
>  * schedule_hrtimeout_range_clock - sleep until timeout
>  * @expires:   timeout value (ktime_t)
> + * @elapsed:   pointer to ktime_t used to save time spent in sleep
>  * @delta:     slack in expires timeout (ktime_t)
>  * @mode:      timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
>  * @clock:     timer clock, CLOCK_MONOTONIC or CLOCK_REALTIME
>  */
>  int __sched
> -schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
> +schedule_hrtimeout_range_clock(ktime_t *expires, ktime_t *elapsed,
> +                              unsigned long delta,
>                               const enum hrtimer_mode mode, int clock)
>  {
>        struct hrtimer_sleeper t;
> @@ -1763,6 +1778,8 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
>         */
>        if (expires && !expires->tv64) {
>                __set_current_state(TASK_RUNNING);
> +               if (elapsed)
> +                       *elapsed = ktime_set(0, 0);
>                return 0;
>        }
>
> @@ -1772,6 +1789,8 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
>        if (!expires) {
>                schedule();
>                __set_current_state(TASK_RUNNING);
> +               if (elapsed)
> +                       *elapsed = ktime_set(KTIME_SEC_MAX, 0);
>                return -EINTR;
>        }
>
> @@ -1787,6 +1806,9 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
>        if (likely(t.task))
>                schedule();
>
> +       if (elapsed)
> +               *elapsed = t.kt;
> +
>        hrtimer_cancel(&t.timer);
>        destroy_hrtimer_on_stack(&t.timer);
>
> @@ -1798,6 +1820,7 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
>  /**
>  * schedule_hrtimeout_range - sleep until timeout
>  * @expires:   timeout value (ktime_t)
> + * @elapsed:   pointer to ktime_t used to save time spent in sleep
>  * @delta:     slack in expires timeout (ktime_t)
>  * @mode:      timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
>  *
> @@ -1823,17 +1846,19 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
>  *
>  * Returns 0 when the timer has expired otherwise -EINTR
>  */
> -int __sched schedule_hrtimeout_range(ktime_t *expires, unsigned long delta,
> +int __sched schedule_hrtimeout_range(ktime_t *expires, ktime_t *elapsed,
> +                                    unsigned long delta,
>                                     const enum hrtimer_mode mode)
>  {
> -       return schedule_hrtimeout_range_clock(expires, delta, mode,
> -                                             CLOCK_MONOTONIC);
> +       return schedule_hrtimeout_range_clock(expires, elapsed, delta,
> +                                             mode, CLOCK_MONOTONIC);
>  }
>  EXPORT_SYMBOL_GPL(schedule_hrtimeout_range);
>
>  /**
>  * schedule_hrtimeout - sleep until timeout
>  * @expires:   timeout value (ktime_t)
> + * @elapsed:   pointer to ktime_t used to save time spent in sleep
>  * @mode:      timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL
>  *
>  * Make the current task sleep until the given expiry time has
> @@ -1853,9 +1878,8 @@ EXPORT_SYMBOL_GPL(schedule_hrtimeout_range);
>  *
>  * Returns 0 when the timer has expired otherwise -EINTR
>  */
> -int __sched schedule_hrtimeout(ktime_t *expires,
> -                              const enum hrtimer_mode mode)
> +int __sched schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode)
>  {
> -       return schedule_hrtimeout_range(expires, 0, mode);
> +       return schedule_hrtimeout_range(expires, NULL, 0, mode);
>  }
>  EXPORT_SYMBOL_GPL(schedule_hrtimeout);
> diff --git a/kernel/timer.c b/kernel/timer.c
> index a297ffc..00acab6 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1796,12 +1796,12 @@ void __init init_timers(void)
>  */
>  void msleep(unsigned int msecs)
>  {
> -       unsigned long timeout = msecs_to_jiffies(msecs) + 1;
> +       unsigned long usecs = msecs * USEC_PER_MSEC;
> +       unsigned long slack = rt_task(current) ? 0 :
> +               current->timer_slack_ns / NSEC_PER_USEC;
>
> -       while (timeout)
> -               timeout = schedule_timeout_uninterruptible(timeout);
> +       usleep_range(usecs, usecs + slack);
>  }
> -
>  EXPORT_SYMBOL(msleep);
>
>  /**
> @@ -1810,23 +1810,27 @@ EXPORT_SYMBOL(msleep);
>  */
>  unsigned long msleep_interruptible(unsigned int msecs)
>  {
> -       unsigned long timeout = msecs_to_jiffies(msecs) + 1;
> +       unsigned long timeout, usecs, slack;
>
> -       while (timeout && !signal_pending(current))
> -               timeout = schedule_timeout_interruptible(timeout);
> -       return jiffies_to_msecs(timeout);
> -}
> +       timeout = 0;
> +       usecs = msecs * USEC_PER_MSEC;
> +       slack = rt_task(current) ? 0 : current->timer_slack_ns / NSEC_PER_USEC;
>
> +       while (timeout < usecs && !signal_pending(current))
> +               timeout += usleep_range_interruptible(usecs, usecs + slack);
> +       return timeout / USEC_PER_MSEC;
> +}
>  EXPORT_SYMBOL(msleep_interruptible);
>
> -static int __sched do_usleep_range(unsigned long min, unsigned long max)
> +static inline unsigned long do_usleep_range(unsigned long min, unsigned long max)
>  {
> -       ktime_t kmin;
> +       ktime_t kmin, elapsed;
>        unsigned long delta;
>
>        kmin = ktime_set(0, min * NSEC_PER_USEC);
>        delta = (max - min) * NSEC_PER_USEC;
> -       return schedule_hrtimeout_range(&kmin, delta, HRTIMER_MODE_REL);
> +       return schedule_hrtimeout_range(&kmin, &elapsed, delta, HRTIMER_MODE_REL)
> +               ? 0 : ktime_to_us(elapsed);
>  }
>
>  /**
> @@ -1834,9 +1838,16 @@ static int __sched do_usleep_range(unsigned long min, unsigned long max)
>  * @min: Minimum time in usecs to sleep
>  * @max: Maximum time in usecs to sleep
>  */
> -void usleep_range(unsigned long min, unsigned long max)
> +unsigned long usleep_range(unsigned long min, unsigned long max)
>  {
>        __set_current_state(TASK_UNINTERRUPTIBLE);
> -       do_usleep_range(min, max);
> +       return do_usleep_range(min, max);
>  }
>  EXPORT_SYMBOL(usleep_range);
> +
> +unsigned long usleep_range_interruptible(unsigned long min, unsigned long max)
> +{
> +       __set_current_state(TASK_INTERRUPTIBLE);
> +       return do_usleep_range(min, max);
> +}
> +EXPORT_SYMBOL(usleep_range_interruptible);
> --
> 1.7.7.5
>
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
