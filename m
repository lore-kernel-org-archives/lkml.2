Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab0DPORw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:17:52 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:32837 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724Ab0DPORt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:17:49 -0400
Date: Fri, 16 Apr 2010 07:17:45 -0700
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
Message-ID: <20100416141745.GC2615@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100408191737.296180458@chello.nl>
 <20100408192722.643778654@chello.nl>
 <1271120731.13059.6.camel@pasglop>
 <20100413034311.GB2772@linux.vnet.ibm.com>
 <1271253110.32749.47.camel@laptop>
 <20100415142852.GA2471@linux.vnet.ibm.com>
 <1271425881.4807.2319.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271425881.4807.2319.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 03:51:21PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-04-15 at 07:28 -0700, Paul E. McKenney wrote:
> > On Wed, Apr 14, 2010 at 03:51:50PM +0200, Peter Zijlstra wrote:
> > > On Mon, 2010-04-12 at 20:43 -0700, Paul E. McKenney wrote:
> > > > > So we might have to support the interrupt assumption, at least in some
> > > > > form, with those guys...
> > > > 
> > > > One way to make the interrupt assumption official is to use
> > > > synchronize_sched() rather than synchronize_rcu().
> > > 
> > > Well, call_rcu_sched() then, because the current usage is to use
> > > call_rcu() to free the page directories.
> > > 
> > > Paul, here is a call_rcu_sched() available in kernel/rcutree.c, but am I
> > > right in reading that code that that would not be available for
> > > preemptible RCU?
> > 
> > Both call_rcu_sched() and call_rcu() are always there for you.  ;-)
> > 
> > o	If CONFIG_TREE_RCU (or CONFIG_TINY_RCU), they both have the same
> > 	implementation.
> > 
> > o	If CONFIG_TREE_PREEMPT_RCU, call_rcu_sched() is preemptible and
> > 	call_rcu() is not.
> 
> (The reverse I suspect?)

Indeed:  If CONFIG_TREE_PREEMPT_RCU, call_rcu() is preemptible and
call_rcu_sched() is not.

> > Of course, with call_rcu_sched(), the corresponding RCU read-side critical
> > sections are non-preemptible.  Therefore, in CONFIG_PREEMPT_RT, these
> > read-side critical sections must use raw spinlocks.
> 
> OK, so if we fully remove CONFIG_TREE_PREEMPT_RCU (defaulting to y),
> rename all the {call_rcu, rcu_read_lock, rcu_read_unlock,
> synchronize_rcu} functions to {*}_preempt and then add a new
> CONFIG_PREEMPT_RCU that simply maps {*} to either {*}_sched or
> {*}_preempt, we've basically got what I've been asking for for a while,
> no?

What would rcu_read_lock_preempt() do in a !CONFIG_PREEMPT kernel?

> > Can the code in question accommodate these restrictions?
> 
> Yes, that should do just fine I think.

Cool!!!

							Thanx, Paul
