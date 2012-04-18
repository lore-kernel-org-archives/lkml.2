Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2DRNUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:20:13 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:56935 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816Ab2DRNUL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:20:11 -0400
MIME-Version: 1.0
In-Reply-To: <tip-b435092f70ec5ebbfb6d075d5bf3c631b49a51de@git.kernel.org>
References: <alpine.LFD.2.02.1204181205540.2542@ionos> <tip-b435092f70ec5ebbfb6d075d5bf3c631b49a51de@git.kernel.org>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Wed, 18 Apr 2012 18:49:46 +0530
Message-ID: <CAMQu2gx4-4kbgEHXUbU0SR=Xj6pe5FxjYJJ_dZD5D=jZs7f03A@mail.gmail.com>
Subject: Re: [tip:timers/urgent] tick: Fix oneshot broadcast setup really
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, suresh.b.siddha@intel.com,
        svenjoac@gmx.de, tglx@linutronix.de, rjw@sisk.pl
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 5:37 PM, tip-bot for Thomas Gleixner
<tglx@linutronix.de> wrote:
> Commit-ID:  b435092f70ec5ebbfb6d075d5bf3c631b49a51de
> Gitweb:     http://git.kernel.org/tip/b435092f70ec5ebbfb6d075d5bf3c631b49a51de
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Wed, 18 Apr 2012 12:08:23 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 18 Apr 2012 14:00:56 +0200
>
> tick: Fix oneshot broadcast setup really
>
> Sven Joachim reported, that suspend/resume on rc3 trips over a NULL
> pointer dereference. Linus spotted the clockevent handler being NULL.
>
> commit fa4da365b(clockevents: tTack broadcast device mode change in
> tick_broadcast_switch_to_oneshot()) tried to fix a problem with the
> broadcast device setup, which was introduced in commit 77b0d60c5(
> clockevents: Leave the broadcast device in shutdown mode when not
> needed).
>
> The initial commit avoided to set up the broadcast device when no
> broadcast request bits were set, but that left the broadcast device
> disfunctional. In consequence deep idle states which need the
> broadcast device were not woken up.
>
> commit fa4da365b tried to fix that by initializing the state of the
> broadcast facility, but that missed the fact, that nothing initializes
> the event handler and some other state of the underlying clock event
> device.
>
> The fix is to revert both commits and make only the mode setting of
> the clock event device conditional on the state of active broadcast
> users.
>
> That initializes everything except the low level device mode, but this
> happens when the broadcast functionality is invoked by deep idle.
>
> Reported-and-tested-by: Sven Joachim <svenjoac@gmx.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1204181205540.2542@ionos
>
> ---
>  kernel/time/tick-broadcast.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index bf57abd..119aca5 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -531,7 +531,6 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
>                int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
>
>                bc->event_handler = tick_handle_oneshot_broadcast;
> -               clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
>
>                /* Take the do_timer update */
>                tick_do_timer_cpu = cpu;
> @@ -549,6 +548,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
>                           to_cpumask(tmpmask));
>
>                if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
> +                       clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
>                        tick_broadcast_init_next_event(to_cpumask(tmpmask),
>                                                       tick_next_period);
>                        tick_broadcast_set_event(tick_next_period, 1);
> @@ -577,15 +577,10 @@ void tick_broadcast_switch_to_oneshot(void)
>        raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
>
>        tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
> -
> -       if (cpumask_empty(tick_get_broadcast_mask()))
> -               goto end;
> -
>        bc = tick_broadcast_device.evtdev;
>        if (bc)
>                tick_broadcast_setup_oneshot(bc);
>
> -end:
>        raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
>  }
>
I tried this patch with OMAP4 idle driver. I am observing
regression with the patch. Broad-cast interrupts are not
firing anymore and I get also get a dump(end of the meail).
Have not debugged it yet but though of reporting it. I quickly tried
undoing the "clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT)"
movement change in this patch and that seems to make idle
happy again.

Regards
Santosh

