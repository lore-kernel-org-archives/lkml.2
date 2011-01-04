Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab1ADRYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:24:23 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:55817 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170Ab1ADRYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:24:22 -0500
Subject: Re: [RFC][RT][PATCH 3/4] rtmutex: Revert Optimize rt lock wakeup
From: "Peter W. Morreale" <pmorreale@novell.com>
Reply-To: pmorreale@novell.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Haskins <ghaskins@novell.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        ThomasGleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1294156079.3948.209.camel@gandalf.stny.rr.com>
References: <20101223224755.078983538@goodmis.org>
	 <20101223225116.729981172@goodmis.org>
	 <4D13DF250200005A000793E1@novprvoes0310.provo.novell.com>
	 <1293166464.22802.415.camel@gandalf.stny.rr.com>
	 <4D19A8B20200005A00079658@novprvoes0310.provo.novell.com>
	 <1294081596.3948.192.camel@gandalf.stny.rr.com>
	 <1294086147.3948.194.camel@gandalf.stny.rr.com>
	 <1294154349.3371.24.camel@hermosa.morreale.net>
	 <1294156079.3948.209.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Organization: LSG - Novell Inc.
Date: Tue, 04 Jan 2011 10:24:15 -0700
Message-ID: <1294161855.3371.82.camel@hermosa.morreale.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 10:47 -0500, Steven Rostedt wrote: 
> On Tue, 2011-01-04 at 08:19 -0700, Peter W. Morreale wrote:
> > On Mon, 2011-01-03 at 15:22 -0500, Steven Rostedt wrote:
> > > On Mon, 2011-01-03 at 14:06 -0500, Steven Rostedt wrote:
> > > 
> > > > 
> > > > 	if (adaptive_wait(&waiter, orig_owner))
> > > > 		sleep = 1;
> > > > 	else
> > > > 		sleep = 0;
> > > > 
> > > > 	if (sleep)
> > > 
> > > 
> > > > 		raw_spin_lock(&lock->wait_lock);
> > > > 		saved_state = rt_set_current_block_state(saved_state);
> > > > 		if (!lock->owner && &waiter == rt_mutex_top_waiter(lock))
> > > > 			sleep = 0;
> > > > 		raw_spin_unlock(&lock->wait_lock);
> > > 
> > > I may be able to remove the above locks and replace it with:
> > > 
> > > 	saved_state = rt_set_current_blocked_state(saved_state);
> > > 	if (orig_owner == rt_mutex_owner(lock))
> > > 		schedule_rt_mutex(lock);
> > > 
> > > -- Steve
> > 
> > Isn't it possible to miss a wakeup here if the waiter becomes preempted?
> 
> Why? Preemption doesn't change the task state.
> > 
> > Recall that adaptive wait is a preemptive wait.  Hence the (I believe)
> > original reason we did the adaptive spin in a (transitioning)  sleep
> > state.
> 
> Yes it is a preemptive wait, I would not have accepted the patches if it
> was anything else. But preemption is not affected by the state of the
> task. A task could be TASK_RUNNING or TASK_INTERRUPTIBLE or
> TASK_UNINTERRUPTIBLE, and that would not affect how it acts when it is
> preempted.
> 
> -- Steve
> 
> 

My bad.  I thought preemption did change task state.

This still requires the owner to run through try_to_wake_up() and all
its associated overhead only to find out that the waiter is running.  

The assumption I made when I suggested the original concept to Greg was
that if the new owner is running, there is *nothing* to do wrt
scheduling.  If that was a wrong assumption, then, yes, drop the patch
and clean things up.  

If that was a good assumption, then we are leaving 'cycles on the table'
as waking up a running process is a non-zero-overhead path and that is a
bad thing considering how many times spin_unlock() is called on an rt
system.

Bear in mind that this savings scales directly as the number of CPUs
(assuming all are vectored on the lock).  We can only have nr_cpus-1
spinning waiters at any given time, regardless of the number of tasks in
contention.  Perhaps this is too little to worry about on a 4way system,
but I suspect that it could be substantial on larger systems.  

I'll be quiet now as I know little about the intricacies of
preemption/scheduling (obviously) and like Greg, have been removed from
RT kernel work for several years. <sigh>

-PWM





