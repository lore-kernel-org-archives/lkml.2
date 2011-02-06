Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1BFXvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:51:44 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49612 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab1BFXvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:51:43 -0500
Date: Sun, 6 Feb 2011 15:51:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        JBeulich@novell.com, efault@gmx.de, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 v2] call_function_many: fix list delete vs add race
Message-ID: <20110206235136.GA23658@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <smp-call-function-peter-reply@mdm.bga.com>
 <smp-call-function-move-writes@mdm.bga.com>
 <1296145360.15234.234.camel@laptop>
 <smp-call-function-list-race@mdm.bga.com>
 <smp-call-function-list-race-fix@mdm.bga.com>
 <ipi-list-reply@mdm.bga.com>
 <smp-call-function-list-race-fix-v2@mdm.bga.com>
 <20110201220026.GD2142@linux.vnet.ibm.com>
 <ipi-paul-reply@mdm.bga.com>
 <20110202041740.GB2129@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202041740.GB2129@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 08:17:40PM -0800, Paul E. McKenney wrote:
> On Tue, Feb 01, 2011 at 02:00:26PM -0800, Milton Miller wrote:
> > On Tue, 1 Feb 2011 about 14:00:26 -0800, "Paul E. McKenney" wrote:
> > > On Tue, Feb 01, 2011 at 01:12:18AM -0600, Milton Miller wrote:

[ . . . ]

> > > 	o	If the bit is set, then we need to process this callback.
> > > 		IRQs are disabled, so we cannot race with ourselves
> > > 		-- our bit will remain set until we clear it.
> > > 		The list_add_rcu() in smp_call_function_many()
> > > 		in conjunction with the list_for_each_entry_rcu()
> > > 		in generic_smp_call_function_interrupt() guarantees
> > > 		that all of the field except for ->refs will be seen as
> > > 		initialized in the common case where we are looking at
> > > 		an callback that has just been enqueued.
> > > 
> > > 		In the uncommon case where we picked up the pointer
> > > 		in list_for_each_entry_rcu() just before the last
> > > 		CPU removed the callback and when someone else
> > > 		immediately recycled it, all bets are off.  We must
> > > 		ensure that we see all initialization via some other
> > > 		means.
> > > 
> > > 		OK, so where is the memory barrier that pairs with the
> > > 		smp_rmb() between the ->cpumask and ->refs checks?
> > > 		It must be before the assignment to ->cpumask.  One
> > > 		candidate is the smp_mb() in csd_lock(), but that does
> > > 		not make much sense.  What we need to do is to ensure
> > > 		that if we see our bit in ->cpumask, that we also see
> > > 		the atomic decrement that previously zeroed ->refs.
> > 
> > We have a full mb in csd_unlock on the cpu that zeroed refs and a full
> > mb in csd_lock on the cpu that sets mask and later refs.
> > 
> > We rely on the atomic returns to order the two atomics, and the 
> > atomic_dec_return to establish a single cpu as the last.  After
> > that atomic is performed we do a full mb in unlock.   At this
> > point all cpus must have visibility to all this prior processing.
> > On the owning cpu we then do a full mb in lock.
> > 
> > How can any of the second party writes after the paired mb in lock be
> > visible and not all of the prior third party writes?
> 
> Because smp_rmb() is not required to order prior writes against
> subsequent reads.  The prior third-party writes are writes, right?
> When you want transitivity (observing n-th party writes that
> n-1-th party observed before n-1-th party's memory barrier), then
> you need a full memory barrier -- smp_mb().

FYI, for an example showing the need for smp_mb() to gain transitivity,
please see the following:

o	http://paulmck.livejournal.com/20061.html
o	http://paulmck.livejournal.com/20312.html

							Thanx, Paul
