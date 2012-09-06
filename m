Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430Ab2IFRrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:47:20 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51928 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759372Ab2IFRrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:47:19 -0400
Date: Thu, 6 Sep 2012 10:46:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] Add callback-free CPUs
Message-ID: <20120906174652.GM2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120905213945.GA15216@linux.vnet.ibm.com>
 <1346881720.2600.48.camel@twins>
 <20120905234443.GY3308@linux.vnet.ibm.com>
 <1346926417.2600.73.camel@twins>
 <20120906164745.GF2448@linux.vnet.ibm.com>
 <1346950736.18408.43.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346950736.18408.43.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090617-4242-0000-0000-000002CF65C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 06:58:56PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-06 at 09:47 -0700, Paul E. McKenney wrote:
> > The key point is "would simple put RCU into extended quiescent state".
> > This can only happen if the CPU has no callbacks.  If the CPU does have
> > callbacks, then RCU will need to do some work to advance the callbacks.
> > Advancing the callbacks requires that RCU periodically do work on that
> > CPU, resulting in OS jitter.
> 
> But since its then not actually in adaptive-tick mode (the tick is still
> running) who cares? It will only disable the tick once all preconditions
> are met, this includes RCU being in extended qs, so until that time...

The fact that it is then not actually in adaptive-tick mode is exactly
the problem.  In other words, if the grace-period processing is offloaded
along with the callbacks, then no-CBs CPUs can get into adaptive-tick
mode more quickly than CPUs processing their own CBs.  Getting these
CPUs into adaptive-tick mode more quickly reduces OS jitter, which is
one big expected benefit of adaptive-tick mode.

> > > That way you could run the entire state thing from a kthread with random
> > > affinity, all 'per-cpu' data would still be fine since only the one
> > > kthread will access it, even though locality might suffer somewhat.
> > 
> > Well, the current patch set does move much of the grace-period machinery
> > to a kthread.  Much of the remaining work needs to remain on the CPUs
> > (at least those not in an extended quiescent state) in order to keep
> > the overhead of the read-side primitives and scheduler hooks inexpensive. 
> 
> Ah indeed, what you're saying is that the data required by those hooks
> needs to be accessed locally in order to avoid proper atomic ops.

Yep, that is it!

> So then you do indeed need to break the state machine into two parts,
> and I guess that's the bit you're struggling with.

Exactly!  I should be able to work something out without too much trouble,
but it was not going to happen in time for Plumbers, hence the crude
prototype.

> Still I would not make this more complex than it needs to be, if the
> tick is running we can use this to drive the state machine, if its not,
> we are in extended qs and we don't need to drive the tick.

True, but an important goal of no-CBs CPUs is to spend more time in
tickless mode, thus reducing OS jitter.

							Thanx, Paul

