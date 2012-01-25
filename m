Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab2AYSPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 13:15:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:42014 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2AYSPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 13:15:08 -0500
Date: Wed, 25 Jan 2012 10:14:41 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steffen Persvold <sp@numascale.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: RCU qsmask !=0 warnings on large-SMP...
Message-ID: <20120125181441.GD2849@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F1FCF02.9060209@numascale-asia.com>
 <20120125140029.GA2534@linux.vnet.ibm.com>
 <4F200F4D.5000201@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F200F4D.5000201@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012518-7282-0000-0000-000005EAFCB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 03:18:53PM +0100, Steffen Persvold wrote:
> On 1/25/2012 15:00, Paul E. McKenney wrote:
> > On Wed, Jan 25, 2012 at 05:44:34PM +0800, Daniel J Blueman wrote:
> []
> > 
> > I do test three-level trees regularly, but on relatively small systems
> > by limiting CONFIG_RCU_FANOUT.  If you are running 64-bit systems
> > with default values of CONFIG_RCU_FANOUT, a 1024-CPU system fits into a
> > two-level tree, so I would guess that you either have more than 1024 CPUs
> > (at least as far as NR_CPUS is concerned) or gaps in your CPU-numbering
> > scheme.
> 
> NR_CPU is set to 4096 (i.e CONFIG_MAXSMP=y) and CONFIG_FCU_FANOUT is 64. We see 3 levels of RCU nodes with this configuration.

Good, that is the expected configuration with that many CPUs.

> >> Has this been encountered previously?
> > 
> > I haven't seen that warning since I was originally developing
> > TREE_PREEMPT_RCU some years back.
> > 
> > Numascale NumaConnect is cache-coherent, right?
> 
> Correct.

Good.

> []
> >>
> >> WARNING: at kernel/rcutree_plugin.h:990
> > 
> > OK, if I have the right version, RCU-sched is trying to do a new grace
> > period, but finds that one of the rcu_node structure's ->qsmask fields
> > indicates that a CPU (or group of CPUs) failed to check into the previous
> > grace period.
> > 
> []
> 
> >>
> >> CPU 48, treason uncloaked, rsp @ ffffffff81a1d000 (rcu_sched),
> >> rsp->gpnum is 4058, rsp->completed is 4057, rnp @ ffffffff81a1d000,
> >> qsmask is 0x1
> >>    0 ffff8803f840d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=0 ri=279
> >> ql=1 qs=..W. b=10 ci=145949 co=0 ca=0
> >>   12 ffff880bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=7 ri=10
> >> ql=2 qs=.R.. b=10 ci=561 co=0 ca=0
> >>   24 ffff8813d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=14
> >> ql=0 qs=.... b=10 ci=406 co=0 ca=0
> >>   36 ffff881bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=5 ri=22
> >> ql=0 qs=.... b=10 ci=215 co=0 ca=0
> >>   48 ffff8823d040d4e0 c=4057 g=4057 pq=1 pgp=4057 qp=0 of=6 ri=14
> >> ql=26 qs=.RWD b=10 ci=7345 co=0 ca=0
> > 
> > And it looks like CPU 48 is the one that did not check in.  What is
> > CONFIG_NO_HZ set to?  If CONFIG_NO_HZ=y, this can legitimately
> > happen, and printing the values of rdp->dynticks->dynticks,
> > rdp->dynticks->dynticks_nesting, rdp->dynticks->dynticks_nmi_nesting,
> > and rdp->dynticks_fqs will determine whether or not the situation is
> > legitimate or not.
> > 
> > If CONFIG_NO_HZ=n, than this should not happen.  In this case, I should
> > be able to provide you with a more focused debug print.
> 
> CONFIG_NO_HZ is not set, so it should not happen. We see that the behavior is the same with CONFIG_NO_HZ=y though, but it takes longer to reproduce usually.

OK, the CONFIG_NO_HZ=n has the least code involved, so it would be best
for debugging.

> >>   60 ffff882bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=16
> >> ql=0 qs=.... b=10 ci=50 co=0 ca=0
> >>   72 ffff8833d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=26
> >> ql=0 qs=.... b=10 ci=22 co=0 ca=0
> []
> 
> >> CPU 48, treason uncloaked, rsp @ ffffffff81a1d000 (rcu_sched),
> >> rsp->gpnum is 4058, rsp->completed is 4057, rnp @ ffffffff81a1d100,
> >> qsmask is 0x8
> >>    0 ffff8803f840d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=0 ri=279
> >> ql=1 qs=..W. b=10 ci=145949 co=0 ca=0
> >>   12 ffff880bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=7 ri=10
> >> ql=3 qs=NR.. b=10 ci=561 co=0 ca=0
> >>   24 ffff8813d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=14
> >> ql=0 qs=.... b=10 ci=406 co=0 ca=0
> >>   36 ffff881bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=5 ri=22
> >> ql=0 qs=.... b=10 ci=215 co=0 ca=0
> >>   48 ffff8823d040d4e0 c=4057 g=4057 pq=1 pgp=4057 qp=0 of=6 ri=19
> >> ql=26 qs=.RWD b=10 ci=7345 co=0 ca=0
> > 
> > Hmmmm...  Same CPU and grace-period number.  This is a repeat of the
> > above printout, correct?
> 
> Because the RCU tree is 3 levels, the printout function we added in the patch gets called 3 times each time with the same RDP but with different RNPs (in rcu_start_gp()).

