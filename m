Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab2FPGhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:37:21 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47882 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab2FPGhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:37:19 -0400
Date: Fri, 15 Jun 2012 23:36:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 13/15] rcu: Introduce for_each_rcu_flavor()
 and use it
Message-ID: <20120616063655.GA2420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-13-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120615235239.GE7613@leaf>
 <20120616010149.GW2389@linux.vnet.ibm.com>
 <20120616053500.GC8252@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616053500.GC8252@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061606-1976-0000-0000-00000E33C669
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 10:35:00PM -0700, Josh Triplett wrote:
> On Fri, Jun 15, 2012 at 06:01:49PM -0700, Paul E. McKenney wrote:
> > On Fri, Jun 15, 2012 at 04:52:40PM -0700, Josh Triplett wrote:
> > > On Fri, Jun 15, 2012 at 02:06:08PM -0700, Paul E. McKenney wrote:
> > > > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > > > index bd4e41c..75ad92a 100644
> > > > --- a/kernel/rcutree.c
> > > > +++ b/kernel/rcutree.c
> > > > @@ -84,6 +84,7 @@ struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh, call_rcu_bh);
> > > >  DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
> > > >  
> > > >  static struct rcu_state *rcu_state;
> > > > +LIST_HEAD(rcu_struct_flavors);
> > > 
> > > Does any means exist to turn this into a constant array known at compile
> > > time rather than a runtime linked list?  Having this as a compile-time
> > > constant may allow the compiler to unroll for_each_rcu_flavor and
> > > potentially inline the calls inside it.
> > 
> > I could do that, but none of the traversals is anywhere near performance
> > critical, and all the ways I can think of to do this are uglier than
> > the list.
> 
> All of the struct rcu_state instances exist at compile time, so you can
> just create an array of pointers to them:
> 
> static struct rcu_state *const rcu_struct_flavors[] = {
>     &rcu_data,
>     &rcu_bh_data,
> #ifdef CONFIG_TREE_PREEMPT_RCU
>     &rcu_preempt_data,
> #endif
> };
> 
> Then just define for_each_rcu_flavor to iterate over that compile-time
> constant array.  Any reason that wouldn't work?

It could work, but I like the automated response of the current system.
Your array would add one more thing that would need to be manually
kept consistent.  Now, if any of the traversals were on a fastpath,
that would be different.

							Thanx, Paul

