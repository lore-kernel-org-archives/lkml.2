Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1K2RmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:42:01 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57654 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab1K2RmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:42:00 -0500
Date: Tue, 29 Nov 2011 09:41:47 -0800
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
Message-ID: <20111129174146.GF2331@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-24-git-send-email-paulmck@linux.vnet.ibm.com>
 <1322484071.2921.115.camel@twins>
 <20111128171513.GF2346@linux.vnet.ibm.com>
 <1322504279.2921.154.camel@twins>
 <20111128183124.GH2346@linux.vnet.ibm.com>
 <1322505327.2921.156.camel@twins>
 <1322573615.2921.235.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322573615.2921.235.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112917-7182-0000-0000-00000046DE01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 02:33:35PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-28 at 19:35 +0100, Peter Zijlstra wrote:
> > On Mon, 2011-11-28 at 10:31 -0800, Paul E. McKenney wrote:
> > > >   local_irq_save(flags);
> > > >   srcu_read_lock(&my_srcu_domain);
> > > >   local_irq_restore(flags);
> > > > 
> > > > and
> > > > 
> > > >   local_irq_save(flags);
> > > >   srcu_read_unlock(&my_srcu_domain);
> > > >   local_irq_restore(flags)
> > > > 
> > > > Doesn't look to be too hard, or confusing.
> > > 
> > > Ah, OK, I was under the mistaken impression that lockdep would splat
> > > if you did (for example) srcu_read_lock() in an exception handler and
> > > srcu_read_unlock() in the context of the task that took the exception. 
> > 
> > I don't think it will, lockdep does very little actual validation on the
> > RCU locks other than recording they're held. But if they do, the planned
> > TODO item will get inversed.
> > 
> > Should be easy enough to test I guess.
> 
> OK, so I had me a little peek at lockdep and you're right, it will
> complain.

OK, I will cross that test off my list for today.  ;-)

> Still uprobes can do:
> 
>   local_irq_save(flags);
>   __srcu_read_lock(&mr_srcu_domain);
>   local_irq_restore(flags);

And this is exactly what the bulkref stuff does, so we at least agree
on the implementation.

> However if you object to exposing the __srcu functions (which I can
> understand) you could expose these two functions as
> srcu_read_{,un}lock_raw() or so, to mirror the non-validation also found
> in rcu_dereference_raw()

Good point, the _raw suffix is used elsewhere in RCU for "turn off lockdep",
so it makes sense to use it here as well.

I will change to srcu_read_lock_raw() and srcu_read_unlock_raw().  And
that has the added benefit of getting rid of the alternative names for
the initialization and cleanup functions, so sounds good!  Thank you!

							Thanx, Paul

