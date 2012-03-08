Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab2CHWNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:13:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6009 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab2CHWNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:13:34 -0500
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=R4lwWBn_HCerRBrefF4A:9 a=iZkNw9MCZPARSkZzK_MA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331244812.25686.518.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 17:13:32 -0500
In-Reply-To: <1331243642.11248.441.camel@twins>
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
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 22:54 +0100, Peter Zijlstra wrote:
> On Thu, 2012-03-08 at 16:44 -0500, Steven Rostedt wrote:
> > On Thu, 2012-03-08 at 22:37 +0100, Peter Zijlstra wrote:
> > 
> > > > Now when the original task releases the lock again, the other task can
> > > > take it just like it does on mainline.
> > > 
> > > Now interleave it with a third task of even higher priority that puts
> > > the spinner to sleep.
> > 
> > So? It will eventually have to allow the task to run. Adding a "third
> > higher priority" task can cause problems in any other part of the -rt
> > kernel.
> > 
> > We don't need to worry about priority inversion. If the higher task
> > blocks on the original task, it will boost its priority (even if it does
> > the adaptive spin) which will again boost the task that it preempted.
> > 
> > Now we may need to add a sched_yield() in the adaptive spin to let the
> > other task run.
> 
> That's not what I mean,..

Actually this is what I thought you meant :-)

> 
> task-A (cpu0)	task-B (cpu1)		task-C (cpu1)
> 
> 		lock ->d_lock
> lock ->i_lock
> lock ->d_lock
> 			<-------------- preempts B
> 		trylock ->i_lock
> 
> 
> While is is perfectly normal, the result is that A stops spinning and
> goes to sleep. Now B continues and loops ad infinitum because it keeps
> getting ->d_lock before A because its cache hot on cpu1 and waking A
> takes a while etc..

I'm confused? As A isn't doing a loop. B is doing the loop because it's
trying to grab the locks in reverse order and can't take the i_lock.
Your example above would have A go to sleep when it tries to take
d_lock.


> 
> No progress guarantee -> fail.

I still don't see the permanent blocking?  Task-A is blocked on d_lock,
which is own by task-B but is preempted by task-C. This happens all the
time, in -rt. What is the issue?

C will eventually go away and the other two will run again, if C doesn't
go away, that's the general problem with migrate_disable() but is out of
scope for the issue we are dealing with here.


> 
> Test-and-set spinlocks have unbounded latency and we've hit pure
> starvation cases in mainline. In fact it was so bad mainline had to grow
> ticket locks to cope -- we don't want to rely on anything like this in
> RT.


It was an issue on all spinlocks. This solution I'm giving is to fix the
trylock() when taking locks in a reverse order. Most of these locations
isn't even in critical paths (hopefully all of them are not).

I'm not changing normal spin locks or the way rt turns the to mutexes,
I'm changing the spin_trylock() that today can become a live lock when a
high priority task preempts a task on the same CPU that holds the lock
it needs.

I still don't see an issue with my proposed solution.

-- Steve


