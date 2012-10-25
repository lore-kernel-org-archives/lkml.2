Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935703Ab2JYNsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:48:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935668Ab2JYNst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:48:49 -0400
Date: Thu, 25 Oct 2012 09:48:33 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] percpu-rw-semaphores: use light/heavy barriers
In-Reply-To: <20121024235735.GL2465@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.1210250854370.1849@file.rdu.redhat.com>
References: <20121023165912.GA18712@redhat.com> <20121023180558.GF2585@linux.vnet.ibm.com>
 <20121023184123.GB24055@redhat.com> <20121023202902.GJ2585@linux.vnet.ibm.com>
 <20121023203254.GA3410@linux.vnet.ibm.com> <Pine.LNX.4.64.1210231730270.2689@file.rdu.redhat.com>
 <20121024162304.GB2465@linux.vnet.ibm.com> <Pine.LNX.4.64.1210241616540.11796@file.rdu.redhat.com>
 <20121024203636.GK2465@linux.vnet.ibm.com> <Pine.LNX.4.64.1210241640310.18254@file.rdu.redhat.com>
 <20121024235735.GL2465@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Oct 2012, Paul E. McKenney wrote:

> On Wed, Oct 24, 2012 at 04:44:14PM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Wed, 24 Oct 2012, Paul E. McKenney wrote:
> > 
> > > On Wed, Oct 24, 2012 at 04:22:17PM -0400, Mikulas Patocka wrote:
> > > > 
> > > > 
> > > > On Wed, 24 Oct 2012, Paul E. McKenney wrote:
> > > > 
> > > > > On Tue, Oct 23, 2012 at 05:39:43PM -0400, Mikulas Patocka wrote:
> > > > > > 
> > > > > > 
> > > > > > On Tue, 23 Oct 2012, Paul E. McKenney wrote:
> > > > > > 
> > > > > > > On Tue, Oct 23, 2012 at 01:29:02PM -0700, Paul E. McKenney wrote:
> > > > > > > > On Tue, Oct 23, 2012 at 08:41:23PM +0200, Oleg Nesterov wrote:
> > > > > > > > > On 10/23, Paul E. McKenney wrote:
> > > > > > > > > >
> > > > > > > > > >  * Note that this guarantee implies a further memory-ordering guarantee.
> > > > > > > > > >  * On systems with more than one CPU, when synchronize_sched() returns,
> > > > > > > > > >  * each CPU is guaranteed to have executed a full memory barrier since
> > > > > > > > > >  * the end of its last RCU read-side critical section
> > > > > > > > >          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > > > > > 
> > > > > > > > > Ah wait... I misread this comment.
> > > > > > > > 
> > > > > > > > And I miswrote it.  It should say "since the end of its last RCU-sched
> > > > > > > > read-side critical section."  So, for example, RCU-sched need not force
> > > > > > > > a CPU that is idle, offline, or (eventually) executing in user mode to
> > > > > > > > execute a memory barrier.  Fixed this.
> > > > > > 
> > > > > > Or you can write "each CPU that is executing a kernel code is guaranteed 
> > > > > > to have executed a full memory barrier".
> > > > > 
> > > > > Perhaps I could, but it isn't needed, nor is it particularly helpful.
> > > > > Please see suggestions in preceding email.
> > > > 
> > > > It is helpful, because if you add this requirement (that already holds for 
> > > > the current implementation), you can drop rcu_read_lock_sched() and 
> > > > rcu_read_unlock_sched() from the following code that you submitted.
> > > > 
> > > > static inline void percpu_up_read(struct percpu_rw_semaphore *p)
> > > > {
> > > >         /*
> > > >          * Decrement our count, but protected by RCU-sched so that
> > > >          * the writer can force proper serialization.
> > > >          */
> > > >         rcu_read_lock_sched();
> > > >         this_cpu_dec(*p->counters);
> > > >         rcu_read_unlock_sched();
> > > > }
> > > > 
> > > > > > The current implementation fulfills this requirement, you can just add it 
> > > > > > to the specification so that whoever changes the implementation keeps it.
> > > > > 
> > > > > I will consider doing that if and when someone shows me a situation where
> > > > > adding that requirement makes things simpler and/or faster.  From what I
> > > > > can see, your example does not do so.
> > > > > 
> > > > > 							Thanx, Paul
> > > > 
> > > > If you do, the above code can be simplified to:
> > > > {
> > > > 	barrier();
> > > > 	this_cpu_dec(*p->counters);
> > > > }
> > > 
> > > The readers are lightweight enough that you are worried about the overhead
> > > of rcu_read_lock_sched() and rcu_read_unlock_sched()?  Really???
> > > 
> > > 							Thanx, Paul
> > 
> > There was no lock in previous kernels, so we should make it as simple as 
> > possible. Disabling and reenabling preemption is probably not a big deal, 
> > but if don't have to do it, why do it?
> 
> Because I don't consider the barrier()-paired-with-synchronize_sched()
> to be a simplification.

It is a simplification because it makes the code smaller (just one 
instruction on x86):
this_cpu_dec(*p->counters):
   0:   64 ff 08                decl   %fs:(%eax)
preempt_disable()
this_cpu_dec(*p->counters)
preempt_enable():
  10:   89 e2                   mov    %esp,%edx
  12:   81 e2 00 e0 ff ff       and    $0xffffe000,%edx
  18:   ff 42 14                incl   0x14(%edx)
  1b:   64 ff 08                decl   %fs:(%eax)
  1e:   ff 4a 14                decl   0x14(%edx)
  21:   8b 42 08                mov    0x8(%edx),%eax
  24:   a8 08                   test   $0x8,%al
  26:   75 03                   jne    2b

this_cpu_dec is uninterruptible, so there is no reason why would you want 
to put preempt_disable and preempt_enable around it.

Disabling preemption may actually improve performance on RISC machines. 
RISC architectures have load/store instructions and they do not have a 
single instruction to load a value from memory, decrement it and write it 
back. So, on RISC architectures, this_cpu_dec is implemented as: disable 
interrupts, load the value, decrement the value, write the value, restore 
interrupt state. Disabling interrupts slows down because it triggers 
microcode.

For example, on PA-RISC
                preempt_disable();
                (*this_cpu_ptr(counters))--;
                preempt_enable();
is faster than
                this_cpu_dec(*counters);

But on X86, this_cpu_inc(*counters) is faster.

> While we are discussing this, I have been assuming that readers must block
> from time to time.  Is this the case?
> 
> 							Thanx, Paul

Processes that hold the read lock block in the i/o path - they may block 
to wait until the data is read from disk. Or for other reasons.

Mikulas
