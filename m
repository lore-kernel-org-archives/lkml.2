Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0DOO3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 10:29:10 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53918 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab0DOO3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 10:29:05 -0400
Date: Thu, 15 Apr 2010 07:28:52 -0700
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
Message-ID: <20100415142852.GA2471@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100408191737.296180458@chello.nl>
 <20100408192722.643778654@chello.nl>
 <1271120731.13059.6.camel@pasglop>
 <20100413034311.GB2772@linux.vnet.ibm.com>
 <1271253110.32749.47.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271253110.32749.47.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 03:51:50PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-04-12 at 20:43 -0700, Paul E. McKenney wrote:
> > > So we might have to support the interrupt assumption, at least in some
> > > form, with those guys...
> > 
> > One way to make the interrupt assumption official is to use
> > synchronize_sched() rather than synchronize_rcu().
> 
> Well, call_rcu_sched() then, because the current usage is to use
> call_rcu() to free the page directories.
> 
> Paul, here is a call_rcu_sched() available in kernel/rcutree.c, but am I
> right in reading that code that that would not be available for
> preemptible RCU?

Both call_rcu_sched() and call_rcu() are always there for you.  ;-)

o	If CONFIG_TREE_RCU (or CONFIG_TINY_RCU), they both have the same
	implementation.

o	If CONFIG_TREE_PREEMPT_RCU, call_rcu_sched() is preemptible and
	call_rcu() is not.

Of course, with call_rcu_sched(), the corresponding RCU read-side critical
sections are non-preemptible.  Therefore, in CONFIG_PREEMPT_RT, these
read-side critical sections must use raw spinlocks.

Can the code in question accommodate these restrictions?

							Thanx, Paul
