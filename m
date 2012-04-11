Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab2DKRcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:32:05 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42852 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab2DKRcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:32:02 -0400
Date: Wed, 11 Apr 2012 10:30:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: semaphore and mutex in current Linux kernel (3.2.2)
Message-ID: <20120411173006.GB2473@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com>
 <20120401121943.GA11893@gmail.com>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com>
 <20120403075245.GD26826@gmail.com>
 <4F7DA8FD.1020909@ladisch.de>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9E45@SCYBEXDAG02.amd.com>
 <4F7EC111.4010608@ladisch.de>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9ED2@SCYBEXDAG02.amd.com>
 <20120409184538.GE2430@linux.vnet.ibm.com>
 <491D6B4EAD0A714894D8AD22F4BDE043A33A9E@SCYBEXDAG02.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE043A33A9E@SCYBEXDAG02.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041117-7408-0000-0000-0000041FEF41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 05:04:03AM +0000, Chen, Dennis (SRDC SW) wrote:
> On Tue, Apr 10, 2012 at 2:45 AM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > On Fri, Apr 06, 2012 at 05:47:28PM +0000, Chen, Dennis (SRDC SW) wrote:
> >> On Fri, Apr 6, 2012 at 6:10 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> >> > Chen, Dennis (SRDC SW) wrote:
> >> >
> >> > "On the internet, nobody can hear you being subtle."
> >> >
> >> > If some other process wants to run on the same CPU, needs_resched() is set.
> >> > (This might happen to make the cursor blink, for keyboard input, or when
> >> > somebody starts a rogue process like ps.)
> >> >
> >>
> >> Hmm, I forget that in each timer interrupt, __rcu_pending() will be called, it will call
> >> set_need_resched() to set the TIF_NEED_RESCHED in some condition...
> >> The optimization of mutex work closely with rcu, so fantastic!
> >
> > I must confess that you all lost me on this one.
> >
> > There is a call to set_need_resched() in __rcu_pending(), which is
> > invoked when the current CPU has not yet responded to a non-preemptible
> > RCU grace period for some time.  However, in the common case where the
> > CPUs all respond in reasonable time, __rcu_pending() will never call
> > set_need_resched().
> >
> > However, we really do not want to call set_need_resched() on every call
> > to __rcu_pending().  There is almost certainly a better solution to any
> > problem that might be solved by a per-jiffy call to set_need_resched().
> >
> > So, what are you really trying to do?
> >
> >                                                        Thanx, Paul
> 
> Paul, I must confess that maybe you're right, I've realized the misunderstanding in the previous email.
> But I don't want to pretend that I have a full understanding for your " There is almost certainly a 
> better solution to any problem that might be solved by a per-jiffy call to set_need_resched()", because
> this is related with your last question.
> 
> I just want to measure the performance between semaphore and mutex, before that I looked at the mutex 
> optimization code, and the focus is on the mutex_spin_on_owner() function, I don't know how long it will
> take before some components in the kernel call set_need_resched() to break the while loop. If it's on
> jiffies level, given the time of a process switch possibly in microsecond level, that means current 
> process must spin for several jiffies before it got the mutex lock or go to sleep finally, I can't
> see the benefit here... 

The loop spins only while a given task owns the lock.  This means that
for the loop to spin for several jiffies, one of three things must happen:

1.	The task holding the lock has been running continuously for
	several jiffies.  This would very likely be a bug.  (Why are
	you running CPU bound in the kernel for several jiffies,
	whether or not you are holding a lock?)

2.	The task spinning in mutex_spin_on_owner() happens to be being
	preempted at exactly the same times as the owner is, and so
	by poor luck happens to always see the owner running.

	The probability of this is quite low, should (famous last words!)
	can be safely ignored.

3.	The task spinning in mutex_spin_on_owner() happens to be being
	preempted at exactly the same times that the owner releases
	the lock, and so again by poor luck happens to always see the
	owner running.

	The probability of this is quite low, should (famous last words!)
	can be safely ignored.

Normally, the lock holder either blocks or releases the lock quickly,
so that mutex_spin_on_owner() exits its loop.

So, are you seeing a situation where mutex_spin_on_owner() really is
spinning for multiple jiffies?

							Thanx, Paul

