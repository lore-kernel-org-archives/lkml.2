Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2CIDIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:08:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29878 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2CIDIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:08:04 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VE3up3jQRU4ngBri_zAA:9 a=qj_2cOJNVfiJV4_vXSIA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331262482.25686.540.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 22:08:02 -0500
In-Reply-To: <alpine.LFD.2.02.1203090124160.2742@ionos>
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
	 <alpine.LFD.2.02.1203090124160.2742@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 01:33 +0100, Thomas Gleixner wrote:
> On Thu, 8 Mar 2012, Steven Rostedt wrote:
> 
> > On Thu, 2012-03-08 at 22:20 +0100, Peter Zijlstra wrote:
> > 
> > > Now put the thing on 2 cpus and both tasks can endlessly chase each
> > > other's tail, no? 
> > 
> > How would this be different than what mainline does? When the lock is
> > released, it will wake up the other task.
> 
> Nonsense. That code is not causing any headache in mainline simply
> because the lock holder cannot be preempted. So the contention case
> runs on different cpus. On RT the failure case is when the trylocker
> preempts the lock holder, which cannot be moved to a different cpu due
> to the implicit migrate disable. Aside of that cpu_relax() and ticket
> locks are there for a reason. They allow the other cpu to make
> progress instead of allowing the trylocking cpu to monopolize the
> cache line forever.

I understand that, I was replying to the "both tasks can endlessly chase
each other's tail". And I gave responses to that. The current solution
of having the task sleep for a tick still doesn't solve the issue of a
the owner being preempted by a higher priority task.

At least the solution I proposed wouldn't cause priority inversion,
where as the current solution can.

task-a (cpu 0)                     task-b(cpu1)        task-c(cpu1)
--------------                     ------------        ------------

retry:                             lock(y);

    lock(x);
                                        <<-------------  preempt task-b
    if (!try_lock(y)) {
	unlock(x);
	sleep(1);
	goto retry;
    }


Now task-a can be of the highest priority task in the system, and task-b
the lowest, but task-c is higher than task-b and lower than task-a. If c
is a CPU hog, then task-a will never get out of this loop.

With the lock inheritance, b will get to run over c.


> 
> The only case where mainline can fail is when a high prio task does a
> mutex_trylock() loop and the mutex owner and the trylocker are pinned
> on the same core. Though I have not yet found code like that, but I
> have not looked too hard either :)
> 
> It's a simple RT problem, which has been there forever, but obviously
> nobody did stress tests such code pathes on UP systems or if someone
> did he was not able to trigger it. On SMP this was not a big issue
> when task migration was almost always enabled. Due to the implicit
> migrate disable withing spinlocked regions we just made it more likely
> to happen.

Right, and I mentioned that the migrate disable causes new issues.

I'm trying to come up with a solution that doesn't "wait for some magic
event which is associated to the unlock of i_lock". Because that's what
we are doing right now. The magic event is the sleep hoping that it will
unlock the lock. And a solution that isn't as nasty as the multiple
readers lock.

Maybe the lock inheritance isn't the best solution, but I believe it's
better than the sleep and hope solution that's there now. And I don't
think it would be that complex to implement.

-- Steve


