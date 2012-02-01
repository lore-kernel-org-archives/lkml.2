Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab2BAKWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 05:22:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44470 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab2BAKWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 05:22:32 -0500
Subject: Re: [RFC][PATCH] srcu: Implement call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Avi Kivity <avi@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
In-Reply-To: <20120131222447.GH2391@linux.vnet.ibm.com>
References: <1328016724.2446.229.camel@twins> <4F27F0E6.1040309@redhat.com>
	 <1328017807.2446.230.camel@twins>
	 <20120131222447.GH2391@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Feb 2012 11:22:29 +0100
Message-ID: <1328091749.2760.34.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 14:24 -0800, Paul E. McKenney wrote:

> > > Can we get it back to speed by scheduling a work function on all cpus? 
> > > wouldn't that force a quiescent state and allow call_srcu() to fire?
> > > 
> > > In kvm's use case synchronize_srcu_expedited() is usually called when no
> > > thread is in a critical section, so we don't have to wait for anything
> > > except the srcu machinery.
> > 
> > OK, I'll try and come up with means of making it go fast again ;-)
> 
> I cannot resist suggesting a kthread to do the call_srcu(), which
> would allow synchronize_srcu_expedited() to proceed with its current
> brute-force speed.

Right, so I really don't like to add a kthread per srcu instance.
Sharing a kthread between all SRCUs will be problematic since these sync
things can take forever and so the thread will become a bottlneck.

Also, I'd really like to come up with a better means of sync for SRCU
and not hammer the entire machine (3 times).

One of the things I was thinking of is adding a sequence counter in the
per-cpu data. Using that we could do something like:

  unsigned int seq1 = 0, seq2 = 0, count = 0;
  int cpu, idx;

  idx = ACCESS_ONCE(sp->completions) & 1;

  for_each_possible_cpu(cpu)
	seq1 += per_cpu(sp->per_cpu_ref, cpu)->seq;

  for_each_possible_cpu(cpu)
	count += per_cpu(sp->per_cpu_ref, cpu)->c[idx];

  for_each_possible_cpu(cpu)
	seq2 += per_cpu(sp->per_cpu_ref, cpu)->seq;

  /*
   * there's no active references and no activity, we pass
   */
  if (seq1 == seq2 && count == 0)
	return;

  synchronize_srcu_slow();


This would add a fast-path which should catch the case Avi outlined
where we call sync_srcu() when there's no other SRCU activity.

The other thing I was hoping to be able to pull off is add a copy of idx
into the same cacheline as c[] and abuse cache-coherency to avoid some
of the sync_sched() calls, but that's currently hurting my brain.

