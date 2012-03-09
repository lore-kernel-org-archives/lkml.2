Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2CIERy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 23:17:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26380 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab2CIERv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 23:17:51 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=GtLqiBI8nYrhgYroJiIA:9 a=PW_dTA3nZbSF7la6zYIA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331266668.25686.571.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 23:17:48 -0500
In-Reply-To: <1331245213.11248.446.camel@twins>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
	 <1331230991.25686.452.camel@gandalf.stny.rr.com>
	 <1331231287.11248.396.camel@twins>
	 <1331232159.25686.456.camel@gandalf.stny.rr.com>
	 <1331235579.11248.402.camel@twins>
	 <1331237441.25686.469.camel@gandalf.stny.rr.com>
	 <1331238369.11248.426.camel@twins>
	 <1331240882.25686.499.camel@gandalf.stny.rr.com>
	 <1331241627.11248.430.camel@twins>
	 <1331241940.25686.502.camel@gandalf.stny.rr.com>
	 <1331242104.11248.432.camel@twins>
	 <1331242574.25686.505.camel@gandalf.stny.rr.com>
	 <1331242625.11248.433.camel@twins>
	 <1331243078.25686.510.camel@gandalf.stny.rr.com>
	 <1331243642.11248.441.camel@twins>
	 <1331244812.25686.518.camel@gandalf.stny.rr.com>
	 <1331245213.11248.446.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 23:20 +0100, Peter Zijlstra wrote:

> Right, but what guarantees that A will ever get ->d_lock when B releases
> it before B again acquires it?
> 
> B is in a very tight:
> 
> 1:
>  lock ->d_lock
>  trylock ->i_lock
>  unlock ->d_lock
>  goto 1
> 
> loop, while A is doing:
> 
> 1:
>   trylock ->d_lock
>   goto 1
> 
> and with rt-mutex having the equal priority lock stealing this reverts
> to a plain test-and-set lock. There's only a tiny window in which A can
> actually get the lock and that is hampered by B's cpu owning the
> cacheline in exclusive mode.
> 
> I simply cannot see guaranteed progress here.

I'm wondering if this is really even an issue. Yes, with mainline before
ticket locks, a tight spin could be faster and grab the lock. But those
were real test-and-set locks. Here we really don't have a tight spin.
d_lock has a waiter and it will force the unlock into the slow path
which is (removing optional debug code):


raw_spin_lock(&lock->wait_lock);
if (!rt_mutex_has_waiters(lock)) {
  /* false */
}

wakeup_next_waiter(lock);
raw_spin_unlock(&lock->wait_lock);
rt_mutex_adjust_prio(current);



Now that wakeup_next_waiter(lock):

raw_spin_lock_irqsave(&current->pi_lock, flags);
waiter = rt_mutex_top_waiter(lock);
plist_del(&waiter->pi_list_entry, &current->pi_waiters);
rt_mutex_set_owner(lock, NULL);  <<-- here's where the race starts.
                                  The other task can break the loop.
raw_spin_unlock_irqrestore(&current->pi_lock, flags);
/* the unlock acts as a write memory barrier */

rt_mutex_wake_waiter(waiter);


Now the task goes through the entire effort of waking up the spinning
task. It needs to grab the spinlocks of the task's runqueue which is the
runqueue of the CPU of the spinning task.

And it's not done. It then does:

raw_spin_unlock(&lock->wait_lock);
rt_mutex_adjust_prio(current);

Which again grabs the task->pi_lock.

Now it's out of the unlock. But we said we would have it also call a
sched_yield() which will add a bit more overhead here. But after that,
it may grab the lock again keeping the other task from getting it.

OK, lets see what the other lock is doing. Well, it's in the adaptive
loop which is:

rcu_read_lock();
for (;;) {
	if (owner != rt_mutex_owner(lock))
		break;  <<-- This is where it jumps out.
	barrier();
	if (!owner->on_cpu) {
		res = 1;
		break;
	}
	cpu_relax();
}
rcu_read_unlock();

Now, the worse case is we just missed the test. Then it did the barrier
(compile barrier only), the check if the owner is on the cpu and a
cpu_relax(), which may slow it down a little, but so is the owner doing
this too.

The the rcu_read_unlock() which does more compiler barriers and updating
the task structure's rcu_read_lock_nesting numbers.

But once this is done, it does...

raw_spin_lock(&lock->wait_lock).

And once we are here, the game is over. The first task had to do
everything stated after the setting of owner to this task, and loop
around and get to the lock -> d_lock again. The wait_lock is a ticket
spinlock, thus once the second task gets here, the first task wont be
able to get in. And the task will be able to get the lock.

But cache is getting bigger, and CPUs are getting faster compared to
memory. It may still be a case where forward progress is prevented, I
don't know.

My last response about not doing lateral steals on locks with priority
is faulty, as the lock in question isn't the one with priority. But this
could be solved by having the unlock be special. A spin_unlock_rt() or
something that tells the lock to not let the new owner have a lateral
steal.

This is only needed if it really is a race, and the first task can do
the wakeup and call to schedule() all before the second task can grab
that lock.

-- Steve

