Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab2IUT53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:57:29 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57641 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab2IUT51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:57:27 -0400
Date: Fri, 21 Sep 2012 12:57:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>, fweisbec@gmail.com
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
Message-ID: <20120921195717.GD2454@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.00.1209131839000.23318@utopia.booyaka.com>
 <20120920000351.GI2455@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
 <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com>
 <20120920220130.GN2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
 <20120920232114.GO2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com>
 <20120921185827.GC2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209211900520.8839@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209211900520.8839@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092119-7606-0000-0000-000003DDC47E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 07:11:14PM +0000, Paul Walmsley wrote:
> On Fri, 21 Sep 2012, Paul E. McKenney wrote:
> 
> > On Fri, Sep 21, 2012 at 06:08:59PM +0000, Paul Walmsley wrote:
> > 
> > > As far as I know, our only idle entry point is in 
> > > arch/arm/common/process.c:cpu_idle().
> > 
> > In mainline, this is arch/arm/kernel/process.c, correct?
> 
> Indeed; sorry about that, mistyped.

No problem!

> > > Looking at the x86 idle entry, they call rcu_idle_{enter,exit}() inside 
> > > {stop,start}_critical_timings().  Making that change here didn't help.
> > 
> > The reason x86 does this is that they have idle notifiers deeper in the
> > idle loop that use RCU read-side critical sections.  So this was an
> > expected result.
> 
> OK
> 
> > > Also tried commenting out the code from the stop_critical_timings() call 
> > > to the WARN_ON(irqs_disabled()), and adding a local_irq_enable().  That 
> > > also didn't help, which suggests that the problem is not caused by the 
> > > OMAP-specific PM idle code.
> > 
> > I must admit that you make a convincing case here.  Though it does leave
> > me wondering what is different about Panda (and MX28, IIRC).
> 
> Given the dependency on CONFIG_NO_HZ, the stalls are probably dependent on 
> the userspace in use.  The userspaces here are quite minimal and so allow 
> the system to stay idle for relatively long periods of time.

Could you please point me to a recipe for creating a minimal userspace?
Just in case it is the userspac erather than the architecture/hardware
that makes the difference.

> > I may take your advice of remote access to a Panda board, though that
> > is likely to take a bit of time due to timezones.  Regardless of the
> > underlying issue here, I clearly need to make the stall-warning messages
> > do a better job of printing out needed information.
> 
> If you've got a patch in mind for that, I'll boot it here.

Hammering it out, will send it along when it is a bit less destructive.  ;-)

> One other observation.  omap2plus_defconfig sets CONFIG_NO_HZ=y but 
> doesn't set CONFIG_RCU_FAST_NO_HZ.  The stall warning messages still 
> appear when CONFIG_RCU_FAST_NO_HZ=y.  One of them is attached below (with 
> CONFIG_RCU_CPU_STALL_INFO set as well, obviously).

Just to make sure I understand the combinations:

o	All stalls have happened when running a minimal userspace.
o	CONFIG_NO_HZ=n suppresses the stalls.
o	CONFIG_RCU_FAST_NO_HZ (which depends on CONFIG_NO_HZ=y) has
	no observable effect on the stalls.

Did I get that right, or am I missing a combination?

> As an aside, in the CONFIG_RCU_FAST_NO_HZ=y build, I dropped a printk() 
> into rcu_idle_gp_timer_func() and it doesn't look like it ever executed.

Indeed, rcu_idle_gp_timer_func() is a bit strange in that it is cancelled
upon exit from idle, and therefore should (almost) never actually execute.
Its sole purpose is to wake up the CPU.  ;-)

							Thanx, Paul

> - Paul
> 
> [  305.832000] INFO: rcu_sched self-detected stall on CPU
> [  305.834838]  1: (2 GPs behind) idle=5b1/1/0 drain=0 . timer=4294967295
> [  305.838378]   (t=17463 jiffies)
> [  305.840118] [<c001be10>] (unwind_backtrace+0x0/0xf0) from [<c00ad65c>] (rcu_pending+0xd0/0x540)
> [  305.844848] [<c00ad65c>] (rcu_pending+0xd0/0x540) from [<c00ae5cc>] (rcu_check_callbacks+0x110/0x198)
> [  305.849884] [<c00ae5cc>] (rcu_check_callbacks+0x110/0x198) from [<c0053800>] (update_process_times+0x38/0x68)
> [  305.855285] [<c0053800>] (update_process_times+0x38/0x68) from [<c008cf40>] (tick_sched_timer+0x80/0xec)
> [  305.860473] [<c008cf40>] (tick_sched_timer+0x80/0xec) from [<c006942c>] (__run_hrtimer+0x7c/0x1e0)
> [  305.865356] [<c006942c>] (__run_hrtimer+0x7c/0x1e0) from [<c006a210>] (hrtimer_interrupt+0x11c/0x2d0)
> [  305.870361] [<c006a210>] (hrtimer_interrupt+0x11c/0x2d0) from [<c001a54c>] (twd_handler+0x30/0x44)
> [  305.875274] [<c001a54c>] (twd_handler+0x30/0x44) from [<c00a8128>] (handle_percpu_devid_irq+0x90/0x13c)
> [  305.880371] [<c00a8128>] (handle_percpu_devid_irq+0x90/0x13c) from [<c00a489c>] (generic_handle_irq+0x30/0x48)
> [  305.885833] [<c00a489c>] (generic_handle_irq+0x30/0x48) from [<c0014fb8>] (handle_IRQ+0x4c/0xac)
> [  305.890624] [<c0014fb8>] (handle_IRQ+0x4c/0xac) from [<c000864c>] (gic_handle_irq+0x28/0x5c)
> [  305.895233] [<c000864c>] (gic_handle_irq+0x28/0x5c) from [<c04fbc64>] (__irq_svc+0x44/0x5c)
> [  305.899780] Exception stack(0xde86ff88 to 0xde86ffd0)
> [  305.902526] ff80:                   0004c062 00000001 00000000 de8660c0 de86e000 c07c42c8
> [  305.906982] ffa0: c05075a0 c074bdd0 00000000 411fc092 c074bff0 00000000 00000001 de86ffd0
> [  305.911437] ffc0: 0004c063 c00152b0 20000113 ffffffff
> [  305.914184] [<c04fbc64>] (__irq_svc+0x44/0x5c) from [<c00152b0>] (default_idle+0x20/0x44)
> [  305.918640] [<c00152b0>] (default_idle+0x20/0x44) from [<c00154dc>] (cpu_idle+0x9c/0x114)
> [  305.923126] [<c00154dc>] (cpu_idle+0x9c/0x114) from [<804f4a34>] (0x804f4a34)
> 

