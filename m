Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab0DPNnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 09:43:42 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40014 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757271Ab0DPNnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 09:43:39 -0400
Date: Fri, 16 Apr 2010 06:43:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20100416134336.GA2615@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100408191737.296180458@chello.nl>
 <20100408192722.643778654@chello.nl>
 <1271120731.13059.6.camel@pasglop>
 <20100413034311.GB2772@linux.vnet.ibm.com>
 <1271253110.32749.47.camel@laptop>
 <20100415142852.GA2471@linux.vnet.ibm.com>
 <1271400891.13059.186.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271400891.13059.186.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 04:54:51PM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2010-04-15 at 07:28 -0700, Paul E. McKenney wrote:
> > 
> > Of course, with call_rcu_sched(), the corresponding RCU read-side
> > critical
> > sections are non-preemptible.  Therefore, in CONFIG_PREEMPT_RT, these
> > read-side critical sections must use raw spinlocks.
> > 
> > Can the code in question accommodate these restrictions? 
> 
> What we protect against is always code that hard-disable IRQs (though
> there seem to be a bug in the hugepages code there...). Would that
> work ?

>From the perspective of call_rcu_sched() and synchronize_sched(),
the following things mark RCU-sched read-side critical sections:

1.	rcu_read_lock_sched() and rcu_read_unlock_sched().

2.	preempt_disable() and preempt_enable(), along with anything
	else that disables preemption.

3.	local_bh_disable() and local_bh_enable(), along with anything
	else that disables bottom halves.

4.	local_irq_disable() and local_irq_enable(), along wiht anything
	else that disables hardirqs.

5.	Handlers for NMIs.

So I believe that in this case call_rcu_sched() is your friend.  ;-)

							Thanx, Paul
