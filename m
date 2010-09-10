Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0IJQFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:05:35 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51809 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab0IJQFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:05:34 -0400
Date: Fri, 10 Sep 2010 09:05:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, eranian@googlemail.com,
        yanmin_zhang@linux.intel.com, robert.richter@amd.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Per-pmu-per-cpu contexts
Message-ID: <20100910160525.GD2400@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-108b02cfce04ee90b0a07ee0b104baffd39f5934@git.kernel.org>
 <20100910145426.GA5618@nowhere>
 <20100910153750.GC2400@linux.vnet.ibm.com>
 <1284133594.402.94.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284133594.402.94.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 05:46:34PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-09-10 at 08:37 -0700, Paul E. McKenney wrote:
> > > So, you say below that it works because synchronize_srcu(), that
> > > waits for qs after touching pmus, implies synchronize_sched(), right?
> > 
> > Ook...  My current plans to fold SRCU into TREE_RCU would invalidate
> > this assumption.
> > 
> > Maybe we need some sort of primitive that concurrently waits for
> > multiple types of RCU grace periods? 
> 
> Nah, but I was thinking that any kind of preemptible rcu sync would
> imply a sched rcu sync.

Ah!

Although disabling interrupts will block preemptible RCU grace periods
in current implementations (but please don't rely on this!), disabling
preemption will -not- block preemptible RCU grace periods, even given
current TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.  Current
SRCU grace periods are blocked by disabling preemption, but folding it
into the tree/tiny implementations would make SRCU grace periods be no
longer blocked by disabling preemption.

This might change if RCU priority boosting is enabled, due to RCU
grace-period computation and callback invocation moving to a kthread,
but I won't have the guts to make TREE_RCU use kthread by default for
some time.  (Probably a year or so trouble-free experience with RCU
priority boosting/kthreads.)

> If not strictly implied I'd have no problem simply writing:
> 
>   synchronize_rcu_sched();
>   synchronize_srcu();

If that works for you, then we are set!  The only reason to introduce
a combined primitive would be if the latency of the above was too large.

							Thanx, Paul
