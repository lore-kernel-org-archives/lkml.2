Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1ADRpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:45:33 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:60891 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751283Ab1ADRpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:45:30 -0500
Subject: Re: [RFC][RT][PATCH 3/4] rtmutex: Revert Optimize rt lock wakeup
From: "Peter W. Morreale" <pmorreale@novell.com>
Reply-To: pmorreale@novell.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Haskins <ghaskins@novell.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        ThomasGleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1294162020.3948.215.camel@gandalf.stny.rr.com>
References: <20101223224755.078983538@goodmis.org>
	 <20101223225116.729981172@goodmis.org>
	 <4D13DF250200005A000793E1@novprvoes0310.provo.novell.com>
	 <1293166464.22802.415.camel@gandalf.stny.rr.com>
	 <4D19A8B20200005A00079658@novprvoes0310.provo.novell.com>
	 <1294081596.3948.192.camel@gandalf.stny.rr.com>
	 <1294086147.3948.194.camel@gandalf.stny.rr.com>
	 <1294154349.3371.24.camel@hermosa.morreale.net>
	 <1294156079.3948.209.camel@gandalf.stny.rr.com>
	 <1294161347.3371.80.camel@hermosa.morreale.net>
	 <1294162020.3948.215.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Organization: LSG - Novell Inc.
Date: Tue, 04 Jan 2011 10:45:23 -0700
Message-ID: <1294163123.3371.89.camel@hermosa.morreale.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 12:27 -0500, Steven Rostedt wrote:
> On Tue, 2011-01-04 at 10:15 -0700, Peter W. Morreale wrote:
> 
> > My bad.  I thought preemption did change task state.
> > 
> > This still requires the owner to run through try_to_wake_up() and all
> > its associated overhead only to find out that the waiter is running.  
> > 
> > The assumption I made when I suggested the original concept to Greg was
> > that if the new owner is running, there is *nothing* to do wrt
> > scheduling.  If that was a wrong assumption, then, yes, drop the patch
> > and clean things up.  
> > 
> > If that was a good assumption, then we are leaving 'cycles on the table'
> > as waking up a running process is a non-zero-overhead path and that is a
> > bad thing considering how many times spin_unlock() is called on an rt
> > system.
> > 
> > Bear in mind that this savings scales directly as the number of CPUs
> > (assuming all are vectored on the lock).  We can only have nr_cpus-1
> > spinning waiters at any given time, regardless of the number of tasks in
> > contention.  Perhaps this is too little to worry about on a 4way system,
> > but I suspect that it could be substantial on larger systems.  
> > 
> > I'll be quiet now as I know little about the intricacies of
> > preemption/scheduling (obviously) and like Greg, have been removed from
> > RT kernel work for several years. <sigh>
> 
> No need to be quiet ;-)
> 
> I'm working on making it spin in TASK_RUNNING state if possible, but it
> is making the code a bit more complex, as it seems that there is an
> assumption with the wakeup and the changing of the current->state in the
> rt_spin_lock_slowlock code all being under the lock->wait_lock. I think
> I'll scrap this idea.
> 
> That said, I think your wakeup patch may be worth while with Lai's new
> code. His changes causes the owner to wake up the pending owner several
> times, because the pending owner is never removed from the lock
> wait_list. If a high prio task grabs and releases the same lock over and
> over, if there is a waiter it will try to wake up that waiter each time.
> 


Oooohhhh  I wonder if that would enable 'lock-stealing' for FIFO?

IIRC, you came up with a ping-pong scenario that prevented its use
there.

-PWM



> Thus, having your patch may prevent that unnecessary wakeup.
> 
> I'll look more into it. Thanks!
> 
> -- Steve
> 
> 
> 


