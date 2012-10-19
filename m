Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab2JSRlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:41:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:52852 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2JSRlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:41:39 -0400
Message-ID: <1350668451.2768.60.camel@twins>
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 19 Oct 2012 19:40:51 +0200
In-Reply-To: <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com>
References: <20121015190958.GA4799@redhat.com>
	  <20121015191018.GA4816@redhat.com>
	 <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
	  <20121017165902.GB9872@redhat.com>
	  <20121017224430.GC2518@linux.vnet.ibm.com>
	 <20121018162409.GA28504@redhat.com>
	  <20121018163833.GK2518@linux.vnet.ibm.com>
	 <20121018175747.GA30691@redhat.com>
	  <Pine.LNX.4.64.1210181525010.32376@file.rdu.redhat.com>
	 <1350650286.30157.28.camel@twins>
	 <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 11:32 -0400, Mikulas Patocka wrote:

> So if you can do an alternative implementation without RCU, show it.

Uhm,,. no that's not how it works. You just don't push through crap like
this and then demand someone else does it better.

But using preempt_{disable,enable} and using synchronize_sched() would
be better (for PREEMPT_RCU) although it wouldn't fix anything
fundamental.

>  The 
> goal is - there should be no LOCK instructions on the read path and as 
> few barriers as possible.

Fine goal, although somewhat arch specific. Also note that there's a
relation between atomics and memory barriers, one isn't necessarily
worse than the other, they all require synchronization of sorts.  

> > So did you consider keeping the inc/dec on the same per-cpu variable?
> > Yes this adds a potential remote access to dec and requires you to use
> > atomics, but I would not be surprised if the inc/dec were mostly on the
> > same cpu most of the times -- which might be plenty fast for what you
> > want.
> 
> Yes, I tried this approach - it involves doing LOCK instruction on read 
> lock, remembering the cpu and doing another LOCK instruction on read 
> unlock (which will hopefully be on the same CPU, so no cacheline bouncing 
> happens in the common case). It was slower than the approach without any 
> LOCK instructions (43.3 seconds seconds for the implementation with 
> per-cpu LOCKed access, 42.7 seconds for this implementation without atomic 
> instruction; the benchmark involved doing 512-byte direct-io reads and 
> writes on a ramdisk with 8 processes on 8-core machine).

So why is that a problem? Surely that's already tons better then what
you've currently got. Also uncontended LOCK is something all x86 vendors
keep optimizing, they'll have to if they want to keep adding CPUs.

> > If you've got coherent per-cpu counts, you can better do the
> > waitqueue/wake condition for write_down.
> 
> synchronize_rcu() is way slower than msleep(1) - so I don't see a reason 
> why should it be complicated to avoid msleep(1).

Its not about slow, a polling write side is just fscking ugly. Also, if
you're already polling that *_sync() is bloody pointless.

> > It might also make sense to do away with the mutex, there's no point in
> > serializing the wakeups in the p->locked case of down_read.
> 
> The advantage of a mutex is that it is already protected against 
> starvation. If I replace the mutex with a wait queue and retry, there is 
> no starvation protection.

Which starvation? writer-writer order? What stops you from adding a list
there yourself? Also, writers had better be rare for this thing, so who
gives a crap?

> > Furthermore,
> > p->locked seems a complete duplicate of the mutex state, so removing the
> > mutex also removes that duplication.
> 
> We could replace if (p->locked) with if (mutex_is_locked(p->mtx))

Quite so.. 

You're also still lacking lockdep annotations...
