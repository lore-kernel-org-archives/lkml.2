Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab2CHU0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:26:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:56664 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2CHU0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:26:17 -0500
Message-ID: <1331238369.11248.426.camel@twins>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 21:26:09 +0100
In-Reply-To: <1331237441.25686.469.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.02.1203072225020.2742@ionos>
	 <1331230991.25686.452.camel@gandalf.stny.rr.com>
	 <1331231287.11248.396.camel@twins>
	 <1331232159.25686.456.camel@gandalf.stny.rr.com>
	 <1331235579.11248.402.camel@twins>
	 <1331237441.25686.469.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 15:10 -0500, Steven Rostedt wrote:
> 
> By doing a spin_trydeadlock() while still holding the d_lock, if the
> holder of the i_lock was blocked on that d_lock then it would detect the
> failure, and release the lock and continue the loop. This doesn't solve
> anything. Just because we released the lock, we are still preempting the
> holder of the d_lock

->i_lock, right?

> , and if we are higher in priority, we will never let the owner run.

So, suppose:

task-A				task-B

lock ->i_lock
				lock ->d_lock
lock ->d_lock <blocks>
				trylock ->i_lock

In this case B's trylock will insta-fail (with -EDEADLK) and we unlock
->d_lock in the existing retry logic. That dropping of ->d_lock will
then wake A, but since B is higher prio A we don't actually run A and
B's retry loop will re-acquire ->d_lock.

Crap.. there's also the fact that A doesn't get (or stays) boosted.

I can only think of ugly things to do, like on the deadlock scan, force
assign the first waiter of the inverted lock to owner (in this case the
deadlock is on ->d_lock so assign A), so that the moment we release
->d_lock our re-acquisition fails because its already owned by A, at
that point B will block and boost A.

There's just the little detail of having two owners for a little while..

> But just sleeping a tick sounds like a heuristic that may someday fail.

Oh absolutely agreed, ideally someone would find a way to implement the
-EDEADLK stuff for rt-mutex in a way that doesn't make tglx sad and
actually works.
