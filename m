Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1K1ShG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:37:06 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53358 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab1K1ShF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:37:05 -0500
Date: Mon, 28 Nov 2011 10:31:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 24/28] rcu: Introduce bulk reference
 count
Message-ID: <20111128183124.GH2346@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-24-git-send-email-paulmck@linux.vnet.ibm.com>
 <1322484071.2921.115.camel@twins>
 <20111128171513.GF2346@linux.vnet.ibm.com>
 <1322504279.2921.154.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322504279.2921.154.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112818-5112-0000-0000-00000283339C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 07:17:59PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-28 at 09:15 -0800, Paul E. McKenney wrote:
> 
> > > I'm having trouble with the naming as well as the need for an explicit
> > > new API.
> > > 
> > > To me this looks like a regular (S)RCU variant, nothing to do with
> > > references per-se (aside from the fact that SRCU is a refcounted rcu
> > > variant). Also WTF is this bulk stuff about? Its still a single ref at a
> > > time, not 10s or 100s or whatnot.
> > 
> > It is a bulk reference in comparison to a conventional atomic_inc()-style
> > reference count, which is normally associated with a specific structure.
> > In contrast, doing a bulkref_get() normally protects a group of structures,
> > everything covered by the bulkref_t.
> > 
> > Yes, in theory you could have a global reference counter that protected
> > a group of structures, but in practice we both know that this would not
> > end well.  ;-)
> 
> Well, all the counter based RCUs are basically that. And yes, making
> them scale is 'interesting', however you've done pretty well so far ;-)

Fair point, and thank you for the vote of confidence.  ;-)

Nevertheless, when most people talk to me about explicit reference
counters, they are thinking in terms of a reference counter within a
structure protecting that structure.

> I just hate the name in that it totally obscures the fact that its
> regular SRCU.

OK, what names would you suggest?

> > > > +static inline int bulkref_get(bulkref_t *brp)
> > > > +{
> > > > +	unsigned long flags;
> > > > +	int ret;
> > > > +
> > > > +	local_irq_save(flags);
> > > > +	ret =  __srcu_read_lock(brp);
> > > > +	local_irq_restore(flags);
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static inline void bulkref_put(bulkref_t *brp, int idx)
> > > > +{
> > > > +	unsigned long flags;
> > > > +
> > > > +	local_irq_save(flags);
> > > > +	__srcu_read_unlock(brp, idx);
> > > > +	local_irq_restore(flags);
> > > > +}
> > > 
> > > This seems to be the main gist of the patch, which to me sounds utterly
> > > ridiculous. Why not document that srcu_read_{un,}lock() aren't IRQ safe
> > > and if you want to use it from those contexts you have to fix it up
> > > yourself.
> > 
> > I thought I had documented this, but I guess not.  I will add that.
> 
> Oh, I hadn't checked, it could be.

It wasn't.  I just now fixed it in my local git tree.  ;-)

> > I lost you on the "fix it up yourself" -- what are you suggesting that
> > someone needing to use RCU in this manner actually do?
> 
>   local_irq_save(flags);
>   srcu_read_lock(&my_srcu_domain);
>   local_irq_restore(flags);
> 
> and
> 
>   local_irq_save(flags);
>   srcu_read_unlock(&my_srcu_domain);
>   local_irq_restore(flags)
> 
> Doesn't look to be too hard, or confusing.

Ah, OK, I was under the mistaken impression that lockdep would splat
if you did (for example) srcu_read_lock() in an exception handler and
srcu_read_unlock() in the context of the task that took the exception.

> > > RCU lockdep doesn't do the full validation so it won't actually catch it
> > > if you mess up the irq states, but I guess if you want we could look at
> > > adding that.
> > 
> > Ah, I had missed that.  Yes, it would be very good if that could be added.
> > The vast majority of the uses exit the RCU read-side critical section in
> > the same context that they enter it, so it would be good to check.
> 
> /me adds to TODO list.

Thank you!  Please CC me on this one -- the above fixup would start
failing once lockdep checked for this, right?

							Thanx, Paul

