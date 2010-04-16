Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab0DPO5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:57:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:53717 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0DPO5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:57:07 -0400
Subject: Re: [PATCH 01/13] powerpc: Add rcu_read_lock() to gup_fast()
 implementation
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100416143202.GE2615@linux.vnet.ibm.com>
References: <20100408191737.296180458@chello.nl>
	 <20100408192722.643778654@chello.nl> <1271120731.13059.6.camel@pasglop>
	 <20100413034311.GB2772@linux.vnet.ibm.com>
	 <1271253110.32749.47.camel@laptop>
	 <20100415142852.GA2471@linux.vnet.ibm.com>
	 <1271425881.4807.2319.camel@twins>
	 <20100416141745.GC2615@linux.vnet.ibm.com>
	 <1271427819.4807.2353.camel@twins>
	 <20100416143202.GE2615@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 16 Apr 2010 16:56:50 +0200
Message-ID: <1271429810.4807.2390.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 07:32 -0700, Paul E. McKenney wrote:
> On Fri, Apr 16, 2010 at 04:23:39PM +0200, Peter Zijlstra wrote:
> > On Fri, 2010-04-16 at 07:17 -0700, Paul E. McKenney wrote:
> > 
> > > > > Of course, with call_rcu_sched(), the corresponding RCU read-side critical
> > > > > sections are non-preemptible.  Therefore, in CONFIG_PREEMPT_RT, these
> > > > > read-side critical sections must use raw spinlocks.
> > > > 
> > > > OK, so if we fully remove CONFIG_TREE_PREEMPT_RCU (defaulting to y),
> > > > rename all the {call_rcu, rcu_read_lock, rcu_read_unlock,
> > > > synchronize_rcu} functions to {*}_preempt and then add a new
> > > > CONFIG_PREEMPT_RCU that simply maps {*} to either {*}_sched or
> > > > {*}_preempt, we've basically got what I've been asking for for a while,
> > > > no?
> > > 
> > > What would rcu_read_lock_preempt() do in a !CONFIG_PREEMPT kernel?
> > 
> > Same as for a preempt one, since you'd have to be able to schedule()
> > while holding it to be able to do things like mutex_lock().
> 
> So what you really want is something like rcu_read_lock_sleep() rather
> than rcu_read_lock_preempt(), right?  The point is that you want to do
> more than merely preempt, given that it is legal to do general blocking
> while holding a mutex, correct?

Right, but CONFIG_TREE_PREEMPT_RCU=y ends up being that. We could change
the name to _sleep, but we've been calling it preemptible-rcu for a long
while now.