Ah, good point.  Hmmm...

Looking back at Daniel's original email, we have the root rcu_node
structure with ->qsmask=0x1 (indicating first descendent), the next
level having ->qsmask=0x8 (indicating fourth descendent) and the last
level having ->qsmask=0x1, again indicating first descendent.  So,
zero, 16, 32, 48.  Which agrees with the CPU number below that has not
yet caught up to the current grace period.

Another really odd thing...  If we are starting the new grace period,
we should have incremented rsp->gpnum.  And in fact, we do have
rsp->gpnum being one larger than rsp->completed, as expected.  But
if we have only initialized the root rcu_node structures, how can
the per-CPU rcudata structures know about the new grace period yet?

There was a time when the CPUs could find out early, but I think that
was a long time ago.  Yes, check_for_new_grace_period() does compare
rdp->gpnum against rsp->gpnum, but it calls note_new_gpnum() which
acquires the rnp->lock(), and nothing happens unless __note_new_gpnum()
sees that rnp->gpnum is different rdp->gpnum.

So, it would be very interesting to add the values rdp->mynode->gpnum
and rdp->mynode->completed to your list, perhaps labeling them something
like "rng" and "rnc" respectively.  

Of course, CPU 48 should not have decided that it was done with the
old grace period before clearing its bit.  For that matter, some
CPU somewhere decided that the grace period was done despite the
root rcu_node's ->qsmask being non-zero, which should be prevented
by the:

	if (rnp->qsmask != 0 || rcu_preempt_blocked_readers_cgp(rnp)) {

line in rcu_report_qs_rnp().

3.2 has some event tracing that would be extremely helpful in tracking
this down.  Are you able to run 3.2?

> >>   60 ffff882bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=16
> >> ql=0 qs=.... b=10 ci=50 co=0 ca=0
> >>   72 ffff8833d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=26
> >> ql=0 qs=.... b=10 ci=22 co=0 ca=0
> >> CPU 48, treason uncloaked, rsp @ ffffffff81a1d000 (rcu_sched),
> >> rsp->gpnum is 4058, rsp->completed is 4057, rnp @ ffffffff81a1d800,
> >> qsmask is 0x1
> >>    0 ffff8803f840d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=0 ri=280
> >> ql=1 qs=..W. b=10 ci=145949 co=0 ca=0
> >>   12 ffff880bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=7 ri=11
> >> ql=3 qs=NR.. b=10 ci=561 co=0 ca=0
> >>   24 ffff8813d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=15
> >> ql=0 qs=.... b=10 ci=406 co=0 ca=0
> >>   36 ffff881bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=5 ri=23
> >> ql=0 qs=.... b=10 ci=215 co=0 ca=0
> >>   48 ffff8823d040d4e0 c=4057 g=4057 pq=1 pgp=4057 qp=0 of=6 ri=21
> >> ql=26 qs=.RWD b=10 ci=7345 co=0 ca=0
> > 
> > Same here, but most of the ql= values are larger.  Later printout?
> 
> The loop in rcu_start_gp() releases the node lock between each time it gets a new level in the RCU tree (it has to) :
> 
> 	rcu_for_each_node_breadth_first(rsp, rnp) {
> 		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
> 		rcu_debug_print(rsp, rnp);
> 
> so I guess this allows ql= values to increase maybe, no ?

The ql= levels can increase anyway -- those queues are only accessed by
the corresponding CPU or from stop_machine context.  The small increases
are entirely consistent with your having bits set at all levels of the
rcu_node tree.  The reason I was surprised is that my earlier bugs (as
in before the code hit mainline) only ever resulted in a single level
having a stray bit.

> > 							Thanx, Paul
> > 
> >>   60 ffff882bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=16
> >> ql=0 qs=.... b=10 ci=50 co=0 ca=0
> >>   72 ffff8833d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=26
> >> ql=0 qs=.... b=10 ci=22 co=0 ca=0
> >>
> 
> Thanks for looking into this Paul, we'd be more than happy to test out theories and patches.

The event tracing, particularly the "rcu_grace_period" set, would be
very helpful.

							Thanx, Paul

