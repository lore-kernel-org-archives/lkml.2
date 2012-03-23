Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2CWEsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:48:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:54450 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752885Ab2CWEsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:48:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18sKVYlB2gsYTwvgIVX4mkATaTusM6PcRVXH3cDrI
	2NG5Rq7vs+Du8b
Message-ID: <1332478086.5721.17.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
From: Mike Galbraith <efault@gmx.de>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Fri, 23 Mar 2012 05:48:06 +0100
In-Reply-To: <20120322202418.GA8569@sgi.com>
References: <20120314151717.GA2435@linux.vnet.ibm.com>
	 <20120314165657.GA19117@linux.vnet.ibm.com>
	 <1331779343.14263.6.camel@marge.simpson.net>
	 <1331780831.14263.15.camel@marge.simpson.net>
	 <20120315175933.GB8705@sgi.com>
	 <1331882861.11010.13.camel@marge.simpson.net>
	 <1331885384.11010.15.camel@marge.simpson.net>
	 <1331887535.11010.18.camel@marge.simpson.net>
	 <20120316172850.GC31290@sgi.com>
	 <1332430533.11517.75.camel@marge.simpson.net>
	 <20120322202418.GA8569@sgi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 15:24 -0500, Dimitri Sivanich wrote: 
> On Thu, Mar 22, 2012 at 04:35:33PM +0100, Mike Galbraith wrote:

> > > This patch also shows great improvement in the two
> > > rcu_for_each_node_breadth_first() (nothing over 20 usec and most less than
> > > 10 in initial testing).
> > > 
> > > However, there are spinlock holdoffs at the following tracebacks (my nmi
> > > handler does work on the 3.0 kernel):
> > > 
> > > [  584.157019]  [<ffffffff8144c5a0>] nmi+0x20/0x30
> > > [  584.157023]  [<ffffffff8144bc8a>] _raw_spin_lock_irqsave+0x1a/0x30
> > > [  584.157026]  [<ffffffff810c5f18>] force_qs_rnp+0x58/0x170
> > > [  584.157030]  [<ffffffff810c6192>] force_quiescent_state+0x162/0x1d0
> > > [  584.157033]  [<ffffffff810c6c95>] __rcu_process_callbacks+0x165/0x200
> > > [  584.157037]  [<ffffffff810c6d4d>] rcu_process_callbacks+0x1d/0x80
> > > [  584.157041]  [<ffffffff81061eaf>] __do_softirq+0xef/0x220
> > > [  584.157044]  [<ffffffff81454cbc>] call_softirq+0x1c/0x30
> > > [  584.157048]  [<ffffffff810043a5>] do_softirq+0x65/0xa0
> > > [  584.157051]  [<ffffffff81061c85>] irq_exit+0xb5/0xe0
> > > [  584.157054]  [<ffffffff810212c8>] smp_apic_timer_interrupt+0x68/0xa0
> > > [  584.157057]  [<ffffffff81454473>] apic_timer_interrupt+0x13/0x20
> > > [  584.157061]  [<ffffffff8102b352>] native_safe_halt+0x2/0x10
> > > [  584.157064]  [<ffffffff8100adf5>] default_idle+0x145/0x150
> > > [  584.157067]  [<ffffffff810020c6>] cpu_idle+0x66/0xc0
> > 
> > Care to try this?  There's likely a better way to defeat ->qsmask == 0
> > take/release all locks thingy, however, if Paul can safely bail in
> > force_qs_rnp() in tweakable latency for big boxen patch, I should be
> > able to safely (and shamelessly) steal that, and should someone hotplug
> > a CPU, and we race, do the same thing bail for small boxen.
> 
> Tested on a 48 cpu UV system with an interrupt latency test on isolated
> cpus and a moderate to heavy load on the rest of the system.
> 
> This patch appears to take care of all excessive (> 35 usec) RCU-based
> latency in the 3.0 kernel on this particular system for this particular
> setup.  Without the patch, I see many latencies on this system > 150 usec
> (and some > 200 usec).

Figures.  I bet Paul has a better idea though.  Too bad we can't whack
those extra barriers, that would likely wipe RCU from your radar.

-Mike

