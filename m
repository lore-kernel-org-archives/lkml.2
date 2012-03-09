Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2CICu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 21:50:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13946 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab2CICu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 21:50:27 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=E5NM_T23q5pZQgi2MQsA:9 a=I5VmV4hTFGJwOeiR7U8A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331261425.25686.527.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 21:50:25 -0500
In-Reply-To: <alpine.LFD.2.02.1203090111240.2742@ionos>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
	  <1331230991.25686.452.camel@gandalf.stny.rr.com>
	  <1331231287.11248.396.camel@twins>
	  <1331232159.25686.456.camel@gandalf.stny.rr.com>
	  <1331235579.11248.402.camel@twins>
	 <1331237441.25686.469.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1203090111240.2742@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 01:20 +0100, Thomas Gleixner wrote:
> On Thu, 8 Mar 2012, Steven Rostedt wrote:
> 
> > On Thu, 2012-03-08 at 20:39 +0100, Peter Zijlstra wrote:
> > 
> > > > For example, we have:
> > > > 
> > > > @@ -410,7 +411,7 @@ static inline struct dentry *dentry_kill
> > > >         if (inode && !spin_trylock(&inode->i_lock)) {
> > > >  relock:
> > > >                 seq_spin_unlock(&dentry->d_lock);
> > > > -               cpu_relax();
> > > > +               cpu_chill();
> > > >                 return dentry; /* try again with same dentry */
> > > >         }
> > > > 
> > > > By doing the test at the trylock, we can easily hit the deadlock,
> > > > because we still hold dentry->d_lock. But by moving the block to the
> > > > cpu_chill(), then we are less likely to hit the deadlock.
> > > 
> > > Actually hitting the deadlock isn't a problem, and doing it in the place
> > > of the trylock has the distinct advantage that you can actually get the
> > > lock and continue like you want.
> > 
> > By doing a spin_trydeadlock() while still holding the d_lock, if the
> > holder of the i_lock was blocked on that d_lock then it would detect the
> > failure, and release the lock and continue the loop. This doesn't solve
> > anything. Just because we released the lock, we are still preempting the
> > holder of the d_lock, and if we are higher in priority, we will never
> > let the owner run.
> > 
> > That's why I recommended doing it after releasing the lock. Of course
> > the d_put() is so screwed up because it's not just two locks involved,
> > it's a reverse chain, where this probably wont help.
> > 
> > But just sleeping a tick sounds like a heuristic that may someday fail.
> 
> And it's the only way to deal with it sanely simply because after
> dropping d_lock you CANNOT dereference inode->i_lock anymore. Care to
> read the fricking locking rules of dcache and friends ?

Right, and the solution I proposed does not need to.

> 
> So yopu need to replace the trylock by try_deadlock() and boost the
> lock owner w/o blocking on the lock. That means that you need some
> other means to tell the lock owner that you are waiting for it w/o
> actually waiting. 

Actually, you don't need to tell the lock owner you are waiting for it,
you only need to make the lock itself have a priority, and the owner
will inherit that priority as long as it holds the lock.



> After you return from try_deadlock() you drop d_lock
> and wait for some magic event which is associated to the unlock of
> i_lock. There is no other way to deal with reverse lock ordering,
> period.

No magic event, the owner of the lock will inherit the priority you just
gave it. All the task needs to do next is a sched_yield(), and if the
other task is on the same CPU, it will have the same priority and run.

The boosted priority of the lock and the owner will only last as long as
the owner has the lock. As soon as the owner drops it, the priority is
reset for both the lock and the owner.

> 
> Now go and imagine the mess you have to create to make this work under
> all circumstances. My reference to the multiple reader boosting was
> not for fun. Though I consider that try_deadlock() idea to be in the
> same category of insanity as the original attempts of implementing
> requeue_pi with ownerless but boosted rtmutexes ....

And the solution I proposed has nothing to do with the mess needed to do
the multi priority boost. As it had a waiter on it. This isn't waiting,
it's simulating more what happens in non-rt. That is, the owner of the
lock will have a chance to run.

-- Steve


