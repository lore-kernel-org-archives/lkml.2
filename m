Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab0DPU2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 16:28:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49231 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab0DPU2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 16:28:47 -0400
Date: Fri, 16 Apr 2010 13:28:43 -0700
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
Message-ID: <20100416202843.GM2615@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100415142852.GA2471@linux.vnet.ibm.com>
 <1271425881.4807.2319.camel@twins>
 <20100416141745.GC2615@linux.vnet.ibm.com>
 <1271427819.4807.2353.camel@twins>
 <20100416143202.GE2615@linux.vnet.ibm.com>
 <1271429810.4807.2390.camel@twins>
 <20100416150909.GF2615@linux.vnet.ibm.com>
 <1271430855.4807.2411.camel@twins>
 <20100416164503.GH2615@linux.vnet.ibm.com>
 <1271446622.1674.433.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271446622.1674.433.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 09:37:02PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-04-16 at 09:45 -0700, Paul E. McKenney wrote:
> > o       mutex_lock(): Critical sections need not guarantee
> >         forward progress, as general blocking is permitted.
> > 
> Right, I would argue that they should guarantee fwd progress, but due to
> being able to schedule while holding them, its harder to enforce.
> 
> Anything that is waiting for uncertainty should do so without any locks
> held and simply re-acquire them once such an event does occur.

Agreed.  But holding a small-scope mutex for (say) 60 seconds would not be
a problem (at 120 seconds, you might start seeing softlockup messages).
In contrast, holding off an RCU grace period for 60 seconds might well
OOM the machine, especially a small embedded system with limited memory.

> > So the easy response is "just use SRCU."  Of course, SRCU has some
> > disadvantages at the moment:
> > 
> > o       The return value from srcu_read_lock() must be passed to
> >         srcu_read_unlock().  I believe that I can fix this.
> > 
> > o       There is no call_srcu().  I believe that I can fix this.
> > 
> > o       SRCU uses a flat per-CPU counter scheme that is not particularly
> >         scalable.  I believe that I can fix this.
> > 
> > o       SRCU's current implementation makes it almost impossible to
> >         implement priority boosting.  I believe that I can fix this.
> > 
> > o       SRCU requires explicit initialization of the underlying
> >         srcu_struct.  Unfortunately, I don't see a reasonable way
> >         around this.  Not yet, anyway.
> > 
> > So, is there anything else that you don't like about SRCU?
> 
> No, I quite like SRCU when implemented as preemptible tree RCU, and I
> don't at all mind that last point, all dynamic things need some sort of
> init. All locks certainly have.

Very good!!!  I should clarify, though -- by "explicit initialization",
I mean that there needs to be a run-time call to init_srcu_struct().
Unless there is some clever way to initialize an array of pointers to
per-CPU structures at compile time.  And, conversely, a way to initialize
pointers in a per-CPU structure to point to possibly-different rcu_node
structures.

							Thanx, Paul
