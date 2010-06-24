Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab0FXQll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:41:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33467 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab0FXQlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:41:39 -0400
Date: Thu, 24 Jun 2010 09:41:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 24/52] fs: dcache reduce d_parent locking
Message-ID: <20100624164135.GG2373@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100624030212.676457061@suse.de>
 <20100624030729.395195069@suse.de>
 <1277369062.1875.928.camel@laptop>
 <20100624150706.GF10441@laptop>
 <20100624153218.GC2373@linux.vnet.ibm.com>
 <20100624160524.GM10441@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624160524.GM10441@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 02:05:24AM +1000, Nick Piggin wrote:
> On Thu, Jun 24, 2010 at 08:32:18AM -0700, Paul E. McKenney wrote:
> > On Fri, Jun 25, 2010 at 01:07:06AM +1000, Nick Piggin wrote:
> > > On Thu, Jun 24, 2010 at 10:44:22AM +0200, Peter Zijlstra wrote:
> > > > On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> > > > > Use RCU property of dcache to simplify locking in some places where we
> > > > > take d_parent and d_lock.
> > > > > 
> > > > > Comment: don't need rcu_deref because we take the spinlock and recheck it.
> > > > 
> > > > But does the LOCK barrier imply a DATA DEPENDENCY barrier? (It does on
> > > > x86, and the compiler barrier implied by spin_lock() suffices to replace
> > > > ACCESS_ONCE()).
> > > 
> > > Well the dependency we care about is from loading the parent pointer
> > > to acquiring its spinlock. But we can't possibly have stale data given
> > > to the spin lock operation itself because it is a RMW.
> > 
> > As long as you check for the structure being valid after acquiring the
> > lock, I agree.  Otherwise, I would be concerned about the following
> > sequence of events:
> > 
> > 1.	CPU 0 picks up a pointer to a given data element.
> > 
> > 2.	CPU 1 removes this element from the list, drops any locks that
> > 	it might have, and starts waiting for a grace period to
> > 	elapse.
> > 
> > 3.	CPU 0 acquires the lock, does some operation that would
> > 	be appropriate had the element not been removed, then
> > 	releases the lock.
> > 
> > 4.	After the grace period, CPU 1 frees the element, negating
> > 	CPU 0's hard work.
> > 
> > The usual approach is to have a "deleted" flag or some such in the
> > element that CPU 0 would set when removing the element and that CPU 1
> > would check after acquiring the lock.  Which you might well already
> > be doing!  ;-)
> 
> Thanks, yep it's done under RCU, and after taking the lock it rechecks
> to see that it is still reachable by the same pointer (and if not,
> unlocks and retries) so it should be fine.

Very good!!!  ;-)

							Thanx, Paul
