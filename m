Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab2CHVyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:54:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57249 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758244Ab2CHVyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:54:12 -0500
Message-ID: <1331243642.11248.441.camel@twins>
Subject: Re: [ANNOUNCE] 3.2.9-rt17
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 08 Mar 2012 22:54:02 +0100
In-Reply-To: <1331243078.25686.510.camel@gandalf.stny.rr.com>
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 16:44 -0500, Steven Rostedt wrote:
> On Thu, 2012-03-08 at 22:37 +0100, Peter Zijlstra wrote:
> 
> > > Now when the original task releases the lock again, the other task can
> > > take it just like it does on mainline.
> > 
> > Now interleave it with a third task of even higher priority that puts
> > the spinner to sleep.
> 
> So? It will eventually have to allow the task to run. Adding a "third
> higher priority" task can cause problems in any other part of the -rt
> kernel.
> 
> We don't need to worry about priority inversion. If the higher task
> blocks on the original task, it will boost its priority (even if it does
> the adaptive spin) which will again boost the task that it preempted.
> 
> Now we may need to add a sched_yield() in the adaptive spin to let the
> other task run.

That's not what I mean,..

task-A (cpu0)	task-B (cpu1)		task-C (cpu1)

		lock ->d_lock
lock ->i_lock
lock ->d_lock
			<-------------- preempts B
		trylock ->i_lock


While is is perfectly normal, the result is that A stops spinning and
goes to sleep. Now B continues and loops ad infinitum because it keeps
getting ->d_lock before A because its cache hot on cpu1 and waking A
takes a while etc..

No progress guarantee -> fail.

Test-and-set spinlocks have unbounded latency and we've hit pure
starvation cases in mainline. In fact it was so bad mainline had to grow
ticket locks to cope -- we don't want to rely on anything like this in
RT.
