Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1K1SSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:18:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33274 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1K1SSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:18:46 -0500
Message-ID: <1322504279.2921.154.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 24/28] rcu: Introduce bulk reference
 count
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Date: Mon, 28 Nov 2011 19:17:59 +0100
In-Reply-To: <20111128171513.GF2346@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
	 <1320265849-5744-24-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1322484071.2921.115.camel@twins>
	 <20111128171513.GF2346@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 09:15 -0800, Paul E. McKenney wrote:

> > I'm having trouble with the naming as well as the need for an explicit
> > new API.
> > 
> > To me this looks like a regular (S)RCU variant, nothing to do with
> > references per-se (aside from the fact that SRCU is a refcounted rcu
> > variant). Also WTF is this bulk stuff about? Its still a single ref at a
> > time, not 10s or 100s or whatnot.
> 
> It is a bulk reference in comparison to a conventional atomic_inc()-style
> reference count, which is normally associated with a specific structure.
> In contrast, doing a bulkref_get() normally protects a group of structures,
> everything covered by the bulkref_t.
> 
> Yes, in theory you could have a global reference counter that protected
> a group of structures, but in practice we both know that this would not
> end well.  ;-)

Well, all the counter based RCUs are basically that. And yes, making
them scale is 'interesting', however you've done pretty well so far ;-)

I just hate the name in that it totally obscures the fact that its
regular SRCU.

> > > +static inline int bulkref_get(bulkref_t *brp)
> > > +{
> > > +	unsigned long flags;
> > > +	int ret;
> > > +
> > > +	local_irq_save(flags);
> > > +	ret =  __srcu_read_lock(brp);
> > > +	local_irq_restore(flags);
> > > +	return ret;
> > > +}
> > > +
> > > +static inline void bulkref_put(bulkref_t *brp, int idx)
> > > +{
> > > +	unsigned long flags;
> > > +
> > > +	local_irq_save(flags);
> > > +	__srcu_read_unlock(brp, idx);
> > > +	local_irq_restore(flags);
> > > +}
> > 
> > This seems to be the main gist of the patch, which to me sounds utterly
> > ridiculous. Why not document that srcu_read_{un,}lock() aren't IRQ safe
> > and if you want to use it from those contexts you have to fix it up
> > yourself.
> 
> I thought I had documented this, but I guess not.  I will add that.

Oh, I hadn't checked, it could be.

> I lost you on the "fix it up yourself" -- what are you suggesting that
> someone needing to use RCU in this manner actually do?

  local_irq_save(flags);
  srcu_read_lock(&my_srcu_domain);
  local_irq_restore(flags);

and

  local_irq_save(flags);
  srcu_read_unlock(&my_srcu_domain);
  local_irq_restore(flags)

Doesn't look to be too hard, or confusing.

> > RCU lockdep doesn't do the full validation so it won't actually catch it
> > if you mess up the irq states, but I guess if you want we could look at
> > adding that.
> 
> Ah, I had missed that.  Yes, it would be very good if that could be added.
> The vast majority of the uses exit the RCU read-side critical section in
> the same context that they enter it, so it would be good to check.

/me adds to TODO list.

