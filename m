Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab2BAOVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:21:13 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:58581 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2BAOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:21:12 -0500
Date: Wed, 1 Feb 2012 06:07:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] srcu: Implement call_srcu()
Message-ID: <20120201140734.GD2488@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1328016724.2446.229.camel@twins>
 <4F27F0E6.1040309@redhat.com>
 <1328017807.2446.230.camel@twins>
 <20120131222447.GH2391@linux.vnet.ibm.com>
 <1328091749.2760.34.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328091749.2760.34.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020114-1780-0000-0000-000002CA8457
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00110001; UDB=6.00027371; UTC=2012-02-01
 14:21:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:22:29AM +0100, Peter Zijlstra wrote:
> On Tue, 2012-01-31 at 14:24 -0800, Paul E. McKenney wrote:
> 
> > > > Can we get it back to speed by scheduling a work function on all cpus? 
> > > > wouldn't that force a quiescent state and allow call_srcu() to fire?
> > > > 
> > > > In kvm's use case synchronize_srcu_expedited() is usually called when no
> > > > thread is in a critical section, so we don't have to wait for anything
> > > > except the srcu machinery.
> > > 
> > > OK, I'll try and come up with means of making it go fast again ;-)
> > 
> > I cannot resist suggesting a kthread to do the call_srcu(), which
> > would allow synchronize_srcu_expedited() to proceed with its current
> > brute-force speed.
> 
> Right, so I really don't like to add a kthread per srcu instance.
> Sharing a kthread between all SRCUs will be problematic since these sync
> things can take forever and so the thread will become a bottlneck.

It should be possible to substitute call_rcu_sched() for synchronize_sched()
and use a per-SRCU-instance state machine to avoid a given instance from
blocking progress on the other instances.

> Also, I'd really like to come up with a better means of sync for SRCU
> and not hammer the entire machine (3 times).

We could introduce read-side smp_mb()s and reduce to one machine-hammer
straightforwardly.  It should be possible to make it so that if a given
srcu_struct ever uses synchronize_srcu_expedited(), it is required to
use the slower version of the read-side primitives.

Hmmm..  I should go back and take a look at the 8 or 9 variants that
I posted to LKML when I first worked on this.

> One of the things I was thinking of is adding a sequence counter in the
> per-cpu data. Using that we could do something like:
> 
>   unsigned int seq1 = 0, seq2 = 0, count = 0;
>   int cpu, idx;
> 
>   idx = ACCESS_ONCE(sp->completions) & 1;
> 
>   for_each_possible_cpu(cpu)
> 	seq1 += per_cpu(sp->per_cpu_ref, cpu)->seq;
> 
>   for_each_possible_cpu(cpu)
> 	count += per_cpu(sp->per_cpu_ref, cpu)->c[idx];
> 
>   for_each_possible_cpu(cpu)
> 	seq2 += per_cpu(sp->per_cpu_ref, cpu)->seq;
> 
>   /*
>    * there's no active references and no activity, we pass
>    */
>   if (seq1 == seq2 && count == 0)
> 	return;
> 
>   synchronize_srcu_slow();
> 
> 
> This would add a fast-path which should catch the case Avi outlined
> where we call sync_srcu() when there's no other SRCU activity.

Overflow could give us false positives for workloads with frequent
readers.  Yes, I know you don't like 32-bit systems, but SRCU still has
to work on them.  ;-)

We also need some smp_mb() calls for readers and in the above sequence
for this to have half a chance of working.

> The other thing I was hoping to be able to pull off is add a copy of idx
> into the same cacheline as c[] and abuse cache-coherency to avoid some
> of the sync_sched() calls, but that's currently hurting my brain.

I will check with some hardware architects.  Last I knew, this was not
officially supported, but it cannot hurt to ask again.

I suppose that another approach would be to use bitfields.  Fifteen bits
should be enough for each of the counters, but ouch!  Atomic instructions
would be required to make incrementing all the idx bits safe.

							Thanx, Paul

