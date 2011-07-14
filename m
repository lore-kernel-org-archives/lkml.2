Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab1GNAqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:46:39 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46735 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab1GNAqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:46:38 -0400
Date: Wed, 13 Jul 2011 17:46:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Nikhil Rao <ncrao@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Subject: Re: [RFT][PATCH] sched, cgroup: Optimize load_balance_fair()
Message-ID: <20110714004621.GM2355@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1310557009.2586.28.camel@twins>
 <CAPM31R+cS+eRaFHa2ygxF3ADYyo5Tf9R+snky3U8b5_am6Wtjg@mail.gmail.com>
 <1310590863.2586.37.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310590863.2586.37.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 11:01:03PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-07-13 at 10:13 -0700, Paul Turner wrote:
> > > +static void update_h_load(long cpu)
> > > +{
> > > +       walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
> > > +}
> > 
> > With a list_for_each_entry_reverse_rcu() this could also only operate
> > on the local hierarchy and avoid the tg tree walk. 
> 
> Ah, sadly that primitive cannot exist, rcu list primitives only keeps
> the fwd link.
> 
> Although I guess we could 'fix' that.

We could, at least in theory -- make list_del_rcu() not poison the
->prev link.  Or, given that there are use cases that absolutely cannot
tolerate following ->prev links, have a list_del_rcu_both() or something
so that list_del_rcu() keeps its current error checking.  Oddly enough,
__list_add_rcu() doesn't need to change because the rcu_assign_pointer()
for the predecessor's ->next pointer covers the successor's ->prev
pointer as well.  OK, a comment is clearly needed...

Of course, in a two-way-RCU doubly linked list, p->next->prev is not
necessarily equal to p.

But how deep/wide is the tree and how many cache misses are expected?
Would this solve a real problem?

							Thanx, Paul
