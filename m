Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2AYVww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:52:52 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:41682 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab2AYVwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:52:47 -0500
Date: Wed, 25 Jan 2012 13:51:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steffen Persvold <sp@numascale.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: RCU qsmask !=0 warnings on large-SMP...
Message-ID: <20120125215121.GK2849@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F1FCF02.9060209@numascale-asia.com>
 <20120125140029.GA2534@linux.vnet.ibm.com>
 <4F200F4D.5000201@numascale.com>
 <20120125181441.GD2849@linux.vnet.ibm.com>
 <4F206783.2050901@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F206783.2050901@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012521-6148-0000-0000-000002E907A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 09:35:15PM +0100, Steffen Persvold wrote:
> On 1/25/2012 19:14, Paul E. McKenney wrote:
> []
> >>CONFIG_NO_HZ is not set, so it should not happen. We see that the behavior is the same with CONFIG_NO_HZ=y though, but it takes longer to reproduce usually.
> >
> >OK, the CONFIG_NO_HZ=n has the least code involved, so it would be best
> >for debugging.
> 
> Good, that was my thought also when looking at the code. I'm
> reducing NR_CPUS to 512 now to get two levels just for simpler
> debugging (the issue is still present).

OK.  The two-level structure is very heavily tested -- any system with
NR_CPUS > 16 uses two levels.

So you do have something interesting going on.

> []
> >>Because the RCU tree is 3 levels, the printout function we added in the patch gets called 3 times each time with the same RDP but with different RNPs (in rcu_start_gp()).
> >
> >Ah, good point.  Hmmm...
> >
> >Looking back at Daniel's original email, we have the root rcu_node
> >structure with ->qsmask=0x1 (indicating first descendent), the next
> >level having ->qsmask=0x8 (indicating fourth descendent) and the last
> >level having ->qsmask=0x1, again indicating first descendent.  So,
> >zero, 16, 32, 48.  Which agrees with the CPU number below that has not
> >yet caught up to the current grace period.
> >
> >Another really odd thing...  If we are starting the new grace period,
> >we should have incremented rsp->gpnum.  And in fact, we do have
> >rsp->gpnum being one larger than rsp->completed, as expected.  But
> >if we have only initialized the root rcu_node structures, how can
> >the per-CPU rcudata structures know about the new grace period yet?
> >
> >There was a time when the CPUs could find out early, but I think that
> >was a long time ago.  Yes, check_for_new_grace_period() does compare
> >rdp->gpnum against rsp->gpnum, but it calls note_new_gpnum() which
> >acquires the rnp->lock(), and nothing happens unless __note_new_gpnum()
> >sees that rnp->gpnum is different rdp->gpnum.
> >
> >So, it would be very interesting to add the values rdp->mynode->gpnum
> >and rdp->mynode->completed to your list, perhaps labeling them something
> >like "rng" and "rnc" respectively.
> 
> I will add this to the printout.

I see that you did, thank you!

> >Of course, CPU 48 should not have decided that it was done with the
> >old grace period before clearing its bit.  For that matter, some
> >CPU somewhere decided that the grace period was done despite the
> >root rcu_node's ->qsmask being non-zero, which should be prevented
> >by the:
> >
> >	if (rnp->qsmask != 0 || rcu_preempt_blocked_readers_cgp(rnp)) {
> >
> >line in rcu_report_qs_rnp().
> >
> >3.2 has some event tracing that would be extremely helpful in tracking
> >this down.  Are you able to run 3.2?
> 
> Yes, 3.2.1 is our debug target right now.

OK, good!  Could you please add an "ftrace_dump(DUMP_ALL)" before you
print the first set of error messages?  (Preferably set up so that
you only dump once!)

Then before you start testing, could you please enable the
rcu_grace_period and rcu_grace_period_init trace events?  This should
get a good picture of the sequence of grace-period-related events leading
up to the failure.

You will need to build the kernel with CONFIG_RCU_TRACE=y.

The usual commands suffice to enable tracing:

	echo 1 > /sys/kernel/debug/tracing/events/rcu_grace_period/enable
	echo 1 > /sys/kernel/debug/tracing/events/rcu_grace_period_init/enable

This should give some history that might help understand why the previous
grace period ended before the CPUs had all checked in.  Maybe even why
the rcu_node structures got advance notice of the new grace period...

> []
> >>>Same here, but most of the ql= values are larger.  Later printout?
> >>
> >>The loop in rcu_start_gp() releases the node lock between each time it gets a new level in the RCU tree (it has to) :
> >>
> >>	rcu_for_each_node_breadth_first(rsp, rnp) {
> >>		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
> >>		rcu_debug_print(rsp, rnp);
> >>
> >>so I guess this allows ql= values to increase maybe, no ?
> >
> >The ql= levels can increase anyway -- those queues are only accessed by
> >the corresponding CPU or from stop_machine context.  The small increases
> >are entirely consistent with your having bits set at all levels of the
> >rcu_node tree.  The reason I was surprised is that my earlier bugs (as
> >in before the code hit mainline) only ever resulted in a single level
> >having a stray bit.
> 
> Ok.
> 
> []
> >>
> >>Thanks for looking into this Paul, we'd be more than happy to test out theories and patches.
> >
> >The event tracing, particularly the "rcu_grace_period" set, would be
> >very helpful.
> 
> Are you talking about the data from /sys/kernel/debug/rcu/ ? I have
> CONFIG_RCU_TRACE (and consequently CONFIG_TREE_RCU_TRACE) set, is
> this enough to get the event data you want ?

Yep, if you have CONFIG_RCU_TRACE=y, then the two tracepoints should
be available.

							Thanx, Paul

