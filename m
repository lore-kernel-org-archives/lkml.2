Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab2IELrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 07:47:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56229 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2IELrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 07:47:40 -0400
Subject: Re: lockdep WARNING for run_timer_softirq()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20120831072149.GA7821@localhost>
References: <20120831072149.GA7821@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Sep 2012 13:47:24 +0200
Message-ID: <1346845644.2461.27.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-31 at 00:21 -0700, Fengguang Wu wrote:
> [    3.267585] Testing tracer function: [    4.282931] tsc: Refined TSC clocksource calibration: 2833.332 MHz
> PASSED
> [   13.392541] Testing tracer irqsoff: PASSED
> [   13.428537] Testing tracer branch: [   20.093074] ------------[ cut here ]------------
> [   20.093861] WARNING: at /c/kernel-tests/src/stable/kernel/lockdep.c:3493 check_flags+0x166/0x386()
> [   20.093861] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc1-00102-ga184d4e #7
> [   20.093861] Call Trace:
> 
> [   20.093861]  [<41064af3>] warn_slowpath_common+0x8e/0xcd
> [   20.093861]  [<410f1372>] ? check_flags+0x166/0x386
> [   20.093861]  [<41064c6b>] warn_slowpath_null+0x30/0x45
> [   20.093861]  [<410f1372>] check_flags+0x166/0x386
> [   20.093861]  [<410f7cc5>] lock_acquire+0x5b/0x24a
> [   20.093861]  [<4107f7d8>] run_timer_softirq+0x2a6/0x77d
> [   20.093861]  [<4107f72f>] ? run_timer_softirq+0x1fd/0x77d
> [   20.093861]  [<4107f449>] ? spin_unlock_irqrestore+0x26/0x26
> [   20.093861]  [<41075293>] __do_softirq+0x234/0x5d6
> [   20.093861]  [<4107505f>] ? local_bh_enable_ip+0x2b/0x2b
> [   20.093861]  <IRQ>  [<41075adf>] ? irq_exit+0x9d/0x14b
> [   20.093861]  [<4103b1b7>] ? smp_apic_timer_interrupt+0xe1/0xfd
> [   20.093861]  [<41a75bc7>] ? apic_timer_interrupt+0x2f/0x34
> [   20.093861]  [<41151975>] ? ftrace_likely_update+0x3bb/0x446
> [   20.093861]  [<41102e17>] ? arch_local_irq_enable+0x6b/0x80
> [   20.093861]  [<41a74287>] ? _raw_spin_unlock_irq+0x80/0xc5
> [   20.093861]  [<410babf0>] ? finish_task_switch+0x109/0x1df
> [   20.093861]  [<410bab8a>] ? finish_task_switch+0xa3/0x1df
> [   20.093861]  [<41a7222b>] ? __schedule+0xb89/0xd51
> [   20.093861]  [<4112efbe>] ? rcu_idle_exit+0x1d0/0x26c
> [   20.093861]  [<4112efd3>] ? rcu_idle_exit+0x1e5/0x26c
> [   20.093861]  [<41a7252f>] ? schedule+0x13c/0x14c
> [   20.093861]  [<41014615>] ? cpu_idle+0x1d5/0x1fd
> [   20.093861]  [<41a01c3d>] ? rest_init+0x319/0x32c
> [   20.093861]  [<4216637a>] ? start_kernel+0x84c/0x85f
> [   20.093861]  [<42165322>] ? i386_start_kernel+0xf8/0x10b
> [   20.093861] ---[ end trace 39036f94f86e3090 ]---
> [   20.093861] possible reason: unannotated irqs-on.
> [   20.093861] irq event stamp: 36791
> [   20.093861] hardirqs last  enabled at (36790): [<41a74274>] _raw_spin_unlock_irq+0x6d/0xc5
> [   20.093861] hardirqs last disabled at (36791): [<41151700>] ftrace_likely_update+0x146/0x446
> [   20.093861] softirqs last  enabled at (34274): [<41074fe8>] _local_bh_enable+0x20/0x30
> [   20.093861] softirqs last disabled at (34275): [<41007553>] call_on_stack+0x20/0x34 

I suspect its because of a 'fun' combination of paravirt and
trace_branch, although I can't seem to make it stick.. the trace
includes the best of both worlds although its rather uncertain of
itself :/

_raw_spin_unlock_irq()
  __raw_spin_unlock_irq()
    spin_release() <-- tell lockdep you release the lock
    do_raw_spin_unlock() <-- actually release the lock
    local_irq_enable()
      trace_hardirqs_on() <-- tell lockdep IRQs are on
      raw_local_irq_enable()
        arch_local_irq_enable()
          PVOP_VCALLEE0(pv_irq_ops.irq_enable);
            *magic*
              ftrace_likely_update()
                local_irq_save()  <-- as per the hardirq last disable

* note that hardirq last enable doesn't appear to be the _restore() ?! *

<IRQ> <-- which would be impossible give the above state ?
  __irqexit
    __do_softirq()
      run_timer_softirq()
        lock_acquire() <-- assuming its spin_lock_irq(&base->lock) in __run_timers

*confused*

Anybody got clue?

