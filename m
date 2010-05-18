Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0EROUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:20:19 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52149 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310Ab0EROUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:20:13 -0400
Date: Tue, 18 May 2010 07:20:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@relay.de.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC tip/core/rcu 23/23] vhost: add __rcu annotations
Message-ID: <20100518142008.GD2302@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100512230057.GH2303@linux.vnet.ibm.com>
 <1273756043.5605.3542.camel@twins>
 <20100513152340.GA2879@linux.vnet.ibm.com>
 <20100517203349.GA14994@redhat.com>
 <20100517210606.GW2320@linux.vnet.ibm.com>
 <20100517220025.GA1366@Krystal>
 <20100517230533.GX2320@linux.vnet.ibm.com>
 <20100517234025.GA11700@Krystal>
 <20100518003429.GA2320@linux.vnet.ibm.com>
 <20100518013528.GA21866@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518013528.GA21866@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 09:35:28PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Mon, May 17, 2010 at 07:40:25PM -0400, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Mon, May 17, 2010 at 06:00:25PM -0400, Mathieu Desnoyers wrote:

[ . . . ]

> > > > But perhaps we should be simply treating this as a use-after-free
> > > > problem, so that RCU is not directly involved. Isn't that the standard
> > > > use of debugobjects anyway?
> > > 
> > > OK so we could tie "rcu_dereference" do debugobjects, and free would be
> > > a standard free. Yes, I think it could be done. It looks a bit like the
> > > memory allocation debugging code. If we know that a certain
> > > rcu_dereference always access dynamically allocated memory, we could
> > > probably add some checks there based on the memory allocator debug
> > > objects.
> > 
> > We probably need vhost to add code at the end of the relevant RCU
> > read-side critical section checking that the pointers returned by
> > any rcu_dereference() calls still point to valid memory.  Don't get
> > me wrong, your approach could find bugs in which someone forgot to
> > remove the RCU-protected structure from a public list, but it could
> > not detect failure to wait a grace period between the time of removal
> > and the time of freeing.
> 
> Good point too. So something like a new rcu_unreference() (or feel free
> to find any better name) ;) that would be compiled out normally, but
> would call into debugobjects might do the trick. We would have to add
> these annotations to match every rcu_dereference() though, might means a
> lot of new lines of code. On the plus side, that looks like a good audit
> of RCU read-side use. ;)

My first thought is that we have added quite a bit of RCU consistency
check code in the past few months, so we should see what bugs they find
and what bugs escape.  It is all too easy to create consistency check
code that is more trouble than it is worth.

But in the meantime, let's see what would be required to check for
failures to insert grace-period delays:

o	There would need to be something like rcu_unreference(),
	rcu_no_more_readers() or some such after the grace period.
	The update side would then become something like the following:

		oldp = rcu_dereference_protected(gp, &mylock);
		rcu_assign_pointer(gp, newp);
		synchronize_rcu();
		rcu_no_more_readers(oldp);
		kfree(oldp);

o	There would need to be something to check all of the pointers
	traversed in the read-side critical sections:

		rcu_read_lock();
		...
		p1 = rcu_dereference(gp1->field1);
		...
		p2 = rcu_dereference(gp2->field2);
		...

		rcu_validate(p1);
		rcu_validate(p2);
		rcu_read_unlock();

One thing that bothers me about this is that we are forcing the developer
to do a lot of extra typing.  For example, rcu_no_more_readers() is in
a truth-and-beauty sense redundant with kfree() -- why type both?  The
same could be said about rcu_validate() and rcu_read_unlock(), but nested
RCU read-side critical sections make this difficult.

Or am I misunderstanding what you are suggesting?

							Thanx, Paul
