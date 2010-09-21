Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab0IUODt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:03:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36181 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754951Ab0IUODq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:03:46 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/DllYZH4zDZvdFadjb87s3p7uXSTkFsN8BwUInlh
	PAvZTdIdZ799Zo
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced
 forks) (v4)
From: Mike Galbraith <efault@gmx.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1285070478.24680.76.camel@marge.simson.net>
References: <20100920191929.GA29026@Krystal>
	 <1285070478.24680.76.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 21 Sep 2010 16:04:04 +0200
Message-Id: <1285077844.24680.176.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 14:01 +0200, Mike Galbraith wrote:

> Since this is mostly about reducing latencies for the non-fork
> competition, maybe a kinder gentler START_DEBIT would work.  Let the
> child inherit parent's vruntime, charge a fraction of the vruntime
> equalizer bill _after_ it execs, until the bill has been paid, or
> whatnot.

One thing that comes to mind is that a lot of this problem is generated,
or rather exacerbated by, sleeper fairness.  For example, take vfork:
parent goes to sleep after passing the baton to the child.  When the
child exits, the parent wakes, gets credit for sleeping while it was
really running in drag, may preempt as a result, and is free to repeat
the procedure, gaining an edge.  START_DEBIT prevents that.

In the naked vfork/exec case, the parent _should_ resume at the relative
vruntime of the child, without further sleeper vruntime adjustment, but
that wouldn't help fix plain fork/clone which can do the same, nor would
it help kbuild's vfork->exec->clone[s]->parallel_stuff->exit unless you
add a lot of complexity... 

(...heh, to end up with something remarkably similar to cgroup container
per process.  Nope, don't want to re-invent the process scheduler to fix
a task scheduler corner case.  That's the core though, same old divide
and conquer problem we've always had.  We have a process scheduler
available these days though.  Back to our task scheduler problem...)

Perhaps take that vslice penalty, apply it to parent and child, and if
present, deduct sleep time from their debt, and only credit sleep time
if there's anything left over?  In any case, seems to me that sleep time
has to be included in the equation while the penalty is in effect.

Guess I'll try that, see what happens.

(but that will likely negate much of the benefit for your testcase,
where parent and child sleep)

	-Mike

