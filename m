Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971Ab2JSPdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:33:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758951Ab2JSPdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:33:31 -0400
Date: Fri, 19 Oct 2012 11:32:35 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
In-Reply-To: <1350650286.30157.28.camel@twins>
Message-ID: <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com>
References: <20121015190958.GA4799@redhat.com>  <20121015191018.GA4816@redhat.com>
  <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com> 
 <20121017165902.GB9872@redhat.com>  <20121017224430.GC2518@linux.vnet.ibm.com>
  <20121018162409.GA28504@redhat.com>  <20121018163833.GK2518@linux.vnet.ibm.com>
  <20121018175747.GA30691@redhat.com>  <Pine.LNX.4.64.1210181525010.32376@file.rdu.redhat.com>
 <1350650286.30157.28.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Oct 2012, Peter Zijlstra wrote:

> On Thu, 2012-10-18 at 15:28 -0400, Mikulas Patocka wrote:
> > 
> > On Thu, 18 Oct 2012, Oleg Nesterov wrote:
> > 
> > > Ooooh. And I just noticed include/linux/percpu-rwsem.h which does
> > > something similar. Certainly it was not in my tree when I started
> > > this patch... percpu_down_write() doesn't allow multiple writers,
> > > but the main problem it uses msleep(1). It should not, I think.
> > 
> > synchronize_rcu() can sleep for hundred milliseconds, so msleep(1) is not 
> > a big problem.
> 
> That code is beyond ugly though.. it should really not have been merged.
> 
> There's absolutely no reason for it to use RCU except to make it more

So if you can do an alternative implementation without RCU, show it. The 
goal is - there should be no LOCK instructions on the read path and as 
few barriers as possible.

> complicated. And as Oleg pointed out that msleep() is very ill
> considered.
> 
> The very worst part of it seems to be that nobody who's usually involved
> with locking primitives was ever consulted (Linus, PaulMck, Oleg, Ingo,
> tglx, dhowells and me). It doesn't even have lockdep annotations :/
> 
> So the only reason you appear to use RCU is because you don't actually
> have a sane way to wait for count==0. And I'm contesting rcu_sync() is
> sane here -- for the very simple reason you still need while (count)
> loop right after it.
> 
> So it appears you want an totally reader biased, sleepable rw-lock like
> thing?

Yes.

> So did you consider keeping the inc/dec on the same per-cpu variable?
> Yes this adds a potential remote access to dec and requires you to use
> atomics, but I would not be surprised if the inc/dec were mostly on the
> same cpu most of the times -- which might be plenty fast for what you
> want.

Yes, I tried this approach - it involves doing LOCK instruction on read 
lock, remembering the cpu and doing another LOCK instruction on read 
unlock (which will hopefully be on the same CPU, so no cacheline bouncing 
happens in the common case). It was slower than the approach without any 
LOCK instructions (43.3 seconds seconds for the implementation with 
per-cpu LOCKed access, 42.7 seconds for this implementation without atomic 
instruction; the benchmark involved doing 512-byte direct-io reads and 
writes on a ramdisk with 8 processes on 8-core machine).

> If you've got coherent per-cpu counts, you can better do the
> waitqueue/wake condition for write_down.

synchronize_rcu() is way slower than msleep(1) - so I don't see a reason 
why should it be complicated to avoid msleep(1).

> It might also make sense to do away with the mutex, there's no point in
> serializing the wakeups in the p->locked case of down_read.

The advantage of a mutex is that it is already protected against 
starvation. If I replace the mutex with a wait queue and retry, there is 
no starvation protection.

> Furthermore,
> p->locked seems a complete duplicate of the mutex state, so removing the
> mutex also removes that duplication.

We could replace if (p->locked) with if (mutex_is_locked(p->mtx))

> Also, that CONFIG_x86 thing.. *shudder*...

Mikulas
