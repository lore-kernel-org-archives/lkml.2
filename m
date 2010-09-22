Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab0IVPpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:45:06 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:37026 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0IVPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:45:05 -0400
Date: Thu, 23 Sep 2010 00:44:52 +0900
From: Norbert Preining <preining@logic.at>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>, "Li, Shaohua" <shaohua.li@intel.com>,
        tglx <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: high power consumption in recent kernels
Message-ID: <20100922154452.GA9080@gamma.logic.tuwien.ac.at>
References: <1284355277.26157.8109.camel@debian> <1284689374.17745.89.camel@debian> <1283840425.26157.6486.camel@debian> <20100909093140.GC29648@gamma.logic.tuwien.ac.at> <EA929A9653AAE14F841771FB1DE5A1366008738EC2@rrsmsx501.amr.corp.intel.com> <20100909205115.GD11053@gamma.logic.tuwien.ac.at> <1284107099.402.30.camel@laptop> <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com> <20100910145451.GB21450@gamma.logic.tuwien.ac.at> <1284355277.26157.8109.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284689374.17745.89.camel@debian> <1284355277.26157.8109.camel@debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex, hi all,

sorry for the long silence, I was on business travel and mountaineering
for some weeks.

On Mo, 13 Sep 2010, Alex,Shi wrote:
> > - revert the nohz patch (can you send me a patch for that)

