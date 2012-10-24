Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935575Ab2JXUg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:36:59 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59039 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935245Ab2JXUg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:36:57 -0400
Date: Wed, 24 Oct 2012 13:36:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] percpu-rw-semaphores: use light/heavy barriers
Message-ID: <20121024203636.GK2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
 <20121023165912.GA18712@redhat.com>
 <20121023180558.GF2585@linux.vnet.ibm.com>
 <20121023184123.GB24055@redhat.com>
 <20121023202902.GJ2585@linux.vnet.ibm.com>
 <20121023203254.GA3410@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210231730270.2689@file.rdu.redhat.com>
 <20121024162304.GB2465@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210241616540.11796@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210241616540.11796@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102420-7282-0000-0000-00000E3BF90F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 04:22:17PM -0400, Mikulas Patocka wrote:
> 
> 
> On Wed, 24 Oct 2012, Paul E. McKenney wrote:
> 
> > On Tue, Oct 23, 2012 at 05:39:43PM -0400, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Tue, 23 Oct 2012, Paul E. McKenney wrote:
> > > 
> > > > On Tue, Oct 23, 2012 at 01:29:02PM -0700, Paul E. McKenney wrote:
> > > > > On Tue, Oct 23, 2012 at 08:41:23PM +0200, Oleg Nesterov wrote:
> > > > > > On 10/23, Paul E. McKenney wrote:
> > > > > > >
> > > > > > >  * Note that this guarantee implies a further memory-ordering guarantee.
> > > > > > >  * On systems with more than one CPU, when synchronize_sched() returns,
> > > > > > >  * each CPU is guaranteed to have executed a full memory barrier since
> > > > > > >  * the end of its last RCU read-side critical section
> > > > > >          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > > 
> > > > > > Ah wait... I misread this comment.
> > > > > 
> > > > > And I miswrote it.  It should say "since the end of its last RCU-sched
> > > > > read-side critical section."  So, for example, RCU-sched need not force
> > > > > a CPU that is idle, offline, or (eventually) executing in user mode to
> > > > > execute a memory barrier.  Fixed this.
> > > 
> > > Or you can write "each CPU that is executing a kernel code is guaranteed 
> > > to have executed a full memory barrier".
> > 
> > Perhaps I could, but it isn't needed, nor is it particularly helpful.
> > Please see suggestions in preceding email.
> 
> It is helpful, because if you add this requirement (that already holds for 
> the current implementation), you can drop rcu_read_lock_sched() and 
> rcu_read_unlock_sched() from the following code that you submitted.
> 
> static inline void percpu_up_read(struct percpu_rw_semaphore *p)
> {
>         /*
>          * Decrement our count, but protected by RCU-sched so that
>          * the writer can force proper serialization.
>          */
>         rcu_read_lock_sched();
>         this_cpu_dec(*p->counters);
>         rcu_read_unlock_sched();
> }
> 
> > > The current implementation fulfills this requirement, you can just add it 
> > > to the specification so that whoever changes the implementation keeps it.
> > 
> > I will consider doing that if and when someone shows me a situation where
> > adding that requirement makes things simpler and/or faster.  From what I
> > can see, your example does not do so.
> > 
> > 							Thanx, Paul
> 
> If you do, the above code can be simplified to:
> {
> 	barrier();
> 	this_cpu_dec(*p->counters);
> }

The readers are lightweight enough that you are worried about the overhead
of rcu_read_lock_sched() and rcu_read_unlock_sched()?  Really???

							Thanx, Paul

