Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab0EERr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 13:47:58 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39375 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863Ab0EERra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 13:47:30 -0400
Date: Wed, 5 May 2010 10:47:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Josh Triplett <josh@freedesktop.org>, Oleg Nesterov <oleg@redhat.com>,
       Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 3/4] scheduler: replace migration_thread with cpu_stop
Message-ID: <20100505174725.GA6783@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1272980864-27235-1-git-send-email-tj@kernel.org>
 <1272980864-27235-4-git-send-email-tj@kernel.org>
 <20100505013351.GN2639@linux.vnet.ibm.com>
 <4BE11E29.6040106@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE11E29.6040106@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 09:28:41AM +0200, Tejun Heo wrote:
> Hello,
> 
> On 05/05/2010 03:33 AM, Paul E. McKenney wrote:
> > o	Therefore, when CPU 0 queues the work for CPU 1, CPU 1
> > 	loops right around and processes it.  There will be no
> > 	context switch on CPU 1.
> 
> Yes, that can happen.
> 
> > 	At first glance, this looks safe because:
> > 
> > 	1.	Although there is no context switch, there (presumably)
> > 		can be no RCU read-side critical sections on CPU 1 that
> > 		span this sequence of events.  (As far as I can see,
> > 		any such RCU read-side critical section would be due
> > 		to abuse of rcu_read_lock() and friends.)
> 
> AFAICS, this must hold; otherwise, synchronize_sched_expedited()
> wouldn't have worked in the first place.  On entry to any cpu_stop
> function, there can be no RCU read-side critical section in progress.

Makes sense to me!

The actual requirement is that, on each CPU, there must have been a
context switch between the end of the last RCU read-side critical
section and the end of a successful return from try_stop_cpus().

For CONFIG_TREE_PREEMPT_RCU, the guarantee required is a bit different:
on each CPU, either that CPU must not have been in an RCU read-side
critical section, or, if it was, there must have been a context switch
between the time that CPU entered its RCU read-side critical section
and the memory barrier executed within a successful try_stop_cpus().

As near as I can tell, the current implementation does meet these
requirements (but I do like your suggested change below).

> > 	2.	CPU 1 will acquire and release stopper->lock, and
> > 		further more will do an atomic_dec_and_test() in
> > 		cpu_stop_signal_done().  The former is a weak
> > 		guarantee, but the latter guarantees a memory
> > 		barrier, so that any subsequent code on CPU 1 will
> > 		be guaranteed to see changes on CPU 0 prior to the
> > 		call to synchronize_sched_expedited().
> > 
> > 		The guarantee required is that there will be a
> > 		full memory barrier on each affected CPU between
> > 		the time that try_stop_cpus() is called and the
> > 		time that it returns.
> 
> Ah, right.  I think it would be dangerous to depend on the implicit
> barriers there.  It might work today but it can easily break with
> later implementation detail changes which seem completely unrelated.
> Adding smp_mb() in the cpu_stop function should suffice, right?  It's
> not like the cost of smp_mb() there would mean anything anyway.

If I understand the code correctly, this would be very good!

							Thanx, Paul
