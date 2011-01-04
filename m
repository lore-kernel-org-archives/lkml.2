Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab1ADUtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:49:06 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:44810 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751100Ab1ADUtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:49:05 -0500
Subject: Re: [RFC][RT][PATCH 3/4] rtmutex: Revert Optimize rt lock wakeup
From: "Peter W. Morreale" <pmorreale@novell.com>
Reply-To: pmorreale@novell.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Haskins <ghaskins@novell.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        ThomasGleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1294164362.3948.220.camel@gandalf.stny.rr.com>
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
	 <1294163123.3371.89.camel@hermosa.morreale.net>
	 <1294164362.3948.220.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Organization: LSG - Novell Inc.
Date: Tue, 04 Jan 2011 13:48:55 -0700
Message-ID: <1294174135.3371.105.camel@hermosa.morreale.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 13:06 -0500, Steven Rostedt wrote:
> On Tue, 2011-01-04 at 10:45 -0700, Peter W. Morreale wrote:
> > On Tue, 2011-01-04 at 12:27 -0500, Steven Rostedt wrote:
> 
> > > That said, I think your wakeup patch may be worth while with Lai's new
> > > code. His changes causes the owner to wake up the pending owner several
> > > times, because the pending owner is never removed from the lock
> > > wait_list. If a high prio task grabs and releases the same lock over and
> > > over, if there is a waiter it will try to wake up that waiter each time.
> > > 
> > 
> > 
> > Oooohhhh  I wonder if that would enable 'lock-stealing' for FIFO?
> 
> I guess you mean literal FIFO order and not SCHED_FIFO.
> 
> But, if I understand you, it would allow for this. If a process has a
> lock and two processes are blocked on it. When the first releases the
> lock it gives it to the higher of the waiters. But if a high prio task
> comes a long, it will steal that lock away, and this woken task will
> need to race to get it from the other lower prio task that comes along.
> And yes, if that other task is the same prio, we reverse the FIFO order
> here.
> 
> Lai's patch prevents this. Either the woken task gets the lock or a
> higher prio task does. No mixing around the order of taking the lock
> here. The better side effect of Lai's patch is that it cleans up the
> code quite a bit, which is what I really want, as we start to introduce
> SCHED_DEADLINE.
> 

I was referring to one of the original patches that allowing an incoming
task of similar priority to 'steal' the lock over a pending waiter.  If
the owner had been cleared and the pending waiter not yet given
ownership, the incoming task could steal the lock.  

IIRC, you had found a case wrt SCHED_FIFO tasks that could negatively
impact performance/throughput in some way and it was restricted to
non-SCHED_FIFO tasks. 

This was just an idle question, it sounds like RT is moving towards (and
perhaps already there) synchronized lock access.  

-PWM


> > 
> > IIRC, you came up with a ping-pong scenario that prevented its use
> > there.
> 
> Probably.
> 
> -- Steve
> 
> 


