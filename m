Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab0JKWn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:43:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754878Ab0JKWn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:43:58 -0400
Date: Mon, 11 Oct 2010 15:43:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix a complex race in hrtimer code.
Message-Id: <20101011154348.d3b24fa4.akpm@linux-foundation.org>
In-Reply-To: <20101008023356.6280.9969.stgit@dungbeetle.mtv.corp.google.com>
References: <20101008023356.6280.9969.stgit@dungbeetle.mtv.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Oct 2010 19:33:56 -0700
Salman Qazi <sqazi@google.com> wrote:

> The race is described as follows:
> 
> CPU X                                 CPU Y
> remove_hrtimer
> // state & QUEUED == 0
> timer->state = CALLBACK
> unlock timer base
> timer->f(n) //very long
>                                   hrtimer_start
>                                     lock timer base
>                                     remove_hrtimer // no effect
>                                     hrtimer_enqueue
>                                     timer->state = CALLBACK |
>                                                    QUEUED
>                                     unlock timer base
>                                   hrtimer_start
>                                     lock timer base
>                                     remove_hrtimer
>                                         mode = INACTIVE
>                                         // CALLBACK bit lost!
>                                     switch_hrtimer_base
>                                             CALLBACK bit not set:
>                                                     timer->base
>                                                     changes to a
>                                                     different CPU.
> lock this CPU's timer base
> 
> Bug reproducible and fix testable using a kernel module that hrtimer_start()s
> a timer with a very long running callback from multiple CPUs:
> 
> MODULE_LICENSE("GPL");
> 
> static long timer_func_time = 1000;
> module_param(timer_func_time, long, 0600);
> static long timer_starts = 2500;
> module_param(timer_starts, long, 0600);
> static long timer_expire = 1000;
> module_param(timer_expire, long, 0600);
> 
> DEFINE_PER_CPU(struct task_struct *, hrtimer_thread);
> 
> /* There are other issues, like deadlocks between multiple hrtimer_start observed
>  * calls, at least in 2.6.34 that this lock works around.  Will look into
>  * those later.
>  */
> static DEFINE_SPINLOCK(blah_lock);
> 
> static ktime_t mytime;
> static struct hrtimer timer;
> 
> static enum hrtimer_restart timer_restart(struct hrtimer *timer)
> {
>         unsigned long i;
>         /* We have to make the callback longer to improve the
>          * probability of having a race.
>          */
>         for (i = 0; i < timer_func_time / 100; i++) {
>                 touch_nmi_watchdog();
>                 touch_softlockup_watchdog();
>                 udelay(100);
>         }
> 
>         return HRTIMER_NORESTART;
> }
> 
> static int restart_hrtimer_repeatedly(void *input)
> {
>         int i;
>         unsigned long range;
>         while (!kthread_should_stop()) {
>                 for (i = 0; i < timer_starts; i++) {
>                         /* Avoid deadlocks for now */
>                         spin_lock(&blah_lock);
>                         hrtimer_start(&timer, mytime, HRTIMER_MODE_REL);
>                         spin_unlock(&blah_lock);
>                         touch_nmi_watchdog();
>                         touch_softlockup_watchdog();
>                 }
>                 cond_resched();
>         }
>         hrtimer_cancel(&timer);
>         return 0;
> }
> 
> static int hrtimer_unit_test_init(void)
> {
>         int cpu;
>         mytime = ktime_set(0, 0);
>         mytime = ktime_add_ns(mytime, timer_expire);
>         hrtimer_init(&timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>         timer.function = timer_restart;
>         for_each_online_cpu(cpu) {
>                 per_cpu(hrtimer_thread, cpu) = kthread_create(
>                         restart_hrtimer_repeatedly, NULL, "hrtimer_test/%d",
>                         cpu);
>                 if (IS_ERR(per_cpu(hrtimer_thread, cpu))) {
>                        printk(KERN_ERR
>                                 "Failed to create hrtimer test thread\n");
>                         BUG();
>                 }
>                 kthread_bind(per_cpu(hrtimer_thread, cpu), cpu);
>                 wake_up_process(per_cpu(hrtimer_thread, cpu));
>         }
>         return 0;
> }
> 
> static void hrtimer_unit_test_exit(void)
> {
>         int cpu;
>         for_each_online_cpu(cpu) {
>                 (void)kthread_stop(per_cpu(hrtimer_thread, cpu));
>         }
> }
> 
> module_init(hrtimer_unit_test_init);
> module_exit(hrtimer_unit_test_exit);
> ---
>  kernel/hrtimer.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 1decafb..4769c51 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -944,8 +944,8 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
>  		debug_deactivate(timer);
>  		timer_stats_hrtimer_clear_start_info(timer);
>  		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
> -		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
> -				 reprogram);
> +		__remove_hrtimer(timer, base,
> +				 (timer->state & HRTIMER_STATE_CALLBACK), reprogram);
>  		return 1;
>  	}
>  	return 0;
> @@ -1231,6 +1231,9 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
>  		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
>  		enqueue_hrtimer(timer, base);
>  	}
> +
> +	BUG_ON(!(timer->state & HRTIMER_STATE_CALLBACK));
> +
>  	timer->state &= ~HRTIMER_STATE_CALLBACK;
>  }

I worry about the BUG_ON(), especially if we're going to put this into
2.6.36 and -stable (as we probably should).  If it triggers
unexpectedly, we just made a big mess.

It's generally better to use a non-fatal assertion, often a
triggers-once one (WARN_ON_ONCE()).  That way our mistake doesn't result in
killing people's machines or flooding their logs.

The one case where BUG_ON() _is_ justified is when we expect that the
kernel is utterly hosed, perhaps to the point of corrupting user data
or application results.

Another downside of using BUG_ON() is that it makes the problem harder
to solve: often the user's box is now dead, sometimes to the point that
the trace didn't even get into the log files.  The user cannot get
control of the machine to have a look in /proc files or anything else. 
We really did shoot our foot off.


Poeple are using BUG waaaaay too often.
