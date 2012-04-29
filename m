Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2D2Dy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 23:54:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52518 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755760Ab2D2Dy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 23:54:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18mLUgweWcmkS0LC8VO95sCOagkLhLePe3QIoj4W1
	hLT3T2mN2Xi3OG
Message-ID: <1335671656.7366.40.camel@marge.simpson.net>
Subject: Re: [PATCH RFC tip/core/rcu 6/6] rcu: Reduce cache-miss
 initialization latencies for large systems
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Date: Sun, 29 Apr 2012 05:54:16 +0200
In-Reply-To: <20120428172127.GE2495@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
	 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335501371.10374.30.camel@marge.simpson.net>
	 <20120427151518.GA2419@linux.vnet.ibm.com>
	 <1335588142.7498.21.camel@marge.simpson.net>
	 <20120428172127.GE2495@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-28 at 10:21 -0700, Paul E. McKenney wrote: 
> On Sat, Apr 28, 2012 at 06:42:22AM +0200, Mike Galbraith wrote:
> > On Fri, 2012-04-27 at 08:15 -0700, Paul E. McKenney wrote: 
> > > On Fri, Apr 27, 2012 at 06:36:11AM +0200, Mike Galbraith wrote:
> > > > On Mon, 2012-04-23 at 09:42 -0700, Paul E. McKenney wrote: 
> > > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > 
> > > > > Commit #0209f649 (rcu: limit rcu_node leaf-level fanout) set an upper
> > > > > limit of 16 on the leaf-level fanout for the rcu_node tree.  This was
> > > > > needed to reduce lock contention that was induced by the synchronization
> > > > > of scheduling-clock interrupts, which was in turn needed to improve
> > > > > energy efficiency for moderate-sized lightly loaded servers.
> > > > > 
> > > > > However, reducing the leaf-level fanout means that there are more
> > > > > leaf-level rcu_node structures in the tree, which in turn means that
> > > > > RCU's grace-period initialization incurs more cache misses.  This is
> > > > > not a problem on moderate-sized servers with only a few tens of CPUs,
> > > > 
> > > > With a distro config (4096 CPUs) interrupt latency is bad even on a
> > > > quad.  Traversing empty nodes taking locks and cache misses hurts.
> > > 
> > > Agreed -- and I will be working on an additional patch that makes RCU
> > > avoid initializing its data structures for CPUs that don't exist.
> > 
> > That's still on my todo list too, your initial patch (and my butchery
> > thereof to skip taking lock) showed this helps a heap.
> 
> Indeed, I am a bit worried about the safety of skipping the lock in
> that case.  Either way, if you would rather keep working on this, I
> have no problem pushing it further down my todo list.

It's on my todo because Paul is a busy fellow.  I'd much prefer that RCU
tweaking is done by somebody who fully understands RCU's gizzard (!me).
IOW, I'll fiddle with RCU as time permits/gripes require, but waiting to
test your implementation is the more prudent thing to do.  Heck, as yet,
I haven't even scraped together the time to test your other patches :-/ 

For the nonce, I've done the safe thing, reverted 0209f649 and enabled
tick skew.  Per my measurements, the regression is thus dead, so it's
not as pressing an issue, though some users do still want and need more.

-Mike

