Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441Ab2CHTju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:39:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49296 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2CHTjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:39:48 -0500
Message-ID: <1331235579.11248.402.camel@twins>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 20:39:39 +0100
In-Reply-To: <1331232159.25686.456.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
	 <1331230991.25686.452.camel@gandalf.stny.rr.com>
	 <1331231287.11248.396.camel@twins>
	 <1331232159.25686.456.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 13:42 -0500, Steven Rostedt wrote:
> On Thu, 2012-03-08 at 19:28 +0100, Peter Zijlstra wrote:
> > On Thu, 2012-03-08 at 13:23 -0500, Steven Rostedt wrote:
> > > So basically what you tried to do was just set the owner of the lock to
> > > have the priority of the task that wants the lock, until it releases it?
> > > But by doing it without having this task sleep? 
> > 
> > No, by having it sleep ;-)
> > 
> 
> That was the second part of my email.

All I saw there was some rambling about cpu_chill() blocking, which
doesn't make any sense..

> > So you do the full PI sleeping lock thing, except you return fail if you
> > loose the acquisition race on wakeup and you mark this waiter as
> > 'special'.
> > 
> > Then on every rt_mutex block you have to do a deadlock analysis on the
> > PI blocking chain (preferably shared with PI boost traversal of said
> > chain), during that scan you collect all special tagged waiters.
> > 
> > If you find a deadlock, wake all these special waiters and have them
> > return -EDEADLK.
> > 
> > I guess you could also do the full spin_deadlock() and do away with the
> > try part and purely rely on the deadlock detection.
> 
> But do you release the lock first? 

Not sure I get you. Release what lock before what?

> For example, we have:
> 
> @@ -410,7 +411,7 @@ static inline struct dentry *dentry_kill
>         if (inode && !spin_trylock(&inode->i_lock)) {
>  relock:
>                 seq_spin_unlock(&dentry->d_lock);
> -               cpu_relax();
> +               cpu_chill();
>                 return dentry; /* try again with same dentry */
>         }
> 
> By doing the test at the trylock, we can easily hit the deadlock,
> because we still hold dentry->d_lock. But by moving the block to the
> cpu_chill(), then we are less likely to hit the deadlock.

Actually hitting the deadlock isn't a problem, and doing it in the place
of the trylock has the distinct advantage that you can actually get the
lock and continue like you want.

You cannot grab the inode->i_lock without holding ->d_lock because
->d_lock serializes dentry->d_inode. So in that case you have to add
more atomic and uglify the code for no gain what so ever.

Furthermore, by pulling the waiting out your success rate doesn't
improve at all.

So its a loose-loose proposition.

> Perhaps call it, cpu_chill_on_lock().

Nah, that doesn't make any sense.

