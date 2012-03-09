Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab2CIAUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:20:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:44548 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab2CIAUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:20:36 -0500
Date: Fri, 9 Mar 2012 01:20:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
In-Reply-To: <1331237441.25686.469.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1203090111240.2742@ionos>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>  <1331230991.25686.452.camel@gandalf.stny.rr.com>  <1331231287.11248.396.camel@twins>  <1331232159.25686.456.camel@gandalf.stny.rr.com>  <1331235579.11248.402.camel@twins>
 <1331237441.25686.469.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012, Steven Rostedt wrote:

> On Thu, 2012-03-08 at 20:39 +0100, Peter Zijlstra wrote:
> 
> > > For example, we have:
> > > 
> > > @@ -410,7 +411,7 @@ static inline struct dentry *dentry_kill
> > >         if (inode && !spin_trylock(&inode->i_lock)) {
> > >  relock:
> > >                 seq_spin_unlock(&dentry->d_lock);
> > > -               cpu_relax();
> > > +               cpu_chill();
> > >                 return dentry; /* try again with same dentry */
> > >         }
> > > 
> > > By doing the test at the trylock, we can easily hit the deadlock,
> > > because we still hold dentry->d_lock. But by moving the block to the
> > > cpu_chill(), then we are less likely to hit the deadlock.
> > 
> > Actually hitting the deadlock isn't a problem, and doing it in the place
> > of the trylock has the distinct advantage that you can actually get the
> > lock and continue like you want.
> 
> By doing a spin_trydeadlock() while still holding the d_lock, if the
> holder of the i_lock was blocked on that d_lock then it would detect the
> failure, and release the lock and continue the loop. This doesn't solve
> anything. Just because we released the lock, we are still preempting the
> holder of the d_lock, and if we are higher in priority, we will never
> let the owner run.
> 
> That's why I recommended doing it after releasing the lock. Of course
> the d_put() is so screwed up because it's not just two locks involved,
> it's a reverse chain, where this probably wont help.
> 
> But just sleeping a tick sounds like a heuristic that may someday fail.

And it's the only way to deal with it sanely simply because after
dropping d_lock you CANNOT dereference inode->i_lock anymore. Care to
read the fricking locking rules of dcache and friends ?

So yopu need to replace the trylock by try_deadlock() and boost the
lock owner w/o blocking on the lock. That means that you need some
other means to tell the lock owner that you are waiting for it w/o
actually waiting. After you return from try_deadlock() you drop d_lock
and wait for some magic event which is associated to the unlock of
i_lock. There is no other way to deal with reverse lock ordering,
period.

Now go and imagine the mess you have to create to make this work under
all circumstances. My reference to the multiple reader boosting was
not for fun. Though I consider that try_deadlock() idea to be in the
same category of insanity as the original attempts of implementing
requeue_pi with ownerless but boosted rtmutexes ....

Thanks,

	tglx
