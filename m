Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1ACTGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:06:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62729 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab1ACTGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:06:39 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=MsfxUTlnwtkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=L65Ci2r-81WHP9RreSsA:9 a=AYXiZG3S4vDJDYPj_cgA:7 a=pHkShnxYia06tUuivCFWpDOd1VYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][RT][PATCH 3/4] rtmutex: Revert Optimize rt lock wakeup
From: Steven Rostedt <rostedt@goodmis.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        ThomasGleixner <tglx@linutronix.de>,
        Peter Morreale <PMorreale@novell.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4D19A8B20200005A00079658@novprvoes0310.provo.novell.com>
References: <20101223224755.078983538@goodmis.org>
	 <20101223225116.729981172@goodmis.org>
	 <4D13DF250200005A000793E1@novprvoes0310.provo.novell.com>
	 <1293166464.22802.415.camel@gandalf.stny.rr.com>
	 <4D19A8B20200005A00079658@novprvoes0310.provo.novell.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 03 Jan 2011 14:06:36 -0500
Message-ID: <1294081596.3948.192.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-28 at 07:06 -0700, Gregory Haskins wrote:
> >>> On 12/23/2010 at 11:54 PM, in message

> > Sure, but as I said, it is mostly broken anyway. I could even insert
> > some tracepoints to show that this is always missed (heck I'll add an
> > unlikely and do the branch profiler ;-)
> 
> Well, I think that would be a good datapoint and is one of the things I'd like to see.

OK, here it is, after running a simple "dbench 10":

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
     150   726979  99 wakeup_next_waiter             rtmutex.c            581

And the patch I added:

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 318d7ed..dacdcb6 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -578,7 +578,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 		smp_mb();
 
 		/* If !RUNNING && !RUNNING_MUTEX */
-		if (pendowner->state & ~TASK_RUNNING_MUTEX)
+		if (unlikely(pendowner->state & ~TASK_RUNNING_MUTEX))
 			wake_up_process_mutex(pendowner);
 	}
 

Interesting that we hit 150 times that the new owner was already awake.
Perhaps it was because the new owner was about to spin on a spinlock
after it had put itself into the TASK_INTERRUPTIBLE state, and it was
woken up by someone else?


> 
> > 
> > The reason is that adaptive spinners spin in some other state than
> > TASK_RUNNING, thus it does not help adaptive spinners at all. I first
> > tried to fix that, but it made dbench run even slower.
> 
> This is why I am skeptical.  You are essentially asserting there are two issues here, IIUC:
> 
> 1) The intent of avoiding a wakeup is broken and we take the double whammy of a mb()
> plus the wakeup() anyway.

Yep, this is what I believe is happening.

> 
> 2) mb() is apparently slower than wakeup().

Forget this point, as #1 seems to be the main issue. Also, I'm not sure
it is safe to "fix" this, as I started to try.


> 
> I agree (1) is plausible, though I would like to see the traces to confirm.  Its been a long time
> since I looked at that code, but I think the original code either ran in RUNNING_MUTEX and was
> inadvertently broken in the mean time or the other cpu would have transitioned to RUNNING on
> its own when we flipped the owner before the release-side check was performed.  Or perhaps
> we just plain screwed this up and it was racy ;)  I'm not sure.  But as Peter (M) stated, it seems
> like a shame to walk away from the concept without further investigation.  I think everyone can
> agree that at the very least, if it is in fact taking a double whammy we should fix that.

[ cut out all the 2's since I'm not worried about that now, even if it 
  is not a problem. ]


Now, the way I was going to fix this is to have the adaptive wait be in
TASK_RUNNING state, and then change the state iff we are going to sleep.

But this can be a bit more race. Especially with Lai's new changes. With
the new changes, the waiter->task does not get nulled anymore.

The test to take the lock, now needs to be under the lock->wait_lock
spinlock. We have to grab that lock, and see if the owner is null, and
that we are the next waiter in the queue. Thus, on taking the lock we
need to have something like this:


	if (adaptive_wait(&waiter, orig_owner))
		sleep = 1;
	else
		sleep = 0;

	if (sleep)
		raw_spin_lock(&lock->wait_lock);
		saved_state = rt_set_current_block_state(saved_state);
		if (!lock->owner && &waiter == rt_mutex_top_waiter(lock))
			sleep = 0;
		raw_spin_unlock(&lock->wait_lock);
		if (sleep)
			schedule_rt_mutex(lock);
		saved_state = rt_restore_current_blocked_state(saved_state);
	}

Otherwise we can risk the wakeup_next_waiter() missing the wakeup.

To clarify, we want the adaptive_wait() to run as TASK_RUNNING. Then if
we must sleep, then we must set the state to TASK_UNINTERRUPTIBLE, test
again if we can still the lock, and if not then sleep. Otherwise, if a
wakeup happens just before we set the state to TASK_UNINTERRUPTIBLE,
then we miss the wake up all together.

I can do this change, and see what impact it makes.

I'm also curious if this ever worked? If it did not, then are you sure
your tests that show the benefit of it was true. I don't have a large
scale box at my disposal ATM, so I can only see what this does on 4way
machines.

-- Steve


