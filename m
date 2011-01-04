Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab1ADPTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:19:20 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:59163 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752130Ab1ADPTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:19:19 -0500
Subject: Re: [RFC][RT][PATCH 3/4] rtmutex: Revert Optimize rt lock wakeup
From: "Peter W. Morreale" <pmorreale@novell.com>
Reply-To: pmorreale@novell.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Haskins <ghaskins@novell.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        ThomasGleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1294086147.3948.194.camel@gandalf.stny.rr.com>
References: <20101223224755.078983538@goodmis.org>
	 <20101223225116.729981172@goodmis.org>
	 <4D13DF250200005A000793E1@novprvoes0310.provo.novell.com>
	 <1293166464.22802.415.camel@gandalf.stny.rr.com>
	 <4D19A8B20200005A00079658@novprvoes0310.provo.novell.com>
	 <1294081596.3948.192.camel@gandalf.stny.rr.com>
	 <1294086147.3948.194.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Organization: LSG - Novell Inc.
Date: Tue, 04 Jan 2011 08:19:09 -0700
Message-ID: <1294154349.3371.24.camel@hermosa.morreale.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 15:22 -0500, Steven Rostedt wrote:
> On Mon, 2011-01-03 at 14:06 -0500, Steven Rostedt wrote:
> 
> > 
> > 	if (adaptive_wait(&waiter, orig_owner))
> > 		sleep = 1;
> > 	else
> > 		sleep = 0;
> > 
> > 	if (sleep)
> 
> 
> > 		raw_spin_lock(&lock->wait_lock);
> > 		saved_state = rt_set_current_block_state(saved_state);
> > 		if (!lock->owner && &waiter == rt_mutex_top_waiter(lock))
> > 			sleep = 0;
> > 		raw_spin_unlock(&lock->wait_lock);
> 
> I may be able to remove the above locks and replace it with:
> 
> 	saved_state = rt_set_current_blocked_state(saved_state);
> 	if (orig_owner == rt_mutex_owner(lock))
> 		schedule_rt_mutex(lock);
> 
> -- Steve

Isn't it possible to miss a wakeup here if the waiter becomes preempted?

Recall that adaptive wait is a preemptive wait.  Hence the (I believe)
original reason we did the adaptive spin in a (transitioning)  sleep
state.

-PWM

> 
> 
> > 		if (sleep)
> > 			schedule_rt_mutex(lock);
> > 		saved_state = rt_restore_current_blocked_state(saved_state);
> > 	}
> > 
> > Otherwise we can risk the wakeup_next_waiter() missing the wakeup.
> > 
> > To clarify, we want the adaptive_wait() to run as TASK_RUNNING. Then if
> > we must sleep, then we must set the state to TASK_UNINTERRUPTIBLE, test
> > again if we can still the lock, and if not then sleep. Otherwise, if a
> > wakeup happens just before we set the state to TASK_UNINTERRUPTIBLE,
> > then we miss the wake up all together.
> > 
> > I can do this change, and see what impact it makes.
> > 
> > I'm also curious if this ever worked? If it did not, then are you sure
> > your tests that show the benefit of it was true. I don't have a large
> > scale box at my disposal ATM, so I can only see what this does on 4way
> > machines.
> > 
> > -- Steve
> > 
> 
> 


