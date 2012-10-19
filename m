Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2JSWzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:55:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab2JSWzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:55:03 -0400
Date: Fri, 19 Oct 2012 18:54:41 -0400 (EDT)
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
In-Reply-To: <1350668451.2768.60.camel@twins>
Message-ID: <Pine.LNX.4.64.1210191758570.12753@file.rdu.redhat.com>
References: <20121015190958.GA4799@redhat.com>   <20121015191018.GA4816@redhat.com>
  <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>  
 <20121017165902.GB9872@redhat.com>   <20121017224430.GC2518@linux.vnet.ibm.com>
  <20121018162409.GA28504@redhat.com>   <20121018163833.GK2518@linux.vnet.ibm.com>
  <20121018175747.GA30691@redhat.com>   <Pine.LNX.4.64.1210181525010.32376@file.rdu.redhat.com>
  <1350650286.30157.28.camel@twins>  <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com>
 <1350668451.2768.60.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Oct 2012, Peter Zijlstra wrote:

> > Yes, I tried this approach - it involves doing LOCK instruction on read 
> > lock, remembering the cpu and doing another LOCK instruction on read 
> > unlock (which will hopefully be on the same CPU, so no cacheline bouncing 
> > happens in the common case). It was slower than the approach without any 
> > LOCK instructions (43.3 seconds seconds for the implementation with 
> > per-cpu LOCKed access, 42.7 seconds for this implementation without atomic 
> > instruction; the benchmark involved doing 512-byte direct-io reads and 
> > writes on a ramdisk with 8 processes on 8-core machine).
> 
> So why is that a problem? Surely that's already tons better then what
> you've currently got.

Percpu rw-semaphores do not improve performance at all. I put them there 
to avoid performance regression, not to improve performance.

All Linux kernels have a race condition - when you change block size of a 
block device and you read or write the device at the same time, a crash 
may happen. This bug is there since ever. Recently, this bug started to 
cause major trouble - multiple high profile business sites report crashes 
because of this race condition.

You can fix this race by using a read lock around I/O paths and write lock 
around block size changing, but normal rw semaphore cause cache line 
bouncing when taken for read by multiple processors and I/O performance 
degradation because of it is measurable.

So I put this percpu-rw-semaphore there to fix the crashes and minimize 
performance impact - on x86 it doesn't take any interlocked instructions 
in the read path.

I don't quite understand why are people opposing to this and what do they 
want to do instead? If you pull percpu-rw-semaphores out of the kernel, 
you introduce a performance regression (raw device i/o will be slower on 
3.7 than on 3.6, because on 3.6 it doesn't take any lock at all and on 3.7 
it takes a read lock).

So you have options:
1) don't lock i/o just like on 3.6 and previous versions - you get a fast 
	kernel that randomly crashes
2) lock i/o with normal rw semaphore - you get a kernel that doesn't 
	crash, but that is slower than previous versions
3) lock i/o with percpu rw semaphore - you get kernel that is almost as 
	fast as previous kernels and that doesn't crash

For the users, the option 3) is the best. The users don't care whether it 
looks ugly or not, they care about correctness and performance, that's 
all.

Obviously, you can improve rw semaphores by adding lockdep annotations, or 
by other things (turning rcu_read_lock/sychronize_rcu into 
preempt_disable/synchronize_sched, by using barrier()-synchronize_sched() 
instead of smp_mb()...), but I don't see a reason why do you want to hurt 
users' experience by pulling it out and reverting to state 1) or 2) and 
then, two kernel cycles later, come up with percpu-rw-semaphores again.

Mikulas