#
INFO: rcu_sched self-detected stall on CPU
INFO: rcu_sched self-detected stall on CPU { 0}  (t=12509 jiffies)
[<c001bbe4>] (unwind_backtrace+0x0/0xf4) from [<c00a5da8>]
(__rcu_pending+0x158/0x45c)
[<c00a5da8>] (__rcu_pending+0x158/0x45c) from [<c00a611c>]
(rcu_check_callbacks+0x70/0x1ac)
[<c00a611c>] (rcu_check_callbacks+0x70/0x1ac) from [<c004f0d4>]
(update_process_times+0x38/0x68)
[<c004f0d4>] (update_process_times+0x38/0x68) from [<c0086c94>]
(tick_sched_timer+0x88/0xd8)
[<c0086c94>] (tick_sched_timer+0x88/0xd8) from [<c0064bb8>]
(__run_hrtimer+0x7c/0x1e0)
[<c0064bb8>] (__run_hrtimer+0x7c/0x1e0) from [<c0064f88>]
(hrtimer_interrupt+0x108/0x294)
[<c0064f88>] (hrtimer_interrupt+0x108/0x294) from [<c001a34c>]
(twd_handler+0x34/0x40)
[<c001a34c>] (twd_handler+0x34/0x40) from [<c00a0818>]
(handle_percpu_devid_irq+0x8c/0x138)
[<c00a0818>] (handle_percpu_devid_irq+0x8c/0x138) from [<c009d8a0>]
(generic_handle_irq+0x34/0x44)
[<c009d8a0>] (generic_handle_irq+0x34/0x44) from [<c00151cc>]
(handle_IRQ+0x4c/0xac)
[<c00151cc>] (handle_IRQ+0x4c/0xac) from [<c0008480>] (gic_handle_irq+0x2c/0x60)
[<c0008480>] (gic_handle_irq+0x2c/0x60) from [<c04761e4>] (__irq_svc+0x44/0x60)
Exception stack(0xc0677ea8 to 0xc0677ef0)
7ea0:                   00007930 00000001 00000000 c0698600 c125b5d8 00000002
7ec0: 00000002 c069b95c 2952ac61 00000003 ea4b27e0 00000019 00000001 c0677ef0
7ee0: 00007931 c0371c18 20000113 ffffffff
[<c04761e4>] (__irq_svc+0x44/0x60) from [<c0371c18>]
(cpuidle_wrap_enter+0x4c/0xa0)
[<c0371c18>] (cpuidle_wrap_enter+0x4c/0xa0) from [<c0371648>]
(cpuidle_enter_state+0x14/0x70)
[<c0371648>] (cpuidle_enter_state+0x14/0x70) from [<c0375d84>]
(cpuidle_enter_state_coupled+0x358/0x900)
[<c0375d84>] (cpuidle_enter_state_coupled+0x358/0x900) from
[<c0371e3c>] (cpuidle_idle_call+0xdc/0x29c)
[<c0371e3c>] (cpuidle_idle_call+0xdc/0x29c) from [<c0015bf4>]
(cpu_idle+0x98/0x124)
[<c0015bf4>] (cpu_idle+0x98/0x124) from [<c06258cc>] (start_kernel+0x2bc/0x310)
 { 1}  (t=12536 jiffies)
[<c001bbe4>] (unwind_backtrace+0x0/0xf4) from [<c00a5da8>]
(__rcu_pending+0x158/0x45c)
[<c00a5da8>] (__rcu_pending+0x158/0x45c) from [<c00a611c>]
(rcu_check_callbacks+0x70/0x1ac)
[<c00a611c>] (rcu_check_callbacks+0x70/0x1ac) from [<c004f0d4>]
(update_process_times+0x38/0x68)
[<c004f0d4>] (update_process_times+0x38/0x68) from [<c0086c94>]
(tick_sched_timer+0x88/0xd8)
[<c0086c94>] (tick_sched_timer+0x88/0xd8) from [<c0064bb8>]
(__run_hrtimer+0x7c/0x1e0)
[<c0064bb8>] (__run_hrtimer+0x7c/0x1e0) from [<c0064f88>]
(hrtimer_interrupt+0x108/0x294)
[<c0064f88>] (hrtimer_interrupt+0x108/0x294) from [<c001a34c>]
(twd_handler+0x34/0x40)
[<c001a34c>] (twd_handler+0x34/0x40) from [<c00a0818>]
(handle_percpu_devid_irq+0x8c/0x138)
[<c00a0818>] (handle_percpu_devid_irq+0x8c/0x138) from [<c009d8a0>]
(generic_handle_irq+0x34/0x44)
[<c009d8a0>] (generic_handle_irq+0x34/0x44) from [<c00151cc>]
(handle_IRQ+0x4c/0xac)
[<c00151cc>] (handle_IRQ+0x4c/0xac) from [<c0008480>] (gic_handle_irq+0x2c/0x60)
[<c0008480>] (gic_handle_irq+0x2c/0x60) from [<c04761e4>] (__irq_svc+0x44/0x60)
Exception stack(0xef075ed8 to 0xef075f20)
5ec0:                                                       0000aedb 00000001
5ee0: 00000000 ef073480 c12645d8 00000002 00000002 c069b95c 2952ac61 00000003
5f00: ea4b27e0 00000019 00000001 ef075f20 0000aedc c0371c18 20000113 ffffffff
[<c04761e4>] (__irq_svc+0x44/0x60) from [<c0371c18>]
(cpuidle_wrap_enter+0x4c/0xa0)
[<c0371c18>] (cpuidle_wrap_enter+0x4c/0xa0) from [<c0371648>]
(cpuidle_enter_state+0x14/0x70)
[<c0371648>] (cpuidle_enter_state+0x14/0x70) from [<c0375d84>]
(cpuidle_enter_state_coupled+0x358/0x900)
[<c0375d84>] (cpuidle_enter_state_coupled+0x358/0x900) from
[<c0371e3c>] (cpuidle_idle_call+0xdc/0x29c)
[<c0371e3c>] (cpuidle_idle_call+0xdc/0x29c) from [<c0015bf4>]
(cpu_idle+0x98/0x124)
[<c0015bf4>] (cpu_idle+0x98/0x124) from [<8046ee34>] (0x8046ee34)

#