I am now running 2.6.36-rc5 with this patch:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 1e2a6db..e66c52e 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -274,8 +274,14 @@ extern cpumask_var_t nohz_cpu_mask;
>  #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
>  extern void select_nohz_load_balancer(int stop_tick);
>  extern int get_nohz_timer_target(void);
> +extern int nohz_ratelimit(int cpu);
>  #else
>  static inline void select_nohz_load_balancer(int stop_tick) { }
> +static inline int nohz_ratelimit(int cpu)
> +{
> +       return 0;
> +}
> +
>  #endif
>  
>  /*
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ed09d4f..25399e7 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1182,6 +1182,17 @@ static void resched_task(struct task_struct *p)
>  		smp_send_reschedule(cpu);
>  }
>  
> +int nohz_ratelimit(int cpu)
> +{
> +       struct rq *rq = cpu_rq(cpu);
> +       u64 diff = rq->clock - rq->nohz_stamp;
> +
> +       rq->nohz_stamp = rq->clock;
> +
> +       return diff < (NSEC_PER_SEC / HZ) >> 1;
> +}
> +
> +
>  static void resched_cpu(int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 3e216e0..d6bca17 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -325,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidle)
>  	} while (read_seqretry(&xtime_lock, seq));
>  
>  	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
> -	    arch_needs_cpu(cpu)) {
> +	    arch_needs_cpu(cpu)|| nohz_ratelimit(cpu)) {
>  		next_jiffies = last_jiffies + 1;
>  		delta_jiffies = 1;
>  	} else {


and it seems that still works nicely. I am now running on battery power,
connected to the internet over bluetooth to my mobile, and get:
Wakeups-from-idle per second : 452.2    interval: 10.0s
Power usage (ACPI estimate): 12.4W (3.6 hours) (long term: 8.0W,/5.6h)

Top causes for wakeups:
  16.1% ( 79.5)   [yenta, ehci_hcd:usb2, uhci_hcd:usb6, uhci_hcd:usb7, uhci_hcd:
  14.3% ( 70.7)   [kernel scheduler] Load balancing tick
  14.1% ( 69.8)   [extra timer interrupt]
  13.1% ( 64.9)   kworker/0:0
  10.7% ( 53.0)   USB device  8-2 : BCM2046 Bluetooth Device (Broadcom Corp)
   8.4% ( 41.8)   [kernel core] hrtimer_start (tick_sched_timer)
   3.8% ( 19.0)   gnome-terminal
   2.9% ( 14.6)   icedove-bin
   2.2% ( 10.7)   PS/2 keyboard/mouse/touchpad interrupt

Which shows that the "Load balancing tick" and "extra timer interrupt" are
down to halfway normal levels. I guess when I shutdown the usb/bluetooth
connection both of them will drop even further.

> > - how to reduce the "extra timer interrupt"?
> The timer was listed in /proc/timer_stats, you can post its contents,
> and let's see what is abnormal here. 

Here is the output of /proc/timer_stats:

Timer Stats Version: v0.2
Sample period: 7.828 s
   66,  4378 firefox-bin      hrtimer_start_range_ns (hrtimer_wakeup)
   15, 12527 aptitude         hrtimer_start_range_ns (hrtimer_wakeup)
    8,  3629 cpufreq-applet   hrtimer_start_range_ns (hrtimer_wakeup)
  612,     0 swapper          hrtimer_start_range_ns (tick_sched_timer)
 483D,  6082 kworker/0:0      do_dbs_timer (delayed_work_timer_fn)
   17, 12527 aptitude         queue_delayed_work (delayed_work_timer_fn)
  376,     0 kworker/0:0      hrtimer_start_range_ns (tick_sched_timer)
 237D,  6810 kworker/1:1      do_dbs_timer (delayed_work_timer_fn)
   51,  7843 sakura           hrtimer_start_range_ns (hrtimer_wakeup)
    8,  2665 Xorg             queue_delayed_work (delayed_work_timer_fn)
  387,     0 swapper          hrtimer_start (tick_sched_timer)
   39,  3510 syndaemon        hrtimer_start_range_ns (hrtimer_wakeup)
    8,  2705 gpsd             hrtimer_start_range_ns (hrtimer_wakeup)
   32,     0 swapper          __mod_timer (rh_timer_func)
    8,  7572 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    8, 12916 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    8, 12949 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    8,  2080 apache2          hrtimer_start_range_ns (hrtimer_wakeup)
    8,  2795 ntpd             hrtimer_start_range_ns (posix_timer_fn)
   26,  3555 yarssr           hrtimer_start_range_ns (hrtimer_wakeup)
   91, 12790 sakura           hrtimer_start_range_ns (hrtimer_wakeup)
   15,  3583 multiload-apple  hrtimer_start_range_ns (hrtimer_wakeup)
    8,  4376 firefox-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    8,  7579 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
   8D,  6810 kworker/1:1      queue_delayed_work (delayed_work_timer_fn)
   4D,  6810 kworker/1:1      queue_delayed_work (delayed_work_timer_fn)
   8D,  6082 kworker/0:0      queue_delayed_work (delayed_work_timer_fn)
   4D,  6082 kworker/0:0      queue_delayed_work (delayed_work_timer_fn)
    8, 12895 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    4,  3516 udisks-daemon    hrtimer_start_range_ns (hrtimer_wakeup)
    4,  2642 hald-addon-stor  hrtimer_start_range_ns (hrtimer_wakeup)
    8,  7540 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    8,  7777 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    9,     0 kworker/0:0      hrtimer_start (tick_sched_timer)
    6,  2665 Xorg             __mod_timer (i915_hangcheck_elapsed)
    8,  7550 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    8,  3531 gvfs-afc-volume  hrtimer_start_range_ns (hrtimer_wakeup)
    7,  7551 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    7,  7549 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    7,  7578 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    1,     0 swapper          __mod_timer (uhci_fsbr_timeout)
    7,  7527 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    7, 12890 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    7,  7536 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
   18, 12790 sakura           hrtimer_start_range_ns (hrtimer_wakeup)
    4,  3582 sensors-applet   hrtimer_start_range_ns (hrtimer_wakeup)
    4,     0 swapper          __mod_timer (laptop_mode_timer_fn)
    4,     0 swapper          __mod_timer (dev_watchdog)
   11,  2868 tor              __mod_timer (process_timeout)
    5,  7528 icedove-bin      hrtimer_start_range_ns (hrtimer_wakeup)
    4,  4807 dropbox          hrtimer_start_range_ns (hrtimer_wakeup)
    1, 12537 http             __mod_timer (tcp_write_timer)
    5,  2825 nmbd             hrtimer_start_range_ns (hrtimer_wakeup)
    1,  3439 gconfd-2         hrtimer_start_range_ns (hrtimer_wakeup)
    4,  7403 kbnepd bnep0     __mod_timer (tcp_delack_timer)
    1,  3422 ssh-agent        hrtimer_start_range_ns (hrtimer_wakeup)
    1,  2195 hald             hrtimer_start_range_ns (hrtimer_wakeup)
    1,  2195 hald             __mod_timer (process_timeout)
    1,     7 watchdog/0       hrtimer_start (watchdog_timer_fn)
    1,  3444 gnome-power-man  hrtimer_start_range_ns (hrtimer_wakeup)
    3,   816 flush-8:0        __mod_timer (blk_unplug_timeout)
    1,     1 init             hrtimer_start_range_ns (hrtimer_wakeup)
    1,     1 swapper          enqueue_task_rt (sched_rt_period_timer)
   16, 12790 sakura           queue_delayed_work (delayed_work_timer_fn)
   14, 12791 bash             queue_delayed_work (delayed_work_timer_fn)
    5,  2665 Xorg             hrtimer_start_range_ns (hrtimer_wakeup)
    2,  3582 sensors-applet   __mod_timer (process_timeout)
    1,  3569 gnome-volume-ma  hrtimer_start_range_ns (hrtimer_wakeup)
    1,  2247 NetworkManager   hrtimer_start_range_ns (hrtimer_wakeup)
   1D,  6082 kworker/0:0      queue_delayed_work (delayed_work_timer_fn)
    1,  7403 kbnepd bnep0     __mod_timer (tcp_delack_timer)
    1,  2642 hald-addon-stor  __mod_timer (blk_rq_timed_out_timer)
    1,  4804 dropbox          __mod_timer (tcp_write_timer)
    1,  3511 gnome-panel      hrtimer_start_range_ns (hrtimer_wakeup)
2772 total events, 354.113 events/sec

Hope you can do something with it!

Let me know if I should do more testing.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
BERKHAMSTED
The massive three-course midmorning blow-out enjoyed by a dieter who
has already done his or her slimming duty by having a teaspoonful of
cottage cheese for breakfast.
			--- Douglas Adams, The Meaning of Liff
