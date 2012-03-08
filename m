Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab2CHSXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:23:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab2CHSXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:23:14 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=6jNYrQyhIvOKx1ulaWcA:9 a=JO6n49mG3CiG_MqjrDYA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331230991.25686.452.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Thu, 08 Mar 2012 13:23:11 -0500
In-Reply-To: <alpine.LFD.2.02.1203072225020.2742@ionos>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 22:49 +0100, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.2.9-rt17 release.
> 
> Changes vs. 3.2.9-rt17:
> 
>   * Cherry-picked a scheduled for 3.2.10 genirq fix
> 
>   * Add missing preemption checks for softirqd wakeups
> 
>   * Implement cpu_chill() and use it in dcache and networking
> 
>     RT suffers from trylock or other busywait loops. When the lock
>     holder / updater is preempted. This is basically the same problem
>     as we experienced with seqlocks and especially their open coded
>     variants. Though it's way harder to solve. 
> 
>     The trylock loops are usually implemented to deal with reverse
>     lock ordering. On !RT this only needs to loop when one of the
>     locks is held on another cpu. On RT the lock holder can be
>     preempted which in turn puts the preempting task into an eternal
>     retry loop.
> 
>     I tried to implement spin_trydeadlock() - thanks Peter for the
>     brilliant function name - which basically boosts the lock holder
>     w/o deadlocking, but it turned out to become a quite horrible mess
>     close to the infamous multiple reader boosting code.

Thanks for the reference :-p

> 
>     Before my brain deadlocked on trylocks I took the easy way out and
>     replaced the cpu_relax() calls in those retry loops with
>     cpu_chill() calls.
> 
>     cpu_chill() defaults to cpu_relax() for !RT. On RT is simply puts
>     the task to sleep for a tick, so the preempted lock holder/updater
>     can make progress.
> 
>     I think that's reasonable as the affected code pathes are not RT
>     critical and not likely to hit. fs operations have no RT
>     guarantees at all, so it might affect random fs scanners which get
>     blocked on a rename or delete operation going on. I don't think
>     that's a real issue. Feel free to yell if you find out that it
>     hurts, but be aware that I might ask _you_ to twist _your_ brain
>     around implementing spin_trydeadlock().
> 

So basically what you tried to do was just set the owner of the lock to
have the priority of the task that wants the lock, until it releases it?
But by doing it without having this task sleep?

I'm guessing the difficulty came with the "waiter"? That's because the
waiter is on the stack of the process that is waiting. If the waiter
isn't waiting, then you can't create the waiter structure, as the stack
isn't available to use.

Did you try it so that it blocks only if the owner is not blocked, and
if the owner blocks, it wakes up the one waiting it on a
spin_trydeadlock()? But this probably has issues if the owner is blocked
on the lock the task has, you would have to do the sleep anyway.

What if you moved the "trydeadlock" into the cpu_chill()? Thus you can
have:

cpu_chill(&parent->d-lock);

on !RT it's still just a cpu_relax(), but on RT it will boost the owner
of the lock, and will block only as long as the owner chain is running.
The difference between cpu_chill() blocking and doing the blocking at
the spin_trydeadlock(), is that here we release a lock which should make
something have forward progress. Doing it before the release of the lock
probably doesn't help. Unless you had spin_trydeadlock() do the release
of the lock too?

It would be interesting to see what was tried.

-- Steve


