Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab1ILNws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 09:52:48 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39269 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754774Ab1ILNwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 09:52:47 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Wr8Ile9eWFxmMAQtXho1ghjNY7rjxUM/l37ecWH
	0BzJVeD1cIkPGb
Subject: Re: [ANNOUNCE] 3.0.4-rt13
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1315817948.26517.16.camel@twins>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Sep 2011 15:52:42 +0200
Message-ID: <1315835562.6758.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 10:59 +0200, Peter Zijlstra wrote:
> On Sun, 2011-09-11 at 12:35 +0200, Mike Galbraith wrote:
> > (gdb) list *do_sigtimedwait+0x62
> > 0xffffffff8104f3e2 is in do_sigtimedwait (kernel/signal.c:2628).
> > 2623             * Invert the set of allowed signals to get those we want to block.
> > 2624             */
> > 2625            sigdelsetmask(&mask, sigmask(SIGKILL) | sigmask(SIGSTOP));
> > 2626            signotset(&mask);
> > 2627
> > 2628            spin_lock_irq(&tsk->sighand->siglock);
> > 2629            sig = dequeue_signal(tsk, &mask, info);
> > 2630            if (!sig && timeout) {
> > 2631                    /*
> > 2632                     * None ready, temporarily unblock those we're interested
> > (gdb) list *do_sigtimedwait+0x15f
> > 0xffffffff8104f4df is in do_sigtimedwait (kernel/signal.c:2642).
> > 2637                    tsk->real_blocked = tsk->blocked;
> > 2638                    sigandsets(&tsk->blocked, &tsk->blocked, &mask);
> > 2639                    recalc_sigpending();
> > 2640                    spin_unlock_irq(&tsk->sighand->siglock);
> > 2641
> > 2642                    timeout = schedule_timeout_interruptible(timeout);
> > 2643
> > 2644                    spin_lock_irq(&tsk->sighand->siglock);
> > 2645                    __set_task_blocked(tsk, &tsk->real_blocked);
> > 2646                    siginitset(&tsk->real_blocked, 0);
> > 
> 
> 
> Right, so what Thomas says.. Now admittedly I haven't had my morning
> juice yet, but staring at that function I can't see why that warning
> would trigger at all.
> 
> I'm going to try and reproduce, but Thomas is already saying he can't,
> so I'm not too confident.
> 
> I you can easily trigger this, could you add some trace_printk() to
> migrate_disable/enable that prints both counters etc.. so we can see wtf
> happens?

trace_printk as we enter migrate_enable/disable like so for both.

        int in_atomic = in_atomic();

        trace_printk("migrate_disable: in_atomic:%d p->migrate_disable_atomic:%d p->migrate_disable:%d\n",
                                in_atomic, p->migrate_disable_atomic, p->migrate_disable);

        if (in_atomic) {
#ifdef CONFIG_SCHED_DEBUG
                p->migrate_disable_atomic++;
#endif
                return;
        }

#ifdef CONFIG_SCHED_DEBUG
        if (WARN_ON_ONCE(p->migrate_disable_atomic))
                tracing_stop();
#endif

We migrate_disable() in_atomic() == false, migrate_enable() with
in_atomic() ==  true.  Burp.

36717            <...>-6266  [002]   242.543129: sys_semop <-system_call_fastpath
36718            <...>-6266  [002]   242.543129: sys_semtimedop <-sys_semop
36719            <...>-6266  [002]   242.543131: ipc_lock_check <-sys_semtimedop
36720            <...>-6266  [002]   242.543131: ipc_lock <-ipc_lock_check
36721            <...>-6266  [002]   242.543132: __rcu_read_lock <-ipc_lock
36722            <...>-6266  [002]   242.543133: migrate_disable <-ipc_lock
36723            <...>-6266  [002]   242.543134: migrate_disable: migrate_disable: in_atomic:0 p->migrate_disable_atomic:0 p->migrate_disable:0
36724            <...>-6266  [002]   242.543134: pin_current_cpu <-migrate_disable
36725            <...>-6266  [002]   242.543134: _raw_spin_lock_irqsave <-migrate_disable
36726            <...>-6266  [002]   242.543135: _raw_spin_unlock_irqrestore <-migrate_disable
36727            <...>-6266  [002]   242.543135: rt_spin_lock <-ipc_lock
36728            <...>-6266  [002]   242.543136: ipcperms <-sys_semtimedop
36729            <...>-6266  [002]   242.543137: ns_capable <-ipcperms
36730            <...>-6266  [002]   242.543138: cap_capable <-ns_capable
36731            <...>-6266  [002]   242.543138: pid_vnr <-sys_semtimedop
36732            <...>-6266  [002]   242.543139: try_atomic_semop <-sys_semtimedop
36733            <...>-6266  [002]   242.543140: do_smart_update <-sys_semtimedop
36734            <...>-6266  [002]   242.543140: update_queue <-do_smart_update
36735            <...>-6266  [002]   242.543141: try_atomic_semop <-update_queue
36736            <...>-6266  [002]   242.543142: update_queue <-do_smart_update
36737            <...>-6266  [002]   242.543142: try_atomic_semop <-update_queue
36738            <...>-6266  [002]   242.543143: update_queue <-do_smart_update
36739            <...>-6266  [002]   242.543143: try_atomic_semop <-update_queue
36740            <...>-6266  [002]   242.543144: get_seconds <-do_smart_update
36741            <...>-6266  [002]   242.543144: rt_spin_unlock <-sys_semtimedop
36742            <...>-6266  [002]   242.543144: migrate_enable <-sys_semtimedop
36743            <...>-6266  [002]   242.543145: migrate_enable: migrate_enable: in_atomic:1 p->migrate_disable_atomic:0 p->migrate_disable:1


