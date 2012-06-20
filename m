Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2FTOox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:44:53 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37811 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab2FTOow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:44:52 -0400
Date: Wed, 20 Jun 2012 07:24:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, johnstul@us.ibm.com,
        fweisbec@gmail.com
Subject: Re: WARNING: at /home/konrad/ssd/linux/kernel/rcutree.c:1547
 __rcu_process_callbacks+0x42e/0x440()
Message-ID: <20120620142459.GA2461@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120619182216.GA13454@phenom.dumpdata.com>
 <20120619184718.GF2385@linux.vnet.ibm.com>
 <20120620135833.GB12787@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620135833.GB12787@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062014-6148-0000-0000-000006E28B11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 09:58:33AM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Jun 19, 2012 at 11:47:18AM -0700, Paul E. McKenney wrote:
> > On Tue, Jun 19, 2012 at 02:22:16PM -0400, Konrad Rzeszutek Wilk wrote:
> > > 
> > > I've been getting this when booting a Xen PV guest with 3 CPUs (of which two are
> > > online). Any thoughts?
> > 
> > Maybe...  I am assuming that your kernel/rcutree.c:1547 is this line of code:
> > 
> > 	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
> > 
> > This is line 1549 in current mainline.
> 
> <nods>
> [    0.064998] ------------[ cut here ]------------^M
> [    0.065004] WARNING: at /home/konrad/linux-linus/kernel/rcutree.c:1549 __rcu_process_callbacks+0x42e/0x440()^M
> [    0.065005] Modules linked in:^M
> [    0.065006] Pid: 12, comm: migration/2 Not tainted 3.5.0-rc3upstream-00111-gf40759e #1^M
> [    0.065007] Call Trace:^M
> [    0.065011]  <IRQ>  [<ffffffff810718ba>] warn_slowpath_common+0x7a/0xb0^M
> [    0.065013]  [<ffffffff81071905>] warn_slowpath_null+0x15/0x20^M
> [    0.065022]  [<ffffffff810edb7e>] __rcu_process_callbacks+0x42e/0x440^M
> [    0.065026]  [<ffffffff810edbb0>] rcu_process_callbacks+0x20/0x40^M
> [    0.065029]  [<ffffffff81079299>] __do_softirq+0xa9/0x160^M
> [    0.065033]  [<ffffffff810a1035>] ? sched_clock_local+0x25/0x90^M
> [    0.065037]  [<ffffffff810d7201>] ? queue_stop_cpus_work+0x61/0xf0^M
> [    0.065042]  [<ffffffff815c44dc>] call_softirq+0x1c/0x30^M
> [    0.065044]  [<ffffffff81039435>] do_softirq+0x65/0xa0^M
> [    0.065047]  [<ffffffff81079095>] irq_exit+0xd5/0xf0^M

Here is the interrupt.  Why are we taking an interrupt on an offline
CPU?  This is very very bad.

> [    0.065050]  [<ffffffff81322f2f>] xen_evtchn_do_upcall+0x2f/0x40^M
> [    0.065054]  [<ffffffff815c452e>] xen_do_hypervisor_callback+0x1e/0x30^M
> [    0.065058]  <EOI>  [<ffffffff810d7201>] ? queue_stop_cpus_work+0x61/0xf0^M
> 
> 
> > 
> > If my guess is correct, my question is "why on earth is a CPU that has
> > marked itself offline taking a timer interrupt???"
> 
> So.. part of this is that I think the CPU hotplug code is a bit brain-dead.
> 
> In the Xen side, when a guest starts - it boots all the available CPUs
> (in this case three), and then it brings down the one it doesn't need.
> How many it brings down is dependent on two simple lines in the guest config:
> 
> vcpus=2
> maxvcpus=3
> 
> The "offline" CPU can be immediately brought back and its parked in the
> cpu_idle call. Which looking at it - means that it also hits the schedule_bug
> when it gets to be onlined. Grrrr..
> 
> But irregardless of that - when a CPU is brought down it does call the CPU
> offline notifiers - and I am not sure why the RCU isn't notified? Could
> it be a race perhaps?

RCU -is- being notified of the CPU going down, as near as I can tell.

As noted previously, the real question is "Why on earth is an offline
CPU taking an interrupt???"  RCU is complaining that it is being asked
to do work while running on an offline CPU.

So, where is that interrupt coming from?  It needs to not be happening.

							Thanx, Paul

> > I could provide a patch to make RCU work around this problem from its
> > viewpoint, but taking timer interrupts on an offline CPU is an extremely
> > bad idea.  It would be good to fix the underlying problem instead of
> 
> Right.
> > silencing RCU's warning.
> 
> Of course.
> > 
> > If my guess on what line is warning you is wrong, please do let me know
> > what the line really is -- or even better, the corresponding mainline
> > git commit ID.
> 
> This is f40759e but I think earlier versions of v3.5 exhibited this too.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

