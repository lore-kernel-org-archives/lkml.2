Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab0DPPJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 11:09:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46557 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab0DPPJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 11:09:16 -0400
Date: Fri, 16 Apr 2010 08:09:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 01/13] powerpc: Add rcu_read_lock() to gup_fast()
 implementation
Message-ID: <20100416150909.GF2615@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100408192722.643778654@chello.nl>
 <1271120731.13059.6.camel@pasglop>
 <20100413034311.GB2772@linux.vnet.ibm.com>
 <1271253110.32749.47.camel@laptop>
 <20100415142852.GA2471@linux.vnet.ibm.com>
 <1271425881.4807.2319.camel@twins>
 <20100416141745.GC2615@linux.vnet.ibm.com>
 <1271427819.4807.2353.camel@twins>
 <20100416143202.GE2615@linux.vnet.ibm.com>
 <1271429810.4807.2390.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271429810.4807.2390.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 04:56:50PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-04-16 at 07:32 -0700, Paul E. McKenney wrote:
> > On Fri, Apr 16, 2010 at 04:23:39PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2010-04-16 at 07:17 -0700, Paul E. McKenney wrote:
> > > 
> > > > > > Of course, with call_rcu_sched(), the corresponding RCU read-side critical
> > > > > > sections are non-preemptible.  Therefore, in CONFIG_PREEMPT_RT, these
> > > > > > read-side critical sections must use raw spinlocks.
> > > > > 
> > > > > OK, so if we fully remove CONFIG_TREE_PREEMPT_RCU (defaulting to y),
> > > > > rename all the {call_rcu, rcu_read_lock, rcu_read_unlock,
> > > > > synchronize_rcu} functions to {*}_preempt and then add a new
> > > > > CONFIG_PREEMPT_RCU that simply maps {*} to either {*}_sched or
> > > > > {*}_preempt, we've basically got what I've been asking for for a while,
> > > > > no?
> > > > 
> > > > What would rcu_read_lock_preempt() do in a !CONFIG_PREEMPT kernel?
> > > 
> > > Same as for a preempt one, since you'd have to be able to schedule()
> > > while holding it to be able to do things like mutex_lock().
> > 
> > So what you really want is something like rcu_read_lock_sleep() rather
> > than rcu_read_lock_preempt(), right?  The point is that you want to do
> > more than merely preempt, given that it is legal to do general blocking
> > while holding a mutex, correct?
> 
> Right, but CONFIG_TREE_PREEMPT_RCU=y ends up being that. We could change
> the name to _sleep, but we've been calling it preemptible-rcu for a long
> while now.

It is actually not permitted to do general blocking in a preemptible RCU
read-side critical section.  Otherwise, someone is going to block waiting
for a network packet that never comes, thus OOMing the system.

							Thanx, Paul
