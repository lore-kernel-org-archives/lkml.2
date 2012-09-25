Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2IYOKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:10:34 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43236 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2IYOKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:10:33 -0400
Date: Tue, 25 Sep 2012 06:04:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
Message-ID: <20120925130443.GF2436@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <505EA09B.6040105@gmail.com>
 <CAFTL4hwqzS8iO2zOOGaizzMtT85MJExTxEgGbponJ4_gfv0nwA@mail.gmail.com>
 <5060E31B.3070203@gmail.com>
 <5060E498.7030003@gmail.com>
 <CAFTL4hzVSBkcDRnzvpmXyBHqydqy=nJxdMtjUHrvR8MwN_M0jQ@mail.gmail.com>
 <5060E863.6020006@gmail.com>
 <CAFTL4hyOMSb2LW+HX1LG+KJCLzazKFmp+nHtEW8CnxG4MX_bsQ@mail.gmail.com>
 <CAFTL4hw7+t8fzcphCyMAQoCBNb6RndQ7hiUnR6qhk6nYa+93fw@mail.gmail.com>
 <20120925040420.GB2436@linux.vnet.ibm.com>
 <20120925115917.GB2310@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925115917.GB2310@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092514-5518-0000-0000-000007E87C73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 01:59:26PM +0200, Frederic Weisbecker wrote:
> On Mon, Sep 24, 2012 at 09:04:20PM -0700, Paul E. McKenney wrote:
> > On Tue, Sep 25, 2012 at 01:41:18AM +0200, Frederic Weisbecker wrote:
> > > >
> > > > [  168.703017] ------------[ cut here ]------------
> > > > [  168.708117] WARNING: at kernel/rcutree.c:502 rcu_eqs_exit_common+0x4a/0x3a0()
> > > > [  168.710034] Pid: 7871, comm: trinity-child65 Tainted: G        W
> > > > 3.6.0-rc6-next-20120924-sasha-00030-g71f256c #5
> > > > [  168.710034] Call Trace:
> > > > [  168.710034]  <IRQ>  [<ffffffff811c737a>] ? rcu_eqs_exit_common+0x4a/0x3a0
> > > > [  168.710034]  [<ffffffff811078b6>] warn_slowpath_common+0x86/0xb0
> > > > [  168.710034]  [<ffffffff811079a5>] warn_slowpath_null+0x15/0x20
> > > > [  168.710034]  [<ffffffff811c737a>] rcu_eqs_exit_common+0x4a/0x3a0
> > > > [  168.710034]  [<ffffffff811c79cc>] rcu_eqs_exit+0x9c/0xb0
> > > > [  168.710034]  [<ffffffff811c7a4c>] rcu_user_exit+0x6c/0xd0
> > > > [  168.710034]  [<ffffffff8106eb1f>] do_general_protection+0x1f/0x170
> > > > [  168.710034]  [<ffffffff83a0e624>] ? restore_args+0x30/0x30
> > > > [  168.710034]  [<ffffffff83a0e875>] general_protection+0x25/0x30
> > > > [  168.710034]  [<ffffffff810a3f06>] ? native_read_msr_safe+0x6/0x20
> > > > [  168.710034]  [<ffffffff81a0b34b>] __rdmsr_safe_on_cpu+0x2b/0x50
> > > > [  168.710034]  [<ffffffff819ec971>] ? list_del+0x11/0x40
> > > > [  168.710034]  [<ffffffff811886dc>]
> > > > generic_smp_call_function_single_interrupt+0xec/0x120
> > > > [  168.710034]  [<ffffffff81151147>] ? account_system_vtime+0xd7/0x140
> > > > [  168.710034]  [<ffffffff81096f72>]
> > > > smp_call_function_single_interrupt+0x22/0x40
> > > > [  168.710034]  [<ffffffff83a0fe2f>] call_function_single_interrupt+0x6f/0x80
> > > > [  168.710034]  <EOI>  [<ffffffff83a0e5f4>] ? retint_restore_args+0x13/0x13
> > > > [  168.710034]  [<ffffffff811c7285>] ? rcu_user_enter+0x105/0x110
> > > > [  168.710034]  [<ffffffff8107e06d>] syscall_trace_leave+0xfd/0x150
> > > > [  168.710034]  [<ffffffff83a0f1ef>] int_check_syscall_exit_work+0x34/0x3d
> > > > [  168.710034] ---[ end trace fd408dd21b70b87c ]---
> > > >
> > > > This is an exception inside an interrupt, and the interrupt
> > > > interrupted RCU user mode.
> > > > And we have that nesting:
> > > >
> > > > rcu_irq_enter(); <--- irq entry
> > > > rcu_user_exit(); <--- exception entry
> > > >
> > > > And rcu_eqs_exit() doesn't handle that very well...
> > > 
> > > So either I should return immediately from rcu_user_exit() if
> > > we are in an interrupt, or we make rcu_user_exit() able to nest
> > > on rcu_irq_enter()   :)
> > 
> > Both of the two are eminently doable, with varying degrees of hackery.
> > 
> > What makes the most sense from an adaptive-idle viewpoint?
> 
> Given that we have:
> 
> rcu_irq_enter()
> 	rcu_user_exit()
> 	rcu_user_enter()
> rcu_irq_exit()

Indeed, the code to deal with irq misnestings won't like that at all.
And we are in the kernel between rcu_user_exit() and rcu_user_enter()
(right?), so we could in fact see irq misnestings.

> And we already have rcu_user_exit_after_irq(), this starts to be confusing
> if we allow that nesting. Although if we find a solution that, in the end,
> merge rcu_user_exit() with rcu_user_exit_after_irq() and same for the enter version,
> this would probably be a good thing. Provided this doesn't involve some more
> complicated rdtp->dyntick_nesting trickies nor more overhead.
> 
> Otherwise we could avoid to call rcu_user_* when we are in an irq. When we'll have
> the user_hooks layer, we can perhaps manage that from that place. For
> now may be we can return after in_interrupt() in the rcu user apis.

This last sounds best.

My main concern is irq misnesting.  We might need to do something ugly
like record the interrupt nesting level at rcu_user_exit() and restore
it at rcu_user_enter().  Sigh!!!

> Let's first ensure I diagnosed it well and we don't have other problems detected
> by Sasha. I'm cooking a testing patch.

Excellent point!

							Thanx, Paul

