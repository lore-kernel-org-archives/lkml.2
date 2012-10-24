Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2JXQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:27:16 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60837 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab2JXQ1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:27:15 -0400
Date: Wed, 24 Oct 2012 09:23:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] percpu-rw-semaphores: use light/heavy barriers
Message-ID: <20121024162304.GB2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121018175747.GA30691@redhat.com>
 <20121019192838.GM2518@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
 <20121023165912.GA18712@redhat.com>
 <20121023180558.GF2585@linux.vnet.ibm.com>
 <20121023184123.GB24055@redhat.com>
 <20121023202902.GJ2585@linux.vnet.ibm.com>
 <20121023203254.GA3410@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210231730270.2689@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210231730270.2689@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102416-5112-0000-0000-00000DC9E671
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 05:39:43PM -0400, Mikulas Patocka wrote:
> 
> 
> On Tue, 23 Oct 2012, Paul E. McKenney wrote:
> 
> > On Tue, Oct 23, 2012 at 01:29:02PM -0700, Paul E. McKenney wrote:
> > > On Tue, Oct 23, 2012 at 08:41:23PM +0200, Oleg Nesterov wrote:
> > > > On 10/23, Paul E. McKenney wrote:
> > > > >
> > > > >  * Note that this guarantee implies a further memory-ordering guarantee.
> > > > >  * On systems with more than one CPU, when synchronize_sched() returns,
> > > > >  * each CPU is guaranteed to have executed a full memory barrier since
> > > > >  * the end of its last RCU read-side critical section
> > > >          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > 
> > > > Ah wait... I misread this comment.
> > > 
> > > And I miswrote it.  It should say "since the end of its last RCU-sched
> > > read-side critical section."  So, for example, RCU-sched need not force
> > > a CPU that is idle, offline, or (eventually) executing in user mode to
> > > execute a memory barrier.  Fixed this.
> 
> Or you can write "each CPU that is executing a kernel code is guaranteed 
> to have executed a full memory barrier".

Perhaps I could, but it isn't needed, nor is it particularly helpful.
Please see suggestions in preceding email.

> It would be consistent with the current implementation and it would make 
> it possible to use
> 
> barrier()-synchronize_sched() as biased memory barriers.

But it is simpler to rely on the properties of RCU.  We really should
avoid memory barriers where possible, as they are way too easy to
get wrong.

> ---
> 
> In percpu-rwlocks, CPU 1 executes
> 
> ...make some writes in the critical section...
> barrier();
> this_cpu_dec(*p->counters);
> 
> and the CPU 2 executes
> 
> while (__percpu_count(p->counters))
> 	msleep(1);
> synchronize_sched();
> 
> So, when CPU 2 finishes synchronize_sched(), we must make sure that
> all writes done by CPU 1 are visible to CPU 2.
> 
> The current implementation fulfills this requirement, you can just add it 
> to the specification so that whoever changes the implementation keeps it.

I will consider doing that if and when someone shows me a situation where
adding that requirement makes things simpler and/or faster.  From what I
can see, your example does not do so.

							Thanx, Paul

> Mikulas
> 
> > And I should hasten to add that for synchronize_sched(), disabling
> > preemption (including disabling irqs, further including NMI handlers)
> > acts as an RCU-sched read-side critical section.  (This is in the
> > comment header for synchronize_sched() up above my addition to it.)
> > 	
> > 							Thanx, Paul
> 

