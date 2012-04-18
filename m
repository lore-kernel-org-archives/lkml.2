Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2DROCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:02:22 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58165 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2DROCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:02:18 -0400
Date: Wed, 18 Apr 2012 07:01:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120418140108.GA6034@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120405123759.GE1963@zod.bos.redhat.com>
 <20120405140006.GB27672@linux.vnet.ibm.com>
 <1838583439.163624.1333635333132.JavaMail.www@wwinf1m19>
 <20120405143918.GE27672@linux.vnet.ibm.com>
 <588810225.17969.1333703883646.JavaMail.www@wwinf1g24>
 <20120410160706.GF2428@linux.vnet.ibm.com>
 <4F859E0E.8050408@wanadoo.fr>
 <20120412180432.GE2394@linux.vnet.ibm.com>
 <20120416210234.GA3490@linux.vnet.ibm.com>
 <4F8E8B58.1040203@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F8E8B58.1040203@wanadoo.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041814-6148-0000-0000-00000522801E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 11:37:28AM +0200, Pascal Chapperon wrote:
> Le 16/04/2012 23:02, Paul E. McKenney a écrit :
> .
> >>So it seems that mount and unmount operations are often slower with
> >>RCU_FAST_NO_HZ during boot and shutdown.  Are these operations also
> >>slower during runtime?  If so, the RCU event tracing across both a fast
> >>and a slow mount or unmount operation would likely be quite helpful.
> -
> Mount and umount operations are not slower with RCU_FAST_NO_HZ during
> runtime; systemctl start and stop operations are also not slower. In
> fact, i couldn't find a single operation slower during runtime with
> RCU_FAST_NO_HZ.

Your boot-time setup is such that all CPUs are online before the
boot-time mount operations take place, right?  Struggling to understand
how RCU can tell the difference between post-CPU-bringup boot time
and run time...

							Thanx, Paul

> >Actually, one other possibility is that RCU_FAST_NO_HZ's timer is
> >being migrated.  If you get a chance, could you please try out the
> >diagnostic patch below?
> >
> >							Thanx, Paul
> >
> >------------------------------------------------------------------------
> >
> >rcu: Check for timer migration for RCU_FAST_NO_HZ
> >
> >If RCU_FAST_NO_HZ's timer is migrated, then the CPU that went dyntick-idle
> >with callbacks might never wake up, which could indefinitely postpone
> >invocation of its callbacks, which could in turn result in a system hang.
> >But if the timer is migrated, then it might actually fire.  In contrast,
> >if it remains on the CPU that posted it, it is guaranteed to be cancelled.
> >
> >This patch therefore adds a WARN_ON_ONCE() to this timer's handler as
> >a diagnostic test.
> >
> >Signed-off-by: Paul E. McKenney<paulmck@linux.vnet.ibm.com>
> >
> >diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> >index c023464..67ee640 100644
> >--- a/kernel/rcutree_plugin.h
> >+++ b/kernel/rcutree_plugin.h
> >@@ -2053,6 +2053,7 @@ static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
> >   */
> >  static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
> >  {
> >+	WARN_ON_ONCE(1);
> >  	trace_rcu_prep_idle("Timer");
> >  	return HRTIMER_NORESTART;
> >  }
> >
> >
> -
> The result below.
> Pascal
> [    0.758325] ------------[ cut here ]------------
> [    0.758330] WARNING: at kernel/rcutree_plugin.h:2056
> rcu_idle_gp_timer_func+0x27/0x30()
> [    0.758332] Hardware name: GX780R/GT780R/GT780DXR/GT783R
> [    0.758334] Modules linked in:
> [    0.758337] Pid: 0, comm: swapper/0 Not tainted 3.4.0-rc2-rcu+ #38
> [    0.758338] Call Trace:
> [    0.758340]  <IRQ>
> [<ffffffff81057a1f>]warn_slowpath_common+0x7f/0xc0
> [    0.758348]  [<ffffffff81057a7a>] warn_slowpath_null+0x1a/0x20
> [    0.758350]  [<ffffffff810e61e7>] rcu_idle_gp_timer_func+0x27/0x30
> [    0.758354]  [<ffffffff8107d5f1>] __run_hrtimer+0x71/0x1e0
> [    0.758357]  [<ffffffff810e61c0>] ? rcu_batches_completed+0x20/0x20
> [    0.758360]  [<ffffffff8107df3b>] hrtimer_interrupt+0xeb/0x210
> [    0.758365]  [<ffffffff81601dd9>] smp_apic_timer_interrupt+0x69/0x99
> [    0.758368]  [<ffffffff81600b4a>] apic_timer_interrupt+0x6a/0x70
> [    0.758369]  <EOI>  [<ffffffff8101b979>] ? sched_clock+0x9/0x10
> [    0.758374]  [<ffffffff8101cc05>] ? mwait_idle+0x95/0x230
> [    0.758377]  [<ffffffff8101d629>] cpu_idle+0xd9/0x120
> [    0.758380]  [<ffffffff815d4f0e>] rest_init+0x72/0x74
> [    0.758384]  [<ffffffff81cf6c12>] start_kernel+0x3c1/0x3ce
> [    0.758386]  [<ffffffff81cf6582>] ? loglevel+0x31/0x31
> [    0.758389]  [<ffffffff81cf6346>
> x86_64_start_reservations+0x131/0x135
> [    0.758392]  [<ffffffff81cf6140>] ? early_idt_handlers+0x140/0x140
> [    0.758394]  [<ffffffff81cf644c>] x86_64_start_kernel+0x102/0x111
> [    0.758398] ---[ end trace 82bc736bb33fe366 ]---
> 

