Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab2KIAlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 19:41:44 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55621 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757345Ab2KIAln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 19:41:43 -0500
Date: Thu, 8 Nov 2012 16:41:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/1] percpu_rw_semaphore: reimplement to not
 block the readers unnecessarily
Message-ID: <20121109004136.GH2519@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121030184800.GA16129@redhat.com>
 <20121031194135.GA504@redhat.com>
 <20121031194158.GB504@redhat.com>
 <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com>
 <20121102180606.GA13255@redhat.com>
 <20121108134805.GA23870@redhat.com>
 <20121108134849.GB23870@redhat.com>
 <20121108120700.42d438f2.akpm@linux-foundation.org>
 <20121108210843.GF2519@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1211081836180.7134@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211081836180.7134@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110900-7182-0000-0000-00000323C88D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 06:41:10PM -0500, Mikulas Patocka wrote:
> 
> 
> On Thu, 8 Nov 2012, Paul E. McKenney wrote:
> 
> > On Thu, Nov 08, 2012 at 12:07:00PM -0800, Andrew Morton wrote:
> > > On Thu, 8 Nov 2012 14:48:49 +0100
> > > Oleg Nesterov <oleg@redhat.com> wrote:
> > > 
> > > > Currently the writer does msleep() plus synchronize_sched() 3 times
> > > > to acquire/release the semaphore, and during this time the readers
> > > > are blocked completely. Even if the "write" section was not actually
> > > > started or if it was already finished.
> > > > 
> > > > With this patch down_write/up_write does synchronize_sched() twice
> > > > and down_read/up_read are still possible during this time, just they
> > > > use the slow path.
> > > > 
> > > > percpu_down_write() first forces the readers to use rw_semaphore and
> > > > increment the "slow" counter to take the lock for reading, then it
> > > > takes that rw_semaphore for writing and blocks the readers.
> > > > 
> > > > Also. With this patch the code relies on the documented behaviour of
> > > > synchronize_sched(), it doesn't try to pair synchronize_sched() with
> > > > barrier.
> > > > 
> > > > ...
> > > >
> > > >  include/linux/percpu-rwsem.h |   83 +++++------------------------
> > > >  lib/Makefile                 |    2 +-
> > > >  lib/percpu-rwsem.c           |  123 ++++++++++++++++++++++++++++++++++++++++++
> > > 
> > > The patch also uninlines everything.
> > > 
> > > And it didn't export the resulting symbols to modules, so it isn't an
> > > equivalent.  We can export thing later if needed I guess.
> > > 
> > > It adds percpu-rwsem.o to lib-y, so the CONFIG_BLOCK=n kernel will
> > > avoid including the code altogether, methinks?
> > > 
> > > >
> > > > ...
> > > >
> > > > --- /dev/null
> > > > +++ b/lib/percpu-rwsem.c
> > > > @@ -0,0 +1,123 @@
> > > 
> > > That was nice and terse ;)
> > > 
> > > > +#include <linux/percpu-rwsem.h>
> > > > +#include <linux/rcupdate.h>
> > > > +#include <linux/sched.h>
> > > 
> > > This list is nowhere near sufficient to support this file's
> > > requirements.  atomic.h, percpu.h, rwsem.h, wait.h, errno.h and plenty
> > > more.  IOW, if it compiles, it was sheer luck.
> > > 
> > > > +int percpu_init_rwsem(struct percpu_rw_semaphore *brw)
> > > > +{
> > > > +	brw->fast_read_ctr = alloc_percpu(int);
> > > > +	if (unlikely(!brw->fast_read_ctr))
> > > > +		return -ENOMEM;
> > > > +
> > > > +	mutex_init(&brw->writer_mutex);
> > > > +	init_rwsem(&brw->rw_sem);
> > > > +	atomic_set(&brw->slow_read_ctr, 0);
> > > > +	init_waitqueue_head(&brw->write_waitq);
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +void percpu_free_rwsem(struct percpu_rw_semaphore *brw)
> > > > +{
> > > > +	free_percpu(brw->fast_read_ctr);
> > > > +	brw->fast_read_ctr = NULL; /* catch use after free bugs */
> > > > +}
> > > > +
> > > > +static bool update_fast_ctr(struct percpu_rw_semaphore *brw, unsigned int val)
> > > > +{
> > > > +	bool success = false;
> > > > +
> > > > +	preempt_disable();
> > > > +	if (likely(!mutex_is_locked(&brw->writer_mutex))) {
> > > > +		__this_cpu_add(*brw->fast_read_ctr, val);
> > > > +		success = true;
> > > > +	}
> > > > +	preempt_enable();
> > > > +
> > > > +	return success;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Like the normal down_read() this is not recursive, the writer can
> > > > + * come after the first percpu_down_read() and create the deadlock.
> > > > + */
> > > > +void percpu_down_read(struct percpu_rw_semaphore *brw)
> > > > +{
> > > > +	if (likely(update_fast_ctr(brw, +1)))
> > > > +		return;
> > > > +
> > > > +	down_read(&brw->rw_sem);
> > > > +	atomic_inc(&brw->slow_read_ctr);
> > > > +	up_read(&brw->rw_sem);
> > > > +}
> > > > +
> > > > +void percpu_up_read(struct percpu_rw_semaphore *brw)
> > > > +{
> > > > +	if (likely(update_fast_ctr(brw, -1)))
> > > > +		return;
> > > > +
> > > > +	/* false-positive is possible but harmless */
> > > > +	if (atomic_dec_and_test(&brw->slow_read_ctr))
> > > > +		wake_up_all(&brw->write_waitq);
> > > > +}
> > > > +
> > > > +static int clear_fast_ctr(struct percpu_rw_semaphore *brw)
> > > > +{
> > > > +	unsigned int sum = 0;
> > > > +	int cpu;
> > > > +
> > > > +	for_each_possible_cpu(cpu) {
> > > > +		sum += per_cpu(*brw->fast_read_ctr, cpu);
> > > > +		per_cpu(*brw->fast_read_ctr, cpu) = 0;
> > > > +	}
> > > > +
> > > > +	return sum;
> > > > +}
> > > > +
> > > > +/*
> > > > + * A writer takes ->writer_mutex to exclude other writers and to force the
> > > > + * readers to switch to the slow mode, note the mutex_is_locked() check in
> > > > + * update_fast_ctr().
> > > > + *
> > > > + * After that the readers can only inc/dec the slow ->slow_read_ctr counter,
> > > > + * ->fast_read_ctr is stable. Once the writer moves its sum into the slow
> > > > + * counter it represents the number of active readers.
> > > > + *
> > > > + * Finally the writer takes ->rw_sem for writing and blocks the new readers,
> > > > + * then waits until the slow counter becomes zero.
> > > > + */
> > > 
> > > Some overview of how fast/slow_read_ctr are supposed to work would be
> > > useful.  This comment seems to assume that the reader already knew
> > > that.
> > > 
> > > > +void percpu_down_write(struct percpu_rw_semaphore *brw)
> > > > +{
> > > > +	/* also blocks update_fast_ctr() which checks mutex_is_locked() */
> > > > +	mutex_lock(&brw->writer_mutex);
> > > > +
> > > > +	/*
> > > > +	 * 1. Ensures mutex_is_locked() is visible to any down_read/up_read
> > > > +	 *    so that update_fast_ctr() can't succeed.
> > > > +	 *
> > > > +	 * 2. Ensures we see the result of every previous this_cpu_add() in
> > > > +	 *    update_fast_ctr().
> > > > +	 *
> > > > +	 * 3. Ensures that if any reader has exited its critical section via
> > > > +	 *    fast-path, it executes a full memory barrier before we return.
> > > > +	 */
> > > > +	synchronize_sched();
> > > 
> > > Here's where I get horridly confused.  Your patch completely deRCUifies
> > > this code, yes?  Yet here we're using an RCU primitive.  And we seem to
> > > be using it not as an RCU primitive but as a handy thing which happens
> > > to have desirable side-effects.  But the implementation of
> > > synchronize_sched() differs considerably according to which rcu
> > > flavor-of-the-minute you're using.
> > 
> > The trick is that the preempt_disable() call in update_fast_ctr()
> > acts as an RCU read-side critical section WRT synchronize_sched().
> > 
> > The algorithm would work given rcu_read_lock()/rcu_read_unlock() and
> > synchronize_rcu() in place of preempt_disable()/preempt_enable() and
> > synchronize_sched().  The real-time guys would prefer the change
> > to rcu_read_lock()/rcu_read_unlock() and synchronize_rcu(), now that
> > you mention it.
> > 
> > Oleg, Mikulas, any reason not to move to rcu_read_lock()/rcu_read_unlock()
> > and synchronize_rcu()?
> 
> preempt_disable/preempt_enable is faster than 
> rcu_read_lock/rcu_read_unlock for preemptive kernels.

Significantly faster in this case?  Can you measure the difference
from a user-mode test?

Hmmm.  I have been avoiding moving the preemptible-RCU state from
task_struct to thread_info, but if the difference really matters,
perhaps that needs to be done.

> Regarding real-time response - the region blocked with 
> preempt_disable/preempt_enable contains a few instructions (one test for 
> mutex_is_locked and one increment of percpu variable), so it isn't any 
> threat to real time response. There are plenty of longer regions in the 
> kernel that are executed with interrupts or preemption disabled.

Careful.  The real-time guys might take the same every-little-bit approach
to latency that you seem to be taking for CPU cycles.  ;-)

							Thanx, Paul

