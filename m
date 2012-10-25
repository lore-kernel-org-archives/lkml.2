Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782Ab2JYOy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:54:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210Ab2JYOy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:54:27 -0400
Date: Thu, 25 Oct 2012 10:54:11 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] percpu-rw-semaphores: use rcu_read_lock_sched
In-Reply-To: <20121024161638.GA2465@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.1210251050400.14454@file.rdu.redhat.com>
References: <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
 <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com>
 <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221937550.25995@file.rdu.redhat.com>
 <20121024161638.GA2465@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Oct 2012, Paul E. McKenney wrote:

> On Mon, Oct 22, 2012 at 07:39:16PM -0400, Mikulas Patocka wrote:
> > Use rcu_read_lock_sched / rcu_read_unlock_sched / synchronize_sched
> > instead of rcu_read_lock / rcu_read_unlock / synchronize_rcu.
> > 
> > This is an optimization. The RCU-protected region is very small, so
> > there will be no latency problems if we disable preempt in this region.
> > 
> > So we use rcu_read_lock_sched / rcu_read_unlock_sched that translates
> > to preempt_disable / preempt_disable. It is smaller (and supposedly
> > faster) than preemptible rcu_read_lock / rcu_read_unlock.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> OK, as promised/threatened, I finally got a chance to take a closer look.
> 
> The light_mb() and heavy_mb() definitions aren't doing much for me,
> the code would be cleared with them expanded inline.  And while the
> approach of pairing barrier() with synchronize_sched() is interesting,
> it would be simpler to rely on RCU's properties.  The key point is that
> if RCU cannot prove that a given RCU-sched read-side critical section
> is seen by all CPUs to have started after a given synchronize_sched(),
> then that synchronize_sched() must wait for that RCU-sched read-side
> critical section to complete.

Also note that you can define both light_mb() and heavy_mb() to be 
smp_mb() and slow down the reader path a bit and speed up the writer path.

On architectures with in-order memory access (and thus smp_mb() equals 
barrier()), it doesn't hurt the reader but helps the writer, for example:
#ifdef ARCH_HAS_INORDER_MEMORY_ACCESS
#define light_mb()      smp_mb()
#define heavy_mb()      smp_mb()
#else
#define light_mb()      barrier()
#define heavy_mb()      synchronize_sched()
#endif

Mikulas
