Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744Ab2INRyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:54:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59988 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758624Ab2INRyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:54:01 -0400
Date: Fri, 14 Sep 2012 10:53:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: RCU lockup in the SMP idle thread, help...
Message-ID: <20120914175322.GI4257@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CACRpkdYgxsF1G7Dc_xCcQcFV9G+foz1czOCmROcMQ5NfR-ziCA@mail.gmail.com>
 <50520E8A.9030408@linaro.org>
 <20120913165844.GW4257@linux.vnet.ibm.com>
 <CACRpkdatjfk_eUof5G4fwa-Qf8SoF_NvSUJQAZ7U8yjcSYFuTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdatjfk_eUof5G4fwa-Qf8SoF_NvSUJQAZ7U8yjcSYFuTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12091417-6078-0000-0000-00000F83171A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 09:27:32AM +0200, Linus Walleij wrote:
> On Thu, Sep 13, 2012 at 6:58 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Sep 13, 2012 at 09:49:14AM -0700, John Stultz wrote:
> >> I saw this once as well testing the fix to Daniel's deep idle hang
> >> issue (also on 32 bit).
> 
> John, what system was this? If it's not Snowball/ux500 we can atleast
> conclude that
> it's a generic bug, not machine-specific...
> 
> >> Really briefly looking at the code in rcutree.c, I'm curious if
> >> we're hitting a false positive on the 5 minute jiffies overflow?
> >
> > Hmmm...  Might be.  Does the patch below help?
> 
> Sorry, nope, I get this:

Could you please try reproducing with CONFIG_RCU_CPU_STALL_INFO=y?

							Thanx, Paul

> root@ME:/
> root@ME:/ INFO: rcu_preempt detected stalls on CPUs/tasks: { 0}
> (detected by 1, t=29545 jiffies)
> [<c0014710>] (unwind_backtrace+0x0/0xf8) from [<c00686fc>]
> (rcu_check_callbacks+0x6e0/0x76c)
> [<c00686fc>] (rcu_check_callbacks+0x6e0/0x76c) from [<c0029cbc>]
> (update_process_times+0x38/0x4c)
> [<c0029cbc>] (update_process_times+0x38/0x4c) from [<c0055088>]
> (tick_sched_timer+0x80/0xe4)
> [<c0055088>] (tick_sched_timer+0x80/0xe4) from [<c003c120>]
> (__run_hrtimer.isra.18+0x44/0xd0)
> [<c003c120>] (__run_hrtimer.isra.18+0x44/0xd0) from [<c003cae0>]
> (hrtimer_interrupt+0x118/0x2b4)
> [<c003cae0>] (hrtimer_interrupt+0x118/0x2b4) from [<c0013658>]
> (twd_handler+0x30/0x44)
> [<c0013658>] (twd_handler+0x30/0x44) from [<c00638c8>]
> (handle_percpu_devid_irq+0x80/0xa0)
> [<c00638c8>] (handle_percpu_devid_irq+0x80/0xa0) from [<c00603b8>]
> (generic_handle_irq+0x20/0x30)
> [<c00603b8>] (generic_handle_irq+0x20/0x30) from [<c000ef58>]
> (handle_IRQ+0x4c/0xac)
> [<c000ef58>] (handle_IRQ+0x4c/0xac) from [<c00084bc>] (gic_handle_irq+0x24/0x58)
> [<c00084bc>] (gic_handle_irq+0x24/0x58) from [<c000dc80>] (__irq_svc+0x40/0x70)
> Exception stack(0xcf865f88 to 0xcf865fd0)
> 5f80:                   00000020 c05c0a20 00000001 00000000 cf864000 cf864000
> 5fa0: c05dfe48 c02de0bc c05c3e90 412fc091 cf864000 00000000 01000000 cf865fd0
> 5fc0: c000f234 c000f238 60000013 ffffffff
> [<c000dc80>] (__irq_svc+0x40/0x70) from [<c000f238>] (default_idle+0x28/0x30)
> [<c000f238>] (default_idle+0x28/0x30) from [<c000f438>] (cpu_idle+0x98/0xe4)
> [<c000f438>] (cpu_idle+0x98/0xe4) from [<002d3094>] (0x2d3094)
> INFO: rcu_preempt detected stalls on CPUs/tasks: { 0} (detected by 1,
> t=30029 jiffies)
> [<c0014710>] (unwind_backtrace+0x0/0xf8) from [<c00686fc>]
> (rcu_check_callbacks+0x6e0/0x76c)
> [<c00686fc>] (rcu_check_callbacks+0x6e0/0x76c) from [<c0029cbc>]
> (update_process_times+0x38/0x4c)
> [<c0029cbc>] (update_process_times+0x38/0x4c) from [<c0055088>]
> (tick_sched_timer+0x80/0xe4)
> [<c0055088>] (tick_sched_timer+0x80/0xe4) from [<c003c120>]
> (__run_hrtimer.isra.18+0x44/0xd0)
> [<c003c120>] (__run_hrtimer.isra.18+0x44/0xd0) from [<c003cae0>]
> (hrtimer_interrupt+0x118/0x2b4)
> [<c003cae0>] (hrtimer_interrupt+0x118/0x2b4) from [<c0013658>]
> (twd_handler+0x30/0x44)
> [<c0013658>] (twd_handler+0x30/0x44) from [<c00638c8>]
> (handle_percpu_devid_irq+0x80/0xa0)
> [<c00638c8>] (handle_percpu_devid_irq+0x80/0xa0) from [<c00603b8>]
> (generic_handle_irq+0x20/0x30)
> [<c00603b8>] (generic_handle_irq+0x20/0x30) from [<c000ef58>]
> (handle_IRQ+0x4c/0xac)
> [<c000ef58>] (handle_IRQ+0x4c/0xac) from [<c00084bc>] (gic_handle_irq+0x24/0x58)
> [<c00084bc>] (gic_handle_irq+0x24/0x58) from [<c000dc80>] (__irq_svc+0x40/0x70)
> Exception stack(0xcf865f88 to 0xcf865fd0)
> 5f80:                   00000020 c05c0a20 00000001 00000000 cf864000 cf864000
> 5fa0: c05dfe48 c02de0bc c05c3e90 412fc091 cf864000 00000000 01000000 cf865fd0
> 5fc0: c000f234 c000f238 60000013 ffffffff
> [<c000dc80>] (__irq_svc+0x40/0x70) from [<c000f238>] (default_idle+0x28/0x30)
> [<c000f238>] (default_idle+0x28/0x30) from [<c000f438>] (cpu_idle+0x98/0xe4)
> [<c000f438>] (cpu_idle+0x98/0xe4) from [<002d3094>] (0x2d3094)
> 
> I'm all confused ..
> 
> Yours,
> Linus Walleij
> 

