Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab2KMAPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:15:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7060 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab2KMAPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:15:22 -0500
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5GM4hxtmu_IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=6uwSHAYG6wEA:10 a=-s1OEKRfaT0MLC4ILFMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352765720.18025.21.camel@gandalf.local.home>
Subject: Re: getnstimeofday stuck for several milliseconds?
From: Steven Rostedt <rostedt@goodmis.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: David Henningsson <david.henningsson@canonical.com>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Date: Mon, 12 Nov 2012 19:15:20 -0500
In-Reply-To: <50A18C0F.9000604@us.ibm.com>
References: <50977DF5.60703@canonical.com> <50A18C0F.9000604@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-12 at 15:53 -0800, John Stultz wrote:

> Cc'ing Steven to see if he can't help understand whats going on here.

I don't trust the trace...


The wake up happened on CPU 2

pulseaud-2106    2d...    1us :   2106:109:R   + [003]  2115: 94:S <...>
pulseaud-2106    2d...    2us+: try_to_wake_up <-default_wake_function


    Xorg-1278    3d... 1038us : __switch_to_xtra <-__switch_to
    Xorg-1278    3d... 1039us : memset <-__switch_to_xtra
kworker/-37      3d... 1040us : finish_task_switch <-__schedule
kworker/-37      3.... 1040us : _raw_spin_lock_irq <-worker_thread
kworker/-37      3d... 1041us : need_more_worker <-worker_thread
kworker/-37      3d... 1041us : process_one_work <-worker_thread
kworker/-37      3.... 1042us : __wake_up <-wakeup_work_handler

A millisecond goes by, Xorg is schedules out for kworker (which I'm sure
is also less in priority). And we don't see any sign of need resched
being set (N).

kworker/-37      3d... 1082us : pick_next_task_idle <-__schedule
  <idle>-0       3d... 1083us : finish_task_switch <-__schedule
  <idle>-0       3.... 1083us : tick_nohz_idle_enter <-cpu_idle
  <idle>-0       3.... 1084us : set_cpu_sd_state_idle <-tick_nohz_idle_enter
  <idle>-0       3d... 1084us : __tick_nohz_idle_enter <-tick_nohz_idle_enter

Idle is even scheduled in here!

  <idle>-0       3d.h. 9047us : ttwu_do_wakeup <-ttwu_do_activate.constprop.86
  <idle>-0       3d.h. 9048us : check_preempt_curr <-ttwu_do_wakeup
  <idle>-0       3d.h. 9049us : resched_task <-check_preempt_curr
  <idle>-0       3dNh. 9049us : task_woken_rt <-ttwu_do_wakeup
  <idle>-0       3dNh. 9050us : ttwu_stat <-try_to_wake_up
  <idle>-0       3dNh. 9050us : _raw_spin_unlock_irqrestore <-try_to_wake_up
  <idle>-0       3dNh. 9051us : _raw_spin_lock <-__run_hrtimer

During an interrupt (h), we see another wakeup (not sure what this was
for), and the need resched is set (N).

  <idle>-0       3dNh. 9053us : lapic_next_event <-clockevents_program_event
  <idle>-0       3dNh. 9054us : irq_exit <-smp_apic_timer_interrupt
  <idle>-0       3dN.. 9055us : idle_cpu <-irq_exit
  <idle>-0       3dN.. 9055us : rcu_irq_exit <-irq_exit
  <idle>-0       3dN.. 9056us : rcu_eqs_enter_common.isra.40 <-rcu_irq_exit
  <idle>-0       3dN.. 9056us : rcu_prepare_for_idle <-rcu_eqs_enter_common.isra.40
  <idle>-0       3.N.. 9057us : menu_reflect <-cpuidle_idle_call
  <idle>-0       3.N.. 9058us : rcu_idle_exit <-cpu_idle
  <idle>-0       3dN.. 9058us : rcu_eqs_exit_common.isra.38 <-rcu_idle_exit
  <idle>-0       3dN.. 9059us : rcu_cleanup_after_idle <-rcu_eqs_exit_common.isra.38
  <idle>-0       3dN.. 9059us : del_timer <-rcu_cleanup_after_idle
  <idle>-0       3.N.. 9060us : tick_nohz_idle_exit <-cpu_idle
  <idle>-0       3dN.. 9060us : ktime_get <-tick_nohz_idle_exit
  <idle>-0       3dN.. 9061us : tick_do_update_jiffies64 <-tick_nohz_idle_exit
  <idle>-0       3dN.. 9061us : update_cpu_load_nohz <-tick_nohz_idle_exit
  <idle>-0       3dN.. 9061us : calc_load_exit_idle <-tick_nohz_idle_exit
  <idle>-0       3dN.. 9062us : touch_softlockup_watchdog <-tick_nohz_idle_exit
  <idle>-0       3dN.. 9062us : tick_nohz_restart <-tick_nohz_idle_exit
  <idle>-0       3dN.. 9063us : hrtimer_cancel <-tick_nohz_restart
  <idle>-0       3dN.. 9063us : hrtimer_try_to_cancel <-hrtimer_cancel

We exit the interrupt and then do a lot of stuff with interrupts
disabled? Oh, this looks like the exit from idle (rcu_idle_exit is
there). It's doing clean up stuff here.


  <idle>-0       3dN.. 9077us : _pick_next_task_rt <-pick_next_task_rt
  <idle>-0       3dN.. 9078us : dequeue_pushable_task <-pick_next_task_rt
  <idle>-0       3d... 9079us : probe_wakeup_sched_switch <-__schedule
  <idle>-0       3d... 9079us :      0:120:R ==> [003]  2115: 94:R <...>

Finally our task is scheduled. But this looks all screwed up to me. I
bet the clocks are not in sync. Do a:

echo global > /sys/kernel/debug/tracing/trace_clock

and this will use a slower clock, but one that is in sync between CPUs.

Also, enable the sched_switch and sched_wakeup trace points too.

cd /sys/kernel/debug/tracing/events/sched
echo 1 > sched_wakeup/enable
echo 1 > sched_switch/enable

-- Steve


