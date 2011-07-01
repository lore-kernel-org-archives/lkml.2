Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab1GAM7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:59:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55400 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043Ab1GAM7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:59:39 -0400
Date: Fri, 1 Jul 2011 14:59:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL v2] sched: Make sleep inside atomic detection work on
 !PREEMPT
Message-ID: <20110701125926.GF12605@elte.hu>
References: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
 <20110622224844.GA3290@somewhere>
 <20110701123629.GA12605@elte.hu>
 <20110701125644.GD8508@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701125644.GD8508@somewhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Jul 01, 2011 at 02:36:29PM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Fri, Jun 10, 2011 at 03:30:18PM +0200, Frederic Weisbecker wrote:
> > > > Ingo,
> > > > 
> > > > Please pull the sched/core branch that can be found at:
> > > > 
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > > > 	sched/core
> > > 
> > > Hi Ingo,
> > > 
> > > I have added Randy's ack on the last patch. To get it, please pull the v2 in
> > > the following branch:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > >        sched/core-v2
> > > 
> > > There are no other changes.
> > 
> > Hm, this triggers such warnings now:
> > 
> > Detected 2010.217 MHz processor.
> > Marking TSC unstable due to TSCs unsynchronized
> > Calibrating delay loop (skipped), value calculated using timer frequency.. 4022.95 BogoMIPS (lpj=6700723)
> > pid_max: default: 4096 minimum: 301
> > BUG: scheduling while atomic: swapper/0/0x10000002
> > no locks held by swapper/0.
> > Pid: 0, comm: swapper Not tainted 3.0.0-rc5-tip-01401-ga7adf5f-dirty #141020
> > Call Trace:
> >  [<ffffffff81ddb3b0>] __schedule_bug+0x60/0x65
> >  [<ffffffff81dee803>] schedule+0x953/0x980
> >  [<ffffffff81571e30>] ? serial8250_console_putchar+0x30/0x40
> >  [<ffffffff81df177b>] ? _raw_spin_unlock+0x2b/0x50
> >  [<ffffffff8107882a>] __cond_resched+0x2a/0x40
> >  [<ffffffff81dee8e2>] _cond_resched+0x32/0x40
> >  [<ffffffff81110ba8>] __alloc_pages_nodemask+0x1b8/0x880
> >  [<ffffffff81df23ce>] ? common_interrupt+0xe/0x13
> >  [<ffffffff81080649>] ? vprintk+0x359/0x530
> >  [<ffffffff8113b4e7>] slob_new_pages+0x17/0x80
> >  [<ffffffff8113bd13>] __kmalloc_node+0xa3/0x270
> >  [<ffffffff81ddb6d5>] ? printk+0x41/0x43
> >  [<ffffffff82738420>] pidmap_init+0x80/0xbf
> >  [<ffffffff8272aa54>] start_kernel+0x28b/0x300
> >  [<ffffffff8272a2ee>] x86_64_start_reservations+0xfe/0x102
> >  [<ffffffff8272a3e2>] x86_64_start_kernel+0xf0/0xf7
> > Security Framework initialized
> > AppArmor: AppArmor initialized
> > Mount-cache hash table entries: 256
> > Initializing cgroup subsys cpuacct
> > 
> > Not sure we want to warn about schedule during early init, or can 
> > it cause problems and should thus be fixed? I bet there's more 
> > such instances.
> 
> I believe this is harmless because no other other tasks than init 
> are queued at that time. But I don't know, may be calling 
> schedule() involves some things that are not ready yet at that 
> time.

So why does it have need_resched set then? (which i presume must be a 
condition for cond_resched() to call into schedule())

> Either we add a system_state check in schedule_debug() or we fix 
> the callers to not call schedule when system_state shows we are 
> booting..

Hm, such attempts were rather fragile in the past.

Thanks,

	Ingo
