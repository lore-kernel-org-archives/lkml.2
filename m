Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571Ab1ETPMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:12:45 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47665 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933183Ab1ETPMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:12:44 -0400
Date: Fri, 20 May 2011 08:12:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Stable <stable@kernel.org>
Subject: Re: [PATCH] rcu: Fix unpaired rcu_irq_enter() from locking
 selftests
Message-ID: <20110520151241.GB2366@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DD58F90.4090506@kernel.org>
 <1305850194-8229-1-git-send-email-fweisbec@gmail.com>
 <20110520083648.GC22802@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520083648.GC22802@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 10:36:48AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > HARDIRQ_ENTER() maps to irq_enter() which calls rcu_irq_enter().
> > But HARDIRQ_EXIT() maps to __irq_exit() which doesn't call
> > rcu_irq_exit().
> > 
> > So for every locking selftest that simulates hardirq disabled,
> > we create an imbalance in the rcu extended quiescent state
> > internal state.
> > 
> > As a result, after the first missing rcu_irq_exit(), subsequent
> > irqs won't exit any extended quiescent state the time of the
> > interrupt servicing. Rcu read side critical section inside irqs
> > on that CPU won't be guaranteed anymore.
> > 
> > To fix this, just use __irq_enter() to simulate the hardirq
> > context. This is sufficient for the locking selftests as we
> > don't need to exit any extended quiescent state or perform
> > any check that irqs normally do when they wake up from idle.
> > 
> > As a side effect, this patch should make it possible to
> > restore
> > "rcu: Decrease memory-barrier usage based on semi-formal proof",
> > which eventually helped finding this bug.
> > 
> > Reported-and-tested-by: Yinghai Lu <yinghai@kernel.org>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Stable <stable@kernel.org>
> > ---
> >  lib/locking-selftest.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
> > index 619313e..507a22f 100644
> > --- a/lib/locking-selftest.c
> > +++ b/lib/locking-selftest.c
> > @@ -144,7 +144,7 @@ static void init_shared_classes(void)
> >  
> >  #define HARDIRQ_ENTER()				\
> >  	local_irq_disable();			\
> > -	irq_enter();				\
> > +	__irq_enter();				\
> >  	WARN_ON(!in_irq());
> >  
> >  #define HARDIRQ_EXIT()				\
> 
> Very nice!
> 
> Note that a cherry-picked version of the manual revert from Paul is upstream 
> now with the main body of RCU changes, so we can do the finegrained split-up 
> queue approach for this one problematic commit (that is no longer problematic).
> 
> I think it can still go in for v2.6.40. Paul, what do you think?

I agree.  I will rebase my split-up version, rebase on that, retest
and push.

							Thanx, Paul
