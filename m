Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab2CLXPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:15:42 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38580 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab2CLXPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:15:39 -0400
Date: Mon, 12 Mar 2012 16:15:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <eag0628@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org, tj@kernel.org
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
Message-ID: <20120312231532.GI2471@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
 <1331032571.11248.277.camel@twins>
 <CACvQF52tYmG4Bx+L+cTjVRbvQxj=sKiKrxhuv35H=fAFVvQJ2Q@mail.gmail.com>
 <1331048093.11248.317.camel@twins>
 <20120308195825.GC2412@linux.vnet.ibm.com>
 <1331374193.18960.13.camel@twins>
 <20120312175432.GF2471@linux.vnet.ibm.com>
 <1331575097.18960.40.camel@twins>
 <20120312183203.GH2471@linux.vnet.ibm.com>
 <1331583916.18960.56.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331583916.18960.56.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031223-7282-0000-0000-0000074E9C80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 09:25:16PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-03-12 at 11:32 -0700, Paul E. McKenney wrote:
> > And another question I should have asked to begin with...  Would each
> > VMA have its own SRCU domain, or are you thinking in terms of one
> > SRCU domain for all VMAs globally?
> 
> The latter, single domain for all objects.

OK.

> > If the latter, that pushes pretty strongly for per-CPU SRCU callback
> > lists. 
> 
> Agreed. I was under the impression the proposed thing had this, but on
> looking at it again it does not. Shouldn't be hard to add though.

Agreed, but see srcu_barrier()...

> >  Which brings up srcu_barrier() scalability (and yes, I am working
> > on rcu_barrier() scalability).  One way to handle this at least initially
> > is to have srcu_barrier() avoid enqueueing callbacks on CPUs whose
> > callback lists are empty.  In addition, if the loop over all CPUs is
> > preemptible, then there should not be much in the way of realtime issues.
> 
> Why do we have rcu_barrier() and how is it different from
> synchronize_rcu()?

We need rcu_barrier() in order to be able to safely unload modules that
use call_rcu().  If a module fails to invoke rcu_barrier() between its
last call_rcu() and its unloading, then its RCU callbacks can be fatally
disappointed to learn that their callback functions are no longer in
memory.  See http://lwn.net/Articles/202847/ for more info.

While synchronize_rcu() waits only for a grace period, rcu_barrier()
waits for all pre-existing RCU callbacks to be invoked.  There is also
an rcu_barrier_bh() and rcu_barrier_sched().

Of course, if all uses of call_srcu() were to be from the main kernel
(as opposed to from a module), then there would be no need for a
srcu_barrier().  But it seems quite likely that if a call_srcu() is
available, its use from a module won't be far behind -- especially
given that rcutorture is normally built as a kernel module.

							Thanx, Paul

