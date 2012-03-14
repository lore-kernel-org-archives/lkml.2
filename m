Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab2CNVAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:00:00 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43916 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab2CNU76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:59:58 -0400
Date: Wed, 14 Mar 2012 13:59:44 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
Message-ID: <20120314205944.GQ27051@google.com>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus (dzickus@redhat.com) wrote:
> From: Michal Hocko <mhocko@suse.cz>
> 
> If the system is loaded while hotplugging a CPU we might end up with a bogus
> hardlockup detection. This has been seen during LTP pounder test executed
> in parallel with hotplug test.
> 
> The main problem is that enable_watchdog (called when CPU is brought up)
> registers perf event which periodically checks per-cpu counter
> (hrtimer_interrupts), updated from a hrtimer callback, but the hrtimer is fired
> from the kernel thread.
> 
> This means that while we already do check for the hard lockup the kernel thread
> might be sitting on the runqueue with zillions of tasks so there is nobody to
> update the value we rely on and so we KABOOM.
> 
> Let's fix this by boosting the watchdog thread priority before we wake it up
> rather than when it's already running.
> This still doesn't handle a case where we have the same amount of high prio
> FIFO tasks but that doesn't seem to be common. The current implementation
> doesn't handle that case anyway so this is not worse at least.
> 
> Unfortunately, we cannot start perf counter from the watchdog thread because we
> could miss a real lock up and also we cannot start the hrtimer watchdog_enable
> because we there is no way (at least I don't know any) to start a hrtimer from
> a different CPU.
> 
> [fix compile issue with param -dcz]
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mandeep Singh Baines <msb@chromium.org>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Reviewed-by: Mandeep Singh Baines <msb@chromium.org>

> ---
>  kernel/watchdog.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index d117262..6618cde 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -321,11 +321,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>   */
>  static int watchdog(void *unused)
>  {
> -	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> +	struct sched_param param = { .sched_priority = 0 };
>  	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
>  
> -	sched_setscheduler(current, SCHED_FIFO, &param);
> -
>  	/* initialize timestamp */
>  	__touch_watchdog();
>  
> @@ -350,7 +348,6 @@ static int watchdog(void *unused)
>  		set_current_state(TASK_INTERRUPTIBLE);
>  	}
>  	__set_current_state(TASK_RUNNING);
> -	param.sched_priority = 0;
>  	sched_setscheduler(current, SCHED_NORMAL, &param);
>  	return 0;
>  }
> @@ -439,6 +436,7 @@ static int watchdog_enable(int cpu)
>  
>  	/* create the watchdog thread */
>  	if (!p) {
> +		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
>  		p = kthread_create_on_node(watchdog, NULL, cpu_to_node(cpu), "watchdog/%d", cpu);
>  		if (IS_ERR(p)) {
>  			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
> @@ -450,6 +448,7 @@ static int watchdog_enable(int cpu)
>  			}
>  			goto out;
>  		}
> +		sched_setscheduler(p, SCHED_FIFO, &param);
>  		kthread_bind(p, cpu);
>  		per_cpu(watchdog_touch_ts, cpu) = 0;
>  		per_cpu(softlockup_watchdog, cpu) = p;
> -- 
> 1.7.7.6
> 
